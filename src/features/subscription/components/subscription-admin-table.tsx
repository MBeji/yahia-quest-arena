import { useState } from "react";
import { Check, Ban, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import { SUBSCRIPTION_TYPES, type SubscriptionType } from "@/shared/constants/subscription";

export type AdminSubscriptionUser = {
  userId: string;
  displayName: string;
  email: string | null;
  role: string;
  type: string | null;
  activatedAt: string | null;
  expiresAt: string | null;
  isActive: boolean;
};

function formatDate(value: string | null, fallback: string): string {
  if (!value) return fallback;
  const ts = Date.parse(value);
  return Number.isFinite(ts) ? new Date(ts).toLocaleDateString() : fallback;
}

/** Admin table: list users + activate/block their premium subscription. */
export function SubscriptionAdminTable({
  users,
  onActivate,
  onBlock,
  pendingUserId,
}: {
  users: AdminSubscriptionUser[];
  onActivate: (userId: string, type: SubscriptionType) => void;
  onBlock: (userId: string) => void;
  pendingUserId: string | null;
}) {
  const t = useT();
  const [selected, setSelected] = useState<Record<string, SubscriptionType>>({});

  return (
    <div className="overflow-x-auto rounded-2xl border border-border/50 bg-card/40 backdrop-blur-xl">
      <table className="w-full min-w-[820px] text-left text-sm">
        <thead className="border-b border-border/50 text-xs uppercase tracking-wider text-muted-foreground">
          <tr>
            <th className="px-4 py-3">{t.subscription.colUser}</th>
            <th className="px-4 py-3">{t.subscription.colStatus}</th>
            <th className="px-4 py-3">{t.subscription.colPlan}</th>
            <th className="px-4 py-3">{t.subscription.colActivated}</th>
            <th className="px-4 py-3">{t.subscription.colExpires}</th>
            <th className="px-4 py-3">{t.subscription.colActions}</th>
          </tr>
        </thead>
        <tbody>
          {users.map((u) => {
            const isPending = pendingUserId === u.userId;
            const plan = selected[u.userId] ?? "monthly";
            return (
              <tr key={u.userId} className="border-b border-border/30 last:border-0">
                <td className="px-4 py-3">
                  <div className="font-semibold text-foreground">{u.displayName}</div>
                  {u.email && <div className="text-xs text-muted-foreground">{u.email}</div>}
                  <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                    {u.role}
                  </div>
                </td>
                <td className="px-4 py-3">
                  <span
                    className={`inline-flex rounded-full px-2.5 py-1 text-xs font-bold ${
                      u.isActive
                        ? "bg-emerald-500/15 text-emerald-400"
                        : "bg-muted/40 text-muted-foreground"
                    }`}
                  >
                    {u.isActive ? t.subscription.statusActive : t.subscription.statusInactive}
                  </span>
                </td>
                <td className="px-4 py-3">
                  {u.type ? t.subscription[u.type as SubscriptionType] : t.subscription.none}
                </td>
                <td className="px-4 py-3 text-muted-foreground">
                  {formatDate(u.activatedAt, t.subscription.none)}
                </td>
                <td className="px-4 py-3 text-muted-foreground">
                  {formatDate(u.expiresAt, t.subscription.none)}
                </td>
                <td className="px-4 py-3">
                  <div className="flex flex-wrap items-center gap-2">
                    <select
                      value={plan}
                      disabled={isPending}
                      onChange={(e) =>
                        setSelected((s) => ({
                          ...s,
                          [u.userId]: e.target.value as SubscriptionType,
                        }))
                      }
                      aria-label={t.subscription.colPlan}
                      className="rounded-md border border-border/60 bg-background/60 px-2 py-1.5 text-xs"
                    >
                      {SUBSCRIPTION_TYPES.map((type) => (
                        <option key={type} value={type}>
                          {t.subscription[type]}
                        </option>
                      ))}
                    </select>
                    <button
                      type="button"
                      disabled={isPending}
                      onClick={() => onActivate(u.userId, plan)}
                      className="inline-flex items-center gap-1 rounded-md bg-emerald-500/15 px-2.5 py-1.5 text-xs font-bold text-emerald-400 hover:bg-emerald-500/25 disabled:opacity-50"
                    >
                      {isPending ? (
                        <Loader2 className="h-3.5 w-3.5 animate-spin" />
                      ) : (
                        <Check className="h-3.5 w-3.5" />
                      )}
                      {t.subscription.activate}
                    </button>
                    <button
                      type="button"
                      disabled={isPending || !u.isActive}
                      onClick={() => onBlock(u.userId)}
                      className="inline-flex items-center gap-1 rounded-md bg-destructive/15 px-2.5 py-1.5 text-xs font-bold text-destructive hover:bg-destructive/25 disabled:opacity-50"
                    >
                      <Ban className="h-3.5 w-3.5" /> {t.subscription.block}
                    </button>
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
