-- =========================================================
-- S64 — LA FORGE : la clé ne descend pas, et rien n'est versé.
--
-- Deux invariants, tous deux nommés par l'étude 29 §5 comme les tests du lot 4 :
--
--   1. `serve_forged_quiz` NE REND JAMAIS LA CLÉ. C'est l'invariant d'AGENTS.md
--      appliqué au contenu forgé — « la clé de réponse n'est JAMAIS envoyée au
--      client » — et il ne peut pas être vérifié ailleurs : la fonction est le
--      seul chemin de lecture, et sa projection est sa spécification.
--
--   2. `grade_forged_quiz` NE VERSE RIEN (R-16, D-13). Aucun XP, aucune pièce,
--      aucun badge, aucune écriture dans `attempts` ni `question_attempts`. Ce
--      test existe parce qu'une récompense ajoutée « juste pour encourager » ne
--      casserait AUCUN test existant — elle rendrait simplement l'adaptativité
--      et le SM-2 pilotés par du contenu que personne n'a relu.
--
-- Plus les gardes qui les entourent : REVOKE total sur la table (comme le
-- coffre), quota de 3 par jour (R-18), expiration à 30 jours (R-17), et
-- l'étanchéité entre familles.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(23);

-- ---------------------------------------------------------
-- Fixtures : un porteur, son élève, une famille étrangère, un chapitre.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('d9000000-0000-4000-8000-000000000001', 'forge-parent@test.local', 'x', now(),
   '{"display_name":"Parent"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('d9000000-0000-4000-8000-000000000002', 'forge-child@test.local', 'x', now(),
   '{"display_name":"Enfant"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('d9000000-0000-4000-8000-000000000003', 'forge-stranger@test.local', 'x', now(),
   '{"display_name":"Étranger"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

-- ⚠️ Le catalogue porte des colonnes NOT NULL (`attribute`, `color_token`,
-- `icon`, `name_fr`…) : une fixture qui les omet fait échouer le FICHIER ENTIER
-- avant la première assertion — « planned 23, ran 0 ». C'est ce qui est arrivé
-- au premier jet, vu par `pgTAP suite` (pile Supabase réelle) et pas par un
-- Postgres nu. Les valeurs sont sans importance ; leur PRÉSENCE ne l'est pas.
INSERT INTO public.themes (id, name_fr, icon, color_token)
VALUES ('forge-theme', 'Forge (test)', 'hammer', 'subject-math')
ON CONFLICT DO NOTHING;
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, content_language)
VALUES ('forge-subject', 'Forge (test)', 'Esprit', 'subject-math', 'hammer', 'forge-theme', 'fr')
ON CONFLICT DO NOTHING;
INSERT INTO public.chapters (id, subject_id, title, lesson_content)
VALUES ('d9000000-0000-4000-8000-0000000000c1', 'forge-subject', 'Les fractions',
        'Une fraction représente une part d''un tout.')
ON CONFLICT DO NOTHING;
INSERT INTO public.exercises (id, chapter_id, subject_id, title)
VALUES ('d9000000-0000-4000-8000-0000000000e1', 'd9000000-0000-4000-8000-0000000000c1',
        'forge-subject', 'Entraînement')
ON CONFLICT DO NOTHING;
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation)
VALUES ('d9000000-0000-4000-8000-0000000000e1', 'Combien vaut un demi ?',
        '[{"id":"a","text":"0,5"},{"id":"b","text":"2"}]'::jsonb, 'a', 'Un demi vaut 0,5.')
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 1. La table est aussi fermée que le coffre — `payload` porte les clés.
-- ---------------------------------------------------------
SELECT has_table('public', 'ai_forged_quizzes', 'ai_forged_quizzes existe');

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name   = 'ai_forged_quizzes'
        AND grantee IN ('anon', 'authenticated') $$,
  'aucun privilège client sur ai_forged_quizzes — `payload` porte les clés de réponse'
);

SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.ai_forged_quizzes'::regclass),
  'RLS est activée — deuxième étage, comme sur le coffre'
);

