import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * Étude 02 — examen blanc : la couche serveur.
 *
 * Tout le métier est en SQL (migrations `20260816120000` / `20260816130000`) :
 * ces fonctions ne font que valider l'entrée, limiter le débit et donner une
 * forme typée à des payloads JSONB. Aucune règle d'examen — durée, barème,
 * unicité de la session classée, ouverture du corrigé — n'est décidée ici ; les
 * réécrire en TypeScript créerait un second juge, et deux juges finissent par
 * diverger.
 *
 * ⚠️ Ce module ne connaît AUCUNE clé de réponse. `start_mock_exam` construit son
 * JSON sans `correct_option` ni `explanation` ; la review n'arrive qu'après le
 * rendu, par `get_mock_exam_review`. C'est la posture GAP-020, appliquée à
 * l'épreuve.
 */

/**
 * Les six RPC de l'examen sont postérieures aux types Supabase générés (figés au
 * 2026-07-14, non régénérables sans accès DB) : on fige leur contrat ici, même
 * patron que `economy.server.ts` et `dashboard.server.ts`. À supprimer à la
 * prochaine régénération des types.
 */
type MockExamRpcClient = {
  rpc: (
    fn:
      | "list_mock_exams"
      | "start_mock_exam"
      | "save_mock_answers"
      | "finish_mock_exam"
      | "get_mock_exam_review"
      | "get_mock_exam_percentile",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

/**
 * Les signaux métier voyagent dans le message de l'exception SQL (motif
 * `DUNGEON_LOCKED` / `PARCOURS_LOCKED`). Ils sont traduits ici — et seulement
 * ici — pour que l'élève lise une phrase et non un code.
 */
const EXAM_ERRORS: ReadonlyArray<readonly [string, string]> = [
  ["MOCK_EXAM_NOT_FOUND", "Cet examen n'est pas disponible."],
  ["MOCK_EXAM_EMPTY", "Cet examen n'a plus d'épreuve — il sera republié bientôt."],
  [
    "MOCK_EXAM_ALREADY_RANKED",
    "Tu as déjà passé cet examen en mode classé. Tu peux le refaire en entraînement.",
  ],
  ["MOCK_EXAM_SESSION_NOT_FOUND", "Cette copie est introuvable."],
  ["MOCK_EXAM_FINISHED", "Cette copie est déjà rendue."],
  ["MOCK_EXAM_NOT_FINISHED", "Le corrigé s'ouvre une fois la copie rendue."],
  ["MOCK_EXAM_DEADLINE_PASSED", "Le temps est écoulé — ta copie a été rendue en l'état."],
];

function failWithExamError(context: string, error: { message: string }, fallback: string): never {
  for (const [code, message] of EXAM_ERRORS) {
    if (error.message.includes(code)) throw new Error(message);
  }
  failWithClientError(context, error, fallback);
}

// ---------------------------------------------------------------------------
// Formes de sortie. `.catch(...)` nulle part : une forme inattendue est une
// panne de lecture, pas un écran à moitié rempli.
// ---------------------------------------------------------------------------

const optionSchema = z.object({ id: z.string(), text: z.string() });

const examQuestionSchema = z.object({
  id: z.string(),
  prompt: z.string(),
  options: z.array(optionSchema).default([]),
  questionType: z.string().nullable().default("mcq"),
});

const examPaperSchema = z.object({
  exerciseId: z.string(),
  labelFr: z.string(),
  labelEn: z.string().nullable().default(null),
  labelAr: z.string().nullable().default(null),
  points: z.coerce.number(),
  subjectId: z.string().nullable().default(null),
  questions: z.array(examQuestionSchema),
});

const examSessionSchema = z.object({
  id: z.string(),
  kind: z.enum(["ranked", "practice"]),
  startedAt: z.string(),
  deadline: z.string(),
  finishedAt: z.string().nullable().default(null),
  answers: z.record(z.string(), z.string()).default({}),
});

const examHeaderSchema = z.object({
  id: z.string(),
  parcoursId: z.string(),
  titleFr: z.string(),
  titleEn: z.string().nullable().default(null),
  titleAr: z.string().nullable().default(null),
  durationMinutes: z.coerce.number(),
});

const startPayloadSchema = z.object({
  session: examSessionSchema,
  /** L'horloge du serveur : le chrono du client se cale dessus, jamais l'inverse. */
  serverNow: z.string(),
  exam: examHeaderSchema,
  papers: z.array(examPaperSchema),
});

const listItemSchema = examHeaderSchema.extend({
  paperCount: z.coerce.number(),
  maxPoints: z.coerce.number(),
  mySessions: z
    .array(
      z.object({
        id: z.string(),
        kind: z.enum(["ranked", "practice"]),
        startedAt: z.string(),
        deadline: z.string(),
        finishedAt: z.string().nullable().default(null),
        scorePoints: z.coerce.number().nullable().default(null),
        maxPoints: z.coerce.number().nullable().default(null),
      }),
    )
    .default([]),
});

const resultSchema = z.object({
  sessionId: z.string(),
  kind: z.enum(["ranked", "practice"]),
  finishedAt: z.string(),
  scorePoints: z.coerce.number(),
  maxPoints: z.coerce.number(),
  scorePct: z.coerce.number(),
  /** La seule échelle que l'élève et le parent savent lire. */
  scoreOn20: z.coerce.number(),
  xpEarned: z.coerce.number(),
  coinsEarned: z.coerce.number(),
  papers: z.array(
    z.object({
      exerciseId: z.string(),
      labelFr: z.string(),
      labelEn: z.string().nullable().default(null),
      labelAr: z.string().nullable().default(null),
      points: z.coerce.number(),
      correct: z.coerce.number(),
      total: z.coerce.number(),
      earned: z.coerce.number().nullable().default(0),
    }),
  ),
});

const reviewSchema = z.array(
  z.object({
    exerciseId: z.string(),
    labelFr: z.string(),
    labelEn: z.string().nullable().default(null),
    labelAr: z.string().nullable().default(null),
    questions: z.array(
      z.object({
        questionId: z.string(),
        prompt: z.string(),
        options: z.array(optionSchema).default([]),
        questionType: z.string().nullable().default("mcq"),
        selectedChoice: z.string().nullable().default(null),
        isCorrect: z.boolean(),
        correctChoice: z.string().nullable().default(null),
        explanation: z.string().nullable().default(null),
      }),
    ),
  }),
);

const percentileSchema = z.object({
  candidates: z.coerce.number(),
  minCandidates: z.coerce.number(),
  percentile: z.coerce.number().nullable().default(null),
});

export type ExamStartPayload = z.infer<typeof startPayloadSchema>;
export type ExamListItem = z.infer<typeof listItemSchema>;
export type ExamResult = z.infer<typeof resultSchema>;
export type ExamReview = z.infer<typeof reviewSchema>;
export type ExamPercentile = z.infer<typeof percentileSchema>;
export type ExamPaper = z.infer<typeof examPaperSchema>;
export type ExamQuestion = z.infer<typeof examQuestionSchema>;

const SHAPE_ERROR_FR = "Réponse inattendue du serveur d'examen.";

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

export const listMockExams = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ parcoursId: z.string().max(64).nullish() }).parse(d ?? {}))
  .handler(async ({ data, context }): Promise<ExamListItem[]> => {
    const client = context.supabase as unknown as MockExamRpcClient;
    const { data: payload, error } = await client.rpc("list_mock_exams", {
      p_parcours_id: data.parcoursId ?? null,
    });
    if (error) {
      failWithExamError("exam.listMockExams", error, "Impossible de charger les examens blancs.");
    }
    return parseOrFail(z.array(listItemSchema), payload, "exam.listMockExams: shape");
  });

