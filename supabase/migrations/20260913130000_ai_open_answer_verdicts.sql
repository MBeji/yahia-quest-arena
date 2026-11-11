-- Étude 33 lot 2 — LE FILET : une réponse libre refusée passe devant un juge.
--
-- CE QUE CE LOT RETOURNE, ET CE QU'IL NE TOUCHE PAS
-- ---------------------------------------------------------------------------
-- L'étude 20 a posé « zéro IA au runtime » (R-7) et l'a bien posé : le scoring
-- déterministe est gratuit, instantané, reproductible, et il n'expose aucun
-- oracle. Rien de cela ne change ici. Ce qui change est le sort d'un REFUS.
--
-- L'ensemble { canonique } ∪ `accepted_answers` a une asymétrie que son étude
-- nomme elle-même : quand il accepte il a raison, quand il refuse il ne sait
-- pas. « فوق الشجرة » là où la clé disait « فوقها » était une réponse JUSTE,
-- comptée fausse en production, et il a fallu un signalement humain pour la
-- voir (privé #96). Le lot 6 d'é20 — « refus contesté » — était la réponse
-- prévue : file admin, auteur qui tranche, variante ajoutée au fichier. Il n'a
-- jamais été livré, et il est par nature POSTÉRIEUR à l'injustice : l'enfant a
-- déjà perdu ses points, et souvent la confiance qui allait avec.
--
-- L'arbitrage du propriétaire (2026-09-13) le rend SYNCHRONE : la question
-- ouverte n'est servie qu'à qui a un juge (lot 1), et le juge tranche le refus
-- avant que la note ne tombe.
--
-- LES QUATRE INVARIANTS QUI RENDENT CE FILET SÛR
-- ---------------------------------------------------------------------------
--   1. LE MODÈLE NE PEUT QU'AJOUTER. Il n'est consulté que sur une réponse déjà
--      REFUSÉE. Il ne voit jamais une acceptation, ne peut donc pas en retirer
--      une. Le déterministe est un plancher, pas un avis.
--   2. IL NE PEUT PAS RENDRE JUSTE CE QUE L'AUTEUR A DÉCLARÉ FAUX. R-4 d'é20
--      tenait à la génération hors-ligne ; ici elle tient à
--      `record_ai_open_answer_verdict`, qui REFUSE d'enregistrer une
--      acceptation qui égalerait une erreur attendue (`answer_key -> mistakes`).
--      La garantie est en SQL, pas dans un prompt — un modèle qu'on convainc ne
--      convainc pas cette ligne-là.
--   3. IL N'ÉCRIT PAS DANS LE CORPUS. `accepted_answers` reste un fichier
--      versionné, relu dans un diff, et rien de ce qui se passe ici ne le
--      modifie — é20 R-7 tient mot pour mot. Ce que ce lot écrit est un verdict
--      PAR ÉLÈVE, pour UN texte, sur UNE question : une trace, pas une règle.
--      Une variante qui revient souvent reste à porter au corpus par un humain,
--      et cette table est justement ce qui permettra de les compter.
--   4. UNE PANNE NE CHANGE RIEN. Pas de ligne ⇒ le verdict déterministe, à
--      l'identique. Le pire cas de ce lot est le comportement d'avant.
--
-- POURQUOI UNE TABLE, ET PAS UN ARGUMENT DE PLUS SUR LES RPC DE NOTATION
-- ---------------------------------------------------------------------------
-- L'arbitrage se décide dans Node (c'est lui qui parle au modèle), la note se
-- calcule en SQL. Il fallait un passage. Un paramètre `p_ai_accepted` sur
-- `submit_exercise_attempt` aurait été le plus court — et forgeable : la RPC est
-- `GRANT`ée à `authenticated`, donc n'importe quel client aurait pu se déclarer
-- arbitré juste. La table, elle, n'est écrite que par une fonction réservée au
-- `service_role`, et par ce chemin-là uniquement.
--
-- Elle rend en prime deux choses qu'un paramètre n'aurait pas données : un CACHE
-- (le même élève retapant le même texte ne repaie pas un appel) et une PISTE
-- D'AUDIT (quel modèle a accepté quoi, et quand).

