import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";
import type { CompiledVideo } from "@/shared/content/schema";

/**
 * Étude 23 lot 3 — the review-video block of the result screen.
 * VideoEmbed itself is covered by video-embed.test.tsx; here we only assert
 * WHEN the block is offered (failure only) and WHERE it lands (quiz vs exercise).
 */

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));
vi.mock("motion/react", () => ({
  motion: new Proxy(
    {},
    {
      get:
        () =>
        ({ children, ...props }: { children?: React.ReactNode }) =>
          React.createElement("div", props, children),
    },
  ),
  useReducedMotion: () => true,
  AnimatePresence: ({ children }: { children?: React.ReactNode }) => children,
}));
// Stub the real embed — we assert the block, not the facade internals.
vi.mock("../components/video-embed", () => ({
  VideoEmbed: ({ video, context }: { video: CompiledVideo; context: string }) =>
    React.createElement("div", { "data-testid": "video-embed", "data-context": context }, video.id),
}));
// Any namespace resolves each key to its own name (enough for .replace() copy);
// only the key under test carries real text.
vi.mock("@/lib/i18n", () => {
  const keysAsStrings = new Proxy({}, { get: (_t, k) => String(k) });
  return {
    useT: () =>
      new Proxy(
        {},
        {
          get: (_t, ns) =>
            ns === "public"
              ? { reader: { videoReviewTitle: "Revoir la notion en vidéo" } }
              : keysAsStrings,
        },
      ),
  };
});

import { QuestResultScreen } from "../components/quest-result-screen";
import type { PlayerResult } from "../components/exercise-player";

const video: CompiledVideo = {
  id: "math.thales",
  provider: "youtube",
  videoId: "AbCdEfGhIjK",
  title: "Thalès",
  channel: "Maths et tiques",
  lang: "fr",
  durationSec: 480,
};

const result = (scorePct: number): PlayerResult =>
  ({
    scorePct,
    correctCount: 1,
    totalCount: 4,
    xpEarned: 10,
    coinsEarned: 0,
    durationSeconds: 30,
    review: [],
    reviewHidden: true,
    newBadges: [],
    profile: { level: 1 },
  }) as unknown as PlayerResult;

function renderScreen(over: Partial<Parameters<typeof QuestResultScreen>[0]> = {}) {
  const props = {
    result: result(25),
    isQuiz: false,
    isRtl: false,
    isRecall: false,
    rewards: false,
    recallUnlockable: false,
    qlang: "fr" as const,
    chapterId: "ch-1",
    subjectId: "math-9eme",
    correctionVideo: video,
    exerciseId: "ex-1",
    nextExerciseId: null,
    showConfetti: false,
    showLevelUp: false,
    onLevelUpComplete: () => {},
    onReplay: () => {},
    renderResultFooter: () => null,
    resolvePrompt: () => "",
    getDisplayChoice: (_q: string, c: string) => c,
    ...over,
  };
  return render(<QuestResultScreen {...props} />);
}

describe("QuestResultScreen — review video (étude 23 R-6/US-2/US-3)", () => {
  it("offers the video on a FAILED exercise, in the result context", () => {
    renderScreen();
    expect(screen.getByTestId("correction-video")).toBeInTheDocument();
    expect(screen.getByText("Revoir la notion en vidéo")).toBeInTheDocument();
    expect(screen.getByTestId("video-embed")).toHaveAttribute("data-context", "result");
  });

  it("never offers it on a PASSED run", () => {
    renderScreen({ result: result(100) });
    expect(screen.queryByTestId("correction-video")).toBeNull();
  });

  it("offers it on a FAILED comprehension quiz too (US-3)", () => {
    renderScreen({ isQuiz: true, result: result(25) });
    expect(screen.getByTestId("correction-video")).toBeInTheDocument();
  });

  it("renders nothing when no video was resolved (R-6 → none)", () => {
    renderScreen({ correctionVideo: null });
    expect(screen.queryByTestId("correction-video")).toBeNull();
  });

  it("does not offer it on a passed quiz", () => {
    renderScreen({ isQuiz: true, result: result(100) });
    expect(screen.queryByTestId("correction-video")).toBeNull();
  });
});
