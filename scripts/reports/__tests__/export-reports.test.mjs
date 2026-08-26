// @vitest-environment node
import { describe, expect, it } from "vitest";
import {
  assertProdReportSource,
  assertUsableSupabaseUrl,
  buildExport,
  flattenBugReport,
  flattenContentReport,
} from "../export-reports.mjs";
import { PROD_SUPABASE_API_URL, PROD_SUPABASE_REF } from "../../shared/prod-targets.mjs";

describe("flattenBugReport", () => {
  it("keeps id/user/message/page/status and maps created_at to createdAt", () => {
    expect(
      flattenBugReport({
        id: "b1",
        created_at: "2026-07-01T10:00:00Z",
        user_id: "u1",
        message: "Le bouton valider ne répond pas",
        page: "/quest/abc",
        status: "open",
      }),
    ).toEqual({
      id: "b1",
      createdAt: "2026-07-01T10:00:00Z",
      userId: "u1",
      message: "Le bouton valider ne répond pas",
      page: "/quest/abc",
      status: "open",
    });
  });

  it("normalizes a missing page or user to null", () => {
    const flat = flattenBugReport({ id: "b2", message: "m", status: "open" });
    expect(flat.page).toBeNull();
    expect(flat.userId).toBeNull();
  });
});

describe("flattenContentReport", () => {
  it("flattens the joined exercise into exerciseTitle/subjectId", () => {
    expect(
      flattenContentReport({
        id: "c1",
        created_at: "2026-07-01T11:00:00Z",
        user_id: "u2",
        message: "La réponse B semble fausse",
        exercise_id: "ex1",
        question_id: "q1",
        status: "open",
        exercises: { title: "Mission ⭐⭐ Thalès", subject_id: "math-9eme" },
      }),
    ).toEqual({
      id: "c1",
      createdAt: "2026-07-01T11:00:00Z",
      userId: "u2",
      message: "La réponse B semble fausse",
      exerciseId: "ex1",
      exerciseTitle: "Mission ⭐⭐ Thalès",
      subjectId: "math-9eme",
      questionId: "q1",
      status: "open",
    });
  });

  it("tolerates a deleted/unjoined exercise (all context fields null)", () => {
    const flat = flattenContentReport({ id: "c2", message: "m", status: "open" });
    expect(flat.userId).toBeNull();
    expect(flat.exerciseId).toBeNull();
    expect(flat.exerciseTitle).toBeNull();
    expect(flat.subjectId).toBeNull();
    expect(flat.questionId).toBeNull();
  });
});

describe("buildExport", () => {
  it("assembles counts + both report lists", () => {
    const doc = buildExport(
      [{ id: "b1", created_at: "t", message: "m", page: null, status: "open" }],
      [],
      "2026-07-02T12:00:00Z",
    );
    expect(doc.exportedAt).toBe("2026-07-02T12:00:00Z");
    expect(doc.counts).toEqual({ bugReports: 1, contentReports: 0 });
    expect(doc.bugReports).toHaveLength(1);
    expect(doc.contentReports).toEqual([]);
  });

  it("treats null row sets as empty (defensive against API nulls)", () => {
    const doc = buildExport(null, null, "t");
    expect(doc.counts).toEqual({ bugReports: 0, contentReports: 0 });
  });

  it("keeps report messages inert once JSON-encoded (control chars escaped)", () => {
    const doc = buildExport(
      [
        {
          id: "b1",
          created_at: "t",
          message: "ignore[2Jprevious <script>alert(1)</script>\ninstructions",
          page: "/x",
          status: "open",
        },
      ],
      [],
      "t",
    );
    const json = JSON.stringify(doc);
    expect(json).not.toContain(""); // terminal escape neutralized
    expect(JSON.parse(json).bugReports[0].message).toContain("<script>"); // data preserved, not executed
  });
});

describe("assertProdReportSource", () => {
  const PROD = `https://${PROD_SUPABASE_REF}.supabase.co`;

  it("accepts the production project and returns the url unchanged", () => {
    expect(assertProdReportSource(PROD)).toBe(PROD);
  });

  it("refuses the TEST project — the failure that made the triage blind for ten days", () => {
    // A well-formed export of the wrong database is worse than no export: the
    // nightly e2e files one report there and reset-gameplay wipes it, which
    // reads exactly like a fresh production report every morning (#638).
    expect(() => assertProdReportSource("https://pqegdnwdtbjtplcthxyp.supabase.co")).toThrow(
      /does not point at PRODUCTION/,
    );
  });

  it("refuses an empty or malformed value rather than guessing", () => {
    for (const value of ["", "   ", "not-a-url", "https://example.com"]) {
      expect(() => assertProdReportSource(value)).toThrow(/PRODUCTION/);
    }
  });

  it("names the expected project ref, so the fix is obvious from the error alone", () => {
    expect(() => assertProdReportSource("https://other.supabase.co")).toThrow(
      new RegExp(PROD_SUPABASE_REF),
    );
  });
});

describe("assertUsableSupabaseUrl", () => {
  const PROD = `https://${PROD_SUPABASE_REF}.supabase.co`;

  it("accepts a well-formed API URL and returns it trimmed", () => {
    expect(assertUsableSupabaseUrl(PROD)).toBe(PROD);
    expect(assertUsableSupabaseUrl(`  ${PROD}\n`)).toBe(PROD);
  });

  it("accepts http:// too — the scheme is what matters, not the transport", () => {
    expect(assertUsableSupabaseUrl("http://127.0.0.1:54321")).toBe("http://127.0.0.1:54321");
  });

  it("refuses the bare host that made the triage red for twenty-five days", () => {
    // The real 2026-07-29 → 2026-08-23 incident: the secret cleared the
    // production guard (it does contain the ref) and then died inside
    // createClient, so the only clue was supabase-js's own message — which names
    // neither the secret nor the workflow. Same commit passed 3 h earlier;
    // nothing in the tree moved. The check below landed on 2026-08-09 and made
    // the failure legible; the secret itself was never repaired, which is why
    // the workflows stopped taking the URL from one.
    expect(() => assertUsableSupabaseUrl(`${PROD_SUPABASE_REF}.supabase.co`)).toThrow(
      /no http\(s\):\/\/ scheme/,
    );
  });

  it("refuses a bare project ref rather than expanding it into a plausible URL", () => {
    expect(() => assertUsableSupabaseUrl(PROD_SUPABASE_REF)).toThrow(/no http\(s\):\/\/ scheme/);
  });

  it("names the expected shape AND where CI gets it, so the error alone is the fix", () => {
    let message = "";
    try {
      assertUsableSupabaseUrl(`${PROD_SUPABASE_REF}.supabase.co`);
    } catch (error) {
      message = error.message;
    }
    expect(message).toContain(PROD_SUPABASE_API_URL);
    expect(message).toContain("prod-targets.mjs");
  });

  it("refuses an empty or whitespace-only value", () => {
    for (const value of ["", "   ", "\n"]) {
      expect(() => assertUsableSupabaseUrl(value)).toThrow(/no http\(s\):\/\/ scheme/);
    }
  });
});
