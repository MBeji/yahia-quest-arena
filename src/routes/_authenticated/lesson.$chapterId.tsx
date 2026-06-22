import { createFileRoute, redirect } from "@tanstack/react-router";

/**
 * The lesson reader moved to the public « Référence » register at
 * `/chapitre/$chapterId` (chantier C8). This legacy path is kept as a permanent
 * (301) redirect so old links/bookmarks and the in-app quiz/exercise CTAs still
 * resolve. `beforeLoad` runs before the `_authenticated` guard (which is a
 * component-level effect, not a `beforeLoad`), so it redirects an anonymous
 * visitor straight to the public course reader instead of bouncing them to login.
 */
export const Route = createFileRoute("/_authenticated/lesson/$chapterId")({
  beforeLoad: ({ params }) => {
    throw redirect({
      to: "/chapitre/$chapterId",
      params: { chapterId: params.chapterId },
      statusCode: 301,
      replace: true,
    });
  },
});
