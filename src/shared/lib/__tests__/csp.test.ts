import { describe, it, expect } from "vitest";
import { buildContentSecurityPolicy } from "@/shared/lib/csp";

describe("buildContentSecurityPolicy", () => {
  it("emits a nonce'd script-src and never 'unsafe-inline' for scripts", () => {
    const csp = buildContentSecurityPolicy("abc123");
    expect(csp).toContain("script-src 'self' 'nonce-abc123'");
    // The whole point of GAP-022: no inline-script escape hatch.
    const scriptSrc = csp.split("; ").find((d) => d.startsWith("script-src "));
    expect(scriptSrc).toBeDefined();
    expect(scriptSrc).not.toContain("'unsafe-inline'");
  });

  it("falls back to a script-src without nonce when none is given", () => {
    const csp = buildContentSecurityPolicy();
    expect(csp).toContain("script-src 'self'");
    expect(csp).not.toContain("nonce-");
    expect(csp).not.toContain("script-src 'self' 'unsafe-inline'");
  });

  it("keeps 'unsafe-inline' for styles (out of GAP-022 scope)", () => {
    const csp = buildContentSecurityPolicy("n");
    expect(csp).toContain("style-src 'self' 'unsafe-inline'");
  });

  it("allows the Google Fonts origins (stylesheet + woff2 files)", () => {
    const csp = buildContentSecurityPolicy("n");
    const styleSrc = csp.split("; ").find((d) => d.startsWith("style-src "));
    const fontSrc = csp.split("; ").find((d) => d.startsWith("font-src "));
    expect(styleSrc).toContain("https://fonts.googleapis.com");
    expect(fontSrc).toContain("https://fonts.gstatic.com");
  });

  it("locks down the dangerous sinks regardless of nonce", () => {
    for (const csp of [buildContentSecurityPolicy(), buildContentSecurityPolicy("n")]) {
      expect(csp).toContain("default-src 'self'");
      expect(csp).toContain("object-src 'none'");
      expect(csp).toContain("frame-ancestors 'none'");
      expect(csp).toContain("base-uri 'self'");
      expect(csp).toContain("form-action 'self'");
    }
  });

  it("allows the Supabase API/realtime origins for connect-src", () => {
    const csp = buildContentSecurityPolicy("n");
    expect(csp).toContain("connect-src 'self' https://*.supabase.co wss://*.supabase.co");
  });

  it("is a single well-formed header value (directives joined by '; ')", () => {
    const csp = buildContentSecurityPolicy("n");
    expect(csp).not.toContain(";;");
    expect(csp.startsWith("default-src")).toBe(true);
    // No trailing separator.
    expect(csp.endsWith(";")).toBe(false);
  });
});
