import type { SupabaseClient } from "@supabase/supabase-js";

export const PUBLIC_GUEST_ACCESS_ENABLED = true;

export const GUEST_ACCESS_COPY = {
  authButton: "Continue as guest (free test)",
  authHint: "Try the student portal without creating an account.",
  loading: "Entering free test mode…",
  signInError: "Guest mode is temporarily unavailable.",
  signOutToast: "Guest session ended.",
};

type GuestSignInResult =
  | { ok: true }
  | { ok: false; errorMessage: string; errorCode?: string };

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

function randomToken() {
  if (typeof crypto !== "undefined" && "randomUUID" in crypto) {
    return crypto.randomUUID().replace(/-/g, "");
  }

  return `${Date.now()}${Math.random().toString(36).slice(2, 10)}`;
}

export async function signInGuestUser(supabase: SupabaseClient): Promise<GuestSignInResult> {
  const anonymousRes = await supabase.auth.signInAnonymously();
  if (!anonymousRes.error) return { ok: true as const };

  const token = randomToken();
  const email = `guest_${token}@yahiaacademy.local`;
  const password = `Guest#${token.slice(0, 16)}aA1`;

  const signUpRes = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        display_name: `Guest ${token.slice(0, 6)}`,
      },
    },
  });

  if (signUpRes.error) {
    return {
      ok: false,
      errorCode: signUpRes.error.code,
      errorMessage: normalizeErrorMessage(signUpRes.error.message, "Guest signup failed."),
    };
  }

  if (signUpRes.data.session) return { ok: true as const };

  const signInRes = await supabase.auth.signInWithPassword({ email, password });
  if (signInRes.error) {
    return {
      ok: false,
      errorCode: signInRes.error.code,
      errorMessage: normalizeErrorMessage(signInRes.error.message, "Guest sign-in failed."),
    };
  }

  return { ok: true as const };
}
