import { describe, it, expect } from "vitest";
import { enrichedParentDigestPayload, PARENT_DIGEST_TAG, type DigestChild } from "../push-copy";

const child = (over: Partial<DigestChild> = {}): DigestChild => ({
  displayName: "Amine",
  learningMinutes: 45,
  missions: 3,
  streak: 2,
  weakChapter: null,
  ...over,
});

describe("enrichedParentDigestPayload — étude 08 lot 2", () => {
  it("rend null sans enfant : l'appelant retombe sur le générique", () => {
    expect(enrichedParentDigestPayload("fr", [])).toBeNull();
  });

  it("garde le tag et l'URL du bilan famille — aucune donnée d'élève dans l'adresse", () => {
    const payload = enrichedParentDigestPayload("fr", [child({ weakChapter: "Les fractions" })]);
    expect(payload?.tag).toBe(PARENT_DIGEST_TAG);
    expect(payload?.url).toBe("/parent-report");
  });

  it.each([
    [45, "45 min"],
    [60, "1 h"],
    [80, "1 h 20"],
  ])("fr : %i minutes se lisent « %s »", (minutes, text) => {
    const payload = enrichedParentDigestPayload("fr", [child({ learningMinutes: minutes })]);
    expect(payload?.body.startsWith(`${text} · `)).toBe(true);
  });

  it("accorde le singulier — « 1 mission », « série de 1 jour »", () => {
    const payload = enrichedParentDigestPayload("fr", [child({ missions: 1, streak: 1 })]);
    expect(payload?.body).toBe("45 min · 1 mission · série de 1 jour.");
  });

  it("tait un segment nul plutôt que d'écrire un zéro", () => {
    const payload = enrichedParentDigestPayload("fr", [child({ learningMinutes: 0, streak: 0 })]);
    expect(payload?.body).toBe("3 missions.");
  });

  it("le chapitre fragile se dit comme une chose à revoir ENSEMBLE", () => {
    const payload = enrichedParentDigestPayload("en", [child({ weakChapter: "Fractions" })]);
    expect(payload?.title).toBe("📋 Amine's week");
    expect(payload?.body).toBe(
      "45 min · 3 missions · 2-day streak. Worth revisiting together: Fractions.",
    );
  });

  it.each(["fr", "en", "ar"] as const)(
    "%s : aucun mot de reproche, même pour une semaine vide",
    (locale) => {
      const idle = enrichedParentDigestPayload(locale, [
        child({ learningMinutes: 0, missions: 0, streak: 0 }),
      ]);
      const weak = enrichedParentDigestPayload(locale, [child({ weakChapter: "X" })]);
      const text = `${idle?.title} ${idle?.body} ${weak?.body}`.toLowerCase();
      for (const word of ["échec", "échou", "raté", "abandon", "fail", "lazy", "فشل", "رسب"]) {
        expect(text).not.toContain(word);
      }
    },
  );

  it("ar : le pluriel suit la grammaire (1, 2, 3-10, 11+)", () => {
    const body = (missions: number, streak: number) =>
      enrichedParentDigestPayload("ar", [child({ learningMinutes: 0, missions, streak })])?.body;
    expect(body(1, 1)).toBe("مهمّة واحدة · سلسلة: يوم واحد.");
    expect(body(2, 2)).toBe("مهمّتان · سلسلة: يومان.");
    expect(body(5, 7)).toBe("5 مهمّات · سلسلة: 7 أيّام.");
    expect(body(12, 30)).toBe("12 مهمّة · سلسلة: 30 يوما.");
  });

  it("sans prénom d'affichage, le message reste une phrase", () => {
    const payload = enrichedParentDigestPayload("fr", [child({ displayName: "  " })]);
    expect(payload?.title).toBe("📋 La semaine de votre enfant");
  });

  it("tronque un prénom ou un titre démesuré — le message tient sur un écran verrouillé", () => {
    const payload = enrichedParentDigestPayload("fr", [
      child({ displayName: "A".repeat(80), weakChapter: "C".repeat(200) }),
    ]);
    expect(payload?.title.length).toBeLessThan(50);
    expect(payload?.body.length).toBeLessThan(160);
    expect(payload?.body).toContain("…");
  });

  it("fratrie : une ligne par enfant, sans chapitre, l'inactif dit sans reproche", () => {
    const payload = enrichedParentDigestPayload("fr", [
      child({ weakChapter: "Les fractions" }),
      child({ displayName: "Besma", learningMinutes: 0, missions: 0, streak: 0 }),
    ]);
    expect(payload?.title).toBe("📋 La semaine de vos enfants");
    expect(payload?.body).toBe("Amine : 45 min, 3 missions · Besma : pas d'activité cette semaine");
  });

  it("fratrie nombreuse : quatre lignes au plus, puis une ellipse", () => {
    const payload = enrichedParentDigestPayload(
      "en",
      Array.from({ length: 6 }, (_, i) => child({ displayName: `K${i}` })),
    );
    expect(payload?.body.match(/K\d/g)).toHaveLength(4);
    expect(payload?.body.endsWith(" · …")).toBe(true);
  });
});
