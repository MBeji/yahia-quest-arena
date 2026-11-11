// @vitest-environment node
import { describe, it, expect } from "vitest";
import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import {
  buildControleIndex,
  controleText,
  isFlagged,
  isWatched,
  lineTargets,
  questionTargets,
  questionText,
  splitExercises,
} from "../../../../scripts/content/gisement/controle-checks.ts";
import { nonTrivialNumbers, toLatinDigits } from "../../../../scripts/content/gisement/nombres.ts";
import { runGisement, tsvLine, withTmp } from "./gisement-fixtures.ts";

/**
 * Étude 36 lot 2 — le contrôle local contre les snapshots. Ce que ces tests protègent : (1) une
 * copie est vue, par ses mots OU par ses données ; (2) une paraphrase et des coordonnées de
 * figure ne le sont PAS — le faux positif du pilote ; (3) le rapport ne transporte aucun
 * fragment de la source.
 *
 * Les « devoirs » ci-dessous sont inventés pour ces tests.
 */

const DEVOIR = `DEVOIR DE CONTRÔLE — session 2031

Exercice 1 (5 points)
Un jardinier possède une parcelle rectangulaire de 125 mètres de long et de 48,5 mètres de large.
Il veut l'entourer d'un grillage vendu 12,75 dinars le mètre. Calculer le périmètre de la parcelle
puis le prix total du grillage.

Exercice 2 (4 points)
<svg viewBox="0 0 320 240"><line x1="160" y1="140" x2="280" y2="190"/></svg>
Sur la figure, le triangle est rectangle ; ses côtés de l'angle droit mesurent 3,6 cm et 4,8 cm.
Calculer son hypoténuse.
`;

const index = () => buildControleIndex([{ slug: "site/D06", text: DEVOIR }]);
const check = (text: string) => controleText({ where: "cible", text }, index());

describe("splitExercises — une transcription, des exercices", () => {
  it("coupe sur les marqueurs français, en-tête compris", () => {
    const parts = splitExercises(DEVOIR);
    expect(parts).toHaveLength(3);
    expect(parts[1]).toMatch(/^Exercice 1/);
    expect(parts[2]).toMatch(/^Exercice 2/);
  });

  it("coupe sur les marqueurs arabes, vocalisés ou non, et sur EXERCICE", () => {
    expect(splitExercises("مقدمة\nالتمرين الأول\nنص\nتمرين عدد 2\nنص")).toHaveLength(3);
    expect(splitExercises("مقدمة\n**التَّمرين الثاني**\nنص")).toHaveLength(2);
    expect(splitExercises("titre\n## EXERCICE 3\ntexte")).toHaveLength(2);
  });

  it("ne coupe ni sur un titre « Exercices », ni au milieu d'une phrase", () => {
    expect(splitExercises("a\nExercices de révision\nb")).toHaveLength(1);
    expect(splitExercises("a\nDans l'Exercice 2 on a vu\nb")).toHaveLength(1);
  });

  it("rend le document entier sans marqueur", () => {
    expect(splitExercises("un texte\nsans marqueur")).toEqual(["un texte\nsans marqueur"]);
  });
});

describe("nonTrivialNumbers — trois chiffres ou plus, ou un décimal", () => {
  const nbsp = String.fromCodePoint(0xa0);

  it("écarte les petits entiers et canonise le reste", () => {
    expect([...nonTrivialNumbers("12 élèves, 125 m, 48,5 m, 2.50 €, 0125")]).toEqual([
      "125",
      "48.5",
      "2.5",
    ]);
  });

  it("recolle les milliers séparés par une espace, insécable comprise", () => {
    expect([...nonTrivialNumbers(`1 000 et 2${nbsp}500 et 3 000 000`)]).toEqual([
      "1000",
      "2500",
      "3000000",
    ]);
  });

  it("ramène les chiffres arabo-indiens aux chiffres latins", () => {
    expect(toLatinDigits("٣٥٠ و ۱۲")).toBe("350 و 12");
    expect([...nonTrivialNumbers("اشترى ٣٥٠ كلغ")]).toEqual(["350"]);
  });

  it("ignore les coordonnées d'une figure SVG", () => {
    expect(nonTrivialNumbers('<svg viewBox="0 0 320 240"><circle cx="160"/></svg> 3,6').size).toBe(
      1,
    );
  });
});

