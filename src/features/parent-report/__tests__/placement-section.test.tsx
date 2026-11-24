import { render, screen, within } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { parentTranslations } from "@/lib/i18n/parent";
import { PLACEMENT_BANDS } from "@/shared/constants/placement";
import type { StudentPlacementSummary } from "../parent-report.schemas";

const locale = vi.hoisted(() => ({ current: "fr" as "fr" | "en" | "ar" }));
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: locale.current }) }));
vi.mock("@/lib/i18n/parent", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/parent")>();
  return { ...actual, useParentT: () => actual.parentTranslations(locale.current) };
});

import { PlacementSection } from "../components/placement-section";

const LRI = "⁦";
const PDI = "⁩";

type Test = StudentPlacementSummary["tests"][number];

const test = (over: Partial<Test> = {}): Test => ({
  sessionId: "s1",
  subjectId: "math-9",
  subjectNameFr: "Mathématiques",
  gradeNameFr: "9ème année",
  finishedAt: "2026-11-18T10:00:00Z",
  correct: 7,
  total: 10,
  scoreOn20: 14,
  band: "en-route",
  chaptersHeld: ["Nombres", "Fractions"],
  chaptersToReview: ["Angles"],
  scope: { throughTitle: "Angles", chaptersInScope: 4, chaptersTotal: 12 },
  ...over,
});

beforeEach(() => {
  locale.current = "fr";
});

describe("PlacementSection — étude 39 lot 5 (é08)", () => {
  it("aucun test : rien à l'écran", () => {
    const { container } = render(<PlacementSection summary={{ tests: [] }} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("⭐ affiche la matière, la note sur 20 et la bande", () => {
    render(<PlacementSection summary={{ tests: [test()] }} />);
    const row = within(screen.getByTestId("report-placement-test"));
    expect(row.getByTestId("report-placement-title")).toHaveTextContent(
      "Mathématiques · 9ème année",
    );
    expect(row.getByText(`${LRI}14 / 20${PDI}`)).toBeInTheDocument();
    expect(row.getByTestId("report-placement-band")).toHaveTextContent("En bonne voie");
  });

  it("⭐ ce qui tient, puis ce qui est à revoir", () => {
    render(<PlacementSection summary={{ tests: [test()] }} />);
    expect(screen.getByTestId("report-placement-held")).toHaveTextContent(
      "Ce qui tient — Nombres · Fractions",
    );
    expect(screen.getByTestId("report-placement-review")).toHaveTextContent("À revoir — Angles");
  });

  it("tout est tenu : aucune ligne « à revoir » vide", () => {
    render(<PlacementSection summary={{ tests: [test({ chaptersToReview: [] })] }} />);
    expect(screen.queryByTestId("report-placement-review")).not.toBeInTheDocument();
    expect(screen.getByTestId("report-placement-held")).toBeInTheDocument();
  });

  it("⭐ la portée dit sur quoi l'enfant a été testé", () => {
    const { rerender } = render(<PlacementSection summary={{ tests: [test()] }} />);
    expect(screen.getByTestId("report-placement-scope")).toHaveTextContent(
      "Testé sur le programme vu jusqu'à « Angles » (4 chapitres sur 12).",
    );
    rerender(<PlacementSection summary={{ tests: [test({ scope: null })] }} />);
    expect(screen.getByTestId("report-placement-scope")).toHaveTextContent(
      "Testé sur tout le programme de l'année.",
    );
  });

  it("une matière sans classe : le nom seul, pas de « · » orphelin", () => {
    render(<PlacementSection summary={{ tests: [test({ gradeNameFr: null })] }} />);
    expect(screen.getByTestId("report-placement-title")).toHaveTextContent(/^Mathématiques$/);
  });

  it("matière arabe : chaque morceau est isolé et la ligne n'est pas retournée (dir=auto)", () => {
    render(
      <PlacementSection
        summary={{
          tests: [test({ subjectNameFr: "الرياضيات", gradeNameFr: "9ème année de base" })],
        }}
      />,
    );
    const title = screen.getByTestId("report-placement-title");
    // Pas de `dir="auto"` : c'est lui qui faisait passer la classe avant la matière.
    expect(title).not.toHaveAttribute("dir");
    const parts = title.querySelectorAll("bdi");
    expect(parts).toHaveLength(2);
    expect(parts[0]).toHaveTextContent("الرياضيات");
    expect(parts[1]).toHaveTextContent("9ème année de base");
  });

  it("plusieurs matières : une ligne chacune", () => {
    render(
      <PlacementSection
        summary={{ tests: [test(), test({ sessionId: "s2", subjectNameFr: "SVT" })] }}
      />,
    );
    expect(screen.getAllByTestId("report-placement-test")).toHaveLength(2);
  });

  it("RTL : la note reste un bloc LTR, la phrase de portée un seul nœud de texte", () => {
    locale.current = "ar";
    render(<PlacementSection summary={{ tests: [test({ scoreOn20: 13.5 })] }} />);
    const ar = parentTranslations("ar").parentReport;
    const row = within(screen.getByTestId("report-placement-test"));
    expect(row.getByText(`${LRI}13.5 / 20${PDI}`)).toBeInTheDocument();
    const scope = row.getByTestId("report-placement-scope");
    expect(scope.childNodes).toHaveLength(1);
    expect(row.getByTestId("report-placement-band")).toHaveTextContent(
      ar.placementBands["en-route"],
    );
  });

  it("les trois langues nomment les quatre bandes et portent les clés, sans mot d'argent", () => {
    for (const code of ["fr", "en", "ar"] as const) {
      const p = parentTranslations(code).parentReport;
      for (const band of PLACEMENT_BANDS) {
        expect(p.placementBands[band].trim().length).toBeGreaterThan(0);
      }
      for (const key of [
        "placementTitle",
        "placementHeld",
        "placementToReview",
        "placementScope",
        "placementWholeYear",
        "placementHint",
      ] as const) {
        expect(p[key].trim().length).toBeGreaterThan(0);
        expect(p[key].toLowerCase()).not.toMatch(/premium|abonnement|payant|subscription/);
      }
      expect(p.placementScope).toContain("{total}");
      expect(p.placementScope).toContain("{chapter}");
    }
  });
});
