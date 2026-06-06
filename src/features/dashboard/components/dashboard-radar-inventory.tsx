import { Backpack, Trophy } from "lucide-react";
import { PolarAngleAxis, PolarGrid, Radar, RadarChart, ResponsiveContainer } from "recharts";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { avatarEmojiForSlug } from "@/shared/lib/avatar";

type RadarPoint = {
  subject: string;
  value: number;
};

type InventoryItem = {
  code: string;
  name: string;
  itemType: string;
  quantity: number;
  isEquipped: boolean;
  isArmable: boolean;
  armSlot: "next-quest" | "passive" | null;
  isActive: boolean;
};

/** Armed-badge label per arming slot (passive streak shield vs next-quest item). */
function armedLabel(armSlot: "next-quest" | "passive" | null): string {
  return armSlot === "passive" ? "Actif · protège ta série" : "Actif · prochaine quête";
}

type DashboardRadarInventoryProps = {
  radarData: RadarPoint[];
  inventory: InventoryItem[];
  /** Currently equipped cosmetic skin slug (`profiles.avatar_slug`), if any. */
  avatarSlug?: string | null;
  /** Fallback initials shown when no skin is equipped. */
  displayName?: string;
  isActivatePending: boolean;
  onActivate: (itemCode: string) => void;
};

export function DashboardRadarInventory({
  radarData,
  inventory,
  avatarSlug,
  displayName,
  isActivatePending,
  onActivate,
}: DashboardRadarInventoryProps) {
  const avatarEmoji = avatarEmojiForSlug(avatarSlug);
  const initials = (displayName ?? "").trim().slice(0, 2).toUpperCase() || "?";
  return (
    <>
      <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
        <Trophy className="h-5 w-5 text-[color:var(--neon-gold)]" /> Success Radar
      </h2>
      <div className="rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
        <div className="h-72 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <RadarChart data={radarData}>
              <PolarGrid stroke="oklch(0.66 0.27 295 / 0.25)" />
              <PolarAngleAxis
                dataKey="subject"
                tick={{ fill: "oklch(0.72 0.04 270)", fontSize: 11 }}
              />
              <Radar
                name="Mastery"
                dataKey="value"
                stroke="oklch(0.66 0.27 295)"
                fill="oklch(0.66 0.27 295)"
                fillOpacity={0.4}
              />
            </RadarChart>
          </ResponsiveContainer>
        </div>
        <p className="px-2 pb-2 text-center text-xs text-muted-foreground">
          Your average scores by attribute.
        </p>
      </div>

      <div className="mt-6 rounded-2xl border border-border/50 bg-black/60 p-4 backdrop-blur-md">
        <div className="mb-3 flex items-center justify-between gap-2">
          <h3 className="flex items-center gap-2 font-display text-lg font-bold">
            <Backpack className="h-4 w-4 text-[color:var(--gold)]" /> Inventory
          </h3>
          <Avatar className="h-9 w-9 border border-[color:var(--gold)]/40">
            <AvatarFallback
              className="bg-[image:var(--gradient-gold)] text-base text-black"
              aria-label={avatarEmoji ? (avatarSlug ?? "avatar") : "avatar"}
            >
              {avatarEmoji ?? initials}
            </AvatarFallback>
          </Avatar>
        </div>
        <div className="space-y-3">
          {inventory.length > 0 ? (
            inventory.slice(0, 4).map((item) => (
              <div key={item.code} className="rounded-xl bg-black/40 p-3">
                <div className="flex items-center justify-between gap-3">
                  <div>
                    <div className="font-semibold">{item.name}</div>
                    <div className="text-xs uppercase tracking-widest text-muted-foreground">
                      {item.itemType}
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="font-display text-lg font-bold text-[color:var(--gold)]">
                      x{item.quantity}
                    </div>
                    {item.isEquipped && (
                      <div className="text-xs uppercase tracking-widest text-[color:var(--success)]">
                        Equipped
                      </div>
                    )}
                  </div>
                </div>
                {item.isArmable && (
                  <div className="mt-3 flex items-center justify-between gap-2">
                    {item.isActive ? (
                      <span className="rounded-full bg-[color:var(--gold)]/15 px-3 py-1 text-xs font-bold text-[color:var(--gold)]">
                        {armedLabel(item.armSlot)}
                      </span>
                    ) : (
                      <button
                        disabled={isActivatePending}
                        onClick={() => onActivate(item.code)}
                        aria-label={`Activer ${item.name}`}
                        className="rounded-lg bg-[image:var(--gradient-gold)] px-3 py-1.5 text-xs font-bold text-black shadow-gold disabled:opacity-40"
                      >
                        Activer
                      </button>
                    )}
                  </div>
                )}
              </div>
            ))
          ) : (
            <div className="rounded-xl bg-background/30 p-4 text-sm text-muted-foreground">
              Your inventory is still empty.
            </div>
          )}
        </div>
      </div>
    </>
  );
}
