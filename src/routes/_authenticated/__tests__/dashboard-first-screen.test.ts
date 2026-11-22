// @vitest-environment node
import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const ROOT = resolve(import.meta.dirname, "../../../..");
const DASHBOARD = readFileSync(resolve(ROOT, "src/routes/_authenticated/dashboard.tsx"), "utf-8");
const AVATAR = readFileSync(
  resolve(ROOT, "src/features/dashboard/components/hero-avatar.tsx"),
  "utf-8",
);

/**
 * Le premier écran du Hall, sur téléphone (constat du 2026-11-14, 390 × 844).
 *
 * L'en-tête du héros faisait 400 px et la carte de première visite 350 : le bouton
 * « Continuer » — la seule chose que la page demande de faire — commençait à 1 006 px,
 * hors de l'écran. L'ordre et la taille de ces trois blocs sont ce qui le ramène à 434 px.
 * Un test de source, faute de mise en page dans jsdom : il épingle l'ORDRE, pas un pixel.
 */
describe("Hall des héros — « Continuer » tient dans le premier écran", () => {
  it("la bande d'action précède la carte de première visite, qui l'explique", () => {
    const focus = DASHBOARD.indexOf("<DashboardFocus");
    const guide = DASHBOARD.indexOf('<GuideIntroCard screen="dashboard"');
    expect(focus).toBeGreaterThan(0);
    expect(guide).toBeGreaterThan(focus);
  });

  it("rien ne s'intercale entre l'en-tête du héros et la zone « Aujourd'hui »", () => {
    const hero = DASHBOARD.indexOf("{/* HERO HEADER */}");
    const today = DASHBOARD.indexOf("title={t.dashboard.zoneToday}");
    const between = DASHBOARD.slice(hero, today);
    expect(between).not.toContain("<GuideIntroCard");
  });

  it("la zone « Explorer » (les matières) suit l'en-tête du héros et précède « Aujourd'hui »", () => {
    const hero = DASHBOARD.indexOf("{/* HERO HEADER */}");
    const explore = DASHBOARD.indexOf('data-testid="dashboard-explore"');
    const today = DASHBOARD.indexOf("title={t.dashboard.zoneToday}");
    expect(hero).toBeGreaterThan(0);
    expect(explore).toBeGreaterThan(hero);
    expect(today).toBeGreaterThan(explore);
  });

  it("sur téléphone l'avatar se range à côté du nom : 56 px, 80 dès `sm`", () => {
    expect(AVATAR).toMatch(/size-14[^"`]*sm:size-20/);
    expect(DASHBOARD).toContain("grid-cols-[auto_1fr]");
  });

  it("la plus longue série se dit dans la langue de l'élève, pas « 3d »", () => {
    expect(DASHBOARD).not.toMatch(/longest_streak\}d\b/);
    expect(DASHBOARD).toMatch(/longest_streak > 1 \? t\.dashboard\.days : t\.dashboard\.day/);
  });
});
