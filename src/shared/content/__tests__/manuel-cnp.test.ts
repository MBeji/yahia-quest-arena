import { describe, it, expect } from "vitest";
import { CNP_MANUEL_BASE_URL, cnpManuelFileName, cnpManuelUrl } from "../manuel-cnp";

describe("cnpManuelFileName", () => {
  it("adds the P00 volume suffix to a bare book code", () => {
    // Every bare code authored today is a single-volume work whose only tome in
    // suivi/corpus-cnp.json is P00 — maths 9ème année de base among them.
    expect(cnpManuelFileName("102905")).toBe("102905P00.pdf");
    expect(cnpManuelFileName("201202")).toBe("201202P00.pdf");
  });

  it("keeps a volume suffix the content already spells out", () => {
    expect(cnpManuelFileName("102105P01")).toBe("102105P01.pdf");
    expect(cnpManuelFileName("102105P02")).toBe("102105P02.pdf");
    expect(cnpManuelFileName("241403P00")).toBe("241403P00.pdf");
  });

  it("refuses anything that could escape the store's path", () => {
    for (const code of ["../evil", "a/b", "102905?x", "102905#f", "102905%2e", "", "a b"]) {
      expect(cnpManuelFileName(code)).toBeNull();
    }
  });
});

describe("cnpManuelUrl", () => {
  it("builds the link from the code alone", () => {
    expect(cnpManuelUrl("102905")).toBe(`${CNP_MANUEL_BASE_URL}/102905P00.pdf`);
  });

  it("anchors on the chapter's first page when there is one", () => {
    expect(cnpManuelUrl("102905", 18)).toBe(`${CNP_MANUEL_BASE_URL}/102905P00.pdf#page=18`);
  });

  it("ignores a page that is not a positive integer", () => {
    const plain = `${CNP_MANUEL_BASE_URL}/102905P00.pdf`;
    expect(cnpManuelUrl("102905", 0)).toBe(plain);
    expect(cnpManuelUrl("102905", -3)).toBe(plain);
    expect(cnpManuelUrl("102905", 2.5)).toBe(plain);
    expect(cnpManuelUrl("102905", null)).toBe(plain);
    expect(cnpManuelUrl("102905", undefined)).toBe(plain);
  });

  it("returns null rather than a dead link for an unusable code", () => {
    expect(cnpManuelUrl("../evil", 3)).toBeNull();
  });

  it("stays on the CNP's own host, over https", () => {
    const url = new URL(cnpManuelUrl("102905", 18) as string);
    expect(url.protocol).toBe("https:");
    expect(url.hostname.endsWith("cnp.com.tn")).toBe(true);
  });
});
