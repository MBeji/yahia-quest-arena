// @vitest-environment node
import { describe, it, expect } from "vitest";
import { auditPositionalOptionRef } from "../../../../scripts/content/qa-option-refs.ts";

/**
 * Le renvoi positionnel. Ce que ces tests protègent : (1) une lettre d'option dans une
 * explication est signalée, en latin comme en arabe, et (2) la notation qui lui ressemble —
 * un argument de fonction, un point, une droite — ne l'est pas.
 */
const opts = ["a", "b", "c", "d"].map((id) => ({ id }));
const flag = (explanation: string, spatial = false) =>
  auditPositionalOptionRef({ explanation, options: opts }, "s/c/quiz · Q1", spatial);

describe("auditPositionalOptionRef — les options sont mélangées à l'affichage", () => {
  it.each([
    "الخطأ الشائع (b): نسيان الحدّ الأوسط.",
    "أمّا (ج) فألحق التاء بالعدد مع المؤنّث.",
    "Le piège courant est (b) : la locution est figée.",
    "contrairement à la réponse d.",
    "soit l'option c.",
  ])("signale « %s »", (e) => {
    expect(flag(e)).toHaveLength(1);
    expect(flag(e)[0].level).toBe("warn");
  });

  it.each([
    "La tangente a pour équation y = f′(a)(x − a) + f(a).",
    "arg(a) ≡ π/4 [2π].",
    "Le point d'arrivée du premier vecteur (B) est le départ du second.",
    "la droite (d) est perpendiculaire à (Δ).",
    "Cite «أجمِلْ بالصبرِ!» plutôt que sa lettre.",
  ])("ne signale pas la notation « %s »", (e) => {
    expect(flag(e)).toEqual([]);
  });

  it("exempte (d) d'un chapitre spatial, où c'est une droite", () => {
    expect(flag("المستقيمان متوازيان: (d) ∥ (d′).", true)).toEqual([]);
    expect(flag("الخطأ الشائع (b): الخلط بين الزاويتين.", true)).toHaveLength(1);
  });

  it("ignore une lettre qui n'est l'identifiant d'aucune option", () => {
    expect(
      auditPositionalOptionRef(
        { explanation: "voir (c).", options: [{ id: "a" }, { id: "b" }] },
        "w",
        false,
      ),
    ).toEqual([]);
  });
});
