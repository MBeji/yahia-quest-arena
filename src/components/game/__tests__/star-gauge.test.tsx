import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { StarGauge } from "../star-gauge";
import { SealMark } from "../seal-mark";
import type { ChapterRung } from "@/shared/lib/progress-stars";

/**
 * LA JAUGE ET LE CACHET — les deux primitives visuelles de l'étude 34.
 *
 * Ce que ce fichier protège, dans l'ordre d'importance :
 *  1. **un cran allumé ne dépend que de `lit`** — donc du grand livre. Si un
 *     jour quelqu'un recâblait la jauge sur le calcul vivant, tout l'objet de
 *     l'étude tomberait sans qu'aucun autre test ne rougisse ;
 *  2. **le nombre de crans suit le contenu** (D-3), pas une constante 4 ;
 *  3. **le RTL ne se fabrique pas** : la rangée est un flex simple, donc c'est le
 *     `dir` du conteneur qui décide. Un `flex-row-reverse` retournerait la jauge
 *     une seconde fois en arabe, donc la remettrait à l'endroit au mauvais endroit.
 */
const rung = (over: Partial<ChapterRung> & { tier: ChapterRung["tier"] }): ChapterRung => ({
  lit: false,
  counted: 0,
  total: 1,
  newMissions: 0,
  ...over,
});

describe("StarGauge", () => {
  it("dessine un cran par difficulté présente, jamais quatre par principe", () => {
    // US-5 : un chapitre qui n'a que ⭐ et ⭐⭐ a DEUX crans.
    render(<StarGauge rungs={[rung({ tier: 1 }), rung({ tier: 2 })]} label="2 crans" />);
    expect(screen.getByTestId("star-gauge").children).toHaveLength(2);
    expect(screen.getByTestId("star-rung-1")).toBeInTheDocument();
    expect(screen.queryByTestId("star-rung-3")).not.toBeInTheDocument();
  });

  it("garde les crans HAUTS d'un chapitre sans ⭐ ni ⭐⭐", () => {
    // 57 chapitres du corpus sont dans ce cas — la vacuité n'est pas un cas d'école.
    render(<StarGauge rungs={[rung({ tier: 3 }), rung({ tier: 4 })]} label="2 crans" />);
    expect(screen.getByTestId("star-rung-3")).toBeInTheDocument();
    expect(screen.queryByTestId("star-rung-1")).not.toBeInTheDocument();
  });

  it("allume un cran sur `lit`, et sur rien d'autre", () => {
    // Un cran acquis dont le VIVANT est retombé (une mission vient d'arriver :
    // 1 comptée sur 2) reste allumé. C'est l'invariant R-6, en une assertion.
    render(
      <StarGauge
        rungs={[
          rung({ tier: 1, lit: true, counted: 1, total: 2 }),
          rung({ tier: 2, lit: false, counted: 0, total: 1 }),
        ]}
        label="1 sur 2"
      />,
    );
    expect(screen.getByTestId("star-rung-1")).toHaveAttribute("data-lit", "true");
    expect(screen.getByTestId("star-rung-2")).toHaveAttribute("data-lit", "false");
  });

  it("ne compte QUE sur un cran à gagner — un acquis ne se justifie pas deux fois", () => {
    render(
      <StarGauge
        rungs={[
          rung({ tier: 1, lit: true, counted: 3, total: 3 }),
          rung({ tier: 2, counted: 1, total: 4 }),
        ]}
        label="1 sur 2"
      />,
    );
    expect(screen.queryByText("3/3")).not.toBeInTheDocument();
    expect(screen.getByText("1/4")).toBeInTheDocument();
  });

  it("marque ✨ le cran qui a grandi", () => {
    // US-1 : la réponse à « pourquoi ma jauge n'est-elle plus pleine ».
    render(
      <StarGauge
        rungs={[rung({ tier: 1, lit: true }), rung({ tier: 3, total: 2, newMissions: 1 })]}
        label="1 sur 2"
      />,
    );
    expect(screen.getByTestId("star-rung-3")).toHaveAttribute("data-new", "true");
    expect(screen.getByTestId("star-rung-1")).toHaveAttribute("data-new", "false");
    expect(screen.getByTestId("star-gauge").textContent).toContain("✨");
  });

  it("est UNE image, nommée — les crans ne parlent pas un à un", () => {
    render(<StarGauge rungs={[rung({ tier: 1, lit: true })]} label="1 étoile sur 1" />);
    expect(screen.getByRole("img", { name: "1 étoile sur 1" })).toBeInTheDocument();
  });

  it("se remplit dans le sens du conteneur, sans rien inverser elle-même", () => {
    // Le test regarde le CODE de la jauge, pas le rendu : `flex-row-reverse`
    // produirait un ordre correct en LTR et inversé en RTL, sans que rien ne casse.
    const { container } = render(
      <div dir="rtl">
        <StarGauge rungs={[rung({ tier: 1 }), rung({ tier: 2 })]} label="0 sur 2" />
      </div>,
    );
    const gauge = screen.getByTestId("star-gauge");
    expect(gauge.className).not.toContain("flex-row-reverse");
    expect(gauge.className).toContain("inline-flex");
    // L'ordre du DOM reste celui du contenu : ⭐ puis ⭐⭐, et c'est le navigateur
    // qui les pose de droite à gauche.
    expect([...gauge.children].map((c) => c.getAttribute("data-testid"))).toEqual([
      "star-rung-1",
      "star-rung-2",
    ]);
    expect(container.querySelector('[dir="rtl"]')).not.toBeNull();
  });

  it("ne rend RIEN pour un chapitre non publié", () => {
    // Pas de mission de catalogue, donc rien à jouer : une rangée vide se lirait
    // « zéro sur zéro », ce qui est un reproche adressé au contenu, pas à l'élève.
    const { container } = render(<StarGauge rungs={[]} label="aucun" />);
    expect(container.firstChild).toBeNull();
  });
});

describe("SealMark", () => {
  it("porte autant d'étoiles que son rang", () => {
    render(<SealMark star={3} earned label="Sceau ⭐⭐⭐" />);
    expect(screen.getByTestId("seal-mark")).toHaveTextContent("⭐⭐⭐");
    expect(screen.getByTestId("seal-mark")).toHaveAttribute("data-star", "3");
  });

  it("distingue l'acquis de l'attente — jamais un état « perdu »", () => {
    const { rerender } = render(<SealMark star={1} earned label="Sceau ⭐" />);
    expect(screen.getByTestId("seal-mark")).toHaveAttribute("data-earned", "true");
    rerender(<SealMark star={1} earned={false} label="Sceau ⭐" />);
    expect(screen.getByTestId("seal-mark")).toHaveAttribute("data-earned", "false");
  });

  it("est UNE image, nommée", () => {
    render(<SealMark star={2} earned={false} label="Sceau ⭐⭐" />);
    expect(screen.getByRole("img", { name: "Sceau ⭐⭐" })).toBeInTheDocument();
  });
});
