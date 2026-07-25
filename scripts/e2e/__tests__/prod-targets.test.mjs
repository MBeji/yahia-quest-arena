import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

import {
  findProdTarget,
  PROD_APP_HOSTS,
  PROD_SUPABASE_REF,
  prodTargetReason,
} from "../../shared/prod-targets.mjs";

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..", "..");

const PROD_SUPABASE_URL = `https://${PROD_SUPABASE_REF}.supabase.co`;
const TEST_SUPABASE_URL = "https://pqegdnwdtbjtplcthxyp.supabase.co";

describe("prodTargetReason — the Supabase route", () => {
  it("catches the production project URL", () => {
    expect(prodTargetReason(PROD_SUPABASE_URL)).toBe("supabase");
  });

  it("catches a Postgres connection string carrying the prod ref", () => {
    expect(
      prodTargetReason(`postgresql://postgres.${PROD_SUPABASE_REF}:pw@aws.pooler.com:5432`),
    ).toBe("supabase");
  });

  it("lets the dedicated TEST project through", () => {
    expect(prodTargetReason(TEST_SUPABASE_URL)).toBeNull();
  });
});

describe("prodTargetReason — the deployed-app route (#614)", () => {
  // The vector that filed a real content_reports row in production: the Supabase
  // vars were TEST, but the browser was pointed at the prod deployment, whose SSR
  // layer writes with its own prod secrets.
  it("catches the production Vercel host", () => {
    expect(prodTargetReason("https://na9ranal3ab.vercel.app")).toBe("app");
  });

  it("catches the custom domain, path and all", () => {
    expect(prodTargetReason("https://na9ranal3ab.tn/parcours/math-9eme")).toBe("app");
  });

  it("catches a bare host with no scheme", () => {
    expect(prodTargetReason("na9ranal3ab.vercel.app")).toBe("app");
  });

  it("ignores the port", () => {
    expect(prodTargetReason("https://na9ranal3ab.tn:443/")).toBe("app");
  });

  it("does NOT catch a Vercel preview deployment", () => {
    // Previews are legitimate e2e targets — matching `na9ranal3ab` as a substring
    // would ban them and push runs back onto localhost-only coverage.
    expect(prodTargetReason("https://na9ranal3ab-abc123.vercel.app")).toBeNull();
  });

  it("does NOT catch localhost", () => {
    expect(prodTargetReason("http://localhost:8080")).toBeNull();
  });

  it("does NOT catch a lookalike host", () => {
    expect(prodTargetReason("https://na9ranal3ab.tn.evil.test")).toBeNull();
  });
});

describe("findProdTarget", () => {
  it("returns null when every value is clean", () => {
    expect(
      findProdTarget([TEST_SUPABASE_URL, "http://localhost:8080", undefined, null]),
    ).toBeNull();
  });

  it("returns the first offender with its reason", () => {
    const hit = findProdTarget([
      TEST_SUPABASE_URL,
      "https://na9ranal3ab.vercel.app",
      PROD_SUPABASE_URL,
    ]);
    expect(hit).toEqual({ value: "https://na9ranal3ab.vercel.app", reason: "app" });
  });

  it("survives non-string values without throwing", () => {
    expect(findProdTarget([undefined, null, "", 42])).toBeNull();
  });
});

describe("no guard keeps its own copy of what production is", () => {
  // The prod ref used to be copy-pasted in six files, each with a "keep in sync"
  // comment. Five now import the shared module; k6 runs outside Node and cannot,
  // so its copy is asserted here instead of merely being promised in a comment.
  it("the k6 load suite mirrors the canonical ref", () => {
    const k6Config = readFileSync(resolve(repoRoot, "perf/k6/lib/config.js"), "utf8");
    const literal = /const PROD_REF = "([^"]+)"/.exec(k6Config)?.[1];
    expect(literal).toBe(PROD_SUPABASE_REF);
  });

  it("no Node-side guard redeclares the ref locally", () => {
    const guards = [
      "playwright.config.ts",
      "scripts/e2e/_env.mjs",
      "scripts/e2e/reset-gameplay.mjs",
      "scripts/perf/mint-load-tokens.mjs",
      "scripts/db/push-prod.mjs",
    ];
    const offenders = guards.filter((file) =>
      readFileSync(resolve(repoRoot, file), "utf8").includes(`"${PROD_SUPABASE_REF}"`),
    );
    expect(offenders).toEqual([]);
  });
});

describe("PROD_APP_HOSTS", () => {
  it("covers the deployment that serves production today", () => {
    expect(PROD_APP_HOSTS).toContain("na9ranal3ab.vercel.app");
  });

  it("already covers the custom domain, wired or not", () => {
    expect(PROD_APP_HOSTS).toContain("na9ranal3ab.tn");
  });
});