-- ---------------------------------------------------------
-- 2. Le contexte de génération : déterministe, et sans clé de réponse.
-- ---------------------------------------------------------
SELECT is(
  (SELECT chapter_title FROM public.get_forge_context('d9000000-0000-4000-8000-0000000000c1')),
  'Les fractions',
  'le contexte porte le titre du chapitre'
);

SELECT is(
  (SELECT content_lang FROM public.get_forge_context('d9000000-0000-4000-8000-0000000000c1')),
  'fr',
  'é11 R-3 : la langue vient de la MATIÈRE, elle n''est pas un choix de l''élève'
);

SELECT is(
  (SELECT array_length(sample_prompts, 1)
     FROM public.get_forge_context('d9000000-0000-4000-8000-0000000000c1')),
  1,
  'les questions d''exemple remontent — référence de STYLE (§3.6)'
);

-- Le point qui compte : les exemples partent SANS leur clé. La fonction ne rend
-- que des énoncés, donc il n'y a rien à retirer — et c'est la garantie.
SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.columns
      WHERE table_schema = 'public'
        AND table_name = 'get_forge_context' $$,
  'get_forge_context n''expose aucune colonne de clé (elle n''en projette aucune)'
);

-- ---------------------------------------------------------
-- 3. L'écriture, puis la lecture SANS clé.
-- ---------------------------------------------------------
SELECT ok(
  public.create_forged_quiz(
    'd9000000-0000-4000-8000-000000000002'::uuid,
    'd9000000-0000-4000-8000-000000000001'::uuid,
    'chapter', 'd9000000-0000-4000-8000-0000000000c1'::uuid, NULL,
    'fr', 2, 5,
    '{"items":[
       {"id":"q1","prompt":"Combien font 2 + 3 ?",
        "options":[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"7"}],
        "correctOption":"b","explanation":"2 + 3 = 5.","difficulty":2},
       {"id":"q2","prompt":"Combien font 4 + 4 ?",
        "options":[{"id":"a","text":"7"},{"id":"b","text":"8"},{"id":"c","text":"9"},{"id":"d","text":"44"}],
        "correctOption":"b","explanation":"4 + 4 = 8.","difficulty":2}
     ]}'::jsonb,
    'claude-haiku-4-5', 3, true
  ) IS NOT NULL,
  'un quiz forgé s''écrit'
);

-- On mémorise l'identifiant dans un GUC `test.*` — la convention du README de
-- `supabase/tests/`. Une table temporaire ne marcherait pas : elle appartient au
-- rôle qui la crée, et la moitié des assertions tournent sous `authenticated`.
SELECT set_config(
  'test.forge_id',
  (SELECT id::text FROM public.ai_forged_quizzes
    WHERE student_user_id = 'd9000000-0000-4000-8000-000000000002'),
  true);

SET LOCAL request.jwt.claims = '{"sub":"d9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- ⭐ L'ASSERTION CENTRALE DU LOT 4.
SELECT is_empty(
  $$ SELECT 1
       FROM public.serve_forged_quiz(current_setting('test.forge_id')::uuid) s,
            jsonb_array_elements(s.items) AS item
      WHERE item ? 'correctOption' OR item ? 'explanation' $$,
  'R-16/AGENTS.md : serve_forged_quiz ne rend NI la clé NI l''explication'
);

SELECT is(
  (SELECT jsonb_array_length(items) FROM public.serve_forged_quiz(current_setting('test.forge_id')::uuid)),
  2,
  'les deux questions sont bien servies — c''est la CLÉ qui manque, pas le contenu'
);

SELECT is(
  (SELECT item->>'prompt'
     FROM public.serve_forged_quiz(current_setting('test.forge_id')::uuid) s,
          jsonb_array_elements(s.items) WITH ORDINALITY AS t(item, n)
    WHERE n = 1),
  'Combien font 2 + 3 ?',
  'l''ordre des questions est préservé'
);

