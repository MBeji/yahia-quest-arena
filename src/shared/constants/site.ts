/**
 * Canonical public origin for indexable URLs. Two distinct rules land here.
 *
 * 1. Search engines must index the custom domain, never the *.vercel.app
 *    deployment — so every public URL we emit is absolute on this origin,
 *    regardless of the host that served the page.
 * 2. The host is **`www`**, because that is the host prod actually serves.
 *    The apex answers `308 → www` (sondé le 2026-08-02). Declaring the apex —
 *    which we did until then — meant every one of the ~1 540 sitemap entries
 *    pointed at a redirect: a crawler paid two round-trips per URL, and the
 *    origin we *declared* contradicted the one we *served*.
 *
 * Changing this is a canonical-host decision, not a detail. Three things name
 * the same host and move together or not at all: this constant, the `Sitemap:`
 * line of `public/robots.txt`, and the Vercel apex→www redirect.
 *
 * WHY IT LIVES HERE AND NOT IN `shared/lib/sitemap.ts`, where it started: the
 * public shell renders `<CanonicalLink>` on every page, and importing the
 * constant from the sitemap module would drag that module's dependencies — the
 * Supabase public client, the logger, the catalogue queries — into the client
 * bundle for the sake of one string. A constant with no imports has no such cost.
 */
export const SITE_URL = "https://www.na9ranal3ab.tn";
