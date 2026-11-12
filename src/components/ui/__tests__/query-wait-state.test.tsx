import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { afterEach, describe, expect, it, vi } from "vitest";
import { onlineManager } from "@tanstack/react-query";
import { I18nProvider } from "@/lib/i18n";
import { fr } from "@/lib/i18n/fr";
import { WaitingForNetwork, isWaitingForNetwork } from "../query-wait-state";

afterEach(() => {
  onlineManager.setOnline(true);
  vi.restoreAllMocks();
});

describe("isWaitingForNetwork", () => {
  it("vrai pour une lecture en pause qui n'a rien à montrer", () => {
    expect(isWaitingForNetwork({ fetchStatus: "paused", data: undefined })).toBe(true);
  });

  it("faux quand la lecture en pause a déjà ses données : l'écran les affiche", () => {
    expect(isWaitingForNetwork({ fetchStatus: "paused", data: { subject: 1 } })).toBe(false);
    // `null` est une réponse (« rien trouvé »), pas une absence de réponse.
    expect(isWaitingForNetwork({ fetchStatus: "paused", data: null })).toBe(false);
  });

  it("faux quand la lecture est en cours ou au repos : le squelette reste le bon écran", () => {
    expect(isWaitingForNetwork({ fetchStatus: "fetching", data: undefined })).toBe(false);
    expect(isWaitingForNetwork({ fetchStatus: "idle", data: undefined })).toBe(false);
  });
});

describe("WaitingForNetwork", () => {
  const renderState = (onRetry = vi.fn()) => {
    render(
      <I18nProvider>
        <WaitingForNetwork onRetry={onRetry} />
      </I18nProvider>,
    );
    return onRetry;
  };

  it("dit ce que l'écran attend, et propose de réessayer", () => {
    renderState();
    expect(screen.getByTestId("waiting-for-network")).toHaveTextContent(fr.offline.waiting);
    expect(screen.getByText(fr.offline.waitingDesc)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: fr.common.retry })).toBeInTheDocument();
  });

  it("« Réessayer » relance la lecture", async () => {
    const onRetry = renderState();
    await userEvent.click(screen.getByRole("button", { name: fr.common.retry }));
    expect(onRetry).toHaveBeenCalledTimes(1);
  });

  it("« Réessayer » rattrape un retour du réseau que le navigateur n'a pas annoncé", async () => {
    onlineManager.setOnline(false);
    vi.spyOn(navigator, "onLine", "get").mockReturnValue(true);
    renderState();
    await userEvent.click(screen.getByRole("button", { name: fr.common.retry }));
    expect(onlineManager.isOnline()).toBe(true);
  });

  it("« Réessayer » ne déclare pas le réseau revenu quand il ne l'est pas", async () => {
    onlineManager.setOnline(false);
    vi.spyOn(navigator, "onLine", "get").mockReturnValue(false);
    const onRetry = renderState();
    await userEvent.click(screen.getByRole("button", { name: fr.common.retry }));
    expect(onlineManager.isOnline()).toBe(false);
    expect(onRetry).toHaveBeenCalledTimes(1);
  });
});
