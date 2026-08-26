// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * `deleteAccount` — la server fn la moins rattrapable de l'application.
 *
 * Ce qui est testé ici n'est pas « est-ce que ça supprime » (c'est PostgreSQL qui
 * répond, en pgTAP : `supabase/tests/60_account_deletion.test.sql`) mais les
 * quatre refus qui séparent un geste volontaire d'un accident ou d'une attaque :
 * QUI est supprimé, et à quelles conditions.
 */

const mockGetUserById = vi.fn();
const mockDeleteUser = vi.fn();

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      inputValidator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: unknown) => {
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({ data, context: { supabase: {}, userId: "user-1" } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: {
    auth: {
      admin: {
        getUserById: (id: string) => mockGetUserById(id),
        deleteUser: (id: string) => mockDeleteUser(id),
      },
    },
  },
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

type DeleteFn = (input: { data: { confirmEmail: string } }) => Promise<unknown>;

async function loadDeleteAccount(): Promise<DeleteFn> {
  const mod = await import("../auth.server");
  return mod.deleteAccount as unknown as DeleteFn;
}

beforeEach(() => {
  vi.resetModules();
  mockGetUserById.mockReset();
  mockDeleteUser.mockReset();
  mockGetUserById.mockResolvedValue({
    data: { user: { id: "user-1", email: "yahia@example.tn" } },
    error: null,
  });
  mockDeleteUser.mockResolvedValue({ error: null });
});

describe("deleteAccount", () => {
  it("supprime le compte quand l'adresse saisie correspond", async () => {
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "yahia@example.tn" } })).resolves.toEqual({
      ok: true,
    });
    expect(mockDeleteUser).toHaveBeenCalledWith("user-1");
  });

  it("ne supprime JAMAIS que l'appelant — l'identifiant vient du jeton, pas de l'entrée", async () => {
    // La garde qui empêche d'en faire une arme. On tente de faire passer un autre
    // identifiant dans la charge utile : le validateur zod le jette, et même s'il
    // passait, la fn n'en lit aucun.
    const deleteAccount = await loadDeleteAccount();
    await deleteAccount({
      data: { confirmEmail: "yahia@example.tn", userId: "victime-2" },
    } as unknown as { data: { confirmEmail: string } });
    expect(mockDeleteUser).toHaveBeenCalledTimes(1);
    expect(mockDeleteUser).toHaveBeenCalledWith("user-1");
    expect(mockDeleteUser).not.toHaveBeenCalledWith("victime-2");
  });

  it("tolère la casse et les espaces de bord", async () => {
    const deleteAccount = await loadDeleteAccount();
    await expect(
      deleteAccount({ data: { confirmEmail: "  Yahia@Example.TN  " } }),
    ).resolves.toEqual({ ok: true });
    expect(mockDeleteUser).toHaveBeenCalledWith("user-1");
  });

  it("refuse une adresse qui n'est pas celle du compte, et ne supprime rien", async () => {
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "voisin@example.tn" } })).rejects.toThrow(
      "ACCOUNT_DELETE_ERROR:email_mismatch",
    );
    expect(mockDeleteUser).not.toHaveBeenCalled();
  });

  it("compare à l'adresse RELUE sur l'Auth, pas à celle qu'on lui souffle", async () => {
    // Un jeton peut avoir été émis avant un changement d'adresse : c'est l'Auth
    // qui fait foi, sinon la confirmation porterait sur une adresse périmée.
    mockGetUserById.mockResolvedValue({
      data: { user: { id: "user-1", email: "nouvelle@example.tn" } },
      error: null,
    });
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "yahia@example.tn" } })).rejects.toThrow(
      "ACCOUNT_DELETE_ERROR:email_mismatch",
    );
    expect(mockDeleteUser).not.toHaveBeenCalled();
  });

  it("refuse quand le compte est introuvable, et ne supprime rien", async () => {
    mockGetUserById.mockResolvedValue({ data: { user: null }, error: { message: "not found" } });
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "yahia@example.tn" } })).rejects.toThrow(
      "ACCOUNT_DELETE_ERROR:generic",
    );
    expect(mockDeleteUser).not.toHaveBeenCalled();
  });

  it("refuse un compte sans adresse — le geste de confirmation n'existerait pas", async () => {
    mockGetUserById.mockResolvedValue({
      data: { user: { id: "user-1", email: null } },
      error: null,
    });
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "" } })).rejects.toThrow();
    expect(mockDeleteUser).not.toHaveBeenCalled();
  });

  it("remonte une erreur générique si l'Auth refuse la suppression", async () => {
    mockDeleteUser.mockResolvedValue({ error: { message: "boom" } });
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "yahia@example.tn" } })).rejects.toThrow(
      "ACCOUNT_DELETE_ERROR:generic",
    );
  });

  it("refuse une saisie vide au validateur", async () => {
    const deleteAccount = await loadDeleteAccount();
    await expect(deleteAccount({ data: { confirmEmail: "" } })).rejects.toThrow();
    expect(mockDeleteUser).not.toHaveBeenCalled();
  });
});
