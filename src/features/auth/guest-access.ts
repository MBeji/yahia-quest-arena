import type { SupabaseClient } from "@supabase/supabase-js";

export const PUBLIC_GUEST_ACCESS_ENABLED = false;

export const GUEST_ACCESS_COPY = {
  authButton: "Continue as guest (free test)",
  authHint: "Try the student portal without creating an account.",
  loading: "Entering free test mode…",
  signInError: "Guest mode is temporarily unavailable.",
  signOutToast: "Guest session ended.",
};

type GuestSignInResult = { ok: true } | { ok: false; errorMessage: string; errorCode?: string };

function normalizeErrorMessage(value: unknown, fallback: string): string {
  if (typeof value === "string" && value.trim().length > 0) {
    return value.trim();
  }

  return fallback;
}

export function getGuestSignInErrorMessage(result: GuestSignInResult): string {
  if (result.ok) return "";

  const message = result.errorMessage.toLowerCase();
  const code = (result.errorCode ?? "").toLowerCase();

  if (message.includes("anonymous") && message.includes("disabled")) {
    return "Guest mode disabled in Supabase. Enable Auth > Providers > Anonymous.";
  }

  if (
    code.includes("rate_limit") ||
    message.includes("rate_limit") ||
    message.includes("rate limit")
  ) {
    return "Too many attempts. Please enable Anonymous sign-ins in Supabase Auth settings.";
  }

  if (message.includes("signups not allowed")) {
    return "Signups are disabled in Supabase. Enable Email signup or Anonymous provider.";
  }

  if (message.includes("captcha")) {
    return "Auth blocked by CAPTCHA policy. Configure CAPTCHA for guest flow or disable it for testing.";
  }

  if (code) {
    return `${GUEST_ACCESS_COPY.signInError} (${code})`;
  }

  return `${GUEST_ACCESS_COPY.signInError} (${result.errorMessage})`;
}

export async function signInGuestUser(supabase: SupabaseClient): Promise<GuestSignInResult> {
  const { error } = await supabase.auth.signInAnonymously();

  if (!error) return { ok: true };

  return {
    ok: false,
    errorCode: error.code,
    errorMessage: normalizeErrorMessage(error.message, "Anonymous sign-in failed."),
  };
}
