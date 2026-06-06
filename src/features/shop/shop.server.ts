import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";

function asRecord(value: unknown): Record<string, unknown> {
  return value && typeof value === "object" ? (value as Record<string, unknown>) : {};
}

// ---------- Buy a shop item ----------
// All validation, coin deduction and inventory writes happen atomically inside
// the `purchase_shop_item` SECURITY DEFINER RPC; the client cannot write
// inventory directly (INSERT/UPDATE revoked at the DB layer).
export const purchaseShopItem = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `purchase_${userId}`, 10, 10_000)) {
      throw new Error("Too many purchases. Please slow down.");
    }

    const { data: result, error } = await supabase.rpc("purchase_shop_item", {
      p_item_code: data.itemCode,
    });
    if (error) {
      failWithClientError("shop.purchaseShopItem", error, "Impossible de finaliser l'achat.");
    }

    const row = asRecord(result);
    return {
      itemCode: typeof row.item_code === "string" ? row.item_code : data.itemCode,
      remainingCoins: Number(row.remaining_coins ?? 0),
      purchasedItemName: typeof row.purchased_item_name === "string" ? row.purchased_item_name : "",
    };
  });

// ---------- Equip a skin from inventory ----------
// Ownership check, equip toggle and avatar update are performed atomically in
// the `equip_inventory_skin` SECURITY DEFINER RPC.
export const equipInventorySkin = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: result, error } = await supabase.rpc("equip_inventory_skin", {
      p_item_code: data.itemCode,
    });
    if (error) {
      failWithClientError("shop.equipInventorySkin", error, "Impossible d'équiper cet objet.");
    }

    const row = asRecord(result);
    return {
      itemCode: typeof row.item_code === "string" ? row.item_code : data.itemCode,
      itemName: typeof row.item_name === "string" ? row.item_name : "",
      avatarSlug: typeof row.avatar_slug === "string" ? row.avatar_slug : null,
    };
  });

// ---------- Arm a consumable (potion or shield) ----------
// Ownership + "armable only" validation and the two-slot toggle happen atomically
// in the `activate_inventory_item` SECURITY DEFINER RPC. Items arm into one of two
// independent slots derived from the effect payload:
//   * "next-quest": multiplier potions + retry shield — applied to the next quest,
//     one armed at a time.
//   * "passive": streak shield — protects a missed day automatically, armed
//     independently of the next-quest slot.
export const activateInventoryItem = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: result, error } = await supabase.rpc("activate_inventory_item", {
      p_item_code: data.itemCode,
    });
    if (error) {
      failWithClientError("shop.activateInventoryItem", error, "Impossible d'activer cet objet.");
    }

    const row = asRecord(result);
    return {
      itemCode: typeof row.item_code === "string" ? row.item_code : data.itemCode,
      itemName: typeof row.item_name === "string" ? row.item_name : "",
      slot: row.slot === "passive" ? ("passive" as const) : ("next-quest" as const),
      isActive: row.is_active === true,
    };
  });
