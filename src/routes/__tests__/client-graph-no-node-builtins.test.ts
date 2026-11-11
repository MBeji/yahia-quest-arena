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

/**
 * LES PAQUETS npm QU'UN `*.server.ts` DU GRAPHE CLIENT A LE DROIT D'IMPORTER
 * STATIQUEMENT — liste FERMÉE, chacun avec sa raison.
 *
 * Pourquoi une liste d'AUTORISÉS et non d'interdits : une liste d'interdits qui
 * oublie une entrée est AVEUGLE, et c'est précisément ce qui s'est produit. La
 * garde d'origine s'arrêtait aux specifiers `node:*` ; elle ne suivait rien
 * au-delà d'un nom de paquet, donc `web-push` — qui tire `jws`, dont trois
 * modules appellent `util.inherits(…)` AU CHARGEMENT — franchissait le contrôle
 * sans être vu. Résultat : 27 tests e2e authentifiés rouges six nuits de suite,
 * sur `util.inherits is not a function`, pendant que `tsc`, le lint,
 * `build:check` et CETTE garde restaient verts (#909).
 *
 * À l'inverse, une liste d'autorisés qui oublie une entrée est BRUYANTE : le
 * nouvel import rougit, quelqu'un décide, et la décision s'écrit ici. C'est la
 * même posture que `harness/controls.json` (#937) — on déclare, avec un pourquoi.
 *
 * ⚠️ Ce contrôle ne modélise PAS la résolution de Vite (conditions `browser` vs
 * `node`, champ `browser`, sous-chemins). Il ne peut donc pas DÉDUIRE qu'un
 * paquet est sûr : il exige qu'on l'ait constaté et écrit.
 *
 * La règle ne s'applique qu'aux `*.server.ts` : c'est là que vit le code
 * Node-only par convention (AGENTS.md), et les trois incidents (#906, #942,
 * #909) sont tous passés par un de ces fichiers.
 */
export const PAQUETS_NAVIGATEUR_SUR: Record<string, string> = {
  zod: "schémas isomorphes — aucun builtin Node, tourne tel quel dans le navigateur",
  "@tanstack/react-start":
    "le framework lui-même ; c'est lui qui sert le module au navigateur, et Vite en résout l'entrée client",
  "@supabase/supabase-js":
    "client isomorphe, publié avec une entrée navigateur — c'est déjà celui qu'utilise le code client",
};

/** Le nom de paquet d'un specifier npm (`@scope/nom/sous/chemin` → `@scope/nom`). */
export function nomDePaquet(spec: string): string {
  const parts = spec.split("/");
  return spec.startsWith("@") ? parts.slice(0, 2).join("/") : (parts[0] as string);
}

/** Un specifier qui désigne un paquet npm — ni relatif, ni l'alias `@/` du dépôt. */
function estPaquetNpm(spec: string): boolean {
  return !spec.startsWith(".") && !spec.startsWith("@/") && !BUILTIN.test(spec);
}

/**
 * Les entrées dont un builtin — ou un paquet npm non déclaré sûr, importé
 * statiquement par un `*.server.ts` — est atteignable, avec la chaîne qui y mène.
 */
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
      const serveur = /\.server\.tsx?$/.test(f);
      for (const spec of staticImports(source)) {
        const paquetInterdit =
          serveur && estPaquetNpm(spec) && !(nomDePaquet(spec) in PAQUETS_NAVIGATEUR_SUR);
        if (BUILTIN.test(spec) || paquetInterdit) {
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

  it("aucun `*.server.ts` du graphe client n'importe un paquet npm non déclaré sûr", () => {
    const entrees = [...tsFiles(join(SRC, "routes")), join(SRC, "router.tsx")];
    // Même appel que ci-dessus : la règle « paquet npm » vit dans le même
    // parcours, parce que c'est le MÊME graphe qui doit être propre. Ce test
    // existe pour nommer la seconde propriété — un rouge doit dire laquelle.
    expect(entreesEmpoisonnees(SRC, entrees)).toEqual([]);
  });

  it("la garde voit un paquet Node-only derrière son nom — contrôle négatif", () => {
    const root = mkdtempSync(join(tmpdir(), "client-graph-npm-"));
    try {
      mkdirSync(join(root, "routes"), { recursive: true });
      // `web-push` n'est pas déclaré sûr : c'est le paquet EXACT de #909, dont
      // `jws` appelle `util.inherits(…)` au chargement. La garde d'avant le
      // voyait passer sans rien dire — elle s'arrêtait au nom de paquet.
      writeFileSync(join(root, "routes", "casse.tsx"), 'import { p } from "../push.server";\n');
      writeFileSync(
        join(root, "push.server.ts"),
        'import webpush from "web-push";\nexport const p = webpush;\n',
      );
      // Un paquet DÉCLARÉ sûr passe, dans le même fichier serveur.
      writeFileSync(join(root, "routes", "sain.tsx"), 'import { s } from "../ok.server";\n');
      writeFileSync(join(root, "ok.server.ts"), 'import { z } from "zod";\nexport const s = z;\n');
      // Le remède : le paquet chargé paresseusement n'est pas un import statique.
      writeFileSync(
        join(root, "routes", "paresseux.tsx"),
        'import { l } from "../lazy.server";\nexport default l;\n',
      );
      writeFileSync(
        join(root, "lazy.server.ts"),
        'export const l = async () => (await import("web-push")).default;\n',
      );
      // Un composant CLIENT (pas `.server.ts`) garde le droit d'importer ses
      // paquets d'interface : la règle vise la frontière serveur, pas React.
      writeFileSync(join(root, "routes", "client.tsx"), 'import { motion } from "motion/react";\n');

      const fautes = entreesEmpoisonnees(root, [
        join(root, "routes", "casse.tsx"),
        join(root, "routes", "sain.tsx"),
        join(root, "routes", "paresseux.tsx"),
        join(root, "routes", "client.tsx"),
      ]);
      expect(fautes).toHaveLength(1);
      expect(fautes[0]).toContain("casse.tsx");
      expect(fautes[0]).toContain("web-push");
      expect(fautes[0]).toContain("push.server.ts");
    } finally {
      rmSync(root, { recursive: true, force: true });
    }
  });

  it("chaque paquet déclaré sûr porte sa raison", () => {
    for (const [paquet, pourquoi] of Object.entries(PAQUETS_NAVIGATEUR_SUR)) {
      expect(pourquoi.length, `${paquet} sans raison`).toBeGreaterThan(20);
    }
  });

  it("le nom de paquet se lit sur un sous-chemin, scopé ou non", () => {
    expect(nomDePaquet("zod")).toBe("zod");
    expect(nomDePaquet("motion/react")).toBe("motion");
    expect(nomDePaquet("@tanstack/react-start")).toBe("@tanstack/react-start");
    expect(nomDePaquet("@tanstack/react-start/server")).toBe("@tanstack/react-start");
  });
});
