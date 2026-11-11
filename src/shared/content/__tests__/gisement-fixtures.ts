/**
 * Fixtures SYNTHÉTIQUES des tests du gisement (étude 36, lot 2) — inventées de bout en bout :
 * aucun manifeste, registre, devoir ni ligne du corpus privé n'entre dans ce dépôt
 * (`leak:check`). Seules les FORMES sont réelles (manifeste, registre, dix colonnes).
 */
import { spawnSync } from "node:child_process";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  type GisementLine,
  LINE_COLUMNS,
  type LineVocabulary,
  renderFault,
  validateLines,
} from "../../../../scripts/content/gisement/lignes-checks.ts";

export const GRADE = "7eme-base";
export const SUBJECT = "math";
/** L'ordre d'enseignement n'est PAS l'ordre lexical des slugs : le placement doit suivre le premier. */
export const CHAPTERS = ["03-fractions", "01-nombres", "02-proportions", "04-aires"];
export const COMPETENCIES = [
  "math.num.fractions",
  "math.num.entiers",
  "math.num.proportions",
  "math.geo.aires",
];
export const VOCAB: LineVocabulary = { chapters: CHAPTERS, competencies: new Set(COMPETENCIES) };

type Column = (typeof LINE_COLUMNS)[number];

export const BASE_ROW: Record<Column, string> = {
  doc: "D06",
  creneau: "DC1",
  exo: "2",
  bareme: "4,5",
  chapitres: "02-proportions",
  competences: "math.num.proportions",
  archetype: "calculer une quatrième proportionnelle puis comparer deux prix",
  etapes: "3",
  piege: "inverser le rapport",
  etage: "d2",
};

/** Une ligne de dix colonnes, `BASE_ROW` surchargée. */
export const tsvLine = (over: Partial<Record<Column, string>> = {}): string =>
  LINE_COLUMNS.map((c) => ({ ...BASE_ROW, ...over })[c]).join("\t");

/** Des lignes validées contre `VOCAB` ; une faute fait échouer le test qui les construit. */
export function parsedLines(...rows: string[]): GisementLine[] {
  const { lines, faults } = validateLines([{ file: "lignes.tsv", text: rows.join("\n") }], VOCAB);
  if (faults.length > 0) throw new Error(faults.map(renderFault).join("\n"));
  return lines;
}

export function withTmp<T>(fn: (dir: string) => T): T {
  const dir = mkdtempSync(join(tmpdir(), "gisement-"));
  try {
    return fn(dir);
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
}

/**
 * Un corpus minimal sous `<root>/content` : le manifeste de la classe (avec un second sujet,
 * `arabic`, qu'aucun registre ne couvre), le registre `math`, et des fichiers d'exercices
 * existants par chapitre.
 */
export function writeCorpus(root: string, exercises: Record<string, string[]> = {}): string {
  const content = join(root, "content");
  const manifestDir = join(content, "programmes-officiels", "manifest");
  mkdirSync(manifestDir, { recursive: true });
  writeFileSync(
    join(manifestDir, `${GRADE}.json`),
    JSON.stringify({
      grade: GRADE,
      subjects: [
        {
          id: SUBJECT,
          contentLanguage: "fr",
          chapters: CHAPTERS.map((slug) => ({ slug, notion: slug.slice(3) })),
        },
        { id: "arabic", contentLanguage: "ar", chapters: [{ slug: "01-jumla", notion: "jumla" }] },
      ],
    }),
  );
  mkdirSync(join(content, "competences"), { recursive: true });
  writeFileSync(
    join(content, "competences", "math.json"),
    JSON.stringify({
      family: "math",
      subjectPrefixes: ["math"],
      competencies: COMPETENCIES.map((id) => ({ id, labels: { fr: id, en: id, ar: id } })),
    }),
  );
  for (const [chapter, files] of Object.entries(exercises)) {
    const dir = join(content, SUBJECT, chapter, "exercices");
    mkdirSync(dir, { recursive: true });
    for (const file of files) writeFileSync(join(dir, file), "{}");
  }
  return content;
}

const REPO_ROOT = join(import.meta.dirname, "../../../..");

/**
 * Lance le VRAI point d'entrée, comme `npm run content:gisement:<commande>` : c'est le seul
 * test qui voit un import cassé sous `--experimental-strip-types` (un type importé sans `type`
 * passe Vitest et tue le CLI au premier lancement).
 */
export function runGisement(
  command: "lignes" | "plan" | "controle",
  args: string[],
  cwd: string,
): { code: number | null; stdout: string; stderr: string } {
  const r = spawnSync(
    process.execPath,
    [
      "--experimental-strip-types",
      join(REPO_ROOT, "scripts", "content", "gisement", `${command}.ts`),
      ...args,
    ],
    { cwd, encoding: "utf8" },
  );
  return { code: r.status, stdout: r.stdout, stderr: r.stderr };
}
