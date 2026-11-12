# Logging Standard

## Objectives

- Improve production traceability.
- Keep logs machine-readable.
- Prevent secrets leakage.

## Format

- Use structured JSON logs.
- Required fields:
  - `ts` (ISO timestamp)
  - `level` (`info` | `warn` | `error`)
  - `message`
- Optional fields:
  - `requestId`
  - `path`
  - domain metadata (`userId`, `operation`, etc.)

## Security Rules

- Never log raw secrets, tokens, passwords, API keys.
- Redact sensitive keys as `********` — **at any depth** (`{ headers: { authorization } }` is
  masked, not only a top-level key).
- Secret-shaped **values** are masked too, whatever the key: JWTs, `Bearer …`, provider keys
  (`sk-…`, `AIza…`, `gsk_…`, `sb_secret_…`), GitHub tokens. A provider that echoes the refused
  key in its error message is the case this exists for. Shapes live in `src/shared/lib/redact.ts`,
  shared by the logger and the Sentry envelope (`monitoring.ts`).
- An `Error` in the metadata is logged as `{ name, message }` (redacted) — never as `{}`.
- Log minimal PII only when operationally necessary.

## Usage

- Use `@/shared/lib/logger` (canonical path; the old `src/lib/logger.ts` shim was removed).
- Prefer `logger.info/warn/error` over `console.*` in server-side runtime code.

## Error Handling

- Log at boundaries (middleware, server entry, function handlers).
- Pass the caught error as `meta.error`: `logger.error("…", { error })`. An `Error` is written
  as `{ name, message, stack, cause }` (stack bounded to 4 000 chars, one level of `cause`) —
  before 2026-11-12 it serialised to `{}` and the line carried neither message nor stack. The
  original object still goes to the monitoring hook untouched.
- Include enough context for triage without exposing sensitive data.
