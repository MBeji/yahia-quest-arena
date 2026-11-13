import { describe, expect, it } from "vitest";
import { arInvite as ar } from "@/lib/i18n/invite/ar";
import { enInvite as en } from "@/lib/i18n/invite/en";
import { frInvite as fr } from "@/lib/i18n/invite/fr";
import { consumeEntrySource, stripEntrySource } from "../entry-source";
import { parentInviteText, parentInviteUrl } from "../parent-invite";

/**
 * Étude 40, lot 5 — « INVITER MON PARENT » (R-19) : le message, son lien, dans les trois langues ;
 * et ce que devient ce lien à l'arrivée (`src` retiré, `code` gardé).
 */
const CODE = "1111-1111-1111-4111-8111-1111-1111-1111";
const LINK = `https://www.na9ranal3ab.tn/suivi?code=${CODE}&src=share`;

describe("R-19 — le lien du bilan", () => {
  it("⭐ `/suivi?code=…&src=share`, absolu, sur l'hôte canonique", () => {
    expect(parentInviteUrl(CODE)).toBe(LINK);
  });

  it("un code n'est jamais interprété comme un morceau d'adresse", () => {
    const url = new URL(parentInviteUrl("AB&src=pwa#x"));
    expect(url.searchParams.get("code")).toBe("AB&src=pwa#x");
    expect(url.searchParams.get("src")).toBe("share");
    expect(url.hash).toBe("");
  });
});

describe("R-19 — le message, dans les trois langues", () => {
  it("⭐ français : le texte de l'étude, mot pour mot", () => {
    expect(parentInviteText(fr.text, CODE)).toBe(
      `👋 Je révise sur Na9ra Nal3ab. Tu peux suivre mon travail ici, sans compte : ${LINK}`,
    );
  });

  it.each([
    ["fr", fr],
    ["en", en],
    ["ar", ar],
  ] as const)("%s — une phrase, puis le lien en fin de message", (_locale, catalog) => {
    const template = catalog.text;
    expect(template.match(/\{url\}/g)).toHaveLength(1);
    const text = parentInviteText(template, CODE);
    expect(text.endsWith(LINK)).toBe(true);
    expect(text.startsWith("👋 ")).toBe(true);
    expect(text).not.toContain("{");
  });

  it.each([
    ["fr", fr],
    ["en", en],
    ["ar", ar],
  ] as const)("%s — R-19 : l'aide redit que le lien ouvre le bilan", (_locale, catalog) => {
    expect(catalog.hint.length).toBeGreaterThan(20);
    expect(catalog.cta.length).toBeGreaterThan(0);
  });

  it.each([
    ["fr", fr],
    ["en", en],
    ["ar", ar],
  ] as const)("%s — R-21 : ni argent, ni urgence, ni rareté", (_locale, catalog) => {
    const s = catalog;
    const words = [s.cta, s.hint, s.text, s.copied, s.cardTitle, s.later].join(" ");
    expect(words).not.toMatch(
      /premium|abonnement|payant|subscription|\bpaid\b|\boffre|\boffer|dépêche|hurry|dernière chance|last chance|اشتراك|مدفوع|بريميوم/i,
    );
  });
});

describe("à l'arrivée — `?src=share` et `?code=` cohabitent", () => {
  const arrival = { pathname: "/suivi", search: `?code=${CODE}&src=share`, hash: "" };

  it("⭐ `src` part, `code` reste — tel quel", () => {
    expect(stripEntrySource(arrival)).toBe(`/suivi?code=${CODE}`);
  });

  it("⭐ l'entrée est comptée `share`, et l'adresse affichée garde le code", () => {
    let shown = "";
    const source = consumeEntrySource({
      location: arrival,
      history: {
        state: { key: "k" },
        replaceState: (_state, _unused, url) => {
          shown = String(url);
        },
      },
    });
    expect(source).toBe("share");
    expect(shown).toBe(`/suivi?code=${CODE}`);
  });
});
