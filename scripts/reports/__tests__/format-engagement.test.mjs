// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  formatEngagementReport,
  num,
  latestMeasurable,
  maxActive,
  pct,
  pooled,
  returnLines,
  shortDay,
} from "../format-engagement.mjs";

/**
 * Ce fichier garde les DÉCISIONS DE LECTURE, pas la mise en page.
 *
 * Un relevé automatique est un texte qui sera cité par quelqu'un qui n'aura pas
 * ouvert la console. Les trois façons dont il peut mentir sont ici :
 *   1. transformer un `null` en `0 %` (« il n'y avait personne » ≠ « personne
 *      n'est revenu ») ;
 *   2. publier un pourcentage sans son `n` ;
 *   3. taire que `n` est trop petit pour qu'on en tire quoi que ce soit.
 */

/** Le relevé RÉEL du 2026-09-03, recopié depuis `/admin/engagement` en production. */
const RELEVE_REEL = {
  curr: [
    { week_start: "2026-06-29", active: 3, returned: 2, curr_pct: 66.7 },
    { week_start: "2026-07-06", active: 2, returned: 1, curr_pct: 50 },
    { week_start: "2026-07-13", active: 2, returned: 1, curr_pct: 50 },
    { week_start: "2026-07-20", active: 1, returned: 0, curr_pct: 0 },
    { week_start: "2026-07-27", active: 1, returned: 1, curr_pct: 100 },
    { week_start: "2026-08-03", active: 1, returned: 0, curr_pct: 0 },
    { week_start: "2026-08-10", active: 1, returned: 1, curr_pct: 100 },
    { week_start: "2026-08-17", active: 5, returned: 3, curr_pct: 60 },
  ],
  learning: {
    accuracy_avg_pct: 74.2,
    accuracy_p50_pct: 80,
    chapters_per_active: 3,
    attempts_30d: 41,
  },
};
const LE_3_SEPTEMBRE = new Date("2026-09-03T18:00:00Z");

describe("les refus hérités de la RPC", () => {
  it("⭐ un `null` reste « — » et ne devient JAMAIS 0 %", () => {
    // C'est le refus que la RPC pose et que la mise en forme pourrait défaire
    // sans que rien ne rougisse : une semaine sans actif rend NULL, et « 0 % »
    // ferait lire « personne n'est revenu » là où il n'y avait personne.
    expect(pct(null)).toBe("—");
    expect(pct(undefined)).toBe("—");
    expect(pct(0)).toBe("0 %");
  });

  it("la dernière semaine PUBLIABLE est la dernière CALCULABLE, pas la dernière ligne", () => {
    const avecNull = {
      curr: [
        { week_start: "2026-08-10", active: 4, returned: 2, curr_pct: 50 },
        { week_start: "2026-08-17", active: 0, returned: 0, curr_pct: null },
      ],
    };
    expect(latestMeasurable(avecNull.curr)?.week_start).toBe("2026-08-10");
    expect(latestMeasurable([])).toBeNull();
    expect(latestMeasurable([{ week_start: "2026-08-17", active: 0, curr_pct: null }])).toBeNull();
  });

  it("le cumul ignore les semaines non mesurables plutôt que de les compter à zéro", () => {
    const p = pooled([
      { week_start: "2026-08-10", active: 4, returned: 2, curr_pct: 50 },
      { week_start: "2026-08-17", active: 0, returned: 0, curr_pct: null },
    ]);
    expect(p).toEqual({ active: 4, returned: 2, pct: 50 });
  });
});

describe("le relevé du 2026-09-03, tel qu'il sera publié", () => {
  const md = formatEngagementReport(RELEVE_REEL, LE_3_SEPTEMBRE);

  it("porte la date du relevé — un chiffre sans date ne vaut rien pour la scorecard", () => {
    expect(md).toContain("2026-09-03");
  });

  it("⭐ ne publie JAMAIS un pourcentage sans son n", () => {
    // « 60 % » qui voyage seul se fait citer comme un taux de rétention produit.
    expect(md).toContain("**CURR = 60 %** sur la semaine du **17/08** — 3 élèves revenus sur 5");
    expect(md).toContain("9 retours sur 16 personnes-semaines");
  });

  it("nomme le cumul « personnes-semaines », jamais « rétention »", () => {
    // Un même élève actif six semaines y compte six fois : le nommer rétention
    // serait le mensonge, le nommer personnes-semaines ne l'est pas.
    expect(md).toContain("personnes-semaines");
    expect(md.split("\n").find((l) => l.includes("Toutes semaines"))).not.toMatch(/rétention/i);
  });

  it("⭐ dit que n est trop petit — la réserve voyage AVEC le chiffre", () => {
    expect(maxActive(RELEVE_REEL.curr)).toBe(5);
    expect(md).toContain("culmine à 5");
    expect(md).toContain("du bruit avec une unité");
  });

  it("rend la métrique de garde R-1 — l'engagement ne se lit pas seul", () => {
    expect(md).toContain("Métrique de garde (R-1)");
    expect(md).toContain("74,2 %");
  });

  it("⭐ un seul séparateur décimal dans tout le relevé — la virgule", () => {
    // Le PREMIER run publié (issue #962) a rendu « 1.4 chapitres » à côté de
    // « 73,38 % » : `chapters_per_active` ne passait pas par le formateur de
    // nombres. Deux séparateurs dans le même tableau, dans un texte français.
    const avecDecimales = formatEngagementReport(
      {
        curr: [],
        learning: { accuracy_avg_pct: 73.38, chapters_per_active: 1.4, attempts_30d: 124 },
      },
      LE_3_SEPTEMBRE,
    );
    const tableau = avecDecimales.split("\n").find((l) => l.includes("73,38"));
    expect(tableau).toContain("1,4");
    expect(tableau).not.toContain("1.4");
    expect(num(1.4)).toBe("1,4");
    expect(num(124)).toBe("124");
    expect(num(null)).toBe("—");
  });

  it("rend les huit semaines, dans l'ordre", () => {
    const lignes = md.split("\n").filter((l) => /^\| \d\d\/\d\d \|/.test(l));
    expect(lignes).toHaveLength(8);
    expect(lignes[0]).toContain("29/06");
    expect(lignes[7]).toContain("17/08");
  });
});

