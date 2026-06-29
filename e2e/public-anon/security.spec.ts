import { test, expect } from "../fixtures";
import { requirePublicEnv } from "../helpers/env";

/**
 * Anon REST-surface invariants behind the C8 public opening (GAP-020). The `anon`
 * role may read admin CONTENT, but must NEVER read the answer key
 * (questions.correct_option) nor any player data (profiles/attempts). We probe the
 * TEST project directly with the anon key — the exact surface the browser holds —
 * via Playwright's APIRequestContext (absolute URL overrides the app baseURL).
 *
 * Mechanism (for reference): 20260610170000_hide_answer_key revokes table SELECT on
 * `questions` and re-grants only (id, exercise_id, prompt, options, display_order);
 * 20260621180000_anon_read_admin_catalogue adds the anon SELECT policy scoped to
 * source='admin'. So correct_option/explanation are unreachable by anon.
 */
test.describe("Anon data-access invariants (C8 public opening / GAP-020)", () => {
  test("anon CAN read admin catalogue content (subjects / exercises / questions)", async ({
    request,
  }) => {
    const { url, anonKey } = requirePublicEnv();
    const headers = { apikey: anonKey, Authorization: `Bearer ${anonKey}` };
    for (const path of [
      "subjects?select=id&limit=1",
      "exercises?select=id&limit=1",
      "questions?select=id&limit=1",
    ]) {
      const res = await request.get(`${url}/rest/v1/${path}`, { headers });
      expect(res.ok(), `anon should be able to read ${path}`).toBeTruthy();
    }
  });

  test("anon can NEVER read the answer key (questions.correct_option)", async ({ request }) => {
    const { url, anonKey } = requirePublicEnv();
    const headers = { apikey: anonKey, Authorization: `Bearer ${anonKey}` };
    const res = await request.get(`${url}/rest/v1/questions?select=correct_option&limit=5`, {
      headers,
    });
    if (res.ok()) {
      // If the request is somehow allowed, the column must never carry a real value.
      const rows = (await res.json()) as Array<{ correct_option?: unknown }>;
      for (const row of rows) {
        expect(row.correct_option ?? null, "correct_option must not be exposed to anon").toBeNull();
      }
    } else {
      // Expected: the column SELECT grant excludes correct_option for anon → denied.
      expect(res.status()).toBeGreaterThanOrEqual(400);
    }
  });

  test("anon canNOT read player data (profiles / attempts)", async ({ request }) => {
    const { url, anonKey } = requirePublicEnv();
    const headers = { apikey: anonKey, Authorization: `Bearer ${anonKey}` };
    for (const table of ["profiles", "attempts"]) {
      const res = await request.get(`${url}/rest/v1/${table}?select=id&limit=1`, { headers });
      if (res.ok()) {
        const rows = (await res.json()) as unknown[];
        expect(rows.length, `${table} must not be readable by anon`).toBe(0);
      } else {
        expect(res.status(), `${table} should be denied to anon`).toBeGreaterThanOrEqual(400);
      }
    }
  });
});
