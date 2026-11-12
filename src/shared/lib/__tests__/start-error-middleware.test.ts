// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

import { consumeLastCapturedError } from "@/shared/lib/error-capture";
import { startInstance } from "@/start";

/**
 * Le middleware d'erreur de `src/start.ts` est le seul endroit où une erreur de
 * requête est VUE sous Node avant que le framework ne l'avale (voir
 * error-capture.ts). On l'exerce par l'instance réelle, pas par une copie.
 */
type ServerStep = (ctx: { next: () => Promise<unknown> }) => Promise<unknown>;

async function errorMiddlewareStep(): Promise<ServerStep> {
  const options = await startInstance.getOptions();
  const middleware = options.requestMiddleware?.at(-1);
  const step = (middleware as { options?: { server?: unknown } } | undefined)?.options?.server;
  if (typeof step !== "function") throw new Error("request error middleware not found");
  return step as ServerStep;
}

describe("request error middleware", () => {
  beforeEach(() => {
    consumeLastCapturedError();
  });

  it("hands an HTTP-status error to the capture before letting it through", async () => {
    const step = await errorMiddlewareStep();
    const error = Object.assign(new Error("upstream down"), { statusCode: 503 });

    await expect(step({ next: () => Promise.reject(error) })).rejects.toBe(error);
    expect(consumeLastCapturedError()).toBe(error);
  });

  it("answers any other throw with the branded 500 page, and logs it with its stack", async () => {
    const step = await errorMiddlewareStep();
    const consoleError = vi.spyOn(console, "error").mockImplementation(() => undefined);

    const response = await step({ next: () => Promise.reject(new Error("render blew up")) });
    const line = JSON.parse(consoleError.mock.calls[0]?.[0] as string) as {
      message: string;
      error: { message: string; stack: string };
    };
    consoleError.mockRestore();

    // Une ligne STRUCTURÉE, qui porte la pile : c'est tout le diagnostic d'un
    // 500 au rendu serveur.
    expect(line.message).toBe("SSR request failed");
    expect(line.error.message).toBe("render blew up");
    expect(line.error.stack).toContain("start-error-middleware.test.ts");

    expect(response).toBeInstanceOf(Response);
    expect((response as Response).status).toBe(500);
    expect((response as Response).headers.get("content-type")).toContain("text/html");
  });

  it("returns the downstream result untouched when nothing throws", async () => {
    const step = await errorMiddlewareStep();
    const downstream = new Response("ok");

    await expect(step({ next: () => Promise.resolve(downstream) })).resolves.toBe(downstream);
    expect(consumeLastCapturedError()).toBeUndefined();
  });
});
