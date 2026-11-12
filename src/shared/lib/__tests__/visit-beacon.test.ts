// @vitest-environment node
import { describe, expect, it, vi } from "vitest";
import { trackVisit, type VisitBeaconDeps } from "@/shared/lib/visit-beacon";
import type { VisitVerdict } from "@/shared/lib/visit-memory";

/**
 * Étude 40 lot 0 — LE DÉCLENCHEMENT (R-2) et LES PROPRIÉTÉS (R-3, R-4).
 *
 * La liste blanche ci-dessous est le « test de propriétés » de l'étude : chaque événement de
 * visite ne porte QUE les clés prévues, et chaque valeur appartient à une liste fermée ou est un
 * booléen. Une propriété ajoutée sans passer par l'étude casse ce fichier.
 */

const ALLOWED: Record<string, Record<string, readonly (string | boolean)[]>> = {
  visit_first: {
    entry_surface: [
      "chapitre",
      "exercice",
      "matiere",
      "niveau",
      "accueil",
      "test",
      "suivi",
      "compte",
      "autre",
    ],
    standalone: [true, false],
  },
  visit_returned: {
    days_bucket: ["1", "2-7", "8-30", "31+"],
    has_account: [true, false],
    entry: ["pwa", "push", "resume_link", "share", "direct"],
    standalone: [true, false],
  },
};

const TODAY = "2026-11-12";

function deps(verdict: VisitVerdict, over: Partial<VisitBeaconDeps> = {}) {
  const track = vi.fn<VisitBeaconDeps["track"]>();
  const all: VisitBeaconDeps = {
    recordVisit: vi.fn(() => verdict),
    consumeEntrySource: vi.fn(() => "direct" as const),
    entrySurface: () => "chapitre",
    standalone: () => false,
    hasAccount: vi.fn(async () => false),
    track,
    ...over,
  };
  return { all, track };
}

function expectWhitelisted(name: string, props: Record<string, unknown>): void {
  const allowed = ALLOWED[name];
  expect(allowed, name).toBeDefined();
  expect(Object.keys(props).sort()).toEqual(Object.keys(allowed ?? {}).sort());
  for (const [key, value] of Object.entries(props)) {
    expect(allowed?.[key], `${name}.${key}`).toContain(value);
  }
}

describe("R-2 — au plus un événement de visite", () => {
  it("⭐ navigateur neuf ⇒ un `visit_first`, aucun `visit_returned`", async () => {
    const { all, track } = deps({ kind: "first" });
    await trackVisit(TODAY, all);
    expect(track).toHaveBeenCalledTimes(1);
    expect(track).toHaveBeenCalledWith("visit_first", {
      entry_surface: "chapitre",
      standalone: false,
    });
    // La session n'est même pas consultée : `visit_first` n'a pas de `has_account`.
    expect(all.hasAccount).not.toHaveBeenCalled();
  });

  it("⭐ même jour, ou stockage jeté ⇒ rien n'est émis", async () => {
    const { all, track } = deps({ kind: "none" });
    await trackVisit(TODAY, all);
    expect(track).not.toHaveBeenCalled();
  });

  it('⭐ le lendemain ⇒ un `visit_returned {days_bucket: "1"}`', async () => {
    const { all, track } = deps({ kind: "returned", daysBucket: "1" });
    await trackVisit(TODAY, all);
    expect(track).toHaveBeenCalledTimes(1);
    expect(track).toHaveBeenCalledWith("visit_returned", {
      days_bucket: "1",
      has_account: false,
      entry: "direct",
      standalone: false,
    });
  });

  it('⭐ `/?src=pwa` ⇒ `entry: "pwa"`, avec la session et l\'installation', async () => {
    const { all, track } = deps(
      { kind: "returned", daysBucket: "8-30" },
      {
        consumeEntrySource: () => "pwa",
        standalone: () => true,
        hasAccount: async () => true,
      },
    );
    await trackVisit(TODAY, all);
    expect(track).toHaveBeenCalledWith("visit_returned", {
      days_bucket: "8-30",
      has_account: true,
      entry: "pwa",
      standalone: true,
    });
  });

  it("⭐ la source est consommée MÊME quand rien n'est émis : l'adresse redevient propre", async () => {
    const { all } = deps({ kind: "none" });
    await trackVisit(TODAY, all);
    expect(all.consumeEntrySource).toHaveBeenCalledTimes(1);
  });

  it("le jour reçu de la racine est passé tel quel à la mémoire", async () => {
    const { all } = deps({ kind: "none" });
    await trackVisit(TODAY, all);
    expect(all.recordVisit).toHaveBeenCalledWith(TODAY);
  });

  it("la surface est lue AVANT que l'adresse soit touchée", async () => {
    const order: string[] = [];
    const { all } = deps(
      { kind: "first" },
      {
        entrySurface: () => (order.push("surface"), "accueil"),
        consumeEntrySource: () => (order.push("source"), "direct"),
      },
    );
    await trackVisit(TODAY, all);
    expect(order).toEqual(["surface", "source"]);
  });

  it("⭐ rien ne casse : une dépendance qui lève n'atteint pas la page", async () => {
    const { all, track } = deps(
      { kind: "returned", daysBucket: "1" },
      {
        hasAccount: async () => {
          throw new Error("réseau");
        },
      },
    );
    await expect(trackVisit(TODAY, all)).resolves.toBeUndefined();
    expect(track).not.toHaveBeenCalled();
  });
});

describe("R-3 / R-4 — la liste blanche des propriétés", () => {
  it("⭐ `visit_first` et `visit_returned` ne portent que des étiquettes fermées et des booléens", async () => {
    const verdicts: VisitVerdict[] = [
      { kind: "first" },
      { kind: "returned", daysBucket: "1" },
      { kind: "returned", daysBucket: "2-7" },
      { kind: "returned", daysBucket: "8-30" },
      { kind: "returned", daysBucket: "31+" },
    ];
    let seen = 0;
    for (const verdict of verdicts) {
      const { all, track } = deps(verdict, { consumeEntrySource: () => "share" });
      await trackVisit(TODAY, all);
      for (const [name, props] of track.mock.calls) {
        seen += 1;
        expectWhitelisted(name, props);
      }
    }
    expect(seen).toBe(verdicts.length);
  });

  it("⭐ aucune clé ne ressemble à une identité, un chapitre, un score ou une date", () => {
    const keys = Object.values(ALLOWED).flatMap((props) => Object.keys(props));
    for (const key of keys) {
      expect(key).not.toMatch(/id$|email|name|chapter|score|date|day$|url|path/i);
    }
  });
});
