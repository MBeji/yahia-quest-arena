/**
 * CLI for the transcription tracking registry (see src/shared/content/transcription-suivi.ts).
 *
 *   node --experimental-strip-types scripts/content/suivi.ts             # check (CI gate)
 *   node --experimental-strip-types scripts/content/suivi.ts --index     # regenerate programme/_INDEX.md
 *   node --experimental-strip-types scripts/content/suivi.ts --corpus    # regenerate suivi/corpus-cnp.json
 *                                                                        #   (needs ../cnp-officiel/catalogue.csv — local only)
 *
 * `--check` (default) validates the whole registry (schemas + invariants,
 * including anti-double-transcription) AND fails if the committed _INDEX.md
 * is out of date with the registry — so the human view can never drift again.
 */
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { resolve } from "node:path";
import {
  checkSuivi,
  corpusSchema,
  renderIndex,
  type Corpus,
  type CorpusDocument,
} from "../../src/shared/content/transcription-suivi.ts";
import {
  CORPUS_JSON,
  INDEX_PATH,
  MANIFEST_DIR,
  REPO_ROOT,
  fail,
  loadRegistryInput,
  manifestChaptersByGrade,
  manifestSubjectsByGrade,
} from "./programmes-io.ts";

const catalogueArgIdx = process.argv.indexOf("--catalogue");
const CATALOGUE_CSV =
  catalogueArgIdx >= 0 && process.argv[catalogueArgIdx + 1]
    ? resolve(process.argv[catalogueArgIdx + 1])
    : resolve(REPO_ROOT, "../cnp-officiel/catalogue.csv");

// --------------------------------------------------------------------------
// --corpus: catalogue.csv → suivi/corpus-cnp.json
// --------------------------------------------------------------------------

/** Minimal CSV line parser (the catalogue quotes only the title field). */
function parseCsvLine(line: string): string[] {
  const fields: string[] = [];
  let current = "";
  let inQuotes = false;
  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (inQuotes) {
      if (ch === '"' && line[i + 1] === '"') {
        current += '"';
        i++;
      } else if (ch === '"') {
        inQuotes = false;
      } else {
        current += ch;
      }
    } else if (ch === '"') {
      inQuotes = true;
    } else if (ch === ",") {
      fields.push(current);
      current = "";
    } else {
      current += ch;
    }
  }
  fields.push(current);
  return fields;
}

function buildCorpus(): Corpus {
  if (!existsSync(CATALOGUE_CSV)) {
    fail(
      `catalogue introuvable: ${CATALOGUE_CSV}\n` +
        "  --corpus se lance depuis une machine qui a le corpus local (cnp-officiel/, dossier frère du repo).",
    );
  }
  const lines = readFileSync(CATALOGUE_CSV, "utf8").trim().split(/\r?\n/).slice(1);
  const documents: CorpusDocument[] = lines.map((line) => {
    const [cycle, , type, code, titre, fichier, octets] = parseCsvLine(line);
    const tome = /P\d{2}(?=\.pdf$)/.exec(fichier)?.[0];
    if (!tome) fail(`fichier sans suffixe de tome PXX: "${fichier}"`);
    return {
      code,
      tome,
      cycle: cycle === "1" ? ("base" as const) : ("secondaire" as const),
      role: type === "eleve" ? ("eleve" as const) : ("enseignant" as const),
      classe: Number(code[3]),
      matiere: code.slice(1, 3),
      titre,
      fichier,
      octets: Number(octets),
    };
  });
  documents.sort((a, b) => a.code.localeCompare(b.code) || a.tome.localeCompare(b.tome));
  return corpusSchema.parse({
    generatedFrom: "cnp-officiel/catalogue.csv",
    count: documents.length,
    documents,
  });
}

// --------------------------------------------------------------------------
// Main
// --------------------------------------------------------------------------

const args = new Set(process.argv.slice(2));

if (args.has("--corpus")) {
  const corpus = buildCorpus();
  writeFileSync(CORPUS_JSON, `${JSON.stringify(corpus, null, 2)}\n`, "utf8");
  console.log(`✓ suivi/corpus-cnp.json régénéré (${corpus.count} PDF)`);
  process.exit(0);
}

const input = {
  ...loadRegistryInput(),
  manifestSubjectsByGrade: manifestSubjectsByGrade(MANIFEST_DIR),
  manifestChaptersByGrade: manifestChaptersByGrade(MANIFEST_DIR),
};

if (args.has("--index")) {
  writeFileSync(INDEX_PATH, renderIndex(input), "utf8");
  console.log(
    `✓ programme/_INDEX.md régénéré (${input.suivis.reduce((n, s) => n + s.fiches.length, 0)} fiches)`,
  );
  process.exit(0);
}

// Default: --check.
const { errors, warnings } = checkSuivi(input);
for (const warning of warnings) console.warn(`⚠ ${warning}`);
for (const error of errors) console.error(`✖ ${error}`);

const expectedIndex = renderIndex(input);
const actualIndex = existsSync(INDEX_PATH) ? readFileSync(INDEX_PATH, "utf8") : "";
if (expectedIndex !== actualIndex) {
  console.error(
    "✖ programme/_INDEX.md n'est pas à jour avec suivi/*.json — lancer `npm run programme:index`",
  );
  errors.push("index désynchronisé");
}

if (errors.length > 0) {
  console.error(`\n✖ programme:check — ${errors.length} erreur(s), ${warnings.length} warning(s)`);
  process.exit(1);
}
console.log(`✓ programme:check — registre cohérent (${warnings.length} warning(s))`);
