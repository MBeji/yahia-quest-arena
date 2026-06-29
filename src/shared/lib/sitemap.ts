import { createPublicSupabaseClient } from "@/shared/integrations/supabase/public-client";
import { logger } from "@/shared/lib/logger";

/**
 * Canonical public origin for indexable URLs. Search engines must index the
 * custom domain, never the *.vercel.app deployment, so every `<loc>` is an
 * absolute na9ranal3ab.tn URL regardless of the host that served the sitemap.
 */
export const SITE_URL = "https://na9ranal3ab.tn";

type SitemapClient = ReturnType<typeof createPublicSupabaseClient>;

/** Static public pages, always present and independent of catalogue data. */
const STATIC_PATHS = ["/", "/programme", "/extras"] as const;

function escapeXml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;");
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
    supabase.from("parcours").select("id,status"),
    supabase.from("subjects").select("id"),
    supabase.from("chapters").select("id,lesson_content"),
    supabase.from("exercises").select("id,mode,source"),
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
      if (c.lesson_content && c.lesson_content.trim().length > 0) paths.push(`/chapitre/${c.id}`);
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
