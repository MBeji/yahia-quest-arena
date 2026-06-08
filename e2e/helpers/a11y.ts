import AxeBuilder from "@axe-core/playwright";
import { expect, type Page } from "@playwright/test";

/**
 * Wait until every *finite* animation on the page has finished, then let a frame
 * paint. Accessibility rules — color-contrast especially — must be checked against
 * the settled UI: entrance animations (e.g. the subject page's staggered chapter
 * fade-in, `initial opacity:0 → animate opacity:1`) momentarily render whole
 * sections at <1 opacity, which dims their text, headings and links alike. axe
 * sampling mid-flight would otherwise report false contrast failures. Infinite
 * decorative loops (gold pulse/shimmer) are skipped — their `.finished` never
 * resolves.
 */
export async function waitForAnimationsSettled(page: Page): Promise<void> {
  await page.evaluate(async () => {
    await Promise.all(
      document
        .getAnimations()
        .filter((a) => a.effect?.getTiming().iterations !== Infinity)
        .map((a) => a.finished.catch(() => undefined)),
    );
    await new Promise<void>((resolve) =>
      requestAnimationFrame(() => requestAnimationFrame(() => resolve())),
    );
  });
}

/**
 * Run axe-core against the current page and fail on serious/critical WCAG 2 A/AA
 * violations. Lower-impact (minor/moderate) findings are not failed here to keep
 * the gate actionable, but the full list is printed on failure.
 *
 * Animations are allowed to settle first (see `waitForAnimationsSettled`) so axe
 * evaluates the resting UI rather than a transient frame.
 *
 * Pass `disableRules` for a documented, accepted limitation (e.g. an SSR/3rd-party
 * widget) — prefer fixing the source over disabling.
 */
export async function expectNoSeriousA11yViolations(
  page: Page,
  opts: { disableRules?: string[] } = {},
): Promise<void> {
  await waitForAnimationsSettled(page);
  let builder = new AxeBuilder({ page }).withTags(["wcag2a", "wcag2aa"]);
  if (opts.disableRules?.length) builder = builder.disableRules(opts.disableRules);
  const results = await builder.analyze();
  const serious = results.violations.filter(
    (v) => v.impact === "serious" || v.impact === "critical",
  );
  const summary = serious
    .map(
      (v) =>
        `• ${v.id} (${v.impact}) — ${v.nodes.length} node(s): ${v.help}\n    ${v.nodes[0]?.target?.join(" ")}`,
    )
    .join("\n");
  expect(serious, `Serious/critical a11y violations found:\n${summary}`).toEqual([]);
}
