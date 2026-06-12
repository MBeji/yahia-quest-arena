import { describe, it, expect } from "vitest";
import { normalizeDbUrl } from "../_env.mjs";

// Regression net for the nightly e2e-auth failure: `supabase db push` (Go)
// rejects a connection string whose password holds raw special characters
// ("invalid userinfo"). normalizeDbUrl must fix those and leave valid URLs
// untouched (idempotent).
describe("normalizeDbUrl", () => {
  const HOST = "aws-0-eu-west-1.pooler.supabase.com:5432/postgres";

  it("leaves an already-valid URL unchanged", () => {
    const url = `postgresql://postgres.ref:simplepass@${HOST}`;
    expect(normalizeDbUrl(url)).toBe(url);
  });

  it("percent-encodes raw special characters in the password", () => {
    expect(normalizeDbUrl(`postgresql://postgres.ref:p#a@ss w%rd@${HOST}`)).toBe(
      `postgresql://postgres.ref:p%23a%40ss%20w%25rd@${HOST}`,
    );
  });

  it("is idempotent on an already-encoded password", () => {
    const url = `postgresql://postgres.ref:p%23a%40ss%20w%25rd@${HOST}`;
    expect(normalizeDbUrl(url)).toBe(url);
  });

  it("keeps dots in the user untouched (pooler usernames)", () => {
    const out = normalizeDbUrl(`postgresql://postgres.wvgeyon:pa#ss@${HOST}`);
    expect(out.startsWith("postgresql://postgres.wvgeyon:")).toBe(true);
  });

  it("handles URLs without userinfo or empty input", () => {
    expect(normalizeDbUrl(`postgresql://${HOST}`)).toBe(`postgresql://${HOST}`);
    expect(normalizeDbUrl("")).toBe("");
    expect(normalizeDbUrl(undefined)).toBe(undefined);
  });
});
