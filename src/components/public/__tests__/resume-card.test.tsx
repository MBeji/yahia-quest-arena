import { act, fireEvent, render, screen } from "@testing-library/react";
import { hydrateRoot } from "react-dom/client";
import { renderToString } from "react-dom/server";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import React from "react";

/**
 * Étude 38 lot 5 — LA CARTE « REPRENDRE » du visiteur sans compte.
 *
 * Ce qui se prouve ici : un chapitre lu ⇒ la carte, sur l'accueil ; TTL échu ⇒ rien ; « oublier »
 * ⇒ rien, mémoire vidée ; un visiteur CONNECTÉ ne la voit jamais, ni tant que la session n'est pas
 * lue ; le serveur ne la rend pas et l'hydratation ne proteste pas ; le titre reste dans la langue
 * où il a été lu quand l'interface en a changé ; le clic se mesure sans rien dire du lecteur.
 */
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
    onClick,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
    onClick?: () => void;
  }) =>
    React.createElement(
      "a",
      {
        ...rest,
        href: params ? to.replace(/\$(\w+)/g, (_m, k: string) => params[k] ?? `$${k}`) : to,
        onClick: (e: React.MouseEvent) => {
          e.preventDefault();
          onClick?.();
        },
      },
      children,
    ),
}));
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));
vi.mock("@/hooks/use-mobile", () => ({ useIsMobile: () => true }));
vi.mock("@/components/landing/golden-hero-canvas", () => ({ default: () => null }));
const mockUseAuth = vi.fn();
vi.mock("@/features/auth", () => ({ useAuth: () => mockUseAuth() }));

import { I18nProvider } from "@/lib/i18n";
import { STORAGE_KEY as LOCALE_KEY } from "@/lib/i18n/context";
import {
  ANON_CONTINUITY_TTL_MS,
  LAST_CHAPTER_KEY,
  QUIZ_PASSED_KEY,
  rememberLastChapter,
  rememberQuizPassed,
} from "@/shared/lib/anon-continuity";
import { PublicLanding } from "../public-landing";
import { ResumeCard } from "../resume-card";

const DAY = 24 * 60 * 60 * 1000;
const anonymous = { user: null, session: null, loading: false };

beforeEach(() => {
  window.localStorage.clear();
  trackProductEvent.mockClear();
  mockUseAuth.mockReturnValue(anonymous);
});
afterEach(() => {
  vi.restoreAllMocks();
});

describe("la carte « Reprendre » sur l'accueil", () => {
  it("⭐ un chapitre lu ⇒ la carte au passage suivant, avec son lien", () => {
    rememberLastChapter({ id: "ch-fractions", title: "Les fractions", lang: "fr" });
    render(<PublicLanding />);

    const card = screen.getByTestId("resume-card");
    expect(card).toHaveTextContent("Reprendre");
    expect(screen.getByTestId("resume-card-title")).toHaveTextContent("Les fractions");
    expect(screen.getByTestId("resume-card-link")).toHaveAttribute(
      "href",
      "/chapitre/ch-fractions",
    );
    // La carte prend la place de la pastille : c'est ce qui la dispense de pousser le titre.
    expect(screen.queryByText(/100 % gratuit · sans inscription/)).toBeNull();
  });

  it("rien à reprendre ⇒ l'accueil d'avant, pastille comprise", () => {
    render(<PublicLanding />);
    expect(screen.queryByTestId("resume-card")).toBeNull();
    expect(screen.getByText(/100 % gratuit · sans inscription/)).toBeInTheDocument();
  });

  it("⭐ TTL échu ⇒ rien", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" }, Date.now() - ANON_CONTINUITY_TTL_MS - DAY);
    render(<PublicLanding />);
    expect(screen.queryByTestId("resume-card")).toBeNull();
  });

  it("⭐ « oublier » ⇒ la carte disparaît et l'appareil ne retient plus rien", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" });
    rememberQuizPassed("ch-1");
    render(<PublicLanding />);

    fireEvent.click(screen.getByTestId("resume-card-forget"));

    expect(screen.queryByTestId("resume-card")).toBeNull();
    expect(screen.getByText(/100 % gratuit · sans inscription/)).toBeInTheDocument();
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
    expect(window.localStorage.getItem(QUIZ_PASSED_KEY)).toBeNull();
    // Oublier ne se mesure pas : rien ne part.
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("⭐ un visiteur CONNECTÉ ne voit jamais la carte", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" });
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    render(<PublicLanding />);
    expect(screen.queryByTestId("resume-card")).toBeNull();
  });

  it("tant que la session n'est pas lue, rien — la carte ne clignote pas pour un connecté", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" });
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: true });
    const { rerender } = render(<PublicLanding />);
    expect(screen.queryByTestId("resume-card")).toBeNull();

    mockUseAuth.mockReturnValue(anonymous);
    rerender(<PublicLanding />);
    expect(screen.getByTestId("resume-card")).toBeInTheDocument();
  });

  it("stockage indisponible ⇒ l'accueil d'avant, sans erreur", () => {
    vi.spyOn(Storage.prototype, "getItem").mockImplementation(() => {
      throw new DOMException("refusé", "SecurityError");
    });
    expect(() => render(<PublicLanding />)).not.toThrow();
    expect(screen.queryByTestId("resume-card")).toBeNull();
  });
});

