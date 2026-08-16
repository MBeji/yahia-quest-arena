import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

/**
 * Le bilan du combat de boss sur l'écran de résultat : le rang (dégâts, mesurés
 * côté client au chronomètre ouvert) et la prime de rapidité sur les XP
 * (décidée SERVEUR). On vérifie surtout qu'on n'annonce jamais une prime que le
 * serveur n'a pas accordée.
 */

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
  useNavigate: () => vi.fn(),
}));
vi.mock("@tanstack/react-start", () => ({
  useServerFn: () => vi.fn(async () => ({ exerciseId: null })),
}));
vi.mock("../quest.training", () => ({ getTrainingForMisconception: vi.fn() }));
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
vi.mock("../components/video-embed", () => ({ VideoEmbed: () => null }));

// Chaque clé rend son propre nom, SAUF le vocabulaire boss qui porte le vrai
// gabarit — c'est lui qu'on mesure (les substitutions {hp} / {pct}).
vi.mock("@/lib/i18n", () => {
  const BOSS = {
    bossRankCritical: "Coup critique",
    bossRankFast: "Frappe solide",
    bossRankSteady: "Combat mené jusqu'au bout",
    bossResultHp: "Boss à {hp} % de HP",
    bossSpeedBonus: "Prime de rapidité : +{pct} % d'XP",
    bossRankHint: "Le chronomètre décide des dégâts, jamais de la correction.",
  };
  const keysAsStrings = new Proxy(BOSS, {
    get: (target, k) => Reflect.get(target, k) ?? String(k),
  });
  const t = new Proxy(
    {},
    {
      get: (_t, ns) => (ns === "public" ? { reader: { videoReviewTitle: "v" } } : keysAsStrings),
    },
  );
  return { useT: () => t, useI18n: () => ({ t, locale: "fr" }) };
});

import { QuestResultScreen } from "../components/quest-result-screen";
import type { PlayerResult } from "../components/exercise-player";

const result = (over: Partial<PlayerResult> = {}): PlayerResult =>
  ({
    correct: 4,
    total: 4,
    scorePct: 100,
    xpEarned: 150,
    coinsEarned: 20,
    durationSeconds: 100,
    speedBonus: 1,
    review: [],
    reviewHidden: true,
    unlockedBadges: [],
    potionApplied: null,
    retryShieldUsed: false,
    tooFast: false,
    improved: true,
    profile: { level: 3, xp: 900, current_streak: 2, hero_class: "Mage" },
    ...over,
  }) as unknown as PlayerResult;

function renderScreen(over: Partial<Parameters<typeof QuestResultScreen>[0]> = {}) {
  const props = {
    result: result(),
    isQuiz: false,
    isRtl: false,
    isRecall: false,
    boss: { hp: 0, rank: "critical" as const },
    rewards: true,
    recallUnlockable: false,
    qlang: "fr" as const,
    chapterId: "ch-1",
    subjectId: "subj-1",
    correctionVideo: null,
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

describe("QuestResultScreen — bilan du combat de boss", () => {
  it("n'affiche aucun bloc boss hors combat de boss", () => {
    renderScreen({ boss: null });
    expect(screen.queryByTestId("boss-result")).not.toBeInTheDocument();
    expect(screen.queryByTestId("boss-speed-bonus")).not.toBeInTheDocument();
  });

  it("rend le rang et les HP restants du boss", () => {
    renderScreen({ boss: { hp: 25, rank: "fast" } });
    const block = screen.getByTestId("boss-result");
    expect(block.textContent).toContain("Frappe solide");
    expect(block.textContent).toContain("Boss à 25 % de HP");
  });

  it("annonce la prime que le SERVEUR a accordée, arrondie en pourcentage", () => {
    renderScreen({ result: result({ speedBonus: 1.5 }) });
    expect(screen.getByTestId("boss-speed-bonus").textContent).toBe(
      "Prime de rapidité : +50 % d'XP",
    );
  });

  it("se tait quand aucune prime n'a été accordée — pas de « tu aurais pu »", () => {
    renderScreen({ result: result({ speedBonus: 1 }), boss: { hp: 50, rank: "steady" } });
    expect(screen.getByTestId("boss-result")).toBeInTheDocument();
    expect(screen.queryByTestId("boss-speed-bonus")).not.toBeInTheDocument();
  });

  it("se tait aussi dans un registre sans récompense, même si le champ arrive garni", () => {
    renderScreen({ result: result({ speedBonus: 1.5 }), rewards: false });
    expect(screen.queryByTestId("boss-speed-bonus")).not.toBeInTheDocument();
  });
});
