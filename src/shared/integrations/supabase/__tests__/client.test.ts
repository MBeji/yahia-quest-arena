// @vitest-environment node
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockCreateClient } = vi.hoisted(() => ({
  mockCreateClient: vi.fn(),
}));

vi.mock("@supabase/supabase-js", () => ({
  createClient: mockCreateClient,
}));

describe("shared supabase client", () => {
  beforeEach(() => {
    vi.resetModules();
    mockCreateClient.mockReset();
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_PUBLISHABLE_KEY;
    delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("creates browser client lazily once", async () => {
    // Provide the build-time vars the browser client reads, so the test is
    // hermetic and does not depend on CI-provided environment/secrets.
    vi.stubEnv("VITE_SUPABASE_URL", "https://example.supabase.co");
    vi.stubEnv("VITE_SUPABASE_PUBLISHABLE_KEY", "anon-key");
    mockCreateClient.mockReturnValue({ from: vi.fn() });

    const { supabase } = await import("@/shared/integrations/supabase/client");

    // Trigger proxy getter multiple times
    void (supabase as unknown as Record<string, unknown>).from;
    void (supabase as unknown as Record<string, unknown>).from;

    expect(mockCreateClient).toHaveBeenCalledTimes(1);
    const [url, key, options] = mockCreateClient.mock.calls[0] as [
      string,
      string,
      { auth: { persistSession: boolean; autoRefreshToken: boolean } },
    ];
    expect(typeof url).toBe("string");
    expect(url.length).toBeGreaterThan(0);
    expect(typeof key).toBe("string");
    expect(key.length).toBeGreaterThan(0);
    expect(options.auth.persistSession).toBe(true);
    expect(options.auth.autoRefreshToken).toBe(true);
  });

  // #1307 — le client recevait le global `localStorage` : le lire lève quand le navigateur refuse
  // le stockage, et la page entière tombait à la création du client. Sans option `storage`,
  // auth-js prend lui-même `localStorage` s'il est joignable et inscriptible, la mémoire sinon.
  it("ne lit pas le localStorage du navigateur : auth-js choisit, mémoire comprise", async () => {
    vi.stubEnv("VITE_SUPABASE_URL", "https://example.supabase.co");
    vi.stubEnv("VITE_SUPABASE_PUBLISHABLE_KEY", "anon-key");
    mockCreateClient.mockReturnValue({ from: vi.fn() });
    const refusing = {};
    Object.defineProperty(refusing, "localStorage", {
      get() {
        throw new DOMException("The operation is insecure.", "SecurityError");
      },
    });
    vi.stubGlobal("window", refusing);
    try {
      const { supabase } = await import("@/shared/integrations/supabase/client");
      expect(() => (supabase as unknown as Record<string, unknown>).from).not.toThrow();
      const [, , options] = mockCreateClient.mock.calls[0] as [
        string,
        string,
        { auth: Record<string, unknown> },
      ];
      expect(options.auth).not.toHaveProperty("storage");
      expect(options.auth.persistSession).toBe(true);
    } finally {
      vi.unstubAllGlobals();
    }
  });

  it("throws for missing env vars in admin client", async () => {
    const { supabaseAdmin } = await import("@/shared/integrations/supabase/client.server");
    expect(() => (supabaseAdmin as unknown as Record<string, unknown>).from).toThrow(
      "Missing Supabase environment variable(s)",
    );
  });

  it("creates admin client lazily once", async () => {
    process.env.SUPABASE_URL = "https://example.supabase.co";
    process.env.SUPABASE_SERVICE_ROLE_KEY = "service-role-key";
    mockCreateClient.mockReturnValue({ from: vi.fn() });

    const { supabaseAdmin } = await import("@/shared/integrations/supabase/client.server");

    void (supabaseAdmin as unknown as Record<string, unknown>).from;
    void (supabaseAdmin as unknown as Record<string, unknown>).from;

    expect(mockCreateClient).toHaveBeenCalledTimes(1);
    expect(mockCreateClient).toHaveBeenCalledWith(
      "https://example.supabase.co",
      "service-role-key",
      expect.objectContaining({
        auth: expect.objectContaining({
          persistSession: false,
          autoRefreshToken: false,
        }),
      }),
    );
  });
});
