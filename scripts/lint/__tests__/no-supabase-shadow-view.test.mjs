// @vitest-environment node
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

import { ESLint, RuleTester } from "eslint";
import { afterAll, describe, expect, it } from "vitest";
import tseslint from "typescript-eslint";

import { noSupabaseShadowView, PENDING_FILES } from "../eslint-rules/no-supabase-shadow-view.mjs";

// Wire ESLint's RuleTester into vitest's runner (it drives describe/it itself).
RuleTester.afterAll = afterAll;
RuleTester.describe = describe;
RuleTester.it = it;
RuleTester.itOnly = it.only;

const ruleTester = new RuleTester({
  languageOptions: {
    parser: tseslint.parser,
    ecmaVersion: 2022,
    sourceType: "module",
  },
});

const FEATURE = "D:/repo/src/features/dashboard/dashboard.server.ts";
const TEST_FILE = "D:/repo/src/features/dashboard/__tests__/dashboard.test.ts";
const PENDING = "D:/repo/src/features/shop/shop.server.ts";

ruleTester.run("no-supabase-shadow-view", noSupabaseShadowView, {
  valid: [
    {
      name: "le client généré s'appelle directement",
      filename: FEATURE,
      code: `const { data } = await context.supabase.rpc("get_daily_plan", { p_limit: 3 });`,
    },
    {
      name: "un paramètre typé par le client généré",
      filename: FEATURE,
      code: `async function read(supabase: SupabaseClient<Database>) { return supabase.rpc("x"); }`,
    },
    {
      name: "un double cast qui ne touche pas le client n'est pas son sujet",
      filename: FEATURE,
      code: `const row = payload as unknown as Row;`,
    },
    {
      name: "un simple `as` sur le client (rétrécissement sûr) passe",
      filename: FEATURE,
      code: `const reader = supabase as Pick<typeof supabase, "rpc">;`,
    },
    {
      name: "un faux client de test est partiel par nature",
      filename: TEST_FILE,
      code: `const client = { rpc } as unknown as Client; read(supabase as unknown as Client);`,
    },
    {
      name: "un fichier de la liste d'attente n'est pas encore jugé",
      filename: PENDING,
      code: `const client = context.supabase as unknown as { rpc: () => void };`,
    },
  ],
  invalid: [
    {
      name: "la forme canonique : `context.supabase as unknown as XRpcClient`",
      filename: FEATURE,
      code: `const client = context.supabase as unknown as DailyPlanRpcClient;`,
      errors: [{ messageId: "shadowCast" }],
    },
    {
      name: "le client de service, et une vue écrite en ligne",
      filename: FEATURE,
      code: `await (supabaseAdmin as unknown as { rpc: (fn: "x") => Promise<void> }).rpc("x");`,
      errors: [{ messageId: "shadowCast" }],
    },
    {
      name: "le client nu",
      filename: FEATURE,
      code: `const client = supabase as unknown as BadgeCatalogueClient;`,
      errors: [{ messageId: "shadowCast" }],
    },
    {
      name: "la forme discrète : un paramètre `supabase: unknown`",
      filename: FEATURE,
      code: `async function fetchPlan(supabase: unknown, limit: number) { return (supabase as Client).rpc("x"); }`,
      errors: [{ messageId: "unknownParam" }],
    },
    {
      name: "…y compris sur une fonction fléchée",
      filename: FEATURE,
      code: `const fetchPlan = async (supabaseAdmin: unknown) => supabaseAdmin;`,
      errors: [{ messageId: "unknownParam" }],
    },
    {
      name: "`ignorePending` juge aussi la liste d'attente",
      filename: PENDING,
      options: [{ ignorePending: true }],
      code: `const client = context.supabase as unknown as { rpc: () => void };`,
      errors: [{ messageId: "shadowCast" }],
    },
  ],
});

/**
 * LE CLIQUET. La liste d'attente ne peut que rétrécir : un fichier qui n'a plus
 * de violation doit en sortir, sinon il resterait exempté pour toujours et la
 * vue pourrait y revenir sans que personne ne le voie.
 */
describe("PENDING_FILES — une liste d'attente, pas une exemption", () => {
  const root = resolve(import.meta.dirname, "../../..");
  const eslint = new ESLint({
    cwd: root,
    overrideConfigFile: true,
    overrideConfig: [
      {
        files: ["**/*.ts"],
        languageOptions: { parser: tseslint.parser, ecmaVersion: 2022, sourceType: "module" },
        plugins: { local: { rules: { "no-supabase-shadow-view": noSupabaseShadowView } } },
        rules: { "local/no-supabase-shadow-view": ["error", { ignorePending: true }] },
      },
    ],
  });

  it.each(PENDING_FILES)("%s porte encore une vue d'ombre", async (file) => {
    const path = resolve(root, file);
    expect(existsSync(path), `${file} n'existe plus : le retirer de PENDING_FILES`).toBe(true);
    const [result] = await eslint.lintText(readFileSync(path, "utf8"), { filePath: path });
    const hits = result.messages.filter((m) => m.ruleId === "local/no-supabase-shadow-view");
    expect(hits.length, `${file} est propre : le retirer de PENDING_FILES`).toBeGreaterThan(0);
  });
});
