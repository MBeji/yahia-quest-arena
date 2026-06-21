/**
 * Program-conformance manifest + audit (school content / `ecole-tn`).
 *
 * The Zod content schema guarantees each chapter is *internally* well-formed
 * (a `cours.md`, a `resume.md`, a `quiz.json`), but nothing knows what a grade
 * is *supposed* to contain — which subjects, which chapters — so "a chapter is
 * missing" or "a whole subject is absent" is undetectable.
 *
 * A **program manifest** closes that gap: a declarative, per-grade transcription
 * of the official CNP program (the subjects expected at that grade and, per
 * subject, the chapters/notions expected). `auditGrade` then diffs the authored
 * content tree against it and reports:
 *   - coverage   — expected subjects / chapters that are missing, and authored
 *                  chapters that are NOT in the program (off-program);
 *   - completeness — every present chapter has a course + summary + quiz + at
 *                  least one mission (exercise);
 *   - level-fit  — the subject's language matches the program.
 *
 * This module is pure (no I/O): the CLI in `scripts/content/audit-program.ts`
 * loads manifests + content from disk and calls into here.
 */
import { z } from "zod";
import { CONTENT_LANGUAGES, type LoadedChapter, type LoadedSubject } from "./schema.ts";

// --------------------------------------------------------------------------
// Manifest schema — the codified official program for one grade.
// --------------------------------------------------------------------------

/** One expected chapter: its content slug + the official notion it covers. */
export const manifestChapterSchema = z.object({
  slug: z
    .string()
    .regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/, "chapter slug must be kebab-case (e.g. '04-addition')"),
  /** Official notion label in the program's terminology (e.g. `الجمع`). */
  notion: z.string().min(1),
  /** When true, a missing chapter is reported informationally, never as a gap. */
  optional: z.boolean().default(false),
});
export type ManifestChapter = z.infer<typeof manifestChapterSchema>;

/** One expected subject of the grade. */
export const manifestSubjectSchema = z.object({
  /** Content subject id, grade-suffixed (e.g. `math-1ere`). */
  id: z.string().regex(/^[a-z][a-z0-9-]*$/, "subject id must be kebab-case"),
  /** Human label (native), for the report only. */
  name: z.string().min(1).optional(),
  contentLanguage: z.enum(CONTENT_LANGUAGES),
  /**
   * The expected chapters, in program order. Empty = the chapter list has not
   * been transcribed from the CNP guide yet: the audit then checks the
   * subject's presence and the completeness of whatever chapters exist, but
   * skips chapter coverage (no false "missing"/"off-program").
   */
  chapters: z.array(manifestChapterSchema).default([]),
});
export type ManifestSubject = z.infer<typeof manifestSubjectSchema>;

/** `manifest/<gradeSlug>.json` — the official program of one grade. */
export const programManifestSchema = z.object({
  /** The grade's stable `grades.slug` (e.g. `1ere-base`). */
  grade: z.string().min(1),
  /**
   * Advisory by default. `true` declares the grade complete: `audit --strict`
   * then turns any finding for this grade into a CI failure (the opt-in gate).
   */
  sealed: z.boolean().default(false),
  /** Provenance of the program transcription (CNP guide ref, etc.). */
  source: z.string().min(1).optional(),
  note: z.string().optional(),
  subjects: z.array(manifestSubjectSchema).min(1, "a manifest must list at least one subject"),
});
export type ProgramManifest = z.infer<typeof programManifestSchema>;

// --------------------------------------------------------------------------
// Audit report types.
// --------------------------------------------------------------------------

export type FindingLevel =
  | "missing-subject"
  | "missing-chapter"
  | "off-program"
  | "incomplete"
  | "language";

export type Finding = { level: FindingLevel; subject: string; detail: string };

export type ChapterCompleteness = {
  slug: string;
  hasCourse: boolean;
  hasSummary: boolean;
  hasQuiz: boolean;
  exerciseCount: number;
  hasBoss: boolean;
  /** course + summary + quiz + at least one mission. */
  complete: boolean;
  issues: string[];
};

export type SubjectAudit = {
  id: string;
  present: boolean;
  /** null when the subject is absent. */
  languageOk: boolean | null;
  chaptersCodified: boolean;
  expectedChapters: number;
  presentExpected: number;
  missingChapters: string[];
  offProgramChapters: string[];
  /** Every present chapter that is incomplete or carries a ladder note. */
  chapterCompleteness: ChapterCompleteness[];
  /** Expected chapters present / expected, or null when not codified. */
  coveragePct: number | null;
  findings: Finding[];
};

export type GradeAudit = {
  grade: string;
  sealed: boolean;
  subjects: SubjectAudit[];
  /** Total findings across subjects — drives `--strict` when the grade is sealed. */
  findingCount: number;
};

