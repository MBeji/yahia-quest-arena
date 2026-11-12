import { createServerFn } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
import { z } from "zod";

import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { logger } from "@/shared/lib/logger";
import { isRateLimited, isRateLimitedLocal } from "@/shared/lib/rate-limit";
import { failWithClientError, RATE_LIMITED_FR } from "@/shared/lib/safe-error";
import { PLACEMENT_BANDS } from "@/shared/constants/placement";

/**
 * Étude 39 — le test de niveau : la couche serveur.
 *
 * Tout le métier est en SQL (`20261101100000_placement_sessions.sql`) : composition du test,
 * jugement (`score_answer`), note figée, bande, percentile, rattachement. Ces fonctions ne font
 * que valider l'entrée, limiter le débit et donner une forme typée à des payloads JSONB. Aucune
 * règle de bilan n'est décidée ici — la réécrire en TypeScript créerait un second juge.
 *
 * ⚠️ Ce module ne connaît AUCUNE clé de réponse : `start_placement_session` construit son JSON
 * sans `correct_option` ni `explanation` ; la correction n'arrive qu'après la fin, et son volet
 * « explication + erreur nommée » au seul propriétaire (R-11, D-5).
 *
 * PUBLIC-FIRST : le départ, la fin et la relecture sont `optionalSupabaseAuth` — le visiteur
 * sans compte est l'audience première du test (étude 39 §1). Le rattachement et le Hall exigent
 * un compte.
 */

/** Les signaux métier voyagent dans le message SQL ; traduits ici, et seulement ici. */
const PLACEMENT_ERRORS: ReadonlyArray<readonly [string, string]> = [
  ["PLACEMENT_SUBJECT_NOT_FOUND", "Cette matière est introuvable."],
  [
    "PLACEMENT_NOT_ENOUGH_QUESTIONS",
    "Cette matière n'a pas encore assez de questions pour un test.",
  ],
  ["PLACEMENT_BUSY", "Beaucoup de monde passe le test en ce moment. Réessaie dans une minute."],
  ["PLACEMENT_NOT_FOUND", "Ce test est introuvable."],
];

/** Les codes que l'écran sait nommer dans la langue de l'élève — le message reste le repli. */
export type PlacementErrorCode = "busy" | "notEnough" | "notFound" | "subjectNotFound";

export function placementErrorCode(error: unknown): PlacementErrorCode | null {
  const message = error instanceof Error ? error.message : "";
  if (message.includes("Beaucoup de monde")) return "busy";
  if (message.includes("pas encore assez de questions")) return "notEnough";
  if (message.includes("test est introuvable")) return "notFound";
  if (message.includes("matière est introuvable")) return "subjectNotFound";
  return null;
}

function failWithPlacementError(
  context: string,
  error: { message: string },
  fallback: string,
): never {
  for (const [code, message] of PLACEMENT_ERRORS) {
    if (error.message.includes(code)) throw new Error(message);
  }
  failWithClientError(context, error, fallback);
}

const TOO_MANY = RATE_LIMITED_FR;

function clientIpKey(): string {
  try {
    const headers = getRequest()?.headers;
    const forwarded = headers?.get("x-forwarded-for");
    return forwarded?.split(",")[0]?.trim() || headers?.get("x-real-ip") || "unknown";
  } catch {
    return "unknown";
  }
}

// ---------------------------------------------------------------------------
// Formes de sortie. `.catch(...)` nulle part : une forme inattendue est une panne de lecture.
// ---------------------------------------------------------------------------

const optionSchema = z.object({ id: z.string(), text: z.string() });

const subjectSchema = z.object({
  id: z.string(),
  nameFr: z.string(),
  contentLanguage: z.string().nullable().default("fr"),
  gradeNameFr: z.string().nullable().default(null),
  gradeSlug: z.string().nullable().default(null),
  parcoursId: z.string().nullable().default(null),
});

