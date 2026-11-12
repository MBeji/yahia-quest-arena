// @vitest-environment node
import { describe, it, expect, vi } from "vitest";
import {
  collectSitemapPaths,
  renderSitemap,
  SITE_URL,
  SITEMAP_PAGE_SIZE,
} from "@/shared/lib/sitemap";

vi.mock("@/shared/lib/logger", () => ({
  logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() },
}));

type TableResult = { data?: unknown[] | null; error?: { message: string } | null };

/**
 * Minimal stub of the anon Supabase client, PostgREST-shaped:
 * `from(t).select(c)[.not(col, "is", null)][.neq(col, v)].order(k).range(a, b)`
 * applies the filters, then resolves to the slice `[a, b]`. `ranges` records every
 * page asked for and `selects` every column list, per table.
 */
function mockClient(
  tables: Record<string, TableResult>,
  ranges: Record<string, Array<[number, number]>> = {},
  selects: Record<string, string[]> = {},
): Parameters<typeof collectSitemapPaths>[0] {
  return {
    from(table: string) {
      const r = tables[table] ?? { data: [], error: null };
      let rows = (r.data ?? []) as Array<Record<string, unknown>>;
      const builder = {
        select(columns: string) {
          (selects[table] ??= []).push(columns);
          return builder;
        },
        not(column: string, op: string, value: unknown) {
          if (op === "is" && value === null) rows = rows.filter((row) => row[column] != null);
          return builder;
        },
        neq(column: string, value: unknown) {
          rows = rows.filter((row) => row[column] !== value);
          return builder;
        },
        order: () => builder,
        range(from: number, to: number) {
          (ranges[table] ??= []).push([from, to]);
          if (r.error) return Promise.resolve({ data: null, error: r.error });
          return Promise.resolve({ data: rows.slice(from, to + 1), error: null });
        },
      };
      return builder;
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
    expect(SITE_URL).toBe("https://www.na9ranal3ab.tn");
    expect(renderSitemap(["/"])).not.toContain("vercel.app");
  });

  it("declares the host prod actually serves — `www`, not the redirecting apex", () => {
    // The apex answers 308 → www (sondé le 2026-08-02). A `<loc>` on the apex
    // costs the crawler an extra round-trip on every one of the ~1 540 URLs, and
    // contradicts the origin we serve. Guard the host itself, not just the domain.
    expect(new URL(SITE_URL).host).toBe("www.na9ranal3ab.tn");
    expect(renderSitemap(["/programme"])).toContain(
      "<loc>https://www.na9ranal3ab.tn/programme</loc>",
    );
  });
});

