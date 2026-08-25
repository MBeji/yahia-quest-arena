-- =========================================================
-- Le pack du tuteur apprend la maîtrise (étude 30, lot 3bis · amendement D).
-- ---------------------------------------------------------
-- Ce que cette suite prouve :
--
--   1-2.  R-6, LITTÉRAL : sans aucune croyance, le pack est celui d'hier — comparé OCTET POUR
--         OCTET à une capture prise avant que le lot existe, et non « à peu près pareil ».
--   3-5.  Le bloc `mastery` : les trois listes, leurs plafonds (3 · 3 · 2), leur contenu.
--   6-7.  D-1, PAR ATTAQUE : on cherche `p_known` dans le JSON RENDU, pas dans les clés —
--         parce qu'une valeur peut fuir sous un autre nom.
--   8-9.  Les stop-points : rien d'autre de é11 n'est touché, et l'ordre des clés existantes
--         ne bouge pas.
--
-- La capture « d'hier » n'est pas une chaîne recopiée à la main : c'est le pack de é11 tel que
-- `20260823100000` le construisait, reconstruit ici par la même expression. Une divergence
-- entre les deux ferait échouer l'assertion 1 — ce qui est exactement le service attendu.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(9);

-- ---------------------------------------------------------
-- Fixtures : deux élèves — l'un sans aucune croyance (le contrôle R-6), l'autre pourvu.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('7a000000-0000-0000-0000-0000000000a1', 'pack-neuf@test.local'),
  ('7a000000-0000-0000-0000-0000000000b2', 'pack-pourvu@test.local');

INSERT INTO public.profiles (id, display_name, current_grade_id)
VALUES ('7a000000-0000-0000-0000-0000000000a1', 'Pack Neuf', NULL),
       ('7a000000-0000-0000-0000-0000000000b2', 'Pack Pourvu', NULL)
ON CONFLICT (id) DO NOTHING;

-- Un graphe : SOCLE → MOYENNE → HAUTE, et deux compétences terminales pour éprouver les
-- plafonds (4 maîtrisées possibles, on n'en veut que 3).
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('7a100000-0000-0000-0000-000000000001', 'pk.num.socle',   'pkfam', 'Socle', 'Base', 'أساس'),
  ('7a100000-0000-0000-0000-000000000002', 'pk.num.moyenne', 'pkfam', 'Moyenne', 'Middle', 'وسط'),
  ('7a100000-0000-0000-0000-000000000003', 'pk.geo.haute',   'pkfam', 'Haute', 'High', 'عال'),
  ('7a100000-0000-0000-0000-000000000004', 'pk.num.extra1',  'pkfam', 'Extra 1', 'Extra 1', 'إضافي ١'),
  ('7a100000-0000-0000-0000-000000000005', 'pk.num.extra2',  'pkfam', 'Extra 2', 'Extra 2', 'إضافي ٢'),
  ('7a100000-0000-0000-0000-000000000006', 'pk.num.extra3',  'pkfam', 'Extra 3', 'Extra 3', 'إضافي ٣');

INSERT INTO public.competency_prereqs (competency_id, prereq_id) VALUES
  ('7a100000-0000-0000-0000-000000000002', '7a100000-0000-0000-0000-000000000001'),
  ('7a100000-0000-0000-0000-000000000003', '7a100000-0000-0000-0000-000000000002');

CREATE OR REPLACE FUNCTION pg_temp.believe(
  p_user UUID, p_competency UUID, p_known NUMERIC, p_evidence INT, p_sessions INT,
  p_forms TEXT[], p_at TIMESTAMPTZ DEFAULT now()
) RETURNS void LANGUAGE sql AS $$
  INSERT INTO public.user_competency_mastery
    (user_id, competency_id, last_attempt_at, p_known, evidence_count, sessions_seen,
     forms_seen, last_evidence_at)
  VALUES (p_user, p_competency, p_at, p_known, p_evidence, p_sessions, p_forms, p_at);
$$;

CREATE OR REPLACE FUNCTION pg_temp.pack() RETURNS JSONB LANGUAGE sql AS $$
  SELECT public.get_tutor_learner_context();
$$;

-- =========================================================
-- 1-2. R-6 — le pack d'un élève sans croyance est celui d'hier, OCTET POUR OCTET.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"7a000000-0000-0000-0000-0000000000a1","role":"authenticated"}';

-- Le pack de é11 tel que `20260823100000` le construisait, reconstruit par la même expression.
-- Si le lot 3bis avait retiré, renommé ou réordonné une clé, cette égalité tomberait.
CREATE TEMP TABLE pack_avant AS
SELECT jsonb_build_object(
  'grade_slug', NULL::TEXT,
  'age_band',   public.tutor_age_band(NULL),
  'goal',       'scolaire',
  'level_band', 'debutant',
  'streak_band', 'aucune',
  'active_misconceptions', '[]'::jsonb,
  'interests', '{}'::TEXT[],
  'verbosity', 'normale'
) AS pack;

SELECT is(
  pg_temp.pack()::TEXT,
  (SELECT pack::TEXT FROM pack_avant),
  'R-6 : sans aucune croyance, le pack est celui d''hier — octet pour octet, sérialisation comprise'
);

SELECT ok(
  NOT (pg_temp.pack() ? 'mastery'),
  'R-6 : la clé `mastery` est ABSENTE, pas vide — une liste vide serait une ligne vide dans le prompt'
);

