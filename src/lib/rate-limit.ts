/**
 * Simple in-memory rate limiter using a sliding window.
 * Each key (e.g. userId) gets at most `maxRequests` per `windowMs`.
 * This is per-worker-instance and resets on deploy — sufficient for abuse prevention.
 */
const store = new Map<string, number[]>();

const MAX_STORE_SIZE = 5000;

export function isRateLimited(key: string, maxRequests: number, windowMs: number): boolean {
  const now = Date.now();
  const timestamps = store.get(key) ?? [];

  // Purge expired entries
  const valid = timestamps.filter((t) => now - t < windowMs);

  if (valid.length >= maxRequests) {
    store.set(key, valid);
    return true;
  }

  valid.push(now);
  store.set(key, valid);

  // Evict oldest keys if store grows too large
  if (store.size > MAX_STORE_SIZE) {
    const firstKey = store.keys().next().value;
    if (firstKey) store.delete(firstKey);
  }

  return false;
}
