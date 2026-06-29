import js from "@eslint/js";
import eslintPluginPrettier from "eslint-plugin-prettier/recommended";
import globals from "globals";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import tseslint from "typescript-eslint";

export default tseslint.config(
  {
    ignores: [
      "dist",
      ".output",
      ".vinxi",
      "src/routeTree.gen.ts",
      "src/shared/integrations/supabase/types.ts",
    ],
  },
  {
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    plugins: {
      "react-hooks": reactHooks,
      "react-refresh": reactRefresh,
    },
    rules: {
      // eslint-plugin-react-hooks v7's `recommended` now bundles the React Compiler
      // rules (react-hooks/immutability, purity, set-state-in-effect, …). Those assume
      // you've adopted the React Compiler and flag valid, intentional patterns in this
      // codebase (R3F `useFrame` per-frame mutation, SSR-hydration `setState` in effect,
      // one-time `Math.random` particle init). Adopting them is a separate, deliberate
      // migration — not a side effect of a version bump — so we keep exactly the classic
      // hooks coverage we had on v5 (rules-of-hooks + exhaustive-deps).
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn",
      "no-restricted-imports": [
        "error",
        {
          paths: [
            {
              name: "server-only",
              message:
                "TanStack Start does not use the Next.js `server-only` package. Rename the module to `*.server.ts` or mark it with `@tanstack/react-start/server-only`.",
            },
          ],
        },
      ],
      "react-refresh/only-export-components": ["error", { allowConstantExport: true }],
      "@typescript-eslint/no-unused-vars": "off",
      "max-lines": ["error", { max: 750, skipBlankLines: true, skipComments: true }],
    },
  },
  {
    files: ["src/components/ui/**/*.{ts,tsx}"],
    rules: {
      "react-refresh/only-export-components": "off",
    },
  },
  {
    // TanStack Start route files must `export const Route = createFileRoute(...)`.
    // Newer eslint-plugin-react-refresh no longer treats that PascalCase const as a
    // component, so only-export-components flags the route's local component(s).
    // Route HMR is handled by the router, not Fast Refresh, so the rule is noise here.
    files: ["src/routes/**/*.{ts,tsx}"],
    rules: {
      "react-refresh/only-export-components": "off",
    },
  },
  eslintPluginPrettier,
);
