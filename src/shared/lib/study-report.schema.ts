/**
 * Le schéma de la RPC `get_study_report` — côté SERVEUR uniquement (zod ne doit jamais
 * atteindre un chunk client). Typé contre `StudyReport` : une clé ajoutée d'un côté sans
 * l'autre casse `tsc`, pas un écran.
 */
import { z } from "zod";

import {
  STUDY_CHAPTER_STATUSES,
  STUDY_LEVELS,
  STUDY_PLAN_KINDS,
  type StudyReport,
} from "./study-report";

const count = z.number().int().nonnegative();

const studyChapterSchema = z.object({
  id: z.string(),
  title: z.string(),
  seen: z.boolean(),
  status: z.enum(STUDY_CHAPTER_STATUSES),
  star: count,
  missionsTotal: count,
  missionsCounted: count,
  missionsFailed: count,
  nextStar: count,
  missingForNext: count,
});

const studyExamSchema = z.object({
  scorePoints: z.number(),
  maxPoints: z.number().positive(),
  finishedAt: z.string(),
});

const studySubjectSchema = z.object({
  id: z.string(),
  name: z.string(),
  contentLanguage: z.string().nullable(),
  declared: z.boolean(),
  chaptersTotal: count,
  chaptersSeen: count,
  seenMastered: count,
  seenAcquired: count,
  seenInProgress: count,
  seenFragile: count,
  seenNotStarted: count,
  missionsSeenTotal: count,
  missionsSeenCounted: count,
  recentAttempts: count,
  recentAvgScore: z.number().nullable(),
  level: z.enum(STUDY_LEVELS),
  lastActiveAt: z.string().nullable(),
  exam: studyExamSchema.nullable(),
  /** `null` quand le bilan a été demandé sans le détail (tableau de bord). */
  chapters: z.array(studyChapterSchema).nullable(),
});

const studyDoneSchema = z.object({
  exerciseId: z.string(),
  title: z.string(),
  subjectId: z.string(),
  chapterTitle: z.string().nullable(),
  scorePct: z.number(),
});

const studyPlanItemSchema = z.object({
  exerciseId: z.string(),
  title: z.string(),
  subjectId: z.string(),
  chapterId: z.string(),
  chapterTitle: z.string(),
  kind: z.enum(STUDY_PLAN_KINDS),
  difficulty: count,
  estMinutes: count,
});

const studyReportSchema: z.ZodType<StudyReport> = z.object({
  studentId: z.string(),
  day: z.string(),
  parcoursId: z.string().nullable(),
  targetMinutes: count,
  doneMinutes: count,
  weekMinutes: count,
  weekActiveDays: count,
  subjects: z.array(studySubjectSchema),
  today: z.array(studyDoneSchema),
  plan: z.array(studyPlanItemSchema),
});

/** `null` sur une forme inattendue : la surface se tait, elle n'affiche jamais un demi-bilan. */
export function parseStudyReport(raw: unknown): StudyReport | null {
  const parsed = studyReportSchema.safeParse(raw);
  return parsed.success ? parsed.data : null;
}
