-- =========================================================
-- Tuteur déterministe — l'inférence dans le graphe (étude 30, lot 2).
-- ---------------------------------------------------------
-- Ce que cette suite prouve :
--
--   1-2.   Grants : ni la propagation ni son déclencheur ne sont joignables côté client.
--   3-6.   L'ARITHMÉTIQUE (annexe A.4) : γ^d · p, le maximum pris, la borne de profondeur.
--   7-10.  D-4, PAR ATTAQUE : on CHERCHE à faire déclarer une maîtrise sans preuve, et on
--          vérifie que c'est impossible — ni par une inférence, ni par une chaîne
--          d'inférences, ni en répétant cent fois l'opération.
--   11-14. LA TRAVERSÉE DE BANDE : la propagation ne tourne pas à chaque réponse.
--   15-17. L'ASYMÉTRIE (D-3/R-8) : une lacune confirmée ne baisse rien, elle marque.
--   18-20. R-6 et la reprise en main par la preuve.
--
-- Le graphe de fixture reproduit la forme mesurée du graphe `math` : une chaîne de
-- profondeur 3 (pour éprouver la borne à 2) et un losange (pour éprouver `UNION` et le
-- « plus court chemin »).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- ---------------------------------------------------------
-- Fixtures.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('1f000000-0000-0000-0000-0000000000a1', 'inference-student@test.local');

-- La chaîne : SOMMET → P1 → P2 → P3 (P3 est à la profondeur 3, hors de portée).
-- Le losange : SOMMET → {P1, Q1} → P2 — P2 est donc atteignable par deux chemins de
-- longueur 2 ; c'est le cas que `UNION ALL` compterait deux fois.
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('1f100000-0000-0000-0000-000000000000', 'test.inf.sommet', 'test', 'Sommet', 'Peak', 'قمة'),
  ('1f100000-0000-0000-0000-000000000001', 'test.inf.p1',     'test', 'P1', 'P1', 'ب١'),
  ('1f100000-0000-0000-0000-000000000002', 'test.inf.p2',     'test', 'P2', 'P2', 'ب٢'),
  ('1f100000-0000-0000-0000-000000000003', 'test.inf.p3',     'test', 'P3', 'P3', 'ب٣'),
  ('1f100000-0000-0000-0000-000000000004', 'test.inf.q1',     'test', 'Q1', 'Q1', 'ق١'),
  ('1f100000-0000-0000-0000-000000000005', 'test.inf.isole',  'test', 'Isolé', 'Lone', 'منعزل');

INSERT INTO public.competency_prereqs (competency_id, prereq_id) VALUES
  ('1f100000-0000-0000-0000-000000000000', '1f100000-0000-0000-0000-000000000001'),
  ('1f100000-0000-0000-0000-000000000000', '1f100000-0000-0000-0000-000000000004'),
  ('1f100000-0000-0000-0000-000000000001', '1f100000-0000-0000-0000-000000000002'),
  ('1f100000-0000-0000-0000-000000000004', '1f100000-0000-0000-0000-000000000002'),
  ('1f100000-0000-0000-0000-000000000002', '1f100000-0000-0000-0000-000000000003');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('inf-subj', 'Inference Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('1f200000-0000-0000-0000-000000000001', 'inf-subj', 'Inference Chapter');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty)
VALUES ('1f300000-0000-0000-0000-000000000001', '1f200000-0000-0000-0000-000000000001',
        'inf-subj', 'd2', 'admin', 'practice', 2);

-- Une saisie libre (G = 0,02) : un seul item juste porte la croyance à 0,932 et franchit
-- donc la bande de 0,85 d'un coup. C'est le chemin le plus court vers une propagation, et
-- il est réaliste — c'est exactement ce que le rappel actif produit.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, question_type, answer_key, display_order) VALUES
  ('1f400000-0000-0000-0000-000000000001', '1f300000-0000-0000-0000-000000000001', 'q sommet',
   '[]'::jsonb, NULL, 'short_answer', '{"accepted":["x"]}'::jsonb, 1),
  ('1f400000-0000-0000-0000-000000000002', '1f300000-0000-0000-0000-000000000001', 'q mcq sommet',
   '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb,
   'a', 'mcq', NULL, 2);
INSERT INTO public.question_competencies (question_id, competency_id, is_primary) VALUES
  ('1f400000-0000-0000-0000-000000000001', '1f100000-0000-0000-0000-000000000000', true),
  ('1f400000-0000-0000-0000-000000000002', '1f100000-0000-0000-0000-000000000000', true);

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, variant) VALUES
  ('1f500000-0000-0000-0000-000000000001', '1f000000-0000-0000-0000-0000000000a1',
   '1f300000-0000-0000-0000-000000000001', 'classic');