describe("l'état « rien à mesurer »", () => {
  const vide = formatEngagementReport({ curr: [], learning: {} }, LE_3_SEPTEMBRE);

  it("dit que c'est un ÉTAT, pas une panne — et pourquoi", () => {
    expect(vide).toContain("Aucune semaine mesurable");
    expect(vide).toContain("zéro canal d'acquisition");
    // Surtout : il n'invente pas un 0 % pour avoir un chiffre à afficher.
    expect(vide).not.toContain("CURR = 0");
  });

  it("ne crie pas au petit n quand il n'y a personne — la réserve n'aurait aucun sens", () => {
    expect(vide).not.toContain("culmine à");
  });

  it("survit à un JSON vide plutôt que d'exploser sur le chemin du relevé", () => {
    expect(() => formatEngagementReport({}, LE_3_SEPTEMBRE)).not.toThrow();
    expect(() => formatEngagementReport(null, LE_3_SEPTEMBRE)).not.toThrow();
  });
});

describe("shortDay", () => {
  it("lit la date, ne la calcule pas — aucun décalage de fuseau possible", () => {
    expect(shortDay("2026-08-17")).toBe("17/08");
    expect(shortDay("2027-01-04")).toBe("04/01");
  });
});

/**
 * Étude 40 lot 0 — les trois lignes du RETOUR. Le décor reprend les agrégats de
 * production du 2026-11-12 au matin : 60 élèves, 36 sans aucun jour d'activité,
 * personne de joignable par push, 2 parents liés.
 */
const RETOUR = {
  cohorts: [
    {
      week: "2026-10-19",
      signups: 8,
      played_7d: 3,
      played_7d_base: 8,
      back_7d: 1,
      back_7d_base: 8,
    },
    {
      week: "2026-10-26",
      signups: 5,
      played_7d: 3,
      played_7d_base: 5,
      back_7d: 2,
      back_7d_base: 5,
    },
    // Semaine en cours : quatre inscrits, aucun mesurable.
    {
      week: "2026-11-09",
      signups: 4,
      played_7d: 0,
      played_7d_base: 0,
      back_7d: 0,
      back_7d_base: 0,
    },
  ],
  students: 60,
  never_played: 36,
  push: { students_active_30d: 8, students_reachable: 0, parents_linked: 2, parents_reachable: 0 },
};

describe("le retour (étude 40 lot 0)", () => {
  const md = formatEngagementReport({ ...RELEVE_REEL, return: RETOUR }, LE_3_SEPTEMBRE);

  it("⭐ le relevé dit « première quête : x/y » — et y ne compte que les fenêtres écoulées", () => {
    expect(md).toContain("**Première quête : 6/13** (46,2 %)");
    // Les quatre inscrits de la semaine en cours ne sont NI au dénominateur NI perdus.
    expect(md).toContain("4 en attente");
  });

  it("dit la portée du push, élèves et parents, chacun avec sa population", () => {
    expect(md).toContain(
      "**Portée du push : 0 élève(s) joignable(s)** pour 8 actif(s) sur 30 jours",
    );
    expect(md).toContain("0 parent(s) joignable(s) sur 2 lié(s)");
  });

  it("⭐ « jamais joué » voyage avec son dénominateur", () => {
    expect(md).toContain("**Jamais joué : 36/60**");
  });

  it("ajoute exactement trois lignes de chiffres", () => {
    expect(returnLines(RETOUR).filter((l) => l.startsWith("- "))).toHaveLength(3);
  });

  it("⭐ sans aucune fenêtre écoulée, la première quête est « — », jamais 0/0 ni 0 %", () => {
    const jeune = returnLines({ ...RETOUR, cohorts: [RETOUR.cohorts[2]] }).join("\n");
    expect(jeune).toContain("**Première quête : —**");
    expect(jeune).not.toContain("0/0");
    expect(jeune).not.toContain("0 %");
  });

  it("⭐ lecture absente ⇒ une ligne qui le dit, pas trois zéros", () => {
    const sans = formatEngagementReport(RELEVE_REEL, LE_3_SEPTEMBRE);
    expect(sans).toContain("non relevé");
    expect(sans).not.toContain("Jamais joué");
    expect(returnLines(null)).toHaveLength(1);
    expect(returnLines({ cohorts: [] })).toHaveLength(1);
  });

  it("le reste du relevé n'a pas bougé : la CURR et la métrique de garde sont toujours là", () => {
    expect(md).toContain("**CURR = 60 %**");
    expect(md).toContain("Métrique de garde (R-1)");
  });
});
