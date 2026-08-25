-- Tuteur déterministe — étude 30 lot 3 : les lectures & la carte à 4 états
-- (FableEtudes/30-tuteur-deterministe, dépôt privé — §3.4, §3.10, R-4/R-5, R-10, R-17).
--
-- CE QUE CE LOT REND LISIBLE. Les lots 1 et 2 ont posé une croyance et l'ont fait circuler
-- dans le graphe. Personne ne peut encore la voir — et c'est voulu : D-1 interdit d'afficher
-- `p_known` à un élève. Ce lot livre les deux lectures qui traduisent la croyance en langage
-- de produit, et elles sont les trois phrases du §1.4 :
--
--   « Voilà ce que tu maîtrises, et pourquoi j'en suis sûr. »        → get_learning_state
--   « Voilà ce que tu es prêt à apprendre maintenant. »              → get_learning_frontier
--   « Voilà ce qui te bloque, et par où on reprend. »                → la zone `hors-portee`
--                                                                       (la remontée est au lot 4)
--
-- LA FRONTIÈRE EST LA LECTURE LA PLUS RENTABLE DE L'ÉTUDE, et elle ne coûte qu'une requête :
--   intérieur    : l'état est `maitrisee`
--   frontière    : pas encore maîtrisée, mais TOUS ses prérequis directs le sont
--   hors-portée  : pas encore maîtrisée, et au moins un prérequis direct ne l'est pas
-- C'est la ZPD de Vygotsky rendue calculable par le graphe. Le hors-portée n'est PAS une zone
-- interdite (R-17) : la maîtrise conseille, elle n'interdit jamais. C'est la zone où toute
-- proposition du système commence par une remontée — et un élève qui insiste peut jouer, c'est
-- son droit, et c'est parfois lui qui a raison.
--
-- ⚠️ AUCUNE DE CES LECTURES NE REND `p_known` À UNE SURFACE ÉLÈVE. Elles rendent un ÉTAT et une
-- ZONE, tous deux des IDENTIFIANTS que le client met en langue (§2.3, même posture que é04
-- A1.2b). Aucune phrase française n'entre en base, et aucune probabilité ne sort vers un écran.
--
-- STOP-POINT TENU : `get_my_competency_map` (é07 lot 4) n'est pas touchée. Elle reste servie ;
-- sa retraite est une décision de é07, pas d'ici.

-- ---------------------------------------------------------------------------
-- 1. La colonne que la contestation exige, et que le §3.8 n'avait pas prévue.
-- ---------------------------------------------------------------------------
-- D-5/R-10 : « un geste "je ne suis pas d'accord" ramène la croyance à SA VALEUR D'AVANT
-- INFÉRENCE et pose `suspect = true` ». Cette valeur n'était stockée nulle part : le §3.8a
-- donne neuf colonnes, aucune ne garde l'avant. Sans elle, la contestation ne peut que
-- deviner — retomber sur `p_init`, ce qui est exact pour une ligne CRÉÉE par déduction et
-- faux pour une ligne RELEVÉE au-dessus d'une croyance déjà gagnée.
--
-- Le repli par défaut aurait sous-estimé, donc dans le sens charitable, et la première preuve
-- réelle l'aurait corrigé. Mais « ramène à sa valeur d'avant » est écrit ; huit octets rendent
-- la phrase vraie plutôt qu'approximativement vraie. NULL tant qu'aucune inférence n'est en
-- cours sur la ligne — c'est ce qui distingue « rien à annuler » de « annuler vers 0 ».
ALTER TABLE public.user_competency_mastery
  ADD COLUMN IF NOT EXISTS p_known_before NUMERIC;

COMMENT ON COLUMN public.user_competency_mastery.p_known_before IS
  'Étude 30 R-10 : la croyance d''AVANT la déduction en cours, pour que la contestation la restaure. NULL hors inférence.';

