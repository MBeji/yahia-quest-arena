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
 */
export async function expectNoHorizontalOverflow(page: Page, tolerance = 2): Promise<void> {
  const overflow = await page.evaluate(
    () => document.documentElement.scrollWidth - document.documentElement.clientWidth,
  );
  expect(overflow, "horizontal overflow (scrollWidth − clientWidth)").toBeLessThanOrEqual(
    tolerance,
  );
}
