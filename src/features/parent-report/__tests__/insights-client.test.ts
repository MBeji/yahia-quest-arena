// @vitest-environment node
import { describe, expect, it, vi } from "vitest";

/**
 * Le moteur d'analyse (`../insights`) est servi au CLIENT — `daily-dashboard.tsx`
 * l'importe pour `formatMinutes`, `computeEngagement`… — et zod n'a rien à y faire.
 *
 * Jusqu'au 2026-10-31, `insights/daily-report.ts` déclarait ses schémas zod au
 * niveau module et le barrel les ré-exportait : non secouable, zod entier (84 KB,
 * 23,6 KB gzip) partait à chaque parent sur /suivi et /parent-report pour un
 * `parse` qui ne tourne que dans les server fns. Les parseurs vivent depuis dans
 * `daily-report.schemas.ts`, importé par le seul `parent-report.server.ts`.
 *
 * La sonde : le module `zod` est remplacé par une fabrique qui note son appel.
 * Charger le barrel ne doit pas la déclencher — une ré-exportation de trop, même
 * d'une seule fonction, la rallumerait.
 */
const sonde = vi.hoisted(() => ({ zodCharge: false }));

vi.mock("zod", () => {
  sonde.zodCharge = true;
  return {};
});

describe("insights — la partie servie au client", () => {
  it("le barrel se charge sans jamais importer zod", async () => {
    const insights = await import("../insights");
    expect(typeof insights.formatMinutes).toBe("function");
    expect(typeof insights.answerLabel).toBe("function");
    expect(sonde.zodCharge).toBe(false);
  });

  it("la sonde elle-même fonctionne : le module des schémas, lui, importe zod", async () => {
    await expect(import("../insights/daily-report.schemas")).rejects.toThrow();
    expect(sonde.zodCharge).toBe(true);
  });
});
