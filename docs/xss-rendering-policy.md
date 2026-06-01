# XSS Rendering Policy

## Scope

Applies to any rendering path that may transform text into HTML.

## Rules

- Prefer plain JSX rendering where possible.
- `dangerouslySetInnerHTML` is allowed only in vetted rendering boundaries.
- Input must be escaped/sanitized before rendering.
- Add regression tests for escaping behavior whenever renderer logic changes.

## Current Boundaries

- Lesson markdown renderer path (`renderMarkdown`).
- Chart style injection path (internal CSS generation only).

## Validation

- Unit tests in `src/__tests__/markdown.test.ts` must pass.
- Security scan and lint must pass in CI.
