-- =========================================================
-- ÉTUDE 34, LOT 3 — LA CONSOLE LIT LE GRAND LIVRE.
-- ---------------------------------------------------------
-- Ce fichier tient la promesse que le lot 3 fait à la mesure, et elle a deux
-- moitiés qu'il ne faut surtout pas confondre :
--
--   1. ⭐ **KPI-E change de SOURCE, PAS de définition.** « Chapitre maîtrisé »
--      reste « toutes les missions de catalogue + le quiz » — l'arbitrage Q-2 a
--      maintenu la barre à l'étoile 4. Le décor construit donc un cas où les deux
--      définitions donnent le MÊME chiffre, puis ajoute une mission : l'ancienne
--      aurait fait tomber le compte, la nouvelle ne bouge pas. C'est la rupture
--      de série que l'étude évite, prouvée plutôt que promise.
--   2. ⭐ **Le ratio nu se lit de travers**, et les trois mesures qui l'entourent
--      existent pour ça : la DISTRIBUTION (un parc entier à ★★★☆ produit
--      « 0,0 chapitre par actif »), sa MÉDIANE (le chiffre de contrôle de Q-2),
--      les SCEAUX par actif, et les ÉTOILES PRÉSERVÉES — le nombre de couples
--      (élève, chapitre) que le grand livre a protégés d'une régression.
--
-- ⚠️ Décor daté dans le PASSÉ (leçon du lot 1) : `now()` est l'horloge de la
-- TRANSACTION, donc un contenu « ajouté plus tard » dans le même test porterait
-- la même date que les tentatives posées juste avant.
-- ⚠️ Une instruction `INSERT` par tentative : un `AFTER INSERT ... FOR EACH ROW`
-- sur un `INSERT` à plusieurs `VALUES` ne se déclenche qu'une fois TOUTES les
-- lignes posées, et la première tentative « verrait » alors les suivantes.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(17);

-- ---------------------------------------------------------
-- Le catalogue : une matière, un chapitre PUBLIÉ, deux missions ⭐ et ⭐⭐.
-- Pas de quiz → le chapitre n'est pas gaté, la porte est ouverte d'office.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('st3-theme', 'Thème étoiles admin', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('d0000000-0000-4000-8000-0000000000f1'::uuid, 'st3-theme', 'st3-9', 'ST3 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('st3-subj', 'ST3 Maths', 'Esprit', 'subject-math', 'Brain', 'st3-theme',
        'd0000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, created_at)
VALUES ('d0000000-0000-4000-8000-0000000000c1'::uuid, 'st3-subj', 'ST3 Chapitre',
        now() - INTERVAL '30 days');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source, created_at)
VALUES
  ('d0000000-0000-4000-8000-0000000000e1'::uuid, 'd0000000-0000-4000-8000-0000000000c1'::uuid,
   'st3-subj', 'ST3 ⭐', 1, 'practice', 'admin', now() - INTERVAL '30 days'),
  ('d0000000-0000-4000-8000-0000000000e2'::uuid, 'd0000000-0000-4000-8000-0000000000c1'::uuid,
   'st3-subj', 'ST3 ⭐⭐', 2, 'practice', 'admin', now() - INTERVAL '30 days');

-- ---------------------------------------------------------
-- Les comptes : un admin qui lit la console, trois élèves qui la peuplent.
--   A — réussit la ⭐ seule           → étoile 1
--   B — réussit les deux             → étoile 4 (maîtrisé), donc le sceau
--   C — touche le chapitre, rate tout → étoile 0
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
SELECT
  ('d0000000-0000-4000-8000-00000000000' || n)::uuid,
  'st3-user-' || n || '@test.local', 'x', now(),
  '{"display_name":"ST3"}'::jsonb, now() - INTERVAL '60 days', now(),
  'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'::uuid
FROM generate_series(1, 4) AS n;

UPDATE public.profiles SET role = 'student'
 WHERE id IN ('d0000000-0000-4000-8000-000000000001'::uuid,
              'd0000000-0000-4000-8000-000000000002'::uuid,
              'd0000000-0000-4000-8000-000000000003'::uuid);
UPDATE public.profiles SET role = 'admin'
 WHERE id = 'd0000000-0000-4000-8000-000000000004'::uuid;

-- Une instruction par tentative — voir l'avertissement de l'en-tête.
-- A : la ⭐ réussie proprement (5 questions, 120 s → jamais précipitée).
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('d0000000-0000-4000-8000-000000000001'::uuid, 'd0000000-0000-4000-8000-0000000000e1'::uuid,
        'st3-subj', 5, 5, 100, 120, 20, 'classic', now() - INTERVAL '10 days');

-- B : les deux missions, dans l'ordre.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('d0000000-0000-4000-8000-000000000002'::uuid, 'd0000000-0000-4000-8000-0000000000e1'::uuid,
        'st3-subj', 5, 5, 100, 120, 20, 'classic', now() - INTERVAL '9 days');
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('d0000000-0000-4000-8000-000000000002'::uuid, 'd0000000-0000-4000-8000-0000000000e2'::uuid,
        'st3-subj', 5, 5, 100, 120, 20, 'classic', now() - INTERVAL '8 days');

