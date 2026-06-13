import { describe, it, expect } from "vitest";
import { renderErrorPage } from "@/shared/lib/error-page";

describe("renderErrorPage", () => {
  it("returns valid HTML string", () => {
    const html = renderErrorPage();
    expect(html).toContain("<!doctype html>");
    expect(html).toContain("</html>");
  });

  it("contains error messaging", () => {
    const html = renderErrorPage();
    expect(html).toContain("didn't load");
    expect(html).toContain("Something went wrong");
  });

  it("offers a CSP-safe retry link (no inline event handler)", () => {
    const html = renderErrorPage();
    expect(html).toContain("Try again");
    // GAP-022: a nonce-based CSP blocks inline handlers — reload via empty href.
    expect(html).not.toContain("onclick");
    expect(html).toContain('href=""');
  });

  it("contains home link", () => {
    const html = renderErrorPage();
    expect(html).toContain('href="/"');
    expect(html).toContain("Go home");
  });

  it("has proper meta viewport for mobile", () => {
    const html = renderErrorPage();
    expect(html).toContain('name="viewport"');
    expect(html).toContain("width=device-width");
  });
});
