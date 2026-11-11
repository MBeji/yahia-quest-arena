/**
 * `content:gisement:controle` — le contrôle local contre les snapshots (étude 36, étage G6).
 *
 * Usage (depuis le moteur ; les snapshots vivent hors git, dans le dossier de la session) :
 *   npm run content:gisement:controle -- --sources <dossier> <cible.json|cible.md|lignes.tsv> …
 *
 * Les transcriptions sont les `.txt` du dossier, récursivement. Une cible JSON (exercice, quiz)
 * se contrôle question par question ; un `.md` (cours, fiche du couple) en entier ; un `.tsv` de
 * lignes du lecteur ligne par ligne, sur sa prose. Mesures : `controle-checks.ts`.
 *
 * Sortie : des COMPTES et nos identifiants (`fichier#q3`, `lignes.tsv:12`), jamais un fragment
 * de la source. Code 1 si un texte partage une plage ≥ 8 mots ou ≥ 3 données avec un même
 * exercice source ; 2 si la commande n'a pas pu contrôler (aucune transcription, cible illisible).
 */
import { readFileSync } from "node:fs";
import { extname, relative } from "node:path";
import { stdout } from "node:process";
import {
  buildControleIndex,
  type ControleRow,
  type ControleTarget,
  controleText,
  isFlagged,
  isWatched,
  lineTargets,
  questionTargets,
  SHARED_DATA_LIMIT,
} from "./controle-checks.ts";
import { listTxtFiles, parseCliArgs, runCli, UsageError } from "./gisement-io.ts";

const USAGE =
  "usage : content:gisement:controle -- --sources <dossier> <cible.json|cible.md|lignes.tsv> …";

function targetsOf(path: string): ControleTarget[] {
  const text = readFileSync(path, "utf8");
  switch (extname(path)) {
    case ".json": {
      let data: unknown;
      try {
        data = JSON.parse(text);
      } catch (err) {
        throw new UsageError(
          `${path} : JSON illisible (${err instanceof Error ? err.message : String(err)})`,
        );
      }
      const targets = questionTargets(data, path);
      if (targets === null) throw new UsageError(`${path} : pas de tableau questions[]`);
      return targets;
    }
    case ".md":
      return [{ where: path, text }];
    case ".tsv":
      return lineTargets(text, path);
    default:
      throw new UsageError(`${path} : cible non prise en charge (.json, .md ou .tsv)`);
  }
}

const describe = (r: ControleRow): string =>
  `plages ≥ 8 mots : ${r.v8}${r.v8 > 0 ? ` (la plus longue : ${r.longest} mots)` : ""}, ` +
  `plages ≥ 6 mots : ${r.v6}, données communes : ${r.shared}`;

runCli(USAGE, () => {
  const { values, positionals } = parseCliArgs({ sources: { type: "string" } });
  if (!values.sources || positionals.length === 0) {
    throw new UsageError("il faut --sources et au moins une cible");
  }
  const sourcesDir = values.sources;
  const files = listTxtFiles(sourcesDir);
  if (files.length === 0) {
    throw new UsageError(
      `aucune transcription .txt sous ${sourcesDir} — un contrôle sans source ne prouve rien`,
    );
  }
  const index = buildControleIndex(
    files.map((p) => ({ slug: relative(sourcesDir, p), text: readFileSync(p, "utf8") })),
  );
  const rows = positionals.flatMap(targetsOf).map((t) => controleText(t, index));

  const flagged = rows.filter(isFlagged);
  const watched = rows.filter(isWatched);
  const out = [
    `content:gisement:controle — sources : ${files.length} transcription(s), ` +
      `${index.exercises.length} exercice(s) à données ; index 8 mots : ${index.v8.grams.size} séquence(s).`,
    `  ${rows.length} texte(s) contrôlé(s) — plage ≥ 8 mots : ${rows.filter((r) => r.v8 > 0).length} ; ` +
      `≥ 6 mots (indicatif) : ${rows.filter((r) => r.v6 > 0).length} ; ` +
      `≥ ${SHARED_DATA_LIMIT} données communes avec un même exercice : ${rows.filter((r) => r.shared >= SHARED_DATA_LIMIT).length} ; ` +
      `${SHARED_DATA_LIMIT - 1} données : ${rows.filter((r) => r.shared === SHARED_DATA_LIMIT - 1).length}.`,
    ...flagged.map((r) => `  ✗ ${r.where} — ${describe(r)}`),
    ...watched.map((r) => `  · ${r.where} — ${describe(r)} (à regarder)`),
    flagged.length === 0
      ? "✓ aucune plage ≥ 8 mots, aucun exercice source dont on reprenne trois données."
      : `✗ ${flagged.length} texte(s) à réécrire : une expression ou des données de la source y passent.`,
  ];
  stdout.write(`${out.join("\n")}\n`);
  return flagged.length > 0 ? 1 : 0;
});
