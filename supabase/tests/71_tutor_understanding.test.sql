-- =========================================================
-- Étude 11, lot 4 — la BOUCLE DE COMPRÉHENSION et ses escalades.
-- ---------------------------------------------------------
-- Trois familles d'invariants, et chacune protège une règle qu'un correctif
-- « juste pour encourager » casserait sans faire rougir un seul test existant :
--
--   R-11 — le mini-check ne verse RIEN. Zéro XP, zéro pièce, aucune ligne dans
--          `attempts` ni dans `spaced_repetition_schedule`. Récompenser un
--          diagnostic en ferait une façon de farmer en se trompant exprès.
--   R-16 — la clé de réponse ne sort pas avec la question. Elle n'arrive
--          qu'APRÈS la soumission, par `submit_tutor_mini_check`.
--   R-8  — les trois signaux (a/b/c) sont OBJECTIFS et le niveau qu'ils
--          recommandent est déterministe.
--   Q-5  — le parent voit des COMPTEURS et des THÈMES ; jamais le verbatim, et
--          rien du tout sans lien actif.
--
-- ⚠️ CE QUE CE FICHIER NE TESTE PAS, ET OÙ ÇA L'EST : les huit cases de la
-- matrice (a, b, c). Quatre sont éprouvées ici sur un vrai historique d'élève ;
-- les huit le sont sans base dans `src/features/tutor/__tests__/
-- tutor-escalation.test.ts`, qui porte le MIROIR du `CASE` SQL. Fabriquer huit
-- historiques ici pour re-prouver une table de vérité serait long et fragile.
--
-- ⚠️ PIÈGE DE FIXTURE (précédent #817) : `exercises.source` n'accepte que
-- 'admin' | 'parent', et `question_attempts.source` que
-- 'exercise'|'quiz'|'dungeon'|'exam'. Une valeur inventée avorte le fichier
-- AVANT la première assertion — et le TAP est alors vide, pas rouge.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(38);

-- ---------------------------------------------------------
-- Décor : une matière SANS parcours (donc `resolve_exercise_access` autorise —
-- « unmapped subject -> always allowed »), un chapitre, un exercice, deux
-- questions taguées sur la MÊME misconception. La question 2 est le candidat
-- naturel du mini-check de la question 1.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('uc-theme', 'UC Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('e7000000-0000-4000-8000-0000000000f1'::uuid, 'uc-theme', 'uc-9', 'UC 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('uc-subj', 'UC Maths', 'Esprit', 'subject-math', 'Brain', 'uc-theme',
        'e7000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content, display_order)
VALUES ('e7000000-0000-4000-8000-0000000000c1'::uuid, 'uc-subj', 'UC Fractions',
        'Résumé UC', 'On garde le dénominateur commun.', 1);

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES ('e7000000-0000-4000-8000-0000000000e1'::uuid,
        'e7000000-0000-4000-8000-0000000000c1'::uuid, 'uc-subj', 'UC Ex', 1, 'practice', 'admin');

-- `distractor_tags` porte le tag PAR OPTION : c'est cette colonne (serveur-seul)
-- que `get_tutor_mini_check` lit pour trouver une question sur la même erreur.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, explanation, distractor_tags, display_order)
VALUES
  ('e7000000-0000-4000-8000-0000000000a1'::uuid, 'e7000000-0000-4000-8000-0000000000e1'::uuid,
   'UC question 1', '[{"id":"a","text":"3/4"},{"id":"b","text":"3/12"}]'::jsonb,
   'a', 'On garde le dénominateur commun.',
   '{"b":"uc.frac.add-denominators"}'::jsonb, 1),
  ('e7000000-0000-4000-8000-0000000000a2'::uuid, 'e7000000-0000-4000-8000-0000000000e1'::uuid,
   'UC question 2', '[{"id":"a","text":"2/5"},{"id":"b","text":"5/6"}]'::jsonb,
   'b', 'On met au même dénominateur avant d''ajouter.',
   '{"a":"uc.frac.add-denominators"}'::jsonb, 2);

-- `competency` reste NULL : c'est le cas NORMAL (la colonne est nullable sans
-- FK, décision de 20260802120000) et c'est lui qui fait DÉGRADER la marche
-- « prérequis » de l'escalade. Le tester est plus utile que de tester le cas
-- heureux, parce que c'est celui qui plantait si la fonction levait.
INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar)
VALUES ('uc.frac.add-denominators', 'math', 'Tu additionnes les dénominateurs',
        'You add the denominators', 'تجمع المقامات')
ON CONFLICT (tag) DO NOTHING;

