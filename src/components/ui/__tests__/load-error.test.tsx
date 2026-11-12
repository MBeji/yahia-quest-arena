import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";

import { I18nProvider } from "@/lib/i18n";
import { fr } from "@/lib/i18n/fr";
import { LoadError } from "../load-error";

// Audit d'affichage (#1228) — `load-error-endless-loader-parcours-boutique`,
// `dashboard-profile-not-found-deadend`, `empty-state-errors-not-announced` : un
// chargement échoué laissait un squelette sans fin, ou une ligne d'anglais sans action.
describe("LoadError — un chargement échoué se dit, et offre une issue", () => {
  it("est annoncé, titré par défaut, et « Réessayer » relance", async () => {
    const onRetry = vi.fn();
    render(
      <I18nProvider>
        <LoadError onRetry={onRetry} />
      </I18nProvider>,
    );
    expect(screen.getByRole("alert")).toHaveTextContent(fr.errors.errorTitle);
    const retry = screen.getByRole("button", { name: fr.common.retry });
    expect(retry.className).toContain("min-h-11");
    await userEvent.click(retry);
    expect(onRetry).toHaveBeenCalledTimes(1);
  });

  it("porte le titre de la page et sa seconde issue", () => {
    render(
      <I18nProvider>
        <LoadError title="Impossible de charger la boutique" onRetry={() => {}}>
          <a href="/dashboard">Retour au hall</a>
        </LoadError>
      </I18nProvider>,
    );
    const alert = screen.getByRole("alert");
    expect(alert).toHaveTextContent("Impossible de charger la boutique");
    expect(screen.getByRole("link", { name: "Retour au hall" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: fr.common.retry })).toBeInTheDocument();
  });
});
