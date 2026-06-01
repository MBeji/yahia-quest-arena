import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

vi.mock("@tanstack/react-start", () => ({
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
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));

// ---- Query chain helper ----
function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.insert = vi.fn().mockReturnValue({ ...result, select: vi.fn().mockReturnValue(chain) });
  chain.update = vi.fn().mockReturnValue(chain);
  chain.in = vi.fn().mockReturnValue(result);
  Object.assign(chain, result);
  return chain;
}

describe("gamification.shop — purchaseShopItem", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns purchase result with remaining coins", async () => {
    const profile = { id: "user-123", yahia_coins: 100 };
    const shopItem = {
      id: "item-id",
      code: "potion_hp",
      name: "HP Potion",
      item_type: "consumable",
      description: "Heals",
      price_coins: 30,
      is_active: true,
    };

    let callCount = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "shop_items") return mockQuery(shopItem);
      if (table === "inventory_items") {
        callCount++;
        if (callCount <= 1) return mockQuery(null); // maybeSingle returns null (not owned yet)
        return mockQuery(null); // insert
      }
      return mockQuery(null);
    });
    mockRpc.mockReturnValue({ data: null, error: null }); // spend_coins

    const { purchaseShopItem } = await import("@/lib/gamification.shop");
    const result = await (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({
      itemCode: "potion_hp",
    });

    const res = result as Record<string, unknown>;
    expect(res.itemCode).toBe("potion_hp");
    expect(res.remainingCoins).toBe(70);
    expect(res.purchasedItemName).toBe("HP Potion");
  });

  it("throws on insufficient coins", async () => {
    const profile = { id: "user-123", yahia_coins: 10 };
    const shopItem = {
      id: "item-id",
      code: "skin_gold",
      name: "Gold Skin",
      item_type: "skin",
      description: null,
      price_coins: 500,
      is_active: true,
    };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "shop_items") return mockQuery(shopItem);
      return mockQuery(null);
    });

    const { purchaseShopItem } = await import("@/lib/gamification.shop");

    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "skin_gold" }),
    ).rejects.toThrow("Insufficient XP Coins");
  });

  it("throws when skin already owned", async () => {
    const profile = { id: "user-123", yahia_coins: 1000 };
    const shopItem = {
      id: "item-id",
      code: "skin_gold",
      name: "Gold Skin",
      item_type: "skin",
      description: null,
      price_coins: 500,
      is_active: true,
    };
    const existingInventory = { id: "inv-1", quantity: 1 };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "shop_items") return mockQuery(shopItem);
      if (table === "inventory_items") return mockQuery(existingInventory);
      return mockQuery(null);
    });

    const { purchaseShopItem } = await import("@/lib/gamification.shop");

    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "skin_gold" }),
    ).rejects.toThrow("already in your inventory");
  });

  it("throws on profile fetch error", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(null, { message: "Profile error" });
      return mockQuery(null);
    });

    const { purchaseShopItem } = await import("@/lib/gamification.shop");

    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "test" }),
    ).rejects.toThrow("Profile error");
  });

  it("throws on spend_coins RPC failure", async () => {
    const profile = { id: "user-123", yahia_coins: 100 };
    const shopItem = {
      id: "item-id",
      code: "potion",
      name: "Potion",
      item_type: "consumable",
      description: null,
      price_coins: 10,
      is_active: true,
    };

    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") return mockQuery(profile);
      if (table === "shop_items") return mockQuery(shopItem);
      if (table === "inventory_items") return mockQuery(null); // not owned
      return mockQuery(null);
    });
    mockRpc.mockReturnValue({ data: null, error: { message: "Insufficient funds" } });

    const { purchaseShopItem } = await import("@/lib/gamification.shop");

    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "potion" }),
    ).rejects.toThrow("Insufficient funds");
  });
});

describe("gamification.shop — equipInventorySkin", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("throws when item not in inventory", async () => {
    mockFrom.mockImplementation(() => mockQuery([])); // empty inventory

    const { equipInventorySkin } = await import("@/lib/gamification.shop");

    await expect(
      (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({
        itemCode: "nonexistent",
      }),
    ).rejects.toThrow("Item not found in inventory");
  });

  it("throws when item is not a skin", async () => {
    const inventoryRows = [
      {
        id: "inv-1",
        shop_item_id: "shop-1",
        item: { code: "potion", name: "Potion", item_type: "consumable", effect_payload: null },
      },
    ];
    mockFrom.mockImplementation(() => mockQuery(inventoryRows));

    const { equipInventorySkin } = await import("@/lib/gamification.shop");

    await expect(
      (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "potion" }),
    ).rejects.toThrow("Only skins can be equipped");
  });

  it("equips skin and returns item code with avatar slug", async () => {
    const inventoryRows = [
      {
        id: "inv-1",
        shop_item_id: "shop-1",
        item: {
          code: "skin_dragon",
          name: "Dragon Skin",
          item_type: "skin",
          effect_payload: { avatarSlug: "dragon" },
        },
      },
    ];

    const chainMock = mockQuery(inventoryRows);
    // For update calls, return success
    chainMock.update = vi.fn().mockReturnValue({
      eq: vi.fn().mockReturnValue({
        eq: vi.fn().mockReturnValue({ data: null, error: null }),
        data: null,
        error: null,
      }),
      in: vi.fn().mockReturnValue({ data: null, error: null }),
      data: null,
      error: null,
    });

    mockFrom.mockImplementation(() => chainMock);

    const { equipInventorySkin } = await import("@/lib/gamification.shop");
    const result = await (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({
      itemCode: "skin_dragon",
    });

    const res = result as Record<string, unknown>;
    expect(res.itemCode).toBe("skin_dragon");
    expect(res.avatarSlug).toBe("dragon");
  });
});

describe("gamification.shop — input validation", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("rejects empty itemCode for purchaseShopItem", async () => {
    const { purchaseShopItem } = await import("@/lib/gamification.shop");

    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "" }),
    ).rejects.toThrow();
  });

  it("rejects empty itemCode for equipInventorySkin", async () => {
    const { equipInventorySkin } = await import("@/lib/gamification.shop");

    await expect(
      (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "" }),
    ).rejects.toThrow();
  });
});
