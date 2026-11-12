import type { ReactNode } from "react";
import { Bell, BellRing, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import { usePush, type PushState } from "../use-push";

type PushController = {
  state: PushState;
  busy: boolean;
  enable: () => Promise<boolean>;
  disable: () => Promise<void>;
};

/**
 * Le corps de la carte d'opt-in, sans son état : la carte parent (é08 lot 2) y
 * loge l'interrupteur du digest sous le MÊME contrôleur — deux `usePush()` côte à
 * côte ne se verraient pas changer l'un l'autre.
 */
export function PushCardShell({
  push,
  title,
  desc,
  blocked,
  children,
}: {
  push: PushController;
  title?: string;
  desc?: string;
  /** Le texte « bloqué » de la surface (le parent se vouvoie, l'élève se tutoie). */
  blocked?: string;
  children?: ReactNode;
}) {
  const t = useT();
  const { state, busy, enable, disable } = push;

  const onEnable = async () => {
    try {
      await enable();
    } catch {
      toast.error(t.pushNotifications.errorGeneric);
    }
  };

  const enabled = state === "granted";

  return (
    <section className="mt-4 rounded-2xl border border-[color:var(--neon-gold)]/30 bg-background/40 p-4">
      <div className="flex items-start gap-3">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[color:var(--neon-gold)]/10 text-[color:var(--neon-gold)]">
          {enabled ? <BellRing className="h-5 w-5" /> : <Bell className="h-5 w-5" />}
        </div>
        <div className="flex-1">
          <h3 className="text-sm font-bold">{title ?? t.pushNotifications.cardTitle}</h3>
          <p className="mt-0.5 text-xs text-muted-foreground">
            {desc ?? t.pushNotifications.cardDesc}
          </p>

          {state === "denied" ? (
            <p className="mt-2 text-xs text-gold">{blocked ?? t.pushNotifications.blocked}</p>
          ) : null}

          <div className="mt-3 flex items-center gap-3">
            {enabled ? (
              <>
                <span className="inline-flex items-center gap-1.5 text-xs font-semibold text-success">
                  <BellRing className="h-3.5 w-3.5" /> {t.pushNotifications.enabled}
                </span>
                <button
                  type="button"
                  onClick={disable}
                  disabled={busy}
                  className="inline-flex items-center px-1 py-2 text-xs font-semibold text-muted-foreground transition hover:text-foreground disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
                >
                  {t.pushNotifications.disable}
                </button>
              </>
            ) : (
              <button
                type="button"
                onClick={onEnable}
                disabled={busy || state === "denied"}
                className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-3 py-1.5 text-xs font-bold text-primary-foreground shadow-gold transition hover:scale-105 disabled:opacity-50 disabled:hover:scale-100"
              >
                {busy ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : null}
                {busy ? t.pushNotifications.enabling : t.pushNotifications.enable}
              </button>
            )}
          </div>

          {children}
        </div>
      </div>
    </section>
  );
}

/**
 * Card to opt into Web Push reminders (streak-at-risk on the dashboard — the copy
 * is overridable per surface). Self-hides when push can't work here (unsupported
 * browser / iOS-not-installed / no VAPID key configured) so we never tease a dead
 * control.
 */
export function EnablePushCard({ title, desc }: { title?: string; desc?: string } = {}) {
  const push = usePush();
  const { state } = push;

  if (state === "loading" || state === "unsupported" || state === "unconfigured") return null;

  return <PushCardShell push={push} title={title} desc={desc} />;
}
