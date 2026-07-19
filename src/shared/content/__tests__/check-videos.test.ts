import { describe, it, expect, vi } from "vitest";
import { mkdtempSync, mkdirSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  checkEntry,
  checkRegistry,
  findReferencingSubjects,
  oembedUrl,
  verdictForStatus,
  // @ts-expect-error — plain .mjs CLI helper, no type declarations by design.
} from "../../../../scripts/content/check-videos.mjs";

/** Étude 23 lot 4 — the oEmbed health checker. Never touches the network here. */

const entry = (over: Record<string, unknown> = {}) => ({
  provider: "youtube",
  videoId: "AbCdEfGhIjK",
  status: "active",
  ...over,
});

const respond = (status: number) => vi.fn().mockResolvedValue({ status });

describe("verdictForStatus — oEmbed status → proposed verdict", () => {
  it("maps the documented statuses", () => {
    expect(verdictForStatus(200).verdict).toBe("ok");
    expect(verdictForStatus(400).verdict).toBe("broken");
    expect(verdictForStatus(401).verdict).toBe("broken");
    expect(verdictForStatus(403).verdict).toBe("broken");
    expect(verdictForStatus(404).verdict).toBe("broken");
  });

  it("explains WHY a video is broken (the issue body needs it)", () => {
    expect(verdictForStatus(401).reason).toMatch(/embedding disabled/i);
    expect(verdictForStatus(403).reason).toMatch(/private/i);
    expect(verdictForStatus(404).reason).toMatch(/deleted/i);
  });

  it("never claims `broken` on an unexpected status", () => {
    expect(verdictForStatus(500).verdict).toBe("unknown");
    expect(verdictForStatus(429).verdict).toBe("unknown");
  });
});

describe("oembedUrl", () => {
  it("probes the anonymous endpoint with an encoded watch URL", () => {
    const url = oembedUrl("AbCdEfGhIjK");
    expect(url.startsWith("https://www.youtube.com/oembed?url=")).toBe(true);
    expect(url).toContain(encodeURIComponent("https://www.youtube.com/watch?v=AbCdEfGhIjK"));
    expect(url).toContain("format=json");
  });
});

describe("checkEntry", () => {
  it("reports a live, embeddable video as ok", async () => {
    const r = await checkEntry("math.ok", entry(), { fetchImpl: respond(200) });
    expect(r).toMatchObject({ id: "math.ok", videoId: "AbCdEfGhIjK", verdict: "ok" });
  });

  it("degrades a network failure to `unknown`, never a false `broken`", async () => {
    const boom = vi.fn().mockRejectedValue(new Error("ETIMEDOUT"));
    const r = await checkEntry("math.x", entry(), { fetchImpl: boom });
    expect(r.verdict).toBe("unknown");
    expect(r.reason).toMatch(/network error/i);
  });

  it("degrades a timeout (AbortError) to `unknown`", async () => {
    const aborted = vi.fn().mockRejectedValue(new DOMException("aborted", "TimeoutError"));
    expect((await checkEntry("math.x", entry(), { fetchImpl: aborted })).verdict).toBe("unknown");
  });

  it("does not probe a provider it cannot check", async () => {
    const fetchImpl = respond(200);
    const r = await checkEntry("math.x", entry({ provider: "vimeo" }), { fetchImpl });
    expect(r.verdict).toBe("unknown");
    expect(fetchImpl).not.toHaveBeenCalled();
  });
});

describe("checkRegistry", () => {
  it("probes only `active` entries", async () => {
    const fetchImpl = respond(200);
    const results = await checkRegistry(
      {
        "math.a": entry(),
        "math.b": entry({ status: "retired" }),
        "math.c": entry({ status: "broken" }),
      },
      { fetchImpl, throttleMs: 0 },
    );
    expect(results).toHaveLength(1);
    expect(results[0].id).toBe("math.a");
    expect(fetchImpl).toHaveBeenCalledTimes(1);
  });

  it("returns a verdict per active entry", async () => {
    const fetchImpl = vi
      .fn()
      .mockResolvedValueOnce({ status: 200 })
      .mockResolvedValueOnce({ status: 404 });
    const results = await checkRegistry(
      { "m.a": entry(), "m.b": entry() },
      {
        fetchImpl,
        throttleMs: 0,
      },
    );
    expect(results.map((r: { verdict: string }) => r.verdict)).toEqual(["ok", "broken"]);
  });

  it("is a no-op on an empty registry (pre-campaign)", async () => {
    const fetchImpl = respond(200);
    expect(await checkRegistry({}, { fetchImpl, throttleMs: 0 })).toEqual([]);
    expect(fetchImpl).not.toHaveBeenCalled();
  });
});

describe("findReferencingSubjects — the rebuild list (US-8)", () => {
  it("names every subject referencing a dead video, from chapters and exercises", () => {
    const root = mkdtempSync(join(tmpdir(), "vidrefs-"));
    try {
      const chapter = join(root, "math-9eme", "01-thales");
      mkdirSync(join(chapter, "exercices"), { recursive: true });
      writeFileSync(join(root, "math-9eme", "subject.json"), "{}");
      writeFileSync(join(chapter, "chapter.json"), JSON.stringify({ videos: ["math.dead"] }));
      writeFileSync(
        join(chapter, "exercices", "boss.json"),
        JSON.stringify({ correctionVideo: "math.also-dead" }),
      );

      const other = join(root, "svt", "01-cellule");
      mkdirSync(other, { recursive: true });
      writeFileSync(join(root, "svt", "subject.json"), "{}");
      writeFileSync(join(other, "chapter.json"), JSON.stringify({ videos: ["math.alive"] }));

      const hits = findReferencingSubjects(root, ["math.dead", "math.also-dead"]);
      expect(hits).toEqual([{ subject: "math-9eme", videos: ["math.also-dead", "math.dead"] }]);
    } finally {
      rmSync(root, { recursive: true, force: true });
    }
  });

  it("returns nothing when no id is dead", () => {
    const root = mkdtempSync(join(tmpdir(), "vidrefs-"));
    try {
      expect(findReferencingSubjects(root, [])).toEqual([]);
    } finally {
      rmSync(root, { recursive: true, force: true });
    }
  });
});