describe("collectSitemapPaths", () => {
  it("always lists the static public pages", async () => {
    const paths = await collectSitemapPaths(mockClient(EMPTY));
    expect(paths).toEqual([
      "/",
      "/programme",
      "/programme/lycee/2eme",
      "/programme/lycee/3eme",
      "/programme/lycee/bac",
      "/extras",
      "/confidentialite",
      "/conditions",
      "/test-de-niveau",
    ]);
  });

  // La déclaration « child-directed » auprès de Google (é23 Q-3) exige une
  // politique de confidentialité ATTEIGNABLE : si elle sort du sitemap, la
  // démarche tombe sans que rien d'autre ne casse.
  it("garde la politique de confidentialité indexable, même sans catalogue", async () => {
    const paths = await collectSitemapPaths(mockClient(EMPTY));
    expect(paths).toContain("/confidentialite");
  });

  it("includes available levels and drops coming-soon ones", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        parcours: {
          data: [
            { id: "ecole-1ere-base", status: "available", theme_id: "scolaire", grade_id: "g1" },
            { id: "ecole-7eme-base", status: "coming_soon", theme_id: "scolaire", grade_id: "g7" },
          ],
        },
        subjects: {
          data: [
            { id: "math-1ere", theme_id: "scolaire", grade_id: "g1" },
            { id: "math-7eme", theme_id: "scolaire", grade_id: "g7" },
          ],
        },
      }),
    );
    expect(paths).toContain("/niveau/ecole-1ere-base");
    expect(paths).not.toContain("/niveau/ecole-7eme-base");
  });

  // Constat du 2026-11-12 : `/niveau/arabe` — « available », aucune matière, retiré
  // exprès du menu des extras — figurait au sitemap. Une page vide n'y a pas sa place.
  it("drops an available level that holds no subject", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        parcours: {
          data: [
            { id: "anglais", status: "available", theme_id: "anglais", grade_id: null },
            { id: "arabe", status: "available", theme_id: "arabe", grade_id: null },
            { id: "ecole-1ere-base", status: "available", theme_id: "scolaire", grade_id: "g1" },
          ],
        },
        subjects: {
          data: [
            { id: "anglais-a1", theme_id: "anglais", grade_id: null },
            // Même thème qu'un niveau scolaire, AUTRE classe : ne le peuple pas.
            { id: "math-2eme", theme_id: "scolaire", grade_id: "g2" },
          ],
        },
      }),
    );
    expect(paths).toContain("/niveau/anglais");
    expect(paths).not.toContain("/niveau/arabe");
    expect(paths).not.toContain("/niveau/ecole-1ere-base");
  });

  // On ne retire un niveau que sur une lecture RÉUSSIE des matières : une panne ne
  // doit pas vider le sitemap de ses niveaux.
  it("keeps every available level when the subjects read fails", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        subjects: { error: { message: "boom" } },
        parcours: {
          data: [{ id: "arabe", status: "available", theme_id: "arabe", grade_id: null }],
        },
      }),
    );
    expect(paths).toContain("/niveau/arabe");
  });

  // Pas de date de modification fiable en base : le sitemap n'en invente pas.
  it("never emits a lastmod", () => {
    expect(renderSitemap(["/", "/chapitre/abc"])).not.toContain("lastmod");
  });

  // Seuls des identifiants et des clés de rattachement voyagent — jamais un contenu.
  it("reads only ids and level keys for levels and subjects", async () => {
    const selects: Record<string, string[]> = {};
    await collectSitemapPaths(mockClient(EMPTY, {}, selects));
    expect(selects.parcours).toEqual(["id,status,theme_id,grade_id"]);
    expect(selects.subjects).toEqual(["id,theme_id,grade_id"]);
  });

  it("includes every anon-visible subject", async () => {
    const paths = await collectSitemapPaths(
      mockClient({ ...EMPTY, subjects: { data: [{ id: "francais-a1" }, { id: "math-9eme" }] } }),
    );
    expect(paths).toContain("/matiere/francais-a1");
    expect(paths).toContain("/matiere/math-9eme");
  });

  it("includes chapters that have lesson content, drops NULL and empty ones", async () => {
    const paths = await collectSitemapPaths(
      mockClient({
        ...EMPTY,
        chapters: {
          data: [
            { id: "ch-with", lesson_content: "# Leçon" },
            { id: "ch-null", lesson_content: null },
            { id: "ch-empty", lesson_content: "" },
          ],
        },
      }),
    );
    expect(paths).toContain("/chapitre/ch-with");
    expect(paths).not.toContain("/chapitre/ch-null");
    expect(paths).not.toContain("/chapitre/ch-empty");
  });

  // Régression du 2026-11-11 : lire `lesson_content` (1 000 leçons triées par page)
  // dépassait le statement timeout et TOUS les cours tombaient du sitemap. Le
  // filtre se fait en base ; seul l'id doit voyager.
  it("never downloads lesson bodies — only chapter ids travel", async () => {
    const selects: Record<string, string[]> = {};
    await collectSitemapPaths(
      mockClient(
        { ...EMPTY, chapters: { data: [{ id: "c", lesson_content: "# L" }] } },
        {},
        selects,
      ),
    );
    expect(selects.chapters).toEqual(["id"]);
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

  // Régression du 2026-11-11 : PostgREST plafonne chaque réponse à 1 000 lignes
  // sans le dire — le sitemap de prod listait 1 000 chapitres sur 1 171 et 858
  // exercices sur 6 648. Chaque table se lit donc page par page.
  it("reads every page of a table past the PostgREST row cap", async () => {
    const total = SITEMAP_PAGE_SIZE * 2 + 171;
    const exercises = Array.from({ length: total }, (_, i) => ({
      id: `ex-${i}`,
      mode: "practice",
      source: "admin",
    }));
    const ranges: Record<string, Array<[number, number]>> = {};
    const paths = await collectSitemapPaths(
      mockClient({ ...EMPTY, exercises: { data: exercises } }, ranges),
    );
    expect(paths.filter((p) => p.startsWith("/exercice/"))).toHaveLength(total);
    expect(paths).toContain(`/exercice/ex-${total - 1}`);
    expect(ranges.exercises).toEqual([
      [0, SITEMAP_PAGE_SIZE - 1],
      [SITEMAP_PAGE_SIZE, 2 * SITEMAP_PAGE_SIZE - 1],
      [2 * SITEMAP_PAGE_SIZE, 3 * SITEMAP_PAGE_SIZE - 1],
    ]);
  });

  it("asks for one more page when the last one is exactly full", async () => {
    const subjects = Array.from({ length: SITEMAP_PAGE_SIZE }, (_, i) => ({ id: `s-${i}` }));
    const ranges: Record<string, Array<[number, number]>> = {};
    const paths = await collectSitemapPaths(
      mockClient({ ...EMPTY, subjects: { data: subjects } }, ranges),
    );
    expect(paths.filter((p) => p.startsWith("/matiere/"))).toHaveLength(SITEMAP_PAGE_SIZE);
    expect(ranges.subjects).toHaveLength(2);
  });
});
