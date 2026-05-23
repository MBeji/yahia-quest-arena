import type { SupabaseClient } from "@supabase/supabase-js";

export const PUBLIC_GUEST_ACCESS_ENABLED = true;

export const GUEST_ACCESS_COPY = {
  authButton: "Continue as guest (free test)",
  authHint: "Try the student portal without creating an account.",
  loading: "Entering free test mode…",
  signInError: "Guest mode is temporarily unavailable.",
  signOutToast: "Guest session ended.",
};

function randomToken() {
  if (typeof crypto !== "undefined" && "randomUUID" in crypto) {
    return crypto.randomUUID().replace(/-/g, "");
  }

  return `${Date.now()}${Math.random().toString(36).slice(2, 10)}`;
}

export async function signInGuestUser(supabase: SupabaseClient) {
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

  if (signUpRes.error) return { ok: false as const, error: signUpRes.error };

  if (signUpRes.data.session) return { ok: true as const };

  const signInRes = await supabase.auth.signInWithPassword({ email, password });
  if (signInRes.error) return { ok: false as const, error: signInRes.error };

  return { ok: true as const };
}
