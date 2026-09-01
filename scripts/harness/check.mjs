/**
 * Anti-drift gate for the AI-native harness (étude 25, "harness:check"). Guards the
 * invariants a model-agnostic harness depends on:
 *
 *   1. Pointer integrity — CLAUDE.md must stay a thin `@AGENTS.md` import, never
 *      regrow into a second copy of the canonical instructions (the exact drift
 *      étude 25 was written to kill — see its §2.4).
 *   2. AGENTS.md size budget — ≤250 lines / ≤24 KiB, under Codex's 32 KiB default
 *      truncation and the industry-observed ~200-line adherence threshold.
 *   3. No hidden Unicode (zero-width / bidi-override / tag characters) in the
 *      instruction/harness surface — the "Rules File Backdoor" class of attack
 *      (invisible instructions smuggled into a rules file a human reviews visually).
 *   4. No model identifier hardcoded outside `harness/models.json` — the one file
 *      a model bump should ever touch. Covers AGENTS.md/CLAUDE.md, `harness/**` and
 *      (since lot 5) `.github/workflows/**`, whose guards resolve their model from
 *      `models.json` at run time. GENERATED views are exempt: the id they contain is
 *      compiled from `models.json`, and invariant 6 proves it was not hand-edited.
 *   5. Every `harness/*.json` file parses as JSON.
 *   6. Every generated view matches what `harness:sync` would produce from the
 *      sources — the anti-drift guarantee that makes invariant 4's exemption safe.
 *   7. Every GitHub Action in `.github/workflows/**` is pinned to a commit SHA,
 *      never a moving tag (étude 25 lot 5b). A tag's owner decides what runs with
 *      this repo's secrets; Dependabot covers npm, this covers Actions.
 *   8. Every YAML file under `.github/**` parses STRICTLY — no duplicate mapping
 *      key, no syntax error. Delegated to `scripts/ci/check-workflow-yaml.mjs`,
 *      whose header tells the 2026-08-24 story: a key shipped twice by two
 *      sessions killed `auto-pr.yml` for the whole repo with zero jobs and no
 *      log, and every lenient parser called the file valid.
 *   9. Every CONTROL script of package.json is either run by a workflow of this
 *      repo, or declared in `harness/controls.json` with where it runs and why.
 *      `content:figures:check` existed since #451 and was called by NOTHING, in
 *      either repo: months of red nobody could see, on 32 findings not one of
 *      which was true. Half the controls live in the PRIVATE corpus CI, which
 *      this repo cannot read — so declaration is the honest mechanism. `--corpus
 *      <dir>` turns a `privé:*` declaration into a verification, for whoever has
 *      both repos at hand; it is wired into no workflow yet (harness/controls.json
 *      says why), so those declarations are taken on trust.
 *
 * Driven by `.github/workflows/ci.yml` (job `verify`) and `npm run ci:verify`.
 * Pure helpers are exported and unit-tested; `main()` does the filesystem walk and
 * runs only when this file is executed directly.
 *
 *   node scripts/harness/check.mjs
 */
