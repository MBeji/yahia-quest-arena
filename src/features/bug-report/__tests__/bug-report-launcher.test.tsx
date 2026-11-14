import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";

vi.mock("@tanstack/react-start", () => ({ useServerFn: () => vi.fn() }));
vi.mock("@tanstack/react-query", () => ({
  useMutation: () => ({ mutate: vi.fn(), isPending: false }),
}));
vi.mock("../bug-report.server", () => ({ reportBug: vi.fn() }));

import { I18nProvider } from "@/lib/i18n";
import { BugReportLauncher } from "../components/bug-report-launcher";

const renderLauncher = (props: Partial<Parameters<typeof BugReportLauncher>[0]> = {}) => {
  const onOpenChange = vi.fn();
  render(
    <I18nProvider>
      <BugReportLauncher open={false} onOpenChange={onOpenChange} {...props} />
    </I18nProvider>,
  );
  return { onOpenChange };
};

// 2026-11-14 — la pastille flottante recouvrait le contenu sur téléphone, empilée avec la
// bulle du Prof au-dessus de la barre d'onglets. Elle n'existe plus que dès `lg` ; en dessous,
// la porte est une ligne du menu des réglages. La fenêtre, elle, est la même.
describe("BugReportLauncher — deux portes, une fenêtre", () => {
  it("ne montre sa pastille qu'à partir de `lg`", () => {
    renderLauncher();
    const pill = screen.getByTestId("bug-report-floating");
    expect(pill).toHaveClass("hidden", "lg:inline-flex");
  });

  it("la pastille demande l'ouverture à la coquille, qui tient l'état", async () => {
    const { onOpenChange } = renderLauncher();
    await userEvent.click(screen.getByTestId("bug-report-floating"));
    expect(onOpenChange).toHaveBeenCalledWith(true);
  });

  it("sans pastille (écran immersif), la fenêtre s'ouvre quand même : le menu des réglages la commande", () => {
    renderLauncher({ floating: false, open: true });
    expect(screen.queryByTestId("bug-report-floating")).toBeNull();
    expect(screen.getByRole("dialog")).toBeInTheDocument();
    expect(screen.getByRole("textbox")).toBeInTheDocument();
  });

  it("fermée, elle ne monte aucune fenêtre", () => {
    renderLauncher();
    expect(screen.queryByRole("dialog")).toBeNull();
  });
});
