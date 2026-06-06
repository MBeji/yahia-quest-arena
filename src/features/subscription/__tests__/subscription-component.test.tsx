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
  SubscriptionAdminTable,
  type AdminSubscriptionUser,
} from "../components/subscription-admin-table";
import { ADMIN_CONTACT_PHONE, SUBSCRIPTION_PLANS } from "@/shared/constants/subscription";

describe("SubscriptionPaywall", () => {
  it("shows the three plans, prices and the admin contact phone", () => {
    render(<SubscriptionPaywall />);
    for (const plan of SUBSCRIPTION_PLANS) {
      expect(screen.getByText(new RegExp(String(plan.priceTnd)))).toBeInTheDocument();
    }
    expect(screen.getByText(ADMIN_CONTACT_PHONE)).toBeInTheDocument();
  });
});

const ACTIVE_USER: AdminSubscriptionUser = {
  userId: "u-active",
  displayName: "Active Hero",
  email: "active@example.com",
  role: "student",
  type: "monthly",
  activatedAt: "2026-06-01T00:00:00Z",
  expiresAt: "2999-01-01T00:00:00Z",
  isActive: true,
};

const INACTIVE_USER: AdminSubscriptionUser = {
  userId: "u-inactive",
  displayName: "Idle Hero",
  email: null,
  role: "student",
  type: null,
  activatedAt: null,
  expiresAt: null,
  isActive: false,
};

describe("SubscriptionAdminTable", () => {
  it("activates with the selected plan", () => {
    const onActivate = vi.fn();
    render(
      <SubscriptionAdminTable
        users={[INACTIVE_USER]}
        onActivate={onActivate}
        onBlock={vi.fn()}
        pendingUserId={null}
      />,
    );

    fireEvent.change(screen.getByRole("combobox"), { target: { value: "annual" } });
    fireEvent.click(screen.getByText("Unlock"));
    expect(onActivate).toHaveBeenCalledWith("u-inactive", "annual");
  });

  it("blocks an active user and disables Block for inactive users", () => {
    const onBlock = vi.fn();
    render(
      <SubscriptionAdminTable
        users={[ACTIVE_USER, INACTIVE_USER]}
        onActivate={vi.fn()}
        onBlock={onBlock}
        pendingUserId={null}
      />,
    );

    const activeRow = screen.getByText("Active Hero").closest("tr") as HTMLElement;
    fireEvent.click(within(activeRow).getByText("Block"));
    expect(onBlock).toHaveBeenCalledWith("u-active");

    const inactiveRow = screen.getByText("Idle Hero").closest("tr") as HTMLElement;
    expect(within(inactiveRow).getByText("Block").closest("button")).toBeDisabled();
  });
});
