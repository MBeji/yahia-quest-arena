-- ÉTUDE 11 LOT 5 — « Entraîne-moi sur ma faiblesse » : la SÉLECTION d'abord,
-- la génération seulement en repli (US-11, US-12, Q-8).
--
-- CE QUE CE FICHIER AJOUTE, ET CE QU'IL SE GARDE BIEN DE REFAIRE
-- ---------------------------------------------------------------------------
-- Le produit sait déjà sélectionner des exercices par COMPÉTENCE
-- (`get_exercises_for_competency`, é07 lot 4) et sait déjà GÉNÉRER un quiz
-- (la Forge, é29 lot 4). Ce lot n'écrit ni l'un ni l'autre. Il écrit la seule
-- chose qui manquait entre les deux : la sélection par ERREUR NOMMÉE, et le
-- DÉCOMPTE qui décide laquelle des deux voies l'élève emprunte.
--
-- Q-8 est une porte, pas une préférence : « génération d'exercices : GO, mais
-- SEULEMENT en fallback conditionnel — quand la sélection ne trouve pas au
-- moins 3 questions fraîches sur le tag ciblé ». Cette porte vit ICI, en SQL,
-- et non dans un écran : un client qui déciderait lui-même « le stock est
-- vide » pourrait déclencher une génération payante à volonté, en mentant.
--
-- POURQUOI DEUX FONCTIONS ET PAS UNE
-- ---------------------------------------------------------------------------
-- `tutor_practice_needs_generation` ne recopie PAS le prédicat de sa voisine :
-- elle l'APPELLE. C'est la leçon de `active_misconceptions` (20260823100000),
-- posée la veille précisément parce que le seuil R-2 avait fini dupliqué à
-- quatre endroits qui divergeaient. Le seuil des 3 questions fraîches est un
-- seuil différent, mais il mérite la même discipline : un seul endroit.
--
-- SECURITY DEFINER — PAR NÉCESSITÉ, PAS PAR CONFORT
-- ---------------------------------------------------------------------------
-- `questions.distractor_tags` est REVOKE au niveau COLONNE pour `anon` et
-- `authenticated` (20260706120000). Une fonction INVOKER — la posture de sa
-- sœur `get_exercises_for_competency`, qui ne lit, elle, que le catalogue
-- public — échouerait ou rendrait vide pour TOUT élève, et un test lancé en
-- `postgres` ne le verrait jamais. La non-fuite ne vient donc pas des droits
-- mais de la PROJECTION NOMMÉE : ni `correct_option`, ni `explanation`, ni
-- `distractor_tags` n'apparaissent dans le RETURNS TABLE (R-16). C'est le seul
-- motif qui résiste à l'ajout d'une colonne — un `SELECT *` moins deux clés
-- aurait fuité la troisième le jour où elle est arrivée.
--
-- LE COÛT, ET POURQUOI LE PÉRIMÈTRE EST BORNÉ AVANT LE TAG
-- ---------------------------------------------------------------------------
-- Il n'existe AUCUN index sur `questions.distractor_tags`, et la table porte
-- 22 146 lignes en production. Partir du tag sur le catalogue entier balaierait
-- tout, à chaque ouverture du tableau de bord. On borne donc d'abord aux
-- CHAPITRES où l'élève a réellement commis cette erreur (`question_attempts`
-- .`chapter_id`, dénormalisé exactement pour ça — A0.1, et c'est le CTE `home`
-- de `get_my_weaknesses`), puis on cherche le tag là-dedans.
--
-- Ce bornage est aussi un choix PÉDAGOGIQUE, pas seulement un choix de coût :
-- on ré-entraîne l'élève là où il se trompe, pas sur un homonyme du tag à
-- l'autre bout du catalogue.
--
-- AGENTS.md : aucune table neuve ⇒ aucun GRANT de table. Les deux fonctions
-- portent leur REVOKE/GRANT nominatif.

