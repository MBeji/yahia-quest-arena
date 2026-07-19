import { describe, it, expect } from "vitest";
import { mkdtempSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  chapterMetaSchema,
  exerciseSchema,
  toCompiledVideo,
  videoEntrySchema,
  videoRegistrySchema,
  type VideoEntry,
  type VideoRegistry,
} from "../schema.ts";
import { loadVideosRegistry, ContentValidationError } from "../loader.ts";
import { buildMigrationSql } from "../sql-builder.ts";
import { auditVideoRefs, auditVideoRegistry } from "../../../../scripts/content/qa-checks.ts";

/**
 * Étude 23 — vidéos explicatives, lot 1 (socle données). Exercises the four
 * pipeline layers the registry touches: schema, loader, sql-builder, content:qa.
 */

const validEntry = (over: Partial<VideoEntry> = {}): VideoEntry => ({
  provider: "youtube",
  videoId: "AbCdEfGhIjK",
  title: "Théorème de Thalès — la configuration",
  channel: "Maths et tiques",
  channelUrl: "https://www.youtube.com/@MathsetTiques",
  lang: "fr",
  durationSec: 480,
  kind: "teacher",
  grades: ["9eme-base"],
  notions: ["configuration de Thalès"],
  madeForKids: false,
  addedOn: "2026-07-20",
  verifiedOn: "2026-07-20",
  verifiedBy: "Mohamed",
  status: "active",
  ...over,
});

describe("étude 23 — video registry schema", () => {
  it("accepts a well-formed registry entry", () => {
    expect(videoEntrySchema.safeParse(validEntry()).success).toBe(true);
  });

  it("rejects a videoId that is not a valid youtube id", () => {
    expect(videoEntrySchema.safeParse(validEntry({ videoId: "too-short" })).success).toBe(false);
    expect(
      videoEntrySchema.safeParse(validEntry({ videoId: "waytoolongforyoutube" })).success,
    ).toBe(false);
  });

  it("rejects an unknown status and a non-ISO date", () => {
    expect(
      videoEntrySchema.safeParse(validEntry({ status: "dead" as unknown as VideoEntry["status"] }))
        .success,
    ).toBe(false);
    expect(videoEntrySchema.safeParse(validEntry({ addedOn: "20/07/2026" })).success).toBe(false);
  });

  it("rejects a grade hint that is not a canonical slug", () => {
    expect(videoEntrySchema.safeParse(validEntry({ grades: ["neuvieme"] })).success).toBe(false);
  });

  it("validates the registry as a keyed record", () => {
    const reg = { "math.thales-configuration": validEntry() };
    expect(videoRegistrySchema.safeParse(reg).success).toBe(true);
  });

  it("caps chapter video refs at 3 and rejects duplicates", () => {
    const base = { title: "t", description: "d", displayOrder: 1 };
    expect(chapterMetaSchema.safeParse({ ...base, videos: ["a.one", "b.two"] }).success).toBe(true);
    expect(
      chapterMetaSchema.safeParse({ ...base, videos: ["a.1", "b.2", "c.3", "d.4"] }).success,
    ).toBe(false);
    expect(chapterMetaSchema.safeParse({ ...base, videos: ["a.dup", "a.dup"] }).success).toBe(
      false,
    );
  });

  it("rejects a malformed video ref id on a chapter", () => {
    const base = { title: "t", description: "d", displayOrder: 1 };
    expect(chapterMetaSchema.safeParse({ ...base, videos: ["Math.Bad"] }).success).toBe(false);
  });

  it("accepts an optional correctionVideo ref on an exercise and rejects a malformed one", () => {
    const ex = {
      title: "exo",
      difficulty: 2,
      mode: "practice",
      xpReward: 50,
      rewardCoins: 10,
      displayOrder: 1,
      questions: [
        {
          type: "mcq",
          prompt: "q?",
          explanation: "e",
          options: [
            { id: "a", text: "1" },
            { id: "b", text: "2" },
          ],
          correctOption: "a",
        },
      ],
    };
    expect(
      exerciseSchema.safeParse({ ...ex, correctionVideo: "math.thales-erreurs" }).success,
    ).toBe(true);
    expect(exerciseSchema.safeParse({ ...ex, correctionVideo: "Math.BAD" }).success).toBe(false);
    // Absent is valid (the field is optional).
    expect(exerciseSchema.safeParse(ex).success).toBe(true);
  });
});

