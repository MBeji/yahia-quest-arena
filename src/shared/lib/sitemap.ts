import { createPublicSupabaseClient } from "@/shared/integrations/supabase/public-client";
import { logger } from "@/shared/lib/logger";

/**
 * Canonical public origin for every `<loc>`. Defined in `shared/constants/site`
 * (a dependency-free module, so the public shell can render its
 * `<link rel="canonical">` without pulling this file's Supabase client into the
 * client bundle) and re-exported here, where sitemap consumers expect it.
 */
export { SITE_URL } from "@/shared/constants/site";
import { SITE_URL } from "@/shared/constants/site";

type SitemapClient = ReturnType<typeof createPublicSupabaseClient>;

/** Static public pages, always present and independent of catalogue data. */
const STATIC_PATHS = [
  "/",
  "/programme",
  "/extras",
  // Pages légales : URL stables et indexables — la déclaration « child-directed »
  // auprès de Google exige une politique de confidentialité atteignable (é23 Q-3).
  "/confidentialite",
  "/conditions",
  // Le test de niveau (étude 39) : la porte d'entrée partageable, indexable comme le catalogue.
  "/test-de-niveau",
] as const;

function escapeXml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;");
}

/**
 * PostgREST caps every response at `max_rows` (1 000 on Supabase by default) and
 * truncates SILENTLY: the sitemap of 2026-11-11 listed exactly 1 000 chapters out
 * of 1 171 and 858 exercises out of 6 648. Every table is therefore read page by
 * page, in a stable order, until a short page says there is nothing left.
 */
export const SITEMAP_PAGE_SIZE = 1000;

type Page<Row> = { data: Row[] | null; error: { message: string } | null };
type PageQuery = (
  from: number,
  to: number,
) => PromiseLike<{ data: unknown[] | null; error: { message: string } | null }>;

async function fetchAllRows<Row>(query: PageQuery): Promise<Page<Row>> {
  const rows: Row[] = [];
  for (let from = 0; ; from += SITEMAP_PAGE_SIZE) {
    const { data, error } = await query(from, from + SITEMAP_PAGE_SIZE - 1);
    if (error) return { data: null, error };
    const page = (data ?? []) as Row[];
    rows.push(...page);
    if (page.length < SITEMAP_PAGE_SIZE) return { data: rows, error: null };
  }
}

/**
 * Collect every public, indexable path from the anon-visible catalogue. RLS
 * already restricts the anon client to public content; on top of that we drop
 * pages that have no real indexable content:
 *  - levels (`parcours`) that are not yet `available` (they render "bientôt"),
 *  - chapters with no `lesson_content` (the reader shows a coming-soon state),
 *  - comprehension quizzes (`mode: "quiz"`) and any non-`admin` exercise (the
 *    public practice page only renders an account upsell for those).
 *
 * A failing table query is logged and skipped so a partial sitemap still ships
 * rather than failing the whole document.
 */
export async function collectSitemapPaths(supabase: SitemapClient): Promise<string[]> {
  const paths: string[] = [...STATIC_PATHS];

  const [parcours, subjects, chapters, exercises] = await Promise.all([
    fetchAllRows<{ id: string; status: string }>((from, to) =>
      supabase.from("parcours").select("id,status").order("id").range(from, to),
    ),
    fetchAllRows<{ id: string }>((from, to) =>
      supabase.from("subjects").select("id").order("id").range(from, to),
    ),
    // Le filtre « a une leçon » se fait EN BASE et seul l'id voyage. Lire
    // `lesson_content` pour le tester ici (~30 Ko par leçon, 1 000 par page, triées)
    // dépassait le statement timeout (57014, constaté en prod le 2026-11-11) : la
    // table entière tombait du sitemap. Même sémantique que les voisins du lecteur
    // (`quest.lesson.server.ts`) : NULL et chaîne vide = pas de leçon.
    fetchAllRows<{ id: string }>((from, to) =>
      supabase
        .from("chapters")
        .select("id")
        .not("lesson_content", "is", null)
        .neq("lesson_content", "")
        .order("id")
        .range(from, to),
    ),
    fetchAllRows<{ id: string; mode: string; source: string }>((from, to) =>
      supabase.from("exercises").select("id,mode,source").order("id").range(from, to),
    ),
  ]);

  if (parcours.error) {
    logger.warn("sitemap: parcours query failed", { error: parcours.error.message });
  } else {
    for (const p of parcours.data ?? []) {
      if (p.status === "available") paths.push(`/niveau/${p.id}`);
    }
  }

  if (subjects.error) {
    logger.warn("sitemap: subjects query failed", { error: subjects.error.message });
  } else {
    for (const s of subjects.data ?? []) {
      paths.push(`/matiere/${s.id}`);
    }
  }

  if (chapters.error) {
    logger.warn("sitemap: chapters query failed", { error: chapters.error.message });
  } else {
    for (const c of chapters.data ?? []) {
      paths.push(`/chapitre/${c.id}`);
    }
  }

  if (exercises.error) {
    logger.warn("sitemap: exercises query failed", { error: exercises.error.message });
  } else {
    for (const e of exercises.data ?? []) {
      if (e.source === "admin" && e.mode !== "quiz") paths.push(`/exercice/${e.id}`);
    }
  }

  return paths;
}

/** Render a sitemap XML document from a list of site-relative paths. */
export function renderSitemap(paths: string[]): string {
  const entries = paths
    .map((path) => `  <url>\n    <loc>${escapeXml(SITE_URL + path)}</loc>\n  </url>`)
    .join("\n");
  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${entries}\n</urlset>\n`;
}

/**
 * Build the full sitemap document for the public catalogue. Called by the
 * `/sitemap.xml` handler in `src/server.ts`, which runs outside a server-fn
 * middleware context — so this creates its own anon Supabase client.
 *
 * A single sitemap holds up to 50 000 URLs / 50 MB (sitemaps.org). The catalogue
 * is far below that today; if it ever approaches the cap, split into a sitemap
 * index keyed by section (one child sitemap per parcours/subject).
 */
export async function generateSitemap(): Promise<string> {
  const supabase = createPublicSupabaseClient();
  const paths = await collectSitemapPaths(supabase);
  return renderSitemap(paths);
}