-- ---------------------------------------------------------------------------
-- 1. La table des verdicts.
--
-- La clé primaire dit la granularité : un verdict vaut pour UN élève, UNE
-- question, UN texte normalisé. Pas pour la question — sinon le premier
-- arbitrage vaudrait pour tout le monde, et une acceptation douteuse se
-- propagerait à tout le parc. Pas pour le texte brut non plus : « Le Triangle »
-- et « le triangle » sont la même réponse, et la table le sait parce qu'elle
-- stocke ce que `normalize_recall_text` en fait — la MÊME normalisation que le
-- scoring, jamais une seconde implémentation (é20 D-3).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_open_answer_verdicts (
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  question_id     UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  -- Le texte tapé, passé par `normalize_recall_text`. Jamais le texte brut : la
  -- comparaison au scoring se fait sur la forme normalisée, et deux colonnes
  -- qui se ressemblent finissent par diverger.
  choice_norm     TEXT NOT NULL,
  accepted        BOOLEAN NOT NULL,
  -- Le modèle qui a tranché. Sans lui, un arbitrage douteux ne se rattache à
  -- rien — et c'est la première question qu'on se pose devant une acceptation
  -- surprenante (R-13, le fournisseur RÉEL).
  model           TEXT NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (student_user_id, question_id, choice_norm)
);

ALTER TABLE public.ai_open_answer_verdicts ENABLE ROW LEVEL SECURITY;

-- ⚠️ AUCUNE POLICY, AUCUN DROIT CLIENT — même posture que `ai_forged_quizzes`.
-- Lue, cette table est un ORACLE : « tape ceci, c'est accepté ». Elle ne se lit
-- que par les fonctions SECURITY DEFINER ci-dessous, qui ne rendent jamais que
-- le booléen dont le scoring a besoin.
REVOKE ALL ON public.ai_open_answer_verdicts FROM PUBLIC, anon, authenticated;
GRANT ALL ON public.ai_open_answer_verdicts TO service_role;

COMMENT ON TABLE public.ai_open_answer_verdicts IS
  'Étude 33 : verdicts d''arbitrage IA sur des réponses libres REFUSÉES par l''ensemble '
  'déterministe. Par (élève, question, texte normalisé). Ne modifie jamais accepted_answers.';

-- ---------------------------------------------------------------------------
-- 2. La lecture, pour le scoring — un booléen, et rien d'autre.
--
-- `auth.uid()` et non un paramètre : appelée depuis `score_answer`, qui ne
-- connaît pas l'élève. Anonyme ⇒ NULL ⇒ aucune ligne ⇒ `false`, ce qui est la
-- bonne réponse (le catalogue public ne sert aucune question ouverte, lot 1).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.has_ai_open_answer_verdict(p_question UUID, p_choice TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.ai_open_answer_verdicts v
    WHERE v.student_user_id = (SELECT auth.uid())
      AND v.question_id = p_question
      AND v.choice_norm = public.normalize_recall_text(p_choice)
      AND v.accepted
  );
$$;

