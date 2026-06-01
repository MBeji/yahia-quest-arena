import { Backpack, Trophy } from "lucide-react";
import { PolarAngleAxis, PolarGrid, Radar, RadarChart, ResponsiveContainer } from "recharts";

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
};

type DashboardRadarInventoryProps = {
  radarData: RadarPoint[];
  inventory: InventoryItem[];
};

export function DashboardRadarInventory({ radarData, inventory }: DashboardRadarInventoryProps) {
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
              <PolarAngleAxis dataKey="subject" tick={{ fill: "oklch(0.72 0.04 270)", fontSize: 11 }} />
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
        <p className="px-2 pb-2 text-center text-xs text-muted-foreground">Your average scores by attribute.</p>
      </div>

      <div className="mt-6 rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
        <h3 className="mb-3 flex items-center gap-2 font-display text-lg font-bold">
          <Backpack className="h-4 w-4 text-[color:var(--neon-cyan)]" /> Inventory
        </h3>
        <div className="space-y-3">
          {inventory.length > 0 ? inventory.slice(0, 4).map((item) => (
            <div key={item.code} className="rounded-xl bg-background/40 p-3">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <div className="font-semibold">{item.name}</div>
                  <div className="text-xs uppercase tracking-widest text-muted-foreground">{item.itemType}</div>
                </div>
                <div className="text-right">
                  <div className="font-display text-lg font-bold text-[color:var(--neon-cyan)]">x{item.quantity}</div>
                  {item.isEquipped && <div className="text-xs uppercase tracking-widest text-[color:var(--success)]">Equipped</div>}
                </div>
              </div>
            </div>
          )) : (
            <div className="rounded-xl bg-background/30 p-4 text-sm text-muted-foreground">Your inventory is still empty.</div>
          )}
        </div>
      </div>
    </>
  );
}
