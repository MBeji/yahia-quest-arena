import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { parentTranslations } from "@/lib/i18n/parent";
import type { ParcoursComparison } from "../parent-report.schemas";

const locale = vi.hoisted(() => ({ current: "fr" as "fr" | "en" | "ar" }));
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: locale.current }) }));
vi.mock("@/lib/i18n/parent", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/parent")>();
  return { ...actual, useParentT: () => actual.parentTranslations(locale.current) };
});

import { ParcoursComparisonSection } from "../components/parcours-comparison";

type Comparison = NonNullable<ParcoursComparison>;

const comparison = (over: Partial<Comparison> = {}): Comparison => ({
  parcours: { nameFr: "Concours 9ᵉ", nameEn: "9th grade exam", nameAr: "مناظرة التاسعة" },
  student: { avgScore: 70, weeklyMinutes: 95 },
  platform: { masked: false, students: 42, avgScore: 61, weeklyMinutes: 80 },
  ...over,
});

const MASKED = { masked: true, students: null, avgScore: null, weeklyMinutes: null };

beforeEach(() => {
  locale.current = "fr";
});

describe("ParcoursComparisonSection — étude 08 lot 3 (US-8)", () => {
  it("⭐ R-6 : sous le seuil (masqué), rien n'est affiché — aucun chiffre, aucune phrase", () => {
    const { container } = render(
      <ParcoursComparisonSection comparison={comparison({ platform: MASKED })} />,
    );
    expect(container).toBeEmptyDOMElement();
  });

  it("un agrégat incomplet se tait plutôt que d'afficher « null »", () => {
    const { container } = render(
      <ParcoursComparisonSection
        comparison={comparison({
          platform: { masked: false, students: 42, avgScore: null, weeklyMinutes: 80 },
        })}
      />,
    );
    expect(container).toBeEmptyDOMElement();
  });

  it("enfant sans activité sur la fenêtre : personne à situer, rien à l'écran", () => {
    const { container } = render(
      <ParcoursComparisonSection comparison={comparison({ student: null })} />,
    );
    expect(container).toBeEmptyDOMElement();
  });

  it("affiche l'enfant à côté du repère, score et temps hebdomadaire", () => {
    render(<ParcoursComparisonSection comparison={comparison()} />);
    expect(screen.getByText("Score moyen : 70 % · plateforme 61 %")).toBeInTheDocument();
    expect(screen.getByText("Par semaine : 95 min · plateforme 80 min")).toBeInTheDocument();
  });

  it("⭐ R-5 : le libellé dit d'où vient la moyenne — la plateforme, l'effectif, la fenêtre", () => {
    render(<ParcoursComparisonSection comparison={comparison()} />);
    const source = screen.getByText(/Moyenne des 42 élèves actifs de la plateforme/);
    expect(source).toHaveTextContent("« Concours 9ᵉ »");
    expect(source).toHaveTextContent("4 semaines");
  });

  it.each(["fr", "en", "ar"] as const)(
    "⭐ R-5 : %s — jamais « moyenne nationale », jamais un mot de classement présenté comme tel",
    (code) => {
      const p = parentTranslations(code).parentReport;
      const text = [p.compareTitle, p.compareSource, p.compareScore, p.compareTime]
        .join(" ")
        .toLowerCase();
      expect(text).not.toMatch(/national|nationale|وطني/);
      expect(text).not.toMatch(/premium|abonnement|payant|subscription/);
      // « plateforme » est nommée comme la source du repère.
      expect(text).toMatch(/plateforme|platform|المنصّة/);
      expect(p.compareSource).toContain("{n}");
      expect(p.compareSource).toContain("{parcours}");
    },
  );

  it("RISK-1 : le texte dit que c'est un repère, pas un classement — et n'affiche aucun rang", () => {
    render(<ParcoursComparisonSection comparison={comparison()} />);
    const box = screen.getByTestId("report-parcours-comparison");
    expect(box).toHaveTextContent("Un repère, pas un classement");
    expect(box.textContent).not.toMatch(/\d+\s*(e|ème|er)\b|rang|top/i);
  });

  it("nomme le parcours dans la langue du parent, repli sur le français", () => {
    locale.current = "en";
    const { rerender } = render(<ParcoursComparisonSection comparison={comparison()} />);
    expect(screen.getByText(/“9th grade exam”/)).toBeInTheDocument();
    rerender(
      <ParcoursComparisonSection
        comparison={comparison({
          parcours: { nameFr: "Concours 9ᵉ", nameEn: null, nameAr: null },
        })}
      />,
    );
    expect(screen.getByText(/“Concours 9ᵉ”/)).toBeInTheDocument();
  });

  it("RTL : chaque ligne chiffrée est un seul nœud de texte", () => {
    locale.current = "ar";
    render(<ParcoursComparisonSection comparison={comparison()} />);
    const ar = parentTranslations("ar").parentReport;
    const score = screen.getByText(ar.compareScore.replace("{child}", "70").replace("{avg}", "61"));
    const time = screen.getByText(ar.compareTime.replace("{child}", "95").replace("{avg}", "80"));
    expect(score.childNodes).toHaveLength(1);
    expect(time.childNodes).toHaveLength(1);
    expect(screen.getByText(/«مناظرة التاسعة»/).childNodes).toHaveLength(1);
  });
});
