-- =========================================================
-- Étude 29, R-15 garde-fou 3 — LA SORTIE DU POT COMMUN.
-- ---------------------------------------------------------
-- « Éviction sur signal : deux 👎 sur une entrée partagée la retirent du pot et
--   forcent une régénération. »
--
-- Ce fichier garde la moitié SQL de la règle. Sa moitié Node — le LIEN entre un
-- message servi et l'entrée de cache qui l'a produit, sans lequel un 👎 ne
-- désigne rien — est dans `src/features/tutor/__tests__/tutor-server.test.ts`.
--
-- ⚠️ LES DEUX ASSERTIONS QUI COMPTENT LE PLUS sont dans les sections 2 et 3 :
--
--   * section 2 — DEUX VOIX, PAS DEUX CLICS. Le même élève peut se faire
--     resservir la même entrée (é11 R-7 : rouvrir le panneau re-sert le registre
--     déjà servi) et cliquer 👎 deux fois. Si ce fichier laissait passer cette
--     paire-là, un seul compte pourrait vider le pot commun de tout le parc ;
--   * section 3 — L'ÉVINCÉE NE SE SERT PLUS À PERSONNE, pas même à la famille
--     qui l'a payée. C'est ce que veut dire « forcent une régénération ». Une
--     éviction qui se contenterait de basculer `shared` continuerait de servir
--     la mauvaise explication à son propriétaire — la seule à qui on doit,
--     justement, une régénération.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(23);

-- ---------------------------------------------------------
-- Décor : une question jouée par DEUX élèves — c'est le minimum pour qu'un
-- seuil « deux voix distinctes » veuille dire quelque chose —, plus un admin
-- pour la console. Trois entrées de cache, une par registre (R-7), toutes
-- PARTAGÉES et toutes payées par l'élève B : c'est ce qui permet de vérifier
-- qu'une éviction prive aussi son propre payeur.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tev-theme', 'TEV Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('d8000000-0000-4000-8000-0000000000f1'::uuid, 'tev-theme', 'tev-9', 'TEV 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('tev-subj', 'TEV Maths', 'Esprit', 'subject-math', 'Brain', 'tev-theme',
        'd8000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content)
VALUES ('d8000000-0000-4000-8000-0000000000c1'::uuid, 'tev-subj', 'TEV Fractions',
        'Résumé TEV', '## Addition' || E'\n' || 'On garde le dénominateur.');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES ('d8000000-0000-4000-8000-0000000000e1'::uuid,
        'd8000000-0000-4000-8000-0000000000c1'::uuid, 'tev-subj', 'TEV Ex', 1, 'practice', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('d8000000-0000-4000-8000-0000000000a1'::uuid, 'd8000000-0000-4000-8000-0000000000e1'::uuid,
        'TEV question 1', '[{"id":"a","text":"5/6"},{"id":"b","text":"2/5"}]'::jsonb,
        'a', 'On met au même dénominateur.', 1);

INSERT INTO auth.users (id, email) VALUES
  ('d8000000-0000-4000-8000-000000000001', 'tev-eleve-a@test.local'),
  ('d8000000-0000-4000-8000-000000000002', 'tev-eleve-b@test.local'),
  ('d8000000-0000-4000-8000-000000000009', 'tev-admin@test.local');

-- `handle_new_user` a créé les profils ; on promeut l'admin, c'est lui que
-- `is_admin()` lit dans la console de la section 7.
UPDATE public.profiles SET role = 'admin' WHERE id = 'd8000000-0000-4000-8000-000000000009';

-- R-1 : sans réponse soumise, ni le fil ni le cache ne s'ouvrent.
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source)
VALUES
  ('d8000000-0000-4000-8000-000000000001'::uuid, 'd8000000-0000-4000-8000-0000000000a1'::uuid,
   'd8000000-0000-4000-8000-0000000000c1'::uuid, 'd8000000-0000-4000-8000-0000000000b1'::uuid,
   'b', false, 'exercise'),
  ('d8000000-0000-4000-8000-000000000002'::uuid, 'd8000000-0000-4000-8000-0000000000a1'::uuid,
   'd8000000-0000-4000-8000-0000000000c1'::uuid, 'd8000000-0000-4000-8000-0000000000b2'::uuid,
   'b', false, 'exercise');

-- Trois entrées PARTAGÉES, payées par l'élève B, une par registre.
SELECT set_config('test.e1', public.store_tutor_explanation(
  'd8000000-0000-4000-8000-0000000000a1'::uuid, NULL, 'fr', '12-14', 'concret',
  'Explication E1 — celle que deux élèves vont refuser.', 'claude-haiku-4-5', true,
  'd8000000-0000-4000-8000-000000000002'::uuid)::text, true);

SELECT set_config('test.e2', public.store_tutor_explanation(
  'd8000000-0000-4000-8000-0000000000a1'::uuid, NULL, 'fr', '12-14', 'visuel-verbal',
  'Explication E2 — celle du recompte.', 'claude-haiku-4-5', true,
  'd8000000-0000-4000-8000-000000000002'::uuid)::text, true);

SELECT set_config('test.e3', public.store_tutor_explanation(
  'd8000000-0000-4000-8000-0000000000a1'::uuid, NULL, 'fr', '12-14', 'formel',
  'Explication E3 — jamais liée à un message.', 'claude-haiku-4-5', true,
  'd8000000-0000-4000-8000-000000000002'::uuid)::text, true);

-- =========================================================
-- 0. Le CONTRAT du lien : le cache rend l'identité de ce qu'il sert.
-- =========================================================
-- Sans cette clé, le serveur n'a rien à ranger et tout le reste du fichier est
-- une fiction. C'est l'assertion qui casse si quelqu'un « nettoie » la charge
-- rendue par `find_tutor_explanation`.
SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.find_tutor_explanation('d8000000-0000-4000-8000-0000000000a1'::uuid,
    NULL, 'fr', '12-14', 'concret'))->>'id',
  current_setting('test.e1'),
  'R-15.3 ⭐ : le cache rend l''IDENTITÉ de l''entrée servie — sans elle, un 👎 ne désigne rien'
);

