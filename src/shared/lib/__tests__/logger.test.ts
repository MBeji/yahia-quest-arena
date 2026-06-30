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
});
