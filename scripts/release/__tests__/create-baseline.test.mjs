import { describe, it, expect } from "vitest";
import {
  slugifyReason,
  baselineTagFor,
  parseHealth,
  shaMatches,
  checklistFrom,
  blockingFailures,
  buildManifest,
  BASELINE_TAG_PREFIX,
} from "../create-baseline.mjs";

const DATE = new Date("2026-07-21T10:00:00Z");
const byKey = (list) => Object.fromEntries(list.map((c) => [c.key, c]));

describe("slugifyReason", () => {
  it("lowercases and dashes a plain phrase", () => {
    expect(slugifyReason("Pre Videos")).toBe("pre-videos");
  });

  it("strips accents without inserting stray dashes", () => {
    expect(slugifyReason("éléphant café")).toBe("elephant-cafe");
  });

  it("trims leading/trailing punctuation and collapses runs", () => {
    expect(slugifyReason("  !!Élan-- ")).toBe("elan");
  });

  it("returns empty string for nothing usable", () => {
    expect(slugifyReason("")).toBe("");
    expect(slugifyReason("***")).toBe("");
  });

  it("truncates to a bounded length", () => {
    expect(slugifyReason("a".repeat(50)).length).toBeLessThanOrEqual(32);
  });
});

describe("baselineTagFor", () => {
  it("names a purely dated tag in UTC", () => {
    expect(baselineTagFor(DATE)).toBe(`${BASELINE_TAG_PREFIX}2026-07-21`);
  });

  it("is stable across the operator's timezone (reads UTC)", () => {
    // 23:30 in a +02:00 zone is still 21:30 UTC → same day.
    expect(baselineTagFor(new Date("2026-07-21T21:30:00Z"))).toBe(
      `${BASELINE_TAG_PREFIX}2026-07-21`,
    );
  });

  it("appends a reason slug when given", () => {
    expect(baselineTagFor(DATE, { reason: "pre videos" })).toBe(
      `${BASELINE_TAG_PREFIX}2026-07-21-pre-videos`,
    );
  });

  it("suffixes on collision so a second baseline the same day is possible", () => {
    const existing = [`${BASELINE_TAG_PREFIX}2026-07-21`];
    expect(baselineTagFor(DATE, { existingTags: existing })).toBe(
      `${BASELINE_TAG_PREFIX}2026-07-21.2`,
    );
    expect(
      baselineTagFor(DATE, { existingTags: [...existing, `${BASELINE_TAG_PREFIX}2026-07-21.2`] }),
    ).toBe(`${BASELINE_TAG_PREFIX}2026-07-21.3`);
  });
});

describe("parseHealth", () => {
  it("reads a healthy probe", () => {
    const r = parseHealth('{"status":"ok","checks":{"database":"ok"},"commit":"bec006f9"}');
    expect(r).toEqual({ ok: true, status: "ok", database: "ok", commit: "bec006f9" });
  });

  it("is not ok when the database check fails", () => {
    const r = parseHealth('{"status":"degraded","checks":{"database":"fail"},"commit":"abc"}');
    expect(r.ok).toBe(false);
    expect(r.database).toBe("fail");
  });

  it("never throws on invalid JSON — returns an unknown report", () => {
    expect(parseHealth("<html>502</html>")).toEqual({
      ok: false,
      status: null,
      database: null,
      commit: null,
    });
  });

  it("tolerates a missing commit field", () => {
    expect(parseHealth('{"status":"ok","checks":{"database":"ok"}}').commit).toBeNull();
  });
});

describe("shaMatches", () => {
  it("matches a short SHA against its long form (either order)", () => {
    expect(shaMatches("bec006f9", "bec006f9abcdef0123")).toBe(true);
    expect(shaMatches("bec006f9abcdef0123", "bec006f9")).toBe(true);
  });

  it("rejects a mismatch or a missing value", () => {
    expect(shaMatches("bec006f9", "deadbeef")).toBe(false);
    expect(shaMatches(null, "bec006f9")).toBe(false);
    expect(shaMatches("bec006f9", null)).toBe(false);
  });
});

