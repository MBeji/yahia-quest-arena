import { describe, it, expect, vi } from "vitest";
import { collectSitemapPaths, renderSitemap, SITE_URL } from "@/shared/lib/sitemap";

vi.mock("@/shared/lib/logger", () => ({
  logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() },
}));

type TableResult = { data?: unknown[] | null; error?: { message: string } | null };

/** Minimal stub of the anon Supabase client: `from(t).select(c)` resolves to a row set. */
function mockClient(
  tables: Record<string, TableResult>,
): Parameters<typeof collectSitemapPaths>[0] {
  return {
    from(table: string) {
      return {
        select() {
          const r = tables[table] ?? { data: [], error: null };
          return Promise.resolve({ data: r.data ?? null, error: r.error ?? null });
        },
      };
    },
  } as unknown as Parameters<typeof collectSitemapPaths>[0];
}

const EMPTY = {
  parcours: { data: [] },
  subjects: { data: [] },
  chapters: { data: [] },
  exercises: { data: [] },
};

describe("renderSitemap", () => {
  it("wraps paths into a urlset of absolute canonical-domain URLs", () => {
    const xml = renderSitemap(["/", "/programme"]);
    expect(xml).toContain('<?xml version="1.0" encoding="UTF-8"?>');
    expect(xml).toContain('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
    expect(xml).toContain(`<loc>${SITE_URL}/</loc>`);
    expect(xml).toContain(`<loc>${SITE_URL}/programme</loc>`);
    expect(xml.trim().endsWith("</urlset>")).toBe(true);
  });

  it("XML-escapes special characters in the URL", () => {
    const xml = renderSitemap(["/matiere/a&b"]);
    expect(xml).toContain(`<loc>${SITE_URL}/matiere/a&amp;b</loc>`);
    expect(xml).not.toContain("a&b</loc>");
  });

  it("uses the .tn custom domain, never a deployment host", () => {
    expect(SITE_URL).toBe("https://na9ranal3ab.tn");
    expect(renderSitemap(["/"])).not.toContain("vercel.app");
  });
});

describe("collectSitemapPaths", () => {
  it("always lists the static public pages", async () => {
    const paths = await collectSitemapPaths(mockClient(EMPTY));
    expect(paths).toEqual(["/", "/programme", "/extras"]);
  });

  it("includes available levels and drops coming-soon ones", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        parcours: {
          data: [
            { id: "ecole-1ere-base", status: "available" },
            { id: "ecole-7eme-base", status: "coming_soon" },
          ],
        },
      }),
    );
    expect(paths).toContain("/niveau/ecole-1ere-base");
    expect(paths).not.toContain("/niveau/ecole-7eme-base");
  });

  it("includes every anon-visible subject", async () => {
    const paths = await collectSitemapPaths(
      mockClient({ ...EMPTY, subjects: { data: [{ id: "francais-a1" }, { id: "math-9eme" }] } }),
    );
    expect(paths).toContain("/matiere/francais-a1");
    expect(paths).toContain("/matiere/math-9eme");
  });

  it("includes chapters that have lesson content, drops empty ones", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        chapters: {
          data: [
            { id: "ch-with", lesson_content: "# Leçon" },
            { id: "ch-null", lesson_content: null },
            { id: "ch-blank", lesson_content: "   " },
          ],
        },
      }),
    );
    expect(paths).toContain("/chapitre/ch-with");
    expect(paths).not.toContain("/chapitre/ch-null");
    expect(paths).not.toContain("/chapitre/ch-blank");
  });

  it("includes admin practice exercises, drops quizzes and non-admin content", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        exercises: {
          data: [
            { id: "ex-practice", mode: "practice", source: "admin" },
            { id: "ex-boss", mode: "boss", source: "admin" },
            { id: "ex-quiz", mode: "quiz", source: "admin" },
            { id: "ex-parent", mode: "practice", source: "parent" },
          ],
        },
      }),
    );
    expect(paths).toContain("/exercice/ex-practice");
    expect(paths).toContain("/exercice/ex-boss");
    expect(paths).not.toContain("/exercice/ex-quiz");
    expect(paths).not.toContain("/exercice/ex-parent");
  });

  it("ships a partial sitemap when one table query fails", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        subjects: { error: { message: "boom" } },
        parcours: { data: [{ id: "ecole-1ere-base", status: "available" }] },
      }),
    );
    // The failed subjects query is skipped, but the rest still ship.
    expect(paths).toContain("/niveau/ecole-1ere-base");
    expect(paths).toContain("/");
    expect(paths.some((p) => p.startsWith("/matiere/"))).toBe(false);
  });
});
