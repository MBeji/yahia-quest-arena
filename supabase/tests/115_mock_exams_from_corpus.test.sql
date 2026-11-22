-- =========================================================
-- Étude 02, suite — les épreuves par matière, déclarées par le corpus.
-- ---------------------------------------------------------
-- Le registre du corpus (`content/mock-exams.json`) compose les examens blancs ;
-- `buildMockExamRegistrySql` le compile, le canal de contenu l'applique. Ce fichier
-- REJOUE le SQL compilé — pas une imitation : les deux blocs `$gen_v…$` ci-dessous
-- sont la sortie du constructeur sur les fixtures de
-- `src/shared/content/__tests__/mock-exam-registry.fixture.ts`, et le test Vitest
-- `content-pipeline-mock-exams.test.ts` échoue dès qu'ils s'en écartent.
--
-- Ce qu'un registre d'examens peut casser, et que ce fichier attaque :
--
--   1. PUBLIER UNE ÉPREUVE AMPUTÉE. Une épreuve dont l'exercice n'est pas en base
--      (sujet pas encore appliqué) ne s'écrit pas ; l'examen doit alors rester
--      `draft` — un français sans sa compréhension n'est pas une épreuve.
--   2. EFFACER DES COPIES. `mock_exam_sessions` pend à l'examen en CASCADE : un
--      examen retiré du registre est ARCHIVÉ, jamais supprimé, et garde ses
--      épreuves (le corrigé d'une copie rendue reste lisible).
--   3. TOUCHER CE QU'IL N'A PAS DÉCLARÉ. La session 1, semée par migration, n'a
--      pas de slug : le registre ne l'archive pas, ne la modifie pas.
--   4. SE DÉDOUBLER AU REJEU. Le canal de contenu rejoue le fichier à chaque
--      application : deux passages = le même état.
--
-- Espace de noms des fixtures : matières `exam-reg-a` / `exam-reg-b`, examens
-- `fixture-…`, compte `e9a30000…`, examens semés `7e571150…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(24);

-- =========================================================
-- 1-5. La forme posée par la migration du 2026-11-22.
-- =========================================================
SELECT has_column('public', 'mock_exams', 'slug',
  'un examen déclaré par le corpus porte son slug');
SELECT has_column('public', 'mock_exams', 'subject_id',
  'et la matière qui range une épreuve mono-matière');

INSERT INTO public.mock_exams (id, parcours_id, title_fr, duration_minutes, status, display_order)
VALUES ('7e571150-0000-4000-8000-000000000001', 'concours-9eme', 'Examen semé (fixture)', 90, 'published', 1);
INSERT INTO public.mock_exams (id, parcours_id, title_fr, duration_minutes, status, display_order)
VALUES ('7e571150-0000-4000-8000-000000000002', 'concours-9eme', 'Second examen semé (fixture)', 90, 'draft', 2);

SELECT is(
  (SELECT count(*)::int FROM public.mock_exams
    WHERE id::text LIKE '7e571150-%' AND slug IS NULL),
  2, 'deux examens SANS slug coexistent — l''unicité ne mord que sur un slug posé');

SELECT throws_ok(
  $$INSERT INTO public.mock_exams (parcours_id, slug, title_fr, duration_minutes)
    VALUES ('concours-9eme', 'Pas Un Slug', 'Refusé', 60)$$,
  '23514', NULL,
  'un slug hors kebab-case est refusé — l''unicité ne se joue pas sur une casse');

INSERT INTO public.mock_exams (parcours_id, slug, title_fr, duration_minutes)
VALUES ('concours-9eme', 'fixture-doublon', 'Premier', 60);
SELECT throws_ok(
  $$INSERT INTO public.mock_exams (parcours_id, slug, title_fr, duration_minutes)
    VALUES ('concours-9eme', 'fixture-doublon', 'Second', 60)$$,
  '23505', NULL,
  'deux examens ne partagent pas un slug');
DELETE FROM public.mock_exams WHERE slug = 'fixture-doublon';

-- =========================================================
-- Fixtures — deux matières ; `exam-reg-b` n'a PAS encore son exercice : c'est le
-- sujet « pas encore appliqué » du monde réel. Les ids d'exercice sont les
-- UUIDv5 du chemin, ceux que le constructeur écrit dans le SQL compilé.
-- =========================================================
INSERT INTO auth.users (id, email) VALUES
  ('e9a30000-0000-4000-8000-00000000000a', 'eleve-registre-exam@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('exam-reg-a', 'Langue (fixture)', 'Esprit', 'subject-french', 'BookOpen', 'ecole-tn'),
       ('exam-reg-b', 'Calcul (fixture)', 'Force', 'subject-math', 'Calculator', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e571151-0000-4000-8000-00000000000a', 'exam-reg-a', 'Chapitre A'),
       ('7e571151-0000-4000-8000-00000000000b', 'exam-reg-b', 'Chapitre B');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty)
VALUES
  ('61e759ab-312a-5996-b061-f8993553a77c', '7e571151-0000-4000-8000-00000000000a',
   'exam-reg-a', 'Compréhension', 'admin', 'practice', 2),
  ('420d4927-78a9-5027-937d-315b6332fdb3', '7e571151-0000-4000-8000-00000000000a',
   'exam-reg-a', 'Langue', 'admin', 'practice', 2);

-- Le SQL compilé, tel quel. Une fonction `LANGUAGE sql` accepte plusieurs
-- instructions : c'est ce qui permet de le rejouer deux fois sans le recopier.
CREATE FUNCTION pg_temp.apply_registry_v1() RETURNS void LANGUAGE sql AS $gen_v1$
-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Mock-exam registry (étude 02) — 2 exam(s), 4 paper(s)
-- Regenerate with: npm run content:build -- --mock-exams
-- Source of truth: content/mock-exams.json
-- Apply AFTER the subjects: a paper only lands if its exercise is in base.
-- =========================================================

-- 1. Les examens déclarés. Le parcours doit exister (JOIN) : un examen
--    déclaré pour un parcours absent de cette base ne s'écrit pas, il n'échoue pas.
INSERT INTO public.mock_exams
  (id, slug, parcours_id, subject_id, title_fr, title_en, title_ar, duration_minutes, status, display_order)
SELECT v.id, v.slug, v.parcours_id, sub.id, v.title_fr, v.title_en, v.title_ar,
       v.duration_minutes, 'draft', v.display_order
  FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, 'fixture-blanc-deux-matieres', 'concours-9eme', NULL::text, 'Blanc à deux matières', 'Two-subject mock', 'تجريبي بمادتين', 90, 120),
    ('99092e31-6322-5e33-8422-170359f37c03'::uuid, 'fixture-epreuve-langue-1', 'concours-9eme', 'exam-reg-a'::text, 'Épreuve de l''élève', 'The student''s paper', 'اختبار التلميذ', 60, 110)
  ) AS v(id, slug, parcours_id, subject_id, title_fr, title_en, title_ar, duration_minutes, display_order)
  JOIN public.parcours p ON p.id = v.parcours_id
  LEFT JOIN public.subjects sub ON sub.id = v.subject_id
ON CONFLICT (id) DO UPDATE SET
  slug = EXCLUDED.slug,
  parcours_id = EXCLUDED.parcours_id,
  subject_id = EXCLUDED.subject_id,
  title_fr = EXCLUDED.title_fr,
  title_en = EXCLUDED.title_en,
  title_ar = EXCLUDED.title_ar,
  duration_minutes = EXCLUDED.duration_minutes,
  display_order = EXCLUDED.display_order;

-- 2. Les épreuves qu'un examen DÉCLARÉ ne liste plus. Un examen archivé
--    (plus déclaré) garde les siennes : le corrigé d'une copie rendue reste lisible.
DELETE FROM public.mock_exam_papers pp
 WHERE pp.exam_id IN ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, '99092e31-6322-5e33-8422-170359f37c03'::uuid)
   AND NOT EXISTS (
     SELECT 1 FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, '61e759ab-312a-5996-b061-f8993553a77c'::uuid),
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, 'bd33717a-3767-5db0-b9ce-3c57974de599'::uuid),
    ('99092e31-6322-5e33-8422-170359f37c03'::uuid, '61e759ab-312a-5996-b061-f8993553a77c'::uuid),
    ('99092e31-6322-5e33-8422-170359f37c03'::uuid, '420d4927-78a9-5027-937d-315b6332fdb3'::uuid)
     ) AS d(exam_id, exercise_id)
      WHERE d.exam_id = pp.exam_id AND d.exercise_id = pp.exercise_id
   );

-- 3. Les épreuves déclarées — seulement celles dont l'exercice est en base.
INSERT INTO public.mock_exam_papers
  (exam_id, exercise_id, label_fr, label_en, label_ar, points, display_order)
SELECT d.exam_id, d.exercise_id, d.label_fr, d.label_en, d.label_ar, d.points, d.display_order
  FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, '61e759ab-312a-5996-b061-f8993553a77c'::uuid, 'Langue', 'Language', 'اللغة', 40, 1),
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, 'bd33717a-3767-5db0-b9ce-3c57974de599'::uuid, 'Calcul', 'Arithmetic', 'الحساب', 10, 2),
    ('99092e31-6322-5e33-8422-170359f37c03'::uuid, '61e759ab-312a-5996-b061-f8993553a77c'::uuid, 'I. Compréhension', 'I. Reading', 'الفهم', 70, 1),
    ('99092e31-6322-5e33-8422-170359f37c03'::uuid, '420d4927-78a9-5027-937d-315b6332fdb3'::uuid, 'II. Langue', 'II. Language', 'اللغة', 60, 2)
  ) AS d(exam_id, exercise_id, label_fr, label_en, label_ar, points, display_order)
  JOIN public.mock_exams e ON e.id = d.exam_id
  JOIN public.exercises x ON x.id = d.exercise_id
ON CONFLICT (exam_id, exercise_id) DO UPDATE SET
  label_fr = EXCLUDED.label_fr,
  label_en = EXCLUDED.label_en,
  label_ar = EXCLUDED.label_ar,
  points = EXCLUDED.points,
  display_order = EXCLUDED.display_order;

-- 4. Publié si COMPLET, brouillon sinon — jamais une épreuve amputée.
UPDATE public.mock_exams e
   SET status = CASE
         WHEN (SELECT count(*) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id) = d.expected
           THEN 'published'
         ELSE 'draft'
       END
  FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, 2),
    ('99092e31-6322-5e33-8422-170359f37c03'::uuid, 2)
  ) AS d(id, expected)
 WHERE e.id = d.id;

-- 5. Ce que le registre ne déclare plus est ARCHIVÉ, jamais supprimé : les
--    copies des élèves pendent à l'examen. `slug IS NOT NULL` borne le geste
--    aux examens que ce registre a lui-même déclarés.
UPDATE public.mock_exams
   SET status = 'archived'
 WHERE slug IS NOT NULL
   AND status <> 'archived'
   AND id NOT IN ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, '99092e31-6322-5e33-8422-170359f37c03'::uuid);
$gen_v1$;

CREATE FUNCTION pg_temp.apply_registry_v2() RETURNS void LANGUAGE sql AS $gen_v2$
-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Mock-exam registry (étude 02) — 1 exam(s), 1 paper(s)
-- Regenerate with: npm run content:build -- --mock-exams
-- Source of truth: content/mock-exams.json
-- Apply AFTER the subjects: a paper only lands if its exercise is in base.
-- =========================================================

-- 1. Les examens déclarés. Le parcours doit exister (JOIN) : un examen
--    déclaré pour un parcours absent de cette base ne s'écrit pas, il n'échoue pas.
INSERT INTO public.mock_exams
  (id, slug, parcours_id, subject_id, title_fr, title_en, title_ar, duration_minutes, status, display_order)
SELECT v.id, v.slug, v.parcours_id, sub.id, v.title_fr, v.title_en, v.title_ar,
       v.duration_minutes, 'draft', v.display_order
  FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, 'fixture-blanc-deux-matieres', 'concours-9eme', NULL::text, 'Blanc à une matière', 'One-subject mock', 'تجريبي بمادة', 45, 120)
  ) AS v(id, slug, parcours_id, subject_id, title_fr, title_en, title_ar, duration_minutes, display_order)
  JOIN public.parcours p ON p.id = v.parcours_id
  LEFT JOIN public.subjects sub ON sub.id = v.subject_id
ON CONFLICT (id) DO UPDATE SET
  slug = EXCLUDED.slug,
  parcours_id = EXCLUDED.parcours_id,
  subject_id = EXCLUDED.subject_id,
  title_fr = EXCLUDED.title_fr,
  title_en = EXCLUDED.title_en,
  title_ar = EXCLUDED.title_ar,
  duration_minutes = EXCLUDED.duration_minutes,
  display_order = EXCLUDED.display_order;

-- 2. Les épreuves qu'un examen DÉCLARÉ ne liste plus. Un examen archivé
--    (plus déclaré) garde les siennes : le corrigé d'une copie rendue reste lisible.
DELETE FROM public.mock_exam_papers pp
 WHERE pp.exam_id IN ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid)
   AND NOT EXISTS (
     SELECT 1 FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, '61e759ab-312a-5996-b061-f8993553a77c'::uuid)
     ) AS d(exam_id, exercise_id)
      WHERE d.exam_id = pp.exam_id AND d.exercise_id = pp.exercise_id
   );

-- 3. Les épreuves déclarées — seulement celles dont l'exercice est en base.
INSERT INTO public.mock_exam_papers
  (exam_id, exercise_id, label_fr, label_en, label_ar, points, display_order)
SELECT d.exam_id, d.exercise_id, d.label_fr, d.label_en, d.label_ar, d.points, d.display_order
  FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, '61e759ab-312a-5996-b061-f8993553a77c'::uuid, 'Langue', 'Language', 'اللغة', 40, 1)
  ) AS d(exam_id, exercise_id, label_fr, label_en, label_ar, points, display_order)
  JOIN public.mock_exams e ON e.id = d.exam_id
  JOIN public.exercises x ON x.id = d.exercise_id
ON CONFLICT (exam_id, exercise_id) DO UPDATE SET
  label_fr = EXCLUDED.label_fr,
  label_en = EXCLUDED.label_en,
  label_ar = EXCLUDED.label_ar,
  points = EXCLUDED.points,
  display_order = EXCLUDED.display_order;

-- 4. Publié si COMPLET, brouillon sinon — jamais une épreuve amputée.
UPDATE public.mock_exams e
   SET status = CASE
         WHEN (SELECT count(*) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id) = d.expected
           THEN 'published'
         ELSE 'draft'
       END
  FROM (VALUES
    ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid, 1)
  ) AS d(id, expected)
 WHERE e.id = d.id;

-- 5. Ce que le registre ne déclare plus est ARCHIVÉ, jamais supprimé : les
--    copies des élèves pendent à l'examen. `slug IS NOT NULL` borne le geste
--    aux examens que ce registre a lui-même déclarés.
UPDATE public.mock_exams
   SET status = 'archived'
 WHERE slug IS NOT NULL
   AND status <> 'archived'
   AND id NOT IN ('5b1b395e-247a-5086-84ac-0e2c494d67df'::uuid);
$gen_v2$;

-- =========================================================
-- 6-12. Premier passage : complet → publié ; amputé → brouillon.
-- =========================================================
SELECT lives_ok($$SELECT pg_temp.apply_registry_v1()$$,
  'le SQL compilé s''exécute sur une base où un sujet manque encore');

SELECT is(
  (SELECT status FROM public.mock_exams WHERE slug = 'fixture-epreuve-langue-1'),
  'published', 'une épreuve dont TOUTES les parties sont en base est publiée');

SELECT is(
  (SELECT subject_id FROM public.mock_exams WHERE slug = 'fixture-epreuve-langue-1'),
  'exam-reg-a', 'elle porte sa matière');

SELECT is(
  (SELECT array_agg(pp.label_fr || ':' || pp.points ORDER BY pp.display_order)
     FROM public.mock_exam_papers pp
     JOIN public.mock_exams e ON e.id = pp.exam_id
    WHERE e.slug = 'fixture-epreuve-langue-1'),
  ARRAY['I. Compréhension:70', 'II. Langue:60'],
  'ses parties sont dans l''ordre du registre, avec leur barème');

SELECT is(
  (SELECT status FROM public.mock_exams WHERE slug = 'fixture-blanc-deux-matieres'),
  'draft', 'un examen auquel il MANQUE une épreuve reste brouillon — jamais une épreuve amputée');

SELECT is(
  (SELECT count(*)::int FROM public.mock_exam_papers pp
     JOIN public.mock_exams e ON e.id = pp.exam_id
    WHERE e.slug = 'fixture-blanc-deux-matieres'),
  1, 'seule l''épreuve dont l''exercice existe a été écrite');

SELECT is(
  (SELECT subject_id FROM public.mock_exams WHERE slug = 'fixture-blanc-deux-matieres'),
  NULL, 'un blanc multi-matières n''a pas de matière');

-- =========================================================
-- 13-16. Le sujet manquant arrive, le fichier est rejoué : l'examen se complète,
-- et rien ne se dédouble.
-- =========================================================
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty)
VALUES ('bd33717a-3767-5db0-b9ce-3c57974de599', '7e571151-0000-4000-8000-00000000000b',
        'exam-reg-b', 'Calcul', 'admin', 'practice', 2);

SELECT lives_ok($$SELECT pg_temp.apply_registry_v1()$$, 'le rejeu passe');

SELECT is(
  (SELECT status FROM public.mock_exams WHERE slug = 'fixture-blanc-deux-matieres'),
  'published', 'l''examen se publie de lui-même quand sa dernière épreuve arrive');

SELECT is(
  (SELECT count(*)::int FROM public.mock_exam_papers pp
     JOIN public.mock_exams e ON e.id = pp.exam_id
    WHERE e.slug LIKE 'fixture-%'),
  4, 'deux passages = quatre épreuves, pas huit');

SELECT is(
  (SELECT count(*)::int FROM public.mock_exams WHERE slug LIKE 'fixture-%'),
  2, 'et deux examens, pas quatre');

-- =========================================================
-- 17-18. Le catalogue de l'élève rend la matière — c'est elle qui range l'écran.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"e9a30000-0000-4000-8000-00000000000a","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT x->>'subjectName' FROM jsonb_array_elements(public.list_mock_exams('concours-9eme')) x
    WHERE x->>'titleFr' = 'Épreuve de l''élève'),
  'Langue (fixture)', 'list_mock_exams rend le nom de la matière d''une épreuve');

SELECT is(
  (SELECT x->'subjectId' FROM jsonb_array_elements(public.list_mock_exams('concours-9eme')) x
    WHERE x->>'titleFr' = 'Blanc à deux matières'),
  'null'::jsonb, 'et null pour un blanc qui mêle les matières');

RESET ROLE;

-- =========================================================
-- 19-24. Le registre change : une épreuve retirée, une partie en moins. Une
-- copie a été rendue entre-temps — c'est elle qu'un DELETE aurait emportée.
-- =========================================================
INSERT INTO public.mock_exam_sessions (id, exam_id, user_id, kind, deadline, finished_at, score_points, max_points)
SELECT '7e571152-0000-4000-8000-000000000001', e.id, 'e9a30000-0000-4000-8000-00000000000a',
       'ranked', now() + interval '1 hour', now(), 65, 130
  FROM public.mock_exams e WHERE e.slug = 'fixture-epreuve-langue-1';

SELECT lives_ok($$SELECT pg_temp.apply_registry_v2()$$, 'la seconde version du registre s''applique');

SELECT is(
  (SELECT status FROM public.mock_exams WHERE slug = 'fixture-epreuve-langue-1'),
  'archived', 'l''épreuve que le registre ne déclare plus est ARCHIVÉE');

SELECT is(
  (SELECT count(*)::int FROM public.mock_exam_sessions
    WHERE id = '7e571152-0000-4000-8000-000000000001'),
  1, 'la copie rendue est toujours là — archiver n''efface rien');

SELECT is(
  (SELECT count(*)::int FROM public.mock_exam_papers pp
     JOIN public.mock_exams e ON e.id = pp.exam_id
    WHERE e.slug = 'fixture-epreuve-langue-1'),
  2, 'et l''examen archivé garde ses épreuves : le corrigé de la copie reste lisible');

SELECT is(
  (SELECT e.title_fr || '/' || e.duration_minutes || '/' || e.status || '/' ||
          (SELECT count(*) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id)
     FROM public.mock_exams e WHERE e.slug = 'fixture-blanc-deux-matieres'),
  'Blanc à une matière/45/published/1',
  'l''examen toujours déclaré suit le registre : titre, durée, épreuve retirée, et il reste publié');

SELECT is(
  (SELECT array_agg(status ORDER BY display_order) FROM public.mock_exams
    WHERE id::text LIKE '7e571150-%'),
  ARRAY['published', 'draft'],
  'les examens semés par migration (sans slug) n''ont pas bougé — le registre ne gère que les siens');

SELECT * FROM finish();
ROLLBACK;
