import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    className,
  }: {
    children: React.ReactNode;
    to: string;
    className?: string;
  }) => React.createElement("a", { href: to, className }, children),
}));

import { I18nProvider } from "@/lib/i18n";
import { StudentTabBar } from "../student-tab-bar";
import { TAB_BAR_CLEARANCE } from "../student-nav";

const renderBar = () =>
  render(
    <I18nProvider>
      <StudentTabBar />
    </I18nProvider>,
  );

describe("StudentTabBar — la navigation d'un élève sur téléphone", () => {
  it("porte les quatre destinations de l'élève, dans l'ordre", () => {
    renderBar();
    const links = screen.getAllByRole("link");
    expect(links.map((link) => link.getAttribute("href"))).toEqual([
      "/dashboard",
      "/parcours",
      "/programme",
      "/arene",
    ]);
    // Le nom d'un onglet est son libellé VISIBLE (WCAG 2.5.3), pas un `aria-label` à part.
    expect(links.map((link) => link.textContent)).toEqual([
      "Hall des Héros",
      "Parcours",
      "Programme",
      "Arène",
    ]);
  });

  it("est une navigation NOMMÉE : une page de catalogue en porte déjà une autre", () => {
    renderBar();
    expect(screen.getByRole("navigation", { name: "Mon espace" })).toBe(
      screen.getByTestId("student-tab-bar"),
    );
  });

  it("s'efface dès `lg` (la barre du haut prend le relais) et à l'impression d'un cours", () => {
    renderBar();
    expect(screen.getByTestId("student-tab-bar")).toHaveClass("fixed", "lg:hidden", "print:hidden");
  });

  it("la place à réserver suit les mêmes seuils que la barre", () => {
    expect(TAB_BAR_CLEARANCE).toContain("pb-[calc(4.5rem+env(safe-area-inset-bottom))]");
    expect(TAB_BAR_CLEARANCE).toContain("lg:pb-[env(safe-area-inset-bottom)]");
    expect(TAB_BAR_CLEARANCE).toContain("print:pb-0");
  });
});
