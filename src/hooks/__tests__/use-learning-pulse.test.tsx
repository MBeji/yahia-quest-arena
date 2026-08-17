import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { renderHook, act } from "@testing-library/react";

/**
 * Le hook qui alimente tout le suivi du temps. Ce qui est vérifié ici, ce n'est
 * pas « il appelle bien le serveur » mais les quatre décisions qui rendent la
 * mesure honnête : ne rien envoyer sans compte, ne pas compter un onglet caché,
 * solder avant de changer de cible, et ne jamais laisser une panne de télémétrie
 * remonter dans l'écran.
 */

/** La charge utile que le hook envoie — typée pour pouvoir l'inspecter. */
type PulsePayload = {
  data: {
    surface: string;
    activeSeconds: number;
    subjectId?: string;
    chapterId?: string;
    exerciseId?: string;
    progressPct?: number;
  };
};

const record = vi.fn(async (_payload: PulsePayload) => ({ credited: 60 }));

vi.mock("@tanstack/react-start", () => ({ useServerFn: () => record }));
vi.mock("@/shared/lib/learning-pulse.server", () => ({ recordLearningPulse: "server-fn" }));

import { useLearningPulse } from "../use-learning-pulse";

/** Avance les minuteries ET l'horloge ensemble — le hook lit `Date.now()`. */
async function advance(ms: number) {
  await act(async () => {
    vi.advanceTimersByTime(ms);
  });
}

function setVisibility(state: "visible" | "hidden") {
  Object.defineProperty(document, "visibilityState", { configurable: true, value: state });
  document.dispatchEvent(new Event("visibilitychange"));
}

describe("useLearningPulse", () => {
  beforeEach(() => {
    record.mockClear();
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-08-16T10:00:00Z"));
    setVisibility("visible");
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("n'émet rien tant que l'élève n'est pas connecté", async () => {
    renderHook(() => useLearningPulse({ surface: "lesson", chapterId: "c1", enabled: false }));
    await advance(180_000);
    expect(record).not.toHaveBeenCalled();
  });

  it("envoie le temps réellement passé, une fois par minute", async () => {
    renderHook(() =>
      useLearningPulse({ surface: "lesson", chapterId: "c1", subjectId: "math", progressPct: 42 }),
    );

    await advance(60_000);

    expect(record).toHaveBeenCalledTimes(1);
    expect(record.mock.calls[0][0]).toEqual({
      data: {
        surface: "lesson",
        activeSeconds: 55,
        subjectId: "math",
        chapterId: "c1",
        exerciseId: undefined,
        progressPct: 42,
      },
    });
  });

  it("ne compte pas un onglet masqué — le cours laissé ouvert ne gonfle rien", async () => {
    renderHook(() => useLearningPulse({ surface: "lesson", chapterId: "c1" }));

    await advance(10_000);
    act(() => setVisibility("hidden"));
    record.mockClear();

    await advance(300_000);
    expect(record).not.toHaveBeenCalled();
  });

  it("solde le compteur quand l'onglet passe en arrière-plan", async () => {
    renderHook(() => useLearningPulse({ surface: "lesson", chapterId: "c1" }));

    await advance(40_000);
    expect(record).not.toHaveBeenCalled(); // pas encore l'heure de l'envoi périodique

    await act(async () => {
      setVisibility("hidden");
    });

    expect(record).toHaveBeenCalledTimes(1);
    expect(record.mock.calls[0][0].data.activeSeconds).toBeGreaterThanOrEqual(35);
  });

  it("attribue le temps au chapitre quitté, pas au suivant", async () => {
    const { rerender } = renderHook(
      ({ chapterId }: { chapterId: string }) => useLearningPulse({ surface: "lesson", chapterId }),
      { initialProps: { chapterId: "chapitre-A" } },
    );

    await advance(40_000);
    await act(async () => {
      rerender({ chapterId: "chapitre-B" });
    });

    expect(record).toHaveBeenCalledTimes(1);
    expect(record.mock.calls[0][0].data.chapterId).toBe("chapitre-A");
  });

  it("solde au démontage plutôt que de perdre la dernière minute", async () => {
    const { unmount } = renderHook(() => useLearningPulse({ surface: "quiz", exerciseId: "e1" }));

    await advance(30_000);
    await act(async () => {
      unmount();
    });

    expect(record).toHaveBeenCalledTimes(1);
    expect(record.mock.calls[0][0].data.surface).toBe("quiz");
  });

  it("avale une panne de télémétrie sans la faire remonter dans l'écran", async () => {
    record.mockRejectedValueOnce(new Error("network down"));
    renderHook(() => useLearningPulse({ surface: "dungeon" }));

    await expect(advance(60_000)).resolves.not.toThrow();
    expect(record).toHaveBeenCalledTimes(1);
  });
});
