import AxeBuilder from "@axe-core/playwright";
import { expect, type Page } from "@playwright/test";

/**
 * Run axe-core against the current page and fail on serious/critical WCAG 2 A/AA
 * violations. Lower-impact (minor/moderate) findings are not failed here to keep
 * the gate actionable, but the full list is printed on failure.
 *
 * Pass `disableRules` for a documented, accepted limitation (e.g. an SSR/3rd-party
 * widget) — prefer fixing the source over disabling.
 */
export async function expectNoSeriousA11yViolations(
  page: Page,
  opts: { disableRules?: string[] } = {},
): Promise<void> {
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
