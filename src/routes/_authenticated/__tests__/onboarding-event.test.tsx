import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

/**
 * Étude 38 lot 0 — l'assistant d'accueil dit D'OÙ vient la fin d'accueil.
 *
 * `onboarding_completed` gagne `source`. Le lot 2 ajoutera l'autre valeur (« quest_card »,
 * la carte de classe posée sur la quête) : sans cette propriété, on ne saurait pas lire
 * ce que chacun des deux chemins amène.
 */
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({ ...opts, useSearch: () => ({}) }),
  useNavigate: () => vi.fn(),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("motion/react", () => {
  const MOTION_PROPS = ["initial", "animate", "exit", "transition", "whileHover", "whileTap"];
  const make =
    (tag: string) =>
    ({ children, ...props }: { children?: React.ReactNode } & Record<string, unknown>) =>
      React.createElement(
        tag,
        Object.fromEntries(Object.entries(props).filter(([k]) => !MOTION_PROPS.includes(k))),
        children,
      );
  return {
    motion: new Proxy({}, { get: (_target, tag: string) => make(tag) }),
    AnimatePresence: ({ children }: { children?: React.ReactNode }) => children,
    useReducedMotion: () => true,
  };
});
vi.mock("@/shared/lib/motion", () => ({ useEntrance: () => ({}) }));
vi.mock("@/components/ui/language-switcher", () => ({ LanguageSwitcher: () => null }));
vi.mock("@/components/guide/guide-rule", () => ({ GuideRule: () => null }));
vi.mock("sonner", () => ({ toast: { error: vi.fn(), success: vi.fn() } }));

const getParcours = vi.fn();
vi.mock("@/features/dashboard", () => ({
  getParcours: (...a: unknown[]) => getParcours(...a),
  useParcoursInterest: () => ({
    counts: {},
    mine: new Set<string>(),
    togglingId: null,
    onToggle: vi.fn(),
  }),
  ParcoursInterestButton: () => null,
  buildLyceeYears: () => [],
}));
const setCurrentParcours = vi.fn();
const claimWelcomePack = vi.fn();
vi.mock("@/features/auth", () => ({
  setCurrentParcours: (...a: unknown[]) => setCurrentParcours(...a),
  claimWelcomePack: (...a: unknown[]) => claimWelcomePack(...a),
}));

import { Route } from "../onboarding";

const OnboardingPage = (Route as unknown as { component: React.ComponentType }).component;

const libre = {
  id: "extras-anglais",
  name_fr: "Anglais",
  name_en: "English",
  name_ar: null,
  kind: "libre",
  is_premium: false,
  hasEntitlement: true,
  status: "available",
  display_order: 1,
  icon: "Languages",
  color: "subject-anglais",
  theme_id: "anglais",
  grade_id: null,
  grade_cycle: null,
  grade_order: null,
  grade_slug: null,
  grade_selectable: true,
};

function renderPage() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <OnboardingPage />
    </QueryClientProvider>,
  );
}

describe("OnboardingPage — onboarding_completed (é38 lot 0)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    getParcours.mockResolvedValue({ parcours: [libre] });
    setCurrentParcours.mockResolvedValue({ ok: true });
    claimWelcomePack.mockResolvedValue(null);
  });

  it("émet l'intention choisie et la source « wizard » quand le parcours est enregistré", async () => {
    renderPage();
    fireEvent.click(await screen.findByRole("button", { name: /J'explore librement/ }));
    fireEvent.click(await screen.findByRole("button", { name: /Anglais/ }));

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("onboarding_completed", {
        intent: "explorer",
        source: "wizard",
      }),
    );
  });

  it("un enregistrement qui échoue n'émet rien : l'accueil n'est pas fini", async () => {
    setCurrentParcours.mockRejectedValue(new Error("réseau"));
    renderPage();
    fireEvent.click(await screen.findByRole("button", { name: /J'explore librement/ }));
    fireEvent.click(await screen.findByRole("button", { name: /Anglais/ }));

    await waitFor(() => expect(setCurrentParcours).toHaveBeenCalled());
    expect(trackProductEvent).not.toHaveBeenCalled();
  });
});
