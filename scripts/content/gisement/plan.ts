/**
 * `content:gisement:plan` — le plan d'écriture (étude 36, étage G4).
 *
 * Usage (depuis le moteur, corpus branché par le lien `content/`) :
 *   npm run content:gisement:plan -- <lignes.tsv> [autres.tsv…] --subject <id> --grade <classe>
 *        --content <dir> [--creneaux DC3,DC4,DS2] [--lot-max 8] [--out plan.json]
 *
 * Les lignes se jugent d'abord comme `content:gisement:lignes` : une seule fautive, et aucun
 * plan n'est écrit (code 1). Puis placement, dédoublonnage, lots d'auteur et plages de numéros
 * (`plan-builder.ts`) ; les numéros suivent le plus grand `NN` existant de
 * `<content>/<sujet>/<chapitre>/exercices/`.
 *
 * Le plan (JSON, déterministe) va dans `--out`, ou sur la sortie standard — le résumé passe
 * alors par la sortie d'erreur, pour que le JSON reste pipable. Code 2 si la commande n'a pas
 * pu planifier.
 */
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname } from "node:path";
import { stderr, stdout } from "node:process";
import {
  contentDirOf,
  describeVocabulary,
  existingNnByChapter,
  loadVocabulary,
  readTextFiles,
  parseCliArgs,
  runCli,
  UsageError,
} from "./gisement-io.ts";
import { type Creneau, CRENEAUX, isCreneau, renderFault, validateLines } from "./lignes-checks.ts";
import {
  buildPlan,
  DEFAULT_LOT_MAX,
  type GisementPlan,
  type MissionKind,
  renderPlan,
} from "./plan-builder.ts";

const USAGE =
  "usage : content:gisement:plan -- <lignes.tsv> [autres.tsv…] --subject <id> --grade <classe> " +
  "--content <dir> [--creneaux DC3,DC4,DS2] [--lot-max 8] [--out plan.json]";

function parseCreneaux(flag: string | undefined): Creneau[] | undefined {
  if (flag === undefined) return undefined;
  const values = flag
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
  const unknown = values.filter((v) => !isCreneau(v));
  if (values.length === 0 || unknown.length > 0) {
    throw new UsageError(
      `--creneaux : « ${unknown.join(", ") || flag} » hors liste (${CRENEAUX.join(", ")})`,
    );
  }
  return values.filter(isCreneau);
}

function parseLotMax(flag: string | undefined): number {
  if (flag === undefined) return DEFAULT_LOT_MAX;
  if (!/^[1-9]\d*$/.test(flag)) throw new UsageError(`--lot-max « ${flag} » : un entier ≥ 1`);
  return Number(flag);
}

function summary(plan: GisementPlan, retained: number, total: number, lotMax: number): string[] {
  const kinds = new Map<MissionKind, number>();
  for (const m of plan.missions) kinds.set(m.kind, (kinds.get(m.kind) ?? 0) + 1);
  const byKind = [...kinds].map(([k, n]) => `${n} ${k}`).join(", ") || "aucune";
  const lines = [
    `  ${retained} ligne(s) retenue(s) sur ${total} → ${plan.missions.length} mission(s) (${byKind}), ` +
      `${plan.horsProgramme.length} hors programme ; ${plan.lots.length} lot(s) de ${lotMax} missions au plus.`,
  ];
  for (const lot of plan.lots) {
    const ranges = Object.entries(lot.nnRanges)
      .map(([chapter, [from, to]]) => `${chapter} (NN ${from}–${to})`)
      .join(" + ");
    lines.push(`  ${lot.id} · ${ranges} : ${lot.missions.length} mission(s)`);
  }
  if (plan.horsProgramme.length > 0) {
    lines.push(
      `  hors programme, non placé(s) : ${plan.horsProgramme.map((h) => h.source).join(", ")}`,
    );
  }
  return lines;
}

runCli(USAGE, () => {
  const { values, positionals } = parseCliArgs({
    subject: { type: "string" },
    grade: { type: "string" },
    content: { type: "string" },
    creneaux: { type: "string" },
    "lot-max": { type: "string" },
    out: { type: "string" },
  });
  if (!values.subject || !values.grade || positionals.length === 0) {
    throw new UsageError("il faut au moins un fichier de lignes, --subject et --grade");
  }
  const creneaux = parseCreneaux(values.creneaux);
  const lotMax = parseLotMax(values["lot-max"]);
  const contentDir = contentDirOf(values.content);

  const loaded = loadVocabulary(contentDir, values.grade, values.subject);
  const { lines, faults, count } = validateLines(readTextFiles(positionals), loaded.vocab);
  const report = values.out ? stdout : stderr;
  report.write(
    `content:gisement:plan — ${describeVocabulary(values.grade, values.subject, loaded)}.\n`,
  );
  if (faults.length > 0) {
    report.write(
      `${faults.map((f) => `  ${renderFault(f)}`).join("\n")}\n` +
        `✗ ${faults.length} ligne(s) fautive(s) sur ${count} : aucun plan — content:gisement:lignes en dit autant.\n`,
    );
    return 1;
  }

  const plan = buildPlan(lines, {
    subject: values.subject,
    grade: values.grade,
    chapters: loaded.vocab.chapters,
    existingNn: existingNnByChapter(contentDir, values.subject, loaded.vocab.chapters),
    lotMax,
    creneaux,
  });
  const retained = creneaux
    ? lines.filter((l) => creneaux.includes(l.creneau)).length
    : lines.length;
  report.write(`${summary(plan, retained, lines.length, lotMax).join("\n")}\n`);

  if (values.out) {
    mkdirSync(dirname(values.out), { recursive: true });
    writeFileSync(values.out, renderPlan(plan));
    report.write(`✓ plan écrit dans ${values.out}\n`);
  } else {
    stdout.write(renderPlan(plan));
  }
  return 0;
});
