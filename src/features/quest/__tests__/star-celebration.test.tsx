import { act, render, renderHook, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, it, expect, vi } from "vitest";
import React from "react";

// Le dictionnaire factice rend `t.<section>.<clé>` — on vérifie le CÂBLAGE, pas
// les libellés, qui vivent dans fr/en/ar et sont contrôlés par le test du catalogue.
const t = new Proxy(
  {},
  { get: (_o, k1) => new Proxy({}, { get: (_o2, k2) => `${String(k1)}.${String(k2)}` }) },
);
vi.mock("@/lib/i18n/progress", () => ({ useProgressT: () => ({ progress: t }) }));

// `prefers-reduced-motion`, pilotable depuis les cas : `motion/react` lit la
// media query, que jsdom ne simule pas.
let reducedMotion = false;
vi.mock("motion/react", async (importOriginal) => {
  const actual = await importOriginal<typeof import("motion/react")>();
  return { ...actual, useReducedMotion: () => reducedMotion };
});

import { StarResultBlock } from "../components/star-result-block";
import { useAttemptCelebration } from "../use-attempt-celebration";
import { SealCelebration } from "@/components/ui/seal-celebration";
import type { AttemptProgress } from "@/shared/lib/progress-stars";

const progress = (over: Partial<AttemptProgress> = {}): AttemptProgress => ({
  chapterId: "c1",
  starBefore: 1,
  starAfter: 2,
  newStars: [2],
  newSeals: [],
  newBadges: [],
  rungs: [
    { tier: 1, lit: true, counted: 1, total: 1, newMissions: 0 },
    { tier: 2, lit: true, counted: 2, total: 2, newMissions: 0 },
    { tier: 3, lit: false, counted: 0, total: 1, newMissions: 0 },
  ],
  ...over,
});

/**
 * LE BLOC ÉTOILE — étude 34, R-12.
 *
 * Ce que ces cas protègent tient en une phrase : une fête à chaque exercice n'est
 * plus une fête. Le bloc n'apparaît QUE lorsque le grand livre a réellement
 * monté, et c'est le serveur qui le dit — le client n'a pas de quoi le deviner
 * sans recopier la règle.
 */
describe("StarResultBlock", () => {
  it("⭐ n'apparaît que lorsque l'étoile MONTE", () => {
    const { container } = render(<StarResultBlock progress={progress()} />);
    expect(screen.getByTestId("result-star-block")).toBeInTheDocument();
    expect(container.querySelector('[data-testid="star-gauge"]')).not.toBeNull();
  });

  it("se tait quand la soumission n'a rien fait monter", () => {
    // Une mission réussie sur un chapitre déjà à ce cran : rien de neuf, rien à fêter.
    const { container } = render(
      <StarResultBlock progress={progress({ starBefore: 2, starAfter: 2, newStars: [] })} />,
    );
    expect(container.firstChild).toBeNull();
  });

  it("se tait sans donnée — jamais de fête inventée", () => {
    const { container } = render(<StarResultBlock progress={null} />);
    expect(container.firstChild).toBeNull();
  });

  it("dit MAÎTRISÉ à l'étoile 4, et le palier autrement", () => {
    render(<StarResultBlock progress={progress({ starBefore: 3, starAfter: 4 })} />);
    expect(screen.getByTestId("result-star-body").textContent).toBe("celebration.starMastered");
  });

  it("compte les crans gagnés d'un coup", () => {
    // Un chapitre franchi en une fois — la copie plurielle existe pour ça.
    render(<StarResultBlock progress={progress({ starBefore: 0, starAfter: 3 })} />);
    expect(screen.getByTestId("result-star-block").textContent).toContain(
      "celebration.starTitlePlural",
    );
  });

  it("⭐ ne promet NI XP NI pièce (R-11, D-10)", () => {
    // La reconnaissance suffit ; l'étude 09 garde seule la main sur la valeur.
    render(<StarResultBlock progress={progress()} />);
    expect(screen.getByTestId("result-star-block").textContent).not.toMatch(/XP|pièce|coin/i);
  });
});

/**
 * LA MODALE DE SCEAU — R-12 et é31 R-6.
 *
 * Deux interdits qu'aucune autre couche ne peut tenir : elle n'enchaîne rien, et
 * elle respecte `prefers-reduced-motion`. Son aînée `level-up-celebration` ne fait
 * pas le second ; ce test empêche le jumeau d'hériter du défaut.
 */
