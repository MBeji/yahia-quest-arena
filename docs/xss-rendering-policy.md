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
- Question figure SVG path (`sanitizeSvg` in `src/shared/lib/figure.ts`, rendered by
  `SvgFigure` in `src/components/ui/svg-figure.tsx`). A quiz/exercise question field
  (`prompt`, an option's `text`, `explanation`) may embed a single `<svg>…</svg>` figure;
  it is sanitized through DOMPurify's SVG profile (drawing primitives only — no
  `script`/`style`/`foreignObject`/`<a>`/`<image>`/`<use>`, no `on*` handlers, no
  `href`/`xlink:href`, residual `javascript:` neutralized) before reaching the DOM.

## Validation

- Unit tests in `src/shared/lib/__tests__/markdown.test.ts` must pass.
- Unit tests in `src/shared/lib/__tests__/figure.test.ts` (SVG sanitizer boundary) must pass.
- Security scan and lint must pass in CI.
