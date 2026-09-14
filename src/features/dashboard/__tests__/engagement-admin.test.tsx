import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import React from "react";

import { EngagementAdmin } from "../components/engagement-admin";
import type { EngagementOverview } from "../engagement.server";
import { PRODUCT_EVENT_CATALOGUE } from "@/shared/lib/product-events";

/**
 * Étude 31 lot 1 — la page « Engagement ».
 *
 * Ce qui est mis à l'épreuve n'est pas la mise en page, ce sont les trois
 * manières dont un tableau de bord de rétention nuit :
 *
 *   * il publie l'engagement SANS sa métrique de garde (R-1) — et on optimise
 *     alors le retour au détriment de l'apprentissage sans jamais le voir ;
 *   * il transforme « pas encore mesurable » en « 0 % » — un zéro faux se décide
 *     dessus, un tiret fait attendre ;
 *   * il affiche une instrumentation qu'il croit branchée.
 */

function overview(over: Partial<EngagementOverview> = {}): EngagementOverview {
  return {
    curr: [
      { week_start: "2026-08-10", active: 10, returned: 4, curr_pct: 40 },
      { week_start: "2026-08-17", active: 12, returned: 3, curr_pct: 25 },
    ],
    cohorts: [
      {
        cohort_week: "2026-08-17",
        size: 6,
        d1_base: 6,
        d1_back: 3,
        d1_pct: 50,
        d7_base: 6,
        d7_back: 2,
        d7_pct: 33.3,
        // Fenêtre non écoulée : rien n'est mesurable, et ça se dit.
        d30_base: 0,
        d30_back: 0,
        d30_pct: null,
      },
    ],
    activity: {
      dau: 3,
      wau: 9,
      mau: 21,
      daily: [
        { day: "2026-09-01", actives: 4 },
        { day: "2026-09-02", actives: 3 },
      ],
    },
    streaks: {
      students: 30,
      b0: 20,
      b1_6: 6,
      b7_29: 3,
      b30_plus: 1,
      weekly_active: 8,
      weekly_active_7plus: 2,
    },
    push: {
      optin_students: 10,
      subscriptions: 12,
      optin_30d: 4,
      optout_30d: 1,
      students_total: 40,
      optout_pct: 9.1,
    },
    learning: {
      active_30d: 21,
      accuracy_avg_pct: 72.5,
      accuracy_p50_pct: 75,
      attempts_30d: 340,
      chapters_completed: 33,
      chapters_per_active: 1.57,
      // Étude 34 R-18 — ce qui entoure le ratio. Le décor est un parc où la barre
      // « maîtrisé » est visiblement haute : 40 chapitres joués, 5 maîtrisés, une
      // médiane à 2. C'est exactement la situation que Q-2 demande de surveiller.
      stars_distribution: { s0: 6, s1: 9, s2: 12, s3: 8, s4: 5 },
      stars_median: 2,
      seals_total: 14,
      seals_per_active: 0.67,
      stars_preserved: 3,
    },
    notes: {
      generated_at: "2026-09-02T18:00:00.000Z",
      week_timezone: "Africa/Tunis",
      streak_clock: "UTC (award_xp)",
      retention_rule: "window",
      activity_rule: "attempts + learning_pulses hors browse",
      current_week: "2026-08-31",
      chapters_source:
        "2026-09-14 (étude 34) : chapters_completed garde sa définition et change de SOURCE — il se lit au grand livre.",
    },
    ...over,
  };
}

