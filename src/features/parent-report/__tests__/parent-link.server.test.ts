// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 40, lot 5 (R-20) — « cet élève a-t-il un parent lié ACTIF ? » : la lecture qui décide de
 * la carte « Inviter mon parent ». Elle porte sur l'élève de la SESSION, filtre `is_active`, et
 * ne rend qu'un booléen.
 */
const calls: unknown[][] = [];
let result: { data: unknown; error: unknown } = { data: [], error: null };
const query = {
  select: (...a: unknown[]) => (calls.push(["select", ...a]), query),
  eq: (...a: unknown[]) => (calls.push(["eq", ...a]), query),
  limit: (...a: unknown[]) => (calls.push(["limit", ...a]), Promise.resolve(result)),
};
const mockSupabase = { from: (table: string) => (calls.push(["from", table]), query) };

vi.mock("@tanstack/react-start", () => ({
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      handler: (fn: (opts: unknown) => unknown) => async () =>
        fn({ context: { supabase: mockSupabase, userId: "student-1" } }),
    };
    return chain;
  },
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
const error = vi.fn();
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: (...a: unknown[]) => error(...a), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { hasActiveParentLink } from "../parent-link.server";

const read = hasActiveParentLink as unknown as () => Promise<boolean>;

beforeEach(() => {
  calls.length = 0;
  error.mockReset();
  result = { data: [], error: null };
});

describe("hasActiveParentLink", () => {
  it("⭐ lit les liens ACTIFS de l'élève de la session, et un seul suffit", async () => {
    await read();
    expect(calls).toEqual([
      ["from", "parent_student_links"],
      ["select", "parent_user_id"],
      ["eq", "student_user_id", "student-1"],
      ["eq", "is_active", true],
      ["limit", 1],
    ]);
  });

  it("aucun lien actif ⇒ `false`", async () => {
    expect(await read()).toBe(false);
  });

  it("⭐ un lien actif ⇒ `true` — et rien du parent ne sort", async () => {
    result = { data: [{ parent_user_id: "parent-9" }], error: null };
    expect(await read()).toBe(true);
  });

  it("⭐ lecture en échec ⇒ une erreur, jamais un `false` qui ouvrirait la carte", async () => {
    result = { data: null, error: { message: "permission denied for table x" } };
    await expect(read()).rejects.toThrow("Impossible de lire le lien parent.");
    expect(error).toHaveBeenCalled();
  });
});
