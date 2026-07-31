-- =========================================================
-- Étude 04 — amendement A1.2, lot A1.2a : la correction nomme l'erreur.
-- Contrat : FableEtudes/04-moteur-adaptatif/ETUDE.md §9 (dépôt privé).
-- ---------------------------------------------------------
-- `get_attempt_review` rend deux colonnes de plus — `misconception_tag` et
-- `chapter_id` — sans toucher une seule de ses portes. Ce fichier prouve les
-- cinq choses qui peuvent la rendre fausse :
--
--   1. le tag rendu est bien celui de l'option CHOISIE, pas le premier venu ;
--   2. une BONNE réponse ne rend aucun tag (R-A1.2-2) ;
--   3. la map `distractor_tags` reste illisible — et surtout INRECONSTITUABLE
--      depuis le résultat : c'est RISK-A1.2-A, le seul risque de cette phase qui
--      justifie un refus de merge. L'option correcte étant la SEULE sans tag
--      (D-1 de la phase A0), rendre la map désignerait la bonne réponse par
--      élimination. Les assertions 15-17 jouent cette attaque, pas le cas nominal ;
--   4. une question NON taguée rend NULL et sa ligne reste rendue (R-A1.2-3 :
--      le comportement d'aujourd'hui est le plancher, jamais une régression) ;
--   5. les portes existantes tiennent — quiz muet, non-propriétaire refusé,
--      session non soumise refusée.
--
-- Espace de noms des fixtures : préfixe `04a12a00…`, inutilisé ailleurs.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- ---------------------------------------------------------
-- Fixtures. Sujet SANS grade : la porte quiz de `start_exercise_session` ne
-- s'applique pas, ce qui isole ce que l'on teste ici. Les sessions sont insérées
-- directement (on teste la correction, pas la création de session).
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('a12a-subj', 'Correction Riche', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('04a12a00-0001-0000-0000-000000000001', 'a12a-subj', 'Fractions');

-- E1 : entraînement ordinaire, la surface enrichie.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, source, mode)
VALUES ('04a12a00-0002-0000-0000-000000000001',
        '04a12a00-0001-0000-0000-000000000001', 'a12a-subj',
        'Additionner des fractions', 100, 20, 'admin', 'practice');

-- Q1 — DEUX distracteurs tagués. C'est la question qui rend l'attaque par
-- élimination possible si le serveur rendait la map : l'option `a` serait la
-- seule sans entrée, donc la bonne réponse.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, distractor_tags, explanation, display_order)
VALUES ('04a12a00-0003-0000-0000-000000000001',
        '04a12a00-0002-0000-0000-000000000001',
        'Combien font 1/2 + 1/3 ?',
        '[{"id":"a","text":"5/6"},{"id":"b","text":"2/5"},{"id":"c","text":"1/5"}]'::jsonb,
        'a',
        '{"b":"math.frac.denominateurs-additionnes","c":"math.frac.tout-additionne"}'::jsonb,
        'On met au même dénominateur.', 1);

-- Q2 — question NON taguée : l'immense majorité du corpus tant que é07 lot 3
-- n'a pas tourné sur toutes les matières. Elle doit rendre NULL, pas disparaître.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('04a12a00-0003-0000-0000-000000000002',
        '04a12a00-0002-0000-0000-000000000001',
        'Combien font 1/4 + 1/4 ?',
        '[{"id":"a","text":"1/2"},{"id":"b","text":"2/8"},{"id":"c","text":"1/8"}]'::jsonb,
        'a', 'Même dénominateur : on ajoute les numérateurs.', 2);

-- E2 : QUIZ de compréhension — la correction y reste muette (R-A1.2-5).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('04a12a00-0002-0000-0000-000000000002',
        '04a12a00-0001-0000-0000-000000000001', 'a12a-subj', 'Quiz fractions', 'admin', 'quiz');
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, distractor_tags, display_order)
VALUES ('04a12a00-0003-0000-0000-000000000003',
        '04a12a00-0002-0000-0000-000000000002',
        'Une fraction, c''est ?',
        '[{"id":"a","text":"Un partage"},{"id":"b","text":"Un entier"}]'::jsonb,
        'a', '{"b":"math.frac.confusion-entier"}'::jsonb, 1);

