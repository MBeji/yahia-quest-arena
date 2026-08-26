// @vitest-environment node
/**
 * Pins the library behaviour that finding C-1 of docs/performance-audit.md rests on.
 *
 * The 2026-06-30 audit ranked "hoist the auth client" as the single highest-ROI
 * perf move, on the premise that a fresh Supabase client per server function
 * means "supabase-js's JWKS cache is empty each call → getClaims re-bootstraps
 * verification (JWKS fetch)". That premise does not hold for the version we
 * ship: auth-js stores the JWKS in a MODULE-LEVEL map keyed by `storageKey`,
 * which supabase-js derives from the project ref (`sb-<ref>-auth-token`). Every
 * per-request client is built from the same SUPABASE_URL, so they all share one
 * cache entry already, and hoisting would buy nothing — while costing us a
 * cross-user token leak, since the per-request client carries the caller's
 * bearer token.
 *
 * This test proves it end-to-end with a real ES256 keypair and a counting fetch:
 * two independently-created clients verify the same token, and the JWKS
 * endpoint is hit exactly once. If a future supabase-js upgrade moves the cache
 * back onto the instance, this test goes red — and C-1 becomes real again.
 */
import { describe, expect, it, vi } from "vitest";
import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://jwks-cache-test.supabase.co";
const PUBLISHABLE_KEY = "test-publishable-key";
const KID = "11111111-1111-1111-1111-111111111111";

function base64url(bytes: Uint8Array): string {
  return Buffer.from(bytes).toString("base64url");
}

function base64urlJson(value: unknown): string {
  return Buffer.from(JSON.stringify(value), "utf8").toString("base64url");
}

/** Mint a real ES256-signed JWT plus the public JWK that verifies it. */
async function mintToken() {
  const { privateKey, publicKey } = await crypto.subtle.generateKey(
    { name: "ECDSA", namedCurve: "P-256" },
    true,
    ["sign", "verify"],
  );

  const jwk = await crypto.subtle.exportKey("jwk", publicKey);
  const publicJwk = { ...jwk, kid: KID, alg: "ES256", use: "sig" };

  const header = { alg: "ES256", typ: "JWT", kid: KID };
  const payload = {
    sub: "user-1",
    role: "authenticated",
    iss: `${SUPABASE_URL}/auth/v1`,
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 3600,
  };

  const signingInput = `${base64urlJson(header)}.${base64urlJson(payload)}`;
  const signature = await crypto.subtle.sign(
    { name: "ECDSA", hash: "SHA-256" },
    privateKey,
    new TextEncoder().encode(signingInput),
  );

  return {
    token: `${signingInput}.${base64url(new Uint8Array(signature))}`,
    publicJwk,
  };
}

describe("supabase-js JWKS cache (finding C-1)", () => {
  it("is shared across per-request clients — the endpoint is fetched once, not per client", async () => {
    const { token, publicJwk } = await mintToken();

    let jwksFetches = 0;
    const countingFetch = vi.fn(async (input: RequestInfo | URL) => {
      const url = String(input instanceof Request ? input.url : input);
      if (url.includes("/.well-known/jwks.json")) {
        jwksFetches++;
        return new Response(JSON.stringify({ keys: [publicJwk] }), {
          status: 200,
          headers: { "content-type": "application/json" },
        });
      }
      // Any other call means verification fell back to the network path
      // (getUser), which is exactly what this test exists to detect.
      throw new Error(`unexpected network call during JWT verification: ${url}`);
    });

    const newClient = () =>
      createClient(SUPABASE_URL, PUBLISHABLE_KEY, {
        global: { fetch: countingFetch as unknown as typeof fetch },
        auth: { storage: undefined, persistSession: false, autoRefreshToken: false },
      });

    // Two separate clients, exactly as two consecutive server-fn calls would build.
    const first = await newClient().auth.getClaims(token);
    const second = await newClient().auth.getClaims(token);

    expect(first.error).toBeNull();
    expect(second.error).toBeNull();
    expect(first.data?.claims.sub).toBe("user-1");
    expect(second.data?.claims.sub).toBe("user-1");

    // The whole point: the second client reused the first one's JWKS.
    expect(jwksFetches).toBe(1);
  });
});
