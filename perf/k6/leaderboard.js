// Hotspot: the GLOBAL leaderboard recomputes RANK() over every student profile
// on each call (audit H1). This scenario is the canary for that — watch p95 of
// get_global_leaderboard climb as the seeded profile count grows.
import { sleep } from "k6";
import { rpc } from "./lib/http.js";
import { assertConfig, USER_JWTS, pick, SUBJECT_IDS } from "./lib/config.js";
import { profile, THRESHOLDS } from "./lib/stages.js";
import { LEADERBOARD_LIMIT } from "./lib/constants.js";

export const options = { ...profile(), thresholds: THRESHOLDS };

export function setup() {
  assertConfig({ needUsers: true });
}

export default function () {
  const jwt = pick(USER_JWTS, __VU);
  rpc("get_global_leaderboard", { p_limit: LEADERBOARD_LIMIT }, jwt);
  if (SUBJECT_IDS.length) {
    rpc(
      "get_subject_leaderboard",
      { p_subject: pick(SUBJECT_IDS, __VU), p_limit: LEADERBOARD_LIMIT },
      jwt,
    );
  }
  sleep(1);
}
