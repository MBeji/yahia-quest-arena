import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

import { ReturnBlock } from "../components/return-block";
import {
  ratePct,
  readReturnCohort,
  returnOverviewSchema,
  sumReturnCohorts,
  type ReturnOverview,
} from "../return-overview";

/**
 * Étude 40 lot 0 — le bloc « Le retour » de `/admin/engagement`.
 *
 * Critère du lot (US-1) : huit cohortes, avec « mesurable » distingué de « perdu ». Ce qui est
 * mis à l'épreuve, ce sont les façons dont ce bloc peut mentir :
 *   * compter « perdu » un compte dont la première semaine n'est pas finie ;
 *   * afficher 0 % là où rien n'est mesurable ;
 *   * publier « jamais joué » sans son dénominateur ;
 *   * emporter la console entière dans sa propre panne.
 */

/** Huit lundis ; les deux derniers ont une fenêtre non (ou partiellement) écoulée. */
function overview(over: Partial<ReturnOverview> = {}): ReturnOverview {
  const empty = { signups: 0, confirmed: 0, played_7d: 0, played_7d_base: 0, back_7d: 0 };
  return {
    cohorts: [
      { week: "2026-09-21", ...empty, back_7d_base: 0 },
      { week: "2026-09-28", ...empty, back_7d_base: 0 },
      {
        week: "2026-10-05",
        signups: 5,
        confirmed: 4,
        played_7d: 3,
        played_7d_base: 5,
        back_7d: 2,
        back_7d_base: 5,
      },
      { week: "2026-10-12", ...empty, back_7d_base: 0 },
      {
        week: "2026-10-19",
        signups: 8,
        confirmed: 8,
        played_7d: 3,
        played_7d_base: 8,
        back_7d: 1,
        back_7d_base: 8,
      },
      { week: "2026-10-26", ...empty, back_7d_base: 0 },
      // À cheval : quatre inscrits, un seul dont les sept jours sont écoulés.
      {
        week: "2026-11-02",
        signups: 4,
        confirmed: 3,
        played_7d: 0,
        played_7d_base: 1,
        back_7d: 0,
        back_7d_base: 1,
      },
      // Semaine en cours : rien n'est mesurable.
      {
        week: "2026-11-09",
        signups: 3,
        confirmed: 3,
        played_7d: 0,
        played_7d_base: 0,
        back_7d: 0,
        back_7d_base: 0,
      },
    ],
    students: 60,
    never_played: 36,
    push: {
      students_active_30d: 8,
      students_reachable: 0,
      parents_linked: 2,
      parents_reachable: 0,
    },
    generated_at: "2026-11-12T18:00:00.000Z",
    ...over,
  };
}

const rows = (): string[] =>
  [...screen.getByTestId("eng-return-cohorts").querySelectorAll("tbody tr")].map(
    (row) => row.textContent ?? "",
  );

describe("ReturnBlock — les cohortes", () => {
  it("⭐ affiche huit cohortes — une semaine sans inscription reste une ligne", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    expect(rows()).toHaveLength(8);
  });

  it("⭐ distingue « mesurable » de « perdu » : la cohorte écoulée compte 5 mesurables, 2 perdus", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    const cells = [
      ...(screen
        .getByTestId("eng-return-cohorts")
        .querySelectorAll("tbody tr")[2]
        ?.querySelectorAll("td") ?? []),
    ].map((cell) => cell.textContent);
    // Cohorte · Inscrits · Confirmés · Mesurables · En attente · 1ʳᵉ quête · Revenus · Perdus
    expect(cells).toEqual(["05/10", "5", "4", "5", "0", "3 (60 %)", "2 (40 %)", "2"]);
  });

  it("⭐ une fenêtre NON écoulée s'affiche « — » : ni 0 %, ni « 3 perdus »", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    const cells = [
      ...(screen
        .getByTestId("eng-return-cohorts")
        .querySelectorAll("tbody tr")[7]
        ?.querySelectorAll("td") ?? []),
    ].map((cell) => cell.textContent);
    expect(cells).toEqual(["09/11", "3", "3", "0", "3", "—", "—", "—"]);
  });

  it("⭐ une cohorte à cheval ne compte perdu que le compte mesurable — les trois autres attendent", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    const cells = [
      ...(screen
        .getByTestId("eng-return-cohorts")
        .querySelectorAll("tbody tr")[6]
        ?.querySelectorAll("td") ?? []),
    ].map((cell) => cell.textContent);
    expect(cells?.slice(3)).toEqual(["1", "3", "0 (0 %)", "0 (0 %)", "1"]);
  });

  it("publie la première quête cumulée avec sa base — jamais un pourcentage seul", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    expect(screen.getByTestId("eng-return-first-quest").textContent).toBe("6/14");
    expect(screen.getByTestId("eng-return").textContent).toContain("6 compte(s) en attente");
  });

  it("dit qu'il n'y a rien à mesurer plutôt que d'afficher un tableau de zéros", () => {
    const none = overview().cohorts.map((c) => ({
      ...c,
      signups: 0,
      confirmed: 0,
      played_7d: 0,
      played_7d_base: 0,
      back_7d: 0,
      back_7d_base: 0,
    }));
    render(<ReturnBlock data={overview({ cohorts: none })} isPending={false} isError={false} />);
    expect(screen.getByTestId("eng-return-empty")).toBeInTheDocument();
    expect(screen.queryByTestId("eng-return-cohorts")).not.toBeInTheDocument();
    // La portée et les jamais-joué restent lisibles : ils ne dépendent pas des cohortes.
    expect(screen.getByTestId("eng-return-reach")).toBeInTheDocument();
  });
});

