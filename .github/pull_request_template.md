## What & why

<!-- Briefly: what does this PR change, and why? Link any issue. -->

## Migration / deploy notes

<!--
Does this PR add or depend on a Supabase migration (new table/column/RPC,
revoked grants, RLS change)? If so, note WHICH migration(s).

Reminder (AGENTS.md §7): merging to `main` auto-deploys to PRODUCTION AND
auto-applies any new supabase/migrations/** to the prod DB (db-migrate-prod.yml
takes a pre-apply backup). Never apply prod migrations by hand. A DESTRUCTIVE
migration (DROP/REVOKE) ships in a SEPARATE merge, AFTER the code that stopped
using the old shape is live.
-->

## Checklist

- [ ] `npm run verify` is green locally (lint + typecheck + tests)
- [ ] **DB migration in this PR?** If yes: additive-before-code ordering holds
      (AGENTS.md §7 — destructive changes in a separate, later merge), and the
      `Migration order` check is green (its timestamp sorts after the newest
      migration on `main`). If no migration, skip — the gate passes silently.
- [ ] No new tech debt; features-import-features boundary respected
- [ ] Tests travel with the change (co-located in the feature's `__tests__/`)
