import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";

import {
  PRODUCT_EVENT_CATALOGUE,
  trackProductEvent,
  type ProductEventName,
} from "../product-events";

vi.mock("../product-analytics", () => ({ captureProductEvent: vi.fn() }));
import { captureProductEvent } from "../product-analytics";

/**
 * Étude 31 lot 1 — la LISTE FERMÉE des événements produit (§3.6).
 *
 * Ce fichier garde trois propriétés dont la perte serait silencieuse :
 *
 *   1. ⭐ LA LISTE EST CELLE DE L'ÉTUDE, exactement. Le stop-point du lot 1 dit
 *      « aucun événement au-delà de la liste fermée » : un ajout discret ne doit
 *      pas passer une revue de diff, il doit casser un test.
 *   2. ⭐ UN ÉVÉNEMENT DÉCLARÉ « live » EST RÉELLEMENT ÉMIS quelque part. C'est
 *      la panne dont l'étude fait le constat n° 4 (« 9 badges sur 13 sont
 *      morts ») transposée à l'instrumentation : déclarer sans câbler produit un
 *      funnel plein de zéros qu'on croit vrais.
 *   3. ZÉRO PII. Aucune propriété ne doit s'appeler comme une identité.
 */

/** La liste §3.6, recopiée à la main depuis l'étude — c'est le point de comparaison. */
const ETUDE_31_CLOSED_LIST: ProductEventName[] = [
  "signup",
  "onboarding_completed",
  "quest_completed",
  "level_up",
  "badge_earned",
  "daily_missions_completed",
  "duel_finished",
  "league_awarded",
  "shop_purchase",
  "streak_recovered",
  "push_optin",
  "push_optout",
];

const SRC = join(process.cwd(), "src");

/** Tous les fichiers de `src/`, sauf le catalogue lui-même et les tests. */
function sourceFiles(dir: string, out: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      if (entry === "__tests__") continue;
      sourceFiles(full, out);
    } else if (/\.(ts|tsx)$/.test(entry) && entry !== "product-events.ts") {
      out.push(full);
    }
  }
  return out;
}

describe("catalogue des événements produit (é31 §3.6)", () => {
  it("⭐ contient exactement la liste fermée de l'étude — ni plus, ni moins", () => {
    const names = PRODUCT_EVENT_CATALOGUE.map((e) => e.name);
    expect([...names].sort()).toEqual([...ETUDE_31_CLOSED_LIST].sort());
    // Pas de doublon : un nom en double fausserait tout comptage en aval.
    expect(new Set(names).size).toBe(names.length);
  });

  it("décrit où chaque événement part — une instrumentation qu'on ne voit pas n'existe pas", () => {
    for (const entry of PRODUCT_EVENT_CATALOGUE) {
      expect(entry.fires.length).toBeGreaterThan(10);
      // Un événement pas encore câblé DIT quel lot le câblera.
      if (!entry.live) expect(entry.note ?? "").not.toBe("");
    }
  });

  it("⭐ tout événement déclaré câblé est réellement émis dans le code", () => {
    const files = sourceFiles(SRC);
    const corpus = files.map((f) => readFileSync(f, "utf8")).join("\n");
    for (const entry of PRODUCT_EVENT_CATALOGUE.filter((e) => e.live)) {
      expect(
        corpus.includes(`trackProductEvent("${entry.name}"`),
        `${entry.name} est annoncé câblé mais aucun appel ne l'émet`,
      ).toBe(true);
    }
  });

  it("un événement NON câblé n'est pas émis en douce (sinon il serait « live »)", () => {
    const files = sourceFiles(SRC);
    const corpus = files.map((f) => readFileSync(f, "utf8")).join("\n");
    for (const entry of PRODUCT_EVENT_CATALOGUE.filter((e) => !e.live)) {
      expect(
        corpus.includes(`trackProductEvent("${entry.name}"`),
        `${entry.name} est émis alors que le catalogue le dit non câblé`,
      ).toBe(false);
    }
  });
});

describe("trackProductEvent", () => {
  beforeEach(() => vi.mocked(captureProductEvent).mockClear());
  afterEach(() => vi.restoreAllMocks());

  it("délègue au transport anonyme de PostHog", () => {
    trackProductEvent("quest_completed", { subject_id: "math-9eme", passed: true });
    expect(captureProductEvent).toHaveBeenCalledWith("quest_completed", {
      subject_id: "math-9eme",
      passed: true,
    });
  });

  it("passe sans propriétés quand il n'y a rien de technique à joindre", () => {
    trackProductEvent("push_optin");
    expect(captureProductEvent).toHaveBeenCalledWith("push_optin", undefined);
  });

  it("⭐ aucun appel du code ne joint une propriété d'identité (zéro PII, D-1)", () => {
    const banned = /\b(email|e_mail|user_id|userId|display_name|displayName|full_name|phone)\b/;
    const files = sourceFiles(SRC);
    for (const file of files) {
      const src = readFileSync(file, "utf8");
      // Chaque appel, avec son bloc de propriétés jusqu'à la parenthèse fermante.
      for (const call of src.matchAll(/trackProductEvent\((?:[^()]|\{[^{}]*\})*\)/g)) {
        expect(banned.test(call[0]), `${file} : ${call[0]}`).toBe(false);
      }
    }
  });
});
