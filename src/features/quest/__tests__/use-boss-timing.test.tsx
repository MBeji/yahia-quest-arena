import { act, renderHook } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { useBossTiming } from "../components/use-boss-timing";

/**
 * Le chronomètre du combat de boss, testé SEUL (il vivait dans `exercise-player`,
 * dont les tests le traversent mais n'épinglent pas ses invariants).
 *
 * Réponse en 1 s sur 5 questions : 20 de dégâts (`boss-speed.test.ts`), donc 80 PV.
 */
const totalRef = { current: 5 };

function setup(overrides: Partial<Parameters<typeof useBossTiming>[0]> = {}) {
  return renderHook((props) => useBossTiming(props), {
    initialProps: { bossMode: true, sessionId: "s1", idx: 0, totalRef, ...overrides },
  });
}

beforeEach(() => vi.useFakeTimers());
afterEach(() => vi.useRealTimers());

describe("useBossTiming", () => {
  it("hors combat de boss : barre pleine, aucun rang, et aucune mesure", () => {
    const { result } = setup({ bossMode: false });
    act(() => result.current.commitBossTiming("q1"));
    expect(result.current.bossHp).toBe(100);
    expect(result.current.bossSummary).toBeNull();
  });

  it("une question n'est mesurée qu'UNE fois — rejouer la validation ne re-frappe pas", () => {
    const { result } = setup();
    vi.advanceTimersByTime(1000);
    act(() => result.current.commitBossTiming("q1"));
    expect(result.current.bossHp).toBe(80);

    act(() => result.current.commitBossTiming("q1"));
    expect(result.current.bossHp).toBe(80);
  });

  it("le chrono d'une question repart à chaque index — la lenteur de la précédente ne se reporte pas", () => {
    const { result, rerender } = setup();
    vi.advanceTimersByTime(60_000);
    rerender({ bossMode: true, sessionId: "s1", idx: 1, totalRef });
    vi.advanceTimersByTime(1000);
    act(() => result.current.commitBossTiming("q2"));
    expect(result.current.bossHp).toBe(80);
  });

  it("la remise à zéro rend la barre pleine et permet de re-mesurer la même question", () => {
    const { result } = setup();
    vi.advanceTimersByTime(1000);
    act(() => result.current.commitBossTiming("q1"));
    expect(result.current.bossHp).toBe(80);

    act(() => result.current.resetBossTiming());
    expect(result.current.bossHp).toBe(100);

    act(() => result.current.commitBossTiming("q1"));
    expect(result.current.bossHp).toBe(80);
  });

  it("la remise à zéro garde la MÊME identité à chaque rendu", () => {
    // `resetRun` en dépend, et l'effet `[exerciseId, resetRun]` le relance : une
    // identité neuve à chaque rendu le ferait boucler à l'infini (100 % de CPU,
    // aucune page rendue) — le défaut vu et documenté dans le lecteur.
    const { result, rerender } = setup();
    const first = result.current.resetBossTiming;
    rerender({ bossMode: true, sessionId: "s1", idx: 1, totalRef });
    rerender({ bossMode: true, sessionId: "s2", idx: 2, totalRef });
    expect(result.current.resetBossTiming).toBe(first);
  });
});
