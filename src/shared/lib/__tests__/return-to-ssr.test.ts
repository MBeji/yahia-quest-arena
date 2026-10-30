// @vitest-environment node
import { describe, it, expect } from "vitest";
import { consumeReturnTo, peekReturnTo, rememberCurrentPage, rememberReturnTo } from "../return-to";

/** Au rendu serveur il n'y a ni `window` ni `localStorage` : aucune de ces fonctions ne doit lever. */
describe("return-to au rendu serveur", () => {
  it("ne retient rien, ne rend rien, ne lève jamais", () => {
    expect(rememberReturnTo("/chapitre/c1")).toBe(false);
    expect(rememberCurrentPage()).toBe(false);
    expect(peekReturnTo()).toBeNull();
    expect(consumeReturnTo()).toBeNull();
  });
});
