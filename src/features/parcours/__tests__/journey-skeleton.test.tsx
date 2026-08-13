import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";

import { JourneySkeleton } from "@/features/parcours";
import { nodeSide } from "@/features/parcours";

describe("JourneySkeleton", () => {
  it("annonce le chargement de la carte", () => {
    render(<JourneySkeleton />);
    expect(screen.getByRole("status")).toHaveAccessibleName();
  });

  it("serpente comme la vraie carte : les côtés viennent de `nodeSide`", () => {
    const { container } = render(<JourneySkeleton />);
    const rows = Array.from(
      container.querySelectorAll("div.flex.justify-start, div.flex.justify-end"),
    );
    expect(rows).toHaveLength(5);
    rows.forEach((row, i) => {
      const expected = nodeSide(i) === "left" ? "justify-start" : "justify-end";
      expect(row.className).toContain(expected);
    });
  });
});
