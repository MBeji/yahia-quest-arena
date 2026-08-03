import { render } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";

// The component reads only the matched pathname from the router; a stub keeps
// this spec on the URL-building rule instead of on router wiring.
const mockPathname = vi.fn<() => string>();
vi.mock("@tanstack/react-router", () => ({
  useRouterState: ({ select }: { select: (s: { location: { pathname: string } }) => string }) =>
    select({ location: { pathname: mockPathname() } }),
}));

import { CanonicalLink } from "@/components/public/canonical-link";
import { SITE_URL } from "@/shared/constants/site";

/** Render and read back the href the component put on its <link rel="canonical">. */
function canonicalFor(pathname: string): string {
  mockPathname.mockReturnValue(pathname);
  const { container } = render(<CanonicalLink />);
  // React 19 hoists <link> to <head> in the browser; under jsdom + RTL the
  // element stays in the container, so look in both to stay implementation-blind.
  const el =
    container.querySelector('link[rel="canonical"]') ??
    document.head.querySelector('link[rel="canonical"]');
  return el?.getAttribute("href") ?? "";
}

describe("CanonicalLink", () => {
  beforeEach(() => {
    document.head.querySelectorAll('link[rel="canonical"]').forEach((n) => n.remove());
  });

  it("points at the served origin, not the redirecting apex", () => {
    expect(canonicalFor("/programme")).toBe("https://www.na9ranal3ab.tn/programme");
  });

  it("collapses the root path to the bare origin (no trailing slash)", () => {
    expect(canonicalFor("/")).toBe(SITE_URL);
  });

  it("drops a trailing slash so one page never claims two canonical URLs", () => {
    expect(canonicalFor("/programme/")).toBe(canonicalFor("/programme"));
  });

  it("keeps the full path of a nested route", () => {
    expect(canonicalFor("/matiere/math-9eme")).toBe(`${SITE_URL}/matiere/math-9eme`);
  });

  it("stays absolute — a relative canonical would resolve against the wrong host", () => {
    expect(canonicalFor("/extras").startsWith("https://")).toBe(true);
  });
});