describe("SealCelebration", () => {
  const props = {
    show: true,
    star: 3 as const,
    subjectName: "Mathématiques",
    title: "Sceau ⭐⭐⭐",
    body: "Tous les chapitres portent l'étoile.",
    hint: "Touche pour revenir.",
  };

  it("atteste le sceau et nomme la matière", () => {
    render(<SealCelebration {...props} />);
    expect(screen.getByTestId("seal-celebration")).toBeInTheDocument();
    expect(screen.getByTestId("seal-celebration-subject").textContent).toBe("Mathématiques");
  });

  it("n'existe pas tant qu'il n'y a rien à fêter", () => {
    const { container } = render(<SealCelebration {...props} show={false} />);
    expect(container.firstChild).toBeNull();
  });

  it("⭐ n'ENCHAÎNE RIEN (é31 R-6) : un tap ferme, et c'est tout", () => {
    // Aucun lien, aucun bouton « continuer » : une modale qui propose une suite
    // transforme un sommet en tapis roulant.
    const onComplete = vi.fn();
    const { container } = render(<SealCelebration {...props} onComplete={onComplete} />);
    expect(container.querySelectorAll("a")).toHaveLength(0);
    expect(container.querySelectorAll("button")).toHaveLength(0);
    screen.getByTestId("seal-celebration").click();
    expect(onComplete).toHaveBeenCalledTimes(1);
  });

  it("⭐ respecte `prefers-reduced-motion` — ce que son aînée ne fait pas", () => {
    // `level-up-celebration` fait tomber 60 particules quoi qu'il arrive. Ici, le
    // mouvement réduit garde la modale et son cachet, et supprime les étincelles :
    // un élève qui a demandé moins de mouvement ne paie pas sa reconnaissance en
    // vertige. Le test lit le DOM, pas l'intention.
    const { container, rerender } = render(<SealCelebration {...props} />);
    const withMotion = container.querySelectorAll("span.absolute.rounded-full").length;
    expect(withMotion).toBeGreaterThan(0);

    reducedMotion = true;
    rerender(<SealCelebration {...props} />);
    expect(container.querySelectorAll("span.absolute.rounded-full")).toHaveLength(0);
    // …et l'essentiel reste : le sceau, la matière, le texte.
    expect(screen.getByTestId("seal-celebration-subject").textContent).toBe("Mathématiques");
    reducedMotion = false;
  });

  it("se nomme pour un lecteur d'écran", () => {
    render(<SealCelebration {...props} />);
    expect(screen.getByRole("dialog", { name: "Sceau ⭐⭐⭐" })).toBeInTheDocument();
  });
});

/**
 * LE REPORT DE LA MODALE — étude 34, R-12, et ce qu'il doit à é31 R-6.
 *
 * La modale de sceau attend que le level-up ait fini de passer, donc elle vit
 * dans un `setTimeout`. Un timer est la seule pièce de cette célébration qui
 * SURVIT à ce qui l'a demandée : c'est ce que ces cas tiennent.
 */
describe("useAttemptCelebration", () => {
  const withSeal = {
    chapterId: "c1",
    starBefore: 3,
    starAfter: 4,
    newStars: [4],
    newSeals: [{ subjectId: "math", star: 4 }],
    newBadges: [],
    rungs: [{ difficulty: 1, total: 1, counted: 1, new: 0 }],
  };
  const play = vi.fn();

  beforeEach(() => {
    vi.useFakeTimers();
    play.mockClear();
  });
  afterEach(() => {
    vi.useRealTimers();
  });

  /** Laisse la promesse de lecture se résoudre AVANT d'avancer les timers. */
  const settle = async (): Promise<void> => {
    await act(async () => {
      await vi.advanceTimersByTimeAsync(0);
    });
  };

  it("lève la modale après le report quand un sceau tombe", async () => {
    const { result } = renderHook(() =>
      useAttemptCelebration(() => Promise.resolve(withSeal), play),
    );
    act(() => result.current.load({ exerciseId: "e1", replayed: false, leveledUp: false }));
    await settle();
    expect(result.current.showSeal).toBe(false); // pas avant le report
    await act(async () => {
      await vi.advanceTimersByTimeAsync(1400);
    });
    expect(result.current.showSeal).toBe(true);
    expect(play).toHaveBeenCalledWith("unlock");
  });

  it("⭐ un enchaînement ANNULE le sceau en vol — il ne se lève pas sur l'exercice suivant", async () => {
    const { result } = renderHook(() =>
      useAttemptCelebration(() => Promise.resolve(withSeal), play),
    );
    act(() => result.current.load({ exerciseId: "e1", replayed: false, leveledUp: false }));
    await settle();

    // L'élève enchaîne AVANT la fin du report : le lecteur se réinitialise (il ne
    // se démonte pas — c'est le même composant qui sert l'exercice suivant).
    act(() => result.current.reset());
    await act(async () => {
      await vi.advanceTimersByTimeAsync(5000);
    });

    // Sans l'annulation, le timer survivrait au reset et lèverait ici le sceau de
    // l'exercice PRÉCÉDENT sur le nouveau — une fête qui ment sur ce qu'elle fête.
    expect(result.current.showSeal).toBe(false);
    expect(play).not.toHaveBeenCalled();
  });

  it("⭐ le démontage n'ouvre rien non plus", async () => {
    const { result, unmount } = renderHook(() =>
      useAttemptCelebration(() => Promise.resolve(withSeal), play),
    );
    act(() => result.current.load({ exerciseId: "e1", replayed: false, leveledUp: false }));
    await settle();
    unmount();
    await act(async () => {
      await vi.advanceTimersByTimeAsync(5000);
    });
    expect(play).not.toHaveBeenCalled();
  });

  it("un rejeu ne lit rien et ne fête rien", async () => {
    const load = vi.fn(() => Promise.resolve(withSeal));
    const { result } = renderHook(() => useAttemptCelebration(load, play));
    act(() => result.current.load({ exerciseId: "e1", replayed: true, leveledUp: false }));
    await settle();
    expect(load).not.toHaveBeenCalled();
    expect(result.current.progress).toBeNull();
  });

  it("une lecture qui échoue se tait, elle n'invente pas", async () => {
    const { result } = renderHook(() =>
      useAttemptCelebration(() => Promise.reject(new Error("offline")), play),
    );
    act(() => result.current.load({ exerciseId: "e1", replayed: false, leveledUp: false }));
    await settle();
    await act(async () => {
      await vi.advanceTimersByTimeAsync(5000);
    });
    expect(result.current.progress).toBeNull();
    expect(result.current.showSeal).toBe(false);
  });
});
