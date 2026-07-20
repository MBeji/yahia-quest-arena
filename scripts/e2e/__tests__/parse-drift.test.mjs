import { describe, it, expect } from "vitest";
import { parseDriftedRevertVersions } from "../_env.mjs";

// Regression net for the nightly e2e-auth failure (issue #221): `supabase db
// push` aborts when the TEST project's history holds a migration version no
// longer present locally (here `20260628094836`, re-timestamped in #227). The
// CLI prints the exact repair command; setup-test-db.mjs auto-heals by parsing
// the versions it must mark `reverted`.
describe("parseDriftedRevertVersions", () => {
  const REAL_CLI_OUTPUT = [
    "Connecting to remote database...",
    "Remote migration versions not found in local migrations directory.",
    "",
    "Make sure your local git repo is up-to-date. If the error persists, try repairing the migration history table:",
    "supabase migration repair --status reverted 20260628094836",
    "",
    "And update local migrations to match remote database:",
    "supabase db pull",
  ].join("\n");

  it("extracts the version from the real CLI drift message", () => {
    expect(parseDriftedRevertVersions(REAL_CLI_OUTPUT)).toEqual(["20260628094836"]);
  });

  it("extracts and de-duplicates multiple reverted versions", () => {
    const out = [
      "supabase migration repair --status reverted 20260628094836",
      "supabase migration repair --status reverted 20260629093204",
      "supabase migration repair --status reverted 20260628094836",
    ].join("\n");
    expect(parseDriftedRevertVersions(out)).toEqual(["20260628094836", "20260629093204"]);
  });

  // The case the suite missed until the étude 24 corpus scission: the CLI lists
  // EVERY drifted version on ONE line. Capturing only the first left ~200
  // behind, so each run repaired one, retried once, and failed again — e2e-auth
  // could not reach a single test.
  it("extracts every version when the CLI lists them all on ONE line", () => {
    const out = [
      "Remote migration versions not found in local migrations directory.",
      "supabase migration repair --status reverted 20260602142000 20260602143000 20260602144000",
      "supabase db pull",
    ].join("\n");
    expect(parseDriftedRevertVersions(out)).toEqual([
      "20260602142000",
      "20260602143000",
      "20260602144000",
    ]);
  });

  it("never harvests digits from the line AFTER a one-line version run", () => {
    const out = [
      "supabase migration repair --status reverted 20260602142000",
      "20260602143000",
    ].join("\n");
    expect(parseDriftedRevertVersions(out)).toEqual(["20260602142000"]);
  });

  it("tolerates extra whitespace between tokens", () => {
    const out = "supabase migration repair   --status    reverted   20260628094836";
    expect(parseDriftedRevertVersions(out)).toEqual(["20260628094836"]);
  });

  it("never harvests `--status applied` versions (would mask missing DDL)", () => {
    const out = "supabase migration repair --status applied 20260628094836";
    expect(parseDriftedRevertVersions(out)).toEqual([]);
  });

  it("returns an empty list when there is no drift hint", () => {
    expect(parseDriftedRevertVersions("Applying migration 20260629210000...\nFinished.")).toEqual(
      [],
    );
  });

  it("handles empty / undefined input", () => {
    expect(parseDriftedRevertVersions("")).toEqual([]);
    expect(parseDriftedRevertVersions(undefined)).toEqual([]);
  });
});
