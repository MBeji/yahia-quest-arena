import { renderHook, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// Mock supabase: auth (so the real useAuth resolves a user) + the
// profiles `.from().select().eq().single()` chain used by useMyStats.
const { mockSingle } = vi.hoisted(() => ({ mockSingle: vi.fn() }));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      onAuthStateChange: vi.fn(() => ({
        data: { subscription: { unsubscribe: vi.fn() } },
      })),
      getSession: vi.fn().mockResolvedValue({
        data: { session: { user: { id: "user-1" } } },
      }),
    },
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        eq: vi.fn(() => ({ single: mockSingle })),
      })),
    })),
  },
}));

import { useMyStats } from "@/features/auth";

function makeWrapper(qc = new QueryClient({ defaultOptions: { queries: { retry: false } } })) {
  return ({ children }: { children: React.ReactNode }) =>
    React.createElement(QueryClientProvider, { client: qc }, children);
}

describe("useMyStats", () => {
  beforeEach(() => {
    mockSingle.mockReset();
  });

  it("exposes the signed-in user's daily streak + XP", async () => {
    mockSingle.mockResolvedValue({ data: { xp: 1280, current_streak: 5 } });

    const { result } = renderHook(() => useMyStats(), { wrapper: makeWrapper() });

    await waitFor(() => expect(result.current.isLoaded).toBe(true));
    expect(result.current.xp).toBe(1280);
    expect(result.current.currentStreak).toBe(5);
    expect(result.current.hasStats).toBe(true);
  });

  it("reports no stats when the profile row is missing", async () => {
    mockSingle.mockResolvedValue({ data: null });

    const { result } = renderHook(() => useMyStats(), { wrapper: makeWrapper() });

    await waitFor(() => expect(result.current.isLoaded).toBe(true));
    expect(result.current.hasStats).toBe(false);
    expect(result.current.xp).toBeNull();
    expect(result.current.currentStreak).toBeNull();
  });
});
