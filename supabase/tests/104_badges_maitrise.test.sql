-- =========================================================
-- ÉTUDE 34, LOT 4 — LES TROIS BADGES DE LA MAÎTRISE.
-- ---------------------------------------------------------
-- Trois badges, et pas un de plus (D-7). Ce fichier tient les trois conditions,
-- leur ORDRE — chacun doit tomber au bon moment, pas tous ensemble — et les deux
-- gardes sans lesquelles le décernement serait faux :
--
--   1. ⭐ **L'IDEMPOTENCE.** Un sceau déjà acquis ne re-décerne rien : le trigger
--      compte les lignes RÉELLEMENT posées (`GET DIAGNOSTICS` après un
--      `ON CONFLICT DO NOTHING`). Sans cette garde, chaque tentative d'un élève
--      déjà scellé rejouerait trois `award_badge_if_new` pour rien, et
--      `get_attempt_progress` ne saurait plus quels badges CETTE soumission a
--      fait tomber.
--   2. ⭐ **AUCUNE VALEUR.** R-11 et D-10 : ni XP ni pièce pour une étoile, un
--      sceau ou un badge de cette étude. L'étude 09 garde seule la main sur la
--      valeur, et une valeur ajoutée sans mesure devient un signal faux. Le décor
--      vérifie que le trigger ne touche pas au profil.
--
-- ⚠️ Une instruction `INSERT` par tentative (leçon du lot 1) : un
-- `AFTER INSERT ... FOR EACH ROW` sur un `INSERT` à plusieurs `VALUES` ne se
-- déclenche qu'une fois TOUTES les lignes posées.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(18);

-- ---------------------------------------------------------
-- Le décor : UNE classe, DEUX matières.
--   S1 — un chapitre, deux missions ⭐ et ⭐⭐⭐⭐. Réussir la ⭐ seule donne
--        l'étoile 3 (le cran 4 est le premier non franchi), donc le sceau ⭐⭐⭐
--        mais PAS le ⭐⭐⭐⭐ : c'est ce qui sépare `first_seal` de `subject_elite`.
--   S2 — un chapitre, une mission ⭐. Tant qu'elle n'est pas faite, la classe
--        n'est pas couverte.
-- Aucun quiz : les chapitres ne sont pas gatés, la porte est ouverte d'office.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('bg-theme', 'Thème badges', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('c0000000-0000-4000-8000-0000000000f1'::uuid, 'bg-theme', 'bg-9', 'BG 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES
  ('bg-s1', 'BG Maths', 'Esprit', 'subject-math', 'Brain', 'bg-theme',
   'c0000000-0000-4000-8000-0000000000f1'::uuid, 'fr'),
  ('bg-s2', 'BG SVT', 'Esprit', 'subject-svt', 'Leaf', 'bg-theme',
   'c0000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

-- Une matière SANS chapitre publié, dans la même classe : elle ne doit jamais
-- empêcher « Classe couverte ». Sans cette borne, le badge serait inatteignable
-- pour toujours dès qu'une matière du programme attend son contenu.
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('bg-vide', 'BG Français', 'Esprit', 'subject-french', 'BookOpen', 'bg-theme',
        'c0000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('c0000000-0000-4000-8000-0000000000c1'::uuid, 'bg-s1', 'BG Ch1'),
  ('c0000000-0000-4000-8000-0000000000c2'::uuid, 'bg-s2', 'BG Ch2');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source) VALUES
  ('c0000000-0000-4000-8000-0000000000a1'::uuid, 'c0000000-0000-4000-8000-0000000000c1'::uuid,
   'bg-s1', 'S1 ⭐', 1, 'practice', 'admin'),
  ('c0000000-0000-4000-8000-0000000000a4'::uuid, 'c0000000-0000-4000-8000-0000000000c1'::uuid,
   'bg-s1', 'S1 ⭐⭐⭐⭐', 4, 'practice', 'admin'),
  ('c0000000-0000-4000-8000-0000000000b1'::uuid, 'c0000000-0000-4000-8000-0000000000c2'::uuid,
   'bg-s2', 'S2 ⭐', 1, 'practice', 'admin');

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES ('c0000000-0000-4000-8000-000000000001'::uuid, 'bg-user@test.local', 'x', now(),
        '{"display_name":"BG"}'::jsonb, now(), now(),
        'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'::uuid);

-- La CLASSE de l'élève : c'est elle que « Classe couverte » mesure.
UPDATE public.profiles
   SET role = 'student', current_grade_id = 'c0000000-0000-4000-8000-0000000000f1'::uuid
 WHERE id = 'c0000000-0000-4000-8000-000000000001'::uuid;

-- ---------------------------------------------------------
-- 1-2. Les trois badges EXISTENT et sont décernables (é31 R-13).
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::INT FROM public.badges
    WHERE code IN ('first_seal', 'subject_elite', 'parcours_covered')),
  3,
  'les trois badges de l''étude sont au catalogue — trois, et pas un de plus (D-7)'
);

