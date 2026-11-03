import { describe, it, expect, vi, afterEach } from "vitest";
import { render, fireEvent } from "@testing-library/react";
import { useState } from "react";
import DOMPurify from "dompurify";

import { RichField, OptionContent, SvgFigure } from "@/components/ui/svg-figure";

// Authored figures use dark ink (#1f2937, currentColor, …) and the default
// theme is dark, so a figure rendered straight onto the card would be
// dark-on-dark and invisible. Every figure must sit on a light "paper" surface
// with dark default text. These tests pin that contract.
const TRIANGLE =
  '<svg viewBox="0 0 10 10"><polygon points="1,9 1,1 9,9" fill="none" stroke="currentColor"/></svg>';
const DARK_INK =
  '<svg viewBox="0 0 10 10"><rect x="1" y="1" width="8" height="8" fill="none" stroke="#1f2937"/></svg>';

const surface = (el: HTMLElement | null) => el?.className ?? "";

describe("figure rendering — visible on a light surface", () => {
  it("RichField draws the prompt figure on a white surface with dark text", () => {
    const { container } = render(<RichField raw={`ما نوع هذا الشكل؟ ${DARK_INK}`} />);
    const figure = container.querySelector("svg")?.parentElement ?? null;
    expect(surface(figure)).toMatch(/bg-white/);
    expect(surface(figure)).toMatch(/text-slate-900/);
    expect(container.querySelector("svg")).not.toBeNull();
  });

  it("RichField gives the figure a definite width so a viewBox-only SVG can't collapse", () => {
    const { container } = render(<RichField raw={DARK_INK} />);
    const figure = container.querySelector("svg")?.parentElement ?? null;
    // a definite container width + the svg filling it (w-full/h-auto) drives the
    // viewBox ratio to a real, visible size instead of the 300x150 default.
    expect(surface(figure)).toMatch(/\bw-64\b/);
    expect(surface(figure)).toMatch(/\[&>svg\]:w-full/);
    expect(surface(figure)).toMatch(/\[&>svg\]:h-auto/);
  });

  it("OptionContent draws an option figure on the same light surface", () => {
    const { container } = render(<OptionContent raw={TRIANGLE} />);
    const figure = container.querySelector("svg")?.parentElement ?? null;
    expect(surface(figure)).toMatch(/bg-white/);
    expect(surface(figure)).toMatch(/text-slate-900/);
  });

  it("SvgFigure keeps the sanitized drawing primitives", () => {
    const { container } = render(<SvgFigure markup={DARK_INK} />);
    expect(container.querySelector("rect")).not.toBeNull();
  });
});

// Une page arabe est `dir="rtl"` et un SVG hérite de `direction` : les ancres
// `text-anchor="start"` / `"end"` s'y inversent (mesuré dans Chromium : une
// graduation `end` posée à x = 150 occupe [96, 150] en LTR, [150, 204] en RTL —
// par-dessus l'axe qu'elle devait border). Un schéma est de la géométrie : il se
// pose gauche-à-droite quel que soit le sens de la page qui le porte.
describe("figure rendering — ancrée gauche-à-droite dans une page arabe", () => {
  const AXIS_TICK =
    '<svg viewBox="0 0 100 30"><text x="50" y="20" text-anchor="end">123</text></svg>';
  const figureOf = (container: HTMLElement) =>
    container.querySelector("svg")?.parentElement ?? null;

  it("SvgFigure se pose dir=ltr", () => {
    const { container } = render(<SvgFigure markup={AXIS_TICK} />);
    expect(figureOf(container)?.getAttribute("dir")).toBe("ltr");
  });

  it("RichField garde la figure d'un énoncé arabe en dir=ltr, même sous un ancêtre dir=rtl", () => {
    const { container } = render(
      <div dir="rtl">
        <RichField raw={`ما قيمة العدد المقروء على المحور؟ ${AXIS_TICK}`} />
      </div>,
    );
    expect(figureOf(container)?.getAttribute("dir")).toBe("ltr");
  });

  it("OptionContent garde la figure d'une option en dir=ltr", () => {
    const { container } = render(
      <div dir="rtl">
        <OptionContent raw={AXIS_TICK} />
      </div>,
    );
    expect(figureOf(container)?.getAttribute("dir")).toBe("ltr");
  });

  it("ne change ni le texte de l'énoncé ni sa direction", () => {
    const { container } = render(
      <RichField raw={`ما قيمة العدد المقروء على المحور؟ ${AXIS_TICK}`} />,
    );
    expect(container.firstElementChild?.getAttribute("dir")).toBe("rtl");
  });
});

