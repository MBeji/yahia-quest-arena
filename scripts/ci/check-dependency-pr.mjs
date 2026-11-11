#!/usr/bin/env node
/**
 * Garde de diff de dépendance — la seconde moitié de l'arbitrage A17.
 *
 * CE QU'ELLE REMPLACE. Jusqu'au 2026-08-13, ce dépôt tournait sur npm 11 et la
 * Content CI privée sur npm 10 : le côté strict refusait un lockfile que celui-ci
 * installait, et c'est LUI qui a attrapé #716 — « bump undici … dependency-type:
 * indirect », qui faisait en réalité passer `@cloudflare/vite-plugin` de ^1.40.2 à
 * ^1.51.1 et entrait `miniflare 5.…-alpha`, `workerd` et `wrangler` dans la chaîne
 * de build. Deux majeures et une ALPHA sous un titre de bump indirect. Aligner les
 * deux CI sur Node 24 (leur #150) a supprimé ce détecteur ; 33 h de Content CI
 * rouge, `main` comprise, pendant que le gate d'ici restait vert.
 *
 * L'arbitrage A17 (2026-08-24) a tranché en deux temps : garder Node 24 et
 *   1. rejouer le lockfile sous npm 10 à chaque PR — LIVRÉ, c'est l'étape
 *      « Canari npm 10 » du job `verify` ;
 *   2. poser la vraie garde : **refuser une PR de dépendance dont le diff dépasse
 *      ce que son titre annonce**. C'est ce fichier.
 *
 * POURQUOI LE CANARI NE SUFFIT PAS, et c'est la raison d'être de ce script. Le
 * canari juge une PROPRIÉTÉ MÉCANIQUE : ce lockfile s'installe-t-il ailleurs ? Il
 * aurait attrapé #716 par accident — parce que sa régénération était cassée — et
 * il ne dira jamais rien d'un bump parfaitement installable qui fait entrer une
 * majeure non arbitrée. La propriété perdue avec npm 10 était accidentelle ; celle
 * qu'on remet est INTENTIONNELLE : le titre d'une PR est une promesse, et le diff
 * doit la tenir.
 *
 * QUATRE RÈGLES, et une seule ne demande pas de titre.
 *
 *   A1 · aucune PRÉVERSION neuve dans le lockfile. Indépendante du titre, donc
 *        valable pour n'importe quelle PR qui touche le lock — y compris une PR
 *        humaine. C'est la règle qui aurait arrêté l'alpha de #716 quel qu'ait été
 *        son intitulé. Échappatoire assumée et VISIBLE : `[allow-prerelease]` dans
 *        le titre, qui suit le squash jusque dans `main` (une échappatoire qu'on
 *        ne lit pas dans l'historique n'en est pas une).
 *   B1 · un titre qui dit « indirect » alors que le MANIFESTE bouge. Une bump
 *        indirecte ne touche pas `package.json` — c'est sa définition. #716 exactement.
 *   B2 · une MAJEURE qui traverse sous un titre qui annonce patch/minor/indirect.
 *   B3 · un titre qui nomme un paquet, et un diff qui en bouge un AUTRE.
 *
 * CE QU'ELLE NE FAIT PAS, délibérément. Elle ne juge ni l'opportunité d'une montée,
 * ni sa sécurité (`audit:deps`), ni son installabilité (le canari). Elle ne compare
 * que deux choses déjà écrites : ce que le titre annonce, ce que le diff fait.
 *
 * AUCUN FAUX POSITIF PAR DEVINETTE. Toute plage de version qu'elle ne sait pas lire
 * (`workspace:*`, `npm:alias@…`, une URL git) est IGNORÉE plutôt qu'interprétée :
 * bloquer la file sur une lecture approximative coûterait plus que la garde ne
 * rapporte — on l'a mesuré le 2026-09-02, où quatre avis `audit:deps` tombés en
 * cours de journée ont arrêté toute la file sur une PR qui ne touchait pas aux
 * dépendances.
 *
 *   node scripts/ci/check-dependency-pr.mjs --base <ref> [--head <ref>] [--title "<titre>"]
 *
 * Les helpers purs sont exportés et testés unitairement ; `main()` fait la
 * plomberie git et ne s'exécute que si le fichier est lancé directement.
 */

