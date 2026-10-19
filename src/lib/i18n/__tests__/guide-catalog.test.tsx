import { afterEach, describe, expect, it } from "vitest";
import { fireEvent, render, screen } from "@testing-library/react";

import { I18nProvider, useI18n } from "@/lib/i18n";
import { fr } from "@/lib/i18n/fr";
import { guideTranslations, useGuideT } from "@/lib/i18n/guide";
import { arGuide } from "@/lib/i18n/guide/ar";
import { enGuide } from "@/lib/i18n/guide/en";
import { frGuide } from "@/lib/i18n/guide/fr";

/**
 * Le catalogue du GUIDE INTÉGRÉ vit à part (chunk `i18n-guide`). Comme pour la
 * progression, ce fichier garde le câblage (`useGuideT()` rend app-wide ET
 * `guide.*`, et suit la langue) et la complétude : trois langues, exactement les
 * mêmes clés — et le même NOMBRE de lignes par fiche, sinon un parent arabophone
 * lirait une fiche amputée.
 */
function GuideConsumer() {
  const t = useGuideT();
  return (
    <div>
      <span data-testid="core">{t.common.loading}</span>
      <span data-testid="sheet">{t.guide.sheetTitle}</span>
    </div>
  );
}

function LocaleSwitch() {
  const { setLocale } = useI18n();
  return <button data-testid="to-ar" onClick={() => setLocale("ar")} />;
}

function leafPaths(value: unknown, prefix = ""): string[] {
  if (value === null || typeof value !== "object") return [prefix];
  return Object.entries(value as Record<string, unknown>)
    .flatMap(([k, v]) => leafPaths(v, prefix ? `${prefix}.${k}` : k))
    .sort();
}

function leaves(value: unknown): string[] {
  if (value === null || typeof value !== "object") return [String(value)];
  return Object.values(value as Record<string, unknown>).flatMap(leaves);
}

describe("catalogue i18n du guide intégré", () => {
  afterEach(() => localStorage.clear());

  it("fusionne le catalogue app-wide et celui du guide, et suit la langue", () => {
    render(
      <I18nProvider>
        <GuideConsumer />
        <LocaleSwitch />
      </I18nProvider>,
    );
    expect(screen.getByTestId("core").textContent).toBe(fr.common.loading);
    expect(screen.getByTestId("sheet").textContent).toBe(frGuide.guide.sheetTitle);
    fireEvent.click(screen.getByTestId("to-ar"));
    expect(screen.getByTestId("sheet").textContent).toBe(arGuide.guide.sheetTitle);
  });

  it("expose chaque locale hors composant", () => {
    expect(guideTranslations("en")).toBe(enGuide);
    expect(guideTranslations("ar")).toBe(arGuide);
    expect(guideTranslations("fr")).toBe(frGuide);
  });

  it("fr, en et ar ont exactement les mêmes clés (fiches comprises)", () => {
    const frPaths = leafPaths(frGuide);
    expect(leafPaths(enGuide)).toEqual(frPaths);
    expect(leafPaths(arGuide)).toEqual(frPaths);
  });

  it("aucune chaîne vide, et jamais le vocabulaire payant (gratuité de phase)", () => {
    for (const catalog of [frGuide, enGuide, arGuide]) {
      for (const text of leaves(catalog)) {
        expect(text.trim()).not.toBe("");
        expect(text).not.toMatch(/premium|abonnement|payant|subscription|paid/i);
      }
    }
  });

  it("les placeholders survivent à la traduction", () => {
    for (const catalog of [enGuide, arGuide]) {
      expect(catalog.guide.rule.quiz.text).toContain("{pct}");
      expect(catalog.guide.rule.quiz.text).toContain("{sec}");
      expect(catalog.guide.locked.body).toContain("{pct}");
      expect(catalog.guide.locked.aria).toContain("{title}");
      expect(catalog.guide.tips.aria).toContain("{label}");
      expect(catalog.guide.tips.quizRow).toContain("{pct}");
    }
  });
});
