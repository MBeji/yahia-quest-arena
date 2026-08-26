import { render, screen } from "@testing-library/react";
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

// Dictionnaire factice : `t.<section>.<clé>` rend une chaîne stable qui garde
// `.replace`/`.replaceAll`, ce qui suffit à vérifier le CÂBLAGE sans dépendre
// des libellés réels (qui, eux, vivent dans fr/en/ar).
const t = new Proxy(
  {},
  { get: (_o, k1) => new Proxy({}, { get: (_o2, k2) => `${String(k1)}.${String(k2)}` }) },
);
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ t, locale: "fr" }), useT: () => t }));
// La surface parent lit son catalogue par `useParentT` (chunk `i18n-parent`) :
// le même dictionnaire factice doit couvrir les deux portes d'entrée.
vi.mock("@/lib/i18n/parent", () => ({ useParentT: () => t }));

import { AlertsSection, IndexCard, SubjectsSection } from "../components/daily-insights";
import { alertMessage } from "../components/alert-message";
import { makeReport, makeTotals } from "./daily-fixtures";
import { computeEngagement } from "../insights/engagement";
import type { ParentAlert } from "../insights/alerts";
import type { ParentTranslations } from "@/lib/i18n/parent.types";

const subject = (over: Record<string, unknown> = {}) => ({
  subjectId: "math",
  name: "Mathématiques",
  colorToken: null,
  gradeName: "6ème",
  minutes: 135,
  lessons: 3,
  exercises: 8,
  previousExercises: 6,
  avgScore: 84,
  scoreDelta: 6,
  chaptersTotal: 0,
  chaptersCompleted: 0,
  ...over,
});

describe("SubjectsSection", () => {
  it("rend une ligne par matière avec temps, réussite et progression", () => {
    render(
      <SubjectsSection
        report={makeReport({
          subjects: [subject(), subject({ subjectId: "fr", name: "Français", avgScore: 48 })],
        })}
      />,
    );

    // Le nom apparaît dans le tableau ET dans les listes de lecture (fortes,
    // fragiles…) : on vérifie la présence, pas l'unicité.
    expect(screen.getAllByText("Mathématiques").length).toBeGreaterThan(0);
    expect(screen.getAllByText("Français").length).toBeGreaterThan(0);
    expect(screen.getAllByText("2 h 15")).toHaveLength(2);
    expect(screen.getByText("84%")).toBeTruthy();
    expect(screen.getByText("48%")).toBeTruthy();
  });

  // Le défaut signalé en production : quatre lignes « Mathématiques » identiques,
  // parce qu'une matière appartient à un NIVEAU et que le niveau n'était pas rendu.
  it("distingue deux matières homonymes par leur niveau", () => {
    const { container } = render(
      <SubjectsSection
        report={makeReport({
          subjects: [
            subject({ subjectId: "math-6", gradeName: "6ème année" }),
            subject({ subjectId: "math-9", gradeName: "9ème année", avgScore: 41 }),
          ],
        })}
      />,
    );

    // Deux lignes du TABLEAU (le nom réapparaît aussi dans les listes de lecture
    // « matières fortes / fragiles » — on ne compte donc pas globalement).
    const firstCells = Array.from(container.querySelectorAll("tbody tr")).map(
      (row) => row.querySelector("td")?.textContent ?? "",
    );
    expect(firstCells).toHaveLength(2);
    // Chaque ligne porte son nom ET son niveau : c'est ce qui les sépare.
    expect(firstCells[0]).toContain("Mathématiques");
    expect(firstCells[0]).toContain("6ème année");
    expect(firstCells[1]).toContain("9ème année");
  });

  it("rend la couverture du programme en fraction, et un tiret sans chapitre publié", () => {
    render(
      <SubjectsSection
        report={makeReport({
          subjects: [
            subject({ subjectId: "math-6", chaptersTotal: 24, chaptersCompleted: 7 }),
            subject({ subjectId: "libre", name: "Culture G", chaptersTotal: 0 }),
          ],
        })}
      />,
    );

    expect(screen.getByText("7/24")).toBeTruthy();
    expect(screen.getByText("29%")).toBeTruthy();
    // Aucun chapitre publié : la fraction n'existe pas, elle ne vaut pas 0 %.
    expect(screen.queryByText("0%")).toBeNull();
  });

  it("affiche un tiret, jamais un verdict, quand la matière n'a pas assez de tentatives", () => {
    render(
      <SubjectsSection
        report={makeReport({ subjects: [subject({ exercises: 1, avgScore: 0, minutes: 0 })] })}
      />,
    );
    // Réussite ET niveau tombent tous deux sur « — ».
    expect(screen.getAllByText("—").length).toBeGreaterThanOrEqual(2);
  });
});

describe("AlertsSection", () => {
  it("rend un lien vers le cours quand l'alerte désigne un chapitre", () => {
    const alerts: ParentAlert[] = [
      {
        key: "chapterStruggle",
        tone: "warning",
        severity: 80,
        params: { chapterTitle: "Les fractions", avgScore: 58 },
        chapterId: "chap-1",
      },
    ];

    render(<AlertsSection alerts={alerts} />);

    const link = screen.getByRole("link");
    expect(link.getAttribute("href")).toBe("/chapitre/chap-1");
  });

  it("dit explicitement qu'il n'y a rien à signaler", () => {
    render(<AlertsSection alerts={[]} />);
    expect(screen.getByText("parentDaily.alertsEmpty")).toBeTruthy();
  });
});

describe("alertMessage", () => {
  it("remplit les paramètres et met les durées en forme lisible", () => {
    const template = "{subjectName} : {minutes} · {chapterTitle} à {chapterScore} %";
    const dictionary = {
      parentDaily: { alertTimeWithoutProgress: template },
    } as unknown as ParentTranslations;

    const message = alertMessage(
      {
        key: "timeWithoutProgress",
        tone: "warning",
        severity: 85,
        params: {
          subjectName: "Mathématiques",
          minutes: 135,
          chapterTitle: "Les fractions",
          chapterScore: 58,
        },
      },
      dictionary,
    );

    expect(message).toBe("Mathématiques : 2 h 15 · Les fractions à 58 %");
  });
});

describe("IndexCard", () => {
  it("annonce le manque de données au lieu d'afficher un score de 0", () => {
    render(
      <IndexCard
        title="Engagement"
        subtitle="…"
        icon={null}
        result={computeEngagement(
          makeReport({
            range: {
              from: "2026-08-09",
              to: "2026-08-15",
              days: 7,
              timezone: "Africa/Tunis",
              measuredSince: null,
            },
            // Aucun facteur mesurable : ni temps, ni cours, ni session.
            totals: makeTotals(),
            previous: makeTotals(),
          }),
        )}
      />,
    );

    // La régularité et le volume restent mesurables (0 sur 5 jours attendus),
    // donc l'indice existe : ce qu'on vérifie, c'est qu'il s'affiche bas et
    // explicité, sans prétendre à une donnée absente.
    expect(screen.getByText("parentDaily.indexHolders")).toBeTruthy();
  });
});
