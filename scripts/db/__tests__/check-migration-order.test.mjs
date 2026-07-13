import { describe, it, expect } from "vitest";
import { versionOf, findOrderingViolations, VERSION_RE } from "../check-migration-order.mjs";

describe("versionOf", () => {
  it("extracts the 14-digit stamp from a bare filename", () => {
    expect(versionOf("20260629210000_push_subscriptions_revoke.sql")).toBe("20260629210000");
  });

  it("extracts the stamp from a full path", () => {
    expect(versionOf("supabase/migrations/20260522134120_init.sql")).toBe("20260522134120");
  });

  it("returns null for an untimestamped filename", () => {
    expect(versionOf("supabase/migrations/init.sql")).toBeNull();
    expect(versionOf("2026_short_stamp.sql")).toBeNull();
  });

  it("the VERSION_RE matches the real convention", () => {
    expect(VERSION_RE.test("20260101000000_x.sql")).toBe(true);
  });
});

describe("findOrderingViolations", () => {
  const base = ["20260601000000", "20260628120000", "20260629093204"];

  it("passes a migration that sorts after the newest on base", () => {
    const { maxBase, violations } = findOrderingViolations(base, [
      "20260629210000_new_feature.sql",
    ]);
    expect(maxBase).toBe("20260629093204");
    expect(violations).toEqual([]);
  });

  it("flags a back-dated migration (the #97 regression) as out-of-order", () => {
    // #97 added a 2026-06-13 migration while main was already at 2026-06-28.
    const { violations } = findOrderingViolations(base, [
      "20260613210000_push_subscriptions_revoke.sql",
    ]);
    expect(violations).toHaveLength(1);
    expect(violations[0]).toMatchObject({
      reason: "out-of-order",
      version: "20260613210000",
      maxBase: "20260629093204",
    });
  });

  it("flags a migration equal to the newest base version (would collide)", () => {
    const { violations } = findOrderingViolations(base, ["20260629093204_dup.sql"]);
    expect(violations).toHaveLength(1);
    expect(violations[0].reason).toBe("out-of-order");
  });

  it("flags an untimestamped migration", () => {
    const { violations } = findOrderingViolations(base, ["add_index.sql"]);
    expect(violations).toEqual([{ file: "add_index.sql", reason: "untimestamped" }]);
  });

  it("checks each added file independently (good + bad in the same PR)", () => {
    const { violations } = findOrderingViolations(base, [
      "20260630000000_ok.sql",
      "20260613210000_bad.sql",
    ]);
    expect(violations).toHaveLength(1);
    expect(violations[0].file).toBe("20260613210000_bad.sql");
  });

  it("accepts any timestamp when the base branch has no migrations yet", () => {
    const { maxBase, violations } = findOrderingViolations([], ["20200101000000_first.sql"]);
    expect(maxBase).toBeNull();
    expect(violations).toEqual([]);
  });

  it("does not assume base versions are pre-sorted", () => {
    const unsorted = ["20260629093204", "20260601000000", "20260628120000"];
    const { maxBase } = findOrderingViolations(unsorted, []);
    expect(maxBase).toBe("20260629093204");
  });
});
