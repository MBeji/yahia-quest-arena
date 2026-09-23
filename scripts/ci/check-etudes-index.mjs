#!/usr/bin/env node
/**
 * Documentation-drift gate — do the three places that state an étude's status agree?
 *
 * Opened as #994: `STATUS.md` documents, in its own header, that "the drift is
 * ONE-WAY — the private ROADMAP and index are kept up to date at every lot, it is
 * the PUBLIC topo that falls behind, because no gate watches it". It then did it
 * again TWELVE HOURS later, on the étude whose subject was precisely the gates.
 *
 * An étude's status is written in THREE places, and only one of them is declared
 * the source of truth (`FableEtudes/README.md`: "le statut vit dans l'en-tête du
 * dossier ETUDE.md ; l'index ci-dessous est un instantané") :
 *
 *   1. the `> **Statut** :` header of its own `ETUDE.md`     ← source of truth
 *   2. the `statut` column of the index (`FableEtudes/README.md`)
 *   3. the §4 table of `STATUS.md` (public repo), which groups études by state
 *
 * …plus a FOURTH, physical one: a `livrée` étude lives in `EtudeRealisé/`, and the
 * index says so in the same breath ("leur dossier NN-<slug>/ est déplacé tel quel
 * dès que le statut bascule").
 *
 * WHAT IT CHECKS — and the boundary is the whole point (#994 § "Ce que ça ne doit
 * pas devenir"). It has an opinion about CONTRADICTION, never about exhaustivity:
 * nothing here demands that a PR mention anything anywhere. A doc that stays
 * silent about an étude is fine; a doc that asserts a state its own document
 * denies is not.
 *
 *   L — dead links: every relative link of the index resolves. (The private
 *       roadmap it also scanned was merged into `STATUS.md` §6 on 2026-09-23.)
 *       Would have caught privé#354, which marked é32 `livrée` while pointing at
 *       `32-harness-optimisation/ETUDE.md`, a path dead since the folder moved
 *       into `EtudeRealisé/`. It went green.
 *   S — index cell vs `ETUDE.md` header.
 *   R — `livrée` ⇔ the folder sits under `EtudeRealisé/`.
 *   T — `STATUS.md` §4 vs the `ETUDE.md` header, plus the same étude filed under
 *       two different states in §4 (a contradiction that needs no second file).
 *
 * The vocabulary is CLOSED (see CANONICAL): the lifecycle the index declares for
 * itself, plus `scission faite`, which é24 and `STATUS.md` §4 both use as a state
 * of its own. A status cell that starts with anything else ("lot 1 livré (1/2)",
 * the real é26 cell on 2026-09-12) is reported as unreadable rather than guessed
 * at — a progress note is not a status, and reading "livré" out of it would file
 * a half-done étude as delivered.
 *
 *   node scripts/ci/check-etudes-index.mjs --etudes ../corpus/FableEtudes
 *
 * Node builtins only: it is called from the private `roadmap-sync.yml`, which runs
 * WITHOUT `npm ci` by design (see harness/controls.json).
 */