import { readFileSync, readdirSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
import { pathToFileURL } from "node:url";
import { checkYamlFiles, collectGithubYaml } from "../ci/check-workflow-yaml.mjs";
import { buildViews } from "./sync.mjs";

const ROOT = join(import.meta.dirname, "..", "..");

export const AGENTS_MD_MAX_LINES = 250;
export const AGENTS_MD_MAX_BYTES = 24 * 1024;

/** CLAUDE.md must stay a pointer: contain the `@AGENTS.md` import. */
export function checkPointer(claudeMdContent) {
  if (typeof claudeMdContent !== "string" || !claudeMdContent.includes("@AGENTS.md")) {
    return {
      ok: false,
      reason:
        "CLAUDE.md no longer imports @AGENTS.md — it must stay a thin pointer (étude 25 D-1).",
    };
  }
  return { ok: true };
}

/** AGENTS.md must stay under the line/byte budget (D-1b). */
export function checkAgentsSize(
  agentsMdContent,
  { maxLines = AGENTS_MD_MAX_LINES, maxBytes = AGENTS_MD_MAX_BYTES } = {},
) {
  // Un fichier bien formé finit par un saut de ligne : `split` rend alors un
  // dernier élément vide qu'aucun éditeur ne compte. Sans ce retrait, le budget
  // réel valait 249 pour un plafond annoncé à 250, et le message d'erreur
  // donnait un nombre de lignes faux de 1 — sur le fichier qui interdit d'en
  // écrire un faux (voir #839).
  const lines = agentsMdContent.replace(/\n$/, "").split("\n").length;
  const bytes = Buffer.byteLength(agentsMdContent, "utf8");
  const violations = [];
  if (lines > maxLines) {
    violations.push(`${lines} lines > budget of ${maxLines}`);
  }
  if (bytes > maxBytes) {
    violations.push(`${bytes} bytes > budget of ${maxBytes} (Codex truncates AGENTS.md at 32 KiB)`);
  }
  return { ok: violations.length === 0, lines, bytes, violations };
}

/**
 * Lit l'inventaire des features déclaré par la section « Conventions »
 * d'AGENTS.md — la forme `src/features/{name}/` (16 — ai, auth, …) —, ou rend
 * `null` si la phrase a changé de forme. L'appelant en fait alors une
 * violation : un inventaire qu'on ne sait plus lire ne protège plus rien.
 */
export function extractFeatureInventory(agentsMdContent) {
  const flat = (agentsMdContent ?? "").replace(/\s+/g, " ");
  const match = /`src\/features\/\{name\}\/` \((\d+)\s*—\s*([^;)]+)/u.exec(flat);
  if (!match) return null;
  return {
    count: Number(match[1]),
    names: match[2]
      .split(",")
      .map((name) => name.trim())
      .filter(Boolean),
  };
}

/**
 * L'inventaire d'AGENTS.md doit décrire `src/features/` tel qu'il est.
 *
 * Pourquoi un gate plutôt qu'une relecture : ce chiffre a dérivé de trois — le
 * fichier annonçait 13 features quand il y en avait 16, et les trois absentes
 * (`ai`, `exam`, `tutor`) étaient exactement la pile que la roadmap allume.
 * Une carte fausse de la codebase, dans le fichier que chaque session lit en
 * premier, coûte une enquête à chacune d'elles ; et la règle voisine
 * (« une feature n'en importe jamais une autre ») ne veut rien dire si on ne
 * sait pas ce qu'est une feature.
 */
export function checkFeatureInventory(agentsMdContent, actualNames) {
  const declared = extractFeatureInventory(agentsMdContent);
  if (!declared) {
    return [
      "inventaire des features illisible — la phrase `src/features/{name}/ (N — a, b, …)` " +
        "de la section Conventions a changé de forme.",
    ];
  }
  const actual = [...actualNames].sort();
  const listed = new Set(declared.names);
  const problems = [];
  const missing = actual.filter((name) => !listed.has(name));
  const ghosts = declared.names.filter((name) => !actual.includes(name));
  if (missing.length) problems.push(`features absentes de l'inventaire : ${missing.join(", ")}`);
  if (ghosts.length) problems.push(`features listées mais inexistantes : ${ghosts.join(", ")}`);
  if (declared.count !== actual.length) {
    problems.push(`le compte annoncé (${declared.count}) ≠ ${actual.length} dossiers réels`);
  }
  return problems;
}

// Zero-width, bidi-override, and Unicode tag ranges — invisible or
// direction-flipping characters that render identically to nothing in a
// GitHub diff review but change what an agent reads. NOT Arabic script (which
// lives at U+0600-U+06FF and is legitimate content elsewhere in this repo —
// deliberately out of these ranges and out of this scan's scope entirely).
const INVISIBLE_RE = /[​-‏‪-‮⁠-⁤﻿\u{E0000}-\u{E007F}]/gu;

/** Returns every invisible/bidi codepoint found, with its index. */
export function findInvisibleChars(text) {
  if (typeof text !== "string") return [];
  return [...text.matchAll(INVISIBLE_RE)].map((m) => ({
    index: m.index,
    codePoint: `U+${m[0].codePointAt(0).toString(16).toUpperCase().padStart(4, "0")}`,
  }));
}

/** Extracts the YAML frontmatter block (between the two `---` lines) of a SKILL.md. */
export function extractFrontmatter(skillMdContent) {
  const match = /^---\r?\n([\s\S]*?)\r?\n---/.exec(skillMdContent ?? "");
  return match ? match[1] : null;
}

/** Max description length imposed by the open Agent Skills spec (agentskills.io). */
export const SKILL_DESCRIPTION_MAX = 1024;

/**
 * Validates a skill against the portable parts of the Agent Skills spec — the
 * ones another tool will actually enforce when it reads `.agents/skills/`:
 * `name` must equal the folder name and match the charset, and `description`
 * must fit the 1024-character budget (it is injected into every session's
 * system prompt, which is why the spec caps it).
 */
export function checkSkillFrontmatter(folderName, frontmatter) {
  const problems = [];
  if (frontmatter === null) return ["no YAML frontmatter"];

  const name = /^name:\s*(.+)$/m.exec(frontmatter)?.[1]?.trim();
  if (!name) problems.push("missing `name`");
  else if (name !== folderName) problems.push(`name "${name}" ≠ folder "${folderName}"`);
  else if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(name))
    problems.push(`name "${name}" is not kebab-case`);

  // `description` is usually a YAML block scalar (`>-`), so take everything up
  // to the next top-level key rather than a single line.
  const raw = /^description:\s*(?:>-|>|\|-|\|)?\s*\n?([\s\S]*?)(?=\n[a-zA-Z-]+:|$)/m.exec(
    frontmatter,
  )?.[1];
  const description = raw?.replace(/\s+/g, " ").trim() ?? "";
  if (!description) problems.push("missing `description`");
  else if (description.length > SKILL_DESCRIPTION_MAX) {
    problems.push(`description is ${description.length} chars > spec max ${SKILL_DESCRIPTION_MAX}`);
  }

  return problems;
}