-- La propagation du lot 2 la renseigne. Seul changement : deux lignes dans le SET, et
-- `p_known_before` posée à la valeur qu'on écrase — jamais réécrite si une inférence en
-- remplace une autre, sinon deux déductions successives feraient perdre l'origine.
CREATE OR REPLACE FUNCTION public.propagate_competency_belief(
  p_user       UUID,
  p_competency UUID,
  p_belief     NUMERIC,
  p_confirmed_gap BOOLEAN DEFAULT false
) RETURNS INT
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_touched INT := 0;
BEGIN
  WITH RECURSIVE ancestry(competency_id, depth) AS (
    SELECT pr.prereq_id, 1
      FROM public.competency_prereqs pr
     WHERE pr.competency_id = p_competency
    UNION
    SELECT pr.prereq_id, a.depth + 1
      FROM public.competency_prereqs pr
      JOIN ancestry a ON pr.competency_id = a.competency_id
     WHERE a.depth < 2
  ),
  shortest AS (
    SELECT competency_id, min(depth) AS depth
      FROM ancestry
     WHERE competency_id <> p_competency
     GROUP BY competency_id
  ),
  target AS (
    SELECT s.competency_id,
           LEAST(0.90, ROUND(POWER(0.70, s.depth)::NUMERIC * p_belief, 4)) AS p_target
      FROM shortest s
  ),
  raised AS (
    INSERT INTO public.user_competency_mastery AS m
      (user_id, competency_id, last_attempt_at, p_known, belief_source, inferred_from, p_known_before)
    SELECT p_user, t.competency_id, now(), t.p_target, 'inference', p_competency,
           -- Ligne créée par déduction : l'avant est le prior du registre, pas zéro.
           (SELECT c.p_init FROM public.competencies c WHERE c.id = t.competency_id)
      FROM target t
     WHERE NOT p_confirmed_gap
    ON CONFLICT (user_id, competency_id) DO UPDATE SET
      p_known       = EXCLUDED.p_known,
      belief_source = 'inference',
      inferred_from = EXCLUDED.inferred_from,
      -- `COALESCE` et non une affectation sèche : si la ligne est DÉJÀ déduite, son « avant »
      -- reste celui de la toute première déduction. Sinon une seconde inférence effacerait la
      -- valeur gagnée par la preuve, et contester ne ramènerait plus qu'à une autre déduction.
      p_known_before = COALESCE(m.p_known_before, m.p_known)
      WHERE m.p_known < EXCLUDED.p_known
    RETURNING 1
  ),
  suspected AS (
    UPDATE public.user_competency_mastery m
       SET suspect = true
      FROM shortest s
     WHERE p_confirmed_gap
       AND m.user_id = p_user
       AND m.competency_id = s.competency_id
       AND NOT m.suspect
    RETURNING 1
  )
  SELECT (SELECT count(*) FROM raised) + (SELECT count(*) FROM suspected) INTO v_touched;

  RETURN v_touched;
END;
$$;

