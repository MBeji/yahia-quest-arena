import { describe, it, expect } from "vitest";
import {
  auditOptionReference,
  auditQuestion,
  optionReferences,
  OPTION_REFERENCE_LEVEL,
  type QAQuestion,
} from "../../../../scripts/content/qa-checks.ts";

// Le module a son propre fichier source (`scripts/content/qa-option-reference.ts`) : ses
// tests ont le leur. Ils vivaient dans `qa-checks.test.ts`, qu'ils poussaient au-dessus du
// plafond de 750 lignes — un fichier de tests qui grossit sans se scinder finit par n'être
// plus relu, et la règle qu'il garde est la plus longuement documentée du gate contenu.
const base = (over: Partial<QAQuestion>): QAQuestion => ({
  prompt: "Question ?",
  options: [
    { id: "a", text: "Alpha" },
    { id: "b", text: "Beta" },
    { id: "c", text: "Gamma" },
    { id: "d", text: "Delta" },
  ],
  correctOption: "a",
  explanation: "Une explication suffisamment longue pour passer le seuil de brièveté.",
  ...over,
});

describe("auditOptionReference — une option ne se désigne pas par sa lettre ni son rang", () => {
  const hits = (s: string) => optionReferences(s);

  it("attrape le nom d'option suivi d'une lettre, nu ou entre délimiteurs", () => {
    expect(hits("La réponse b se trompe de signe.")).toEqual(["réponse b"]);
    expect(hits("L'option (c) ne dérive pas −2x.")).toEqual(["option (c)"]);
    expect(hits("Only option D keeps the auxiliary.")).toEqual(["option D"]);
    expect(hits("L'option « d » garde la constante.")).toEqual(["option « d »"]);
    expect(hits("الخيار (b) يناقض النصّ صراحةً.")).toEqual(["الخيار (b)"]);
    expect(hits("الجواب أ نتيجة لا شعور قلبيّ.")).toEqual(["الجواب أ"]);
  });

  it("attrape la lettre entre parenthèses, mais seulement corroborée", () => {
    // Deux lettres différentes : personne n'aligne deux unités pour parler d'autre chose.
    expect(hits("Sentences (a), (b) and (c) are all correct.")).toEqual(["(a)", "(b)", "(c)"]);
    // Corroborée par une option nommée en toutes lettres.
    expect(hits("L'option b oublie le signe, et (c) divise les dérivées.")).toEqual([
      "option b",
      "(c)",
    ]);
    // Isolée, elle reste ambiguë : l'ampère (A), la droite (d), la brique (B).
    expect(hits("L'intensité s'exprime en ampère (A).")).toEqual([]);
    expect(hits("A′ est sur le même perpendiculaire à (d), à égale distance de (d).")).toEqual([]);
  });

  it("laisse l'énoncé étiqueter ses propres cas (A) … (D) sans crier au loup", () => {
    const prompt = "Quatre cas : (A) une roche gelée. (B) un plateau. (C) une côte. (D) une dune.";
    const explanation =
      "Le gel donne (A) ; l'amplitude thermique (B) ; les vagues (C) ; le vent (D).";
    expect(optionReferences(explanation, prompt)).toEqual([]);
    // Sans l'énoncé pour les expliquer, les mêmes lettres restent suspectes.
    expect(optionReferences(explanation)).toHaveLength(4);
  });

  it("laisse l'énoncé nommer ses figures par une analogie « A est à B », lettres NUES", () => {
    // Le patron le plus courant du raisonnement analogique. Les lettres y désignent
    // les FIGURES de l'énoncé, que `shuffleOptions` ne mélange pas — mais l'énoncé
    // les écrit nues là où l'explication les parenthèse, et cette asymétrie de FORME
    // suffisait à faire crier la garde (#945). Les trois langues du corpus :
    const cas = [
      [
        "A est à B ce que C est à ? — observe la transformation entre les deux premières figures.",
        "Le triangle plein vers la droite (A) devient un triangle vers le bas (B) : un quart de tour.",
      ],
      [
        "A is to B as C is to ? — observe the transformation between the first two figures.",
        "The solid triangle pointing right (A) becomes a triangle pointing down (B).",
      ],
      [
        "نسبة A إلى B كنسبة C إلى ؟ — لاحظ التحويل.",
        "المثلث الممتلئ (A) يصير مثلثًا متجهًا نحو الأسفل (B).",
      ],
    ] as const;
    for (const [prompt, explanation] of cas) {
      expect(optionReferences(explanation, prompt)).toEqual([]);
      // Contrôle négatif, le même que pour les cas parenthésés : sans l'analogie
      // dans l'énoncé, la garde voit encore les deux lettres.
      expect(optionReferences(explanation)).toEqual(["(A)", "(B)"]);
    }
  });

  it("n'excuse QUE la lettre encadrée par le connecteur d'analogie", () => {
    // Une majuscule nue est plus ambiguë qu'une lettre parenthésée : un énoncé qui
    // se contente d'en semer ne déclare rien, et l'explication reste fautive.
    const explanation = "L'option (a) oublie le signe et (b) inverse le produit.";
    expect(optionReferences(explanation, "Soit A un point du plan et B son image.")).toHaveLength(
      2,
    );
    // `D` n'est pas dans l'analogie : il reste une option désignée par sa lettre —
    // ici corroborée par le nom d'option, la règle FORTE. Une parenthèse `(d)` restée
    // seule après le filtrage ne compterait pas : la règle faible exige toujours DEUX
    // lettres non déclarées, ou une règle forte à côté.
    expect(
      optionReferences("L'option (d) translate le tracé (a).", "A est à B ce que C est à ?"),
    ).toEqual(["option (d)"]);
  });

  it("ne prend pas une dérivée ni une application pour une option", () => {
    // Les SIX dernières questions de la campagne « options par lettre » (privé#260) —
    // `math-bac-math`, verbatim. Aucune réécriture ne pouvait les corriger : elles
    // étaient justes, c'est la garde qui lisait mal. Deux caractères manquaient à son
    // lookbehind, la PRIME et la parenthèse fermante.
    expect(hits("La formule est (f⁻¹)′(b) = 1/f′(a) avec b = f(a).")).toEqual([]);
    expect(hits("L'image de B serait B ↦ r′(B) = (√2/2 ; −√2/2).")).toEqual([]);
    expect(hits("L'image de A par f est A ↦ r(A) = A ↦ S_(AC)(A) = A ↦ (1 ; 0).")).toEqual([]);
    expect(hits("B ↦ t_(BA⃗)(B) = A ↦ S_(AC)(A) compose les deux.")).toEqual([]);
    // La parenthèse n'est écartée que COLLÉE : un espace la sépare d'une étiquette.
    expect(hits("L'option b oublie le signe (voir plus haut) (c) aussi.")).toEqual([
      "option b",
      "(c)",
    ]);
  });

  it("ne prend pas la « seconde proposition » de la grammaire pour une option", () => {
    // En grammaire française, « proposition » désigne d'abord la proposition de la
    // PHRASE analysée. Les six occurrences de fin de campagne étaient toutes de cette
    // nature, dans les quatre `french-2eme-sec-*`, sur le chapitre « antithèse,
    // opposition, concession » — là où l'on parle de propositions par métier.
    expect(
      hits(
        "« si bien que » est une locution conjonctive de subordination : la seconde " +
          "proposition dépend syntaxiquement de la première.",
      ),
    ).toEqual([]);
    // Mais la règle n'est pas retirée : corroborée par une règle FORTE, elle compte.
    expect(hits("L'option b inverse le lien, et la seconde proposition oublie le signe.")).toEqual([
      "option b",
      "seconde proposition",
    ]);
    // Deux faibles ne se corroborent pas l'une l'autre : la parenthèse nue isolée ne
    // relève pas le rang, et le rang ne relève pas la parenthèse.
    expect(hits("La seconde proposition et (b) restent possibles.")).toEqual([]);
    // Et le RANG seul est équivoque, pas le nom : « la proposition (b) » nomme bien
    // une option, et reste un défaut.
    expect(hits("La proposition (c) confond les deux formules.")).toEqual(["proposition (c)"]);
  });

  it("attrape le rang, dans les deux ordres et dans les trois langues", () => {
    expect(hits("La dernière réponse confond composée et bissectrice.")).toEqual([
      "dernière réponse",
    ]);
    expect(hits("Et la troisième option vérifie bien f(0) = 0.")).toEqual(["troisième option"]);
    expect(hits("The first option adds a wrong to after will.")).toEqual(["first option"]);
    expect(hits("La réponse n° 2 additionne les degrés.")).toEqual(["réponse n° 2"]);
    expect(hits("الخيار الأخير يخلط المضارع بالماضي.")).toEqual(["الخيار الأخير"]);
  });

  it("laisse passer le bon patron : l'explication cite la VALEUR de l'option", () => {
    expect(hits("La réponse −25 vient d'une erreur de signe.")).toEqual([]);
    expect(hits("3 et 10 respecte le produit mais pas la somme.")).toEqual([]);
    // Une valeur numérique n'est pas un rang : `réponse 4` désigne la réponse « 4 ».
    expect(hits("La réponse 4 donne le coefficient dominant.")).toEqual([]);
    expect(hits("La réponse 1/16 oublie le facteur n = 5.")).toEqual([]);
  });

  it("ne prend pas une variable mathématique pour une option", () => {
    // La lettre est suivie d'une relation : c'est la valeur de l'option, citée.
    expect(hits("La réponse « b = −5 et c = 0 » place −5 au mauvais endroit.")).toEqual([]);
    expect(hits("Le choix D = 3 se trompe de rapport.")).toEqual([]);
    // Application de fonction et radicande d'un radical.
    expect(hits("On calcule f(a) puis f(b) pour conclure.")).toEqual([]);
    expect(hits("Le piège : √(a) + √(b) ≠ √(a+b).")).toEqual([]);
  });

  it("ne prend pas « la réponse de … » ni l'auxiliaire avoir pour une lettre", () => {
    expect(hits("La réponse de Marie est incomplète.")).toEqual([]);
    expect(hits("La réponse d'un élève pressé.")).toEqual([]);
    expect(hits("L'option a été retenue par le jury.")).toEqual([]);
  });

  it("ne prend pas le verbe anglais « answers » + l'article « a » pour une option", () => {
    // `answers` est plus souvent un verbe qu'un nom pluriel, et `a` l'article indéfini :
    // la prose anglaise ordinaire déclenchait la règle. Cas réels du corpus (2026-08-31).
    expect(hits("An opposite answers a meaning, never a word.")).toEqual([]);
    expect(hits("The other pair answers a different question altogether.")).toEqual([]);
    expect(hits("A price list answers a question about money.")).toEqual([]);
    // L'article ouvre aussi bien une citation qu'un nom.
    expect(hits('"It is behind" answers a "where" question.')).toEqual([]);
    // La garde ne doit pas fuir sur un mot qui FINIT par un déterminant.
    expect(hits("The crowd breathe answers a doubt.")).toEqual([]);
  });

  it("garde le nom anglais « answer(s) » quand la lettre est bien étiquetée", () => {
    // Le singulier n'est jamais ambigu : la garde ne le touche pas.
    expect(hits("the answer b is wrong")).toEqual(["answer b"]);
    expect(hits("Answer a is wrong.")).toEqual(["Answer a"]);
    // Au pluriel, la lettre doit être étiquetée : un déterminant devant le nom, un
    // délimiteur, ou une coordination qui la laisse fermer le groupe nominal.
    expect(hits("The answers a and c are both wrong.")).toEqual(["answers a"]);
    expect(hits("Answers a and c reverse the relationship.")).toEqual(["Answers a"]);
    expect(hits("Answers a, b and d repeat the stem.")).toEqual(["Answers a"]);
    expect(hits("answers (a) drops the article")).toEqual(["answers (a)"]);
    // Les autres noms d'option gardent leur lettre `a` : « option a » est bien réel.
    expect(hits("Option a keeps the -s on visits.")).toEqual(["Option a"]);
    expect(hits("Options a and c reverse the relationship.")).toEqual(["Options a"]);
  });

  it("remonte un seul flag par question, au niveau documenté", () => {
    const flags = auditOptionReference(
      { prompt: "Question ?", explanation: "La réponse b oublie le signe ; l’option (c) aussi." },
      "w",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0].level).toBe(OPTION_REFERENCE_LEVEL);
    expect(flags[0].msg).toContain('"réponse b"');
    expect(flags[0].msg).toContain('"option (c)"');
  });

  it("remonte depuis auditQuestion, sur l'explication d'un QCM", () => {
    const flags = auditQuestion(
      base({ explanation: "La dernière réponse intervertit la somme et le produit du trinôme." }),
      "w",
    );
    expect(
      flags.some((f) => f.level === OPTION_REFERENCE_LEVEL && /designates an option/.test(f.msg)),
    ).toBe(true);
  });
});