// Matches a model IDENTIFIER, keyed on the model FAMILY — not on the vendor
// prefix alone. Anchoring on `claude-*` was too loose once the scan reached
// `.github/workflows/**`: `claude-code-action` (a GitHub Action), and the
// `claude-result.py` / `claude-execution-output.json` filenames all matched,
// none of which is a model. Families are cheap to extend when a new one ships.
const MODEL_ID_RE =
  /\bclaude-[0-9][a-z0-9.-]*\b|\bclaude-(?:sonnet|opus|haiku|fable|instant)[a-z0-9.-]*\b|\bgpt-[0-9][a-z0-9.-]*\b|\bgemini-[0-9][a-z0-9.-]*\b|\bo[0-9](?:-[a-z]+)?\b/gi;

/** Returns every model-id-shaped token found in text (deduped). */
export function findModelIds(text) {
  if (typeof text !== "string") return [];
  return [...new Set([...text.matchAll(MODEL_ID_RE)].map((m) => m[0]))];
}

/** A pinned action ref is a full 40-hex commit SHA. Nothing else is immovable. */
const PINNED_REF_RE = /^[0-9a-f]{40}$/;

// `uses:` at the start of a (possibly list-item) line. Deliberately anchored so
// a `#`-commented line never matches. A literal `uses:` inside a `run: |` block
// would be a false positive; none exists in this repo and the gate's own run
// over `.github/workflows/**` is what proves it — revisit if one ever lands.
const USES_RE = /^[^\S\n]*(?:-[^\S\n]+)?uses:[^\S\n]*(\S+)/gm;

