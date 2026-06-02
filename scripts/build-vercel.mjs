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
writeFileSync(join(FUNC_DIR, "package.json"), JSON.stringify({ type: "module" }, null, 2));

// Step 5 — Adapt Worker entry to Vercel Node.js Serverless Function format
// Cloudflare Workers export { fetch(req, env, ctx) } returning a Response
// Vercel Node.js functions use (req, res) IncomingMessage/ServerResponse
import { readFileSync } from "node:fs";
const originalEntry = readFileSync(join(FUNC_DIR, "index.js"), "utf8");
// Rename original to _worker.js
writeFileSync(join(FUNC_DIR, "_worker.js"), originalEntry);
// Create Node.js adapter entry
writeFileSync(
  join(FUNC_DIR, "index.js"),
  `import worker from "./_worker.js";

export default async function handler(req, res) {
  try {
    // Build a standard Request from Node.js IncomingMessage
    const proto = req.headers["x-forwarded-proto"] || "https";
    const host = req.headers["x-forwarded-host"] || req.headers.host || "localhost";
    const url = new URL(req.url, proto + "://" + host);

    const headers = new Headers();
    for (const [key, value] of Object.entries(req.headers)) {
      if (value) headers.set(key, Array.isArray(value) ? value.join(", ") : value);
    }

    const hasBody = req.method !== "GET" && req.method !== "HEAD";
    const body = hasBody ? req : undefined;

    const request = new Request(url.href, {
      method: req.method,
      headers,
      body,
      duplex: hasBody ? "half" : undefined,
    });

    // Call the Cloudflare Worker handler
    const response = await worker.fetch(request, {}, { waitUntil: () => {} });

    // Write the Response back to Node.js ServerResponse
    res.statusCode = response.status;
    response.headers.forEach((value, key) => {
      res.setHeader(key, value);
    });

    if (response.body) {
      const reader = response.body.getReader();
      while (true) {
        const { done, value: chunk } = await reader.read();
        if (done) break;
        res.write(chunk);
      }
    }
    res.end();
  } catch (error) {
    console.error("[Vercel Function Error]", error);
    res.statusCode = 500;
    res.setHeader("content-type", "text/plain");
    res.end("Internal Server Error");
  }
}
`,
);

// Step 6 — Write Serverless Function config (.vc-config.json)
writeFileSync(
  join(FUNC_DIR, ".vc-config.json"),
  JSON.stringify(
    {
      runtime: "nodejs22.x",
      handler: "index.js",
      launcherType: "Nodejs",
      maxDuration: 30,
    },
    null,
    2,
  ),
);

// Step 6 — Write global routing config
writeFileSync(
  join(OUTPUT, "config.json"),
  JSON.stringify(
    {
      version: 3,
      routes: [
        // Security headers on every response (then continue routing)
        {
          src: "/(.*)",
          headers: {
            "X-Content-Type-Options": "nosniff",
            "X-Frame-Options": "DENY",
            "Referrer-Policy": "strict-origin-when-cross-origin",
            "Strict-Transport-Security": "max-age=63072000; includeSubDomains; preload",
            "Permissions-Policy": "camera=(), microphone=(), geolocation=(), browsing-topics=()",
            "Content-Security-Policy": [
              "default-src 'self'",
              "script-src 'self' 'unsafe-inline'",
              "style-src 'self' 'unsafe-inline'",
              "img-src 'self' data: blob: https:",
              "font-src 'self' data:",
              "connect-src 'self' https://*.supabase.co wss://*.supabase.co",
              "frame-ancestors 'none'",
              "base-uri 'self'",
              "form-action 'self'",
              "object-src 'none'",
            ].join("; "),
          },
          continue: true,
        },
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
    2,
  ),
);

console.log("✅ Vercel Build Output API v3 ready at .vercel/output/");