SELECT set_config('test.thread_a',
  (public.open_tutor_thread('d8000000-0000-4000-8000-0000000000a1'::uuid, 'fr', '12-14'))->>'thread_id',
  true);

SELECT set_config('test.ix_a0',
  (public.append_tutor_message(current_setting('test.thread_a')::uuid,
                               'tutor', 'explain', 'E1 servie une première fois'))->>'message_ix',
  true);

SET LOCAL ROLE postgres;
SELECT public.record_tutor_explanation_serving(
  current_setting('test.thread_a')::uuid,
  current_setting('test.ix_a0')::int,
  current_setting('test.e1')::uuid);
SET LOCAL ROLE authenticated;

-- =========================================================
-- 1. UNE voix ne suffit pas.
-- =========================================================
SELECT lives_ok(
  $$ SELECT public.rate_tutor_message(current_setting('test.thread_a')::uuid,
                                      current_setting('test.ix_a0')::int, -1::smallint) $$,
  'un 👎 s''enregistre comme avant — l''éviction ne change pas le geste de l''élève'
);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e1')::uuid) IS NULL,
  'R-15.3 : UN seul 👎 n''évince pas — le seuil est à deux, et il vaut d''être tenu'
);
SET LOCAL ROLE authenticated;

-- =========================================================
-- 2. ⭐ DEUX CLICS DU MÊME ÉLÈVE NE FONT PAS DEUX VOIX.
-- =========================================================
-- Le cas réel : l'élève rouvre le panneau de correction, la même entrée lui est
-- RE-servie (é11 R-7 ne brûle pas de registre à la réouverture), il re-clique
-- 👎. Deux lignes dans `tutor_feedback`, un seul enfant. Si ce fichier laissait
-- passer, un compte suffirait à vider le pot commun.
SELECT set_config('test.ix_a1',
  (public.append_tutor_message(current_setting('test.thread_a')::uuid,
                               'tutor', 'explain', 'E1 re-servie au même élève'))->>'message_ix',
  true);

SET LOCAL ROLE postgres;
SELECT public.record_tutor_explanation_serving(
  current_setting('test.thread_a')::uuid,
  current_setting('test.ix_a1')::int,
  current_setting('test.e1')::uuid);
SET LOCAL ROLE authenticated;

SELECT public.rate_tutor_message(current_setting('test.thread_a')::uuid,
                                current_setting('test.ix_a1')::int, -1::smallint);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e1')::uuid) IS NULL,
  'R-15.3 ⭐ : deux 👎 du MÊME élève sur la même entrée = UNE voix — sinon un seul compte vide le pot'
);
SET LOCAL ROLE authenticated;

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT is(
  (SELECT count(*)::int FROM public.tutor_feedback f
     JOIN public.tutor_explanation_servings s
       ON s.thread_id = f.thread_id AND s.message_ix = f.message_ix
    WHERE s.explanation_id = current_setting('test.e1')::uuid AND f.rating = -1),
  2,
  'les deux avis sont bien ENREGISTRÉS — c''est le comptage qui les rassemble, pas un filtre à l''écriture'
);
SET LOCAL ROLE authenticated;

