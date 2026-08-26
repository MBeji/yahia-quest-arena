// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * LE COMPTEUR D'ÉNERGIE — étude 11 lot 7.
 *
 * CE QUE CES TESTS GARDENT
 * ---------------------------------------------------------------------------
 * Deux invariants, et aucun des deux n'est cosmétique :
 *
 *   1. **On ne recalcule rien.** `left`, `max` et `canRecharge` viennent de
 *      `get_tutor_energy()`. Le jour où quelqu'un écrirait `max - used` dans
 *      l'écran « pour simplifier », les seuils vivraient à deux endroits — la
 *      faute que R-2 a dû réparer après avoir vu son triplet recopié quatre fois.
 *      Le cas `left` incohérent avec `max - used` existe pour ça : il n'a pas
 *      vocation à se produire, il a vocation à faire échouer cette dérive.
 *
 *   2. **Un refus reste un état (R-15).** Les trois server fns appellent des RPC
 *      qui LÈVENT — `Not authenticated.` pour les deux premières, `Unauthorized`
 *      pour la troisième. Aucune ne doit propager : une jauge qui plante emporte
 *      le tableau de bord, un panneau d'admin qui lève laisse une page blanche.
 *
 * Le rendu n'est pas testé ici (fichier `.ts`) : les composants sont exclus de
 * la couverture par `vitest.config.ts`, et ce qui DÉCIDE est déjà pur.
 */

const { USER, mockRpc, mockSupabase } = vi.hoisted(() => {
  // ⚠️ Piège mesuré du poste : une fabrique `vi.mock` qui lit un `const` déclaré
  // plus bas fige le worker au lieu de lever. Tout ce que les mocks consomment
  // passe donc par `vi.hoisted`.
  const rpc = vi.fn();
  return {
    USER: "11111111-1111-4111-8111-111111111111",
    mockRpc: rpc,
    mockSupabase: { rpc },
  };
});

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      inputValidator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: unknown) => {
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: USER } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { rechargeOutcome, tutorEnergyState, type TutorEnergyReading } from "../energy";
import { getTutorCacheStats, getTutorEnergy, rechargeTutorEnergy } from "../tutor.energy.server";

// ---------------------------------------------------------------------------
// 1. Le module pur — les états du compteur
// ---------------------------------------------------------------------------

/** Une journée entamée, plafond de base, aucun indice échangé. */
const base: TutorEnergyReading = { used: 4, bonus: 0, max: 10, left: 6, canRecharge: true };

function state(over: Partial<TutorEnergyReading> = {}) {
  const s = tutorEnergyState({ ...base, ...over });
  if (s.kind !== "known") throw new Error("lecture attendue");
  return s;
}

describe("les trois niveaux, et l'ordre dans lequel ils se testent", () => {
  it("plein : rien n'a été dépensé", () => {
    const s = state({ used: 0, left: 10 });
    expect(s.level).toBe("full");
    expect(s.leftRatio).toBe(1);
  });

  it("entamé : il reste quelque chose, et il en manque", () => {
    expect(state().level).toBe("partial");
  });

  it("vide : il ne reste rien", () => {
    expect(state({ used: 10, left: 0 }).level).toBe("empty");
  });

  it("plafond nul ⇒ VIDE, jamais plein", () => {
    // Un parent peut poser `daily_energy_max = 0` : l'élève a `used = 0` ET
    // `left = 0`. Tester `full` avant `empty` lui dirait « plein » — un mensonge
    // que le premier clic démentirait.
    const s = state({ used: 0, max: 0, left: 0 });
    expect(s.level).toBe("empty");
    expect(s.leftRatio).toBe(0);
  });
});

