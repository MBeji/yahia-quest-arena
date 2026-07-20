/**
 * Bannière de rentrée — étude 22, R-4.
 *
 * Deux comportements portent tout : l'action proposée (promotion directe OU choix de section —
 * jamais les deux), et le refus, qui doit valoir pour LA SAISON et pas au-delà. Une bannière
 * qui ressurgit après un « je reste » harcèle ; une bannière définitivement muette prive
 * l'élève de sa rentrée suivante.
 */
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    [k: string]: unknown;
  }) => React.createElement("a", { href: to, ...(rest as object) }, children),
}));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    dashboard: {
      backToSchool: {
        title: "C'est la rentrée !",
        body: "Tu prépares toujours la {current} ?",
        cta: "Passer en {next}",
        ctaSection: "Choisir ma section de {next}",
        stay: "Je reste en {current}",
      },
    },
  }),
}));

import { BackToSchoolBanner } from "../components/back-to-school-banner";

const direct = { gradeName: "8ème année", parcoursId: "ecole-8eme", drilldownYear: null };
const section = { gradeName: "2ème année secondaire", parcoursId: null, drilldownYear: "2eme" };

describe("BackToSchoolBanner", () => {
  beforeEach(() => localStorage.clear());

  it("propose la promotion en un clic quand la classe suivante est directe", () => {
    render(<BackToSchoolBanner suggestion={direct} currentClassName="7ème année" />);
    expect(screen.getByTestId("back-to-school-cta")).toHaveAttribute("href", "/niveau/$parcoursId");
    expect(screen.getByText("Passer en 8ème année")).toBeInTheDocument();
  });

  it("emmène choisir sa section — et surtout pas vers un parcours", () => {
    // Depuis l'ouverture du lycée, 2ème/3ème/bac se déclinent : la bannière ne peut pas
    // choisir une section à la place de l'élève, elle l'emmène sur la page de l'année.
    render(<BackToSchoolBanner suggestion={section} currentClassName="1ère année secondaire" />);
    expect(screen.getByTestId("back-to-school-cta")).toHaveAttribute(
      "href",
      "/programme/lycee/$annee",
    );
    expect(screen.getByText("Choisir ma section de 2ème année secondaire")).toBeInTheDocument();
  });

  it("interpelle l'élève avec le nom de SA classe", () => {
    render(<BackToSchoolBanner suggestion={direct} currentClassName="7ème année" />);
    expect(screen.getByText("Tu prépares toujours la 7ème année ?")).toBeInTheDocument();
    expect(screen.getByText("Je reste en 7ème année")).toBeInTheDocument();
  });

  it("disparaît sur « je reste », et le refus est mémorisé", () => {
    const { unmount } = render(
      <BackToSchoolBanner suggestion={direct} currentClassName="7ème année" />,
    );
    fireEvent.click(screen.getByTestId("back-to-school-stay"));
    expect(screen.queryByTestId("back-to-school-banner")).not.toBeInTheDocument();

    unmount();
    render(<BackToSchoolBanner suggestion={direct} currentClassName="7ème année" />);
    expect(screen.queryByTestId("back-to-school-banner")).not.toBeInTheDocument();
  });

  it("un refus d'une saison ne muselle pas la rentrée suivante", () => {
    // LE cas qui justifie que la clé porte l'année scolaire. Un refus stocké sous une autre
    // saison ne doit rien masquer.
    localStorage.setItem("na9ra.backToSchoolDismissed.2024-2025", "1");
    render(<BackToSchoolBanner suggestion={direct} currentClassName="7ème année" />);
    expect(screen.getByTestId("back-to-school-banner")).toBeInTheDocument();
  });
});
