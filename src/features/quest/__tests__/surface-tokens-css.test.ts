import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const CSS = readFileSync(resolve(import.meta.dirname, "../../../styles.css"), "utf-8");

/** Le corps d'un bloc de thème, commentaires retirés. */
function themeBody(selector: string): string {
  const stripped = CSS.replace(/\/\*[\s\S]*?\*\//g, "");
  const start = stripped.indexOf(`${selector} {`);
  expect(start, `bloc ${selector} introuvable`).toBeGreaterThanOrEqual(0);
  return stripped.slice(start, stripped.indexOf("}", start));
}

const SURFACE_TOKENS = [
  "--surface-1",
  "--surface-2",
  "--surface-3",
  "--media-scrim",
  "--ink-on-media",
];

describe("Tokens de surface (levier 03)", () => {
  // Le piège classique d'un design system à deux thèmes : une couleur définie
  // d'un seul côté rend l'encre d'un thème sur le fond de l'autre.
  it.each(SURFACE_TOKENS)("%s est défini dans le thème SOMBRE", (token) => {
    expect(themeBody(":root")).toContain(`${token}:`);
  });

  it.each(SURFACE_TOKENS)("%s est défini dans le thème RÉFÉRENCE", (token) => {
    expect(themeBody("html.reference")).toContain(`${token}:`);
  });

  it("expose les trois surfaces comme couleurs Tailwind (sinon `bg-surface-2` n'existe pas)", () => {
    const theme = CSS.slice(CSS.indexOf("@theme inline"), CSS.indexOf("Dark theme"));
    for (const level of [1, 2, 3]) {
      expect(theme).toContain(`--color-surface-${level}: var(--surface-${level})`);
    }
  });

  it("ne remappe plus le noir de Tailwind pour le lecteur : `.game-surface` a disparu", () => {
    // La rustine existait parce que le lecteur était écrit en `bg-black/<alpha>`.
    // Elle avait un effet de bord : elle repeignait aussi l'incrustation vidéo,
    // qui devenait de l'encre sombre sur un scrim sombre.
    expect(CSS).not.toContain(".game-surface");
  });

  it("garde le scrim vidéo NOIR dans les deux thèmes — une vidéo n'est pas une surface d'UI", () => {
    expect(themeBody(":root")).toContain("--media-scrim: oklch(0 0 0)");
    expect(themeBody("html.reference")).toContain("--media-scrim: oklch(0 0 0)");
  });

  it("dessine le clair au lieu de l'inverser : le creux y est plus SOMBRE que la carte", () => {
    // En Référence, `surface-1` (creux) est un blanc cassé teinté et `surface-3`
    // (carte) un blanc franc — l'élévation vient du filet et de l'ombre, jamais
    // d'un remplissage plus foncé comme le produisait le décalquage du sombre.
    const light = themeBody("html.reference");
    expect(light).toContain("--surface-1: oklch(0.972 0.008 165)");
    expect(light).toContain("--surface-3: oklch(1 0 0)");
  });
});

describe("Échelle de rareté (levier 02)", () => {
  const RARITIES = ["common", "rare", "epic", "legendary"];

  /** La teinte OKLCH d'un token de rareté (3e composante), ou null s'il manque. */
  function hueOf(theme: string, rarity: string): string | null {
    const match = themeBody(theme).match(new RegExp(`--rarity-${rarity}: oklch\\(([^)]+)\\)`));
    return match ? (match[1].trim().split(/\s+/)[2] ?? null) : null;
  }

  it.each(RARITIES)("--rarity-%s est défini dans le thème SOMBRE", (r) => {
    expect(themeBody(":root")).toContain(`--rarity-${r}:`);
  });

  it.each(RARITIES)("--rarity-%s est défini dans le thème RÉFÉRENCE", (r) => {
    expect(themeBody("html.reference")).toContain(`--rarity-${r}:`);
  });

  it.each([":root", "html.reference"])(
    "rompt le monochrome dans %s : quatre crans, quatre teintes",
    (theme) => {
      // Une échelle de rareté qui se lit d'un coup d'œil est ce qui donne sa
      // valeur à la collection ; la décliner en quatre ors la supprimerait.
      const hues = RARITIES.map((r) => hueOf(theme, r));
      expect(hues.every(Boolean)).toBe(true);
      expect(new Set(hues).size).toBe(4);
    },
  );
});