const servedQuestionSchema = z.object({
  id: z.string(),
  chapterId: z.string(),
  chapterTitle: z.string(),
  chapterOrder: z.coerce.number(),
  prompt: z.string(),
  options: z.array(optionSchema).default([]),
  questionType: z.string().nullable().default("mcq"),
});

const runningSchema = z.object({
  id: z.string(),
  status: z.literal("running"),
  audience: z.enum(["student", "parent"]),
  startedAt: z.string(),
  subject: subjectSchema,
  questions: z.array(servedQuestionSchema),
});

const startedSchema = runningSchema.extend({
  /** R-14 : la seule fois où le jeton sort. */
  token: z.string(),
});

const chapterSchema = z.object({
  chapterId: z.string(),
  title: z.string(),
  displayOrder: z.coerce.number(),
  correct: z.coerce.number(),
  total: z.coerce.number(),
  held: z.boolean(),
  hasLesson: z.boolean().default(false),
});

const reviewItemSchema = z.object({
  questionId: z.string(),
  chapterId: z.string().nullable().default(null),
  prompt: z.string(),
  options: z.array(optionSchema).default([]),
  questionType: z.string().nullable().default("mcq"),
  selectedChoice: z.string().nullable().default(null),
  isCorrect: z.boolean(),
  correctChoice: z.string().nullable().default(null),
  explanation: z.string().nullable().default(null),
  misconception: z
    .object({
      tag: z.string(),
      labelFr: z.string(),
      labelEn: z.string(),
      labelAr: z.string(),
    })
    .nullable()
    .default(null),
});

const bilanSchema = z.object({
  id: z.string(),
  status: z.literal("completed"),
  audience: z.enum(["student", "parent"]),
  startedAt: z.string(),
  finishedAt: z.string(),
  subject: subjectSchema,
  correct: z.coerce.number(),
  total: z.coerce.number(),
  scoreOn20: z.coerce.number(),
  band: z.enum(PLACEMENT_BANDS),
  durationSeconds: z.coerce.number(),
  tooFast: z.boolean(),
  chapters: z.array(chapterSchema),
  firstToReview: z.object({ chapterId: z.string(), title: z.string() }).nullable().default(null),
  percentile: z.object({
    candidates: z.coerce.number(),
    minCandidates: z.coerce.number(),
    percentile: z.coerce.number().nullable().default(null),
  }),
  review: z.array(reviewItemSchema),
  insightsLocked: z.boolean(),
});

/** Un test relu : en cours (la reprise) ou fini (le bilan). */
const sessionSchema = z.discriminatedUnion("status", [runningSchema, bilanSchema]);

const overviewSchema = z.array(
  z.object({
    sessionId: z.string(),
    subjectId: z.string(),
    subjectNameFr: z.string(),
    contentLanguage: z.string().nullable().default("fr"),
    scoreOn20: z.coerce.number(),
    band: z.enum(PLACEMENT_BANDS),
    finishedAt: z.string(),
    chaptersToReview: z.array(z.object({ chapterId: z.string(), title: z.string() })).default([]),
  }),
);

const testableSubjectSchema = z.object({
  id: z.string(),
  nameFr: z.string(),
  contentLanguage: z.string().nullable().default("fr"),
  chapters: z.coerce.number(),
  questions: z.coerce.number(),
});

const subjectCardSchema = subjectSchema.extend({
  testable: z.boolean(),
  questions: z.coerce.number(),
  chapters: z.coerce.number(),
});

export type PlacementTestableSubject = z.infer<typeof testableSubjectSchema>;
export type PlacementSubjectCard = z.infer<typeof subjectCardSchema>;
export type PlacementStarted = z.infer<typeof startedSchema>;
export type PlacementRunning = z.infer<typeof runningSchema>;
export type PlacementBilan = z.infer<typeof bilanSchema>;
export type PlacementSession = z.infer<typeof sessionSchema>;
export type PlacementSubject = z.infer<typeof subjectSchema>;
export type PlacementServedQuestion = z.infer<typeof servedQuestionSchema>;
export type PlacementReviewItem = z.infer<typeof reviewItemSchema>;
export type PlacementOverview = z.infer<typeof overviewSchema>;

