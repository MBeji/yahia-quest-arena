import { act, renderHook } from "@testing-library/react";
import { renderToString } from "react-dom/server";
import { afterEach, describe, expect, it } from "vitest";
import { onlineManager } from "@tanstack/react-query";
import { useOnlineStatus } from "../use-online-status";

afterEach(() => onlineManager.setOnline(true));

describe("useOnlineStatus — une seule source, celle qui met les requêtes en pause", () => {
  it("suit onlineManager dans les deux sens, sans rechargement", () => {
    const { result } = renderHook(() => useOnlineStatus());
    expect(result.current).toBe(true);

    act(() => onlineManager.setOnline(false));
    expect(result.current).toBe(false);

    act(() => onlineManager.setOnline(true));
    expect(result.current).toBe(true);
  });

  it("lit l'état déjà connu au montage", () => {
    onlineManager.setOnline(false);
    const { result } = renderHook(() => useOnlineStatus());
    expect(result.current).toBe(false);
  });

  it("rend « en ligne » côté serveur, quel que soit l'état du processus", () => {
    onlineManager.setOnline(false);
    function Probe() {
      return <span>{useOnlineStatus() ? "online" : "offline"}</span>;
    }
    expect(renderToString(<Probe />)).toContain("online");
    expect(renderToString(<Probe />)).not.toContain("offline");
  });

  it("se désabonne au démontage", () => {
    const { result, unmount } = renderHook(() => useOnlineStatus());
    unmount();
    act(() => onlineManager.setOnline(false));
    expect(result.current).toBe(true);
  });
});