/**
 * Returns every `uses:` that is NOT pinned to a commit SHA.
 *
 * A moving tag (`@v7`, `@main`) means whoever controls that tag decides what
 * code runs with this repo's secrets — the supply-chain half that Dependabot
 * does not cover. Étude 25 lot 5b pinned the whole repo and wrote the rule down,
 * but shipped NO gate: on 2026-07-20 two workflows added hours later
 * reintroduced four moving tags and merged green. This closes that hole.
 *
 * Exempt: local reusable workflows (`./.github/workflows/x.yml` — this repo's
 * own code at this repo's own commit) and `docker://` refs (pinned by digest,
 * a different rule; the repo uses none).
 */
export function findUnpinnedActions(text) {
  if (typeof text !== "string") return [];
  const out = [];
  for (const match of text.matchAll(USES_RE)) {
    const uses = match[1];
    if (uses.startsWith("./") || uses.startsWith("../") || uses.startsWith("docker://")) continue;

    const at = uses.lastIndexOf("@");
    if (at === -1) {
      out.push({ uses, ref: null, reason: "no ref at all — resolves to the default branch" });
      continue;
    }
    const ref = uses.slice(at + 1);
    if (!PINNED_REF_RE.test(ref)) {
      out.push({ uses, ref, reason: `moving ref \`${ref}\`` });
    }
  }
  return out;
}

export function isJsonValid(text) {
  try {
    JSON.parse(text);
    return true;
  } catch {
    return false;
  }
}

/**
 * Un script de CONTRÔLE : celui dont le rouge est censé atteindre quelqu'un.
 * Le suffixe/préfixe suffit à les nommer tous, et rien d'autre ne les nomme —
 * `package.json` ne distingue pas un gate d'un utilitaire.
 */
export const CONTROL_SCRIPT_RE = /(?:^|:)(check|audit|qa|verify|lint|typecheck)(?::|$)/;

/**
 * `npm run <nom>` tel qu'un workflow l'écrit VRAIMENT — flags compris.
 *
 * Le premier détecteur écrit pour ce gate cherchait la sous-chaîne
 * `npm run content:manuel:check` et concluait « orphelin ». Le workflow écrivait
 * `npm run --silent content:manuel:check` : un flag intercalé, plus de
 * correspondance, et une sonde branchée depuis trois semaines déclarée absente.
 * D'où les flags optionnels ici, et la garde de fin de mot — sans elle,
 * `content:qa` matcherait la ligne de `content:qa:strict`.
 */
const npmRunPattern = (name) =>
  new RegExp(
    `npm\\s+run(?:\\s+-{1,2}[\\w-]+)*\\s+${name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}(?![\\w:.-])`,
  );

/** Les fichiers `scripts/**` que la commande d'un script npm nomme. */
const scriptFiles = (command) =>
  [...String(command).matchAll(/(scripts\/[\w./-]+\.(?:mjs|ts|js))/g)].map((m) => m[1]);

/**
 * Où un workflow lance ce script — ou `null`. Deux façons de l'appeler, et le
 * détecteur doit connaître les deux : `npm run <nom>`, et l'exécution DIRECTE du
 * fichier (`node scripts/content/check-videos.mjs`), qui ne mentionne le script
 * npm nulle part.
 */
export function findRunner(name, scripts, workflows) {
  const pattern = npmRunPattern(name);
  const files = scriptFiles(scripts[name] ?? "");
  for (const [label, body] of workflows) {
    if (pattern.test(body)) return label;
    for (const file of files) if (body.includes(file)) return label;
  }
  return null;
}

/** Les scripts qu'un script DÉJÀ lancé entraîne avec lui (`verify` → `eol:check`, …). */
function reachableThroughChains(scripts, directlyRun) {
  const reached = new Map();
  const walkChain = (name, origin, seen) => {
    if (seen.has(name)) return;
    seen.add(name);
    for (const m of String(scripts[name] ?? "").matchAll(
      /npm\s+run(?:\s+-{1,2}[\w-]+)*\s+([\w:.-]+)/g,
    )) {
      if (!reached.has(m[1])) reached.set(m[1], origin);
      walkChain(m[1], origin, seen);
    }
  };
  for (const [name, label] of directlyRun) walkChain(name, `${name} (${label})`, new Set());
  return reached;
}

