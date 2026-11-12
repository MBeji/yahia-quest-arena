import { act, render, screen, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it } from "vitest";
import { onlineManager } from "@tanstack/react-query";
import { I18nProvider } from "@/lib/i18n";
import { fr } from "@/lib/i18n/fr";
import { clearOutboxForTests, enqueue, remove } from "@/shared/lib/outbox";
import { NetworkBanner } from "../network-banner";

const renderBanner = () =>
  render(
    <I18nProvider>
      <button type="button">ailleurs</button>
      <NetworkBanner />
    </I18nProvider>,
  );

const mission = (clientId: string) => ({ clientId, kind: "quest-submit", payload: {} });

beforeEach(() => clearOutboxForTests());
afterEach(() => {
  onlineManager.setOnline(true);
  clearOutboxForTests();
});

describe("NetworkBanner — le réseau se voit (étude 38, lot 4)", () => {
  it("en ligne : la région d'annonce existe déjà, vide", () => {
    renderBanner();
    const region = screen.getByRole("status");
    expect(region).toHaveAttribute("aria-live", "polite");
    expect(region).toBeEmptyDOMElement();
  });

  it("hors connexion : le dit, dans la région annoncée, sans prendre le focus", () => {
    renderBanner();
    const elsewhere = screen.getByRole("button", { name: "ailleurs" });
    elsewhere.focus();

    act(() => onlineManager.setOnline(false));

    expect(screen.getByRole("status")).toHaveTextContent(fr.offline.banner);
    expect(elsewhere).toHaveFocus();
    expect(screen.queryByTestId("network-banner-pending")).toBeNull();
  });

  it("retour du réseau : le bandeau s'efface seul", () => {
    renderBanner();
    act(() => onlineManager.setOnline(false));
    expect(screen.getByRole("status")).not.toBeEmptyDOMElement();

    act(() => onlineManager.setOnline(true));
    expect(screen.getByRole("status")).toBeEmptyDOMElement();
  });

  it("une mission en file : « 1 mission en attente d'envoi »", async () => {
    enqueue(mission("a"));
    renderBanner();
    act(() => onlineManager.setOnline(false));

    await waitFor(() =>
      expect(screen.getByTestId("network-banner-pending")).toHaveTextContent(fr.offline.pendingOne),
    );
    expect(fr.offline.pendingOne).toBe("1 mission en attente d'envoi");
  });

  it("suit la file : une seconde mission, puis la file qui se vide", async () => {
    enqueue(mission("a"));
    renderBanner();
    act(() => onlineManager.setOnline(false));
    await screen.findByTestId("network-banner-pending");

    act(() => enqueue(mission("b")));
    await waitFor(() =>
      expect(screen.getByTestId("network-banner-pending")).toHaveTextContent(
        fr.offline.pendingMany.replace("{n}", "2"),
      ),
    );

    act(() => {
      remove("a");
      remove("b");
    });
    await waitFor(() => expect(screen.queryByTestId("network-banner-pending")).toBeNull());
    expect(screen.getByRole("status")).toHaveTextContent(fr.offline.banner);
  });

  it("en ligne, la file n'est pas lue : rien ne s'affiche même si elle est pleine", async () => {
    enqueue(mission("a"));
    renderBanner();
    await Promise.resolve();
    expect(screen.getByRole("status")).toBeEmptyDOMElement();
  });
});