export const startMockExam = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        examId: z.guid(),
        kind: z.enum(["ranked", "practice"]).default("ranked"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<ExamStartPayload> => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `exam_start_${userId}`, 5, 30_000)) {
      throw new Error("Trop d'ouvertures d'examen. Attends un instant.");
    }

    const client = supabase as unknown as MockExamRpcClient;
    const { data: payload, error } = await client.rpc("start_mock_exam", {
      p_exam_id: data.examId,
      p_kind: data.kind,
    });
    if (error) {
      failWithExamError("exam.startMockExam", error, "Impossible d'ouvrir l'examen.");
    }
    return parseOrFail(startPayloadSchema, payload, "exam.startMockExam: shape");
  });

/**
 * R-8 : la sauvegarde est un PATCH idempotent. Le client envoie le tableau
 * `{questionId, choice}` du reste du projet ; on le replie en objet parce que
 * c'est cette forme-là qui rend la fusion SQL (`answers || patch`) incapable de
 * créer deux réponses pour une même question.
 */
export const saveMockAnswers = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        sessionId: z.guid(),
        answers: z
          .array(
            z.object({
              questionId: z.guid(),
              choice: z.string().min(1).max(MAX_CHOICE_LENGTH),
            }),
          )
          .min(1)
          .max(200),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Généreux : l'autosave d'une épreuve de 90 minutes tape souvent.
    if (await isRateLimited(supabase, `exam_save_${userId}`, 120, 60_000)) {
      throw new Error("Trop de sauvegardes. Attends un instant.");
    }

    const patch: Record<string, string> = {};
    for (const a of data.answers) patch[a.questionId] = a.choice;

    const client = supabase as unknown as MockExamRpcClient;
    const { data: payload, error } = await client.rpc("save_mock_answers", {
      p_session_id: data.sessionId,
      p_answers: patch,
    });
    if (error) {
      failWithExamError("exam.saveMockAnswers", error, "Impossible d'enregistrer tes réponses.");
    }
    return parseOrFail(
      z.object({
        answered: z.coerce.number(),
        deadline: z.string(),
        serverNow: z.string(),
      }),
      payload,
      "exam.saveMockAnswers: shape",
    );
  });

export const finishMockExam = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ sessionId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<ExamResult> => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `exam_finish_${userId}`, 5, 30_000)) {
      throw new Error("Trop de rendus. Attends un instant.");
    }

    const client = supabase as unknown as MockExamRpcClient;
    const { data: payload, error } = await client.rpc("finish_mock_exam", {
      p_session_id: data.sessionId,
    });
    if (error) {
      failWithExamError("exam.finishMockExam", error, "Impossible de rendre ta copie.");
    }
    return parseOrFail(resultSchema, payload, "exam.finishMockExam: shape");
  });

export const getMockExamReview = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ sessionId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<ExamReview> => {
    const client = context.supabase as unknown as MockExamRpcClient;
    const { data: payload, error } = await client.rpc("get_mock_exam_review", {
      p_session_id: data.sessionId,
    });
    if (error) {
      failWithExamError("exam.getMockExamReview", error, "Impossible de charger le corrigé.");
    }
    return parseOrFail(reviewSchema, payload, "exam.getMockExamReview: shape");
  });

export const getMockExamPercentile = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ sessionId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<ExamPercentile> => {
    const client = context.supabase as unknown as MockExamRpcClient;
    const { data: payload, error } = await client.rpc("get_mock_exam_percentile", {
      p_session_id: data.sessionId,
    });
    if (error) {
      failWithExamError("exam.getMockExamPercentile", error, "Impossible de calculer ton rang.");
    }
    return parseOrFail(percentileSchema, payload, "exam.getMockExamPercentile: shape");
  });
