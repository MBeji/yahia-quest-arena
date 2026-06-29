import { describe, it, expect } from "vitest";
import {
  getClientIp,
  guardRequest,
  isAllowedCrawler,
  isBlockedUserAgent,
  RATE_LIMIT_MAX_REQUESTS,
} from "../bot-guard";

const BROWSER_UA =
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36";

describe("isBlockedUserAgent", () => {
  it("blocks declared AI/LLM crawlers", () => {
    expect(
      isBlockedUserAgent("Mozilla/5.0 (compatible; GPTBot/1.1; +https://openai.com/gptbot)"),
    ).toBe(true);
    expect(isBlockedUserAgent("ClaudeBot/1.0")).toBe(true);
    expect(isBlockedUserAgent("CCBot/2.0 (https://commoncrawl.org/faq/)")).toBe(true);
  });

  it("blocks generic scraping tools", () => {
    expect(isBlockedUserAgent("python-requests/2.31.0")).toBe(true);
    expect(isBlockedUserAgent("curl/8.4.0")).toBe(true);
    expect(isBlockedUserAgent("Scrapy/2.11 (+https://scrapy.org)")).toBe(true);
  });

  it("allows real browsers", () => {
    expect(isBlockedUserAgent(BROWSER_UA)).toBe(false);
  });

  it("never blocks allowlisted search/social crawlers", () => {
    expect(
      isBlockedUserAgent(
        "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
      ),
    ).toBe(false);
    expect(
      isBlockedUserAgent("Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)"),
    ).toBe(false);
    expect(isAllowedCrawler("facebookexternalhit/1.1")).toBe(true);
  });

  it("does not hard-block a missing User-Agent", () => {
    expect(isBlockedUserAgent(null)).toBe(false);
    expect(isBlockedUserAgent("")).toBe(false);
  });
});

describe("getClientIp", () => {
  it("reads the first x-forwarded-for hop", () => {
    expect(getClientIp(new Headers({ "x-forwarded-for": "203.0.113.5, 70.41.3.18" }))).toBe(
      "203.0.113.5",
    );
  });

  it("falls back to x-real-ip then cf-connecting-ip", () => {
    expect(getClientIp(new Headers({ "x-real-ip": "198.51.100.7" }))).toBe("198.51.100.7");
    expect(getClientIp(new Headers({ "cf-connecting-ip": "198.51.100.9" }))).toBe("198.51.100.9");
  });

  it("returns null without proxy headers", () => {
    expect(getClientIp(new Headers())).toBeNull();
  });
});

describe("guardRequest", () => {
  it("403s a blocked agent", () => {
    const res = guardRequest(
      new Request("https://x.tn/programme", { headers: { "user-agent": "GPTBot/1.1" } }),
    );
    expect(res?.status).toBe(403);
  });

  it("lets a normal browser through", () => {
    const res = guardRequest(
      new Request("https://x.tn/programme", {
        headers: { "user-agent": BROWSER_UA, "x-forwarded-for": "192.0.2.50" },
      }),
    );
    expect(res).toBeNull();
  });

  it("429s an IP over the burst limit", () => {
    const ip = "192.0.2.123";
    let last: Response | null = null;
    for (let i = 0; i < RATE_LIMIT_MAX_REQUESTS + 5; i++) {
      last = guardRequest(
        new Request("https://x.tn/programme", {
          headers: { "user-agent": BROWSER_UA, "x-forwarded-for": ip },
        }),
      );
    }
    expect(last?.status).toBe(429);
    expect(last?.headers.get("retry-after")).toBe("60");
  });
});
