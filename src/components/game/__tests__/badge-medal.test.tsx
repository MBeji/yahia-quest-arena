import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";

import { BadgeMedal } from "@/components/game/badge-medal";

/** La couleur de rareté est portée en `style` par le conteneur de la médaille. */
function medalOf(container: HTMLElement): HTMLElement {
  return container.firstElementChild as HTMLElement;
}

describe("BadgeMedal", () => {
  it("prend la couleur du cran de rareté, pas une couleur d'accent générique", () => {
    const { container } = render(<BadgeMedal iconName="Flame" rarity="epic" />);
    expect(medalOf(container).style.color).toBe("var(--rarity-epic)");
  });

  it("retombe sur « commun » plutôt que de rendre un cadre sans couleur", () => {
    // Un badge semé avec une rareté hors échelle doit rester une médaille.
    const { container } = render(<BadgeMedal iconName="Flame" rarity="mythique-inventé" />);
    expect(medalOf(container).style.color).toBe("var(--rarity-common)");
  });

  it("distingue le cran le plus haut par la FORME, pas seulement par la couleur", () => {
    // Sans ça, l'échelle disparaît pour qui ne distingue pas les teintes.
    const legendary = render(<BadgeMedal iconName="Zap" rarity="legendary" />);
    const rare = render(<BadgeMedal iconName="Zap" rarity="rare" />);
    expect(legendary.container.querySelectorAll("polygon").length).toBeGreaterThan(
      rare.container.querySelectorAll("polygon").length,
    );
  });

  it("rend un glyphe même quand la base n'en déclare aucun", () => {
    const { container } = render(<BadgeMedal iconName={null} rarity="common" />);
    expect(container.querySelector("svg.lucide")).not.toBeNull();
  });

  it("se tait pour le lecteur d'écran : le nom du badge est déjà écrit à côté", () => {
    const { container } = render(<BadgeMedal iconName="Star" rarity="rare" />);
    expect(medalOf(container).getAttribute("aria-hidden")).toBe("true");
  });
});
