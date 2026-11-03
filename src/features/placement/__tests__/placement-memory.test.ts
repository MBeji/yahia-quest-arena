import { beforeEach, describe, expect, it } from "vitest";

import { PLACEMENT_MEMORY_MAX, PLACEMENT_MEMORY_TTL_MS } from "@/shared/constants/placement";

import {
  PLACEMENT_MEMORY_KEY,
  clearPlacementDraft,
  forgetPlacements,
  lastFinishedPlacement,
  readPlacementDraft,
  readRememberedPlacements,
  rememberPlacement,
  rememberedToken,
  rememberedTokens,
  writePlacementDraft,
} from "../placement-memory";

/**
 * Étude 39 R-15 — la mémoire de l'appareil : cinq tests, trente jours, défensive. Et le brouillon
 * du test en cours, qui survit au rechargement de l'onglet.
 */
const id = (n: number) => `0000000${n}-0000-4000-8000-000000000000`.slice(-36).padStart(36, "0");
const uuid = (n: number) => `${String(n).padStart(8, "0")}-0000-4000-8000-000000000000`;
const entry = (n: number, at: number) => ({
  id: uuid(n),
  token: uuid(100 + n),
  subjectId: "math",
  subjectName: "Maths",
  at,
});

describe("la mémoire des tests (R-15)", () => {
  beforeEach(() => {
    window.localStorage.clear();
    window.sessionStorage.clear();
  });

  it("retient un test et rend son jeton", () => {
    rememberPlacement(entry(1, 1_000), 1_000);
    expect(rememberedToken(uuid(1), 1_000)).toBe(uuid(101));
    expect(rememberedTokens(1_000)).toEqual([uuid(101)]);
    expect(id(1)).toHaveLength(36);
  });

  it("ne garde que les plus récents, dans la limite", () => {
    for (let n = 1; n <= PLACEMENT_MEMORY_MAX + 2; n += 1)
      rememberPlacement(entry(n, n * 1_000), 10_000);
    const kept = readRememberedPlacements(10_000);
    expect(kept).toHaveLength(PLACEMENT_MEMORY_MAX);
    expect(kept[0]?.id).toBe(uuid(PLACEMENT_MEMORY_MAX + 2));
  });

  it("oublie ce qui a plus de trente jours", () => {
    rememberPlacement(entry(1, 0), 0);
    expect(readRememberedPlacements(PLACEMENT_MEMORY_TTL_MS - 1)).toHaveLength(1);
    expect(readRememberedPlacements(PLACEMENT_MEMORY_TTL_MS + 1)).toHaveLength(0);
  });

  it("met à jour un test fini et le rend comme dernier résultat", () => {
    rememberPlacement(entry(1, 1_000), 1_000);
    rememberPlacement(
      { ...entry(1, 1_000), scoreOn20: 14, band: "en-route", finished: true },
      2_000,
    );
    expect(readRememberedPlacements(2_000)).toHaveLength(1);
    expect(lastFinishedPlacement(2_000)?.scoreOn20).toBe(14);
  });

  it("oublie des tests par identifiant (le rattachement)", () => {
    rememberPlacement(entry(1, 1_000), 1_000);
    rememberPlacement(entry(2, 1_000), 1_000);
    forgetPlacements([uuid(1)], 1_000);
    expect(rememberedTokens(1_000)).toEqual([uuid(102)]);
  });

  it("ignore un stockage altéré au lieu de le renvoyer au serveur", () => {
    window.localStorage.setItem(
      PLACEMENT_MEMORY_KEY,
      JSON.stringify([
        { id: "pas-un-uuid", token: "x", subjectId: "math", at: 1 },
        "n'importe quoi",
      ]),
    );
    expect(readRememberedPlacements(1_000)).toEqual([]);
    window.localStorage.setItem(PLACEMENT_MEMORY_KEY, "{pas du json");
    expect(readRememberedPlacements(1_000)).toEqual([]);
  });

  it("refuse de retenir une entrée mal formée", () => {
    rememberPlacement({ ...entry(1, 1_000), token: "pas-un-jeton" }, 1_000);
    expect(readRememberedPlacements(1_000)).toEqual([]);
  });
});

describe("le brouillon du test en cours (US-8)", () => {
  beforeEach(() => window.sessionStorage.clear());

  it("écrit, relit, efface", () => {
    writePlacementDraft(uuid(1), { answers: { q1: "a", q2: "" }, index: 2 });
    expect(readPlacementDraft(uuid(1))).toEqual({ answers: { q1: "a" }, index: 2 });
    clearPlacementDraft(uuid(1));
    expect(readPlacementDraft(uuid(1))).toBeNull();
  });

  it("un brouillon illisible vaut aucun brouillon", () => {
    window.sessionStorage.setItem(`na9ra.placement.draft.${uuid(1)}`, "{{");
    expect(readPlacementDraft(uuid(1))).toBeNull();
  });
});
