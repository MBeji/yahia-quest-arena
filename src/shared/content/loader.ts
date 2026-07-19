import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";
import { z } from "zod";
import {
  chapterMetaSchema,
  competencyRegistrySchema,
  exerciseSchema,
  misconceptionRegistrySchema,
  quizSchema,
  subjectMetaWithCompileToSchema,
  videoRegistrySchema,
  type CompetencyRegistry,
  type LoadedChapter,
  type LoadedSubject,
  type LoadedExercise,
  type MisconceptionRegistry,
  type SubjectMeta,
  type VideoRegistry,
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
const MISCONCEPTION_REGISTRY = "misconceptions.json";
const COMPETENCES_DIR = "competences";
const VIDEO_REGISTRY = "videos.json";

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
    subjectMetaWithCompileToSchema,
    readJson(join(subjectDir, SUBJECT_META)),
    join(subjectDir, SUBJECT_META),
  );

  const chapters = listDirs(subjectDir)
    .filter((slug) => existsSync(join(subjectDir, slug, CHAPTER_META)))
    .map((slug) => loadChapter(join(subjectDir, slug), slug));

  return { meta, chapters };
}

/**
 * Load and validate the misconception registry (`content/misconceptions.json`).
 * Absent → an empty registry (tagging is progressive — étude 04 D-4); present →
 * validated against the schema so a malformed registry fails `content:check`.
 */
export function loadMisconceptionRegistry(contentRoot: string): MisconceptionRegistry {
  const filePath = join(contentRoot, MISCONCEPTION_REGISTRY);
  if (!existsSync(filePath)) return {};
  return parseOrThrow(misconceptionRegistrySchema, readJson(filePath), filePath);
}

/**
 * Load and validate every competency family registry under
 * `content/competences/*.json` (étude 07 D-1). Absent directory → empty list
 * (the graph rolls out progressively); a malformed registry (bad shape,
 * unknown prereq, cycle — R-3) fails `content:check`. The file name must
 * match the declared `family` (one registry per family, no aliases).
 */
export function loadCompetencyRegistries(contentRoot: string): CompetencyRegistry[] {
  const dir = join(contentRoot, COMPETENCES_DIR);
  if (!existsSync(dir)) return [];
  return listJsonFiles(dir).map((file) => {
    const filePath = join(dir, file);
    const registry = parseOrThrow(competencyRegistrySchema, readJson(filePath), filePath);
    const base = file.replace(/\.json$/, "");
    if (base !== registry.family) {
      throw new ContentValidationError(
        `Competency registry ${filePath} declares family "${registry.family}" but is named "${base}.json" — they must match`,
      );
    }
    return registry;
  });
}

/**
 * Load and validate the curated-video registry (`content/videos.json`, étude 23
 * D-2). Absent → an empty registry (videos roll out progressively); present →
 * validated against the schema so a malformed registry fails `content:check`.
 * Usage of unknown / non-active / language-mismatched refs is cross-checked by
 * `content:qa`.
 */
export function loadVideosRegistry(contentRoot: string): VideoRegistry {
  const filePath = join(contentRoot, VIDEO_REGISTRY);
  if (!existsSync(filePath)) return {};
  return parseOrThrow(videoRegistrySchema, readJson(filePath), filePath);
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

/**
 * Mutualisation (étude 16 D-4) — expand shared subjects into their compiled
 * per-section subjects.
 *
 * A subject WITHOUT `compileTo` passes through unchanged (and must not carry
 * any chapter/exercise `gradeSlugs`). A subject WITH `compileTo` is replaced by
 * one clone per target: `id`/`gradeSlug` (and optionally `nameFr`/`description`)
 * are overridden, chapters and exercises are filtered by their `gradeSlugs`
 * narrowing (absent = all targets). Every downstream consumer (build, qa,
 * program audit) sees only compiled subjects, so UUIDv5 derivation, migration
 * filenames and pruning all key on the COMPILED identity — the invariant that
 * makes a later fork loss-free (étude 16 D-4.a/R-7).
 *
 * Throws on: narrowing outside a shared subject, a narrowing slug that is not
 * one of the subject's targets, a target left with zero chapters, or two
 * compiled/physical subjects sharing one id (never a silent overwrite).
 */
export function expandSubjects(subjects: LoadedSubject[]): LoadedSubject[] {
  const expanded: LoadedSubject[] = [];
  const originOf = new Map<string, string>();

  const register = (id: string, origin: string): void => {
    const prior = originOf.get(id);
    if (prior) {
      throw new ContentValidationError(
        `Duplicate compiled subject id '${id}' (from '${prior}' and '${origin}') — compiled ids must be globally unique`,
      );
    }
    originOf.set(id, origin);
  };

  for (const subject of subjects) {
    const targets = subject.meta.compileTo;

    if (!targets) {
      for (const chapter of subject.chapters) {
        if (chapter.meta.gradeSlugs) {
          throw new ContentValidationError(
            `${subject.meta.id}/${chapter.slug}: 'gradeSlugs' requires a 'compileTo' declaration on the subject`,
          );
        }
        for (const ex of chapter.exercises) {
          if (ex.data.gradeSlugs) {
            throw new ContentValidationError(
              `${subject.meta.id}/${chapter.slug}/${ex.slug}: 'gradeSlugs' requires a 'compileTo' declaration on the subject`,
            );
          }
        }
      }
      register(subject.meta.id, subject.meta.id);
      expanded.push(subject);
      continue;
    }

    const targetSlugs = new Set(targets.map((t) => t.gradeSlug));
    for (const chapter of subject.chapters) {
      for (const slug of chapter.meta.gradeSlugs ?? []) {
        if (!targetSlugs.has(slug)) {
          throw new ContentValidationError(
            `${subject.meta.id}/${chapter.slug}: gradeSlug '${slug}' is not a compileTo target of this subject`,
          );
        }
      }
      const effective = new Set(chapter.meta.gradeSlugs ?? [...targetSlugs]);
      for (const ex of chapter.exercises) {
        for (const slug of ex.data.gradeSlugs ?? []) {
          if (!effective.has(slug)) {
            throw new ContentValidationError(
              `${subject.meta.id}/${chapter.slug}/${ex.slug}: gradeSlug '${slug}' is not among the chapter's effective targets`,
            );
          }
        }
      }
    }

    for (const target of targets) {
      const meta: SubjectMeta = {
        ...subject.meta,
        id: target.id,
        gradeSlug: target.gradeSlug,
        nameFr: target.nameFr ?? subject.meta.nameFr,
        description: target.description ?? subject.meta.description,
        compileTo: undefined,
      };
      const chapters: LoadedChapter[] = subject.chapters
        .filter((ch) => !ch.meta.gradeSlugs || ch.meta.gradeSlugs.includes(target.gradeSlug))
        .map((ch) => ({
          ...ch,
          exercises: ch.exercises.filter(
            (ex) => !ex.data.gradeSlugs || ex.data.gradeSlugs.includes(target.gradeSlug),
          ),
        }));
      if (chapters.length === 0) {
        throw new ContentValidationError(
          `${subject.meta.id}: compileTo target '${target.id}' receives no chapter — narrow less or drop the target`,
        );
      }
      register(target.id, subject.meta.id);
      expanded.push({ meta, chapters });
    }
  }

  return expanded;
}
