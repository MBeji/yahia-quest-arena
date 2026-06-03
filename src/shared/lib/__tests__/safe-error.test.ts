import { describe, it, expect, vi, beforeEach } from "vitest";
import { failWithClientError } from "@/shared/lib/safe-error";

const mockLoggerError = vi.fn();

vi.mock("@/shared/lib/logger", () => ({
  logger: {
    error: (...args: unknown[]) => mockLoggerError(...args),
  },
}));

describe("failWithClientError", () => {
  beforeEach(() => {
    mockLoggerError.mockClear();
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
});
