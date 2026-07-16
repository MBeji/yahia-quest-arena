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