-- =========================================================
-- 3-5. Le bloc `mastery` : les trois listes et leurs plafonds.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"7a000000-0000-0000-0000-0000000000b2","role":"authenticated"}';

-- Quatre compétences maîtrisées (le plafond est à 3), de fraîcheur décroissante.
SELECT pg_temp.believe('7a000000-0000-0000-0000-0000000000b2', '7a100000-0000-0000-0000-000000000001',
                       0.97, 4, 2, ARRAY['mcq','numeric'], now() - INTERVAL '1 hour');
SELECT pg_temp.believe('7a000000-0000-0000-0000-0000000000b2', '7a100000-0000-0000-0000-000000000004',
                       0.97, 4, 2, ARRAY['mcq','numeric'], now() - INTERVAL '2 hours');
SELECT pg_temp.believe('7a000000-0000-0000-0000-0000000000b2', '7a100000-0000-0000-0000-000000000005',
                       0.97, 4, 2, ARRAY['mcq','numeric'], now() - INTERVAL '3 hours');
SELECT pg_temp.believe('7a000000-0000-0000-0000-0000000000b2', '7a100000-0000-0000-0000-000000000006',
                       0.97, 4, 2, ARRAY['mcq','numeric'], now() - INTERVAL '9 hours');
-- MOYENNE est une lacune confirmée : elle bloque HAUTE, donc elle est « ce qui te bloque ».
SELECT pg_temp.believe('7a000000-0000-0000-0000-0000000000b2', '7a100000-0000-0000-0000-000000000002',
                       0.10, 5, 2, ARRAY['mcq']);

SELECT is(
  jsonb_array_length(pg_temp.pack() #> '{mastery,mastered}'),
  3,
  'Plafond : au plus 3 compétences maîtrisées, même quand l''élève en a quatre'
);

SELECT is(
  (SELECT array_agg(x->>'slug' ORDER BY ord)
     FROM jsonb_array_elements(pg_temp.pack() #> '{mastery,mastered}')
          WITH ORDINALITY AS e(x, ord)),
  ARRAY['pk.num.socle','pk.num.extra1','pk.num.extra2']::TEXT[],
  '« les plus récentes » : la maîtrise de 9 h est écartée au profit des trois plus fraîches'
);

SELECT is(
  ARRAY[
    (pg_temp.pack() #>> '{mastery,frontier,0,slug}'),
    (pg_temp.pack() #>> '{mastery,blockers,0,slug}')
  ],
  ARRAY['pk.num.moyenne','pk.num.moyenne']::TEXT[],
  'Frontière et blocage : MOYENNE est jouable (son prérequis est acquis) ET bloque HAUTE'
);

-- =========================================================
-- 6-7. D-1, PAR ATTAQUE : la probabilité ne sort pas, sous aucun nom.
-- =========================================================
-- On ne teste pas « la clé p_known est-elle absente ? » — c'est trop facile à satisfaire par
-- un renommage. On cherche la VALEUR dans le texte rendu : le pack part vers un modèle qui
-- peut le répéter à l'élève, et une croyance recopiée dans une réponse est une croyance
-- affichée.
SELECT ok(
  (pg_temp.pack() #>> '{mastery}') NOT LIKE '%0.97%'
  AND (pg_temp.pack() #>> '{mastery}') NOT LIKE '%0.10%'
  AND (pg_temp.pack() #>> '{mastery}') NOT LIKE '%p_known%',
  'D-1 par attaque : aucune valeur de croyance dans le JSON du bloc — ni sous son nom, ni sans'
);

SELECT is_empty(
  $$ SELECT k FROM jsonb_array_elements(public.get_tutor_learner_context() #> '{mastery,mastered}') e,
          LATERAL jsonb_object_keys(e.value) k
      WHERE k NOT IN ('slug','state','label_fr','label_en','label_ar') $$,
  'D-1 : chaque entrée ne porte QUE slug, état et libellés — la liste des clés est fermée'
);

-- =========================================================
-- 8-9. Les stop-points : rien d'autre de é11 ne bouge.
-- =========================================================
SELECT is(
  (SELECT array_agg(k ORDER BY ord)
     FROM jsonb_object_keys(pg_temp.pack()) WITH ORDINALITY AS o(k, ord)
    WHERE k <> 'mastery'),
  (SELECT array_agg(k ORDER BY ord)
     FROM pack_avant, jsonb_object_keys(pack) WITH ORDINALITY AS o(k, ord)),
  'Stop-point : les clés existantes sont les mêmes, dans le même ordre — `mastery` s''ajoute, ne réordonne rien'
);

-- Le mini-check, le chat, les digests et l'énergie de é11 : aucune de leurs fonctions n'a été
-- redéfinie par ce lot. On le vérifie sur ce qui est observable — leur existence et leur
-- signature —, la preuve complète étant que leurs suites (70, 71, 73, 74) passent inchangées.
SELECT ok(
  to_regprocedure('public.submit_tutor_mini_check(uuid,text)') IS NOT NULL
  AND to_regprocedure('public.get_tutor_learner_context()') IS NOT NULL,
  'Stop-point : la signature du pack est inchangée, et le mini-check de é11 est intact'
);

SELECT * FROM finish();
ROLLBACK;
