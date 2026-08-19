/**
 * Zero-import module — how a CNP book code becomes a link to the official
 * student textbook (manuel élève) hosted by the Centre National Pédagogique.
 *
 * The doctrine is the one étude 23 D-10 set for videos: **no free URL travels
 * through the content pipeline**. Content declares a `code` (already validated,
 * already cross-checked against the CNP corpus registry by `content:qa`), and
 * the link is rebuilt here by template. A typo can therefore only produce a
 * missing document, never an arbitrary destination in a student's browser.
 *
 * Kept import-free on purpose: it is read by the course reader (client bundle),
 * by the content QA gate (node) and by tests, and none of them should drag zod
 * or the loader along.
 */

/**
 * Where the CNP serves its textbook PDFs — a flat store keyed by the official
 * file name, so `102905` (maths, 9ème année de base) resolves to
 * `<base>/102905P00.pdf`. Confirmed against the live store by Mohamed on
 * 2026-08-19.
 *
 * ⚠️ **The single value to re-point if the CNP moves its store.** Everything
 * else in the manuel-link chain derives from the codes already in `content/`.
 */
export const CNP_MANUEL_BASE_URL = "https://www.cnp.com.tn/arabic/PDF";

/**
 * Charset of a book code — deliberately the SAME as the authoring schema's
 * (`subject.manuels[].code`, `chapter.manuel.code`) rather than stricter: a code
 * the schema accepts must never yield a silently hidden card. It excludes every
 * character that could escape the path (`/ : ? # %`), so a code can only ever
 * name a file inside the store.
 */
const CNP_CODE_RE = /^[A-Za-z0-9_-]+$/;

/** A code already carrying its volume suffix — `102105P01`, `241403P00`. */
const CNP_TOME_SUFFIX_RE = /P\d{2}$/;

/**
 * The official PDF file name for a book code, or `null` if the code is not a
 * code shape we accept.
 *
 * The corpus registry (`suivi/corpus-cnp.json`) names each document
 * `<code><tome>.pdf`, and the corpus itself is what makes the default safe:
 * every bare 6-digit code authored today is a single-volume work whose only
 * tome is `P00`, and every multi-volume work is authored with its tome spelled
 * out (`102105P01` / `102105P02`). So: keep an explicit suffix, add `P00` when
 * there is none.
 */
export function cnpManuelFileName(code: string): string | null {
  if (!CNP_CODE_RE.test(code)) return null;
  return CNP_TOME_SUFFIX_RE.test(code) ? `${code}.pdf` : `${code}P00.pdf`;
}

/**
 * The link to open a manuel at the CNP, optionally anchored at `page` via the
 * PDF `#page=` fragment (RFC 8118) so a chapter opens on ITS pages rather than
 * on the cover. Returns `null` when the code is unusable — callers render
 * nothing rather than a dead link.
 */
export function cnpManuelUrl(code: string, page?: number | null): string | null {
  const file = cnpManuelFileName(code);
  if (!file) return null;
  const anchored = typeof page === "number" && Number.isInteger(page) && page > 0;
  return `${CNP_MANUEL_BASE_URL}/${file}${anchored ? `#page=${page}` : ""}`;
}
