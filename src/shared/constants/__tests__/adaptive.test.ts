// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  MASTERY_THRESHOLD,
  GAP_THRESHOLD,
  FRAGILE_THRESHOLD,
  MIN_EVIDENCE,
  MIN_SESSIONS,
  MIN_FORMS,
  EVIDENCE_STALE_DAYS,
  INFERENCE_DAMPING,
  INFERENCE_MAX_DEPTH,
  INFERENCE_CEILING,
  EVIDENCE_WEIGHTS,
  TUTOR_CHECK_WEIGHT,
  ZPD_TARGET,
} from "@/shared/constants/adaptive";

/**
 * Ces tests ne vérifient pas « que le code marche » — un fichier de constantes n'a pas de
 * comportement. Ils verrouillent DEUX choses qu'un futur ajustement casserait sans bruit :
 *
 *  1. les VALEURS exactes du tableau de l'étude 30 §3.2, chacune avec sa provenance ;
 *  2. les RELATIONS entre elles, qui sont le vrai contenu du modèle — le plafond de
 *     l'inférence sous le seuil de maîtrise (R-9), les poids strictement décroissants
 *     (R-21), la ZPD strictement à l'intérieur de [0 ; 1]. Une constante changée seule
 *     passe le point 1 en le mettant à jour ; elle échoue au point 2 si elle rompt le
 *     modèle, et c'est là que le test gagne son coût.
 */
describe("Constantes du tuteur déterministe (étude 30 §3.2)", () => {
  describe("Les bandes de croyance", () => {
    it("le seuil de maîtrise est le 0,95 canonique de Corbett & Anderson", () => {
      expect(MASTERY_THRESHOLD).toBe(0.95);
    });

    it("les trois bandes sont ordonnées : lacune < fragile < maîtrise", () => {
      expect(GAP_THRESHOLD).toBe(0.25);
      expect(FRAGILE_THRESHOLD).toBe(0.6);
      expect(GAP_THRESHOLD).toBeLessThan(FRAGILE_THRESHOLD);
      expect(FRAGILE_THRESHOLD).toBeLessThan(MASTERY_THRESHOLD);
    });

    it("toutes les bandes vivent dans l'intervalle ouvert des croyances", () => {
      for (const p of [MASTERY_THRESHOLD, GAP_THRESHOLD, FRAGILE_THRESHOLD]) {
        expect(p).toBeGreaterThan(0.01);
        expect(p).toBeLessThan(0.99);
      }
    });
  });

  describe("« Répétée et variée » (R-4)", () => {
    it("quatre preuves, deux sessions, deux formes", () => {
      expect(MIN_EVIDENCE).toBe(4);
      expect(MIN_SESSIONS).toBe(2);
      expect(MIN_FORMS).toBe(2);
    });

    it("le minimum de sessions et de formes ne peut pas dépasser le minimum de preuves", () => {
      // Une condition impossible à satisfaire rendrait la maîtrise indéclarable — et le
      // produit dirait « en cours » pour toujours, sans que rien ne signale l'erreur.
      expect(MIN_SESSIONS).toBeLessThanOrEqual(MIN_EVIDENCE);
      expect(MIN_FORMS).toBeLessThanOrEqual(MIN_EVIDENCE);
    });

    it("la fenêtre de fraîcheur est celle des misconceptions de é04", () => {
      expect(EVIDENCE_STALE_DAYS).toBe(30);
    });
  });

  describe("L'inférence (R-7 à R-9)", () => {
    it("γ = 0,70 et la profondeur est bornée à 2", () => {
      expect(INFERENCE_DAMPING).toBe(0.7);
      expect(INFERENCE_MAX_DEPTH).toBe(2);
    });

    it("le plafond de l'inférence est SOUS le seuil de maîtrise (R-9)", () => {
      // L'invariant central du lot 2 : aucune séquence d'inférences ne peut déclarer une
      // maîtrise. S'il tombe, l'attaque du pgTAP tombe avec lui.
      expect(INFERENCE_CEILING).toBe(0.9);
      expect(INFERENCE_CEILING).toBeLessThan(MASTERY_THRESHOLD);
    });

    it("γ amorti sur la profondeur maximale reste au-dessus du seuil de lacune", () => {
      // γ² = 0,49 : une inférence de profondeur 2 depuis une croyance haute reste une
      // information, pas un bruit. En dessous du seuil de lacune elle ne servirait à rien.
      expect(INFERENCE_DAMPING ** INFERENCE_MAX_DEPTH).toBeGreaterThan(GAP_THRESHOLD);
    });
  });

  describe("Le poids de la preuve (R-21)", () => {
    it("sans aide 1,0 · paliers 1-2 0,5 · palier 3 0,25", () => {
      expect(EVIDENCE_WEIGHTS.unaided).toBe(1);
      expect(EVIDENCE_WEIGHTS.tier12).toBe(0.5);
      expect(EVIDENCE_WEIGHTS.tier3).toBe(0.25);
    });

    it("les poids décroissent strictement avec l'aide reçue", () => {
      expect(EVIDENCE_WEIGHTS.unaided).toBeGreaterThan(EVIDENCE_WEIGHTS.tier12);
      expect(EVIDENCE_WEIGHTS.tier12).toBeGreaterThan(EVIDENCE_WEIGHTS.tier3);
      expect(EVIDENCE_WEIGHTS.tier3).toBeGreaterThan(0);
    });

    it("le mini-check du tuteur pèse comme une reprise après les paliers 1-2", () => {
      expect(TUTOR_CHECK_WEIGHT).toBe(0.5);
      expect(TUTOR_CHECK_WEIGHT).toBe(EVIDENCE_WEIGHTS.tier12);
    });
  });

  describe("La zone proximale (§3.4)", () => {
    it("la cible de P(réussite) est [0,55 ; 0,80]", () => {
      expect(ZPD_TARGET.min).toBe(0.55);
      expect(ZPD_TARGET.max).toBe(0.8);
    });

    it("l'intervalle est non vide et strictement à l'intérieur de [0 ; 1]", () => {
      expect(ZPD_TARGET.min).toBeLessThan(ZPD_TARGET.max);
      expect(ZPD_TARGET.min).toBeGreaterThan(0);
      expect(ZPD_TARGET.max).toBeLessThan(1);
    });
  });
});
