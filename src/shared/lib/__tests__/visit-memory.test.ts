// @vitest-environment node
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import {
  VISIT_KEY,
  bucketDays,
  classifyVisit,
  parseVisitMemory,
  recordVisit,
  type VisitStorage,
} from "@/shared/lib/visit-memory";

/**
 * Étude 40 lot 0 — LA MÉMOIRE DE VISITE (R-1 à R-3). Chaque règle a son test nommé.
 *
 * Les critères du lot (US-1) qui se prouvent ici : navigateur neuf ⇒ « première visite » ;
 * réouverture le même jour ⇒ rien ; le lendemain ⇒ « revenu », tranche "1" ; stockage jeté ⇒
 * rien n'est émis et rien ne casse.
 */

import { appLocalDate } from "@/shared/lib/app-day";

/** Le jour civil de Tunis d'un instant de novembre 2026 — ce que la racine passe au module. */
const at = (day: number, hourUtc = 11): string =>
  appLocalDate(new Date(Date.UTC(2026, 10, day, hourUtc, 0, 0)));
const tunisDay = (date: Date): string => appLocalDate(date);

function memoryStorage(initial?: string): VisitStorage & { value: string | null; writes: number } {
  const store = {
    value: initial ?? null,
    writes: 0,
    getItem: (key: string) => (key === VISIT_KEY ? store.value : null),
    setItem: (key: string, value: string) => {
      if (key !== VISIT_KEY) throw new Error(`clé inattendue : ${key}`);
      store.value = value;
      store.writes += 1;
    },
  };
  return store;
}

