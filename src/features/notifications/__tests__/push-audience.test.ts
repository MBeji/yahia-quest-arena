// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  appLocalDate,
  appLocalWeekday,
  groupPushPlan,
  isParentDigestDay,
  isStreakAtRisk,
  parentDigestPayload,
  payloadFor,
  PUSH_PRIORITY,
  resolveDailyPushPlan,
  safeLocale,
  selectStreakAtRiskUserIds,
  type PushCandidate,
  type StreakProfileRow,
} from "../push-audience";
import { PUSH_COPY, PARENT_DIGEST_COPY } from "../push-copy";

describe("push-audience", () => {
  describe("appLocalDate", () => {
    it("maps a late-UTC instant to the next Tunisia-local day (UTC+1)", () => {
      // 23:30 UTC on 2026-06-12 is already 00:30 on 2026-06-13 in Tunis.
      expect(appLocalDate(new Date("2026-06-12T23:30:00Z"))).toBe("2026-06-13");
    });
    it("keeps the same civil day for a midday instant", () => {
      expect(appLocalDate(new Date("2026-06-12T10:00:00Z"))).toBe("2026-06-12");
    });
  });

  describe("isStreakAtRisk", () => {
    const today = "2026-06-13";
    it("flags a live streak last active before today", () => {
      expect(
        isStreakAtRisk({ id: "a", current_streak: 4, last_active_date: "2026-06-12" }, today),
      ).toBe(true);
    });
    it("does not flag a streak already active today", () => {
      expect(
        isStreakAtRisk({ id: "a", current_streak: 4, last_active_date: "2026-06-13" }, today),
      ).toBe(false);
    });
    it("does not flag a zero streak", () => {
      expect(
        isStreakAtRisk({ id: "a", current_streak: 0, last_active_date: "2026-06-01" }, today),
      ).toBe(false);
    });
    it("flags a live streak with a null last-active date", () => {
      expect(isStreakAtRisk({ id: "a", current_streak: 2, last_active_date: null }, today)).toBe(
        true,
      );
    });
  });

  it("selectStreakAtRiskUserIds keeps only the at-risk ids", () => {
    const rows: StreakProfileRow[] = [
      { id: "at-risk", current_streak: 3, last_active_date: "2026-06-12" },
      { id: "safe", current_streak: 3, last_active_date: "2026-06-13" },
      { id: "no-streak", current_streak: 0, last_active_date: null },
    ];
    expect(selectStreakAtRiskUserIds(rows, "2026-06-13")).toEqual(["at-risk"]);
  });

  it("le rappel de série vise le tableau de bord, sous un tag stable", () => {
    const p = payloadFor("streak-at-risk", "fr", 4);
    expect(p.url).toBe("/dashboard");
    expect(p.tag).toBe("streak-at-risk");
    expect(p.body).toContain("4");
  });

  describe("weekly parent digest scheduling", () => {
    it("appLocalWeekday resolves the Tunisia-local weekday across the UTC boundary", () => {
      // 23:30 UTC on Saturday 2026-07-04 is already Sunday 00:30 in Tunis (UTC+1).
      expect(appLocalWeekday(new Date("2026-07-04T23:30:00Z"))).toBe("Sun");
      expect(appLocalWeekday(new Date("2026-07-01T18:00:00Z"))).toBe("Wed");
    });

    it("isParentDigestDay fires on Sunday (Tunis-local) only", () => {
      expect(isParentDigestDay(new Date("2026-07-05T18:00:00Z"))).toBe(true); // Sunday 19:00 Tunis
      expect(isParentDigestDay(new Date("2026-07-01T18:00:00Z"))).toBe(false); // Wednesday
      expect(isParentDigestDay(new Date("2026-07-04T23:30:00Z"))).toBe(true); // Sunday in Tunis already
    });

    it("le bilan famille vise le suivi parental, sous un tag stable", () => {
      const p = parentDigestPayload("fr");
      expect(p.url).toBe("/parent-report");
      expect(p.tag).toBe("weekly-family-report");
      expect(p.title.length).toBeGreaterThan(0);
      expect(p.body.length).toBeGreaterThan(0);
    });
  });
});

/**
 * Étude 31 lot 4 — LE CANAL.
 *
 * Trois propriétés, et chacune répare une panne nommée par l'étude :
 *
 *   1. ⭐ AU PLUS UN PUSH PAR ÉLÈVE ET PAR JOUR (R-4), par STRUCTURE. La règle
 *      tenait par une exclusion écrite à la main entre DEUX audiences ; à six, il
 *      en faudrait quinze, et il suffirait d'en oublier une pour qu'un élève
 *      reçoive trois notifications le même soir — c'est-à-dire pour qu'il les
 *      coupe (RISK-2).
 *   2. ⭐ L'ORDRE DE PRIORITÉ EST CELUI DE R-16, et il n'est pas décoratif : un
 *      résultat de ligue est une nouvelle, une relance d'absent est un dernier
 *      recours. Les inverser ferait passer « reviens » avant « tu as gagné ».
 *   3. ⭐ CHAQUE TAG PARLE LES TROIS LANGUES (R-17). Le canal a déjà divergé une
 *      fois : trois payloads en français pour tout le monde, y compris l'élève
 *      qui lit l'application en arabe.
 */
