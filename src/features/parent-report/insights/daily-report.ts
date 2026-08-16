import { z } from "zod";

/**
 * La forme du rapport quotidien renvoyé par `get_student_daily_report`.
 *
 * Le RPC rend un `Json` opaque : on le valide champ par champ, avec un
 * `.catch()` partout. Un tableau de bord parental n'a pas le droit de tomber en
 * écran blanc parce qu'un agrégat est arrivé en `null` — il affiche zéro et
 * continue. C'est la même posture que `studentReportSchema` (bilan famille).
 */

const numberish = z.coerce.number().catch(0);
const nullableNumber = z.coerce.number().nullable().catch(null);
const text = z.string().catch("");
const nullableText = z.string().nullable().catch(null);

const activityBreakdownSchema = z
  .object({
    lesson: numberish,
    exercise: numberish,
    quiz: numberish,
    recall: numberish,
    arena: numberish,
    browse: numberish,
  })
  .catch({ lesson: 0, exercise: 0, quiz: 0, recall: 0, arena: 0, browse: 0 });

const dailySliceSchema = z.object({
  date: text,
  appMinutes: numberish,
  learningMinutes: numberish,
  byActivity: activityBreakdownSchema,
  firstAt: nullableText,
  lastAt: nullableText,
  sessions: numberish,
  exercises: numberish,
  lessonsRead: numberish,
  activities: numberish,
  avgScore: numberish,
  correct: numberish,
  questions: numberish,
});

const lessonViewSchema = z.object({
  date: text,
  firstAt: text,
  at: text,
  chapterId: nullableText,
  chapterTitle: text,
  subjectId: nullableText,
  subjectName: text,
  gradeName: nullableText,
  seconds: numberish,
  progressPct: numberish,
  views: numberish,
  studied: z.boolean().catch(false),
});

const exerciseRunSchema = z.object({
  attemptId: text,
  date: text,
  at: text,
  exerciseId: nullableText,
  exerciseTitle: text,
  mode: text,
  variant: text,
  difficulty: numberish,
  chapterId: nullableText,
  chapterTitle: text,
  subjectId: nullableText,
  subjectName: text,
  gradeName: nullableText,
  durationSeconds: numberish,
  scorePct: numberish,
  correct: numberish,
  wrong: numberish,
  total: numberish,
  attemptNo: numberish,
  previousScorePct: nullableNumber,
});

const subjectSliceSchema = z.object({
  subjectId: text,
  name: text,
  colorToken: nullableText,
  gradeName: nullableText,
  minutes: numberish,
  lessons: numberish,
  exercises: numberish,
  previousExercises: numberish,
  avgScore: numberish,
  scoreDelta: nullableNumber,
});

const chapterSliceSchema = z.object({
  chapterId: text,
  title: text,
  subjectId: text,
  subjectName: text,
  exercises: numberish,
  avgScore: numberish,
  correct: numberish,
  questions: numberish,
});

const EMPTY_TOTALS = {
  appMinutes: 0,
  learningMinutes: 0,
  byActivity: { lesson: 0, exercise: 0, quiz: 0, recall: 0, arena: 0, browse: 0 },
  activeDays: 0,
  sessions: 0,
  exercises: 0,
  exercisesPassed: 0,
  exercisesFailed: 0,
  correct: 0,
  wrong: 0,
  questions: 0,
  avgScore: 0,
  avgSecondsPerExercise: 0,
  avgSecondsPerQuestion: 0,
  lessonsOpened: 0,
  lessonsStudied: 0,
  exerciseSessionsStarted: 0,
  exerciseSessionsCompleted: 0,
  avgTriesToPass: 0,
};

const totalsSchema = z
  .object({
    appMinutes: numberish,
    learningMinutes: numberish,
    byActivity: activityBreakdownSchema,
    activeDays: numberish,
    sessions: numberish,
    exercises: numberish,
    exercisesPassed: numberish,
    exercisesFailed: numberish,
    correct: numberish,
    wrong: numberish,
    questions: numberish,
    avgScore: numberish,
    avgSecondsPerExercise: numberish,
    avgSecondsPerQuestion: numberish,
    lessonsOpened: numberish,
    lessonsStudied: numberish,
    exerciseSessionsStarted: numberish,
    exerciseSessionsCompleted: numberish,
    avgTriesToPass: numberish,
  })
  .catch(EMPTY_TOTALS);