-- C : touché, raté — « tenté » n'est pas « compté ».
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
VALUES ('d0000000-0000-4000-8000-000000000003'::uuid, 'd0000000-0000-4000-8000-0000000000e1'::uuid,
        'st3-subj', 1, 5, 20, 120, 0, 'classic', now() - INTERVAL '7 days');

SET LOCAL request.jwt.claims = '{"sub":"d0000000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 1-2. KPI-E : même définition, et le décor le prouve des deux côtés.
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'learning'->>'chapters_completed')::int,
  1,
  'un seul élève a TOUT réussi dans le chapitre — « maîtrisé » reste l''étoile 4 (Q-2)'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->>'chapters_per_active')::numeric,
  ROUND(1::numeric / 3, 2),
  'le ratio se publie sur les trois actifs — définition inchangée, source changée'
);

-- =========================================================
-- 3-5. LA DISTRIBUTION — ce sans quoi « 0,33 » se lirait « ils ne font rien ».
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'learning'->'stars_distribution'->>'s0')::int,
  1,
  'C a touché le chapitre sans rien réussir : il pèse au cran 0, il n''est pas invisible'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->'stars_distribution'->>'s1')::int,
  1,
  '⭐ A tient une étoile — le travail à mi-chemin se VOIT, là où le ratio l''effaçait'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->'stars_distribution'->>'s4')::int,
  1,
  'B en tient quatre — la distribution somme aux chapitres joués, pas aux chapitres du parc'
);

-- =========================================================
-- 6. LA MÉDIANE — le chiffre de contrôle de Q-2 (« la barre est-elle atteignable ? »).
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'learning'->>'stars_median')::numeric,
  1.0::numeric,
  'médiane de [0, 1, 4] = 1 — continue, pour qu''une tendance se voie entre deux crans'
);

-- =========================================================
-- 7-8. LES SCEAUX — la reconnaissance de MATIÈRE, par actif.
-- =========================================================
-- ⚠️ CINQ, pas quatre — et le décor le dit mieux qu'un commentaire. R-9 scelle la
-- matière dès que TOUS ses chapitres publiés tiennent l'étoile r ; ici il n'y en a
-- qu'un, donc A (étoile 1) emporte le sceau ⭐ en même temps que B emporte les
-- quatre. Une matière à un seul chapitre se scelle vite, c'est la règle, pas un
-- défaut : le sceau mesure la COUVERTURE, et couvrir un chapitre sur un est fait.
SELECT is(
  (public.admin_engagement_overview()->'learning'->>'seals_total')::int,
  5,
  'B tient les quatre sceaux, A le premier — un chapitre unique scelle dès l''étoile atteinte (R-9)'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->>'seals_per_active')::numeric,
  ROUND(5::numeric / 3, 2),
  'les sceaux se rapportent aux actifs, comme les chapitres'
);

-- =========================================================
-- 9. ÉTOILES PRÉSERVÉES — nulles tant qu''aucune campagne n'est passée.
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'learning'->>'stars_preserved')::int,
  0,
  'sans ajout de contenu, grand livre et vivant coïncident : rien n''a eu besoin d''être protégé'
);

RESET ROLE;

