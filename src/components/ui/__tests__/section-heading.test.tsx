import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { Swords } from "lucide-react";

import { SectionHeading } from "@/components/ui/section-heading";

describe("SectionHeading", () => {
  it("expose un vrai titre de niveau 2 — un intertitre qui n'en est pas un ne structure rien", () => {
    render(<SectionHeading title="Aujourd'hui" />);
    expect(screen.getByRole("heading", { level: 2, name: "Aujourd'hui" })).toBeInTheDocument();
  });

  it("porte son action à côté du titre, sans l'enfermer dedans", () => {
    render(<SectionHeading title="Explorer" action={<a href="/leaderboard">Classement</a>} />);
    const heading = screen.getByRole("heading", { level: 2, name: "Explorer" });
    const link = screen.getByRole("link", { name: "Classement" });
    expect(link).toBeInTheDocument();
    expect(heading.contains(link)).toBe(false);
  });

  it("masque le filet et l'icône au lecteur d'écran : ils ne disent rien de plus", () => {
    const { container } = render(<SectionHeading icon={Swords} title="Explorer" />);
    const decorations = container.querySelectorAll('[aria-hidden="true"]');
    expect(decorations.length).toBe(2);
  });
});
