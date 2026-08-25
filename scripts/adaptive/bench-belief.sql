-- Relevé de performance des triggers de croyance (étude 30, critère d'acceptation du lot 2).
--
-- POURQUOI CE FICHIER EXISTE. Le §3.3 de l'étude annonce un ordre de grandeur — « ≈ 3 lignes
-- en régime courant, 12 dans le pire cas théorique » — et refuse d'en faire une promesse :
-- « le lot 2 doit MESURER le coût réel du trigger avant/après sur la RPC de soumission, parce
-- que dans ce dépôt une réécriture SQL a déjà guéri un appelant et empoisonné l'autre ».
--
-- D'où la double mesure, sur les DEUX vraies RPC et non sur un INSERT nu :
--   * `submit_exercise_attempt` — une session entière, les 20 réponses en UN ordre ;
--   * `submit_dungeon_answer`   — une réponse par appel, 20 appels.
-- La différence n'est pas cosmétique : sur un ordre multi-lignes, un AFTER ROW voit toutes les
-- lignes de l'ordre, et le compteur de sessions du lot 1 fait un lookup par ligne. Mesurer un
-- seul appelant cacherait exactement le genre de dissymétrie que l'étude redoute.
--
-- MÉTHODE. « Avant » et « après » sont mesurés sur LA MÊME base, les MÊMES fixtures et la MÊME
-- session psql, en basculant les triggers avec `ALTER TABLE … DISABLE/ENABLE TRIGGER`. C'est
-- plus honnête qu'une comparaison entre deux commits : cela isole le coût des triggers sans y
-- mêler la variance de deux environnements ou de deux jeux de données. Les triggers de é04
-- (misconceptions) et é07 (EWMA) restent actifs partout — l'« avant » est bien l'état d'avant
-- l'étude 30, pas une base sans instrumentation.
--
-- USAGE (pile locale ou projet TEST — JAMAIS la prod, ce script ÉCRIT) :
--   psql "$DB_URL" -f scripts/adaptive/bench-belief.sql
--
-- Le script tourne dans une transaction qu'il ROLLBACK : il ne laisse rien derrière lui.
-- ⚠️ `DISABLE TRIGGER` pose un ACCESS EXCLUSIVE lock sur les tables concernées — inoffensif
-- dans une transaction jetable sur une base de test, à proscrire sur une base servie.

BEGIN;
SET LOCAL client_min_messages = WARNING;

-- ---------------------------------------------------------------------------
-- Fixtures : un graphe à la forme du graphe `math` mesuré (62 compétences,
-- ~1,3 prérequis en moyenne) et un exercice de 20 questions, toutes taggées.
-- ---------------------------------------------------------------------------
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar)
SELECT ('bb100000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       'bench.kg.c' || i, 'bench', 'C' || i, 'C' || i, 'C' || i
  FROM generate_series(1, 62) AS i;

-- Chaque compétence (à partir de la 4ᵉ) reçoit 1 à 2 prérequis parmi les précédentes : même
-- ordre de grandeur de fan-in que le graphe réel, donc même coût de remontée.
INSERT INTO public.competency_prereqs (competency_id, prereq_id)
SELECT DISTINCT
       ('bb100000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       ('bb100000-0000-0000-0000-' || lpad((1 + ((i * 7 + k * 13) % GREATEST(i - 1, 1)))::TEXT, 12, '0'))::UUID
  FROM generate_series(4, 62) AS i, generate_series(0, 1) AS k
 WHERE (1 + ((i * 7 + k * 13) % GREATEST(i - 1, 1))) <> i;

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('bench-subj', 'Bench', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('bb200000-0000-0000-0000-000000000001', 'bench-subj', 'Bench Chapter');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty, xp_reward, reward_coins)
VALUES ('bb300000-0000-0000-0000-000000000001', 'bb200000-0000-0000-0000-000000000001',
        'bench-subj', 'Bench', 'admin', 'practice', 2, 100, 20);

-- 20 questions — le minimum exigé par le critère — toutes taggées, donc toutes payantes :
-- c'est le pire cas réaliste, un chapitre entièrement couvert par la campagne de tagging.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, question_type, display_order)
SELECT ('bb400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       'bb300000-0000-0000-0000-000000000001', 'q' || i,
       '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb,
       'a', 'mcq', i
  FROM generate_series(1, 20) AS i;

-- Les 20 questions se répartissent sur 4 compétences seulement (5 items chacune) : c'est ce
-- qui fait FRANCHIR la bande de 0,85 en cours de série, donc ce qui met réellement la
-- propagation du lot 2 sur le chemin critique. Vingt compétences distinctes auraient donné un
-- « après » flatteur en ne déclenchant jamais l'inférence — le piège de ce genre de banc.
INSERT INTO public.question_competencies (question_id, competency_id, is_primary)
SELECT ('bb400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID,
       ('bb100000-0000-0000-0000-' || lpad((55 + (i % 4))::TEXT, 12, '0'))::UUID,
       true
  FROM generate_series(1, 20) AS i;

ANALYZE public.competency_prereqs;
ANALYZE public.question_competencies;
ANALYZE public.user_competency_mastery;

-- ---------------------------------------------------------------------------
-- Les deux bancs, sur les vraies RPC.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pg_temp.answers_payload() RETURNS JSONB LANGUAGE sql IMMUTABLE AS $$
  SELECT jsonb_agg(jsonb_build_object(
           'questionId', ('bb400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0')),
           'choice', CASE WHEN i % 5 = 0 THEN 'b' ELSE 'a' END))
    FROM generate_series(1, 20) AS i;
$$;

-- Un élève neuf par série : sinon les croyances saturent, les traversées de bande cessent, et
-- le banc mesurerait le cas le plus FAVORABLE en le prenant pour la moyenne.
CREATE OR REPLACE FUNCTION pg_temp.bench_exercise(p_label TEXT, p_rounds INT)
RETURNS TABLE (appelant TEXT, mesure TEXT, rondes INT, par_soumission_ms NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE v_start TIMESTAMPTZ; v_user UUID; v_session UUID;
BEGIN
  v_start := clock_timestamp();
  FOR r IN 1..p_rounds LOOP
    v_user := gen_random_uuid();
    INSERT INTO auth.users (id, email) VALUES (v_user, v_user || '@bench.local');
    v_session := gen_random_uuid();
    INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
    VALUES (v_session, v_user, 'bb300000-0000-0000-0000-000000000001',
            clock_timestamp() - INTERVAL '300 seconds');  -- passe la porte anti-farm
    PERFORM set_config('request.jwt.claims',
                       json_build_object('sub', v_user, 'role', 'authenticated')::TEXT, true);
    PERFORM public.submit_exercise_attempt(v_session, 'bb300000-0000-0000-0000-000000000001',
                                           pg_temp.answers_payload());
  END LOOP;
  RETURN QUERY SELECT 'submit_exercise_attempt (20 réponses en un ordre)', p_label, p_rounds,
    ROUND(EXTRACT(EPOCH FROM (clock_timestamp() - v_start))::NUMERIC * 1000 / p_rounds, 3);
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.bench_dungeon(p_label TEXT, p_rounds INT)
RETURNS TABLE (appelant TEXT, mesure TEXT, rondes INT, par_soumission_ms NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE v_start TIMESTAMPTZ; v_user UUID; v_run UUID;
BEGIN
  v_start := clock_timestamp();
  FOR r IN 1..p_rounds LOOP
    v_user := gen_random_uuid();
    INSERT INTO auth.users (id, email) VALUES (v_user, v_user || '@bench.local');
    v_run := gen_random_uuid();
    INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
    VALUES (v_run, v_user, 1, 'active');
    -- Un étage = une question (contrainte d'unicité de `dungeon_run_questions`), donc les
    -- 20 réponses gravissent 20 étages — exactement la boucle d'un vrai donjon.
    INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor)
    SELECT v_run, ('bb400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID, i
      FROM generate_series(1, 20) AS i;
    PERFORM set_config('request.jwt.claims',
                       json_build_object('sub', v_user, 'role', 'authenticated')::TEXT, true);
    FOR i IN 1..20 LOOP
      PERFORM public.submit_dungeon_answer(
        v_run, ('bb400000-0000-0000-0000-' || lpad(i::TEXT, 12, '0'))::UUID, 'a');
    END LOOP;
  END LOOP;
  RETURN QUERY SELECT 'submit_dungeon_answer (20 réponses, une par appel)', p_label, p_rounds,
    ROUND(EXTRACT(EPOCH FROM (clock_timestamp() - v_start))::NUMERIC * 1000 / p_rounds, 3);
END;
$$;

-- Chauffe : le premier passage paie les plans, le cache et l'expansion des fichiers.
SELECT * FROM pg_temp.bench_exercise('chauffe', 10);
SELECT * FROM pg_temp.bench_dungeon('chauffe', 5);

-- ---------------------------------------------------------------------------
-- AVANT — les deux triggers de l'étude 30 désactivés.
-- ---------------------------------------------------------------------------
ALTER TABLE public.question_attempts DISABLE TRIGGER trg_question_attempts_competency_belief;
ALTER TABLE public.user_competency_mastery DISABLE TRIGGER trg_ucm_belief_propagation;

SELECT * FROM pg_temp.bench_exercise('AVANT (é30 absente)', 50);
SELECT * FROM pg_temp.bench_dungeon('AVANT (é30 absente)', 25);

-- ---------------------------------------------------------------------------
-- APRÈS LOT 1 — la croyance, sans l'inférence. Cette mesure intermédiaire attribue
-- le coût au bon lot au lieu de le mettre en bloc sur le dernier arrivé.
-- ---------------------------------------------------------------------------
ALTER TABLE public.question_attempts ENABLE TRIGGER trg_question_attempts_competency_belief;

SELECT * FROM pg_temp.bench_exercise('APRÈS lot 1 (croyance)', 50);
SELECT * FROM pg_temp.bench_dungeon('APRÈS lot 1 (croyance)', 25);

-- ---------------------------------------------------------------------------
-- APRÈS LOT 2 — croyance + inférence dans le graphe.
-- ---------------------------------------------------------------------------
ALTER TABLE public.user_competency_mastery ENABLE TRIGGER trg_ucm_belief_propagation;

SELECT * FROM pg_temp.bench_exercise('APRÈS lot 2 (+ inférence)', 50);
SELECT * FROM pg_temp.bench_dungeon('APRÈS lot 2 (+ inférence)', 25);

-- ---------------------------------------------------------------------------
-- Combien de lignes une propagation touche-t-elle réellement sur ce graphe ?
-- C'est le nombre que le §3.3 estimait à « ≈ 3 en régime courant, 12 au pire ».
-- ---------------------------------------------------------------------------
SELECT
  'lignes déduites par propagation' AS mesure,
  COALESCE(ROUND(AVG(n), 2), 0)     AS moyenne,
  COALESCE(MAX(n), 0)               AS pire_cas,
  COALESCE(SUM(n), 0)               AS total
FROM (
  SELECT count(*) AS n
    FROM public.user_competency_mastery
   WHERE belief_source = 'inference'
   GROUP BY user_id, inferred_from
) AS per_propagation;

ROLLBACK;
