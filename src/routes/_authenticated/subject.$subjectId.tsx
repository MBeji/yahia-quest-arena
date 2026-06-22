import { createFileRoute, redirect } from "@tanstack/react-router";

/**
 * The subject hub moved to the public « Référence » register at
 * `/matiere/$subjectId` (chantier C8). This legacy path is kept as a permanent
 * (301) redirect so old links/bookmarks and in-app navigation resolve.
 * `beforeLoad` runs before the `_authenticated` guard (a component-level effect),
 * so an anonymous visitor lands on the public subject page, not on login.
 */
export const Route = createFileRoute("/_authenticated/subject/$subjectId")({
  beforeLoad: ({ params }) => {
    throw redirect({
      to: "/matiere/$subjectId",
      params: { subjectId: params.subjectId },
      statusCode: 301,
      replace: true,
    });
  },
});
