# XSS Rendering Policy

## Scope

Applies to any rendering path that may transform text into HTML.

## Rules

- Prefer plain JSX rendering where possible.
- `dangerouslySetInnerHTML` is allowed only in vetted rendering boundaries.
- Input must be escaped/sanitized before rendering.
- Add regression tests for escaping behavior whenever renderer logic changes.

## Current Boundaries

- Lesson markdown renderer path (`renderLesson` in `src/shared/lib/markdown.ts`, rendered by
  `LessonReader`). The invariant IS the order of its passes: the body is fully HTML-escaped
  **before** any tag is emitted, so the only tags that survive are the ones the renderer itself
  produces — an author cannot inject markup, whatever they write. The pedagogical blocks of
  étude 18 (`::: definition …`, promoted `> ⚠️` callouts) are emitted from a line-level parser,
  never copied from the source. `ALLOWED_TAGS` therefore carries only inert elements
  (`section`/`span`/`figure`/`figcaption` alongside the original set) and `ALLOWED_ATTR` only
  inert attributes (`class`/`id`/`dir` plus `role`/`tabindex`/`aria-label`, which make a figure
  zoomable from the keyboard) — no `style`, no `href`, no `on*`. A directive with an unknown
  type degrades to a neutral block and an unclosed one is implicitly closed: a content mistake
  can cost style, never safety.
  - **Author text in an attribute.** A `::: figure <caption>` legend reaches `aria-label`, so it
    goes through `escapeAttr` (quotes escaped), not merely `escapeHtml` (which escapes only
    `&`/`<`/`>`): an unescaped `"` would close the attribute. Regression test:
    « échappe les GUILLEMETS d'une légende » in `markdown.test.ts`.
- Lesson figure zoom dialog (`LessonReader`). Clicking a figure re-reads its already-sanitized
  SVG from the DOM and re-injects it into a dialog — passing it through `sanitizeSvg` **again**
  (defense in depth: the value is read back from a `dangerouslySetInnerHTML` subtree).
- Video embed path (`VideoEmbed` / `ChapterVideosSection` in `src/features/quest/components/`,
  étude 23). A curated explainer video is rendered as **pure JSX**, never through the markdown
  renderer and never through `dangerouslySetInnerHTML`: no `iframe` is ever added to `ALLOWED_TAGS`,
  and the video never traverses `renderLesson`. The `<iframe>` `src` is **built by template** from
  two validated fields — `provider` (a closed enum) and `videoId` (a strict per-provider regex,
  re-checked at render: an id that fails `^[A-Za-z0-9_-]{11}$` renders `null`) — so no free URL from
  the data ever reaches the DOM (étude 23 D-10). The only embeddable origin is pinned by the CSP
  `frame-src https://www.youtube-nocookie.com` directive (`src/shared/lib/csp.ts`): a compromised
  registry could at worst point at another YouTube video, never an arbitrary host. Before the user
  clicks the facade, no iframe exists in the DOM and no third-party request is made (the poster is a
  local `/video-posters/<id>.jpg` — étude 23 R-4).
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
- Unit tests in `src/features/quest/components/__tests__/video-embed.test.tsx` (facade invariant:
  no iframe/third-party URL before click, exact `src` after) and
  `src/shared/lib/__tests__/csp.test.ts` (`frame-src` pins the single embed host) must pass.
- Security scan and lint must pass in CI.
