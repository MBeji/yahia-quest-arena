import { describe, it, expect } from "vitest";
import {
  findAnswerFormatViolation,
  isValidAnswerFormat,
  MAX_CHOICE_LENGTH,
  TIMEOUT_ANSWER_CHOICE,
  UNSUPPORTED_ANSWER_CHOICE,
} from "@/shared/lib/answer-formats";
import { RECALL_MAX_ANSWER_LENGTH } from "@/shared/constants/gamification";

describe("answer-formats — isValidAnswerFormat", () => {
  it("accepts any bounded non-empty string for mcq (historical contract)", () => {
    expect(isValidAnswerFormat("mcq", "a")).toBe(true);
    expect(isValidAnswerFormat("mcq", "option-42")).toBe(true);
  });

  it("rejects empty and oversized choices for every type", () => {
    expect(isValidAnswerFormat("mcq", "")).toBe(false);
    expect(isValidAnswerFormat("mcq", "   ")).toBe(false);
    expect(isValidAnswerFormat("numeric", "")).toBe(false);
    expect(isValidAnswerFormat("mcq", "x".repeat(MAX_CHOICE_LENGTH + 1))).toBe(false);
  });

  it("accepts well-formed numeric answers (sign, dot or comma decimal, whitespace)", () => {
    expect(isValidAnswerFormat("numeric", "42")).toBe(true);
    expect(isValidAnswerFormat("numeric", "-5")).toBe(true);
    expect(isValidAnswerFormat("numeric", "3.14")).toBe(true);
    expect(isValidAnswerFormat("numeric", "3,14")).toBe(true);
    expect(isValidAnswerFormat("numeric", "  42  ")).toBe(true);
  });

  it("rejects malformed numeric answers", () => {
    expect(isValidAnswerFormat("numeric", "abc")).toBe(false);
    expect(isValidAnswerFormat("numeric", "4a")).toBe(false);
    expect(isValidAnswerFormat("numeric", "1.2.3")).toBe(false);
    expect(isValidAnswerFormat("numeric", "1e5")).toBe(false);
    expect(isValidAnswerFormat("numeric", "--3")).toBe(false);
    expect(isValidAnswerFormat("numeric", ".5")).toBe(false);
  });

  it("accepts the give-up sentinels for EVERY type (they score wrong, never reject)", () => {
    // Boss timeout on a numeric question must not fail the whole submission.
    expect(isValidAnswerFormat("numeric", TIMEOUT_ANSWER_CHOICE)).toBe(true);
    expect(isValidAnswerFormat("numeric", UNSUPPORTED_ANSWER_CHOICE)).toBe(true);
    expect(isValidAnswerFormat("mcq", TIMEOUT_ANSWER_CHOICE)).toBe(true);
    expect(isValidAnswerFormat("ordering", UNSUPPORTED_ANSWER_CHOICE)).toBe(true);
  });

  it("treats unknown/null types as the generic bounded-string contract", () => {
    expect(isValidAnswerFormat(null, "whatever")).toBe(true);
    expect(isValidAnswerFormat("essay", "free text")).toBe(true);
  });

  it("accepts well-formed multi answers (unique checked-id CSV)", () => {
    expect(isValidAnswerFormat("multi", "a,c")).toBe(true);
    expect(isValidAnswerFormat("multi", "c, a")).toBe(true);
    expect(isValidAnswerFormat("multi", "b")).toBe(true); // a single check is a valid selection
  });

  it("rejects malformed multi answers", () => {
    expect(isValidAnswerFormat("multi", "a,,c")).toBe(false); // empty part
    expect(isValidAnswerFormat("multi", "a,c,")).toBe(false); // trailing comma
    expect(isValidAnswerFormat("multi", "a,a")).toBe(false); // duplicated id
    expect(isValidAnswerFormat("multi", "l1:r2")).toBe(false); // pair syntax
  });

  it("accepts well-formed ordering answers (unique id CSV, whitespace-insensitive)", () => {
    expect(isValidAnswerFormat("ordering", "b,a,d,c")).toBe(true);
    expect(isValidAnswerFormat("ordering", "b, a, d, c")).toBe(true);
    expect(isValidAnswerFormat("ordering", "step2,step1")).toBe(true);
  });

  it("rejects malformed ordering answers", () => {
    expect(isValidAnswerFormat("ordering", "b")).toBe(false); // a sequence needs >= 2 steps
    expect(isValidAnswerFormat("ordering", "b,,a")).toBe(false); // empty part
    expect(isValidAnswerFormat("ordering", "b,a,")).toBe(false); // trailing comma
    expect(isValidAnswerFormat("ordering", "b,a,b")).toBe(false); // duplicated id
    expect(isValidAnswerFormat("ordering", "l1:r2,l2:r1")).toBe(false); // pair syntax
  });

  it("accepts well-formed matching answers (unique left:right pair CSV)", () => {
    expect(isValidAnswerFormat("matching", "l1:r2,l2:r1")).toBe(true);
    expect(isValidAnswerFormat("matching", "l1:r2, l2:r1")).toBe(true);
    expect(isValidAnswerFormat("matching", "l1:r1")).toBe(true);
  });

  it("rejects malformed matching answers", () => {
    expect(isValidAnswerFormat("matching", "l1r2,l2r1")).toBe(false); // no ':' separator
    expect(isValidAnswerFormat("matching", "l1:r2:x")).toBe(false); // two ':' in a pair
    expect(isValidAnswerFormat("matching", "l1:,l2:r1")).toBe(false); // empty right side
    expect(isValidAnswerFormat("matching", "l1:r2,l1:r2")).toBe(false); // duplicated pair
    expect(isValidAnswerFormat("matching", "b,a,c")).toBe(false); // ordering syntax
  });

  it("accepts free-text recall answers up to the tighter recall cap (étude 17)", () => {
    expect(isValidAnswerFormat("recall", "Paris")).toBe(true);
    // Recall answers may contain punctuation the CSV-based types would reject.
    expect(isValidAnswerFormat("recall", "l'accord du participe passé")).toBe(true);
    expect(isValidAnswerFormat("recall", "a,b:c")).toBe(true);
    expect(isValidAnswerFormat("recall", "x".repeat(RECALL_MAX_ANSWER_LENGTH))).toBe(true);
  });

  it("rejects empty or over-cap recall answers", () => {
    expect(isValidAnswerFormat("recall", "")).toBe(false);
    expect(isValidAnswerFormat("recall", "   ")).toBe(false);
    // The recall cap is tighter than the generic wire bound.
    expect(RECALL_MAX_ANSWER_LENGTH).toBeLessThan(MAX_CHOICE_LENGTH);
    expect(isValidAnswerFormat("recall", "x".repeat(RECALL_MAX_ANSWER_LENGTH + 1))).toBe(false);
  });
});

describe("answer-formats — findAnswerFormatViolation", () => {
  const types = new Map<string, string | null>([
    ["q-mcq", "mcq"],
    ["q-num", "numeric"],
  ]);

  it("returns null for a well-formed payload", () => {
    expect(
      findAnswerFormatViolation(types, [
        { questionId: "q-mcq", choice: "a" },
        { questionId: "q-num", choice: "3,14" },
      ]),
    ).toBeNull();
  });

  it("flags the first malformed answer with its question type", () => {
    expect(
      findAnswerFormatViolation(types, [
        { questionId: "q-mcq", choice: "a" },
        { questionId: "q-num", choice: "abc" },
      ]),
    ).toEqual({ questionId: "q-num", questionType: "numeric" });
  });

  it("skips answers targeting unknown question ids (the RPC's concern)", () => {
    expect(findAnswerFormatViolation(types, [{ questionId: "q-ghost", choice: "!!" }])).toBeNull();
  });

  it("treats a null stored type as mcq", () => {
    const withNull = new Map<string, string | null>([["q-x", null]]);
    expect(findAnswerFormatViolation(withNull, [{ questionId: "q-x", choice: "abc" }])).toBeNull();
  });
});
