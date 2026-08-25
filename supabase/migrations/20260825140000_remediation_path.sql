-- Tuteur déterministe — étude 30 lot 4 : la décision
-- (FableEtudes/30-tuteur-deterministe, dépôt privé — §3.9 amendement C, §3.13c, R-14/R-15/R-16).
--
-- CE QUE CE LOT FERME. Les trois lots précédents savent ce que l'élève croit, ce qu'on peut en
-- déduire, et comment le lire. Ce lot en fait une DÉCISION : « ce qui te bloque, et par où on
-- reprend » — la troisième des trois phrases du §1.4, la seule qui demande d'agir.
--
--   R-15 — LA CAUSE RACINE, PAS LE SYMPTÔME. La remontée va « jusqu'à la première compétence
--   non maîtrisée EN PARTANT DU BAS ». C'est l'inverse de l'intuition : on ne propose pas le
--   prérequis le plus proche de l'échec, mais le plus profond de ceux qui manquent. Traiter
--   le prérequis immédiat quand c'est celui d'en dessous qui cloche, c'est exactement le
--   piétinement que KPI-4 mesure.
--
--   R-16 — la décision ne propose QUE des exercices que `resolve_exercise_access` autorise.
--   La porte n'est jamais recopiée : `get_exercises_for_competency` (é07 lot 4) est appelée
--   telle quelle, ici comme dans la frontière du lot 3.
--
--   R-17 — et elle ne VERROUILLE rien. Une remontée est une proposition motivée ; l'élève
--   reste libre de jouer ce qu'il veut, et c'est parfois lui qui a raison.
--
-- LE SECOND OBJET DE CE LOT est une couture, pas une création : `get_targeted_exercises`
-- (é11 lot 5) vise aujourd'hui la compétence OÙ L'ERREUR S'EST VUE. Elle apprend ici à viser
-- la cause quand il y en a une. É11 et é29 étant closes toutes les deux, ce branchement n'a
-- pas d'autre porteur — et le §3.13c le lui assigne nommément.
--
-- ⚠️ STOP-POINTS. Pas de nouvelle RPC de décision (é22 D-8 : le moteur reste la fonction TS
-- partagée `next-action.ts`, cette RPC ne fait que RÉSOUDRE une entrée). Côté é11/é29, un seul
-- `CREATE OR REPLACE` : ni la porte Q-8 (`tutor_practice_needs_generation`), ni la Forge, ni
-- ses budgets — la porte hérite du rebranchement en appelant sa voisine, ce qui est exactement
-- ce qu'elle a toujours fait.

