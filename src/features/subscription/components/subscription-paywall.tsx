import { Link } from "@tanstack/react-router";
import { Crown, Phone, Check } from "lucide-react";
import { useT } from "@/lib/i18n";
import {
  ADMIN_CONTACT_PHONE,
  SUBSCRIPTION_CURRENCY,
  SUBSCRIPTION_PLANS,
} from "@/shared/constants/subscription";
import { BetaAccessRequest } from "./beta-access-request";

/**
 * Paywall shown when a user without an active subscription tries to reach a
 * premium feature (the Dungeon, or any future paywalled feature/level).
 * Lists the three plans and the admin phone number to call.
 */
export function SubscriptionPaywall() {
  const t = useT();

  return (
    <div className="mx-auto mt-8 max-w-md rounded-2xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-6 text-left">
      <div className="flex items-center gap-2 font-display text-lg font-bold text-[color:var(--neon-gold)]">
        <Crown className="h-5 w-5" /> {t.subscription.premiumTitle}
      </div>
      <p className="mt-2 text-sm text-muted-foreground">{t.subscription.premiumDesc}</p>

      <div className="mt-5 space-y-2">
        {SUBSCRIPTION_PLANS.map((plan) => (
          <div
            key={plan.type}
            className="flex items-center justify-between rounded-xl border border-border/50 bg-background/40 px-4 py-3"
          >
            <span className="flex items-center gap-2 text-sm font-semibold">
              <Check className="h-4 w-4 text-[color:var(--neon-gold)]" />
              {t.subscription[plan.type]}
            </span>
            <span className="font-display font-bold text-foreground">
              {plan.priceTnd} {SUBSCRIPTION_CURRENCY}
            </span>
          </div>
        ))}
      </div>

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
