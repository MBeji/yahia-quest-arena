-- Étude 20 — Réponses acceptées · lot 1 (socle du scoring ensembliste).
--
-- Problème (constaté en production le 2026-07-15) : le mode Rappel (étude 17)
-- compare la saisie à l'UNIQUE texte de la bonne option. Une réponse juste
-- formulée autrement — « فوق الشجرة » là où l'option dit « فوقها » — est refusée.
-- Cause racine : le moteur ne connaît qu'UNE réponse acceptable là où il en
-- existe plusieurs.
--
-- Ce lot pose le socle, sans générer aucun contenu (les ensembles arrivent aux
-- lots 2–4, dans le repo privé du corpus) :
--   * colonne `questions.accepted_answers` — server-only, défaut '[]' (R-1) ;
--   * `is_accepted_free_answer` — L'UNIQUE implémentation du verdict « saisie
--     libre » : appartenance normalisée à { canonique } ∪ accepted_answers (R-3,
--     D-9). Le lot 7 la BRANCHE dans la seam `score_answer` sans la modifier —
--     d'où la branche `short_answer` déjà présente ici ;
--   * `score_recall_answer` — délègue, comportement à ensemble vide STRICTEMENT
--     identique à l'étude 17 (aucune régression, R-2) ;
--   * `content_reports.kind` — cadrage du type `recall_false_negative` (Q-3) ;
--     la file admin reste au lot 6.
--
-- NON touchés (stop-points du lot) : `normalize_recall_text` (R-8),
-- `is_question_recall_eligible` (R-6/Q-4), la seam `score_answer` (lot 7), les
-- RPCs de soumission (elles appellent déjà `score_recall_answer`).

-- ---------------------------------------------------------------------------
-- 1. L'ensemble accepté — une colonne additive, server-only.
--    Défaut '[]' = pas de backfill, et toute question non dotée score comme
--    avant. NOT NULL + DEFAULT : pas de réécriture de table (PG 11+).
-- ---------------------------------------------------------------------------
ALTER TABLE public.questions
  ADD COLUMN IF NOT EXISTS accepted_answers jsonb NOT NULL DEFAULT '[]'::jsonb;

-- Invariant de FORME seulement. Le contenu de l'array (charset R-5,
-- anti-collision R-4, bornes) est garanti à la COMPILATION par `content:qa` :
-- le scoring fait confiance à l'ensemble déjà validé, exactement comme il fait
-- confiance à `correct_option` (étude §5). D'où : la garde QA est bloquante en
-- CI et la revue humaine obligatoire (R-7).
ALTER TABLE public.questions
  DROP CONSTRAINT IF EXISTS questions_accepted_answers_is_array;
ALTER TABLE public.questions
  ADD CONSTRAINT questions_accepted_answers_is_array
  CHECK (jsonb_typeof(accepted_answers) = 'array');

-- R-1 / RISK-5 — même posture que `correct_option`, `answer_key`,
-- `distractor_tags` : la colonne existe mais n'est JAMAIS dans une whitelist
-- client. Les droits sur `public.questions` sont accordés COLONNE PAR COLONNE
-- (20260610170000_hide_answer_key.sql a révoqué le SELECT de table puis
-- granté 5 colonnes ; 20260705130000 y a ajouté `question_type`), donc une
-- colonne nouvelle est invisible par défaut. Ce REVOKE explicite reprend le
-- précédent de `distractor_tags` (20260706120000) : il ne corrige rien, il
-- documente et verrouille l'intention.
REVOKE SELECT (accepted_answers) ON public.questions FROM anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. Le verdict « saisie libre » — UNE implémentation, deux consommateurs (D-9).
--    Appartenance normalisée à { réponse canonique } ∪ accepted_answers.
--    Déterministe, tout-ou-rien, aucune distance d'édition, aucun appel modèle
--    (D-1). REVOKEd : pas d'oracle client.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_accepted_free_answer(q public.questions, p_choice text)
RETURNS boolean
STABLE
LANGUAGE sql
SET search_path = public
AS $$
  SELECT btrim(coalesce(p_choice, '')) <> ''
     AND public.normalize_recall_text(p_choice) IN (
       SELECT s.n
       FROM (
         -- La réponse canonique, TOUJOURS acceptée sans avoir à la répéter
         -- (R-2). `short_answer` (lot 7) lit sa clé typée ; tout le reste lit
         -- le texte de la bonne option — le cas du mode Rappel.
         SELECT public.normalize_recall_text(
                  CASE
                    WHEN q.question_type = 'short_answer' THEN q.answer_key ->> 'text'
                    ELSE (SELECT opt ->> 'text'
                            FROM jsonb_array_elements(q.options) opt
                           WHERE opt ->> 'id' = q.correct_option
                           LIMIT 1)
                  END) AS n
         UNION
         -- Les variantes acceptées, authored/générées hors-ligne (R-7).
         SELECT public.normalize_recall_text(x)
         FROM jsonb_array_elements_text(q.accepted_answers) AS x
       ) s
       -- Un membre qui se normalise en VIDE n'est jamais une réponse : sans ce
       -- filtre, une clé malformée (option introuvable, `answer_key` sans
       -- `text`) produirait la canonique '' et une saisie hors-charset — « π »
       -- se normalise en '' — scorerait VRAI. La spec exige l'inverse (§5 :
       -- « clé malformée ⇒ faux »). R-5 garantit par ailleurs qu'aucun membre
       -- légitime ne se normalise en vide, donc le filtre ne retire rien de bon.
       WHERE s.n <> ''
     );
$$;

REVOKE EXECUTE ON FUNCTION public.is_accepted_free_answer(public.questions, text)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Le scorer du MODE Rappel délègue. Signature, posture STABLE et REVOKE
--    inchangés (D-3 étude 17). Avec `accepted_answers = '[]'`, le verdict est
--    celui de l'étude 17 à l'identique — prouvé par un cas pgTAP dédié.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.score_recall_answer(q public.questions, p_choice text)
RETURNS boolean
STABLE
LANGUAGE sql
SET search_path = public
AS $$
  SELECT COALESCE(public.is_accepted_free_answer(q, p_choice), false);
$$;

REVOKE EXECUTE ON FUNCTION public.score_recall_answer(public.questions, text)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. « Refus contesté » — cadrage du type seulement (Q-3, arbitrée 2026-07-15).
--    Un élève qui juge sa réponse refusée-mais-juste la remonte via le bouton
--    « Signaler une erreur » existant (US-5). On pose ici le DISCRIMINANT pour
--    que ces signalements soient distinguables dès maintenant ; la file admin
--    et la procédure d'ajout de variante sont le lot 6, quand le volume réel
--    sera connu. Défaut = le comportement actuel, donc zéro backfill.
-- ---------------------------------------------------------------------------
ALTER TABLE public.content_reports
  ADD COLUMN IF NOT EXISTS kind text NOT NULL DEFAULT 'content_error';

ALTER TABLE public.content_reports
  DROP CONSTRAINT IF EXISTS content_reports_kind_check;
ALTER TABLE public.content_reports
  ADD CONSTRAINT content_reports_kind_check
  CHECK (kind IN ('content_error', 'recall_false_negative'));

-- Aucun GRANT nouveau : `content_reports` porte déjà GRANT SELECT, INSERT TO
-- authenticated (20260603170000) et la policy d'insertion contraint
-- `user_id = auth.uid() AND status = 'open'` — `kind` est une donnée de
-- l'utilisateur sur SA propre ligne, sans secret.
