// Hotspot: get_dungeon_questions selects its batch with ORDER BY random() over
// the full questions⨝exercises join (audit H2) — the dominant cost of dungeon
// play and the scenario most sensitive to a fully-populated catalogue. Watch
// get_dungeon_questions p95 grow with the seeded question count.
//
// Requires seeded users that hold a concours entitlement AND meet the dungeon
// prereqs (get_dungeon_access). Users without access will short-circuit at
// start_dungeon_run — that still load-tests the two unbounded COUNT(DISTINCT)
// aggregates in get_dungeon_access (audit M2).
import { sleep } from "k6";
import { rpc } from "./lib/http.js";
import { assertConfig, USER_JWTS, pick } from "./lib/config.js";
import { profile, THRESHOLDS } from "./lib/stages.js";

export const options = { ...profile(), thresholds: THRESHOLDS };

export function setup() {
  assertConfig({ needUsers: true });
}

export default function () {
  const jwt = pick(USER_JWTS, __VU);

  rpc("get_dungeon_access", {}, jwt);
  const runRes = rpc("start_dungeon_run", {}, jwt);

  let runId = null;
  try {
    const body = runRes.json();
    runId = Array.isArray(body) ? body[0]?.run_id : body?.run_id || body?.id;
  } catch (_e) {
    /* surfaced by the status check */
  }
  if (runId) {
    // Mirror dungeon.server.ts: 10 req / 10s rate-limit gate, then the batch.
    rpc("get_dungeon_questions", { p_run_id: runId, p_batch_size: 5 }, jwt);
  }
  sleep(2);
}
