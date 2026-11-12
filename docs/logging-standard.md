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
- Redact sensitive keys as `********`.
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