describe("étude 23 — toCompiledVideo", () => {
  it("keeps only the display subset (no free URL, no curation trail)", () => {
    const c = toCompiledVideo("math.thales-configuration", validEntry());
    expect(c).toEqual({
      id: "math.thales-configuration",
      provider: "youtube",
      videoId: "AbCdEfGhIjK",
      title: "Théorème de Thalès — la configuration",
      channel: "Maths et tiques",
      lang: "fr",
      durationSec: 480,
    });
    expect(c).not.toHaveProperty("channelUrl");
    expect(c).not.toHaveProperty("verifiedBy");
    expect(c).not.toHaveProperty("status");
  });

  it("carries start/end only when the entry defines an extract", () => {
    const c = toCompiledVideo("x.y", validEntry({ startSec: 312, endSec: 540 }));
    expect(c.startSec).toBe(312);
    expect(c.endSec).toBe(540);
  });
});

describe("étude 23 — loadVideosRegistry", () => {
  it("returns an empty registry when content/videos.json is absent", () => {
    const dir = mkdtempSync(join(tmpdir(), "vids-"));
    try {
      expect(loadVideosRegistry(dir)).toEqual({});
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("parses a present, valid registry", () => {
    const dir = mkdtempSync(join(tmpdir(), "vids-"));
    try {
      writeFileSync(
        join(dir, "videos.json"),
        JSON.stringify({ "math.thales-configuration": validEntry() }),
      );
      expect(Object.keys(loadVideosRegistry(dir))).toEqual(["math.thales-configuration"]);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("throws on a malformed registry", () => {
    const dir = mkdtempSync(join(tmpdir(), "vids-"));
    try {
      writeFileSync(join(dir, "videos.json"), JSON.stringify({ "math.x": { provider: "vimeo" } }));
      expect(() => loadVideosRegistry(dir)).toThrow(ContentValidationError);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("étude 23 — sql-builder compilation", () => {
  const registry: VideoRegistry = {
    "math.active": validEntry({ videoId: "AAAAAAAAAAA", lang: "ar" }),
    "math.retired": validEntry({ videoId: "BBBBBBBBBBB", lang: "ar", status: "retired" }),
    "math.extract": validEntry({ videoId: "CCCCCCCCCCC", lang: "ar", startSec: 60, endSec: 180 }),
  };

  const makeSubject = (chapterVideos: string[], correctionVideo?: string) => ({
    meta: {
      id: "math",
      nameFr: "الرياضيات",
      description: "d",
      attribute: "Force",
      colorToken: "subject-math",
      icon: "Calculator",
      displayOrder: 1,
      contentLanguage: "ar" as const,
      themeId: "ecole-tn",
      gradeSlug: "9eme-base",
      isPremium: false,
    },
    chapters: [
      {
        slug: "01-foo",
        meta: {
          title: "الفصل",
          description: "d",
          displayOrder: 1,
          sources: [],
          videos: chapterVideos,
        },
        lesson: "# cours",
        summary: "## résumé",
        quiz: {
          questions: [
            {
              type: "mcq" as const,
              prompt: "q؟",
              options: [
                { id: "a", text: "1" },
                { id: "b", text: "2" },
              ],
              correctOption: "a",
              explanation: "ج",
            },
          ],
        },
        exercises: [
          {
            slug: "ex1",
            data: {
              title: "exo",
              difficulty: 1,
              mode: "practice" as const,
              xpReward: 50,
              rewardCoins: 10,
              displayOrder: 1,
              ...(correctionVideo ? { correctionVideo } : {}),
              questions: [
                {
                  type: "mcq" as const,
                  prompt: "2+2 ?",
                  options: [
                    { id: "a", text: "3" },
                    { id: "b", text: "4" },
                  ],
                  correctOption: "b",
                  explanation: "= 4",
                },
              ],
            },
          },
        ],
      },
    ],
  });

  it("compiles an active chapter video into chapters.videos with the display shape", () => {
    const sql = buildMigrationSql(makeSubject(["math.active", "math.extract"]), registry);
    expect(sql).toContain("display_order, manuel_ref, videos) VALUES");
    expect(sql).toContain("videos = EXCLUDED.videos");
    expect(sql).toContain('"id":"math.active"');
    expect(sql).toContain('"videoId":"AAAAAAAAAAA"');
    // The extract carries its start/end.
    expect(sql).toContain('"startSec":60');
    expect(sql).toContain('"endSec":180');
    // No free URL / curation trail ever reaches the compiled column (D-10).
    expect(sql).not.toContain("channelUrl");
    expect(sql).not.toContain("verifiedBy");
  });

  it("excludes non-active and unknown refs from the compiled array", () => {
    const sql = buildMigrationSql(
      makeSubject(["math.active", "math.retired", "math.ghost"]),
      registry,
    );
    expect(sql).toContain('"id":"math.active"');
    expect(sql).not.toContain('"id":"math.retired"');
    expect(sql).not.toContain('"id":"math.ghost"');
  });

  it("emits an empty videos array and NULL correction_video with no refs / empty registry", () => {
    const sql = buildMigrationSql(makeSubject([]), {});
    expect(sql).toContain("display_order, manuel_ref, videos) VALUES");
    expect(sql).toContain("'[]'::jsonb)"); // chapter videos default
    expect(sql).toContain("source, display_order, correction_video) VALUES");
    // The exercise row ends with a NULL correction_video.
    expect(sql).toMatch(/'admin', 1, NULL\)/);
  });

  it("compiles an exercise correction_video from an active ref", () => {
    const sql = buildMigrationSql(makeSubject([], "math.active"), registry);
    expect(sql).toContain("correction_video = EXCLUDED.correction_video");
    expect(sql).toContain('"id":"math.active"');
  });

  it("leaves correction_video NULL for a non-active ref", () => {
    const sql = buildMigrationSql(makeSubject([], "math.retired"), registry);
    expect(sql).toMatch(/'admin', 1, NULL\)/);
  });
});

describe("étude 23 — content:qa cross-checks", () => {
  const registry = {
    "math.ok": { lang: "ar", status: "active", durationSec: 300, verifiedOn: "2026-07-20" },
    "math.broken": { lang: "ar", status: "broken", durationSec: 300, verifiedOn: "2026-07-20" },
    "math.fr": { lang: "fr", status: "active", durationSec: 300, verifiedOn: "2026-07-20" },
  };

  describe("auditVideoRegistry", () => {
    it("passes a clean registry", () => {
      expect(auditVideoRegistry(registry, new Set()).length).toBe(0);
    });

    it("flags an active entry without verifiedOn", () => {
      const f = auditVideoRegistry(
        { "m.x": { lang: "ar", status: "active", durationSec: 100 } },
        new Set(),
      );
      expect(f.some((x) => x.level === "error" && /verifiedOn/.test(x.msg))).toBe(true);
    });

    it("flags endSec without startSec and endSec <= startSec", () => {
      const noStart = auditVideoRegistry(
        {
          "m.x": {
            lang: "ar",
            status: "active",
            durationSec: 100,
            verifiedOn: "2026-07-20",
            endSec: 50,
          },
        },
        new Set(),
      );
      expect(noStart.some((x) => x.level === "error" && /without a startSec/.test(x.msg))).toBe(
        true,
      );
      const inverted = auditVideoRegistry(
        {
          "m.x": {
            lang: "ar",
            status: "active",
            durationSec: 100,
            verifiedOn: "2026-07-20",
            startSec: 100,
            endSec: 100,
          },
        },
        new Set(),
      );
      expect(inverted.some((x) => x.level === "error" && /greater than startSec/.test(x.msg))).toBe(
        true,
      );
    });

    it("warns on a video longer than 15 min", () => {
      const f = auditVideoRegistry(
        { "m.x": { lang: "ar", status: "active", durationSec: 1200, verifiedOn: "2026-07-20" } },
        new Set(),
      );
      expect(f.some((x) => x.level === "warn" && /exceeds 15 min/.test(x.msg))).toBe(true);
    });

    it("errors on an unknown evaluated competency", () => {
      const f = auditVideoRegistry(
        {
          "m.x": {
            lang: "ar",
            status: "active",
            durationSec: 300,
            verifiedOn: "2026-07-20",
            competencies: ["math.geo.ghost"],
          },
        },
        new Set(["math.geo.thales-direct"]),
      );
      expect(f.some((x) => x.level === "error" && /not declared/.test(x.msg))).toBe(true);
    });
  });

  describe("auditVideoRefs", () => {
    it("passes an active ref in the subject language", () => {
      expect(auditVideoRefs(["math.ok"], registry, "ar", "math/01").length).toBe(0);
    });

    it("errors on an unknown ref", () => {
      const f = auditVideoRefs(["math.ghost"], registry, "ar", "math/01");
      expect(f[0].level).toBe("error");
      expect(f[0].msg).toContain("not declared");
    });

    it("errors on a non-active ref", () => {
      const f = auditVideoRefs(["math.broken"], registry, "ar", "math/01");
      expect(f.some((x) => x.level === "error" && /status is "broken"/.test(x.msg))).toBe(true);
    });

    it("errors on a language mismatch", () => {
      const f = auditVideoRefs(["math.fr"], registry, "ar", "math/01");
      expect(f.some((x) => x.level === "error" && /contentLanguage/.test(x.msg))).toBe(true);
    });
  });
});
