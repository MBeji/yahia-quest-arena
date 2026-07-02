// Shared load profiles + SLO thresholds, selected by the STAGE env var.
//
//   STAGE=smoke   1 VU, 30s         — wiring check, run on every PR
//   STAGE=load    ramp to 200 VUs   — expected steady-state concurrency
//   STAGE=stress  ramp to 1000 VUs  — find the knee / breaking point
//   STAGE=soak    150 VUs, 30m      — leak / bloat detection (rate_limit_events, locks)
//   STAGE=spike   0→800 in 30s      — launch / exam-season surge
const STAGE = __ENV.STAGE || "smoke";

const PROFILES = {
  smoke: { vus: 1, duration: "30s" },
  load: {
    stages: [
      { duration: "1m", target: 200 },
      { duration: "3m", target: 200 },
      { duration: "1m", target: 0 },
    ],
  },
  stress: {
    stages: [
      { duration: "2m", target: 200 },
      { duration: "2m", target: 500 },
      { duration: "3m", target: 1000 },
      { duration: "2m", target: 0 },
    ],
  },
  soak: {
    stages: [
      { duration: "2m", target: 150 },
      { duration: "26m", target: 150 },
      { duration: "2m", target: 0 },
    ],
  },
  spike: {
    stages: [
      { duration: "30s", target: 800 },
      { duration: "1m", target: 800 },
      { duration: "30s", target: 0 },
    ],
  },
};

// p95 SLOs. Reads should stay snappy; the write path (scoring + rewards +
// rate-limit round-trip) is allowed more headroom. http_req_failed guards
// against the suite "passing" while everything 500s.
export const THRESHOLDS = {
  http_req_failed: ["rate<0.01"],
  "http_req_duration{name:get_global_leaderboard}": ["p95<400"],
  "http_req_duration{name:get_subject_leaderboard}": ["p95<300"],
  "http_req_duration{name:start_exercise_session}": ["p95<400"],
  "http_req_duration{name:submit_exercise_attempt}": ["p95<800"],
  "http_req_duration{name:check_rate_limit}": ["p95<250"],
  "http_req_duration{name:get_dungeon_questions}": ["p95<600"],
  http_req_duration: ["p95<1000"],
};

export function profile() {
  const p = PROFILES[STAGE];
  if (!p) throw new Error(`Unknown STAGE=${STAGE}. Use smoke|load|stress|soak|spike.`);
  return p;
}
