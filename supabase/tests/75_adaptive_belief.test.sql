-- =========================================================
-- Tuteur déterministe — le socle de croyance (étude 30, lot 1).
-- ---------------------------------------------------------
-- Ce que cette suite prouve, dans l'ordre :
--
--   1-3.   Grants & sécurité : les quatre helpers et le trigger ne sont exécutables par
--          aucun rôle client ; les colonnes ajoutées héritent du SELECT-only de é07 lot 2.
--   4-13.  LA TABLE DE VÉRITÉ BKT (annexe A) — pour chaque forme d'item, la croyance après
--          une réponse juste et après une réponse fausse, comparée à la valeur calculée à la
--          main DANS le commentaire. C'est le seul endroit du dépôt où un nombre magique est
--          légitime : il est dérivé et montré.
--   14-19. Le trigger sur données réelles : premier contact, composition, formes distinctes,
--          sessions distinctes, 1..3 compétences par question.
--   20-22. LE POIDS DU FIL (§3.2) — deux assertions jumelles, mêmes fixtures, seul le fil
--          change : une soumission dont `session_id` est un fil `tutor_threads` pèse 0,5.
--   23-27. R-6, LA NEUTRALITÉ DU NON-TAGGÉ — le test central de non-régression : aucune
--          ligne créée, `get_daily_plan` littéralement identique, `mastery` intacte.
--
-- ⚠️ UN ÉCART AVEC L'ANNEXE A, TRANCHÉ EN FAVEUR DU MODÈLE. Huit des neuf lignes des tables
-- A.1/A.2 se rejouent exactement avec les formules du §3.2. Une seule ne s'y rejoue pas :
-- A.1 n° 2 (`numeric` juste depuis 0,200) est annoncée à 0,861 alors que les formules donnent
-- **0,8482** — il faudrait p(G) = 0,045 et non 0,05 pour obtenir 0,861. Le §3.2 donne les
-- formules ET les constantes ; la table en est dérivée. Là où la table contredit le modèle
-- dont elle dérive, le modèle fait foi, et le désaccord est écrit ici plutôt que subi.
--
-- Schéma + comportement uniquement : chaque compétence, question et tentative est une fixture
-- créée DANS cette transaction, donc la suite est indépendante du corpus (parti au dépôt privé
-- avec l'étude 24).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(29);

-- ---------------------------------------------------------
-- Fixtures (superuser : RLS contournée pour le seed).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('be000000-0000-0000-0000-0000000000a1', 'belief-student-a@test.local'),
  ('be000000-0000-0000-0000-0000000000b2', 'belief-student-b@test.local');

-- Deux compétences aux paramètres ÉCRITS (D-2), plus une troisième laissée aux défauts.
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar, p_init, p_transit) VALUES
  ('be100000-0000-0000-0000-000000000001', 'test.belief.alpha', 'test', 'Alpha', 'Alpha', 'ألفا', 0.20, 0.15),
  ('be100000-0000-0000-0000-000000000002', 'test.belief.beta',  'test', 'Beta',  'Beta',  'بيتا', 0.20, 0.15);
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('be100000-0000-0000-0000-000000000003', 'test.belief.defaults', 'test', 'Défauts', 'Defaults', 'افتراضي');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('belief-subj', 'Belief Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('be200000-0000-0000-0000-000000000001', 'belief-subj', 'Belief Chapter');

-- Un exercice de palier 2 : p(S) = 0,08, le palier de toute l'annexe A.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty)
VALUES ('be300000-0000-0000-0000-000000000001', 'be200000-0000-0000-0000-000000000001',
        'belief-subj', 'd2', 'admin', 'practice', 2);

-- q1 = mcq à 4 options (G = 0,25) · q2 = short_answer (G = 0,02) · q3 = mcq à 4 options
-- taggée SUR DEUX compétences · q4 = mcq NON TAGGÉE (le contrôle de neutralité R-6).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, question_type, answer_key, display_order) VALUES
  ('be400000-0000-0000-0000-000000000001', 'be300000-0000-0000-0000-000000000001', 'q mcq4',
   '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb,
   'a', 'mcq', NULL, 1),
  ('be400000-0000-0000-0000-000000000002', 'be300000-0000-0000-0000-000000000001', 'q short',
   '[]'::jsonb, NULL, 'short_answer', '{"accepted":["x"]}'::jsonb, 2),
  ('be400000-0000-0000-0000-000000000003', 'be300000-0000-0000-0000-000000000001', 'q double',
   '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb,
   'a', 'mcq', NULL, 3),
  ('be400000-0000-0000-0000-000000000004', 'be300000-0000-0000-0000-000000000001', 'q untagged',
   '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb,
   'a', 'mcq', NULL, 4);

