import { useRouterState } from "@tanstack/react-router";
import { SITE_URL } from "@/shared/constants/site";

/**
 * `<link rel="canonical">` for the public (indexable) shell.
 *
 * WHY IT EXISTS. The sitemap and `robots.txt` both declare `SITE_URL` as the
 * origin, but nothing in the served HTML said so — a crawler reaching a page by
 * any other route (the apex before its 308, a `?utm_*` link, an old
 * `*.vercel.app` URL) had no statement of which URL is the real one, and decided
 * for itself. This tag says it outright, on every public page.
 *
 * WHY THE QUERY STRING IS DROPPED. None of our public routes vary their content
 * by query parameter — the path fully determines the page. So `?utm_source=fb`
 * and the bare path are the same document, and pointing both at the bare path is
 * exactly what a canonical is for. If a public route ever *does* become
 * query-dependent (a paginated list, a filtered catalogue), it must declare its
 * own canonical instead of inheriting this one.
 *
 * WHY IT IS A COMPONENT AND NOT A `head()` ENTRY. The root route's `head()`
 * cannot see the matched pathname, and it is not re-evaluated on client
 * navigation — a canonical built there would be right at SSR and stale the
 * moment the visitor clicks a link. React 19 hoists `<link>` from anywhere in
 * the tree into `<head>`, so rendering it here gives the correct tag on the SSR
 * pass *and* keeps it in step with every navigation.
 *
 * WHY ONLY THE PUBLIC SHELL. Authenticated pages are not indexable and carry no
 * canonical: pointing a crawler at a URL it will be redirected away from is
 * worse than saying nothing.
 */
export function CanonicalLink() {
  const pathname = useRouterState({ select: (s) => s.location.pathname });
  // Collapse the root path so the canonical of "/" is the bare origin, and drop
  // any trailing slash elsewhere ("/programme/" and "/programme" are one page).
  const path = pathname === "/" ? "" : pathname.replace(/\/+$/, "");
  return <link rel="canonical" href={`${SITE_URL}${path}`} />;
}
