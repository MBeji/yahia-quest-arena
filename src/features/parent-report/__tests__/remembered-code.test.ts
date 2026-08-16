import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import {
  SUIVI_CODE_STORAGE_KEY,
  forgetRememberedCode,
  readRememberedCode,
  rememberCode,
} from "../remembered-code";

// Format réel d'un Alliance Code (UUID de l'élève en hex groupé par 4).
const VALID_CODE = "A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D";

describe("remembered-code", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("retient un code et le relit tel quel", () => {
    rememberCode(VALID_CODE);

    expect(localStorage.getItem(SUIVI_CODE_STORAGE_KEY)).toBe(VALID_CODE);
    expect(readRememberedCode()).toBe(VALID_CODE);
  });

  it("nettoie les espaces autour du code collé", () => {
    rememberCode(`  ${VALID_CODE}\n`);

    expect(readRememberedCode()).toBe(VALID_CODE);
  });

  it("ne retient rien tant que le code est hors bornes", () => {
    rememberCode("A1B2");
    expect(readRememberedCode()).toBeNull();

    rememberCode("Z".repeat(65));
    expect(readRememberedCode()).toBeNull();
    expect(localStorage.getItem(SUIVI_CODE_STORAGE_KEY)).toBeNull();
  });

  it("renvoie null quand rien n'a été mémorisé", () => {
    expect(readRememberedCode()).toBeNull();
  });

  it("ignore une valeur altérée à la main dans le stockage", () => {
    localStorage.setItem(SUIVI_CODE_STORAGE_KEY, "  ");

    expect(readRememberedCode()).toBeNull();
  });

  it("oublie le code sur demande", () => {
    rememberCode(VALID_CODE);

    forgetRememberedCode();

    expect(readRememberedCode()).toBeNull();
    expect(localStorage.getItem(SUIVI_CODE_STORAGE_KEY)).toBeNull();
  });

  // Navigation privée / stockage refusé par la politique du navigateur : la page
  // doit rester utilisable, seule la commodité saute.
  it("dégrade en « rien de mémorisé » quand la lecture lève", () => {
    vi.spyOn(Storage.prototype, "getItem").mockImplementation(() => {
      throw new Error("SecurityError: access denied");
    });

    expect(readRememberedCode()).toBeNull();
  });

  it("n'échoue pas quand l'écriture lève (quota, stockage bloqué)", () => {
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new Error("QuotaExceededError");
    });

    expect(() => rememberCode(VALID_CODE)).not.toThrow();
  });

  it("n'échoue pas quand l'effacement lève", () => {
    vi.spyOn(Storage.prototype, "removeItem").mockImplementation(() => {
      throw new Error("SecurityError: access denied");
    });

    expect(() => forgetRememberedCode()).not.toThrow();
  });
});
