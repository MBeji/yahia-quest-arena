import { describe, expect, it } from "vitest";
import {
  PULSE_IDLE_MS,
  PULSE_MAX_SECONDS,
  PULSE_MAX_TICK_MS,
  advancePulse,
  createPulseState,
  readingProgressPct,
  takePulseSeconds,
  type PulseState,
} from "../learning-pulse";

/**
 * Ce compteur décide de ce qui sera affiché au parent comme « temps
 * d'apprentissage ». Chaque cas ci-dessous correspond à une manière réelle de
 * fausser cette mesure — onglet laissé ouvert, machine en veille, horloge qui
 * recule — et à ce qui doit alors être compté : rien.
 */

const T0 = 1_700_000_000_000;

/** Enchaîne des tics de 5 s, avec un état de visibilité/inactivité constant. */
function run(
  state: PulseState,
  ticks: number,
  options: { visible?: boolean; idleFor?: number; stepMs?: number } = {},
): PulseState {
  const { visible = true, idleFor = 0, stepMs = 5_000 } = options;
  let next = state;
  let now = state.lastTickAt ?? T0;
  for (let i = 0; i < ticks; i += 1) {
    now += stepMs;
    next = advancePulse(next, { now, visible, lastInteractionAt: now - idleFor });
  }
  return next;
}

describe("advancePulse", () => {
  it("ne crédite rien au tout premier tic (aucune tranche antérieure)", () => {
    const state = advancePulse(createPulseState(), {
      now: T0,
      visible: true,
      lastInteractionAt: T0,
    });
    expect(state.activeMs).toBe(0);
    expect(state.lastTickAt).toBe(T0);
  });

  it("accumule le temps quand l'onglet est visible et l'élève actif", () => {
    const start = advancePulse(createPulseState(), {
      now: T0,
      visible: true,
      lastInteractionAt: T0,
    });
    expect(run(start, 12).activeMs).toBe(60_000);
  });

  it("ne compte pas un onglet masqué — c'est le cas du cours laissé ouvert", () => {
    const start = advancePulse(createPulseState(), {
      now: T0,
      visible: true,
      lastInteractionAt: T0,
    });
    const after = run(start, 12, { visible: false });
    expect(after.activeMs).toBe(0);
    // L'horloge avance quand même : au retour, on ne rattrape pas le temps perdu.
    expect(after.lastTickAt).toBe(T0 + 60_000);
  });

  it("ne compte pas au-delà du délai d'inactivité", () => {
    const start = advancePulse(createPulseState(), {
      now: T0,
      visible: true,
      lastInteractionAt: T0,
    });
    expect(run(start, 12, { idleFor: PULSE_IDLE_MS + 1_000 }).activeMs).toBe(0);
  });

  it("plafonne une tranche géante — onglet gelé, machine en veille", () => {
    const start = advancePulse(createPulseState(), {
      now: T0,
      visible: true,
      lastInteractionAt: T0,
    });
    const twoHoursLater = T0 + 7_200_000;
    const after = advancePulse(start, {
      now: twoHoursLater,
      visible: true,
      lastInteractionAt: twoHoursLater,
    });
    expect(after.activeMs).toBe(PULSE_MAX_TICK_MS);
  });

  it("ignore une horloge qui recule au lieu de créditer un négatif", () => {
    const start = advancePulse(createPulseState(), {
      now: T0,
      visible: true,
      lastInteractionAt: T0,
    });
    const after = advancePulse(start, {
      now: T0 - 30_000,
      visible: true,
      lastInteractionAt: T0,
    });
    expect(after.activeMs).toBe(0);
    expect(after.lastTickAt).toBe(T0 - 30_000);
  });
});

describe("takePulseSeconds", () => {
  it("n'envoie rien sous le plancher — pas de ligne d'une seconde en base", () => {
    const { seconds, next } = takePulseSeconds({ activeMs: 3_000, lastTickAt: T0 });
    expect(seconds).toBe(0);
    expect(next.activeMs).toBe(3_000);
  });

  it("garde le reliquat sub-seconde : une heure de lecture ne perd pas ses miettes", () => {
    const { seconds, next } = takePulseSeconds({ activeMs: 61_400, lastTickAt: T0 });
    expect(seconds).toBe(61);
    expect(next.activeMs).toBe(400);
  });

  it("plafonne un envoi au maximum accepté par le serveur", () => {
    const { seconds, next } = takePulseSeconds({ activeMs: 3_600_000, lastTickAt: T0 });
    expect(seconds).toBe(PULSE_MAX_SECONDS);
    expect(next.activeMs).toBe(3_600_000 - PULSE_MAX_SECONDS * 1_000);
  });
});

describe("readingProgressPct", () => {
  const viewportHeight = 800;

  it("compte un contenu plus court que l'écran comme entièrement atteint", () => {
    expect(
      readingProgressPct({ contentTop: 100, contentHeight: 400, viewportHeight, scrollY: 0 }),
    ).toBe(100);
  });

  it("mesure la descente dans un long cours", () => {
    // Contenu de 4 000 px commençant à 200 px : à mi-parcours du défilement.
    expect(
      readingProgressPct({ contentTop: 200, contentHeight: 4_000, viewportHeight, scrollY: 1_400 }),
    ).toBe(50);
  });

  it("borne à 0 et 100 quoi qu'il arrive", () => {
    expect(
      readingProgressPct({ contentTop: 2_000, contentHeight: 4_000, viewportHeight, scrollY: 0 }),
    ).toBe(0);
    expect(
      readingProgressPct({ contentTop: 0, contentHeight: 4_000, viewportHeight, scrollY: 99_999 }),
    ).toBe(100);
  });

  it("rend 0 sur une hauteur absurde plutôt que NaN", () => {
    expect(
      readingProgressPct({ contentTop: 0, contentHeight: 0, viewportHeight, scrollY: 100 }),
    ).toBe(0);
    expect(
      readingProgressPct({
        contentTop: 0,
        contentHeight: Number.NaN,
        viewportHeight,
        scrollY: 100,
      }),
    ).toBe(0);
  });
});
