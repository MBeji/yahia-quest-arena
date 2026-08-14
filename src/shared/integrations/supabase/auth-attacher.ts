// Attaches the caller's bearer token to every server-fn RPC — CLIENT side.
//
// NOT generated, despite the header this file used to carry: nothing produces
// it and `guard-generated.mjs` does not list it (only `types.ts` is).
//
// ⚠️ This `.client()` middleware is the ONLY thing that puts a token on a
// server-fn call, and it reads the session from localStorage. Consequence, and
// it is architectural: **the server never holds a session**, so a route
// `loader` running at SSR cannot call an authenticated server fn — it would be
// rejected as unauthorized. Real SSR prefetching of authenticated data needs
// cookie-borne sessions first. See finding C1-fe in docs/performance-audit.md.
import { createMiddleware } from "@tanstack/react-start";
import { supabase } from "./client";

// Must be registered as a global `functionMiddleware` in `src/start.ts`; otherwise
// the browser never attaches the bearer token to serverFn RPCs.
export const attachSupabaseAuth = createMiddleware({ type: "function" }).client(
  async ({ next }) => {
    const { data } = await supabase.auth.getSession();
    const token = data.session?.access_token;
    return next({
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    });
  },
);
