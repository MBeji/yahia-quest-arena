/**
 * ESLint rule: every `createServerFn(...)` must pass through a recognized auth
 * middleware.
 *
 * WHY THIS IS A SCRIPT, NOT AN AGENT (étude "IA → déterministe", lot L1b)
 * ---------------------------------------------------------------------------
 * The pre-commit agent hook used to eyeball the staged diff for "a server fn
 * without `requireSupabaseAuth`". That check is a pure AST shape — two runs on
 * the same input must give the same verdict — so it belongs in `npm run lint`,
 * where it runs for free, instantly, identically, at the commit, the pre-push
 * AND in CI, instead of once per commit at the cost of tokens + up to 180 s of
 * latency. This is the same reasoning already accepted for `guard-generated.mjs`.
 *
 * WHAT IT ENFORCES
 * ---------------------------------------------------------------------------
 * A complete inline definition — `createServerFn(...)….handler(…)` — must chain
 * a `.middleware([…])` whose array contains at least one recognized auth
 * middleware. The project ships exactly two, both a *deliberate* auth decision:
 *   - `requireSupabaseAuth`   — authentication mandatory (the default);
 *   - `optionalSupabaseAuth`  — PUBLIC-first, degrades to the `anon` role, RLS
 *                               still enforces reads (a conscious public choice).
 * A server fn with NO middleware is the bug this rule exists to catch: it is
 * exposed with no server-side auth gate at all ("server fn nue").
 *
 * WHY IT DOES NOT ENFORCE `.inputValidator`
 * ---------------------------------------------------------------------------
 * 27 of the 68 server fns legitimately take no input and carry no validator, so
 * requiring one everywhere would be 27 false positives — a *degradation* of the
 * gate for no gain. And TanStack Start already couples the two at the type level:
 * without `.inputValidator`, the handler's `data` is `undefined`, so consuming
 * input without validating it is already a `tsc` error. The validator is thus
 * covered by TypeScript + PR review; only the auth gate needs this AST rule.
 *
 * ZERO FALSE POSITIVES BY DESIGN
 * ---------------------------------------------------------------------------
 * The rule stays silent whenever it cannot see the whole picture: a chain that
 * does not end in `.handler` (result stored/passed and completed elsewhere), or
 * a `.middleware(arg)` whose argument is not a literal array of identifiers
 * (variable/spread — unverifiable statically). It reports only when it can prove
 * the auth middleware is absent. All 68 current server fns pass unchanged.
 */

const DEFAULT_AUTH_MIDDLEWARE = ["requireSupabaseAuth", "optionalSupabaseAuth"];

/** @type {import('eslint').Rule.RuleModule} */
export const requireServerFnAuth = {
  meta: {
    type: "problem",
    docs: {
      description:
        "Require every createServerFn(...) to chain a .middleware([...]) with a recognized auth middleware (requireSupabaseAuth or optionalSupabaseAuth).",
      recommended: true,
    },
    schema: [
      {
        type: "object",
        properties: {
          authMiddleware: {
            type: "array",
            items: { type: "string" },
            uniqueItems: true,
            minItems: 1,
          },
        },
        additionalProperties: false,
      },
    ],
    messages: {
      missingMiddleware:
        "createServerFn is exposed without a server-side auth gate: no .middleware([...]) in the chain. Add .middleware([...]) with one of: {{allowed}}.",
      noAuthMiddleware:
        "createServerFn().middleware([...]) has no recognized auth middleware. Expected one of: {{allowed}}. Found: {{found}}.",
    },
  },

  create(context) {
    const options = context.options[0] ?? {};
    const allowed = new Set(options.authMiddleware ?? DEFAULT_AUTH_MIDDLEWARE);
    const allowedList = [...allowed].join(", ");

    return {
      CallExpression(node) {
        // Fire only on the innermost `createServerFn(...)` call. The outer
        // `.middleware(...)`, `.inputValidator(...)`, `.handler(...)` calls have a
        // MemberExpression callee, so they are skipped here.
        if (node.callee.type !== "Identifier" || node.callee.name !== "createServerFn") {
          return;
        }

        // Walk OUTWARD through the fluent chain built directly on this call,
        // collecting each `.<method>(...)` step.
        const chain = [];
        let current = node;
        for (;;) {
          const member = current.parent;
          if (!member || member.type !== "MemberExpression" || member.object !== current) break;
          const call = member.parent;
          if (!call || call.type !== "CallExpression" || call.callee !== member) break;
          if (member.property.type === "Identifier") {
            chain.push({ name: member.property.name, call });
          }
          current = call;
        }

        // Only analyze a COMPLETE inline definition (ends in `.handler`). If the
        // result is stored/passed and finished elsewhere we cannot see the whole
        // chain — stay silent to guarantee zero false positives.
        if (!chain.some((step) => step.name === "handler")) return;

        const middlewareCalls = chain
          .filter((step) => step.name === "middleware")
          .map((step) => step.call);

        if (middlewareCalls.length === 0) {
          context.report({ node, messageId: "missingMiddleware", data: { allowed: allowedList } });
          return;
        }

        // Inspect the middleware array(s). We only ever report when we can PROVE no
        // recognized auth middleware is present — i.e. every argument is an array
        // literal of plain identifiers, none of them recognized. Anything we cannot
        // resolve statically (a `.middleware(variable)`, a `[...spread]`, or a
        // non-identifier element like `[obj.authMw]`) marks the chain unverifiable and
        // we stay silent, guaranteeing zero false positives.
        let unresolvable = false;
        const found = [];
        for (const call of middlewareCalls) {
          const arg = call.arguments[0];
          if (!arg || arg.type !== "ArrayExpression") {
            unresolvable = true;
            continue;
          }
          for (const element of arg.elements) {
            if (!element) continue; // array hole (elision) — ignore
            if (element.type === "Identifier") {
              found.push(element.name);
              if (allowed.has(element.name)) return; // recognized auth middleware present → OK
            } else {
              unresolvable = true; // spread / call / member expression — cannot resolve
            }
          }
        }

        if (unresolvable) return;

        context.report({
          node,
          messageId: "noAuthMiddleware",
          data: {
            allowed: allowedList,
            found: found.length ? found.join(", ") : "(none)",
          },
        });
      },
    };
  },
};

export default requireServerFnAuth;
