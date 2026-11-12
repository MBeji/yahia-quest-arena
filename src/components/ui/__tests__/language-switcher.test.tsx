import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect } from "vitest";

import { I18nProvider } from "@/lib/i18n";
import { LanguageSwitcher } from "../language-switcher";

const renderSwitcher = () =>
  render(
    <I18nProvider>
      <LanguageSwitcher />
    </I18nProvider>,
  );

// Audit d'affichage (#1228) — `accessible-names-label-in-name` et
// `hardcoded-english-accessible-names` : le bouton portait `aria-label="Change language"`,
// en anglais dans une interface française, et sans le « FR » qu'il affiche.
describe("LanguageSwitcher — le sélecteur de langue des écrans sans en-tête", () => {
  it("son nom accessible contient le code affiché et n'est plus de l'anglais en dur", () => {
    renderSwitcher();
    const trigger = screen.getByRole("button");
    const visible = trigger.querySelector("span:not(.sr-only)")?.textContent ?? "";
    expect(visible).not.toBe("");
    expect(trigger).toHaveAccessibleName(new RegExp(visible));
    expect(trigger).not.toHaveAttribute("aria-label");
    expect(trigger).not.toHaveAccessibleName(/change language/i);
  });

  it("dit s'il est ouvert, offre des choix de 44 px et marque la langue active", async () => {
    renderSwitcher();
    const trigger = screen.getByRole("button");
    expect(trigger).toHaveAttribute("aria-expanded", "false");
    await userEvent.click(trigger);
    expect(trigger).toHaveAttribute("aria-expanded", "true");

    const choices = screen.getAllByRole("button").filter((b) => b !== trigger);
    expect(choices).toHaveLength(3);
    for (const choice of choices) expect(choice.className).toContain("min-h-11");
    expect(choices.filter((c) => c.getAttribute("aria-current") === "true")).toHaveLength(1);
    // Chaque libellé natif est lu dans sa langue.
    expect(screen.getByRole("button", { name: "العربية" })).toHaveAttribute("lang", "ar");
  });

  it("Échap referme la liste", async () => {
    renderSwitcher();
    const trigger = screen.getByRole("button");
    await userEvent.click(trigger);
    await userEvent.keyboard("{Escape}");
    expect(trigger).toHaveAttribute("aria-expanded", "false");
    expect(screen.getAllByRole("button")).toHaveLength(1);
  });

  it("choisir une langue la rend active et referme", async () => {
    renderSwitcher();
    await userEvent.click(screen.getByRole("button"));
    await userEvent.click(screen.getByRole("button", { name: "English" }));
    expect(screen.getAllByRole("button")).toHaveLength(1);
    // Le catalogue de la nouvelle langue se charge : le code affiché suit au rendu suivant.
    await waitFor(() => expect(screen.getByRole("button")).toHaveAccessibleName(/EN/));
  });
});