// --------------------------------------------------------------------------
// The pure audit.
// --------------------------------------------------------------------------

const BOSS_MODE = "boss";

/** Completeness of a single authored chapter. */
export function auditChapter(ch: LoadedChapter): ChapterCompleteness {
  const hasCourse = ch.lesson.trim().length > 0;
  const hasSummary = ch.summary.trim().length > 0;
  const hasQuiz = ch.quiz.questions.length > 0;
  const exerciseCount = ch.exercises.length;
  const hasBoss = ch.exercises.some((e) => e.data.mode === BOSS_MODE);

  const issues: string[] = [];
  if (!hasCourse) issues.push("cours.md manquant ou vide");
  if (!hasSummary) issues.push("resume.md manquant ou vide");
  if (!hasQuiz) issues.push("quiz vide");
  if (exerciseCount === 0) issues.push("aucune mission (exercice)");
  else if (!hasBoss) issues.push("pas de mission boss (échelle incomplète)");

  const complete = hasCourse && hasSummary && hasQuiz && exerciseCount >= 1;
  return {
    slug: ch.slug,
    hasCourse,
    hasSummary,
    hasQuiz,
    exerciseCount,
    hasBoss,
    complete,
    issues,
  };
}

/** Diff one grade's authored content against its program manifest. */
export function auditGrade(manifest: ProgramManifest, subjects: LoadedSubject[]): GradeAudit {
  const bySubjectId = new Map(subjects.map((s) => [s.meta.id, s]));

  const subjectAudits = manifest.subjects.map((ms): SubjectAudit => {
    const found = bySubjectId.get(ms.id);
    const findings: Finding[] = [];
    const chaptersCodified = ms.chapters.length > 0;

    // (1) Subject absent entirely → one coverage finding, nothing else to check.
    if (!found) {
      findings.push({
        level: "missing-subject",
        subject: ms.id,
        detail: `matière absente du catalogue${ms.name ? ` (${ms.name})` : ""}`,
      });
      return {
        id: ms.id,
        present: false,
        languageOk: null,
        chaptersCodified,
        expectedChapters: ms.chapters.length,
        presentExpected: 0,
        missingChapters: ms.chapters.filter((c) => !c.optional).map((c) => c.slug),
        offProgramChapters: [],
        chapterCompleteness: [],
        coveragePct: chaptersCodified ? 0 : null,
        findings,
      };
    }

    // (2) Language fit.
    const languageOk = found.meta.contentLanguage === ms.contentLanguage;
    if (!languageOk) {
      findings.push({
        level: "language",
        subject: ms.id,
        detail: `langue '${found.meta.contentLanguage}' ≠ programme '${ms.contentLanguage}'`,
      });
    }

    const contentSlugs = new Set(found.chapters.map((c) => c.slug));
    const expectedSlugs = new Set(ms.chapters.map((c) => c.slug));

    // (3) Chapter coverage — only meaningful once the chapter list is codified.
    const missingChapters: string[] = [];
    const offProgramChapters: string[] = [];
    if (chaptersCodified) {
      for (const ec of ms.chapters) {
        if (!contentSlugs.has(ec.slug) && !ec.optional) {
          missingChapters.push(ec.slug);
          findings.push({
            level: "missing-chapter",
            subject: ms.id,
            detail: `chapitre manquant : ${ec.slug} — ${ec.notion}`,
          });
        }
      }
      for (const cs of found.chapters) {
        if (!expectedSlugs.has(cs.slug)) {
          offProgramChapters.push(cs.slug);
          findings.push({
            level: "off-program",
            subject: ms.id,
            detail: `chapitre hors-programme : ${cs.slug}`,
          });
        }
      }
    }

    // (4) Completeness of every present chapter.
    const chapterCompleteness: ChapterCompleteness[] = [];
    for (const ch of found.chapters) {
      const cc = auditChapter(ch);
      if (cc.issues.length > 0) chapterCompleteness.push(cc);
      if (!cc.complete) {
        findings.push({
          level: "incomplete",
          subject: ms.id,
          detail: `${ch.slug} : ${cc.issues.join(", ")}`,
        });
      }
    }

    const presentExpected = chaptersCodified
      ? ms.chapters.filter((c) => contentSlugs.has(c.slug)).length
      : found.chapters.length;
    const coveragePct = chaptersCodified
      ? Math.round((presentExpected / ms.chapters.length) * 100)
      : null;

    return {
      id: ms.id,
      present: true,
      languageOk,
      chaptersCodified,
      expectedChapters: ms.chapters.length,
      presentExpected,
      missingChapters,
      offProgramChapters,
      chapterCompleteness,
      coveragePct,
      findings,
    };
  });

  const findingCount = subjectAudits.reduce((n, s) => n + s.findings.length, 0);
  return { grade: manifest.grade, sealed: manifest.sealed, subjects: subjectAudits, findingCount };
}
