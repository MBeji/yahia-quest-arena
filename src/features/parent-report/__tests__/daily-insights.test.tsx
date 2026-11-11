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
import { frParent } from "@/lib/i18n/parent/fr";

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

  it("⭐ la couverture NOMME son verdict, et se tait sans chapitre publié (é34)", () => {
    // « 7/24 chap. » s'est lu, le 2026-09-04, « il a fait 7 chapitres sur 24 ».
    // Le mot manquait. Ici on vérifie le CÂBLAGE (le dictionnaire est factice) ; la
    // copie réelle est contrôlée juste en dessous, sur le catalogue français.
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

    const cells = screen.getAllByTestId("coverage-count");
    // Une seule cellule : la matière sans chapitre publié rend « — », pas « 0 sur 0 ».
    expect(cells).toHaveLength(1);
    expect(cells[0]!.textContent).toBe("parentDaily.coverageMastered");
    // Le POURCENTAGE de couverture a disparu — il divisait un travail par un
    // catalogue qui bouge. (La colonne « Réussite » garde le sien : c'est un score.)
    expect(cells[0]!.closest("td")?.textContent ?? "").not.toMatch(/\d+\s*%/);
  });

  it("⭐ et la copie française dit bien « maîtrisés », avec ses deux substitutions", () => {
    // Le dictionnaire factice ci-dessus prouve le câblage, jamais le mot. Or c'est
    // le MOT qui manquait le 2026-09-04 : « chap. » ne disait pas ce qu'il fallait
    // avoir fait pour qu'un chapitre compte.
    expect(frParent.parentDaily.coverageMastered).toContain("maîtrisés");
    expect(frParent.parentDaily.coverageMastered).toContain("{done}");
    expect(frParent.parentDaily.coverageMastered).toContain("{total}");
  });

  it("⭐ montre la DISTRIBUTION au-dessus du compte — la barre qui empêche le verdict", () => {
    // 24 chapitres : 7 maîtrisés, 5 à ★★★, 4 à ★★, 3 à ★, 5 pas commencés. Sans la
    // barre, « 7 sur 24 » efface les douze chapitres largement entamés.
    render(
      <SubjectsSection
        report={makeReport({
          subjects: [subject({ subjectId: "math-6", chaptersTotal: 24, chaptersCompleted: 7 })],
          subjectStars: [
            {
              subjectId: "math-6",
              chaptersTotal: 24,
              chaptersStarted: 19,
              star1: 19,
              star2: 16,
              star3: 12,
              star4: 7,
              sealStar: 0,
              newChapters: 2,
              newMissions: 3,
            },
          ],
        })}
      />,
    );

    const bar = screen.getByTestId("coverage-bar");
    expect(bar).toBeInTheDocument();
    // Cinq crans EXACTS, dérivés des bornes cumulées : 5 · 3 · 4 · 5 · 7.
    expect(screen.getByTestId("coverage-seg-0")).toHaveStyle({ width: `${(5 / 24) * 100}%` });
    expect(screen.getByTestId("coverage-seg-4")).toHaveStyle({ width: `${(7 / 24) * 100}%` });
    // …et la ligne ✨ dit ce qui est arrivé depuis, plutôt que de laisser le
    // dénominateur grandir en silence.
    expect(screen.getByTestId("coverage-new")).toBeInTheDocument();
  });

  it("se passe de barre quand le rapport est ANTÉRIEUR à l'étude 34", () => {
    // Le suivi parental est lu par des comptes qui n'ont pas rechargé : un rapport
    // sans `subjectStars` doit rendre le compte seul, pas une barre vide.
    render(
      <SubjectsSection
        report={makeReport({
          subjects: [subject({ subjectId: "math-6", chaptersTotal: 24, chaptersCompleted: 7 })],
        })}
      />,
    );
    expect(screen.queryByTestId("coverage-bar")).not.toBeInTheDocument();
    expect(screen.getByTestId("coverage-count")).toBeInTheDocument();
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

// =============================================================================
// CE QUI MANQUE POUR VALIDER UN CHAPITRE — le signalement du 2026-09-04.
//
// « Mon fils a fait tous les exercices de maths 9ème et j'ai 3/20 chap. » Le
// chiffre était juste ; c'est le recours qui manquait. Ce bloc garde la moitié
// ACTIONNABLE : le geste attendu est nommé, et le chapitre à un seul geste
// passe devant.
// =============================================================================
describe("SubjectsSection — les lacunes", () => {
  const gap = (over: Record<string, unknown> = {}) => ({
    subjectId: "math",
    chapterId: "ch-1",
    title: "Les fractions",
    missionsTotal: 6,
    missionsPassed: 4,
    quizGated: true,
    quizSatisfied: true,
    // Étude 34 : l'étoile visée et ce qui l'en sépare — c'est ce chiffre qui TRIE.
    nextStar: 2,
    missingForNext: 2,
    ...over,
  });

  it("nomme le chapitre, son compte de missions et le geste attendu", () => {
    render(
      <SubjectsSection report={makeReport({ subjects: [subject()], chapterGaps: [gap()] })} />,
    );

    expect(screen.getByText("Les fractions")).toBeTruthy();
    // Le compte que l'élève voit dans son hub — les deux écrans disent la même chose.
    expect(screen.getByText("parentDaily.gapsMissionCount")).toBeTruthy();
    expect(screen.getByText("parentDaily.gapsMissions")).toBeTruthy();
  });

  it("dit LE QUIZ quand c'est lui qui bloque, et explique la porte invisible", () => {
    // 6/6 missions et le chapitre ne compte toujours pas : c'est le cas que rien
    // n'expliquait nulle part avant ce lot.
    render(
      <SubjectsSection
        report={makeReport({
          subjects: [subject()],
          chapterGaps: [gap({ missionsPassed: 6, quizSatisfied: false })],
        })}
      />,
    );

    expect(screen.getByText("parentDaily.gapsQuiz")).toBeTruthy();
    expect(screen.getByText("parentDaily.gapsQuizHint")).toBeTruthy();
  });

  it("ne montre PAS l'explication du quiz quand seules des missions manquent", () => {
    // Une note qui s'affiche toujours cesse d'être lue.
    render(
      <SubjectsSection report={makeReport({ subjects: [subject()], chapterGaps: [gap()] })} />,
    );

    expect(screen.queryByText("parentDaily.gapsQuizHint")).toBeNull();
  });

  it("n'affiche aucun bloc quand tout est maîtrisé", () => {
    render(<SubjectsSection report={makeReport({ subjects: [subject()], chapterGaps: [] })} />);

    expect(screen.queryByText("parentDaily.gapsTitle")).toBeNull();
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
