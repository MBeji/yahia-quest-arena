-- Étude 11 — lot 6 : LE BILAN HEBDOMADAIRE, côté base.
--
-- CE QUE CE LOT EST, ET CE QU'IL N'EST PAS
-- ---------------------------------------------------------------------------
-- Le lot 6 est le SEUL endroit de toute l'étude 11 où le modèle RÉDIGE. Il ne
-- calcule rien : R-10 dit « le déterministe décide, le LLM rédige », et ce
-- fichier est la moitié « déterministe » de la phrase. Les chiffres du bilan
-- sortent d'ici, en SQL, agrégés et arrêtés ; le modèle les met en phrases.
--
-- Conséquence directe sur ce qui suit : `get_tutor_digest_inputs` ne rend PAS
-- des lignes brutes à faire compter par un modèle. Elle rend le bilan DÉJÀ
-- fait — totaux, moyennes, écarts avec la semaine précédente, trois erreurs
-- nommées. Un modèle à qui l'on demande d'additionner se trompe un jour sur
-- vingt, et ce jour-là il annonce à un parent des progrès qui n'existent pas.
--
-- LA RÈGLE QUI COMMANDE TOUT LE FICHIER — R-14, VIE PRIVÉE DES MINEURS
-- ---------------------------------------------------------------------------
-- Le JSON de `get_tutor_digest_inputs` PART CHEZ UN FOURNISSEUR DE MODÈLE.
-- C'est la seule fonction du dépôt dont la sortie quitte l'infrastructure.
-- Elle ne contient donc AUCUN identifiant : ni nom d'affichage, ni e-mail, ni
-- UUID d'élève, de chapitre, de matière ou de tag technique. Rien que des
-- nombres, des libellés de contenu et une bande d'âge dérivée de la classe.
--
-- C'est aussi pourquoi elle ne réutilise PAS `_student_report_json` telle
-- quelle, alors qu'elle en recalcule des voisins : ce payload-là porte
-- `student.displayName`, et il sert aussi `get_student_report_by_code`, qui est
-- GRANT à **anon**. Le transmettre serait la fuite exacte que R-14 interdit.
-- Les deux fonctions ne répondent d'ailleurs pas à la même question :
-- `_student_report_json` décrit une fenêtre GLISSANTE (7 j / 30 j) pour un
-- écran consulté n'importe quand ; le bilan décrit une SEMAINE CIVILE close,
-- la même pour tout le monde, réexécutable à l'identique. Une moyenne « des 7
-- derniers jours » recalculée le lundi ne dit plus ce que disait le bilan du
-- dimanche — un bilan doit être stable pour être citable.
--
-- CE QUE CE FICHIER NE CONTIENT PAS, DÉLIBÉRÉMENT
-- ---------------------------------------------------------------------------
--   * Aucune récompense (R-11). Rien n'écrit dans `attempts`, `profiles`,
--     `student_badges` ni `spaced_repetition_schedule` — un bilan n'est pas un
--     geste de jeu, et le récompenser en ferait un.
--   * Aucun compteur d'usage du tuteur. Q-5 les a déjà (`get_tutor_parent_
--     counters`, lot 4) ; les recalculer ici ferait deux juges du même nombre.
--   * Aucun verbatim de conversation, nulle part — voir le contrôle négatif
--     de la suite pgTAP S73, qui vérifie qu'aucune colonne ne pourrait en
--     porter un.

-- ---------------------------------------------------------------------------
-- 1. La semaine — une seule définition, pour que deux bilans ne se recouvrent
--    jamais.
-- ---------------------------------------------------------------------------
-- Semaine ISO : elle commence le LUNDI. Le rendez-vous produit du bilan est le
-- dimanche (`PARENT_DIGEST_WEEKDAY`), donc le jour où le batch s'exécute est le
-- DERNIER de la semaine qu'il résume — `date_trunc('week', dimanche)` rend bien
-- le lundi six jours plus tôt, et non le lendemain.
--
-- Cette fonction existe pour que le batch n'ait pas à savoir tout ça : il passe
-- n'importe quel jour de la semaine, la clé retenue est toujours la même. Sans
-- elle, un batch relancé le lundi matin après un échec du dimanche soir créerait
-- un SECOND bilan pour la même semaine, et l'unicité (élève, semaine, audience)
-- ne l'empêcherait pas — les deux clés seraient différentes.
CREATE OR REPLACE FUNCTION public.tutor_week_start(p_day DATE)
RETURNS DATE
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT date_trunc('week', p_day::timestamp)::DATE;
$$;

COMMENT ON FUNCTION public.tutor_week_start(DATE) IS
  'Étude 11 lot 6 : le lundi de la semaine ISO contenant p_day. Source unique de la clé de semaine des bilans — un batch rejoué un autre jour retombe sur la même.';

REVOKE EXECUTE ON FUNCTION public.tutor_week_start(DATE) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_week_start(DATE) TO authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 2. La table des bilans.
-- ---------------------------------------------------------------------------
-- Une ligne = un texte rédigé, pour UNE audience, sur UNE semaine. Le texte est
-- stocké et non recalculé à l'affichage : un bilan qui changerait de phrases à
-- chaque ouverture ne serait pas un bilan, et chaque ouverture coûterait un
-- appel de modèle.
CREATE TABLE IF NOT EXISTS public.tutor_digests (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Toujours un LUNDI. La règle est recopiée ici plutôt qu'appelée via
  -- `tutor_week_start()` : une CHECK qui appelle une fonction utilisateur
  -- impose un ordre de restauration à `pg_dump`, et un bilan hebdomadaire ne
  -- vaut pas ce risque sur une restauration de sauvegarde. La normalisation,
  -- elle, reste dans la RPC — la CHECK n'est là que pour attraper une écriture
  -- directe en service_role qui aurait contourné la fonction.
  week_start DATE NOT NULL CHECK (week_start = date_trunc('week', week_start::timestamp)::DATE),
  -- Deux audiences, deux registres : l'élève est TUTOYÉ, le parent VOUVOYÉ, et
  -- le second ne parle jamais le langage du jeu. C'est la colonne qui décide
  -- lequel des deux prompts a produit le texte — et surtout QUI a le droit de
  -- le lire (voir les policies).
  audience   TEXT NOT NULL CHECK (audience IN ('student', 'parent')),
  -- R-18 : la langue du texte, pas celle de l'interface. Un bilan rédigé en
  -- arabe doit s'afficher en RTL même si le parent lit l'application en
  -- français ; sans cette colonne l'écran devrait le deviner au script.
  lang       TEXT NOT NULL DEFAULT 'fr' CHECK (lang IN ('fr', 'en', 'ar')),
  body       TEXT NOT NULL,
  -- Traçabilité qualité : quel modèle a écrit ce texte. NULL = repli
  -- déterministe (R-15), et c'est une information utile, pas un trou.
  model      TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- La garantie de ré-exécution du batch : relancer un dimanche deux fois
  -- REMPLACE le bilan, il ne l'empile pas. Sans cette contrainte, un incident
  -- de réseau au milieu du lot produirait deux bilans contradictoires pour la
  -- même semaine et l'écran en montrerait un au hasard.
  UNIQUE (user_id, week_start, audience)
);

COMMENT ON TABLE public.tutor_digests IS
  'Bilans hebdomadaires rédigés (étude 11 lot 6). Un texte par (élève, semaine ISO, audience). Q-5 : aucune colonne ne porte de verbatim de conversation — ni ici, ni ailleurs à destination d''un parent. Purge à 12 mois (R-14).';
COMMENT ON COLUMN public.tutor_digests.audience IS
  'Qui lit ce texte. Commande le registre à la rédaction ET le droit de lecture : chaque audience ne lit que ce qui a été écrit pour elle.';
COMMENT ON COLUMN public.tutor_digests.model IS
  'Modèle ayant rédigé, NULL quand le repli déterministe a servi (R-15). Sert à mesurer la part réellement rédigée.';

-- L'unique index (user_id, week_start, audience) sert déjà les deux seules
-- lectures du produit — « le bilan de CETTE semaine » et « le plus récent »,
-- qui parcourt le préfixe user_id trié par week_start. Pas d'index de plus :
-- une table qui grossit d'une ligne par élève et par semaine n'en a pas besoin,
-- et chaque index de trop est une écriture de plus dans le batch dominical.

ALTER TABLE public.tutor_digests ENABLE ROW LEVEL SECURITY;

-- L'élève lit ce qui lui est ADRESSÉ, et rien d'autre.
--
-- ⚠️ `AND audience = 'student'` n'est pas une précaution superflue : le bilan
-- parent parle de l'enfant à la troisième personne, en vouvoyant quelqu'un
-- d'autre. Le laisser lisible par l'enfant, ce n'est pas protéger un secret —
-- c'est mettre sous ses yeux un texte qui n'est pas écrit pour lui, et lui
-- faire découvrir le tuteur comme un rapporteur. Le défaut prudent est le
-- plus étroit ; l'ouvrir un jour se fera en connaissance de cause.
CREATE POLICY tutor_digests_select_own ON public.tutor_digests
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()) AND audience = 'student');

-- Le parent lit le bilan PARENT d'un enfant auquel il est ACTIVEMENT lié.
--
-- Le lien est jugé par `is_parent_of_student`, qui teste déjà `is_active` — et
-- c'est la seule bonne façon de le tester. Un EXISTS réécrit ici ferait un
-- second juge du lien, celui qui oublierait `is_active` le jour où quelqu'un
-- le retouchera ; un parent séparé, un tuteur révoqué ou un compte repris
-- continueraient d'observer un mineur sans que rien ne rougisse.
--
-- `(SELECT auth.uid())` et non `auth.uid()` nu : motif
-- `20260810120000_rls_initplan_wrap_auth_uid` — l'appel est alors évalué une
-- fois pour la requête au lieu d'une fois par ligne.
CREATE POLICY tutor_digests_select_linked_parent ON public.tutor_digests
  FOR SELECT TO authenticated
  USING (
    audience = 'parent'
    AND public.is_parent_of_student((SELECT auth.uid()), user_id)
  );

-- AUCUNE policy d'écriture, volontairement : tout passe par
-- `store_tutor_digest()`. Un INSERT direct laisserait un élève s'écrire un
-- bilan flatteur, et un parent en écrire un à son enfant.
REVOKE ALL ON public.tutor_digests FROM anon, authenticated;
GRANT SELECT ON public.tutor_digests TO authenticated;
GRANT ALL ON public.tutor_digests TO service_role;

-- ---------------------------------------------------------------------------
-- 3. L'écriture — le batch, et lui seul.
-- ---------------------------------------------------------------------------
-- SECURITY DEFINER + REVOKE de `authenticated` : la fonction n'est appelable
-- que par `service_role`, c'est-à-dire par le batch dominical qui parle à la
-- base avec `supabaseAdmin`. Aucune session d'élève ne peut l'atteindre.
CREATE OR REPLACE FUNCTION public.store_tutor_digest(
  p_user       UUID,
  p_week_start DATE,
  p_audience   TEXT,
  p_body       TEXT,
  p_model      TEXT DEFAULT NULL,
  p_lang       TEXT DEFAULT 'fr'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  -- Le batch peut passer le dimanche où il tourne, le lundi d'une reprise ou
  -- la date exacte du lundi : les trois désignent la même semaine, et doivent
  -- donc écraser la même ligne.
  v_week DATE := public.tutor_week_start(p_week_start);
  v_id   UUID;
BEGIN
  -- Un corps vide n'est pas un bilan « minimal », c'est un écran blanc servi
  -- toute la semaine. Mieux vaut échouer bruyamment dans un batch — que
  -- personne ne regarde en direct mais dont les erreurs se journalisent — que
  -- de figer un vide qu'aucune ré-exécution ne distinguerait d'un vrai texte.
  IF p_user IS NULL OR p_body IS NULL OR btrim(p_body) = '' THEN
    RAISE EXCEPTION 'EMPTY_DIGEST';
  END IF;

  INSERT INTO public.tutor_digests (user_id, week_start, audience, lang, body, model)
  VALUES (p_user, v_week, p_audience, p_lang, btrim(p_body), p_model)
  ON CONFLICT (user_id, week_start, audience) DO UPDATE
    SET body       = EXCLUDED.body,
        lang       = EXCLUDED.lang,
        model      = EXCLUDED.model,
        -- La date de PRODUCTION du texte affiché, pas celle de la première
        -- tentative : c'est elle que l'écran montre, et une ré-exécution après
        -- correction doit se voir.
        created_at = now()
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

COMMENT ON FUNCTION public.store_tutor_digest(UUID, DATE, TEXT, TEXT, TEXT, TEXT) IS
  'Étude 11 lot 6 : enregistre (ou REMPLACE) le bilan d''une semaine pour une audience. Normalise la semaine au lundi ISO, ce qui rend le batch dominical rejouable sans doublon. Réservée à service_role.';

REVOKE EXECUTE ON FUNCTION public.store_tutor_digest(UUID, DATE, TEXT, TEXT, TEXT, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.store_tutor_digest(UUID, DATE, TEXT, TEXT, TEXT, TEXT)
  TO service_role;

-- ---------------------------------------------------------------------------
-- 4. LES FAITS DE LA SEMAINE — le bloc DÉPERSONNALISÉ qui part chez le modèle.
-- ---------------------------------------------------------------------------
-- ⚠️ C'EST LA SEULE FONCTION DU DÉPÔT DONT LA SORTIE QUITTE L'INFRASTRUCTURE.
-- Relire la liste de ce qu'elle NE rend pas avant d'y ajouter quoi que ce soit :
--   * pas de `display_name`, pas d'e-mail, pas de `p_user` ni d'aucun UUID ;
--   * pas d'identifiant de chapitre, de matière ni de tag de misconception —
--     un tag est un identifiant technique, et il n'apprend rien à un modèle que
--     son libellé ne lui dise mieux ;
--   * pas de date de naissance ni d'âge : une BANDE, dérivée de la classe.
-- La suite pgTAP S73 le vérifie par un contrôle négatif — un nom injecté dans
-- le profil ne doit ressortir nulle part dans ce JSON.
--
-- UNE SEULE fonction pour les DEUX audiences : les faits d'une semaine sont les
-- mêmes pour l'élève et pour son parent. Ce qui diffère, c'est le registre du
-- texte — donc le prompt, côté Node. Deux fonctions de faits divergeraient au
-- premier ajustement, et un parent lirait alors d'autres chiffres que son
-- enfant sur la même semaine.
CREATE OR REPLACE FUNCTION public.get_tutor_digest_inputs(p_user UUID, p_week_start DATE)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_week      DATE := public.tutor_week_start(p_week_start);
  -- Bornes explicites en UTC plutôt qu'un `date::timestamptz`, qui dépendrait
  -- du fuseau de la SESSION : deux appels de la même semaine depuis deux
  -- connexions réglées différemment ne doivent pas compter deux totaux.
  v_from      TIMESTAMPTZ := (v_week::timestamp AT TIME ZONE 'UTC');
  v_to        TIMESTAMPTZ := ((v_week + 7)::timestamp AT TIME ZONE 'UTC');
  v_prev_from TIMESTAMPTZ := ((v_week - 7)::timestamp AT TIME ZONE 'UTC');
  v_age_band  TEXT;
  v_lang      TEXT;
  v_this      RECORD;
  v_prev      RECORD;
  v_chapters  JSONB;
  v_errors    JSONB;
BEGIN
  -- R-14 : l'âge se DÉRIVE de la classe, il ne se collecte pas. Un élève sans
  -- profil (compte en cours de création) retombe sur la bande médiane plutôt
  -- que de faire échouer le batch pour toute la promotion.
  SELECT public.tutor_age_band(p.current_grade_id)
    INTO v_age_band
    FROM public.profiles p
   WHERE p.id = p_user;
  v_age_band := COALESCE(v_age_band, '12-14');

  -- La semaine résumée. Un agrégat sans GROUP BY rend TOUJOURS une ligne :
  -- une semaine sans activité donne des zéros, jamais NULL — c'est ce qui rend
  -- `hasActivity` calculable sans cas particulier.
  SELECT count(*)::int AS missions,
         ROUND(COALESCE(SUM(a.duration_seconds), 0)::numeric / 60)::int AS minutes,
         ROUND(COALESCE(AVG(a.score_pct), 0))::int AS avg_score,
         count(DISTINCT (a.completed_at AT TIME ZONE 'UTC')::date)::int AS days_active
    INTO v_this
    FROM public.attempts a
   WHERE a.user_id = p_user
     AND a.completed_at >= v_from
     AND a.completed_at <  v_to;

  -- La semaine d'avant, mesurée EXACTEMENT pareil. C'est la comparaison qui
  -- fait un bilan : « 12 missions » ne dit rien, « 12 contre 5 » dit tout.
  SELECT count(*)::int AS missions,
         ROUND(COALESCE(SUM(a.duration_seconds), 0)::numeric / 60)::int AS minutes,
         ROUND(COALESCE(AVG(a.score_pct), 0))::int AS avg_score,
         count(DISTINCT (a.completed_at AT TIME ZONE 'UTC')::date)::int AS days_active
    INTO v_prev
    FROM public.attempts a
   WHERE a.user_id = p_user
     AND a.completed_at >= v_prev_from
     AND a.completed_at <  v_from;

  -- Où l'élève a travaillé, par LIBELLÉ. Cinq chapitres au plus : au-delà, le
  -- modèle produit une liste au lieu d'un bilan, et la semaine d'un enfant de
  -- neuf ans ne tient de toute façon pas sur plus.
  SELECT COALESCE(jsonb_agg(c.x ORDER BY c.attempts DESC, c.chapter), '[]'::jsonb)
    INTO v_chapters
    FROM (
      SELECT jsonb_build_object(
               'chapter',  ch.title,
               'subject',  sub.name_fr,
               'attempts', count(*)::int,
               'avgScore', ROUND(COALESCE(AVG(a.score_pct), 0))::int
             ) AS x,
             count(*)::int AS attempts,
             ch.title      AS chapter
        FROM public.attempts a
        JOIN public.exercises e   ON e.id   = a.exercise_id
        JOIN public.chapters  ch  ON ch.id  = e.chapter_id
        JOIN public.subjects  sub ON sub.id = ch.subject_id
       WHERE a.user_id = p_user
         AND a.completed_at >= v_from
         AND a.completed_at <  v_to
       GROUP BY ch.id, ch.title, sub.name_fr
       ORDER BY count(*) DESC, ch.title
       LIMIT 5
    ) c;

  -- Les trois erreurs ACTIVES au sens de é04 R-2 (≥ 3 occurrences, ≥ 2 séances,
  -- 30 jours). Appelées par la fonction canonique et non re-seuillées ici : une
  -- quatrième copie du triplet (3, 2, 30) rendrait le seuil inajustable.
  --
  -- La jointure sur `misconceptions` est INTERNE, comme dans
  -- `get_tutor_parent_counters` : un tag hors vocabulaire n'a pas de phrase à
  -- donner au modèle, et on préfère l'omettre qu'envoyer un identifiant
  -- technique qui finirait recopié tel quel dans un bilan de parent.
  --
  -- Les trois libellés partent ensemble : la langue du bilan se décide côté
  -- Node (matière dominante), et un aller-retour de plus vers la base pour
  -- choisir une colonne coûterait plus cher que deux chaînes de trop.
  SELECT COALESCE(jsonb_agg(t.x ORDER BY t.occurrences DESC, t.label_fr), '[]'::jsonb)
    INTO v_errors
    FROM (
      SELECT jsonb_build_object(
               'labelFr',     m.label_fr,
               'labelEn',     m.label_en,
               'labelAr',     m.label_ar,
               'occurrences', um.occurrences
             ) AS x,
             um.occurrences,
             m.label_fr
        FROM public.active_misconceptions(p_user) um
        JOIN public.misconceptions m ON m.tag = um.tag
       ORDER BY um.occurrences DESC, m.label_fr
       LIMIT 3
    ) t;

  -- R-3 : la langue de sortie est celle de la MATIÈRE travaillée, pas celle de
  -- l'interface. Un élève qui a passé sa semaine en arabe reçoit son bilan en
  -- arabe. Semaine vide ⇒ 'fr', le réglage le moins surprenant du produit.
  SELECT sub.content_language
    INTO v_lang
    FROM public.attempts a
    JOIN public.subjects sub ON sub.id = a.subject_id
   WHERE a.user_id = p_user
     AND a.completed_at >= v_from
     AND a.completed_at <  v_to
   GROUP BY sub.content_language
   ORDER BY count(*) DESC, sub.content_language
   LIMIT 1;
  v_lang := COALESCE(v_lang, 'fr');

  RETURN jsonb_build_object(
    'weekStart', to_char(v_week::timestamp, 'YYYY-MM-DD'),
    'weekEnd',   to_char((v_week + 6)::timestamp, 'YYYY-MM-DD'),
    'ageBand',   v_age_band,
    'lang',      v_lang,
    -- Le levier R-15 du batch : une semaine sans une seule mission n'a pas de
    -- bilan à faire rédiger. Appeler un modèle pour lui faire écrire « tu n'as
    -- rien fait » coûte de l'argent et sonne comme un reproche ; l'écran a un
    -- état pour ça, déterministe et traduit.
    'hasActivity', (v_this.missions > 0),
    'thisWeek', jsonb_build_object(
      'missions',   v_this.missions,
      'minutes',    v_this.minutes,
      'avgScore',   v_this.avg_score,
      'daysActive', v_this.days_active
    ),
    'lastWeek', jsonb_build_object(
      'missions',   v_prev.missions,
      'minutes',    v_prev.minutes,
      'avgScore',   v_prev.avg_score,
      'daysActive', v_prev.days_active
    ),
    -- L'écart est calculé ICI et non laissé au modèle (R-10) : c'est la phrase
    -- que retient un parent, et une soustraction ratée s'y verrait pendant une
    -- semaine entière.
    'delta', jsonb_build_object(
      'missions',   v_this.missions   - v_prev.missions,
      'minutes',    v_this.minutes    - v_prev.minutes,
      -- ⚠️ Un écart de moyenne n'a de sens que si les DEUX semaines ont eu des
      -- missions. Sans cette garde, une semaine précédente vide (moyenne 0)
      -- produirait « +67 points de progression » sur une reprise après
      -- vacances — un compliment mécanique et faux. NULL veut dire « pas
      -- comparable », et le prompt le traduit par le silence.
      'avgScore',   CASE WHEN v_this.missions > 0 AND v_prev.missions > 0
                         THEN v_this.avg_score - v_prev.avg_score END,
      'daysActive', v_this.days_active - v_prev.days_active
    ),
    'chapters',  v_chapters,
    'topErrors', v_errors
  );
END;
$fn$;

COMMENT ON FUNCTION public.get_tutor_digest_inputs(UUID, DATE) IS
  'Étude 11 lot 6 (R-10, R-14) : les faits d''une semaine ISO, agrégés et DÉPERSONNALISÉS — c''est le seul JSON du dépôt qui part chez un fournisseur de modèle. Aucun nom, aucun e-mail, aucun UUID, aucun tag technique. Réservée à service_role.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_digest_inputs(UUID, DATE)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_tutor_digest_inputs(UUID, DATE) TO service_role;

-- ---------------------------------------------------------------------------
-- 5. La lecture, côté ÉLÈVE.
-- ---------------------------------------------------------------------------
-- SECURITY INVOKER, et c'est le choix qui compte : la policy est alors le seul
-- juge du droit de lire. En DEFINER il aurait fallu réécrire le contrôle dans
-- le corps, et deux juges d'une même règle finissent toujours par diverger.
--
-- R-15 : aucune exception, jamais. Pas de bilan cette semaine, pas de session
-- du tout, semaine invalide — la fonction rend un ÉTAT (`available: false`) que
-- l'écran sait afficher. Un `RAISE` ici ferait un écran cassé là où il n'y a
-- qu'une semaine calme.
--
-- `p_week_start` à NULL rend le PLUS RÉCENT, avec sa semaine. C'est le défaut
-- utile : le bilan se produit le dimanche, donc demander « celui de la semaine
-- en cours » un mardi rendrait vide six jours sur sept. L'écran affiche la
-- semaine que la fonction lui annonce, il ne la suppose pas.
CREATE OR REPLACE FUNCTION public.get_tutor_digest(p_week_start DATE DEFAULT NULL)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT COALESCE(
    (SELECT jsonb_build_object(
              'available', true,
              'weekStart', to_char(d.week_start::timestamp, 'YYYY-MM-DD'),
              'lang',      d.lang,
              'body',      d.body,
              'model',     d.model,
              'createdAt', d.created_at
            )
       FROM public.tutor_digests d
      WHERE d.user_id  = (SELECT auth.uid())
        AND d.audience = 'student'
        AND (p_week_start IS NULL OR d.week_start = public.tutor_week_start(p_week_start))
      ORDER BY d.week_start DESC
      LIMIT 1),
    jsonb_build_object(
      'available', false,
      'weekStart', CASE WHEN p_week_start IS NULL THEN NULL
                        ELSE to_char(public.tutor_week_start(p_week_start)::timestamp, 'YYYY-MM-DD') END,
      'lang',      NULL::text,
      'body',      NULL::text,
      'model',     NULL::text,
      'createdAt', NULL::timestamptz
    )
  );
$$;

COMMENT ON FUNCTION public.get_tutor_digest(DATE) IS
  'Étude 11 lot 6 : le bilan de l''élève courant (audience student). p_week_start NULL = le plus récent. R-15 : rend { available: false } au lieu de lever quand il n''y en a pas.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_digest(DATE) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_digest(DATE) TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. La lecture, côté PARENT (Q-5).
-- ---------------------------------------------------------------------------
-- Ici on LÈVE, contrairement au chemin élève — et la différence est voulue.
-- L'écran parent appelle déjà `get_tutor_parent_counters`, qui refuse par
-- `NOT_LINKED` ; deux RPC de la même page qui traitent différemment le même lien
-- coupé donneraient deux messages contradictoires. Surtout, « lien inactif » et
-- « pas encore de bilan » demandent deux réponses opposées à un parent : la
-- première se règle en rétablissant le lien, la seconde en attendant dimanche.
-- Les confondre dans un `available: false` ferait attendre indéfiniment un
-- parent dont le lien est simplement à réactiver.
--
-- Le lien est jugé AVANT toute lecture, et par `is_parent_of_student` — le même
-- juge que la policy de la table. Pas de `OR is_admin()` : le bilan d'un mineur
-- n'a pas de destinataire légitime hors de son parent lié.
CREATE OR REPLACE FUNCTION public.get_tutor_parent_digest(
  p_student_id UUID,
  p_week_start DATE DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_parent UUID := auth.uid();
  v_row    public.tutor_digests;
BEGIN
  IF v_parent IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  IF NOT public.is_parent_of_student(v_parent, p_student_id) THEN
    RAISE EXCEPTION 'NOT_LINKED';
  END IF;

  SELECT * INTO v_row
    FROM public.tutor_digests d
   WHERE d.user_id  = p_student_id
     AND d.audience = 'parent'
     AND (p_week_start IS NULL OR d.week_start = public.tutor_week_start(p_week_start))
   ORDER BY d.week_start DESC
   LIMIT 1;

  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'available', false,
      'weekStart', CASE WHEN p_week_start IS NULL THEN NULL
                        ELSE to_char(public.tutor_week_start(p_week_start)::timestamp, 'YYYY-MM-DD') END,
      'lang',      NULL::text,
      'body',      NULL::text,
      'model',     NULL::text,
      'createdAt', NULL::timestamptz
    );
  END IF;

  RETURN jsonb_build_object(
    'available', true,
    'weekStart', to_char(v_row.week_start::timestamp, 'YYYY-MM-DD'),
    'lang',      v_row.lang,
    'body',      v_row.body,
    'model',     v_row.model,
    'createdAt', v_row.created_at
  );

  -- ⚠️ IL N'Y A RIEN D'AUTRE DANS CE RETURN, ET C'EST LA RÈGLE (Q-5).
  -- Le bilan parent est un texte AGRÉGÉ. Ni fil, ni message, ni résumé de
  -- conversation ne transite par ici — et la table elle-même n'a aucune colonne
  -- qui pourrait en porter un (contrôle négatif dans la suite pgTAP S73).
END;
$$;

COMMENT ON FUNCTION public.get_tutor_parent_digest(UUID, DATE) IS
  'Q-5 (étude 11 lot 6) : le bilan hebdomadaire d''audience parent, pour un parent LIÉ ACTIF. Jamais le verbatim des conversations. Lève NOT_LINKED sur un lien coupé — un lien à rétablir ne se confond pas avec un bilan pas encore écrit.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_parent_digest(UUID, DATE) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_parent_digest(UUID, DATE) TO authenticated;

-- ---------------------------------------------------------------------------
-- 7. LES RÉTENTIONS R-14 — et une promesse ouverte depuis le lot 1.
-- ---------------------------------------------------------------------------
-- R-14 fixe trois durées : les fils à 6 mois, la comptabilité à 12 mois, les
-- bilans à 12 mois. La comptabilité est balayée depuis é29 (`purge_ai_ledgers`,
-- planifiée à 3 h 40). Les deux autres sont ici.
--
-- ⚠️ La purge des FILS n'existait pas. `tutor_threads` porte « Purge à 6 mois
-- (R-14) » dans son COMMENT depuis le lot 1, et `tutor_feedback` déclare même
-- que son verbatim « se purge avec lui » — mais aucun job ne l'exécutait. Une
-- rétention promise dans un commentaire et absente de la base n'est pas une
-- dette de confort : c'est une affirmation fausse sur des données de mineurs.
-- Le lot 6 est celui des rétentions, elle atterrit donc ici, avec la sienne.
-- La cascade de `tutor_feedback` emporte les avis du même geste, comme prévu.
--
-- Deux fonctions et deux jobs plutôt qu'un seul balayage : les deux durées
-- répondent à deux raisonnements différents (une conversation d'enfant vs un
-- texte agrégé), et l'une doit pouvoir être ajustée sans toucher à l'autre.
CREATE OR REPLACE FUNCTION public.purge_tutor_digests()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Sur `week_start` et non `created_at` : une ré-exécution du batch rafraîchit
  -- `created_at` et maintiendrait indéfiniment en vie le bilan d'une semaine de
  -- 2024. C'est la SEMAINE qui vieillit, pas la ligne.
  DELETE FROM public.tutor_digests
   WHERE week_start < (CURRENT_DATE - INTERVAL '12 months')::DATE;
END;
$$;

COMMENT ON FUNCTION public.purge_tutor_digests() IS
  'R-14 (étude 11 lot 6) : les bilans au-delà de 12 mois sont supprimés. Mesuré sur la SEMAINE, pas sur la date d''écriture — une ré-exécution ne rajeunit pas un bilan.';

REVOKE EXECUTE ON FUNCTION public.purge_tutor_digests() FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.purge_tutor_threads()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Sur `updated_at` : un fil rouvert la semaine dernière n'a pas six mois,
  -- même s'il a été ouvert il y a un an. C'est la dernière fois qu'un enfant a
  -- parlé qui compte, pas la première.
  -- `tutor_feedback` tombe par CASCADE — son COMMENT l'annonce depuis le lot 1.
  DELETE FROM public.tutor_threads
   WHERE updated_at < now() - INTERVAL '6 months';
END;
$$;

COMMENT ON FUNCTION public.purge_tutor_threads() IS
  'R-14 (promesse du lot 1, tenue au lot 6) : les fils du tuteur inactifs depuis 6 mois sont supprimés, avec leurs avis par cascade. Mesuré sur updated_at — un fil rouvert redevient récent.';

REVOKE EXECUTE ON FUNCTION public.purge_tutor_threads() FROM PUBLIC, anon, authenticated;

-- L'enveloppe défensive est OBLIGATOIRE : sans elle, la migration échoue sur
-- une base VIERGE sans pg_cron et casse `db:check-chain` — donc la suite pgTAP
-- et tout provisionnement d'un projet TEST neuf. Motif `purge_ai_ledgers`.
-- Créneaux déjà pris : '40 3 * * *' (purge-ai-ledgers), '*/10 * * * *'
-- (sweep-ai-reservations) ; on prend deux créneaux libres, décalés pour ne pas
-- lancer deux DELETE concurrents sur des tables du même produit.
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'purge-tutor-digests';
  PERFORM cron.schedule(
    'purge-tutor-digests', '10 4 * * *',
    $cron$SELECT public.purge_tutor_digests();$cron$
  );

  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'purge-tutor-threads';
  PERFORM cron.schedule(
    'purge-tutor-threads', '25 4 * * *',
    $cron$SELECT public.purge_tutor_threads();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron indisponible (%). Les bilans et les fils fonctionnent, mais AUCUNE des deux rétentions R-14 ne sera appliquée — conversations de mineurs conservées sans limite. Activer pg_cron puis rejouer les blocs cron.schedule(...).',
    SQLERRM;
END;
$$;