/**
 * Tout contrôle doit être exécuté par quelqu'un, ou dire qui l'exécute.
 *
 * `corpusWorkflows` transforme une déclaration `privé:*` en VÉRIFICATION : ce
 * dépôt ne voit pas les workflows du corpus, la Content CI privée voit les deux.
 * Absent, les déclarations privées sont crues sur parole (et c'est dit).
 */
export function checkControlCoverage({ scripts, workflows, registry, corpusWorkflows = null }) {
  const problems = [];
  const declared = registry?.controls ?? {};

  const directlyRun = new Map();
  for (const name of Object.keys(scripts)) {
    const label = findRunner(name, scripts, workflows);
    if (label) directlyRun.set(name, label);
  }
  const viaChain = reachableThroughChains(scripts, directlyRun);
  const isRun = (name) => directlyRun.get(name) ?? viaChain.get(name) ?? null;

  for (const name of Object.keys(scripts).filter((n) => CONTROL_SCRIPT_RE.test(n))) {
    const runner = isRun(name);
    const entry = declared[name];
    if (!runner && !entry) {
      problems.push(
        `\`${name}\` est un script de contrôle qu'aucun workflow de ce dépôt n'appelle et que ` +
          "`harness/controls.json` ne déclare pas. Un gate que rien ne lance ne protège rien : " +
          "branche-le dans un workflow, ou déclare où il tourne et pourquoi",
      );
    } else if (runner && entry) {
      problems.push(
        `\`${name}\` est déclaré dans harness/controls.json alors que ${runner} l'exécute déjà — ` +
          "déclaration périmée, retire-la (sinon ce fichier devient un cimetière)",
      );
    }
  }

  for (const [name, entry] of Object.entries(declared)) {
    if (!(name in scripts)) {
      problems.push(
        `harness/controls.json déclare \`${name}\`, qui n'existe plus dans package.json`,
      );
      continue;
    }
    if (!entry?.where || !entry?.why) {
      problems.push(`harness/controls.json: \`${name}\` doit porter un \`where\` ET un \`why\``);
      continue;
    }
    if (!corpusWorkflows || !entry.where.startsWith("privé:")) continue;
    // Le mode vérifié — celui de la Content CI privée.
    const file = entry.where.slice("privé:".length);
    const body = corpusWorkflows.get(file);
    if (body === undefined) {
      problems.push(
        `harness/controls.json: \`${name}\` dit tourner dans \`${file}\` (privé), fichier absent du corpus`,
      );
    } else if (!findRunner(name, scripts, [[file, body]])) {
      problems.push(
        `harness/controls.json: \`${name}\` dit tourner dans \`${file}\` (privé), qui ne l'appelle pas`,
      );
    }
  }

  return problems;
}

function readIfExists(path) {
  return existsSync(path) ? readFileSync(path, "utf8") : null;
}

/** Recursively lists files under `dir` matching `pattern`, or [] if `dir` is absent. */
function walk(dir, pattern) {
  if (!existsSync(dir)) return [];
  const out = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walk(full, pattern));
    else if (pattern.test(entry.name)) out.push(full);
  }
  return out;
}

