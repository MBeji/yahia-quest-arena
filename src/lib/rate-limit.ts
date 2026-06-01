type RateLimitRpcClient = {
  rpc: (fn: string, args?: Record<string, unknown>) => Promise<{ data: unknown; error: { message: string } | null }>;
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
      console.warn("[rate-limit] Falling back to local limiter:", error.message);
      return isRateLimitedLocal(key, maxRequests, windowMs);
    }

    return data === true;
  } catch {
    return isRateLimitedLocal(key, maxRequests, windowMs);
  }
}