CREATE OR REPLACE FUNCTION pg_temp.answer(p_question UUID, p_correct BOOLEAN)
RETURNS void LANGUAGE sql AS $$
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, source)
  VALUES ('1f000000-0000-0000-0000-0000000000a1', p_question,
          '1f200000-0000-0000-0000-000000000001', '1f500000-0000-0000-0000-000000000001',
          'a', p_correct, 'exercise');
$$;

CREATE OR REPLACE FUNCTION pg_temp.row_of(p_competency UUID)
RETURNS public.user_competency_mastery LANGUAGE sql AS $$
  SELECT m.* FROM public.user_competency_mastery m
   WHERE m.user_id = '1f000000-0000-0000-0000-0000000000a1' AND m.competency_id = p_competency;
$$;

-- =========================================================
-- 1-2. Grants.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.propagate_competency_belief(uuid,uuid,numeric,boolean)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.propagate_competency_belief(uuid,uuid,numeric,boolean)', 'EXECUTE'),
  'Sécurité : la propagation n''est exécutable par aucun rôle client'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.trigger_belief_propagation()', 'EXECUTE'),
  'Sécurité : le déclencheur non plus — on ne déduit pas depuis un navigateur'
);

-- =========================================================
-- 3-6. L'ARITHMÉTIQUE (annexe A.4).
-- Un élève établit p_known = 0,88 sur le sommet. P2 part de 0,500, Q1 de 0,300.
-- =========================================================
INSERT INTO public.user_competency_mastery
  (user_id, competency_id, last_attempt_at, p_known, evidence_count, sessions_seen, forms_seen)
VALUES
  ('1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000004', now(), 0.300, 2, 1, ARRAY['mcq']),
  ('1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000002', now(), 0.500, 3, 2, ARRAY['mcq','numeric']);

SELECT is(
  public.propagate_competency_belief(
    '1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000000', 0.88, false),
  2,
  'A.4 : la propagation n''écrit QUE ce qu''elle améliore — P1 et Q1, pas P2 (déjà mieux informé)'
);

SELECT is(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000004')).p_known,
  0.6160::NUMERIC,
  'A.4 : profondeur 1 — 0,300 devient 0,7 × 0,88 = 0,616'
);

SELECT is(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000002')).p_known,
  0.5000::NUMERIC,
  'A.4 · D-3 : profondeur 2 — 0,49 × 0,88 = 0,4312 < 0,500, donc RIEN NE BOUGE (on ne baisse jamais)'
);

SELECT ok(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000003')) IS NULL,
  'R-7 : la profondeur 3 est hors de portée — P3 n''a toujours aucune ligne'
);

-- =========================================================
-- 7-9. D-4, PAR ATTAQUE : faire déclarer une maîtrise sans preuve.
-- =========================================================
-- Attaque 1 — la croyance la plus haute possible sur le sommet (0,99).
SELECT public.propagate_competency_belief(
  '1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000000', 0.99, false);

SELECT ok(
  (SELECT max(p_known) FROM public.user_competency_mastery
    WHERE user_id = '1f000000-0000-0000-0000-0000000000a1'
      AND belief_source = 'inference') = 0.6930,
  'R-9 par attaque : depuis 0,99, le mieux qu''une déduction produise est 0,7 × 0,99 = 0,693'
);

