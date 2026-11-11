// @vitest-environment node
import { describe, expect, it } from "vitest";

import { ar } from "@/lib/i18n/ar";
import { en } from "@/lib/i18n/en";
import { fr } from "@/lib/i18n/fr";
import { STREAK_RECOVERY_COST } from "@/shared/constants/gamification";

/**
 * UN PRIX NE SE RECOPIE PAS DANS UN CATALOGUE DE TRADUCTION.
 *
 * Les trois catalogues écrivaient « 15 » en toutes lettres dans la phrase du
 * rachat de série. Un prix vit dans `gamification.ts` ; recopié ailleurs, il
 * cesse d'être une constante et devient trois faits qui peuvent diverger — dans
 * trois langues dont deux que personne dans l'équipe ne relit à voix haute.
 *
 * Le jour où le prix change (l'arbitrage A16 est ouvert), le catalogue mentirait
 * en silence : la phrase annoncerait 15 pièces pendant que le serveur en
 * demanderait le double. C'est exactement la forme de #914/#915 et #931 — une
 * surface qui promet ce que le serveur refuse.
 */
const CATALOGUES = [
  ["fr", fr],
  ["en", en],
  ["ar", ar],
] as const;

describe("le prix du rachat de série n'est jamais écrit en dur", () => {
  for (const [locale, dict] of CATALOGUES) {
    it(`${locale} — la phrase porte le gabarit {cost}`, () => {
      expect(dict.dashboard.streakLostDesc).toContain("{cost}");
    });

    it(`${locale} — la phrase ne contient aucun chiffre en dur`, () => {
      // `{n}` et `{cost}` sont des gabarits, pas des chiffres. Tout chiffre
      // ASCII ou arabo-indien restant serait une valeur recopiée.
      const sansGabarits = dict.dashboard.streakLostDesc.replace(/\{[a-z]+\}/g, "");
      expect(sansGabarits).not.toMatch(/[0-9٠-٩]/);
    });
  }

  it("le contrôle négatif : ce détecteur verrait bien un prix recopié", () => {
    const fauteAr = "استرجع سلسلتك مقابل ١٥ عملة (كان لديك {n} أيام)";
    const fauteFr = "Récupère ta série pour 15 pièces (tu avais {n} jours)";
    for (const faute of [fauteFr, fauteAr]) {
      expect(faute.replace(/\{[a-z]+\}/g, "")).toMatch(/[0-9٠-٩]/);
    }
  });

  it("la constante existe et est un entier positif — ce que la phrase interpole", () => {
    expect(Number.isInteger(STREAK_RECOVERY_COST)).toBe(true);
    expect(STREAK_RECOVERY_COST).toBeGreaterThan(0);
  });
});
