-- =========================================================
-- Étude 04, lot A2 — « Tes points faibles » (US-2) et le rapport parent (US-3).
-- ---------------------------------------------------------
-- Trois choses à prouver, et la première commande les deux autres :
--
--   1. R-2 est UN seuil, pas cinq. `active_misconceptions` décide, et elle
--      décide la même chose pour toutes les surfaces. On teste la matrice
--      complète : installée mais pas reproduite, reproduite mais pas installée,
--      installée et reproduite mais VIEILLE, et le cas nominal.
--   2. `get_my_weaknesses` ne montre que MES erreurs, jamais celles du voisin,
--      et jamais un tag que le vocabulaire ne sait pas mettre en phrase.
--   3. `_student_weakness_insights` lit les erreurs d'un AUTRE — c'est son rôle
--      dans le rapport parent — mais elle n'est pas appelable par un client.
--
-- ⚠️ Fixtures recopiées de `35_daily_plan.test.sql`, qui est vert : le lot d'hier
-- a perdu un tour de CI sur un `source = 'authored'` inventé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(14);

-- ---------------------------------------------------------
-- Décor minimal : un thème, une classe, une matière, un chapitre, un exercice,
-- une question. Deux élèves — le nôtre et le voisin.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('wk-theme', 'WK Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('e4000000-0000-4000-8000-0000000000f1'::uuid, 'wk-theme', 'wk-9', 'WK 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES ('wk-subj', 'WK Maths', 'Esprit', 'subject-math', 'Brain', 'wk-theme',
        'e4000000-0000-4000-8000-0000000000f1'::uuid);

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('e4000000-0000-4000-8000-0000000000c1'::uuid, 'wk-subj', 'WK Fractions');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, difficulty, display_order, source)
VALUES ('e4000000-0000-4000-8000-0000000000e1'::uuid,
        'e4000000-0000-4000-8000-0000000000c1'::uuid, 'wk-subj', 'WK Ex', 'practice', 1, 1, 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('e4000000-0000-4000-8000-0000000000a1'::uuid, 'e4000000-0000-4000-8000-0000000000e1'::uuid,
        'WK question', '[{"id":"a","text":"3/4"},{"id":"b","text":"3/12"}]'::jsonb,
        'a', 'On garde le dénominateur.', 1);

INSERT INTO auth.users (id, email) VALUES
  ('e4000000-0000-4000-8000-000000000001', 'wk-eleve@test.local'),
  ('e4000000-0000-4000-8000-000000000002', 'wk-voisin@test.local');

INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar, competency)
VALUES
  ('wk.nominal',   'math', 'Tu additionnes les dénominateurs', 'You add denominators', 'تجمع المقامات', 'math.frac.add-sous'),
  ('wk.peu',       'math', 'Erreur vue une seule fois',        'Seen once',            'خطأ مرّة واحدة', NULL),
  ('wk.une-seance','math', 'Erreur d''une seule séance',       'One session only',     'خطأ حصّة واحدة', NULL),
  ('wk.vieille',   'math', 'Erreur ancienne',                  'Old mistake',          'خطأ قديم',      NULL)
ON CONFLICT (tag) DO NOTHING;

-- La matrice R-2, écrite directement dans l'agrégat : c'est lui que la fonction lit.
INSERT INTO public.user_misconceptions (user_id, tag, occurrences, sessions_seen, last_seen_at)
VALUES
  -- nominal : installée (5), reproduite (3), récente
  ('e4000000-0000-4000-8000-000000000001'::uuid, 'wk.nominal',    5, 3, now() - INTERVAL '2 days'),
  -- installée mais UNE seule séance → hors seuil
  ('e4000000-0000-4000-8000-000000000001'::uuid, 'wk.une-seance', 7, 1, now() - INTERVAL '2 days'),
  -- reproduite mais vue deux fois seulement → hors seuil
  ('e4000000-0000-4000-8000-000000000001'::uuid, 'wk.peu',        2, 2, now() - INTERVAL '2 days'),
  -- installée ET reproduite, mais VIEILLE → hors seuil
  ('e4000000-0000-4000-8000-000000000001'::uuid, 'wk.vieille',    9, 4, now() - INTERVAL '45 days'),
  -- le voisin a la même erreur nominale : elle ne doit jamais apparaître chez nous
  ('e4000000-0000-4000-8000-000000000002'::uuid, 'wk.nominal',   12, 6, now() - INTERVAL '1 day');

