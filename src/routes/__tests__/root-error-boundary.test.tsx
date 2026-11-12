import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

// La frontière d'erreur racine REMPLACE `RootComponent` : `I18nProvider` n'est plus
// au-dessus d'elle. Elle lisait donc le contexte par défaut — du français, de gauche
// à droite, pour l'élève arabophone comme pour l'anglophone (issue #1228,
// `root-error-boundary-wrong-language-direction`). On la rend ici SANS provider,
// comme le routeur le fait.
const requete = vi.hoisted(() => ({ locale: "fr" as "fr" | "en" | "ar" }));
vi.mock("@/lib/i18n/shell-locale", () => ({ getShellLocale: () => requete.locale }));
vi.mock("@tanstack/react-router", () => ({
  createRootRouteWithContext: () => (opts: unknown) => opts,
  useRouter: () => ({ invalidate: vi.fn() }),
  Link: ({ children }: { children: React.ReactNode }) => React.createElement("a", null, children),
  Outlet: () => null,
  HeadContent: () => null,
  Scripts: () => null,
}));
vi.mock("@/features/auth", () => ({ useExitOnRefusedSession: () => {} }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn() },
}));

import { Route } from "../__root";
import { loadCatalogue } from "@/lib/i18n/catalogues";

const ErrorComponent = (
  Route as unknown as {
    errorComponent: React.ComponentType<{ error: unknown; reset: () => void }>;
  }
).errorComponent;

describe("frontière d'erreur racine — langue et sens de la requête", () => {
  beforeEach(() => {
    requete.locale = "fr";
  });

  it("cookie arabe : texte arabe, écran en RTL", async () => {
    const ar = await loadCatalogue("ar");
    requete.locale = "ar";
    render(<ErrorComponent error={new Error("")} reset={() => {}} />);
    const screenEl = screen.getByTestId("root-error-boundary");
    expect(screenEl.getAttribute("dir")).toBe("rtl");
    expect(screenEl.getAttribute("lang")).toBe("ar");
    expect(screen.getByRole("heading").textContent).toBe(ar.errors.errorTitle);
    expect(screen.getByRole("button").textContent).toBe(ar.common.retry);
    expect(screenEl.textContent).not.toContain("Réessayer");
  });

  it("cookie anglais : texte anglais, LTR", async () => {
    const en = await loadCatalogue("en");
    requete.locale = "en";
    render(<ErrorComponent error={new Error("")} reset={() => {}} />);
    const screenEl = screen.getByTestId("root-error-boundary");
    expect(screenEl.getAttribute("dir")).toBe("ltr");
    expect(screen.getByRole("heading").textContent).toBe(en.errors.errorTitle);
  });

  it("sans cookie : français, LTR", () => {
    render(<ErrorComponent error={new Error("")} reset={() => {}} />);
    const screenEl = screen.getByTestId("root-error-boundary");
    expect(screenEl.getAttribute("dir")).toBe("ltr");
    expect(screenEl.getAttribute("lang")).toBe("fr");
    expect(screen.getByRole("button").textContent).toBe("Réessayer");
  });
});
