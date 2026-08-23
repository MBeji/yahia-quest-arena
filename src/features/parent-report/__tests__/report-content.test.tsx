import { render } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
  }) =>
    React.createElement(
      "a",
      { href: params ? to.replace(/\$(\w+)/g, (_m, k: string) => params[k] ?? `$${k}`) : to },
      children,
    ),
}));
vi.mock("motion/react", () => ({
  motion: {
    div: ({ children, ...p }: { children?: React.ReactNode }) =>
      React.createElement("div", p, children),
  },
}));
vi.mock("@/shared/lib/motion", () => ({ useEntrance: () => ({}) }));
// A 2-level proxy: any t.<section>.<key> resolves to a stable string with .replace().
const t = new Proxy(
  {},
  { get: (_o, k1) => new Proxy({}, { get: (_o2, k2) => `${String(k1)}.${String(k2)}` }) },
);
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ t, locale: "fr" }), useT: () => t }));

import { ReportContent } from "../components/report-content";

const LRI = "⁦";
const PDI = "⁩";

const report = {
  student: {
    displayName: "Yahia",
    heroClass: "Guerrier",
    level: 5,
    currentStreak: 3,
    createdAt: "2026-01-01T00:00:00Z",
    lastActiveDate: "2026-07-13T00:00:00Z",
  },
  summary: {
    seriousnessScore: 80,
    verdict: "good",
    totalTimeMinutes: 120,
    totalExercises: 20,
    avgScore: 75,
    daysActiveThisWeek: 4,
    scoreTrend: 5,
  },
  subjectStats: [{ subjectId: "s-ar", name: "الرياضيات (الجبر)", avgScore: 72, attempts: 15 }],
  dailyActivity: [{ date: "2026-07-13", exercises: 2, minutes: 10, avgScore: 80 }],
  weekComparison: {
    thisWeek: { exercises: 5, minutes: 30, avgScore: 75 },
    lastWeek: { exercises: 3, minutes: 20, avgScore: 70 },
  },
  chapterInsights: {
    strengths: [],
    weaknesses: [
      {
        chapterId: "chap-frac",
        chapterTitle: "الكسور (الجزء الأول)",
        subjectId: "s-math",
        subjectName: "الرياضيات (كلاسيكي)",
        attempts: 3,
        avgScore: 40,
      },
    ],
  },
};

describe("ReportContent — actionable weak points (étude 15 lot 12, D-9)", () => {
  it("links each weak chapter — and the weekly advice — into its /chapitre reader", () => {
    const { container } = render(<ReportContent report={report as never} />);
    // Two clickable paths to the same weak chapter: the insight row + the advice CTA.
    expect(container.querySelectorAll('a[href="/chapitre/chap-frac"]')).toHaveLength(2);
  });

  it("does NOT add LRI/PDI isolates around parentheses in Arabic chapter titles", () => {
    const { container } = render(<ReportContent report={report as never} />);
    // chapterTitle "الكسور (الجزء الأول)": standalone brackets around Arabic content
    // must NOT be wrapped in LTR isolates — the browser's bidi-mirror already flips
    // them correctly, and isolation would reverse their visual order (C5/C6/C7 bug).
    const titleEl = container.querySelector(".truncate.text-foreground");
    expect(titleEl?.textContent).toContain("الكسور (الجزء الأول)");
    expect(titleEl?.textContent).not.toContain(LRI);
    expect(titleEl?.textContent).not.toContain(PDI);
  });

  it("does NOT add LRI/PDI isolates around parentheses in Arabic subject names", () => {
    const { container } = render(<ReportContent report={report as never} />);
    // subjectName "الرياضيات (كلاسيكي)" — brackets around Arabic must not be isolated
    const subjectEls = Array.from(container.querySelectorAll(".text-xs.text-muted-foreground"));
    const withParens = subjectEls.find((el) => el.textContent?.includes("الرياضيات (كلاسيكي)"));
    expect(withParens).toBeTruthy();
    expect(withParens?.textContent).not.toContain(LRI);
  });

  it("does NOT add LRI/PDI isolates around parentheses in Arabic subject stat names", () => {
    const { container } = render(<ReportContent report={report as never} />);
    // subjectStats[0].name "الرياضيات (الجبر)" — same bidi rule.
    // Le nom vit désormais dans un enfant du bloc `.w-16`, qui porte aussi le
    // niveau scolaire sous lui (« Mathématiques » apparaissait sinon plusieurs
    // fois à l'identique) — d'où le sélecteur descendant.
    const nameEl = container.querySelector(".w-16 .truncate.text-sm");
    expect(nameEl?.textContent).toContain("الرياضيات (الجبر)");
    expect(nameEl?.textContent).not.toContain(LRI);
    expect(nameEl?.textContent).not.toContain(PDI);
  });

  // Le graphe « Activité 30 jours » a rendu 0 px de haut sur toute sa largeur —
  // le parent voyait une bande vide alors que les données étaient là. Cause :
  // la barre porte une hauteur en POURCENTAGE, et sa colonne n'avait aucune
  // hauteur définie (`flex-1` ne dimensionne que l'axe principal, et
  // `items-end` laisse la hauteur en `auto`), donc le pourcentage se résolvait
  // contre rien. Mesuré dans Chromium : colonne 0 px, barre 0 px.
  // jsdom ne fait pas de layout : ce test épingle l'invariant STRUCTUREL qui
  // rend le pourcentage résoluble — la colonne doit avoir une hauteur définie.
  it("gives each activity bar a column with a DEFINITE height (percent heights need one)", () => {
    const { container } = render(<ReportContent report={report as never} />);
    const bar = container.querySelector<HTMLElement>('[style*="height"].rounded-t');
    expect(bar).toBeTruthy();

    const column = bar?.parentElement;
    expect(column?.className).toContain("h-full");
    // Et la barre reste ancrée en bas de sa colonne.
    expect(column?.className).toContain("items-end");
  });
});

