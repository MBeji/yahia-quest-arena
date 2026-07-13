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
- Include enough context for triage without exposing sensitive data.