describe("le module ne recalcule NI `left` NI `max` (le SQL les possède)", () => {
  it("rend `left` tel quel, même quand il contredit `max - used`", () => {
    // Ce cas ne se produit pas en base : il fait échouer la dérive « on peut
    // bien recalculer ça côté écran », qui ferait vivre les seuils à deux
    // endroits.
    const s = state({ used: 5, max: 10, left: 2 });
    expect(s.left).toBe(2);
    expect(s.max).toBe(10);
  });

  it("borne la jauge sans corriger les nombres affichés", () => {
    const s = state({ used: 0, max: 4, left: 9 });
    expect(s.left).toBe(9);
    expect(s.leftRatio).toBe(1);
  });
});

describe("le bouton d'échange : le serveur autorise, l'écran ajoute le besoin", () => {
  it("s'offre quand le compteur est entamé et le plafond dur non atteint", () => {
    const s = state({ canRecharge: true });
    expect(s.cap).toBe("rechargeable");
    expect(s.offerRecharge).toBe(true);
  });

  it("ne s'offre PAS sur un compteur plein — la charge serait prise pour rien", () => {
    // `recharge_tutor_energy()` ne protège que du plafond DUR : à 10/10 elle
    // consommerait bel et bien l'indice. C'est l'écran qui évite l'échange
    // prématuré, et é09 (anti-farm) qui évite le bouton toujours présent.
    expect(state({ used: 0, left: 10 }).offerRecharge).toBe(false);
  });

  it("ne s'offre PAS au plafond dur, même compteur vide — il n'y a rien à gagner", () => {
    const s = state({ used: 30, max: 30, left: 0, bonus: 20, canRecharge: false });
    expect(s.cap).toBe("at-cap");
    expect(s.offerRecharge).toBe(false);
  });

  it("`canRecharge` ne promet PAS une charge d'indice en poche", () => {
    // La RPC ne regarde l'inventaire qu'au moment de l'échange : « pas de
    // charge » est un cas normal du bouton, pas un état à masquer en amont.
    expect(state({ canRecharge: true }).offerRecharge).toBe(true);
  });
});

describe("le bonus du jour", () => {
  it("se signale dès qu'un indice a été échangé", () => {
    const s = state({ bonus: 6, max: 16, left: 12, used: 4 });
    expect(s.boosted).toBe(true);
    expect(s.bonus).toBe(6);
  });

  it("reste muet à zéro", () => {
    expect(state({ bonus: 0 }).boosted).toBe(false);
  });
});

describe("une lecture absente est un ÉTAT, pas un zéro (R-15)", () => {
  it.each([[null], [undefined]])("%s ⇒ inconnu", (input) => {
    expect(tutorEnergyState(input)).toEqual({ kind: "unknown" });
  });
});

// ---------------------------------------------------------------------------
// 2. Le verdict d'un échange — `consumed` fait autorité
// ---------------------------------------------------------------------------

describe("rechargeOutcome : on n'annonce un gain que si quelque chose a bougé", () => {
  it("consommé ⇒ gain, quel que soit le libellé", () => {
    expect(rechargeOutcome({ consumed: true, reason: "OK" })).toBe("recharged");
  });

  it("déjà au plafond ⇒ refus nommé, rien n'a été pris", () => {
    expect(rechargeOutcome({ consumed: false, reason: "AT_CAP" })).toBe("at-cap");
  });

  it("pas de charge ⇒ refus nommé, rien n'a été pris", () => {
    expect(rechargeOutcome({ consumed: false, reason: "NO_ITEM" })).toBe("no-item");
  });

  it("⚠️ `reason: OK` SANS consommation ne devient JAMAIS un gain", () => {
    // Le cas qui justifie de lire `consumed` plutôt que `reason` : annoncer
    // « +3 » à un enfant dont l'indice n'a pas été pris est le seul mensonge que
    // ce module peut produire.
    expect(rechargeOutcome({ consumed: false, reason: "OK" })).toBe("unknown");
  });

  it("un verdict inconnu se dégrade, il ne s'invente pas", () => {
    expect(rechargeOutcome({ consumed: false, reason: "SOMETHING_NEW" })).toBe("unknown");
  });
});