describe("checklistFrom", () => {
  const okState = {
    tagName: `${BASELINE_TAG_PREFIX}2026-07-21`,
    remoteTags: { arena: [], content: [], scribekit: [] },
    cleanTrees: { arena: true, content: true, scribekit: true },
    health: { ok: true, status: "ok", database: "ok", commit: "bec006f9" },
    arenaSha: "bec006f9",
    frozen: true,
    openPRs: 0,
    dump: {},
  };

  it("passes clean-trees, main-eq-prod and tag-free on a healthy state", () => {
    const c = byKey(checklistFrom(okState));
    expect(c["clean-trees"].status).toBe("ok");
    expect(c["main-eq-prod"].status).toBe("ok");
    expect(c["tag-free"].status).toBe("ok");
  });

  it("fails clean-trees and names the dirty repo", () => {
    const c = byKey(checklistFrom({ ...okState, cleanTrees: { arena: false, content: true } }));
    expect(c["clean-trees"].status).toBe("fail");
    expect(c["clean-trees"].detail).toContain("arena");
  });

  it("fails main-eq-prod when the served commit differs from the arena SHA", () => {
    const c = byKey(
      checklistFrom({
        ...okState,
        health: { ok: true, status: "ok", database: "ok", commit: "deadbeef" },
      }),
    );
    expect(c["main-eq-prod"].status).toBe("fail");
  });

  it("marks main-eq-prod manual when the probe is unreachable", () => {
    const c = byKey(checklistFrom({ ...okState, health: null }));
    expect(c["main-eq-prod"].status).toBe("manual");
  });

  it("marks main-eq-prod manual when the probe answers unreadable non-JSON", () => {
    const c = byKey(
      checklistFrom({
        ...okState,
        health: { ok: false, status: null, database: null, commit: null },
      }),
    );
    expect(c["main-eq-prod"].status).toBe("manual");
  });

  it("fails tag-free when the name already exists on a remote", () => {
    const c = byKey(
      checklistFrom({
        ...okState,
        remoteTags: { arena: [`${BASELINE_TAG_PREFIX}2026-07-21`], content: [], scribekit: [] },
      }),
    );
    expect(c["tag-free"].status).toBe("fail");
    expect(c["tag-free"].detail).toContain("arena");
  });
});

describe("blockingFailures", () => {
  it("returns only blocking items that failed", () => {
    const checklist = [
      { key: "a", blocking: true, status: "fail" },
      { key: "b", blocking: false, status: "fail" },
      { key: "c", blocking: true, status: "ok" },
      { key: "d", blocking: true, status: "manual" },
    ];
    expect(blockingFailures(checklist).map((c) => c.key)).toEqual(["a"]);
  });
});

describe("buildManifest", () => {
  it("carries the tag and the three repositories", () => {
    const m = buildManifest({
      tag: `${BASELINE_TAG_PREFIX}2026-07-21`,
      date: DATE,
      reason: "pre-videos",
      repos: {
        arena: { sha: "bec006f9", version: "0.1.0" },
        content: { sha: "f07a0dd", version: null },
        scribekit: { sha: "941b7b5", version: "0.1.0" },
      },
    });
    expect(m).toContain(`Tag : ${BASELINE_TAG_PREFIX}2026-07-21`);
    expect(m).toContain("MBeji/yahia-quest-arena");
    expect(m).toContain("MBeji/yahia-quest-content");
    expect(m).toContain("MBeji/ScribeKit");
    expect(m).toContain("bec006f9");
    expect(m).toContain("pre-videos");
  });

  it("fills DB placeholders when values are supplied", () => {
    const m = buildManifest({
      tag: `${BASELINE_TAG_PREFIX}2026-07-21`,
      date: DATE,
      db: { migrationHead: "20260721140000_competency_map_rpcs", dumpStamp: "20260721" },
    });
    expect(m).toContain("20260721140000_competency_map_rpcs");
    expect(m).toContain("db-prod-20260721.dump");
  });

  it("leaves explicit placeholders when values are missing", () => {
    const m = buildManifest({ tag: "baseline/x", date: DATE });
    expect(m).toContain("<raison>");
    expect(m).toContain("<checksum>");
  });
});
