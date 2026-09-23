#!/usr/bin/env node
/**
 * `content:gates` — les SEPT étages de la Content CI, en une commande, dans
 * l'ordre de la CI (corpus privé, `.github/workflows/content-ci.yml`).
 *
 * Le CLAUDE.md du corpus les donnait comme une chaîne de huit `&&` à recopier :
 * le premier rouge arrêtait tout, donc on corrigeait, relançait, découvrait le
 * rouge suivant, relançait — et l'étage `content:catalogue` (qui exige un
 * `git diff` sur le CORPUS, pas sur le moteur) était celui qu'on oubliait.
 * Ici chaque étage tourne même après un rouge, le bilan dit tout d'un coup, et
 * la sortie est non nulle dès qu'un étage l'est — comme la CI.
 *
 * Usage (depuis le moteur, corpus branché par le lien `content`) :
 *   npm run content:gates                 # les sept étages
 *   npm run content:gates -- --tranche    # + content:tranche --changed (méthode § B2)
 *   npm run content:gates -- --quiet      # n'affiche la sortie que des étages rouges
 *
 * Avant tout, il mesure le RETARD du moteur sur `origin/main` (skill campagne
 * § 0) : un clone en retard rend un verdict qui n'engage personne, dans les deux
 * sens. Il ne fetch pas — il dit quand il ne peut pas savoir.
 */
import { spawnSync } from "node:child_process";
import { existsSync, realpathSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { argv, cwd, exit, stdout } from "node:process";

const engine = cwd();
const content = resolve(engine, "content");
const quiet = argv.includes("--quiet");

function run(cmd, args, opts = {}) {
  const t0 = Date.now();
  const r = spawnSync(cmd, args, { cwd: engine, encoding: "utf8", ...opts });
  return { ok: r.status === 0, out: `${r.stdout ?? ""}${r.stderr ?? ""}`, ms: Date.now() - t0 };
}

if (
  !existsSync(resolve(content, "misconceptions.json")) ||
  !existsSync(resolve(content, "programmes-officiels/manifest"))
) {
  stdout.write(
    "✗ corpus non branché : `content/` doit être le lien vers le `content/` du dépôt privé " +
      "(méthode, Phase 0.1). Sans lui, chaque gate ment par omission.\n",
  );
  exit(2);
}
const corpus = dirname(realpathSync(content));

const lag = run("git", ["rev-list", "--count", "HEAD..origin/main"]);
stdout.write(
  !lag.ok
    ? "• moteur : retard sur origin/main inconnu (pas de ref distante) — `git fetch origin main` pour le mesurer.\n"
    : lag.out.trim() === "0"
      ? "• moteur : à jour d'origin/main (au dernier fetch).\n"
      : `⚠ moteur : ${lag.out.trim()} commit(s) de retard sur origin/main — le verdict ci-dessous peut ` +
        "manquer une garde ou signaler ce qui est déjà réparé. `git pull` avant de conclure.\n",
);

const npm = (script) => ["npm", ["run", "-s", script]];
const stages = [
  ["content:check", ...npm("content:check")],
  ["content:catalogue", ...npm("content:catalogue")],
  ["content:qa:strict", ...npm("content:qa:strict")],
  ["content:figures:check", ...npm("content:figures:check")],
  ["content:audit:strict", ...npm("content:audit:strict")],
  ["programme:check", ...npm("programme:check")],
  ["harness:check --corpus", "node", ["scripts/harness/check.mjs", "--corpus", corpus]],
];
if (argv.includes("--tranche")) {
  stages.push([
    "content:tranche --changed",
    "node",
    ["--experimental-strip-types", "scripts/content/tranche.ts", "--changed", "--strict"],
  ]);
}

const results = [];
for (const [name, cmd, args] of stages) {
  const r = run(cmd, args);
  if (r.ok && name === "content:catalogue") {
    // Le générateur écrit à travers le lien : la fraîcheur se lit dans le CORPUS.
    const diff = spawnSync(
      "git",
      ["-C", corpus, "diff", "--exit-code", "--stat", "--", "content/CATALOGUE.md"],
      {
        encoding: "utf8",
      },
    );
    if (diff.status !== 0) {
      r.ok = false;
      r.out +=
        `${diff.stdout}\nCATALOGUE.md était périmé — il vient d'être régénéré : le committer ` +
        "avec la tranche (la CI le compare par git diff).\n";
    }
  }
  results.push({ name, ...r });
  if (!quiet || !r.ok)
    stdout.write(`\n── ${name} ${"─".repeat(Math.max(0, 60 - name.length))}\n${r.out}`);
}

stdout.write("\n══ bilan content:gates ══\n");
for (const r of results) {
  stdout.write(`  ${r.ok ? "✓" : "✗"} ${r.name.padEnd(28)} ${(r.ms / 1000).toFixed(1)} s\n`);
}
const red = results.filter((r) => !r.ok);
stdout.write(
  red.length === 0
    ? "✓ tous les étages de la Content CI sont verts — un vert de gate ne dit rien du fond : l'audit pédagogique reste à faire (méthode B3).\n"
    : `✗ ${red.length} étage(s) rouge(s) : ${red.map((r) => r.name).join(", ")}\n`,
);
exit(red.length === 0 ? 0 : 1);