-- ⚠️ CE QUE L'ASSERTION PRÉCÉDENTE APPREND, ET QUI N'EST PAS DANS L'ÉTUDE : le plafond de
-- 0,90 (R-9) n'est JAMAIS atteint. Avec γ = 0,7 et une croyance bornée à 0,99, une déduction
-- de profondeur 1 plafonne arithmétiquement à 0,693, et la profondeur 2 à 0,485. Le vrai
-- garant de R-9 est donc l'AMORTISSEMENT, pas le plafond — celui-ci est une seconde ceinture,
-- qui ne servirait qu'à un γ relevé au-delà de 0,96. C'est une bonne nouvelle (la propriété
-- tient deux fois), pas une invitation à retirer le plafond : il documente l'intention.
SELECT ok(
  (SELECT max(p_known) FROM public.user_competency_mastery
    WHERE user_id = '1f000000-0000-0000-0000-0000000000a1'
      AND belief_source = 'inference') < 0.95,
  'R-9 : une croyance déduite reste sous le seuil de maîtrise — par amortissement ET par plafond'
);

-- Attaque 2 — cent propagations d'affilée : une accumulation ne doit pas devenir une preuve.
CREATE TEMP TABLE evidence_before AS
  SELECT competency_id, evidence_count, sessions_seen, forms_seen, mastery, attempts
    FROM public.user_competency_mastery
   WHERE user_id = '1f000000-0000-0000-0000-0000000000a1';

DO $$ BEGIN
  FOR i IN 1..100 LOOP
    PERFORM public.propagate_competency_belief(
      '1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000000', 0.99, false);
  END LOOP;
END $$;

-- La preuve ne se compare pas à une constante mais à l'état d'AVANT : ce qui compte est que
-- les cent propagations n'aient rien ajouté au compteur de preuves, quel qu'il fût.
SELECT is_empty(
  $$ SELECT m.competency_id FROM public.user_competency_mastery m
       JOIN evidence_before b USING (competency_id)
      WHERE m.user_id = '1f000000-0000-0000-0000-0000000000a1'
        AND (m.evidence_count IS DISTINCT FROM b.evidence_count
             OR m.sessions_seen IS DISTINCT FROM b.sessions_seen
             OR m.forms_seen IS DISTINCT FROM b.forms_seen
             OR m.mastery IS DISTINCT FROM b.mastery
             OR m.attempts IS DISTINCT FROM b.attempts) $$,
  'D-4 par attaque : cent inférences ne touchent NI preuve, NI forme, NI session, NI l''EWMA de é07'
);

-- Attaque 3 — la conjonction complète de R-4 sur une ligne déduite.
SELECT is_empty(
  $$ SELECT 1 FROM public.user_competency_mastery
      WHERE user_id = '1f000000-0000-0000-0000-0000000000a1'
        AND belief_source = 'inference'
        AND p_known >= 0.95 AND evidence_count >= 4
        AND sessions_seen >= 2 AND array_length(forms_seen, 1) >= 2 $$,
  'R-4/R-9 : aucune ligne déduite ne satisfait les cinq conditions de la maîtrise déclarée'
);

-- =========================================================
-- 10-13. LA TRAVERSÉE DE BANDE.
-- =========================================================
DELETE FROM public.user_competency_mastery WHERE user_id = '1f000000-0000-0000-0000-0000000000a1';

-- Un QCM juste porte le sommet à 0,5573 : sous la bande, donc rien ne se propage.
SELECT pg_temp.answer('1f400000-0000-0000-0000-000000000002', true);

SELECT is(
  (SELECT count(*)::int FROM public.user_competency_mastery
    WHERE user_id = '1f000000-0000-0000-0000-0000000000a1'),
  1,
  'Bande : une croyance à 0,557 ne franchit pas 0,85 — aucun prérequis n''est relevé'
);

-- Une saisie libre juste porte le sommet de 0,5573 à 0,9645 : la bande est franchie.
SELECT pg_temp.answer('1f400000-0000-0000-0000-000000000001', true);

SELECT ok(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).p_known > 0.60
  AND (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).belief_source = 'inference'
  AND (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).inferred_from
      = '1f100000-0000-0000-0000-000000000000',
  'Bande : le franchissement de 0,85 relève les prérequis, tracés (D-5) vers leur source'
);

-- La ligne déduite est-elle repartie en cascade ? P3 le dirait.
SELECT ok(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000003')) IS NULL,
  'Stop-point : une ligne écrite par inférence NE propage PAS — la profondeur reste 2, pas 3'
);