import { execFileSync } from "node:child_process";
import { pathToFileURL } from "node:url";

/** Les champs de `package.json` qui déclarent une dépendance. */
const MANIFEST_FIELDS = [
  "dependencies",
  "devDependencies",
  "peerDependencies",
  "optionalDependencies",
];

/** Le marqueur qui assume une préversion, en toutes lettres, dans le titre. */
export const PRERELEASE_ESCAPE = "[allow-prerelease]";

/**
 * Le cœur numérique d'une plage : `^1.40.2` → `1.40.2`, `>=2.0.0-rc.1` → `2.0.0-rc.1`.
 *
 * Rend `null` sur tout ce qui n'est pas une version sémantique littérale — un alias
 * `npm:`, un `workspace:*`, une URL git, une plage `||` composite. C'est le point
 * où la garde choisit de se taire : une plage qu'on ne sait pas lire ne prouve rien.
 */
export function semverCore(range) {
  if (typeof range !== "string") return null;
  const trimmed = range.trim();
  // Une plage composite (`^1 || ^2`) ou un alias décrit plusieurs mondes : on ne
  // tranche pas lequel est « le » sien.
  if (trimmed.includes("||") || trimmed.includes(":")) return null;
  const m = /^[\^~>=<v\s]*(\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?)/.exec(trimmed);
  return m ? m[1] : null;
}

/** Le majeur d'une plage, ou `null` si elle n'est pas lisible. */
export function majorOf(range) {
  const core = semverCore(range);
  if (!core) return null;
  return Number.parseInt(core.split(".")[0], 10);
}

/**
 * Cette version porte-t-elle une préversion ?
 *
 * Le tiret DOIT suivre le cœur `x.y.z` : `5.20260801.1-alpha` en porte une,
 * `4.0.0` non. Les numéros datés de Cloudflare (`5.20260801.1`) sont exactement le
 * cas où une lecture naïve du tiret se serait trompée si le champ en contenait un.
 */
export function isPrerelease(version) {
  const core = semverCore(version);
  return core !== null && core.includes("-");
}

/** `{ nom: plage }` pour tous les champs de dépendance d'un `package.json`. */
export function manifestRanges(manifestText) {
  let parsed;
  try {
    parsed = JSON.parse(manifestText);
  } catch {
    return null; // shape illisible → signalée par l'appelant, jamais devinée
  }
  const out = {};
  for (const field of MANIFEST_FIELDS) {
    const block = parsed?.[field];
    if (!block || typeof block !== "object") continue;
    for (const [name, range] of Object.entries(block)) out[name] = range;
  }
  return out;
}

/**
 * Les dépendances du manifeste qui ont bougé entre deux états.
 *
 * Une dépendance AJOUTÉE compte comme un mouvement (`from: null`) : #716 aurait pu
 * tout aussi bien introduire son alpha en nouvelle entrée.
 */
export function changedManifestDeps(baseRanges, headRanges) {
  const moved = [];
  for (const [name, to] of Object.entries(headRanges)) {
    const from = Object.hasOwn(baseRanges, name) ? baseRanges[name] : null;
    if (from !== to) moved.push({ name, from, to });
  }
  for (const name of Object.keys(baseRanges)) {
    if (!Object.hasOwn(headRanges, name)) moved.push({ name, from: baseRanges[name], to: null });
  }
  return moved.sort((a, b) => a.name.localeCompare(b.name));
}

/** `{ chemin: version }` des paquets d'un `package-lock.json` (lockfileVersion ≥ 2). */
export function lockVersions(lockText) {
  let parsed;
  try {
    parsed = JSON.parse(lockText);
  } catch {
    return null;
  }
  // `packages` est la forme depuis lockfileVersion 2. Son absence n'est PAS un
  // « rien à voir » : c'est une forme qu'on ne sait pas lire, et une garde qui
  // passe en silence sur ce qu'elle ne comprend pas est une garde qu'on cesse de
  // lire (leçon L-2). L'appelant en fait une erreur, pas un succès.
  if (!parsed?.packages || typeof parsed.packages !== "object") return null;
  const out = {};
  for (const [path, entry] of Object.entries(parsed.packages)) {
    if (entry && typeof entry.version === "string") out[path] = entry.version;
  }
  return out;
}

