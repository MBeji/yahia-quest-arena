import type { TranslationKeys } from "@/lib/i18n";

/**
 * Alliance-code failures, as STABLE codes (étude 15, lot 3 — audit §F-1).
 *
 * The `link_student_by_code` / `get_student_report_by_code` RPCs raise distinct,
 * NON-sensitive validation reasons (bad code, wrong role, not-a-student,
 * self-link). The server maps the raw reason to one of these codes and throws
 * `<PREFIX><code>`; the client translates the code in the visitor's language —
 * the old scheme baked tutoyé French into the error and served it to Arabic
 * parents as-is. Surfacing the precise reason is safe: the full 128-bit UUID is
 * needed to even reach the "student not found" branch, so there is no
 * meaningful enumeration risk.
 */
export type ParentCodeErrorCode =
  "not_parent" | "invalid_code" | "self_link" | "not_student" | "not_found" | "generic";

export const PARENT_LINK_ERROR_PREFIX = "PARENT_LINK_ERROR:";
export const REPORT_CODE_ERROR_PREFIX = "REPORT_CODE_ERROR:";

/** Raw RPC reason → stable code (server-side use; pure). */
export function parentCodeErrorCode(raw: string): ParentCodeErrorCode {
  const m = raw.toLowerCase();
  if (m.includes("parent account required")) return "not_parent";
  if (m.includes("invalid student alliance code")) return "invalid_code";
  if (m.includes("cannot link your own account")) return "self_link";
  if (m.includes("does not belong to a student account")) return "not_student";
  if (m.includes("student not found")) return "not_found";
  return "generic";
}

const CODES: ReadonlySet<string> = new Set([
  "not_parent",
  "invalid_code",
  "self_link",
  "not_student",
  "not_found",
  "generic",
] satisfies ParentCodeErrorCode[]);

/**
 * Translate a thrown alliance-code error into the visitor's language. Accepts
 * the raw `Error#message`; anything without a recognised prefix (network
 * failures, legacy messages) falls back to the context's generic label.
 */
export function parentCodeErrorLabel(message: string, t: TranslationKeys): string {
  const labels = t.parentReport.codeErrors;
  const context: "link" | "report" = message.startsWith(REPORT_CODE_ERROR_PREFIX)
    ? "report"
    : "link";
  const generic = context === "report" ? labels.generic_report : labels.generic_link;
  const code = message.startsWith(PARENT_LINK_ERROR_PREFIX)
    ? message.slice(PARENT_LINK_ERROR_PREFIX.length)
    : message.startsWith(REPORT_CODE_ERROR_PREFIX)
      ? message.slice(REPORT_CODE_ERROR_PREFIX.length)
      : "";
  if (!CODES.has(code) || code === "generic") return generic;
  return labels[code as Exclude<ParentCodeErrorCode, "generic">];
}
