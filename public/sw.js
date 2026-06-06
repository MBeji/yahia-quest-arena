/**
 * XP Scholars service worker — conservative, SSR/auth-safe.
 *
 * - Immutable, content-hashed build assets (/assets/*) → cache-first (fast repeat
 *   visits, works offline once cached).
 * - Navigations (HTML) → network-only with an offline fallback page. HTML is NEVER
 *   cached, so SSR freshness and per-user auth state are never served stale.
 * - Everything else falls through to the network.
 *
 * Bump VERSION to invalidate old caches on deploy.
 */
const VERSION = "v1";
const ASSET_CACHE = `xp-assets-${VERSION}`;
const OFFLINE_CACHE = `xp-offline-${VERSION}`;
const OFFLINE_URL = "/offline.html";

self.addEventListener("install", (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(OFFLINE_CACHE);
      await cache.add(new Request(OFFLINE_URL, { cache: "reload" }));
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(keys.filter((k) => !k.endsWith(VERSION)).map((k) => caches.delete(k)));
      await self.clients.claim();
    })(),
  );
});

self.addEventListener("fetch", (event) => {
  const { request } = event;
  if (request.method !== "GET") return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return; // only same-origin

  // Immutable hashed assets → cache-first.
  if (url.pathname.startsWith("/assets/")) {
    event.respondWith(
      (async () => {
        const cache = await caches.open(ASSET_CACHE);
        const hit = await cache.match(request);
        if (hit) return hit;
        const res = await fetch(request);
        if (res.ok) cache.put(request, res.clone());
        return res;
      })(),
    );
    return;
  }

  // Navigations → network-only, offline page as a fallback (never cache HTML).
  if (request.mode === "navigate") {
    event.respondWith(
      (async () => {
        try {
          return await fetch(request);
        } catch {
          const cache = await caches.open(OFFLINE_CACHE);
          return (await cache.match(OFFLINE_URL)) ?? Response.error();
        }
      })(),
    );
  }
});
