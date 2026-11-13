import { afterEach, describe, expect, it, vi } from "vitest";
import { readLocal, writeLocal } from "../safe-storage";

/**
 * #1307 — un navigateur qui refuse le stockage voyait l'écran d'erreur à la place du site.
 * Ces fonctions ne lèvent JAMAIS : le refus se lit `null`, une écriture refusée rend `false`.
 */
afterEach(() => {
  vi.restoreAllMocks();
  window.localStorage.clear();
});

describe("readLocal / writeLocal", () => {
  it("lisent et écrivent le localStorage quand il répond", () => {
    expect(readLocal("k")).toBeNull();
    expect(writeLocal("k", "v")).toBe(true);
    expect(readLocal("k")).toBe("v");
    expect(window.localStorage.getItem("k")).toBe("v");
  });

  it("⭐ accès refusé (SecurityError, cookies bloqués) : null, false, aucune exception", () => {
    vi.spyOn(window, "localStorage", "get").mockImplementation(() => {
      throw new DOMException("The operation is insecure.", "SecurityError");
    });
    expect(readLocal("k")).toBeNull();
    expect(writeLocal("k", "v")).toBe(false);
  });

  it("⭐ quota plein : getItem et setItem qui lèvent ne remontent pas", () => {
    vi.spyOn(Storage.prototype, "getItem").mockImplementation(() => {
      throw new DOMException("quota", "QuotaExceededError");
    });
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new DOMException("quota", "QuotaExceededError");
    });
    expect(readLocal("k")).toBeNull();
    expect(writeLocal("k", "v")).toBe(false);
  });
});
