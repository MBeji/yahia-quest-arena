import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";

import { SubjectHubSkeleton } from "@/features/quest/components/subject-hub-skeleton";

describe("SubjectHubSkeleton", () => {
  it("annonce le chargement du hub", () => {
    render(<SubjectHubSkeleton />);
    expect(screen.getByRole("status")).toHaveAccessibleName();
  });

  it("dessine quatre cartes de chapitre, chacune avec ses missions", () => {
    const { container } = render(<SubjectHubSkeleton />);
    expect(container.querySelectorAll(".rounded-2xl.border")).toHaveLength(4);
  });
});