describe("é31 lot 4 — pipeline de priorité et textes localisés", () => {
  const candidate = (over: Partial<PushCandidate> = {}): PushCandidate => ({
    userId: "u1",
    tag: "comeback",
    locale: "fr",
    arg: null,
    ...over,
  });

  it("⭐ ne garde qu'UN candidat par élève (R-4)", () => {
    const plan = resolveDailyPushPlan([
      candidate({ userId: "u1", tag: "comeback" }),
      candidate({ userId: "u1", tag: "streak-at-risk", arg: 5 }),
      candidate({ userId: "u1", tag: "tutor-daily-plan", arg: 2 }),
      candidate({ userId: "u2", tag: "comeback" }),
    ]);
    expect(plan).toHaveLength(2);
    expect(plan.filter((p) => p.userId === "u1")).toHaveLength(1);
  });

  it("⭐ garde le plus prioritaire, quel que soit l'ordre d'arrivée", () => {
    const forward = resolveDailyPushPlan([
      candidate({ tag: "comeback" }),
      candidate({ tag: "league-result", arg: 30 }),
    ]);
    const backward = resolveDailyPushPlan([
      candidate({ tag: "league-result", arg: 30 }),
      candidate({ tag: "comeback" }),
    ]);
    expect(forward[0].tag).toBe("league-result");
    expect(backward[0].tag).toBe("league-result");
  });

  it("respecte l'ordre exact de R-16, deux à deux", () => {
    for (let i = 0; i < PUSH_PRIORITY.length - 1; i += 1) {
      const plan = resolveDailyPushPlan([
        candidate({ tag: PUSH_PRIORITY[i + 1], arg: 1 }),
        candidate({ tag: PUSH_PRIORITY[i], arg: 1 }),
      ]);
      expect(plan[0].tag).toBe(PUSH_PRIORITY[i]);
    }
  });

  it("⭐ une série PERDUE passe devant une série en danger — le trou du canal d'avant", () => {
    const plan = resolveDailyPushPlan([
      candidate({ tag: "streak-at-risk", arg: 3 }),
      candidate({ tag: "streak-lost", arg: 3 }),
    ]);
    expect(plan[0].tag).toBe("streak-lost");
  });

  it("écarte un tag inconnu au lieu de le laisser gagner par accident", () => {
    const plan = resolveDailyPushPlan([
      { userId: "u1", tag: "marketing" as never, locale: "fr", arg: null },
    ]);
    expect(plan).toHaveLength(0);
  });

  it("groupe par (tag, langue, nombre) — un envoi par groupe, pas par élève", () => {
    const groups = groupPushPlan([
      candidate({ userId: "a", tag: "tutor-daily-plan", arg: 2, locale: "fr" }),
      candidate({ userId: "b", tag: "tutor-daily-plan", arg: 2, locale: "fr" }),
      candidate({ userId: "c", tag: "tutor-daily-plan", arg: 2, locale: "ar" }),
      candidate({ userId: "d", tag: "tutor-daily-plan", arg: 3, locale: "fr" }),
    ]);
    expect(groups).toHaveLength(3);
    expect(groups.find((g) => g.locale === "fr" && g.arg === 2)?.userIds).toEqual(["a", "b"]);
  });

  it("⭐ chaque tag a un titre et un corps dans les trois langues (R-17)", () => {
    for (const tag of PUSH_PRIORITY) {
      for (const locale of ["fr", "en", "ar"] as const) {
        const copy = PUSH_COPY[tag][locale];
        expect(copy.title.length, `${tag}/${locale} titre`).toBeGreaterThan(0);
        expect(copy.body.length, `${tag}/${locale} corps`).toBeGreaterThan(0);
        expect(copy.url.startsWith("/"), `${tag}/${locale} url`).toBe(true);
      }
      expect(PARENT_DIGEST_COPY.ar.title.length).toBeGreaterThan(0);
    }
  });

  it("⭐ aucun texte ne culpabilise (R-8)", () => {
    const banned = [
      "échoué",
      "abandonn",
      "tu as perdu",
      "failed",
      "gave up",
      "you lost",
      "خسرت",
      "فشلت",
    ];
    for (const tag of PUSH_PRIORITY) {
      for (const locale of ["fr", "en", "ar"] as const) {
        const text = `${PUSH_COPY[tag][locale].title} ${PUSH_COPY[tag][locale].body}`.toLowerCase();
        for (const word of banned) {
          expect(text.includes(word), `${tag}/${locale} contient « ${word} »`).toBe(false);
        }
      }
    }
  });

  it("interpole le nombre, et met le plan du jour au singulier quand il n'y en a qu'une", () => {
    expect(payloadFor("tutor-daily-plan", "fr", 3).body).toContain("3");
    expect(payloadFor("tutor-daily-plan", "fr", 1).body).not.toContain("{n}");
    expect(payloadFor("streak-milestone", "ar", 30).title).toContain("30");
  });

  it("une langue inconnue retombe en français plutôt que de ne rien envoyer", () => {
    expect(safeLocale(null)).toBe("fr");
    expect(safeLocale("de")).toBe("fr");
    expect(safeLocale("ar")).toBe("ar");
  });
});
