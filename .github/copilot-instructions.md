---
applyTo: "**"
---

# Coding Instructions — XP Scholars

## Read first

- Always read `ARCHITECTURE.md` before making changes.
- Understand the feature-based structure before touching any file.

## Feature isolation

- Each feature lives in `src/features/{name}/` and is self-contained.
- Features NEVER import from other features directly. Use `src/shared/` for cross-cutting code.
- Routes (`src/routes/`) are THIN — they import from features and compose; no business logic.

## File placement rules

- New server function → `src/features/{name}/{name}.server.ts`
- New component used by one feature → `src/features/{name}/components/`
- New shared UI component → `src/shared/ui/`
- New utility → `src/shared/lib/`
- New test → co-located in `src/features/{name}/__tests__/`

## Import conventions

- Use `@/features/{name}` barrel imports for feature public APIs.
- Use `@/shared/ui/{component}` for UI primitives.
- Use `@/shared/lib/{module}` for utilities.
- Use `@/shared/integrations/supabase/` for Supabase access.
- NEVER use relative paths that cross feature boundaries.

## Server functions

- Always use `createServerFn` from `@tanstack/react-start`.
- Always apply `requireSupabaseAuth` middleware for authenticated endpoints.
- Validate inputs with Zod schemas.
- Return plain serializable objects (no class instances).

## Testing

- Every server function MUST have at least one test.
- Tests mock Supabase via `vi.fn()` — never hit real DB.
- Co-locate tests: `src/features/{name}/__tests__/{name}.test.ts`.
- Run `npm test` before considering any change complete.

## Code style

- TypeScript strict mode — no `any` unless absolutely necessary.
- Prefer `const` over `let`. Never use `var`.
- Use named exports, not default exports (except route components).
- Keep files under 300 lines. Split if larger.
- No console.log in production code — use `logger` from `@/shared/lib/logger`.

## Security

- All user input validated server-side with Zod.
- HTML rendering uses DOMPurify (`@/shared/lib/markdown`).
- Supabase RLS is the primary access control — server functions are defense-in-depth.
- Never expose internal error details to the client.

## When modifying a feature

1. Read the feature's `index.ts` to understand its public API.
2. Make changes inside the feature folder.
3. Run the feature's tests: `npx vitest run src/features/{name}`.
4. If changing shared code, run ALL tests: `npm test`.
5. Never change the public API without updating all consumers.