INSERT INTO auth.users (id, email) VALUES
  ('e7000000-0000-4000-8000-000000000001', 'uc-eleve@test.local'),
  ('e7000000-0000-4000-8000-000000000002', 'uc-autre-eleve@test.local'),
  ('e7000000-0000-4000-8000-000000000003', 'uc-parent-actif@test.local'),
  ('e7000000-0000-4000-8000-000000000004', 'uc-parent-inactif@test.local');

-- Un parent LIÉ ACTIF, un parent dont le lien a été coupé. Le second est tout
-- l'intérêt du décor : `is_active = false` doit refuser, pas rendre du vide.
INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active) VALUES
  ('e7000000-0000-4000-8000-000000000003'::uuid, 'e7000000-0000-4000-8000-000000000001'::uuid, true),
  ('e7000000-0000-4000-8000-000000000004'::uuid, 'e7000000-0000-4000-8000-000000000001'::uuid, false);

-- L'élève a répondu FAUX à la question 1 : R-1 est franchie, et le tag est
-- connu. `session_id` est ici une session d'exercice ordinaire — donc PAS un
-- fil : ce point compte pour le signal (a), qui ne doit compter que les
-- mini-checks.
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source, misconception_tag)
VALUES ('e7000000-0000-4000-8000-000000000001'::uuid,
        'e7000000-0000-4000-8000-0000000000a1'::uuid,
        'e7000000-0000-4000-8000-0000000000c1'::uuid,
        'e7000000-0000-4000-8000-0000000000b1'::uuid,
        'b', false, 'exercise', 'uc.frac.add-denominators');

-- Le fil ouvert par l'explication. C'est LUI que `submit_tutor_mini_check`
-- inscrira en `session_id`, et c'est ce qui rend le signal (a) calculable.
INSERT INTO public.tutor_threads
  (id, user_id, scope, question_id, lang, age_band, status)
VALUES ('e7000000-0000-4000-8000-00000000cafe'::uuid,
        'e7000000-0000-4000-8000-000000000001'::uuid, 'question',
        'e7000000-0000-4000-8000-0000000000a1'::uuid, 'fr', '12-14', 'active');

-- =========================================================
-- 1. US-4 — la question de vérification, et ce qu'elle NE dit PAS (R-16).
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"e7000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_mini_check('e7000000-0000-4000-8000-0000000000a1'::uuid))->>'served',
  'true',
  'US-4 : après une réponse soumise, le mini-check trouve une question du stock'
);

SELECT is(
  (public.get_tutor_mini_check('e7000000-0000-4000-8000-0000000000a1'::uuid))->>'question_id',
  'e7000000-0000-4000-8000-0000000000a2',
  'US-4 : jamais la question d''origine — re-servir la même mesurerait la mémoire'
);

SELECT is(
  (public.get_tutor_mini_check('e7000000-0000-4000-8000-0000000000a1'::uuid))->>'match',
  'tag',
  'US-4 : la sélection passe par le TAG de misconception quand il est connu'
);

-- ⭐ L'ASSERTION CENTRALE DE LA SECTION. La non-fuite vient de la projection
-- NOMMÉE : aucune de ces trois clés n'est construite dans le jsonb de sortie.
SELECT ok(
  NOT ((public.get_tutor_mini_check('e7000000-0000-4000-8000-0000000000a1'::uuid))
       ?| ARRAY['correct_option', 'explanation', 'distractor_tags']),
  'R-16 : la question de vérification sort SANS clé, sans explication et sans distractor_tags'
);

-- R-1 : le tuteur n'existe pas pendant une épreuve notée. La garde n'est pas
-- recopiée ici, elle est DÉLÉGUÉE à can_use_tutor — ce test vérifie qu'elle
-- l'est vraiment.
SET LOCAL ROLE postgres;
INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('e7000000-0000-4000-8000-0000000000d9'::uuid,
        'e7000000-0000-4000-8000-000000000001'::uuid, 1, 'active');
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_mini_check('e7000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_DUNGEON',
  'R-1 : un donjon en cours ferme le mini-check comme il ferme le tuteur'
);

SET LOCAL ROLE postgres;
UPDATE public.dungeon_runs SET status = 'completed'
 WHERE id = 'e7000000-0000-4000-8000-0000000000d9'::uuid;
SET LOCAL ROLE authenticated;

-- =========================================================
-- 2. La correction — juste, et SANS AUCUNE RÉCOMPENSE (R-11).
-- =========================================================
SELECT is(
  (public.submit_tutor_mini_check('e7000000-0000-4000-8000-0000000000a2'::uuid, 'b'))->>'correct',
  'true',
  'US-4 : la bonne option est reconnue côté serveur'
);

