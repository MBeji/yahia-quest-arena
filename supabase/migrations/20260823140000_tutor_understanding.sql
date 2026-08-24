-- Étude 11 — lot 4 : la BOUCLE DE COMPRÉHENSION et ses escalades.
--
-- CE QUE CE LOT AJOUTE, ET CE QU'IL SE CONTENTE D'APPELER
-- ---------------------------------------------------------------------------
-- Il ajoute cinq RPC et PAS UNE TABLE. Tout le stockage nécessaire existait
-- déjà : `tutor_threads.escalation_level` a été posé par le lot 1 (« une
-- escalade se lit sur un historique »), la télémétrie d'erreur par é04, et la
-- Forge par é29 lot 4. Créer ici `tutor_mini_checks` ou
-- `tutor_generated_exercises` aurait fait un doublon de chacun des trois.
--
-- Il n'ARBITRE rien qui soit déjà arbitré ailleurs. Chaque garde est un APPEL :
--   * R-1 (anti-triche)          → can_use_tutor()
--   * accès au contenu           → resolve_exercise_access()
--   * « erreur active »          → active_misconceptions()  (seuils canoniques)
--   * lien parent                → is_parent_of_student()
--   * prérequis faibles          → get_competency_blockers()
--   * item du plan               → get_daily_plan()
-- Recopier l'un d'eux créerait un second juge sur la même question — la faute
-- que `20260823100000_active_misconceptions_canon.sql` vient précisément
-- d'éliminer en centralisant le triplet de seuils.
--
-- LA DÉCISION QUI MÉRITE D'ÊTRE DITE : LE MINI-CHECK ÉCRIT DANS LA TÉLÉMÉTRIE
-- ---------------------------------------------------------------------------
-- `submit_tutor_mini_check` insère une ligne dans `question_attempts`. Ce n'est
-- pas neutre : le trigger `record_user_misconception()` s'en saisit, incrémente
-- `user_misconceptions`, donc alimente `active_misconceptions`, donc
-- `get_daily_plan`, `get_my_weaknesses` ET le rapport parent.
--
-- C'est ASSUMÉ, et c'est même la condition du signal R-8 (a) : un élève qui
-- retombe dans la même erreur au mini-check se trompe RÉELLEMENT sur ce tag, et
-- le prétendre invisible fausserait le plan du jour dans l'autre sens. Ce qui
-- reste interdit, c'est la RÉCOMPENSE (R-11) — zéro XP, zéro pièce, aucun badge,
-- aucune ligne dans `attempts` ni dans `spaced_repetition_schedule`, aucun effet
-- sur le classement. Mesurer n'est pas récompenser.
--
-- LE PIÈGE DE `question_attempts.session_id`, ET POURQUOI C'EST LE FIL
-- ---------------------------------------------------------------------------
-- La colonne est `UUID NOT NULL` SANS clé étrangère : elle est polymorphe
-- (`exercise_sessions.id` | `dungeon_runs.id`). Un mini-check n'a pas de
-- session, mais il FAUT fournir une valeur — et le choix décide de deux choses.
--
-- On y met `tutor_threads.id`. Un `gen_random_uuid()` par mini-check aurait eu
-- deux conséquences, toutes deux fausses :
--   1. le signal (a) deviendrait INCALCULABLE — plus rien ne distinguerait une
--      tentative de mini-check d'une tentative de quête ;
--   2. pire, chaque échec compterait pour une SESSION nouvelle aux yeux de
--      `record_user_misconception()`, donc ferait franchir le seuil
--      « 2 sessions » à des tags qui ne le méritent pas — des erreurs actives
--      fabriquées, dans le plan du jour et dans le rapport parent.
-- Le fil est la seule valeur qui rende la jointure possible ET qui garde le
-- compte de sessions honnête (tous les mini-checks d'un fil = une session).
--
-- AGENTS.md : aucune table neuve ⇒ aucun GRANT de table. Les cinq fonctions
-- portent leur REVOKE/GRANT, et les deux qui lisent des colonnes serveur-seul
-- (`correct_option`, `explanation`, `distractor_tags` sont REVOKE au niveau
-- COLONNE depuis 20260610170000) sont SECURITY DEFINER par nécessité — la
-- non-fuite vient alors de la PROJECTION NOMMÉE, motif `serve_forged_quiz`.

-- ---------------------------------------------------------------------------
-- 1. US-4 — LE MINI-CHECK : « Vérifions ensemble ».
-- ---------------------------------------------------------------------------
-- Après une explication, une SEULE question du stock, sur la même erreur. Pas
-- un item généré : Q-8 n'autorise la génération qu'en repli conditionnel, et le
-- repli s'appelle la Forge (é29 lot 4), qui existe déjà.
--
-- R-16 — CE QUI SORT D'ICI : `prompt` et `options`, rien d'autre. Ni
-- `correct_option`, ni `explanation`, ni `distractor_tags`. La garantie ne vient
-- pas d'un retrait de clés après coup mais du fait qu'aucune des trois n'est
-- NOMMÉE dans le `jsonb_build_object` final. C'est le seul motif qui résiste à
-- l'ajout d'une colonne : un `SELECT *` moins deux clés aurait fuité la
-- troisième le jour où elle est arrivée.
--
-- R-15 — un refus est un ÉTAT, jamais une exception : `served: false` + un
-- motif que l'écran sait traduire.
CREATE OR REPLACE FUNCTION public.get_tutor_mini_check(p_question_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_gate    JSONB;
  v_tag     TEXT;
  v_chapter UUID;
  v_lang    TEXT;
  v_pick    RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  -- R-1 en entier, et par APPEL. `can_use_tutor` connaît les quatre refus et
  -- leur ordre ; recopier ici ses EXISTS ferait de cette fonction un second
  -- juge de l'anti-triche, qui divergerait au premier ajustement.
  v_gate := public.can_use_tutor('question', p_question_id);
  IF NOT (v_gate->>'allowed')::BOOLEAN THEN
    RETURN jsonb_build_object('served', false, 'reason', v_gate->>'reason');
  END IF;

  -- La DERNIÈRE tentative fait foi (motif `get_tutor_question_context`) : si
  -- l'élève a rejoué la question, c'est de sa dernière erreur qu'on le teste.
  SELECT a.misconception_tag, a.chapter_id
    INTO v_tag, v_chapter
    FROM public.question_attempts a
   WHERE a.user_id = v_user AND a.question_id = p_question_id
   ORDER BY a.created_at DESC
   LIMIT 1;

  -- La langue de SORTIE est celle de la MATIÈRE (R-3), pas celle de
  -- l'interface : un énoncé d'arabe ne se lit pas en français parce que l'écran
  -- est en français.
  SELECT CASE WHEN s.content_language IN ('fr', 'en', 'ar') THEN s.content_language ELSE 'fr' END
    INTO v_lang
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
    JOIN public.chapters  c ON c.id = e.chapter_id
    JOIN public.subjects  s ON s.id = c.subject_id
   WHERE q.id = p_question_id;

  -- Le vivier, puis l'accès. L'ordre des deux étapes est une décision de coût :
  -- `resolve_exercise_access` est une fonction par exercice, et la lancer sur
  -- tout le catalogue tagué pour n'en garder qu'une question serait absurde. On
  -- borne d'abord à 20 candidats ORDONNÉS, puis on filtre l'accès dessus.
  -- Conséquence assumée : si les 20 meilleurs sont tous hors parcours, on rend
  -- NO_CANDIDATE plutôt que de balayer plus loin. C'est le bon compromis —
  -- l'élève est par construction DANS un parcours qu'il a ouvert.
  WITH pool AS (
    SELECT q2.id,
           q2.prompt,
           q2.options,
           e.id         AS exercise_id,
           e.chapter_id AS chapter_id,
           e.difficulty AS difficulty,
           -- 1 = même erreur nommée, 2 = même compétence. Le rang porte la
           -- préférence de US-4 : on re-teste l'ERREUR quand on la connaît, et
           -- on retombe sur la compétence quand la question n'était pas taguée.
           CASE
             WHEN v_tag IS NOT NULL
              AND EXISTS (
                    SELECT 1 FROM jsonb_each_text(COALESCE(q2.distractor_tags, '{}'::jsonb)) dt
                     WHERE dt.value = v_tag
                  )
             THEN 1 ELSE 2
           END AS match_rank,
           (e.chapter_id = v_chapter) AS same_chapter
      FROM public.questions q2
      JOIN public.exercises e ON e.id = q2.exercise_id
     WHERE q2.id <> p_question_id
       -- Contenu du catalogue uniquement, et jamais un boss : un mini-check est
       -- une vérification, pas une épreuve.
       AND e.source = 'admin'
       AND e.mode = 'practice'
       AND (
             (v_tag IS NOT NULL AND EXISTS (
                SELECT 1 FROM jsonb_each_text(COALESCE(q2.distractor_tags, '{}'::jsonb)) dt
                 WHERE dt.value = v_tag))
          OR EXISTS (
                SELECT 1
                  FROM public.question_competencies qc1
                  JOIN public.question_competencies qc2
                    ON qc2.competency_id = qc1.competency_id
                 WHERE qc1.question_id = p_question_id
                   AND qc2.question_id = q2.id)
           )
       -- « Non vue récemment » : 30 jours, la même fenêtre que le seuil d'erreur
       -- active. Re-servir une question dont l'élève se souvient de la réponse
       -- mesurerait sa mémoire, pas sa compréhension.
       AND NOT EXISTS (
             SELECT 1 FROM public.question_attempts a2
              WHERE a2.user_id = v_user
                AND a2.question_id = q2.id
                AND a2.created_at >= now() - INTERVAL '30 days'
           )
     ORDER BY match_rank, same_chapter DESC, e.difficulty, q2.id
     LIMIT 20
  )
  SELECT p.id, p.prompt, p.options, p.chapter_id, p.match_rank
    INTO v_pick
    FROM pool p
    CROSS JOIN LATERAL public.resolve_exercise_access(p.exercise_id) acc
   WHERE acc.allowed
   ORDER BY p.match_rank, p.same_chapter DESC, p.difficulty, p.id
   LIMIT 1;

  IF NOT FOUND THEN
    -- Q-8 : c'est ICI que la génération deviendrait légitime, en repli. Elle
    -- n'est pas branchée dans ce lot, et l'écran doit donc savoir se taire
    -- plutôt qu'afficher un mini-check vide.
    RETURN jsonb_build_object('served', false, 'reason', 'NO_CANDIDATE', 'tag', v_tag);
  END IF;

  RETURN jsonb_build_object(
    'served',      true,
    'reason',      'OK',
    'question_id', v_pick.id,
    'prompt',      v_pick.prompt,
    'options',     v_pick.options,
    'chapter_id',  v_pick.chapter_id,
    'tag',         v_tag,
    'lang',        COALESCE(v_lang, 'fr'),
    -- 1 = même erreur, 2 = même compétence. L'écran n'en fait rien aujourd'hui ;
    -- l'admin et les tests s'en servent pour savoir POURQUOI cette question-là.
    'match',       CASE WHEN v_pick.match_rank = 1 THEN 'tag' ELSE 'competency' END
  );
END;
$$;

COMMENT ON FUNCTION public.get_tutor_mini_check(UUID) IS
  'US-4 (é11 lot 4) : sert UNE question du stock sur la même erreur, sans clé ni explication (R-16, projection nommée). R-1 déléguée à can_use_tutor, accès délégué à resolve_exercise_access.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_mini_check(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_mini_check(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. US-4 — LA CORRECTION, côté serveur, et SANS AUCUNE RÉCOMPENSE (R-11).
-- ---------------------------------------------------------------------------
-- `p_question_id` est ici la question du MINI-CHECK, pas la question d'origine.
--
-- ⚠️ R-1 EST RÉ-INTERROGÉE EN PORTÉE `chapter`, ET C'EST DÉLIBÉRÉ.
-- La portée `question` de `can_use_tutor` exige `NOT_ATTEMPTED = false` — elle
-- refuserait donc TOUTE première réponse à un mini-check, puisqu'un mini-check
-- est par construction une question jamais tentée. La portée `chapter` applique
-- exactement les gardes qui ont un sens ici : donjon actif, duel actif, session
-- d'exercice ouverte sur ce chapitre. Aucun EXISTS n'est recopié.
CREATE OR REPLACE FUNCTION public.submit_tutor_mini_check(
  p_question_id UUID,
  p_choice      TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_row     RECORD;
  v_gate    JSONB;
  v_correct BOOLEAN;
  v_tag     TEXT;
  v_thread  UUID;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  SELECT q.correct_option,
         q.explanation,
         q.distractor_tags,
         e.chapter_id,
         e.source AS exercise_source
    INTO v_row
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
   WHERE q.id = p_question_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'QUESTION_NOT_FOUND';
  END IF;

  v_gate := public.can_use_tutor('chapter', NULL, v_row.chapter_id);
  IF NOT (v_gate->>'allowed')::BOOLEAN THEN
    RETURN jsonb_build_object('graded', false, 'reason', v_gate->>'reason');
  END IF;

  v_correct := (p_choice = v_row.correct_option);
  -- Le tag se résout depuis `distractor_tags->>choice`, exactement comme à
  -- l'insert d'une tentative de quête (é04 A0.1) : une bonne réponse n'a pas de
  -- tag, et une option non taguée non plus.
  v_tag := CASE
             WHEN v_correct THEN NULL
             ELSE COALESCE(v_row.distractor_tags, '{}'::jsonb)->>p_choice
           END;

  -- Le fil actif le plus récent de l'élève : le mini-check est servi DANS un
  -- panneau ouvert, donc dans un fil. On ne fabrique jamais d'UUID (voir
  -- l'en-tête) ; sans fil, on renonce à la ligne de télémétrie plutôt que de
  -- polluer le compte de sessions. La correction, elle, est rendue quand même —
  -- R-15 : l'élève a droit à sa réponse même quand la comptabilité échoue.
  SELECT t.id INTO v_thread
    FROM public.tutor_threads t
   WHERE t.user_id = v_user AND t.status = 'active'
   ORDER BY t.updated_at DESC
   LIMIT 1;

  -- La télémétrie é04 reste PURE : seule une vraie question du catalogue y
  -- entre. Un item forgé (D-10) n'écrirait jamais ici — c'est la raison d'être
  -- du test sur `exercise_source`.
  IF v_thread IS NOT NULL AND v_row.exercise_source = 'admin' THEN
    INSERT INTO public.question_attempts
      (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source)
    VALUES
      (v_user, p_question_id, v_row.chapter_id, v_thread, p_choice, v_correct, v_tag, 'exercise');
  END IF;

  RETURN jsonb_build_object(
    'graded',         true,
    'reason',         'OK',
    'correct',        v_correct,
    'correct_option', v_row.correct_option,
    'explanation',    v_row.explanation,
    'tag',            v_tag
  );

  -- ⚠️ IL N'Y A RIEN APRÈS CE RETURN, ET C'EST LA RÈGLE (R-11).
  -- Pas d'award_xp, pas d'award_coins, pas de badge, pas de série, pas de ligne
  -- dans `attempts`, pas de `spaced_repetition_schedule`, aucun effet sur le
  -- classement. Le mini-check est un diagnostic, pas une quête : le récompenser
  -- en ferait une façon de farmer de l'XP en se trompant exprès.
  -- La seule écriture autorisée est celle du dessus, et pgTAP S71 vérifie
  -- l'absence des autres — parce qu'une récompense ajoutée « juste pour
  -- encourager » ne casserait aucun test existant.
END;
$$;

COMMENT ON FUNCTION public.submit_tutor_mini_check(UUID, TEXT) IS
  'US-4 (é11 lot 4) : corrige un mini-check côté serveur. ZÉRO récompense (R-11). Écrit une ligne question_attempts (source=exercise, session_id = le fil) uniquement pour une question du catalogue.';

REVOKE EXECUTE ON FUNCTION public.submit_tutor_mini_check(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_tutor_mini_check(UUID, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. Le tag visé par un fil — le petit pont dont R-8 (b) et (c) ont besoin.
-- ---------------------------------------------------------------------------
-- Un fil porte une QUESTION ; R-8 raisonne sur une ERREUR. Le pont est la
-- dernière tentative de l'élève sur cette question, comme partout ailleurs dans
-- la feature (`get_tutor_question_context`, `get_tutor_mini_check`).
--
-- Elle prend l'élève sur le FIL et non sur `auth.uid()` : la fonction répond
-- « quel tag vise ce fil », une question qui a la même réponse quel que soit
-- l'appelant. C'est aussi pourquoi elle n'est GRANT à personne — elle n'est pas
-- une surface publique, seulement un facteur commun des deux RPC ci-dessous,
-- qui, elles, ont déjà vérifié à qui appartient le fil.
CREATE OR REPLACE FUNCTION public.tutor_thread_tag(p_thread UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT a.misconception_tag
    FROM public.tutor_threads t
    JOIN public.question_attempts a
      ON a.question_id = t.question_id AND a.user_id = t.user_id
   WHERE t.id = p_thread
   ORDER BY a.created_at DESC
   LIMIT 1;
$$;

COMMENT ON FUNCTION public.tutor_thread_tag(UUID) IS
  'Le tag de misconception visé par un fil du tuteur (é11 lot 4) : la dernière tentative de son propriétaire sur sa question. Helper interne — aucun GRANT, appelé seulement depuis les RPC de ce fichier.';

-- Aucun GRANT : motif `record_user_misconception()`. Les fonctions SECURITY
-- DEFINER de ce fichier l'appellent en tant que propriétaire ; personne d'autre
-- n'a de raison de l'atteindre, et la GRANT à `authenticated` en ferait une
-- surface publique acceptant l'identifiant de fil d'autrui.
REVOKE EXECUTE ON FUNCTION public.tutor_thread_tag(UUID) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. R-8 — LES TROIS SIGNAUX D'INCOMPRÉHENSION PERSISTANTE.
-- ---------------------------------------------------------------------------
-- Trois, littéralement, et aucun quatrième. La tentation d'ajouter « et aussi
-- quand le score du chapitre baisse » est exactement ce que R-8 interdit : des
-- signaux OBJECTIFS, énumérés, calculés côté serveur — pas une intuition de
-- modèle ni une heuristique inventée en cours de route (R-10).
--
--   (a) échec au mini-check DEUX FOIS sur le même tag ;
--   (b) deux « Explique autrement » consécutifs SUIVIS d'un échec ;
--   (c) tag toujours ACTIF 7 jours après au moins 2 explications servies.
--
-- Le seuil d'« actif » n'est PAS recopié ici : `active_misconceptions()` le
-- porte pour toutes les surfaces à la fois. Le redéclarer serait la cinquième
-- copie que la migration 20260823100000 vient d'éliminer.
CREATE OR REPLACE FUNCTION public.tutor_understanding_signal(p_tag TEXT)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user     UUID := auth.uid();
  v_a        BOOLEAN := false;
  v_b        BOOLEAN := false;
  v_c        BOOLEAN := false;
  v_level    INT;
  v_explains INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;
  IF p_tag IS NULL THEN
    RAISE EXCEPTION 'BAD_TAG';
  END IF;

  -- (a) La jointure `session_id → tutor_threads.id` est ce qui distingue une
  -- tentative de MINI-CHECK d'une tentative de quête. C'est toute la raison
  -- d'être du choix de session_id documenté en tête de fichier.
  SELECT count(*) >= 2
    INTO v_a
    FROM public.question_attempts a
    JOIN public.tutor_threads t ON t.id = a.session_id AND t.user_id = v_user
   WHERE a.user_id = v_user
     AND a.misconception_tag = p_tag
     AND a.is_correct = false;

  -- (b) « Deux Explique autrement CONSÉCUTIFS » : dans un fil, rien ne s'insère
  -- entre deux reformulations du tuteur qu'un tour d'élève — le seul contenu
  -- pédagogique servi est `explain` puis `reformulate`. Deux `reformulate` dans
  -- le même fil sont donc consécutifs par construction, et `variant_served`
  -- (borné 0..3 en base) en est le compteur autoritaire.
  -- « Suivi d'un échec » : une tentative ratée sur ce tag APRÈS la 2e
  -- reformulation. On date par le message, pas par `updated_at` du fil — qui
  -- bouge à chaque écriture et daterait donc n'importe quoi.
  --
  -- `WITH ORDINALITY` et non l'ordre implicite de `jsonb_array_elements` : le
  -- fil est append-only, donc son ordre EST la chronologie, mais s'appuyer sur
  -- un ordre non demandé est le genre de pari qu'un plan parallèle perd un jour.
  SELECT EXISTS (
    SELECT 1
      FROM public.tutor_threads t
      CROSS JOIN LATERAL (
        -- `said_at` et non `at` : AT est un mot-clé SQL (AT TIME ZONE), et un
        -- alias qui frôle un mot-clé est une panne qui attend son analyseur.
        SELECT (e.value->>'at')::TIMESTAMPTZ AS said_at,
               row_number() OVER (ORDER BY e.ord) AS rn
          FROM jsonb_array_elements(t.messages) WITH ORDINALITY e(value, ord)
         WHERE e.value->>'role' = 'tutor'
           AND e.value->>'kind' = 'reformulate'
      ) r
     WHERE t.user_id = v_user
       AND r.rn = 2
       AND public.tutor_thread_tag(t.id) = p_tag
       AND EXISTS (
             SELECT 1 FROM public.question_attempts a
              WHERE a.user_id = v_user
                AND a.misconception_tag = p_tag
                AND a.is_correct = false
                AND a.created_at > r.said_at
           )
  ) INTO v_b;

  -- (c) Deux explications SERVIES (peu importe le registre), la seconde datant
  -- d'au moins 7 jours, et le tag encore rendu par la définition canonique.
  -- On compte sur les messages du fil, pas sur `tutor_explanations` : cette
  -- table-là est le pot COMMUN, mutualisé entre familles — elle dit ce qui a été
  -- produit, jamais ce que CET élève a lu.
  SELECT count(*)
    INTO v_explains
    FROM public.tutor_threads t
    CROSS JOIN LATERAL jsonb_array_elements(t.messages) e(value)
   WHERE t.user_id = v_user
     AND public.tutor_thread_tag(t.id) = p_tag
     AND e.value->>'role' = 'tutor'
     AND e.value->>'kind' IN ('explain', 'reformulate')
     AND (e.value->>'at')::TIMESTAMPTZ <= now() - INTERVAL '7 days';

  v_c := v_explains >= 2
     AND EXISTS (
           SELECT 1 FROM public.active_misconceptions(v_user) am WHERE am.tag = p_tag
         );

  -- LE NIVEAU RECOMMANDÉ. La matrice est la MÊME que celle de
  -- `src/features/tutor/escalation.ts`, qui la teste sans base sur ses huit
  -- cases. Elle n'est pas arbitraire : chaque signal dit à quelle profondeur la
  -- compréhension a décroché, donc où reprendre.
  --   (a) l'explication ne prend pas        → 1 : montrer le COURS
  --   (b) les trois registres sont épuisés  → 2 : chercher le PRÉREQUIS
  --   (c) ça dure depuis une semaine        → 3 : inscrire au PLAN
  --   les trois à la fois                   → 4 : le dire au PARENT
  v_level := CASE
               WHEN v_a AND v_b AND v_c THEN 4
               WHEN v_c THEN 3
               WHEN v_b THEN 2
               WHEN v_a THEN 1
               ELSE 0
             END;

  RETURN jsonb_build_object(
    'tag',               p_tag,
    'signal_a',          v_a,
    'signal_b',          v_b,
    'signal_c',          v_c,
    'recommended_level', v_level
  );
END;
$$;

COMMENT ON FUNCTION public.tutor_understanding_signal(TEXT) IS
  'R-8 (é11 lot 4) : les TROIS signaux objectifs d''incompréhension persistante et le niveau d''escalade recommandé (0..4). Aucune heuristique hors R-8 ; le seuil « actif » vient de active_misconceptions().';

REVOKE EXECUTE ON FUNCTION public.tutor_understanding_signal(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_understanding_signal(TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. R-8 — L'ESCALADE ORDONNÉE. Une marche à la fois, et elle se DÉGRADE.
-- ---------------------------------------------------------------------------
-- Les cinq marches, dans l'ordre imposé par R-8 :
--   0 reteach        re-expliquer dans un autre registre  (état de départ)
--   1 lesson         « Montre-moi le cours » (deep-link chapitre)
--   2 prerequisite   le prérequis faible (get_competency_blockers)
--   3 plan           un item du plan du jour (get_daily_plan)
--   4 parent_digest  mention AGRÉGÉE dans le digest parent (Q-5)
--
-- POURQUOI ELLE DÉGRADE AU LIEU DE LEVER
-- ---------------------------------------------------------------------------
-- La marche 2 n'est pas toujours praticable : `misconceptions.competency` est
-- NULLABLE et sans clé étrangère (choix assumé de 20260802120000 — une confusion
-- de vocabulaire n'a pas de compétence), et `get_competency_blockers` exclut
-- déjà les prérequis jamais travaillés. Un élève dont l'erreur n'a pas de
-- compétence, ou dont aucun prérequis n'a de maîtrise mesurée, ne doit pas voir
-- l'escalade s'arrêter : elle passe à la marche suivante.
--
-- Et le niveau ENREGISTRÉ est celui réellement ATTEINT, pas celui visé. Écrire
-- 2 quand on a montré le plan ferait mentir l'historique sur lequel le lot
-- suivant — et le digest parent — raisonnent.
CREATE OR REPLACE FUNCTION public.escalate_tutor_thread(p_thread UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_row     RECORD;
  v_level   INT;
  v_action  TEXT;
  v_target  JSONB := NULL;
  v_slug    TEXT;
  -- Des SCALAIRES et non des RECORD, pour une raison précise : un `SELECT INTO`
  -- placé sous un `IF` peut ne jamais s'exécuter, et lire un RECORD non affecté
  -- LÈVE (« record is not assigned yet »). Un scalaire vaut NULL, ce qui est
  -- exactement l'information dont la dégradation a besoin. Même raison pour
  -- ne pas tester `FOUND` ici : il garderait la valeur du SELECT précédent.
  v_chap_id    UUID;
  v_chap_title TEXT;
  v_chap_subj  TEXT;
  v_blk_slug   TEXT;
  v_blk_fr     TEXT;
  v_blk_en     TEXT;
  v_blk_ar     TEXT;
  v_blk_master NUMERIC;
  v_plan_ex    UUID;
  v_plan_title TEXT;
  v_plan_chap  UUID;
  v_plan_subj  TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  -- L'appartenance est DANS le WHERE (motif `append_tutor_message`), pas dans un
  -- contrôle séparé : un fil qui n'est pas le sien est un fil qui n'existe pas.
  SELECT t.escalation_level, t.question_id, t.chapter_id
    INTO v_row
    FROM public.tutor_threads t
   WHERE t.id = p_thread AND t.user_id = v_user;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'THREAD_NOT_FOUND';
  END IF;

  -- Le plafond est dans le CHECK de la colonne ; `LEAST` le rend explicite
  -- plutôt qu'accidentel — au niveau 4 on re-mentionne au parent, on ne casse pas.
  v_level := LEAST(v_row.escalation_level + 1, 4);

  IF v_level = 1 THEN
    SELECT c.id, c.title, c.subject_id
      INTO v_chap_id, v_chap_title, v_chap_subj
      FROM public.chapters c
     WHERE c.id = COALESCE(
             v_row.chapter_id,
             (SELECT e.chapter_id
                FROM public.questions q
                JOIN public.exercises e ON e.id = q.exercise_id
               WHERE q.id = v_row.question_id)
           );
    IF v_chap_id IS NOT NULL THEN
      v_action := 'lesson';
      v_target := jsonb_build_object(
        'chapter_id', v_chap_id,
        'chapter_title', v_chap_title,
        'subject_id', v_chap_subj
      );
    ELSE
      v_level := 2;
    END IF;
  END IF;

  IF v_level = 2 THEN
    -- Le SEUL chemin tag → compétence. `get_competency_blockers` attend un SLUG,
    -- pas un tag ni un UUID. La colonne étant NULLABLE, `v_slug` NULL est le cas
    -- NORMAL, pas une anomalie : on dégrade sans rien signaler.
    SELECT m.competency INTO v_slug
      FROM public.misconceptions m
     WHERE m.tag = public.tutor_thread_tag(p_thread);

    IF v_slug IS NOT NULL THEN
      SELECT b.slug, b.label_fr, b.label_en, b.label_ar, b.mastery
        INTO v_blk_slug, v_blk_fr, v_blk_en, v_blk_ar, v_blk_master
        FROM public.get_competency_blockers(v_slug) b
       LIMIT 1;
    END IF;

    IF v_blk_slug IS NOT NULL THEN
      v_action := 'prerequisite';
      v_target := jsonb_build_object(
        'competency', v_blk_slug,
        'label_fr', v_blk_fr,
        'label_en', v_blk_en,
        'label_ar', v_blk_ar,
        'mastery', v_blk_master
      );
    ELSE
      v_level := 3;
    END IF;
  END IF;

  IF v_level = 3 THEN
    SELECT d.exercise_id, d.exercise_title, d.chapter_id, d.subject_id
      INTO v_plan_ex, v_plan_title, v_plan_chap, v_plan_subj
      FROM public.get_daily_plan(1) d
     LIMIT 1;

    IF v_plan_ex IS NOT NULL THEN
      v_action := 'plan';
      v_target := jsonb_build_object(
        'exercise_id', v_plan_ex,
        'exercise_title', v_plan_title,
        'chapter_id', v_plan_chap,
        'subject_id', v_plan_subj
      );
    ELSE
      v_level := 4;
    END IF;
  END IF;

  IF v_level = 4 THEN
    -- Q-5 : le parent reçoit une MENTION AGRÉGÉE dans son digest, jamais le
    -- verbatim. Il n'y a donc aucune cible à rendre à l'écran de l'élève — et
    -- surtout aucune notification immédiate : le digest est hebdomadaire.
    v_action := 'parent_digest';
    v_target := NULL;
  END IF;

  UPDATE public.tutor_threads t
     SET escalation_level = v_level,
         updated_at = now()
   WHERE t.id = p_thread AND t.user_id = v_user;

  RETURN jsonb_build_object(
    'escalation_level', v_level,
    'action', v_action,
    'target', v_target
  );
END;
$$;

COMMENT ON FUNCTION public.escalate_tutor_thread(UUID) IS
  'R-8 (é11 lot 4) : monte le fil d''une marche (0..4) et rend l''action suivante + sa cible. Se DÉGRADE vers la marche suivante quand la cible est introuvable, et enregistre le niveau réellement atteint.';

REVOKE EXECUTE ON FUNCTION public.escalate_tutor_thread(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.escalate_tutor_thread(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. Q-5 — CE QUE LE PARENT VOIT DE L'AIDE, ET CE QU'IL NE VERRA JAMAIS.
-- ---------------------------------------------------------------------------
-- Il voit : combien de fois son enfant a demandé de l'aide (7 j / 30 j), et les
-- trois THÈMES qui reviennent. Il ne voit PAS une seule phrase de la
-- conversation — ni `messages`, ni `summary`, ni un énoncé, ni une question
-- posée. Un enfant qui sait son tuteur rapporté mot à mot cesse de lui parler,
-- et le produit perd sa raison d'être en même temps que sa confiance.
--
-- ⚠️ POURQUOI UNE RPC SÉPARÉE PLUTÔT QU'UN CHAMP DE `_student_report_json`
-- ---------------------------------------------------------------------------
-- `_student_report_json` sert DEUX chemins : `get_student_report` (parent
-- authentifié, lien vérifié) et `get_student_report_by_code`, qui est GRANT à
-- **anon** — un accès au porteur du code alliance. Y greffer ces compteurs les
-- publierait à quiconque détient le code, sans aucun lien parent : la violation
-- directe de Q-5. La séparation n'est pas de la propreté, c'est la garde.
--
-- Le lien est vérifié par `is_parent_of_student`, qui teste déjà
-- `is_active = true`. Réécrire ici un EXISTS sur `parent_student_links` ferait
-- un second juge du lien — celui qui oublierait `is_active` un jour.
CREATE OR REPLACE FUNCTION public.get_tutor_parent_counters(p_student_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_parent UUID := auth.uid();
  v_7d     INT;
  v_30d    INT;
  v_themes JSONB;
BEGIN
  IF v_parent IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  -- Première instruction utile, et volontairement AVANT toute lecture : rien de
  -- l'enfant n'est touché tant que le lien n'est pas prouvé actif.
  -- Pas de `OR is_admin()` ici, contrairement au rapport d'activité : l'usage du
  -- tuteur par un mineur n'a pas de destinataire légitime hors de son parent lié.
  IF NOT public.is_parent_of_student(v_parent, p_student_id) THEN
    RAISE EXCEPTION 'NOT_LINKED';
  END IF;

  -- Une « interaction » = un tour de l'ÉLÈVE. Compter les tours du tuteur
  -- gonflerait le chiffre d'un facteur deux sans rien dire de plus, et compter
  -- les fils écraserait dix questions d'affilée en une seule ligne.
  SELECT count(*) FILTER (WHERE (e.value->>'at')::TIMESTAMPTZ >= now() - INTERVAL '7 days'),
         count(*) FILTER (WHERE (e.value->>'at')::TIMESTAMPTZ >= now() - INTERVAL '30 days')
    INTO v_7d, v_30d
    FROM public.tutor_threads t
    CROSS JOIN LATERAL jsonb_array_elements(t.messages) e(value)
   WHERE t.user_id = p_student_id
     AND e.value->>'role' = 'student';

  -- Les thèmes, AGRÉGÉS. La jointure sur `misconceptions` est INTERNE et c'est
  -- délibéré, comme dans `get_my_weaknesses` : un tag hors vocabulaire n'a pas
  -- de phrase à montrer à un parent, et on préfère l'omettre qu'afficher un
  -- identifiant technique (R-A1.2-1 — le tag n'est jamais AFFICHÉ ; il est rendu
  -- ici comme clé de liste, pas comme libellé).
  -- La jointure est DANS la sous-requête, avant le LIMIT : filtrer après aurait
  -- rendu deux thèmes là où trois étaient connus.
  -- L'alias `th(thread_tag)` n'est pas cosmétique : `misconceptions` porte elle
  -- aussi une colonne `tag`, et un `tag` nu dans le ON serait AMBIGU — l'erreur
  -- se serait vue au premier appel, pas à la compilation de la fonction.
  SELECT COALESCE(jsonb_agg(themes.x), '[]'::jsonb)
    INTO v_themes
    FROM (
      SELECT jsonb_build_object(
               'tag', m.tag,
               'label_fr', m.label_fr,
               'label_en', m.label_en,
               'label_ar', m.label_ar,
               'count', count(*)
             ) AS x
        FROM public.tutor_threads t
        CROSS JOIN LATERAL public.tutor_thread_tag(t.id) AS th(thread_tag)
        JOIN public.misconceptions m ON m.tag = th.thread_tag
       WHERE t.user_id = p_student_id
         AND t.updated_at >= now() - INTERVAL '30 days'
       GROUP BY m.tag, m.label_fr, m.label_en, m.label_ar
       ORDER BY count(*) DESC, m.tag
       LIMIT 3
    ) themes;

  RETURN jsonb_build_object(
    'interactions_7d',  COALESCE(v_7d, 0),
    'interactions_30d', COALESCE(v_30d, 0),
    'top_themes',       v_themes
  );

  -- ⚠️ IL N'Y A RIEN D'AUTRE DANS CE RETURN, ET C'EST LA RÈGLE (Q-5).
  -- Pas de `messages`, pas de `summary`, pas d'énoncé, pas de titre de fil.
  -- pgTAP S71 vérifie le refus quand le lien est inactif ; la non-fuite du
  -- verbatim, elle, tient à ce que rien ne le NOMME ici.
END;
$$;

COMMENT ON FUNCTION public.get_tutor_parent_counters(UUID) IS
  'Q-5 (é11 lot 4) : compteurs d''usage du tuteur (7 j / 30 j) + top 3 thèmes AGRÉGÉS pour un parent LIÉ ACTIF. Jamais le verbatim des conversations. Volontairement hors de _student_report_json, qui sert aussi le chemin anon au code alliance.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_parent_counters(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_parent_counters(UUID) TO authenticated;
