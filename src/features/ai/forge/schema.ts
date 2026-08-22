// Le SCHÉMA d'un candidat de la Forge — étude 29 §3.6, premier filtre.
//
// « schéma zod miroir du pipeline contenu (4 options, clé unique, longueurs,
// difficulté) ». Miroir, et non réutilisation : le schéma du corpus
// (`src/shared/content/schema.ts`) accepte huit types de question, des figures
// SVG, des tags de misconception et des compétences. La Forge v1 ne produit
// qu'un QCM à 4 options (§2.3 : « les types natifs sont hors v1 »), et lui
// donner un schéma plus large serait accepter des sorties qu'aucun écran ne sait
// jouer.
//
// Module ISOMORPHE : l'écran de la Forge en lit les bornes, le serveur les
// applique. Aucun accès réseau, aucun secret.

import { z } from "zod";
import { AI_FORGE_LIMITS } from "@/shared/constants/ai";

/** Les identifiants d'option, figés : le modèle ne les invente pas. */
export const FORGE_OPTION_IDS = ["a", "b", "c", "d"] as const;

export const forgedOptionSchema = z.object({
  id: z.enum(FORGE_OPTION_IDS),
  // 160 caractères : au-delà, ce n'est plus une option de QCM, c'est un
  // paragraphe — et un élève qui doit relire quatre paragraphes ne fait plus
  // l'exercice qu'on croit lui donner (charge cognitive, barre qualité contenu).
  text: z.string().min(1).max(160),
});

export const forgedQuestionSchema = z.object({
  prompt: z.string().min(10).max(600),
  options: z
    .array(forgedOptionSchema)
    .length(AI_FORGE_LIMITS.optionsPerQuestion)
    // Quatre ids DISTINCTS : un modèle qui rend deux `b` produit un quiz
    // injouable, et le dire ici évite de le découvrir dans le lecteur.
    .refine((opts) => new Set(opts.map((o) => o.id)).size === opts.length, {
      message: "duplicate option id",
    })
    // Deux options au texte identique rendent la question insoluble : quelle
    // que soit la clé, l'élève a une chance sur deux d'avoir « raison » et
    // d'être compté faux.
    .refine((opts) => new Set(opts.map((o) => o.text.trim().toLowerCase())).size === opts.length, {
      message: "duplicate option text",
    }),
  correctOption: z.enum(FORGE_OPTION_IDS),
  // L'explication n'est pas décorative : c'est ce que l'élève lit quand il se
  // trompe, et le seul endroit où un quiz forgé enseigne quelque chose.
  explanation: z.string().min(10).max(600),
  difficulty: z.number().int().min(1).max(4),
});

export type ForgedQuestion = z.infer<typeof forgedQuestionSchema>;

/** Ce que le modèle doit rendre : rien d'autre qu'une liste d'items. */
export const forgeOutputSchema = z.object({
  items: z
    .array(forgedQuestionSchema)
    .min(1)
    .max(AI_FORGE_LIMITS.allowedSizes.at(-1)! + AI_FORGE_LIMITS.candidateOverhead),
});

/** Ce que la double résolution doit rendre : une option, et rien d'autre. */
export const forgeSolveSchema = z.object({ answer: z.enum(FORGE_OPTION_IDS) });

/**
 * Le JSON Schema passé au fournisseur (`responseSchema`).
 *
 * Écrit à la main plutôt que dérivé du zod : les fournisseurs qui contraignent
 * nativement la sortie exigent `additionalProperties: false` et un `required`
 * exhaustif, deux choses qu'un convertisseur générique rend de façon variable —
 * et une divergence ici ne se voit qu'au taux de rebut.
 */
export const FORGE_JSON_SCHEMA: Record<string, unknown> = {
  type: "object",
  additionalProperties: false,
  required: ["items"],
  properties: {
    items: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        required: ["prompt", "options", "correctOption", "explanation", "difficulty"],
        properties: {
          prompt: { type: "string" },
          options: {
            type: "array",
            minItems: AI_FORGE_LIMITS.optionsPerQuestion,
            maxItems: AI_FORGE_LIMITS.optionsPerQuestion,
            items: {
              type: "object",
              additionalProperties: false,
              required: ["id", "text"],
              properties: {
                id: { type: "string", enum: [...FORGE_OPTION_IDS] },
                text: { type: "string" },
              },
            },
          },
          correctOption: { type: "string", enum: [...FORGE_OPTION_IDS] },
          explanation: { type: "string" },
          difficulty: { type: "integer", minimum: 1, maximum: 4 },
        },
      },
    },
  },
};

export const FORGE_SOLVE_JSON_SCHEMA: Record<string, unknown> = {
  type: "object",
  additionalProperties: false,
  required: ["answer"],
  properties: { answer: { type: "string", enum: [...FORGE_OPTION_IDS] } },
};

/** Un item STOCKÉ : le candidat validé, plus son identifiant de lecture. */
export const forgedItemSchema = forgedQuestionSchema.extend({ id: z.string().min(1) });
export type ForgedItem = z.infer<typeof forgedItemSchema>;

/** Le `payload` d'un quiz forgé, tel qu'il vit en base. */
export const forgedPayloadSchema = z.object({ items: z.array(forgedItemSchema).min(1) });

/** Ce que l'élève reçoit : les items SANS clé ni explication (serve_forged_quiz). */
export const servedItemSchema = z.object({
  id: z.string(),
  prompt: z.string(),
  options: z.array(forgedOptionSchema),
});
export type ServedForgedItem = z.infer<typeof servedItemSchema>;
