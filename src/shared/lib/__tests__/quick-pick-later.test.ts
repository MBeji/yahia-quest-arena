import { afterEach, describe, expect, it, vi } from "vitest";
import { hasPostponedQuickPick, postponeQuickPick } from "@/shared/lib/quick-pick-later";

afterEach(() => {
  window.sessionStorage.clear();
  vi.restoreAllMocks();
});

/** « Plus tard » sur la carte de classe (étude 38, lot 2) : la session de navigation. */
describe("quick-pick-later", () => {
  it("rien n'est différé par défaut", () => {
    expect(hasPostponedQuickPick()).toBe(false);
  });

  it("« plus tard » tient pour la session de navigation", () => {
    postponeQuickPick();
    expect(hasPostponedQuickPick()).toBe(true);
  });

  // La carte revient à la prochaine visite : rien n'est écrit hors de l'onglet.
  it("n'écrit que dans sessionStorage", () => {
    postponeQuickPick();
    expect(window.localStorage.length).toBe(0);
    expect(document.cookie).toBe("");
  });

  // Navigation privée, iframe : le stockage peut lever. Le sens sûr est « la carte
  // reste montrable », jamais une erreur qui casserait la quête.
  it("stockage refusé : lecture à faux, écriture sans erreur", () => {
    vi.spyOn(Storage.prototype, "getItem").mockImplementation(() => {
      throw new Error("SecurityError");
    });
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new Error("SecurityError");
    });
    expect(hasPostponedQuickPick()).toBe(false);
    expect(() => postponeQuickPick()).not.toThrow();
  });
});