describe("controleText — les mots", () => {
  it("détecte deux textes identiques", () => {
    const row = check(DEVOIR);
    expect(row.v8).toBeGreaterThan(0);
    expect(row.longest).toBeGreaterThanOrEqual(8);
    expect(isFlagged(row)).toBe(true);
  });

  it("détecte une phrase recopiée dont seuls les nombres changent", () => {
    const row = check(
      "Un jardinier possède une parcelle rectangulaire de 90 mètres de long et de 40 mètres de large.",
    );
    expect(row.v8).toBe(1);
    expect(isFlagged(row)).toBe(true);
  });

  it("laisse passer une paraphrase lointaine de la même notion", () => {
    const row = check(
      "Une clôture fait le tour d'un terrain en forme de rectangle : combien coûte-t-elle si l'on connaît son tarif au mètre ?",
    );
    expect(row).toMatchObject({ v8: 0, v6: 0, shared: 0 });
    expect(isFlagged(row) || isWatched(row)).toBe(false);
  });
});

describe("controleText — les données", () => {
  it("signale trois nombres non triviaux communs avec un même exercice source", () => {
    const row = check(
      "Une piscine mesure 125 m sur 48,5 m ; le carrelage coûte 12,75 dinars le m².",
    );
    expect(row).toMatchObject({ v8: 0, shared: 3 });
    expect(isFlagged(row)).toBe(true);
  });

  it("compte par exercice : deux données de l'un et une de l'autre ne font pas trois", () => {
    const row = check("Deux terrains de 125 m et 48,5 m, puis un segment de 3,6 cm.");
    expect(row.shared).toBe(2);
    expect(isFlagged(row)).toBe(false);
    expect(isWatched(row)).toBe(true);
  });

  it("ignore les mêmes nombres quand la source ne les porte que dans une figure", () => {
    expect(check("Placer les points d'abscisses 160, 140 et 280 puis 320 et 240.").shared).toBe(0);
  });

  it("ignore les données de la source quand notre texte ne les porte que dans une figure", () => {
    const row = check(
      '<svg viewBox="0 0 125 100"><circle cx="48.5" cy="12.75" r="3"/></svg> Quelle est l\'aire ?',
    );
    expect(row.shared).toBe(0);
  });
});

describe("les cibles — nos identifiants, nos textes", () => {
  it("contrôle une cible JSON question par question, toute sa surface", () => {
    const targets = questionTargets(
      {
        questions: [
          { prompt: "p", options: [{ id: "a", text: "option visible" }], explanation: "e" },
          {
            type: "short_answer",
            prompt: "p2",
            explanation: "e2",
            answerKey: { text: "clé libre" },
            acceptedAnswers: ["variante acceptée"],
            expectedMistakes: [{ text: "erreur attendue", misconceptionTag: "t" }],
          },
          { type: "numeric", prompt: "p3", explanation: "e3", answerKey: { value: 48.5 } },
        ],
      },
      "chap/exercices/05-x.json",
    );
    expect(targets?.map((t) => t.where)).toEqual([
      "chap/exercices/05-x.json#q1",
      "chap/exercices/05-x.json#q2",
      "chap/exercices/05-x.json#q3",
    ]);
    expect(targets?.[0].text).toContain("option visible");
    expect(targets?.[1].text).toContain("clé libre");
    expect(targets?.[1].text).toContain("variante acceptée");
    expect(targets?.[1].text).toContain("erreur attendue");
    expect(targets?.[2].text).toContain("48.5");
    expect(targets?.map((t) => t.text).join("")).not.toContain("[object Object]");
  });

  it("refuse une cible JSON sans questions[] et tolère une question mal formée", () => {
    expect(questionTargets({ title: "x" }, "f.json")).toBeNull();
    expect(questionTargets([], "f.json")).toBeNull();
    expect(questionText(null)).toBe("");
    expect(questionText({ prompt: 3, options: "x", answerKey: { order: ["a", "b"] } }).trim()).toBe(
      "",
    );
  });

  it("contrôle des lignes du lecteur une à une, sur leur prose seule", () => {
    const text = `${tsvLine({ bareme: "12,75" })}\n\nligne\tcassée`;
    const targets = lineTargets(text, "lignes.tsv");
    expect(targets.map((t) => t.where)).toEqual(["lignes.tsv:1", "lignes.tsv:3"]);
    expect(targets[0].text).toBe(
      "calculer une quatrième proportionnelle puis comparer deux prix\ninverser le rapport",
    );
    expect(targets[1].text).toBe("ligne\tcassée");
  });
});

