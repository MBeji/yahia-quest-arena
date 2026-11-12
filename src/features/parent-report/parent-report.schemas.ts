import { z } from "zod";

/**
 * Les schémas zod de `parent-report.server.ts` — et RIEN d'autre.
 *
 * Pourquoi un fichier à part (2026-10-31). Le compilateur de TanStack Start retire
 * `.validator()`/`.handler()` des `*.server.ts` dans le bundle CLIENT, puis les
 * imports devenus inutiles — mais il garde les instructions de niveau module à
 * effet. Tant que ces schémas étaient déclarés dans le fichier des server fns, le
 * stub client `parent-report.server-*.js` les CONSTRUISAIT au chargement et tirait
 * pour ça zod entier (chunk `schemas-*.js`, 84 KB / 23,6 KB gzip) sur /auth
 * (`linkStudentByCode`), /suivi et /parent-report — alors que le validateur ne
 * tourne jamais côté client (`createServerFn.js` : `if (validator && env ===
 * "server")`). Déclarés ici et importés seulement depuis les validateurs et les
 * handlers, ils disparaissent du stub avec leur import, comme `displayNameSchema`
 * pour `auth.server`. Le gate `check-bundle-budget` refuse désormais tout chunk
 * client `schemas-`.
 */

// The RPC returns a `Json` value; validate field-by-field with zod, coercing
// numbers, defaulting arrays to [], and constraining the verdict union with a
// safe fallback so the route's `.map()`/`summary.verdict` access can never crash.
const numberish = z.coerce.number().catch(0);
const VERDICT_VALUES = ["excellent", "good", "average", "needs_improvement", "inactive"] as const;

const weekSliceSchema = z
  .object({
    exercises: numberish,
    minutes: numberish,
    avgScore: numberish,
  })
  .catch({ exercises: 0, minutes: 0, avgScore: 0 });

const chapterInsightSchema = z.object({
  chapterId: z.string().catch(""),
  chapterTitle: z.string().catch(""),
  subjectId: z.string().catch(""),
  subjectName: z.string().catch(""),
  attempts: numberish,
  avgScore: numberish,
});

const studentReportSchema = z.object({
  student: z
    .object({
      displayName: z.string().nullable().catch(null),
      heroClass: z.string().nullable().catch(null),
      level: numberish,
      xp: numberish,
      currentStreak: numberish,
      longestStreak: numberish,
      lastActiveDate: z.string().nullable().catch(null),
      createdAt: z.string().catch(""),
    })
    .catch({
      displayName: null,
      heroClass: null,
      level: 0,
      xp: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastActiveDate: null,
      createdAt: "",
    }),
  summary: z
    .object({
      totalTimeMinutes: numberish,
      totalExercises: numberish,
      avgScore: numberish,
      daysActiveThisWeek: numberish,
      seriousnessScore: numberish,
      verdict: z.enum(VERDICT_VALUES).catch("average"),
      scoreTrend: numberish,
    })
    .catch({
      totalTimeMinutes: 0,
      totalExercises: 0,
      avgScore: 0,
      daysActiveThisWeek: 0,
      seriousnessScore: 0,
      verdict: "average",
      scoreTrend: 0,
    }),
  subjectStats: z
    .array(
      z.object({
        subjectId: z.string().catch(""),
        name: z.string().catch(""),
        // Le NIVEAU : une matière appartient à un niveau scolaire, et sans lui le
        // bilan listait « Mathématiques » quatre fois sans rien pour les séparer.
        gradeName: z.string().nullable().catch(null),
        colorToken: z.string().nullable().catch(null),
        attempts: numberish,
        avgScore: numberish,
        totalTimeMinutes: numberish,
        // Couverture du programme — même règle que la carte `/parcours`.
        chaptersTotal: numberish,
        chaptersCompleted: numberish,
      }),
    )
    .catch([]),
  dailyActivity: z
    .array(
      z.object({
        date: z.string().catch(""),
        exercises: numberish,
        minutes: numberish,
        avgScore: numberish,
      }),
    )
    .catch([]),
  weekComparison: z
    .object({
      thisWeek: weekSliceSchema,
      lastWeek: weekSliceSchema,
    })
    .catch({
      thisWeek: { exercises: 0, minutes: 0, avgScore: 0 },
      lastWeek: { exercises: 0, minutes: 0, avgScore: 0 },
    }),
  chapterInsights: z
    .object({
      strengths: z.array(chapterInsightSchema).catch([]),
      weaknesses: z.array(chapterInsightSchema).catch([]),
    })
    .catch({ strengths: [], weaknesses: [] }),
  /**
   * Étude 04 A2.2 (US-3) — les erreurs NOMMÉES, à côté des chapitres faibles.
   *
   * Ce n'est pas un doublon de `chapterInsights` : celui-ci dit « Fractions :
   * 45 % » (OÙ ça coince), celui-là dit « il additionne les dénominateurs »
   * (QUOI réviser). Le second est le seul des deux sur lequel un parent peut
   * agir le soir même.
   *
   * `.catch([])` comme partout ici : un rapport doit s'afficher même si la RPC
   * est en cours de déploiement, ou si l'élève n'a aucune erreur installée —
   * ce qui est le cas de tout compte neuf.
   */
  misconceptionInsights: z
    .array(
      z.object({
        tag: z.string().catch(""),
        labelFr: z.string().catch(""),
        labelEn: z.string().catch(""),
        labelAr: z.string().catch(""),
        occurrences: numberish,
        trend: z.enum(["improving", "worsening", "stable"]).catch("stable"),
      }),
    )
    .catch([]),
});