describe("ReturnBlock — portée du push et jamais-joué", () => {
  it("⭐ « jamais joué » voyage avec son dénominateur", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    expect(screen.getByTestId("eng-return-never").textContent).toContain("36/60");
  });

  it("rend la portée du push, élèves et parents, chacun avec sa population", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    const reach = screen.getByTestId("eng-return-reach").textContent ?? "";
    expect(reach).toContain("8 actif(s) sur 30 jours");
    expect(reach).toContain("2 parent(s) lié(s)");
  });

  it("dit où se lit le retour des visiteurs SANS compte — ce bloc ne le couvre pas", () => {
    render(<ReturnBlock data={overview()} isPending={false} isError={false} />);
    const text = screen.getByTestId("eng-return").textContent ?? "";
    expect(text).toContain("visit_first");
    expect(text).toContain("visit_returned");
  });
});

describe("ReturnBlock — ses propres états", () => {
  it("⭐ en erreur, il le dit SEUL : aucun chiffre, aucun zéro inventé", () => {
    render(<ReturnBlock data={undefined} isPending={false} isError />);
    expect(screen.getByTestId("eng-return-error")).toBeInTheDocument();
    expect(screen.queryByTestId("eng-return-reach")).not.toBeInTheDocument();
  });

  it("en chargement, il attend", () => {
    render(<ReturnBlock data={undefined} isPending isError={false} />);
    expect(screen.getByTestId("eng-return-loading")).toBeInTheDocument();
  });
});

describe("la lecture d'une cohorte", () => {
  it("⭐ un taux sans base est `null`, jamais 0", () => {
    expect(ratePct(0, 0)).toBeNull();
    expect(ratePct(0, 4)).toBe(0);
    expect(ratePct(1, 3)).toBe(33.3);
  });

  it("« en attente » = inscrits moins mesurables ; « perdus » = mesurables moins première quête", () => {
    const cohort = overview().cohorts[6];
    if (!cohort) throw new Error("décor");
    expect(readReturnCohort(cohort)).toEqual({
      measurable: 1,
      pending: 3,
      lost: 1,
      playedPct: 0,
      backPct: 0,
    });
  });

  it("le cumul additionne bases et numérateurs séparément", () => {
    expect(sumReturnCohorts(overview().cohorts)).toEqual({
      signups: 20,
      played: 6,
      playedBase: 14,
      back: 3,
      backBase: 14,
      pending: 6,
    });
  });
});

describe("le schéma de la lecture", () => {
  it("accepte la forme rendue par `admin_return_overview`", () => {
    expect(returnOverviewSchema.safeParse(overview()).success).toBe(true);
  });

  it("⭐ refuse une forme incomplète : une lecture partielle est une panne, pas un bloc à moitié", () => {
    const { push: _push, ...withoutPush } = overview();
    expect(returnOverviewSchema.safeParse(withoutPush).success).toBe(false);
    expect(returnOverviewSchema.safeParse({}).success).toBe(false);
  });
});
