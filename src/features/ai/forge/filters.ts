// Les FILTRES DÉTERMINISTES de la Forge — étude 29 §3.6.
//
// « 0 token, aucune indulgence. » Ce module est la partie de la chaîne qui ne
// coûte rien et qui rattrape le plus : avant de payer une seconde résolution
// pour vérifier une réponse, on jette tout ce qu'aucun modèle n'aurait dû
// écrire. Un candidat rejeté ici n'a coûté que sa part du premier appel.
//
// Il est PUR et ISOMORPHE, et c'est ce qui le rend testable exhaustivement : pas
// de réseau, pas d'horloge, pas de base. Chaque règle a un test qui la casse.
//
// ⚠️ Aucune de ces règles n'est une préférence de style. Chacune correspond à un
// défaut observable dans une sortie de modèle, et à une ligne de la barre de
// qualité du pipeline contenu (`content-engine`, `math-and-notation.md`).

import { AI_FORGE_LIMITS } from "@/shared/constants/ai";
import { violatesNotation as violatesNotationText } from "@/shared/integrations/ai/notation";
import { forgedQuestionSchema, type ForgedQuestion } from "./schema";

/** Pourquoi un candidat a été jeté. Le vocabulaire est fermé : il alimente le taux de rebut. */
export type ForgeRejection =
  | "schema" // hors du schéma zod (options, longueurs, difficulté)
  | "notation" // chiffres non occidentaux, LaTeX, URL
  | "duplicate_catalogue" // l'énoncé existe déjà dans le chapitre
  | "duplicate_candidate" // deux candidats du même lot disent la même chose
  | "vocabulary" // hors de la bande d'âge
  | "none_of_the_above" // option fourre-tout
  | "solve_disagreement"; // la double résolution n'a pas retrouvé la clé

export type FilterOutcome<T> = { kept: T[]; rejected: { index: number; reason: ForgeRejection }[] };

/**
 * Normalise un énoncé pour la comparaison : casse, accents, ponctuation et
 * espaces disparaissent.
 *
 * C'est ce qui fait la différence entre « détecter un doublon » et « détecter
 * une copie exacte ». Un modèle qui recopie une question du chapitre change
 * presque toujours une majuscule ou une virgule — et le §3.6 exige que les trois
 * questions d'exemple servent de « référence de style, JAMAIS à recopier ».
 */
export function normalizePrompt(text: string): string {
  return text
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "") // diacritiques latins
    .replace(/[ً-ْ]/g, "") // diacritiques arabes (harakat)
    .toLowerCase()
    .replace(/[^\p{L}\p{N}]+/gu, " ")
    .trim();
}

// Les trois règles de notation vivent dans `@/shared/integrations/ai/notation` :
// l'étude 11 lot 1 en a besoin sur de la PROSE (une explication rendue à un
// élève), et deux copies auraient dérivé au premier cas limite corrigé d'un
// seul côté.

/**
 * Les options fourre-tout. Elles cassent le QCM : « aucune des réponses » rend
 * la question résoluble par élimination sans rien savoir, et « toutes les
 * réponses » n'a jamais un seul distracteur honnête.
 */
const CATCH_ALL = [
  /aucune?\s+(de\s+ces|des)\s+r[ée]ponses?/i,
  /toutes\s+les\s+r[ée]ponses?/i,
  /none\s+of\s+the\s+above/i,
  /all\s+of\s+the\s+above/i,
  /لا\s+شيء\s+مما\s+سبق/,
  /كل\s+ما\s+سبق/,
];

/**
 * Vocabulaire hors bande d'âge, par CYCLE. Volontairement court et concret :
 * une liste longue produit des faux positifs, et le vrai garde-fou de la
 * difficulté est le rang scolaire passé au prompt. Ces mots-ci sont ceux qu'un
 * modèle glisse dans un énoncé de primaire sans y penser.
 */
const TOO_ADVANCED_FOR_PRIMARY = [
  /\bd[ée]riv[ée]e?\b/i,
  /\bint[ée]grale\b/i,
  /\blogarithme\b/i,
  /\bpolyn[ôo]me\b/i,
  /\bvecteur\b/i,
  /\btrigonom[ée]tri/i,
];

