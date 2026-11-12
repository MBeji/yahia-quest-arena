import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { ParcoursQuickPick } from "@/components/game/parcours-quick-pick";

/**
 * La carte de classe de la quête (étude 38, lot 2 — R-5). Présentation pure : elle
 * nomme la classe, et rend deux gestes à qui la monte.
 */
describe("ParcoursQuickPick", () => {
  const mount = (props: Partial<Parameters<typeof ParcoursQuickPick>[0]> = {}) => {
    const onChoose = vi.fn();
    const onLater = vi.fn();
    render(
      <ParcoursQuickPick
        parcoursName="9ème année de base"
        onChoose={onChoose}
        onLater={onLater}
        {...props}
      />,
    );
    return { onChoose, onLater };
  };

  it("nomme la classe du chapitre, et tutoie", () => {
    mount();
    expect(
      screen.getByText("Ce chapitre est en 9ème année de base — c'est ta classe ?"),
    ).toBeInTheDocument();
    // La carte est une région nommée : un lecteur d'écran sait de quoi elle parle.
    expect(screen.getByRole("region", { name: /9ème année de base/ })).toBeInTheDocument();
  });

  it("« Choisir » adopte, « Plus tard » diffère — un geste chacun", () => {
    const { onChoose, onLater } = mount();
    fireEvent.click(screen.getByRole("button", { name: "Choisir" }));
    expect(onChoose).toHaveBeenCalledTimes(1);
    expect(onLater).not.toHaveBeenCalled();

    fireEvent.click(screen.getByRole("button", { name: "Plus tard" }));
    expect(onLater).toHaveBeenCalledTimes(1);
  });

  // Pendant l'enregistrement, un second tap ne doit ni doubler l'adoption ni la
  // croiser avec un « plus tard ».
  it("pendant l'adoption, les deux boutons attendent", () => {
    const { onChoose, onLater } = mount({ isChoosing: true });
    const choose = screen.getByRole("button", { name: "Enregistrement…" });
    const later = screen.getByRole("button", { name: "Plus tard" });
    expect(choose).toBeDisabled();
    expect(later).toBeDisabled();
    fireEvent.click(choose);
    fireEvent.click(later);
    expect(onChoose).not.toHaveBeenCalled();
    expect(onLater).not.toHaveBeenCalled();
  });
});
