-- =========================================================
-- LE REJEU INITIAL — « on ne reprend rien à personne » (étude 34, R-15).
-- ---------------------------------------------------------
-- La migration inscrit au grand livre ce que les tentatives DÉJÀ EN BASE
-- valent. Deux passes, et ce fichier tient les deux :
--
--   a) la règle d'AUJOURD'HUI (R-3, précipitation exclue) sur le contenu
--      d'aujourd'hui — elle doit donner EXACTEMENT ce que le trigger aurait
--      donné, sinon un élève d'avant et un élève d'après ne seraient pas logés
--      à la même enseigne ;
--   b) le GRAND-PÈRE : un chapitre complet au sens de é22 R-15 — l'ancienne
--      règle, qui tolérait la précipitation — reçoit l'étoile 4 même si R-3 la
--      lui refuserait. Le durcissement vaut pour la suite, jamais
--      rétroactivement.
--
-- ⭐ POURQUOI CE FICHIER PEUT EXISTER : le rejeu est une FONCTION
-- (`replay_progress_stars`), pas un bloc anonyme. Un `DO $$…$$` n'aurait été
-- rejouable par aucun test, et l'écriture d'une migration dans une table
-- serait restée une promesse sur parole.
--
-- Méthode : on DÉSACTIVE le trigger, on pose des tentatives comme si elles
-- dataient d'avant l'étude, on lance le rejeu, on compare.
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(9);

ALTER TABLE public.attempts DISABLE TRIGGER trg_record_progress_stars;

INSERT INTO auth.users (id, email) VALUES
  ('ed000000-0000-0000-0000-0000000000aa', 'rejeu@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('ed000000-0000-0000-0000-0000000000aa', 'Rejeu', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('rj-theme', 'Thème rejeu', 'history', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('ed000000-0000-0000-0000-0000000000e9'::uuid, 'rj-theme', 'rj-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon)
VALUES ('rj-math', 'rj-theme', 'ed000000-0000-0000-0000-0000000000e9'::uuid,
        'Maths rejeu', 'logic', 'primary', 'sigma');

-- RJ-A : tout propre — la règle d'aujourd'hui suffit.
-- RJ-B : la mission ⭐⭐ a été réussie EN SE PRÉCIPITANT. R-3 la refuse ;
--        l'ancienne règle la comptait, donc le grand-père doit la sauver.
-- RJ-C : rien de complet — ni l'une ni l'autre passe.
INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('ed000000-0000-0000-0000-00000000000a', 'rj-math', 'RJ-A', 1),
  ('ed000000-0000-0000-0000-00000000000b', 'rj-math', 'RJ-B', 2),
  ('ed000000-0000-0000-0000-00000000000c', 'rj-math', 'RJ-C', 3);

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('ed000000-0000-0000-0000-00000000a001', 'ed000000-0000-0000-0000-00000000000a', 'rj-math', 'A d1', 'practice', 'admin', 1, 1),
  ('ed000000-0000-0000-0000-00000000a002', 'ed000000-0000-0000-0000-00000000000a', 'rj-math', 'A d2', 'practice', 'admin', 2, 2),
  ('ed000000-0000-0000-0000-00000000b001', 'ed000000-0000-0000-0000-00000000000b', 'rj-math', 'B d1', 'practice', 'admin', 1, 1),
  ('ed000000-0000-0000-0000-00000000b002', 'ed000000-0000-0000-0000-00000000000b', 'rj-math', 'B d2', 'practice', 'admin', 2, 2),
  ('ed000000-0000-0000-0000-00000000c001', 'ed000000-0000-0000-0000-00000000000c', 'rj-math', 'C d1', 'practice', 'admin', 1, 1),
  ('ed000000-0000-0000-0000-0000000009a1', 'ed000000-0000-0000-0000-00000000000a', 'rj-math', 'quiz A', 'quiz', 'admin', 1, 0),
  ('ed000000-0000-0000-0000-0000000009b1', 'ed000000-0000-0000-0000-00000000000b', 'rj-math', 'quiz B', 'quiz', 'admin', 1, 0),
  ('ed000000-0000-0000-0000-0000000009c1', 'ed000000-0000-0000-0000-00000000000c', 'rj-math', 'quiz C', 'quiz', 'admin', 1, 0);

INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  -- RJ-A : quiz posé, deux missions réussies proprement
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-0000000009a1', 'rj-math', 10, 10, 100, 120, 0, 'classic', now() - INTERVAL '10 days'),
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-00000000a001', 'rj-math',  6,  6, 100,  60, 0, 'classic', now() - INTERVAL '9 days'),
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-00000000a002', 'rj-math',  6,  6, 100,  60, 0, 'classic', now() - INTERVAL '8 days'),
  -- RJ-B : quiz posé, ⭐ propre, ⭐⭐ EXPÉDIÉE (6 questions en 5 s)
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-0000000009b1', 'rj-math', 10, 10, 100, 120, 0, 'classic', now() - INTERVAL '7 days'),
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-00000000b001', 'rj-math',  6,  6, 100,  60, 0, 'classic', now() - INTERVAL '6 days'),
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-00000000b002', 'rj-math',  6,  6, 100,   5, 0, 'classic', now() - INTERVAL '5 days'),
  -- RJ-C : quiz seulement
  ('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-0000000009c1', 'rj-math', 10, 10, 100, 120, 0, 'classic', now() - INTERVAL '4 days');

-- ---------------------------------------------------------
-- 1. Le trigger étant désactivé, rien n'est inscrit : c'est bien l'état
--    « d'avant l'étude » que l'on rejoue.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ed000000-0000-0000-0000-0000000000aa'),
  0,
  'Avant le rejeu, le grand livre est vide — le décor est bien celui d''avant'
);

SELECT is(
  (SELECT chapters_completed FROM public.student_parcours_progress(
     'ed000000-0000-0000-0000-0000000000aa', ARRAY['rj-math'])),
  0,
  '…et la carte /parcours ne compte rien, puisqu''elle lit le grand livre'
);

-- ---------------------------------------------------------
-- 2-6. LE REJEU.
-- ---------------------------------------------------------
SELECT lives_ok(
  $$SELECT public.replay_progress_stars()$$,
  'Le rejeu s''exécute'
);

SELECT is(
  (SELECT MAX(star)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ed000000-0000-0000-0000-0000000000aa'
      AND chapter_id = 'ed000000-0000-0000-0000-00000000000a'),
  4,
  'RJ-A, propre de bout en bout : quatre étoiles, comme le trigger les aurait posées'
);

SELECT is(
  (SELECT MAX(star)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ed000000-0000-0000-0000-0000000000aa'
      AND chapter_id = 'ed000000-0000-0000-0000-00000000000b'),
  4,
  '⭐ RJ-B, dont la ⭐⭐ fut EXPÉDIÉE : le GRAND-PÈRE le sauve — R-3 ne reprend rien'
);

SELECT is(
  public.chapter_star_live('ed000000-0000-0000-0000-0000000000aa', 'ed000000-0000-0000-0000-00000000000b')::INT,
  1,
  '…alors que la règle d''aujourd''hui ne lui donnerait qu''une étoile : c''est bien un grand-père'
);

SELECT is(
  (SELECT count(*)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ed000000-0000-0000-0000-0000000000aa'
      AND chapter_id = 'ed000000-0000-0000-0000-00000000000c'),
  0,
  'RJ-C, où rien n''est fini, ne reçoit rien — le rejeu n''invente pas de progression'
);

SELECT is(
  (SELECT reached_at::date FROM public.user_chapter_stars
    WHERE user_id = 'ed000000-0000-0000-0000-0000000000aa'
      AND chapter_id = 'ed000000-0000-0000-0000-00000000000a' AND star = 4),
  (now() - INTERVAL '8 days')::date,
  'Une étoile rejouée est datée de la dernière tentative du chapitre, pas de la migration'
);

-- ---------------------------------------------------------
-- 7. Le rejeu est IDEMPOTENT : la reconciliation horaire des migrations peut
--    le rejouer sans rien dupliquer ni redater.
-- ---------------------------------------------------------
SELECT is(
  (SELECT (public.replay_progress_stars() ->> 'stars')::INT),
  0,
  'Relancé, il n''inscrit plus rien — ON CONFLICT DO NOTHING, dates d''origine gardées'
);

ALTER TABLE public.attempts ENABLE TRIGGER trg_record_progress_stars;

SELECT * FROM finish();
ROLLBACK;
