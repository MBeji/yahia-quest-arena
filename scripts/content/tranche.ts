/**
 * `content:tranche` — les mesures de tranche AVANT le commit (méthode § B2).
 *
 * Usage (depuis le moteur, corpus branché) :
 *   npm run content:tranche -- --subject <id> [--chapters 04,05,06] [--json] [--strict]
 *   npm run content:tranche -- --changed [--base origin/main] [--json] [--strict]
 *
 * `--chapters` désigne la tranche par préfixe numérique ou par slug ; sans lui,
 * toute la matière est la tranche. `--changed` la déduit du diff du corpus
 * contre `--base` (défaut `origin/main`) + les fichiers non suivis : c'est la
 * tranche que la session s'apprête à committer, matière par matière.
 * Les autres chapitres de la matière sont les chapitres PUBLIÉS, contre
 * lesquels les paires et les gabarits se croisent.
 *
 * `--strict` sort en 1 quand une des trois mesures de la méthode échoue ; les
 * candidats gabarit ne font jamais échouer : ils nourrissent le mandat de
 * l'auditeur (méthode B3, point 2).
 */
import { execFileSync } from "node:child_process";
import { existsSync, realpathSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { argv, cwd, exit, stdout } from "node:process";
import { loadSubject } from "../../src/shared/content/loader.ts";
import { measureTranche, type TrancheReport } from "./tranche-checks.ts";

const hasFlag = (n: string) => argv.includes(`--${n}`);
const getFlag = (n: string) => {
  const i = argv.indexOf(`--${n}`);
  return i !== -1 ? argv[i + 1] : undefined;
};

const MAX_LISTED = 12;
const pct = (x: number) => `${Math.round(x * 100)} %`;

/** Chapitres touchés par matière, d'après le git du corpus (le lien `content` y mène). */
function changedChapters(contentDir: string, base: string): Map<string, Set<string>> {
  const repo = dirname(realpathSync(contentDir));
  const git = (...args: string[]) =>
    execFileSync("git", ["-C", repo, ...args], { encoding: "utf8" })
      .split("\n")
      .filter(Boolean);
  const paths = [
    ...git("diff", "--name-only", `${base}...HEAD`, "--", "content"),
    ...git("diff", "--name-only", "HEAD", "--", "content"),
    ...git("ls-files", "--others", "--exclude-standard", "--", "content"),
  ];
  const out = new Map<string, Set<string>>();
  for (const p of paths) {
    const [, subject, chapter] = p.split("/");
    if (!subject || !chapter || !existsSync(join(contentDir, subject, chapter, "chapter.json")))
      continue;
    out.set(subject, (out.get(subject) ?? new Set()).add(chapter));
  }
  return out;
}

function resolveChapters(slugs: string[], wanted: string | undefined): Set<string> {
  if (!wanted) return new Set(slugs);
  const picked = new Set<string>();
  for (const w of wanted
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean)) {
    const hit = slugs.filter((s) => s === w || s.startsWith(`${w}-`));
    if (hit.length === 0) throw new Error(`--chapters : aucun chapitre « ${w} »`);
    hit.forEach((h) => picked.add(h));
  }
  return picked;
}

function list(refs: string[]): string {
  const shown = refs.slice(0, MAX_LISTED).join(", ");
  return refs.length > MAX_LISTED ? `${shown}, … (+${refs.length - MAX_LISTED})` : shown;
}

function render(r: TrancheReport): string {
  const mark = (ok: boolean) => (ok ? "✓" : "⚠");
  const lines = [
    `\n■ ${r.subject} — tranche : ${r.tranche.join(", ")} (${r.items} question(s))`,
    `  ${mark(r.longestKey.ok)} clé strictement la plus longue : ${r.longestKey.longest.length}/` +
      `${r.longestKey.measured} = ${pct(r.longestKey.rate)} (hasard ${pct(r.longestKey.chance)}, viser 0)`,
  ];
  if (r.longestKey.longest.length) lines.push(`      ${list(r.longestKey.longest)}`);
  const kd = r.keyDistribution;
  lines.push(
    `  ${mark(kd.ok)} positions de clé (4 options, n=${kd.measured}) : ` +
      kd.counts.map((c, i) => `${"abcd"[i]} ${c}`).join(" · ") +
      (kd.measured ? ` — ${kd.counts.map((c) => pct(c / kd.measured)).join(" / ")}` : ""),
  );
  lines.push(
    `  ${mark(r.nearPairs.length === 0)} paires proches (Jaccard ≥ 0,45) : ${r.nearPairs.length}`,
  );
  for (const p of r.nearPairs.slice(0, MAX_LISTED)) {
    lines.push(
      `      ${p.score.toFixed(2)}  ${p.a} ↔ ${p.b}${p.interChapter ? "  [inter-chapitres]" : ""}`,
    );
  }
  lines.push(
    `  · candidats gabarit (même cadre de tâche, ≥ 2 chapitres) : ${r.templates.length} groupe(s) — à trancher par l'auditeur`,
  );
  for (const t of r.templates.slice(0, MAX_LISTED)) {
    lines.push(`      ×${t.refs.length} « ${t.frame} »`, `         ${list(t.refs)}`);
  }
  return lines.join("\n");
}

function main(): void {
  const contentDir = resolve(cwd(), "content");
  let targets: Map<string, Set<string> | undefined>;
  if (hasFlag("changed")) {
    const changed = changedChapters(contentDir, getFlag("base") ?? "origin/main");
    targets = new Map([...changed].map(([s, c]) => [s, c]));
    if (targets.size === 0) {
      stdout.write("content:tranche — aucun chapitre touché contre la base : rien à mesurer.\n");
      return;
    }
  } else {
    const subject = getFlag("subject");
    if (!subject) {
      stdout.write("usage : content:tranche -- --subject <id> [--chapters 04,05] | --changed\n");
      exit(2);
    }
    targets = new Map([[subject, undefined]]);
  }

  const reports: TrancheReport[] = [];
  for (const [id, chapters] of targets) {
    const subject = loadSubject(join(contentDir, id));
    const slugs = subject.chapters.map((c) => c.slug);
    const tranche = chapters ?? resolveChapters(slugs, getFlag("chapters"));
    reports.push(measureTranche(subject, tranche));
  }

  stdout.write(
    hasFlag("json")
      ? `${JSON.stringify(reports, null, 2)}\n`
      : `${reports.map(render).join("\n")}\n`,
  );
  const failed = reports.filter((r) => !r.ok);
  if (!hasFlag("json")) {
    stdout.write(
      failed.length === 0
        ? "\n✓ content:tranche — les trois mesures de la méthode passent.\n"
        : `\n⚠ content:tranche — ${failed.length} matière(s) à reprendre avant le commit : ` +
            "raccourcir la clé ou étoffer un distracteur (la clé ne bouge pas) ; réécrire la paire proche, " +
            "ou la justifier au rapport si c'est un exercice parallèle voulu (même savoir-faire, autres données).\n",
    );
  }
  if (hasFlag("strict") && failed.length > 0) exit(1);
}

main();
