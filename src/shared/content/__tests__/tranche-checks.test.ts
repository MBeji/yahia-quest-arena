// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  collectItems,
  freshRefs,
  jaccard,
  keyDistribution,
  longestKey,
  measureTranche,
  nearPairs,
  taskFrame,
  templateClusters,
  visibleText,
  type TrancheItem,
} from "../../../../scripts/content/tranche-checks.ts";
import type { LoadedSubject } from "../schema.ts";

/**
 * Les mesures de tranche (méthode § B2). Ce que ces tests protègent : (1) les
 * trois mesures de la méthode rendent le bon chiffre, (2) le cadre de tâche
 * survit à un changement de décor — c'est tout l'intérêt du signal gabarit —
 * et (3) aucun des signaux ne crie sur ce qui n'est pas un défaut (un item de
 * calcul court, deux figures différentes, un seul chapitre).
 */

const item = (over: Partial<TrancheItem> & Pick<TrancheItem, "ref">): TrancheItem => ({
  chapter: over.ref.split("/")[0],
  inTranche: true,
  type: "mcq",
  prompt: "Prompt",
  options: [],
  keyIndex: null,
  ...over,
});

const mcq = (ref: string, texts: string[], keyIndex: number, extra: Partial<TrancheItem> = {}) =>
  item({
    ref,
    options: texts.map((text, i) => ({ id: "abcdef"[i], text })),
    keyIndex,
    ...extra,
  });

describe("visibleText", () => {
  it("retire figures et balises, compacte les blancs", () => {
    expect(visibleText('a <svg viewBox="0 0 1 1"><line/></svg>  <b>b</b>')).toBe("a b");
  });
});

describe("longestKey — la fuite par la forme", () => {
  it("compte une clé strictement plus longue que tous les distracteurs", () => {
    const r = longestKey([
      mcq("c/quiz#1", ["court", "une réponse bien plus longue", "bref", "net"], 1),
      mcq("c/quiz#2", ["égal", "égal", "autre", "moins"], 0),
    ]);
    expect(r.longest).toEqual(["c/quiz#1"]);
    expect(r.measured).toBe(2);
    expect(r.rate).toBe(0.5);
    expect(r.chance).toBe(0.25);
    // deux items ne font pas un verdict : listés, pas condamnés
    expect(r.ok).toBe(true);
  });

  it("condamne au-delà du hasard sur un échantillon suffisant", () => {
    const leak = (i: number) =>
      mcq(`c/quiz#${i}`, ["non", "oui, parce que la règle le veut", "peut-être", "jamais"], 1);
    const fair = (i: number) => mcq(`c/quiz#${i}`, ["abc", "abcd", "ab", "a"], 0);
    expect(longestKey([...[1, 2, 3, 4].map(leak), ...[5, 6, 7, 8].map(fair)]).ok).toBe(false);
    expect(longestKey([leak(1), ...[2, 3, 4, 5, 6, 7, 8, 9].map(fair)]).ok).toBe(true);
  });

  it("une égalité de longueur n'est pas une fuite, et une figure ne compte pas", () => {
    const r = longestKey([
      mcq("c/quiz#1", ["abc", "abc", "ab", "a"], 0),
      mcq("c/quiz#2", ['<svg viewBox="0 0 9 9"><circle r="4"/></svg>', "longer", "x", "y"], 0),
    ]);
    expect(r.longest).toEqual([]);
    expect(r.ok).toBe(true);
  });

  it("ignore les types sans clé d'option", () => {
    expect(longestKey([item({ ref: "c/quiz#1", type: "numeric" })]).measured).toBe(0);
  });
});

describe("keyDistribution — un symptôme, pas une fuite", () => {
  const four = (k: number, n: string) => mcq(n, ["a", "b", "c", "d"], k);

  it("compte les positions sur les items à 4 options", () => {
    const r = keyDistribution([four(0, "c/q#1"), four(2, "c/q#2"), mcq("c/q#3", ["a", "b"], 1)]);
    expect(r.measured).toBe(2);
    expect(r.counts).toEqual([1, 0, 1, 0]);
    expect(r.ok).toBe(true); // trop peu d'items pour conclure
  });

  it("signale une clé toujours au même rang", () => {
    const r = keyDistribution(Array.from({ length: 12 }, (_, i) => four(0, `c/q#${i}`)));
    expect(r.ok).toBe(false);
  });

  it("accepte une distribution équilibrée", () => {
    const r = keyDistribution(Array.from({ length: 12 }, (_, i) => four(i % 4, `c/q#${i}`)));
    expect(r.ok).toBe(true);
  });
});

