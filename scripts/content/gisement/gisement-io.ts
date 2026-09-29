/**
 * Les entrées-sorties du gisement (étude 36) — le seul endroit qui sait OÙ les trois commandes
 * lisent : le manifeste de la classe, le registre des compétences, les dossiers `exercices/`,
 * les fichiers passés en argument.
 *
 * Tout chemin se donne en argument (`--content`, `--sources`, les fichiers) : le corpus n'est
 * pas dans ce dépôt, et une commande qui ne sait lire que `./content` ne se teste pas sans lui.
 */
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { argv, cwd, stderr } from "node:process";
import { type ParseArgsConfig, parseArgs } from "node:util";
import { loadCompetencyRegistries } from "../../../src/shared/content/loader.ts";
import { programManifestSchema } from "../../../src/shared/content/program-manifest.ts";
import { competencyScope, type LineVocabulary } from "./lignes-checks.ts";
import { maxExistingNn } from "./plan-builder.ts";

/** La commande n'a pas pu juger (argument, fichier, manifeste) : sortie 2, jamais 1. */
export class UsageError extends Error {}

/**
 * Les arguments de la commande (`process.argv` après le script) : positionnels admis, et une
 * option inconnue ou sans valeur est une erreur d'usage (code 2), pas un crash.
 */
export function parseCliArgs<T extends ParseArgsConfig["options"]>(
  options: T,
): ReturnType<typeof parseArgs<{ args: string[]; allowPositionals: true; options: T }>> {
  try {
    return parseArgs({ args: argv.slice(2), allowPositionals: true, options });
  } catch (err) {
    throw new UsageError(err instanceof Error ? err.message : String(err));
  }
}

/** `--content`, ou le lien `content/` du moteur quand la commande tourne depuis sa racine. */
export const contentDirOf = (flag: string | undefined): string => resolve(cwd(), flag ?? "content");

export const manifestPath = (contentDir: string, grade: string): string =>
  join(contentDir, "programmes-officiels", "manifest", `${grade}.json`);

/** Les slugs du sujet au manifeste de la classe, dans l'ordre d'enseignement. */
export function loadSubjectChapters(contentDir: string, grade: string, subject: string): string[] {
  const path = manifestPath(contentDir, grade);
  if (!existsSync(path)) {
    throw new UsageError(
      `manifeste introuvable : ${path} — le corpus est-il branché (lien content/ ou --content) ?`,
    );
  }
  const parsed = programManifestSchema.safeParse(JSON.parse(readFileSync(path, "utf8")));
  if (!parsed.success) throw new UsageError(`manifeste invalide : ${path}`);
  if (parsed.data.grade !== grade) {
    throw new UsageError(`${path} déclare la classe « ${parsed.data.grade} », pas « ${grade} »`);
  }
  const entry = parsed.data.subjects.find((s) => s.id === subject);
  if (!entry) {
    throw new UsageError(
      `le manifeste ${grade} ne liste pas le sujet « ${subject} » ` +
        `(sujets : ${parsed.data.subjects.map((s) => s.id).join(", ")})`,
    );
  }
  if (entry.chapters.length === 0) {
    throw new UsageError(
      `le manifeste ${grade} ne liste aucun chapitre pour « ${subject} » : sans l'ordre ` +
        "d'enseignement, rien ne se juge ni ne se place — transcrire le programme d'abord",
    );
  }
  return entry.chapters.map((c) => c.slug);
}

/** Le vocabulaire fermé d'une ligne : chapitres du manifeste, compétences du registre. */
export function loadVocabulary(
  contentDir: string,
  grade: string,
  subject: string,
): { vocab: LineVocabulary; families: string[] } {
  const chapters = loadSubjectChapters(contentDir, grade, subject);
  const scope = competencyScope(loadCompetencyRegistries(contentDir), subject);
  return {
    vocab: { chapters, competencies: scope?.ids ?? null },
    families: scope?.families ?? [],
  };
}

/** Le contexte de jugement, imprimé même quand il est vide : un gate muet ne se voit pas. */
export function describeVocabulary(
  grade: string,
  subject: string,
  { vocab, families }: { vocab: LineVocabulary; families: string[] },
): string {
  const registry =
    vocab.competencies === null
      ? `aucun registre de compétences ne couvre « ${subject} » : la colonne vaut -`
      : `registre ${families.join(" + ")} (${vocab.competencies.size} compétence(s))`;
  return `${subject} · ${grade} : ${vocab.chapters.length} chapitre(s) au manifeste ; ${registry}`;
}

export function readTextFiles(paths: readonly string[]): Array<{ file: string; text: string }> {
  return paths.map((file) => {
    if (!existsSync(file)) throw new UsageError(`fichier introuvable : ${file}`);
    return { file, text: readFileSync(file, "utf8") };
  });
}

/** Par chapitre, le plus grand `NN` de `<content>/<sujet>/<chapitre>/exercices/NN-*.json`. */
export function existingNnByChapter(
  contentDir: string,
  subject: string,
  chapters: readonly string[],
): Map<string, number> {
  return new Map(
    chapters.map((chapter) => {
      const dir = join(contentDir, subject, chapter, "exercices");
      return [chapter, existsSync(dir) ? maxExistingNn(readdirSync(dir)) : 0];
    }),
  );
}

/** Les `.txt` d'un dossier, récursivement, en ordre stable. */
export function listTxtFiles(dir: string): string[] {
  if (!existsSync(dir)) throw new UsageError(`dossier de sources introuvable : ${dir}`);
  const out: string[] = [];
  const walk = (d: string): void => {
    for (const entry of readdirSync(d, { withFileTypes: true })) {
      const path = join(d, entry.name);
      if (entry.isDirectory()) walk(path);
      else if (entry.name.endsWith(".txt")) out.push(path);
    }
  };
  walk(dir);
  return out.sort();
}

/**
 * Lance une commande : son code de retour (0 net, 1 constat) devient le code de sortie ; une
 * erreur devient `✖ message` et le code 2. `exitCode` plutôt que `exit()` : une sortie longue
 * vers un tube n'est pas tronquée.
 */
export function runCli(usage: string, main: () => number): void {
  try {
    process.exitCode = main();
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    stderr.write(`✖ ${message}\n${err instanceof UsageError ? `${usage}\n` : ""}`);
    process.exitCode = 2;
  }
}
