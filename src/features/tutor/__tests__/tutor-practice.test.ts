// @vitest-environment node
import { describe, expect, it } from "vitest";

import { decidePractice, type TutorPracticeFacts } from "../practice";

/**
 * Étude 11 lot 5 — la décision « sélection ou génération » (Q-8).
 *
 * Ce que ces tests gardent, ce n'est pas une branche de code : c'est une
 * DÉPENSE. La branche `forge` déclenche un appel de modèle, facturé, avec de
 * l'énergie prélevée à l'élève. Une inversion de condition ici ne casserait
 * aucun écran — elle ferait forger un quiz à chaque clic sur « Entraîne-moi »,
 * y compris quand le catalogue avait de quoi répondre. C'est le genre de bug
 * qui se découvre sur une facture.
 */

const base: TutorPracticeFacts = {
  needsGeneration: false,
  itemCount: 3,
  chapterId: "chap-1",
  forgeEnabled: true,
};

function decide(over: Partial<TutorPracticeFacts>) {
  return decidePractice({ ...base, ...over });
}

describe("le stock passe avant la génération (Q-8)", () => {
  it("joue les exercices réels dès que le SQL dit que le stock suffit", () => {
    // Le cas nominal, et le plus important : la Forge est ouverte, un chapitre
    // est connu — et on ne forge PAS, parce que le catalogue répond.
    expect(decide({ needsGeneration: false })).toEqual({ kind: "exercises", onTarget: true });
  });

  it("ne consulte MÊME PAS la Forge quand le stock suffit", () => {
    // Forge fermée, aucun chapitre : sans la priorité au stock, cette entrée
    // tomberait sur un aveu alors qu'il y a de quoi travailler.
    expect(decide({ needsGeneration: false, forgeEnabled: false, chapterId: null })).toEqual({
      kind: "exercises",
      onTarget: true,
    });
  });
});

describe("la génération, et ses deux conditions", () => {
  it("renvoie vers la Forge quand le stock manque, avec le chapitre pour scope", () => {
    expect(decide({ needsGeneration: true, itemCount: 0 })).toEqual({
      kind: "forge",
      chapterId: "chap-1",
    });
  });

  it("ne forge jamais sans chapitre — la Forge n'a pas de scope `tag`", () => {
    // `get_my_weaknesses.chapter_id` est nullable : une erreur sans chapitre
    // identifié est un cas RÉEL. Inventer un scope que la RPC refuserait
    // produirait une erreur serveur au lieu d'un état affichable.
    expect(decide({ needsGeneration: true, itemCount: 0, chapterId: null })).toEqual({
      kind: "none",
      reason: "no-chapter",
    });
  });

  it("ne forge jamais si la Forge n'est pas ouverte à cet élève", () => {
    // Sans accord parental, `callAi` refuserait de toute façon — mais l'écran
    // doit le savoir AVANT de promettre un quiz qui n'arrivera pas.
    expect(decide({ needsGeneration: true, itemCount: 0, forgeEnabled: false })).toEqual({
      kind: "none",
      reason: "no-material",
    });
  });
});

describe("on ne jette pas du matériel réel pour aller forger (R-15)", () => {
  it("joue le peu qu'il y a plutôt que rien, en l'annonçant comme non ciblé", () => {
    // Deux fraîches + un repli : le compte ne franchit pas le seuil, mais il y
    // a bel et bien trois choses à jouer. `onTarget: false` oblige l'écran à ne
    // pas promettre « sur ton erreur ».
    expect(decide({ needsGeneration: true, itemCount: 3, forgeEnabled: false })).toEqual({
      kind: "exercises",
      onTarget: false,
    });
  });

  it("préfère quand même la Forge quand elle est ouverte et le ciblage faible", () => {
    // L'ordre compte : à stock insuffisant, une question VRAIMENT sur l'erreur
    // vaut mieux qu'une question voisine — c'est tout l'objet de Q-8.
    expect(decide({ needsGeneration: true, itemCount: 2 })).toEqual({
      kind: "forge",
      chapterId: "chap-1",
    });
  });

  it("avoue plutôt que de renvoyer une liste vide", () => {
    expect(
      decide({ needsGeneration: true, itemCount: 0, forgeEnabled: false, chapterId: null }),
    ).toEqual({ kind: "none", reason: "no-chapter" });
  });
});

describe("la matrice complète : le seuil n'est JAMAIS recalculé côté client", () => {
  // Le fait d'entrée est un BOOLÉEN venu du SQL. Ces cas le prouvent en le
  // faisant varier seul : à faits identiques, c'est lui — et lui seul — qui
  // fait basculer la décision. Si un `>= 3` réapparaissait ici un jour, ces
  // deux lignes continueraient de passer et le bug serait invisible ; c'est
  // pourquoi le décompte n'est PAS un paramètre de `decidePractice`.
  it.each([
    [false, "exercises"],
    [true, "forge"],
  ] as const)("needsGeneration=%s ⇒ %s", (needsGeneration, kind) => {
    expect(decide({ needsGeneration, itemCount: 5 }).kind).toBe(kind);
  });
});
