// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";
import { logger } from "@/shared/lib/logger";

describe("logger", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it("writes info logs as JSON", () => {
    const infoSpy = vi.spyOn(console, "info").mockImplementation(() => {});

    logger.info("request completed", { path: "/dashboard", status: 200 });

    expect(infoSpy).toHaveBeenCalledTimes(1);
    const payload = JSON.parse(infoSpy.mock.calls[0][0] as string) as {
      ts: string;
      level: string;
      message: string;
      path: string;
      status: number;
    };

    expect(payload.level).toBe("info");
    expect(payload.message).toBe("request completed");
    expect(payload.path).toBe("/dashboard");
    expect(payload.status).toBe(200);
    expect(typeof payload.ts).toBe("string");
    expect(payload.ts.length).toBeGreaterThan(10);
  });

  it("redacts sensitive keys", () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    logger.warn("auth event", {
      accessToken: "abc",
      SECRET_KEY: "value",
      password: "pass",
      authorization: "Bearer xyz",
      bearer: "xyz",
      cookie: "sb-access=1",
      normalField: "ok",
    });

    const payload = JSON.parse(warnSpy.mock.calls[0][0] as string) as Record<string, unknown>;
    expect(payload.accessToken).toBe("********");
    expect(payload.SECRET_KEY).toBe("********");
    expect(payload.password).toBe("********");
    expect(payload.authorization).toBe("********");
    expect(payload.bearer).toBe("********");
    expect(payload.cookie).toBe("********");
    expect(payload.normalField).toBe("ok");
  });

  it("routes warn and error to the right console methods", () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});

    logger.warn("warn message");
    logger.error("error message");

    expect(warnSpy).toHaveBeenCalledTimes(1);
    expect(errorSpy).toHaveBeenCalledTimes(1);

    const warnPayload = JSON.parse(warnSpy.mock.calls[0][0] as string) as { level: string };
    const errorPayload = JSON.parse(errorSpy.mock.calls[0][0] as string) as { level: string };

    expect(warnPayload.level).toBe("warn");
    expect(errorPayload.level).toBe("error");
  });

  // La convention de tout le serveur est `logger.error("…", { error })`. Une
  // `Error` n'ayant aucune propriété énumérable, la ligne portait `"error":{}`.
  it("writes an Error's name, message and stack instead of an empty object", () => {
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const error = new TypeError("boom at render");

    logger.error("SSR response normalized", { status: 500, error });

    const payload = JSON.parse(errorSpy.mock.calls[0][0] as string) as {
      status: number;
      error: { name: string; message: string; stack: string };
    };
    expect(payload.status).toBe(500);
    expect(payload.error.name).toBe("TypeError");
    expect(payload.error.message).toBe("boom at render");
    expect(payload.error.stack).toContain("boom at render");
    expect(payload.error.stack).toContain("logger.test.ts");
  });

  it("keeps the wrapped origin: one level of cause", () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});
    const origin = new Error("connection refused");

    logger.warn("read failed", { error: new Error("wrapper", { cause: origin }) });

    const payload = JSON.parse(warnSpy.mock.calls[0][0] as string) as {
      error: { message: string; cause: { message: string; cause?: unknown } };
    };
    expect(payload.error.message).toBe("wrapper");
    expect(payload.error.cause.message).toBe("connection refused");
    expect(payload.error.cause.cause).toBeUndefined();
  });

  it("bounds the stack so one error cannot flood the line", () => {
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const error = new Error("deep");
    error.stack = "x".repeat(10_000);

    logger.error("deep failure", { error });

    const payload = JSON.parse(errorSpy.mock.calls[0][0] as string) as {
      error: { stack: string };
    };
    expect(payload.error.stack).toHaveLength(4000);
  });

  it("still masks an Error stored under a sensitive key", () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    logger.warn("auth event", { tokenError: new Error("eyJhbGciOi-leaked") });

    const line = warnSpy.mock.calls[0][0] as string;
    expect(JSON.parse(line)).toMatchObject({ tokenError: "********" });
    expect(line).not.toContain("eyJhbGciOi-leaked");
  });

  it("leaves non-Error values exactly as they were", () => {
    const infoSpy = vi.spyOn(console, "info").mockImplementation(() => {});

    logger.info("rpc failed", { error: { message: "PGRST116", code: "42" }, reason: "x" });

    expect(JSON.parse(infoSpy.mock.calls[0][0] as string)).toMatchObject({
      error: { message: "PGRST116", code: "42" },
      reason: "x",
    });
  });
});
