import { defineConfig } from "vitest/config";
import path from "path";

// `import.meta.dirname` plutôt que `__dirname` : Vite 8 avertit à chaque run que
// `configLoader: 'native'` — le futur défaut — ne sait pas fournir `__dirname`. Le
// paquet est `"type": "module"`, donc la forme ESM est la seule des deux qui vaudra
// encore quand le défaut basculera.
const here = import.meta.dirname;

export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve(here, "./src"),
    },
  },
  // Unit tests must stay hermetic: vitest runs in Vite mode "test", so a repo-root
  // `.env.test` (the DOCUMENTED e2e setup, see e2e/README.md) would otherwise be
  // loaded into import.meta.env (client.ts reads VITE_SUPABASE_URL). Point envDir
  // at a directory with no .env* files. The process.env channel of the same leak
  // (scripts' _env.mjs dotenv side effect) is purged in src/__tests__/setup.ts.
  envDir: path.resolve(here, "./src/__tests__"),
  test: {
    globals: true,
    // Le DÉFAUT est jsdom : la majorité des tests de composants en a besoin. Mais un
    // boot DOM coûte ~1,7 s par fichier, et il pesait l'essentiel du temps mural de la
    // suite — mesuré ici le 2026-08-26 sur 276 fichiers : `environment 475 s` pour un
    // `Duration` de 365 s. Une bonne moitié de ces fichiers ne touche pas au DOM.
    //
    // Un fichier sans DOM le déclare donc en PREMIÈRE ligne :
    //
    //     // @vitest-environment node
    //
    // 163 fichiers sur 276 le font (tous les `scripts/**` sauf le contrat du sanitizer
    // SVG, qui passe par DOMPurify). Résultat : 365 s -> 254 s, à décompte identique
    // (276 fichiers, 3 445 tests).
    //
    // Vitest 4 n'a plus `environmentMatchGlobs` ; le docblock est la voie supportée, et
    // il a l'avantage d'être lisible DANS le fichier concerné plutôt que dans un glob
    // ici. Se tromper échoue **bruyamment** (`document is not defined`), jamais en
    // silence — c'est ce qui rend la bascule sûre, et c'est ainsi que le seul fichier
    // mal classé de la passe s'est signalé.
    //
    // ⚠️ Avant de tagger : si le module sous test branche sur `typeof window`, le test
    // change de BRANCHE et pas seulement d'environnement. Vérifier qu'il teste encore
    // ce qu'il croit tester.
    environment: "jsdom",
    setupFiles: ["./src/__tests__/setup.ts"],
    // Several suites `await import("@/features/…")` INSIDE the test, so the
    // first-import transform/eval of a whole feature graph counts against the
    // test budget. On a loaded local machine (Windows) that regularly crosses
    // vitest's 5s default and made `npm run verify` flake on random files; CI
    // is unaffected. 15s changes no assertion — only the flake threshold.
    testTimeout: 15_000,
    // Same story one floor down: the `forks` pool starts ONE PROCESS per worker.
    // On the Windows dev box (16 cores, but ~4 GB free late in a session) they
    // stop STARTING at all — `Failed to start forks worker` / `Timeout waiting
    // for worker to respond` — whole files never run, and the survivors cross
    // the timeout above. It reads exactly like a regression on a diff that
    // touched no code. Measured 2026-08-24 on a docs-only diff: 16 workers → 16
    // pool errors, 4 → 3, 2 → clean (263 files, 3146 tests). Capping is NOT a
    // trade-off: 2 workers finished in 244s where 16 took 280-374s — the
    // contention cost more than the parallelism bought. CI has the memory and
    // keeps the default; VITEST_MAX_WORKERS overrides this (vitest applies it
    // after config resolution), e.g. `VITEST_MAX_WORKERS=8 npm test` on a
    // healthy box. See docs/agents/poste-windows.md § contention.
    ...(process.env.CI ? {} : { maxWorkers: 2 }),
    // scripts/** ships ops-critical helpers (DB-URL normalization, the TEST/PROD
    // ref guards) whose regressions only ever surfaced in the nightly — unit-test
    // them here alongside the app.
    include: ["src/**/*.{test,spec}.{ts,tsx}", "scripts/**/__tests__/*.test.mjs"],

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
