import { describe, expect, it } from "vitest";
import { hubRouteForRole, shouldLeaveDashboard } from "../hub-route";

// Regression: the dashboard used to bounce BOTH admins and parents to
// /parent-report. Since /dashboard is the return target of the whole shell (logo,
// account chip, « Hall des héros », and the « Retour au hall » of every /admin
// console), an admin was thrown back to /parent-report from every exit — the
// navigation looped and the Hall was unreachable. Only the parent leaves.
describe("hubRouteForRole", () => {
  it("sends a parent to their family report", () => {
    expect(hubRouteForRole("parent")).toBe("/parent-report");
  });

  it("keeps an admin on the Heroes' Hall", () => {
    expect(hubRouteForRole("admin")).toBe("/dashboard");
  });

  it("keeps a student on the Heroes' Hall", () => {
    expect(hubRouteForRole("student")).toBe("/dashboard");
  });

  it("defaults to the Hall while the role is still unknown", () => {
    expect(hubRouteForRole(null)).toBe("/dashboard");
    expect(hubRouteForRole(undefined)).toBe("/dashboard");
  });
});

describe("shouldLeaveDashboard", () => {
  it("is true only for a parent", () => {
    expect(shouldLeaveDashboard("parent")).toBe(true);
  });

  it("is false for an admin — no bounce, no navigation loop", () => {
    expect(shouldLeaveDashboard("admin")).toBe(false);
  });

  it("is false for a student", () => {
    expect(shouldLeaveDashboard("student")).toBe(false);
  });

  it("does not fire before the profile is read", () => {
    expect(shouldLeaveDashboard(null)).toBe(false);
    expect(shouldLeaveDashboard(undefined)).toBe(false);
  });
});