type StudentReportShape = z.infer<typeof studentReportSchema>;

export function parseStudentReportPayload(payload: unknown): StudentReportShape {
  if (!payload || typeof payload !== "object") {
    throw new Error("Invalid student report payload.");
  }

  return studentReportSchema.parse(payload);
}

// Une date de calendrier, telle que la RPC l'attend et que le sélecteur de
// période la produit (`YYYY-MM-DD`).
export const isoDate = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Expected YYYY-MM-DD");

// Objectif hebdo : payload de get_family_weekly_goal (null si aucun objectif posé).
export const weeklyGoalSchema = z
  .object({
    weekStart: z.string().catch(""),
    target: numberish,
    done: numberish,
  })
  .nullable()
  .catch(null);

// Objectif du jour : payload de get_family_daily_goal (null si aucun objectif posé).
export const dailyGoalSchema = z
  .object({
    day: z.string().catch(""),
    target: numberish,
    done: numberish,
  })
  .nullable()
  .catch(null);

// Compteurs d'aide du tuteur (`get_tutor_parent_counters`) — voir la server fn
// `getTutorParentCounters` pour les deux frontières (features, vie privée).
const tutorThemeSchema = z.object({
  tag: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
  count: numberish,
});

export const tutorCountersSchema = z.object({
  interactions_7d: numberish,
  interactions_30d: numberish,
  top_themes: z.array(tutorThemeSchema).catch([]),
});

// Examens blancs (`get_student_exam_summary`, étude 08 lot 1). Le percentile est
// `null` sous le seuil de l'étude 02 — et le seuil voyage dans la réponse.
const nullableNumber = z.coerce.number().nullable().catch(null);

const examSummaryItemSchema = z.object({
  examId: z.string(),
  titleFr: z.string().catch(""),
  titleEn: z.string().nullable().catch(null),
  titleAr: z.string().nullable().catch(null),
  finishedAt: z.string().catch(""),
  scorePoints: numberish,
  maxPoints: numberish,
  scoreOn20: numberish,
  candidates: numberish,
  percentile: nullableNumber,
});

export const examSummarySchema = z.object({
  minCandidates: numberish,
  openExams: numberish,
  exams: z.array(examSummaryItemSchema).catch([]),
});

export type StudentExamSummary = z.infer<typeof examSummarySchema>;

// Comparatif de parcours (`get_student_parcours_comparison`, étude 08 lot 3).
// Sous le seuil (R-6) la base rend `masked` et des NULL : aucun chiffre n'arrive.
const platformStatsSchema = z.object({
  masked: z.boolean().catch(true),
  students: nullableNumber,
  avgScore: nullableNumber,
  weeklyMinutes: nullableNumber,
});

export const parcoursComparisonSchema = z
  .object({
    parcours: z.object({
      nameFr: z.string().catch(""),
      nameEn: z.string().nullable().catch(null),
      nameAr: z.string().nullable().catch(null),
    }),
    student: z.object({ avgScore: numberish, weeklyMinutes: numberish }).nullable().catch(null),
    platform: platformStatsSchema,
  })
  .nullable();

export type ParcoursComparison = z.infer<typeof parcoursComparisonSchema>;
