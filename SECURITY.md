# Security Policy

## Reporting a vulnerability

**Please do not open a public issue for security problems.**

Report vulnerabilities privately via GitHub's **[Report a vulnerability](https://github.com/MBeji/yahia-quest-arena/security/advisories/new)**
button (repository **Security** tab → *Advisories* → *Report a vulnerability*). This opens a
private advisory visible only to the maintainer. We aim to acknowledge a report within a few days.

## Scope

This is a learning-platform web app (TanStack Start + Supabase). Particularly relevant:

- Authentication / session handling and Supabase **Row-Level Security** (RLS) bypasses.
- The `SECURITY DEFINER` SQL RPCs (scoring, rewards, entitlements) and their grants.
- The per-parcours premium **entitlement** checks (`resolve_exercise_access`, `has_parcours_entitlement`).
- Server functions (`*.server.ts`) and their input validation.

### Out of scope

- The Supabase **anon / publishable key** and project ref are **public by design** — RLS is the
  protection boundary. Their presence in client code or git history is not a vulnerability.
- Findings that require an already-compromised account or physical access.

## Secrets

Runtime secrets (service-role keys, database URLs, tokens) live in **GitHub Actions secrets** and
the deploy platform — never in the repository. If you believe a *real* secret has been committed,
report it privately as above so it can be rotated.
