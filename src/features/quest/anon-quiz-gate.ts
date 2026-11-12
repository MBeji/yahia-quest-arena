import { useCallback, useEffect, useState } from "react";
import { hasPassedQuizOnDevice, rememberQuizPassed } from "@/shared/lib/anon-continuity";

/**
 * Anonymous-visitor comprehension-quiz gate (parity with the connected gate).
 *
 * Signed-in students must PASS a chapter's comprehension quiz before its
 * exercises unlock — enforced server-side in `start_exercise_session` against the
 * persisted `attempts`. Anonymous visitors have no account, so their "I passed
 * this chapter's quiz" state lives ON THEIR DEVICE: `localStorage`, thirty days
 * (étude 38 lot 5 — it used to be `sessionStorage`, so the gate closed again with
 * the tab and a visitor coming back the next day had to redo every quiz). The
 * storage itself — keys, TTL, defensive reads — is `@/shared/lib/anon-continuity`.
 * It is intentionally client-trust (an anon visitor earns no XP and nothing is
 * recorded, not even the score); the server-authoritative gate is unchanged for
 * signed-in students.
 *
 * The decision of WHEN the gate applies is shared with the connected side: the
 * server fn `getExercise` returns `quizGated` (school subject + chapter has a
 * quiz), and `isQuizGateLocked` combines it with the pass state below.
 */

/** Has the anonymous visitor passed this chapter's comprehension quiz on this device? */
export function hasPassedChapterQuiz(chapterId: string | null | undefined): boolean {
  return hasPassedQuizOnDevice(chapterId);
}

/**
 * Record a device-local pass for a chapter's comprehension quiz (idempotent). When the
 * storage is unavailable nothing is kept and the gate degrades to "locked" on the next
 * screen — the safe direction.
 */
export function markChapterQuizPassed(chapterId: string | null | undefined): void {
  rememberQuizPassed(chapterId);
}

/**
 * Shared gate predicate: is a (non-quiz) exercise locked behind its chapter's
 * comprehension quiz? `quizGated` comes from the server (`getExercise`); the pass
 * state comes from the persisted account (connected) or the device memory (anon).
 */
export function isQuizGateLocked(opts: { quizGated: boolean; quizPassed: boolean }): boolean {
  return opts.quizGated && !opts.quizPassed;
}

/**
 * React binding over the device-local pass state. Reads in an effect (SSR-safe:
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