-- ---------------------------------------------------------------------------
-- 2. L'ÉTAT — les cinq conditions de R-4 en une fonction, jamais recopiées.
-- ---------------------------------------------------------------------------
-- Elle est centralisée pour la même raison que `competency_mastery_alpha` de é07 : c'est la
-- règle métier la plus recopiable de l'étude (la carte, la frontière, le sélecteur du lot 4,
-- le rapport parent de é08 la voudront tous), et une définition de « maîtrisée » qui diverge
-- d'un écran à l'autre est pire que pas de définition du tout.
CREATE OR REPLACE FUNCTION public.competency_state(
  p_known          NUMERIC,
  p_evidence_count INT,
  p_sessions_seen  INT,
  p_forms_count    INT,
  p_last_evidence  TIMESTAMPTZ
) RETURNS TEXT
LANGUAGE sql
STABLE
AS $$
  SELECT CASE
    -- Aucune preuve : `inconnue` n'est pas un jugement, c'est l'absence de jugement. Une ligne
    -- créée par pure déduction (evidence_count = 0) n'est donc PAS « inconnue » — elle porte
    -- une croyance, simplement pas gagnée ; c'est `belief_source` qui le dira à l'écran.
    WHEN p_known IS NULL THEN 'inconnue'
    -- R-4, les CINQ conditions ensemble. « Répétée ET variée » : quatre fois le même QCM ne
    -- déclare rien, et une preuve vieille de deux mois non plus.
    WHEN p_known >= 0.95
     AND COALESCE(p_evidence_count, 0) >= 4
     AND COALESCE(p_sessions_seen, 0)  >= 2
     AND COALESCE(p_forms_count, 0)    >= 2
     AND p_last_evidence IS NOT NULL
     AND p_last_evidence >= now() - INTERVAL '30 days'
      THEN 'maitrisee'
    -- R-5 : en deçà de trois preuves on dit « fragile », JAMAIS « lacune ». Accuser sur deux
    -- items est une erreur de mesure, pas un diagnostic.
    WHEN p_known <= 0.25 AND COALESCE(p_evidence_count, 0) >= 3 THEN 'lacune'
    WHEN p_known <  0.60 THEN 'fragile'
    ELSE 'en-cours'
  END;
$$;

COMMENT ON FUNCTION public.competency_state(NUMERIC, INT, INT, INT, TIMESTAMPTZ) IS
  'Étude 30 R-4/R-5 : les cinq conditions de la maîtrise déclarée, en un seul endroit.';

-- ---------------------------------------------------------------------------
-- 3. P(réussite) prédite — le sélecteur ZPD (§3.4, annexe A.5).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.belief_success_odds(
  p_known NUMERIC, p_guess NUMERIC, p_slip NUMERIC
) RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
AS $$
  -- `P = p·(1−S) + (1−p)·G` : soit l'élève sait et ne fait pas d'étourderie, soit il ne sait
  -- pas et tombe juste. C'est ce que é11 US-13 appelait « probabilité de réussite estimée
  -- 60-80 % » — elle cesse d'être estimée. On y lit aussi, en creux, pourquoi un QCM ennuie
  -- plus tard qu'une saisie libre : à croyance égale il est plus facile, de p(G) exactement.
  SELECT ROUND(p_known * (1 - p_slip) + (1 - p_known) * p_guess, 4);
$$;

COMMENT ON FUNCTION public.belief_success_odds(NUMERIC, NUMERIC, NUMERIC) IS
  'Étude 30 §3.4 / annexe A.5 : P(réussite) prédite avant de servir un item.';

REVOKE EXECUTE ON FUNCTION public.belief_success_odds(NUMERIC, NUMERIC, NUMERIC)
  FROM PUBLIC, anon, authenticated;
-- `competency_state` reste exécutable par le client : c'est un vocabulaire, pas un secret, et
-- les deux lectures ci-dessous sont DEFINER de toute façon. Rien à révoquer.

