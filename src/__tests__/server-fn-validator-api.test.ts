// @vitest-environment node
import { readFileSync, readdirSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, join, relative } from "node:path";
import { describe, expect, it } from "vitest";

/**
 * Les server fns valident leur entrée par `.validator()`, jamais par l'ancien alias.
 *
 * Ce que ça a coûté, le 2026-10-30 (issue #1203) : `@tanstack/start-client-core`
 * 1.170.39, tiré par la minor `@tanstack/react-start` 1.169.x, a retiré l'alias
 * `inputValidator` de `createServerFn` — des types comme du runtime. Les 91 appels
 * du dépôt ont cessé de compiler (TS2339), `data` et `context` sont devenus `any`
 * dans les handlers, et tout le lot de montées patch/minor est tombé au typecheck.
 * `.validator()` existait déjà dans la version installée : la migration s'est faite
 * sur `main`, sans monter la dépendance.
 *
 * Ce test ferme le retour en arrière : un copier-coller d'un vieux snippet, ou un
 * mock de test qui simule encore l'ancienne chaîne, échoue ici avant d'échouer au
 * prochain sweep de dépendances, là où la cause est noyée dans le lot.
 */
const SRC = join(process.cwd(), "src");
const SOI_MEME = import.meta.filename;

/** Le nom retiré, assemblé pour que ce fichier ne se dénonce pas lui-même. */
const ALIAS_RETIRE = ["input", "Validator"].join("");
const USAGE_RETIRE = new RegExp(`\\b${ALIAS_RETIRE}\\b`);

function tsFiles(dir: string, out: string[] = []): string[] {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) tsFiles(full, out);
    else if (/\.tsx?$/.test(entry.name) && full !== SOI_MEME) out.push(full);
  }
  return out;
}

describe("API de validation des server fns (#1203)", () => {
  const files = tsFiles(SRC);

  it("aucun fichier de src/ ne nomme l'alias retiré — ni appel, ni clé de mock, ni prose", () => {
    const offenders = files
      .filter((f) => USAGE_RETIRE.test(readFileSync(f, "utf-8")))
      .map((f) => relative(process.cwd(), f));
    expect(
      offenders,
      `\`.${ALIAS_RETIRE}\` est retiré de TanStack Start : utiliser \`.validator\``,
    ).toEqual([]);
  });

  it("les server fns valident bien par `.validator(` (le scan n'est pas vide de sens)", () => {
    const callers = files.filter((f) => /\.validator\(/.test(readFileSync(f, "utf-8")));
    expect(callers.length).toBeGreaterThan(20);
  });

  it("la version installée de start-client-core déclare `validator` sur createServerFn", () => {
    const require = createRequire(import.meta.url);
    const pkgDir = dirname(require.resolve("@tanstack/start-client-core/package.json"));
    const dts = readFileSync(join(pkgDir, "dist/esm/createServerFn.d.ts"), "utf-8");
    expect(dts).toMatch(/\bvalidator\s*:/);
  });
});
