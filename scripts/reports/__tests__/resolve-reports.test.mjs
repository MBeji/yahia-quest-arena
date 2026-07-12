import { describe, expect, it } from "vitest";
import { parseReportTrailers, TABLES } from "../resolve-reports.mjs";

const B1 = "3f2b8c1a-4d5e-4f6a-8b9c-0d1e2f3a4b5c";
const C1 = "aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee";

describe("parseReportTrailers", () => {
  it("extracts bug and content trailers from a PR body", () => {
    const body = [
      "## What & why",
      "Fixes the stuck submit button reported by users.",
      "",
      `Report-Id: ${B1} (bug)`,
      `Report-Id: ${C1} (content)`,
    ].join("\n");
    expect(parseReportTrailers(body)).toEqual({ bug: [B1], content: [C1] });
  });

  it("is case-insensitive on hex digits and channel, and de-duplicates", () => {
    const body = [`report-id: ${B1.toUpperCase()} (BUG)`, `Report-Id: ${B1} (bug)`].join("\n");
    expect(parseReportTrailers(body)).toEqual({ bug: [B1], content: [] });
  });

  it("ignores malformed ids and unknown channels (untrusted body text)", () => {
    const body = [
      "Report-Id: not-a-uuid (bug)",
      `Report-Id: ${B1} (shop)`,
      `Report-Id: ${B1} (bug) ; DROP TABLE bug_reports;`, // trailing junk → full-line match fails
      `some prose mentioning Report-Id: inline ${C1} (content) mid-sentence`,
    ].join("\n");
    expect(parseReportTrailers(body)).toEqual({ bug: [], content: [] });
  });

  it("tolerates surrounding whitespace and empty/null bodies", () => {
    expect(parseReportTrailers(`   Report-Id:  ${C1}  (content)   `)).toEqual({
      bug: [],
      content: [C1],
    });
    expect(parseReportTrailers("")).toEqual({ bug: [], content: [] });
    expect(parseReportTrailers(null)).toEqual({ bug: [], content: [] });
  });
});

describe("TABLES", () => {
  it("maps each channel to its Supabase table", () => {
    expect(TABLES).toEqual({ bug: "bug_reports", content: "content_reports" });
  });
});
