import { describe, expect, it } from "vitest";

import {
  escalationKey,
  escalationLevel,
  escalationStep,
  escalationStepFromAction,
  nextEscalationStep,
  recommendedEscalation,
  TUTOR_ESCALATION_STEPS,
  TUTOR_MAX_ESCALATION,
  type TutorUnderstandingSignals,
} from "../escalation";

// R-8, lot 4 : l'escalade est ORDONNÉE et sa matrice a huit cases. Les huit sont
// écrites ici une par une plutôt que dérivées d'une boucle : une boucle qui
// recalcule la règle pour la vérifier ne teste rien du tout — elle recopie le
// bug. Ce fichier est aussi le MIROIR du `CASE` de `tutor_understanding_signal()`
// (migration 20260823140000 §4) ; si l'un bouge sans l'autre, c'est ici que ça
// doit rougir.

const signals = (a: boolean, b: boolean, c: boolean): TutorUnderstandingSignals => ({
  signalA: a,
  signalB: b,
  signalC: c,
});

describe("l'ordre des marches est le contrat", () => {
  it("énumère les cinq marches de R-8, dans l'ordre", () => {
    // L'index EST le `escalation_level` stocké en base (CHECK 0..4). Réordonner
    // ce tableau réécrirait silencieusement l'historique de tous les fils.
    expect([...TUTOR_ESCALATION_STEPS]).toEqual([
      "reteach",
      "lesson",
      "prerequisite",
      "plan",
      "parentDigest",
    ]);
  });

  it("plafonne au niveau 4, comme le CHECK de tutor_threads", () => {
    expect(TUTOR_MAX_ESCALATION).toBe(4);
  });

  it("associe chaque niveau à sa marche", () => {
    expect(escalationStep(0)).toBe("reteach");
    expect(escalationStep(1)).toBe("lesson");
    expect(escalationStep(2)).toBe("prerequisite");
    expect(escalationStep(3)).toBe("plan");
    expect(escalationStep(4)).toBe("parentDigest");
  });

  it("borne au lieu de rendre undefined hors de 0..4", () => {
    // Un niveau hors bornes vient forcément d'une donnée abîmée. Rendre
    // `undefined` ferait planter un écran ; retomber sur la marche 0 ne fait que
    // re-expliquer, ce qui n'a jamais fait de mal à personne.
    expect(escalationStep(-3)).toBe("reteach");
    expect(escalationStep(99)).toBe("parentDigest");
    expect(escalationStep(Number.NaN)).toBe("reteach");
    expect(escalationStep(2.7)).toBe("prerequisite");
  });

  it("avance d'une marche, et se répète au sommet", () => {
    expect(nextEscalationStep(0)).toBe("lesson");
    expect(nextEscalationStep(1)).toBe("prerequisite");
    expect(nextEscalationStep(2)).toBe("plan");
    expect(nextEscalationStep(3)).toBe("parentDigest");
    // Au niveau 4 on RE-mentionne au parent : le SQL applique le même
    // `LEAST(level + 1, 4)`, il ne déborde pas et ne lève pas.
    expect(nextEscalationStep(4)).toBe("parentDigest");
  });

  it("ne rend jamais une phrase, seulement une clé i18n", () => {
    // Le contrat de `coaching.ts`, repris tel quel : aucune microcopy ici.
    for (const step of TUTOR_ESCALATION_STEPS) {
      expect(escalationKey(step)).toBe(step);
    }
  });
});

describe("la matrice R-8 — les huit cases de (a, b, c)", () => {
  it("aucun signal : rien à escalader", () => {
    expect(escalationLevel(signals(false, false, false))).toBe(0);
  });

  it("(a) seul : l'explication ne prend pas → montrer le cours", () => {
    expect(escalationLevel(signals(true, false, false))).toBe(1);
  });

  it("(b) seul : les registres sont épuisés → chercher le prérequis", () => {
    expect(escalationLevel(signals(false, true, false))).toBe(2);
  });

  it("(c) seul : ça dure depuis une semaine → inscrire au plan", () => {
    expect(escalationLevel(signals(false, false, true))).toBe(3);
  });

  it("(a) + (b) : le signal le plus PROFOND l'emporte", () => {
    // Et non le plus récent : re-montrer le cours à un élève dont les trois
    // registres sont déjà épuisés, c'est lui resservir ce qui a échoué.
    expect(escalationLevel(signals(true, true, false))).toBe(2);
  });

  it("(a) + (c) : (c) l'emporte", () => {
    expect(escalationLevel(signals(true, false, true))).toBe(3);
  });

  it("(b) + (c) : (c) l'emporte", () => {
    expect(escalationLevel(signals(false, true, true))).toBe(3);
  });

  it("les trois : et SEULEMENT les trois font monter jusqu'au parent", () => {
    // Prévenir un parent sur un signal isolé, c'est lui apprendre à ignorer les
    // alertes. La dernière marche se mérite par la conjonction.
    expect(escalationLevel(signals(true, true, true))).toBe(4);
  });

  it("aucune paire ne saute jusqu'au digest parent", () => {
    expect(escalationLevel(signals(true, true, false))).toBeLessThan(4);
    expect(escalationLevel(signals(true, false, true))).toBeLessThan(4);
    expect(escalationLevel(signals(false, true, true))).toBeLessThan(4);
  });
});

describe("le pont entre le vocabulaire SQL et les clés i18n", () => {
  it("traduit chaque action de escalate_tutor_thread() en marche", () => {
    // Les quatre actions que la RPC peut rendre. `parent_digest` est la seule
    // qui change de casse — et c'est exactement celle qu'on ne peut pas se
    // permettre de rater.
    expect(escalationStepFromAction("lesson")).toBe("lesson");
    expect(escalationStepFromAction("prerequisite")).toBe("prerequisite");
    expect(escalationStepFromAction("plan")).toBe("plan");
    expect(escalationStepFromAction("parent_digest")).toBe("parentDigest");
  });

  it("retombe sur la marche la plus DOUCE pour une action inconnue", () => {
    // Se tromper vers « je te réexplique » est sans conséquence ; se tromper
    // vers « j'en parle à tes parents » ne l'est pas. Le défaut penche du bon côté.
    expect(escalationStepFromAction("something_else")).toBe("reteach");
    expect(escalationStepFromAction(null)).toBe("reteach");
    expect(escalationStepFromAction(undefined)).toBe("reteach");
    expect(escalationStepFromAction("")).toBe("reteach");
  });

  it("ne rend que des marches connues du catalogue i18n", () => {
    for (const action of ["lesson", "prerequisite", "plan", "parent_digest", "??"]) {
      expect(TUTOR_ESCALATION_STEPS).toContain(escalationStepFromAction(action));
    }
  });
});

describe("recommendedEscalation", () => {
  it("rend la marche du niveau recommandé, pas la suivante", () => {
    // `escalationLevel` a déjà dit OÙ reprendre ; y ajouter un cran ferait
    // sauter une marche à chaque diagnostic.
    expect(recommendedEscalation(signals(false, true, false))).toEqual({
      level: 2,
      step: "prerequisite",
    });
  });

  it("reste à la marche 0 quand aucun signal n'est levé", () => {
    expect(recommendedEscalation(signals(false, false, false))).toEqual({
      level: 0,
      step: "reteach",
    });
  });
});