const SHAPE_ERROR_FR = "Réponse inattendue du serveur du test.";

function parseOrFail<T>(schema: z.ZodType<T>, data: unknown, context: string): T {
  const parsed = schema.safeParse(data);
  if (!parsed.success) {
    failWithClientError(context, { message: parsed.error.message }, SHAPE_ERROR_FR);
  }
  return parsed.data;
}

// ---------------------------------------------------------------------------
// Server functions
// ---------------------------------------------------------------------------

/** L'entrée : les matières TESTABLES d'une classe (≥ 5 questions éligibles — R-1). */
export const listPlacementSubjects = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d) => z.object({ parcoursId: z.string().min(1).max(64) }).parse(d))
  .handler(async ({ data, context }): Promise<PlacementTestableSubject[]> => {
    const { data: payload, error } = await context.supabase.rpc("list_placement_subjects", {
      p_parcours_id: data.parcoursId,
    });
    if (error) {
      failWithClientError("placement.listSubjects", error, "Impossible de charger les matières.");
    }
    return parseOrFail(z.array(testableSubjectSchema), payload, "placement.listSubjects: shape");
  });

/** Un lien partagé (`?matiere=`) : la matière, sa classe, et si elle est testable. `null` si inconnue. */
export const getPlacementSubject = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d) => z.object({ subjectId: z.string().min(1).max(64) }).parse(d))
  .handler(async ({ data, context }): Promise<PlacementSubjectCard | null> => {
    const { data: payload, error } = await context.supabase.rpc("get_placement_subject", {
      p_subject_id: data.subjectId,
    });
    if (error) {
      failWithClientError("placement.getSubject", error, "Impossible de charger cette matière.");
    }
    if (payload === null || payload === undefined) return null;
    return parseOrFail(subjectCardSchema, payload, "placement.getSubject: shape");
  });

/**
 * Ouvrir un test (US-1). Débit (R-18) : un compte, dix tests par dix minutes au limiteur
 * persistant ; un visiteur, six par adresse au limiteur local — la digue globale est en SQL.
 */