import { readFileSync, existsSync, readdirSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { pathToFileURL } from "node:url";

/**
 * The closed vocabulary, in the order the lifecycle runs.
 *
 * Plurals are accepted because `STATUS.md` §4 labels its rows with them
 * ("Livrées", "Gelées"); the accents are stripped before matching, so `LIVRÉE`,
 * `livrée` and `Livrées` all land on the same token.
 */
const CANONICAL = [
  ["brouillon", /^brouillons?(?![a-z])/],
  ["validée", /^validees?(?![a-z])/],
  ["en exécution", /^en execution(?![a-z])/],
  ["livrée", /^livrees?(?![a-z])/],
  ["gelée", /^gelees?(?![a-z])/],
  // é24 — "scission faite" is not in the declared lifecycle, and it is used
  // consistently by both its own header and the §4 row of STATUS.md. The gate
  // polices contradiction, not vocabulary, so it is a status here too.
  ["scission faite", /^scission faite(?![a-z])/],
];

/** Markdown emphasis, code ticks, quote markers and links reduced to their text. */
function plain(cell) {
  return String(cell)
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/[*_`>]/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

/** Lowercase, accent-free, emphasis-free — the form the patterns match against. */
export function normalize(cell) {
  return plain(cell)
    .normalize("NFD")
    .replace(/\p{Mn}/gu, "")
    .toLowerCase()
    .trim();
}

/**
 * The lifecycle status a cell or header STARTS with, or null.
 *
 * Anchored at the start on purpose: "lot 1 livré (1/2)" must not read as
 * `livrée`, while "LIVRÉE le 2026-09-06 — 5 lots sur 6 (le lot 3 est abandonné)"
 * and "en exécution (validée le 2026-07-11…)" must read as the status they open
 * with. Searching anywhere in the string would make the second one ambiguous and
 * the first one plainly wrong.
 */
export function canonicalStatus(cell) {
  const text = normalize(cell);
  for (const [label, pattern] of CANONICAL) if (pattern.test(text)) return label;
  return null;
}

/** The cells of a markdown table row, outer pipes dropped. */
function cellsOf(line) {
  const trimmed = line.trim();
  if (!trimmed.startsWith("|")) return null;
  const cells = trimmed.split("|");
  cells.shift();
  if (trimmed.endsWith("|")) cells.pop();
  return cells;
}

const SEPARATOR_RE = /^[\s:|-]+$/;

/**
 * The index rows: `{ num, link, status, line }`, one per étude cited.
 *
 * The `statut` column is found by its HEADER LABEL, never by position: the table
 * has grown a column twice since the split, and a hardcoded index would then read
 * the "complexité" cell and compare a cost to a status.
 */
export function parseIndexRows(markdown) {
  const rows = [];
  let statusCol = null;
  let numCol = null;
  let etudeCol = null;

  for (const line of markdown.split("\n")) {
    const cells = cellsOf(line);
    if (!cells) continue;
    const labels = cells.map((c) => normalize(c));

    if (statusCol === null) {
      const i = labels.findIndex((l) => l === "statut");
      if (i !== -1) {
        statusCol = i;
        numCol = labels.findIndex((l) => l === "#");
        etudeCol = labels.findIndex((l) => l === "etude");
      }
      continue;
    }
    if (SEPARATOR_RE.test(line.trim())) continue;

    const num = (cells[numCol] ?? "").trim();
    if (!/^\d{1,2}$/.test(num)) continue;
    const link = /\[[^\]]*\]\(([^)\s]+)/.exec(cells[etudeCol] ?? "");
    rows.push({
      num: num.padStart(2, "0"),
      link: link ? link[1] : null,
      status: (cells[statusCol] ?? "").trim(),
      line,
    });
  }
  return rows;
}

/** The `> **Statut** :` line of an `ETUDE.md`, raw. */
export function headerStatusLine(markdown) {
  for (const line of markdown.split("\n").slice(0, 60)) {
    const m = /^\s*>?\s*\*{0,2}statut\*{0,2}\s*\*{0,2}\s*:\s*(.+)$/i.exec(line);
    if (m) return m[1].trim();
  }
  return null;
}

/**
 * What `STATUS.md` §4 claims, as `Map<num, { state, label }[]>`.
 *
 * §4 is a table of STATE → list of études, so a row label is the claim and every
 * bolded étude number in the row carries it. Only numbers the index knows are
 * read: a bolded two-digit number elsewhere in the prose (a GAP, a lot count) is
 * not a status claim, and guessing would make the gate lie in the safest-looking
 * direction — green.
 */
export function statusClaims(markdown, knownNums) {
  const claims = new Map();
  const section = /\n##\s*4\.[^\n]*\n([\s\S]*?)(?=\n##\s|\s*$)/.exec(markdown);
  if (!section) return claims;

  for (const line of section[1].split("\n")) {
    const cells = cellsOf(line);
    if (!cells || cells.length < 2) continue;
    if (SEPARATOR_RE.test(line.trim())) continue;
    const state = canonicalStatus(cells[0]);
    if (!state) continue;
    const label = plain(cells[0]);
    for (const m of cells
      .slice(1)
      .join(" | ")
      .matchAll(/\*\*(\d{2})\*\*/g)) {
      if (!knownNums.has(m[1])) continue;
      const list = claims.get(m[1]) ?? [];
      if (!list.some((c) => c.state === state)) list.push({ state, label });
      claims.set(m[1], list);
    }
  }
  return claims;
}

/**
 * Every relative link target of a markdown file that does not resolve to a file.
 *
 * Anchors are stripped, then the target must exist as written. `%` escapes are
 * decoded: `EtudeRealis%C3%A9/` is how an editor writes the folder, and comparing
 * it raw would report every single one of them as dead.
 */
export function deadLinks(markdown, filePath) {
  const base = dirname(filePath);
  const dead = [];
  for (const m of markdown.matchAll(/\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g)) {
    const raw = m[1];
    if (/^(?:https?:|mailto:|#|<)/i.test(raw)) continue;
    const target = raw.split("#")[0];
    if (!target) continue;
    let decoded = target;
    try {
      decoded = decodeURIComponent(target);
    } catch {
      /* a literal `%` is not an escape — compare it as written */
    }
    if (!existsSync(resolve(base, decoded))) dead.push(raw);
  }
  return [...new Set(dead)];
}

/** Folders that look like an étude, wherever they sit. */
function etudeFolders(etudesDir) {
  const found = new Map();
  const scan = (dir, prefix) => {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      if (!entry.isDirectory()) continue;
      const m = /^(\d{2})-/.exec(entry.name);
      const child = join(dir, entry.name);
      if (m) {
        if (existsSync(join(child, "ETUDE.md"))) found.set(m[1], join(prefix, entry.name));
        continue;
      }
      if (entry.name.startsWith("EtudeRealis")) scan(child, join(prefix, entry.name));
    }
  };
  scan(etudesDir, "");
  return found;
}

const DELIVERED_DIR_RE = /EtudeRealis/;

/**
 * The contradictions, as flat `{ code, num, detail }` records.
 *
 * @param {object} input
 * @param {{num: string, link: string|null, status: string}[]} input.rows index rows
 * @param {Map<string, string>} input.headers étude number → its raw header status
 * @param {Map<string, string>} input.paths étude number → path of its ETUDE.md
 * @param {Map<string, {state: string, label: string}[]>} input.claims STATUS.md §4
 */
export function findContradictions({ rows, headers, paths, claims }) {
  const found = [];
  const push = (code, num, detail) => found.push({ code, num, detail });

  for (const row of rows) {
    const header = headers.get(row.num);
    const indexStatus = canonicalStatus(row.status);

    if (indexStatus === null) {
      push(
        "S",
        row.num,
        `l'index dit « ${plain(row.status) || "(vide)"} », qui n'est pas un statut du cycle de vie`,
      );
    }
    if (header === undefined) continue;
    const headerStatus = canonicalStatus(header);
    if (headerStatus === null) {
      push(
        "S",
        row.num,
        `l'en-tête de son ETUDE.md dit « ${plain(header) || "(vide)"} », qui n'est pas un statut du cycle de vie`,
      );
      continue;
    }
    if (indexStatus !== null && indexStatus !== headerStatus) {
      push("S", row.num, `l'index dit « ${indexStatus} », son ETUDE.md dit « ${headerStatus} »`);
    }

    const path = paths.get(row.num) ?? "";
    const filed = DELIVERED_DIR_RE.test(path);
    if (headerStatus === "livrée" && !filed) {
      push("R", row.num, `son ETUDE.md dit « livrée » et son dossier est resté hors EtudeRealisé/`);
    } else if (headerStatus !== "livrée" && filed) {
      push(
        "R",
        row.num,
        `son dossier est dans EtudeRealisé/ alors que son ETUDE.md dit « ${headerStatus} »`,
      );
    }

    for (const claim of claims.get(row.num) ?? []) {
      if (claim.state !== headerStatus) {
        push(
          "T",
          row.num,
          `STATUS.md §4 la classe « ${claim.label} », son ETUDE.md dit « ${headerStatus} »`,
        );
      }
    }
  }

  for (const [num, list] of claims) {
    if (list.length > 1) {
      push(
        "T",
        num,
        `STATUS.md §4 la classe DEUX fois : ${list.map((c) => `« ${c.label} »`).join(" et ")}`,
      );
    }
  }

  return found.sort((a, b) => a.num.localeCompare(b.num) || a.code.localeCompare(b.code));
}