describe("nearPairs — les doublons littéraux", () => {
  it("jaccard", () => {
    expect(jaccard(new Set(["a", "b"]), new Set(["b", "c"]))).toBeCloseTo(1 / 3);
    expect(jaccard(new Set(), new Set())).toBe(0);
  });

  const prose = (ref: string, prompt: string, inTranche = true) =>
    mcq(ref, ["the shop", "the town", "his father", "the market"], 0, { prompt, inTranche });

  it("trouve une reformulation minimale, même inter-chapitres", () => {
    const pairs = nearPairs([
      prose("01-a/quiz#1", "Read the text again. What does the pronoun it refer to in line four?"),
      prose(
        "02-b/quiz#3",
        "Read the text again. What does the pronoun it refer to in line six?",
        false,
      ),
    ]);
    expect(pairs).toHaveLength(1);
    expect(pairs[0].interChapter).toBe(true);
  });

  it("ne compare pas deux chapitres publiés entre eux", () => {
    const p = "Read the text again. What does the pronoun it refer to in line four?";
    expect(nearPairs([prose("01-a/quiz#1", p, false), prose("02-b/quiz#1", p, false)])).toEqual([]);
  });

  it("un calcul court n'est proche que presque identique — les nombres comptent", () => {
    const calc = (ref: string, prompt: string, opts: string[]) => mcq(ref, opts, 0, { prompt });
    expect(
      nearPairs([
        calc("c/quiz#1", "ما ناتج 4/9 − 1/9؟", ["3/9", "5/9", "3/18", "4/9"]),
        calc("c/quiz#2", "ما ناتج 8/3 × 3؟", ["8", "24/9", "11/3", "1/8"]),
      ]),
    ).toEqual([]);
    expect(
      nearPairs([
        calc("c/quiz#1", "العددُ 0 مضاعفٌ لـ:", ["العدد 0 فقط", "كلّ الأعداد", "لا شيء"]),
        calc("c/quiz#2", "العددُ 0 مضاعفٌ لـ:", ["العدد 0 فقط", "كلّ الأعداد", "لا شيء"]),
      ]),
    ).toHaveLength(1);
  });

  it("deux figures différentes font deux questions", () => {
    const fig = (x: number) =>
      `ما نوعُ هذه الزاوية؟ <svg viewBox="0 0 9 9"><line x1="${x}"/></svg>`;
    const opts = ["حادّة", "قائمة", "منفرجة", "مستقيمة"];
    expect(
      nearPairs([
        mcq("c/q#1", opts, 0, { prompt: fig(1) }),
        mcq("c/q#2", opts, 1, { prompt: fig(2) }),
      ]),
    ).toEqual([]);
  });
});

describe("taskFrame — la forme de la tâche sans son décor", () => {
  it("retire passage cité, noms propres et nombres", () => {
    const a = taskFrame(
      'Read this passage. Sami has run a shop in Sfax for ten years and loves it. What does "it" refer to?',
    );
    const b = taskFrame(
      'Read this passage. Leila has taught at a school in Bizerte for 12 years and enjoys it. What does "it" refer to?',
    );
    expect(a).toEqual(["read", "this", "passage", "what", "does", "refer", "to"]);
    expect(b).toEqual(a);
  });

  it("garde tout l'énoncé quand il n'a que deux phrases", () => {
    expect(taskFrame("Complete the sentence. Choose one word.")).toEqual([
      "complete",
      "the",
      "sentence",
      "choose",
      "one",
      "word",
    ]);
  });
});

describe("templateClusters — le gabarit que l'auteur ne peut pas voir", () => {
  const passage = (ref: string, who: string, where: string, inTranche = true) =>
    item({
      ref,
      inTranche,
      prompt: `Read this passage carefully. ${who} has run a shop in ${where} for years. What does the pronoun "it" refer to in the passage?`,
    });

  it("regroupe le même cadre servi dans deux chapitres", () => {
    const clusters = templateClusters([
      passage("01-a/quiz#1", "Sami", "Sfax"),
      passage("03-c/quiz#2", "Leila", "Bizerte", false),
      item({
        ref: "02-b/quiz#1",
        prompt: "Choose the correct tense to complete this long sentence here.",
      }),
    ]);
    expect(clusters).toHaveLength(1);
    expect(clusters[0].refs).toEqual(["01-a/quiz#1", "03-c/quiz#2"]);
    expect(clusters[0].chapters).toEqual(["01-a", "03-c"]);
  });

  it("se tait dans un seul chapitre, hors tranche, ou entre types différents", () => {
    expect(
      templateClusters([passage("01-a/q#1", "Sami", "Sfax"), passage("01-a/q#2", "Ali", "Tunis")]),
    ).toEqual([]);
    expect(
      templateClusters([
        passage("01-a/q#1", "Sami", "Sfax", false),
        passage("02-b/q#1", "Ali", "Tunis", false),
      ]),
    ).toEqual([]);
    expect(
      templateClusters([
        passage("01-a/q#1", "Sami", "Sfax"),
        { ...passage("02-b/q#1", "Ali", "Tunis"), type: "multi" },
      ]),
    ).toEqual([]);
  });

  it("ignore un cadre trop court pour décrire une tâche", () => {
    const short = (ref: string) => item({ ref, prompt: 'Complete: "I ___ sixteen."' });
    expect(templateClusters([short("01-a/q#1"), short("02-b/q#1")])).toEqual([]);
  });
});