-- ---------------------------------------------------------------------------
-- 1. get_targeted_exercises — US-11 : de quoi s'entraîner sur CETTE erreur.
-- ---------------------------------------------------------------------------
-- Deux voies de ciblage, dans cet ordre de préférence :
--   * rang 1 — la question porte le TAG (`distractor_tags`, une map
--     {option_id: tag} : le tag se cherche dans les VALEURS, jamais avec `?`,
--     qui teste l'existence d'une CLÉ et ne matcherait donc jamais rien) ;
--   * rang 2 — la question évalue la COMPÉTENCE mise en défaut. `p_competency`
--     est un SLUG (`competencies.slug`), jamais un UUID : c'est ce que rend
--     `get_my_weaknesses.competency`, et toute l'API du graphe prend le slug.
--
-- `fresh_count` COMPTE AVANT LE REPLI, et c'est tout son intérêt. Il dit
-- combien de questions VRAIMENT sur l'erreur, jamais vues récemment et
-- accessibles, le stock contient. C'est lui — et lui seul — qui arme Q-8 :
-- un décompte gonflé par les questions de repli ferait croire à un stock
-- fourni et n'appellerait jamais la Forge.
--
-- R-15 : `auth.uid()` NULL rend VIDE au lieu de lever. Ce n'est pas de la
-- politesse — `resolve_exercise_access` fait `RAISE EXCEPTION 'Unauthorized'`
-- quand la session manque, et en CROSS JOIN LATERAL l'exception remonterait
-- jusqu'à l'appelant. Un refus est un ÉTAT rendu, jamais une exception.
CREATE OR REPLACE FUNCTION public.get_targeted_exercises(
  p_tag        TEXT,
  p_competency TEXT DEFAULT NULL,
  p_limit      INT  DEFAULT 3
)
RETURNS TABLE (
  question_id    UUID,
  exercise_id    UUID,
  chapter_id     UUID,
  subject_id     TEXT,
  exercise_title TEXT,
  difficulty     INT,
  -- `true` = question de REPLI (même chapitre, difficulté voisine), pas une
  -- question portant l'erreur. L'écran a le droit de le dire ; il n'a pas le
  -- droit de l'ignorer en promettant « sur ton erreur ».
  is_fallback    BOOLEAN,
  -- Répété sur chaque ligne (motif fenêtre) : une valeur scalaire aurait
  -- demandé une seconde fonction, donc un second parcours du même vivier.
  fresh_count    INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  -- ⚠️ `me` est VIDE quand la session manque — un `WHERE uid IS NOT NULL` en
  -- aurait fait un simple prédicat, que le planificateur est libre d'évaluer
  -- APRÈS le sous-select d'accès. Or `resolve_exercise_access` LÈVE
  -- ('Unauthorized') sans session : la garde doit être STRUCTURELLE. Un CROSS
  -- JOIN sur une relation vide ne rend rien, avant tout qual — c'est ce qui
  -- fait tenir R-15 ici, et non l'ordre des lignes du WHERE.
  WITH me AS (
    SELECT u.uid
      FROM (SELECT (SELECT auth.uid()) AS uid) u
     WHERE u.uid IS NOT NULL
  ),
  -- Le périmètre : les chapitres où CETTE erreur a été commise, sur la même
  -- fenêtre de 30 jours que le seuil d'erreur active. C'est ce qui borne le
  -- balayage JSONB (voir l'en-tête) et ce qui garde l'entraînement près du
  -- lieu de l'erreur.
  scope AS (
    SELECT DISTINCT qa.chapter_id
      FROM public.question_attempts qa, me
     WHERE qa.user_id = me.uid
       AND p_tag IS NOT NULL
       AND qa.misconception_tag = p_tag
       AND qa.chapter_id IS NOT NULL
       AND qa.created_at >= now() - INTERVAL '30 days'
  ),
  -- Le vivier CIBLÉ : les questions du stock qui portent l'erreur ou la
  -- compétence, jamais vues récemment. `LIMIT` haut (40) : le seuil à franchir
  -- est 3, et au-delà de 40 candidats la réponse à Q-8 ne change plus — mais
  -- chaque candidat coûte un appel à la porte d'accès juste après.
  pool AS (
    SELECT q.id            AS q_id,
           e.id            AS ex_id,
           e.chapter_id    AS chap_id,
           e.subject_id    AS subj_id,
           e.title         AS ex_title,
           e.difficulty    AS diff,
           -- 1 = l'erreur nommée, 2 = la compétence. On ré-entraîne sur ce que
           -- l'élève a RATÉ quand on le sait, et on retombe sur la compétence
           -- quand la question n'était pas taguée.
           CASE
             WHEN p_tag IS NOT NULL
              AND EXISTS (
                    SELECT 1
                      FROM jsonb_each_text(COALESCE(q.distractor_tags, '{}'::jsonb)) dt
                     WHERE dt.value = p_tag
                  )
             THEN 1 ELSE 2
           END AS match_rank
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      CROSS JOIN me
       -- Catalogue officiel seulement, et jamais le quiz de compréhension :
       -- il est la PORTE du chapitre, pas un entraînement (motif repris de
       -- `get_daily_plan` et de `get_exercises_for_competency`).
     WHERE e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
       AND (
             -- Voie TAG, bornée aux chapitres de `scope`.
             (p_tag IS NOT NULL
              AND e.chapter_id IN (SELECT s.chapter_id FROM scope s)
              AND EXISTS (
                    SELECT 1
                      FROM jsonb_each_text(COALESCE(q.distractor_tags, '{}'::jsonb)) dt
                     WHERE dt.value = p_tag
                  ))
             -- Voie COMPÉTENCE, bornée par l'index sur `question_competencies`.
          OR (p_competency IS NOT NULL
              AND EXISTS (
                    SELECT 1
                      FROM public.question_competencies qc
                      JOIN public.competencies c ON c.id = qc.competency_id
                     WHERE qc.question_id = q.id
                       AND c.slug = p_competency
                  ))
           )
       -- « Non vue récemment » : 30 jours, la même fenêtre que partout
       -- ailleurs. C'est aussi ce qui écarte LA QUESTION D'ORIGINE — celle sur
       -- laquelle l'erreur vient d'être commise a forcément une tentative
       -- récente. Re-servir une question dont l'élève se souvient de la
       -- réponse mesurerait sa mémoire, pas sa compréhension.
       AND NOT EXISTS (
             SELECT 1
               FROM public.question_attempts a
              WHERE a.user_id = me.uid
                AND a.question_id = q.id
                AND a.created_at >= now() - INTERVAL '30 days'
           )
     ORDER BY match_rank, e.difficulty, q.id
     LIMIT 40
  ),
  -- La porte d'accès, jamais recopiée (R-3) : `resolve_exercise_access` est
  -- l'unique arbitre, ici comme dans le plan du jour.
  fresh AS (
    SELECT p.*
      FROM pool p
      CROSS JOIN LATERAL public.resolve_exercise_access(p.ex_id) acc
     WHERE acc.allowed
  ),
  -- LE décompte de Q-8. Compté sur les QUESTIONS (« y a-t-il de la matière ? »)
  -- et non sur les destinations dédupliquées plus bas : deux questions du même
  -- exercice sont bien deux occasions de s'entraîner, même si l'écran n'y
  -- envoie qu'une fois.
  counted AS (
    SELECT count(*)::INT AS n FROM fresh
  ),
  -- La difficulté de référence du repli : celle du matériel ciblé quand il y
  -- en a, sinon 1 — on ne propose pas un exercice difficile à un élève dont on
  -- ne sait rien sur ce point.
  ref AS (
    SELECT COALESCE((SELECT min(f.diff) FROM fresh f), 1) AS diff
  ),
  -- LE REPLI. Même chapitre, difficulté à ±1, mêmes exclusions — il élargit le
  -- SUJET, jamais le périmètre. Il ne s'active que si le ciblé ne remplit pas
  -- la demande, et il ne compte JAMAIS dans `fresh_count`.
  --
  -- ⚠️ Il s'appuie sur `scope`, donc sur le TAG : un appel par la seule
  -- compétence (`p_tag` NULL) n'a PAS de repli. C'est volontaire — sans erreur
  -- commise, on ne sait pas dans quel chapitre élargir, et élargir au hasard du
  -- catalogue de la compétence rendrait des exercices d'un autre niveau.
  fallback AS (
    SELECT q.id         AS q_id,
           e.id         AS ex_id,
           e.chapter_id AS chap_id,
           e.subject_id AS subj_id,
           e.title      AS ex_title,
           e.difficulty AS diff,
           9            AS match_rank
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      CROSS JOIN me
      CROSS JOIN ref
     WHERE (SELECT c.n FROM counted c) < GREATEST(LEAST(COALESCE(p_limit, 3), 10), 1)
       AND e.chapter_id IN (SELECT s.chapter_id FROM scope s)
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
       AND e.difficulty BETWEEN ref.diff - 1 AND ref.diff + 1
       AND q.id NOT IN (SELECT f.q_id FROM fresh f)
       AND NOT EXISTS (
             SELECT 1
               FROM public.question_attempts a
              WHERE a.user_id = me.uid
                AND a.question_id = q.id
                AND a.created_at >= now() - INTERVAL '30 days'
           )
       AND (SELECT a2.allowed FROM public.resolve_exercise_access(e.id) a2)
     ORDER BY e.difficulty, q.id
     LIMIT 20
  ),
  merged AS (
    SELECT f.q_id, f.ex_id, f.chap_id, f.subj_id, f.ex_title, f.diff,
           f.match_rank, false AS is_fb
      FROM fresh f
    UNION ALL
    SELECT b.q_id, b.ex_id, b.chap_id, b.subj_id, b.ex_title, b.diff,
           b.match_rank, true AS is_fb
      FROM fallback b
  ),
  -- Une DESTINATION par ligne. Sans ce DISTINCT, un exercice portant trois
  -- questions taguées enverrait trois fois l'élève au même endroit — le même
  -- piège que le repli du plan du jour, qui a coûté son `DISTINCT ON`.
  picked AS (
    SELECT DISTINCT ON (m.ex_id) m.*
      FROM merged m
     ORDER BY m.ex_id, m.match_rank, m.diff, m.q_id
  )
  SELECT p.q_id, p.ex_id, p.chap_id, p.subj_id, p.ex_title, p.diff, p.is_fb,
         (SELECT c.n FROM counted c)
    FROM picked p
   ORDER BY p.is_fb, p.match_rank, p.diff, p.q_id
   LIMIT GREATEST(LEAST(COALESCE(p_limit, 3), 10), 1);
$$;

COMMENT ON FUNCTION public.get_targeted_exercises(TEXT, TEXT, INT) IS
  'É11 lot 5 (US-11) : les questions du stock qui rejouent une erreur nommée ou sa compétence — fraîches, accessibles (resolve_exercise_access), avec repli même chapitre à difficulté ±1. `fresh_count` compte le CIBLÉ avant repli : c''est la porte de Q-8. R-16 par projection nommée — ni clé, ni explication, ni distractor_tags.';

REVOKE EXECUTE ON FUNCTION public.get_targeted_exercises(TEXT, TEXT, INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_targeted_exercises(TEXT, TEXT, INT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. tutor_practice_needs_generation — LA porte de Q-8 (US-12).
-- ---------------------------------------------------------------------------
-- Vrai quand la sélection trouve MOINS DE 3 questions fraîches sur le tag.
-- C'est la seule condition qui autorise la génération, et elle est en base :
-- un écran qui déciderait lui-même « le stock est vide » ouvrirait une
-- dépense de modèle à qui sait forger une requête.
--
-- ⚠️ Elle APPELLE `get_targeted_exercises`, elle ne recopie pas son prédicat.
-- Le jour où « fraîche » changera de sens (la fenêtre de 30 jours, la porte
-- d'accès, le bornage aux chapitres), les deux fonctions changeront ensemble
-- ou l'écran promettra un stock que la sélection ne sait plus trouver.
--
-- Zéro ligne rendue ⇒ `fresh_count` inconnu ⇒ 0 par `COALESCE`, donc vrai :
-- le cas « aucune matière du tout » est précisément celui où la Forge sert.
CREATE OR REPLACE FUNCTION public.tutor_practice_needs_generation(p_tag TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT COALESCE(
    (SELECT t.fresh_count
       FROM public.get_targeted_exercises(p_tag, NULL, 3) t
      LIMIT 1),
    0
  ) < 3;
$$;

COMMENT ON FUNCTION public.tutor_practice_needs_generation(TEXT) IS
  'É11 lot 5 (Q-8) : la porte de la génération — vrai quand get_targeted_exercises trouve moins de 3 questions fraîches sur le tag. Appelle la sélection, ne recopie jamais son prédicat : le seuil vit à un seul endroit.';

REVOKE EXECUTE ON FUNCTION public.tutor_practice_needs_generation(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_practice_needs_generation(TEXT) TO authenticated;
