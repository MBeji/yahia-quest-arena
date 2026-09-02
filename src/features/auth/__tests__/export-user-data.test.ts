// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * `exportUserData` — la server fn qui rend à quelqu'un son propre dossier.
 *
 * Ce qui est testé ici n'est PAS ce que l'export contient : cette question se
 * décide dans `pg_constraint`, et se vérifie contre un vrai Postgres
 * (`supabase/tests/85_export_user_data.test.sql`). Ici on tient les trois
 * propriétés que le TypeScript, lui, peut trahir :
 *
 *   1. l'appel ne porte AUCUN argument — c'est le garde-fou de la fonction :
 *      rien ne désigne une personne, donc rien n'en fait une arme ;
 *   2. le document est RELAYÉ tel quel — la moindre mise en forme ici rouvrirait
 *      la « deuxième liste » que toute la migration a servi à éviter ;
 *   3. un échec ne rend jamais un demi-document, et ne laisse pas fuir le message
 *      de la base au client.
 */

const mockRpc = vi.fn();

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async () =>
          handlerFn({
            context: { supabase: { rpc: mockRpc }, userId: "user-1" },
          });
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { auth: { admin: { getUserById: vi.fn(), deleteUser: vi.fn() } } },
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

const DOCUMENT = {
  format_version: 1,
  generated_at: "2026-09-02T14:31:07Z",
  account: { id: "user-1", email: "eleve@test.local" },
  tables: { profiles: [{ id: "user-1" }], attempts: [{ id: 1 }, { id: 2 }] },
  redacted: [{ table: "ai_credentials", column: "secret_enc", reason: "clé d'API" }],
  not_exported: [
    { table: "bug_reports", column: "resolved_by", disposition: "attribution", reason: "un autre" },
  ],
};

type ExportFn = () => Promise<{ document: typeof DOCUMENT }>;

async function loadExport(): Promise<ExportFn> {
  const mod = await import("../auth.server");
  return mod.exportUserData as unknown as ExportFn;
}

describe("exportUserData", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRpc.mockResolvedValue({ data: DOCUMENT, error: null });
  });

  it("appelle la RPC SANS aucun argument — rien dans cet appel ne désigne une personne", async () => {
    const run = await loadExport();
    await run();

    expect(mockRpc).toHaveBeenCalledTimes(1);
    expect(mockRpc).toHaveBeenCalledWith("export_user_data");
    // Explicitement : pas de second paramètre. Un `p_user` ajouté « pour la
    // console d'admin » ferait de cette fonction un lecteur de dossiers d'autrui.
    expect(mockRpc.mock.calls[0]).toHaveLength(1);
  });

  it("relaie le document tel quel — aucune décision sur CE QUI sort ne se prend ici", async () => {
    const run = await loadExport();
    const result = await run();

    expect(result.document).toEqual(DOCUMENT);
    // Le bloc qui dit ses propres limites doit survivre au relais : c'est ce qui
    // empêche le fichier de se présenter comme exhaustif.
    expect(result.document.not_exported).toHaveLength(1);
    expect(result.document.redacted[0].column).toBe("secret_enc");
  });

  it("refuse quand la base refuse, sans lui emprunter son message", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: 'permission denied for schema auth, role "authenticated"' },
    });
    const run = await loadExport();

    await expect(run()).rejects.toThrow("data_export_failed");
    await expect(run()).rejects.not.toThrow(/permission denied/);
  });

  it("refuse aussi un document ABSENT sans erreur — un `null` relayé se lirait « tu n'as rien »", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const run = await loadExport();

    await expect(run()).rejects.toThrow("data_export_failed");
  });
});