describe("content:gisement:controle — le CLI", () => {
  const COPIE =
    "Un jardinier possède une parcelle rectangulaire de 90 mètres de long et de 40 mètres de large.";

  const setup = (dir: string) => {
    mkdirSync(join(dir, "snapshots", "site"), { recursive: true });
    writeFileSync(join(dir, "snapshots", "site", "D06.txt"), DEVOIR);
    writeFileSync(join(dir, "snapshots", "notes.md"), "ignoré : seuls les .txt sont des sources");
    const question = (prompt: string) => ({
      prompt,
      options: [
        { id: "a", text: "un" },
        { id: "b", text: "deux" },
      ],
      correctOption: "a",
      explanation: "Parce que.",
    });
    writeFileSync(
      join(dir, "copie.json"),
      JSON.stringify({ questions: [question(COPIE), question("Combien de côtés a un carré ?")] }),
    );
    writeFileSync(
      join(dir, "propre.json"),
      JSON.stringify({ questions: [question("Quel est le double de sept ?")] }),
    );
    writeFileSync(
      join(dir, "carte.md"),
      "## Carte\n\nPérimètre d'un rectangle puis coût au mètre.",
    );
    writeFileSync(join(dir, "lignes.tsv"), `${tsvLine()}\n`);
  };

  it(
    "sort en 1 sur une copie, avec nos identifiants et des comptes seulement",
    { timeout: 60_000 },
    () => {
      withTmp((dir) => {
        setup(dir);
        const r = runGisement(
          "controle",
          ["--sources", "snapshots", "copie.json", "carte.md", "lignes.tsv"],
          dir,
        );
        expect(r.stdout).toMatch(/sources : 1 transcription\(s\), 3 exercice\(s\) à données/);
        expect(r.stdout).toMatch(/4 texte\(s\) contrôlé\(s\) — plage ≥ 8 mots : 1/);
        expect(r.stdout).toMatch(
          /✗ copie\.json#q1 — plages ≥ 8 mots : 1 \(la plus longue : \d+ mots\)/,
        );
        expect(r.stdout).not.toContain("copie.json#q2");
        // Le rapport d'un contrôle anti-copie n'est pas le véhicule de la copie.
        expect(r.stdout).not.toMatch(/jardinier|parcelle|grillage/);
        expect(r.code).toBe(1);
      });
    },
  );

  it("sort en 0 sur des textes propres", { timeout: 60_000 }, () => {
    withTmp((dir) => {
      setup(dir);
      const r = runGisement(
        "controle",
        ["--sources", "snapshots", "propre.json", "lignes.tsv"],
        dir,
      );
      expect(r.stdout).toMatch(/✓ aucune plage ≥ 8 mots/);
      expect(r.code).toBe(0);
    });
  });

  it("sort en 2 sans transcription ou sur une cible illisible", { timeout: 60_000 }, () => {
    withTmp((dir) => {
      setup(dir);
      mkdirSync(join(dir, "vide"));
      const empty = runGisement("controle", ["--sources", "vide", "propre.json"], dir);
      expect(empty.stderr).toMatch(/aucune transcription \.txt/);
      expect(empty.code).toBe(2);

      writeFileSync(join(dir, "sans.json"), JSON.stringify({ title: "x" }));
      const noQuestions = runGisement("controle", ["--sources", "snapshots", "sans.json"], dir);
      expect(noQuestions.stderr).toMatch(/pas de tableau questions\[\]/);
      expect(noQuestions.code).toBe(2);
    });
  });
});
