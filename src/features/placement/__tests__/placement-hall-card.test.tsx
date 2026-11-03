import { render, screen } from "@testing-library/react";
import React from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { PlacementHallCard } from "../components/placement-hall-card";

/**
 * Étude 39 US-6 / R-17 — « Ton bilan de départ » : une invitation sans bilan (jamais un
 * reproche), le dernier bilan par matière avec ses chapitres à revoir sinon, et RIEN quand la
 * lecture a échoué (une carte vide inviterait à tort).
 */
const overview = vi.fn();
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("../placement.server", () => ({ getMyPlacementOverview: () => overview() }));
vi.mock("@tanstack/react-query", () => ({
  useQuery: ({ queryFn }: { queryFn: () => unknown }) => {
    const state = queryState.current;
    void queryFn;
    return state;
  },
}));
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
    search,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
    search?: Record<string, string>;
  }) => {
    let href = to;
    for (const [k, v] of Object.entries(params ?? {})) href = href.replace(`$${k}`, v);
    if (search) href += `?${new URLSearchParams(search).toString()}`;
    return React.createElement("a", { href, ...rest }, children);
  },
}));
vi.mock("@/lib/i18n/placement", async () => {
  const mod = await vi.importActual<typeof import("@/lib/i18n/placement")>("@/lib/i18n/placement");
  const fr = await import("@/lib/i18n/fr");
  return { ...mod, usePlacementT: () => ({ ...fr.fr, ...mod.placementTranslations("fr") }) };
});
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: "fr" }) }));

const queryState = vi.hoisted(() => ({
  current: { data: undefined as unknown, isLoading: false, isError: false },
}));

describe("PlacementHallCard", () => {
  beforeEach(() => {
    queryState.current = { data: undefined, isLoading: false, isError: false };
  });

  it("sans bilan : l'invitation, dix questions, sept minutes", () => {
    queryState.current = { data: [], isLoading: false, isError: false };
    render(<PlacementHallCard />);
    expect(screen.getByTestId("placement-hall-card")).toHaveTextContent(
      "Dix questions, sept minutes",
    );
    expect(screen.getByTestId("placement-hall-empty-cta")).toHaveAttribute(
      "href",
      "/test-de-niveau",
    );
  });

  it("avec un bilan : la note, la bande, les chapitres à revoir, voir et refaire", () => {
    queryState.current = {
      data: [
        {
          sessionId: "11111111-1111-4111-8111-111111111111",
          subjectId: "math",
          subjectNameFr: "Mathématiques",
          contentLanguage: "fr",
          scoreOn20: 14,
          band: "en-route",
          finishedAt: "2026-11-01T10:05:00Z",
          chaptersToReview: [
            { chapterId: "c2", title: "Angles" },
            { chapterId: "c3", title: "Thalès" },
          ],
        },
      ],
      isLoading: false,
      isError: false,
    };
    render(<PlacementHallCard />);
    const entry = screen.getByTestId("placement-hall-entry");
    expect(entry).toHaveTextContent("Mathématiques");
    expect(entry).toHaveTextContent("14/20 · En bonne voie");
    expect(entry).toHaveTextContent("À revoir : Angles · Thalès");
    expect(screen.getByRole("link", { name: "Voir le bilan" })).toHaveAttribute(
      "href",
      "/test-de-niveau/11111111-1111-4111-8111-111111111111",
    );
    expect(screen.getByRole("link", { name: "Refaire" })).toHaveAttribute(
      "href",
      "/test-de-niveau?matiere=math",
    );
  });

  it("lecture en panne ou en cours : rien du tout", () => {
    queryState.current = { data: undefined, isLoading: false, isError: true };
    const { container, rerender } = render(<PlacementHallCard />);
    expect(container).toBeEmptyDOMElement();
    queryState.current = { data: undefined, isLoading: true, isError: false };
    rerender(<PlacementHallCard />);
    expect(container).toBeEmptyDOMElement();
  });
});
