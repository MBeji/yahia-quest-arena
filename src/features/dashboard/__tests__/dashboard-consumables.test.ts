import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
        const wrapped = async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({
            data,
            context: {
              supabase: mockSupabase,
              userId: "user-123",
              claims: { sub: "user-123", user_metadata: { display_name: "Yahia" } },
            },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

// ---- Query chain helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  Object.assign(chain, result);
  return chain;
}

describe("getDashboardSecondary — shield arming slots (#consumables step 2)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("marks both shields as armable with the correct arming slot and surfaces the armed one", async () => {
    const inventory = [
      {
        quantity: 1,
        is_equipped: false,
        is_active: false,
        acquired_at: "2026-06-03",
        item: {
          id: "s1",
          code: "shield_retry",
          name: "Bouclier de Réessai",
          item_type: "shield",
          description: "retry",
          price_coins: 60,
          effect_payload: { retries: 1 },
        },
      },
      {
        quantity: 1,
        is_equipped: false,
        is_active: true,
        acquired_at: "2026-06-03",
        item: {
          id: "s2",
          code: "bouclier_flamme",
          name: "Bouclier de Flamme",
          item_type: "shield",
          description: "streak",
          price_coins: 250,
          effect_payload: { streakShield: 1 },
        },
      },
    ];
    const shopItems = [
      {
        id: "s1",
        code: "shield_retry",
        name: "Bouclier de Réessai",
        item_type: "shield",
        description: "retry",
        price_coins: 60,
        is_active: true,
        effect_payload: { retries: 1 },
      },
      {
        id: "s2",
        code: "bouclier_flamme",
        name: "Bouclier de Flamme",
        item_type: "shield",
        description: "streak",
        price_coins: 250,
        is_active: true,
        effect_payload: { streakShield: 1 },
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "student_badges") return mockQuery([]);
      if (table === "inventory_items") return mockQuery(inventory);
      if (table === "shop_items") return mockQuery(shopItems);
      return mockQuery([]);
    });

    const { getDashboardSecondary } = await import("@/features/dashboard");
    const result = await (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    const inv = res.inventory as Array<{
      code: string;
      isArmable: boolean;
      armSlot: string | null;
      isActive: boolean;
    }>;
    const retry = inv.find((i) => i.code === "shield_retry");
    const streak = inv.find((i) => i.code === "bouclier_flamme");
    // Retry shield arms into the next-quest slot; streak shield is a passive slot.
    expect(retry?.isArmable).toBe(true);
    expect(retry?.armSlot).toBe("next-quest");
    expect(streak?.isArmable).toBe(true);
    expect(streak?.armSlot).toBe("passive");
    // The passive streak shield is currently armed; the retry shield is not.
    expect(streak?.isActive).toBe(true);
    expect(retry?.isActive).toBe(false);

    const shop = res.shopItems as Array<{
      code: string;
      isArmable: boolean;
      armSlot: string | null;
    }>;
    expect(shop.find((i) => i.code === "shield_retry")?.armSlot).toBe("next-quest");
    expect(shop.find((i) => i.code === "bouclier_flamme")?.armSlot).toBe("passive");
  });

  it("leaves non-armable items (skins) with a null arming slot", async () => {
    const inventory = [
      {
        quantity: 1,
        is_equipped: true,
        is_active: false,
        acquired_at: "2026-06-03",
        item: {
          id: "k1",
          code: "skin_samourai",
          name: "Skin Samourai",
          item_type: "skin",
          description: "cosmetic",
          price_coins: 500,
          effect_payload: { avatarSlug: "samurai-neon" },
        },
      },
    ];

    mockFrom.mockImplementation((table: string) => {
      if (table === "student_badges") return mockQuery([]);
      if (table === "inventory_items") return mockQuery(inventory);
      if (table === "shop_items") return mockQuery([]);
      return mockQuery([]);
    });

    const { getDashboardSecondary } = await import("@/features/dashboard");
    const result = await (getDashboardSecondary as unknown as (d?: unknown) => Promise<unknown>)();

    const res = result as Record<string, unknown>;
    const inv = res.inventory as Array<{
      code: string;
      isArmable: boolean;
      armSlot: string | null;
    }>;
    const skin = inv.find((i) => i.code === "skin_samourai");
    expect(skin?.isArmable).toBe(false);
    expect(skin?.armSlot).toBeNull();
  });
});
