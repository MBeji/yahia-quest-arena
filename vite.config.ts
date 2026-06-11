// @lovable.dev/vite-tanstack-config already includes the following — do NOT add them manually
// or the app will break with duplicate plugins:
//   - tanstackStart, viteReact, tailwindcss, tsConfigPaths, cloudflare (build-only),
//     componentTagger (dev-only), VITE_* env injection, @ path alias, React/TanStack dedupe,
//     error logger plugins, and sandbox detection (port/host/strictPort).
// You can pass additional config via defineConfig({ vite: { ... } }) if needed.
import { defineConfig } from "@lovable.dev/vite-tanstack-config";

// Redirect TanStack Start's bundled server entry to src/server.ts (our SSR error wrapper).
// @cloudflare/vite-plugin builds from this — wrangler.jsonc main alone is insufficient.
export default defineConfig({
  tanstackStart: {
    server: { entry: "server" },
  },
  vite: {
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
  },
});
