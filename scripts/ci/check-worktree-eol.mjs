#!/usr/bin/env node
/**
 * Working-tree EOL gate — the CRLF trap git cannot show you.
 *
 * `.gitattributes` mandates `* text=auto eol=lf`: every text file is LF in the
 * object store AND in the working tree. But `text=auto` also means git NORMALIZES
 * on compare — so a working-tree file rewritten with CRLF by some tool after
 * checkout (an editor, an agent's file writer on Windows) is byte-different on
 * disk while `git status` and `git diff` report it as perfectly clean. It is
 * invisible, and it survives every pull.
 *
 * Why that is not cosmetic: Vite's SSR transform chokes on a CRLF module that
 * needs CJS interop — it injects the interop imports ahead of the shebang and
 * then fails to re-parse its own output. On 2026-07-25 that made
 * `.claude/hooks/precommit-checks.mjs` fail `npm test` on the Windows
 * workstation with a rolldown parse error pointing deep into node_modules, while
 * CI (a fresh LF checkout) stayed green. `npm run verify` is the pre-push hook,
 * so the whole local gate was red for a reason no git command would reveal —
 * precisely the situation that tempts a `--no-verify` (DoD §2 forbids it).
 *
 * This gate is a no-op on Linux/CI and costs ~200 ms locally. `--fix` rewrites
 * the offenders to LF: a pure normalization, byte-for-byte what git already
 * believes the files contain, so it can never lose work.
 *
 *   node scripts/ci/check-worktree-eol.mjs         # report and fail
 *   node scripts/ci/check-worktree-eol.mjs --fix   # normalize in place
 */

import { execFileSync } from "node:child_process";
import { readFileSync, writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

const CR = 0x0d;
const LF = 0x0a;
const NUL = 0x00;

/** A NUL byte means git treats it as binary — never touch those. */
export function isBinary(bytes) {
  return bytes.includes(NUL);
}

/** Does this buffer contain a CRLF pair? */
export function hasCrlf(bytes) {
  for (let i = 0; i < bytes.length - 1; i += 1) {
    if (bytes[i] === CR && bytes[i + 1] === LF) return true;
  }
  return false;
}

/** CRLF → LF. Lone CR (classic Mac) is left alone: not ours to guess about. */
export function toLf(bytes) {
  const out = Buffer.alloc(bytes.length);
  let n = 0;
  for (let i = 0; i < bytes.length; i += 1) {
    if (bytes[i] === CR && bytes[i + 1] === LF) continue;
    out[n] = bytes[i];
    n += 1;
  }
  return out.subarray(0, n);
}

/**
 * Files whose working-tree bytes disagree with the LF mandate.
 * IO is injected so this is unit-testable without a fixture repo.
 *
 * @param {string[]} files paths git declares `eol=lf`
 * @param {(path: string) => Buffer | null} read returns null for unreadable paths
 * @returns {string[]} offenders, in input order
 */
export function findCrlfOffenders(files, read) {
  const offenders = [];
  for (const file of files) {
    const bytes = read(file);
    if (!bytes || isBinary(bytes)) continue;
    if (hasCrlf(bytes)) offenders.push(file);
  }
  return offenders;
}

/** Tracked files git declares `eol=lf` — i.e. the ones this gate governs. */
function lfMandatedFiles() {
  const tracked = execFileSync("git", ["ls-files", "-z"], { maxBuffer: 64 * 1024 * 1024 });
  const attrs = execFileSync("git", ["check-attr", "--stdin", "-z", "eol"], {
    input: tracked,
    maxBuffer: 64 * 1024 * 1024,
  });
  // Output is a flat NUL-separated stream of (path, attribute, value) triples.
  const fields = attrs.toString("utf8").split("\0");
  const files = [];
  for (let i = 0; i + 2 < fields.length; i += 3) {
    if (fields[i + 2] === "lf") files.push(fields[i]);
  }
  return files;
}

function main() {
  const fix = process.argv.includes("--fix");
  const files = lfMandatedFiles();
  const read = (file) => {
    try {
      return readFileSync(file);
    } catch {
      return null; // deleted or unreadable — not this gate's business
    }
  };
  const offenders = findCrlfOffenders(files, read);

  if (offenders.length === 0) {
    console.log(`[eol] OK — ${files.length} fichiers suivis, aucun CRLF dans l'arbre de travail.`);
    return;
  }

  if (fix) {
    for (const file of offenders) writeFileSync(file, toLf(readFileSync(file)));
    // Rewriting the bytes is only half the repair. git keeps a stat cache entry
    // it can no longer confirm, so `git status` shows the files as modified even
    // though `git diff` is empty — and THAT is what makes `git rebase` refuse to
    // run ("you have unstaged changes"). `--renormalize` refreshes the cache and
    // stages nothing, because the normalized content is already the blob.
    for (let i = 0; i < offenders.length; i += 100) {
      execFileSync("git", ["add", "--renormalize", ...offenders.slice(i, i + 100)]);
    }
    console.log(`[eol] ${offenders.length} fichier(s) renormalisé(s) en LF :`);
    for (const file of offenders) console.log(`  - ${file}`);
    console.log("[eol] index rafraîchi — l'arbre de travail est propre, rien n'a été staged.");
    return;
  }

  console.error(
    `[eol] ${offenders.length} fichier(s) sont en CRLF dans l'arbre de travail alors que ` +
      "`.gitattributes` impose LF.\n" +
      "      git ne le montre pas (text=auto normalise à la comparaison), mais la transformation\n" +
      "      SSR de Vite casse sur ces fichiers — c'est ce qui rend `npm test` rouge en local\n" +
      "      pendant que la CI reste verte.\n",
  );
  for (const file of offenders) console.error(`  - ${file}`);
  console.error("\n      Réparer : npm run eol:fix");
  process.exit(1);
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}