// ---------------------------------------------------------------------------
// 3. Les server fns — R-15 : elles rendent un état, elles ne lèvent pas
// ---------------------------------------------------------------------------

const reading = { used: 4, bonus: 3, max: 13, left: 9, canRecharge: true };

function reply(data: unknown, error: { message: string } | null = null) {
  return { data, error };
}

beforeEach(() => {
  mockRpc.mockReset();
});

describe("getTutorEnergy — un objet JSONB, lu DIRECTEMENT", () => {
  it("rend la lecture telle que la RPC la donne", async () => {
    mockRpc.mockResolvedValue(reply(reading));
    await expect(getTutorEnergy()).resolves.toEqual(reading);
    expect(mockRpc).toHaveBeenCalledWith("get_tutor_energy");
  });

  it("REFUSE une réponse enveloppée dans un tableau", async () => {
    // `get_tutor_energy()` est `RETURNS JSONB`, pas `RETURNS TABLE`. Appliquer
    // ici le `data[0]` de `getAiAdminOverview` rendrait `null` en silence et le
    // compteur resterait vide sans qu'aucune erreur ne soit journalisée. Ce test
    // fige la forme attendue dans le bon sens.
    mockRpc.mockResolvedValue(reply([reading]));
    await expect(getTutorEnergy()).resolves.toBeNull();
  });

  it("rend `null` quand la RPC lève, sans propager", async () => {
    mockRpc.mockResolvedValue(reply(null, { message: "Not authenticated." }));
    await expect(getTutorEnergy()).resolves.toBeNull();
  });

  it("rend `null` sur une forme inattendue plutôt qu'un compteur à moitié lu", async () => {
    mockRpc.mockResolvedValue(reply({ used: 4, max: 10 }));
    await expect(getTutorEnergy()).resolves.toBeNull();
  });
});

describe("rechargeTutorEnergy — trois issues, et deux qui ne prennent rien", () => {
  it("échange réussi : le verdict, l'objet nommé et les compteurs", async () => {
    mockRpc.mockResolvedValue(
      reply({
        consumed: true,
        reason: "OK",
        itemName: "Potion d'indice",
        used: 4,
        max: 13,
        left: 9,
      }),
    );
    await expect(rechargeTutorEnergy()).resolves.toEqual({
      outcome: "recharged",
      itemName: "Potion d'indice",
      count: { used: 4, max: 13, left: 9 },
    });
  });

  it("déjà au plafond : aucun objet nommé, mais les compteurs restent lisibles", async () => {
    mockRpc.mockResolvedValue(
      reply({ consumed: false, reason: "AT_CAP", used: 12, max: 30, left: 18 }),
    );
    await expect(rechargeTutorEnergy()).resolves.toEqual({
      outcome: "at-cap",
      itemName: null,
      count: { used: 12, max: 30, left: 18 },
    });
  });

  it("pas de charge : un refus nommé, pas une panne", async () => {
    mockRpc.mockResolvedValue(
      reply({ consumed: false, reason: "NO_ITEM", used: 4, max: 10, left: 6 }),
    );
    await expect(rechargeTutorEnergy()).resolves.toEqual({
      outcome: "no-item",
      itemName: null,
      count: { used: 4, max: 10, left: 6 },
    });
  });

  it("n'affiche JAMAIS un objet que la RPC dit ne pas avoir pris", async () => {
    // Ceinture et bretelles : si un jour la RPC joignait `itemName` à un refus,
    // la phrase « tu as échangé ta potion » serait comprise comme une perte.
    mockRpc.mockResolvedValue(
      reply({ consumed: false, reason: "AT_CAP", itemName: "Potion", used: 0, max: 30, left: 30 }),
    );
    await expect(rechargeTutorEnergy()).resolves.toMatchObject({ itemName: null });
  });

  it("une panne rend un état inconnu sans compteurs, et ne lève pas", async () => {
    mockRpc.mockResolvedValue(reply(null, { message: "boom" }));
    await expect(rechargeTutorEnergy()).resolves.toEqual({
      outcome: "unknown",
      itemName: null,
      count: null,
    });
  });
});