SELECT is(
  (public.submit_tutor_mini_check('e7000000-0000-4000-8000-0000000000a2'::uuid, 'a'))->>'correct',
  'false',
  'US-4 : la mauvaise option est reconnue côté serveur'
);

SELECT is(
  (public.submit_tutor_mini_check('e7000000-0000-4000-8000-0000000000a2'::uuid, 'a'))->>'tag',
  'uc.frac.add-denominators',
  'US-4 : le tag se résout depuis distractor_tags->>choice, comme à l''insert d''une quête'
);

RESET ROLE;

-- ⭐ LES TROIS ASSERTIONS QUI TIENNENT R-11. Aucune ne casserait si quelqu'un
-- ajoutait un award_xp « pour encourager » — c'est exactement pour ça qu'elles
-- sont écrites AVANT que l'envie n'en vienne à quiconque.
SELECT is(
  (SELECT count(*)::int FROM public.attempts
    WHERE user_id = 'e7000000-0000-4000-8000-000000000001'),
  0,
  'R-11 : aucune tentative d''exercice — un mini-check n''est pas une quête'
);

SELECT is(
  (SELECT xp + yahia_coins FROM public.profiles
    WHERE id = 'e7000000-0000-4000-8000-000000000001'),
  0,
  'R-11 : ni XP ni pièce — se vérifier ne rapporte rien, donc ne se farme pas'
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
    WHERE user_id = 'e7000000-0000-4000-8000-000000000001'),
  0,
  'R-11 : aucune échéance SM-2 — le mini-check ne pilote pas la mémorisation'
);

-- La télémétrie é04, elle, est bien écrite — et rattachée au FIL. C'est ce
-- rattachement qui rend le signal (a) calculable ; un gen_random_uuid() aurait
-- rendu ces lignes indistinguables d'une session de quête.
SELECT is(
  (SELECT count(*)::int
     FROM public.question_attempts qa
     JOIN public.tutor_threads t ON t.id = qa.session_id
    WHERE qa.user_id = 'e7000000-0000-4000-8000-000000000001'
      AND qa.question_id = 'e7000000-0000-4000-8000-0000000000a2'),
  3,
  'D-10 : chaque mini-check écrit UNE ligne de télémétrie, dont session_id EST le fil'
);

SELECT is(
  (SELECT DISTINCT source FROM public.question_attempts
    WHERE question_id = 'e7000000-0000-4000-8000-0000000000a2'),
  'exercise',
  'la seule valeur légale du CHECK est utilisée — ''tutor'' aurait avorté le fichier (#817)'
);

-- =========================================================
-- 3. R-8 — les trois signaux, construits sur un historique RÉEL.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"e7000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- Deux échecs au mini-check ont déjà eu lieu (section 2). Le signal (a) demande
-- DEUX, il est donc levé. La tentative de quête initiale, elle, ne compte pas :
-- son session_id n'est pas un fil.
SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'signal_a',
  'true',
  'R-8 (a) : deux échecs au mini-check sur le même tag lèvent le signal'
);

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'signal_b',
  'false',
  'R-8 (b) : aucune reformulation servie ⇒ le signal reste BAISSÉ (pas de faux positif)'
);

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'recommended_level',
  '1',
  'R-8 : (a) seul recommande la marche 1 — montrer le cours'
);

-- (b) : deux « Explique autrement » dans le fil, SUIVIS d'un échec. Les
-- messages sont datés d'il y a deux heures ; les échecs de la section 2 sont
-- postérieurs, donc « suivis d'un échec » est vrai. Ils sont trop RÉCENTS pour
-- (c), qui demande sept jours — c'est ce qui sépare les deux signaux ici.
SET LOCAL ROLE postgres;
UPDATE public.tutor_threads SET messages = jsonb_build_array(
  jsonb_build_object('role','student','kind','ask','content','?','at', now() - INTERVAL '3 hours'),
  jsonb_build_object('role','tutor','kind','explain','content','...','at', now() - INTERVAL '3 hours'),
  jsonb_build_object('role','student','kind','again','content','?','at', now() - INTERVAL '150 minutes'),
  jsonb_build_object('role','tutor','kind','reformulate','content','...','at', now() - INTERVAL '150 minutes'),
  jsonb_build_object('role','student','kind','again','content','?','at', now() - INTERVAL '2 hours'),
  jsonb_build_object('role','tutor','kind','reformulate','content','...','at', now() - INTERVAL '2 hours')
), variant_served = 3
 WHERE id = 'e7000000-0000-4000-8000-00000000cafe'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'signal_b',
  'true',
  'R-8 (b) : deux reformulations puis un échec lèvent le signal'
);

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'signal_c',
  'false',
  'R-8 (c) : des explications d''il y a deux heures ne sont pas « sept jours après »'
);

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'recommended_level',
  '2',
  'R-8 : (b) l''emporte sur (a) — les registres épuisés mènent au prérequis, pas au cours'
);

