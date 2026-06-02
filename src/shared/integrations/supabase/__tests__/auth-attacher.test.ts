import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetSession } = vi.hoisted(() => ({
  mockGetSession: vi.fn(),
}));

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({
    client: (handler: unknown) => handler,
  }),
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      getSession: mockGetSession,
    },
  },
}));

import { attachSupabaseAuth } from "@/shared/integrations/supabase/auth-attacher";

describe("attachSupabaseAuth", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
  });

  it("attaches Authorization header when session token exists", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: {
          access_token: "token-123",
        },
      },
    });

    const next = vi.fn().mockResolvedValue("ok");

    const result = await attachSupabaseAuth({ next } as never);

    expect(result).toBe("ok");
    expect(next).toHaveBeenCalledWith({
      headers: {
        Authorization: "Bearer token-123",
      },
    });
  });

  it("passes empty headers when no session token exists", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: null,
      },
    });

    const next = vi.fn().mockResolvedValue("ok");

    await attachSupabaseAuth({ next } as never);

    expect(next).toHaveBeenCalledWith({ headers: {} });
  });
});
