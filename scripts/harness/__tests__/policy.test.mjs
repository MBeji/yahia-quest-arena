// @vitest-environment node
import { describe, expect, it } from "vitest";

import { checkPolicyReasons } from "../check.mjs";
import { readSources } from "../sync.mjs";

const { policy } = readSources();

/** Les dénis qui existaient AVANT l'option C — la famille `cloud-autonomy` n'en retire aucun. */
const HISTORICAL_DENIES = [
  "Bash(npx supabase db push:*)",
  "Bash(npx supabase db reset:*)",
  "Bash(supabase db push:*)",
  "Bash(supabase db reset:*)",
  "Bash(gh workflow run db-migrate-prod.yml:*)",
  "Bash(gh workflow run release.yml:*)",
  "Bash(node scripts/db/push-prod.mjs:*)",
  "Bash(gh secret delete:*)",
];

describe("harness/policy.json — la famille cloud-autonomy (étude cloud-first, lot 2, option C)", () => {
  it("autorise tout Bash, tout le serveur MCP github, les sessions cloud et Google Drive", () => {
    expect(policy.allow["cloud-autonomy"]).toEqual([
      "Bash",
      "mcp__github",
      "mcp__Claude_Code_Remote",
      "mcp__Google_Drive",
    ]);
  });

  it("garde les huit dénis historiques, chacun avec sa raison — l'option C n'en retire aucun", () => {
    const rules = policy.deny.map((d) => d.rule);
    for (const rule of HISTORICAL_DENIES) expect(rules).toContain(rule);
    for (const d of policy.deny) expect(d.reason.trim().length).toBeGreaterThan(20);
  });

  it("n'ajoute aucun déni MCP : un déni gagnerait sur l'allow, et l'option C n'en veut pas", () => {
    expect(policy.deny.some((d) => d.rule.startsWith("mcp__"))).toBe(false);
  });

  it("porte sa raison datée dans allow.$why, comme harness:check l'exige", () => {
    expect(checkPolicyReasons(policy)).toEqual([]);
    expect(policy.allow.$why["cloud-autonomy"]).toMatch(/2026-09-05/);
  });

  it("fait démarrer les sessions en acceptEdits — sans classifieur, ce sont ces règles qui décident", () => {
    expect(policy.mode.default).toBe("acceptEdits");
    expect(policy.mode.$comment).toMatch(/2026-09-05/);
  });

  it("nomme des serveurs entiers, sans joker — un joker non ancré est ignoré par l'outil", () => {
    for (const rule of policy.allow["cloud-autonomy"]) expect(rule).not.toMatch(/\*/);
  });
});
