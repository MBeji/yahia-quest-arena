import { render, screen } from "@testing-library/react";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, it, expect } from "vitest";
import React from "react";

import { HeroAvatar } from "../components/hero-avatar";
import { HeroStatChips } from "../components/hero-stat-chips";
import { HERO_CLASSES, HERO_TITLES, clampAvatarTier } from "@/shared/constants/hero-identity";
import { fr } from "@/lib/i18n/fr";
import { en } from "@/lib/i18n/en";
import { ar } from "@/lib/i18n/ar";

/**
 * Étude 31 lot 7 — L'IDENTITÉ DU HÉROS (US-11, R-22).
 *
 * Constat n° 10 : `avatar_tier` était calculé à chaque gain d'XP et rendu NULLE
 * PART ; `hero_class` était du français non accentué, affiché tel quel dans les
 * trois langues. Ce fichier tient les deux moitiés visibles :
 *
 *   1. ⭐ la classe se TRADUIT — un élève arabophone ne lit plus « Guerrier des
 *      Equations » ;
 *   2. le palier et le cadre SE VOIENT : un cosmétique invisible ne donne envie
 *      d'acheter rien du tout, et c'est là que l'économie n'avait aucun puits.
 */

describe("HeroStatChips — la classe et le titre", () => {
  it("⭐ traduit le code de classe au lieu de l'afficher brut", () => {
    render(
      <HeroStatChips level={12} currentStreak={3} xp={2400} coins={100} heroClass="guerrier" />,
    );
    expect(screen.getByTestId("hero-class").textContent).toContain(
      fr.dashboard.heroClasses.guerrier,
    );
    // Le code technique ne fuit jamais à l'écran.
    expect(screen.getByTestId("hero-class").textContent).not.toContain("guerrier");
  });

  it("affiche le titre acheté à côté de la classe", () => {
    render(
      <HeroStatChips
        level={12}
        currentStreak={3}
        xp={2400}
        coins={100}
        heroClass="guerrier"
        titleCode="sharp"
      />,
    );
    expect(screen.getByTestId("hero-title").textContent).toContain(fr.dashboard.heroTitles.sharp);
  });

  it("laisse passer un code inconnu plutôt que de laisser un trou", () => {
    render(
      <HeroStatChips level={1} currentStreak={0} xp={0} coins={0} heroClass="classe_du_futur" />,
    );
    expect(screen.getByTestId("hero-class").textContent).toContain("classe_du_futur");
  });

  it("ne rend aucun titre quand l'élève n'en a pas équipé", () => {
    render(<HeroStatChips level={1} currentStreak={0} xp={0} coins={0} heroClass="novice" />);
    expect(screen.queryByTestId("hero-title")).not.toBeInTheDocument();
  });
});

describe("HeroAvatar — le palier et le cadre, enfin visibles", () => {
  it("⭐ rend le palier d'avatar, que rien n'affichait", () => {
    render(<HeroAvatar avatarSlug="ninja" avatarTier={4} />);
    expect(screen.getByTestId("hero-avatar-tier").textContent).toContain("4");
    expect(screen.getByTestId("hero-avatar-tier").textContent).toContain("6");
  });

  it("porte le cadre acheté", () => {
    render(<HeroAvatar avatarSlug="ninja" frameSlug="gold" avatarTier={2} />);
    expect(screen.getByTestId("hero-avatar").getAttribute("data-frame")).toBe("gold");
  });

  it("ignore un cadre inconnu plutôt que de dessiner n'importe quoi", () => {
    render(<HeroAvatar avatarSlug="ninja" frameSlug="cadre-pirate" avatarTier={2} />);
    expect(screen.getByTestId("hero-avatar").getAttribute("data-frame")).toBeNull();
  });

  it("borne le palier — `award_xp` le plafonne à 6, l'écran ne dépasse pas non plus", () => {
    expect(clampAvatarTier(99)).toBe(6);
    expect(clampAvatarTier(0)).toBe(1);
    expect(clampAvatarTier(null)).toBe(1);
  });
});

describe("les libellés d'identité, dans les trois langues (R-22)", () => {
  it("⭐ chaque classe et chaque titre est traduit trois fois", () => {
    for (const dict of [fr, en, ar]) {
      for (const code of HERO_CLASSES) {
        expect(dict.dashboard.heroClasses[code].length).toBeGreaterThan(0);
      }
      for (const code of HERO_TITLES) {
        expect(dict.dashboard.heroTitles[code].length).toBeGreaterThan(0);
      }
    }
  });

  it("⭐ la liste du code est celle que la migration contraint", () => {
    const migration = readFileSync(
      join(process.cwd(), "supabase/migrations/20260902190000_hero_identity.sql"),
      "utf8",
    );
    for (const code of HERO_CLASSES) {
      expect(migration.includes(`'${code}'`), `${code} absent de la contrainte SQL`).toBe(true);
    }
  });
});
