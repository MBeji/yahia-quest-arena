// @vitest-environment node
import { describe, expect, it } from "vitest";
import { shouldRedirectToOnboarding } from "../onboarding-guard";

// The onboarding parcours picker is a STUDENT-only flow. The layout guard must
// only trap students without a parcours; parents/admins never enrol in a parcours
// so redirecting them would strand them forever (regression: parent linked via
// alliance code could never reach /parent-report).
describe("shouldRedirectToOnboarding", () => {
  const base = {
    hasProfile: true,
    role: "student" as string | null,
    currentParcoursId: null as string | null,
    pathname: "/dashboard",
  };

  it("redirects a student with no active parcours", () => {
    expect(shouldRedirectToOnboarding(base)).toBe(true);
  });

  it("does NOT redirect a student who already picked a parcours", () => {
    expect(shouldRedirectToOnboarding({ ...base, currentParcoursId: "concours-9eme" })).toBe(false);
  });

  it("does NOT redirect a parent (no parcours by design)", () => {
    expect(shouldRedirectToOnboarding({ ...base, role: "parent" })).toBe(false);
  });

  it("does NOT redirect an admin (no parcours by design)", () => {
    expect(shouldRedirectToOnboarding({ ...base, role: "admin" })).toBe(false);
  });

  it("does NOT redirect while the profile is still unknown", () => {
    expect(shouldRedirectToOnboarding({ ...base, hasProfile: false, role: null })).toBe(false);
  });

  it("does NOT redirect when already on /onboarding (no loop)", () => {
    expect(shouldRedirectToOnboarding({ ...base, pathname: "/onboarding" })).toBe(false);
  });

  // Étude 38, lot 2 (R-5) — l'accueil n'est plus un péage : la quête demandée se joue.
  describe("étude 38 lot 2 — la quête demandée est épargnée", () => {
    it("does NOT redirect a student with no parcours away from a quest", () => {
      expect(
        shouldRedirectToOnboarding({
          ...base,
          pathname: "/quest/6e7219be-5c5a-586e-bedd-318a6262ec8f",
        }),
      ).toBe(false);
    });

    // D-3 : SEULE la quête est épargnée. Le hall, l'arène, la boutique supposent un
    // parcours ; y laisser entrer un élève sans classe, c'est lui montrer un écran vide.
    it.each(["/dashboard", "/arene", "/boutique", "/parcours", "/examens", "/dungeon"])(
      "still redirects from %s",
      (pathname) => {
        expect(shouldRedirectToOnboarding({ ...base, pathname })).toBe(true);
      },
    );

    // Le préfixe est `/quest/`, barre comprise : une route voisine ne passe pas par accident.
    it("does not spare a look-alike path", () => {
      expect(shouldRedirectToOnboarding({ ...base, pathname: "/quests" })).toBe(true);
      expect(shouldRedirectToOnboarding({ ...base, pathname: "/quest" })).toBe(true);
    });
  });
});