-- ---------------------------------------------------------------------------
-- 1. get_remediation_path — la chaîne de remontée (R-15).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_remediation_path(p_competency TEXT)
RETURNS TABLE (
  competency_id     UUID,
  slug              TEXT,
  label_fr          TEXT,
  label_en          TEXT,
  label_ar          TEXT,
  state             TEXT,
  depth             INT,      -- 1 = prérequis direct, borné à 3 (R-15)
  is_root_cause     BOOLEAN,  -- la plus profonde des non maîtrisées : par où on reprend
  entry_exercise_id UUID
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  -- Aucun identifiant d'élève en paramètre : le périmètre est `(SELECT auth.uid())` en dur
  -- (é07 R-6). Sans session, `auth.uid()` est NULL, les jointures ne rendent rien, et la
  -- fonction renvoie vide au lieu de lever.
  WITH RECURSIVE me AS (
    -- ⚠️ LA GARDE STRUCTURELLE, et pourquoi un `WHERE uid IS NOT NULL` ne suffirait pas.
    -- Cette fonction appelle `get_exercises_for_competency`, qui appelle
    -- `resolve_exercise_access`, qui LÈVE ('Unauthorized') sans session. Un simple prédicat
    -- serait un qual que le planificateur est libre d'évaluer APRÈS l'appel — donc trop tard.
    -- Un CROSS JOIN sur une relation VIDE, lui, ne rend rien avant tout qual : la fonction
    -- n'est jamais appelée. C'est le patron de `get_targeted_exercises` (é11 lot 5), et c'est
    -- ce qui fait tenir l'invariant du §3.10 (« sans session, la fonction renvoie vide au lieu
    -- de lever ») plutôt que de l'espérer.
    SELECT u.uid
      FROM (SELECT (SELECT auth.uid()) AS uid) u
     WHERE u.uid IS NOT NULL
  ),
  target AS (
    SELECT c.id FROM public.competencies c WHERE c.slug = p_competency
  ),
  ancestry(competency_id, depth) AS (
    SELECT pr.prereq_id, 1
      FROM public.competency_prereqs pr, target t
     WHERE pr.competency_id = t.id
    UNION
    SELECT pr.prereq_id, a.depth + 1
      FROM public.competency_prereqs pr
      JOIN ancestry a ON pr.competency_id = a.competency_id
     WHERE a.depth < 3
  ),
  -- La profondeur retenue est la PLUS COURTE, comme pour l'inférence du lot 2 : un losange
  -- dans le graphe donnerait sinon deux profondeurs au même ancêtre, et la « plus profonde
  -- des non maîtrisées » deviendrait ambiguë.
  shortest AS (
    SELECT competency_id, min(depth) AS depth
      FROM ancestry
     WHERE competency_id NOT IN (SELECT id FROM target)
     GROUP BY competency_id
  ),
  scored AS (
    SELECT s.competency_id, s.depth,
           c.slug, c.label_fr, c.label_en, c.label_ar,
           public.competency_state(
             m.p_known, m.evidence_count, m.sessions_seen,
             array_length(m.forms_seen, 1), m.last_evidence_at
           ) AS state
      FROM shortest s
      JOIN public.competencies c ON c.id = s.competency_id
      LEFT JOIN public.user_competency_mastery m
        ON m.competency_id = s.competency_id AND m.user_id = (SELECT auth.uid())
  ),
  -- « En partant du bas » : la plus PROFONDE des non maîtrisées. À profondeur égale, la plus
  -- faible d'abord — `lacune` avant `fragile` avant le reste —, puis le slug pour rendre le
  -- choix déterministe (deux élèves dans le même état voient la même proposition).
  root AS (
    SELECT sc.competency_id
      FROM scored sc
     WHERE sc.state <> 'maitrisee'
     ORDER BY sc.depth DESC,
              CASE sc.state WHEN 'lacune' THEN 0 WHEN 'fragile' THEN 1
                            WHEN 'inconnue' THEN 2 ELSE 3 END,
              sc.slug
     LIMIT 1
  )
  SELECT
    sc.competency_id, sc.slug, sc.label_fr, sc.label_en, sc.label_ar, sc.state, sc.depth,
    sc.competency_id = (SELECT r.competency_id FROM root r) AS is_root_cause,
    entry.exercise_id
  FROM scored sc
  -- R-16 : l'exercice d'entrée passe par la porte, jamais par une copie de ses règles. Et il
  -- vise la ZPD comme au lot 3 — remonter à la cause ne dispense pas de servir un item du bon
  -- calibre : une cause racine servie trop dure est une remédiation qui échoue.
  LEFT JOIN LATERAL (
    SELECT ex.exercise_id, odds.value AS odds
      FROM me
      CROSS JOIN LATERAL public.get_exercises_for_competency(sc.slug) ex
      CROSS JOIN LATERAL (
        SELECT public.belief_success_odds(
          COALESCE((SELECT m2.p_known FROM public.user_competency_mastery m2
                     WHERE m2.competency_id = sc.competency_id
                       AND m2.user_id = (SELECT auth.uid())), 0.20),
          public.belief_guess(
            (SELECT q.question_type FROM public.questions q
              WHERE q.exercise_id = ex.exercise_id
              GROUP BY q.question_type ORDER BY count(*) DESC, q.question_type LIMIT 1),
            (SELECT jsonb_array_length(q.options) FROM public.questions q
              WHERE q.exercise_id = ex.exercise_id AND jsonb_typeof(q.options) = 'array'
              ORDER BY q.display_order LIMIT 1),
            'classic'),
          public.belief_slip(ex.difficulty, false)
        ) AS value
      ) odds
     ORDER BY (odds.value BETWEEN 0.55 AND 0.80) DESC,
              LEAST(abs(odds.value - 0.55), abs(odds.value - 0.80)),
              ex.difficulty, ex.exercise_id
     LIMIT 1
  ) entry ON true
  -- Rendu du plus profond au plus proche : c'est l'ordre de la REMONTÉE, donc l'ordre dans
  -- lequel un élève doit lire la chaîne — « on reprend ici, et ça débloquera ça ».
  ORDER BY sc.depth DESC, sc.slug;