INSERT INTO public.question_competencies (question_id, competency_id, is_primary) VALUES
  ('be400000-0000-0000-0000-000000000001', 'be100000-0000-0000-0000-000000000001', true),
  ('be400000-0000-0000-0000-000000000002', 'be100000-0000-0000-0000-000000000001', true),
  ('be400000-0000-0000-0000-000000000003', 'be100000-0000-0000-0000-000000000001', true),
  ('be400000-0000-0000-0000-000000000003', 'be100000-0000-0000-0000-000000000002', false);

-- Une session d'exercice classique, et un FIL DE TUTEUR dont l'id servira de session_id —
-- c'est exactement ce que fait `submit_tutor_mini_check` (é11 lot 4).
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, variant)
VALUES ('be500000-0000-0000-0000-000000000001', 'be000000-0000-0000-0000-0000000000a1',
        'be300000-0000-0000-0000-000000000001', 'classic'),
       ('be500000-0000-0000-0000-000000000002', 'be000000-0000-0000-0000-0000000000a1',
        'be300000-0000-0000-0000-000000000001', 'classic');

INSERT INTO public.tutor_threads (id, user_id, scope, question_id, lang, age_band)
VALUES ('be600000-0000-0000-0000-000000000001', 'be000000-0000-0000-0000-0000000000b2',
        'question', 'be400000-0000-0000-0000-000000000001', 'fr', '12-14');

-- Helper : une ligne de télémétrie (le trigger sous test se déclenche sur cet INSERT).
CREATE OR REPLACE FUNCTION pg_temp.answer(
  p_user UUID, p_question UUID, p_correct BOOLEAN,
  p_session UUID DEFAULT 'be500000-0000-0000-0000-000000000001',
  p_at TIMESTAMPTZ DEFAULT now()
) RETURNS void LANGUAGE sql AS $$
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, source, created_at)
  VALUES (p_user, p_question, 'be200000-0000-0000-0000-000000000001',
          p_session, 'a', p_correct, 'exercise', p_at);
$$;

CREATE OR REPLACE FUNCTION pg_temp.belief(p_user UUID, p_competency UUID)
RETURNS NUMERIC LANGUAGE sql AS $$
  SELECT p_known FROM public.user_competency_mastery
   WHERE user_id = p_user AND competency_id = p_competency;
$$;

-- =========================================================
-- 1-3. Grants & sécurité.
-- =========================================================
-- Les helpers décident ; les décisions ne s'exécutent pas depuis un navigateur. Même posture
-- que les helpers de é07 lot 2 : les lectures du lot 3 sont SECURITY DEFINER et les appellent
-- comme propriétaire.
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.belief_update(numeric,boolean,numeric,numeric,numeric,numeric)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.belief_update(numeric,boolean,numeric,numeric,numeric,numeric)', 'EXECUTE'),
  'Sécurité : belief_update n''est exécutable par aucun rôle client'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.belief_guess(text,integer,text)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.belief_slip(integer,boolean)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.belief_evidence_weight(uuid,uuid)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.record_competency_belief()', 'EXECUTE'),
  'Sécurité : ni les paramètres du modèle ni l''écrivain ne sont joignables côté client'
);