REVOKE EXECUTE ON FUNCTION public.has_ai_open_answer_verdict(UUID, TEXT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. LE VERDICT DÉTERMINISTE, ÉTENDU D'UN SEUL REPLI.
--
-- `score_answer` recréée VERBATIM (patron B1→B3) : seule la branche
-- `short_answer` change, et elle ne change que dans le sens « le refus peut
-- avoir été renversé ». Les cinq autres types ne bougent pas d'un caractère.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.score_answer(q public.questions, p_choice text)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  v_answer numeric;
  v_value numeric;
  v_tolerance numeric;
BEGIN
  IF p_choice IS NULL THEN
    RETURN false;
  END IF;

  -- 'mcq' fast path: strictly the historical semantics (zero regression, US-4).
  IF q.question_type = 'mcq' OR q.question_type IS NULL THEN
    RETURN q.correct_option = p_choice;
  END IF;

  IF q.question_type = 'numeric' THEN
    IF q.answer_key IS NULL OR NOT (q.answer_key ? 'value') THEN
      RETURN false;
    END IF;
    BEGIN
      -- Accept '-', '.' and ',' (normalized) — US-1. Unparseable input is a
      -- wrong answer, never an exception (a bad payload must not kill a session).
      v_answer := replace(btrim(p_choice), ',', '.')::numeric;
      v_value := (q.answer_key ->> 'value')::numeric;
      v_tolerance := COALESCE((q.answer_key ->> 'tolerance')::numeric, 0);
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
    RETURN abs(v_answer - v_value) <= v_tolerance;
  END IF;

  -- 'ordering': the submitted id CSV must reproduce the key's EXACT sequence.
  -- All-or-nothing (no partial credit, spec R-2); whitespace-insensitive.
  IF q.question_type = 'ordering' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'order') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(t.part ORDER BY t.ord), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) WITH ORDINALITY AS t(part, ord)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(k.val ORDER BY k.ord), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'matching': the submitted "left:right" pair CSV must equal the key's pair
  -- SET (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'matching' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'pairs') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(
          array_agg(DISTINCT ((p.pair ->> 0) || ':' || (p.pair ->> 1))
                    ORDER BY ((p.pair ->> 0) || ':' || (p.pair ->> 1))),
          ARRAY[]::text[]
        )
        FROM jsonb_array_elements(q.answer_key -> 'pairs') AS p(pair)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'multi': the checked option ids as a CSV — SET equality with the key
  -- (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'multi' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'correct') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(DISTINCT k.val ORDER BY k.val), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'correct') AS k(val)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'short_answer' (étude 20 R-11): free typed text, scored by MEMBERSHIP in
  -- { canonical } ∪ accepted_answers — the single implementation shared with
  -- the Recall mode (`is_accepted_free_answer`, lot 1). A malformed key scores
  -- false and never raises (posture étude 03).
  IF q.question_type = 'short_answer' THEN
    IF q.answer_key IS NULL OR NOT (q.answer_key ? 'text') THEN
      RETURN false;
    END IF;
    -- 1. Le PLANCHER, inchangé : l'appartenance à l'ensemble authored. Une
    --    réponse acceptée ici l'est sans qu'aucun modèle soit consulté — c'est
    --    le cas ordinaire, et il reste gratuit, instantané et reproductible.
    IF COALESCE(public.is_accepted_free_answer(q, p_choice), false) THEN
      RETURN true;
    END IF;
    -- 2. LE FILET (étude 33). Un refus déterministe peut avoir été renversé, en
    --    amont de cette transaction, par l'arbitrage IA — et seulement dans ce
    --    sens. Le modèle ne peut rien REFUSER : il n'est consulté que sur ce que
    --    l'ensemble a déjà rejeté, donc son verdict ne peut qu'AJOUTER des
    --    réponses justes. Un fournisseur en panne, une clé révoquée, un mode
    --    éteint ⇒ aucune ligne ⇒ le verdict d'avant, à l'identique.
    RETURN public.has_ai_open_answer_verdict(q.id, p_choice);
  END IF;

  -- Unknown / future types: score false, never crash (R-3).
  RETURN false;
END;
$$;

