import "@testing-library/jest-dom/vitest";
import { vi } from "vitest";

// Unit tests are hermetic — they must never see the repo-root `.env.test`
// (the DOCUMENTED local e2e setup, see e2e/README.md). The suite includes
// scripts/**/__tests__ whose modules import scripts/e2e/_env.mjs for its pure
// helpers; that module's side effect dotenv-loads `.env.test` into process.env
// of the SHARED vitest worker, and the server-side Supabase modules read
// process.env.SUPABASE_URL — flipping in-process server-fn tests from mocks to
// real network calls (5s timeouts). setupFiles run before each test file's
// imports, so purging here shields every file deterministically. Tests that
// need these vars set them explicitly (e.g. auth-middleware.test.ts).
for (const key of [
  "SUPABASE_URL",
  "SUPABASE_PUBLISHABLE_KEY",
  "SUPABASE_SERVICE_ROLE_KEY",
  "VITE_SUPABASE_URL",
  "VITE_SUPABASE_PUBLISHABLE_KEY",
  "E2E_USER_PASSWORD",
  "TEST_SUPABASE_DB_URL",
]) {
  delete process.env[key];
}

// La langue de la requête (`getShellLocale`) est une fonction isomorphe de TanStack
// Start : hors de son compilateur — donc dans Vitest — elle n'a ni cookie de requête
// ni branche client, et rend toujours le français. Elle est figée ici à cette même
// valeur pour que les fichiers de route (dont le `head` appelle `pageTitle`) restent
// importables par les suites qui remplacent `@tanstack/react-start` en entier. Un
// test qui veut une autre langue pose son propre `vi.mock` de ce module.
vi.mock("@/lib/i18n/shell-locale", () => ({ getShellLocale: () => "fr" }));