INSERT INTO auth.users (id, email) VALUES
  ('04a12a00-0004-0000-0000-000000000001', 'eleve-a12a@test.local'),
  ('04a12a00-0004-0000-0000-000000000002', 'intrus-a12a@test.local');

-- S1 : la session soumise de l'élève. S2 : son quiz soumis. S3 : la session d'un
-- AUTRE élève. S4 : une session ouverte, jamais soumise.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, variant, completed_at) VALUES
  ('04a12a00-0005-0000-0000-000000000001', '04a12a00-0004-0000-0000-000000000001',
   '04a12a00-0002-0000-0000-000000000001', 'classic', now()),
  ('04a12a00-0005-0000-0000-000000000002', '04a12a00-0004-0000-0000-000000000001',
   '04a12a00-0002-0000-0000-000000000002', 'classic', now()),
  ('04a12a00-0005-0000-0000-000000000003', '04a12a00-0004-0000-0000-000000000002',
   '04a12a00-0002-0000-0000-000000000001', 'classic', now()),
  ('04a12a00-0005-0000-0000-000000000004', '04a12a00-0004-0000-0000-000000000001',
   '04a12a00-0002-0000-0000-000000000001', 'classic', NULL);

-- =========================================================
-- 1–2. La colonne source reste server-only — inchangé depuis A0 (R-1/D-1), et
-- c'est la prémisse de tout le reste : le tag ne peut venir que du serveur.
-- =========================================================
SELECT is(
  has_column_privilege('anon', 'public.questions', 'distractor_tags', 'SELECT'),
  false, 'RISK-A1.2-A: anon ne peut toujours pas lire questions.distractor_tags');

SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'distractor_tags', 'SELECT'),
  false, 'RISK-A1.2-A: authenticated ne peut toujours pas lire questions.distractor_tags');

-- =========================================================
-- 3–5. La SIGNATURE : les deux colonnes promises, et pas la map (D-A1.2-2).
-- =========================================================
SELECT matches(
  pg_get_function_result('public.get_attempt_review(uuid,jsonb)'::regprocedure),
  'misconception_tag text',
  'A1.2a: le résultat porte misconception_tag');

SELECT matches(
  pg_get_function_result('public.get_attempt_review(uuid,jsonb)'::regprocedure),
  'chapter_id uuid',
  'A1.2a: le résultat porte chapter_id (D-A1.2-4, lien « revoir le cours »)');

SELECT unlike(
  pg_get_function_result('public.get_attempt_review(uuid,jsonb)'::regprocedure),
  '%distractor_tags%',
  'D-A1.2-2: la MAP distractor_tags n''est pas dans la signature de sortie');

-- =========================================================
-- 6–7. Les droits d'exécution survivent au DROP + CREATE (D-A1.2-6).
-- =========================================================
SELECT is(
  has_function_privilege('anon', 'public.get_attempt_review(uuid,jsonb)', 'EXECUTE'),
  false, 'get_attempt_review reste inexécutable par anon');

SELECT is(
  has_function_privilege('authenticated', 'public.get_attempt_review(uuid,jsonb)', 'EXECUTE'),
  true, 'get_attempt_review reste exécutable par authenticated');

-- ---------------------------------------------------------
-- Désormais en élève réel, JWT posé.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"04a12a00-0004-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 8–9. Le tag rendu est celui de l'option CHOISIE — prouvé en changeant le
-- choix sur la MÊME question : si le serveur rendait « le premier tag », les
-- deux assertions ne pourraient pas être vraies ensemble.
-- =========================================================
SELECT is(
  (SELECT r.misconception_tag FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"b"}]'::jsonb) r
    WHERE r.question_id = '04a12a00-0003-0000-0000-000000000001'),
  'math.frac.denominateurs-additionnes',
  'US-4: choisir « b » nomme l''erreur de « b »');

SELECT is(
  (SELECT r.misconception_tag FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"c"}]'::jsonb) r
    WHERE r.question_id = '04a12a00-0003-0000-0000-000000000001'),
  'math.frac.tout-additionne',
  'US-4: choisir « c » nomme l''erreur de « c » — c''est bien le tag du CHOIX');

