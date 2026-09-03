import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

const mutate = vi.fn();
vi.mock("@tanstack/react-query", () => ({
  useMutation: (opts: unknown) => ({ mutate, isPending: false, isSuccess: false, ...(opts ?? {}) }),
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@/features/dashboard", () => ({ claimEventBadge: vi.fn() }));

import { EventBanner } from "../components/event-banner";
import type { ActiveEvent } from "../events.server";

/**
 * Étude 31 lot 8 — LA BANNIÈRE D'ÉVÉNEMENT (US-12, R-21, R-2).
 *
 * Constat n° 9 : rien ne rythmait l'année scolaire. Trois propriétés :
 *
 *   1. ⭐ R-2 — la bannière annonce un DÉFI, elle ne verrouille rien. Aucun mot
 *      de blocage, aucun contenu conditionné ;
 *   2. ⭐ aucune urgence anxiogène : une date de fin, pas un chronomètre ;
 *   3. le badge se réclame TOUT SEUL une fois l'objectif atteint — demander un
 *      clic pour une récompense méritée, c'est une corvée déguisée en fête.
 */

function event(over: Partial<ActiveEvent> = {}): ActiveEvent {
  return {
    code: "rentree-2026",
    name: { fr: "Défi de la rentrée", en: "Back-to-school challenge", ar: "تحدّي العودة" },
    description: { fr: "Cinq missions.", en: "Five missions.", ar: "خمس مهامّ." },
    endsAt: "2026-09-30T00:00:00+01:00",
    goalType: "exercises_n",
    goalTarget: 5,
    progress: 2,
    badgeCode: "event_rentree",
    ...over,
  };
}

describe("EventBanner", () => {
  it("annonce l'événement et la progression", () => {
    render(<EventBanner event={event()} />);
    expect(screen.getByTestId("event-banner").textContent).toContain("Défi de la rentrée");
    expect(screen.getByTestId("event-progress").textContent).toContain("2/5");
  });

  it("⭐ ne verrouille rien (R-2) — aucun vocabulaire de blocage", () => {
    const { container } = render(<EventBanner event={event()} />);
    const text = (container.textContent ?? "").toLowerCase();
    for (const word of ["verrouill", "bloqué", "expire", "réservé", "indisponible"]) {
      expect(text).not.toContain(word);
    }
  });

  it("⭐ n'affiche aucun compte à rebours (R-8 : pas d'urgence fabriquée)", () => {
    const { container } = render(<EventBanner event={event()} />);
    const text = (container.textContent ?? "").toLowerCase();
    for (const word of ["il te reste", "plus que", "dernière chance", "vite"]) {
      expect(text).not.toContain(word);
    }
  });

  it("ne rend rien hors de toute fenêtre — pas d'affiche vide", () => {
    const { container } = render(<EventBanner event={null} />);
    expect(container.textContent).toBe("");
  });

  it("⭐ réclame le badge tout seul une fois l'objectif atteint", () => {
    mutate.mockClear();
    render(<EventBanner event={event({ progress: 5 })} />);
    expect(mutate).toHaveBeenCalled();
  });

  it("ne réclame rien tant que l'objectif n'est pas atteint", () => {
    mutate.mockClear();
    render(<EventBanner event={event({ progress: 4 })} />);
    expect(mutate).not.toHaveBeenCalled();
  });
});