/**
 * Les préversions qui n'étaient pas là avant.
 *
 * Comparé PAR VERSION et pas par chemin : un paquet déjà en alpha qui reste en
 * alpha ne se re-signale pas à chaque PR — sinon la garde crierait en continu et
 * finirait ignorée. Ce qui compte, c'est la préversion qui ENTRE.
 */
export function newPrereleases(baseVersions, headVersions) {
  const known = new Set(Object.values(baseVersions).filter(isPrerelease));
  const found = new Map();
  for (const [path, version] of Object.entries(headVersions)) {
    if (!isPrerelease(version) || known.has(version)) continue;
    if (!found.has(version)) found.set(version, path);
  }
  return Array.from(found, ([version, path]) => ({ version, path })).sort((a, b) =>
    a.version.localeCompare(b.version),
  );
}

/**
 * Ce que le titre d'une PR de dépendance ANNONCE.
 *
 * Les titres de Dependabot ont une forme stable — « bump <paquet> from <a> to <b> » —
 * et le type de mise à jour voyage dans le corps ou dans les libellés. On lit ce
 * qu'on trouve, sans exiger la forme : un titre non reconnu rend `{package: null,
 * scope: null}`, et les règles B se taisent alors toutes. Une garde qui exigerait
 * un format de titre bloquerait les PR humaines, qui n'en ont aucun.
 */
export function parseDependencyTitle(title) {
  const text = typeof title === "string" ? title : "";
  const bump = /\bbump\s+(@?[\w.-]+(?:\/[\w.-]+)?)\s+from\s+\S+\s+to\s+\S+/i.exec(text);
  const indirect = /dependency-type:\s*indirect|\bindirect\b/i.test(text);
  const major = /semver-major|\bmajor\b/i.test(text);
  const minorOrPatch = /semver-(?:minor|patch)|\b(?:minor|patch)\b/i.test(text);
  return {
    package: bump ? bump[1] : null,
    /** Ce que le titre promet sur l'ampleur : 'indirect' | 'major' | 'small' | null. */
    scope: indirect ? "indirect" : major ? "major" : minorOrPatch ? "small" : null,
    allowsPrerelease: text.toLowerCase().includes(PRERELEASE_ESCAPE),
  };
}

/**
 * Confronter le titre au diff. Rend la liste des écarts, vide si tout concorde.
 *
 * Chaque écart porte sa RÈGLE et sa phrase : un message qui dit seulement « échec »
 * envoie son lecteur relire un diff qu'il vient déjà de lire.
 */
export function findMismatches({ title, movedDeps, prereleases }) {
  const announced = parseDependencyTitle(title);
  const findings = [];

  if (prereleases.length > 0 && !announced.allowsPrerelease) {
    for (const { version, path } of prereleases) {
      findings.push({
        rule: "A1",
        message:
          `préversion entrée dans le lockfile : ${version} (${path}). ` +
          `Une alpha dans la chaîne de build est ce que #716 a fait passer sous un titre ` +
          `de bump indirect. Si elle est voulue, l'assumer dans le titre avec ` +
          `« ${PRERELEASE_ESCAPE} » ; sinon, ne pas re-synchroniser le lock à l'aveugle.`,
      });
    }
  }

  // Les règles B n'ont d'objet que si le titre annonce quelque chose ET que le
  // manifeste a bougé : un lock qui bouge seul est le régime NORMAL d'une bump
  // indirecte, et c'est très bien.
  if (movedDeps.length === 0) return findings;

  if (announced.scope === "indirect") {
    findings.push({
      rule: "B1",
      message:
        `le titre annonce une mise à jour « indirect », mais package.json bouge : ` +
        `${movedDeps.map((d) => d.name).join(", ")}. Une bump indirecte ne touche pas le ` +
        `manifeste — c'est sa définition. C'est exactement #716.`,
    });
  }

  if (announced.scope === "indirect" || announced.scope === "small") {
    for (const dep of movedDeps) {
      const from = majorOf(dep.from);
      const to = majorOf(dep.to);
      if (from === null || to === null || from === to) continue;
      findings.push({
        rule: "B2",
        message:
          `${dep.name} traverse une MAJEURE (${dep.from} → ${dep.to}) sous un titre qui ` +
          `annonce « ${announced.scope === "indirect" ? "indirect" : "patch/minor"} ». ` +
          `Une majeure se livre en PR isolée, avec sa lecture de changelog.`,
      });
    }
  }

  if (announced.package) {
    const others = movedDeps.filter((d) => d.name !== announced.package);
    if (others.length > 0) {
      findings.push({
        rule: "B3",
        message:
          `le titre nomme « ${announced.package} », mais package.json bouge ` +
          `${others.map((d) => d.name).join(", ")}. Le titre suit le squash jusque dans ` +
          `main : il doit décrire ce qui entre.`,
      });
    }
  }

  return findings;
}

