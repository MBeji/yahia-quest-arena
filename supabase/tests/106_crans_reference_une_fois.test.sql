-- =========================================================
-- db-01 — la référence de nouveauté d'un chapitre se calcule UNE fois par appel.
-- ---------------------------------------------------------
-- Migration 20261031110000. Avant elle, la CTE `ref` de `chapter_star_rungs`
-- était aplatie par le planificateur et `chapter_progress_ref` — qui joint
-- toutes les tentatives de l'élève — repartait deux fois par mission : 1 464
-- évaluations pour un hub matière de 10 chapitres, 5 490 pour un tableau de
-- bord de 15 matières (mesure du 2026-10-31). `WITH ref AS MATERIALIZED`
-- garantit l'évaluation unique ; ce fichier garde ce mot ET son effet.
--
-- La preuve de l'effet : dans la transaction du test, `chapter_progress_ref`
-- est remplacée par une sonde de même signature et de même volatilité (STABLE,
-- SECURITY DEFINER — ce qui compte pour le planificateur) qui rend la même
-- valeur mais avance une séquence à chaque évaluation. Un appel des crans sur
-- un chapitre de trois missions doit l'avancer d'UN, pas de six. Tout est
-- annulé à la fin, la sonde comprise.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

INSERT INTO auth.users (id, email) VALUES
  ('d0010000-0000-0000-0000-0000000000aa', 'crans-une-fois@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('d0010000-0000-0000-0000-0000000000aa', 'CransUneFois', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('db01-theme', 'Thème crans', 'book', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('d0010000-0000-0000-0000-0000000000e9'::uuid, 'db01-theme', 'db01-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon)
VALUES ('db01-math', 'db01-theme', 'd0010000-0000-0000-0000-0000000000e9'::uuid,
        'Maths crans', 'logic', 'primary', 'sigma');

INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('d0010000-0000-0000-0000-00000000000a', 'db01-math', 'Crans A', 1);

-- Trois missions : deux anciennes (⭐ et ⭐⭐), une arrivée après la référence
-- (⭐⭐⭐, créée maintenant) — pour qu'une nouveauté ✨ soit réellement calculée.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order, created_at) VALUES
  ('d0010000-0000-0000-0000-00000000a001', 'd0010000-0000-0000-0000-00000000000a', 'db01-math', 'A d1', 'practice', 'admin', 1, 1, now() - INTERVAL '10 days'),
  ('d0010000-0000-0000-0000-00000000a002', 'd0010000-0000-0000-0000-00000000000a', 'db01-math', 'A d2', 'practice', 'admin', 2, 2, now() - INTERVAL '10 days'),
  ('d0010000-0000-0000-0000-00000000a003', 'd0010000-0000-0000-0000-00000000000a', 'db01-math', 'A d3 (neuve)', 'boss', 'admin', 3, 3, now());

-- Une tentative datée dans le passé : c'est elle qui fixe la référence (R-7).
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('d0010000-0000-0000-0000-00000000aa01', 'd0010000-0000-0000-0000-0000000000aa', 'd0010000-0000-0000-0000-00000000a001', 'db01-math', 6, 6, 100, 60, 0, 'classic', now() - INTERVAL '2 days');

-- ---------------------------------------------------------
-- 1. Le mot qui porte tout le gain est dans la définition.
-- ---------------------------------------------------------
SELECT matches(
  (SELECT p.prosrc FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public' AND p.proname = 'chapter_star_rungs'),
  'WITH ref AS MATERIALIZED',
  'chapter_star_rungs pose sa référence dans une CTE MATERIALIZED (db-01)'
);

-- ---------------------------------------------------------
-- 2. Le résultat n'a pas bougé : un cran par difficulté présente, la mission
--    neuve comptée comme nouveauté ✨, la mission réussie comme comptée.
-- ---------------------------------------------------------
SELECT is(
  (SELECT string_agg(r.difficulty || ':' || r.missions_total || ':' || r.missions_counted || ':' || r.missions_new, '|' ORDER BY r.difficulty)
     FROM public.chapter_star_rungs('d0010000-0000-0000-0000-0000000000aa', 'd0010000-0000-0000-0000-00000000000a') r),
  '1:1:1:0|2:1:0:0|3:1:0:1',
  'Les crans sont inchangés : ⭐ comptée, ⭐⭐ à faire, ⭐⭐⭐ neuve ✨'
);

-- ---------------------------------------------------------
-- 3-5. La SONDE : même signature, même volatilité, même valeur, mais une
--      séquence avance à chaque évaluation. Elle ne vit que dans ce test.
-- ---------------------------------------------------------
CREATE TEMPORARY SEQUENCE db01_ref_evaluations;

CREATE OR REPLACE FUNCTION public.chapter_progress_ref(p_user UUID, p_chapter UUID)
RETURNS TIMESTAMPTZ
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT GREATEST(
    (SELECT MAX(s.reached_at)
       FROM public.user_chapter_stars s
      WHERE s.user_id = p_user AND s.chapter_id = p_chapter),
    (SELECT MAX(a.completed_at)
       FROM public.attempts a
       JOIN public.exercises e ON e.id = a.exercise_id
      WHERE a.user_id = p_user AND e.chapter_id = p_chapter)
  ) + nextval('db01_ref_evaluations') * INTERVAL '0';
$fn$;

SELECT is(
  (SELECT string_agg(r.difficulty || ':' || r.missions_new, '|' ORDER BY r.difficulty)
     FROM public.chapter_star_rungs('d0010000-0000-0000-0000-0000000000aa', 'd0010000-0000-0000-0000-00000000000a') r),
  '1:0|2:0|3:1',
  'La sonde rend la même référence : les mêmes nouveautés ✨'
);

SELECT is(
  (SELECT last_value FROM db01_ref_evaluations),
  1::BIGINT,
  'Un appel des crans sur trois missions évalue la référence UNE fois — pas six'
);

-- L'étoile vivante (chemin du trigger à chaque soumission) passe par les crans
-- une fois : la référence n'est évaluée qu'une fois de plus.
SELECT public.chapter_star_live('d0010000-0000-0000-0000-0000000000aa', 'd0010000-0000-0000-0000-00000000000a');

SELECT is(
  (SELECT last_value FROM db01_ref_evaluations),
  2::BIGINT,
  'L''étoile vivante (le trigger de chaque soumission) n''évalue la référence qu''une fois'
);

SELECT * FROM finish();
ROLLBACK;