-- La télémétrie qui porte la TENDANCE : 1 fois cette semaine, 3 la précédente.
-- Donc « ça s'améliore » — et c'est la seule source qui porte une date.
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source, misconception_tag, created_at)
SELECT 'e4000000-0000-4000-8000-000000000001'::uuid,
       'e4000000-0000-4000-8000-0000000000a1'::uuid,
       'e4000000-0000-4000-8000-0000000000c1'::uuid,
       gen_random_uuid(), 'b', false, 'exercise', 'wk.nominal', ts
  FROM unnest(ARRAY[
    now() - INTERVAL '2 days',
    now() - INTERVAL '9 days',
    now() - INTERVAL '10 days',
    now() - INTERVAL '11 days'
  ]) AS ts;

-- =========================================================
-- 1. R-2 — la matrice du seuil, à UN seul endroit.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e4000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.active_misconceptions('e4000000-0000-4000-8000-000000000001'::uuid)),
  1,
  'R-2 ⭐ : une seule des quatre erreurs est ACTIVE — installée, reproduite ET récente'
);

SELECT is(
  (SELECT tag FROM public.active_misconceptions('e4000000-0000-4000-8000-000000000001'::uuid)),
  'wk.nominal',
  'R-2 : c''est bien la nominale, pas une des trois qui rate un critère'
);

SELECT is(
  (SELECT min_occurrences FROM public.misconception_active_thresholds()),
  3,
  'les constantes de R-2 sont lisibles à UN endroit, et valent bien (3, 2, 30)'
);

SELECT is(
  (SELECT window_days FROM public.misconception_active_thresholds()),
  30,
  'la fenêtre est de 30 jours'
);

-- =========================================================
-- 2. A2.1 — « Tes points faibles ».
-- =========================================================
SELECT is(
  (SELECT count(*)::int FROM public.get_my_weaknesses(5)),
  1,
  'A2.1 : le panneau ne montre que les erreurs ACTIVES — il hérite du seuil, il ne le refait pas'
);

SELECT is(
  (SELECT label_fr FROM public.get_my_weaknesses(5)),
  'Tu additionnes les dénominateurs',
  'A2.1 : la PHRASE vient du registre — le tag n''est jamais destiné à l''écran (R-A1.2-1)'
);

SELECT is(
  (SELECT competency FROM public.get_my_weaknesses(5)),
  'math.frac.add-sous',
  'A2.1 : la compétence est rendue — c''est elle qui arme le geste « S''entraîner » (A12)'
);

SELECT is(
  (SELECT chapter_id FROM public.get_my_weaknesses(5)),
  'e4000000-0000-4000-8000-0000000000c1'::uuid,
  'A2.1 : le chapitre où l''erreur se commet le plus, pour « revoir le cours »'
);

SELECT is(
  (SELECT trend FROM public.get_my_weaknesses(5)),
  'improving',
  'A2.1 ⭐ : la tendance est MESURÉE — 1 fois cette semaine contre 3 la précédente'
);

SELECT is(
  (SELECT recent_7d FROM public.get_my_weaknesses(5)),
  1,
  'A2.1 : la fenêtre récente compte bien une occurrence'
);

-- Le voisin a la même erreur, en pire. Elle ne doit jamais traverser.
SELECT is(
  (SELECT count(*)::int FROM public.get_my_weaknesses(5) w WHERE w.occurrences = 12),
  0,
  'A2.1 ⭐ : les erreurs du voisin ne traversent pas — la fonction lit `auth.uid()`, pas un paramètre'
);

-- Un tag hors vocabulaire n'a pas de phrase : on l'omet plutôt que d'afficher un id.
SET LOCAL ROLE postgres;
INSERT INTO public.user_misconceptions (user_id, tag, occurrences, sessions_seen, last_seen_at)
VALUES ('e4000000-0000-4000-8000-000000000001'::uuid, 'wk.inconnue-du-registre', 8, 4, now());
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_my_weaknesses(5)),
  1,
  'A2.1 : un tag que le registre ne connaît pas est OMIS — jamais un identifiant technique à l''écran'
);

-- =========================================================
-- 3. A2.2 — le rapport parent.
-- =========================================================
SET LOCAL ROLE postgres;

SELECT is(
  jsonb_array_length(public._student_weakness_insights('e4000000-0000-4000-8000-000000000001'::uuid)),
  1,
  'A2.2 : le rapport parent voit les erreurs de l''ÉLÈVE — la fonction prend l''élève en paramètre'
);

SET LOCAL request.jwt.claims = '{"sub":"e4000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(
  NOT has_function_privilege('authenticated', 'public._student_weakness_insights(uuid)', 'EXECUTE'),
  'A2.2 ⭐ : un client ne peut PAS appeler la fonction du rapport — sinon n''importe qui lirait les erreurs de n''importe quel enfant'
);

SELECT * FROM finish();
ROLLBACK;
