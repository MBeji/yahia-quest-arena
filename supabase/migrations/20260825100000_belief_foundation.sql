-- Tuteur déterministe — étude 30 lot 1 : le socle de croyance
-- (FableEtudes/30-tuteur-deterministe, dépôt privé — §3.2, §3.8a/c, §3.9 amendements A et B).
--
-- CE QUE CE LOT AJOUTE, ET RIEN D'AUTRE : le produit sait déjà *si* l'élève a raté (é04) et
-- *à quel point* une compétence est faible (é07, EWMA `mastery`). Il ne sait pas ce qu'il
-- CROIT. Ce lot pose la variable de décision — `p_known`, une probabilité calibrée par
-- Bayesian Knowledge Tracing (Corbett & Anderson, 1994) — à côté de la variable d'affichage.
--
--   D-1 « l'EWMA se montre, la croyance décide » : `mastery` (0–100) n'est PAS touchée, ni sa
--   formule, ni son trigger, ni son oubli à la lecture. Aucune surface élève n'affiche
--   `p_known` (le lot 3 rendra un ÉTAT, jamais un pourcentage de croyance).
--
--   D-2 « BKT sans ajustement » : des quatre paramètres du modèle, deux sont DÉDUITS de la
--   forme de l'item (`belief_guess` = la géométrie, `belief_slip` = le palier de difficulté)
--   et deux sont ÉCRITS au registre de compétences (`p_init`, `p_transit`, compilés depuis
--   le corpus). Rien n'est estimé, donc le reproche d'identifiabilité fait à BKT (Beck) ne
--   se pose pas : il n'y a pas d'estimation. Les bornes de la littérature (G ≤ 0,30,
--   S ≤ 0,10 hors charge) restent des garde-fous d'ÉCRITURE, pas des contraintes d'optimisation.
--
--   R-6, non négociable — LA NEUTRALITÉ DU NON-TAGGÉ : une question sans compétence ne crée
--   ni ne modifie aucune croyance. Sur les ~88 matières non taggées, tout ce fichier est
--   silencieux et le produit rend exactement ce qu'il rend aujourd'hui. C'est le même
--   invariant que é07 R-2, et il est vérifié littéralement par la suite pgTAP.
--
-- MIGRATION ENTIÈREMENT ADDITIVE (§3.8) : que des `ADD COLUMN IF NOT EXISTS` avec DEFAULT, un
-- index, quatre fonctions pures et un trigger de plus sur un événement déjà instrumenté.
-- Aucune signature existante n'est modifiée, aucun GRANT existant n'est retiré.
--
-- ⚠️ Écart relevé avec l'annexe A de l'étude, et tranché en faveur du modèle. Sept des neuf
-- lignes des tables A.1/A.2 se rejouent exactement avec les formules du §3.2 ; deux ne s'y
-- rejouent pas — A.1 n° 2 (`numeric`, annoncé 0,861, calculé **0,848**) et A.2 n° 9 (sous
-- charge, annoncé 0,885, calculé **0,879** — hors périmètre, lot 6). Le §3.2 donne les
-- formules ET les constantes ; la table en est dérivée. Là où la table contredit la formule
-- dont elle dérive, la formule fait foi. Les deux dérivations sont posées en clair dans
-- `supabase/tests/75_adaptive_belief.test.sql` pour que le désaccord soit lisible et non subi.

-- ---------------------------------------------------------------------------
-- 1. Amendement A (é07) — les deux paramètres ÉCRITS, au registre de compétences.
-- ---------------------------------------------------------------------------
-- Compilés depuis `content/competences/<famille>.json` par le sql-builder (champs optionnels
-- `pInit` / `pTransit`, défauts de famille) — jamais écrits à la main en base. Les défauts de
-- colonne sont ceux de l'annexe A : p(L₀) = 0,20, p(T) = 0,15.
-- Les bornes sont des garde-fous d'auteur : une compétence qu'on croit connue d'avance à 0,7
-- n'est pas une compétence, et un p(T) de 0,5 ferait « apprendre » en répondant faux.
ALTER TABLE public.competencies
  ADD COLUMN IF NOT EXISTS p_init    NUMERIC NOT NULL DEFAULT 0.20 CHECK (p_init    BETWEEN 0.02 AND 0.60),
  ADD COLUMN IF NOT EXISTS p_transit NUMERIC NOT NULL DEFAULT 0.15 CHECK (p_transit BETWEEN 0.02 AND 0.40);