-- Les colonnes ajoutées suivent le grant de la TABLE (é07 lot 2 : SELECT-only). Aucun
-- nouveau grant n'a été posé et aucun n'a été retiré — le piège d'AGENTS.md porte sur les
-- tables neuves, pas sur les colonnes d'une table déjà servie.
SELECT ok(
  has_table_privilege('authenticated', 'public.user_competency_mastery', 'SELECT')
  AND NOT has_table_privilege('authenticated', 'public.user_competency_mastery', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.user_competency_mastery', 'UPDATE')
  AND NOT has_table_privilege('anon', 'public.user_competency_mastery', 'SELECT'),
  'Grants : la croyance se lit (par son propriétaire), ne s''écrit que par le trigger'
);

-- =========================================================
-- 4-13. LA TABLE DE VÉRITÉ BKT (annexe A) — nombres dérivés et montrés.
-- Paramètres partout : p(S) = 0,08 (palier 2), p(T) = 0,15.
-- =========================================================

-- p(G) est la GÉOMÉTRIE de l'item (D-2) : 1/k borné [0,15 ; 0,30].
SELECT is(
  ARRAY[
    public.belief_guess('mcq', 2, 'classic'), public.belief_guess('mcq', 4, 'classic'),
    public.belief_guess('mcq', 8, 'classic'), public.belief_guess('short_answer', NULL, 'classic'),
    public.belief_guess('numeric', NULL, 'classic'), public.belief_guess('multi', NULL, 'classic')
  ],
  ARRAY[0.3000, 0.2500, 0.1500, 0.0200, 0.0500, 0.0800]::NUMERIC[],
  'p(G) : 1/2 plafonné à 0,30 · 1/4 = 0,25 · 1/8 planché à 0,15 · saisie libre 0,02'
);

-- La variante RAPPEL prime sur le type : une mcq jouée de mémoire n'affiche pas ses options.
SELECT is(
  public.belief_guess('mcq', 4, 'recall'), 0.0200::NUMERIC,
  'p(G) : le rappel actif (é17) écrase la géométrie du QCM — c''est ce qui en fait une preuve'
);

-- p(S) décroît avec la difficulté, et monte au plafond de R-3 sous charge (lot 6).
SELECT is(
  ARRAY[
    public.belief_slip(1, false), public.belief_slip(2, false), public.belief_slip(3, false),
    public.belief_slip(4, false), public.belief_slip(NULL, false), public.belief_slip(4, true)
  ],
  ARRAY[0.10, 0.08, 0.06, 0.05, 0.08, 0.20]::NUMERIC[],
  'p(S) : d1 0,10 → d4 0,05, défaut d2, plafond 0,20 sous signal de charge (R-3)'
);

-- A.1 n° 1 — p⁺ = 0,20×0,92 / (0,20×0,92 + 0,80×0,02) = 0,184/0,200 = 0,92
--            p' = 0,92 + (1−0,92)×0,15 = 0,932
SELECT is(
  public.belief_update(0.20, true, public.belief_guess('short_answer', NULL, 'classic'),
                       public.belief_slip(2, false), 0.15),
  0.9320::NUMERIC,
  'A.1 n° 1 : une seule saisie libre juste porte la croyance de 0,200 à 0,932'
);

-- A.1 n° 2 — p⁺ = 0,184 / (0,184 + 0,80×0,05) = 0,184/0,224 = 0,821428…
--            p' = 0,821428 + 0,178571×0,15 = 0,848214 → 0,8482   (l'étude annonce 0,861)
SELECT is(
  public.belief_update(0.20, true, public.belief_guess('numeric', NULL, 'classic'),
                       public.belief_slip(2, false), 0.15),
  0.8482::NUMERIC,
  'A.1 n° 2 : un `numeric` juste porte 0,200 à 0,8482 (et non 0,861 — voir l''entête)'
);

-- A.1 n° 3-6 — la démonstration du corollaire produit : il faut TROIS QCM à 4 options pour
-- dépasser UNE saisie libre. La variété n'est pas un ornement, c'est la quantité d'information.
SELECT is(
  ARRAY[
    public.belief_update(0.2000, true, 0.25, 0.08, 0.15),
    public.belief_update(0.5573, true, 0.25, 0.08, 0.15),
    public.belief_update(0.8491, true, 0.25, 0.08, 0.15),
    public.belief_update(0.9608, true, 0.25, 0.08, 0.15)
  ],
  ARRAY[0.5573, 0.8491, 0.9608, 0.99]::NUMERIC[],
  'A.1 n° 3-6 : 0,200 → 0,557 → 0,849 → 0,961 → 0,99 (la 4ᵉ vaut 0,9907, bornée par R-1)'
);

