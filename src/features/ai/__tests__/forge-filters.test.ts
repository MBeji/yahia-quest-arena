// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  candidateCount,
  filterCandidates,
  hasCatchAllOption,
  isPrimaryRank,
  normalizePrompt,
  shouldSampleVerify,
  violatesNotation,
  violatesVocabulary,
} from "../forge/filters";
import { FORGE_JSON_SCHEMA, forgedQuestionSchema, type ForgedQuestion } from "../forge/schema";
import { ageBand, buildForgeBlocks, buildSolveBlocks, stripKey } from "../forge/prompt";
import { AI_VERIFY_SAMPLE_RATE } from "@/shared/constants/ai";

/**
 * LES FILTRES DÉTERMINISTES de la Forge (§3.6) — « 0 token, aucune indulgence ».
 *
 * C'est la partie de la chaîne qui décide de la qualité sans rien dépenser, et
 * la seule qu'on puisse tester exhaustivement : chaque règle a ici le candidat
 * qui la casse.
 */

// Typé sur le schéma : les fonctions de filtre prennent un candidat DÉJÀ
// validé, et un objet littéral élargirait `id` en `string`.
const GOOD: ForgedQuestion = {
  prompt: "Quelle est la somme de 2 et 3 ?",
  options: [
    { id: "a", text: "4" },
    { id: "b", text: "5" },
    { id: "c", text: "6" },
    { id: "d", text: "23" },
  ],
  correctOption: "b",
  explanation: "2 + 3 = 5. L'option d colle les deux chiffres au lieu de les additionner.",
  difficulty: 2,
};

const ctx = { existingPrompts: [] as string[], gradeRank: 5 };

describe("le schéma — miroir du pipeline contenu, borné au QCM v1", () => {
  it("accepte un candidat conforme", () => {
    expect(forgedQuestionSchema.safeParse(GOOD).success).toBe(true);
  });

  it("refuse un nombre d'options différent de 4", () => {
    expect(
      forgedQuestionSchema.safeParse({ ...GOOD, options: GOOD.options.slice(0, 3) }).success,
    ).toBe(false);
  });

  it("refuse deux options portant le même id", () => {
    const clashed = [...GOOD.options.slice(0, 3), { id: "c", text: "autre" }];
    expect(forgedQuestionSchema.safeParse({ ...GOOD, options: clashed }).success).toBe(false);
  });

  it("refuse deux options au MÊME TEXTE — la question serait insoluble", () => {
    const dup = [...GOOD.options.slice(0, 3), { id: "d", text: "  5 " }];
    expect(forgedQuestionSchema.safeParse({ ...GOOD, options: dup }).success).toBe(false);
  });

  it("refuse une clé qui ne désigne aucune option connue", () => {
    expect(forgedQuestionSchema.safeParse({ ...GOOD, correctOption: "e" }).success).toBe(false);
  });

  it("refuse une explication trop courte — c'est ce que l'élève lit quand il se trompe", () => {
    // 10 caractères minimum : « oui », « c'est b » ou une chaîne vide
    // n'enseignent rien, et l'explication est la seule chose qu'un quiz forgé
    // apporte au-delà du score.
    expect(forgedQuestionSchema.safeParse({ ...GOOD, explanation: "" }).success).toBe(false);
    expect(forgedQuestionSchema.safeParse({ ...GOOD, explanation: "c'est b" }).success).toBe(false);
  });

  it("le JSON Schema envoyé au fournisseur ferme les objets", () => {
    // `additionalProperties: false` : sans lui, un fournisseur qui contraint
    // nativement la sortie laisse passer des champs qu'aucun filtre n'attend.
    expect(FORGE_JSON_SCHEMA).toMatchObject({ additionalProperties: false });
    const items = (FORGE_JSON_SCHEMA.properties as Record<string, { items: unknown }>).items;
    expect(items.items).toMatchObject({ additionalProperties: false });
  });
});