SELECT is(
  (SELECT count(DISTINCT family)::INT FROM public.badges
    WHERE code IN ('first_seal', 'subject_elite', 'parcours_covered')),
  1,
  '…tous dans la famille « maitrise », celle de la compétence prouvée'
);

-- =========================================================
-- ACTE 1 — la mission ⭐ de S1. Étoile 3 (le cran ⭐⭐⭐⭐ n'est pas franchi),
--          donc le sceau ⭐⭐⭐ de S1 tombe : le PREMIER sceau.
-- =========================================================
INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('c0000000-0000-4000-8000-00000000d001'::uuid,
        'c0000000-0000-4000-8000-000000000001'::uuid, 'c0000000-0000-4000-8000-0000000000a1'::uuid,
        'bg-s1', 5, 5, 100, 120, 0, 'classic', now() - INTERVAL '3 days');

SELECT is(
  (SELECT MAX(sl.star)::INT FROM public.user_subject_seals sl
    WHERE sl.user_id = 'c0000000-0000-4000-8000-000000000001'::uuid AND sl.subject_id = 'bg-s1'),
  3,
  'la ⭐ seule scelle S1 au ⭐⭐⭐ — le cran ⭐⭐⭐⭐ reste à prendre'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb
            JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
             AND b.code = 'first_seal'),
  '⭐ « Premier sceau » est décerné'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.student_badges sb
                JOIN public.badges b ON b.id = sb.badge_id
               WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
                 AND b.code = 'subject_elite'),
  '…mais PAS « Matière d''élite » : il reste un défi à relever dans S1'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.student_badges sb
                JOIN public.badges b ON b.id = sb.badge_id
               WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
                 AND b.code = 'parcours_covered'),
  '…ni « Classe couverte » : S2 n''a pas encore son sceau'
);

SELECT is(
  (SELECT sb.awarded_reason FROM public.student_badges sb
     JOIN public.badges b ON b.id = sb.badge_id
    WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
      AND b.code = 'first_seal'),
  'stars:c0000000-0000-4000-8000-00000000d001',
  '⭐ la raison porte l''id de la tentative — c''est par là que l''écran de résultat les retrouve'
);

-- =========================================================
-- ACTE 2 — le défi ⭐⭐⭐⭐ de S1. Étoile 4, sceau ⭐⭐⭐⭐ : l'ÉLITE.
-- =========================================================
INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('c0000000-0000-4000-8000-00000000d002'::uuid,
        'c0000000-0000-4000-8000-000000000001'::uuid, 'c0000000-0000-4000-8000-0000000000a4'::uuid,
        'bg-s1', 5, 5, 100, 120, 0, 'classic', now() - INTERVAL '2 days');

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb
            JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
             AND b.code = 'subject_elite'),
  '⭐ « Matière d''élite » tombe avec le sceau ⭐⭐⭐⭐'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.student_badges sb
                JOIN public.badges b ON b.id = sb.badge_id
               WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
                 AND b.code = 'parcours_covered'),
  '…et « Classe couverte » attend toujours S2 — un sceau ⭐⭐⭐⭐ ne couvre pas la classe'
);