/** Le contenu d'un fichier à une révision, ou `null` s'il n'y est pas. */
function showFile(ref, path) {
  try {
    return execFileSync("git", ["show", `${ref}:${path}`], {
      encoding: "utf8",
      maxBuffer: 64 * 1024 * 1024,
    });
  } catch {
    return null;
  }
}

function argOf(flag, fallback = null) {
  const i = process.argv.indexOf(flag);
  return i !== -1 && process.argv[i + 1] ? process.argv[i + 1] : fallback;
}

function main() {
  const base = argOf("--base");
  const head = argOf("--head", "HEAD");
  const title = argOf("--title", "");

  if (!base) {
    console.error("usage: check-dependency-pr.mjs --base <ref> [--head <ref>] [--title <titre>]");
    process.exit(2);
  }

  const baseManifest = showFile(base, "package.json");
  const headManifest = showFile(head, "package.json");
  const baseLock = showFile(base, "package-lock.json");
  const headLock = showFile(head, "package-lock.json");

  if (!baseManifest || !headManifest) {
    console.error(`[dependency-pr] package.json introuvable sur ${base} ou ${head}.`);
    process.exit(2);
  }

  const baseRanges = manifestRanges(baseManifest);
  const headRanges = manifestRanges(headManifest);
  if (!baseRanges || !headRanges) {
    console.error("[dependency-pr] package.json illisible (JSON invalide).");
    process.exit(2);
  }

  const movedDeps = changedManifestDeps(baseRanges, headRanges);

  let prereleases = [];
  if (baseLock && headLock) {
    const baseVersions = lockVersions(baseLock);
    const headVersions = lockVersions(headLock);
    if (!baseVersions || !headVersions) {
      // Forme inconnue : on le DIT. Passer en silence sur ce qu'on ne sait pas
      // lire est le mécanisme même qui rend une garde inutile.
      console.error(
        "[dependency-pr] package-lock.json sans bloc `packages` — forme non reconnue " +
          "(lockfileVersion < 2 ?). La règle A1 ne peut pas s'appliquer : corriger ce " +
          "script avant de la croire verte.",
      );
      process.exit(2);
    }
    prereleases = newPrereleases(baseVersions, headVersions);
  }

  if (movedDeps.length === 0 && prereleases.length === 0) {
    console.log("[dependency-pr] OK — aucune dépendance déplacée, aucune préversion entrante.");
    return;
  }

  const findings = findMismatches({ title, movedDeps, prereleases });

  console.log(
    `[dependency-pr] ${movedDeps.length} dépendance(s) déplacée(s) dans package.json` +
      (movedDeps.length > 0
        ? ` : ${movedDeps.map((d) => `${d.name} ${d.from ?? "∅"} → ${d.to ?? "∅"}`).join(", ")}`
        : "") +
      ` · ${prereleases.length} préversion(s) entrante(s).`,
  );

  if (findings.length === 0) {
    console.log("[dependency-pr] OK — le diff ne dépasse pas ce que le titre annonce.");
    return;
  }

  for (const f of findings) {
    console.error(`::error title=Diff de dépendance (${f.rule})::${f.message}`);
  }
  console.error(
    `[dependency-pr] ${findings.length} écart(s) entre le titre et le diff — voir ` +
      "docs/dependency-maintenance.md § Le piège des deux npm.",
  );
  process.exit(1);
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}
