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

  it("n'autorise plus AUCUNE origine de fonte tierce (levier 06 : auto-hébergement)", () => {
    // L'assertion inverse tenait tant que les fontes venaient de Google. Elle est
    // retournée volontairement : la politique doit interdire ce que le code ne
    // fait plus, sinon elle rouvre en silence le jour où quelqu'un recolle un
    // <link> — et avec lui l'envoi de l'IP d'un élève mineur à un tiers.
    const csp = buildContentSecurityPolicy("n");
    const styleSrc = csp.split("; ").find((d) => d.startsWith("style-src "));
    const fontSrc = csp.split("; ").find((d) => d.startsWith("font-src "));
    expect(styleSrc).not.toContain("fonts.googleapis.com");
    expect(fontSrc).not.toContain("fonts.gstatic.com");
    expect(fontSrc).toBe("font-src 'self' data:");
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

  it("allows the Google Analytics 4 origins (gtag.js loader + collect beacons)", () => {
    // Une assertion PAR HÔTE, et sur le jeton exact — pas un `toContain` sur la
    // chaîne entière. Ce test a longtemps affirmé `https://*.analytics.google.com`
    // sans rien dire du domaine nu : il restait vert sur un défaut bien réel.
    //
    // ⚠️ `https://*.analytics.google.com` ne couvre PAS `https://analytics.google.com`.
    // En CSP, un joker d'hôte exige au moins un label de sous-domaine : le motif
    // `*.example.com` matche `a.example.com`, jamais `example.com`. Les deux
    // entrées sont donc nécessaires — ne « simplifiez » pas en n'en gardant qu'une,
    // cela rouvre exactement le défaut que ce test verrouille (constat prod du
    // 2026-08-19 : des `page_view` et des `scroll` bloqués en silence, invisibles
    // côté serveur — aucun gate ne les voit, ça ne se lit qu'en console navigateur).
    const collectHosts = [
      "https://www.google-analytics.com",
      "https://*.google-analytics.com",
      "https://analytics.google.com",
      "https://*.analytics.google.com",
      // gtag émet aussi vers /g/collect sur ce domaine (signaux Google / régions).
      "https://www.google.com",
    ];
    for (const csp of [buildContentSecurityPolicy(), buildContentSecurityPolicy("n")]) {
      const scriptSrc = csp.split("; ").find((d) => d.startsWith("script-src "));
      const connectSrc = csp.split("; ").find((d) => d.startsWith("connect-src "));
      // gtag.js loads as an external script from the tag-manager host…
      expect(scriptSrc).toContain("https://www.googletagmanager.com");
      // …and beacons the measurement protocol to each collect host below.
      const sources = connectSrc?.split(" ").slice(1) ?? [];
      for (const host of collectHosts) expect(sources).toContain(host);
      // Rester étroit : couvrir `www.google.com` ne doit jamais devenir un joker
      // sur toute propriété Google.
      expect(sources).not.toContain("https://*.google.com");
    }
  });

  it("allows the PostHog ingest origin in connect-src only (no SDK, no script host)", () => {
    for (const csp of [buildContentSecurityPolicy(), buildContentSecurityPolicy("n")]) {
      const scriptSrc = csp.split("; ").find((d) => d.startsWith("script-src "));
      const connectSrc = csp.split("; ").find((d) => d.startsWith("connect-src "));
      expect(connectSrc).toContain("https://eu.i.posthog.com");
      // We post capture payloads with `fetch` — nothing is ever loaded as a script.
      expect(scriptSrc).not.toContain("posthog");
    }
  });

  it("pins exactly one embeddable video host via frame-src (étude 23)", () => {
    for (const csp of [buildContentSecurityPolicy(), buildContentSecurityPolicy("n")]) {
      const frameSrc = csp.split("; ").filter((d) => d.startsWith("frame-src "));
      expect(frameSrc).toHaveLength(1);
      expect(frameSrc[0]).toBe("frame-src https://www.youtube-nocookie.com");
      // frame-src (what WE embed) is distinct from frame-ancestors (who embeds US).
      expect(csp).toContain("frame-ancestors 'none'");
    }
  });

  it("is a single well-formed header value (directives joined by '; ')", () => {
    const csp = buildContentSecurityPolicy("n");
    expect(csp).not.toContain(";;");
    expect(csp.startsWith("default-src")).toBe(true);
    // No trailing separator.
    expect(csp.endsWith(";")).toBe(false);
  });
});
