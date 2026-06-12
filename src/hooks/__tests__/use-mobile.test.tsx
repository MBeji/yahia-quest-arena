import { describe, it, expect, beforeEach, vi } from "vitest";
import { renderHook, act } from "@testing-library/react";
import { useIsMobile } from "../use-mobile";

// The responsive shell (mobile nav vs desktop sidebar) keys off this hook; a
// regression silently breaks the whole mobile journey. jsdom has no real
// matchMedia, so emulate it and drive the change listener by hand.
type Listener = () => void;

function setupViewport(width: number) {
  const listeners = new Set<Listener>();
  Object.defineProperty(window, "innerWidth", { configurable: true, value: width, writable: true });
  vi.stubGlobal(
    "matchMedia",
    vi.fn((query: string) => ({
      matches: width < 768,
      media: query,
      addEventListener: (_: string, cb: Listener) => listeners.add(cb),
      removeEventListener: (_: string, cb: Listener) => listeners.delete(cb),
    })),
  );
  return {
    resizeTo(next: number) {
      window.innerWidth = next;
      listeners.forEach((cb) => cb());
    },
    listeners,
  };
}

describe("useIsMobile", () => {
  beforeEach(() => vi.unstubAllGlobals());

  it("reports mobile below the 768px breakpoint", () => {
    setupViewport(375);
    const { result } = renderHook(() => useIsMobile());
    expect(result.current).toBe(true);
  });

  it("reports desktop at and above the breakpoint", () => {
    setupViewport(1280);
    const { result } = renderHook(() => useIsMobile());
    expect(result.current).toBe(false);
  });

  it("follows live viewport changes (rotate / window resize)", () => {
    const viewport = setupViewport(1024);
    const { result } = renderHook(() => useIsMobile());
    expect(result.current).toBe(false);

    act(() => viewport.resizeTo(600));
    expect(result.current).toBe(true);

    act(() => viewport.resizeTo(900));
    expect(result.current).toBe(false);
  });

  it("unsubscribes from the media query on unmount", () => {
    const viewport = setupViewport(500);
    const { unmount } = renderHook(() => useIsMobile());
    expect(viewport.listeners.size).toBe(1);
    unmount();
    expect(viewport.listeners.size).toBe(0);
  });
});
