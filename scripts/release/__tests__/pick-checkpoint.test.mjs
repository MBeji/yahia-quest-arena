import { describe, it, expect } from "vitest";
import {
  isoWeek,
  checkpointTagFor,
  classifySuites,
  evaluateCandidate,
  pickCheckpoint,
  buildAnnotation,
  CHECKPOINT_TAG_PREFIX,
  MAX_EVIDENCE_AGE_DAYS,
} from "../pick-checkpoint.mjs";

const NOW = new Date("2026-07-20T09:00:00Z");

/** Job names as GitHub actually reports them for nightly.yml's reusable calls. */
const GREEN_JOBS = [
  { name: "E2E (public) / e2e", conclusion: "success" },
  { name: "E2E (authenticated) / e2e-auth", conclusion: "success" },
  { name: "DB integration (pgTAP) / pgtap", conclusion: "success" },
  { name: "Performance (load — smoke) / perf", conclusion: "success" },
  { name: "Nightly report", conclusion: "success" },
];

const candidate = (over = {}) => ({
  headSha: "a".repeat(40),
  conclusion: "success",
  createdAt: "2026-07-20T01:00:00Z",
  verify: "success",
  jobs: GREEN_JOBS,
  runUrl: "https://github.com/o/r/actions/runs/1",
  ...over,
});

describe("isoWeek", () => {
  it("numbers a mid-year week", () => {
    expect(isoWeek(new Date("2026-07-20T00:00:00Z"))).toEqual({ year: 2026, week: 30 });
  });

  it("applies the Thursday rule across a year boundary", () => {
    // 2027-01-01 is a Friday → it belongs to ISO week 53 of 2026.
    expect(isoWeek(new Date("2027-01-01T00:00:00Z"))).toEqual({ year: 2026, week: 53 });
  });

  it("puts the first Monday-anchored week of a year at 1", () => {
    expect(isoWeek(new Date("2026-01-05T00:00:00Z"))).toEqual({ year: 2026, week: 2 });
  });
});

describe("checkpointTagFor", () => {
  it("names the tag after the ISO week, zero-padded", () => {
    expect(checkpointTagFor(new Date("2026-01-08T00:00:00Z"), [])).toBe(
      `${CHECKPOINT_TAG_PREFIX}2026-W02`,
    );
  });

  it("suffixes on collision so a second checkpoint in the week is possible", () => {
    const existing = [`${CHECKPOINT_TAG_PREFIX}2026-W30`];
    expect(checkpointTagFor(NOW, existing)).toBe(`${CHECKPOINT_TAG_PREFIX}2026-W30.2`);
    expect(checkpointTagFor(NOW, [...existing, `${CHECKPOINT_TAG_PREFIX}2026-W30.2`])).toBe(
      `${CHECKPOINT_TAG_PREFIX}2026-W30.3`,
    );
  });
});

describe("classifySuites", () => {
  it("maps the reusable-workflow job names onto the suite keys", () => {
    expect(classifySuites(GREEN_JOBS)).toEqual({
      e2e: "success",
      "e2e-auth": "success",
      pgtap: "success",
      perf: "success",
    });
  });

  it("reports a suite with no matching job as unknown, never as failed", () => {
    expect(classifySuites([{ name: "Nightly report", conclusion: "success" }])).toEqual({
      e2e: "unknown",
      "e2e-auth": "unknown",
      pgtap: "unknown",
      perf: "unknown",
    });
  });

  it("survives an empty or malformed job list", () => {
    expect(classifySuites().pgtap).toBe("unknown");
    expect(classifySuites([{}]).pgtap).toBe("unknown");
  });
});