-- A.2 n° 7-8 — l'erreur d'un débutant n'apprend presque rien ; celle d'un quasi-maître, si.
SELECT is(
  ARRAY[
    public.belief_update(0.200, false, 0.25, 0.08, 0.15),
    public.belief_update(0.960, false, 0.25, 0.08, 0.15)
  ],
  ARRAY[0.1721, 0.7612]::NUMERIC[],
  'A.2 n° 7-8 : 0,200 → 0,172 (on le savait déjà) · 0,960 → 0,761 (la maîtrise se re-prouve)'
);

-- A.2 n° 9 — sous charge, le système PARDONNE. L'écart avec le n° 8 est toute la différence
-- entre « tu ne sais pas » et « tu es fatigué » (R-25).
SELECT is(
  public.belief_update(0.960, false, 0.25, public.belief_slip(2, true), 0.15),
  0.8851::NUMERIC,
  'A.2 n° 9 : sous signal de charge la même erreur ne coûte que 0,960 → 0,885 (R-25)'
);

-- A.3 — le poids de la preuve : p_final = p_avant + w·(p_après − p_avant).
SELECT is(
  ARRAY[
    public.belief_update(0.20, true, 0.25, 0.08, 0.15, 1.00),
    public.belief_update(0.20, true, 0.25, 0.08, 0.15, 0.50),
    public.belief_update(0.20, true, 0.25, 0.08, 0.15, 0.25)
  ],
  ARRAY[0.5573, 0.3786, 0.2893]::NUMERIC[],
  'A.3 : sans aide 0,557 · après aide légère 0,379 · après décomposition 0,289 (R-21)'
);

-- Test par ATTAQUE : aucune séquence, si longue soit-elle, ne franchit les bornes de R-1.
-- Une croyance à 0 ou 1 serait un point fixe dont aucune preuve contraire ne la sortirait.
SELECT is(
  (WITH RECURSIVE walk(i, p) AS (
     SELECT 1, 0.20::NUMERIC
     UNION ALL
     SELECT i + 1, public.belief_update(p, true, 0.25, 0.08, 0.15) FROM walk WHERE i < 60
   ) SELECT max(p) FROM walk),
  0.99::NUMERIC,
  'Attaque : soixante réussites d''affilée plafonnent à 0,99 — la certitude n''est pas atteignable'
);

-- =========================================================
-- 14-19. Le trigger, sur des tentatives réelles.
-- =========================================================
SELECT pg_temp.answer('be000000-0000-0000-0000-0000000000a1', 'be400000-0000-0000-0000-000000000001', true);

SELECT is(
  pg_temp.belief('be000000-0000-0000-0000-0000000000a1', 'be100000-0000-0000-0000-000000000001'),
  0.5573::NUMERIC,
  'Trigger : le premier contact part du p_init du REGISTRE (D-2), pas d''un 0,20 en dur'
);

