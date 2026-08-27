import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { ForgeableChapter } from "../forge.server";

/**
 * LA BULLE IA — l'arbitrage du 2026-08-27, tenu par des tests.
 *
 * R-1 d'é29 interdisait toute surface IA sans mode actif — « pas de bouton
 * grisé, pas d'appel à l'action ». Le propriétaire a tranché l'inverse : le mode
 * IA est le cœur du produit, et personne ne découvre ce qui est invisible.
 *
 * Ce que ces tests fixent, ce sont les trois contreparties SANS lesquelles le
 * renversement serait une régression : une entrée verrouillée ne se déclenche
 * jamais (donc ne coûte rien), l'invitation ne s'affiche qu'à qui n'a pas de
 * clé, et la bulle se TAIT pendant une épreuve notée — l'autre moitié de R-1
 * étant une règle d'anti-triche, pas de découverte.
 */

let surfaces: { enabled: boolean; features: string[] } = { enabled: false, features: [] };
let chapters: ForgeableChapter[] = [];
const navigations: unknown[] = [];
let pathname = "/dashboard";
let routeParams: Record<string, string> = {};

vi.mock("@tanstack/react-query", () => ({
  useQuery: ({ queryKey, enabled }: { queryKey: unknown[]; enabled?: boolean }) => {
    if (enabled === false) return { data: undefined };
    return { data: queryKey[0] === "forgeable-chapters" ? chapters : surfaces };
  },
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: () => vi.fn(),
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
  useNavigate: () => (args: unknown) => {
    navigations.push(args);
    return Promise.resolve();
  },
  useParams: () => routeParams,
}));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    ai: new Proxy({} as Record<string, string>, { get: (_t, key: string) => `ai.${key}` }),
  }),
}));

import { AiLauncher } from "../components/ai-launcher";

const CHAPTERS: ForgeableChapter[] = [
  { id: "ch-1", title: "Les fractions", subjectName: "Mathématiques" },
];

beforeEach(() => {
  navigations.length = 0;
  surfaces = { enabled: false, features: [] };
  chapters = CHAPTERS;
  routeParams = {};
  pathname = "/dashboard";
  window.history.replaceState({}, "", pathname);
});

describe("AiLauncher", () => {
  it("est là pour qui N'A PAS de clé — grisé, pas absent", () => {
    render(<AiLauncher authenticated />);
    const bubble = screen.getByTestId("ai-launcher");
    expect(bubble).toBeInTheDocument();
    expect(bubble).toHaveAttribute("data-state", "locked");
  });

  it("une entrée verrouillée EXPLIQUE, elle ne déclenche rien", async () => {
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));

    expect(screen.getByTestId("ai-launcher-chat")).toHaveAttribute("data-locked", "true");
    expect(screen.getByTestId("ai-launcher-forge")).toHaveAttribute("data-locked", "true");
    // Aucun bouton d'action : rien à cliquer, donc aucun appel possible.
    expect(screen.queryByTestId("ai-launcher-chat-go")).not.toBeInTheDocument();
    expect(screen.queryByTestId("ai-launcher-forge-go")).not.toBeInTheDocument();
  });

  it("invite à ajouter une clé, et mène aux Réglages", async () => {
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));
    expect(screen.getByTestId("ai-launcher-invite")).toBeInTheDocument();

    await userEvent.click(screen.getByTestId("ai-launcher-settings"));
    expect(navigations).toEqual([{ to: "/parametrage" }]);
  });

  it("n'invite PLUS une famille qui a déjà branché sa clé", async () => {
    surfaces = { enabled: true, features: ["chat", "forge"] };
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));

    expect(screen.getByTestId("ai-launcher")).toHaveAttribute("data-state", "on");
    expect(screen.queryByTestId("ai-launcher-invite")).not.toBeInTheDocument();
  });

  it("sur un chapitre : le chat y mène directement, déplié", async () => {
    surfaces = { enabled: true, features: ["chat"] };
    routeParams = { chapterId: "ch-42" };
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));

    // Aucun sélecteur : l'élève a déjà désigné son chapitre en y étant.
    expect(screen.queryByTestId("ai-launcher-chapter")).not.toBeInTheDocument();
    await userEvent.click(screen.getByTestId("ai-launcher-chat-go"));
    expect(navigations).toEqual([
      { to: "/chapitre/$chapterId", params: { chapterId: "ch-42" }, search: { chat: true } },
    ]);
  });

  it("hors chapitre : il faut en choisir un AVANT de pouvoir discuter", async () => {
    surfaces = { enabled: true, features: ["chat"] };
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));

    // Le cadrage sur un cours est ce qui rend la conversation sûre (é11 R-6) :
    // sans chapitre choisi, le bouton ne part pas.
    expect(screen.getByTestId("ai-launcher-chat-go")).toBeDisabled();
    await userEvent.selectOptions(screen.getByTestId("ai-launcher-chapter"), "ch-1");
    await userEvent.click(screen.getByTestId("ai-launcher-chat-go"));

    expect(navigations).toEqual([
      { to: "/chapitre/$chapterId", params: { chapterId: "ch-1" }, search: { chat: true } },
    ]);
  });

  it("la Forge emporte le chapitre courant quand il y en a un", async () => {
    surfaces = { enabled: true, features: ["forge"] };
    routeParams = { chapterId: "ch-42" };
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));
    await userEvent.click(screen.getByTestId("ai-launcher-forge-go"));

    expect(navigations).toEqual([{ to: "/forge", search: { chapitre: "ch-42" } }]);
  });

  it("grise CHAQUE surface séparément", async () => {
    surfaces = { enabled: true, features: ["forge"] };
    render(<AiLauncher authenticated />);
    await userEvent.click(screen.getByTestId("ai-launcher"));

    expect(screen.getByTestId("ai-launcher-chat")).toHaveAttribute("data-locked", "true");
    expect(screen.getByTestId("ai-launcher-forge")).toHaveAttribute("data-locked", "false");
  });

  it("SE TAIT pendant une épreuve notée — anti-triche, pas découverte", () => {
    surfaces = { enabled: true, features: ["chat", "forge"] };
    for (const path of ["/quest/abc", "/dungeon", "/duel/xyz", "/examen/1", "/onboarding"]) {
      window.history.replaceState({}, "", path);
      const view = render(<AiLauncher authenticated />);
      expect(screen.queryByTestId("ai-launcher"), path).not.toBeInTheDocument();
      view.unmount();
    }
  });

  it("n'existe pas pour un visiteur anonyme", () => {
    render(<AiLauncher authenticated={false} />);
    expect(screen.queryByTestId("ai-launcher")).not.toBeInTheDocument();
  });
});
