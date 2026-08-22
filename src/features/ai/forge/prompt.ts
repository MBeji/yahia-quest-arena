// Les GABARITS de la Forge — étude 29 §3.6, é11 annexe B (normative ici aussi).
//
// DEUX PROMPTS, ET LE SECOND NE DOIT RIEN SAVOIR DU PREMIER
// ---------------------------------------------------------------------------
// La génération produit des candidats ; la double résolution les RÉSOUT, « sans
// voir la clé déclarée » (§3.6). C'est tout l'intérêt de l'exercice : si le
// second appel voyait la réponse annoncée, il l'approuverait, et le stop-point
// de l'étude serait contourné sans que personne ne s'en aperçoive —
// « le double-solve n'est pas optimisable en un seul appel qui s'auto-vérifie :
// c'est le même modèle qui se relit, la garantie tombe » (Q-7).
//
// `buildSolvePrompt` reçoit donc un candidat DÉPOUILLÉ, et son type le dit :
// il ne prend ni `correctOption` ni `explanation`. Ce n'est pas une convention,
// c'est le compilateur qui l'empêche.
//
// L'ORDRE DES BLOCS EST STABLE (é11 §3.4) : instructions figées d'abord, cours
// ensuite, demande volatile en dernier — la césure de cache se pose après le
// cours, qui est le plus gros et le plus réutilisé d'un appel à l'autre.
//
// é11 R-5 : rien de ce que l'élève écrit n'entre dans les instructions système.
// La Forge n'a de toute façon pas de champ libre — l'élève choisit un périmètre,
// un volume et une difficulté, tous validés contre des listes fermées.

import type { AiBlock } from "@/shared/integrations/ai/types";
import type { ForgedQuestion } from "./schema";

export type ForgeContext = {
  readonly chapterTitle: string;
  readonly lessonExcerpt: string;
  readonly samplePrompts: readonly string[];
  readonly lang: "fr" | "en" | "ar";
  readonly gradeRank: number | null;
};

const LANG_NAME: Record<ForgeContext["lang"], string> = {
  fr: "français",
  en: "anglais",
  ar: "arabe",
};

/** La bande d'âge, dérivée du rang scolaire — jamais l'âge réel de l'élève (é11 R-14). */
export function ageBand(gradeRank: number | null): string {
  if (gradeRank === null) return "collège (12-15 ans)";
  if (gradeRank <= 6) return "primaire (6-12 ans)";
  if (gradeRank <= 9) return "collège (12-15 ans)";
  return "secondaire (15-19 ans)";
}

/**
 * Les instructions système de la génération. STABLES : elles ne dépendent ni du
 * chapitre, ni de l'élève, ni de l'heure — c'est ce qui permet au préfixe d'être
 * caché d'un appel à l'autre, et à la facture de baisser (annexe A).
 */
export const FORGE_SYSTEM = [
  "Tu écris des questions de QCM pour une application scolaire tunisienne.",
  "Règles absolues :",
  "- exactement 4 options, identifiées a, b, c, d, dont UNE SEULE est juste ;",
  "- chiffres occidentaux (0-9) uniquement, y compris en arabe ; jamais de LaTeX ;",
  "- aucune option « aucune des réponses » ni « toutes les réponses » ;",
  "- aucune URL, aucun lien, aucune référence à une source externe ;",
  "- les distracteurs correspondent à des ERREURS PLAUSIBLES, pas à des absurdités ;",
  "- l'explication dit POURQUOI la bonne réponse est juste, en une ou deux phrases ;",
  "- tu n'utilises pas les questions d'exemple : elles montrent un STYLE, pas un contenu.",
].join("\n");

/** Les instructions système de la double résolution. Encore plus courtes, et sans contexte. */
export const FORGE_SOLVE_SYSTEM = [
  "Tu résous une question de QCM. Tu réponds par l'identifiant de l'option juste,",
  "et par rien d'autre. Si aucune option n'est clairement juste, réponds avec",
  "l'option la moins fausse — un désaccord est un signal utile, pas une erreur.",
].join("\n");

export function buildForgeBlocks(
  context: ForgeContext,
  request: { count: number; difficulty: number },
): AiBlock[] {
  return [
    // Bloc STABLE 1 : le cours. Le plus gros, le plus réutilisé — c'est lui qui
    // rentabilise le cache quand un élève forge deux quiz sur le même chapitre.
    {
      label: "cours",
      text: `Chapitre : ${context.chapterTitle}\n\n${context.lessonExcerpt || "(cours indisponible — appuie-toi sur le titre du chapitre)"}`,
    },
    // Bloc STABLE 2 : le style. Trois questions du catalogue, SANS leur clé.
    {
      label: "style_de_reference",
      text:
        context.samplePrompts.length > 0
          ? context.samplePrompts.map((p, i) => `${i + 1}. ${p}`).join("\n")
          : "(aucun exemple disponible)",
      // La césure se pose ICI : tout ce qui précède ne bouge pas d'un appel à
      // l'autre pour un même chapitre.
      cacheBoundary: true,
    },
    // Bloc VOLATIL : la demande. Il change à chaque appel, donc il vient après.
    {
      label: "demande",
      text: [
        `Écris ${request.count} questions.`,
        `Langue : ${LANG_NAME[context.lang]}.`,
        `Public : ${ageBand(context.gradeRank)}.`,
        `Difficulté visée : ${request.difficulty} sur 4.`,
      ].join("\n"),
    },
  ];
}

/**
 * Le candidat DÉPOUILLÉ, tel que la double résolution le voit.
 *
 * Le type omet `correctOption` et `explanation` : c'est la garantie de Q-7,
 * exprimée là où elle ne peut pas être oubliée.
 */
export type UnkeyedCandidate = Pick<ForgedQuestion, "prompt" | "options">;

export function stripKey(candidate: ForgedQuestion): UnkeyedCandidate {
  return { prompt: candidate.prompt, options: candidate.options };
}

export function buildSolveBlocks(candidate: UnkeyedCandidate): AiBlock[] {
  return [
    {
      label: "question",
      text: [candidate.prompt, "", ...candidate.options.map((o) => `${o.id}) ${o.text}`)].join(
        "\n",
      ),
    },
  ];
}