COMMENT ON COLUMN public.competencies.p_init IS
  'Étude 30 D-2 : p(L₀) BKT — croyance initiale, écrite par le corpus, jamais estimée.';
COMMENT ON COLUMN public.competencies.p_transit IS
  'Étude 30 D-2 : p(T) BKT — probabilité d''apprendre EN répondant, écrite par le corpus.';

-- Le registre est déjà lisible par le client (é07 lot 1 : les libellés de compétences).
-- Ces deux colonnes n'ajoutent aucun secret — elles ne désignent aucune réponse — donc elles
-- suivent le grant de la table plutôt qu'une whitelist. Rien à faire.

-- ---------------------------------------------------------------------------
-- 2. Amendement A (é07) — la croyance rejoint la maîtrise, sur la même ligne.
-- ---------------------------------------------------------------------------
-- Une table de croyance séparée a été rejetée (§3.2 D-1) : deux écrivains sur le même fait.
-- La coexistence est ici structurelle — une ligne, deux nombres, deux usages.
ALTER TABLE public.user_competency_mastery
  ADD COLUMN IF NOT EXISTS p_known          NUMERIC NOT NULL DEFAULT 0.20
      CHECK (p_known BETWEEN 0.01 AND 0.99),
  ADD COLUMN IF NOT EXISTS evidence_count   INT     NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sessions_seen    INT     NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS forms_seen       TEXT[]  NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS last_evidence_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS belief_source    TEXT    NOT NULL DEFAULT 'evidence'
      CHECK (belief_source IN ('evidence','inference','placement')),
  ADD COLUMN IF NOT EXISTS inferred_from    UUID REFERENCES public.competencies(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS suspect          BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS disputed_at      TIMESTAMPTZ;

COMMENT ON COLUMN public.user_competency_mastery.p_known IS
  'Étude 30 D-1 : la variable de DÉCISION (BKT). `mastery` reste la variable d''affichage.';
COMMENT ON COLUMN public.user_competency_mastery.forms_seen IS
  'Étude 30 R-4 : les TYPES d''items déjà vus (la variante rappel compte pour un type). Un
   tableau et non un compteur — « varié » se vérifie sur des types distincts, et un compteur
   ne saurait pas si les 4 preuves sont 4 fois le même QCM.';
COMMENT ON COLUMN public.user_competency_mastery.belief_source IS
  'Étude 30 D-5 : d''où vient cette croyance — preuve jouée, inférence dans le graphe (lot 2)
   ou bilan d''entrée (lot 7). Ce qui rend l''inférence traçable, donc contestable.';

-- « les compétences dont je suis le moins sûr » (le bilan d'entrée du lot 7, §3.5) :
-- l'incertitude est une DISTANCE À 0,5, donc un index sur l'expression, pas sur la colonne.
CREATE INDEX IF NOT EXISTS idx_ucm_user_uncertainty
  ON public.user_competency_mastery (user_id, (abs(p_known - 0.5)));

-- Aucun GRANT ne bouge : la table est déjà SELECT-only pour `authenticated` (é07 lot 2) et
-- des colonnes ajoutées à une table dont le grant est au niveau TABLE en héritent. Le seul
-- écrivain reste le trigger, qui tourne comme propriétaire dans la transaction des RPC
-- SECURITY DEFINER.

-- ---------------------------------------------------------------------------
-- L'amendement B (é04) N'EST PAS ICI, et c'est délibéré.
-- ---------------------------------------------------------------------------
-- §3.9 amende aussi `question_attempts` : `elapsed_ms` et la source `placement`. Aucun des
-- deux n'a de lecteur dans le périmètre retenu (0bis·1·2·3·3bis·4) — `elapsed_ms` attend le
-- détecteur de charge (lot 6), `placement` attend le bilan d'entrée (lot 7), tous deux
-- différés. Les poser ici ferait voyager un élargissement de CHECK sans consommateur — et la
-- suppression de contrainte que cet élargissement exige est précisément ce que le hook de
-- pré-commit refuse de voir partir avec du `src/**` (DoD §7). Ils partiront avec le lot qui
-- les lit.

-- ---------------------------------------------------------------------------
-- 3. Le hasard est la GÉOMÉTRIE de l'item (D-2), pas un paramètre d'auteur.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.belief_guess(
  p_question_type TEXT,
  p_option_count  INT,
  p_variant       TEXT
) RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
AS $$
  -- La variante RAPPEL (é17) prime sur le type : une `mcq` jouée de mémoire n'affiche pas ses
  -- options, donc son hasard n'est plus celui d'un QCM. C'est le corollaire produit du §3.2 —
  -- une saisie libre juste vaut plusieurs QCM justes, et ce n'est pas une faveur faite au
  -- rappel actif : c'est la quantité d'information que la forme de l'item transporte.
  -- ROUND : `1.0 / k` porte une échelle de 20 décimales que NUMERIC propage jusqu'aux
  -- assertions. Quatre décimales suffisent — G est une géométrie, pas une mesure.
  SELECT ROUND(CASE
    WHEN p_variant = 'recall'                       THEN 0.02
    WHEN p_question_type = 'short_answer'           THEN 0.02
    WHEN p_question_type = 'numeric'                THEN 0.05
    WHEN p_question_type IN ('ordering','matching') THEN 0.05
    WHEN p_question_type = 'multi'                  THEN 0.08
    WHEN p_question_type = 'mcq'                    THEN
      -- 1/k borné [0,15 ; 0,30] : la borne haute est celle de la littérature
      -- (anti-dégénérescence), la borne basse dit qu'un QCM reste un QCM — un item à
      -- 12 options n'est pas une saisie libre, on peut encore y tomber juste.
      LEAST(0.30, GREATEST(0.15, 1.0 / GREATEST(COALESCE(p_option_count, 4), 2)))
    ELSE 0.25
  END, 4)::NUMERIC;
$$;

COMMENT ON FUNCTION public.belief_guess(TEXT, INT, TEXT) IS
  'Étude 30 D-2/R-2 : p(G) BKT déduit de la forme de l''item (mcq 1/k borné, saisie libre 0,02).';

-- ---------------------------------------------------------------------------
-- 4. L'inattention décroît avec la difficulté (D-2).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.belief_slip(
  p_difficulty INT,
  p_under_load BOOLEAN
) RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
AS $$
  -- Rater un item facile ressemble à une étourderie, rater un item dur ressemble à une lacune.
  -- `p_under_load` pousse au plafond de R-3 (0,20) : le système devient PLUS indulgent quand
  -- il détecte la fatigue. Le détecteur qui le lèvera est au lot 6 ; jusque-là l'appelant
  -- passe `false` et le paramètre reste une porte, pas une branche morte.
  SELECT (CASE WHEN p_under_load THEN 0.20 ELSE
    CASE COALESCE(p_difficulty, 2)
      WHEN 1 THEN 0.10 WHEN 2 THEN 0.08 WHEN 3 THEN 0.06 WHEN 4 THEN 0.05 ELSE 0.08 END
  END)::NUMERIC;
$$;

COMMENT ON FUNCTION public.belief_slip(INT, BOOLEAN) IS
  'Étude 30 D-2/R-3 : p(S) BKT par palier de difficulté (d1 .10 → d4 .05), plafond 0,20 sous charge.';

-- ---------------------------------------------------------------------------
-- 5. La mise à jour bayésienne elle-même — une fonction pure, donc opposable.
-- ---------------------------------------------------------------------------
-- Elle est SÉPARÉE du trigger pour deux raisons. (1) R-4 « constantes centralisées, jamais en
-- ligne à l'appel » : l'arithmétique de BKT est la constante la plus importante de l'étude, et
-- l'enfouir dans un `plpgsql` la rendrait invérifiable autrement qu'en insérant des lignes.
-- (2) Elle a déjà deux appelants prévus — le trigger ici, et le bilan d'entrée du lot 7.
CREATE OR REPLACE FUNCTION public.belief_update(
  p_prior   NUMERIC,
  p_correct BOOLEAN,
  p_guess   NUMERIC,
  p_slip    NUMERIC,
  p_transit NUMERIC,
  p_weight  NUMERIC DEFAULT 1.0
) RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
AS $$
  --   juste : p⁺ = p(1−S) / [ p(1−S) + (1−p)G ]
  --   faux  : p⁺ = p·S    / [ p·S    + (1−p)(1−G) ]
  --   puis    p' = p⁺ + (1−p⁺)·T        (l'élève peut avoir appris EN répondant)
  --   enfin   p_final = p_avant + w·(p' − p_avant)   ← le poids de la preuve (R-21)
  --
  -- `w` est ce qui distingue une preuve d'autonomie d'une reprise après aide : 1,0 sans aide,
  -- 0,5 après les paliers 1–2 ou un mini-check du tuteur, 0,25 après le palier 3. C'est
  -- l'échafaudage de Bruner rendu arithmétique — l'aide se retire à mesure que l'autonomie se
  -- prouve, et le système sait toujours de quelle autonomie il parle.
  --
  -- Bornes [0,01 ; 0,99] : la certitude absolue n'est pas un état atteignable, et une croyance
  -- à 0 ou 1 serait un point fixe dont aucune preuve contraire ne pourrait plus la sortir.
  WITH posterior AS (
    SELECT CASE WHEN p_correct
      THEN (p_prior * (1 - p_slip)) / NULLIF(p_prior * (1 - p_slip) + (1 - p_prior) * p_guess, 0)
      ELSE (p_prior * p_slip)       / NULLIF(p_prior * p_slip       + (1 - p_prior) * (1 - p_guess), 0)
    END AS p_post
  ), learned AS (
    -- `p'` : la croyance qu'on aurait SANS pondération. Un item dégénéré (G = 1, ou S = 1 sur
    -- une erreur) annulerait le dénominateur ; on retombe alors sur le prior — ne rien
    -- apprendre est la seule réponse honnête à une observation qui n'informe pas.
    SELECT COALESCE(p_post + (1 - p_post) * p_transit, p_prior) AS p_after FROM posterior
  )
  SELECT LEAST(0.99, GREATEST(0.01, ROUND(
    p_prior + COALESCE(p_weight, 1.0) * (p_after - p_prior)
  , 4)))::NUMERIC
  FROM learned;
