import { describe, it, expect } from "vitest";
import {
  findAnswerFormatViolation,
  isValidAnswerFormat,
  MAX_CHOICE_LENGTH,
} from "@/shared/lib/answer-formats";

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

  it("treats unknown/null types as the generic bounded-string contract", () => {
    expect(isValidAnswerFormat(null, "whatever")).toBe(true);
    expect(isValidAnswerFormat("ordering", "b,a,c")).toBe(true);
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
