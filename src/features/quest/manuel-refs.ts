/**
 * Zero-import module — the manuel-élève volume shape shared by the subject-page
 * card and its tests, kept out of the component file (react-refresh) and out of
 * the server module (client bundle).
 */

/** One authored manuel volume, as stored in `subjects.manuel_refs`. */
export type ManuelRef = { code: string; label: string | null };

/**
 * Defensive parse of `subjects.manuel_refs` (JSONB straight from the DB row —
 * kept schema-light on purpose: this runs in the client bundle, and the value
 * is produced by our own content pipeline). Anything malformed → [] → no card.
 */
export function parseManuelRefs(value: unknown): ManuelRef[] {
  if (!Array.isArray(value)) return [];
  const out: ManuelRef[] = [];
  for (const entry of value) {
    if (!entry || typeof entry !== "object") return [];
    const { code, label } = entry as { code?: unknown; label?: unknown };
    if (typeof code !== "string" || !/^[A-Za-z0-9_-]+$/.test(code)) return [];
    out.push({ code, label: typeof label === "string" && label.length > 0 ? label : null });
  }
  return out;
}

/**
 * One chapter's link into the manuel, as stored in `chapters.manuel_ref`:
 * the book `code`, the authored page expression (`"18-30"`, `"12, 14-16"` —
 * for display) and its expansion (for the anchor and the pages gallery).
 */
export type ChapterManuelRef = { code: string; pages: string; pageNumbers: number[] };

/** A page expression as the authoring schema builds it: digits, ranges, commas. */
const PAGES_EXPR_RE = /^[\d\s,-]+$/;

/**
 * Defensive parse of `chapters.manuel_ref` (JSONB straight from the DB row) —
 * same posture as {@link parseManuelRefs}: this runs in the client bundle
 * against a value our own pipeline produced, so it stays schema-light, and
 * anything malformed collapses to `null` → no link rendered.
 *
 * `pages` is re-checked here even though the build validated it: it is the one
 * field that reaches the reader as free text, and a shape check costs nothing.
 */
export function parseChapterManuelRef(value: unknown): ChapterManuelRef | null {
  if (!value || typeof value !== "object" || Array.isArray(value)) return null;
  const { code, pages, pageNumbers } = value as {
    code?: unknown;
    pages?: unknown;
    pageNumbers?: unknown;
  };
  if (typeof code !== "string" || !/^[A-Za-z0-9_-]+$/.test(code)) return null;
  if (typeof pages !== "string" || !PAGES_EXPR_RE.test(pages)) return null;
  if (
    !Array.isArray(pageNumbers) ||
    pageNumbers.length === 0 ||
    !pageNumbers.every((p) => typeof p === "number" && Number.isInteger(p) && p > 0)
  ) {
    return null;
  }
  return { code, pages, pageNumbers: pageNumbers as number[] };
}
