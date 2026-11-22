// @vitest-environment jsdom
import { act, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import React from "react";

/** Audit de navigation du 2026-11-21, N-16 : une navigation sans rechargement ne disait rien. */
let resolved: (() => void) | undefined;
const routerState = { location: { href: "/" } };
vi.mock("@tanstack/react-router", () => ({
  useRouter: () => ({
    state: routerState,
    subscribe: (_event: string, cb: () => void) => {
      resolved = cb;
      return () => {};
    },
  }),
}));
/** Une navigation : l'adresse change, puis le routeur la dit résolue. */
const navigateTo = (href: string) => {
  routerState.location.href = href;
  act(() => resolved?.());
};

import { MAIN_CONTENT_ID, RouteAnnouncer, SkipToContent } from "../route-announcer";

beforeEach(() => {
  routerState.location.href = "/";
  vi.spyOn(window, "requestAnimationFrame").mockImplementation((cb) => {
    cb(0);
    return 0;
  });
});

function renderWithMain() {
  return render(
    <>
      <RouteAnnouncer />
      <main id={MAIN_CONTENT_ID} tabIndex={-1}>
        <button type="button">filtre</button>
      </main>
    </>,
  );
}

describe("RouteAnnouncer", () => {
  it("se tait sur la page chargée : le navigateur l'annonce lui-même", () => {
    document.title = "Accueil";
    renderWithMain();
    act(() => resolved?.());
    expect(screen.getByTestId("route-announcer")).toHaveTextContent("");
  });

  it("annonce la PREMIÈRE navigation, même si la résolution initiale est passée avant lui", () => {
    renderWithMain();
    document.title = "Parcours · Na9ra Nal3ab";
    navigateTo("/parcours");
    expect(screen.getByTestId("route-announcer")).toHaveTextContent("Parcours · Na9ra Nal3ab");
  });

  it("annonce le titre de la nouvelle page et pose le focus perdu sur le contenu", () => {
    renderWithMain();
    document.title = "Arène · Na9ra Nal3ab";
    (document.activeElement as HTMLElement | null)?.blur();
    navigateTo("/arene");
    expect(screen.getByTestId("route-announcer")).toHaveTextContent("Arène · Na9ra Nal3ab");
    expect(document.activeElement?.id).toBe(MAIN_CONTENT_ID);
  });

  it("ne vole pas le focus d'un contrôle encore là (un filtre qui touche l'adresse)", () => {
    renderWithMain();
    const filtre = screen.getByRole("button", { name: "filtre" });
    filtre.focus();
    navigateTo("/classement?onglet=semaine");
    expect(document.activeElement).toBe(filtre);
  });
});

describe("SkipToContent", () => {
  it("mène au contenu principal", () => {
    render(<SkipToContent label="Aller au contenu" />);
    expect(screen.getByRole("link", { name: "Aller au contenu" })).toHaveAttribute(
      "href",
      `#${MAIN_CONTENT_ID}`,
    );
  });
});
