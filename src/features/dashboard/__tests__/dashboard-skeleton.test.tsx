import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";

import { DashboardSkeleton } from "@/features/dashboard/components/dashboard-skeleton";

describe("DashboardSkeleton", () => {
  it("annonce le chargement — les pulsations posées à la main ne le faisaient pas", () => {
    render(<DashboardSkeleton />);
    // Un `role="status"` NOMMÉ : sans nom accessible, un lecteur d'écran
    // n'annonce rien et l'attente est silencieuse.
    const status = screen.getByRole("status");
    expect(status).toHaveAccessibleName();
  });

  it("cache les os au lecteur d'écran : ils décrivent une forme, pas un contenu", () => {
    const { container } = render(<DashboardSkeleton />);
    const bones = container.querySelectorAll(".animate-pulse");
    expect(bones.length).toBeGreaterThan(0);
    // Chaque os vit sous le conteneur aria-hidden.
    bones.forEach((bone) => expect(bone.closest("[aria-hidden]")).not.toBeNull());
  });

  it("dessine la forme réelle de l'écran : héros, bande focus, grille de matières", () => {
    const { container } = render(<DashboardSkeleton />);
    // 1 avatar + 1 eyebrow + 1 titre + 4 pastilles + 1 barre = 8, puis 3 tuiles
    // de focus et 5 matières.
    expect(container.querySelectorAll(".animate-pulse")).toHaveLength(16);
  });
});