SELECT throws_ok(
  $$ SELECT payload FROM public.ai_forged_quizzes $$,
  '42501', NULL,
  'un client authentifié ne peut pas lire le payload directement'
);

-- ---------------------------------------------------------
-- 4. La correction — juste, et SANS AUCUNE récompense (R-16).
-- ---------------------------------------------------------
SELECT is(
  (SELECT correct FROM public.grade_forged_quiz(current_setting('test.forge_id')::uuid,
                                                '{"q1":"b","q2":"a"}'::jsonb)),
  1,
  'la correction compte juste : une bonne sur deux'
);

SELECT is(
  (SELECT total FROM public.grade_forged_quiz(current_setting('test.forge_id')::uuid,
                                              '{"q1":"b"}'::jsonb)),
  2,
  'une question sans réponse compte dans le total, et compte faux'
);

SELECT is(
  (SELECT (review->0->>'explanation')
     FROM public.grade_forged_quiz(current_setting('test.forge_id')::uuid, '{"q1":"b"}'::jsonb)),
  '2 + 3 = 5.',
  'l''explication arrive APRÈS la correction — pas avant (motif du corrigé)'
);

RESET ROLE;

-- ⭐ LA SECONDE ASSERTION CENTRALE : rien n'a été versé.
SELECT is(
  (SELECT count(*)::int FROM public.attempts
    WHERE user_id = 'd9000000-0000-4000-8000-000000000002'),
  0,
  'R-16 : aucune tentative écrite — un quiz forgé ne compte pas dans la progression'
);

-- `yahia_coins`, et pas `coins` : le nom réel de la colonne, appris du pgTAP de
-- CI. Une assertion sur une colonne inexistante avorte le fichier au lieu de
-- vérifier quoi que ce soit — elle aurait été verte par erreur si elle avait
-- pointé une colonne qui existe sans porter les pièces.
SELECT is(
  (SELECT xp + yahia_coins FROM public.profiles
    WHERE id = 'd9000000-0000-4000-8000-000000000002'),
  0,
  'R-16 : ni XP ni pièce — jouer un quiz forgé ne rapporte rien'
);

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts
    WHERE user_id = 'd9000000-0000-4000-8000-000000000002'),
  0,
  'D-13 : la télémétrie d''apprentissage reste PURE — é04 ne voit pas le contenu forgé'
);

-- ---------------------------------------------------------
-- 5. R-17 : le quiz ne quitte pas la famille.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"d9000000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.serve_forged_quiz(current_setting('test.forge_id')::uuid) $$,
  'AI_FORGE_NOT_FOUND',
  'R-17 : une famille étrangère ne lit pas le quiz — et ne sait même pas qu''il existe'
);

RESET ROLE;

-- Le PORTEUR, lui, peut relire ce qu'il a payé.
SET LOCAL request.jwt.claims = '{"sub":"d9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT lives_ok(
  $$ SELECT * FROM public.serve_forged_quiz(current_setting('test.forge_id')::uuid) $$,
  'le porteur de la clé relit le quiz qu''il a payé'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 6. R-17 : l'expiration à 30 jours est effective, pas décorative.
-- ---------------------------------------------------------
UPDATE public.ai_forged_quizzes SET expires_at = now() - INTERVAL '1 day'
 WHERE id = current_setting('test.forge_id')::uuid;

SET LOCAL request.jwt.claims = '{"sub":"d9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.serve_forged_quiz(current_setting('test.forge_id')::uuid) $$,
  'AI_FORGE_EXPIRED',
  'R-17 : un quiz périmé ne se joue plus, même avant que la purge passe'
);

RESET ROLE;
SELECT lives_ok(
  $$ SELECT public.purge_ai_forged_quizzes() $$,
  'la purge tourne et emporte les quiz expirés'
);

SELECT is(
  (SELECT count(*)::int FROM public.ai_forged_quizzes WHERE id = current_setting('test.forge_id')::uuid),
  0,
  'R-17 : purgé à 30 jours — le contenu forgé ne s''accumule pas'
);

SELECT * FROM finish();
ROLLBACK;
