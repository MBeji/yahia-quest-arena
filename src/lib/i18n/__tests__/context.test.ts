import { describe, it, expect } from "vitest";
import {
  localeFromCookieHeader,
  isLocale,
  dirForLocale,
  DEFAULT_LOCALE,
  LOCALE_COOKIE,
} from "../context";

// SSR locale resolution: the server shell sets <html lang/dir> from the raw
// Cookie header BEFORE hydration. A regression here flashes the wrong language
// / direction on every page load (the GAP-010 French-first journey).
describe("localeFromCookieHeader", () => {
  it("falls back to the French default without a Cookie header", () => {
    expect(DEFAULT_LOCALE).toBe("fr");
    expect(localeFromCookieHeader(null)).toBe("fr");
    expect(localeFromCookieHeader(undefined)).toBe("fr");
    expect(localeFromCookieHeader("")).toBe("fr");
  });

  it("reads the locale cookie among other cookies, with spaces", () => {
    const header = `theme=dark; ${LOCALE_COOKIE}=ar; sb-token=abc`;
    expect(localeFromCookieHeader(header)).toBe("ar");
  });

  it("decodes a percent-encoded value", () => {
    expect(localeFromCookieHeader(`${LOCALE_COOKIE}=%65%6e`)).toBe("en");
  });

  it("ignores unknown locales and look-alike cookie names", () => {
    expect(localeFromCookieHeader(`${LOCALE_COOKIE}=de`)).toBe("fr");
    expect(localeFromCookieHeader(`not-${LOCALE_COOKIE}=en`)).toBe("fr");
  });

  it("keeps values containing '=' intact (split on the first '=' only)", () => {
    // An invalid-but-weird value must not crash and must fall back.
    expect(localeFromCookieHeader(`${LOCALE_COOKIE}=en=extra`)).toBe("fr");
  });
});

describe("isLocale / dirForLocale", () => {
  it("accepts exactly the three supported locales", () => {
    expect(isLocale("fr")).toBe(true);
    expect(isLocale("en")).toBe(true);
    expect(isLocale("ar")).toBe(true);
    expect(isLocale("es")).toBe(false);
    expect(isLocale(null)).toBe(false);
    expect(isLocale(undefined)).toBe(false);
  });

  it("flips the document direction only for Arabic", () => {
    expect(dirForLocale("ar")).toBe("rtl");
    expect(dirForLocale("fr")).toBe("ltr");
    expect(dirForLocale("en")).toBe("ltr");
  });
});
