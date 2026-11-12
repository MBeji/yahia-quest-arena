// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";
import {
  errorMessage,
  failWithClientError,
  isRateLimitedError,
  RATE_LIMITED_FR,
} from "@/shared/lib/safe-error";

const mockLoggerError = vi.fn();
const mockLoggerWarn = vi.fn();

vi.mock("@/shared/lib/logger", () => ({
  logger: {
    error: (...args: unknown[]) => mockLoggerError(...args),
    warn: (...args: unknown[]) => mockLoggerWarn(...args),
  },
}));

describe("failWithClientError", () => {
  beforeEach(() => {
    mockLoggerError.mockClear();
    mockLoggerWarn.mockClear();
  });

  // La borne durable des RPC (audit S-1) lève SQLSTATE PT429. Traduit en erreur
  // générique, l'élève lisait « impossible de corriger » et réessayait aussitôt.
  it("turns a durable rate-limit refusal into « trop de requêtes », not the generic message", () => {
    const refusal = { code: "PT429", message: "RATE_LIMITED", details: null, hint: null };
    expect(() =>
      failWithClientError("quest.checkAnswersPublic", refusal, "Impossible de corriger."),
    ).toThrowError(RATE_LIMITED_FR);
    // Un refus de cadence n'est pas une erreur serveur : il ne nourrit pas l'alerte.
    expect(mockLoggerError).not.toHaveBeenCalled();
    expect(mockLoggerWarn).toHaveBeenCalledWith("quest.checkAnswersPublic: rate limited");
  });

  it("logs the Error message and throws the client message", () => {
    expect(() =>
      failWithClientError("loadProfile", new Error("db down"), "Could not load profile"),
    ).toThrowError("Could not load profile");
    expect(mockLoggerError).toHaveBeenCalledWith("loadProfile", { error: "db down" });
  });

  it("stringifies non-Error values", () => {
    expect(() => failWithClientError("ctx", "boom", "Something went wrong")).toThrowError(
      "Something went wrong",
    );
    expect(mockLoggerError).toHaveBeenCalledWith("ctx", { error: "boom" });
  });

  it("never returns (always throws)", () => {
    expect(() => failWithClientError("ctx", null, "msg")).toThrow();
    expect(mockLoggerError).toHaveBeenCalledWith("ctx", { error: "null" });
  });

  it("logs the message of a Supabase-style error object (not '[object Object]')", () => {
    // Supabase PostgrestError is a plain object, NOT an Error instance.
    const pgError = { message: "relation does not exist", code: "42P01" };
    expect(() => failWithClientError("getDashboard.profile", pgError, "msg")).toThrow();
    expect(mockLoggerError).toHaveBeenCalledWith("getDashboard.profile", {
      error: "relation does not exist",
    });
  });
});

describe("errorMessage", () => {
  it("returns an Error's message", () => {
    expect(errorMessage(new Error("boom"))).toBe("boom");
  });

  it("returns a string as-is", () => {
    expect(errorMessage("plain string")).toBe("plain string");
  });

  it("extracts .message from a plain object (Supabase-style)", () => {
    expect(errorMessage({ message: "db down", code: "X" })).toBe("db down");
  });

  it("never degrades a plain object to '[object Object]' (falls back to JSON)", () => {
    expect(errorMessage({ code: "X", detail: "y" })).toBe('{"code":"X","detail":"y"}');
  });

  it("stringifies null/undefined safely", () => {
    expect(errorMessage(null)).toBe("null");
  });
});

describe("isRateLimitedError", () => {
  it("recognises the SQLSTATE and the raised message", () => {
    expect(isRateLimitedError({ code: "PT429", message: "whatever" })).toBe(true);
    expect(isRateLimitedError({ message: "RATE_LIMITED" })).toBe(true);
  });

  it("ignores every other failure", () => {
    expect(isRateLimitedError({ code: "42501", message: "permission denied" })).toBe(false);
    expect(isRateLimitedError(new Error("db down"))).toBe(false);
    expect(isRateLimitedError(null)).toBe(false);
    expect(isRateLimitedError("RATE_LIMITED")).toBe(false);
  });
});
