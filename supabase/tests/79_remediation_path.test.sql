-- =========================================================
-- Tuteur déterministe — la décision (étude 30, lot 4).
-- ---------------------------------------------------------
-- Ce que cette suite prouve :
--
--   1-2.   Grants : la remontée est nominative, fermée à `anon`.
--   3-7.   R-15, LA CAUSE RACINE : « en partant du bas » — c'est-à-dire la PLUS PROFONDE des
--          non maîtrisées, et non la plus proche de l'échec. C'est tout le lot, et c'est
--          contre-intuitif, donc c'est ce qu'on éprouve le plus.
--   8-9.   La borne de profondeur (3) et l'exercice d'entrée passé par la porte (R-16).
--   10-13. LE REBRANCHEMENT de `get_targeted_exercises` — et, surtout, sa NON-RÉGRESSION
--          LITTÉRALE sans croyance : la sélection est identique à celle d'aujourd'hui,
--          comparée ligne à ligne et non « à peu près ».
--   14-15. Les stop-points : la porte Q-8 hérite sans être touchée, la Forge non plus.
--   16.    La garde de SESSION, sur les deux lectures — un défaut du lot 3 trouvé et corrigé ici.
--
-- La chaîne de fixture est volontairement longue (4 niveaux) : c'est le seul moyen de
-- distinguer « le prérequis le plus proche » de « le plus profond des manquants », qui sont
-- la même chose sur une chaîne courte — et donc de faire échouer une implémentation naïve.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

-- ---------------------------------------------------------
-- Fixtures : SOMMET → P1 → P2 → P3 (profondeur 3), plus P4 hors de portée (profondeur 4).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('4d000000-0000-0000-0000-0000000000a1', 'remed-student@test.local');

INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('4d100000-0000-0000-0000-000000000000', 'rm.geo.sommet', 'rmfam', 'Sommet', 'Peak', 'قمة'),
  ('4d100000-0000-0000-0000-000000000001', 'rm.geo.p1', 'rmfam', 'P1', 'P1', 'ب١'),
  ('4d100000-0000-0000-0000-000000000002', 'rm.num.p2', 'rmfam', 'P2', 'P2', 'ب٢'),
  ('4d100000-0000-0000-0000-000000000003', 'rm.num.p3', 'rmfam', 'P3', 'P3', 'ب٣'),
  ('4d100000-0000-0000-0000-000000000004', 'rm.num.p4', 'rmfam', 'P4', 'P4', 'ب٤');

