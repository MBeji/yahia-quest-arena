// @vitest-environment node
import { mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, relative, resolve } from "node:path";
import { describe, expect, it } from "vitest";

/**
 * AUCUN BUILTIN NODE N'EST ATTEIGNABLE DEPUIS UNE ENTRÉE CLIENT.
 *
 * Ce que la garde de #906 ne pouvait pas voir, et ce que cinq nuits de nightly
 * ont coûté : elle interdisait à une COQUILLE DE ROUTE d'importer la barrel
 * mixte `@/features/ai`. Or la chaîne vivante ne passait pas par une route —
 * elle passait par une FEATURE :
 *
 *   `_authenticated/dashboard.tsx` → `features/tutor/components/tutor-digest`
 *     → `features/tutor/digest.server` → barrel `@/features/ai`
 *     → `ai-call.server` → `provider.server` → `openai-compatible.server`
 *     → `egress.server` → `node:dns`
 *
 * En dev, Vite sert les modules NON bundlés : le navigateur charge vraiment ce
 * graphe, `node:dns` est externalisé, l'accès LÈVE au moment d'évaluer le
 * module, et la frontière d'erreur racine attrape avant tout routage. La
 * production, elle, va bien — son build élague ce que le dev server charge.
 *
 * D'où cette garde, qui ne raisonne plus par nom de module mais par GRAPHE, et
 * seulement sur les imports STATIQUES : c'est exactement ce que le navigateur
 * évalue, et c'est ce qui rend un `await import(…)` acceptable là où un
 * `import … from` ne l'est pas.
 *
 * Elle est volontairement une SUR-APPROXIMATION : elle ne modélise pas
 * l'élagage du plugin TanStack Start (qui vide les corps de handler puis retire
 * les imports devenus inutiles). Dépendre de ce détail d'implémentation, c'est
 * exactement ce qui a rendu le défaut invisible — `tsc`, le lint et
 * `build:check` sont tous restés verts pendant les cinq nuits.
 */
const SRC = join(process.cwd(), "src");

/** Un builtin atteint en import STATIQUE depuis une entrée client = échec. */
const BUILTIN = /^(node:|fs$|path$|os$|crypto$|dns$|net$|https?$|child_process$|stream$)/;

function tsFiles(dir: string, out: string[] = []): string[] {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      if (entry.name !== "__tests__") tsFiles(full, out);
    } else if (/\.tsx?$/.test(full) && !full.endsWith(".gen.ts")) {
      out.push(full);
    }
  }
  return out;
}

/**
 * Les specifiers importés STATIQUEMENT par un fichier — `import type` et les
 * clauses dont TOUS les membres sont `type …` sont ignorés (ils disparaissent à
 * la compilation), et `await import(…)` n'est pas vu, ce qui est le remède.
 */
export function staticImports(source: string): string[] {
  const sansBlocs = source.replace(/\/\*[\s\S]*?\*\//g, "");
  const out: string[] = [];
  const re = /^(?:import|export)\s+([\s\S]*?)\s*from\s*["']([^"']+)["']/gm;
  for (const m of sansBlocs.matchAll(re)) {
    const clause = m[1] ?? "";
    const spec = m[2] ?? "";
    if (/^type\b/.test(clause.trim())) continue;
    const accolade = clause.match(/\{([\s\S]*)\}/);
    if (accolade) {
      const membres = (accolade[1] ?? "")
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
      const avantAccolade = clause.slice(0, clause.indexOf("{")).replace(/,\s*$/, "").trim();
      if (membres.length > 0 && membres.every((s) => /^type\s/.test(s)) && avantAccolade === "") {
        continue;
      }
    }
    out.push(spec);
  }
  return out;
}

/** Résout un specifier vers un fichier réel sous `root`, ou `null` (paquet npm). */
function resoudre(root: string, depuis: string, spec: string): string | null {
  let base: string;
  if (spec.startsWith("@/")) base = join(root, spec.slice(2));
  else if (spec.startsWith(".")) base = resolve(dirname(depuis), spec);
  else return null;
  for (const cand of [
    base,
    `${base}.ts`,
    `${base}.tsx`,
    join(base, "index.ts"),
    join(base, "index.tsx"),
  ]) {
    try {
      if (/\.tsx?$/.test(cand)) return readFileSync(cand, "utf8") === null ? null : cand;
    } catch {
      /* essai suivant */
    }
  }
  return null;
}

/** Les entrées dont un builtin est atteignable, avec la chaîne qui y mène. */
export function entreesEmpoisonnees(root: string, entrees: string[]): string[] {
  const fautes: string[] = [];
  for (const entree of entrees) {
    const vus = new Set<string>();
    const file: Array<{ f: string; chemin: string[] }> = [{ f: entree, chemin: [entree] }];
    while (file.length > 0) {
      const { f, chemin } = file.shift() as { f: string; chemin: string[] };
      if (vus.has(f)) continue;
      vus.add(f);
      let source: string;
      try {
        source = readFileSync(f, "utf8");
      } catch {
        continue;
      }
      for (const spec of staticImports(source)) {
        if (BUILTIN.test(spec)) {
          fautes.push(
            `${relative(root, entree)} → ${spec}\n    via ${chemin.map((c) => relative(root, c)).join(" → ")}`,
          );
          file.length = 0;
          break;
        }
        const cible = resoudre(root, f, spec);
        if (cible && !vus.has(cible)) file.push({ f: cible, chemin: [...chemin, cible] });
      }
    }
  }
  return fautes;
}

describe("le graphe client n'atteint aucun builtin Node", () => {
  it("aucune entrée de route n'atteint `node:*` en import statique", () => {
    const entrees = [...tsFiles(join(SRC, "routes")), join(SRC, "router.tsx")];
    expect(entreesEmpoisonnees(SRC, entrees)).toEqual([]);
  });

  it("la garde voit encore les fautes — contrôle négatif sur un faux arbre", () => {
    const root = mkdtempSync(join(tmpdir(), "client-graph-"));
    try {
      mkdirSync(join(root, "routes"), { recursive: true });
      writeFileSync(join(root, "routes", "casse.tsx"), 'import { b } from "../b.server";\n');
      writeFileSync(
        join(root, "b.server.ts"),
        'import { lookup } from "node:dns";\nexport const b = lookup;\n',
      );
      writeFileSync(join(root, "routes", "sain.tsx"), 'import { d } from "@/d";\n');
      writeFileSync(join(root, "d.ts"), "export const d = 1;\n");
      // Un import de TYPE seul disparaît à la compilation : il ne compte pas.
      writeFileSync(join(root, "routes", "type-seul.tsx"), 'import type { X } from "node:dns";\n');
      // Un `await import(…)` est le remède : il ne doit PAS être vu.
      writeFileSync(
        join(root, "routes", "paresseux.tsx"),
        'const f = async () => (await import("node:dns")).lookup;\nexport default f;\n',
      );

      const fautes = entreesEmpoisonnees(root, [
        join(root, "routes", "casse.tsx"),
        join(root, "routes", "sain.tsx"),
        join(root, "routes", "type-seul.tsx"),
        join(root, "routes", "paresseux.tsx"),
      ]);
      expect(fautes).toHaveLength(1);
      expect(fautes[0]).toContain("casse.tsx");
      expect(fautes[0]).toContain("node:dns");
      expect(fautes[0]).toContain("b.server.ts");
    } finally {
      rmSync(root, { recursive: true, force: true });
    }
  });
});
