-- =========================================================
-- Étude 40, lot 2 — LA PREMIÈRE QUÊTE (R-7, R-8, R-10).
-- ---------------------------------------------------------
-- Le relevé du 2026-11-12 : 36 élèves sur 60 n'avaient jamais joué après
-- l'inscription, et les six audiences de l'étude 31 exigent toutes une activité
-- passée. Ce fichier garde la septième : QUI y entre, et à quel jour EXACT.
--
--   1. ⭐ Inscrit la VEILLE ou il y a TROIS jours, jamais actif ⇒ candidat.
--   2. ⭐ Deux soirs, puis plus jamais : ni J+2, ni J+4, ni le jour même.
--   3. ⭐ Le premier jour d'activité l'en sort ; un parent n'y entre jamais.
--   4. La langue voyage avec le candidat ; aucun nombre n'est interpolé.
--
-- Le jour d'inscription se lit à l'heure de TUNIS : les fixtures posent
-- `created_at` à midi, heure de Tunis, pour qu'aucun fuseau ne change la date.
-- Espace de noms des fixtures : préfixe `c40…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(10);

INSERT INTO auth.users (id, email)
SELECT ('c4000000-0000-4000-8000-00000000000' || g)::uuid, 'c40-u' || g || '@test.local'
FROM generate_series(1, 7) AS g;

CREATE TEMP TABLE c40_today AS SELECT DATE '2026-11-20' AS d;

-- Inscrit il y a N jours, à midi heure de Tunis.
CREATE TEMP TABLE c40_signup (id UUID, days_ago INT, active BOOLEAN, role TEXT, locale TEXT);
INSERT INTO c40_signup VALUES
  ('c4000000-0000-4000-8000-000000000001', 1, false, 'student', 'ar'),  -- J+1 → candidat
  ('c4000000-0000-4000-8000-000000000002', 3, false, 'student', 'fr'),  -- J+3 → candidat
  ('c4000000-0000-4000-8000-000000000003', 2, false, 'student', 'fr'),  -- J+2 → rien
  ('c4000000-0000-4000-8000-000000000004', 4, false, 'student', 'fr'),  -- J+4 → rien
  ('c4000000-0000-4000-8000-000000000005', 0, false, 'student', 'fr'),  -- le jour même → rien
  ('c4000000-0000-4000-8000-000000000006', 1, true,  'student', 'fr'),  -- a joué → rien
  ('c4000000-0000-4000-8000-000000000007', 1, false, 'parent',  'fr');  -- parent → rien

UPDATE public.profiles p
   SET created_at = (((SELECT d FROM c40_today) - s.days_ago)::timestamp + TIME '12:00')
                    AT TIME ZONE 'Africa/Tunis',
       last_active_date = CASE WHEN s.active THEN (SELECT d FROM c40_today) - s.days_ago END,
       current_streak = CASE WHEN s.active THEN 1 ELSE 0 END,
       role = s.role,
       locale = s.locale
  FROM c40_signup s
 WHERE p.id = s.id;

CREATE TEMP TABLE c40_out AS
SELECT * FROM public.push_daily_audiences((SELECT d FROM c40_today)) WHERE tag = 'first-quest';

SELECT ok(
  EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000001'),
  '⭐ inscrit HIER, jamais actif : candidat à la première quête'
);
SELECT ok(
  EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000002'),
  '⭐ inscrit il y a TROIS jours, jamais actif : second et dernier soir'
);
SELECT ok(
  NOT EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000003'),
  '⭐ J+2 : rien — deux soirs exacts, pas un de plus'
);
SELECT ok(
  NOT EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000004'),
  '⭐ J+4 : plus jamais'
);
SELECT ok(
  NOT EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000005'),
  'le jour même de l''inscription : rien (il vient de partir)'
);
SELECT ok(
  NOT EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000006'),
  '⭐ un premier jour d''activité l''en sort pour toujours'
);
SELECT ok(
  NOT EXISTS (SELECT 1 FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000007'),
  'un parent n''entre jamais dans une audience d''élève'
);
SELECT is(
  (SELECT locale FROM c40_out WHERE user_id = 'c4000000-0000-4000-8000-000000000001'),
  'ar',
  'la langue du profil voyage avec le candidat (é31 R-17)'
);
SELECT ok(
  (SELECT bool_and(arg IS NULL AND detail IS NULL) FROM c40_out),
  'aucun nombre ni détail : le texte ne dit rien de ce qui n''a pas été fait'
);
SELECT is(
  (SELECT count(*)::int FROM c40_out),
  2,
  'exactement deux candidats parmi les sept fixtures'
);

SELECT * FROM finish();
ROLLBACK;
