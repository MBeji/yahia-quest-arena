// @vitest-environment node
import { describe, expect, it } from "vitest";

import { AI_LIVE_FEATURES } from "@/shared/constants/ai";
import { AI_ACTIVATABLE_FEATURES, studentSurfaces } from "../ai-access.server";

/**
 * L'ÉCRAN DOIT VOIR LES DEUX PAYEURS — le défaut constaté en production le
 * 2026-08-27, clé plateforme posée.
 *
 * `ai_student_access` répond à « la clé de ma famille paie-t-elle cette
 * surface ». L'écran lui demandait « cette surface est-elle ouverte ». Les deux
 * questions ont la même réponse tant que le chemin plateforme dort ; elles
 * divergent à la seconde où `AI_PLATFORM_API_KEY` est posée.
 *
 * Symptôme relevé : la bulle « Le Prof » de #894, chat et Forge cadenassés,
 * affichant « Le mode IA n'est pas encore ouvert sur ce compte » et invitant à
 * brancher une clé de famille — alors que `resolve_ai_access` aurait servi
 * l'élève sur la clé plateforme, et que `preparePlatformCall` n'applique aucun
 * filtre de surface. La configuration était juste ; c'est la lecture qui était
 * borgne.
 *
 * Ces tests tiennent les deux bords, comme `live-features.test.ts` : rien
 * d'ouvert que le SQL refuserait, rien de fermé qu'il aurait servi.
 */

/**
 * CE QUE LA PLATEFORME OUVRE — les surfaces vivantes, MOINS `open_answer`.
 *
 * L'exception est étroite et elle est la seule : `open_answer` (étude 33) ne
 * change pas le payeur d'une surface existante, elle décide si un TYPE DE
 * QUESTION est servi. Poser `AI_PLATFORM_API_KEY` ouvrirait sinon les questions
 * ouvertes à tout le parc d'un coup, sans qu'aucun parent l'ait décidé pour son
 * enfant — et l'écran promettrait alors ce que `can_play_open_questions`
 * refuse, puisque le SQL ne connaît pas la clé plateforme.
 *
 * Le calcul est DÉRIVÉ et non recopié : ajouter une surface vivante l'ajoute
 * ici, et seule une nouvelle exception délibérée fera bouger cette ligne.
 */
const PLATEFORME = AI_LIVE_FEATURES.filter((f) => f !== "open_answer");

describe("studentSurfaces — sans ligne famille", () => {
  it("plateforme éteinte : RIEN, et ce n'est pas une panne (R-1)", () => {
    // L'état par défaut de tout le monde, et le produit y est complet.
    expect(studentSurfaces({ globalEnabled: true, family: null, platformOpen: false })).toEqual({
      enabled: false,
      features: [],
    });
  });

  it("plateforme armée : les surfaces vivantes — LE cas qui était faux", () => {
    // `resolve_ai_access` renvoie `payer = 'platform'` pour TOUT élève sans
    // ligne famille. L'écran doit dire la même chose que le SQL.
    expect(studentSurfaces({ globalEnabled: true, family: null, platformOpen: true })).toEqual({
      enabled: true,
      features: PLATEFORME,
    });
  });

  it("n'ouvre JAMAIS les questions ouvertes sur la seule clé plateforme (é33)", () => {
    // Le miroir exact de `can_play_open_questions`, qui ne lit que la ligne
    // famille. Si cette assertion tombe, l'écran annonce un type de question
    // que le moteur de service retirera — la faute que tout ce fichier
    // documente, dans l'autre sens.
    const { features } = studentSurfaces({
      globalEnabled: true,
      family: null,
      platformOpen: true,
    });
    expect(features).not.toContain("open_answer");
  });

  it("une ligne famille, elle, ouvre bien les questions ouvertes (é33)", () => {
    // L'activation EXPLICITE par élève reste le seul chemin, et il marche.
    const { features } = studentSurfaces({
      globalEnabled: true,
      family: { enabled: true, features: ["open_answer"] },
      platformOpen: true,
    });
    expect(features).toContain("open_answer");
  });

  it("ouvre nommément le chat et la Forge — les deux entrées de la bulle", () => {
    // Les deux clés que lit `ai-launcher.tsx`. Les nommer ici fait échouer ce
    // test si une refonte de la liste les fait tomber, au lieu de laisser la
    // bulle se re-cadenasser en silence.
    const { features } = studentSurfaces({
      globalEnabled: true,
      family: null,
      platformOpen: true,
    });
    expect(features).toContain("chat");
    expect(features).toContain("forge");
  });
});

describe("studentSurfaces — avec une ligne famille", () => {
  it("plateforme éteinte : le comportement d'avant, à l'identique", () => {
    // La non-régression du chemin famille : cette route servait ça, et elle
    // doit continuer de le servir mot pour mot.
    expect(
      studentSurfaces({
        globalEnabled: true,
        family: { enabled: true, features: ["forge", "chat"] },
        platformOpen: false,
      }),
    ).toEqual({ enabled: true, features: ["forge", "chat"] });
  });

  it("une ligne DÉSACTIVÉE n'ouvre rien, plateforme éteinte", () => {
    expect(
      studentSurfaces({
        globalEnabled: true,
        family: { enabled: false, features: ["forge", "chat"] },
        platformOpen: false,
      }),
    ).toEqual({ enabled: false, features: [] });
  });

  it("une ligne désactivée n'EMPÊCHE pas la plateforme", () => {
    // Décocher un élève, c'est dire « ma clé ne le paie pas » — pas « il n'a
    // droit à rien ». Le SQL le renvoie sur la plateforme ; l'écran aussi.
    expect(
      studentSurfaces({
        globalEnabled: true,
        family: { enabled: false, features: [] },
        platformOpen: true,
      }),
    ).toEqual({ enabled: true, features: PLATEFORME });
  });

  it("la plateforme AJOUTE, elle ne retire ni ne double", () => {
    // Une famille qui ne coche que la Forge garde la Forge et gagne le reste,
    // sans que « forge » apparaisse deux fois dans la liste rendue.
    const { features } = studentSurfaces({
      globalEnabled: true,
      family: { enabled: true, features: ["forge"] },
      platformOpen: true,
    });
    expect(features).toEqual(PLATEFORME);
    expect(features.filter((f) => f === "forge")).toHaveLength(1);
  });
});

describe("studentSurfaces — le kill-switch données passe devant", () => {
  it("coupé : rien, même plateforme armée et famille active (les DEUX payeurs)", () => {
    // Étape 1 de `resolve_ai_access` : le mode global coupe avant toute autre
    // question. Un écran qui l'ignorerait ouvrirait une porte que le SQL ferme.
    expect(
      studentSurfaces({
        globalEnabled: false,
        family: { enabled: true, features: ["forge"] },
        platformOpen: true,
      }),
    ).toEqual({ enabled: false, features: [] });
  });
});

describe("studentSurfaces ne promet rien que le serveur refuserait", () => {
  it("n'ouvre que des surfaces ACTIVABLES", () => {
    // Le même invariant que `live-features.test.ts` tient sur l'activation :
    // une surface rendue ici sans écran ni appelant serait une porte vers nulle
    // part, et `resolve_ai_access` la refuserait.
    const { features } = studentSurfaces({
      globalEnabled: true,
      family: { enabled: true, features: ["forge"] },
      platformOpen: true,
    });
    for (const feature of features) {
      expect(AI_ACTIVATABLE_FEATURES as readonly string[]).toContain(feature);
    }
  });
});
