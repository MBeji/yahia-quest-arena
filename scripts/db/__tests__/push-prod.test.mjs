import { describe, it, expect } from "vitest";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { assertProdDbUrl, localMigrationVersions, PROD_REF, TEST_REF } from "../push-prod.mjs";

// The prod-migration tooling fails CLOSED: it only runs when the connection
// string unambiguously targets production. These are the safety net for that.
const HOST = "aws-0-eu-west-1.pooler.supabase.com:5432/postgres";

describe("assertProdDbUrl", () => {
  it("accepts a URL carrying the prod ref", () => {
    const url = `postgresql://postgres.${PROD_REF}:pass@${HOST}`;
    expect(assertProdDbUrl(url)).toBe(url);
  });

  it("rejects an empty / missing URL", () => {
    expect(() => assertProdDbUrl("")).toThrow(/empty/i);
    expect(() => assertProdDbUrl(undefined)).toThrow(/empty/i);
  });

  it("refuses a URL that targets the TEST project", () => {
    expect(() => assertProdDbUrl(`postgresql://postgres.${TEST_REF}:pass@${HOST}`)).toThrow(/TEST/);
  });

  it("refuses a URL with no known prod ref (wrong database)", () => {
    expect(() => assertProdDbUrl(`postgresql://postgres.someotherref:pass@${HOST}`)).toThrow(
      /prod ref/,
    );
  });

  it("prod and test refs are distinct (no overlap)", () => {
    expect(PROD_REF).not.toBe(TEST_REF);
  });
});

describe("localMigrationVersions", () => {
  it("reads ascending, unique 14-digit versions from the real migrations dir", () => {
    const dir = resolve(
      dirname(fileURLToPath(import.meta.url)),
      "..",
      "..",
      "..",
      "supabase",
      "migrations",
    );
    const versions = localMigrationVersions(dir);
    expect(versions.length).toBeGreaterThan(50);
    expect(versions).toEqual([...versions].sort());
    expect(new Set(versions).size).toBe(versions.length);
    expect(versions.every((v) => /^\d{14}$/.test(v))).toBe(true);
  });
});