describe("EngagementAdmin — l'engagement ne se lit jamais seul", () => {
  it("⭐ publie la métrique de garde (R-1) : précision ET progression", () => {
    render(<EngagementAdmin data={overview()} />);
    const guard = screen.getByTestId("eng-learning");
    expect(guard.textContent).toContain("72,5 %");
    expect(guard.textContent).toContain("1,57");
  });

  it("ne MESURE aucun temps passé (R-1) — aucun indicateur n'est une durée", () => {
    render(<EngagementAdmin data={overview()} />);
    // La consigne ne porte pas sur la prose (qui a le droit de dire pourquoi on
    // ne mesure pas le temps) mais sur les CHIFFRES publiés : aucun d'eux n'est
    // une durée, sinon il finirait par devenir un objectif.
    for (const id of ["eng-learning", "eng-activity", "eng-streaks", "eng-push"]) {
      const block = (screen.getByTestId(id).textContent ?? "").toLowerCase();
      expect(block).not.toContain("temps");
      expect(block).not.toContain("minute");
      expect(block).not.toContain("heure");
    }
  });

  it("rend la CURR de la dernière semaine mesurable, avec son effectif", () => {
    render(<EngagementAdmin data={overview()} />);
    expect(screen.getByTestId("eng-curr-latest").textContent).toContain("25 %");
    expect(screen.getByTestId("eng-curr").textContent).toContain("40 %");
  });

  it("dit « aucune semaine mesurable » plutôt que d'afficher 0 % sur un parc vide", () => {
    render(<EngagementAdmin data={overview({ curr: [] })} />);
    expect(screen.getByTestId("eng-curr-empty")).toBeInTheDocument();
    expect(screen.queryByTestId("eng-curr")).not.toBeInTheDocument();
  });

  it("⭐ une fenêtre de cohorte non écoulée s'affiche « — », jamais 0 %", () => {
    render(<EngagementAdmin data={overview()} />);
    const row = screen.getByTestId("eng-cohorts").textContent ?? "";
    expect(row).toContain("50 %"); // D1 mesuré
    expect(row).toContain("—"); // D30 pas encore mesurable
  });

  it("alerte quand le garde-fou R-4 d'opt-out est franchi (RISK-2)", () => {
    render(<EngagementAdmin data={overview()} />);
    expect(screen.getByTestId("eng-optout-warning")).toBeInTheDocument();
  });

  it("reste muette sur l'opt-out tant que le garde-fou tient", () => {
    const data = overview();
    render(<EngagementAdmin data={{ ...data, push: { ...data.push, optout_pct: 2 } }} />);
    expect(screen.queryByTestId("eng-optout-warning")).not.toBeInTheDocument();
  });

  it("montre KPI-C (part des actifs hebdo à 7 jours de série)", () => {
    render(<EngagementAdmin data={overview()} />);
    expect(screen.getByTestId("eng-kpi-c").textContent).toContain("25 %");
  });

  // =========================================================================
  // Étude 34 R-18 — ce qui entoure KPI-E, et la note qui date le changement.
  // =========================================================================
  it("⭐ publie la médiane de l'étoile, les sceaux et les étoiles préservées", () => {
    // Les trois mesures existent pour une raison chiffrée : 56 % des missions du
    // corpus sont ⭐⭐⭐/⭐⭐⭐⭐, donc « 1,57 chapitre par actif » ne dit PAS que le
    // parc travaille peu. Sans elles, ce ratio se lit comme un échec.
    render(<EngagementAdmin data={overview()} />);
    const tiles = screen.getByTestId("eng-stars").textContent ?? "";
    expect(tiles).toContain("médiane de l'étoile");
    expect(tiles).toContain("2");
    expect(tiles).toContain("sceaux / actif");
    expect(tiles).toContain("étoiles préservées");
    expect(tiles).toContain("3");
  });

  it("montre la DISTRIBUTION, sans laquelle un parc à ★★★☆ ressemble à un parc à zéro", () => {
    render(<EngagementAdmin data={overview()} />);
    const dist = screen.getByTestId("eng-stars-dist").textContent ?? "";
    // Les cinq crans sont comptés, celui de zéro compris — un chapitre joué sans
    // étoile n'est pas un chapitre absent, et la barre doit le dire.
    expect(dist).toContain("aucune 6");
    expect(dist).toContain("⭐⭐⭐⭐ 5");
  });

  it("⭐ DATE le changement de source de KPI-E — sans quoi la série serait rompue en silence", () => {
    // R-18 : « la console porte une note datée disant ce qui a changé sous le
    // chiffre ». Une console qui change de source sans le dire fabrique une
    // rupture que personne ne saura dater six mois plus tard.
    render(<EngagementAdmin data={overview()} />);
    const note = screen.getByTestId("eng-kpie-note").textContent ?? "";
    expect(note).toContain("2026-09-14");
    expect(note).toContain("garde sa définition");
  });

  it("répond quand même sur un rapport ANTÉRIEUR à l'étude 34", () => {
    // Le déploiement n'est pas atomique : la console peut être lue entre la mise
    // en ligne du code et l'application de la migration. Elle doit rendre la page,
    // pas une erreur de lecture — les champs manquants valent zéro, et la note
    // absente ne s'affiche pas plutôt que de s'afficher vide.
    const data = overview();
    const legacy = {
      ...data,
      learning: { ...data.learning, stars_preserved: 0, stars_median: null },
      notes: { ...data.notes, chapters_source: "" },
    };
    render(<EngagementAdmin data={legacy} />);
    expect(screen.getByTestId("eng-stars").textContent).toContain("—");
    expect(screen.queryByTestId("eng-kpie-note")).not.toBeInTheDocument();
  });

  it("⭐ liste TOUTE l'instrumentation, et n'en cache aucune (§3.7)", () => {
    render(<EngagementAdmin data={overview()} />);
    const events = screen.getByTestId("eng-events").textContent ?? "";
    for (const entry of PRODUCT_EVENT_CATALOGUE) {
      expect(events, `${entry.name} absent de la carte`).toContain(entry.name);
    }
    // Depuis le lot 5, les douze événements sont câblés : plus aucune mention
    // « pas encore émis ». Le MARQUEUR, lui, reste tenu par
    // `product-events.test.ts`, qui échoue si un événement déclaré non câblé est
    // émis quelque part — ou l'inverse.
    expect(events).not.toContain("pas encore émis");
  });
});
