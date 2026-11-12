// @vitest-environment node
import { describe, expect, it, vi } from "vitest";

/**
 * Un chunk de langue qui n'arrive pas doit pouvoir être redemandé. La promesse
 * rejetée restait dans le cache `inflight` : une coupure réseau au mauvais moment
 * privait l'élève de sa langue jusqu'au rechargement de la page. Depuis que
 * `router.tsx` attend ce chunk avant d'hydrater (2026-11-12), l'échec est aussi un
 * chemin du DÉMARRAGE — il doit rester rattrapable.
 */
const reseau = vi.hoisted(() => ({ coupe: true, appels: 0 }));

vi.mock("../en", () => {
  reseau.appels += 1;
  if (reseau.coupe) throw new Error("Failed to fetch dynamically imported module");
  return { en: { common: { loading: "Loading…" } } };
});

describe("loadCatalogue — échec de chunk", () => {
  it("rejette, n'enregistre rien, puis réussit à la demande suivante", async () => {
    const { loadCatalogue, loadedCatalogue } = await import("../catalogues");
    await expect(loadCatalogue("en")).rejects.toThrow();
    expect(loadedCatalogue("en")).toBeUndefined();

    reseau.coupe = false;
    vi.resetModules();
    vi.doMock("../en", () => ({ en: { common: { loading: "Loading…" } } }));
    const en = await loadCatalogue("en");
    expect(en.common.loading).toBe("Loading…");
    expect(loadedCatalogue("en")).toBe(en);
  });
});
