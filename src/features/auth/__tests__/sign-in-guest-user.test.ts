import { describe, it, expect, vi } from "vitest";
import type { SupabaseClient } from "@supabase/supabase-js";
import { signInGuestUser } from "@/features/auth/guest-access";

/**
 * Build a minimal SupabaseClient stub whose `auth.signInAnonymously` resolves to a
 * caller-supplied result. Only the surface `signInGuestUser` touches is implemented.
 */
function makeSupabase(result: { error: unknown }): SupabaseClient {
  return {
    auth: {
      signInAnonymously: vi.fn().mockResolvedValue(result),
    },
  } as unknown as SupabaseClient;
}

describe("signInGuestUser", () => {
  it("returns ok on success (no error)", async () => {
    const supabase = makeSupabase({ error: null });
    const result = await signInGuestUser(supabase);
    expect(result).toEqual({ ok: true });
    expect(supabase.auth.signInAnonymously).toHaveBeenCalledOnce();
  });

  it("maps an error message and code on failure", async () => {
    const supabase = makeSupabase({
      error: { message: "Anonymous sign-ins are disabled", code: "anonymous_provider_disabled" },
    });
    const result = await signInGuestUser(supabase);
    expect(result).toEqual({
      ok: false,
      errorCode: "anonymous_provider_disabled",
      errorMessage: "Anonymous sign-ins are disabled",
    });
  });

  it("trims a whitespace-padded error message", async () => {
    const supabase = makeSupabase({
      error: { message: "  Rate limit exceeded  ", code: "rate_limit" },
    });
    const result = await signInGuestUser(supabase);
    expect(result).toEqual({
      ok: false,
      errorCode: "rate_limit",
      errorMessage: "Rate limit exceeded",
    });
  });

  it("falls back to a default message when the error message is empty", async () => {
    const supabase = makeSupabase({ error: { message: "", code: "" } });
    const result = await signInGuestUser(supabase);
    expect(result).toEqual({
      ok: false,
      errorCode: "",
      errorMessage: "Anonymous sign-in failed.",
    });
  });

  it("falls back to a default message when the error message is whitespace-only", async () => {
    const supabase = makeSupabase({ error: { message: "   ", code: undefined } });
    const result = await signInGuestUser(supabase);
    expect(result).toEqual({
      ok: false,
      errorCode: undefined,
      errorMessage: "Anonymous sign-in failed.",
    });
  });
});