describe("la notation (math-and-notation.md)", () => {
  it("refuse les chiffres non occidentaux, y compris en arabe", () => {
    expect(violatesNotation({ ...GOOD, prompt: "كم يساوي ٢ + ٣ ؟" })).toBe(true);
  });

  it("refuse le LaTeX — le lecteur ne le rend pas", () => {
    expect(violatesNotation({ ...GOOD, prompt: "Calcule \\frac{1}{2} + 1" })).toBe(true);
    expect(violatesNotation({ ...GOOD, explanation: "On a $x^2 = 4$ donc x = 2." })).toBe(true);
  });

  it("refuse toute URL (RISK-6 : une adresse inventée est un piège)", () => {
    expect(violatesNotation({ ...GOOD, explanation: "Voir https://exemple.tn/cours" })).toBe(true);
    expect(violatesNotation({ ...GOOD, explanation: "Voir www.exemple.tn" })).toBe(true);
  });

  it("laisse passer une question arabe en chiffres occidentaux", () => {
    expect(violatesNotation({ ...GOOD, prompt: "كم يساوي 2 + 3 ؟" })).toBe(false);
  });
});

describe("les options fourre-tout", () => {
  it("refuse « aucune des réponses » et « toutes les réponses », en trois langues", () => {
    for (const text of [
      "Aucune de ces réponses",
      "Toutes les réponses",
      "None of the above",
      "لا شيء مما سبق",
    ]) {
      const candidate: ForgedQuestion = {
        ...GOOD,
        options: [...GOOD.options.slice(0, 3), { id: "d" as const, text }],
      };
      expect(hasCatchAllOption(candidate), text).toBe(true);
    }
  });

  it("laisse passer un distracteur ordinaire", () => {
    expect(hasCatchAllOption(GOOD)).toBe(false);
  });
});

describe("le vocabulaire de la bande d'âge", () => {
  it("refuse une notion de lycée dans un énoncé de primaire", () => {
    expect(violatesVocabulary({ ...GOOD, prompt: "Calcule la dérivée de x²" }, 3)).toBe(true);
  });

  it("l'accepte au collège et au-delà — la règle porte sur l'ÂGE, pas sur le mot", () => {
    expect(violatesVocabulary({ ...GOOD, prompt: "Calcule la dérivée de x²" }, 12)).toBe(false);
  });

  it("un niveau inconnu n'est pas traité comme du primaire ici", () => {
    // Contrairement à R-2a (où l'inconnu vaut mineur, parce qu'il s'agit
    // d'argent), un niveau inconnu ne doit pas amputer le vocabulaire : la
    // conséquence serait un rebut, pas une protection.
    expect(violatesVocabulary({ ...GOOD, prompt: "Calcule la dérivée" }, null)).toBe(false);
  });

  it("nomme correctement le cycle primaire", () => {
    expect(isPrimaryRank(6)).toBe(true);
    expect(isPrimaryRank(7)).toBe(false);
    expect(isPrimaryRank(null)).toBe(false);
  });
});

describe("le doublon — « référence de style, JAMAIS à recopier »", () => {
  it("normalise casse, accents, ponctuation et espaces", () => {
    expect(normalizePrompt("Quelle est la SOMME de 2 et 3 ?")).toBe(
      normalizePrompt("quelle  est   la somme de 2 et 3"),
    );
  });

  it("normalise aussi les diacritiques arabes", () => {
    expect(normalizePrompt("كَمْ يساوي 2")).toBe(normalizePrompt("كم يساوي 2"));
  });

  it("rejette un candidat qui recopie une question du chapitre", () => {
    const { kept, rejected } = filterCandidates([GOOD], {
      existingPrompts: ["quelle est la somme de 2 et 3"],
      gradeRank: 5,
    });
    expect(kept).toHaveLength(0);
    expect(rejected[0].reason).toBe("duplicate_catalogue");
  });

  it("rejette le second de deux candidats identiques du MÊME lot", () => {
    const { kept, rejected } = filterCandidates([GOOD, { ...GOOD }], ctx);
    expect(kept).toHaveLength(1);
    expect(rejected[0].reason).toBe("duplicate_candidate");
  });
});

describe("la chaîne de filtres, bout à bout", () => {
  it("garde les bons, compte les mauvais, et nomme chaque motif", () => {
    const candidates = [
      GOOD,
      { ...GOOD, prompt: "Combien font 4 et 4 ?", options: GOOD.options.slice(0, 2) }, // schéma
      { ...GOOD, prompt: "Calcule \\frac{1}{2} de 10" }, // notation
      {
        ...GOOD,
        prompt: "Quelle est la moitié de 10 ?",
        options: [
          ...GOOD.options.slice(0, 3),
          { id: "d" as const, text: "Aucune de ces réponses" },
        ],
      }, // fourre-tout
      { ...GOOD, prompt: "Quelle est la dérivée de x ?" }, // vocabulaire (primaire)
    ];

    const { kept, rejected } = filterCandidates(candidates, ctx);
    expect(kept).toHaveLength(1);
    expect(rejected.map((r) => r.reason)).toEqual([
      "schema",
      "notation",
      "none_of_the_above",
      "vocabulary",
    ]);
  });

  it("un lot entièrement mauvais ne lève pas — il rend zéro gardé", () => {
    const { kept, rejected } = filterCandidates([{}, null, "texte"], ctx);
    expect(kept).toHaveLength(0);
    expect(rejected).toHaveLength(3);
  });
});

