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
