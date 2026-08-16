-- Suivi parental « jour par jour » — lot 1 : le SOCLE de télémétrie du temps.
--
-- POURQUOI CETTE TABLE EXISTE
-- ---------------------------------------------------------------------------
-- Le bilan famille actuel ne sait répondre qu'à « combien d'exercices, quel
-- score » : la seule durée mesurée est `attempts.duration_seconds`, c'est-à-dire
-- le temps passé DANS un exercice terminé. Tout le reste est invisible :
--   * lire un cours ne laisse aucune trace (ni durée, ni % lu, ni « ouvert vs
--     réellement étudié ») — `chapters.lesson_content` se consulte sans écrire ;
--   * un exercice abandonné en cours de route ne compte pour rien ;
--   * « heure de première connexion », « nombre de sessions », « temps total
--     dans l'application » n'ont aucune source.
-- Sans ces faits, l'indice d'engagement et l'indice d'efficacité demandés par le
-- tableau de bord parent seraient des chiffres inventés. Cette table les fonde.
--
-- FORME : un POULS, pas un évènement
-- ---------------------------------------------------------------------------
-- Le client n'envoie pas « j'ai ouvert le cours X » / « je l'ai fermé » (une
-- fermeture d'onglet ne prévient personne, et la moitié des sessions finiraient
-- ouvertes à l'infini). Il envoie périodiquement « voici N secondes d'activité
-- RÉELLE sur telle surface » — onglet visible et interaction récente, cf.
-- `src/hooks/use-learning-pulse.ts`. Un pouls perdu coûte une minute, jamais une
-- session entière.
--
-- LE TEMPS DÉCLARÉ NE PEUT PAS DÉPASSER LE TEMPS RÉEL (invariant anti-triche)
-- ---------------------------------------------------------------------------
-- `record_learning_pulse` ne crédite jamais plus de secondes qu'il ne s'en est
-- écoulé depuis le pouls précédent du même élève. Un client modifié qui poste
-- « 3 600 secondes » toutes les secondes n'obtient qu'une seconde. C'est aussi ce
-- qui rend le total honnête quand deux onglets sont ouverts en parallèle : le
-- temps d'application reste borné par l'horloge murale.
--
-- CONFIDENTIALITÉ (l'application sert des mineurs)
-- ---------------------------------------------------------------------------
-- Aucune URL, aucun contenu, aucun texte libre : uniquement des identifiants de
-- catalogue déjà publics et une durée. Rétention 12 mois, alignée sur
-- `question_attempts` (20260706130000). Les données ne quittent pas Postgres —
-- PostHog reste sans PII et n'a rien à voir avec ceci.
--
-- CLAUDE.md : une table neuve embarque ses propres GRANT explicites.

-- ---------------------------------------------------------------------------
-- 1. La table.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.learning_pulses (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Le « type d'activité » du tableau de bord parent. Fermé, et volontairement
  -- plus grossier que les modes internes : un parent veut lire « cours /
  -- exercices / quiz / révisions », pas la taxonomie du moteur.
  surface TEXT NOT NULL CHECK (surface IN (
    'lesson',    -- lecture d'un cours (lecteur de chapitre)
    'exercise',  -- entraînement / boss
    'quiz',      -- quiz de compréhension
    'recall',    -- rappel actif (révision espacée)
    'dungeon',   -- donjon
    'duel',      -- duel
    'browse'     -- navigation pédagogique (catalogue, parcours) — hors apprentissage
  )),
  -- Contexte dénormalisé, SANS clé étrangère : même posture que
  -- `question_attempts.chapter_id`. Le catalogue est réappliqué par
  -- `sql/content/*.sql` hors migrations ; une FK ferait dépendre une table de
  -- télémétrie de lignes de contenu absentes du dépôt public (piège
  -- `db:check-chain`). Un identifiant qui ne résout plus est simplement ignoré
  -- par les jointures du rapport. Types alignés sur le catalogue :
  -- `subjects.id` est un slug TEXT, `chapters.id`/`exercises.id` des UUID.
  subject_id TEXT,
  chapter_id UUID,
  exercise_id UUID,
  -- Secondes d'activité réelle rapportées par ce pouls, après écrêtage serveur.
  active_seconds INT NOT NULL CHECK (active_seconds > 0 AND active_seconds <= 300),
  -- Avancée dans le contenu au moment du pouls — pour un cours, le pourcentage
  -- de la page atteint (le « % du cours consulté » du tableau de bord). NULL
  -- quand la notion n'a pas de sens (donjon, duel, navigation).
  progress_pct SMALLINT CHECK (progress_pct BETWEEN 0 AND 100),
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.learning_pulses IS
  'Pouls d''activité append-only : N secondes d''activité réelle sur une surface. Source du temps du tableau de bord parental. Écriture exclusivement via record_learning_pulse(). Rétention 12 mois.';

-- Agrégation par jour / par surface sur une fenêtre glissante : c'est LA requête
-- du rapport quotidien, toujours bornée à un élève et à une période.
CREATE INDEX IF NOT EXISTS idx_learning_pulses_user_recent
  ON public.learning_pulses (user_id, occurred_at DESC);

-- Détail « cours consultés » : temps et % par chapitre sur la période.
CREATE INDEX IF NOT EXISTS idx_learning_pulses_user_chapter
  ON public.learning_pulses (user_id, chapter_id, occurred_at DESC)
  WHERE chapter_id IS NOT NULL;

ALTER TABLE public.learning_pulses ENABLE ROW LEVEL SECURITY;

-- Lecture : l'élève sur ses propres lignes, l'admin pour le triage. Le PARENT ne
-- lit jamais cette table directement — il passe par les RPC SECURITY DEFINER du
-- rapport, qui vérifient le lien famille. Aucune policy d'écriture : le seul
-- écrivain est la RPC ci-dessous (son propriétaire contourne la RLS).
DROP POLICY IF EXISTS "Users read own learning pulses" ON public.learning_pulses;
CREATE POLICY "Users read own learning pulses" ON public.learning_pulses
  FOR SELECT USING (user_id = (SELECT auth.uid()) OR public.is_admin());

REVOKE ALL ON public.learning_pulses FROM anon, authenticated;
GRANT SELECT ON public.learning_pulses TO authenticated;
GRANT ALL ON public.learning_pulses TO service_role;

-- ---------------------------------------------------------------------------
-- 2. L'écriture — la seule porte, et elle est écrêtée.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_learning_pulse(
  p_surface TEXT,
  p_active_seconds INT,
  p_subject TEXT DEFAULT NULL,
  p_chapter UUID DEFAULT NULL,
  p_exercise UUID DEFAULT NULL,
  p_progress_pct INT DEFAULT NULL
)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  -- Plafond par pouls. Le client émet toutes les 60 s ; 300 s laisse de la marge
  -- à un envoi retardé (onglet en arrière-plan qui vide sa file au retour) sans
  -- jamais permettre de créditer une demi-heure d'un coup.
  c_max_seconds CONSTANT INT := 300;
  -- Sous ce seuil on n'écrit rien : évite d'inonder la table de lignes d'une
  -- seconde, et borne mécaniquement le débit à 12 lignes/minute/élève.
  c_min_seconds CONSTANT INT := 5;
  v_user UUID := auth.uid();
  v_last TIMESTAMPTZ;
  v_elapsed NUMERIC;
  v_credit INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_active_seconds IS NULL OR p_active_seconds <= 0 THEN
    RETURN 0;
  END IF;

  IF p_surface IS NULL OR p_surface NOT IN
     ('lesson', 'exercise', 'quiz', 'recall', 'dungeon', 'duel', 'browse') THEN
    RAISE EXCEPTION 'Invalid surface';
  END IF;

  -- Horloge murale : on ne crédite jamais plus que le temps écoulé depuis le
  -- dernier pouls, toutes surfaces confondues.
  SELECT MAX(occurred_at) INTO v_last
  FROM public.learning_pulses
  WHERE user_id = v_user;

  IF v_last IS NULL THEN
    v_credit := LEAST(p_active_seconds, c_max_seconds);
  ELSE
    v_elapsed := EXTRACT(EPOCH FROM (now() - v_last));
    v_credit := LEAST(p_active_seconds, c_max_seconds, GREATEST(FLOOR(v_elapsed)::INT, 0));
  END IF;

  IF v_credit < c_min_seconds THEN
    RETURN 0;
  END IF;

  INSERT INTO public.learning_pulses
    (user_id, surface, subject_id, chapter_id, exercise_id, active_seconds, progress_pct)
  VALUES (
    v_user,
    p_surface,
    p_subject,
    p_chapter,
    p_exercise,
    v_credit,
    CASE
      WHEN p_progress_pct IS NULL THEN NULL
      ELSE LEAST(GREATEST(p_progress_pct, 0), 100)::SMALLINT
    END
  );

  RETURN v_credit;
END;
$$;

COMMENT ON FUNCTION public.record_learning_pulse(TEXT, INT, TEXT, UUID, UUID, INT) IS
  'Enregistre un pouls d''activité pour auth.uid(). Retourne les secondes réellement créditées (0 = trop tôt / rien à créditer). Le crédit ne dépasse jamais le temps réel écoulé depuis le pouls précédent.';

REVOKE EXECUTE ON FUNCTION public.record_learning_pulse(TEXT, INT, TEXT, UUID, UUID, INT)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.record_learning_pulse(TEXT, INT, TEXT, UUID, UUID, INT)
  TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. Rétention — 12 mois, comme la télémétrie par question.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.purge_learning_pulses()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.learning_pulses
  WHERE occurred_at < now() - INTERVAL '12 months';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_learning_pulses() FROM PUBLIC, anon, authenticated;

-- Purge quotidienne via pg_cron. Enveloppée comme les autres : si l'extension
-- n'est pas disponible (stack locale nue), la migration réussit quand même — la
-- table et les RPC sont en place, seule la planification est différée.
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid)
  FROM cron.job
  WHERE jobname = 'purge-learning-pulses';

  PERFORM cron.schedule(
    'purge-learning-pulses',
    '25 3 * * *',
    $cron$SELECT public.purge_learning_pulses();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron indisponible (%). Les pouls fonctionnent mais ne seront PAS purgés automatiquement. Activer pg_cron (Supabase -> Database -> Extensions) puis rejouer le bloc cron.schedule(...).',
    SQLERRM;
END;
$$;