$$;

COMMENT ON FUNCTION public.get_remediation_path(TEXT) IS
  'Étude 30 R-15 : la chaîne de prérequis (profondeur ≤ 3) et LA cause racine — la plus profonde des non maîtrisées.';

REVOKE ALL ON FUNCTION public.get_remediation_path(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_remediation_path(TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. get_targeted_exercises — le rebranchement « cause racine » (§3.13c).
-- ---------------------------------------------------------------------------
-- La fonction de é11 lot 5, VERBATIM, à une CTE près. Sa signature, ses colonnes, ses bornes,
-- son repli et son décompte de Q-8 sont inchangés — c'est ce qui permet à
-- `tutor_practice_needs_generation` d'hériter du rebranchement sans être touchée : elle
-- appelle sa voisine, elle ne la recopie pas.
--
-- LE CHANGEMENT tient en une substitution : là où la voie COMPÉTENCE visait `p_competency`,
-- elle vise désormais la cause racine QUAND il y en a une. Sans croyance, sans graphe ou sans
-- lacune confirmée en amont, `effective` rend `p_competency` et la sélection est identique à
-- aujourd'hui — assertion littérale au pgTAP, R-6.
CREATE OR REPLACE FUNCTION public.get_targeted_exercises(
  p_tag TEXT,
  p_competency TEXT DEFAULT NULL,
  p_limit INT DEFAULT 3
)
RETURNS TABLE (
  question_id UUID, exercise_id UUID, chapter_id UUID, subject_id TEXT,
  exercise_title TEXT, difficulty INT, is_fallback BOOLEAN, fresh_count INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH me AS (
    -- ⚠️ `me` est VIDE quand la session manque — un `WHERE uid IS NOT NULL` en aurait fait un
    -- simple prédicat, que le planificateur est libre d'évaluer APRÈS le sous-select d'accès.
    -- Or `resolve_exercise_access` LÈVE ('Unauthorized') sans session : la garde doit être
    -- STRUCTURELLE. Un CROSS JOIN sur une relation vide ne rend rien, avant tout qual.
    SELECT u.uid
      FROM (SELECT (SELECT auth.uid()) AS uid) u
     WHERE u.uid IS NOT NULL
  ),
  -- ═══ AJOUT é30 LOT 4 — LA CAUSE RACINE ════════════════════════════════════════════════
  -- Quand une lacune CONFIRMÉE (R-5 : `state = 'lacune'`) existe en amont de la compétence
  -- visée, on s'entraîne sur ELLE plutôt que sur le symptôme. Deux garde-fous dans le choix :
  --
  --   * `state = 'lacune'` et pas « non maîtrisée » — une compétence simplement jamais vue
  --     n'a rien prouvé, et détourner l'entraînement vers elle serait deviner ;
  --   * `is_root_cause` — c'est-à-dire la plus PROFONDE des manquantes, pas la plus proche.
  --     Traiter le prérequis immédiat quand c'est celui d'en dessous qui cloche est
  --     précisément le piétinement que cette étude cherche à faire baisser.
  --
  -- Et un troisième, implicite mais décisif : `get_remediation_path` ne rend une ligne que si
  -- le graphe et les croyances existent. Sans elles, `effective` retombe sur `p_competency`
  -- et TOUT ce qui suit est bit pour bit la fonction de é11.
  effective AS (
    SELECT COALESCE(
      (SELECT rp.slug
         FROM public.get_remediation_path(p_competency) rp
        WHERE p_competency IS NOT NULL
          AND rp.is_root_cause
          AND rp.state = 'lacune'
        LIMIT 1),
      p_competency
    ) AS competency
  ),
  -- ══════════════════════════════════════════════════════════════════════════════════════
  scope AS (
    SELECT DISTINCT qa.chapter_id
      FROM public.question_attempts qa, me
     WHERE qa.user_id = me.uid
       AND p_tag IS NOT NULL
       AND qa.misconception_tag = p_tag
       AND qa.chapter_id IS NOT NULL
       AND qa.created_at >= now() - INTERVAL '30 days'
  ),
  pool AS (
    SELECT q.id            AS q_id,
           e.id            AS ex_id,
           e.chapter_id    AS chap_id,
           e.subject_id    AS subj_id,
           e.title         AS ex_title,
           e.difficulty    AS diff,
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
      CROSS JOIN effective
     WHERE e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
       AND (
             (p_tag IS NOT NULL
              AND e.chapter_id IN (SELECT s.chapter_id FROM scope s)
              AND EXISTS (
                    SELECT 1
                      FROM jsonb_each_text(COALESCE(q.distractor_tags, '{}'::jsonb)) dt
                     WHERE dt.value = p_tag
                  ))
             -- Voie COMPÉTENCE — c'est ICI, et nulle part ailleurs, que la cause racine
             -- remplace le symptôme.
          OR (effective.competency IS NOT NULL
              AND EXISTS (
                    SELECT 1
                      FROM public.question_competencies qc
                      JOIN public.competencies c ON c.id = qc.competency_id
                     WHERE qc.question_id = q.id
                       AND c.slug = effective.competency
                  ))
           )
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
  fresh AS (
    SELECT p.*
      FROM pool p
      CROSS JOIN LATERAL public.resolve_exercise_access(p.ex_id) acc
     WHERE acc.allowed
  ),
  counted AS (
    SELECT count(*)::INT AS n FROM fresh
  ),
  ref AS (
    SELECT COALESCE((SELECT min(f.diff) FROM fresh f), 1) AS diff
  ),
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
  'é11 lot 5 + rebranchement cause racine de é30 lot 4 : vise le prérequis en lacune quand il y en a un, la compétence visée sinon.';

-- Les grants de é11 lot 5 survivent au `CREATE OR REPLACE` (les privilèges suivent l'objet) ;
-- on les réaffirme pour qu'une lecture de ce fichier seul ne laisse aucun doute.
REVOKE ALL ON FUNCTION public.get_targeted_exercises(TEXT, TEXT, INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_targeted_exercises(TEXT, TEXT, INT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. La même garde, sur `get_learning_frontier` — un défaut du lot 3, trouvé ici.
-- ---------------------------------------------------------------------------
-- La frontière du lot 3 appelle `get_exercises_for_competency` de la même façon, et LÈVE donc
-- `Unauthorized` pour un appelant sans session au lieu de rendre vide. Le §3.10 pose pourtant
-- l'invariant sans exception, pour les deux lectures.
--
-- La portée réelle est étroite — la server fn est derrière `requireSupabaseAuth`, donc aucun
-- appelant d'aujourd'hui n'arrive sans session — mais c'est exactement le genre de défaut qui
-- attend un nouvel appelant pour se voir : une route publique, un job, un test qui oublie de
-- poser les claims. Il est corrigé ici plutôt que dans une PR à part parce que le lot 4
-- introduisait le JUMEAU du bug : le corriger d'un côté et pas de l'autre aurait laissé la
-- moitié d'une leçon dans le dépôt.
CREATE OR REPLACE FUNCTION public.get_learning_frontier(
  p_family TEXT DEFAULT NULL,
  p_limit  INT DEFAULT 5
)
RETURNS TABLE (
  competency_id     UUID,
  slug              TEXT,
  label_fr          TEXT,
  label_en          TEXT,
  label_ar          TEXT,
  state             TEXT,
  p_known           NUMERIC,
  unlocks           INT,
  entry_exercise_id UUID,
  entry_subject_id  TEXT,
  entry_odds        NUMERIC
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH me AS (
    -- Voir le commentaire de `get_remediation_path` ci-dessus : garde STRUCTURELLE, pas un
    -- prédicat, parce que la porte d'accès lève au lieu de rendre faux.
    SELECT u.uid
      FROM (SELECT (SELECT auth.uid()) AS uid) u
     WHERE u.uid IS NOT NULL
  ),
  frontier AS (
    SELECT ls.competency_id, ls.slug, ls.label_fr, ls.label_en, ls.label_ar,
           ls.state, ls.p_known
      FROM public.get_learning_state(p_family) ls
     WHERE ls.zone = 'frontiere'
  ),
  ranked AS (
    SELECT f.*,
           (SELECT count(*)::INT FROM public.competency_prereqs pr
             WHERE pr.prereq_id = f.competency_id) AS unlocks
      FROM frontier f
  ),
  -- Le tri par fan-out est le SEUL pari pédagogique explicite de l'étude : à croyance égale,
  -- on propose d'abord ce qui ouvre le plus de portes. C'est ce qui distingue un plan d'un
  -- tirage — et c'est vérifiable (KPI-5), donc réfutable.
  top AS (
    SELECT * FROM ranked
     ORDER BY unlocks DESC, COALESCE(p_known, 0) DESC, slug
     LIMIT GREATEST(COALESCE(p_limit, 5), 1)
  )
  SELECT
    t.competency_id, t.slug, t.label_fr, t.label_en, t.label_ar, t.state, t.p_known,
    t.unlocks, entry.exercise_id, entry.subject_id, entry.odds
  FROM top t
  -- L'exercice d'entrée VISE LA ZPD (§3.4). `get_exercises_for_competency` est réutilisée,
  -- jamais réécrite, donc la porte d'accès reste son unique arbitre (R-16).
  LEFT JOIN LATERAL (
    SELECT ex.exercise_id, ex.subject_id, odds.value AS odds
      FROM me
      CROSS JOIN LATERAL public.get_exercises_for_competency(t.slug) ex
      CROSS JOIN LATERAL (
        SELECT public.belief_success_odds(
          COALESCE(t.p_known, 0.20),
          public.belief_guess(
            (SELECT q.question_type FROM public.questions q
              WHERE q.exercise_id = ex.exercise_id
              GROUP BY q.question_type ORDER BY count(*) DESC, q.question_type LIMIT 1),
            (SELECT jsonb_array_length(q.options) FROM public.questions q
              WHERE q.exercise_id = ex.exercise_id AND jsonb_typeof(q.options) = 'array'
              ORDER BY q.display_order LIMIT 1),
            'classic'),
          public.belief_slip(ex.difficulty, false)
        ) AS value
      ) odds
     ORDER BY
       (odds.value BETWEEN 0.55 AND 0.80) DESC,
       LEAST(abs(odds.value - 0.55), abs(odds.value - 0.80)),
       ex.difficulty,
       ex.exercise_id
     LIMIT 1
  ) entry ON true
  ORDER BY t.unlocks DESC, COALESCE(t.p_known, 0) DESC, t.slug;
$$;

COMMENT ON FUNCTION public.get_learning_frontier(TEXT, INT) IS
  'Étude 30 §3.4 : la frontière « prêt à apprendre », triée par fan-out, avec un exercice d''entrée visant la ZPD. Rend vide sans session (garde structurelle, lot 4).';

REVOKE ALL ON FUNCTION public.get_learning_frontier(TEXT, INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_learning_frontier(TEXT, INT) TO authenticated;
