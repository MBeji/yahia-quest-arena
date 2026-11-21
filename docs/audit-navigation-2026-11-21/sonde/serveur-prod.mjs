// Serves the local PRODUCTION build (dist/) on 127.0.0.1:5198 — same wrapper as scripts/smoke/shell-smoke.mjs,
// plus request bodies (server fns) and long-cache headers on hashed assets, as the CDN does.
import http from "node:http";
import { readFile } from "node:fs/promises";
import { join, extname } from "node:path";
import { pathToFileURL } from "node:url";
const ROOT = join(import.meta.dirname, "../../..");
const PORT = 5198,
  ORIGIN = `http://127.0.0.1:${PORT}`;
const MIME = {
  ".js": "text/javascript",
  ".css": "text/css",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".woff2": "font/woff2",
  ".webmanifest": "application/manifest+json",
  ".html": "text/html",
  ".txt": "text/plain",
  ".json": "application/json",
};
const worker = (await import(pathToFileURL(join(ROOT, "dist/server/index.js")).href)).default;
http
  .createServer(async (req, res) => {
    const url = new URL(req.url, ORIGIN);
    try {
      if (url.pathname.startsWith("/assets/") || extname(url.pathname)) {
        try {
          const body = await readFile(join(ROOT, "dist/client", url.pathname));
          res.writeHead(200, {
            "content-type": MIME[extname(url.pathname)] ?? "application/octet-stream",
            "cache-control": url.pathname.startsWith("/assets/")
              ? "public, max-age=31536000, immutable"
              : "no-cache",
          });
          return res.end(body);
        } catch {}
      }
      const chunks = [];
      for await (const c of req) chunks.push(c);
      const init = { method: req.method, headers: { ...req.headers } };
      if (req.method !== "GET" && req.method !== "HEAD") init.body = Buffer.concat(chunks);
      const response = await worker.fetch(
        new Request(ORIGIN + req.url, init),
        {},
        { waitUntil: () => {} },
      );
      const headers = Object.fromEntries(response.headers);
      delete headers["content-encoding"];
      res.writeHead(response.status, headers);
      res.end(Buffer.from(await response.arrayBuffer()));
    } catch (error) {
      res.writeHead(500);
      res.end(String(error));
    }
  })
  .listen(PORT, "127.0.0.1", () => console.log("prod build on " + ORIGIN));