describe("collectItems / measureTranche — sur une matière chargée", () => {
  const q = (prompt: string, texts: string[], key: string) => ({
    type: "mcq" as const,
    prompt,
    explanation: "x",
    options: texts.map((text, i) => ({ id: "abcd"[i], text })),
    correctOption: key,
  });
  const subject = {
    meta: { id: "demo" },
    chapters: [
      {
        slug: "01-a",
        quiz: { questions: [q("Q1 first question here", ["a", "bb", "c", "d"], "b")] },
        exercises: [
          {
            slug: "01-pratique",
            data: { questions: [q("Q2 other prompt", ["w", "x", "y", "z"], "a")] },
          },
        ],
      },
      {
        slug: "02-b",
        quiz: { questions: [q("Q3 published", ["p", "q", "r", "s"], "c")] },
        exercises: [],
      },
    ],
  } as unknown as LoadedSubject;

  it("aplatit quiz et exercices avec des références lisibles", () => {
    const items = collectItems(subject, new Set(["01-a"]));
    expect(items.map((i) => i.ref)).toEqual([
      "01-a/quiz#1",
      "01-a/exercices/01-pratique#1",
      "02-b/quiz#1",
    ]);
    expect(items.map((i) => i.inTranche)).toEqual([true, true, false]);
    expect(items[0].keyIndex).toBe(1);
  });

  it("ne mesure que la tranche, et son verdict ignore positions et gabarits", () => {
    const r = measureTranche(subject, new Set(["01-a"]));
    expect(r.tranche).toEqual(["01-a"]);
    expect(r.items).toBe(2);
    expect(r.longestKey.longest).toEqual(["01-a/quiz#1"]);
    // listé, mais deux items ne font pas un verdict
    expect(r.ok).toBe(true);
  });
});

describe("freshRefs / measureTranche(fresh) — le cliquet", () => {
  const leak = (ref: string) =>
    mcq(ref, ["non", "oui, parce que la règle le veut", "peut-être", "jamais"], 1);

  it("ne retient que le nouveau et le modifié", () => {
    const base = [leak("01-a/quiz#1"), leak("01-a/quiz#2")];
    const now = [
      leak("01-a/quiz#1"),
      { ...leak("01-a/quiz#2"), prompt: "Autre énoncé" },
      leak("01-a/quiz#3"),
    ];
    expect([...freshRefs(now, base)]).toEqual(["01-a/quiz#2", "01-a/quiz#3"]);
  });

  it("une matière absente de la base est entièrement neuve", () => {
    expect(freshRefs([leak("01-a/quiz#1")], null).size).toBe(1);
  });

  it("la dette publiée ne rend pas la tranche rouge", () => {
    const q = (prompt: string, texts: string[], key: string) => ({
      type: "mcq" as const,
      prompt,
      explanation: "x",
      options: texts.map((text, i) => ({ id: "abcd"[i], text })),
      correctOption: key,
    });
    const leaky = Array.from({ length: 10 }, (_, i) =>
      q(`Question ${i}`, ["non", "oui, parce que la règle le veut", "peut-être", "jamais"], "b"),
    );
    const subject = {
      meta: { id: "demo" },
      chapters: [{ slug: "01-a", quiz: { questions: leaky }, exercises: [] }],
    } as unknown as LoadedSubject;
    const tranche = new Set(["01-a"]);
    expect(measureTranche(subject, tranche).longestKey.ok).toBe(false);
    const r = measureTranche(subject, tranche, new Set(["01-a/quiz#10"]));
    expect(r.items).toBe(1);
    expect(r.longestKey.longest).toEqual(["01-a/quiz#10"]);
    expect(r.longestKey.ok).toBe(true);
  });
});
