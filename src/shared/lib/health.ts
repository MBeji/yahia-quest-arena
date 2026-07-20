import { createPublicSupabaseClient } from "@/shared/integrations/supabase/public-client";
import { logger } from "@/shared/lib/logger";

type HealthClient = ReturnType<typeof createPublicSupabaseClient>;

/**
 * A hung database must not hang the probe: a monitor reads a timeout as "down"
 * anyway, and an endpoint that blocks is worse than one that answers "degraded".
 */
export const HEALTH_TIMEOUT_MS = 3_000;

export type HealthReport = {
  status: "ok" | "degraded";
  checks: { database: "ok" | "fail" };
  /** Short SHA of the deployment actually serving this response. */
  commit: string;
  ts: string;
};

/**
 * Probe Postgres with the cheapest anon-readable read available.
 *
 * `themes` is tiny and readable by `anon`, so this costs one index scan. It
 * answers the question a bare HTTP 200 cannot: the app can keep serving HTML
 * while the database behind it is gone — precisely the outage shape that a code
 * rollback does NOT fix (docs/prod-rollback-runbook.md § « Si le rollback ne
 * suffit pas »).
 *
 * The underlying error is never surfaced to the caller: a connection failure can
 * carry host names and DSN fragments. It goes to the log; the response says
 * "fail" and nothing more.
 */
export async function probeDatabase(
  supabase: HealthClient,
  timeoutMs: number = HEALTH_TIMEOUT_MS,
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from("themes")
      .select("id")
      .limit(1)
      .abortSignal(AbortSignal.timeout(timeoutMs));

    if (error) {
      logger.error("Health probe: database read failed", { error });
      return false;
    }
    return true;
  } catch (error) {
    logger.error("Health probe: database unreachable", { error });
    return false;
  }
}

/**
 * Short SHA of the running deployment. Vercel injects `VERCEL_GIT_COMMIT_SHA` at
 * build time, so this is the one reliable way to answer "which code is live
 * right now?" from outside — the check the rollback runbook asks for after
 * re-promoting a deployment, where an HTTP 200 alone proves nothing.
 *
 * Safe to expose: the repository is public, so a commit SHA discloses nothing
 * that `git log` does not.
 */
export function deploymentCommit(env: NodeJS.ProcessEnv = process.env): string {
  const sha = env.VERCEL_GIT_COMMIT_SHA;
  return sha ? sha.slice(0, 7) : "unknown";
}

export function buildHealthReport(
  databaseOk: boolean,
  { commit = deploymentCommit(), now = new Date() }: { commit?: string; now?: Date } = {},
): HealthReport {
  return {
    status: databaseOk ? "ok" : "degraded",
    checks: { database: databaseOk ? "ok" : "fail" },
    commit,
    ts: now.toISOString(),
  };
}

/**
 * 200 when healthy, 503 when not — so the dumbest possible uptime monitor works
 * on the status code alone, without parsing the body.
 */
export function healthResponse(report: HealthReport): Response {
  return new Response(JSON.stringify(report), {
    status: report.status === "ok" ? 200 : 503,
    headers: {
      "content-type": "application/json; charset=utf-8",
      // A cached health check reports the past — worse than no check at all.
      "cache-control": "no-store, max-age=0",
    },
  });
}

/** Entry point used by `src/server.ts` for `GET /api/health`. */
export async function handleHealthRequest(): Promise<Response> {
  let databaseOk = false;
  try {
    databaseOk = await probeDatabase(createPublicSupabaseClient());
  } catch (error) {
    // readSupabaseEnv() throws when the env vars are missing — a deployment that
    // cannot build a client IS degraded, and must report so rather than 500.
    logger.error("Health probe: Supabase client unavailable", { error });
  }
  return healthResponse(buildHealthReport(databaseOk));
}
