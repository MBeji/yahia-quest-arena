import { describe, it, expect } from "vitest";

import { frPublic } from "../fr-public";
import { enPublic } from "../en-public";
import { arPublic } from "../ar-public";

/**
 * Étude 31 lot 6 — LE BANDEAU DE CONVERSION ANONYME (US-10, R-20).
 *
 * L'écran de résultat anonyme invitait déjà à créer un compte, mais sans jamais
 * dire CE QUI N'EST PAS GARDÉ. Un visiteur qui vient de faire 100 % ne sait pas
 * qu'il ne garde rien : il l'apprendra en revenant, quand tout aura disparu.
 *
 * Deux contraintes opposées, et le test tient les deux :
 *
 *   * il doit NOMMER la perte (XP, série, progression) — sinon il n'informe pas ;
 *   * il doit rester formulé en GAIN FUTUR (R-20) : « garder tes prochains XP »,
 *     jamais « tu viens de tout perdre ». Et jamais de compte à rebours ni de
 *     blocage : la pratique reste ouverte sans compte (acquis é22/é24).
 */
const DICTS = [
  ["fr", frPublic, ["XP", "série", "prochains"]],
  ["en", enPublic, ["XP", "streak", "next"]],
  ["ar", arPublic, ["خبرت", "سلسلت", "القادمة"]],
] as const;

describe("bandeau de conversion anonyme (é31 R-20)", () => {
  it("⭐ nomme ce qui n'est pas gardé, dans les trois langues", () => {
    for (const [lang, dict, words] of DICTS) {
      const text = dict.practice.inviteDesc;
      for (const word of words) {
        expect(text.includes(word), `${lang} : « ${word} » attendu dans le bandeau`).toBe(true);
      }
    }
  });

  it("⭐ reste formulé en gain futur — aucun reproche, aucune urgence", () => {
    const banned = [
      "tu as perdu",
      "trop tard",
      "dépêche",
      "you lost",
      "too late",
      "hurry",
      "فات الأوان",
    ];
    for (const [lang, dict] of DICTS) {
      const text = dict.practice.inviteDesc.toLowerCase();
      for (const word of banned) {
        expect(text.includes(word), `${lang} contient « ${word} »`).toBe(false);
      }
    }
  });
});
