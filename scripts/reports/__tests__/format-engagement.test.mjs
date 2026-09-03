// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  formatEngagementReport,
  latestMeasurable,
  maxActive,
  pct,
  pooled,
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
  learning: { accuracy_avg_pct: 74.2, accuracy_p50_pct: 80, chapters_per_active: 3, attempts_30d: 41 },
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
