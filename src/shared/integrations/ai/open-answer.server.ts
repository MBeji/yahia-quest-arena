// L'ARBITRAGE d'une réponse libre refusée — étude 33 lot 2, l'orchestration.
//
// LA SEAM, ET POURQUOI ELLE EST OÙ ELLE EST
// ---------------------------------------------------------------------------
// L'arbitrage doit s'intercaler entre « l'élève valide » et « la base note ».
// Il ne peut pas vivre dans le SQL (il faut parler à un modèle), et il ne peut
// pas vivre dans la RPC de notation (elle est `GRANT`ée à `authenticated`, donc
// tout ce qu'on lui passerait serait forgeable). Il vit donc ici, avant l'appel
// à la notation, et il laisse en base une TRACE que la notation relit —
// `ai_open_answer_verdicts`, écrite par le seul `service_role`.
//
// POURQUOI `callAi` EST INJECTÉ PLUTÔT QU'IMPORTÉ
// ---------------------------------------------------------------------------
// `callAi` vit dans `@/features/ai/ai-call.server`. `features/tutor` l'importe
// directement (lots 1 et 3 d'é11) et le précédent est assumé : c'est la porte
// unique vers le modèle. Mais ce module-ci est dans `shared/`, et un import
// `shared/ → features/` INVERSE la dépendance — c'est pire que le franchissement
// horizontal du tuteur, pas mieux. L'appelant passe donc la porte en paramètre :
// `quest` importe `callAi` comme `tutor` le fait, et ce module reste un module
// partagé qui ne connaît personne. Bénéfice secondaire, et il n'est pas mince :
// le test exerce la chaîne complète avec un faux juge de quatre lignes, sans
// monter le graphe d'imports du mode IA.
//
// CE QUE CE MODULE NE RENVOIE PAS
// ---------------------------------------------------------------------------
// Rien. Il ne dit pas à l'appelant combien de réponses ont été renversées, et
// surtout jamais `expected` — la réponse canonique, qu'il reçoit pour la mettre
// dans un prompt. La note reste calculée par la RPC, une fois, à partir de la
// base : un second chemin qui dirait « et en plus, celle-ci est juste » serait
// un second barème.

import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import type { Database } from "@/shared/integrations/supabase/types";
import {
  buildOpenAnswerBlocks,
  readOpenAnswerVerdict,
  OPEN_ANSWER_JSON_SCHEMA,
  OPEN_ANSWER_SYSTEM,
  type OpenAnswerCandidate,
  type OpenAnswerLang,
} from "./open-answer";

/**
 * Plafond d'arbitrages par soumission.
 *
 * Le corpus pilote porte UNE question ouverte par mission (é20 lot 8), donc le
 * cas nominal est 1. Ce plafond existe pour le jour où une mission en porterait
 * dix : l'élève attend son score, écran bloqué, et dix allers-retours séquentiels
 * transformeraient une correction en chargement. Au-delà, les questions
 * excédentaires gardent leur verdict déterministe — c'est une dégradation, pas
 * une panne, et elle se lit dans le log.
 */
export const OPEN_ANSWER_MAX_PER_SUBMISSION = 4;

/** La porte vers le modèle, telle que `callAi` l'expose. Injectée par l'appelant. */
export type OpenAnswerJudge = (request: {
  studentUserId: string;
  feature: "open_answer";
  tier: "fast";
  system: string;
  blocks: ReturnType<typeof buildOpenAnswerBlocks>;
  responseSchema: Record<string, unknown>;
}) => Promise<
  { ok: true; text: string; model: string } | { ok: false; code: string } | { ok: boolean }
>;

/**
 * La ligne rendue par `ai_open_answer_candidates`, prise du type GÉNÉRÉ. Elle
 * a été décrite à la main tant que la RPC était plus récente que `types.ts` ;
 * elle y est depuis, et c'est la base qui doit dire sa forme — une colonne qui
 * bouge casse alors ici, au `tsc`, et non à l'exécution.
 */
type CandidateRow = Database["public"]["Functions"]["ai_open_answer_candidates"]["Returns"][number];

const LANGS: ReadonlySet<string> = new Set(["fr", "en", "ar"]);

function toCandidate(row: CandidateRow): OpenAnswerCandidate {
  return {
    questionId: row.question_id,
    prompt: row.prompt,
    expected: row.expected,
    choice: row.choice,
    // Une matière dont la langue est inconnue ou exotique est corrigée en
    // français : c'est la langue de l'énoncé par défaut du catalogue, et se
    // tromper de langue de consigne coûte moins cher que de ne pas arbitrer.
    lang: (LANGS.has(row.content_language) ? row.content_language : "fr") as OpenAnswerLang,
  };
}

