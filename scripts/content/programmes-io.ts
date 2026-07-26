/**
 * Disk I/O for the `programmes-officiels/` tree — registry + program manifests.
 *
 * The logic is pure and lives in `src/shared/content/transcription-suivi.ts`
 * and `src/shared/content/program-manifest.ts`; this module is the single place
 * that knows WHERE those files sit and how to parse them, so the three CLIs
 * that consume them (`suivi.ts`, `audit-program.ts`, `etat.ts`) cannot drift
 * apart on paths or parsing.
 *
 * Since étude 24 (2026-07-20) the tree itself lives in the PRIVATE corpus repo:
 * the loaders below therefore fail loudly — and explain why — when run from the
 * public engine without the corpus linked in (see the Content CI workflow).
 */
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { basename, join, resolve } from "node:path";
import {
  affectationsSchema,
  corpusSchema,
  suiviGradeSchema,
  type SuiviCheckInput,
  type SuiviGrade,
} from "../../src/shared/content/transcription-suivi.ts";
import {
  programManifestSchema,
  type ProgramManifest,
} from "../../src/shared/content/program-manifest.ts";
import { ContentValidationError } from "../../src/shared/content/loader.ts";

export const REPO_ROOT = resolve(import.meta.dirname, "../..");
export const PROGRAMMES_DIR = join(
  REPO_ROOT,
  ".claude/skills/content-ecole-tn/references/programmes-officiels",
);
export const SUIVI_DIR = join(PROGRAMMES_DIR, "suivi");
export const PROGRAMME_DIR = join(PROGRAMMES_DIR, "programme");
export const MANIFEST_DIR = join(PROGRAMMES_DIR, "manifest");
export const INDEX_PATH = join(PROGRAMME_DIR, "_INDEX.md");
export const CORPUS_JSON = join(SUIVI_DIR, "corpus-cnp.json");
export const AFFECTATIONS_JSON = join(SUIVI_DIR, "affectations.json");

export function fail(message: string): never {
  console.error(`\n✖ ${message}`);
  process.exit(1);
}

/**
 * Depuis la scission (étude 24, 2026-07-20), l'arbre `programmes-officiels/` vit
 * dans le repo PRIVÉ avec le corpus ; seul le moteur est resté ici. Lancer un
 * gate depuis le repo public échoue donc légitimement — mais le message ne doit
 * pas envoyer sur une fausse piste : `--corpus` recréerait un registre vide ICI,
 * à côté de la plaque. Le registre est le garde-fou anti-double-transcription,
 * mieux vaut refuser bruyamment que fabriquer un faux « rien à faire ».
 */
export function failMissingRegistry(path: string, what: string): never {
  const corpusSkillDir = join(REPO_ROOT, ".claude/skills/content-ecole-tn");
  if (!existsSync(corpusSkillDir)) {
    fail(
      `${what} introuvable: ${path}\n` +
        `  → Normal dans le repo PUBLIC : depuis l'étude 24, le registre de transcription vit\n` +
        `    dans le repo privé MBeji/yahia-quest-content, avec le corpus qu'il décrit. Ce gate\n` +
        `    y tourne (workflow « Content CI » : il checkout ce repo-ci pour le moteur et branche\n` +
        `    les données par symlink).\n` +
        `  → Ne PAS lancer --corpus ici : cela créerait un registre vide au mauvais endroit et\n` +
        `    masquerait le vrai registre.`,
    );
  }
  fail(`${what} introuvable: ${path} (lancer --corpus)`);
}

/** Corpus snapshot + affectations + per-grade suivi + fiches present on disk. */
export function loadRegistryInput(): SuiviCheckInput {
  if (!existsSync(CORPUS_JSON)) failMissingRegistry(CORPUS_JSON, "registre");
  if (!existsSync(AFFECTATIONS_JSON)) failMissingRegistry(AFFECTATIONS_JSON, "affectations");
  const corpus = corpusSchema.parse(JSON.parse(readFileSync(CORPUS_JSON, "utf8")));
  const affectations = affectationsSchema.parse(
    JSON.parse(readFileSync(AFFECTATIONS_JSON, "utf8")),
  );

  const suivis: SuiviGrade[] = readdirSync(SUIVI_DIR)
    .filter((f) => f.endsWith(".json") && f !== "corpus-cnp.json" && f !== "affectations.json")
    .sort()
    .map((f) => {
      const parsed = suiviGradeSchema.parse(JSON.parse(readFileSync(join(SUIVI_DIR, f), "utf8")));
      if (`${parsed.grade}.json` !== f) {
        fail(`suivi/${f}: le champ grade="${parsed.grade}" ne correspond pas au nom du fichier`);
      }
      return parsed;
    });

  const fichesOnDisk: string[] = [];
  for (const gradeDir of readdirSync(PROGRAMME_DIR, { withFileTypes: true })) {
    if (!gradeDir.isDirectory()) continue;
    for (const file of readdirSync(join(PROGRAMME_DIR, gradeDir.name))) {
      if (file.endsWith(".md")) fichesOnDisk.push(`${gradeDir.name}/${file.replace(/\.md$/, "")}`);
    }
  }
  return { corpus, affectations, suivis, fichesOnDisk };
}

/** Parse every `manifest/<grade>.json`, optionally narrowed to one grade. */
export function loadManifests(
  dir: string,
  onlyGrade?: string,
): Array<{ file: string; manifest: ProgramManifest }> {
  if (!existsSync(dir)) {
    throw new ContentValidationError(`Manifest directory does not exist: ${dir}`);
  }
  return readdirSync(dir)
    .filter((f) => f.endsWith(".json"))
    .sort()
    .map((f) => {
      const filePath = join(dir, f);
      let raw: unknown;
      try {
        raw = JSON.parse(readFileSync(filePath, "utf8"));
      } catch (err) {
        throw new ContentValidationError(`Invalid JSON in ${filePath}: ${(err as Error).message}`);
      }
      const parsed = programManifestSchema.safeParse(raw);
      if (!parsed.success) {
        const issues = parsed.error.issues
          .map((i) => `  • ${i.path.join(".") || "<root>"}: ${i.message}`)
          .join("\n");
        throw new ContentValidationError(`Invalid manifest ${filePath}:\n${issues}`);
      }
      return { file: basename(f), manifest: parsed.data };
    })
    .filter(({ manifest }) => !onlyGrade || manifest.grade === onlyGrade);
}

/** `{ <grade>: [subject ids] }` — what `checkSuivi` needs to verify a fiche link. */
export function manifestSubjectsByGrade(dir: string): Record<string, string[]> | undefined {
  if (!existsSync(dir)) return undefined;
  const out: Record<string, string[]> = {};
  for (const { manifest } of loadManifests(dir)) {
    out[manifest.grade] = manifest.subjects.map((s) => s.id);
  }
  return out;
}
