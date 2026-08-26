import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { ForgeableChapter } from "../forge.server";

/**
 * LA PORTE DU TABLEAU DE BORD S'OUVRE — le défaut que ce fichier fige.
 *
 * Le panneau ne montrait ses réglages que `{chapterId && …}`, et l'entrée du
 * dashboard n'en passe aucun (é29 §2.1 en demande pourtant deux). Un élève dont
 * la famille venait de brancher sa clé arrivait donc sur un titre, une phrase et
 * « aucun quiz » : la seule surface que le mode IA allume vraiment ne faisait
 * rien. Ces tests tiennent les deux entrées ouvertes, et le seul état où l'écran
 * a le droit de ne rien proposer — celui où il n'y a rien à forger.
 */

let chapters: ForgeableChapter[] = [];
let chaptersLoading = false;

vi.mock("@tanstack/react-query", () => ({
  useQuery: ({ queryKey }: { queryKey: unknown[] }) => {
    if (queryKey[0] === "forgeable-chapters") {
      return { data: chapters, isLoading: chaptersLoading };
    }
    return { data: { quizzes: [], quotaLeft: 3 }, isLoading: false };
  },
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: () => vi.fn(),
    };
    return chain;
  },
}));

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) => (
    <a href={to}>{children}</a>
  ),
}));

vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    ai: new Proxy({} as Record<string, string>, {
      get: (_target, key: string) => `ai.${key}`,
    }),
  }),
}));

import { ForgePanel } from "../components/forge-panel";

const CHAPTERS: ForgeableChapter[] = [
  { id: "ch-1", title: "Les fractions", subjectName: "Mathématiques" },
  { id: "ch-2", title: "Les forces", subjectName: "Sciences physiques" },
];

beforeEach(() => {
  chapters = CHAPTERS;
  chaptersLoading = false;
});

describe("ForgePanel", () => {
  it("arrivé depuis un chapitre : les réglages, sans sélecteur", () => {
    render(<ForgePanel chapterId="ch-1" />);
    expect(screen.getByTestId("forge-run")).toBeInTheDocument();
    // On ne redemande pas ce que l'élève vient de désigner.
    expect(screen.queryByTestId("forge-chapter")).not.toBeInTheDocument();
  });

  it("arrivé sans chapitre : un sélecteur, et les réglages APRÈS le choix", async () => {
    render(<ForgePanel chapterId={null} />);

    // C'est tout le défaut : avant le choix, rien à régler — mais quelque chose
    // à faire, ce qui n'était pas le cas.
    expect(screen.queryByTestId("forge-run")).not.toBeInTheDocument();
    const select = screen.getByTestId("forge-chapter");

    await userEvent.selectOptions(select, "ch-2");
    expect(screen.getByTestId("forge-run")).toBeInTheDocument();
  });

  it("groupe les chapitres par matière", () => {
    render(<ForgePanel chapterId={null} />);
    // Deux chapitres homonymes de matières différentes seraient sinon
    // indiscernables dans la liste.
    const groups = screen
      .getByTestId("forge-chapter")
      .querySelectorAll<HTMLOptGroupElement>("optgroup");
    expect([...groups].map((g) => g.label)).toEqual(["Mathématiques", "Sciences physiques"]);
  });

  it("aucun chapitre forgeable : une explication et une sortie, pas le vide", () => {
    chapters = [];
    render(<ForgePanel chapterId={null} />);
    expect(screen.getByTestId("forge-no-chapter")).toBeInTheDocument();
    expect(screen.getByRole("link")).toHaveAttribute("href", "/parcours");
  });

  it("pendant le chargement : rien — un squelette est déjà une promesse (R-1)", () => {
    chapters = [];
    chaptersLoading = true;
    render(<ForgePanel chapterId={null} />);
    expect(screen.queryByTestId("forge-no-chapter")).not.toBeInTheDocument();
    expect(screen.queryByTestId("forge-chapter")).not.toBeInTheDocument();
  });
});