-- =========================================================
-- ACTE 3 — la mission ⭐ de S2. La classe est couverte.
-- =========================================================
INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('c0000000-0000-4000-8000-00000000d003'::uuid,
        'c0000000-0000-4000-8000-000000000001'::uuid, 'c0000000-0000-4000-8000-0000000000b1'::uuid,
        'bg-s2', 5, 5, 100, 120, 0, 'classic', now() - INTERVAL '1 day');

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb
            JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
             AND b.code = 'parcours_covered'),
  '⭐ « Classe couverte » tombe — et la matière SANS chapitre publié ne l''a pas bloqué'
);

SELECT is(
  (SELECT count(*)::INT FROM public.student_badges sb
     JOIN public.badges b ON b.id = sb.badge_id
    WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
      AND b.family = 'maitrise'),
  3,
  'les trois, et rien d''autre : aucun badge de plus n''a été inventé en chemin'
);

-- =========================================================
-- LES DEUX GARDES.
-- =========================================================
-- Une tentative de PLUS sur un chapitre déjà maîtrisé : rien ne bouge.
INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('c0000000-0000-4000-8000-00000000d004'::uuid,
        'c0000000-0000-4000-8000-000000000001'::uuid, 'c0000000-0000-4000-8000-0000000000a1'::uuid,
        'bg-s1', 5, 5, 100, 120, 0, 'classic', now());

SELECT is(
  (SELECT count(*)::INT FROM public.student_badges sb
    WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid),
  3,
  '⭐ rejouer une mission déjà comptée ne re-décerne RIEN — l''idempotence tient'
);

SELECT is(
  (SELECT count(*)::INT FROM public.student_badges sb
     JOIN public.badges b ON b.id = sb.badge_id
    WHERE sb.student_user_id = 'c0000000-0000-4000-8000-000000000001'::uuid
      AND sb.awarded_reason = 'stars:c0000000-0000-4000-8000-00000000d004'),
  0,
  '…et la dernière tentative ne revendique aucun badge : elle n''a rien fait tomber'
);

-- R-11 / D-10 : la reconnaissance suffit. Aucune valeur n'a été créée.
SELECT is(
  (SELECT (p.xp, p.yahia_coins) FROM public.profiles p
    WHERE p.id = 'c0000000-0000-4000-8000-000000000001'::uuid),
  (0, 0),
  '⭐ AUCUNE XP, AUCUNE PIÈCE : trois sceaux et trois badges n''ont créé aucune valeur (R-11)'
);

-- =========================================================
-- LE DELTA D'UNE SOUMISSION — ce que l'écran de résultat a le droit de célébrer.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"c0000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  jsonb_array_length(
    public.get_attempt_progress('c0000000-0000-4000-8000-00000000d002'::uuid) -> 'newBadges'),
  1,
  '⭐ la tentative du défi ⭐⭐⭐⭐ revendique SON badge, pas toute la collection'
);

SELECT is(
  (public.get_attempt_progress('c0000000-0000-4000-8000-00000000d002'::uuid)
     -> 'newBadges' -> 0 ->> 'code'),
  'subject_elite',
  '…et c''est bien celui que ce geste-là a fait tomber'
);

SELECT is(
  jsonb_array_length(
    public.get_attempt_progress('c0000000-0000-4000-8000-00000000d004'::uuid) -> 'newBadges'),
  0,
  'la tentative qui n''a rien fait tomber ne célèbre rien — l''écran doit se taire'
);

-- L'enveloppe que l'écran appelle vraiment : il connaît l'exercice, pas l'id de
-- la tentative que `submit_exercise_attempt` ne rend pas (D-4).
SELECT is(
  (public.get_last_attempt_progress('c0000000-0000-4000-8000-0000000000a1'::uuid) ->> 'starAfter')::INT,
  4,
  '⭐ « ma dernière tentative sur cet exercice » résout la bonne, sans toucher à la RPC de soumission'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
