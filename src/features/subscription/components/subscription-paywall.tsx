import { Link } from "@tanstack/react-router";
import { Crown, Phone } from "lucide-react";
import { useT } from "@/lib/i18n";
import { ADMIN_CONTACT_PHONE } from "@/shared/constants/subscription";
import { BetaAccessRequest } from "./beta-access-request";

/**
 * Paywall shown when a user without a parcours entitlement reaches premium
 * content (the Dungeon, or a premium Concours parcours mission). Premium access
 * is sold per Concours parcours and provisioned out-of-band by the admin as an
 * entitlement (no time-based plans), so this explains the model and surfaces the
 * admin contact phone plus the free beta-access request.
 */
export function SubscriptionPaywall() {
  const t = useT();

  return (
    <div className="mx-auto mt-8 max-w-md rounded-2xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-6 text-start">
      <div className="flex items-center gap-2 font-display text-lg font-bold text-[color:var(--neon-gold)]">
        <Crown className="h-5 w-5" /> {t.subscription.premiumTitle}
      </div>
      <p className="mt-2 text-sm text-muted-foreground">{t.subscription.premiumDesc}</p>

      <div className="mt-5 rounded-xl border border-[color:var(--neon-gold)]/30 bg-background/30 p-4">
        <div className="text-xs uppercase tracking-widest text-muted-foreground">
          {t.subscription.contactTitle}
        </div>
        <a
          href={`tel:${ADMIN_CONTACT_PHONE.replace(/\s/g, "")}`}
          className="mt-1 flex items-center gap-2 font-display text-lg font-bold text-[color:var(--neon-gold)]"
        >
          <Phone className="h-5 w-5" /> {ADMIN_CONTACT_PHONE}
        </a>
      </div>

      {/* Free beta-tester access request */}
      <BetaAccessRequest />

      <Link
        to="/dashboard"
        className="mt-5 inline-flex items-center gap-1.5 rounded-lg border border-border/50 px-4 py-2 text-sm font-semibold text-foreground hover:bg-card/60"
      >
        {t.common.backToHall}
      </Link>
    </div>
  );
}