-- (c) : les mêmes explications, vieillies de huit jours. Le tag est ACTIF
-- (3 occurrences sur 2 sessions dans les 30 jours, seuil canonique
-- d'active_misconceptions) — donc l'incompréhension a duré une semaine malgré
-- deux explications servies.
SET LOCAL ROLE postgres;
UPDATE public.tutor_threads SET messages = jsonb_build_array(
  jsonb_build_object('role','student','kind','ask','content','?','at', now() - INTERVAL '9 days'),
  jsonb_build_object('role','tutor','kind','explain','content','...','at', now() - INTERVAL '9 days'),
  jsonb_build_object('role','student','kind','again','content','?','at', now() - INTERVAL '8 days'),
  jsonb_build_object('role','tutor','kind','reformulate','content','...','at', now() - INTERVAL '8 days'),
  jsonb_build_object('role','student','kind','again','content','?','at', now() - INTERVAL '8 days'),
  jsonb_build_object('role','tutor','kind','reformulate','content','...','at', now() - INTERVAL '8 days')
) WHERE id = 'e7000000-0000-4000-8000-00000000cafe'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'signal_c',
  'true',
  'R-8 (c) : un tag encore ACTIF sept jours après deux explications lève le signal'
);

SELECT is(
  (public.tutor_understanding_signal('uc.frac.add-denominators'))->>'recommended_level',
  '4',
  'R-8 : les TROIS signaux — et seulement les trois — mènent jusqu''au digest parent'
);

SELECT is(
  (public.tutor_understanding_signal('uc.inconnu'))->>'recommended_level',
  '0',
  'R-8 : un tag sans histoire ne lève rien — le silence est une réponse valide'
);

-- =========================================================
-- 4. L'escalade ORDONNÉE, et sa dégradation.
-- =========================================================
SELECT is(
  (public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid))->>'action',
  'lesson',
  'R-8 : la première marche est « montre-moi le cours », jamais le prérequis'
);

-- Le fil n'a PAS de chapter_id (portée question) : la cible se retrouve par
-- question → exercice → chapitre. C'est le COALESCE de la RPC qu'on teste ici.
-- ⚠️ ON REMET LE FIL A ZERO. Chaque appel CONSOMME une marche : deux
-- assertions sur « la premiere marche » exigent deux points de depart
-- identiques, sinon la seconde observe la deuxieme marche et echoue.
SET LOCAL ROLE postgres;
UPDATE public.tutor_threads SET escalation_level = 0
 WHERE id = 'e7000000-0000-4000-8000-00000000cafe'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  ((public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid))->'target')->>'chapter_id',
  'e7000000-0000-4000-8000-0000000000c1',
  'la cible du cours se retrouve par la QUESTION quand le fil ne porte pas de chapitre'
);

-- ⭐ LA DÉGRADATION. `misconceptions.competency` est NULL, donc la marche
-- « prérequis » est impraticable : elle doit passer à la suivante, pas lever.
SELECT isnt(
  (public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid))->>'action',
  'prerequisite',
  'R-8 : sans compétence associée au tag, la marche « prérequis » se DÉGRADE au lieu de lever'
);

-- Le niveau STOCKÉ est celui réellement atteint. Écrire 2 quand on a montré le
-- plan ferait mentir l'historique sur lequel le digest parent raisonnera.
SELECT ok(
  (SELECT escalation_level FROM public.tutor_threads
    WHERE id = 'e7000000-0000-4000-8000-00000000cafe'::uuid) >= 3,
  'l''historique enregistre le niveau ATTEINT, pas le niveau visé'
);

-- Le plafond est dans le CHECK ; au sommet on re-mentionne au parent, on ne
-- déborde pas et on ne lève pas.
-- `lives_ok` plutôt qu'un `SELECT` nu : un SELECT nu émettrait une ligne de
-- résultat au milieu du flux TAP, que le parseur compterait pour du bruit. Et
-- tant qu'à exécuter, autant affirmer quelque chose — que monter au-delà du
-- sommet ne lève pas.
SELECT lives_ok(
  $$ SELECT public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid) $$,
  'escalader encore au sommet ne lève pas (1/2)'
);

SELECT lives_ok(
  $$ SELECT public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid) $$,
  'escalader encore au sommet ne lève pas (2/2)'
);

