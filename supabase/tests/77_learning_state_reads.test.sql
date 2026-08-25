-- =========================================================
-- Tuteur déterministe — les lectures & la carte à 4 états (étude 30, lot 3).
-- ---------------------------------------------------------
-- Ce que cette suite prouve :
--
--   1-3.   Grants : les deux lectures et la contestation sont réservées à `authenticated`,
--          fermées à `anon`.
--   4-8.   L'ÉTAT (R-4/R-5) : les cinq conditions de la maîtrise, chacune éprouvée seule —
--          c'est-à-dire qu'on vérifie surtout ce qui NE déclare PAS.
--   9-12.  LA ZONE (§3.4) : intérieur, frontière, hors-portée, et la compétence sans prérequis.
--   13-15. LA FRONTIÈRE : le tri par fan-out, l'exercice d'entrée qui vise la ZPD.
--   16-18. LA CONTESTATION (US-3/R-10) : elle annule une déduction, et RIEN d'autre.
--   19-21. R-6 et la sécurité : périmètre `auth.uid()`, aucune fuite entre élèves.
--
-- ⚠️ Ce que la suite NE fait PAS : vérifier que `p_known` n'atteint pas un écran. Ce n'est pas
-- vérifiable en SQL — la RPC le rend (la console d'admin en a besoin), et c'est le composant
-- qui doit s'abstenir. L'assertion correspondante est du Vitest, dans
-- `learning-state-map.test.tsx` : « aucun pourcentage de croyance dans le DOM rendu ».
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(21);

-- ---------------------------------------------------------
-- Fixtures : A → B → C, plus D isolée (sans prérequis).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('12000000-0000-0000-0000-0000000000a1', 'state-student-a@test.local'),
  ('12000000-0000-0000-0000-0000000000b2', 'state-student-b@test.local');

INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('12100000-0000-0000-0000-000000000001', 'ls.geo.avancee', 'lsfam', 'Avancée', 'Advanced', 'متقدم'),
  ('12100000-0000-0000-0000-000000000002', 'ls.geo.moyenne', 'lsfam', 'Moyenne', 'Middle', 'وسط'),
  ('12100000-0000-0000-0000-000000000003', 'ls.num.base',    'lsfam', 'Base', 'Base', 'أساس'),
  ('12100000-0000-0000-0000-000000000004', 'ls.num.isolee',  'lsfam', 'Isolée', 'Lone', 'وحيد');

-- A dépend de B, B dépend de C. D ne dépend de rien.
INSERT INTO public.competency_prereqs (competency_id, prereq_id) VALUES
  ('12100000-0000-0000-0000-000000000001', '12100000-0000-0000-0000-000000000002'),
  ('12100000-0000-0000-0000-000000000002', '12100000-0000-0000-0000-000000000003');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('ls-subj', 'Learning State', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('12200000-0000-0000-0000-000000000001', 'ls-subj', 'LS Chapter');

-- Trois exercices de paliers différents sur la MÊME compétence : c'est le choix que le
-- sélecteur ZPD doit trancher.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty, display_order) VALUES
  ('12300000-0000-0000-0000-000000000001', '12200000-0000-0000-0000-000000000001', 'ls-subj', 'facile', 'admin', 'practice', 1, 1),
  ('12300000-0000-0000-0000-000000000002', '12200000-0000-0000-0000-000000000001', 'ls-subj', 'moyen',  'admin', 'practice', 2, 2),
  ('12300000-0000-0000-0000-000000000003', '12200000-0000-0000-0000-000000000001', 'ls-subj', 'dur',    'admin', 'practice', 4, 3);

-- L'exercice « dur » est en saisie libre (G = 0,02) ; les deux autres sont des QCM à 4 options.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, question_type, answer_key, display_order) VALUES
  ('12400000-0000-0000-0000-000000000001', '12300000-0000-0000-0000-000000000001', 'q1',
   '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'mcq', NULL, 1),
  ('12400000-0000-0000-0000-000000000002', '12300000-0000-0000-0000-000000000002', 'q2',
   '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'mcq', NULL, 1),
  ('12400000-0000-0000-0000-000000000003', '12300000-0000-0000-0000-000000000003', 'q3',
   '[]'::jsonb, NULL, 'short_answer', '{"accepted":["x"]}'::jsonb, 1);

INSERT INTO public.question_competencies (question_id, competency_id, is_primary) VALUES
  ('12400000-0000-0000-0000-000000000001', '12100000-0000-0000-0000-000000000002', true),
  ('12400000-0000-0000-0000-000000000002', '12100000-0000-0000-0000-000000000002', true),
  ('12400000-0000-0000-0000-000000000003', '12100000-0000-0000-0000-000000000002', true);

CREATE OR REPLACE FUNCTION pg_temp.believe(
  p_user UUID, p_competency UUID, p_known NUMERIC, p_evidence INT, p_sessions INT,
  p_forms TEXT[], p_age INTERVAL DEFAULT INTERVAL '1 day', p_source TEXT DEFAULT 'evidence'
) RETURNS void LANGUAGE sql AS $$
  INSERT INTO public.user_competency_mastery
    (user_id, competency_id, last_attempt_at, p_known, evidence_count, sessions_seen,
     forms_seen, last_evidence_at, belief_source)
  VALUES (p_user, p_competency, now(), p_known, p_evidence, p_sessions, p_forms,
          now() - p_age, p_source)
  ON CONFLICT (user_id, competency_id) DO UPDATE SET
    p_known = EXCLUDED.p_known, evidence_count = EXCLUDED.evidence_count,
    sessions_seen = EXCLUDED.sessions_seen, forms_seen = EXCLUDED.forms_seen,
    last_evidence_at = EXCLUDED.last_evidence_at, belief_source = EXCLUDED.belief_source;
$$;

CREATE OR REPLACE FUNCTION pg_temp.state_of(p_slug TEXT) RETURNS TEXT LANGUAGE sql AS $$
  SELECT ls.state FROM public.get_learning_state('lsfam') ls WHERE ls.slug = p_slug;
$$;
CREATE OR REPLACE FUNCTION pg_temp.zone_of(p_slug TEXT) RETURNS TEXT LANGUAGE sql AS $$
  SELECT ls.zone FROM public.get_learning_state('lsfam') ls WHERE ls.slug = p_slug;
$$;

-- =========================================================
-- 1-3. Grants.
-- =========================================================
SELECT ok(
  has_function_privilege('authenticated', 'public.get_learning_state(text)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.get_learning_state(text)', 'EXECUTE'),
  'Grants : la carte est nominative — `authenticated` seul, jamais `anon`'
);
SELECT ok(
  has_function_privilege('authenticated', 'public.get_learning_frontier(text,integer)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.get_learning_frontier(text,integer)', 'EXECUTE'),
  'Grants : la frontière aussi'
);
SELECT ok(
  has_function_privilege('authenticated', 'public.dispute_inference(text)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.dispute_inference(text)', 'EXECUTE'),
  'Grants : contester est un geste d''élève connecté'
);

-- =========================================================
-- 4-8. L'ÉTAT (R-4/R-5) — surtout : ce qui NE déclare PAS.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"12000000-0000-0000-0000-0000000000a1","role":"authenticated"}';

SELECT is(pg_temp.state_of('ls.num.base'), 'inconnue',
  'État : sans aucune preuve, l''état est `inconnue` — une absence de jugement, pas un jugement');

-- Les cinq conditions réunies.
SELECT pg_temp.believe('12000000-0000-0000-0000-0000000000a1', '12100000-0000-0000-0000-000000000003',
                       0.97, 4, 2, ARRAY['mcq','short_answer']);
SELECT is(pg_temp.state_of('ls.num.base'), 'maitrisee',
  'R-4 : p ≥ 0,95 · 4 preuves · 2 sessions · 2 formes · fraîche → `maitrisee`');

-- Chaque condition retirée SEULE doit suffire à ne plus déclarer. C'est le vrai contenu de
-- R-4 : « répétée ET variée » n'a de sens que si chaque « et » peut faire échouer.
SELECT is(
  ARRAY[
    -- quatre fois la MÊME forme : le cas exact du n° 6 de l'annexe A.1
    (SELECT public.competency_state(0.99, 4, 2, 1, now())),
    -- une seule session : un bon jour n'est pas une maîtrise
    (SELECT public.competency_state(0.99, 4, 1, 2, now())),
    -- trois preuves seulement
    (SELECT public.competency_state(0.99, 3, 2, 2, now())),
    -- preuve périmée (R-4, 30 jours)
    (SELECT public.competency_state(0.99, 4, 2, 2, now() - INTERVAL '31 days'))
  ],
  ARRAY['en-cours','en-cours','en-cours','en-cours']::TEXT[],
  'R-4 : chacune des quatre conditions annexes, retirée SEULE, empêche la déclaration'
);

SELECT is(
  ARRAY[
    (SELECT public.competency_state(0.20, 3, 1, 1, now())),   -- lacune : ≥ 3 preuves
    (SELECT public.competency_state(0.20, 2, 1, 1, now())),   -- 2 preuves → fragile, pas lacune
    (SELECT public.competency_state(0.50, 9, 3, 3, now())),   -- sous 0,60 → fragile
    (SELECT public.competency_state(0.80, 9, 3, 3, now()))    -- entre les deux → en cours
  ],
  ARRAY['lacune','fragile','fragile','en-cours']::TEXT[],
  'R-5 : sous trois preuves on dit `fragile`, JAMAIS `lacune` — accuser sur deux items est une erreur de mesure'
);

SELECT is(
  (SELECT ls.forms_count FROM public.get_learning_state('lsfam') ls WHERE ls.slug = 'ls.num.base'),
  2,
  'La carte rend le NOMBRE de formes distinctes — de quoi dire « prouvé 4 fois, sous 2 formes »'
);

-- =========================================================
-- 9-12. LA ZONE (§3.4).
-- =========================================================
SELECT is(pg_temp.zone_of('ls.num.base'), 'interieur',
  'Zone : une compétence maîtrisée est à l''intérieur');

SELECT is(pg_temp.zone_of('ls.geo.moyenne'), 'frontiere',
  'Zone : tous ses prérequis directs sont maîtrisés → frontière, la ZPD rendue calculable');

SELECT is(pg_temp.zone_of('ls.geo.avancee'), 'hors-portee',
  'Zone : son prérequis direct ne l''est pas → hors-portée (pas interdite — R-17 — juste précédée d''une remontée)');

SELECT is(pg_temp.zone_of('ls.num.isolee'), 'frontiere',
  'Zone : une compétence SANS prérequis est dans la frontière — rien ne la bloque');

-- =========================================================
-- 13-15. LA FRONTIÈRE et le sélecteur ZPD.
-- =========================================================
-- `ls.geo.moyenne` débloque `ls.geo.avancee` (fan-out 1) ; `ls.num.isolee` n'en débloque
-- aucune (fan-out 0). Le pari pédagogique dit : d'abord ce qui ouvre le plus de portes.
SELECT is(
  (SELECT array_agg(fr.slug ORDER BY fr.unlocks DESC, fr.slug)
     FROM public.get_learning_frontier('lsfam', 5) fr),
  ARRAY['ls.geo.moyenne','ls.num.isolee']::TEXT[],
  '§3.4 : la frontière est triée par fan-out — à croyance égale, ce qui ouvre le plus de portes d''abord'
);

SELECT is(
  (SELECT fr.unlocks FROM public.get_learning_frontier('lsfam', 5) fr WHERE fr.slug = 'ls.geo.moyenne'),
  1,
  '§3.4 : le fan-out compte les compétences que celle-ci débloque'
);

-- Le sélecteur ZPD, en nombres. Croyance 0,20 sur `ls.geo.moyenne` :
--   d1 mcq4  : 0,20×0,90 + 0,80×0,25 = 0,380   → sous la ZPD
--   d2 mcq4  : 0,20×0,92 + 0,80×0,25 = 0,384   → sous la ZPD
--   d4 saisie: 0,20×0,95 + 0,80×0,02 = 0,206   → très sous la ZPD
-- Aucun ne tombe dans [0,55 ; 0,80] : le sélecteur doit donc prendre LE PLUS PROCHE du bord,
-- soit le d2 en QCM (0,384, à 0,166 de 0,55). C'est le cas le plus intéressant du sélecteur —
-- celui où la ZPD est vide et où il faut quand même choisir.
SELECT pg_temp.believe('12000000-0000-0000-0000-0000000000a1', '12100000-0000-0000-0000-000000000002',
                       0.20, 1, 1, ARRAY['mcq']);
SELECT is(
  (SELECT fr.entry_exercise_id FROM public.get_learning_frontier('lsfam', 5) fr
    WHERE fr.slug = 'ls.geo.moyenne'),
  '12300000-0000-0000-0000-000000000002'::UUID,
  '§3.4 : ZPD vide → l''exercice d''entrée est celui dont la P(réussite) est la PLUS PROCHE du bord'
);

-- =========================================================
-- 16-18. LA CONTESTATION (US-3 / R-10).
-- =========================================================
-- Une croyance gagnée à 0,40, puis relevée par déduction à 0,63.
SELECT pg_temp.believe('12000000-0000-0000-0000-0000000000a1', '12100000-0000-0000-0000-000000000004',
                       0.40, 2, 1, ARRAY['mcq']);
UPDATE public.user_competency_mastery
   SET p_known = 0.63, belief_source = 'inference', p_known_before = 0.40,
       inferred_from = '12100000-0000-0000-0000-000000000001'
 WHERE user_id = '12000000-0000-0000-0000-0000000000a1'
   AND competency_id = '12100000-0000-0000-0000-000000000004';

SELECT is(
  (SELECT d.p_known FROM public.dispute_inference('ls.num.isolee') d),
  0.40::NUMERIC,
  'R-10 : contester ramène la croyance à SA VALEUR D''AVANT la déduction — pas à un défaut'
);

SELECT ok(
  (SELECT m.suspect AND m.disputed_at IS NOT NULL AND m.belief_source = 'evidence'
          AND m.inferred_from IS NULL AND m.p_known_before IS NULL
     FROM public.user_competency_mastery m
    WHERE m.user_id = '12000000-0000-0000-0000-0000000000a1'
      AND m.competency_id = '12100000-0000-0000-0000-000000000004'),
  'R-10 : la compétence passe `suspect` (à sonder en priorité), la trace de déduction est effacée'
);

-- Contester ce qu'on a PROUVÉ n'a aucun effet : ce serait effacer ce que l'élève a fait.
SELECT is(
  (SELECT count(*)::INT FROM public.dispute_inference('ls.num.base')),
  0,
  'R-10 : une croyance gagnée par la PREUVE n''est pas contestable — elle n''est pas une opinion du système'
);

-- =========================================================
-- 19-21. Sécurité et périmètre (R-6).
-- =========================================================
-- L'élève B n'a rien joué : il voit la même carte, tous états `inconnue`. Aucune ligne de A.
SET LOCAL "request.jwt.claims" = '{"sub":"12000000-0000-0000-0000-0000000000b2","role":"authenticated"}';

SELECT is(
  (SELECT count(DISTINCT ls.state)::INT FROM public.get_learning_state('lsfam') ls),
  1,
  'R-6 : un élève neuf voit un seul état — `inconnue` — et jamais la croyance d''un autre'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.get_learning_state('lsfam') ls WHERE ls.p_known IS NOT NULL $$,
  'R-6 : aucune croyance ne fuit d''un élève à l''autre — le périmètre est auth.uid() en dur'
);

-- Sans session, la lecture rend VIDE de croyances au lieu de lever (posture é07 R-6). La carte
-- reste rendue — le catalogue de compétences est public — mais sans une seule ligne d'élève.
SET LOCAL "request.jwt.claims" = '';

SELECT is_empty(
  $$ SELECT 1 FROM public.get_learning_state('lsfam') ls
      WHERE ls.p_known IS NOT NULL OR ls.state <> 'inconnue' $$,
  'R-6 : sans session, la lecture ne lève pas — elle ne connaît simplement personne'
);

SELECT * FROM finish();
ROLLBACK;