describe("R-1 — la mémoire vit sur l'appareil, deux jours civils de Tunis", () => {
  it("⭐ écrit { first, last } en jours civils, et rien d'autre", () => {
    const storage = memoryStorage();
    recordVisit({ today: at(12), storage });
    expect(JSON.parse(storage.value ?? "")).toEqual({ first: "2026-11-12", last: "2026-11-12" });
  });

  it("⭐ le jour est celui de TUNIS : 23 h 30 UTC le 12 est déjà le 13 là-bas", () => {
    const storage = memoryStorage();
    recordVisit({ today: tunisDay(new Date(Date.UTC(2026, 10, 12, 23, 30))), storage });
    expect(parseVisitMemory(storage.value)?.first).toBe("2026-11-13");
  });

  it("⭐ elle n'est jamais envoyée : le module n'importe RIEN", () => {
    const source = readFileSync(join(process.cwd(), "src/shared/lib/visit-memory.ts"), "utf8");
    expect(source).not.toMatch(/^import /m);
    expect(source).not.toMatch(/fetch\(|sendBeacon|XMLHttpRequest/);
  });

  it("⭐ le jour vient de la racine, calculé par `appLocalDate` — jamais une date UTC", () => {
    const root = readFileSync(join(process.cwd(), "src/routes/__root.tsx"), "utf8");
    expect(root).toContain("m.trackVisit(appLocalDate(new Date()))");
  });

  it("un « jour » qui n'en est pas un n'entre jamais dans la mémoire", () => {
    const storage = memoryStorage();
    for (const today of ["", "2026-11-12T10:00:00Z", "12/11/2026", "2026-13-01"]) {
      expect(recordVisit({ today, storage }), today).toEqual({ kind: "none" });
    }
    expect(storage.writes).toBe(0);
  });

  it("⭐ stockage indisponible ⇒ aucun verdict (sens sûr : on sous-compte)", () => {
    expect(recordVisit({ today: at(12), storage: null })).toEqual({ kind: "none" });
  });

  it("⭐ stockage JETÉ ⇒ rien n'est émis et rien ne casse (lecture qui lève)", () => {
    const storage: VisitStorage = {
      getItem: () => {
        throw new Error("SecurityError");
      },
      setItem: () => {
        throw new Error("SecurityError");
      },
    };
    expect(recordVisit({ today: at(12), storage })).toEqual({ kind: "none" });
  });

  it("⭐ écriture refusée ⇒ pas de « première visite » : sinon une par chargement de page", () => {
    const storage: VisitStorage = {
      getItem: () => null,
      setItem: () => {
        throw new Error("QuotaExceededError");
      },
    };
    expect(recordVisit({ today: at(12), storage })).toEqual({ kind: "none" });
    expect(recordVisit({ today: at(13), storage })).toEqual({ kind: "none" });
  });

  it("une mémoire illisible est réécrite à aujourd'hui SANS verdict — on ne sait pas s'il est neuf", () => {
    for (const junk of ["{", "42", '"x"', "null", '{"first":"2026-02-31","last":"2026-03-01"}']) {
      const storage = memoryStorage(junk);
      expect(recordVisit({ today: at(12), storage }), junk).toEqual({ kind: "none" });
      expect(parseVisitMemory(storage.value)).toEqual({ first: "2026-11-12", last: "2026-11-12" });
    }
  });

  it("refuse une mémoire dont `first` suit `last`, ou dont un jour manque", () => {
    expect(parseVisitMemory('{"first":"2026-11-12","last":"2026-11-10"}')).toBeNull();
    expect(parseVisitMemory('{"first":"2026-11-12"}')).toBeNull();
    expect(parseVisitMemory('{"first":20261112,"last":20261112}')).toBeNull();
    expect(parseVisitMemory(null)).toBeNull();
  });
});

describe("R-2 — première visite, retour, et au plus un événement par jour", () => {
  it("⭐ navigateur neuf ⇒ « première visite », et pas un retour", () => {
    expect(recordVisit({ today: at(12), storage: memoryStorage() })).toEqual({ kind: "first" });
  });

  it("⭐ réouverture le MÊME jour ⇒ rien, et la mémoire n'est pas réécrite", () => {
    const storage = memoryStorage();
    recordVisit({ today: at(12, 8), storage });
    expect(recordVisit({ today: at(12, 20), storage })).toEqual({ kind: "none" });
    expect(storage.writes).toBe(1);
  });

  it('⭐ le LENDEMAIN ⇒ « revenu », tranche "1" ; `last` avance, `first` ne bouge pas', () => {
    const storage = memoryStorage();
    recordVisit({ today: at(12), storage });
    expect(recordVisit({ today: at(13), storage })).toEqual({ kind: "returned", daysBucket: "1" });
    expect(parseVisitMemory(storage.value)).toEqual({ first: "2026-11-12", last: "2026-11-13" });
  });

  it("⭐ deux réouvertures le jour du retour ⇒ UN seul retour", () => {
    const storage = memoryStorage();
    recordVisit({ today: at(12), storage });
    recordVisit({ today: at(14, 8), storage });
    expect(recordVisit({ today: at(14, 20), storage })).toEqual({ kind: "none" });
  });

  it("minuit de Tunis sépare deux jours : 22 h 59 puis 23 h 01 UTC ⇒ un retour", () => {
    const storage = memoryStorage();
    recordVisit({ today: tunisDay(new Date(Date.UTC(2026, 10, 12, 22, 59))), storage });
    expect(
      recordVisit({ today: tunisDay(new Date(Date.UTC(2026, 10, 12, 23, 1))), storage }),
    ).toEqual({
      kind: "returned",
      daysBucket: "1",
    });
  });

  it("l'écart se compte depuis la DERNIÈRE visite, pas depuis la première", () => {
    const storage = memoryStorage('{"first":"2026-09-01","last":"2026-11-10"}');
    expect(recordVisit({ today: at(12), storage })).toEqual({
      kind: "returned",
      daysBucket: "2-7",
    });
  });

  it("horloge reculée (`last` dans le futur) ⇒ rien, et rien n'est écrit", () => {
    const storage = memoryStorage('{"first":"2026-11-01","last":"2026-11-20"}');
    expect(recordVisit({ today: at(12), storage })).toEqual({ kind: "none" });
    expect(storage.writes).toBe(0);
  });

  it("`classifyVisit` est pur : il rend le verdict et la mémoire suivante sans rien toucher", () => {
    const memory = { first: "2026-10-01", last: "2026-10-01" } as const;
    expect(classifyVisit(memory, "2026-11-12")).toEqual({
      verdict: { kind: "returned", daysBucket: "31+" },
      next: { first: "2026-10-01", last: "2026-11-12" },
    });
    expect(classifyVisit(memory, "2026-10-01")).toEqual({ verdict: { kind: "none" }, next: null });
    expect(classifyVisit(memory, "pas-un-jour")).toEqual({ verdict: { kind: "none" }, next: null });
  });
});

describe("R-3 — la tranche de jours, jamais le nombre exact", () => {
  it("⭐ quatre tranches, bornes comprises", () => {
    expect([1, 2, 7, 8, 30, 31, 400].map(bucketDays)).toEqual([
      "1",
      "2-7",
      "2-7",
      "8-30",
      "8-30",
      "31+",
      "31+",
    ]);
  });

  it("⭐ le verdict ne porte ni date ni nombre de jours", () => {
    const storage = memoryStorage('{"first":"2026-11-01","last":"2026-11-03"}');
    const verdict = recordVisit({ today: at(12), storage });
    expect(Object.keys(verdict).sort()).toEqual(["daysBucket", "kind"]);
    expect(JSON.stringify(verdict)).not.toMatch(/2026|\b9\b/);
  });
});