describe("les bornes de la Forge (R-18)", () => {
  it("demande N+2 candidats, jamais plus de 12", () => {
    expect(candidateCount(5)).toBe(7);
    expect(candidateCount(10)).toBe(12);
  });
});

describe("R-18bis.3 — l'échantillon de 20 % quand la vérification est coupée", () => {
  it("vérifie une question sur cinq, de façon DÉTERMINISTE", () => {
    const verified = Array.from({ length: 10 }, (_, i) =>
      shouldSampleVerify(i, AI_VERIFY_SAMPLE_RATE),
    );
    // Deux sur dix : c'est « une question sur cinq », et c'est reproductible —
    // un tirage aléatoire rendrait le taux de rebut inexploitable sur les
    // petits volumes, donc R-19 muette.
    expect(verified.filter(Boolean)).toHaveLength(2);
    expect(verified[0]).toBe(true);
    expect(verified[5]).toBe(true);
  });

  it("un taux nul ne vérifie rien, un taux plein vérifie tout", () => {
    expect(shouldSampleVerify(3, 0)).toBe(false);
    expect(shouldSampleVerify(3, 1)).toBe(true);
  });
});

describe("Q-7 — la double résolution ne voit PAS la clé", () => {
  it("`stripKey` retire la clé ET l'explication", () => {
    const stripped = stripKey(GOOD);
    expect(Object.keys(stripped).sort()).toEqual(["options", "prompt"]);
    expect(JSON.stringify(stripped)).not.toContain("2 + 3 = 5");
  });

  it("le bloc envoyé au second appel ne contient ni la clé ni l'explication", () => {
    const [block] = buildSolveBlocks(stripKey(GOOD));
    expect(block.text).toContain("Quelle est la somme");
    expect(block.text).toContain("b) 5");
    // Si la clé passait, le second appel approuverait tout et la garantie de
    // Q-7 tomberait sans que rien ne rougisse.
    expect(block.text).not.toContain("correctOption");
    expect(block.text).not.toContain("2 + 3 = 5");
  });
});

describe("le prompt de génération", () => {
  const context = {
    chapterTitle: "Les fractions",
    lessonExcerpt: "Une fraction représente une part.",
    samplePrompts: ["Quelle fraction vaut un demi ?"],
    lang: "fr" as const,
    gradeRank: 5,
  };

  it("pose la césure de cache après le contexte STABLE (é11 §3.4)", () => {
    const blocks = buildForgeBlocks(context, { count: 7, difficulty: 2 });
    const boundary = blocks.findIndex((b) => b.cacheBoundary);
    // Le bloc volatil (la demande) vient APRÈS : sinon le préfixe change à
    // chaque appel et le cache ne mord jamais.
    expect(boundary).toBe(blocks.length - 2);
    expect(blocks.at(-1)?.label).toBe("demande");
  });

  it("dit au modèle de ne PAS recopier les exemples", () => {
    const blocks = buildForgeBlocks(context, { count: 7, difficulty: 2 });
    expect(blocks.find((b) => b.label === "style_de_reference")?.text).toContain(
      "Quelle fraction vaut un demi",
    );
  });

  it("tient debout sans cours ni exemple — un chapitre neuf n'est pas une panne", () => {
    const blocks = buildForgeBlocks(
      { ...context, lessonExcerpt: "", samplePrompts: [] },
      { count: 5, difficulty: 1 },
    );
    expect(blocks[0].text).toContain("Les fractions");
    expect(blocks[1].text).toContain("aucun exemple");
  });

  it("envoie une BANDE d'âge, jamais l'âge réel de l'élève (é11 R-14)", () => {
    expect(ageBand(3)).toContain("primaire");
    expect(ageBand(8)).toContain("collège");
    expect(ageBand(13)).toContain("secondaire");
    // Niveau inconnu : la bande médiane, pas une absence — le modèle a besoin
    // d'un registre, et « aucun » produirait du contenu hors sol.
    expect(ageBand(null)).toContain("collège");
  });
});
