// Hottest WRITE path: start a session, then submit an attempt. Reproduces the
// app's exact two-round-trip write (audit C-2): the DB-backed rate-limit RPC
// runs before submit_exercise_attempt. submit is a heavy SECURITY DEFINER RPC
// (scoring + rewards + badge unlocks + per-user COUNT/MAX reads, audit H3).
//
// NOTE: this mutates seeded data (attempts/XP grow). Run only against a
// throwaway load-test project; the soak stage is designed to surface
// rate_limit_events bloat + lock contention over time.
import { sleep } from "k6";
import { rpc } from "./lib/http.js";
import { assertConfig, USER_JWTS, EXERCISE_IDS, pick } from "./lib/config.js";
import { jwtSub } from "./lib/jwt.js";
import { profile, THRESHOLDS } from "./lib/stages.js";
import { SUBMIT_RL_MAX, SUBMIT_RL_WINDOW_MS } from "./lib/constants.js";

export const options = { ...profile(), thresholds: THRESHOLDS };

export function setup() {
  assertConfig({ needUsers: true, needExercises: true });
}

export default function () {
  const jwt = pick(USER_JWTS, __VU);
  const exerciseId = pick(EXERCISE_IDS, __VU);

  const startRes = rpc("start_exercise_session", { p_exercise_id: exerciseId }, jwt);
  let sessionId = null;
  try {
    const body = startRes.json();
    sessionId = Array.isArray(body) ? body[0]?.session_id : body?.session_id;
  } catch (_e) {
    /* surfaced by the status check in rpc() */
  }
  if (!sessionId) {
    sleep(1);
    return;
  }

  // Mirror quest.server.ts: best-effort goal seeding, then the rate-limit gate,
  // then the scoring RPC.
  rpc("ensure_daily_weekly_goals", { p_user: jwtSub(jwt) }, jwt);
  rpc(
    "check_rate_limit",
    {
      p_key: `submit_${jwtSub(jwt)}`,
      p_max_requests: SUBMIT_RL_MAX,
      p_window_ms: SUBMIT_RL_WINDOW_MS,
    },
    jwt,
  );

  // Empty answers score 0% but still exercise the full RPC cost (scoring loop,
  // award_xp, badge checks, difficulty recompute). Supply real answer maps via
  // LOAD_ANSWERS fixtures if you want non-trivial scoring branches covered.
  rpc(
    "submit_exercise_attempt",
    { p_session_id: sessionId, p_exercise_id: exerciseId, p_answers: {} },
    jwt,
  );

  // Respect the 5-per-10s budget so we measure throughput, not 429 storms.
  sleep(2.5);
}