-- ---------------------------------------------------------------------------
-- 4. get_learning_state — « ce que tu maîtrises, et pourquoi j'en suis sûr ».
-- ---------------------------------------------------------------------------
-- DEFINER, comme ses voisines de é07 lot 4, parce qu'elle lit des colonnes dont les helpers ne
-- sont pas exécutables côté client. Elle ne prend JAMAIS d'identifiant d'élève en paramètre :
-- le périmètre est `(SELECT auth.uid())` en dur (R-6). Sans session, `auth.uid()` est NULL, le
-- filtre ne rend rien, et la fonction renvoie vide au lieu de lever.
CREATE OR REPLACE FUNCTION public.get_learning_state(p_family TEXT DEFAULT NULL)
RETURNS TABLE (
  competency_id UUID,
  slug          TEXT,
  family        TEXT,
  domain        TEXT,
  label_fr      TEXT,
  label_en      TEXT,
  label_ar      TEXT,
  state         TEXT,     -- maitrisee | en-cours | fragile | lacune | inconnue
  zone          TEXT,     -- interieur | frontiere | hors-portee
  p_known       NUMERIC,  -- ⚠️ console d'admin seulement — aucune surface élève ne l'affiche (D-1)
  evidence_count INT,
  sessions_seen  INT,
  forms_count    INT,
  belief_source  TEXT,
  suspect        BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  -- Toutes les compétences de la famille, pas seulement celles qui ont une ligne : une carte
  -- qui ne montrerait que le déjà-joué ne pourrait pas dire « prêt à apprendre ». Le LEFT JOIN
  -- est donc le cœur de la lecture, pas un détail — l'absence de preuve EST une information.
  WITH scored AS (
    SELECT
      c.id, c.slug, c.family,
      split_part(c.slug, '.', 2) AS domain,
      c.label_fr, c.label_en, c.label_ar,
      m.p_known,
      COALESCE(m.evidence_count, 0) AS evidence_count,
      COALESCE(m.sessions_seen, 0)  AS sessions_seen,
      COALESCE(array_length(m.forms_seen, 1), 0) AS forms_count,
      COALESCE(m.belief_source, 'evidence') AS belief_source,
      COALESCE(m.suspect, false) AS suspect,
      public.competency_state(
        m.p_known, m.evidence_count, m.sessions_seen,
        array_length(m.forms_seen, 1), m.last_evidence_at
      ) AS state
    FROM public.competencies c
    LEFT JOIN public.user_competency_mastery m
      ON m.competency_id = c.id AND m.user_id = (SELECT auth.uid())
    WHERE p_family IS NULL OR c.family = p_family
  )
  SELECT
    s.id, s.slug, s.family, s.domain, s.label_fr, s.label_en, s.label_ar,
    s.state,
    CASE
      WHEN s.state = 'maitrisee' THEN 'interieur'
      -- Un prérequis direct non maîtrisé suffit à mettre hors de portée. `NOT EXISTS` plutôt
      -- qu'un comptage : on cherche un contre-exemple, pas une statistique — et une compétence
      -- SANS prérequis est donc dans la frontière, ce qui est exact (rien ne la bloque).
      WHEN EXISTS (
        SELECT 1
          FROM public.competency_prereqs pr
          LEFT JOIN public.user_competency_mastery pm
            ON pm.competency_id = pr.prereq_id AND pm.user_id = (SELECT auth.uid())
         WHERE pr.competency_id = s.id
           AND public.competency_state(
                 pm.p_known, pm.evidence_count, pm.sessions_seen,
                 array_length(pm.forms_seen, 1), pm.last_evidence_at
               ) <> 'maitrisee'
      ) THEN 'hors-portee'
      ELSE 'frontiere'
    END AS zone,
    s.p_known, s.evidence_count, s.sessions_seen, s.forms_count, s.belief_source, s.suspect
  FROM scored s
  ORDER BY s.family, s.domain, s.slug;
$$;

COMMENT ON FUNCTION public.get_learning_state(TEXT) IS
  'Étude 30 §3.10 : l''état (R-4/R-5) et la zone (§3.4) de chaque compétence, pour l''élève connecté.';

-- ---------------------------------------------------------------------------
-- 5. get_learning_frontier — « ce que tu es prêt à apprendre maintenant ».
-- ---------------------------------------------------------------------------
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
  unlocks           INT,     -- fan-out : combien de compétences celle-ci débloque
  entry_exercise_id UUID,
  entry_subject_id  TEXT,
  entry_odds        NUMERIC  -- P(réussite) prédite de l'exercice d'entrée (§3.4)
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH frontier AS (
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
  -- L'exercice d'entrée VISE LA ZPD (§3.4, révision du 2026-08-25). Parmi les exercices que
  -- `get_exercises_for_competency` rend déjà — réutilisée, jamais réécrite, donc la porte
  -- d'accès reste son unique arbitre (R-16) — on retient celui dont la P(réussite) prédite
  -- tombe dans [0,55 ; 0,80], à défaut le plus proche du bord. C'est le mandat point 4 rendu
  -- arithmétique : ni frustration, ni ennui.
  LEFT JOIN LATERAL (
    SELECT ex.exercise_id, ex.subject_id, odds.value AS odds
      FROM public.get_exercises_for_competency(t.slug) ex
      CROSS JOIN LATERAL (
        SELECT public.belief_success_odds(
          COALESCE(t.p_known, 0.20),
          -- Le type d'item de l'exercice est celui de sa question la plus fréquente : un
          -- exercice est homogène en pratique, et prendre la première serait aussi arbitraire.
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
       -- Dans la ZPD d'abord ; sinon le plus proche du bord le plus proche.
       (odds.value BETWEEN 0.55 AND 0.80) DESC,
       LEAST(abs(odds.value - 0.55), abs(odds.value - 0.80)),
       ex.difficulty,
       ex.exercise_id
     LIMIT 1
  ) entry ON true
  ORDER BY t.unlocks DESC, COALESCE(t.p_known, 0) DESC, t.slug;
$$;

COMMENT ON FUNCTION public.get_learning_frontier(TEXT, INT) IS
  'Étude 30 §3.4 : la frontière « prêt à apprendre », triée par fan-out, avec un exercice d''entrée visant la ZPD.';

-- ---------------------------------------------------------------------------
-- 6. dispute_inference — « je ne suis pas d'accord » (US-3, R-10).
-- ---------------------------------------------------------------------------
-- Le mandat parle d'un tuteur autonome, pas d'un tuteur qui a toujours raison. Une croyance
-- déduite est révisable en un geste : elle revient à sa valeur d'avant, et la compétence passe
-- `suspect` — ce qui la fait SONDER EN PRIORITÉ plutôt que punir. Contester n'est pas se
-- pénaliser : c'est demander à être interrogé.
CREATE OR REPLACE FUNCTION public.dispute_inference(p_competency TEXT)
RETURNS TABLE (competency_id UUID, p_known NUMERIC, state TEXT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := (SELECT auth.uid());
BEGIN
  IF v_user IS NULL THEN
    RETURN;  -- pas de session : on ne lève pas, on ne rend rien (posture é07 R-6)
  END IF;

  RETURN QUERY
  UPDATE public.user_competency_mastery m
     SET p_known        = COALESCE(m.p_known_before, c.p_init),
         belief_source  = 'evidence',
         inferred_from  = NULL,
         p_known_before = NULL,
         -- `suspect` marque « à sonder », pas « à sanctionner » : c'est la même colonne que
         -- R-8 pose sur les prérequis d'une lacune, et elle a le même effet — passer devant.
         suspect        = true,
         disputed_at    = now()
    FROM public.competencies c
   WHERE c.id = m.competency_id
     AND c.slug = p_competency
     AND m.user_id = v_user
     -- On ne conteste QUE de la déduction. Une croyance gagnée par la preuve n'est pas une
     -- opinion du système : la refuser reviendrait à effacer ce que l'élève a réellement fait.
     AND m.belief_source = 'inference'
  RETURNING
    m.competency_id,
    m.p_known,
    public.competency_state(m.p_known, m.evidence_count, m.sessions_seen,
                            array_length(m.forms_seen, 1), m.last_evidence_at);
END;
$$;

COMMENT ON FUNCTION public.dispute_inference(TEXT) IS
  'Étude 30 R-10/US-3 : annule une croyance DÉDUITE et marque la compétence à sonder. Sans effet sur une croyance prouvée.';

-- ---------------------------------------------------------------------------
-- 7. Grants — nominatives, réservées à l'élève connecté ; rien pour anon.
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION public.get_learning_state(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_learning_frontier(TEXT, INT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.dispute_inference(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_learning_state(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_learning_frontier(TEXT, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.dispute_inference(TEXT) TO authenticated;
