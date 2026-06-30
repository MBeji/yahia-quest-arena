import { useCallback, useEffect, useState } from "react";

/**
 * Anonymous-visitor comprehension-quiz gate (parity with the connected gate).
 *
 * Signed-in students must PASS a chapter's comprehension quiz before its
 * exercises unlock — enforced server-side in `start_exercise_session` against the
 * persisted `attempts`. Anonymous visitors have no account and no persistence, so
 * their "I passed this chapter's quiz" state lives in `sessionStorage` for the
 * browsing session. It is intentionally client-trust (an anon visitor earns no
 * XP and nothing is recorded); the server-authoritative gate is unchanged for
 * signed-in students.
 *
 * The decision of WHEN the gate applies is shared with the connected side: the
 * server fn `getExercise` returns `quizGated` (school subject + chapter has a
 * quiz), and `isQuizGateLocked` combines it with the pass state below.
 */

const STORAGE_KEY = "na9ra.anonQuizPassed";

function readPassed(): Set<string> {
  if (typeof window === "undefined") return new Set();
  try {
    const raw = window.sessionStorage.getItem(STORAGE_KEY);
    if (!raw) return new Set();
    const parsed: unknown = JSON.parse(raw);
    return Array.isArray(parsed)
      ? new Set(parsed.filter((x): x is string => typeof x === "string"))
      : new Set();
  } catch {
    return new Set();
  }
}

function writePassed(set: Set<string>): void {
  if (typeof window === "undefined") return;
  try {
    window.sessionStorage.setItem(STORAGE_KEY, JSON.stringify([...set]));
  } catch {
    // sessionStorage unavailable (private mode quota / disabled) — the gate then
    // degrades to "locked", which is the safe direction.
  }
}

/** Has the anonymous visitor passed this chapter's comprehension quiz this session? */
export function hasPassedChapterQuiz(chapterId: string | null | undefined): boolean {
  if (!chapterId) return false;
  return readPassed().has(chapterId);
}

/** Record a session-local pass for a chapter's comprehension quiz (idempotent). */
export function markChapterQuizPassed(chapterId: string | null | undefined): void {
  if (!chapterId) return;
  const set = readPassed();
  if (set.has(chapterId)) return;
  set.add(chapterId);
  writePassed(set);
}

/**
 * Shared gate predicate: is a (non-quiz) exercise locked behind its chapter's
 * comprehension quiz? `quizGated` comes from the server (`getExercise`); the pass
 * state comes from the persisted account (connected) or `sessionStorage` (anon).
 */
export function isQuizGateLocked(opts: { quizGated: boolean; quizPassed: boolean }): boolean {
  return opts.quizGated && !opts.quizPassed;
}

/**
 * React binding over the session-local pass state. Reads in an effect (SSR-safe:
 * the server render is always "not passed", then the client reconciles on mount)
 * and exposes a `markPassed` that updates both storage and local state so the
 * current screen reacts immediately after the quiz is passed.
 */
export function useChapterQuizPassed(chapterId: string | null | undefined): {
  passed: boolean;
  markPassed: () => void;
} {
  const [passed, setPassed] = useState(false);
  useEffect(() => {
    setPassed(hasPassedChapterQuiz(chapterId));
  }, [chapterId]);
  const markPassed = useCallback(() => {
    markChapterQuizPassed(chapterId);
    setPassed(true);
  }, [chapterId]);
  return { passed, markPassed };
}
