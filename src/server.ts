import "@/shared/lib/error-capture";

import { consumeLastCapturedError } from "@/shared/lib/error-capture";
import { renderErrorPage } from "@/shared/lib/error-page";
import { logger } from "@/shared/lib/logger";
import { handlePushCron } from "@/features/notifications/notifications.cron.server";

type ServerEntry = {
  fetch: (request: Request, env: unknown, ctx: unknown) => Promise<Response> | Response;
};

let serverEntryPromise: Promise<ServerEntry> | undefined;

async function getServerEntry(): Promise<ServerEntry> {
  if (!serverEntryPromise) {
    serverEntryPromise = import("@tanstack/react-start/server-entry").then(
      (m) => (m as { default?: ServerEntry }).default ?? (m as unknown as ServerEntry),
    );
  }
  return serverEntryPromise;
}

function brandedErrorResponse(): Response {
  return new Response(renderErrorPage(), {
    status: 500,
    headers: { "content-type": "text/html; charset=utf-8" },
  });
}

function isCatastrophicSsrErrorBody(body: string, responseStatus: number): boolean {
  let payload: unknown;
  try {
    payload = JSON.parse(body);
  } catch {
    return false;
  }

  if (!payload || Array.isArray(payload) || typeof payload !== "object") {
    return false;
  }

  const fields = payload as Record<string, unknown>;
  const expectedKeys = new Set(["message", "status", "unhandled"]);
  if (!Object.keys(fields).every((key) => expectedKeys.has(key))) {
    return false;
  }

  return (
    fields.unhandled === true &&
    fields.message === "HTTPError" &&
    (fields.status === undefined || fields.status === responseStatus)
  );
}

// h3 swallows in-handler throws into a normal 500 Response with body
// {"unhandled":true,"message":"HTTPError"} — try/catch alone never fires for those.
async function normalizeCatastrophicSsrResponse(response: Response): Promise<Response> {
  if (response.status < 500) return response;
  const contentType = response.headers.get("content-type") ?? "";
  if (!contentType.includes("application/json")) return response;

  const body = await response.clone().text();
  if (!isCatastrophicSsrErrorBody(body, response.status)) {
    return response;
  }

  logger.error("SSR response normalized after swallowed catastrophic error", {
    status: response.status,
    error: consumeLastCapturedError() ?? new Error(`h3 swallowed SSR error: ${body}`),
  });
  return brandedErrorResponse();
}

export default {
  async fetch(request: Request, env: unknown, ctx: unknown) {
    // Scheduled push dispatch (Vercel Cron → GET /api/cron/notify). Handled
    // before the SSR handler: it carries its own auth (CRON_SECRET) and returns
    // JSON rather than the branded HTML error page.
    if (new URL(request.url).pathname === "/api/cron/notify") {
      try {
        return await handlePushCron(request);
      } catch (error) {
        logger.error("Push cron dispatch failed", { error });
        return new Response("error", { status: 500 });
      }
    }

    try {
      const handler = await getServerEntry();
      const response = await handler.fetch(request, env, ctx);
      return await normalizeCatastrophicSsrResponse(response);
    } catch (error) {
      logger.error("Unhandled server fetch error", {
        path: new URL(request.url).pathname,
        error,
      });
      return brandedErrorResponse();
    }
  },
};
