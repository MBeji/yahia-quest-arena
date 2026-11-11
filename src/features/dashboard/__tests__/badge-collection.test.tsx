import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import React from "react";

import { BadgeCollection } from "../components/badge-collection";
import { buildBadgeCollection } from "../badges";
import { BADGE_CODES, BADGE_FAMILIES } from "@/shared/constants/badges";
import { frBadges } from "@/lib/i18n/badges/fr";
import { enBadges } from "@/lib/i18n/badges/en";
import { arBadges } from "@/lib/i18n/badges/ar";
import type { BadgeCollectionEntry } from "@/shared/types/gamification";

/**
 * Étude 31 lot 2 — la collection (US-3, R-13).
 *
 * Ce qui est tenu ici, c'est la moitié du constat n° 4 que le SQL ne peut pas
 * garder : **un badge verrouillé doit être VISIBLE et porter sa condition**. Une
 * vitrine des seuls badges obtenus ne donne aucune raison de revenir, et c'est
 * exactement l'état d'avant ce lot.
 */

function entry(over: Partial<BadgeCollectionEntry> = {}): BadgeCollectionEntry {
  return {
    code: "first_quest",
    name: "Première Quête",
    description: "Terminer son premier exercice",
    rarity: "common",
    iconName: "Sword",
    family: "debut",
    awardedAt: null,
    ...over,
  };
}

describe("BadgeCollection", () => {
  it("⭐ affiche les badges VERROUILLÉS, avec leur condition en clair", () => {
    render(
      <BadgeCollection
        collection={[
          entry({ code: "streak_30", family: "serie", awardedAt: null }),
          entry({ code: "first_quest", awardedAt: "2026-08-01T10:00:00Z" }),
        ]}
      />,
    );
    const locked = screen.getByTestId("badge-collection").querySelector('[data-code="streak_30"]');
    expect(locked).not.toBeNull();
    expect(locked?.getAttribute("data-unlocked")).toBe("false");
    expect(locked?.textContent).toContain(frBadges.badgeCollection.labels.streak_30.condition);
  });

  it("dit la progression globale et celle de chaque famille", () => {
    render(
      <BadgeCollection
        collection={[
          entry({ code: "first_quest", awardedAt: "2026-08-01T10:00:00Z" }),
          entry({ code: "level_10", awardedAt: null }),
          entry({ code: "streak_7", family: "serie", awardedAt: "2026-08-02T10:00:00Z" }),
        ]}
      />,
    );
    expect(screen.getByTestId("badge-collection-progress").textContent).toContain("2");
    const debut = screen.getByTestId("badge-collection").querySelector('[data-family="debut"]');
    expect(debut?.textContent).toContain("1/2");
  });

  it("ouvre sur les premiers pas, pas sur l'ordre alphabétique", () => {
    render(
      <BadgeCollection
        collection={[
          entry({ code: "collector", family: "arene" }),
          entry({ code: "streak_7", family: "serie" }),
          entry({ code: "first_quest", family: "debut" }),
        ]}
      />,
    );
    const families = Array.from(screen.getAllByTestId("badge-family")).map((el) =>
      el.getAttribute("data-family"),
    );
    expect(families).toEqual(["debut", "serie", "arene"]);
  });

  it("⭐ n'emploie aucun vocabulaire d'échec (R-8)", () => {
    const { container } = render(
      <BadgeCollection collection={[entry({ code: "streak_30", family: "serie" })]} />,
    );
    const text = (container.textContent ?? "").toLowerCase();
    for (const banned of ["échoué", "raté", "perdu", "abandonn"]) {
      expect(text).not.toContain(banned);
    }
  });

  it("affiche un badge inconnu du catalogue de traduction plutôt que de le cacher", () => {
    render(
      <BadgeCollection
        collection={[
          entry({
            code: "badge_du_futur",
            name: "Badge du futur",
            description: "Condition maison",
          }),
        ]}
      />,
    );
    const card = screen
      .getByTestId("badge-collection")
      .querySelector('[data-code="badge_du_futur"]');
    expect(card?.textContent).toContain("Badge du futur");
    expect(card?.textContent).toContain("Condition maison");
  });

  it("rend le message d'attente quand le catalogue est vide", () => {
    render(<BadgeCollection collection={[]} />);
    expect(screen.getByTestId("badge-collection-empty")).toBeInTheDocument();
  });
});