$$;

COMMENT ON FUNCTION public.belief_update(NUMERIC, BOOLEAN, NUMERIC, NUMERIC, NUMERIC, NUMERIC) IS
  'Étude 30 §3.2 : une observation BKT, pondérée par le poids de la preuve (R-21). Bornée [0,01 ; 0,99].';

-- ---------------------------------------------------------------------------
-- 6. Le poids de la preuve — et le mini-check du tuteur, détecté par LE FIL.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.belief_evidence_weight(
  p_user_id    UUID,
  p_session_id UUID
) RETURNS NUMERIC
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  -- É11 lot 4 n'a PAS créé de source `'tutor'` : `submit_tutor_mini_check` écrit
  -- `source = 'exercise'` avec `session_id` = le fil `tutor_threads` actif. Le poids se lit
  -- donc sur le FIL, pas sur la source — un `EXISTS` sur la clé primaire de `tutor_threads`,
  -- le coût d'un lookup indexé, nul pour les soumissions dont le `session_id` est un
  -- exercice ou un donjon.
  --
  -- Pourquoi 0,5 : une question posée JUSTE APRÈS une explication est structurellement une
  -- reprise après aide (é11 US-4), pas une preuve d'autonomie. C'est le premier cas réel du
  -- poids de R-21, et il arrive avant l'échafaudage qui l'a motivé (lot 5, différé).
  SELECT CASE
    WHEN EXISTS (
      SELECT 1 FROM public.tutor_threads t
       WHERE t.id = p_session_id AND t.user_id = p_user_id
    ) THEN 0.5
    ELSE 1.0
  END::NUMERIC;
