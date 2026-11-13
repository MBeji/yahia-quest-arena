// @vitest-environment node
import { RuleTester } from "eslint";
import { afterAll, describe, it } from "vitest";
import tseslint from "typescript-eslint";

import { noSupabaseShadowView } from "../eslint-rules/no-supabase-shadow-view.mjs";

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
const FORMERLY_PENDING = "D:/repo/src/features/shop/shop.server.ts";

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
      // La liste d'attente de la naissance de la règle est vidée (2026-11-13) :
      // aucun fichier n'est plus exempté, un ancien comme un neuf.
      name: "un ancien fichier de la liste d'attente est jugé comme les autres",
      filename: FORMERLY_PENDING,
      code: `const client = context.supabase as unknown as { rpc: () => void };`,
      errors: [{ messageId: "shadowCast" }],
    },
  ],
});
