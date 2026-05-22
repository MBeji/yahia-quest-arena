/**
 * Custom Vercel build script.
 *
 * Runs the standard Vite build (which targets Cloudflare Workers),
 * then restructures the output into the Vercel Build Output API v3 format
 * so the Worker entry is served as a Vercel Edge Function.
 */
import { execSync } from "node:child_process";
import { cpSync, mkdirSync, writeFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const ROOT = process.cwd();
const OUTPUT = join(ROOT, ".vercel", "output");

// Step 1 — Run Vite build (produces dist/client + dist/server)
console.log("▶ Running vite build...");
execSync("npx vite build", { stdio: "inherit", cwd: ROOT });

// Step 2 — Create Build Output API structure
console.log("▶ Structuring Vercel Build Output API v3...");

// Clean previous output
execSync(`rm -rf "${OUTPUT}"`, { stdio: "inherit", cwd: ROOT });

const STATIC_DIR = join(OUTPUT, "static");
const FUNC_DIR = join(OUTPUT, "functions", "index.func");

mkdirSync(STATIC_DIR, { recursive: true });
mkdirSync(FUNC_DIR, { recursive: true });

// Step 3 — Copy static assets (client build) → .vercel/output/static/
cpSync(join(ROOT, "dist", "client"), STATIC_DIR, { recursive: true });

// Step 4 — Copy server bundle → Edge Function directory
cpSync(join(ROOT, "dist", "server"), FUNC_DIR, { recursive: true });

// Step 4b — Ensure ESM resolution in the function directory
writeFileSync(
  join(FUNC_DIR, "package.json"),
  JSON.stringify({ type: "module" }, null, 2)
);

// Step 5 — Adapt Worker entry to Vercel Edge Function format
// Cloudflare Workers export { fetch(req, env, ctx) }
// Vercel Edge Functions export default function(request, context)
import { readFileSync } from "node:fs";
const originalEntry = readFileSync(join(FUNC_DIR, "index.js"), "utf8");
// Rename original to _worker.js
writeFileSync(join(FUNC_DIR, "_worker.js"), originalEntry);
// Create adapter entry
writeFileSync(
  join(FUNC_DIR, "index.js"),
  `import worker from "./_worker.js";
export default async function handler(request, context) {
  // Cloudflare Worker interface: worker.fetch(request, env, ctx)
  if (typeof worker === "function") return worker(request, context);
  if (typeof worker.fetch === "function") return worker.fetch(request, {}, { waitUntil: () => {} });
  // If default export is already a Response-returning function
  return new Response("Internal Server Error", { status: 500 });
}
`
);

// Step 6 — Write Serverless Function config (.vc-config.json)
// Use Node.js runtime (not Edge) because the Worker bundle uses node:stream, node:events
writeFileSync(
  join(FUNC_DIR, ".vc-config.json"),
  JSON.stringify(
    {
      runtime: "nodejs22.x",
      handler: "index.js",
      launcherType: "Nodejs",
      supportsResponseStreaming: true,
      maxDuration: 30,
    },
    null,
    2
  )
);

// Step 6 — Write global routing config
writeFileSync(
  join(OUTPUT, "config.json"),
  JSON.stringify(
    {
      version: 3,
      routes: [
        // Serve static assets directly (immutable cache for hashed filenames)
        {
          src: "/assets/(.*)",
          headers: { "Cache-Control": "public, max-age=31536000, immutable" },
          continue: true,
        },
        // Let existing static files be served as-is
        { handle: "filesystem" },
        // Everything else → Edge Function (SSR)
        { src: "/(.*)", dest: "/index" },
      ],
    },
    null,
    2
  )
);

console.log("✅ Vercel Build Output API v3 ready at .vercel/output/");
