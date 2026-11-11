// @vitest-environment node
import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const ROOT = resolve(import.meta.dirname, "../..");
const CSS = readFileSync(resolve(ROOT, "src/styles.css"), "utf-8");
const CHIPS = readFileSync(
  resolve(ROOT, "src/features/dashboard/components/hero-stat-chips.tsx"),
  "utf-8",
);
const STEPPER = readFileSync(resolve(ROOT, "src/components/guide/chapter-steps.tsx"), "utf-8");

/**
 * Contraste des tokens de THÈME, mesuré dans `verify`.
 *
 * Pourquoi ici et pas dans l'e2e a11y : axe ne tourne qu'en nightly et ne visite
 * que deux pages. Il a mis cinq nuits à signaler que `--flame` était resté clair
 * dans le thème clair (3,02:1 sur la puce de série du tableau de bord, issue
 * #733) — alors que la faute était lisible dans la feuille de style. Ce test la
 * lit, la calcule, et échoue AVANT la fusion.
 */

/** Bloc `{ … }` d'un sélecteur, sans les blocs imbriqués (il n'y en a pas ici). */
function block(selector: string): string {
  const start = CSS.indexOf(`${selector} {`);
  expect(start, `sélecteur ${selector} introuvable`).toBeGreaterThan(-1);
  return CSS.slice(start, CSS.indexOf("\n}", start));
}

/** Valeur brute d'un custom property dans un bloc. */
function token(css: string, name: string): string {
  const m = css.match(new RegExp(String.raw`\n\s*${name}:\s*([^;]+);`));
  expect(m, `${name} non défini`).not.toBeNull();
  return m![1].trim();
}

type RGB = [number, number, number];

const srgb = (x: number) => (x <= 0.0031308 ? 12.92 * x : 1.055 * x ** (1 / 2.4) - 0.055);
const clamp = (x: number) => Math.min(1, Math.max(0, x));

/** oklch(L C H) | #rrggbb → sRGB 0-255. Oklab, Björn Ottosson. */
function parseColor(value: string): RGB {
  const hex = value.match(/^#([0-9a-f]{6})$/i);
  if (hex) {
    const n = parseInt(hex[1], 16);
    return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
  }
  const ok = value.match(/^oklch\(\s*([\d.]+)\s+([\d.]+)\s+([\d.]+)/);
  expect(ok, `couleur non gérée : ${value}`).not.toBeNull();
  const [L, C, h] = [Number(ok![1]), Number(ok![2]), (Number(ok![3]) * Math.PI) / 180];
  const a = C * Math.cos(h);
  const b = C * Math.sin(h);
  const l = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3;
  const m = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3;
  const s = (L - 0.0894841775 * a - 1.291485548 * b) ** 3;
  return [
    4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.707614701 * s,
  ].map((v) => Math.round(srgb(clamp(v)) * 255)) as RGB;
}

/** Alpha d'une couleur `oklch(L C H / a)` — 1 si elle est opaque. */
function alphaOf(value: string): number {
  const m = value.match(/\/\s*([\d.]+)\s*\)$/);
  return m ? Number(m[1]) : 1;
}

/** Composite `fg` à `alpha` sur `bg` — ce que le navigateur peint pour `/20`. */
const over = (fg: RGB, alpha: number, bg: RGB): RGB =>
  fg.map((v, i) => Math.round(alpha * v + (1 - alpha) * bg[i])) as RGB;

function luminance([r, g, b]: RGB): number {
  const [R, G, B] = [r, g, b].map((v) => {
    const c = v / 255;
    return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
  });
  return 0.2126 * R + 0.7152 * G + 0.0722 * B;
}

function contrast(a: RGB, b: RGB): number {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}

/** WCAG 2 AA, texte normal. Les 14 px gras de la puce n'atteignent pas le seuil « large ». */
const AA = 4.5;

describe("Contraste des tokens de thème", () => {
  const light = block("html.reference");

  it("le texte flamme est lisible sur une carte du thème clair", () => {
    const ink = parseColor(token(light, "--flame-ink"));
    const card = parseColor(token(light, "--card"));
    expect(contrast(ink, card)).toBeGreaterThanOrEqual(AA);
  });

  it("le texte flamme est lisible sur la teinte de la puce de série (#733)", () => {
    // L'alpha est LU dans le composant : si la puce passe à /30, le seuil se
    // recalcule ici au lieu de mentir.
    const chip = CHIPS.match(/data-testid="stat-streak"[\s\S]{0,400}?className="([^"]+)"/);
    expect(chip, "puce stat-streak introuvable").not.toBeNull();
    const alpha = chip![1].match(/bg-\[color:var\(--flame\)\]\/(\d+)/);
    expect(alpha, "la puce n'est plus teintée en --flame").not.toBeNull();
    expect(chip![1]).toContain("text-flame-ink");

    const tint = over(
      parseColor(token(light, "--flame")),
      Number(alpha![1]) / 100,
      parseColor(token(light, "--card")),
    );
    expect(contrast(parseColor(token(light, "--flame-ink")), tint)).toBeGreaterThanOrEqual(AA);
  });

  it("les deux thèmes définissent --flame-ink — sans quoi l'un d'eux n'a plus de couleur de texte", () => {
    expect(token(block(":root"), "--flame-ink")).toBeTruthy();
    expect(token(light, "--flame-ink")).toBeTruthy();
  });
});

/**
 * Stepper de chapitre (#1191) : la surface et la couleur de texte de chaque état
 * sont LUES dans `STATE_CLASS`, puis le contraste est calculé dans les deux
 * thèmes. Le nightly axe ne voit qu'un seul état à la fois — celui que l'état de
 * jeu du compte de test met à l'écran — ; ce test les voit tous, à chaque `verify`.
 */
describe("Contraste du stepper de chapitre", () => {
  const themes = { clair: block("html.reference"), sombre: block(":root") };

  /** La carte peinte : composée sur `--background` quand elle est translucide (thème sombre). */
  function cardOf(theme: string): RGB {
    const raw = token(theme, "--card");
    return over(parseColor(raw), alphaOf(raw), parseColor(token(theme, "--background")));
  }

  const states = [...STEPPER.matchAll(/^\s*(done|current|next|locked):\s*"([^"]+)"/gm)].map(
    ([, state, classes]) => ({ state, classes }),
  );

  it("lit les quatre états de STATE_CLASS", () => {
    expect(states.map((s) => s.state).sort()).toEqual(["current", "done", "locked", "next"]);
  });

  for (const [name, theme] of Object.entries(themes)) {
    for (const { state, classes } of states) {
      it(`l'état « ${state} » est lisible en thème ${name}`, () => {
        const bg = classes.match(/\bbg-([a-z-]+?)(?:\/(\d+))?(?:\s|$)/);
        const fg = classes.match(/\btext-([a-z-]+)(?:\s|$)/);
        expect(bg, `pas de fond pour ${state}`).not.toBeNull();
        expect(fg, `pas de couleur de texte pour ${state}`).not.toBeNull();

        const card = cardOf(theme);
        const surface = over(
          parseColor(token(theme, `--${bg![1]}`)),
          bg![2] ? Number(bg![2]) / 100 : 1,
          card,
        );
        const ink = parseColor(token(theme, `--${fg![1]}`));
        expect(contrast(ink, surface)).toBeGreaterThanOrEqual(AA);
      });
    }
  }

  it("aucun texte du stepper n'est éclairci par une opacité (4,41:1 à 90 % — #1191)", () => {
    expect(STEPPER).not.toMatch(/className=[^>]*\bopacity-\d+/);
  });
});
