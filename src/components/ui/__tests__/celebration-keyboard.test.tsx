import { fireEvent, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";

// `prefers-reduced-motion`, pilotable depuis les cas : `motion/react` lit la
// media query, que jsdom ne simule pas.
let reducedMotion = false;
vi.mock("motion/react", async (importOriginal) => {
  const actual = await importOriginal<typeof import("motion/react")>();
  return { ...actual, useReducedMotion: () => reducedMotion };
});

import { LevelUpCelebration } from "@/components/ui/level-up-celebration";
import { SealCelebration } from "@/components/ui/seal-celebration";
import { Switch } from "@/components/ui/switch";

afterEach(() => {
  reducedMotion = false;
});

/**
 * Audit d'affichage du 2026-10-31, constat majeur : les modales de niveau et de
 * sceau ne se fermaient qu'à la souris, et la montée de niveau ignorait
 * `prefers-reduced-motion`. Un élève au clavier restait derrière un voile plein écran.
 */
describe("LevelUpCelebration — clavier et mouvement réduit", () => {
  const mount = (onComplete = vi.fn()) => {
    render(<LevelUpCelebration show newLevel={7} xpGained={120} onComplete={onComplete} />);
    return { onComplete, dialog: screen.getByRole("dialog") };
  };

  it("est une modale nommée, qui prend le focus à l'ouverture", () => {
    const { dialog } = mount();
    expect(dialog).toHaveAttribute("aria-modal", "true");
    expect(dialog).toHaveAccessibleName(/7/);
    expect(dialog).toHaveFocus();
  });

  it.each(["Escape", "Enter", " "])("la touche « %s » ferme", (key) => {
    const { onComplete } = mount();
    fireEvent.keyDown(window, { key });
    expect(onComplete).toHaveBeenCalledTimes(1);
  });

  // L'Entrée qui vient de valider la dernière réponse, encore enfoncée, ne doit
  // pas refermer la modale avant qu'elle ait été vue.
  it("ignore une touche maintenue et les autres touches", () => {
    const { onComplete } = mount();
    fireEvent.keyDown(window, { key: "Enter", repeat: true });
    fireEvent.keyDown(window, { key: "a" });
    expect(onComplete).not.toHaveBeenCalled();
  });

  it("rend le focus à l'élément qui l'avait, à la fermeture", () => {
    const { rerender } = render(
      <>
        <button type="button">Rejouer</button>
        <LevelUpCelebration show={false} newLevel={7} xpGained={120} />
      </>,
    );
    const before = screen.getByRole("button", { name: "Rejouer" });
    before.focus();
    rerender(
      <>
        <button type="button">Rejouer</button>
        <LevelUpCelebration show newLevel={7} xpGained={120} />
      </>,
    );
    expect(screen.getByRole("dialog")).toHaveFocus();
    rerender(
      <>
        <button type="button">Rejouer</button>
        <LevelUpCelebration show={false} newLevel={7} xpGained={120} />
      </>,
    );
    expect(before).toHaveFocus();
  });

  it("n'écoute plus le clavier une fois fermée", () => {
    const onComplete = vi.fn();
    render(<LevelUpCelebration show={false} newLevel={7} xpGained={120} onComplete={onComplete} />);
    fireEvent.keyDown(window, { key: "Escape" });
    expect(onComplete).not.toHaveBeenCalled();
  });

  it("le libellé du niveau vient du catalogue, plus de « Lvl » en dur", () => {
    const { dialog } = mount();
    // Catalogue français par défaut : « Niv. 7 ».
    expect(dialog).toHaveTextContent("Niv. 7");
    expect(dialog).not.toHaveTextContent("Lvl");
  });

  it("en mouvement réduit, aucune particule ne tombe", () => {
    const withMotion = render(<LevelUpCelebration show newLevel={7} xpGained={120} />);
    const fullCount = withMotion.container.ownerDocument.querySelectorAll(".rounded-sm").length;
    expect(fullCount).toBeGreaterThanOrEqual(60);
    withMotion.unmount();

    reducedMotion = true;
    const reduced = render(<LevelUpCelebration show newLevel={7} xpGained={120} />);
    expect(reduced.container.ownerDocument.querySelectorAll(".rounded-sm")).toHaveLength(0);
    expect(screen.getByRole("dialog")).toHaveTextContent("+120 XP");
  });
});

describe("SealCelebration — clavier", () => {
  it("prend le focus et se ferme à Échap", () => {
    const onComplete = vi.fn();
    render(
      <SealCelebration
        show
        star={2}
        subjectName="Mathématiques"
        title="Sceau ⭐⭐"
        body="corps"
        hint="indice"
        onComplete={onComplete}
      />,
    );
    expect(screen.getByRole("dialog", { name: "Sceau ⭐⭐" })).toHaveFocus();
    fireEvent.keyDown(window, { key: "Escape" });
    expect(onComplete).toHaveBeenCalledTimes(1);
  });
});

/**
 * Même audit : en arabe, la pastille « activé » d'un interrupteur sortait de la
 * piste — la translation restait vers la droite alors que la piste part de la droite.
 */
describe("Switch — sens d'écriture", () => {
  it("la pastille activée glisse vers la gauche en RTL", () => {
    render(<Switch aria-label="Son" defaultChecked />);
    const thumb = screen.getByRole("switch").firstElementChild;
    expect(thumb?.className).toContain("data-[state=checked]:translate-x-4");
    expect(thumb?.className).toContain("rtl:data-[state=checked]:-translate-x-4");
  });
});
