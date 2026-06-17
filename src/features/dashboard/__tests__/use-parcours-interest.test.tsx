import React from "react";
import { renderHook, waitFor, act } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";

const getMine = vi.fn();
const getCounts = vi.fn();
const toggle = vi.fn();
const toastError = vi.fn();

vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("../parcours-interest.server", () => ({
  getMyParcoursInterests: (...a: unknown[]) => getMine(...a),
  getParcoursInterestCounts: (...a: unknown[]) => getCounts(...a),
  toggleParcoursInterest: (...a: unknown[]) => toggle(...a),
}));
vi.mock("@/lib/i18n", () => ({ useT: () => ({ parcoursInterest: { toggleError: "err" } }) }));
vi.mock("sonner", () => ({ toast: { error: (...a: unknown[]) => toastError(...a) } }));

import { useParcoursInterest } from "../use-parcours-interest";

function wrapper({ children }: { children: React.ReactNode }) {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return <QueryClientProvider client={qc}>{children}</QueryClientProvider>;
}

describe("useParcoursInterest", () => {
  beforeEach(() => {
    getMine.mockReset();
    getCounts.mockReset();
    toggle.mockReset();
    toastError.mockReset();
  });

  it("exposes the user's votes and the aggregate counts", async () => {
    getMine.mockResolvedValue({ parcoursIds: ["a"] });
    getCounts.mockResolvedValue({ counts: [{ parcoursId: "a", name: "A", count: 3 }] });

    const { result } = renderHook(() => useParcoursInterest(), { wrapper });

    await waitFor(() => expect(result.current.mine.has("a")).toBe(true));
    expect(result.current.counts).toEqual({ a: 3 });
  });

  it("optimistically registers interest then reconciles with the server", async () => {
    getMine.mockResolvedValueOnce({ parcoursIds: [] }).mockResolvedValue({ parcoursIds: ["x"] });
    getCounts
      .mockResolvedValueOnce({ counts: [] })
      .mockResolvedValue({ counts: [{ parcoursId: "x", name: "x", count: 1 }] });
    toggle.mockResolvedValue({ interested: true });

    const { result } = renderHook(() => useParcoursInterest(), { wrapper });
    await waitFor(() => expect(result.current.counts).toEqual({}));

    await act(async () => {
      result.current.onToggle("x");
      await Promise.resolve();
    });

    expect(toggle).toHaveBeenCalledWith({ data: { parcoursId: "x" } });
    await waitFor(() => expect(result.current.mine.has("x")).toBe(true));
    await waitFor(() => expect(result.current.counts.x).toBe(1));
  });

  it("optimistically removes an existing vote (toggle off)", async () => {
    getMine.mockResolvedValueOnce({ parcoursIds: ["a"] }).mockResolvedValue({ parcoursIds: [] });
    getCounts
      .mockResolvedValueOnce({ counts: [{ parcoursId: "a", name: "A", count: 1 }] })
      .mockResolvedValue({ counts: [{ parcoursId: "a", name: "A", count: 0 }] });
    toggle.mockResolvedValue({ interested: false });

    const { result } = renderHook(() => useParcoursInterest(), { wrapper });
    await waitFor(() => expect(result.current.mine.has("a")).toBe(true));

    await act(async () => {
      result.current.onToggle("a");
      await Promise.resolve();
    });

    await waitFor(() => expect(result.current.mine.has("a")).toBe(false));
  });

  it("rolls back and toasts on a toggle error", async () => {
    getMine.mockResolvedValue({ parcoursIds: [] });
    getCounts.mockResolvedValue({ counts: [] });
    toggle.mockRejectedValue(new Error("boom"));

    const { result } = renderHook(() => useParcoursInterest(), { wrapper });
    await waitFor(() => expect(result.current.counts).toEqual({}));

    await act(async () => {
      result.current.onToggle("x");
      await Promise.resolve();
    });

    await waitFor(() => expect(toastError).toHaveBeenCalledWith("err"));
    // Rolled back: the optimistic vote is gone.
    await waitFor(() => expect(result.current.mine.has("x")).toBe(false));
  });
});
