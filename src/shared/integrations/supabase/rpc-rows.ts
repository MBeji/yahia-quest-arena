import { z } from "zod";

import { logger } from "@/shared/lib/logger";
import type {
  CompetencyBlocker,
  CompetencyExercise,
  CompetencyMasteryRow,
  LearningFrontierRow,
  LearningStateRow,
} from "@/shared/types/competency";
import type { DailyPlanItem } from "@/shared/types/daily-plan";
import type { WeaknessRow } from "@/shared/types/weakness";

/**
 * LA FRONTIÈRE DE FORME des RPC en `RETURNS TABLE`.
 *
 * Les types Supabase générés connaissent ces fonctions, mais le générateur ne
 * sait exprimer ni une union de domaine (`state TEXT` → `string`, pas
 * `"lacune" | …`) ni la nullabilité d'une colonne de retour (`recent_result
 * NUMERIC` → `number`, alors qu'un `LEFT JOIN` la rend `NULL`). Entre le type
 * généré et le type de l'application il reste donc un écart qu'aucun des deux ne
 * peut combler seul.
 *
 * L'arbitrage, pris une fois (dette « vues d'ombre RPC », 2026-11-12) : cet
 * écart se VALIDE ici, il ne se caste pas. Une vue étroite du client posée par
 * `as unknown as …` affirmait la forme sans la vérifier — une dérive SQL
 * devenait une valeur mal typée, en silence, jusque dans le rendu.
 *
 * Chaque schéma est tenu au type de l'application par `satisfies` : ils ne
 * peuvent pas diverger sans que `tsc` le dise.
 */

/**
 * Valide les lignes une à une. Une ligne hors contrat est ÉCARTÉE et
 * journalisée en erreur ; les autres passent. Ces lectures se dégradent toutes
 * gracieusement (un panneau en moins, jamais une page cassée) : perdre la ligne
 * fautive plutôt que le panneau entier garde cette promesse, et l'erreur
 * journalisée rend la dérive bruyante.
 */
export function parseRpcRows<T>(schema: z.ZodType<T>, data: unknown, context: string): T[] {
  if (data == null) return [];
  if (!Array.isArray(data)) {
    logger.error(`${context}: unexpected RPC shape`, { reason: "not an array" });
    return [];
  }
  const rows: T[] = [];
  let rejected = 0;
  let firstIssue: string | undefined;
  for (const raw of data) {
    const parsed = schema.safeParse(raw);
    if (parsed.success) {
      rows.push(parsed.data);
      continue;
    }
    rejected += 1;
    const issue = parsed.error.issues[0];
    // Le CHEMIN et le code, jamais la valeur : une ligne de RPC porte des
    // données d'élève.
    firstIssue ??= issue ? `${issue.path.join(".")}: ${issue.code}` : "unknown";
  }
  if (rejected > 0) {
    logger.error(`${context}: unexpected RPC shape`, {
      rejected,
      total: data.length,
      firstIssue,
    });
  }
  return rows;
}

/** `get_daily_plan`. */
export const dailyPlanItemSchema = z.object({
  exercise_id: z.string(),
  chapter_id: z.string(),
  subject_id: z.string(),
  exercise_title: z.string(),
  chapter_title: z.string(),
  days_overdue: z.number(),
  weak_tags: z.number(),
  is_fallback: z.boolean(),
}) satisfies z.ZodType<DailyPlanItem>;

/** `get_my_competency_map`. `recent_result` sort d'un `LEFT JOIN LATERAL`. */
export const competencyMasteryRowSchema = z.object({
  competency_id: z.string(),
  slug: z.string(),
  family: z.string(),
  domain: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
  mastery: z.number(),
  attempts: z.number(),
  recent_result: z.number().nullable(),
}) satisfies z.ZodType<CompetencyMasteryRow>;

/** `get_competency_blockers`. */
export const competencyBlockerSchema = z.object({
  competency_id: z.string(),
  slug: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
  mastery: z.number(),
  depth: z.number(),
}) satisfies z.ZodType<CompetencyBlocker>;

/** `get_exercises_for_competency`. */
export const competencyExerciseSchema = z.object({
  exercise_id: z.string(),
  chapter_id: z.string(),
  subject_id: z.string(),
  exercise_title: z.string(),
  difficulty: z.number(),
}) satisfies z.ZodType<CompetencyExercise>;

/** `get_my_weaknesses`. Le chapitre sort d'un `LEFT JOIN` ; `trend` d'un `CASE` fermé. */
export const weaknessRowSchema = z.object({
  tag: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
  competency: z.string().nullable(),
  occurrences: z.number(),
  last_seen_at: z.string(),
  chapter_id: z.string().nullable(),
  chapter_title: z.string().nullable(),
  subject_id: z.string().nullable(),
  recent_7d: z.number(),
  previous_7d: z.number(),
  trend: z.enum(["improving", "worsening", "stable"]),
}) satisfies z.ZodType<WeaknessRow>;

const competencyStateSchema = z.enum(["maitrisee", "en-cours", "fragile", "lacune", "inconnue"]);

/** `get_learning_state`. */
export const learningStateRowSchema = z.object({
  competency_id: z.string(),
  slug: z.string(),
  family: z.string(),
  domain: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
  state: competencyStateSchema,
  zone: z.enum(["interieur", "frontiere", "hors-portee"]),
  p_known: z.number().nullable(),
  evidence_count: z.number(),
  sessions_seen: z.number(),
  forms_count: z.number(),
  belief_source: z.enum(["evidence", "inference", "placement"]),
  suspect: z.boolean(),
}) satisfies z.ZodType<LearningStateRow>;

/** `get_learning_frontier`. */
export const learningFrontierRowSchema = z.object({
  competency_id: z.string(),
  slug: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
  state: competencyStateSchema,
  p_known: z.number().nullable(),
  unlocks: z.number(),
  entry_exercise_id: z.string().nullable(),
  entry_subject_id: z.string().nullable(),
  entry_odds: z.number().nullable(),
}) satisfies z.ZodType<LearningFrontierRow>;
