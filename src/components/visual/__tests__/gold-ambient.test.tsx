import { render } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { GoldAmbient } from "../gold-ambient";

describe("GoldAmbient", () => {
  it("renders a non-interactive, aria-hidden ambient layer", () => {
    const { container } = render(<GoldAmbient />);
    const root = container.firstChild as HTMLElement;
    expect(root).toBeTruthy();
    expect(root.getAttribute("aria-hidden")).toBe("true");
    expect(root.className).toContain("pointer-events-none");
  });
});