function argValue(flag, fallback) {
  const i = process.argv.indexOf(flag);
  return i !== -1 && process.argv[i + 1] ? process.argv[i + 1] : fallback;
}

function readOrExit(path, what) {
  try {
    return readFileSync(path, "utf8");
  } catch {
    console.error(
      `[etudes-index] ${what} introuvable : ${path}\n` +
        "      Ce gate se lance depuis le moteur avec le corpus privé à côté :\n" +
        "      node scripts/ci/check-etudes-index.mjs --etudes ../corpus/FableEtudes",
    );
    process.exit(2);
  }
}

const CODE_TITLES = {
  L: "liens morts",
  S: "statut de l'index ≠ en-tête de l'étude",
  R: "rangement du dossier ≠ statut",
  T: "STATUS.md ≠ en-tête de l'étude",
};

function main() {
  const etudesDir = argValue("--etudes", "FableEtudes");
  const statusPath = argValue("--status", "STATUS.md");

  const indexPath = join(etudesDir, "README.md");
  const index = readOrExit(indexPath, "l'index des études");
  const topo = readOrExit(statusPath, "le topo STATUS.md");

  const rows = parseIndexRows(index);
  if (rows.length === 0) {
    console.error(
      `[etudes-index] aucune ligne d'étude lue dans ${indexPath}.\n` +
        "      Le tableau doit porter une colonne « statut » et une colonne « # ».",
    );
    process.exit(2);
  }

  const folders = etudeFolders(etudesDir);
  const headers = new Map();
  const paths = new Map();
  for (const [num, folder] of folders) {
    const file = join(etudesDir, folder, "ETUDE.md");
    const header = headerStatusLine(readFileSync(file, "utf8"));
    if (header !== null) headers.set(num, header);
    paths.set(num, folder);
  }

  const problems = findContradictions({
    rows,
    headers,
    paths,
    claims: statusClaims(topo, new Set(rows.map((r) => r.num))),
  });

  for (const row of rows) {
    if (!row.link)
      problems.push({ code: "L", num: row.num, detail: "sa ligne d'index ne porte aucun lien" });
  }
  for (const link of deadLinks(readFileSync(indexPath, "utf8"), indexPath)) {
    problems.push({
      code: "L",
      num: "--",
      detail: `${relative(etudesDir, indexPath)} pointe « ${link} », qui n'existe pas`,
    });
  }

  if (problems.length === 0) {
    console.log(
      `[etudes-index] OK — ${rows.length} études : index, en-têtes, rangement et STATUS.md §4 s'accordent.`,
    );
    return;
  }

  console.error(
    `[etudes-index] ${problems.length} contradiction(s). Un document qui AFFIRME un état faux\n` +
      "      coûte plus qu'un document muet : une session le croit et refait du travail déjà mergé.\n" +
      "      La source de vérité est l'en-tête du ETUDE.md (index privé, § Cycle de vie).\n",
  );
  let current = null;
  for (const { code, num, detail } of problems.sort(
    (a, b) => a.code.localeCompare(b.code) || a.num.localeCompare(b.num),
  )) {
    if (code !== current) {
      current = code;
      console.error(`  ${code} — ${CODE_TITLES[code]}`);
    }
    console.error(`     ${num === "--" ? "  " : `é${num}`}  ${detail}`);
  }
  process.exit(1);
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}
