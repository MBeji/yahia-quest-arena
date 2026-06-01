import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import type { InventoryItemWithShop } from "@/shared/types/gamification";

// ---------- Buy a shop item ----------
export const purchaseShopItem = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const [profileRes, shopItemRes] = await Promise.all([
      supabase.from("profiles").select("id,yahia_coins").eq("id", userId).single(),
      supabase
        .from("shop_items")
        .select("id,code,name,item_type,description,price_coins,is_active")
        .eq("code", data.itemCode)
        .eq("is_active", true)
        .single(),
    ]);

    if (profileRes.error) throw new Error(profileRes.error.message);
    if (shopItemRes.error) throw new Error(shopItemRes.error.message);

    const profile = profileRes.data;
    const shopItem = shopItemRes.data;

    if ((profile.yahia_coins ?? 0) < shopItem.price_coins) {
      throw new Error("Insufficient XP Coins.");
    }

    const existingInventoryRes = await supabase
      .from("inventory_items")
      .select("id,quantity")
      .eq("student_user_id", userId)
      .eq("shop_item_id", shopItem.id)
      .maybeSingle();
    if (existingInventoryRes.error) throw new Error(existingInventoryRes.error.message);

    if (shopItem.item_type === "skin" && existingInventoryRes.data) {
      throw new Error("This skin is already in your inventory.");
    }

    // Atomic coin deduction — fails if insufficient funds (race-safe)
    const { error: spendErr } = await supabase.rpc("spend_coins", {
      p_user: userId,
      p_coins: shopItem.price_coins,
    });
    if (spendErr) throw new Error(spendErr.message);

    if (existingInventoryRes.data) {
      const inventoryUpdateRes = await supabase
        .from("inventory_items")
        .update({ quantity: existingInventoryRes.data.quantity + 1 })
        .eq("id", existingInventoryRes.data.id)
        .eq("student_user_id", userId);
      if (inventoryUpdateRes.error) throw new Error(inventoryUpdateRes.error.message);
    } else {
      const inventoryInsertRes = await supabase.from("inventory_items").insert({
        student_user_id: userId,
        shop_item_id: shopItem.id,
        quantity: 1,
        is_equipped: false,
      });
      if (inventoryInsertRes.error) throw new Error(inventoryInsertRes.error.message);
    }

    return {
      itemCode: shopItem.code,
      remainingCoins: (profile.yahia_coins ?? 0) - shopItem.price_coins,
      purchasedItemName: shopItem.name,
    };
  });

// ---------- Equip a skin from inventory ----------
export const equipInventorySkin = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const inventoryRes = await supabase
      .from("inventory_items")
      .select("id,shop_item_id,item:shop_items(code,name,item_type,effect_payload)")
      .eq("student_user_id", userId);

    if (inventoryRes.error) throw new Error(inventoryRes.error.message);

    const rows = (inventoryRes.data ?? []) as unknown as InventoryItemWithShop[];
    const inventoryItem = rows.find((row) => row.item?.code === data.itemCode);

    if (!inventoryItem?.item) throw new Error("Item not found in inventory.");
    if (inventoryItem.item.item_type !== "skin") throw new Error("Only skins can be equipped.");

    const skinRows = rows.filter((row) => row.item?.item_type === "skin");
    if (skinRows.length > 0) {
      const resetRes = await supabase
        .from("inventory_items")
        .update({ is_equipped: false })
        .in(
          "id",
          skinRows.map((row) => row.id),
        );
      if (resetRes.error) throw new Error(resetRes.error.message);
    }

    const equipRes = await supabase
      .from("inventory_items")
      .update({ is_equipped: true })
      .eq("id", inventoryItem.id)
      .eq("student_user_id", userId);
    if (equipRes.error) throw new Error(equipRes.error.message);

    const effectPayload = inventoryItem.item.effect_payload;
    const avatarSlug =
      effectPayload !== null && typeof effectPayload === "object" && "avatarSlug" in effectPayload
        ? effectPayload.avatarSlug
        : null;

    if (typeof avatarSlug === "string") {
      const profileRes = await supabase
        .from("profiles")
        .update({ avatar_slug: avatarSlug })
        .eq("id", userId);
      if (profileRes.error) throw new Error(profileRes.error.message);
    }

    return {
      itemCode: inventoryItem.item.code,
      itemName: inventoryItem.item.name,
      avatarSlug: typeof avatarSlug === "string" ? avatarSlug : null,
    };
  });
