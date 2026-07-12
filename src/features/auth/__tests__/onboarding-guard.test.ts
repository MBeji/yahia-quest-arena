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
});
