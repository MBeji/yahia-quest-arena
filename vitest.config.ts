import { defineConfig } from "vitest/config";
import path from "path";

export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  // Unit tests must stay hermetic: vitest runs in Vite mode "test", so a repo-root
  // `.env.test` (the DOCUMENTED e2e setup, see e2e/README.md) would otherwise be
  // loaded into import.meta.env (client.ts reads VITE_SUPABASE_URL). Point envDir
  // at a directory with no .env* files. The process.env channel of the same leak
  // (scripts' _env.mjs dotenv side effect) is purged in src/__tests__/setup.ts.
  envDir: path.resolve(__dirname, "./src/__tests__"),
  test: {
    globals: true,
    environment: "jsdom",
    setupFiles: ["./src/__tests__/setup.ts"],
    // scripts/** ships ops-critical helpers (DB-URL normalization, the TEST/PROD
    // ref guards) whose regressions only ever surfaced in the nightly — unit-test
    // them here alongside the app.
    include: ["src/**/*.{test,spec}.{ts,tsx}", "scripts/**/__tests__/*.test.mjs"],
    exclude: ["src/__tests__/deprecated/**"],
    coverage: {
      provider: "v8",
      reporter: ["text", "json-summary", "html"],
      // Coverage is scoped to the code we own and want protected: feature logic,
      // shared utilities/integrations, i18n, and hooks. Vendored shadcn UI
      // primitives, thin route wrappers, generated files, barrels, and SSR entry
      // glue are excluded — they are framework/vendor glue, exercised via build
      // and integration rather than unit-tested for line count.
      include: [
        "src/features/**/*.{ts,tsx}",
        "src/shared/**/*.{ts,tsx}",
        "src/lib/**/*.{ts,tsx}",
        "src/hooks/**/*.{ts,tsx}",
      ],
      exclude: [
        "src/**/*.{test,spec}.{ts,tsx}",
        "src/**/__tests__/**",
        "src/**/index.ts",
        "src/components/ui/**",
        "src/shared/integrations/supabase/types.ts",
        "src/features/**/components/**",
      ],
      thresholds: {
        lines: 80,
        statements: 80,
        functions: 80,
        branches: 80,
      },
    },
  },
});
