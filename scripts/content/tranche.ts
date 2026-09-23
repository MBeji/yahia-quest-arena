/**
 * `content:tranche` — les mesures de tranche AVANT le commit (méthode § B2).
 *
 * Usage (depuis le moteur, corpus branché) :
 *   npm run content:tranche -- --subject <id> [--chapters 04,05,06] [--json] [--strict]
 *   npm run content:tranche -- --changed [--base origin/main] [--fresh] [--json] [--strict]
 *
 * `--chapters` désigne la tranche par préfixe numérique ou par slug ; sans lui,
 * toute la matière est la tranche. `--changed` la déduit du diff du corpus
 * contre `--base` (défaut `origin/main`) + les fichiers non suivis : c'est la
 * tranche que la session s'apprête à committer, matière par matière.
 * Les autres chapitres de la matière sont les chapitres PUBLIÉS, contre
 * lesquels les paires et les gabarits se croisent.
 *
 * `--fresh` ne mesure que les questions NOUVELLES ou MODIFIÉES par rapport à la
 * base (la matière est relue telle qu'elle est dans `--base`, par `git archive`) :
 * c'est le cliquet de la Content CI — la dette publiée ne rend personne rouge,
 * une question neuve ne peut plus en ajouter.
 *
 * `--strict` sort en 1 quand la clé fuit par sa longueur ou qu'une paire est
 * proche ; `--strict-longest` seulement dans le premier cas (la CI : une paire
 * d'exercices parallèles voulue se justifie au rapport, pas dans un gate). Les
 * candidats gabarit ne font jamais échouer : ils nourrissent le mandat de
 * l'auditeur (méthode B3, point 2).
 */
import { execFileSync } from "node:child_process";
import { existsSync, mkdtempSync, realpathSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { argv, cwd, exit, stdout } from "node:process";
import { loadSubject } from "../../src/shared/content/loader.ts";
import type { LoadedSubject } from "../../src/shared/content/schema.ts";
import { collectItems, freshRefs, measureTranche, type TrancheReport } from "./tranche-checks.ts";

const hasFlag = (n: string) => argv.includes(`--${n}`);
const getFlag = (n: string) => {
  const i = argv.indexOf(`--${n}`);
  return i !== -1 ? argv[i + 1] : undefined;
};

const MAX_LISTED = 12;
const pct = (x: number) => `${Math.round(x * 100)} %`;

/** Le dépôt git du corpus (le lien `content` y mène). */
const corpusRepo = (contentDir: string) => dirname(realpathSync(contentDir));

/**
 * La matière telle qu'elle est dans `base`, ou null si elle n'y existe pas
 * (ou n'y est pas lisible) — alors tout est neuf, ce qui est la réponse juste.
 */
function loadBaseSubject(contentDir: string, base: string, id: string): LoadedSubject | null {
  const dir = mkdtempSync(join(tmpdir(), "tranche-base-"));
  try {
    const archive = execFileSync(
      "git",
      ["-C", corpusRepo(contentDir), "archive", base, "--", `content/${id}`],
      { stdio: ["ignore", "pipe", "ignore"], maxBuffer: 512 * 1024 * 1024 },
    );
    execFileSync("tar", ["-x", "-C", dir], { input: archive });
    return loadSubject(join(dir, "content", id));
  } catch {
    return null;
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
}

function mergeBase(contentDir: string, base: string): string {
  try {
    return execFileSync("git", ["-C", corpusRepo(contentDir), "merge-base", base, "HEAD"], {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch {
    return base;
  }
}

/** Chapitres touchés par matière, d'après le git du corpus. */
function changedChapters(contentDir: string, base: string): Map<string, Set<string>> {
  const repo = corpusRepo(contentDir);
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
    `\n■ ${r.subject} — tranche : ${r.tranche.join(", ")} (${r.items} question(s)` +
      `${hasFlag("fresh") ? ` nouvelle(s) ou modifiée(s) contre ${getFlag("base") ?? "origin/main"}` : ""})`,
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
  const base = getFlag("base") ?? "origin/main";
  // La matière de référence se lit au POINT DE DÉPART de la branche, pas à la
  // pointe de la base : ce que `main` a changé depuis n'est pas le travail de
  // cette branche, et le compter « neuf » jugerait la tranche d'un autre.
  const forkPoint = hasFlag("fresh") ? mergeBase(contentDir, base) : base;
  let targets: Map<string, Set<string> | undefined>;
  if (hasFlag("changed")) {
    const changed = changedChapters(contentDir, base);
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
    const baseSubject = hasFlag("fresh") ? loadBaseSubject(contentDir, forkPoint, id) : undefined;
    const fresh =
      baseSubject === undefined
        ? undefined
        : freshRefs(
            collectItems(subject, tranche),
            baseSubject && collectItems(baseSubject, new Set()),
          );
    reports.push(measureTranche(subject, tranche, fresh));
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
  if (hasFlag("strict-longest") && reports.some((r) => !r.longestKey.ok)) exit(1);
}

main();