// ---------------------------------------------------------------------------
// Une équation ne se coupe jamais en deux lignes, et ne se mêle pas au texte.
//
// L'isolat Unicode posé par `isolateLtrRuns` corrige l'ORDRE des glyphes, pas le
// RETOUR À LA LIGNE. Un énoncé arabe un peu long voyait donc son équation scindée
// entre deux lignes, chacune réordonnée pour elle-même — la capture signalée sur
// `(x − 4)(x + 2) = 0`. Seul le rendu peut l'empêcher : ces tests l'épinglent.
// ---------------------------------------------------------------------------
const PROMPT_AR = "بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟";

describe("rendu des formules — insécables et hors du texte", () => {
  it("pose l'équation d'un énoncé arabe dans un seul élément insécable", () => {
    const { container } = render(<RichField raw={PROMPT_AR} />);
    const runs = container.querySelectorAll(".math-run");
    expect(runs).toHaveLength(1);
    expect(runs[0].textContent).toContain("(x − 4)(x + 2) = 0");
    expect(runs[0].className).toContain("math-run-tight");
  });

  it("rend le texte de l'énoncé sans y glisser de caractère invisible", () => {
    const { container } = render(<RichField raw={PROMPT_AR} />);
    // L'isolement passe désormais par un élément, plus par des LRI/PDI insérés
    // dans le texte : ce que lit un lecteur d'écran est l'énoncé, exactement.
    expect(container.textContent).toBe(PROMPT_AR);
    expect(container.textContent).not.toMatch(/[⁦-⁩]/);
  });

  it("laisse la prose sans formule exactement telle quelle", () => {
    const { container } = render(<RichField raw="ما ينصّ عليه مبدأ الجداء المعدوم؟" />);
    expect(container.querySelectorAll(".math-run")).toHaveLength(0);
    expect(container.textContent).toBe("ما ينصّ عليه مبدأ الجداء المعدوم؟");
  });

  it("pose une ligne qui n'est QUE la formule en bloc centré, hors de la question", () => {
    const { container } = render(
      <RichField
        raw={"بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة التالية؟\n(x − 4)(x + 2) = 0"}
      />,
    );
    const equation = container.querySelector(".math-equation");
    expect(equation?.textContent).toBe("(x − 4)(x + 2) = 0");
    // La prose garde sa propre ligne — le saut authored n'est plus aplati en espace.
    expect(container.querySelectorAll(".block")).toHaveLength(1);
  });

  it("garde chaque ligne authored sur sa ligne (support de lecture puis question)", () => {
    const { container } = render(
      <RichField raw={'Read: "Tom is from London."\nWhere is Tom from?'} as="p" />,
    );
    const lines = container.querySelectorAll("p > span.block");
    expect(lines).toHaveLength(2);
    expect(lines[1].textContent).toBe("Where is Tom from?");
    // `as="p"` : les lignes sont des <span> en display:block, jamais des <p> imbriqués.
    expect(container.querySelector("p p")).toBeNull();
  });

  it("garde aussi la formule d'un énoncé latin d'un seul tenant", () => {
    const { container } = render(
      <RichField raw="Quelle est la solution de (x − 4)(x + 2) = 0 ?" />,
    );
    const runs = container.querySelectorAll(".math-run");
    expect(runs).toHaveLength(1);
    expect(runs[0].textContent?.trim()).toBe("(x − 4)(x + 2) = 0");
  });

  it("n'exige pas l'insécable d'une chaîne de calcul trop longue pour une ligne", () => {
    const { container } = render(
      <RichField raw="الحساب p(Y = 1) = 4 × 0,368 × 0,632³ ≈ 4 × 0,368 ≈ 0,372 إذن" />,
    );
    const runs = container.querySelectorAll(".math-run");
    expect(runs).toHaveLength(1);
    expect(runs[0].className).not.toContain("math-run-tight");
  });

  it("isole aussi la formule d'une option de réponse", () => {
    const { container } = render(<OptionContent raw="x = −4 و x = 2" />);
    expect(container.querySelectorAll(".math-run").length).toBeGreaterThan(0);
    expect(container.textContent).toBe("x = −4 و x = 2");
  });
});