/**
 * Arbitre les réponses libres que l'ensemble déterministe a REFUSÉES, et écrit
 * les verdicts avant que la notation ne lise la base.
 *
 * NE LÈVE JAMAIS. Tout ce qui peut mal tourner ici — la base, le fournisseur, un
 * modèle qui bafouille — laisse simplement le verdict déterministe en place.
 * C'est la posture de dégradation silencieuse d'é11 R-15, et elle est ici plus
 * forte qu'ailleurs : ce module n'ajoute que des points, donc son échec ne peut
 * pas en retirer.
 */
export async function arbitrateOpenAnswers(input: {
  studentUserId: string;
  answers: ReadonlyArray<{ questionId: string; choice: string }>;
  judge: OpenAnswerJudge;
}): Promise<void> {
  const { studentUserId, answers, judge } = input;
  if (answers.length === 0) return;

  let rows: CandidateRow[];
  try {
    // C'est la BASE qui décide ce qu'il reste à arbitrer : la porte du lot 1, le
    // test d'appartenance, la normalisation et le cache sont quatre règles qui
    // vivent en SQL (é20 D-3). Les rejouer ici, c'est la divergence garantie.
    const { data, error } = await supabaseAdmin.rpc("ai_open_answer_candidates", {
      p_student: studentUserId,
      p_answers: answers.map((a) => ({ questionId: a.questionId, choice: a.choice })),
    });
    if (error) {
      logger.warn("ai.openAnswer.candidates", { error: error.message });
      return;
    }
    rows = Array.isArray(data) ? data : [];
  } catch (cause) {
    logger.warn("ai.openAnswer.candidates", { error: errorMessage(cause) });
    return;
  }

  if (rows.length === 0) return;

  const budget = rows.slice(0, OPEN_ANSWER_MAX_PER_SUBMISSION);
  if (rows.length > budget.length) {
    logger.info("ai.openAnswer.capped", { asked: rows.length, kept: budget.length });
  }

  let overturned = 0;
  for (const row of budget) {
    const candidate = toCandidate(row);

    let verdict: boolean | null = null;
    let model = "unknown";
    try {
      const outcome = await judge({
        studentUserId,
        feature: "open_answer",
        tier: "fast",
        system: OPEN_ANSWER_SYSTEM,
        blocks: buildOpenAnswerBlocks(candidate),
        responseSchema: OPEN_ANSWER_JSON_SCHEMA,
      });
      if (outcome.ok === true && "text" in outcome) {
        verdict = readOpenAnswerVerdict(outcome.text);
        model = outcome.model;
      }
    } catch (cause) {
      // `callAi` rend un refus TYPÉ plutôt que de lever, mais la porte est
      // injectée : on ne parie pas sur la politesse d'une implémentation.
      logger.warn("ai.openAnswer.judge", { error: errorMessage(cause) });
    }

    // `null` ⇒ le modèle n'a rien prononcé (panne, sortie hors schéma). On
    // n'écrit RIEN : inscrire un refus fabriqué figerait pour toujours, par le
    // cache, une réponse qu'aucun juge n'a lue. Le déterministe tranche seul,
    // et un prochain essai pourra être arbitré.
    if (verdict === null) continue;

    try {
      const { data: recorded, error } = await supabaseAdmin.rpc("record_ai_open_answer_verdict", {
        p_student: studentUserId,
        p_question: candidate.questionId,
        p_choice: candidate.choice,
        p_accepted: verdict,
        p_model: model,
      });
      if (error) {
        logger.warn("ai.openAnswer.record", { error: error.message });
        continue;
      }
      // `recorded` peut valoir `false` là où `verdict` valait `true` : le mur de
      // R-4 en SQL a ramené une acceptation à un refus parce que le texte égale
      // une erreur ATTENDUE par l'auteur. Ce désaccord est le signal qui compte
      // — c'est un modèle qui vient de valider ce que le contenu déclare faux.
      if (verdict && recorded !== true) {
        logger.warn("ai.openAnswer.blockedByMistakeKey", { model });
      } else if (recorded === true) {
        overturned += 1;
      }
    } catch (cause) {
      logger.warn("ai.openAnswer.record", { error: errorMessage(cause) });
    }
  }

  // Aucun identifiant, aucun texte d'élève, aucune réponse : des compteurs. Ce
  // journal sert à savoir si le filet attrape quelque chose — s'il reste à zéro
  // sur des milliers de soumissions, l'ensemble déterministe suffisait.
  logger.info("ai.openAnswer", { judged: budget.length, overturned });
}