// Étude 11 lot 4 (Q-5) — l'encadré « aide d'El Ostedh ».
//
// L'invariant qui compte n'est pas qu'il s'affiche : c'est qu'il ne s'affiche
// PAS sans le prop. `ReportContent` est rendu par la route authentifiée AUTANT
// que par `_public/suivi.tsx`, qui sert un porteur de code alliance sans lien
// parent vérifié — et ce chemin-là ne doit rien savoir de l'usage du tuteur.
describe("ReportContent — Q-5, l'aide du tuteur", () => {
  const counters = {
    interactions7d: 4,
    interactions30d: 11,
    topThemes: [
      {
        tag: "math.frac.add-denominators",
        labelFr: "Tu additionnes les dénominateurs",
        labelEn: "You add the denominators",
        labelAr: "تجمع المقامات",
        count: 6,
      },
    ],
  };

  it("n'affiche RIEN quand le prop est absent — le chemin public au code alliance", () => {
    const { queryByTestId } = render(<ReportContent report={report as never} />);
    expect(queryByTestId("report-tutor-help")).toBeNull();
  });

  it("n'affiche rien non plus quand l'enfant n'a jamais demandé d'aide", () => {
    // Un encadré « 0 demande » se lirait comme un reproche, alors qu'il ne dit
    // que « nous n'avons pas encore assez joué ».
    const { queryByTestId } = render(
      <ReportContent
        report={report as never}
        tutorCounters={{ interactions7d: 0, interactions30d: 0, topThemes: [] }}
      />,
    );
    expect(queryByTestId("report-tutor-help")).toBeNull();
  });

  it("affiche les compteurs et le LIBELLÉ du thème — jamais le tag brut", () => {
    const { getByTestId } = render(
      <ReportContent report={report as never} tutorCounters={counters} />,
    );
    const box = getByTestId("report-tutor-help");
    expect(box).toBeTruthy();
    // R-A1.2-1 : le tag ne sert que de clé de liste, il n'est jamais AFFICHÉ.
    expect(box.textContent).toContain("Tu additionnes les dénominateurs");
    expect(box.textContent).not.toContain("math.frac.add-denominators");
  });

  it("ne laisse filtrer AUCUN verbatim de conversation (Q-5)", () => {
    // Le composant ne reçoit ni `messages` ni `summary` — la RPC ne les rend
    // pas. Ce test épingle la surface : si quelqu'un élargit un jour le type
    // des compteurs pour y glisser du texte de conversation, il devra passer ici.
    const { getByTestId } = render(
      <ReportContent report={report as never} tutorCounters={counters} />,
    );
    expect(Object.keys(counters)).toEqual(["interactions7d", "interactions30d", "topThemes"]);
    expect(Object.keys(counters.topThemes[0])).not.toContain("content");
    expect(getByTestId("report-tutor-help").textContent).not.toMatch(/messages|summary/i);
  });
});
