import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import React from "react";

// Le menu n'a besoin que de <Link> — stub identique à celui des specs voisines.
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    onClick,
  }: {
    children: React.ReactNode;
    to: string;
    onClick?: () => void;
  }) => React.createElement("a", { href: to, onClick }, children),
}));

import { I18nProvider } from "@/lib/i18n";
import { SettingsMenu } from "../settings-menu";

const renderMenu = (props: { onSignOut?: () => void } = {}) =>
  render(
    <I18nProvider>
      <SettingsMenu {...props} />
    </I18nProvider>,
  );

const open = async () => userEvent.click(screen.getByTestId("settings-trigger"));

describe("SettingsMenu — le point d'entrée unique des réglages", () => {
  it("est fermé au départ : il ne prend qu'un bouton dans le header", () => {
    renderMenu();
    expect(screen.getByTestId("settings-trigger")).toBeInTheDocument();
    expect(screen.queryByTestId("settings-menu")).toBeNull();
  });

  it("réunit les quatre bascules instantanées que trois pop-over portaient séparément", async () => {
    renderMenu();
    await open();
    // Thème (2 choix) + langue (3 choix) — ex-ThemeSwitcher et ex-LanguageSwitcher.
    expect(screen.getAllByRole("menuitemradio")).toHaveLength(5);
    // Son : effets + musique — ex-SoundSwitcher.
    expect(screen.getAllByRole("switch")).toHaveLength(2);
  });

  it("sans onSignOut (coquille publique), aucun bloc compte", async () => {
    renderMenu();
    await open();
    expect(screen.queryByRole("link")).toBeNull();
    expect(screen.queryByRole("button", { name: /déconnexion|sign out/i })).toBeNull();
    // …mais les réglages rapides, eux, sont bien là.
    expect(screen.getAllByRole("switch")).toHaveLength(2);
  });

  it("avec onSignOut (coquille connectée), il mène à la page-pôle et déconnecte", async () => {
    const onSignOut = vi.fn();
    renderMenu({ onSignOut });
    await open();

    const link = screen.getByRole("link");
    expect(link).toHaveAttribute("href", "/parametrage");

    await userEvent.click(screen.getByRole("button", { name: /déconnexion|sign out/i }));
    expect(onSignOut).toHaveBeenCalledTimes(1);
    // Le menu se referme : il ne doit pas rester ouvert par-dessus l'écran suivant.
    expect(screen.queryByTestId("settings-menu")).toBeNull();
  });

  it("Échap referme — le menu porte des interrupteurs, il ne piège pas le clavier", async () => {
    renderMenu();
    await open();
    expect(screen.getByTestId("settings-menu")).toBeInTheDocument();
    await userEvent.keyboard("{Escape}");
    expect(screen.queryByTestId("settings-menu")).toBeNull();
  });
});
