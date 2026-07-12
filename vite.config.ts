import { defineConfig, loadEnv, type PluginOption } from "vite";
import tailwindcss from "@tailwindcss/vite";
import tsConfigPaths from "vite-tsconfig-paths";
import viteReact from "@vitejs/plugin-react";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";

// Inlined replacement for the meta-plugin the original scaffold vendored — the project
// now has ZERO dependency on that boilerplate. This reproduces exactly what that plugin
// wired for the build: Tailwind, tsconfig path resolution, the Cloudflare Worker build
// (build-time only — it produces the `dist/server` Worker entry that `wrangler.jsonc`
// (`main: src/server.ts`) targets and `scripts/build-vercel.mjs` repackages for Vercel),
// TanStack Start (SSR; entry = our error-wrapping `src/server.ts`) and React — plus the
// same `VITE_*` env inlining into BOTH the client and the Worker bundles, the `@`→`src`
// alias and the React/TanStack-Query dedupe. The DEV-only extras it also added
// (sandbox bridge, HMR gate, component tagger, dev SSR/server-fn error overlays) are
// intentionally omitted: they only run under `vite serve` and never shipped in the build.
export default defineConfig(async ({ command, mode }) => {
  const plugins: PluginOption[] = [tailwindcss(), tsConfigPaths({ projects: ["./tsconfig.json"] })];

  // @cloudflare/vite-plugin only at build time (it owns the "ssr" Worker environment).
  if (command === "build") {
    const { cloudflare } = await import("@cloudflare/vite-plugin");
    plugins.push(cloudflare({ viteEnvironment: { name: "ssr" } }));
  }

  plugins.push(
    tanstackStart({
      importProtection: {
        behavior: "error",
        client: { files: ["**/server/**"], specifiers: ["server-only"] },
      },
      // Redirect the bundled server entry to src/server.ts (our SSR error wrapper).
      server: { entry: "server" },
    }),
    viteReact(),
  );

  // Inline VITE_* env vars into BOTH bundles (client + SSR/Worker), exactly as the former
  // meta-plugin did — e.g. VITE_SUPABASE_URL must be baked into the browser bundle.
  // loadEnv merges .env files with prefixed vars already present on process.env (Vercel/CI).
  const env = loadEnv(mode, process.cwd(), "VITE_");
  const define = Object.fromEntries(
    Object.entries(env).map(([key, value]) => [`import.meta.env.${key}`, JSON.stringify(value)]),
  );

  return {
    define,
    resolve: {
      alias: { "@": `${process.cwd()}/src` },
      dedupe: [
        "react",
        "react-dom",
        "react/jsx-runtime",
        "react/jsx-dev-runtime",
        "@tanstack/react-query",
        "@tanstack/query-core",
      ],
    },
    server: { host: "::", port: 8080 },
    plugins,
    build: {
      rollupOptions: {
        output: {
          manualChunks(id: string) {
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
            if (id.includes("motion")) return "vendor-motion";
            // Drag-&-drop runtime (B2 ordering/matching boards) — own cached
            // chunk with its own budget so it never eats the index budget (D-3).
            if (id.includes("@dnd-kit/")) return "vendor-dndkit";
            if (id.includes("@supabase/")) return "vendor-supabase";
            if (id.includes("@radix-ui/")) return "vendor-radix";

            return undefined;
          },
        },
      },
    },
  };
});
