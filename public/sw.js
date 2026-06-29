/**
 * Na9ra Nal3ab service worker — conservative, SSR/auth-safe.
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

// --- Web Push ----------------------------------------------------------------
// The cron sender posts a JSON payload: { title, body, url, tag }. We render a
// notification; clicking it focuses an existing tab (navigating it to `url`) or
// opens a new one. Kept defensive: a malformed/empty payload still shows a
// sane default rather than throwing inside the push event.
self.addEventListener("push", (event) => {
  let payload = {};
  try {
    payload = event.data ? event.data.json() : {};
  } catch {
    payload = {};
  }

  const title = payload.title || "Na9ra Nal3ab";
  const options = {
    body: payload.body || "",
    icon: "/icons/icon-192.png",
    badge: "/icons/icon-192.png",
    tag: payload.tag || "xp-scholars",
    data: { url: payload.url || "/" },
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const targetUrl = (event.notification.data && event.notification.data.url) || "/";

  event.waitUntil(
    (async () => {
      const allClients = await self.clients.matchAll({
        type: "window",
        includeUncontrolled: true,
      });
      for (const client of allClients) {
        if ("focus" in client) {
          await client.focus();
          if ("navigate" in client) {
            try {
              await client.navigate(targetUrl);
            } catch {
              // Navigation can reject (cross-origin / unsupported) — focusing is enough.
            }
          }
          return;
        }
      }
      if (self.clients.openWindow) await self.clients.openWindow(targetUrl);
    })(),
  );
});
