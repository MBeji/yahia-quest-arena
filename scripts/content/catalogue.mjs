#!/usr/bin/env node
// Generates content/CATALOGUE.md — a navigation index of every authored subject
// (theme → grade → subject, with chapter / exercise / quiz counts) so any session can
// answer "does this subject/grade already exist?" without globbing the whole tree.
//
// Output is DETERMINISTIC (sorted, no timestamp) so it diffs cleanly and can later be
// staleness-checked in CI. Counts are read from disk: a chapter = a dir with chapter.json;
// a subject with 0 chapters is flagged as a ⚠ stub (subject.json exists but no content yet).
//
// Regenerate: npm run content:catalogue
import { readdirSync, readFileSync, writeFileSync, existsSync, statSync } from "node:fs";
import { join } from "node:path";

const CONTENT = join(process.cwd(), "content");
const OUT = join(CONTENT, "CATALOGUE.md");

const isDir = (p) => existsSync(p) && statSync(p).isDirectory();

function readSubject(dir) {
  const subjDir = join(CONTENT, dir);
  let meta;
  try {
    meta = JSON.parse(readFileSync(join(subjDir, "subject.json"), "utf8"));
  } catch {
    return null;
  }

  let chapters = 0;
  let exercises = 0;
  let quizzes = 0;
  for (const entry of readdirSync(subjDir)) {
    const chDir = join(subjDir, entry);
    if (!isDir(chDir) || !existsSync(join(chDir, "chapter.json"))) continue;
    chapters += 1;
    if (existsSync(join(chDir, "quiz.json"))) quizzes += 1;
    const exDir = join(chDir, "exercices");
    if (isDir(exDir)) {
      exercises += readdirSync(exDir).filter((f) => f.endsWith(".json")).length;
    }
  }

  return {
    id: typeof meta.id === "string" ? meta.id : dir,
    name: typeof meta.nameFr === "string" ? meta.nameFr : "",
    themeId: typeof meta.themeId === "string" ? meta.themeId : "(no theme)",
    gradeSlug: typeof meta.gradeSlug === "string" ? meta.gradeSlug : null,
    lang: typeof meta.contentLanguage === "string" ? meta.contentLanguage : "",
    displayOrder: typeof meta.displayOrder === "number" ? meta.displayOrder : 999,
    chapters,
    exercises,
    quizzes,
  };
}

const subjects = readdirSync(CONTENT)
  .filter((d) => isDir(join(CONTENT, d)) && existsSync(join(CONTENT, d, "subject.json")))
  .map(readSubject)
  .filter(Boolean);

const byTheme = new Map();
for (const s of subjects) {
  if (!byTheme.has(s.themeId)) byTheme.set(s.themeId, []);
  byTheme.get(s.themeId).push(s);
}

const themes = [...byTheme.keys()].sort();
const totalChapters = subjects.reduce((a, s) => a + s.chapters, 0);
const totalExercises = subjects.reduce((a, s) => a + s.exercises, 0);
const stubs = subjects.filter((s) => s.chapters === 0).length;

const out = [];
out.push("# Content catalogue (generated)");
out.push("");
out.push(
  "> **Generated file — do not edit by hand.** Regenerate with `npm run content:catalogue`.",
);
out.push(
  "> Navigation index of every authored subject. Counts are read from disk (a chapter = a dir",
);
out.push(
  "> with `chapter.json`; a subject with 0 chapters is a ⚠ stub). Check here whether a subject /",
);
out.push("> grade already exists before creating one, and which slugs are taken.");
out.push("");
out.push(
  `**${subjects.length} subjects · ${totalChapters} chapters · ${totalExercises} exercises · ` +
    `${themes.length} themes · ${stubs} stub(s)**`,
);
out.push("");

for (const theme of themes) {
  const list = byTheme
    .get(theme)
    .slice()
    .sort((a, b) => {
      const ga = a.gradeSlug ?? "";
      const gb = b.gradeSlug ?? "";
      if (ga !== gb) return ga.localeCompare(gb);
      if (a.displayOrder !== b.displayOrder) return a.displayOrder - b.displayOrder;
      return a.id.localeCompare(b.id);
    });
  out.push(`## ${theme}`);
  out.push("");
  out.push("| subject id | name | grade | lang | chapters | exercises | quiz |");
  out.push("| --- | --- | --- | --- | --: | --: | --: |");
  for (const s of list) {
    const stub = s.chapters === 0 ? " ⚠ stub" : "";
    const name = s.name.replace(/\|/g, "\\|");
    out.push(
      `| \`${s.id}\`${stub} | ${name} | ${s.gradeSlug ?? "—"} | ${s.lang || "—"} | ` +
        `${s.chapters} | ${s.exercises} | ${s.quizzes} |`,
    );
  }
  out.push("");
}

writeFileSync(OUT, out.join("\n") + "\n", "utf8");
console.log(
  `Wrote content/CATALOGUE.md: ${subjects.length} subjects, ${themes.length} themes, ${stubs} stub(s).`,
);
