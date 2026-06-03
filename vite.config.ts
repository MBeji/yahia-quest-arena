// @lovable.dev/vite-tanstack-config already includes the following — do NOT add them manually
// or the app will break with duplicate plugins:
//   - tanstackStart, viteReact, tailwindcss, tsConfigPaths, VITE_* env injection,
//     @ path alias, React/TanStack dedupe, error logger plugins, and sandbox
//     detection (port/host/strictPort). (The Cloudflare plugin is opt-in and
//     disabled here — see `cloudflare: false` below.)
// You can pass additional config via defineConfig({ vite: { ... } }) if needed.
import { defineConfig } from "@lovable.dev/vite-tanstack-config";

// Deploy target: Vercel. `cloudflare: false` disables the Cloudflare worker
// plugin so `vite build` emits a portable web `fetch` handler at
// dist/server/server.js (our src/server.ts); scripts/build-vercel.mjs wraps it
// into a Vercel Build Output API v3 function. The server.entry redirect points
// TanStack Start's bundled SSR entry at src/server.ts (our branded-error wrapper).
export default defineConfig({
  cloudflare: false,
  tanstackStart: {
    server: { entry: "server" },
  },
  vite: {
    build: {
      rollupOptions: {
        output: {
          manualChunks(id) {
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
