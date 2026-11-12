import { describe, expect, it } from "vitest";
import { forwardArrow, plus, signedNumber } from "@/shared/lib/bidi";

/**
 * Le signe reste solidaire de ses chiffres en RTL (issue #1228,
 * `rtl-signed-numbers`). Mesuré dans Chromium le 2026-11-12, paragraphe `dir="rtl"` :
 * « +50 XP », « +50 قطعة », « -3 » et « حتى +50 نقطة » placent le signe À DROITE des
 * chiffres ; précédés de U+200E, tous le placent à gauche. jsdom ne fait pas de
 * mise en page bidi : ce test tient le contrat de la chaîne, pas le rendu.
 */
const LRM = "‎";

describe("plus", () => {
  it("pose la marque gauche-à-droite devant le signe", () => {
    expect(plus(50)).toBe(`${LRM}+50`);
    expect(plus("...")).toBe(`${LRM}+...`);
  });

  it("reste lisible tel quel une fois la marque (invisible) retirée", () => {
    expect(plus(12).replace(LRM, "")).toBe("+12");
  });
});

describe("signedNumber", () => {
  it("signe les écarts positifs et négatifs, marque comprise", () => {
    expect(signedNumber(5)).toBe(`${LRM}+5`);
    expect(signedNumber(-3)).toBe(`${LRM}-3`);
  });

  it("laisse zéro sans signe ni marque", () => {
    expect(signedNumber(0)).toBe("0");
  });
});

describe("forwardArrow", () => {
  it("pointe dans le sens de lecture", () => {
    expect(forwardArrow("ltr")).toBe("→");
    expect(forwardArrow("rtl")).toBe("←");
  });
});
