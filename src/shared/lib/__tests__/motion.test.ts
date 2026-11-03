import { describe, it, expect, vi, beforeEach } from "vitest";
import { act, createElement } from "react";
import { hydrateRoot } from "react-dom/client";
import { renderToString } from "react-dom/server";
import { renderHook } from "@testing-library/react";
import { useReducedMotion } from "motion/react";
import { entrance, questionSlide, useEntrance, MOTION_PRESETS } from "@/shared/lib/motion";

vi.mock("motion/react", () => ({ useReducedMotion: vi.fn() }));
const mockedReduced = vi.mocked(useReducedMotion);

describe("useEntrance", () => {
  beforeEach(() => mockedReduced.mockReset());

  it("returns the rise preset by default with an easeOut transition", () => {
    mockedReduced.mockReturnValue(false);
    const { result } = renderHook(() => useEntrance());
    expect(result.current).toEqual({
      initial: MOTION_PRESETS.rise.initial,
      animate: MOTION_PRESETS.rise.animate,
      transition: { duration: 0.35, ease: "easeOut", delay: 0 },
    });
  });

  it("threads the preset and delay through", () => {
    mockedReduced.mockReturnValue(false);
    const { result } = renderHook(() => useEntrance("scale", 0.2));
    expect(result.current).toMatchObject({
      initial: MOTION_PRESETS.scale.initial,
      transition: { delay: 0.2 },
    });
  });

  it("entrance (non-hook, staggered lists) mirrors the hook behaviour", () => {
    expect(entrance(false, "rise", 0.1)).toEqual({
      initial: MOTION_PRESETS.rise.initial,
      animate: MOTION_PRESETS.rise.animate,
      transition: { duration: 0.35, ease: "easeOut", delay: 0.1 },
    });
    expect(entrance(true, "rise", 0.1)).toEqual({ initial: false });
  });

  it("neutralizes the entrance under prefers-reduced-motion", () => {
    mockedReduced.mockReturnValue(true);
    const { result } = renderHook(() => useEntrance("fade", 0.5));
    // `initial: false` renders the element directly in its final state ; `animate` reste défini (voir
    // le bloc d'hydratation plus bas) et la durée est nulle : aucun mouvement, aucune image de départ.
    expect(result.current).toEqual({
      initial: false,
      animate: MOTION_PRESETS.fade.animate,
      transition: { duration: 0, ease: "easeOut", delay: 0 },
    });
  });
});

/**
 * LE BLOQUANT QUE L'AUDIT D'AFFICHAGE A TROUVÉ : sous « réduire les animations », la carte de /auth et
 * de /auth/reset restait à `opacity: 0` pour toujours — personne ne pouvait se connecter.
 *
 * Le serveur ne connaît pas la préférence : il rend l'état de DÉPART du preset
 * (`style="opacity:0;transform:scale(.95)"`). Ce qui se passe ensuite se joue en deux temps, et les deux
 * ont tenu la carte invisible :
 *   1. un premier rendu client en `initial: false` ne corrige pas ce style (React ne corrige pas les
 *      attributs à l'hydratation) ;
 *   2. retirer `animate` au rendu suivant fait « retourner `motion` à sa valeur de base » — celle du
 *      HTML serveur, donc `opacity: 0` — avant que l'animation ait écrit quoi que ce soit.
 * Ces tests fixent ce que le hook doit rendre à chaque étape ; l'e2e du tier public, lui, regarde
 * l'opacité réelle dans un navigateur.
 */
describe("useEntrance — l'hydratation sous « réduire les animations »", () => {
  const scale = MOTION_PRESETS.scale;
  const instant = { duration: 0, ease: "easeOut", delay: 0 };

  beforeEach(() => mockedReduced.mockReset());

  /** Un composant qui note ce que le hook rend à CHAQUE rendu. */
  function Probe({ seen }: { seen: unknown[] }) {
    seen.push(useEntrance("scale"));
    return createElement("div");
  }

  it("le serveur rend l'état de départ : il ne connaît pas la préférence", () => {
    mockedReduced.mockReturnValue(null);
    const seen: unknown[] = [];
    renderToString(createElement(Probe, { seen }));

    expect(seen[0]).toEqual({
      initial: scale.initial,
      animate: scale.animate,
      transition: { duration: 0.35, ease: "easeOut", delay: 0 },
    });
  });

  it("pendant l'hydratation, le client rend CE QUE LE SERVEUR A RENDU, avec une durée nulle", async () => {
    mockedReduced.mockReturnValue(null);
    const container = document.createElement("div");
    container.innerHTML = renderToString(createElement(Probe, { seen: [] }));
    document.body.appendChild(container);

    mockedReduced.mockReturnValue(true);
    const seen: unknown[] = [];
    await act(async () => {
      hydrateRoot(container, createElement(Probe, { seen }));
    });

    // Même `initial` que le serveur : pas de différence d'attribut, et `motion` amène l'élément à son
    // état final dès la première image, sans mouvement.
    expect(seen[0]).toEqual({
      initial: scale.initial,
      animate: scale.animate,
      transition: instant,
    });
    container.remove();
  });

  it("après l'hydratation, `initial` tombe à false mais `animate` RESTE défini", async () => {
    mockedReduced.mockReturnValue(null);
    const container = document.createElement("div");
    container.innerHTML = renderToString(createElement(Probe, { seen: [] }));
    document.body.appendChild(container);

    mockedReduced.mockReturnValue(true);
    const seen: unknown[] = [];
    await act(async () => {
      hydrateRoot(container, createElement(Probe, { seen }));
    });

    expect(seen.length).toBeGreaterThan(1);
    expect(seen[seen.length - 1]).toEqual({
      initial: false,
      animate: scale.animate,
      transition: instant,
    });
    // Aucun rendu ne retire `animate` : c'est ce retrait qui défaisait l'animation.
    for (const props of seen) expect(props).toHaveProperty("animate", scale.animate);
    container.remove();
  });

  it("sans réduction, l'hydratation n'est pas touchée : le mouvement normal, du début à la fin", async () => {
    mockedReduced.mockReturnValue(null);
    const container = document.createElement("div");
    container.innerHTML = renderToString(createElement(Probe, { seen: [] }));
    document.body.appendChild(container);

    mockedReduced.mockReturnValue(false);
    const seen: unknown[] = [];
    await act(async () => {
      hydrateRoot(container, createElement(Probe, { seen }));
    });

    for (const props of seen) {
      expect(props).toEqual({
        initial: scale.initial,
        animate: scale.animate,
        transition: { duration: 0.35, ease: "easeOut", delay: 0 },
      });
    }
    container.remove();
  });
});

describe("questionSlide", () => {
  it("slides the incoming question in and the outgoing one out", () => {
    expect(questionSlide(false)).toEqual({
      initial: { opacity: 0, x: 30 },
      animate: { opacity: 1, x: 0 },
      exit: { opacity: 0, x: -30 },
      transition: { duration: 0.3 },
    });
  });

  it("renders in place (no exit prop) under prefers-reduced-motion", () => {
    expect(questionSlide(true)).toEqual({ initial: false });
  });
});
