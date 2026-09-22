-- =========================================================
-- Étude 33 — R-4 REJOUÉE À LA LECTURE DU VERDICT (#1074, point 1).
-- ---------------------------------------------------------
-- CE QUI CLOCHAIT. Le mur de R-4 (« élargir l'acceptation ne rend JAMAIS juste
-- un élément déclaré faux », é20) était posé dans
-- `record_ai_open_answer_verdict` — donc à l'INSTANT de l'arbitrage. Il a tenu
-- quand le modèle a tranché ; il ne tenait plus quand le CONTENU bougeait
-- ensuite. Un auteur qui ajoute après coup à `answer_key -> 'mistakes'` un
-- texte déjà accepté pour un élève laissait la ligne `accepted = true`
-- continuer de noter cet élève juste, pour cette question, indéfiniment.
--
-- Le `ON CONFLICT … DO NOTHING` de l'écriture scellait le piège : un second
-- passage ne réécrit jamais une ligne existante, donc rien, jamais, ne venait
-- rattraper l'acceptation devenue caduque. Pire, `record_…` renvoyait alors
-- `false` (le mur a joué sur SA variable) pendant que la lecture, elle, rendait
-- toujours `true` : deux réponses contradictoires sur le même fait.
--
-- CE QU'ON CHANGE. Le test des erreurs attendues passe dans le chemin de
-- LECTURE, donc il est rejoué à CHAQUE notation. `answer_key` étant lu au
-- moment du scoring, la correction d'un auteur prend effet à la question
-- suivante, sans migration de données et sans toucher aux lignes écrites.
--
-- CE QU'ON NE CHANGE PAS — et c'est délibéré :
--   • le garde à l'ÉCRITURE reste. Il évite d'écrire une ligne qui ne servira
--     jamais, et surtout il journalise le désaccord
--     (`ai.openAnswer.blockedByMistakeKey`) : le signal qui dit qu'un modèle
--     vient de valider ce que le contenu déclare faux. Retirer un filet parce
--     que l'autre existe est exactement le geste contre lequel
--     `docs/agents/pieges-du-code.md` met en garde.
--   • le GRAND LIVRE des verdicts n'est pas réécrit. Ce que le modèle a répondu
--     ce jour-là reste vrai comme trace ; c'est sa PORTÉE qui se re-décide à
--     la lecture. Une trace d'arbitrage qu'on corrige a posteriori n'est plus
--     une trace.
--   • la signature est identique (mêmes arguments, même retour) : `types.ts`
--     reste valide, aucun appelant ne bouge.
--
-- COÛT. Une lecture de `questions` par clé primaire, sur la branche RARE
-- (l'ensemble authored a déjà refusé) et sur une ligne que l'appelant vient de
-- lire — donc en cache. Lire `questions` depuis une fonction SECURITY DEFINER
-- est déjà le patron de `record_ai_open_answer_verdict`, juste à côté.
-- La clé de réponse ne sort pas : le test vit en SQL, seul un booléen remonte.
-- =========================================================

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
    JOIN public.questions q ON q.id = v.question_id
    WHERE v.student_user_id = (SELECT auth.uid())
      AND v.question_id = p_question
      AND v.choice_norm = public.normalize_recall_text(p_choice)
      AND v.accepted
      -- LE MUR (é20 R-4), rejoué ici : l'erreur ATTENDUE telle qu'elle est
      -- déclarée MAINTENANT, pas telle qu'elle l'était au moment du verdict.
      AND NOT EXISTS (
        SELECT 1
        FROM jsonb_array_elements(
               CASE WHEN jsonb_typeof(q.answer_key -> 'mistakes') = 'array'
                    THEN q.answer_key -> 'mistakes'
                    ELSE '[]'::jsonb END
             ) AS m
        WHERE public.normalize_recall_text(m ->> 'text') = v.choice_norm
      )
  );
$$;

-- Inchangé, re-déclaré parce qu'un `CREATE OR REPLACE` ne rétablit pas les
-- privilèges d'une fonction recréée sous un autre propriétaire : l'oracle ne
-- se consulte pas directement, il ne se traverse que par `score_answer`.
REVOKE EXECUTE ON FUNCTION public.has_ai_open_answer_verdict(UUID, TEXT)
  FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION public.has_ai_open_answer_verdict(UUID, TEXT) IS
  'Verdict IA d''une réponse ouverte pour l''élève courant. Re-teste les erreurs '
  'attendues de la question À CHAQUE LECTURE (é20 R-4) : un texte ajouté à '
  '`mistakes` après coup redevient faux sans que le grand livre soit réécrit.';