describe("evaluateCandidate", () => {
  it("accepts a green nightly whose commit also has a green verify", () => {
    expect(evaluateCandidate(candidate(), { now: NOW }).ok).toBe(true);
  });

  it("rejects a nightly that did not succeed", () => {
    const v = evaluateCandidate(candidate({ conclusion: "failure" }), { now: NOW });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain("failure");
  });

  it("rejects a commit whose verify check is not green — CI cancels superseded main runs", () => {
    const v = evaluateCandidate(candidate({ verify: "cancelled" }), { now: NOW });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain("cancelled");
  });

  it("rejects a commit with no verify check at all", () => {
    const v = evaluateCandidate(candidate({ verify: undefined }), { now: NOW });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain("absent");
  });

  it("rejects evidence older than the freshness window", () => {
    const stale = candidate({ createdAt: "2026-07-01T01:00:00Z" });
    const v = evaluateCandidate(stale, { now: NOW });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain("trop ancienne");
    expect(v.ageDays).toBeGreaterThan(MAX_EVIDENCE_AGE_DAYS);
  });

  it("rejects a commit that already carries a checkpoint tag (idempotence)", () => {
    const v = evaluateCandidate(candidate(), { now: NOW, taggedShas: ["a".repeat(40)] });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain("déjà taggé");
  });

  it("rejects a SKIPPED required suite — a skip proves nothing", () => {
    const jobs = GREEN_JOBS.map((j) =>
      j.name.includes("pgTAP") ? { ...j, conclusion: "skipped" } : j,
    );
    const v = evaluateCandidate(candidate({ jobs }), { now: NOW });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain("pgTAP");
  });

  it("tolerates a SKIPPED optional suite — e2e-auth and perf are secret-gated by design", () => {
    const jobs = GREEN_JOBS.map((j) =>
      /auth|Performance/.test(j.name) ? { ...j, conclusion: "skipped" } : j,
    );
    const v = evaluateCandidate(candidate({ jobs }), { now: NOW });
    expect(v.ok).toBe(true);
    expect(v.suites["e2e-auth"]).toBe("skipped");
  });

  it("tolerates an unmatched required suite rather than freezing checkpointing forever", () => {
    const v = evaluateCandidate(candidate({ jobs: [] }), { now: NOW });
    expect(v.ok).toBe(true);
    expect(v.suites.pgtap).toBe("unknown");
  });
});

describe("pickCheckpoint", () => {
  it("returns the newest qualifying candidate and records the rejections before it", () => {
    const { chosen, rejected } = pickCheckpoint(
      [
        candidate({ headSha: "c".repeat(40), conclusion: "failure" }),
        candidate({ headSha: "b".repeat(40), verify: "cancelled" }),
        candidate({ headSha: "a".repeat(40) }),
      ],
      { now: NOW },
    );
    expect(chosen.headSha).toBe("a".repeat(40));
    expect(rejected).toHaveLength(2);
    expect(rejected[0].reason).toContain("failure");
  });

  it("returns nothing rather than a false checkpoint when no candidate qualifies", () => {
    const { chosen, rejected } = pickCheckpoint([candidate({ conclusion: "failure" })], {
      now: NOW,
    });
    expect(chosen).toBeNull();
    expect(rejected).toHaveLength(1);
  });

  it("handles an empty candidate list", () => {
    expect(pickCheckpoint([], { now: NOW })).toEqual({ chosen: null, rejected: [] });
  });
});

describe("buildAnnotation", () => {
  const annotation = buildAnnotation({
    tag: "checkpoint/2026-W30",
    headSha: "a".repeat(40),
    runUrl: "https://github.com/o/r/actions/runs/1",
    runDate: "2026-07-20T01:00:00Z",
    suites: classifySuites(GREEN_JOBS),
    version: "0.1.0",
    migrationHead: "20260715120000",
    deployment: "https://na9ranal3ab-abc.vercel.app",
  });

  it("records the commit, the schema head and the deployment together", () => {
    expect(annotation).toContain("a".repeat(40));
    expect(annotation).toContain("20260715120000");
    expect(annotation).toContain("https://na9ranal3ab-abc.vercel.app");
  });

  it("carries the forward-only migration warning — the trap of every rollback here", () => {
    expect(annotation).toContain("NE RAMÈNE PAS le schéma");
    expect(annotation).toContain("docs/prod-rollback-runbook.md");
  });

  it("degrades gracefully when the deployment could not be resolved", () => {
    expect(buildAnnotation({ tag: "t", headSha: "s", suites: {} })).toContain("non résolu");
  });
});
