import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const CSS = readFileSync(resolve(import.meta.dirname, "../../../styles.css"), "utf-8");

describe("@media print — authenticated lesson reader (app-shell)", () => {
  it("resets .lesson-content text to black so dark-theme foreground is not invisible", () => {
    // Regression test for C4 (d526f658): dark theme --foreground ≈ white becomes
    // invisible when the browser sets a white page background for print. The fix adds
    // an explicit color:#000 rule for .app-shell .lesson-content inside @media print.
    expect(CSS).toMatch(
      /@media print[\s\S]*?\.app-shell\s+\.lesson-content[\s\S]*?color\s*:\s*#000/,
    );
  });

  it("does not hide lesson content in print mode", () => {
    // Guard against accidentally adding display:none to the lesson content in print.
    const match = CSS.match(/@media print[\s\S]*?(\.app-shell\s+\.lesson-content[^{]*\{[^}]*\})/);
    if (match) {
      expect(match[1]).not.toContain("display: none");
    }
  });
});
