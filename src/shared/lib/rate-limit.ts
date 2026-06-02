import { logger } from "./logger";

// Minimal structural shape the rate limiter needs from a Supabase client.
// Narrowed to the exact RPC it calls so the real typed client (and test mocks)
// are both assignable.
type RateLimitRpcClient = {
  rpc: (
    fn: "check_rate_limit",
    args: { p_key: string; p_max_requests: number; p_window_ms: number },
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

// Local fallback used when DB rate-limit RPC is unavailable.
const localStore = new Map<string, number[]>();
const MAX_LOCAL_STORE_SIZE = 5000;

export function isRateLimitedLocal(key: string, maxRequests: number, windowMs: number): boolean {
  const now = Date.now();
  const timestamps = localStore.get(key) ?? [];
  const valid = timestamps.filter((t) => now - t < windowMs);

  if (valid.length >= maxRequests) {
    localStore.set(key, valid);
    return true;
  }

  valid.push(now);
  localStore.set(key, valid);

  if (localStore.size > MAX_LOCAL_STORE_SIZE) {
    const firstKey = localStore.keys().next().value;
    if (firstKey) localStore.delete(firstKey);
  }

  return false;
}

export async function isRateLimited(
  supabase: RateLimitRpcClient,
  key: string,
  maxRequests: number,
  windowMs: number,
): Promise<boolean> {
  try {
    const { data, error } = await supabase.rpc("check_rate_limit", {
      p_key: key,
      p_max_requests: maxRequests,
      p_window_ms: windowMs,
    });

    if (error) {
      logger.warn("Rate-limit RPC unavailable, falling back to local limiter", {
        reason: error.message,
      });
      return isRateLimitedLocal(key, maxRequests, windowMs);
    }

    return data === true;
  } catch {
    return isRateLimitedLocal(key, maxRequests, windowMs);
  }
}
