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

  it("contains retry button", () => {
    const html = renderErrorPage();
    expect(html).toContain("Try again");
    expect(html).toContain("location.reload()");
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