-- L'élève B, lui, est une seconde voix.
SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.thread_b',
  (public.open_tutor_thread('d8000000-0000-4000-8000-0000000000a1'::uuid, 'fr', '12-14'))->>'thread_id',
  true);

SELECT set_config('test.ix_b0',
  (public.append_tutor_message(current_setting('test.thread_b')::uuid,
                               'tutor', 'explain', 'E1 servie à un second élève'))->>'message_ix',
  true);

SET LOCAL ROLE postgres;
SELECT public.record_tutor_explanation_serving(
  current_setting('test.thread_b')::uuid,
  current_setting('test.ix_b0')::int,
  current_setting('test.e1')::uuid);
SET LOCAL ROLE authenticated;

SELECT public.rate_tutor_message(current_setting('test.thread_b')::uuid,
                                current_setting('test.ix_b0')::int, -1::smallint);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e1')::uuid) IS NOT NULL,
  'R-15.3 ⭐ : DEUX voix distinctes retirent l''entrée du service — la règle devient un fait'
);
SET LOCAL ROLE authenticated;

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT shared FROM public.tutor_explanations WHERE id = current_setting('test.e1')::uuid),
  'R-15.3 : `shared` n''est PAS retourné — l''entrée reste un fait d''écriture, sinon le taux d''éviction serait incalculable'
);
SET LOCAL ROLE authenticated;

-- =========================================================
-- 3. ⭐ L'ÉVINCÉE NE SE SERT PLUS — À PERSONNE.
-- =========================================================
-- C'est ici que « forcent une régénération » se vérifie. L'élève B est le
-- PAYEUR de E1 : si l'éviction s'était contentée de basculer `shared`, la clause
-- `(e.shared OR e.owner_user_id = v_user)` continuerait de lui servir
-- exactement l'explication que deux enfants viennent de refuser.
SELECT ok(
  public.find_tutor_explanation('d8000000-0000-4000-8000-0000000000a1'::uuid,
    NULL, 'fr', '12-14', 'concret') IS NULL,
  'R-15.3 ⭐ : une entrée évincée n''est plus servie à son PROPRE PAYEUR — la régénération est forcée pour tous'
);

SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(
  public.find_tutor_explanation('d8000000-0000-4000-8000-0000000000a1'::uuid,
    NULL, 'fr', '12-14', 'concret') IS NULL,
  'R-15.3 : ni aux autres élèves du parc — le pot commun a rendu sa mauvaise entrée'
);

-- =========================================================
-- 4. L'éviction est un ALLER SIMPLE.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.rate_tutor_message(current_setting('test.thread_b')::uuid,
                                current_setting('test.ix_b0')::int, 1::smallint);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e1')::uuid) IS NOT NULL,
  'R-15.3 : un 👍 postérieur ne remet RIEN dans le pot — deux enfants l''ont refusée, la régénérer coûte moins qu''un contresens'
);
SET LOCAL ROLE authenticated;

-- =========================================================
-- 5. Le compte est REFAIT, il n'est pas incrémenté.
-- =========================================================
-- Un compteur incrémental aurait manqué la correction d'un avis : un élève qui
-- passe son 👎 en 👍 doit faire REDESCENDRE le compte, sinon on évince sur un
-- avis retiré. E2 sert exactement ce scénario.
SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.ix_a2',
  (public.append_tutor_message(current_setting('test.thread_a')::uuid,
                               'tutor', 'reformulate', 'E2 servie à l''élève A'))->>'message_ix',
  true);

SET LOCAL ROLE postgres;
SELECT public.record_tutor_explanation_serving(
  current_setting('test.thread_a')::uuid,
  current_setting('test.ix_a2')::int,
  current_setting('test.e2')::uuid);
SET LOCAL ROLE authenticated;

-- A désavoue, puis se ravise.
SELECT public.rate_tutor_message(current_setting('test.thread_a')::uuid,
                                current_setting('test.ix_a2')::int, -1::smallint);
SELECT public.rate_tutor_message(current_setting('test.thread_a')::uuid,
                                current_setting('test.ix_a2')::int, 1::smallint);

SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.ix_b1',
  (public.append_tutor_message(current_setting('test.thread_b')::uuid,
                               'tutor', 'reformulate', 'E2 servie à l''élève B'))->>'message_ix',
  true);

SET LOCAL ROLE postgres;
SELECT public.record_tutor_explanation_serving(
  current_setting('test.thread_b')::uuid,
  current_setting('test.ix_b1')::int,
  current_setting('test.e2')::uuid);
SET LOCAL ROLE authenticated;

