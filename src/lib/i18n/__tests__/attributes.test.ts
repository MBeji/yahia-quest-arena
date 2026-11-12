// @vitest-environment node
import { describe, expect, it } from "vitest";
import { attributeLabel } from "../attributes";
import { fr } from "../fr";
import { en } from "../en";
import { ar } from "../ar";

/**
 * « Force / Sagesse » restaient en français dans l'interface arabe (audit de première
 * visite, 2026-11-12) : l'attribut d'une matière vient du contenu, écrit en français.
 */
describe("attributeLabel", () => {
  it("traduit les attributs connus dans la langue de l'interface", () => {
    expect(attributeLabel(ar, "Force")).toBe("القوة");
    expect(attributeLabel(ar, "Sagesse")).toBe("الحكمة");
    expect(attributeLabel(en, "Esprit")).toBe("Mind");
    expect(attributeLabel(fr, "Force")).toBe("Force");
  });

  it("reconnaît un attribut accentué ou en autre casse", () => {
    expect(attributeLabel(en, "Agilité")).toBe("Agility");
    expect(attributeLabel(ar, "LOGIQUE")).toBe("المنطق");
  });

  it("laisse tel quel un attribut que le catalogue ne connaît pas", () => {
    expect(attributeLabel(ar, "Sciences")).toBe("Sciences");
    expect(attributeLabel(ar, "label")).toBe("label");
    expect(attributeLabel(ar, "")).toBe("");
  });
});