// Le lecteur, le donjon, l'examen et les écrans de correction re-rendent ces
// composants à chaque tic d'état (sélection, verdict, autosave, confettis, chaque
// mouvement du pointeur sur un plateau), sans que `raw` change. Mesuré le
// 2026-10-31 (jsdom) : 5 sanitize au montage d'une question à figures et +5 à
// chaque tap, ≈2,5 ms chacun. Le cache de module en tient le compte à 1 par
// chaîne — la politique XSS reste la même, le sanitiseur tourne à la première vue.
describe("figure rendering — une figure n'est assainie qu'une fois par chaîne", () => {
  const figure = (seed: number) =>
    `<svg viewBox="0 0 10 10"><circle cx="${seed}" cy="5" r="2" fill="#1f2937"/></svg>`;
  const PROMPT = `حلّ المعادلة (x − 4)(x + 2) = 0 ${figure(100)}`;
  const OPTIONS = [101, 102, 103, 104].map((seed) => `x = ${seed} ${figure(seed)}`);

  afterEach(() => {
    vi.restoreAllMocks();
  });

  function Question() {
    const [taps, setTaps] = useState(0);
    return (
      <div>
        <button onClick={() => setTaps(taps + 1)}>{taps}</button>
        <RichField raw={PROMPT} />
        {OPTIONS.map((raw) => (
          <OptionContent key={raw} raw={raw} />
        ))}
      </div>
    );
  }

  it("un tic d'état du parent ne relance aucun DOMPurify sur les figures déjà vues", () => {
    const sanitize = vi.spyOn(DOMPurify, "sanitize");
    const { getByRole, container } = render(<Question />);
    expect(sanitize).toHaveBeenCalledTimes(5);
    for (let tap = 0; tap < 6; tap++) fireEvent.click(getByRole("button"));
    expect(sanitize).toHaveBeenCalledTimes(5);
    expect(container.querySelectorAll("svg")).toHaveLength(5);
  });

  it("une même chaîne remontée ailleurs (correction après le lecteur) ne repasse pas par le sanitiseur", () => {
    const sanitize = vi.spyOn(DOMPurify, "sanitize");
    const { unmount } = render(<OptionContent raw={OPTIONS[0]} />);
    unmount();
    render(<OptionContent raw={OPTIONS[0]} />);
    expect(sanitize).not.toHaveBeenCalled();
  });

  it("une chaîne jamais vue passe toujours par le sanitiseur, et en garde le résultat", () => {
    const sanitize = vi.spyOn(DOMPurify, "sanitize");
    const hostile =
      '<svg viewBox="0 0 10 10"><script>alert(1)</script><rect width="4" height="4"/></svg>';
    const first = render(<SvgFigure markup={hostile} />);
    expect(sanitize).toHaveBeenCalledTimes(1);
    expect(first.container.querySelector("script")).toBeNull();
    expect(first.container.querySelector("rect")).not.toBeNull();
    const second = render(<SvgFigure markup={hostile} />);
    expect(sanitize).toHaveBeenCalledTimes(1);
    expect(second.container.querySelector("script")).toBeNull();
  });

  it("le cache est borné : au-delà de 512 chaînes, la plus ancienne est réassainie", () => {
    const sanitize = vi.spyOn(DOMPurify, "sanitize");
    const oldest = figure(1000);
    render(<SvgFigure markup={oldest} />);
    expect(sanitize).toHaveBeenCalledTimes(1);
    for (let seed = 1001; seed <= 1512; seed++) render(<SvgFigure markup={figure(seed)} />);
    expect(sanitize).toHaveBeenCalledTimes(513);
    render(<SvgFigure markup={oldest} />);
    expect(sanitize).toHaveBeenCalledTimes(514);
  });
});
