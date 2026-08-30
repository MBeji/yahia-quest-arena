// @vitest-environment node
import { describe, expect, it } from "vitest";
import { buildDisplayChoice } from "@/features/quest/question-maps";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import type { DisplayOption } from "@/shared/lib/question-utils";

/**
 * La mise en forme d'une réponse à l'écran, branche par branche. Elle vivait
 * dans le lecteur de mission, hors couverture ; l'extraction de
 * `question-maps.ts` l'y fait entrer, et ce fichier en profite.
 *
 * Ce qui compte ici, ce sont les DEUX pièges : un type qui n'a pas d'options
 * (rappel, réponse courte) ne doit jamais tomber dans la branche CSV, et un id
 * d'option mélangé ne doit jamais être montré tel quel quand on peut rendre son
 * texte.
 */
const OPTIONS: DisplayOption[] = [
  { id: "o1", text: "Paris", displayId: "A" },
  { id: "o2", text: "Lyon", displayId: "B" },
  { id: "o3", text: "<svg>…</svg>", displayId: "C" },
];

function make(overrides: { isRecall?: boolean; type?: string } = {}) {
  return buildDisplayChoice({
    typeById: new Map([["q1", overrides.type ?? "mcq"]]),
    optionsById: new Map([["q1", OPTIONS]]),
    isRecall: overrides.isRecall ?? false,
  });
}

describe("buildDisplayChoice", () => {
  it("rend un tiret pour une absence de réponse", () => {
    expect(make()("q1", "")).toBe("-");
  });

  it("montre la LETTRE de l'option pour un QCM", () => {
    // L'élève reconnaît « B », pas l'id mélangé « o2 ».
    expect(make()("q1", "o2")).toBe("B");
  });

  it("laisse une réponse courte telle quelle, isolée en LTR", () => {
    // ⚠️ Le piège : « 3,14 » contient une virgule. Sans le court-circuit sur le
    // type, il partirait dans la branche CSV et s'afficherait découpé.
    expect(make({ type: "short_answer" })("q1", "3,14")).toBe(isolateLtrRuns("3,14"));
  });

  it("laisse une réponse de Rappel telle quelle, isolée en LTR", () => {
    expect(make({ isRecall: true })("q1", "la Seine, à Paris")).toBe(
      isolateLtrRuns("la Seine, à Paris"),
    );
  });

  it("traduit un ordonnancement CSV en textes d'options", () => {
    expect(make()("q1", "o2,o1")).toBe(isolateLtrRuns("Lyon · Paris"));
  });

  it("traduit un appariement en paires lisibles", () => {
    expect(make()("q1", "o1:o2")).toBe(isolateLtrRuns("Paris ⇢ Lyon"));
  });

  it("retombe sur l'id quand le texte de l'option est du balisage", () => {
    // Coller un SVG entier dans la correction ne dirait rien à personne.
    expect(make()("q1", "o1,o3")).toBe(isolateLtrRuns("Paris · o3"));
  });

  it("rend la réponse brute quand aucune option ne correspond", () => {
    // Valeur numérique, sentinelle d'abandon : rien à traduire.
    expect(make()("q1", "42")).toBe(isolateLtrRuns("42"));
  });

  it("ne casse pas sur une question dont on n'a pas les options", () => {
    expect(make()("inconnue", "42")).toBe(isolateLtrRuns("42"));
  });
});