describe("buildBadgeCollection", () => {
  it("marque comme obtenu ce que l'élève porte, et laisse le reste verrouillé", () => {
    const collection = buildBadgeCollection(
      [
        {
          code: "first_quest",
          name: "Première Quête",
          description: "…",
          rarity: "common",
          icon_name: "Sword",
          family: "debut",
        },
        {
          code: "streak_30",
          name: "Flamme Légendaire",
          description: "…",
          rarity: "legendary",
          icon_name: "Zap",
          family: "serie",
        },
      ],
      [{ code: "first_quest", awardedAt: "2026-08-01T10:00:00Z" }],
    );
    expect(collection.map((b) => b.awardedAt)).toEqual(["2026-08-01T10:00:00Z", null]);
  });
});

describe("catalogue de badges — les trois langues (R-22)", () => {
  it("⭐ chaque badge a un nom ET une condition dans les 3 langues", () => {
    for (const code of BADGE_CODES) {
      for (const [name, dict] of [
        ["fr", frBadges],
        ["en", enBadges],
        ["ar", arBadges],
      ] as const) {
        const label = dict.badgeCollection.labels[code];
        expect(label?.name?.length ?? 0, `${code} / ${name} : nom manquant`).toBeGreaterThan(0);
        expect(
          label?.condition?.length ?? 0,
          `${code} / ${name} : condition manquante`,
        ).toBeGreaterThan(0);
      }
    }
  });

  it("chaque famille est nommée dans les 3 langues", () => {
    for (const family of BADGE_FAMILIES) {
      for (const dict of [frBadges, enBadges, arBadges]) {
        expect(dict.badgeCollection.families[family].length).toBeGreaterThan(0);
      }
    }
  });
});

describe("le catalogue du code suit celui de la base (R-13)", () => {
  /**
   * ⭐ La règle R-13 a deux moitiés : tout badge de la base est décernable, et la
   * collection les montre tous. Elle se casse en silence si la liste du code et
   * le semis SQL divergent — un badge semé sans sa ligne ici s'afficherait en
   * français dans les trois langues, un badge retiré de la base laisserait une
   * carte fantôme. Le test lit la migration, pas une copie.
   */
  const MIGRATIONS = join(process.cwd(), "supabase/migrations");
  const migration = readFileSync(join(MIGRATIONS, "20260902140000_badges_alive.sql"), "utf8");
  /** Toutes les migrations, concaténées : un badge peut être semé par un lot ultérieur. */
  const allMigrations = readdirSync(MIGRATIONS)
    .filter((f) => f.endsWith(".sql"))
    .map((f) => readFileSync(join(MIGRATIONS, f), "utf8"))
    .join("\n");

  it("⭐ déclare tous les badges que le lot 2 remplit", () => {
    const block = migration.slice(
      migration.indexOf("UPDATE public.badges SET family"),
      migration.indexOf("-- D-5 :"),
    );
    const seeded = [
      ...block.matchAll(/\('([a-z_0-9]+)',\s+'(?:debut|serie|maitrise|arene|saison)'/g),
    ].map((m) => m[1]);
    for (const code of seeded) {
      expect((BADGE_CODES as readonly string[]).includes(code), `${code} absent du code`).toBe(
        true,
      );
    }
  });

  it("⭐ et n'en déclare AUCUN que la base ne sème — dans les deux sens", () => {
    // L'inverse du test précédent : un code inventé côté client afficherait une
    // carte que personne ne peut obtenir, exactement la panne que R-13 interdit.
    for (const code of BADGE_CODES) {
      expect(allMigrations.includes(`'${code}'`), `${code} n'est semé par aucune migration`).toBe(
        true,
      );
    }
  });

  it("⭐ `night_owl` a disparu des deux côtés (D-5)", () => {
    expect((BADGE_CODES as readonly string[]).includes("night_owl")).toBe(false);
    expect(migration).toContain("DELETE FROM public.badges b");
    expect(migration).toContain("'night_owl'");
    expect(frBadges.badgeCollection.labels).not.toHaveProperty("night_owl");
  });
});