SELECT is(
  (SELECT escalation_level FROM public.tutor_threads
    WHERE id = 'e7000000-0000-4000-8000-00000000cafe'::uuid),
  4,
  'R-8 : l''escalade plafonne à 4 — une marche de plus n''existe pas'
);

SELECT is(
  (public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid))->>'action',
  'parent_digest',
  'au sommet, l''escalade re-mentionne au parent au lieu de casser'
);

RESET ROLE;

-- Le fil d'un autre élève n'existe pas pour lui : l'appartenance est dans le
-- WHERE de l'UPDATE, pas dans un contrôle séparé qu'on pourrait oublier.
SET LOCAL "request.jwt.claims" = '{"sub":"e7000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.escalate_tutor_thread('e7000000-0000-4000-8000-00000000cafe'::uuid) $$,
  'P0001',
  'THREAD_NOT_FOUND',
  'le fil d''un autre élève est INTROUVABLE — pas « interdit », introuvable'
);

RESET ROLE;

-- =========================================================
-- 5. Q-5 — le compteur parent : des agrégats, et rien d'autre.
-- =========================================================
-- On fige un historique lisible : deux tours d'élève dans la semaine, un
-- troisième plus ancien. Les deux fenêtres doivent donc DIFFÉRER — un test où
-- 7 j et 30 j rendent le même nombre ne prouverait pas qu'elles sont distinctes.
SET LOCAL ROLE postgres;
UPDATE public.tutor_threads SET messages = jsonb_build_array(
  jsonb_build_object('role','student','kind','ask','content','ma question','at', now() - INTERVAL '2 days'),
  jsonb_build_object('role','tutor','kind','explain','content','ma réponse','at', now() - INTERVAL '2 days'),
  jsonb_build_object('role','student','kind','again','content','encore','at', now() - INTERVAL '1 day'),
  jsonb_build_object('role','student','kind','ask','content','vieille question','at', now() - INTERVAL '20 days')
), summary = 'un résumé qui ne doit JAMAIS sortir'
 WHERE id = 'e7000000-0000-4000-8000-00000000cafe'::uuid;

SET LOCAL "request.jwt.claims" = '{"sub":"e7000000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid))->>'interactions_7d',
  '2',
  'Q-5 : la fenêtre 7 jours ne compte que les tours de l''ÉLÈVE, pas ceux du tuteur'
);

SELECT is(
  (public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid))->>'interactions_30d',
  '3',
  'Q-5 : la fenêtre 30 jours est bien PLUS LARGE que celle de 7 jours'
);

SELECT is(
  ((public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid))->'top_themes'->0)->>'label_fr',
  'Tu additionnes les dénominateurs',
  'Q-5 : les thèmes arrivent avec leur LIBELLÉ, jamais en identifiant technique brut'
);

-- ⭐ L'ASSERTION CENTRALE DE Q-5. Le fil porte un `summary` et des `messages` ;
-- ni l'un ni l'autre ne doit apparaître dans ce que le parent reçoit.
SELECT ok(
  NOT ((public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid))
       ?| ARRAY['messages', 'summary'])
  AND (public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid))::text
      NOT LIKE '%ne doit JAMAIS sortir%',
  'Q-5 : AUCUN verbatim — ni les messages, ni le résumé du fil ne franchissent la RPC'
);

RESET ROLE;

-- ⭐ Le lien COUPÉ refuse. Un `is_active = false` qui rendrait des compteurs
-- vides au lieu de refuser laisserait un ex-tuteur, un parent séparé ou un
-- compte révoqué continuer à observer un mineur.
SET LOCAL "request.jwt.claims" = '{"sub":"e7000000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid) $$,
  'P0001',
  'NOT_LINKED',
  'Q-5 : un lien parent INACTIF est REFUSÉ — pas servi vide'
);

RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"e7000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.get_tutor_parent_counters('e7000000-0000-4000-8000-000000000001'::uuid) $$,
  'P0001',
  'NOT_LINKED',
  'Q-5 : un tiers sans aucun lien est refusé — et par un P0001, donc le GRANT existe bien'
);

-- =========================================================
-- 6. Les droits d'exécution.
-- =========================================================
-- `tutor_thread_tag` n'est GRANT à personne : c'est un facteur commun interne,
-- pas une surface publique. GRANT à `authenticated` en ferait une fonction
-- acceptant l'identifiant de fil d'AUTRUI, sans contrôle d'appartenance.
SELECT throws_ok(
  $$ SELECT public.tutor_thread_tag('e7000000-0000-4000-8000-00000000cafe'::uuid) $$,
  '42501',
  NULL,
  'tutor_thread_tag reste INTERNE — authenticated ne peut pas l''exécuter'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
