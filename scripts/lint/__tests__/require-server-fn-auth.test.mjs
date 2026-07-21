import { RuleTester } from "eslint";
import { afterAll, describe, it } from "vitest";
import tseslint from "typescript-eslint";

import { requireServerFnAuth } from "../eslint-rules/require-server-fn-auth.mjs";

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

ruleTester.run("require-server-fn-auth", requireServerFnAuth, {
  valid: [
    // The two shipped auth middlewares — the exact shapes used across the 68 real
    // server fns (58 mandatory-auth, 10 public-first). Both must pass unchanged.
    {
      name: "requireSupabaseAuth",
      code: `createServerFn({ method: "POST" })
        .middleware([requireSupabaseAuth])
        .inputValidator((d) => schema.parse(d))
        .handler(async ({ data, context }) => ({ ok: true }));`,
    },
    {
      name: "optionalSupabaseAuth (public-first)",
      code: `createServerFn({ method: "GET" })
        .middleware([optionalSupabaseAuth])
        .handler(async ({ context }) => ({ ok: true }));`,
    },
    // Realistic TypeScript syntax (return-type annotation) must parse and pass.
    {
      name: "typed handler with return annotation",
      code: `export const getThing = createServerFn({ method: "GET" })
        .middleware([requireSupabaseAuth])
        .handler(async ({ context }): Promise<{ n: number }> => ({ n: 1 }));`,
    },
    // Auth middleware alongside another middleware — accepted if any is recognized.
    {
      name: "auth middleware combined with another",
      code: `createServerFn({ method: "POST" })
        .middleware([rateLimit, requireSupabaseAuth])
        .handler(async () => 1);`,
    },
    // Configurable allow-list: a project-specific auth middleware.
    {
      name: "custom authMiddleware option",
      code: `createServerFn({ method: "GET" }).middleware([myAuth]).handler(async () => 1);`,
      options: [{ authMiddleware: ["myAuth"] }],
    },
    // Incomplete / indirect chains: not analyzable → intentionally NOT reported.
    {
      name: "stored base (no .handler) is skipped",
      code: `const base = createServerFn({ method: "GET" });`,
    },
    {
      name: "middleware on a stored chain, handler elsewhere → skipped",
      code: `const withAuth = createServerFn({ method: "GET" }).middleware([whatever]);
        export const fn = withAuth.handler(async () => 1);`,
    },
    {
      name: "non-literal middleware argument is unverifiable → skipped",
      code: `createServerFn({ method: "POST" }).middleware(mws).handler(async () => 1);`,
    },
    // Unrelated calls must never trip the rule.
    {
      name: "unrelated call expression",
      code: `doSomething({ method: "POST" });`,
    },
    {
      name: "mock-style property definition is not a call",
      code: `const mod = { createServerFn: ({ method }) => chain };`,
    },
  ],

  invalid: [
    {
      name: "no middleware at all — naked server fn",
      code: `createServerFn({ method: "POST" }).handler(async ({ data }) => data);`,
      errors: [{ messageId: "missingMiddleware" }],
    },
    {
      name: "validator but no middleware",
      code: `createServerFn({ method: "POST" })
        .inputValidator((d) => schema.parse(d))
        .handler(async ({ data }) => data);`,
      errors: [{ messageId: "missingMiddleware" }],
    },
    {
      name: "empty middleware array",
      code: `createServerFn({ method: "GET" }).middleware([]).handler(async () => 1);`,
      errors: [{ messageId: "noAuthMiddleware" }],
    },
    {
      name: "non-auth middleware only",
      code: `createServerFn({ method: "POST" }).middleware([rateLimit]).handler(async () => 1);`,
      errors: [{ messageId: "noAuthMiddleware" }],
    },
    {
      name: "recognized name excluded by custom option",
      code: `createServerFn({ method: "GET" }).middleware([requireSupabaseAuth]).handler(async () => 1);`,
      options: [{ authMiddleware: ["myAuth"] }],
      errors: [{ messageId: "noAuthMiddleware" }],
    },
  ],
});