SELECT is(
  (SELECT ARRAY[evidence_count, sessions_seen] FROM public.user_competency_mastery
    WHERE user_id = 'be000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'be100000-0000-0000-0000-000000000001'),
  ARRAY[1, 1],
  'Trigger : la première preuve compte une preuve et une session'
);

-- Deuxième item, MÊME session, forme DIFFÉRENTE (short_answer, G = 0,02).
SELECT pg_temp.answer('be000000-0000-0000-0000-0000000000a1', 'be400000-0000-0000-0000-000000000002', true);

SELECT is(
  (SELECT forms_seen FROM public.user_competency_mastery
    WHERE user_id = 'be000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'be100000-0000-0000-0000-000000000001'),
  ARRAY['mcq', 'short_answer']::TEXT[],
  'R-4 : `forms_seen` accumule des TYPES distincts — un compteur ne saurait pas dire « varié »'
);

SELECT is(
  (SELECT sessions_seen FROM public.user_competency_mastery
    WHERE user_id = 'be000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'be100000-0000-0000-0000-000000000001'),
  1,
  'R-4 : deux items de la MÊME session ne font toujours qu''une session'
);

-- Troisième item, AUTRE session, et une question taggée sur DEUX compétences.
SELECT pg_temp.answer('be000000-0000-0000-0000-0000000000a1', 'be400000-0000-0000-0000-000000000003', true,
                      'be500000-0000-0000-0000-000000000002');

SELECT is(
  (SELECT sessions_seen FROM public.user_competency_mastery
    WHERE user_id = 'be000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'be100000-0000-0000-0000-000000000001'),
  2,
  'R-4 : une session neuve pour cette compétence incrémente le compteur de sessions'
);

SELECT ok(
  (SELECT count(*) FROM public.user_competency_mastery
    WHERE user_id = 'be000000-0000-0000-0000-0000000000a1') = 2
  AND pg_temp.belief('be000000-0000-0000-0000-0000000000a1', 'be100000-0000-0000-0000-000000000002') = 0.5573,
  'é07 R-2 : une question taggée sur deux compétences en fait avancer deux, chacune depuis SON prior'
);

-- =========================================================
-- 20-22. LE POIDS DU FIL (§3.2) — deux assertions jumelles, seul le fil change.
-- =========================================================
-- L'élève B rejoue exactement le premier item de A, mais sa session_id est un fil de tuteur :
-- c'est un mini-check é11, donc une reprise APRÈS explication, donc une demi-preuve.
SELECT pg_temp.answer('be000000-0000-0000-0000-0000000000b2', 'be400000-0000-0000-0000-000000000001', true,
                      'be600000-0000-0000-0000-000000000001');

SELECT is(
  pg_temp.belief('be000000-0000-0000-0000-0000000000b2', 'be100000-0000-0000-0000-000000000001'),
  0.3786::NUMERIC,
  'Poids du fil : la MÊME bonne réponse dans un fil de tuteur pèse w = 0,5 (0,379 et non 0,557)'
);

SELECT ok(
  pg_temp.belief('be000000-0000-0000-0000-0000000000b2', 'be100000-0000-0000-0000-000000000001')
    < pg_temp.belief('be000000-0000-0000-0000-0000000000a1', 'be100000-0000-0000-0000-000000000001'),
  'Poids du fil : une reprise après aide prouve strictement moins qu''une réussite autonome (R-21)'
);

-- Le fil d'un AUTRE élève ne doit pas alléger ma preuve : la détection porte sur le couple
-- (élève, fil), sinon un identifiant emprunté deviendrait une remise sur la difficulté.
SELECT is(
  public.belief_evidence_weight('be000000-0000-0000-0000-0000000000a1', 'be600000-0000-0000-0000-000000000001'),
  1.0::NUMERIC,
  'Poids du fil : le fil d''un autre élève ne pèse rien — la détection est par (élève, fil)'
);

-- =========================================================
-- 23-27. R-6 — LA NEUTRALITÉ DU NON-TAGGÉ.
-- « Les trois quarts des assertions de cette étude portent sur ce qui ne doit PAS changer. »
-- =========================================================
CREATE TEMP TABLE belief_before AS
  SELECT user_id, competency_id, p_known, mastery, attempts, evidence_count
    FROM public.user_competency_mastery;

-- Deux révisions dues, pour que le plan comparé ne soit pas vide : une égalité entre deux
-- ensembles vides ne prouverait rien, et c'est le piège classique d'une assertion « identique ».
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES ('be000000-0000-0000-0000-0000000000a1', 'be300000-0000-0000-0000-000000000001',
        'belief-subj', 1, now() - INTERVAL '3 days', 'pending');

SET LOCAL "request.jwt.claims" = '{"sub":"be000000-0000-0000-0000-0000000000a1","role":"authenticated"}';

CREATE TEMP TABLE plan_before AS SELECT * FROM public.get_daily_plan();

-- Vingt réponses sur une question SANS compétence : le socle doit rester muet.
SELECT pg_temp.answer('be000000-0000-0000-0000-0000000000a1', 'be400000-0000-0000-0000-000000000004', i % 2 = 0)
  FROM generate_series(1, 20) AS i;

SELECT is(
  (SELECT count(*)::int FROM public.user_competency_mastery),
  (SELECT count(*)::int FROM belief_before),
  'R-6 : vingt réponses sur du non-taggé ne créent AUCUNE ligne de croyance'
);

SELECT is_empty(
  $$ SELECT m.competency_id FROM public.user_competency_mastery m
       JOIN belief_before b USING (user_id, competency_id)
      WHERE m.p_known IS DISTINCT FROM b.p_known
         OR m.evidence_count IS DISTINCT FROM b.evidence_count $$,
  'R-6 : elles ne modifient non plus aucune croyance existante'
);

SELECT is_empty(
  $$ SELECT m.competency_id FROM public.user_competency_mastery m
       JOIN belief_before b USING (user_id, competency_id)
      WHERE m.mastery IS DISTINCT FROM b.mastery OR m.attempts IS DISTINCT FROM b.attempts $$,
  'D-1 : l''EWMA de é07 est intacte — la croyance décide, la maîtrise se montre'
);

-- L'assertion littérale exigée au §4.2 : le plan du jour, à l'octet près.
SELECT ok(
  (SELECT count(*) FROM plan_before) > 0
  AND NOT EXISTS (
    (SELECT * FROM public.get_daily_plan() EXCEPT ALL SELECT * FROM plan_before)
    UNION ALL
    (SELECT * FROM plan_before EXCEPT ALL SELECT * FROM public.get_daily_plan())
  ),
  'R-6 : `get_daily_plan` rend EXACTEMENT le même plan (non vide) qu''avant le lot — assertion littérale'
);

-- Le dernier verrou : une question taggée dont l'élève n'a jamais rien joué n'a pas de ligne.
-- « Une compétence sans preuve n'a aucune ligne » — c'est ce qui rend l'absence lisible.
SELECT is_empty(
  $$ SELECT 1 FROM public.user_competency_mastery
      WHERE competency_id = 'be100000-0000-0000-0000-000000000003' $$,
  'R-6 : une compétence jamais rencontrée n''a pas de ligne — l''absence de preuve se lit'
);

-- ---------------------------------------------------------
-- privé#247 item 2 — la borne de `p_transit` REFUSE ce qui éteindrait R-5.
--
-- Le plancher de la croyance vaut environ 1,12 x p(T) : au-dela de p(T) ~ 0,22 il passe
-- au-dessus du seuil de lacune de R-5 (0,25), et une lacune devient indetectable quel que
-- soit le nombre d'erreurs. La borne haute (0,18) est ce qui rend ce cas impossible a
-- ecrire. Ces deux assertions sont ce qui empeche un elargissement futur du CHECK de
-- rallumer le defaut en silence ; leur jumelle cote JS est dans
-- `scripts/adaptive/__tests__/belief-model.test.mjs`.
-- ---------------------------------------------------------
SELECT throws_ok(
  $$ INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar, p_transit)
     VALUES ('be100000-0000-0000-0000-0000000000ff', 'test.belief.ptransit.haut', 'test',
             'Trop haut', 'Too high', 'مرتفع', 0.30) $$,
  '23514',
  NULL,
  'privé#247 : p_transit = 0,30 est REFUSÉ — au-dessus de 0,22 le plancher couvre le seuil de lacune de R-5'
);

SELECT lives_ok(
  $$ INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar, p_transit)
     VALUES ('be100000-0000-0000-0000-0000000000fe', 'test.belief.ptransit.max', 'test',
             'Au maximum', 'At the cap', 'الحدّ', 0.18) $$,
  'privé#247 : p_transit = 0,18 (le maximum) est ACCEPTÉ — le plancher y vaut ≈ 0,202, sous le seuil'
);

SELECT * FROM finish();
ROLLBACK;