export const dailyReportSchema = z.object({
  student: z
    .object({
      displayName: nullableText,
      level: numberish,
      currentStreak: numberish,
      longestStreak: numberish,
      lastActiveDate: nullableText,
    })
    .catch({
      displayName: null,
      level: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastActiveDate: null,
    }),
  range: z
    .object({
      from: text,
      to: text,
      days: numberish,
      timezone: text,
      /** Date du tout premier temps mesuré — `null` avant l'instrumentation. */
      measuredSince: nullableText,
    })
    .catch({ from: "", to: "", days: 0, timezone: "UTC", measuredSince: null }),
  thresholds: z
    .object({
      passPct: numberish,
      studiedSeconds: numberish,
      studiedPct: numberish,
      sessionGapMinutes: numberish,
    })
    .catch({ passPct: 60, studiedSeconds: 120, studiedPct: 60, sessionGapMinutes: 30 }),
  days: z.array(dailySliceSchema).catch([]),
  lessons: z.array(lessonViewSchema).catch([]),
  exercises: z.array(exerciseRunSchema).catch([]),
  subjects: z.array(subjectSliceSchema).catch([]),
  chapters: z.array(chapterSliceSchema).catch([]),
  totals: totalsSchema,
  previous: totalsSchema,
});

export type DailyReport = z.infer<typeof dailyReportSchema>;
export type DailySlice = z.infer<typeof dailySliceSchema>;
export type LessonView = z.infer<typeof lessonViewSchema>;
export type ExerciseRun = z.infer<typeof exerciseRunSchema>;
export type SubjectSlice = z.infer<typeof subjectSliceSchema>;
export type ChapterSlice = z.infer<typeof chapterSliceSchema>;
export type ActivityTotals = z.infer<typeof totalsSchema>;
export type ActivityBreakdown = z.infer<typeof activityBreakdownSchema>;

export function parseDailyReport(payload: unknown): DailyReport {
  if (!payload || typeof payload !== "object") {
    throw new Error("Invalid daily report payload.");
  }
  return dailyReportSchema.parse(payload);
}

/** Le détail d'une tentative — ce que l'enfant a répondu, question par question. */
const attemptQuestionSchema = z.object({
  questionId: text,
  order: numberish,
  prompt: text,
  questionType: text,
  // `{ id, text }` — la forme `BaseOption` du moteur de quête. Indispensable :
  // la réponse enregistrée est l'IDENTIFIANT de l'option (« b »), qui ne veut
  // rien dire pour un parent tant qu'on ne le remet pas en face de son libellé.
  options: z.array(z.object({ id: text, text: text })).catch([]),
  answer: nullableText,
  isCorrect: z.boolean().catch(false),
  /** `null` sur un quiz de compréhension : sa correction n'est jamais révélée. */
  correctOption: nullableText,
  explanation: nullableText,
});

/**
 * Le libellé lisible d'une réponse : le texte de l'option quand l'identifiant en
 * désigne une, la valeur brute sinon (réponse libre, mise en ordre, appariement).
 */
export function answerLabel(
  question: { options: { id: string; text: string }[] },
  value: string | null,
): string | null {
  if (!value) return null;
  return question.options.find((option) => option.id === value)?.text ?? value;
}

export const attemptDetailSchema = z.object({
  attemptId: text,
  exerciseId: nullableText,
  exerciseTitle: text,
  mode: text,
  difficulty: numberish,
  chapterId: nullableText,
  chapterTitle: text,
  subjectName: text,
  contentLanguage: z.string().catch("fr"),
  completedAt: text,
  durationSeconds: numberish,
  scorePct: numberish,
  correct: numberish,
  total: numberish,
  reviewHidden: z.boolean().catch(false),
  questions: z.array(attemptQuestionSchema).catch([]),
});

export type AttemptDetail = z.infer<typeof attemptDetailSchema>;
export type AttemptQuestion = z.infer<typeof attemptQuestionSchema>;

export function parseAttemptDetail(payload: unknown): AttemptDetail {
  if (!payload || typeof payload !== "object") {
    throw new Error("Invalid attempt detail payload.");
  }
  return attemptDetailSchema.parse(payload);
}
