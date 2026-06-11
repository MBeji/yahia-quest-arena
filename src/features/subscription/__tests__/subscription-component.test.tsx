import { render, screen, fireEvent, within } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

// The beta-request sub-component needs a QueryClient + server-fn runtime; the
// paywall test only cares about plans + phone, so stub it out here.
vi.mock("../components/beta-access-request", () => ({ BetaAccessRequest: () => null }));

import { SubscriptionPaywall } from "../components/subscription-paywall";
import {
  ParcoursEntitlementsAdmin,
  type ParcoursEntitlementRow,
  type AdminParcoursOption,
} from "../components/parcours-entitlements-admin";
import { ADMIN_CONTACT_PHONE } from "@/shared/constants/subscription";
// Components render with the default-locale catalog (FR) when no provider wraps
// them; assert via catalog keys so tests survive locale-default changes.
import { fr } from "@/lib/i18n/fr";

describe("SubscriptionPaywall", () => {
  it("surfaces the per-parcours admin contact phone (no time-based plans)", () => {
    render(<SubscriptionPaywall />);
    // Premium is provisioned out-of-band per parcours: the only call-to-action is
    // the admin contact phone — there are no monthly/quarterly/annual plan prices.
    expect(screen.getByText(ADMIN_CONTACT_PHONE)).toBeInTheDocument();
    expect(screen.queryByText(/\b19\b|\b40\b|\b99\b/)).not.toBeInTheDocument();
  });
});

const PARCOURS_OPTIONS: AdminParcoursOption[] = [
  { id: "concours-9eme", name: "Concours 9ème", isPremium: true },
  { id: "concours-6eme", name: "Concours 6ème", isPremium: true },
  { id: "francais", name: "Français", isPremium: false },
];

const ACTIVE_ENT: ParcoursEntitlementRow = {
  userId: "u-active",
  displayName: "Active Hero",
  email: "active@example.com",
  parcoursId: "concours-9eme",
  parcoursName: "Concours 9ème",
  source: "purchase",
  grantedAt: "2026-06-01T00:00:00Z",
  expiresAt: "2999-01-01T00:00:00Z",
  isActive: true,
};

const INACTIVE_ENT: ParcoursEntitlementRow = {
  userId: "u-inactive",
  displayName: "Idle Hero",
  email: null,
  parcoursId: "concours-6eme",
  parcoursName: "Concours 6ème",
  source: "beta",
  grantedAt: null,
  expiresAt: null,
  isActive: false,
};

describe("ParcoursEntitlementsAdmin", () => {
  it("grants with the chosen parcours, source and months", () => {
    const onGrant = vi.fn();
    render(
      <ParcoursEntitlementsAdmin
        entitlements={[]}
        parcoursOptions={PARCOURS_OPTIONS}
        onGrant={onGrant}
        onRevoke={vi.fn()}
        pendingKey={null}
        isGranting={false}
      />,
    );

    fireEvent.change(screen.getByLabelText(fr.subscription.grantUserId), {
      target: { value: "11111111-1111-1111-1111-111111111111" },
    });
    fireEvent.change(screen.getByLabelText(fr.subscription.grantParcours), {
      target: { value: "concours-6eme" },
    });
    fireEvent.change(screen.getByLabelText(fr.subscription.grantSource), {
      target: { value: "gift" },
    });
    fireEvent.change(screen.getByLabelText(fr.subscription.grantMonths), {
      target: { value: "3" },
    });
    fireEvent.click(screen.getByText(fr.subscription.grant));

    expect(onGrant).toHaveBeenCalledWith({
      userId: "11111111-1111-1111-1111-111111111111",
      parcoursId: "concours-6eme",
      source: "gift",
      months: 3,
    });
  });

  it("does not grant when the user id is blank", () => {
    const onGrant = vi.fn();
    render(
      <ParcoursEntitlementsAdmin
        entitlements={[]}
        parcoursOptions={PARCOURS_OPTIONS}
        onGrant={onGrant}
        onRevoke={vi.fn()}
        pendingKey={null}
        isGranting={false}
      />,
    );

    fireEvent.click(screen.getByText(fr.subscription.grant));
    expect(onGrant).not.toHaveBeenCalled();
  });

  it("revokes an active entitlement and disables Revoke for inactive ones", () => {
    const onRevoke = vi.fn();
    render(
      <ParcoursEntitlementsAdmin
        entitlements={[ACTIVE_ENT, INACTIVE_ENT]}
        parcoursOptions={PARCOURS_OPTIONS}
        onGrant={vi.fn()}
        onRevoke={onRevoke}
        pendingKey={null}
        isGranting={false}
      />,
    );

    const activeRow = screen.getByText("Active Hero").closest("tr") as HTMLElement;
    fireEvent.click(within(activeRow).getByText(fr.subscription.revoke));
    expect(onRevoke).toHaveBeenCalledWith("u-active", "concours-9eme");

    const inactiveRow = screen.getByText("Idle Hero").closest("tr") as HTMLElement;
    expect(within(inactiveRow).getByText(fr.subscription.revoke).closest("button")).toBeDisabled();
  });
});
