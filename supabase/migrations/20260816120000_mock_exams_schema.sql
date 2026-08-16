-- Étude 02 — examen blanc, lot 1 : le schéma d'une épreuve chronométrée.
--
-- POURQUOI MAINTENANT. L'app entraîne mission par mission, avec correction
-- immédiate et récompense au bout. Le concours, lui, est une épreuve : plusieurs
-- matières d'affilée, un chrono global, aucune aide pendant, la correction après.
-- Rien dans le moteur ne sait faire ça — l'étude 02 le dit depuis le 2026-07-04 et
-- le placeholder `'exam'` d'un CHECK est tout ce qui en existait.
--
-- CE QUE CE LOT CHANGE PAR RAPPORT À L'ÉTUDE, ET POURQUOI. L'étude a été écrite
-- AVANT le pivot gratuit du 2026-06-21 ; son R-7 réserve le mode aux porteurs d'un
-- entitlement `concours`. Appliqué tel quel, il livrerait un écran verrouillé pour
-- tout le monde : en phase gratuite tout parcours a `is_premium = false`, donc
-- personne n'a d'entitlement, donc l'examen serait mort-né. **R-7 est donc rescopé :
-- la seule condition est d'avoir un compte.** Rien n'est gaté, aucune surface ne
-- nomme « premium ». Le jour où l'étude 01 dégèle le premium, la garde se repose
-- dans `start_mock_exam` — un `IF` dans une fonction, pas une migration de schéma.
--
-- LE BARÈME EST LA FEATURE. `mock_exam_papers.points` n'est pas une décoration :
-- c'est là que vivent les **coefficients réels du concours** (maths 4, arabe 2+2,
-- français 3, sciences 3, anglais 1). Un examen blanc qui pondère toutes les
-- matières pareil entraîne l'élève à répartir son effort à l'envers ; c'est le
-- reproche principal qu'on peut faire à un QCM générique. La note /20 projetée en
-- sort, et c'est elle que l'élève et le parent lisent.
--
-- CE QUI N'EST PAS ICI. Pas d'annales (le corpus est un corpus de chapitres — leur
-- transcription est un chantier de contenu au dépôt privé, et l'étude 02 les a
-- explicitement repassées en « enrichissement ultérieur » le 2026-08-13). Pas de
-- console de composition : la première session est assemblée par requête dans la
-- migration suivante, ce qui suffit tant qu'il y a un examen par mois.
--
-- ORDRE DE LIVRAISON (DoD §7) : cette migration est ADDITIVE et part avant tout
-- code qui la consomme. Aucun DROP, aucun REVOKE sur l'existant.

-- ---------------------------------------------------------------------------
-- 1. L'examen — une épreuve publiable, rattachée à un parcours.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mock_exams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parcours_id TEXT NOT NULL REFERENCES public.parcours(id) ON DELETE CASCADE,
  title_fr TEXT NOT NULL,
  title_en TEXT,
  title_ar TEXT,
  -- Bornes larges : 15 min pour un blanc d'une seule matière, 300 pour une
  -- simulation longue. La v1 seedée tient en 90.
  duration_minutes INT NOT NULL CHECK (duration_minutes BETWEEN 15 AND 300),
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  display_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_mock_exams_parcours_published
  ON public.mock_exams (parcours_id, display_order)
  WHERE status = 'published';

