// Vite config — de-vendored from @lovable.dev/vite-tanstack-config.
//
// This inlines exactly the plugins + settings the (removed) Lovable meta-plugin
// assembled, MINUS its editor/sandbox-only pieces (componentTagger, hmr-gate,
// dev-server bridge, dev SSR/server-fn error overlays) which only ran inside the
// Lovable editor and are inert here. Load-bearing parts kept verbatim:
//   - VITE_* env injection via loadEnv → `define` (inlined into BOTH the client
//     and the Cloudflare-Worker SSR bundle — carries Supabase/Sentry/VAPID; do
//     not drop or prod env wiring breaks).
//   - @cloudflare/vite-plugin (build only) → produces the Worker bundle that
//     scripts/build-vercel.mjs repackages into the Vercel function. The whole
//     deploy pipeline depends on it; removing it is a separate lot (GAP-007).
//   - tanstackStart: server entry → src/server.ts (our SSR 500 wrapper) +
//     importProtection tuned so the app's pervasive `*.server.ts` files build.
//   - React/Query dedupe, `@` alias, dev server on :: / 8080 (Playwright + DX),
//     and the manualChunks split (i18n + vendor chunks, bundle-budget managed).
import { fileURLToPath } from "node:url";
import { cloudflare } from "@cloudflare/vite-plugin";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import tailwindcss from "@tailwindcss/vite";
import viteReact from "@vitejs/plugin-react";
import { defineConfig, loadEnv } from "vite";
import tsConfigPaths from "vite-tsconfig-paths";

export default defineConfig(({ command, mode }) => {
  // Inline VITE_*-prefixed env into every bundle (mirrors the meta-plugin).
  const env = loadEnv(mode, process.cwd(), "VITE_");
  const define = Object.fromEntries(
    Object.entries(env).map(([key, value]) => [`import.meta.env.${key}`, JSON.stringify(value)]),
  );

  return {
    define,
    resolve: {
      alias: {
        "@": fileURLToPath(new URL("./src", import.meta.url)),
      },
      dedupe: [
        "react",
        "react-dom",
        "react/jsx-runtime",
        "react/jsx-dev-runtime",
        "@tanstack/react-query",
        "@tanstack/query-core",
      ],
    },
    server: {
      host: "::",
      port: 8080,
      watch: {
        awaitWriteFinish: { stabilityThreshold: 1000, pollInterval: 100 },
      },
    },
    plugins: [
      tailwindcss(),
      tsConfigPaths({ projects: ["./tsconfig.json"] }),
      tanstackStart({
        importProtection: {
          behavior: "error",
          client: {
            files: ["**/server/**"],
            specifiers: ["server-only"],
          },
        },
        server: { entry: "server" },
      }),
      viteReact(),
      // Build only: the Cloudflare Worker bundle that build-vercel.mjs adapts.
      ...(command === "build" ? [cloudflare({ viteEnvironment: { name: "ssr" } })] : []),
    ],
    build: {
      rollupOptions: {
        output: {
          manualChunks(id) {
            // Locale catalogs (fr/en/ar) — one parallel-loaded, independently cached
            // chunk with its own budget, so growing the translations (GAP-010) never
            // eats the index chunk's budget. ONLY the pure-data catalogs: pulling the
            // provider/context/hooks in too made the chunk import React back from the
            // index chunk, creating an i18n⇄index cycle whose TDZ crash killed the
            // whole client bundle in production (login regression).
            if (/\/src\/lib\/i18n\/(fr|en|ar)\.ts$/.test(id)) return "i18n";
            if (!id.includes("node_modules")) return;

            if (id.includes("@tanstack/")) return "vendor-tanstack";
            // 3D landing scene — isolated, lazy-loaded chunk (kept out of index/budget).
            if (
              id.includes("/three/") ||
              id.includes("@react-three/") ||
              id.includes("postprocessing")
            )
              return "vendor-three";
            if (id.includes("lucide-react")) return "vendor-icons";
            if (id.includes("recharts") || id.includes("d3-")) return "vendor-charts";
            if (id.includes("motion")) return "vendor-motion";
            if (id.includes("@supabase/")) return "vendor-supabase";
            if (id.includes("@radix-ui/")) return "vendor-radix";

            return undefined;
          },
        },
      },
    },
  };
});
