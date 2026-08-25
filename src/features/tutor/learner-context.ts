/**
 * Le PACK ÉLÈVE, de la ligne JSON au contexte de prompt (études 11 et 30).
 *
 * `get_tutor_learner_context()` rend un objet JSON ; le tuteur consomme un objet TypeScript.
 * Entre les deux il y a une validation et un choix de langue — deux gestes purs, sans réseau,
 * sans base et sans secret. Ils vivaient dans `tutor.server.ts` jusqu'à ce que le bloc
 * `mastery` de é30 lot 3bis pousse ce fichier au-delà de son plafond de lignes. Les sortir
 * était le bon geste indépendamment du plafond : ce sont exactement les deux choses de ce
 * chemin qu'on peut tester sans monter un serveur.
 *
 * LA RÈGLE QUI GOUVERNE LE CHOIX DE LANGUE, et qui explique pourquoi il est ici plutôt qu'en
 * SQL : le pack est au niveau ÉLÈVE, la langue est une propriété de la QUESTION. La RPC ne
 * peut donc pas choisir — elle envoie les trois libellés, et un seul endroit tranche. C'est
 * la posture de é04 A1.2b (« la fonction SQL rend un ID, le registre reste source unique »),
 * appliquée aux libellés de compétences comme elle l'était déjà aux misconceptions.
 */
import { z } from "zod";

import type { TutorLang, TutorLearnerContext } from "./prompt";

/** Une compétence citée au pack : slug, état, libellés trilingues. Jamais `p_known` (D-1). */
const masteryItemSchema = z.object({
  slug: z.string(),
  state: z.string(),
  label_fr: z.string().nullable().optional(),
  label_en: z.string().nullable().optional(),
  label_ar: z.string().nullable().optional(),
});

export const learnerContextSchema = z.object({
  grade_slug: z.string().nullable(),
  goal: z.string(),
  level_band: z.string(),
  streak_band: z.string(),
  active_misconceptions: z
    .array(
      z.object({
        tag: z.string(),
        label_fr: z.string().nullable().optional(),
        label_en: z.string().nullable().optional(),
        label_ar: z.string().nullable().optional(),
      }),
    )
    .default([]),
  interests: z.array(z.string()).default([]),
  verbosity: z.enum(["courte", "normale"]).default("normale"),
  /**
   * Étude 30 lot 3bis (amendement D) — ce que l'élève sait, peut attaquer, et ce qui le
   * bloque. `optional()` et non `default({})` : R-6 veut que la clé soit ABSENTE quand il n'y
   * a aucune croyance, et un défaut la ferait réapparaître ici sous forme de listes vides,
   * donc de lignes vides dans le prompt. L'absence doit traverser la couche de validation.
   */
  mastery: z
    .object({
      mastered: z.array(masteryItemSchema).default([]),
      frontier: z.array(masteryItemSchema).default([]),
      blockers: z.array(masteryItemSchema).default([]),
    })
    .optional(),
});

export function toLearnerContext(
  raw: z.infer<typeof learnerContextSchema>,
  lang: TutorLang,
): TutorLearnerContext {
  return {
    gradeSlug: raw.grade_slug,
    goal: raw.goal,
    levelBand: raw.level_band,
    streakBand: raw.streak_band,
    activeMisconceptions: raw.active_misconceptions.map((m) => ({
      tag: m.tag,
      label: (lang === "ar" ? m.label_ar : lang === "en" ? m.label_en : m.label_fr) ?? null,
    })),
    interests: raw.interests,
    verbosity: raw.verbosity,
    // Étude 30 lot 3bis. La langue est choisie ICI, exactement comme pour les misconceptions
    // deux lignes plus haut : le pack est au niveau ÉLÈVE et ne connaît pas la langue de la
    // matière, qui est une propriété de la QUESTION. Un seul endroit décide, et c'est celui-ci.
    mastery: raw.mastery
      ? {
          mastered: raw.mastery.mastered.map((m) => pickMasteryLabel(m, lang)),
          frontier: raw.mastery.frontier.map((m) => pickMasteryLabel(m, lang)),
          blockers: raw.mastery.blockers.map((m) => pickMasteryLabel(m, lang)),
        }
      : undefined,
  };
}

/** Le libellé de la compétence dans la langue de la matière, ou `null` si le corpus n'en a pas. */
function pickMasteryLabel(
  m: z.infer<typeof masteryItemSchema>,
  lang: TutorLang,
): { slug: string; label: string | null; state: string } {
  return {
    slug: m.slug,
    label: (lang === "ar" ? m.label_ar : lang === "en" ? m.label_en : m.label_fr) ?? null,
    state: m.state,
  };
}
