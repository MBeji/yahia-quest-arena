/**
 * Test accounts for authenticated E2E. These users must exist in the TEST
 * Supabase project — create/refresh them with `npm run e2e:seed` (uses the
 * service-role key). Never point this at production.
 *
 * Password comes from E2E_USER_PASSWORD (see helpers/env.ts).
 */
import { E2E_PASSWORD } from "./env";

export type Role = "free" | "premium" | "parent" | "admin";

export { E2E_PASSWORD };

export const TEST_USERS: Record<Role, { email: string; role: string; premium: boolean }> = {
  free: { email: "student.free@e2e.xpscholars.test", role: "student", premium: false },
  premium: { email: "student.premium@e2e.xpscholars.test", role: "student", premium: true },
  parent: { email: "parent@e2e.xpscholars.test", role: "parent", premium: false },
  admin: { email: "admin@e2e.xpscholars.test", role: "admin", premium: false },
};

/** Where each role's authenticated browser state is saved (git-ignored). */
export const STORAGE_STATE: Record<Role, string> = {
  free: "e2e/.auth/free.json",
  premium: "e2e/.auth/premium.json",
  parent: "e2e/.auth/parent.json",
  admin: "e2e/.auth/admin.json",
};