INSERT INTO public.competency_prereqs (competency_id, prereq_id) VALUES
  ('4d100000-0000-0000-0000-000000000000', '4d100000-0000-0000-0000-000000000001'),
  ('4d100000-0000-0000-0000-000000000001', '4d100000-0000-0000-0000-000000000002'),
  ('4d100000-0000-0000-0000-000000000002', '4d100000-0000-0000-0000-000000000003'),
  ('4d100000-0000-0000-0000-000000000003', '4d100000-0000-0000-0000-000000000004');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('rm-subj', 'Remediation', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('4d200000-0000-0000-0000-000000000001', 'rm-subj', 'RM Chapter');

-- Un exercice par compétence, tous accessibles.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty, display_order)
SELECT ('4d300000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       '4d200000-0000-0000-0000-000000000001', 'rm-subj', 'ex' || i, 'admin', 'practice', 2, i
  FROM generate_series(1, 5) AS i;

-- ⚠️ SEULE q1 (celle du SOMMET) porte l'erreur nommée, et c'est ce qui rend cette suite
-- capable de prouver quoi que ce soit. Taguer les cinq questions ferait entrer TOUTES les
-- destinations par la voie TAG — la voie que le lot 4 ne touche pas — et les assertions du
-- rebranchement seraient vertes avant même qu'il existe. Avec un seul item tagué, et lui-même
-- écarté parce que joué récemment, la voie COMPÉTENCE est le seul chemin qui reste : ce qui
-- sort de la sélection ciblée sort donc de la décision qu'on teste, et de rien d'autre.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, question_type, display_order, distractor_tags)
SELECT ('4d400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       ('4d300000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID, 'q' || i,
       '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb,
       'a', 'mcq', 1,
       CASE WHEN i = 1 THEN '{"b": "rm.tag.erreur"}'::jsonb ELSE NULL END
  FROM generate_series(1, 5) AS i;

-- q1 → SOMMET, q2 → P1, q3 → P2, q4 → P3, q5 → P4.
INSERT INTO public.question_competencies (question_id, competency_id, is_primary)
SELECT ('4d400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       ('4d100000-0000-0000-0000-' || lpad((i - 1)::TEXT, 12, '0'))::UUID, true
  FROM generate_series(1, 5) AS i;

CREATE OR REPLACE FUNCTION pg_temp.believe(
  p_competency UUID, p_known NUMERIC, p_evidence INT, p_sessions INT, p_forms TEXT[]
) RETURNS void LANGUAGE sql AS $$
  INSERT INTO public.user_competency_mastery
    (user_id, competency_id, last_attempt_at, p_known, evidence_count, sessions_seen,
     forms_seen, last_evidence_at)
  VALUES ('4d000000-0000-0000-0000-0000000000a1', p_competency, now(), p_known,
          p_evidence, p_sessions, p_forms, now())
  ON CONFLICT (user_id, competency_id) DO UPDATE SET
    p_known = EXCLUDED.p_known, evidence_count = EXCLUDED.evidence_count,
    sessions_seen = EXCLUDED.sessions_seen, forms_seen = EXCLUDED.forms_seen,
    -- ⚠️ `last_evidence_at` DOIT être rafraîchie ici, et l'oubli s'est déjà payé une fois.
    -- La ligne peut avoir été CRÉÉE par la propagation du lot 2 (une déduction, donc sans
    -- preuve, donc `last_evidence_at` NULL) ; poser une croyance dessus sans dater la preuve
    -- laisse une ligne à 0,97 que R-4 refuse de déclarer maîtrisée — pour une raison juste,
    -- avec une fixture fausse. Le vrai trigger, lui, la date (`GREATEST(COALESCE(...))`) :
    -- une aide de test qui ne l'imite pas ment sur l'état du produit.
    last_evidence_at = EXCLUDED.last_evidence_at;
$$;

-- =========================================================
-- 1-2. Grants.
-- =========================================================
SELECT ok(
  has_function_privilege('authenticated', 'public.get_remediation_path(text)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.get_remediation_path(text)', 'EXECUTE'),
  'Grants : la remontée est nominative — `authenticated` seul, jamais `anon`'
);

SELECT ok(
  has_function_privilege('authenticated', 'public.get_targeted_exercises(text,text,integer)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.get_targeted_exercises(text,text,integer)', 'EXECUTE'),
  'Grants : ceux de é11 lot 5 survivent au CREATE OR REPLACE'
);

-- =========================================================
-- 3-7. R-15 — LA CAUSE RACINE, « en partant du bas ».
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"4d000000-0000-0000-0000-0000000000a1","role":"authenticated"}';

-- Sans aucune croyance, il n'y a rien à remonter : tout est `inconnue`, et une compétence
-- jamais vue n'a rien prouvé. La chaîne est rendue (elle est publique) mais la cause racine
-- est la plus profonde des inconnues — c'est correct, et le rebranchement, lui, exigera une
-- LACUNE (assertion 10).
SELECT is(
  (SELECT count(*)::INT FROM public.get_remediation_path('rm.geo.sommet')),
  3,
  'R-15 : la remontée est bornée à la profondeur 3 — P4, à la profondeur 4, n''y est pas'
);

-- L'élève a une lacune à la profondeur 1 (P1) ET une à la profondeur 3 (P3).
-- Une implémentation naïve proposerait P1 (le plus proche de l'échec). R-15 dit P3.
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000001', 0.10, 5, 2, ARRAY['mcq']);
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000002', 0.97, 4, 2, ARRAY['mcq','numeric']);
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000003', 0.08, 6, 2, ARRAY['mcq']);

SELECT is(
  (SELECT rp.slug FROM public.get_remediation_path('rm.geo.sommet') rp WHERE rp.is_root_cause),
  'rm.num.p3',
  'R-15 : la cause racine est la PLUS PROFONDE des non maîtrisées, pas la plus proche de l''échec'
);

SELECT is(
  (SELECT count(*)::INT FROM public.get_remediation_path('rm.geo.sommet') rp WHERE rp.is_root_cause),
  1,
  'R-15 : une seule cause racine — « une action, jamais une liste » (é15 R-1) commence ici'
);

SELECT is(
  (SELECT array_agg(rp.slug ORDER BY rp.depth DESC, rp.slug)
     FROM public.get_remediation_path('rm.geo.sommet') rp),
  ARRAY['rm.num.p3','rm.num.p2','rm.geo.p1']::TEXT[],
  'R-15 : la chaîne se lit du plus profond au plus proche — l''ordre de la REMONTÉE'
);

-- Une compétence maîtrisée au milieu ne coupe pas la remontée : le graphe est le graphe, et
-- c'est l'ÉTAT qui décide de la cause, pas la traversée.
SELECT is(
  (SELECT rp.state FROM public.get_remediation_path('rm.geo.sommet') rp WHERE rp.slug = 'rm.num.p2'),
  'maitrisee',
  'La chaîne rend AUSSI les maillons acquis — l''élève doit voir ce qui tient, pas que ce qui manque'
);

-- Quand tout est acquis en amont, il n'y a plus de cause : c'est le cas normal, et il ne doit
-- surtout pas désigner un coupable par défaut.
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000001', 0.97, 4, 2, ARRAY['mcq','numeric']);
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000003', 0.97, 4, 2, ARRAY['mcq','numeric']);

SELECT is_empty(
  $$ SELECT 1 FROM public.get_remediation_path('rm.geo.sommet') rp WHERE rp.is_root_cause $$,
  'R-15 : tous les prérequis acquis ⇒ AUCUNE cause racine — on ne désigne pas un coupable par défaut'
);

-- =========================================================
-- 8-9. L'exercice d'entrée (R-16) et l'absence de session.
-- =========================================================
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000003', 0.08, 6, 2, ARRAY['mcq']);

SELECT is(
  (SELECT rp.entry_exercise_id FROM public.get_remediation_path('rm.geo.sommet') rp
    WHERE rp.is_root_cause),
  '4d300000-0000-0000-0000-000000000004'::UUID,
  'R-16 : la cause racine arrive avec un exercice qui l''évalue, passé par la porte d''accès'
);

SET LOCAL "request.jwt.claims" = '';
SELECT is_empty(
  $$ SELECT 1 FROM public.get_remediation_path('rm.geo.sommet') rp WHERE rp.state <> 'inconnue' $$,
  'R-6 : sans session, la remontée ne lève pas et ne connaît personne'
);
SET LOCAL "request.jwt.claims" = '{"sub":"4d000000-0000-0000-0000-0000000000a1","role":"authenticated"}';

-- =========================================================
-- 10-12. LE REBRANCHEMENT, et sa non-régression LITTÉRALE.
-- =========================================================
-- L'élève a joué (et raté) sur le SOMMET : il a donc un `scope` et une erreur nommée.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, variant)
VALUES ('4d500000-0000-0000-0000-000000000001', '4d000000-0000-0000-0000-0000000000a1',
        '4d300000-0000-0000-0000-000000000001', 'classic');
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source, created_at)
VALUES ('4d000000-0000-0000-0000-0000000000a1', '4d400000-0000-0000-0000-000000000001',
        '4d200000-0000-0000-0000-000000000001', '4d500000-0000-0000-0000-000000000001',
        'b', false, 'rm.tag.erreur', 'exercise', now() - INTERVAL '1 hour');

-- P3 est en lacune confirmée : la voie compétence doit basculer vers ELLE.
-- ⚠️ `is_fallback = false` n'est pas un détail d'assertion : les cinq exercices de la fixture
-- vivent dans LE MÊME chapitre à la même difficulté, donc le repli de é11 lot 5 les ramène
-- tous. Sans ce filtre, l'assertion serait vraie avant même le rebranchement — elle
-- mesurerait le repli, pas la cause racine, et passerait au vert pour la mauvaise raison.
SELECT ok(
  EXISTS (
    SELECT 1 FROM public.get_targeted_exercises('rm.tag.erreur', 'rm.geo.sommet', 10) t
     WHERE t.exercise_id = '4d300000-0000-0000-0000-000000000004' AND NOT t.is_fallback
  ),
  '§3.13c : avec une lacune confirmée en amont, la sélection CIBLÉE sert la CAUSE RACINE'
);

-- Et maintenant la non-régression littérale : un élève SANS aucune croyance doit obtenir
-- exactement ce que la fonction de é11 lot 5 rendait. On compare la sortie complète, ligne à
-- ligne, à celle obtenue en neutralisant la seule chose que le lot ajoute (le passage par la
-- cause racine) — c'est-à-dire en appelant sans compétence, qui est la voie que le
-- rebranchement ne touche pas.
DELETE FROM public.user_competency_mastery WHERE user_id = '4d000000-0000-0000-0000-0000000000a1';

CREATE TEMP TABLE sans_croyance AS
  SELECT * FROM public.get_targeted_exercises('rm.tag.erreur', 'rm.geo.sommet', 10);

SELECT ok(
  (SELECT count(*) FROM sans_croyance) > 0
  AND NOT EXISTS (
    (SELECT * FROM sans_croyance
      EXCEPT ALL
     SELECT * FROM public.get_targeted_exercises('rm.tag.erreur', 'rm.geo.sommet', 10))
    UNION ALL
    (SELECT * FROM public.get_targeted_exercises('rm.tag.erreur', 'rm.geo.sommet', 10)
      EXCEPT ALL
     SELECT * FROM sans_croyance)
  ),
  'R-6 littéral : sans croyance, la sélection est IDENTIQUE (non vide) — ligne à ligne'
);

-- Et le détournement ne se produit PAS sur une simple faiblesse : `fragile` n'est pas
-- `lacune`. Accuser sur deux items est une erreur de mesure, pas un diagnostic (R-5) — et
-- détourner l'entraînement sur cette base enverrait l'élève au mauvais endroit.
SELECT pg_temp.believe('4d100000-0000-0000-0000-000000000003', 0.20, 2, 1, ARRAY['mcq']);

SELECT ok(
  NOT EXISTS (
    SELECT 1 FROM public.get_targeted_exercises('rm.tag.erreur', 'rm.geo.sommet', 10) t
     WHERE t.exercise_id = '4d300000-0000-0000-0000-000000000004' AND NOT t.is_fallback
  ),
  'R-5 : une compétence FRAGILE (2 preuves) ne détourne pas l''entraînement — seule une lacune le fait'
);

-- =========================================================
-- 13-14. Les stop-points.
-- =========================================================
-- La porte Q-8 hérite du rebranchement en APPELANT sa voisine : elle n'a pas été redéfinie,
-- et son seuil vit toujours en un seul endroit.
SELECT is(
  (SELECT count(*)::INT FROM pg_proc p
     JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public' AND p.proname = 'tutor_practice_needs_generation'),
  1,
  'Stop-point : la porte Q-8 existe toujours, en un seul exemplaire — elle n''a pas été touchée'
);

SELECT ok(
  (SELECT prosrc FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public' AND p.proname = 'tutor_practice_needs_generation')
    LIKE '%get_targeted_exercises%',
  'Stop-point : elle appelle sa voisine plutôt que de la recopier — donc elle hérite du rebranchement'
);

-- =========================================================
-- 16. La garde de session, sur les DEUX lectures (défaut du lot 3, corrigé ici).
-- =========================================================
-- `get_learning_frontier` levait `Unauthorized` pour un appelant sans session, au lieu de
-- rendre vide : elle appelle `get_exercises_for_competency`, qui appelle la porte d'accès,
-- qui LÈVE. Le §3.10 pose pourtant l'invariant sans exception. Aucun appelant d'aujourd'hui
-- n'arrive sans session (la server fn est derrière `requireSupabaseAuth`) — c'est exactement
-- le genre de défaut qui attend un nouvel appelant pour se voir.
SET LOCAL "request.jwt.claims" = '';

SELECT lives_ok(
  $$ SELECT count(*) FROM public.get_learning_frontier('rmfam', 3) $$,
  'Garde de session : la frontière rend vide sans session — elle ne LÈVE plus (défaut du lot 3)'
);

SELECT * FROM finish();
ROLLBACK;
