// @vitest-environment jsdom
import { fireEvent, render, renderHook, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { I18nProvider } from "@/lib/i18n";
import { DungeonLeaveButton } from "../components/dungeon-leave";
import { useFinalizeRunOnLeave } from "../use-finalize-run-on-leave";

/**
 * Quitter une descente (audit de navigation du 2026-11-21, N-12 · arbitrage Q-6) : on confirme,
 * et la partie est finalisée — par le bouton comme par toute autre sortie de l'écran.
 */
describe("DungeonLeaveButton", () => {
  const renderButton = (onConfirm: () => void) =>
    render(
      <I18nProvider>
        <DungeonLeaveButton onConfirm={onConfirm} />
      </I18nProvider>,
    );

  it("ne quitte pas au premier geste : il demande d'abord", () => {
    const onConfirm = vi.fn();
    renderButton(onConfirm);
    fireEvent.click(screen.getByTestId("dungeon-leave"));
    expect(screen.getByRole("alertdialog")).toBeInTheDocument();
    expect(onConfirm).not.toHaveBeenCalled();
  });

  it("« Continuer » referme la question sans rien terminer", () => {
    const onConfirm = vi.fn();
    renderButton(onConfirm);
    fireEvent.click(screen.getByTestId("dungeon-leave"));
    fireEvent.click(screen.getByTestId("dungeon-leave-cancel"));
    expect(onConfirm).not.toHaveBeenCalled();
    expect(screen.queryByRole("alertdialog")).not.toBeInTheDocument();
  });

  it("la confirmation termine la partie (et donc la finalise)", () => {
    const onConfirm = vi.fn();
    renderButton(onConfirm);
    fireEvent.click(screen.getByTestId("dungeon-leave"));
    fireEvent.click(screen.getByTestId("dungeon-leave-confirm"));
    expect(onConfirm).toHaveBeenCalledTimes(1);
  });
});

describe("useFinalizeRunOnLeave", () => {
  it("finalise une partie EN COURS quand l'écran disparaît (onglet, logo, Retour)", () => {
    const finalize = vi.fn();
    const { rerender, unmount } = renderHook(
      ({ runId, playing }) => useFinalizeRunOnLeave({ runId, playing }, finalize),
      { initialProps: { runId: null as string | null, playing: false } },
    );
    // La partie démarre APRÈS le montage : c'est l'état au démontage qui compte.
    rerender({ runId: "run-1", playing: true });
    unmount();
    expect(finalize).toHaveBeenCalledWith("run-1");
  });

  it("ne touche à rien hors partie : au hall du donjon ou après le bilan", () => {
    const finalize = vi.fn();
    const { rerender, unmount } = renderHook(
      ({ runId, playing }) => useFinalizeRunOnLeave({ runId, playing }, finalize),
      { initialProps: { runId: "run-1" as string | null, playing: true } },
    );
    rerender({ runId: "run-1", playing: false });
    unmount();
    expect(finalize).not.toHaveBeenCalled();
  });
});
