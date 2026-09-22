// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  CIBLES,
  confronterAuxCibles,
  formatMarkdown,
  lundiDe,
  mediane,
  readDays,
  resumeAdoption,
  resumeFacture,
  resumeQualite,
} from "../export-ai-pilot.mjs";

/**
 * LE PILOTE DE L'ÉTAGE IA — é29 §1.4.
 *
 * Ce que ces tests existent pour attraper n'est pas « le calcul est-il juste »
 * mais « une absence de mesure se distingue-t-elle d'une mesure à zéro ». Les
 * deux se ressemblent dans un rapport et ne disent pas du tout la même chose :
 * #1071 a dû rétablir cette distinction ailleurs après qu'un `0` de repli eut
 * été lu comme une mesure pendant des semaines.
 */

describe("mediane", () => {
  it("rend null sur une série vide — PAS zéro", () => {
    // « Rien à mesurer » et « mesuré à zéro » ne se confondent pas.
    expect(mediane([])).toBeNull();
    expect(mediane([Number.NaN, undefined, null])).toBeNull();
  });

  it("prend la moyenne des deux centraux sur un effectif pair", () => {
    expect(mediane([4, 1, 3, 2])).toBe(2.5);
    expect(mediane([5, 1, 3])).toBe(3);
  });

  it("ne se laisse pas tirer par une valeur extrême — c'est pourquoi ce n'est pas une moyenne", () => {
    // Un élève curieux un soir porterait la mesure de tous si on moyennait.
    expect(mediane([1, 1, 1, 1, 400])).toBe(1);
  });
});

describe("lundiDe", () => {
  it("ramène au lundi UTC, dimanche compris", () => {
    expect(lundiDe("2026-09-22T10:00:00Z")).toBe("2026-09-21"); // mardi → lundi
    expect(lundiDe("2026-09-21T00:00:00Z")).toBe("2026-09-21"); // lundi → lui-même
    expect(lundiDe("2026-09-20T23:59:59Z")).toBe("2026-09-14"); // dimanche → lundi PRÉCÉDENT
  });
});

describe("resumeAdoption", () => {
  const base = {
    credentials: [{ status: "active" }, { status: "active" }, { status: "revoked" }],
    acces: [{ enabled: true }, { enabled: true }, { enabled: false }],
    elevesLies: 4,
  };

  it("compte les clés ACTIVES, pas les clés saisies", () => {
    const a = resumeAdoption({ ...base, usages: [] });
    expect(a.famillesAvecCle).toBe(3);
    expect(a.famillesActives).toBe(2);
    expect(a.partElevesActives).toBe(0.5);
  });

  it("écarte les appels SANS élève — ils ne mesurent l'usage de personne", () => {
    // Vérification de clé et tâches de plateforme n'ont pas de `user_id` :
    // les compter gonflerait l'adoption sans qu'aucun élève ait rien fait.
    const a = resumeAdoption({
      ...base,
      usages: [
        { user_id: null, created_at: "2026-09-22T10:00:00Z" },
        { user_id: "e1", created_at: "2026-09-22T10:00:00Z" },
        { user_id: "e1", created_at: "2026-09-23T10:00:00Z" },
      ],
    });
    expect(a.interactionsMedianeParEleveSemaine).toBe(2);
    expect(a.semainesObservees).toBe(1);
  });

  it("rend null quand aucun élève n'a interagi, et 0 élève lié ne divise pas", () => {
    const a = resumeAdoption({ ...base, elevesLies: 0, usages: [] });
    expect(a.interactionsMedianeParEleveSemaine).toBeNull();
    expect(a.partElevesActives).toBeNull();
  });
});

describe("resumeFacture", () => {
  const credentials = [
    { owner_user_id: "p1", monthly_budget_usd: 5, limits_enforced: false },
    { owner_user_id: "p2", monthly_budget_usd: 10, limits_enforced: true },
  ];

  it("agrège le grand livre au mois et rend la médiane des couples famille × mois", () => {
    const f = resumeFacture({
      credentials,
      spend: [
        { owner_user_id: "p1", day: "2026-09-01", spent_micros: 1_000_000 },
        { owner_user_id: "p1", day: "2026-09-02", spent_micros: 1_000_000 },
        { owner_user_id: "p2", day: "2026-09-03", spent_micros: 4_000_000 },
      ],
    });
    expect(f.depenseMensuelleMedianeUsd).toBe(3); // médiane de [2, 4]
    expect(f.depenseTotaleUsd).toBe(6);
    expect(f.famillesAvecDepense).toBe(2);
  });

  it("juge le plafond de CHAQUE famille, jamais un plafond moyen", () => {
    const f = resumeFacture({
      credentials,
      spend: [
        { owner_user_id: "p1", day: "2026-09-01", spent_micros: 5_000_000 }, // atteint SON plafond (5 $)
        { owner_user_id: "p2", day: "2026-09-01", spent_micros: 5_000_000 }, // moitié du sien (10 $)
      ],
    });
    expect(f.famillesAuPlafond).toBe(1);
    expect(f.partFamillesAuPlafond).toBe(0.5);
  });

  it("rend le fait brut à la place du KPI devenu immesurable", () => {
    // « dépassements non stoppés : 0 » n'a plus de sens depuis que les plafonds
    // ne coupent plus par défaut (arena#811). On dit combien de familles
    // tournent sans coupure ; on ne fabrique pas un zéro rassurant.
    const f = resumeFacture({ credentials, spend: [] });
    expect(f.famillesSansCoupure).toBe(1);
    expect(f.kpiDepassementsNonStoppes).toMatch(/immesurable/);
    expect(f.depenseMensuelleMedianeUsd).toBeNull();
  });
});

