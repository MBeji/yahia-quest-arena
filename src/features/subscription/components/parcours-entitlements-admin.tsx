import { useState } from "react";
import { Check, Ban, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import {
  PARCOURS_ENTITLEMENT_SOURCES,
  type ParcoursEntitlementSource,
} from "@/shared/constants/subscription";

/** A live parcours entitlement row (from `listParcoursEntitlements`). */
export type ParcoursEntitlementRow = {
  userId: string;
  displayName: string;
  email: string | null;
  parcoursId: string;
  parcoursName: string;
  source: string;
  grantedAt: string | null;
  expiresAt: string | null;
  isActive: boolean;
};

/** A grantable parcours option (derived from the dashboard's `getParcours`). */
export type AdminParcoursOption = {
  id: string;
  name: string;
  isPremium: boolean;
};

function formatDate(value: string | null, fallback: string): string {
  if (!value) return fallback;
  const ts = Date.parse(value);
  return Number.isFinite(ts) ? new Date(ts).toLocaleDateString() : fallback;
}

/**
 * Admin panel: per-parcours entitlement management. Lists every live grant
 * (user × parcours) with a Revoke action, plus a form to grant a parcours to a
 * user by id (covers their linked children too, via the family-pack-aware gate).
 *
 * Presentational only — the route owns the queries/mutations and the parcours
 * catalogue (fetched from the dashboard feature and passed down), keeping the
 * subscription feature free of cross-feature imports.
 */
export function ParcoursEntitlementsAdmin({
  entitlements,
  parcoursOptions,
  onGrant,
  onRevoke,
  pendingKey,
  isGranting,
}: {
  entitlements: ParcoursEntitlementRow[];
  parcoursOptions: AdminParcoursOption[];
  onGrant: (input: {
    userId: string;
    parcoursId: string;
    source: ParcoursEntitlementSource;
    months?: number;
  }) => void;
  onRevoke: (userId: string, parcoursId: string) => void;
  /** `${userId}:${parcoursId}` of the row whose revoke is in flight, else null. */
  pendingKey: string | null;
  isGranting: boolean;
}) {
  const t = useT();
  const defaultParcours = parcoursOptions[0]?.id ?? "";
  const [userId, setUserId] = useState("");
  const [parcoursId, setParcoursId] = useState(defaultParcours);
  const [source, setSource] = useState<ParcoursEntitlementSource>("purchase");
  const [months, setMonths] = useState("");

  const canGrant = userId.trim().length > 0 && parcoursId.length > 0 && !isGranting;

  return (
    <div className="space-y-6">
      {/* Grant form */}
      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (!canGrant) return;
          const parsedMonths = months.trim() === "" ? undefined : Number(months);
          onGrant({
            userId: userId.trim(),
            parcoursId,
            source,
            months:
              parsedMonths !== undefined && Number.isFinite(parsedMonths) && parsedMonths > 0
                ? parsedMonths
                : undefined,
          });
        }}
        className="rounded-2xl border border-border/50 bg-card/40 p-4 backdrop-blur-xl"
      >
        <h2 className="mb-3 font-display text-lg font-bold">{t.subscription.grantTitle}</h2>
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-5">
          <label className="flex flex-col gap-1 text-xs lg:col-span-2">
            <span className="text-muted-foreground">{t.subscription.grantUserId}</span>
            <input
              type="text"
              value={userId}
              onChange={(e) => setUserId(e.target.value)}
              placeholder={t.subscription.grantUserIdPlaceholder}
              className="rounded-md border border-border/60 bg-background/60 px-2.5 py-1.5 text-sm [@media(pointer:coarse)]:min-h-11"
            />
          </label>
          <label className="flex flex-col gap-1 text-xs">
            <span className="text-muted-foreground">{t.subscription.grantParcours}</span>
            <select
              value={parcoursId}
              onChange={(e) => setParcoursId(e.target.value)}
              className="rounded-md border border-border/60 bg-background/60 px-2 py-1.5 text-sm [@media(pointer:coarse)]:min-h-11"
            >
              {parcoursOptions.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.name}
                  {p.isPremium ? " ★" : ""}
                </option>
              ))}
            </select>
          </label>
          <label className="flex flex-col gap-1 text-xs">
            <span className="text-muted-foreground">{t.subscription.grantSource}</span>
            <select
              value={source}
              onChange={(e) => setSource(e.target.value as ParcoursEntitlementSource)}
              className="rounded-md border border-border/60 bg-background/60 px-2 py-1.5 text-sm [@media(pointer:coarse)]:min-h-11"
            >
              {PARCOURS_ENTITLEMENT_SOURCES.map((s) => (
                <option key={s} value={s}>
                  {t.subscription[s]}
                </option>
              ))}
            </select>
          </label>
          <label className="flex flex-col gap-1 text-xs">
            <span className="text-muted-foreground">{t.subscription.grantMonths}</span>
            <input
              type="number"
              min={1}
              max={120}
              value={months}
              onChange={(e) => setMonths(e.target.value)}
              placeholder={t.subscription.grantMonthsPlaceholder}
              className="rounded-md border border-border/60 bg-background/60 px-2.5 py-1.5 text-sm [@media(pointer:coarse)]:min-h-11"
            />
          </label>
        </div>
        <button
          type="submit"
          disabled={!canGrant}
          className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-sm font-bold text-black shadow-gold transition hover:scale-105 disabled:opacity-50"
        >
          {isGranting ? (
            <Loader2 className="h-4 w-4 animate-spin" />
          ) : (
            <Check className="h-4 w-4" />
          )}
          {t.subscription.grant}
        </button>
      </form>

      {/* Live entitlements */}
      <div className="overflow-x-auto rounded-2xl border border-border/50 bg-card/40 backdrop-blur-xl">
        <table className="w-full min-w-[760px] text-left text-sm">
          <thead className="border-b border-border/50 text-xs uppercase tracking-wider text-muted-foreground">
            <tr>
              <th className="px-4 py-3">{t.subscription.colUser}</th>
              <th className="px-4 py-3">{t.subscription.colParcours}</th>
              <th className="px-4 py-3">{t.subscription.colSource}</th>
              <th className="px-4 py-3">{t.subscription.colStatus}</th>
              <th className="px-4 py-3">{t.subscription.colExpires}</th>
              <th className="px-4 py-3">{t.subscription.colActions}</th>
            </tr>
          </thead>
          <tbody>
            {entitlements.length === 0 ? (
              <tr>
                <td colSpan={6} className="px-4 py-10 text-center text-muted-foreground">
                  {t.subscription.entitlementsEmpty}
                </td>
              </tr>
            ) : (
              entitlements.map((e) => {
                const key = `${e.userId}:${e.parcoursId}`;
                const isPending = pendingKey === key;
                return (
                  <tr key={key} className="border-b border-border/30 last:border-0">
                    <td className="px-4 py-3">
                      <div className="font-semibold text-foreground">{e.displayName}</div>
                      {e.email && <div className="text-xs text-muted-foreground">{e.email}</div>}
                    </td>
                    <td className="px-4 py-3">{e.parcoursName}</td>
                    <td className="px-4 py-3 text-muted-foreground">
                      {t.subscription[e.source as ParcoursEntitlementSource] ?? e.source}
                    </td>
                    <td className="px-4 py-3">
                      <span
                        className={`inline-flex rounded-full px-2.5 py-1 text-xs font-bold ${
                          e.isActive
                            ? "bg-emerald-500/15 text-emerald-400"
                            : "bg-muted/40 text-muted-foreground"
                        }`}
                      >
                        {e.isActive ? t.subscription.statusActive : t.subscription.statusInactive}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-muted-foreground">
                      {formatDate(e.expiresAt, t.subscription.perpetual)}
                    </td>
                    <td className="px-4 py-3">
                      <button
                        type="button"
                        disabled={isPending || !e.isActive}
                        onClick={() => onRevoke(e.userId, e.parcoursId)}
                        className="inline-flex min-h-11 items-center gap-1 rounded-md bg-destructive/15 px-2.5 py-1.5 text-xs font-bold text-destructive hover:bg-destructive/25 disabled:opacity-50"
                      >
                        {isPending ? (
                          <Loader2 className="h-3.5 w-3.5 animate-spin" />
                        ) : (
                          <Ban className="h-3.5 w-3.5" />
                        )}
                        {t.subscription.revoke}
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
