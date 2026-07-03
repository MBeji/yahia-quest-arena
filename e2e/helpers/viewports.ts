import { type Page, expect } from "@playwright/test";

/**
 * Representative device screen sizes for responsive / graphical coverage. Logical
 * (CSS) sizes matching real devices — phone → tablet → laptop → desktop. Layout
 * is driven by viewport width, so these cover the responsive breakpoints without
 * needing per-device UA emulation.
 */
export const DEVICE_VIEWPORTS = [
  { name: "iPhone SE", width: 375, height: 667 },
  { name: "iPhone 14 Pro Max", width: 430, height: 932 },
  { name: "iPad Mini portrait", width: 768, height: 1024 },
  { name: "iPad Pro landscape", width: 1194, height: 834 },
  { name: "Laptop", width: 1366, height: 768 },
  { name: "Desktop 1080p", width: 1920, height: 1080 },
] as const;

/** The Tailwind `sm` breakpoint — the public Référence header reveals its
 *  catalogue nav (Programme/Extras) at/above this width (hidden below). */
export const SM_BREAKPOINT = 640;

/** The Tailwind `md` breakpoint — desktop nav appears at/above this width. */
export const MD_BREAKPOINT = 768;

/**
 * Assert the page does not scroll horizontally (a classic responsive regression).
 * Allows a couple px for sub-pixel rounding.
 *
 * On failure the message also names the element(s) whose box extends past the
 * viewport — a horizontal-overflow bug is otherwise invisible in CI (only a
 * scrollWidth delta), so the offenders' tag + classes + rect are surfaced to
 * pinpoint the culprit straight from the run log. The list is capped at the 8
 * widest offenders to keep the message readable.
 */
export async function expectNoHorizontalOverflow(page: Page, tolerance = 2): Promise<void> {
  const { overflow, offenders } = await page.evaluate((tol) => {
    const docEl = document.documentElement;
    const overflow = docEl.scrollWidth - docEl.clientWidth;
    if (overflow <= tol) return { overflow, offenders: [] as string[] };

    const limit = docEl.clientWidth + tol;
    const offenders = Array.from(document.body.querySelectorAll<HTMLElement>("*"))
      .map((el) => ({ el, rect: el.getBoundingClientRect() }))
      .filter(({ rect }) => rect.width > 0 && (rect.right > limit || rect.left < -tol))
      .sort((a, b) => b.rect.right - a.rect.right)
      .slice(0, 8)
      .map(({ el, rect }) => {
        // SVG elements expose className as an SVGAnimatedString, not a string.
        const cls =
          typeof el.className === "string" ? el.className : (el.getAttribute("class") ?? "");
        return `<${el.tagName.toLowerCase()} class="${cls}"> [left=${Math.round(rect.left)}, right=${Math.round(rect.right)}, width=${Math.round(rect.width)}]`;
      });
    return { overflow, offenders };
  }, tolerance);

  const detail = offenders.length
    ? `\nOffending element(s) past the viewport (widest first):\n${offenders.join("\n")}`
    : "";
  expect(overflow, `horizontal overflow (scrollWidth − clientWidth)${detail}`).toBeLessThanOrEqual(
    tolerance,
  );
}