function main() {
  const problems = [];
  const rel = (p) => relative(ROOT, p).split("\\").join("/");

  // 1. Pointer integrity.
  const claudeMd = readIfExists(join(ROOT, "CLAUDE.md"));
  if (claudeMd === null) {
    problems.push("CLAUDE.md is missing.");
  } else {
    const pointer = checkPointer(claudeMd);
    if (!pointer.ok) problems.push(pointer.reason);
  }

  // 2. AGENTS.md size budget.
  const agentsMd = readIfExists(join(ROOT, "AGENTS.md"));
  if (agentsMd === null) {
    problems.push("AGENTS.md is missing — it is the canonical source (étude 25 D-1).");
  } else {
    const size = checkAgentsSize(agentsMd);
    for (const v of size.violations) problems.push(`AGENTS.md over budget: ${v}.`);

    // 2bis. L'inventaire des features décrit-il encore src/features/ ?
    const featuresDir = join(ROOT, "src", "features");
    const featureNames = existsSync(featuresDir)
      ? readdirSync(featuresDir, { withFileTypes: true })
          .filter((entry) => entry.isDirectory())
          .map((entry) => entry.name)
      : [];
    if (featureNames.length) {
      for (const problem of checkFeatureInventory(agentsMd, featureNames)) {
        problems.push(`AGENTS.md: ${problem}.`);
      }
    }
  }

  // Harness surface scanned for BOTH invisible Unicode and stray model ids.
  // Since lot 5 the guard workflows resolve their model from harness/models.json,
  // so `.github/workflows/**` is in scope too — this is what makes the study's
  // "zero hardcoded model id" KPI actually enforced rather than aspirational.
  const generatedViews = new Set(buildViews(ROOT).map(([relPath]) => relPath));
  const surface = [
    ["AGENTS.md", agentsMd],
    ["CLAUDE.md", claudeMd],
    ...[...generatedViews].map((relPath) => [relPath, readIfExists(join(ROOT, relPath))]),
    // La SOURCE des skills, pas seulement son miroir : le miroir est exempté du
    // scan d'identifiants (il est généré), donc sans cette ligne un id écrit à la
    // main dans `.claude/skills/**` traversait le gate et arrivait tel quel chez
    // Codex, Cursor et Amp.
    ...walk(join(ROOT, ".claude", "skills"), /\.md$/).map((p) => [rel(p), readIfExists(p)]),
    ...walk(join(ROOT, "harness"), /\.(json|md)$/).map((p) => [rel(p), readIfExists(p)]),
    ...walk(join(ROOT, ".github", "workflows"), /\.ya?ml$/).map((p) => [rel(p), readIfExists(p)]),
  ].filter(([, content]) => content !== null);

  for (const [label, content] of surface) {
    for (const hit of findInvisibleChars(content)) {
      problems.push(`${label}: hidden Unicode ${hit.codePoint} at offset ${hit.index}.`);
    }
    // Exempt: models.json declares the ids, and generated views merely compile
    // them (invariant 6 catches a hand-edit).
    if (label !== "harness/models.json" && !generatedViews.has(label)) {
      for (const id of findModelIds(content)) {
        problems.push(
          `${label}: hardcoded model id "${id}" — resolve it via harness/models.json instead.`,
        );
      }
    }
  }

  // 3. Skill frontmatters — hidden Unicode, plus conformance to the portable
  // parts of the Agent Skills spec (lot 3): the mirror at `.agents/skills/` is
  // read by tools that DO enforce them, so a skill that drifts here silently
  // stops working there.
  for (const skillMd of walk(join(ROOT, ".claude", "skills"), /^SKILL\.md$/)) {
    const frontmatter = extractFrontmatter(readIfExists(skillMd));
    const folderName = rel(skillMd).split("/").at(-2);

    for (const problem of checkSkillFrontmatter(folderName, frontmatter)) {
      problems.push(`${rel(skillMd)}: ${problem} (Agent Skills spec).`);
    }

    if (frontmatter === null) continue;
    for (const hit of findInvisibleChars(frontmatter)) {
      problems.push(
        `${rel(skillMd)} frontmatter: hidden Unicode ${hit.codePoint} at offset ${hit.index}.`,
      );
    }
  }

  // 4. Every GitHub Action pinned to a commit SHA (étude 25 lot 5b). The policy
  // was written in docs/dependency-maintenance.md but never enforced — see
  // findUnpinnedActions' header for the regression that proved a documented rule
  // without a gate is a suggestion.
  for (const workflow of walk(join(ROOT, ".github", "workflows"), /\.ya?ml$/)) {
    const content = readIfExists(workflow);
    if (content === null) continue;
    for (const hit of findUnpinnedActions(content)) {
      problems.push(
        `${rel(workflow)}: \`uses: ${hit.uses}\` is not pinned to a commit SHA (${hit.reason}) — ` +
          "resolve it with `gh api repos/<owner>/<repo>/commits/<tag> --jq .sha` and keep the " +
          "version as a trailing comment (docs/dependency-maintenance.md).",
      );
    }
  }

  // 5. JSON validity of every harness/*.json file.
  for (const jsonFile of walk(join(ROOT, "harness"), /\.json$/)) {
    const content = readIfExists(jsonFile);
    if (content !== null && !isJsonValid(content)) {
      problems.push(`${rel(jsonFile)} is not valid JSON.`);
    }
  }

  // 6. Generated views must match their harness sources (lot 4). This is what
  // lets the model id inside a GENERATED file be legitimate: it is not
  // hand-written, it is compiled from harness/models.json — and any hand-edit
  // (including a model bumped only here) shows up as drift below.
  for (const [relPath, expected] of buildViews(ROOT)) {
    const actual = readIfExists(join(ROOT, relPath));
    if (actual === null) {
      problems.push(`${relPath} is missing — run \`npm run harness:sync\`.`);
    } else if (actual !== expected) {
      problems.push(
        `${relPath} drifted from its harness sources — run \`npm run harness:sync\` and commit the result.`,
      );
    }
  }

  // 7. Strict YAML under `.github/**` — a duplicate mapping key ends the run as
  // `startup_failure`: zero jobs, no log, no annotation. Lenient parsers (last
  // key wins) call such a file valid, so this needs a parser with `uniqueKeys`,
  // not a convention. See check-workflow-yaml.mjs for the incident it replays.
  problems.push(...checkYamlFiles(collectGithubYaml(ROOT)));

  // 8. Tout script de CONTRÔLE est exécuté par quelqu'un — ou dit qui l'exécute.
  // `content:figures:check` a passé des mois rouge sans qu'aucun workflow ne
  // l'appelle : rien, ici, ne disait qu'il en était un. Voir harness/controls.json.
  const pkg = readIfExists(join(ROOT, "package.json"));
  const registryRaw = readIfExists(join(ROOT, "harness", "controls.json"));
  if (pkg === null) {
    problems.push("package.json is missing.");
  } else if (registryRaw === null || !isJsonValid(registryRaw)) {
    problems.push("harness/controls.json is missing or invalid JSON.");
  } else {
    const workflows = walk(join(ROOT, ".github", "workflows"), /\.ya?ml$/).map((p) => [
      rel(p),
      readIfExists(p),
    ]);
    // `--corpus <dir>` : le corpus privé monté à côté, comme le fait déjà
    // `check-roadmap-sync.mjs`. La Content CI privée l'a, ce dépôt non — et
    // c'est elle qui transforme les déclarations `privé:*` en vérifications.
    const corpusFlag = process.argv.indexOf("--corpus");
    let corpusWorkflows = null;
    if (corpusFlag !== -1 && process.argv[corpusFlag + 1]) {
      const dir = join(process.argv[corpusFlag + 1], ".github", "workflows");
      if (!existsSync(dir)) {
        problems.push(`--corpus: ${dir} introuvable — le corpus est-il bien monté ?`);
      } else {
        corpusWorkflows = new Map(
          walk(dir, /\.ya?ml$/).map((p) => [p.split(/[\\/]/).at(-1), readIfExists(p)]),
        );
      }
    }
    problems.push(
      ...checkControlCoverage({
        scripts: JSON.parse(pkg).scripts ?? {},
        workflows: workflows.filter(([, body]) => body !== null),
        registry: JSON.parse(registryRaw),
        corpusWorkflows,
      }),
    );
  }

  if (problems.length === 0) {
    console.log(
      "[harness:check] OK — pointers intact, AGENTS.md in budget et son inventaire de " +
        "features à jour, no hidden Unicode, " +
        "no stray model ids, Actions pinned to SHAs, .github YAML parses strictly, chaque contrôle exécuté ou déclaré, " +
        "generated views in sync.",
    );
    return;
  }

  for (const p of problems) console.error(`::error::${p}`);
  throw new Error(`${problems.length} harness gate violation(s) — see annotations above.`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
