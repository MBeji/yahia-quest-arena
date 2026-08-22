import { describe, expect, it } from "vitest";

import {
  AI_FEATURES,
  AI_INTERNAL_FEATURES,
  AI_LIVE_FEATURES,
  AI_MAX_TOKENS,
  type AiFeature,
} from "@/shared/constants/ai";
import { AI_ACTIVATABLE_FEATURES } from "../ai-access.server";

/**
 * UNE SURFACE PROPOSÉE EST UNE SURFACE QUI EXISTE.
 *
 * `AI_FEATURES` est le vocabulaire de l'étude, é11 compris : il sert à la
 * comptabilité, aux bornes de tokens et au CHECK en base. Le panneau
 * d'activation s'en servait pour dresser la liste des interrupteurs — et
 * proposait donc « Explication », « Chat », « Bilans », qu'aucun écran ne
 * consomme. Un parent cochait, rien ne s'allumait, et il en concluait que le
 * mode était cassé.
 *
 * C'est la même faute que l'écran qui n'annonçait que deux fournisseurs quand
 * le moteur en acceptait n'importe lequel : un écran qui promet ce que le
 * moteur ne fait pas. Ces tests sont là pour qu'elle ne revienne pas par
 * l'autre bout — un lot d'é11 qui ajouterait sa surface à `AI_LIVE_FEATURES`
 * sans livrer son écran.
 */

describe("AI_LIVE_FEATURES est un sous-ensemble discipliné", () => {
  it("ne contient que des surfaces du vocabulaire", () => {
    for (const feature of AI_LIVE_FEATURES) {
      expect(AI_FEATURES).toContain(feature);
    }
  });

  it("ne contient AUCUNE surface interne", () => {
    // `verify` et `forge_solve` sont émises par le produit lui-même. Les
    // proposer laisserait un parent « activer » la vérification de sa propre
    // clé, ce qui ne veut rien dire.
    for (const internal of AI_INTERNAL_FEATURES) {
      expect(AI_LIVE_FEATURES as readonly AiFeature[]).not.toContain(internal);
    }
  });

  it("porte une borne de tokens pour chaque surface proposée", () => {
    // Une surface sans plafond de sortie serait une surface sans R-10.
    for (const feature of AI_LIVE_FEATURES) {
      expect(AI_MAX_TOKENS[feature]).toBeGreaterThan(0);
    }
  });

  it("n'annonce que la Forge au 2026-08-22", () => {
    // Ce test échouera le jour où un lot d'é11 ajoutera sa surface — c'est
    // voulu : le faire passer oblige à relire ce fichier, donc à vérifier que
    // l'écran existe vraiment avant d'élargir la liste.
    expect([...AI_LIVE_FEATURES]).toEqual(["forge"]);
  });
});

describe("le SERVEUR applique la même liste que l'écran", () => {
  it("n'accepte à l'activation que ce que l'écran propose", () => {
    // Sans cette égalité, une requête forgée inscrirait en base l'activation
    // d'une surface sans écran : `resolve_ai_access` accorderait alors un accès
    // vers nulle part, et la comptabilité porterait une ligne inexplicable.
    expect([...AI_ACTIVATABLE_FEATURES]).toEqual([...AI_LIVE_FEATURES]);
  });
});
