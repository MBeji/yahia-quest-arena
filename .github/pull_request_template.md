## What & why

<!-- Briefly: what does this PR change, and why? Link any issue. -->

## Migration / deploy notes

<!--
Does this PR add or depend on a Supabase migration (new table/column/RPC,
revoked grants, RLS change)? If so, note WHICH migration(s) and confirm the
deploy ordering below.

Reminder (CLAUDE.md §7): pushing to `main` auto-deploys to PRODUCTION, but
migrations are applied MANUALLY. The migration MUST be applied to the prod DB
BEFORE this PR merges, or prod runs new code against an old schema.
-->

## Checklist

- [ ] `npm run verify` is green locally (lint + typecheck + tests)
- [ ] **DB migration in this PR?** If yes: it has been applied to the
      **production** Supabase DB **before merge** (CLAUDE.md §7), and the
      `migration-applied` label is set on this PR. _(The "Migration gate" check
      fails on a new `supabase/migrations/*.sql` until that label is present.)_
      If no migration, skip — the gate passes silently.
- [ ] No new tech debt; features-import-features boundary respected
- [ ] Tests travel with the change (co-located in the feature's `__tests__/`)
