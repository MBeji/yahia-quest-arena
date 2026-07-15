/**
 * Per-type wire formats for native question types (Tier B — phase B1).
 *
 * The answer wire shape stays a single string (`choice`) for every type
 * (docs/interactive-question-types.md §Target data model); what varies per
 * `questions.question_type` is the expected FORMAT of that string. The scoring
 * RPCs are already garbage-safe (an unparseable choice scores false, never
 * throws), so this validation exists for the client contract: a malformed
 * payload surfaces as a clear input error instead of a silently-wrong score.
 *
 * Shared by the quest and dungeon server fns (features never import features).
 */

import { RECALL_MAX_ANSWER_LENGTH } from "@/shared/constants/gamification";

/** Upper bound for any answer string — generous for the B2/B3 CSV encodings. */
export const MAX_CHOICE_LENGTH = 512;

/** Boss-timer expiry sentinel: submitted when time runs out with no answer. */
export const TIMEOUT_ANSWER_CHOICE = "__timeout__";
/**
 * R-3 sentinel: submitted for a question type this client cannot render, so the
 * run stays completable. Like the timeout sentinel it can never match an option
 * id or a typed key — it always scores wrong, for every type.
 */
export const UNSUPPORTED_ANSWER_CHOICE = "__unsupported__";

/** Give-up sentinels are valid for EVERY type (they just score wrong). */
const SENTINEL_CHOICES = new Set([TIMEOUT_ANSWER_CHOICE, UNSUPPORTED_ANSWER_CHOICE]);

/**
 * A numeric answer: an optionally-negative decimal number, with `.` or `,` as
 * the decimal separator (normalized server-side) — mirrors `score_answer`.
 */
export const NUMERIC_CHOICE_PATTERN = /^-?\d+(?:[.,]\d+)?$/;

/**
 * Split a B2 CSV answer into its parts, whitespace-insensitive (mirrors the
 * server-side normalization in `score_answer`). Empty parts are kept so a
 * trailing/double comma invalidates the payload instead of hiding a bug.
 */
function splitCsvChoice(value: string): string[] {
  return value.replace(/\s+/g, "").split(",");
}

/**
 * An `ordering` answer: the full arranged sequence as an id CSV ("b,a,d,c") —
 * at least two unique, non-empty ids (an id never contains `,` or `:`).
 */
function isValidOrderingChoice(value: string): boolean {
  const parts = splitCsvChoice(value);
  if (parts.length < 2) return false;
  if (parts.some((part) => part.length === 0 || part.includes(":"))) return false;
  return new Set(parts).size === parts.length;
}

/**
 * A `matching` answer: the associations as a pair CSV ("l1:r2,l2:r1") — each
 * part exactly `left:right` with non-empty sides, pairs unique.
 */
function isValidMatchingChoice(value: string): boolean {
  const parts = splitCsvChoice(value);
  if (parts.length < 1) return false;
  if (!parts.every((part) => /^[^:]+:[^:]+$/.test(part))) return false;
  return new Set(parts).size === parts.length;
}

/**
 * A `multi` answer: the checked option ids as a CSV ("a,c") — at least one
 * unique, non-empty id (an id never contains `,` or `:`).
 */
function isValidMultiChoice(value: string): boolean {
  const parts = splitCsvChoice(value);
  if (parts.length < 1) return false;
  if (parts.some((part) => part.length === 0 || part.includes(":"))) return false;
  return new Set(parts).size === parts.length;
}

/**
 * Whether `choice` matches the wire format expected for `questionType`.
 *
 * - `numeric` → a plain number as string;
 * - `ordering` → the arranged sequence as a unique-id CSV ("b,a,d,c");
 * - `matching` → the associations as a unique "left:right" pair CSV;
 * - `multi` → the checked ids as a unique-id CSV ("a,c");
 * - `recall` → any non-empty string, capped tighter (≤ RECALL_MAX_ANSWER_LENGTH)
 *   than the wire bound — the typed free-text answer (étude 17);
 * - `mcq` → any non-empty bounded string, the historical contract.
 */
export function isValidAnswerFormat(
  questionType: string | null | undefined,
  choice: string,
): boolean {
  const value = choice.trim();
  if (value.length === 0 || value.length > MAX_CHOICE_LENGTH) return false;
  if (SENTINEL_CHOICES.has(value)) return true;
  if (questionType === "numeric") return NUMERIC_CHOICE_PATTERN.test(value);
  if (questionType === "ordering") return isValidOrderingChoice(value);
  if (questionType === "matching") return isValidMatchingChoice(value);
  if (questionType === "multi") return isValidMultiChoice(value);
  if (questionType === "recall") return value.length <= RECALL_MAX_ANSWER_LENGTH;
  return true;
}

/**
 * First answer whose choice violates its question's wire format, or null when
 * the whole payload is well-formed. Answers targeting unknown question ids are
 * skipped — rejecting/ignoring those is the scoring RPC's responsibility.
 */
export function findAnswerFormatViolation(
  questionTypeById: ReadonlyMap<string, string | null | undefined>,
  answers: ReadonlyArray<{ questionId: string; choice: string }>,
): { questionId: string; questionType: string } | null {
  for (const answer of answers) {
    if (!questionTypeById.has(answer.questionId)) continue;
    const questionType = questionTypeById.get(answer.questionId) ?? "mcq";
    if (!isValidAnswerFormat(questionType, answer.choice)) {
      return { questionId: answer.questionId, questionType };
    }
  }
  return null;
}