describe("getTutorCacheStats — la fenêtre voyage, et un zéro ne s'invente pas", () => {
  it("passe la fenêtre demandée à la RPC", async () => {
    mockRpc.mockResolvedValue(reply({ hitRate: 0.62, discardRate: 0.08 }));
    await getTutorCacheStats({ data: { days: 7 } });
    expect(mockRpc).toHaveBeenCalledWith("get_tutor_cache_stats", { p_days: 7 });
  });

  it("applique 30 jours par défaut, comme les autres agrégats de la console", async () => {
    mockRpc.mockResolvedValue(reply({ hitRate: 0.62, discardRate: 0.08 }));
    await getTutorCacheStats({ data: {} });
    expect(mockRpc).toHaveBeenCalledWith("get_tutor_cache_stats", { p_days: 30 });
  });

  it("garde les détails absents ABSENTS — surtout pas à zéro", async () => {
    mockRpc.mockResolvedValue(reply({ hitRate: 0.62, discardRate: 0.08 }));
    const out = await getTutorCacheStats({ data: {} });
    expect(out).toMatchObject({ hitRate: 0.62, discardRate: 0.08 });
    expect(out?.hits).toBeUndefined();
    expect(out?.days).toBeUndefined();
  });

  it("⚠️ un TAUX manquant rend `null`, jamais « 0 % »", async () => {
    // Un `.catch(0)` sur les taux afficherait « 0 % » pour toujours le jour où
    // un nom de clé dériverait entre la migration et ce schéma — sans erreur
    // nulle part. Un aveu se corrige, un zéro silencieux se croit.
    mockRpc.mockResolvedValue(reply({ hit_rate: 0.62, discard_rate: 0.08 }));
    await expect(getTutorCacheStats({ data: {} })).resolves.toBeNull();
  });

  it("un non-admin obtient `null`, pas une exception", async () => {
    mockRpc.mockResolvedValue(reply(null, { message: "Unauthorized" }));
    await expect(getTutorCacheStats({ data: {} })).resolves.toBeNull();
  });

  it("R-15.3 : le taux d'ÉVICTION voyage avec ses deux compteurs", async () => {
    // « Le taux d'éviction est un indicateur de la console admin » (é29 R-15.3).
    // Il ne se lit jamais seul : `evictedRows` sur `sharedRows`, sinon on ne sait
    // pas si 20 % vient de 1 sortie sur 5 ou de 200 sur 1 000.
    mockRpc.mockResolvedValue(
      reply({
        hitRate: 0.62,
        discardRate: 0.08,
        evictionRate: 0.667,
        evictedRows: 2,
        sharedRows: 3,
      }),
    );
    const out = await getTutorCacheStats({ data: {} });
    expect(out).toMatchObject({ evictionRate: 0.667, evictedRows: 2, sharedRows: 3 });
  });

  it("⭐ R-15.3 : une base EN RETARD n'éteint pas tout le panneau", async () => {
    // Ce panneau est déployé par Vercel pendant que `db-migrate-prod` applique la
    // migration : les deux courent en parallèle sur le même merge. Si
    // `evictionRate` était exigé comme les deux autres taux, la RPC d'avant la
    // migration ferait rendre `null` — donc « mesure indisponible » sur le
    // hit-rate ET sur le rebut, qui eux marchaient très bien.
    mockRpc.mockResolvedValue(reply({ hitRate: 0.62, discardRate: 0.08 }));
    const out = await getTutorCacheStats({ data: {} });
    expect(out).toMatchObject({ hitRate: 0.62, discardRate: 0.08 });
    expect(out?.evictionRate).toBeUndefined();
  });
});