/** Rang `grades.display_order` : 1-6 primaire, 7-9 collège, 10-13 secondaire. */
export function isPrimaryRank(gradeRank: number | null): boolean {
  return gradeRank !== null && gradeRank <= 6;
}

function textOf(candidate: ForgedQuestion): string {
  return [candidate.prompt, candidate.explanation, ...candidate.options.map((o) => o.text)].join(
    " ",
  );
}

/** La notation : chiffres occidentaux, pas de LaTeX, pas d'URL. */
export function violatesNotation(candidate: ForgedQuestion): boolean {
  return violatesNotationText(textOf(candidate));
}

export function hasCatchAllOption(candidate: ForgedQuestion): boolean {
  return candidate.options.some((o) => CATCH_ALL.some((re) => re.test(o.text)));
}

export function violatesVocabulary(candidate: ForgedQuestion, gradeRank: number | null): boolean {
  if (!isPrimaryRank(gradeRank)) return false;
  const all = textOf(candidate);
  return TOO_ADVANCED_FOR_PRIMARY.some((re) => re.test(all));
}

/**
 * La chaîne complète des filtres à 0 token (§3.6).
 *
 * L'ORDRE est choisi : le schéma d'abord (le moins cher, et il garantit la forme
 * que les suivants supposent), le doublon en dernier (il est le seul à dépendre
 * des autres candidats, donc à changer de verdict selon ce qui l'a précédé).
 */
export function filterCandidates(
  raw: unknown[],
  context: { existingPrompts: readonly string[]; gradeRank: number | null },
): FilterOutcome<ForgedQuestion> {
  const kept: ForgedQuestion[] = [];
  const rejected: { index: number; reason: ForgeRejection }[] = [];

  const seen = new Set(context.existingPrompts.map(normalizePrompt));

  raw.forEach((entry, index) => {
    const parsed = forgedQuestionSchema.safeParse(entry);
    if (!parsed.success) {
      rejected.push({ index, reason: "schema" });
      return;
    }
    const candidate = parsed.data;

    if (violatesNotation(candidate)) {
      rejected.push({ index, reason: "notation" });
      return;
    }
    if (hasCatchAllOption(candidate)) {
      rejected.push({ index, reason: "none_of_the_above" });
      return;
    }
    if (violatesVocabulary(candidate, context.gradeRank)) {
      rejected.push({ index, reason: "vocabulary" });
      return;
    }

    const normalized = normalizePrompt(candidate.prompt);
    if (seen.has(normalized)) {
      // On ne distingue pas « déjà au catalogue » de « déjà dans ce lot » par le
      // contenu de `seen` : les deux sont des doublons pour l'élève. Le code de
      // rejet, lui, les distingue — c'est le catalogue qui compte pour R-19.
      rejected.push({
        index,
        reason: context.existingPrompts.some((p) => normalizePrompt(p) === normalized)
          ? "duplicate_catalogue"
          : "duplicate_candidate",
      });
      return;
    }

    seen.add(normalized);
    kept.push(candidate);
  });

  return { kept, rejected };
}

/**
 * Combien de candidats demander pour espérer N validés (R-18).
 *
 * N+2, borné à 10 questions par quiz. Demander davantage ferait de la Forge une
 * action encore plus chère pour un gain marginal : les rebuts se concentrent sur
 * les modèles faibles, et pour ceux-là c'est R-19 qui répond, pas une marge.
 */
export function candidateCount(requested: number): number {
  return Math.min(requested + AI_FORGE_LIMITS.candidateOverhead, 12);
}

/**
 * Faut-il re-résoudre CE candidat quand la double résolution est coupée ?
 * (R-18bis.3 — échantillon obligatoire de 20 %.)
 *
 * Déterministe par POSITION, pas aléatoire : un tirage rendrait le taux de rebut
 * bruité sur les petits volumes, et un test ne pourrait rien en dire. Un item
 * sur cinq, toujours les mêmes rangs — c'est exactement « une question sur
 * cinq », et c'est reproductible.
 */
export function shouldSampleVerify(index: number, rate: number): boolean {
  if (rate <= 0) return false;
  if (rate >= 1) return true;
  const period = Math.round(1 / rate);
  return index % period === 0;
}
