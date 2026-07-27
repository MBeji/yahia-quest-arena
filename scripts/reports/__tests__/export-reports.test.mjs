import { describe, expect, it } from "vitest";
import {
  assertProdReportSource,
  buildExport,
  flattenBugReport,
  flattenContentReport,
} from "../export-reports.mjs";
import { PROD_SUPABASE_REF } from "../../shared/prod-targets.mjs";

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
