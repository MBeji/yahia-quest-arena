-- =========================================================
-- Étude 02, suite — les épreuves par matière, déclarées par le corpus.
-- ---------------------------------------------------------
-- LE BESOIN (commande du propriétaire, 2026-11-22). Un parent veut savoir si son
-- enfant « a le niveau » dans chacune des matières du concours. Le seul examen
-- blanc en base, « Concours blanc 9ᵉ — session 1 », pose six questions par
-- matière : il dit qu'on a passé un examen, pas ce qu'on vaut en arabe. Il faut
-- des ÉPREUVES — une matière, son format réel (compréhension / langue /
-- production ; les cinq exercices d'un sujet de mathématiques), sa note sur 20.
--
-- POURQUOI LE SEED NE SUFFIT PAS. La session 1 est composée par un
-- `INSERT … SELECT` qui prend, par matière, l'exercice le plus difficile : il ne
-- sait pas DÉSIGNER un exercice. Or un exercice du corpus n'a pas d'identité dans
-- ce dépôt (étude 24) — son id est un UUIDv5 de son chemin, que seul le pipeline
-- de contenu sait calculer. La composition d'une épreuve part donc du corpus :
-- `content/mock-exams.json`, compilé par `content:build -- --mock-exams` en
-- `_mock_exams_registry.sql`, appliqué par le canal de contenu APRÈS les sujets
-- (une épreuve référence leurs exercices).
--
-- CE QUE CETTE MIGRATION AJOUTE, et rien de plus :
--
--   • `mock_exams.slug` — l'identité d'une épreuve DÉCLARÉE PAR LE CORPUS. NULL
--     pour un examen semé par migration (la session 1) : c'est ce qui permet au
--     registre d'archiver ce qu'il ne déclare plus SANS toucher à ce qu'il n'a
--     jamais déclaré. Unique quand il est posé.
--
--   • `mock_exams.subject_id` — la matière d'une épreuve mono-matière ; NULL pour
--     un concours blanc qui les mêle. `ON DELETE SET NULL` : une matière retirée
--     ne doit pas emporter les copies déjà rendues (les sessions pendent à
--     l'examen, pas à la matière).
--
--   • `list_mock_exams` rend `subjectId` et `subjectName` : le catalogue range les
--     épreuves par matière. Même signature, donc `CREATE OR REPLACE` conserve les
--     droits posés le 2026-08-16 ; ils sont réaffirmés plus bas pour qu'une base
--     reconstruite ne dépende pas de cet héritage.
--
-- Additive de bout en bout : un client d'avant ignore les deux champs neufs, un
-- client d'après lit `null` tant que la fonction n'est pas remplacée. Aucune
-- donnée n'est écrite ici — sur une base sans corpus il n'y a rien à composer, et
-- `db:check-chain` rejoue cette migration à vide.
-- =========================================================

ALTER TABLE public.mock_exams
  ADD COLUMN IF NOT EXISTS slug TEXT,
  ADD COLUMN IF NOT EXISTS subject_id TEXT REFERENCES public.subjects(id) ON DELETE SET NULL;

-- Kebab-case, comme tout slug du corpus : l'unicité ne doit pas se jouer sur une
-- casse ou un espace. Posée sous garde d'existence (et non par un DROP suivi d'un
-- ADD) : la migration reste rejouable sans jamais retirer une contrainte.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
     WHERE conname = 'mock_exams_slug_format'
       AND conrelid = 'public.mock_exams'::regclass
  ) THEN
    ALTER TABLE public.mock_exams
      ADD CONSTRAINT mock_exams_slug_format
      CHECK (slug IS NULL OR slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
  END IF;
END
$$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_mock_exams_slug
  ON public.mock_exams (slug)
  WHERE slug IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_mock_exams_subject
  ON public.mock_exams (subject_id)
  WHERE subject_id IS NOT NULL;

COMMENT ON COLUMN public.mock_exams.slug IS
  'Identité d''une épreuve déclarée par le corpus (content/mock-exams.json). NULL = examen semé par migration, que le registre du corpus ne gère pas et n''archive jamais.';
COMMENT ON COLUMN public.mock_exams.subject_id IS
  'Matière d''une épreuve mono-matière ; NULL pour un concours blanc multi-matières. Sert au rangement du catalogue, jamais au barème.';

CREATE OR REPLACE FUNCTION public.list_mock_exams(p_parcours_id TEXT DEFAULT NULL)
RETURNS JSONB
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', e.id,
        'parcoursId', e.parcours_id,
        'subjectId', e.subject_id,
        -- Le nom tel que le catalogue l'affiche partout ailleurs : dans la langue
        -- de la matière (`subjects.name_fr` porte « العربية » pour l'arabe).
        'subjectName', (
          SELECT sub.name_fr FROM public.subjects sub WHERE sub.id = e.subject_id
        ),
        'titleFr', e.title_fr,
        'titleEn', e.title_en,
        'titleAr', e.title_ar,
        'durationMinutes', e.duration_minutes,
        'paperCount', (
          SELECT count(*) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id
        ),
        'maxPoints', COALESCE((
          SELECT sum(pp.points) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id
        ), 0),
        'mySessions', COALESCE((
          SELECT jsonb_agg(
                   jsonb_build_object(
                     'id', s.id,
                     'kind', s.kind,
                     'startedAt', s.started_at,
                     'deadline', s.deadline,
                     'finishedAt', s.finished_at,
                     'scorePoints', s.score_points,
                     'maxPoints', s.max_points
                   ) ORDER BY s.started_at DESC
                 )
          FROM public.mock_exam_sessions s
          WHERE s.exam_id = e.id AND s.user_id = (SELECT auth.uid())
        ), '[]'::jsonb)
      ) ORDER BY e.display_order, e.created_at
    ),
    '[]'::jsonb
  )
  FROM public.mock_exams e
  WHERE e.status = 'published'
    AND (p_parcours_id IS NULL OR e.parcours_id = p_parcours_id);
$$;

REVOKE ALL ON FUNCTION public.list_mock_exams(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.list_mock_exams(TEXT) TO authenticated;
