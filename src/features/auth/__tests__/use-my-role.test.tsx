import { renderHook, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

// Mock the supabase client: auth (so the real useAuth resolves a user) + the
// profiles `.from().select().eq().single()` chain used by useMyRole.
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

import { useMyRole } from "@/features/auth";

function makeWrapper(qc = new QueryClient({ defaultOptions: { queries: { retry: false } } })) {
  return ({ children }: { children: React.ReactNode }) =>
    React.createElement(QueryClientProvider, { client: qc }, children);
}

describe("useMyRole", () => {
  beforeEach(() => {
    mockSingle.mockReset();
  });

  it("exposes role + isAdmin for an admin profile", async () => {
    mockSingle.mockResolvedValue({ data: { role: "admin", current_parcours_id: null } });

    const { result } = renderHook(() => useMyRole(), { wrapper: makeWrapper() });

    await waitFor(() => expect(result.current.isLoaded).toBe(true));
    expect(result.current.role).toBe("admin");
    expect(result.current.isAdmin).toBe(true);
    expect(result.current.hasProfile).toBe(true);
  });

  it("a non-admin profile is not admin and exposes its active parcours", async () => {
    mockSingle.mockResolvedValue({
      data: { role: "student", current_parcours_id: "concours-9eme" },
    });

    const { result } = renderHook(() => useMyRole(), { wrapper: makeWrapper() });

    await waitFor(() => expect(result.current.isLoaded).toBe(true));
    expect(result.current.role).toBe("student");
    expect(result.current.isAdmin).toBe(false);
    expect(result.current.currentParcoursId).toBe("concours-9eme");
  });

  it("distinguishes a missing profile row from a not-yet-onboarded one", async () => {
    mockSingle.mockResolvedValue({ data: null });

    const { result } = renderHook(() => useMyRole(), { wrapper: makeWrapper() });

    await waitFor(() => expect(result.current.isLoaded).toBe(true));
    expect(result.current.role).toBeNull();
    expect(result.current.hasProfile).toBe(false);
    expect(result.current.isAdmin).toBe(false);
  });

  // Regression — GAP-017. The authenticated layout and every /admin guard read the
  // SAME query key ["me-role", userId]. They previously inlined diverging queryFn
  // shapes (object vs bare string), so the second consumer read the first's object
  // and `role === "admin"` was always false → admins locked out. With one shared
  // hook, a second consumer reading the cached entry must still see isAdmin === true.
  it("two consumers sharing one cache entry both resolve isAdmin correctly", async () => {
    mockSingle.mockResolvedValue({ data: { role: "admin", current_parcours_id: null } });
    const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
    const wrapper = makeWrapper(qc);

    // First consumer (mimics the layout) populates the shared cache entry.
    const layout = renderHook(() => useMyRole(), { wrapper });
    await waitFor(() => expect(layout.result.current.isLoaded).toBe(true));

    // Second consumer (mimics an /admin route guard) reads the SAME entry.
    const adminGuard = renderHook(() => useMyRole(), { wrapper });
    await waitFor(() => expect(adminGuard.result.current.isLoaded).toBe(true));
    expect(adminGuard.result.current.isAdmin).toBe(true);
  });
});
