import { describe, it, expect } from "vitest";
import { getGuestSignInErrorMessage, GUEST_ACCESS_COPY } from "@/lib/guest-access";

describe("getGuestSignInErrorMessage", () => {
  it("returns empty string for successful result", () => {
    expect(getGuestSignInErrorMessage({ ok: true })).toBe("");
  });

  it("detects anonymous sign-in disabled", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "Anonymous sign-ins are disabled",
      errorCode: "",
    });
    expect(result).toContain("Guest mode disabled");
    expect(result).toContain("Anonymous");
  });

  it("detects rate limit error", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "Rate limit exceeded",
      errorCode: "rate_limit",
    });
    expect(result).toContain("Too many attempts");
  });

  it("detects rate limit in message only", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "rate_limit exceeded for this IP",
      errorCode: "",
    });
    expect(result).toContain("Too many attempts");
  });

  it("detects signups disabled", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "Signups not allowed for this instance",
      errorCode: "",
    });
    expect(result).toContain("Signups are disabled");
  });

  it("detects captcha error", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "captcha verification failed",
      errorCode: "",
    });
    expect(result).toContain("CAPTCHA");
  });

  it("includes error code when available", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "Something unknown",
      errorCode: "unknown_error",
    });
    expect(result).toContain("unknown_error");
    expect(result).toContain(GUEST_ACCESS_COPY.signInError);
  });

  it("includes error message when no code", () => {
    const result = getGuestSignInErrorMessage({
      ok: false,
      errorMessage: "Something went wrong",
      errorCode: "",
    });
    expect(result).toContain("Something went wrong");
  });
});
