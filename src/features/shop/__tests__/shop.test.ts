import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks ----
// Shop mutations now go through SECURITY DEFINER RPCs (purchase_shop_item /
// equip_inventory_skin); the server fns are thin wrappers, so we mock supabase.rpc.
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
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
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

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

// Dispatch rpc responses by function name.
function rpcResponder(map: Record<string, { data: unknown; error: unknown }>) {
  return (fn: string) => map[fn] ?? { data: null, error: null };
}

describe("shop — purchaseShopItem", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("returns purchase result mapped from the RPC payload", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        purchase_shop_item: {
          data: { item_code: "potion_hp", remaining_coins: 70, purchased_item_name: "HP Potion" },
          error: null,
        },
      }),
    );

    const { purchaseShopItem } = await import("@/features/shop");
    const result = await (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({
      itemCode: "potion_hp",
    });

    const res = result as Record<string, unknown>;
    expect(res.itemCode).toBe("potion_hp");
    expect(res.remainingCoins).toBe(70);
    expect(res.purchasedItemName).toBe("HP Potion");
    expect(mockRpc).toHaveBeenCalledWith("purchase_shop_item", { p_item_code: "potion_hp" });
  });

  it("surfaces the RPC error on insufficient coins", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        purchase_shop_item: { data: null, error: { message: "Insufficient XP Coins." } },
      }),
    );

    const { purchaseShopItem } = await import("@/features/shop");
    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "skin_gold" }),
    ).rejects.toThrow("Impossible de finaliser l'achat.");
  });

  it("surfaces the RPC error when a skin is already owned", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        purchase_shop_item: {
          data: null,
          error: { message: "This skin is already in your inventory." },
        },
      }),
    );

    const { purchaseShopItem } = await import("@/features/shop");
    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "skin_gold" }),
    ).rejects.toThrow("Impossible de finaliser l'achat.");
  });

  it("rejects empty itemCode (input validation)", async () => {
    const { purchaseShopItem } = await import("@/features/shop");
    await expect(
      (purchaseShopItem as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "" }),
    ).rejects.toThrow();
  });
});

describe("shop — equipInventorySkin", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("equips a skin and returns the avatar slug from the RPC", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        equip_inventory_skin: {
          data: { item_code: "skin_dragon", item_name: "Dragon Skin", avatar_slug: "dragon" },
          error: null,
        },
      }),
    );

    const { equipInventorySkin } = await import("@/features/shop");
    const result = await (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({
      itemCode: "skin_dragon",
    });

    const res = result as Record<string, unknown>;
    expect(res.itemCode).toBe("skin_dragon");
    expect(res.itemName).toBe("Dragon Skin");
    expect(res.avatarSlug).toBe("dragon");
    expect(mockRpc).toHaveBeenCalledWith("equip_inventory_skin", { p_item_code: "skin_dragon" });
  });

  it("surfaces the RPC error when the item is not a skin", async () => {
    mockRpc.mockImplementation(
      rpcResponder({
        equip_inventory_skin: { data: null, error: { message: "Only skins can be equipped." } },
      }),
    );

    const { equipInventorySkin } = await import("@/features/shop");
    await expect(
      (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "potion" }),
    ).rejects.toThrow("Impossible d'équiper cet objet.");
  });

  it("rejects empty itemCode (input validation)", async () => {
    const { equipInventorySkin } = await import("@/features/shop");
    await expect(
      (equipInventorySkin as unknown as (d: unknown) => Promise<unknown>)({ itemCode: "" }),
    ).rejects.toThrow();
  });
});