-- Re-franchissement : l'élève répond encore juste, mais il était DÉJÀ au-dessus de la bande.
-- La propagation ne doit pas retourner — c'est la moitié du budget de perf du lot.
CREATE TEMP TABLE after_first_crossing AS
  SELECT competency_id, p_known, belief_source FROM public.user_competency_mastery
   WHERE user_id = '1f000000-0000-0000-0000-0000000000a1';

SELECT pg_temp.answer('1f400000-0000-0000-0000-000000000001', true);

SELECT is_empty(
  $$ SELECT m.competency_id FROM public.user_competency_mastery m
       JOIN after_first_crossing a USING (competency_id)
      WHERE m.user_id = '1f000000-0000-0000-0000-0000000000a1'
        AND m.belief_source = 'inference'
        AND m.p_known IS DISTINCT FROM a.p_known $$,
  'Bande : déjà au-dessus de 0,85, une réponse de plus ne relance AUCUNE propagation'
);

-- =========================================================
-- 14-16. L'ASYMÉTRIE (D-3 / R-8) : une lacune ne baisse rien, elle marque.
-- =========================================================
DELETE FROM public.user_competency_mastery WHERE user_id = '1f000000-0000-0000-0000-0000000000a1';
INSERT INTO public.user_competency_mastery
  (user_id, competency_id, last_attempt_at, p_known, evidence_count, sessions_seen, forms_seen)
VALUES
  ('1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000001', now(), 0.700, 4, 2, ARRAY['mcq','numeric']),
  ('1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000004', now(), 0.400, 2, 1, ARRAY['mcq']);

-- Trois réponses fausses sur le sommet : la lacune devient CONFIRMÉE (R-5).
SELECT pg_temp.answer('1f400000-0000-0000-0000-000000000002', false) FROM generate_series(1, 3);

SELECT ok(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000000')).p_known <= 0.25
  AND (pg_temp.row_of('1f100000-0000-0000-0000-000000000000')).evidence_count >= 3,
  'R-5 : trois erreurs sur un QCM confirment la lacune (p ≤ 0,25 ET ≥ 3 preuves)'
);

SELECT is(
  ARRAY[(pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).p_known,
        (pg_temp.row_of('1f100000-0000-0000-0000-000000000004')).p_known],
  ARRAY[0.700, 0.400]::NUMERIC[],
  'D-3/R-8 : la lacune confirmée ne baisse AUCUNE croyance de prérequis — on n''accuse pas par déduction'
);

SELECT ok(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).suspect
  AND (pg_temp.row_of('1f100000-0000-0000-0000-000000000004')).suspect
  AND (pg_temp.row_of('1f100000-0000-0000-0000-000000000002')) IS NULL,
  'R-8 : elle les marque `suspect` (à sonder en priorité) et ne CRÉE aucune ligne au passage'
);

-- =========================================================
-- 17-19. R-6, et la reprise en main par la preuve.
-- =========================================================
-- Une compétence hors du graphe ne déclenche rien, même à croyance maximale.
SELECT is(
  public.propagate_competency_belief(
    '1f000000-0000-0000-0000-0000000000a1', '1f100000-0000-0000-0000-000000000005', 0.99, false),
  0,
  'R-6 : une compétence sans prérequis dans le graphe ne propage rien — zéro écriture'
);

-- Une preuve JOUÉE reprend la main sur une croyance déduite (D-4/D-5) : c'est ce qui rend
-- l'inférence révisable au lieu de définitive.
DELETE FROM public.user_competency_mastery WHERE user_id = '1f000000-0000-0000-0000-0000000000a1';
SELECT pg_temp.answer('1f400000-0000-0000-0000-000000000001', true);

INSERT INTO public.question_competencies (question_id, competency_id, is_primary)
VALUES ('1f400000-0000-0000-0000-000000000002', '1f100000-0000-0000-0000-000000000001', false);
SELECT pg_temp.answer('1f400000-0000-0000-0000-000000000002', false);

SELECT is(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).belief_source,
  'evidence',
  'D-5 : la première preuve réelle sur une compétence déduite reprend la main sur la source'
);

SELECT ok(
  (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).inferred_from IS NULL
  AND NOT (pg_temp.row_of('1f100000-0000-0000-0000-000000000001')).suspect,
  'D-5 : et elle efface la trace de la déduction — on n''est plus dispensé, on a joué'
);

SELECT * FROM finish();
ROLLBACK;
