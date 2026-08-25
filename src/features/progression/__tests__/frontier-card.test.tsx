/**
 * « Prêt à apprendre » — la frontière (étude 30, lot 3 · §3.4).
 *
 * Ce que ces tests protègent :
 *
 *  1. **D-1 encore** — ni `p_known` ni `entry_odds` n'atteignent le DOM. Ils voyagent
 *     jusqu'ici pour que le SERVEUR ait pu trier et choisir ; les afficher retournerait la
 *     proposition en score.
 *  2. **Le pari du fan-out est montré** — « ouvre N suites » est la RAISON de la proposition,
 *     et R-14 dit qu'une action se donne toujours avec sa raison. Un pari qu'on montre est un
 *     pari qu'on peut contester.
 *  3. **Pas de CTA qui mène à un refus** (é22 R-30) — sans exercice d'entrée, pas de bouton.
 *  4. **R-6** — zéro ligne ⇒ le panneau ne s'affiche pas du tout, et l'écran est exactement
 *     celui d'aujourd'hui. Ce `null` EST la neutralité du non-taggé.
 */
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

import type { LearningFrontierRow } from "@/shared/types/competency";

const navigate = vi.fn();
vi.mock("@tanstack/react-router", () => ({
  useNavigate: () => navigate,
}));

let mockLocale: "fr" | "en" | "ar" = "fr";
vi.mock("@/lib/i18n", async () => {
  const { fr } = await import("@/lib/i18n/fr");
  const { ar } = await import("@/lib/i18n/ar");
  return {
    useI18n: () => ({
      t: mockLocale === "ar" ? ar : fr,
      locale: mockLocale,
      dir: mockLocale === "ar" ? "rtl" : "ltr",
      setLocale: () => {},
    }),
  };
});

import { FrontierCard } from "../components/frontier-card";

function row(overrides: Partial<LearningFrontierRow> = {}): LearningFrontierRow {
  return {
    competency_id: "c-1",
    slug: "math.prop.quatrieme",
    label_fr: "Quatrième proportionnelle",
    label_en: "Fourth proportional",
    label_ar: "الرابع المتناسب",
    state: "en-cours",
    p_known: 0.6421,
    unlocks: 3,
    entry_exercise_id: "ex-1",
    entry_subject_id: "math-9",
    entry_odds: 0.7133,
    ...overrides,
  };
}

beforeEach(() => {
  mockLocale = "fr";
  navigate.mockClear();
});

describe("FrontierCard — « prêt à apprendre »", () => {
  it("D-1 : ne rend ni la croyance ni la probabilité de réussite", () => {
    const { container } = render(<FrontierCard rows={[row()]} />);
    const text = container.textContent ?? "";
    for (const forbidden of ["0.6421", "0,6421", "0.64", "64 %", "0.7133", "0,7133", "71 %"]) {
      expect(text).not.toContain(forbidden);
    }
    expect(text).not.toMatch(/\d+\s*%/);
  });

  it("R-14 : montre la RAISON de la proposition — combien de portes elle ouvre", () => {
    render(<FrontierCard rows={[row({ unlocks: 3 })]} />);
    expect(screen.getByText(/ouvre 3 suites/)).toBeInTheDocument();
  });

  it("une compétence qui n'ouvre rien n'est pas présentée comme un échec", () => {
    // « ouvre 0 suites » serait une phrase absurde et vaguement décourageante pour une
    // compétence terminale, qui n'a rien de moins légitime à travailler.
    render(<FrontierCard rows={[row({ unlocks: 0 })]} />);
    expect(screen.getByText("à ton rythme")).toBeInTheDocument();
    expect(screen.queryByText(/ouvre 0/)).not.toBeInTheDocument();
  });

  it("le bouton mène à l'exercice d'entrée choisi par le sélecteur ZPD", async () => {
    const user = userEvent.setup();
    render(<FrontierCard rows={[row({ entry_exercise_id: "ex-42" })]} />);
    await user.click(screen.getByRole("button", { name: "Commencer" }));
    expect(navigate).toHaveBeenCalledWith({
      to: "/quest/$exerciseId",
      params: { exerciseId: "ex-42" },
    });
  });

  it("é22 R-30 : sans exercice d'entrée, aucun bouton — un CTA qui mène à un refus est pire", () => {
    render(<FrontierCard rows={[row({ entry_exercise_id: null, entry_subject_id: null })]} />);
    expect(screen.getByText("Quatrième proportionnelle")).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Commencer" })).not.toBeInTheDocument();
  });

  it("respecte l'ordre du serveur — le tri par fan-out est une décision SQL, pas une décision d'UI", () => {
    const { container } = render(
      <FrontierCard
        rows={[
          row({ competency_id: "a", slug: "a", label_fr: "Sept portes", unlocks: 7 }),
          row({ competency_id: "b", slug: "b", label_fr: "Une porte", unlocks: 1 }),
        ]}
      />,
    );
    const items = [...container.querySelectorAll("li")].map((li) => li.textContent ?? "");
    expect(items[0]).toContain("Sept portes");
    expect(items[1]).toContain("Une porte");
  });

  it("met les libellés dans la langue de l'interface", () => {
    mockLocale = "ar";
    render(<FrontierCard rows={[row()]} />);
    expect(screen.getByText("الرابع المتناسب")).toBeInTheDocument();
  });

  it("R-6 : sans frontière, le panneau ne s'affiche pas du tout", () => {
    const { container } = render(<FrontierCard rows={[]} />);
    expect(container).toBeEmptyDOMElement();
  });
});