-- =========================================================
-- 10–11. Une BONNE réponse ne rend aucun tag (R-A1.2-2), et le verdict lui-même
-- ne bouge pas (non-régression de la couture de scoring).
-- =========================================================
SELECT is(
  (SELECT r.misconception_tag FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"a"}]'::jsonb) r
    WHERE r.question_id = '04a12a00-0003-0000-0000-000000000001'),
  NULL::text,
  'R-A1.2-2: une bonne réponse ne rend AUCUN tag — une réussite n''est pas une leçon');

SELECT is(
  (SELECT r.is_correct FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"a"}]'::jsonb) r
    WHERE r.question_id = '04a12a00-0003-0000-0000-000000000001'),
  true,
  'non-régression: le verdict is_correct est inchangé');

-- =========================================================
-- 12–13. R-A1.2-3 — question NON taguée : NULL, et la ligne RESTE rendue. C'est
-- l'état du corpus pour tout ce que é07 lot 3 n'a pas encore tagué.
-- =========================================================
SELECT is(
  (SELECT r.misconception_tag FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000002","choice":"b"}]'::jsonb) r
    WHERE r.question_id = '04a12a00-0003-0000-0000-000000000002'),
  NULL::text,
  'R-A1.2-3: une question non taguée rend NULL, sans lever');

SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000002","choice":"b"}]'::jsonb)),
  2,
  'R-A1.2-3: la ligne non taguée reste rendue — le plancher, pas une régression');

-- =========================================================
-- 14. Le chapitre voyage avec la correction (D-A1.2-4).
-- =========================================================
SELECT is(
  (SELECT DISTINCT r.chapter_id FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001') r),
  '04a12a00-0001-0000-0000-000000000001'::uuid,
  'D-A1.2-4: chapter_id est rendu, de quoi bâtir « revoir le cours »');

-- =========================================================
-- 15–17. RISK-A1.2-A — L'ATTAQUE PAR ÉLIMINATION. Un client malveillant rejoue
-- la correction pour reconstituer la map : si elle fuyait, l'option sans tag
-- serait la bonne réponse. Trois angles :
--   15. sans réponses, aucun tag ne sort du tout ;
--   16. avec UNE mauvaise réponse, il sort EXACTEMENT un tag — celui-là ;
--   17. le tag du distracteur NON choisi n'apparaît nulle part.
-- =========================================================
SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review('04a12a00-0005-0000-0000-000000000001') r
    WHERE r.misconception_tag IS NOT NULL),
  0,
  'RISK-A1.2-A: sans réponses fournies, aucun tag n''est rendu');

SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"b"},
       {"questionId":"04a12a00-0003-0000-0000-000000000002","choice":"b"}]'::jsonb) r
    WHERE r.misconception_tag IS NOT NULL),
  1,
  'RISK-A1.2-A: une seule erreur commise -> un seul tag rendu, jamais la map');

SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000001',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"b"}]'::jsonb) r
    WHERE r.misconception_tag = 'math.frac.tout-additionne'),
  0,
  'RISK-A1.2-A: le tag du distracteur NON choisi ne fuit pas — pas d''élimination');

-- =========================================================
-- 18–19. Les portes existantes, inchangées : un quiz reste muet (R-A1.2-5) et
-- une session non soumise ne se corrige pas.
-- =========================================================
SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000002',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000003","choice":"b"}]'::jsonb)),
  0,
  'R-A1.2-5: un quiz de compréhension ne rend toujours RIEN, tag compris');

SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000004',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"b"}]'::jsonb)),
  0,
  'porte inchangée: une session non soumise ne rend aucune correction');

-- =========================================================
-- 20. La session d'un AUTRE élève reste inaccessible — la porte owner-only tient,
-- et le tag ne lui ouvre donc aucun chemin de contournement. (Toujours sous le JWT
-- de l'élève A : c'est lui qui tente de lire la session de l'élève B.)
-- =========================================================
SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review(
     '04a12a00-0005-0000-0000-000000000003',
     '[{"questionId":"04a12a00-0003-0000-0000-000000000001","choice":"b"}]'::jsonb)),
  0,
  'porte inchangée: la session d''un autre élève ne rend aucune correction');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
