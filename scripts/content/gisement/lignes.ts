/**
 * `content:gisement:lignes` — juge les lignes du lecteur (étude 36, étage G2).
 *
 * Usage (depuis le moteur, corpus branché par le lien `content/`) :
 *   npm run content:gisement:lignes -- <lignes.tsv> [autres.tsv…] --subject <id> --grade <classe>
 *                                      [--content <dir>]
 *
 * Le manifeste de la classe (`<content>/programmes-officiels/manifest/<classe>.json`) donne les
 * slugs admis dans `chapitres`, dans l'ordre d'enseignement ; le registre de la famille du sujet
 * (`<content>/competences/<famille>.json`) les ids admis dans `compétences`. Format et règles :
 * `lignes-checks.ts`.
 *
 * Sortie : un compte, puis `fichier:ligne — motif` par ligne fautive. Code 1 si une ligne est
 * fautive, 2 si la commande n'a pas pu juger (argument, fichier ou manifeste manquant).
 */
import { stdout } from "node:process";
import {
  contentDirOf,
  describeVocabulary,
  loadVocabulary,
  readTextFiles,
  parseCliArgs,
  runCli,
  UsageError,
} from "./gisement-io.ts";
import { renderFault, validateLines } from "./lignes-checks.ts";

const USAGE =
  "usage : content:gisement:lignes -- <lignes.tsv> [autres.tsv…] --subject <id> --grade <classe> [--content <dir>]";

runCli(USAGE, () => {
  const { values, positionals } = parseCliArgs({
    subject: { type: "string" },
    grade: { type: "string" },
    content: { type: "string" },
  });
  if (!values.subject || !values.grade || positionals.length === 0) {
    throw new UsageError("il faut au moins un fichier de lignes, --subject et --grade");
  }

  const loaded = loadVocabulary(contentDirOf(values.content), values.grade, values.subject);
  const files = readTextFiles(positionals);
  const { lines, faults, count } = validateLines(files, loaded.vocab);

  const out = [
    `content:gisement:lignes — ${describeVocabulary(values.grade, values.subject, loaded)}.`,
    `  ${files.length} fichier(s), ${count} ligne(s) : ${lines.length} valide(s), ${faults.length} fautive(s).`,
    ...faults.map((f) => `  ${renderFault(f)}`),
    faults.length === 0
      ? "✓ lignes conformes au format fermé."
      : `✗ ${faults.length} ligne(s) à reprendre — rien ne se planifie sur une ligne fautive.`,
  ];
  stdout.write(`${out.join("\n")}\n`);
  return faults.length > 0 ? 1 : 0;
});