export const startPlacementSession = createServerFn({ method: "POST" })
  .middleware([optionalSupabaseAuth])
  .validator((d) =>
    z
      .object({
        subjectId: z.string().min(1).max(64),
        audience: z.enum(["student", "parent"]).default("student"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<PlacementStarted> => {
    const { supabase, userId } = context;
    const limited = userId
      ? await isRateLimited(supabase, `placement_start_${userId}`, 10, 10 * 60_000)
      : isRateLimitedLocal(`placement_start_ip_${clientIpKey()}`, 6, 10 * 60_000);
    if (limited) throw new Error(TOO_MANY);

    const { data: payload, error } = await supabase.rpc("start_placement_session", {
      p_subject_id: data.subjectId,
      p_audience: data.audience,
    });
    if (error) {
      failWithPlacementError("placement.start", error, "Le test n'a pas pu démarrer.");
    }
    const started = parseOrFail(startedSchema, payload, "placement.start: shape");
    logger.info("placement.started", {
      subjectId: started.subject.id,
      audience: started.audience,
      signedIn: userId !== null,
    });
    return started;
  });

/** Finir un test : noter, figer, rendre le bilan (idempotent côté SQL). */
export const finishPlacementSession = createServerFn({ method: "POST" })
  .middleware([optionalSupabaseAuth])
  .validator((d) =>
    z
      .object({
        sessionId: z.guid(),
        /** `null` pour le propriétaire connecté qui a perdu la mémoire de son appareil. */
        token: z.guid().nullable(),
        answers: z
          .array(
            z.object({ questionId: z.guid(), choice: z.string().min(1).max(MAX_CHOICE_LENGTH) }),
          )
          .max(30),
        durationSeconds: z.number().int().min(0).max(86_400),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<PlacementBilan> => {
    const { supabase, userId } = context;
    const limited = userId
      ? await isRateLimited(supabase, `placement_finish_${userId}`, 20, 10 * 60_000)
      : isRateLimitedLocal(`placement_finish_ip_${clientIpKey()}`, 12, 10 * 60_000);
    if (limited) throw new Error(TOO_MANY);

    // Le tableau `{questionId, choice}` du reste du projet, replié en objet : c'est cette forme
    // que la RPC filtre (une clé par question, jamais deux).
    const answers: Record<string, string> = {};
    for (const a of data.answers) answers[a.questionId] = a.choice;

    const { data: payload, error } = await supabase.rpc("finish_placement_session", {
      p_session_id: data.sessionId,
      p_token: data.token ?? undefined,
      p_answers: answers,
      p_duration_seconds: data.durationSeconds,
    });
    if (error) {
      failWithPlacementError("placement.finish", error, "Impossible de corriger le test.");
    }
    const bilan = parseOrFail(bilanSchema, payload, "placement.finish: shape");
    logger.info("placement.finished", {
      subjectId: bilan.subject.id,
      scoreOn20: bilan.scoreOn20,
      durationSeconds: bilan.durationSeconds,
      signedIn: userId !== null,
    });
    return bilan;
  });

/** Relire un test : par jeton (l'appareil) ou par propriété (le compte connecté). */
export const getPlacementSession = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d) => z.object({ sessionId: z.guid(), token: z.guid().nullable() }).parse(d))
  .handler(async ({ data, context }): Promise<PlacementSession> => {
    const { supabase, userId } = context;
    const limited = userId
      ? await isRateLimited(supabase, `placement_get_${userId}`, 60, 60_000)
      : isRateLimitedLocal(`placement_get_ip_${clientIpKey()}`, 60, 60_000);
    if (limited) throw new Error(TOO_MANY);

    // `?? undefined` et non `null` : la signature SQL porte `DEFAULT NULL`, donc omettre
    // l'argument vaut exactement `NULL` — les types générés savent dire « optionnel ».
    const { data: payload, error } = await supabase.rpc("get_placement_session", {
      p_session_id: data.sessionId,
      p_token: data.token ?? undefined,
    });
    if (error) {
      failWithPlacementError("placement.get", error, "Impossible de charger ce test.");
    }
    return parseOrFail(sessionSchema, payload, "placement.get: shape");
  });

/** Rattacher les tests de l'appareil au compte qui vient de se connecter (R-16). */
export const claimPlacementSessions = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d) => z.object({ tokens: z.array(z.guid()).min(1).max(10) }).parse(d))
  .handler(async ({ data, context }): Promise<{ claimed: string[] }> => {
    const { supabase, userId } = context;
    if (await isRateLimited(supabase, `placement_claim_${userId}`, 10, 60_000)) {
      throw new Error(TOO_MANY);
    }
    const { data: payload, error } = await supabase.rpc("claim_placement_sessions", {
      p_tokens: data.tokens,
    });
    if (error) {
      failWithClientError("placement.claim", error, "Impossible de rattacher ces tests.");
    }
    const claimed = parseOrFail(
      z.object({ claimed: z.array(z.string()) }),
      payload,
      "placement.claim: shape",
    ).claimed;
    if (claimed.length > 0) logger.info("placement.claimed", { count: claimed.length });
    return { claimed };
  });

/** Le Hall : le dernier bilan fini, non bâclé, par matière (R-17). */
export const getMyPlacementOverview = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<PlacementOverview> => {
    const { data: payload, error } = await context.supabase.rpc("get_my_placement_overview");
    if (error) {
      failWithClientError("placement.overview", error, "Impossible de charger tes bilans.");
    }
    return parseOrFail(overviewSchema, payload, "placement.overview: shape");
  });
