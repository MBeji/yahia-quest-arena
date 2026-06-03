import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";
import { z } from "zod";
import {
  chapterMetaSchema,
  exerciseSchema,
  quizSchema,
  subjectMetaSchema,
  type LoadedChapter,
  type LoadedExercise,
  type LoadedSubject,
} from "./schema.ts";

/** Thrown when a content file is missing or fails schema validation. */
export class ContentValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ContentValidationError";
  }
}

const LESSON_FILE = "cours.md";
const SUMMARY_FILE = "resume.md";
const CHAPTER_META = "chapter.json";
const SUBJECT_META = "subject.json";
const QUIZ_FILE = "quiz.json";
const EXERCISES_DIR = "exercices";

function readJson(filePath: string): unknown {
  if (!existsSync(filePath)) {
    throw new ContentValidationError(`Missing required file: ${filePath}`);
  }
  try {
    return JSON.parse(readFileSync(filePath, "utf8"));
  } catch (err) {
    throw new ContentValidationError(`Invalid JSON in ${filePath}: ${(err as Error).message}`);
  }
}

function readText(filePath: string): string {
  if (!existsSync(filePath)) {
    throw new ContentValidationError(`Missing required file: ${filePath}`);
  }
  const text = readFileSync(filePath, "utf8").trim();
  if (text.length === 0) {
    throw new ContentValidationError(`File is empty: ${filePath}`);
  }
  return text;
}

function parseOrThrow<S extends z.ZodTypeAny>(
  schema: S,
  data: unknown,
  filePath: string,
): z.infer<S> {
  const result = schema.safeParse(data);
  if (!result.success) {
    const issues = result.error.issues
      .map((i) => `  • ${i.path.join(".") || "<root>"}: ${i.message}`)
      .join("\n");
    throw new ContentValidationError(`Validation failed for ${filePath}:\n${issues}`);
  }
  return result.data;
}

const listDirs = (dir: string): string[] =>
  readdirSync(dir)
    .filter((name) => statSync(join(dir, name)).isDirectory())
    .sort();

const listJsonFiles = (dir: string): string[] =>
  existsSync(dir)
    ? readdirSync(dir)
        .filter((name) => name.endsWith(".json"))
        .sort()
    : [];

function loadChapter(chapterDir: string, slug: string): LoadedChapter {
  const meta = parseOrThrow(
    chapterMetaSchema,
    readJson(join(chapterDir, CHAPTER_META)),
    join(chapterDir, CHAPTER_META),
  );
  const lesson = readText(join(chapterDir, LESSON_FILE));
  const summary = readText(join(chapterDir, SUMMARY_FILE));
  const quiz = parseOrThrow(
    quizSchema,
    readJson(join(chapterDir, QUIZ_FILE)),
    join(chapterDir, QUIZ_FILE),
  );

  const exercisesDir = join(chapterDir, EXERCISES_DIR);
  const exercises: LoadedExercise[] = listJsonFiles(exercisesDir).map((file) => {
    const filePath = join(exercisesDir, file);
    return {
      slug: file.replace(/\.json$/, ""),
      data: parseOrThrow(exerciseSchema, readJson(filePath), filePath),
    };
  });

  return { slug, meta, lesson, summary, quiz, exercises };
}

/** Load and validate one subject directory (containing `subject.json`). */
export function loadSubject(subjectDir: string): LoadedSubject {
  const meta = parseOrThrow(
    subjectMetaSchema,
    readJson(join(subjectDir, SUBJECT_META)),
    join(subjectDir, SUBJECT_META),
  );

  const chapters = listDirs(subjectDir)
    .filter((slug) => existsSync(join(subjectDir, slug, CHAPTER_META)))
    .map((slug) => loadChapter(join(subjectDir, slug), slug));

  return { meta, chapters };
}

/** Discover and load every subject under a content root directory. */
export function loadAllSubjects(contentRoot: string): LoadedSubject[] {
  if (!existsSync(contentRoot)) {
    throw new ContentValidationError(`Content root does not exist: ${contentRoot}`);
  }
  return listDirs(contentRoot)
    .filter((name) => existsSync(join(contentRoot, name, SUBJECT_META)))
    .map((name) => loadSubject(join(contentRoot, name)));
}
