import { describe, it, expect, vi } from "vitest";
import type { SupabaseClient } from "@supabase/supabase-js";
import { parseCompiledVideo, resolveCorrectionVideo } from "../correction-video";

/** Étude 23 lot 3 — R-6 resolution of the result-screen review video. */

const video = (over: Record<string, unknown> = {}) => ({
  id: "math.thales",
  provider: "youtube",
  videoId: "AbCdEfGhIjK",
  title: "Thalès",
  channel: "Maths et tiques",
  lang: "fr",
  durationSec: 480,
  ...over,
});

/** Minimal supabase stub: from("chapters").select().eq().single() → { data }. */
function stubSupabase(chapterRow: unknown) {
  const single = vi.fn().mockResolvedValue({ data: chapterRow, error: null });
  const eq = vi.fn().mockReturnValue({ single });
  const select = vi.fn().mockReturnValue({ eq });
  const from = vi.fn().mockReturnValue({ select });
  return { client: { from } as unknown as SupabaseClient, from, select, eq };
}

describe("parseCompiledVideo — defense in depth (D-10)", () => {
  it("accepts a well-formed compiled video", () => {
    expect(parseCompiledVideo(video())?.videoId).toBe("AbCdEfGhIjK");
  });

  it("rejects a malformed videoId, a bad provider and non-objects", () => {
    expect(parseCompiledVideo(video({ videoId: "nope" }))).toBeNull();
    expect(parseCompiledVideo(video({ provider: "vimeo" }))).toBeNull();
    expect(parseCompiledVideo(null)).toBeNull();
    expect(parseCompiledVideo("not-an-object")).toBeNull();
    expect(parseCompiledVideo({})).toBeNull();
  });
});

describe("resolveCorrectionVideo — R-6 (exercise > chapter > none)", () => {
  it("prefers the exercise's own correction_video and skips the chapter read", async () => {
    const sb = stubSupabase({ videos: [video({ id: "math.chapter-one" })] });
    const got = await resolveCorrectionVideo(sb.client, {
      correction_video: video({ id: "math.exercise-one" }),
      chapter_id: "ch-1",
    });
    expect(got?.id).toBe("math.exercise-one");
    // The exercise's own video wins — no chapter round-trip.
    expect(sb.from).not.toHaveBeenCalled();
  });

  it("falls back to the chapter's FIRST video when the exercise has none", async () => {
    const sb = stubSupabase({
      videos: [video({ id: "math.first" }), video({ id: "math.second" })],
    });
    const got = await resolveCorrectionVideo(sb.client, { chapter_id: "ch-1" });
    expect(got?.id).toBe("math.first");
    expect(sb.from).toHaveBeenCalledWith("chapters");
    expect(sb.eq).toHaveBeenCalledWith("id", "ch-1");
  });

  it("returns null when the exercise has no chapter", async () => {
    const sb = stubSupabase(null);
    expect(await resolveCorrectionVideo(sb.client, { chapter_id: null })).toBeNull();
    expect(sb.from).not.toHaveBeenCalled();
  });

  it("returns null when the chapter carries an empty video list", async () => {
    const sb = stubSupabase({ videos: [] });
    expect(await resolveCorrectionVideo(sb.client, { chapter_id: "ch-1" })).toBeNull();
  });

  it("returns null when the stored JSONB is malformed (never a half-built embed)", async () => {
    const sb = stubSupabase({ videos: [{ id: "x", provider: "youtube", videoId: "bad" }] });
    expect(await resolveCorrectionVideo(sb.client, { chapter_id: "ch-1" })).toBeNull();
  });

  it("falls back to the chapter when the exercise's own video is malformed", async () => {
    const sb = stubSupabase({ videos: [video({ id: "math.chapter-one" })] });
    const got = await resolveCorrectionVideo(sb.client, {
      correction_video: { id: "broken", provider: "youtube", videoId: "nope" },
      chapter_id: "ch-1",
    });
    expect(got?.id).toBe("math.chapter-one");
  });
});
