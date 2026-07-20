import "@/shared/lib/error-capture";

import { consumeLastCapturedError } from "@/shared/lib/error-capture";
import { renderErrorPage } from "@/shared/lib/error-page";
import { logger } from "@/shared/lib/logger";
import { handlePushCron } from "@/features/notifications/notifications.cron.server";
import { guardRequest } from "@/shared/lib/bot-guard";
import { generateSitemap } from "@/shared/lib/sitemap";
import { handleHealthRequest } from "@/shared/lib/health";

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

    // Public sitemap for search engines, generated from the anon-visible
    // catalogue and served as XML outside the SSR/router path. Edge-cached for an
    // hour so a crawler fetch doesn't re-query the catalogue every time.
    if (new URL(request.url).pathname === "/sitemap.xml") {
      try {
        const xml = await generateSitemap();
        return new Response(xml, {
          status: 200,
          headers: {
            "content-type": "application/xml; charset=utf-8",
            "cache-control": "public, max-age=3600, s-maxage=3600",
          },
        });
      } catch (error) {
        logger.error("Sitemap generation failed", { error });
        return new Response("error", { status: 500 });
      }
    }

    // Liveness probe for an external uptime monitor. Handled BEFORE the bot
    // guard, for two reasons that both produce a FALSE outage otherwise:
    //   • monitors commonly ride on `python-requests`/`httpx`-class agents,
    //     which the guard answers with a 403;
    //   • a monitor polling on a schedule from one IP is exactly the shape the
    //     guard's per-IP burst cap answers with a 429.
    // Cheap, cached nowhere, and it never discloses more than ok/fail.
    if (new URL(request.url).pathname === "/api/health") {
      try {
        return await handleHealthRequest();
      } catch (error) {
        // The handler already degrades gracefully; this is the last resort.
        logger.error("Health endpoint failed", { error });
        return new Response('{"status":"degraded"}', {
          status: 503,
          headers: {
            "content-type": "application/json; charset=utf-8",
            "cache-control": "no-store, max-age=0",
          },
        });
      }
    }

    // Discriminant bot guard (anti-scraping): refuse declared AI/scraper agents
    // and cap per-IP bursts before any SSR work. Search/social crawlers pass
    // through (kept indexable for SEO). See src/shared/lib/bot-guard.ts.
    const guardResponse = guardRequest(request);
    if (guardResponse) return guardResponse;

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
