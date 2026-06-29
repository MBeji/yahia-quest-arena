import { Backpack, Lightbulb, Trophy } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { avatarEmojiForSlug } from "@/shared/lib/avatar";
import { useT } from "@/lib/i18n";

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
  /** Hint consumable (booster_hint / potion_rappel) — used on demand in a quest. */
  isHintConsumable?: boolean;
};

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

// --- Pure-SVG mastery radar (replaces the former recharts RadarChart, its only use) ---
const RADAR_CENTER = 100;
const RADAR_RADIUS = 60;
const RADAR_RINGS = [0.25, 0.5, 0.75, 1];
const RADAR_STROKE = "oklch(0.66 0.27 295)";
const RADAR_GRID = "oklch(0.66 0.27 295 / 0.25)";

/** Evenly-spaced angle (radians) for axis `i` of `n`, starting at the top (12 o'clock). */
function radarAngle(i: number, n: number): number {
  return -Math.PI / 2 + (i * 2 * Math.PI) / n;
}

/** A point at `radius`/`angle` from the radar centre, formatted for an SVG points list. */
function radarPoint(radius: number, angle: number): string {
  const x = RADAR_CENTER + radius * Math.cos(angle);
  const y = RADAR_CENTER + radius * Math.sin(angle);
  return `${x.toFixed(1)},${y.toFixed(1)}`;
}

/**
 * Mastery radar drawn as plain SVG. Values are average scores per attribute on a fixed
 * 0-100 domain, so a 50 reads as half-mastered (absolute, not relative to the peak).
 */
function RadarChartSvg({ data }: { data: RadarPoint[] }) {
  const n = data.length;
  if (n === 0) return null;
  // Never clip: only stretch the domain past 100 if a value somehow exceeds it.
  const domain = Math.max(100, ...data.map((d) => d.value));

  return (
    <svg
      viewBox="0 0 200 200"
      className="h-full w-full"
      role="img"
      aria-label={data.map((d) => `${d.subject}: ${d.value}`).join(", ")}
    >
      {RADAR_RINGS.map((ring) => (
        <polygon
          key={ring}
          points={data.map((_, i) => radarPoint(RADAR_RADIUS * ring, radarAngle(i, n))).join(" ")}
          fill="none"
          stroke={RADAR_GRID}
          strokeWidth={0.5}
        />
      ))}
      {data.map((_, i) => {
        const angle = radarAngle(i, n);
        return (
          <line
            key={i}
            x1={RADAR_CENTER}
            y1={RADAR_CENTER}
            x2={RADAR_CENTER + RADAR_RADIUS * Math.cos(angle)}
            y2={RADAR_CENTER + RADAR_RADIUS * Math.sin(angle)}
            stroke={RADAR_GRID}
            strokeWidth={0.5}
          />
        );
      })}
      <polygon
        points={data
          .map((d, i) => {
            const r = (Math.min(Math.max(d.value, 0), domain) / domain) * RADAR_RADIUS;
            return radarPoint(r, radarAngle(i, n));
          })
          .join(" ")}
        fill={RADAR_STROKE}
        fillOpacity={0.4}
        stroke={RADAR_STROKE}
        strokeWidth={1.5}
        strokeLinejoin="round"
      />
      {data.map((d, i) => {
        const angle = radarAngle(i, n);
        const cos = Math.cos(angle);
        const anchor = cos > 0.3 ? "start" : cos < -0.3 ? "end" : "middle";
        return (
          <text
            key={i}
            x={(RADAR_CENTER + (RADAR_RADIUS + 13) * cos).toFixed(1)}
            y={(RADAR_CENTER + (RADAR_RADIUS + 13) * Math.sin(angle)).toFixed(1)}
            textAnchor={anchor}
            dominantBaseline="middle"
            fontSize={9}
            fill="oklch(0.72 0.04 270)"
          >
            {d.subject}
          </text>
        );
      })}
    </svg>
  );
}

export function DashboardRadarInventory({
  radarData,
  inventory,
  avatarSlug,
  displayName,
  isActivatePending,
  onActivate,
}: DashboardRadarInventoryProps) {
  const t = useT();
  /** Armed-badge label per arming slot (passive streak shield vs next-quest item). */
  const armedLabel = (armSlot: "next-quest" | "passive" | null): string =>
    armSlot === "passive" ? t.dashboard.armedPassive : t.dashboard.armedQuest;
  const avatarEmoji = avatarEmojiForSlug(avatarSlug);
  const initials = (displayName ?? "").trim().slice(0, 2).toUpperCase() || "?";
  return (
    <>
      <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
        <Trophy className="h-5 w-5 text-[color:var(--neon-gold)]" /> {t.dashboard.radarTitle}
      </h2>
      <div className="rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
        <div className="h-72 w-full">
          <RadarChartSvg data={radarData} />
        </div>
        <p className="px-2 pb-2 text-center text-xs text-muted-foreground">
          {t.dashboard.radarCaption}
        </p>
      </div>

      <div className="mt-6 rounded-2xl border border-border/50 bg-black/60 p-4 backdrop-blur-md">
        <div className="mb-3 flex items-center justify-between gap-2">
          <h3 className="flex items-center gap-2 font-display text-lg font-bold">
            <Backpack className="h-4 w-4 text-[color:var(--gold)]" /> {t.dashboard.inventoryTitle}
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
                        {t.dashboard.shopEquipped}
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
                        aria-label={`${t.dashboard.shopActivate} ${item.name}`}
                        className="rounded-lg bg-[image:var(--gradient-gold)] px-3 py-1.5 text-xs font-bold text-black shadow-gold disabled:opacity-40"
                      >
                        {t.dashboard.shopActivate}
                      </button>
                    )}
                  </div>
                )}
                {/* Hint consumables are spent on demand inside a quest (no arming),
                    so they get a label instead of an "Activer" button. */}
                {item.isHintConsumable && (
                  <div className="mt-3">
                    <span className="inline-flex items-center gap-1.5 rounded-full bg-[color:var(--neon-gold)]/15 px-3 py-1 text-xs font-bold text-[color:var(--neon-gold)]">
                      <Lightbulb className="h-3.5 w-3.5" /> {t.quest.hintUseInQuest}
                    </span>
                  </div>
                )}
              </div>
            ))
          ) : (
            <div className="rounded-xl bg-background/30 p-4 text-sm text-muted-foreground">
              {t.dashboard.inventoryEmpty}
            </div>
          )}
        </div>
      </div>
    </>
  );
}