describe("resumeQualite", () => {
  it("calcule le rebut sur les DEMANDES, pas sur le nombre de forges", () => {
    const q = resumeQualite({
      forges: [
        { requested: 10, discarded: 2 },
        { requested: 10, discarded: 0 },
      ],
      feedback: [],
    });
    expect(q.tauxRebutForge).toBe(0.1);
  });

  it("classe les modèles par VOLUME de jugements — le plus jugé décide", () => {
    const q = resumeQualite({
      forges: [],
      feedback: [
        { model: "deepseek-v4", verdict: "up" },
        { model: "deepseek-v4", verdict: "up" },
        { model: "deepseek-v4", verdict: "down" },
        { model: "kimi", verdict: "up" },
      ],
    });
    expect(q.parModele[0]).toMatchObject({ model: "deepseek-v4", up: 2, down: 1, total: 3 });
    expect(q.parModele[0].ratio).toBeCloseTo(2 / 3);
    expect(q.parModele[1].model).toBe("kimi");
  });

  it("rend null sans aucune forge — pas 0 %, qui se lirait « aucun rebut »", () => {
    expect(resumeQualite({ forges: [], feedback: [] }).tauxRebutForge).toBeNull();
  });
});

describe("confronterAuxCibles", () => {
  const qualite = { tauxRebutForge: 0.1 };

  it("nomme l'écart sans rendre de verdict", () => {
    const lignes = confronterAuxCibles({
      adoption: { interactionsMedianeParEleveSemaine: 3 },
      facture: { depenseMensuelleMedianeUsd: 9, partFamillesAuPlafond: 0.5 },
      qualite,
    });
    const etats = Object.fromEntries(lignes.map((l) => [l.nom, l.etat]));
    expect(etats["dépense mensuelle médiane par famille"]).toBe("écart");
    expect(etats["part des familles ayant touché un plafond"]).toBe("écart");
    expect(etats["taux de rebut de la Forge"]).toBe("atteinte");
    // Aucune ligne ne porte « concluant » / « non concluant » : c'est un arbitrage.
    expect(JSON.stringify(lignes)).not.toMatch(/concluant/);
  });

  it("une mesure absente rend `inconnu` — elle ne compte NI pour NI contre", () => {
    const lignes = confronterAuxCibles({
      adoption: { interactionsMedianeParEleveSemaine: null },
      facture: { depenseMensuelleMedianeUsd: null, partFamillesAuPlafond: null },
      qualite: { tauxRebutForge: null },
    });
    expect(lignes.every((l) => l.etat === "inconnu")).toBe(true);
  });

  it("les cibles sont celles de é29 §1.4, jamais recalées sur la mesure", () => {
    expect(CIBLES).toEqual({
      depenseMensuelleMedianeUsd: 3,
      partFamillesAuPlafond: 0.1,
      tauxRebutForge: 0.2,
    });
  });
});

describe("readDays", () => {
  it("défaut 30, et une valeur non numérique est une ERREUR", () => {
    expect(readDays([])).toBe(30);
    expect(readDays(["--days", "7"])).toBe(7);
    expect(() => readDays(["--days", "zéro"])).toThrow(/nombre > 0/);
    expect(() => readDays(["--days", "0"])).toThrow(/nombre > 0/);
  });
});

describe("formatMarkdown", () => {
  /** Un rapport de base vide — le cas qui compte, et celui qu'on rend mal par défaut. */
  const vide = {
    generatedAt: "2026-09-22T09:00:00Z",
    fenetre: { jours: 30, depuis: "2026-08-23T09:00:00Z" },
    adoption: {
      famillesAvecCle: 0,
      famillesActives: 0,
      elevesLies: 0,
      elevesActives: 0,
      partElevesActives: null,
      interactionsMedianeParEleveSemaine: null,
      semainesObservees: 0,
    },
    facture: {
      depenseMensuelleMedianeUsd: null,
      depenseTotaleUsd: 0,
      famillesAvecDepense: 0,
      famillesAuPlafond: 0,
      partFamillesAuPlafond: null,
      famillesSansCoupure: 0,
      kpiDepassementsNonStoppes: "immesurable",
    },
    qualite: { forgesDemandees: 0, forgesRebutees: 0, tauxRebutForge: null, parModele: [] },
    confrontation: confronterAuxCibles({
      adoption: { interactionsMedianeParEleveSemaine: null },
      facture: { depenseMensuelleMedianeUsd: null, partFamillesAuPlafond: null },
      qualite: { tauxRebutForge: null },
    }),
    cibles: CIBLES,
  };

  it("écrit un TIRET là où la mesure manque, jamais un zéro", () => {
    // « 0,00 $ » sur une base vide ferait conclure « le pilote ne coûte rien »
    // au lieu de « le pilote n'a rien produit ». C'est la seconde lecture qui
    // compte pour un verdict.
    const md = formatMarkdown(vide);
    expect(md).toContain("| dépense mensuelle **médiane** par famille | — |");
    expect(md).not.toMatch(/médiane\*\* par famille \| 0[.,]00 \$/);
  });

  it("dit l'absence du tableau par modèle au lieu d'afficher un tableau vide", () => {
    const md = formatMarkdown(vide);
    expect(md).toContain("Aucun 👍/👎 sur la fenêtre");
    expect(md).toContain("absence de mesure, pas un verdict neutre");
  });

  it("ne rend aucun verdict — le mot n'y est pas", () => {
    expect(formatMarkdown(vide)).toMatch(/ne rend aucun verdict/);
    expect(formatMarkdown(vide)).not.toMatch(/pilote (est|semble) concluant/);
  });

  it("nomme le KPI devenu immesurable au lieu de le taire", () => {
    expect(formatMarkdown(vide)).toContain("n'est plus mesurable");
  });
});