-- Server-side only (posture inchangée) : aucun oracle de clé côté client.
REVOKE EXECUTE ON FUNCTION public.score_answer(public.questions, text) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. CE QU'IL RESTE À ARBITRER — la liste, calculée en base.
--
-- Node ne refait AUCUN test : il demande « parmi ces réponses, lesquelles le
-- déterministe a-t-il refusées, et pour lesquelles n'ai-je pas déjà un verdict
-- ? ». La normalisation, l'appartenance à l'ensemble et le cache sont trois
-- règles qui vivent en SQL (é20 D-3) ; les rejouer en TypeScript, c'est la
-- divergence garantie que le corpus de parité de `free-answer.ts` existe
-- justement pour contenir.
--
-- ⚠️ ELLE REND LA RÉPONSE ATTENDUE. C'est nécessaire — un juge qui ne connaît
-- pas la réponse n'arbitre rien — et c'est pour cela qu'elle est réservée au
-- `service_role` : le texte va dans un prompt, jamais dans une réponse HTTP.
-- L'appelant (`open-answer.server.ts`) porte le même avertissement, et son test
-- vérifie que le champ ne ressort pas.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.ai_open_answer_candidates(p_student UUID, p_answers JSONB)
RETURNS TABLE (
  question_id UUID,
  prompt TEXT,
  expected TEXT,
  choice TEXT,
  content_language TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH answered AS (
    SELECT DISTINCT ON (x.question_id) x.question_id, x.choice
    FROM (
      SELECT
        NULLIF(elem ->> 'questionId', '')::UUID AS question_id,
        elem ->> 'choice' AS choice
      FROM jsonb_array_elements(
             CASE WHEN jsonb_typeof(p_answers) = 'array'
                  THEN p_answers ELSE '[]'::jsonb END
           ) AS elem
    ) x
    WHERE x.question_id IS NOT NULL
      AND x.choice IS NOT NULL
    ORDER BY x.question_id
  )
  SELECT
    q.id,
    q.prompt,
    q.answer_key ->> 'text',
    a.choice,
    COALESCE(s.content_language, 'fr')
  FROM answered a
  JOIN public.questions q ON q.id = a.question_id
  JOIN public.exercises e ON e.id = q.exercise_id
  JOIN public.subjects  s ON s.id = e.subject_id
  WHERE q.question_type = 'short_answer'
    AND q.answer_key ? 'text'
    -- La porte du lot 1, re-vérifiée ICI : sans elle, un appel forgé ferait
    -- payer un arbitrage pour une question qui n'est même pas servie.
    AND public.can_play_open_questions(p_student)
    -- Le déterministe d'abord, toujours. Ce qu'il accepte ne coûte rien.
    AND NOT COALESCE(public.is_accepted_free_answer(q, a.choice), false)
    -- Une saisie qui se normalise en vide n'est pas une réponse à juger.
    AND public.normalize_recall_text(a.choice) <> ''
    -- Déjà tranché pour ce couple : le cache évite un second appel, et fige le
    -- verdict (rejouer ne doit pas donner une autre note).
    AND NOT EXISTS (
      SELECT 1
      FROM public.ai_open_answer_verdicts v
      WHERE v.student_user_id = p_student
        AND v.question_id = q.id
        AND v.choice_norm = public.normalize_recall_text(a.choice)
    );
$$;

REVOKE EXECUTE ON FUNCTION public.ai_open_answer_candidates(UUID, JSONB)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. L'ÉCRITURE DU VERDICT — et le mur de R-4.
--
-- Elle rend le verdict RÉELLEMENT enregistré, qui n'est pas toujours celui
-- qu'on lui passe : une acceptation qui égalerait une erreur attendue est
-- ramenée à un refus, en silence côté appelant et bruyamment dans la ligne
-- écrite. C'est la traduction exacte de R-4 d'é20 — « élargir l'acceptation ne
-- rend jamais juste un élément déclaré faux » — appliquée à un juge qu'on ne
-- contrôle pas. Un modèle persuadé par un énoncé bricolé ne franchit pas ce
-- `IF`.
--
-- `ON CONFLICT DO NOTHING` : le PREMIER verdict fait foi. Une seconde
-- soumission du même texte ne rejoue pas l'arbitrage et ne peut pas retourner
-- la note — une même réponse vaut la même chose, toujours.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_ai_open_answer_verdict(
  p_student  UUID,
  p_question UUID,
  p_choice   TEXT,
  p_accepted BOOLEAN,
  p_model    TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_q        public.questions;
  v_norm     TEXT;
  v_accepted BOOLEAN := COALESCE(p_accepted, false);
BEGIN
  IF p_student IS NULL OR p_question IS NULL THEN
    RETURN false;
  END IF;

  SELECT * INTO v_q FROM public.questions WHERE id = p_question;
  IF NOT FOUND OR v_q.question_type <> 'short_answer' THEN
    RETURN false;
  END IF;

  v_norm := public.normalize_recall_text(p_choice);
  IF v_norm IS NULL OR v_norm = '' THEN
    RETURN false;
  END IF;

  -- LE MUR (é20 R-4). Une erreur ATTENDUE — le pendant du distracteur pour une
  -- question sans propositions — reste fausse quoi qu'en dise le modèle.
  IF v_accepted AND EXISTS (
       SELECT 1
       FROM jsonb_array_elements(
              CASE WHEN jsonb_typeof(v_q.answer_key -> 'mistakes') = 'array'
                   THEN v_q.answer_key -> 'mistakes'
                   ELSE '[]'::jsonb END
            ) AS m
       WHERE public.normalize_recall_text(m ->> 'text') = v_norm
     ) THEN
    v_accepted := false;
  END IF;

  INSERT INTO public.ai_open_answer_verdicts
    (student_user_id, question_id, choice_norm, accepted, model)
  VALUES
    (p_student, p_question, v_norm, v_accepted, COALESCE(NULLIF(p_model, ''), 'unknown'))
  ON CONFLICT (student_user_id, question_id, choice_norm) DO NOTHING;

  RETURN v_accepted;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.record_ai_open_answer_verdict(UUID, UUID, TEXT, BOOLEAN, TEXT)
  FROM PUBLIC, anon, authenticated;
