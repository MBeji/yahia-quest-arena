import { act, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 40, lot 2 — LE RAPPEL PROPOSÉ APRÈS UNE VICTOIRE (R-5, R-6, US-3) : à qui la carte
 * paraît, ce que fait chaque geste à la mémoire commune (R-12), sa place devant les autres
 * invitations, et l'attente bornée de l'état du push.
 */
type State = "loading" | "unsupported" | "unconfigured" | "default" | "granted" | "denied";
const push = {
  state: "default" as State,
  busy: false,
  enable: vi.fn<() => Promise<boolean>>(),
  disable: vi.fn(),
};
const usePushArgs = vi.fn();
vi.mock("../use-push", () => ({
  usePush: (options: unknown) => {
    usePushArgs(options);
    return { ...push };
  },
}));
const toastError = vi.fn();
vi.mock("sonner", () => ({ toast: { error: (...a: unknown[]) => toastError(...a) } }));

import { NudgeSlot, type NudgeCandidate } from "@/components/public/nudge-slot";
import { fr } from "@/lib/i18n/fr";
import { NUDGE_KEY } from "@/shared/lib/nudge-memory";
import {
  PUSH_STATE_WAIT_MS,
  usePushVictoryCandidate,
} from "../components/use-push-victory-candidate";

const TODAY = new Date("2026-11-13T10:00:00Z");

function Screen({ passed, install = false }: { passed: boolean; install?: boolean }) {
  const reminder = usePushVictoryCandidate(passed);
  const other: NudgeCandidate = {
    kind: "install",
    available: install,
    render: () => <p data-testid="nudge-install" />,
  };
  return <NudgeSlot candidates={[reminder, other]} />;
}

const card = () => screen.queryByTestId("push-victory");
const memory = (): Record<string, { shown: string; dismissed: number }> =>
  JSON.parse(window.localStorage.getItem(NUDGE_KEY) ?? "{}");
const setPermission = (value: NotificationPermission) =>
  Object.defineProperty(globalThis, "Notification", {
    value: { permission: value },
    configurable: true,
    writable: true,
  });

beforeEach(() => {
  vi.useFakeTimers({ toFake: ["Date", "setTimeout", "clearTimeout"] });
  vi.setSystemTime(TODAY);
  vi.clearAllMocks();
  window.localStorage.clear();
  push.state = "default";
  push.busy = false;
  setPermission("default");
});
afterEach(() => vi.useRealTimers());

describe("R-6 — à qui la carte paraît", () => {
  it("⭐ quête réussie, navigateur sans décision ⇒ la carte, en gain (R-5)", () => {
    render(<Screen passed />);
    expect(card()).toBeInTheDocument();
    expect(screen.getByText(fr.pushNotifications.cardTitle)).toBeInTheDocument();
    expect(fr.pushNotifications.cardDesc).not.toMatch(/danger|perd|casser/i);
    expect(usePushArgs).toHaveBeenCalledWith({ moment: "victory" });
  });

  it("⭐ quête ratée ⇒ jamais de carte", () => {
    render(<Screen passed={false} />);
    expect(card()).toBeNull();
  });

  it.each(["granted", "denied", "unsupported", "unconfigured"] as const)(
    "navigateur %s ⇒ jamais de carte",
    (state) => {
      push.state = state;
      render(<Screen passed />);
      expect(card()).toBeNull();
    },
  );

  it("⭐ passe devant l'installation : une seule carte, la sienne (R-12)", () => {
    render(<Screen passed install />);
    expect(card()).toBeInTheDocument();
    expect(screen.queryByTestId("nudge-install")).toBeNull();
  });

  it("montrée il y a moins de sept jours ⇒ l'installation prend la place", () => {
    window.localStorage.setItem(
      NUDGE_KEY,
      JSON.stringify({ push: { shown: "2026-11-10", dismissed: 0 } }),
    );
    render(<Screen passed install />);
    expect(card()).toBeNull();
    expect(screen.getByTestId("nudge-install")).toBeInTheDocument();
  });
});

describe("l'état du push se lit en asynchrone : l'emplacement l'attend, et pas plus de 1,5 s", () => {
  it("⭐ état en cours de lecture ⇒ rien n'est choisi ; lu `default` ⇒ la carte du rappel", () => {
    push.state = "loading";
    const view = render(<Screen passed install />);
    expect(card()).toBeNull();
    expect(screen.queryByTestId("nudge-install")).toBeNull();
    expect(memory()).toEqual({});

    push.state = "default";
    view.rerender(<Screen passed install />);
    expect(card()).toBeInTheDocument();
    expect(screen.queryByTestId("nudge-install")).toBeNull();
  });

  it("⭐ état jamais lu (pas de service worker) ⇒ l'emplacement choisit sans lui après l'attente", () => {
    push.state = "loading";
    render(<Screen passed install />);
    expect(screen.queryByTestId("nudge-install")).toBeNull();
    act(() => {
      vi.advanceTimersByTime(PUSH_STATE_WAIT_MS);
    });
    expect(screen.getByTestId("nudge-install")).toBeInTheDocument();
    expect(card()).toBeNull();
  });
});

describe("R-6, R-12 — ce que fait chaque geste", () => {
  it("⭐ « Plus tard » deux fois ⇒ elle ne revient plus jamais sur cet écran", () => {
    const first = render(<Screen passed />);
    fireEvent.click(screen.getByTestId("push-victory-later"));
    expect(card()).toBeNull();
    expect(memory().push).toEqual({ shown: "2026-11-13", dismissed: 1 });
    first.unmount();

    vi.setSystemTime(new Date("2026-11-20T10:00:00Z"));
    const second = render(<Screen passed />);
    fireEvent.click(screen.getByTestId("push-victory-later"));
    expect(memory().push?.dismissed).toBe(2);
    second.unmount();

    vi.setSystemTime(new Date("2026-12-30T10:00:00Z"));
    render(<Screen passed />);
    expect(card()).toBeNull();
  });

  it("⭐ « Activer », accordé ⇒ la carte part et ne revient plus", async () => {
    push.enable.mockResolvedValue(true);
    render(<Screen passed />);
    await act(async () => {
      fireEvent.click(screen.getByTestId("push-victory-enable"));
    });
    expect(push.enable).toHaveBeenCalledTimes(1);
    expect(card()).toBeNull();
    expect(memory().push?.dismissed).toBe(2);
  });

  it("« Activer », refusé par le navigateur ⇒ elle ne revient plus (le navigateur a tranché)", async () => {
    push.enable.mockImplementation(async () => {
      setPermission("denied");
      return false;
    });
    render(<Screen passed />);
    await act(async () => {
      fireEvent.click(screen.getByTestId("push-victory-enable"));
    });
    expect(memory().push?.dismissed).toBe(2);
  });

  it("« Activer », fenêtre du navigateur refermée ⇒ compté comme un refus", async () => {
    push.enable.mockResolvedValue(false);
    render(<Screen passed />);
    await act(async () => {
      fireEvent.click(screen.getByTestId("push-victory-enable"));
    });
    expect(card()).toBeNull();
    expect(memory().push?.dismissed).toBe(1);
  });

  it("une erreur d'enregistrement ⇒ un message, la carte reste", async () => {
    push.enable.mockRejectedValue(new Error("network"));
    render(<Screen passed />);
    await act(async () => {
      fireEvent.click(screen.getByTestId("push-victory-enable"));
    });
    expect(toastError).toHaveBeenCalledWith(fr.pushNotifications.errorGeneric);
    expect(card()).toBeInTheDocument();
  });
});
