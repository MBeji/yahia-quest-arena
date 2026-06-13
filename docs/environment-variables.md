# Environment variables (Supabase) & Vercel setup

The app **requires** Supabase environment variables at build and runtime. When
they are missing, the server renders the branded error page ("The scroll has
torn apart") and logs:

> Missing Supabase environment variable(s): SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY.

This is by design (see `src/shared/integrations/supabase/client.ts` and
`client.server.ts`) — the app never falls back to a hard-coded backend.

## Required variables

| Variable                        | Scope                  | Notes                                  |
| ------------------------------- | ---------------------- | -------------------------------------- |
| `VITE_SUPABASE_URL`             | client (build time)    | Project URL                            |
| `VITE_SUPABASE_PUBLISHABLE_KEY` | client (build time)    | anon / publishable key                 |
| `SUPABASE_URL`                  | server / SSR (runtime) | same Project URL                       |
| `SUPABASE_PUBLISHABLE_KEY`      | server / SSR (runtime) | same anon / publishable key            |
| `SUPABASE_SERVICE_ROLE_KEY`     | server only (runtime)  | **secret** — never prefix with `VITE_` |

`VITE_*` values are inlined into the client bundle at build time; the
non-prefixed ones are read from the server runtime (`process.env`). You need
both sets. See [`env.example`](../env.example).

Find the values in **Supabase → Project Settings → API** (Project URL, anon /
publishable key, service_role key).

## Vercel

1. Project → **Settings → Environment Variables** → add the five variables
   above. Tick **Production** (and **Preview** if preview deployments should
   work).
2. **Redeploy** so the values take effect — Deployments → ⋯ → **Redeploy**
   (uncheck "Use existing build cache" so the `VITE_*` values are re-inlined),
   or push a new commit.

> ⚠️ Never put `SUPABASE_SERVICE_ROLE_KEY` (or any secret) into a `VITE_*`
> variable — it would be shipped in the client bundle.

## Local development

```bash
cp env.example .env
# fill in the values, then:
npm run dev
```

`.env` is gitignored and must never be committed.

## Web Push notifications

Scheduled push (streak reminders) needs a VAPID keypair and a cron secret:

| Variable                | Scope                 | Notes                                      |
| ----------------------- | --------------------- | ------------------------------------------ |
| `VAPID_PUBLIC_KEY`      | server (runtime)      | Web Push VAPID public key                  |
| `VAPID_PRIVATE_KEY`     | server only (runtime) | **secret** — VAPID private key             |
| `VAPID_SUBJECT`         | server (runtime)      | `mailto:` contact (VAPID requirement)      |
| `VITE_VAPID_PUBLIC_KEY` | client (build time)   | same public key (browser subscribe)        |
| `CRON_SECRET`           | server only (runtime) | **secret** — guards `GET /api/cron/notify` |

1. Generate the keypair once: `npx web-push generate-vapid-keys`.
2. Set the five variables in Vercel → Settings → Environment Variables.
   `VITE_VAPID_PUBLIC_KEY` must equal `VAPID_PUBLIC_KEY`; rebuild so it inlines.
3. The cron route is declared in `vercel.json` (`crons`); Vercel automatically
   sends `Authorization: Bearer $CRON_SECRET` on each scheduled run, which
   `src/server.ts` → `handlePushCron` verifies.
