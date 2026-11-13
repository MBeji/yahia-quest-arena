import { useId } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { BellOff } from "lucide-react";
import { toast } from "sonner";
import { Switch } from "@/components/ui/switch";
import { useParentT } from "@/lib/i18n/parent";
import { getParentDigestPref, setParentDigestPref } from "../notifications.server";
import { usePush } from "../use-push";
import { PushCardShell } from "./enable-push-card";

const DIGEST_PREF_KEY = ["parent-digest-pref"] as const;

/**
 * Étude 08 lot 2 (US-7) — la carte « bilan du dimanche » du rapport parent.
 *
 * Elle porte DEUX réglages, dans l'ordre où ils dépendent l'un de l'autre :
 * les notifications de cet appareil (le canal), puis le digest ENRICHI (le
 * contenu). Le second est désactivé par défaut (Q-1) et se demande en un clic —
 * si le canal n'est pas encore ouvert, le même clic l'ouvre.
 *
 * Les états vides sont dits, pas masqués : un navigateur qui ne sait pas
 * recevoir de push reçoit la marche à suivre, un parent sans enfant lié apprend
 * pourquoi rien ne partira. Seul « VAPID absent du build » se tait — il n'y a
 * rien que le parent puisse y faire.
 */
export function ParentDigestCard({ hasLinkedStudent }: { hasLinkedStudent: boolean }) {
  const t = useParentT();
  const push = usePush({ moment: "parent" });
  const switchId = useId();
  const queryClient = useQueryClient();
  const getPref = useServerFn(getParentDigestPref);
  const setPref = useServerFn(setParentDigestPref);
  const usable = push.state !== "loading" && push.state !== "unconfigured";

  const { data: pref } = useQuery({
    queryKey: DIGEST_PREF_KEY,
    queryFn: () => getPref(),
    enabled: usable && push.state !== "unsupported",
  });

  const mutation = useMutation({
    mutationFn: async (enabled: boolean) => {
      // Le résumé passe par le push : le demander sans canal serait une promesse
      // vide. Le même geste ouvre donc le canal — et renonce s'il est refusé.
      if (enabled && push.state !== "granted" && !(await push.enable())) return null;
      return setPref({ data: { enabled } });
    },
    onSuccess: (result) => {
      if (!result) {
        toast.error(t.parentReport.digestBlocked);
        return;
      }
      queryClient.setQueryData(DIGEST_PREF_KEY, result);
      toast.success(result.enriched ? t.parentReport.digestOn : t.parentReport.digestOff);
    },
    onError: () => toast.error(t.parentReport.digestError),
  });

  if (!usable) return null;

  if (push.state === "unsupported") {
    return (
      <section className="mt-4 rounded-2xl border border-border/50 bg-background/40 p-4">
        <div className="flex items-start gap-3">
          <BellOff className="mt-0.5 h-5 w-5 shrink-0 text-muted-foreground" />
          <div>
            <h3 className="text-sm font-bold">{t.parentReport.pushTitle}</h3>
            <p className="mt-0.5 text-xs text-muted-foreground">
              {t.parentReport.digestUnsupported}
            </p>
          </div>
        </div>
      </section>
    );
  }

  const enriched = pref?.enriched === true;
  // Bloqué par le navigateur : on ne peut plus DEMANDER le résumé d'ici, mais on
  // doit toujours pouvoir le couper.
  const locked = mutation.isPending || push.busy || (push.state === "denied" && !enriched);

  return (
    <PushCardShell
      push={push}
      title={t.parentReport.pushTitle}
      desc={t.parentReport.pushDesc}
      blocked={t.parentReport.digestBlocked}
    >
      <div className="mt-4 border-t border-border/40 pt-3">
        <div className="flex items-start justify-between gap-3">
          <label htmlFor={switchId} className="text-sm font-semibold text-foreground">
            {t.parentReport.digestTitle}
          </label>
          <Switch
            id={switchId}
            checked={enriched}
            disabled={locked || pref === undefined}
            onCheckedChange={(next) => mutation.mutate(next)}
          />
        </div>
        <p className="mt-1 text-xs text-muted-foreground">{t.parentReport.digestDesc}</p>
        <p className="mt-1 text-xs text-muted-foreground">{t.parentReport.digestLockNote}</p>
        {enriched && push.state !== "granted" ? (
          <p className="mt-2 text-xs text-gold">{t.parentReport.digestOtherDevice}</p>
        ) : null}
        {!hasLinkedStudent ? (
          <p className="mt-2 text-xs text-gold">{t.parentReport.digestNoChild}</p>
        ) : null}
      </div>
    </PushCardShell>
  );
}
