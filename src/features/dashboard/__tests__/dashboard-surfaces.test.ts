import { describe, it, expect } from "vitest";
import { readFileSync, readdirSync } from "node:fs";
import { resolve } from "node:path";

const ROOT = resolve(import.meta.dirname, "../../../..");

/** Tous les fichiers de rendu du tableau de bord : la feature + sa route. */
function dashboardSources(): { path: string; text: string }[] {
  const dir = resolve(ROOT, "src/features/dashboard/components");
  const files = readdirSync(dir)
    .filter((f) => f.endsWith(".tsx"))
    .map((f) => resolve(dir, f));
  files.push(resolve(ROOT, "src/routes/_authenticated/dashboard.tsx"));
  return files.map((path) => ({ path, text: readFileSync(path, "utf-8") }));
}

describe("Surfaces du tableau de bord (levier 04)", () => {
  it("ne peint plus AUCUNE surface en noir littéral", () => {
    // Le thème clair les rattrapait par le remap `--color-black` de `.app-shell` ;
    // ce lot les fait passer par `surface-*`, donc l'écran ne dépend plus d'une
    // règle CSS de rattrapage pour être lisible.
    const offenders = dashboardSources()
      .filter(({ text }) => /\b(?:bg-black|text-black)(?:\/\d+)?\b/.test(text))
      .map(({ path }) => path.replace(ROOT, ""));
    expect(offenders).toEqual([]);
  });

  it("garde le voile des CTA en encre du bouton, pas en noir — il doit s'éclaircir avec elle", () => {
    const focus = dashboardSources().find(({ path }) => path.endsWith("dashboard-focus.tsx"));
    expect(focus?.text).toContain("bg-primary-foreground/15");
  });
});