SELECT public.rate_tutor_message(current_setting('test.thread_b')::uuid,
                                current_setting('test.ix_b1')::int, -1::smallint);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e2')::uuid) IS NULL,
  'R-15.3 ⭐ : un avis RETIRÉ ne compte plus — le seuil se recompte, il ne s''empile pas'
);
SET LOCAL ROLE authenticated;

-- Et il remonte aussi bien qu'il descend : A revient à son 👎.
SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.rate_tutor_message(current_setting('test.thread_a')::uuid,
                                current_setting('test.ix_a2')::int, -1::smallint);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e2')::uuid) IS NOT NULL,
  'le recompte fonctionne dans les deux sens : l''avis rendu au 👎 refait la seconde voix'
);
SET LOCAL ROLE authenticated;

-- =========================================================
-- 6. Un message SANS lien n'évince rien — et ne casse rien.
-- =========================================================
-- Le cas des messages antérieurs à cette migration, et de toute réponse qui ne
-- vient pas du cache (le chat du lot 3, un modèle plateforme non curé). L'avis
-- doit s'enregistrer comme avant.
SELECT set_config('test.ix_a3',
  (public.append_tutor_message(current_setting('test.thread_a')::uuid,
                               'tutor', 'explain', 'Un message que rien ne lie au cache'))->>'message_ix',
  true);

SELECT lives_ok(
  $$ SELECT public.rate_tutor_message(current_setting('test.thread_a')::uuid,
                                      current_setting('test.ix_a3')::int, -1::smallint) $$,
  'un 👎 sur un message sans lien s''enregistre sans lever — R-15.3 n''a pas rendu le geste fragile'
);

-- Lecture DIRECTE des tables du cache : elles sont REVOKE ALL pour
-- `authenticated` (leurs corps portent la correction, é11 R-1). On repasse
-- donc `postgres` le temps de l'observation, comme le fait 66_tutor_explain.
SET LOCAL ROLE postgres;
SELECT ok(
  (SELECT evicted_at FROM public.tutor_explanations WHERE id = current_setting('test.e3')::uuid) IS NULL,
  'R-15.3 : un 👎 non rattaché n''évince rien au hasard — E3 n''a jamais été servie, elle reste au pot'
);
SET LOCAL ROLE authenticated;

SELECT is(
  (public.find_tutor_explanation('d8000000-0000-4000-8000-0000000000a1'::uuid,
    NULL, 'fr', '12-14', 'formel'))->>'id',
  current_setting('test.e3'),
  'l''éviction est CIBLÉE : les entrées voisines du même cache continuent de servir'
);

-- =========================================================
-- 7. L'indicateur que R-15.3 réclame nommément.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"d8000000-0000-4000-8000-000000000009","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_cache_stats(30))->>'sharedRows', '3',
  'les trois entrées sont bien ENTRÉES au pot — c''est le dénominateur du taux'
);

SELECT is(
  (public.get_tutor_cache_stats(30))->>'evictedRows', '2',
  'R-15.3 : la console compte les sorties — E1 et E2, pas E3'
);

SELECT is(
  (public.get_tutor_cache_stats(30))->>'evictionRate', '0.667',
  'R-15.3 ⭐ : « le taux d''éviction est un indicateur de la console admin » — 2 sorties sur 3 entrées'
);

-- =========================================================
-- 8. Les droits — le lien est écrit par le serveur ou pas du tout.
-- =========================================================
-- Si un client pouvait joindre cette RPC ou cette table, il DÉSIGNERAIT
-- l'entrée que son propre 👎 fait sortir du pot commun. C'est la porte qui rend
-- le seuil à deux voix crédible.
SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.record_tutor_explanation_serving(uuid,integer,uuid)', 'EXECUTE'),
  'R-15.3 ⭐ : un client ne RANGE pas le lien — il choisirait l''entrée que son 👎 évince'
);

SELECT ok(
  NOT has_function_privilege('anon',
    'public.record_tutor_explanation_serving(uuid,integer,uuid)', 'EXECUTE'),
  'anon non plus — le REVOKE tient sans dépendre d''une session'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.tutor_explanation_servings', 'SELECT'),
  'la table de jonction n''est pas lisible par un client : elle décide d''une perte pour tout le parc'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.tutor_explanation_servings', 'INSERT'),
  'ni inscriptible — sinon le PostgREST du client remplacerait la RPC'
);

SELECT is(
  public.tutor_eviction_downvotes(), 2,
  'le seuil vit en base ET dans TUTOR_EVICTION_DOWNVOTES — le changer demande une migration, donc une revue'
);

SELECT * FROM finish();
ROLLBACK;
