import { describe, it, expect, afterEach } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { I18nProvider, useI18n } from "@/lib/i18n";
import { useParentT, parentTranslations } from "@/lib/i18n/parent";
import { fr } from "@/lib/i18n/fr";
import { frParent } from "@/lib/i18n/parent/fr";
import { arParent } from "@/lib/i18n/parent/ar";

/**
 * Le catalogue de la surface parent vit à part (chunk `i18n-parent`, chargé avec
 * /suivi et /parent-report seulement — voir `src/lib/i18n/parent/index.ts`).
 * Ce fichier garde le CÂBLAGE de ce découpage : les tests de la feature
 * parent-report, eux, mockent `@/lib/i18n/parent` et ne le vérifieraient pas.
 */
function ParentConsumer() {
  const t = useParentT();
  return (
    <div>
      {/* une clé app-wide et deux clés parent, lues sur le MÊME objet */}
      <span data-testid="core">{t.common.loading}</span>
      <span data-testid="daily">{t.parentDaily.tabSummary}</span>
      <span data-testid="report">{t.parentReport.title}</span>
    </div>
  );
}

function LocaleSwitch() {
  const { setLocale } = useI18n();
  return <button data-testid="to-ar" onClick={() => setLocale("ar")} />;
}

describe("catalogue i18n de la surface parent", () => {
  afterEach(() => {
    localStorage.clear();
  });

  it("fusionne le catalogue app-wide et le catalogue parent sur le même `t`", () => {
    render(
      <I18nProvider>
        <ParentConsumer />
      </I18nProvider>,
    );

    // Une seule porte d'entrée rend les deux moitiés — c'est ce qui permet aux
    // écrans parent de remplacer `useT()` par `useParentT()` sans rien changer
    // d'autre.
    expect(screen.getByTestId("core").textContent).toBe(fr.common.loading);
    expect(screen.getByTestId("daily").textContent).toBe(frParent.parentDaily.tabSummary);
    expect(screen.getByTestId("report").textContent).toBe(frParent.parentReport.title);
  });

  it("suit le changement de langue comme le catalogue app-wide", () => {
    render(
      <I18nProvider>
        <LocaleSwitch />
        <ParentConsumer />
      </I18nProvider>,
    );

    expect(screen.getByTestId("daily").textContent).toBe(frParent.parentDaily.tabSummary);

    act(() => {
      fireEvent.click(screen.getByTestId("to-ar"));
    });

    expect(screen.getByTestId("daily").textContent).toBe(arParent.parentDaily.tabSummary);
    // Contrôle négatif : les deux libellés diffèrent bien, sinon l'assertion
    // ci-dessus passerait même si la locale n'était pas suivie.
    expect(arParent.parentDaily.tabSummary).not.toBe(frParent.parentDaily.tabSummary);
  });

  it("expose le catalogue parent hors composant, pour les trois langues", () => {
    for (const locale of ["fr", "en", "ar"] as const) {
      expect(parentTranslations(locale).parentReport.title).toBeTruthy();
      expect(parentTranslations(locale).parentDaily.tabSummary).toBeTruthy();
    }
  });

  it("garde les namespaces parent HORS du catalogue app-wide (l'objet du découpage)", () => {
    // Si cette assertion tombe, le catalogue parent a été ré-agrégé dans celui que
    // chaque élève télécharge : le budget `i18n-` remontera de ~36 KB et le gain
    // est perdu. Voir `scripts/check-bundle-budget.mjs`.
    expect(fr).not.toHaveProperty("parentReport");
    expect(fr).not.toHaveProperty("parentDaily");
  });
});
