import type { TranslationKeys } from "@/lib/i18n/types";

// Les messages d'erreur d'authentification, sortis de `routes/auth.tsx` (2026-11-03) : la route
// était à 728 lignes de code pour un plafond de 750, et ces fonctions pures n'ont rien à y faire.

/** `AuthError.code` when supabase-js exposes one (it is absent on plain Errors). */
function authCode(err: unknown): string {
  const code = (err as { code?: unknown } | null)?.code;
  return typeof code === "string" ? code : "";
}

/** GoTrue refuses an unconfirmed sign-in with « Email not confirmed ». */
export function isEmailNotConfirmed(err: unknown): boolean {
  const msg = err instanceof Error ? err.message.toLowerCase() : "";
  return msg.includes("email not confirmed") || authCode(err) === "email_not_confirmed";
}

/** Map a raw Supabase auth error to a localized, user-actionable message. */
export function friendlyAuthError(t: TranslationKeys, err: unknown): string {
  const msg = err instanceof Error ? err.message.toLowerCase() : "";
  const code = authCode(err);
  if (msg.includes("invalid login")) return t.auth.errorInvalidLogin;
  if (isEmailNotConfirmed(err)) return t.auth.errorEmailNotConfirmed;
  if (msg.includes("user already registered") || code === "user_already_exists")
    return t.auth.errorAccountExists;
  // A mailer failure is not a credentials problem: the account exists, only the mail
  // never left. Answering « authentication error » sends the user back to a form that
  // will then tell them the account already exists — the dead end this branch closes.
  if (msg.includes("error sending")) return t.auth.errorMailerDown;
  // GoTrue's per-address cooldown reads « For security purposes, you can only request
  // this after N seconds » — neither « rate limit » nor « too many » appears in it.
  if (
    msg.includes("rate limit") ||
    msg.includes("too many") ||
    msg.includes("for security purposes") ||
    code === "over_email_send_rate_limit"
  )
    return t.auth.errorRateLimit;
  if (msg.includes("password")) return t.auth.passwordTooShort;
  if (msg.includes("signup_disabled") || code === "signup_disabled")
    return t.auth.errorSignupDisabled;
  return t.auth.errorGeneric;
}

/** Seconds GoTrue asks us to wait, parsed from its cooldown message. */
export function cooldownFromError(err: unknown): number {
  const m = err instanceof Error ? /after (\d+) seconds?/i.exec(err.message) : null;
  return m ? Number(m[1]) : 0;
}