$$;

COMMENT ON FUNCTION public.belief_evidence_weight(UUID, UUID) IS
  'Étude 30 §3.2/R-21 : w = 0,5 quand la soumission appartient à un fil de tuteur (mini-check é11), 1,0 sinon.';

-- Serveur seulement, comme les helpers de é07 lot 2. Les lectures du lot 3 sont SECURITY
-- DEFINER et les appellent comme propriétaire — aucun EXECUTE client n'est nécessaire.
REVOKE EXECUTE ON FUNCTION public.belief_guess(TEXT, INT, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.belief_slip(INT, BOOLEAN) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.belief_update(NUMERIC, BOOLEAN, NUMERIC, NUMERIC, NUMERIC, NUMERIC)
  FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.belief_evidence_weight(UUID, UUID) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 7. L'écrivain : un TROISIÈME trigger sur `question_attempts` (§3.13a).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_competency_belief()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_type       TEXT;
  v_options    INT;
  v_difficulty INT;
  v_variant    TEXT;
  v_guess      NUMERIC;
  v_slip       NUMERIC;
  v_weight     NUMERIC;
  v_form       TEXT;
BEGIN
  -- La forme de l'item et son palier. Comme pour l'EWMA de é07, la difficulté est portée par
  -- l'exercice (`questions` n'a pas de colonne de difficulté) ; une question détachée de tout
  -- exercice n'apprend rien et sort ici.
  SELECT q.question_type,
         CASE WHEN jsonb_typeof(q.options) = 'array' THEN jsonb_array_length(q.options) END,
         e.difficulty
    INTO v_type, v_options, v_difficulty
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
   WHERE q.id = NEW.question_id;

  IF v_type IS NULL THEN
    RETURN NULL;
  END IF;

  -- La variante est lue sur la SESSION, jamais sur la ligne de télémétrie : `question_attempts`
  -- n'en porte pas, et une variante passée par l'appelant serait une variante déclarable.
  -- Un `session_id` de donjon ou de fil de tuteur ne joint rien → 'classic', ce qui est exact.
  SELECT s.variant INTO v_variant
    FROM public.exercise_sessions s
   WHERE s.id = NEW.session_id;

  v_guess  := public.belief_guess(v_type, v_options, COALESCE(v_variant, 'classic'));
  -- `false` : le signal de charge est au lot 6. Le paramètre existe déjà pour que le lot 6
  -- soit un changement d'argument et non une réécriture du trigger.
  v_slip   := public.belief_slip(v_difficulty, false);
  v_weight := public.belief_evidence_weight(NEW.user_id, NEW.session_id);
  -- La variante rappel compte pour un TYPE à part entière (R-4) : c'est bien une autre façon
  -- de savoir, et c'est celle qui porte le plus d'information.
  v_form   := CASE WHEN COALESCE(v_variant, 'classic') = 'recall' THEN 'recall' ELSE v_type END;

  -- Un upsert par compétence évaluée par la question (1–3, é07 R-2). Une question sans mapping
  -- rend zéro ligne : le non-taggé reste strictement neutre (R-6), il ne crée jamais de ligne.
  --
  -- ⚠️ `mastery` et `attempts` sont DÉLIBÉRÉMENT absents de la liste de colonnes : ils prennent
  -- leur DEFAULT (50 et 0) à l'insertion, ce qui est exactement l'état de départ que
  -- `record_competency_mastery` (é07 lot 2) suppose quand il tombe sur sa branche ON CONFLICT.
  -- Les deux triggers voient donc le même résultat quel que soit celui qui crée la ligne —
  -- l'EWMA de é07 reste bit pour bit ce qu'elle était (D-1), et la suite pgTAP de é07 lot 2
  -- le prouve sans avoir été retouchée.
  INSERT INTO public.user_competency_mastery AS m
    (user_id, competency_id, last_attempt_at,
     p_known, evidence_count, sessions_seen, forms_seen, last_evidence_at, belief_source)
  SELECT
    NEW.user_id,
    qc.competency_id,
    NEW.created_at,
    -- Premier contact : le prior est celui du registre (D-2), pas un 0,20 en dur.
    public.belief_update(c.p_init, NEW.is_correct, v_guess, v_slip, c.p_transit, v_weight),
    1,
    1,
    ARRAY[v_form],
    NEW.created_at,
    'evidence'
  FROM public.question_competencies qc
  JOIN public.competencies c ON c.id = qc.competency_id
  WHERE qc.question_id = NEW.question_id
  ON CONFLICT (user_id, competency_id) DO UPDATE SET
    p_known = public.belief_update(
      m.p_known, NEW.is_correct, v_guess, v_slip,
      (SELECT c2.p_transit FROM public.competencies c2 WHERE c2.id = m.competency_id),
      v_weight
    ),
    evidence_count = m.evidence_count + 1,
    -- Une session n'est nouvelle pour CETTE compétence que si aucune ligne antérieure de la
    -- même session ne l'évaluait. `id < NEW.id` et non `<>` : un AFTER ROW sur un INSERT
    -- multi-lignes (les RPC insèrent toutes les réponses d'une session en une fois) voit
    -- TOUTES les lignes de l'ordre — le patron est celui de `record_user_misconception`.
    sessions_seen = m.sessions_seen + CASE WHEN EXISTS (
      SELECT 1
        FROM public.question_attempts qa
        JOIN public.question_competencies qc2 ON qc2.question_id = qa.question_id
       WHERE qa.user_id = NEW.user_id
         AND qa.session_id = NEW.session_id
         AND qc2.competency_id = m.competency_id
         AND qa.id < NEW.id
    ) THEN 0 ELSE 1 END,
    forms_seen = CASE WHEN v_form = ANY (m.forms_seen)
                      THEN m.forms_seen ELSE m.forms_seen || v_form END,
    last_evidence_at = GREATEST(COALESCE(m.last_evidence_at, NEW.created_at), NEW.created_at),
    -- Une preuve JOUÉE reprend toujours la main sur une croyance déduite (D-4/D-5) : on peut
    -- être dispensé d'un prérequis par inférence, on n'est déclaré maître que de ce qu'on a
    -- fait. `inferred_from` et `suspect` sont donc effacés par la première preuve réelle.
    belief_source = 'evidence',
    inferred_from = NULL,
    suspect = false;

  RETURN NULL;
END;
$$;

COMMENT ON FUNCTION public.record_competency_belief() IS
  'Étude 30 lot 1 : entretient p_known (BKT) sur user_competency_mastery. Neutre sur le non-taggé (R-6).';

REVOKE EXECUTE ON FUNCTION public.record_competency_belief() FROM PUBLIC, anon, authenticated;

-- Comme le trigger d'EWMA, il tourne sur TOUTE tentative : une réponse juste est exactement la
-- preuve qui élève une croyance, donc elle ne doit pas être filtrée (contrairement au trigger
-- de misconceptions de é04, gaté sur un tag non nul).
--
-- Ordre d'exécution : Postgres déclenche les AFTER ROW par ordre alphabétique de nom, donc
-- `..._belief` avant `..._mastery`. C'est indifférent ici (cf. le commentaire de l'INSERT
-- ci-dessus) et la suite pgTAP de é07 lot 2, inchangée, le vérifie de fait.
DROP TRIGGER IF EXISTS trg_question_attempts_competency_belief ON public.question_attempts;
CREATE TRIGGER trg_question_attempts_competency_belief
  AFTER INSERT ON public.question_attempts
  FOR EACH ROW
  EXECUTE FUNCTION public.record_competency_belief();
