/**
 * Local ESLint plugin — project-specific invariants that are pure AST shapes and
 * therefore belong in the deterministic gate, not in an agent's judgement.
 *
 * Consumed by the flat config at the repo root (`eslint.config.js`) under the
 * `local/` namespace. Rules are co-located under `./` and unit-tested with
 * `RuleTester` in `scripts/lint/__tests__/`.
 */
import { requireServerFnAuth } from "./require-server-fn-auth.mjs";

/** @type {import('eslint').ESLint.Plugin} */
const plugin = {
  meta: { name: "eslint-plugin-local", version: "1.0.0" },
  rules: {
    "require-server-fn-auth": requireServerFnAuth,
  },
};

export default plugin;