-- ---------------------------------------------------------------------------
-- 2. L'épreuve — un exercice existant, pondéré par le coefficient réel.
--
-- D-1 de l'étude (curation, pas tirage) est conservé : un examen référence des
-- exercices EXISTANTS, il n'en génère pas. C'est ce qui rend le percentile
-- comparable — deux élèves qui passent « session 1 » ont passé la même épreuve.
--
-- `ON DELETE CASCADE` sur l'exercice est un arbitrage, pas un réflexe : le corpus
-- est réappliqué régulièrement par `apply-content.yml`. Avec RESTRICT, une
-- application de contenu se mettrait à ÉCHOUER à cause d'un examen — on casserait
-- la chaîne de publication pour protéger un blanc. Avec CASCADE, l'examen perd une
-- épreuve, ce qui est visible et rattrapable ; `start_mock_exam` refuse d'ouvrir un
-- examen vide plutôt que de servir une coquille.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mock_exam_papers (
  exam_id UUID NOT NULL REFERENCES public.mock_exams(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  -- Le nom de l'ÉPREUVE (« Mathématiques »), pas le titre de l'exercice : au
  -- concours l'élève voit une matière, pas un chapitre.
  label_fr TEXT NOT NULL,
  label_en TEXT,
  label_ar TEXT,
  points INT NOT NULL CHECK (points > 0),
  display_order INT NOT NULL,
  PRIMARY KEY (exam_id, exercise_id)
);

COMMENT ON COLUMN public.mock_exam_papers.points IS
  'Barème de l''épreuve — porte le COEFFICIENT réel du concours (étude 02 rescopée : maths 4, arabe 2+2, français 3, sciences 3, anglais 1, ×10). La note /20 en dérive.';

CREATE INDEX IF NOT EXISTS idx_mock_exam_papers_exam_order
  ON public.mock_exam_papers (exam_id, display_order);

-- ---------------------------------------------------------------------------
-- 3. La session — l'état serveur d'un passage.
--
-- R-2 : la `deadline` est SERVEUR et absolue (motif du duel, `expires_at`). Le
-- chrono du client n'est qu'un affichage ; il ne décide de rien.
-- R-8 : `answers` est écrit au fil de l'eau, en objet `{questionId: choix}` —
-- un objet et pas un tableau parce que la sauvegarde doit être IDEMPOTENTE :
-- `answers || patch` écrase la réponse d'une question sans jamais la dupliquer,
-- donc un double envoi ou un refresh ne crée pas deux réponses à la même question.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mock_exam_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id UUID NOT NULL REFERENCES public.mock_exams(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  kind TEXT NOT NULL DEFAULT 'ranked' CHECK (kind IN ('ranked', 'practice')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deadline TIMESTAMPTZ NOT NULL,
  finished_at TIMESTAMPTZ,
  answers JSONB NOT NULL DEFAULT '{}'::jsonb,
  score_points NUMERIC,
  max_points INT,
  CONSTRAINT mock_exam_sessions_deadline_after_start CHECK (deadline > started_at)
);

-- R-4 : une seule session CLASSÉE par (examen, élève) ; les reprises sont en
-- `practice` et n'entrent ni au classement ni aux récompenses. L'unicité est un
-- index PARTIEL — la contrainte UNIQUE de l'étude aurait aussi interdit deux
-- entraînements, ce qui n'est pas voulu.
CREATE UNIQUE INDEX IF NOT EXISTS uq_mock_exam_sessions_ranked
  ON public.mock_exam_sessions (exam_id, user_id)
  WHERE kind = 'ranked';

-- D-3 : le percentile se calcule à la lecture, sur cet index — pas de vue
-- matérialisée tant que les volumes sont ceux d'un blanc mensuel.
CREATE INDEX IF NOT EXISTS idx_mock_exam_sessions_ranking
  ON public.mock_exam_sessions (exam_id, score_points)
  WHERE kind = 'ranked' AND finished_at IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mock_exam_sessions_user
  ON public.mock_exam_sessions (user_id, exam_id);

-- ---------------------------------------------------------------------------
-- 4. RLS et droits.
--
-- Les deux tables de catalogue sont en lecture pour l'élève connecté, et
-- seulement quand l'examen est PUBLIÉ : un brouillon en cours de composition ne
-- doit pas fuir ses épreuves à l'avance (RISK-1, partage de sujets).
-- Aucune politique d'ÉCRITURE nulle part, volontairement : le seul écrivain est
-- le jeu de RPC SECURITY DEFINER de la migration suivante, qui s'exécute en
-- propriétaire. Motif de `user_competency_mastery`.
--
-- AGENTS.md : une table neuve porte ses PROPRES grants, sinon la suite pgTAP
-- casse sur une base vierge (baseline 20260612221000).
-- ---------------------------------------------------------------------------
ALTER TABLE public.mock_exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_exam_papers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_exam_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Published exams readable by authenticated"
  ON public.mock_exams
  FOR SELECT TO authenticated
  USING (status = 'published' OR public.is_admin());

CREATE POLICY "Papers of a published exam readable by authenticated"
  ON public.mock_exam_papers
  FOR SELECT TO authenticated
  USING (
    public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.mock_exams e
      WHERE e.id = mock_exam_papers.exam_id
        AND e.status = 'published'
    )
  );

-- R-6 : jamais la session d'un autre élève. `auth.uid()` est enveloppé dans un
-- sous-select scalaire pour que le planner le remonte une fois (posture perf de
-- 20260810120000).
CREATE POLICY "Own exam sessions readable by owner, admin or linked parent"
  ON public.mock_exam_sessions
  FOR SELECT
  USING (
    user_id = (SELECT auth.uid())
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.parent_student_links l
      WHERE l.parent_user_id = (SELECT auth.uid())
        AND l.student_user_id = mock_exam_sessions.user_id
        AND l.is_active
    )
  );

REVOKE ALL ON public.mock_exams FROM anon, authenticated;
GRANT SELECT ON public.mock_exams TO authenticated;
GRANT ALL ON public.mock_exams TO service_role;

REVOKE ALL ON public.mock_exam_papers FROM anon, authenticated;
GRANT SELECT ON public.mock_exam_papers TO authenticated;
GRANT ALL ON public.mock_exam_papers TO service_role;

REVOKE ALL ON public.mock_exam_sessions FROM anon, authenticated;
GRANT SELECT ON public.mock_exam_sessions TO authenticated;
GRANT ALL ON public.mock_exam_sessions TO service_role;
