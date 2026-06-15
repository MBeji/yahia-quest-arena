import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { DashboardRadarInventory } from "../components/dashboard-radar-inventory";
import { DashboardBadgesShop } from "../components/dashboard-badges-shop";

describe("equipped skin rendering", () => {
  it("shows the equipped skin glyph in the inventory avatar", () => {
    render(
      <DashboardRadarInventory
        radarData={[]}
        inventory={[]}
        avatarSlug="dragon"
        displayName="Yahia"
        isActivatePending={false}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("🐲")).toBeInTheDocument();
  });

  it("falls back to initials when no skin is equipped", () => {
    render(
      <DashboardRadarInventory
        radarData={[]}
        inventory={[]}
        avatarSlug={null}
        displayName="Yahia"
        isActivatePending={false}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("YA")).toBeInTheDocument();
  });

  it("shows the skin glyph on a shop skin card", () => {
    render(
      <DashboardBadgesShop
        badges={[]}
        shopItems={[
          {
            code: "skin_pharaoh",
            name: "Masque du Pharaon",
            description: null,
            itemType: "skin",
            priceCoins: 200,
            isOwned: false,
            isEquipped: false,
            quantity: 0,
            avatarSlug: "pharaoh",
            isArmable: false,
            armSlot: null,
            isActive: false,
          },
        ]}
        availableCoins={500}
        isPurchasePending={false}
        isEquipPending={false}
        isActivatePending={false}
        onPurchase={() => {}}
        onEquip={() => {}}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("👑")).toBeInTheDocument();
  });
});

describe("mastery radar (SVG)", () => {
  it("renders one labelled axis per attribute with an accessible summary", () => {
    render(
      <DashboardRadarInventory
        radarData={[
          { subject: "Force", value: 80 },
          { subject: "Esprit", value: 40 },
          { subject: "Sagesse", value: 60 },
        ]}
        inventory={[]}
        avatarSlug={null}
        displayName="Yahia"
        isActivatePending={false}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("Force")).toBeInTheDocument();
    expect(screen.getByText("Esprit")).toBeInTheDocument();
    expect(screen.getByText("Sagesse")).toBeInTheDocument();
    expect(screen.getByRole("img", { name: /Force: 80/ })).toBeInTheDocument();
  });
});