describe("la carte autonome (/programme)", () => {
  it("rend la carte quand il y a quoi reprendre, rien sinon", () => {
    const { container, unmount } = render(<ResumeCard surface="programme" />);
    expect(container).toBeEmptyDOMElement();
    unmount();

    rememberLastChapter({ id: "ch-1", title: "Un" });
    render(<ResumeCard surface="programme" />);
    expect(screen.getByTestId("resume-card-link")).toHaveAttribute("href", "/chapitre/ch-1");
  });

  it("apprend d'un autre onglet qu'un chapitre vient d'être lu", () => {
    render(<ResumeCard surface="programme" />);
    expect(screen.queryByTestId("resume-card")).toBeNull();

    act(() => {
      window.localStorage.setItem(
        LAST_CHAPTER_KEY,
        JSON.stringify({ id: "ch-9", title: "Neuf", lang: "fr", at: Date.now() }),
      );
      window.dispatchEvent(new StorageEvent("storage", { key: LAST_CHAPTER_KEY }));
    });
    expect(screen.getByTestId("resume-card-title")).toHaveTextContent("Neuf");
  });
});

describe("la mesure — `resume_card_clicked`", () => {
  it("⭐ le clic dit d'où et depuis combien de jours — ni le chapitre, ni le lecteur", () => {
    rememberLastChapter({ id: "ch-secret", title: "Titre lu" }, Date.now() - 3 * DAY - 1000);
    render(<ResumeCard surface="programme" />);

    fireEvent.click(screen.getByTestId("resume-card-link"));

    expect(trackProductEvent).toHaveBeenCalledTimes(1);
    expect(trackProductEvent).toHaveBeenCalledWith("resume_card_clicked", {
      surface: "programme",
      days_since: 3,
    });
    expect(JSON.stringify(trackProductEvent.mock.calls)).not.toMatch(/ch-secret|Titre lu/);
  });
});

describe("trois langues — le titre reste celui qui a été LU", () => {
  // La langue de l'interface est celle que l'appareil a retenue : le fournisseur l'applique après
  // le premier rendu (catalogue chargé à la demande), d'où l'attente.
  it("⭐ interface passée à l'arabe : habillage en arabe, titre français isolé dans sa langue", async () => {
    rememberLastChapter({ id: "ch-1", title: "Les fractions (1)", lang: "fr" });
    window.localStorage.setItem(LOCALE_KEY, "ar");
    render(
      <I18nProvider>
        <ResumeCard surface="landing" />
      </I18nProvider>,
    );
    expect(await screen.findByText("واصل القراءة")).toBeInTheDocument();
    expect(screen.getByTestId("resume-card-forget")).toHaveTextContent("انسَ");
    const title = screen.getByTestId("resume-card-title");
    expect(title).toHaveTextContent("Les fractions (1)");
    expect(title.tagName).toBe("BDI");
    expect(title).toHaveAttribute("dir", "auto");
    expect(title).toHaveAttribute("lang", "fr");
  });

  it("interface en anglais, titre arabe : même règle dans l'autre sens", async () => {
    rememberLastChapter({ id: "ch-2", title: "الكسور", lang: "ar" });
    window.localStorage.setItem(LOCALE_KEY, "en");
    render(
      <I18nProvider>
        <ResumeCard surface="landing" />
      </I18nProvider>,
    );
    expect(await screen.findByText("Continue reading")).toBeInTheDocument();
    expect(screen.getByTestId("resume-card-title")).toHaveAttribute("lang", "ar");
    expect(screen.getByRole("button", { name: /Stop remembering/ })).toBeInTheDocument();
  });
});

describe("rendu serveur et hydratation", () => {
  it("⭐ le serveur ne rend pas la carte, l'hydratation ne proteste pas, puis la carte arrive", async () => {
    rememberLastChapter({ id: "ch-1", title: "Un" });
    const errors = vi.spyOn(console, "error").mockImplementation(() => {});

    // Le serveur ne connaît pas le stockage — même quand ce test, lui, le remplit.
    const html = renderToString(<PublicLanding />);
    expect(html).not.toContain("resume-card");
    expect(html).toContain("100 % gratuit");

    const host = document.createElement("div");
    host.innerHTML = html;
    document.body.appendChild(host);
    const recoverable = vi.fn();
    let root: ReturnType<typeof hydrateRoot> | undefined;
    await act(async () => {
      root = hydrateRoot(host, <PublicLanding />, { onRecoverableError: recoverable });
    });

    expect(recoverable).not.toHaveBeenCalled();
    expect(errors.mock.calls.flat().join(" ")).not.toMatch(/hydrat/i);
    expect(host.querySelector('[data-testid="resume-card"]')).not.toBeNull();

    act(() => root?.unmount());
    document.body.removeChild(host);
  });
});