-- ---------------------------------------------------------
-- LA CAMPAGNE. Une mission ⭐⭐⭐ arrive dans le chapitre que B avait maîtrisé.
-- C'est le geste qui, avant l'étude, retirait un chapitre au compte de tous ceux
-- qui l'avaient fini — et personne ne pouvait le voir dans la série.
-- ---------------------------------------------------------
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source, created_at)
VALUES ('d0000000-0000-4000-8000-0000000000e3'::uuid, 'd0000000-0000-4000-8000-0000000000c1'::uuid,
        'st3-subj', 'ST3 ⭐⭐⭐', 3, 'practice', 'admin', now());

SET LOCAL request.jwt.claims = '{"sub":"d0000000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 10-12. ⭐ L'INVARIANT DU LOT, côté console.
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'learning'->>'chapters_completed')::int,
  1,
  '⭐ la campagne passe et le compte NE BOUGE PAS — c''est toute la raison d''être du lot'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->>'stars_preserved')::int,
  1,
  '⭐ et le compteur NOMME la régression évitée : un couple (élève, chapitre) protégé'
);

RESET ROLE;

-- Le calcul VIVANT, lu HORS rôle client : `chapter_star_live` est interne
-- (`REVOKE` de anon/authenticated), et c'est volontaire — un client qui pourrait
-- l'appeler pourrait sonder la progression d'autrui en passant un `p_user`.
SELECT is(
  public.chapter_star_live('d0000000-0000-4000-8000-000000000002'::uuid,
                           'd0000000-0000-4000-8000-0000000000c1'::uuid)::int,
  2,
  '…et le vivant est bien retombé à 2 : c''est exactement ce que l''ancienne règle publiait'
);

-- =========================================================
-- 13-15. LE WRAPPER ÉLÈVE — la porte que la carte et le QG franchissent.
--
-- `student_subject_stars` prend un `p_user` : le donner tel quel aux clients
-- laisserait n'importe quel compte lire la progression d'un autre. L'enveloppe
-- self-scopée est la seule surface ouverte, et ces trois assertions le tiennent.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.student_subject_stars(uuid, text[])', 'EXECUTE'),
  'l''agrégat à p_user reste FERMÉ aux clients — sinon il lit la progression d''autrui'
);

SELECT ok(
  has_function_privilege('authenticated',
    'public.get_user_subject_stars(text[])', 'EXECUTE'),
  '…et son enveloppe self-scopée est la seule porte ouverte'
);

SET LOCAL request.jwt.claims = '{"sub":"d0000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT seal_star::INT FROM public.get_user_subject_stars(ARRAY['st3-subj'])),
  4,
  '⭐ B lit SES sceaux sans passer d''identité — et la campagne ne les a pas retirés'
);

RESET ROLE;

-- =========================================================
-- 16-17. L'ENVELOPPE DU SUIVI PARENTAL porte la distribution.
--
-- La colonne « Programme » disait « 3/20 » et rien d'autre ; le 2026-09-04 ce
-- ratio nu s'est lu « il a fait 3 chapitres sur 20 » alors que les autres étaient
-- entamés. Les bornes cumulées voyagent donc à côté du compte — sans elles, la
-- barre empilée du parent ne serait qu'une décoration calculée côté client.
-- =========================================================
SELECT is(
  (SELECT (e ->> 'star4')::INT
     FROM jsonb_array_elements(
            public._daily_report_with_scopes(
              'd0000000-0000-4000-8000-000000000002'::uuid,
              (now() - INTERVAL '30 days')::date, now()::date, 'all') -> 'subjectStars') e
    WHERE e ->> 'subjectId' = 'st3-subj'),
  1,
  '⭐ le parent reçoit la distribution, pas seulement la fraction — B a un chapitre maîtrisé'
);

SELECT is(
  (SELECT (e ->> 'star1')::INT
     FROM jsonb_array_elements(
            public._daily_report_with_scopes(
              'd0000000-0000-4000-8000-000000000001'::uuid,
              (now() - INTERVAL '30 days')::date, now()::date, 'all') -> 'subjectStars') e
    WHERE e ->> 'subjectId' = 'st3-subj'),
  1,
  '…et A, à « 0 maîtrisé », n''est plus invisible : son chapitre pèse au cran 1'
);

SELECT * FROM finish();
ROLLBACK;
