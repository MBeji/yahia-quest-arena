import { describe, it, expect } from "vitest";
import {
  ACCOUNT_DELETE_ERROR_PREFIX,
  accountDeleteErrorLabel,
  confirmsAccountEmail,
  normalizeAccountEmail,
} from "../account-deletion";
import type { TranslationKeys } from "@/lib/i18n";

const t = {
  settings: {
    deleteErrors: {
      email_mismatch: "MISMATCH",
      generic: "GENERIC",
    },
  },
} as unknown as TranslationKeys;

describe("normalizeAccountEmail", () => {
  it("ignore la casse et les espaces de bord — un correcteur mobile en ajoute", () => {
    expect(normalizeAccountEmail("  Yahia@Example.TN \n")).toBe("yahia@example.tn");
  });

  it("ne normalise RIEN d'autre : deux adresses distinctes le restent", () => {
    // Retirer les points ou le suffixe « + » rendrait la confirmation plus
    // permissive que l'identité du compte — le geste cesserait de prouver que la
    // personne sait lequel elle efface.
    expect(normalizeAccountEmail("y.ahia@example.tn")).not.toBe(
      normalizeAccountEmail("yahia@example.tn"),
    );
    expect(normalizeAccountEmail("yahia+test@example.tn")).not.toBe(
      normalizeAccountEmail("yahia@example.tn"),
    );
  });
});

describe("confirmsAccountEmail", () => {
  it("accepte l'adresse du compte, quelle que soit la casse", () => {
    expect(confirmsAccountEmail(" YAHIA@example.tn ", "yahia@example.tn")).toBe(true);
  });

  it("refuse une autre adresse", () => {
    expect(confirmsAccountEmail("voisin@example.tn", "yahia@example.tn")).toBe(false);
  });

  it("refuse une saisie vide, même si le compte n'a pas d'adresse", () => {
    // Sans ce garde, `"" === ""` armerait le bouton le plus destructeur de
    // l'application sur un formulaire vide.
    expect(confirmsAccountEmail("", "yahia@example.tn")).toBe(false);
    expect(confirmsAccountEmail("   ", "")).toBe(false);
    expect(confirmsAccountEmail("", null)).toBe(false);
  });

  it("refuse quand le compte n'a pas d'adresse connue", () => {
    expect(confirmsAccountEmail("yahia@example.tn", null)).toBe(false);
  });
});

describe("accountDeleteErrorLabel", () => {
  it("traduit le code de non-correspondance", () => {
    expect(accountDeleteErrorLabel(`${ACCOUNT_DELETE_ERROR_PREFIX}email_mismatch`, t)).toBe(
      "MISMATCH",
    );
  });

  it("retombe sur le générique pour le code générique", () => {
    expect(accountDeleteErrorLabel(`${ACCOUNT_DELETE_ERROR_PREFIX}generic`, t)).toBe("GENERIC");
  });

  it("retombe sur le générique pour un code inconnu ou un message sans préfixe", () => {
    // Une panne réseau ne porte aucun préfixe : elle ne doit pas s'afficher brute.
    expect(accountDeleteErrorLabel(`${ACCOUNT_DELETE_ERROR_PREFIX}martien`, t)).toBe("GENERIC");
    expect(accountDeleteErrorLabel("Failed to fetch", t)).toBe("GENERIC");
  });
});
