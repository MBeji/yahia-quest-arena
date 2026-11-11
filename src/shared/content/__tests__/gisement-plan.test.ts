// @vitest-environment node
import { describe, it, expect } from "vitest";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import {
  buildPlan,
  compareSources,
  maxExistingNn,
  normalizeArchetype,
  placementChapter,
  renderPlan,
  splitBalanced,
  type PlanInput,
} from "../../../../scripts/content/gisement/plan-builder.ts";
import { existingNnByChapter } from "../../../../scripts/content/gisement/gisement-io.ts";
import type { GisementLine } from "../../../../scripts/content/gisement/lignes-checks.ts";
import {
  CHAPTERS,
  GRADE,
  parsedLines,
  runGisement,
  SUBJECT,
  tsvLine,
  withTmp,
  writeCorpus,
} from "./gisement-fixtures.ts";

/**
 * Étude 36 lot 2 — le plan d'écriture. Ce que ces tests protègent : (1) le placement suit
 * l'ordre du MANIFESTE, pas celui des slugs ; (2) un archétype de devoir vu plusieurs fois est
 * UNE mission, un exercice d'examen jamais fusionné ; (3) les plages de numéros ne se
 * chevauchent pas et suivent l'existant ; (4) le plan est rejouable, octet pour octet.
 */

const input = (over: Partial<PlanInput> = {}): PlanInput => ({
  subject: SUBJECT,
  grade: GRADE,
  chapters: CHAPTERS,
  existingNn: new Map(),
  ...over,
});

const plan = (lines: GisementLine[], over: Partial<PlanInput> = {}) =>
  buildPlan(lines, input(over));

/** `n` archétypes distincts de devoir dans un chapitre, numérotés à partir de `exo`. */
const distinct = (chapitres: string, n: number, doc = "D10") =>
  Array.from({ length: n }, (_, i) =>
    tsvLine({ doc, exo: String(i + 1), chapitres, archetype: `archétype ${"abcdefghijklm"[i]}` }),
  );

describe("placement — le chapitre le plus avancé du manifeste", () => {
  it("suit l'ordre d'enseignement, pas l'ordre lexical des slugs", () => {
    // Manifeste : 03-fractions, 01-nombres, 02-proportions, 04-aires.
    expect(placementChapter({ chapitres: ["01-nombres", "03-fractions"] }, CHAPTERS)).toBe(
      "01-nombres",
    );
    const [line] = parsedLines(tsvLine({ chapitres: "03-fractions+01-nombres" }));
    expect(plan([line]).missions[0].chapter).toBe("01-nombres");
  });

  it("ne place pas un exercice tout HP:, et le compte avec son doc#exo", () => {
    const p = plan(parsedLines(tsvLine({ chapitres: "HP:systemes+HP:fonction-affine" })));
    expect(p.missions).toEqual([]);
    expect(p.horsProgramme).toEqual([
      { source: "D06#2", notions: ["fonction-affine", "systemes"] },
    ]);
  });

  it("place une ligne mêlée d'après ses seuls slugs et garde ses notions HP", () => {
    const [m] = plan(parsedLines(tsvLine({ chapitres: "HP:systemes+02-proportions" }))).missions;
    expect(m.chapter).toBe("02-proportions");
    expect(m.horsProgramme).toEqual(["systemes"]);
  });

  it("refuse une ligne dont un chapitre n'est pas au manifeste plutôt que de la perdre", () => {
    const [line] = parsedLines(tsvLine());
    expect(() => plan([{ ...line, chapitres: ["99-ailleurs"] }])).toThrow(/99-ailleurs/);
  });
});

describe("dédoublonnage — une mission par signature de devoir", () => {
  it("fusionne deux signatures identiques : sources, étage le plus haut, étapes les plus nombreuses", () => {
    const p = plan(
      parsedLines(
        tsvLine({
          doc: "D12",
          exo: "1",
          competences: "math.num.fractions+math.num.proportions",
          archetype: "Calculer une quatrième proportionnelle, puis comparer deux prix.",
          etapes: "2",
          etage: "d3",
          piege: "inverser le rapport",
        }),
        tsvLine({
          doc: "D06",
          exo: "10",
          creneau: "DS2",
          competences: "math.num.proportions+math.num.fractions",
          archetype: "calculer une quatrieme proportionnelle puis  comparer deux prix",
          etapes: "4",
          etage: "d2",
          piege: "oublier l'unité",
        }),
      ),
    );
    expect(p.missions).toHaveLength(1);
    expect(p.missions[0]).toMatchObject({
      kind: "devoir",
      sources: ["D06#10", "D12#1"],
      etage: "d3",
      etapes: 4,
      competences: ["math.num.fractions", "math.num.proportions"],
      archetype: "calculer une quatrieme proportionnelle puis  comparer deux prix",
      piege: "oublier l'unité ; inverser le rapport",
    });
  });

  it("garde deux missions quand l'archétype diffère", () => {
    const p = plan(parsedLines(tsvLine(), tsvLine({ exo: "3", archetype: "autre chose à faire" })));
    expect(p.missions).toHaveLength(2);
  });

  it("ne dédoublonne JAMAIS deux exercices d'examen identiques", () => {
    const p = plan(
      parsedLines(
        tsvLine({ doc: "E01", exo: "1", creneau: "concours" }),
        tsvLine({ doc: "E02", exo: "1", creneau: "concours" }),
      ),
    );
    expect(p.missions.map((m) => [m.kind, m.sources])).toEqual([
      ["examen", ["E01#1"]],
      ["examen", ["E02#1"]],
    ]);
  });

  it("ne fusionne pas un examen avec un devoir de même signature", () => {
    const p = plan(parsedLines(tsvLine(), tsvLine({ doc: "E01", creneau: "concours" })));
    expect(p.missions.map((m) => m.kind).sort()).toEqual(["devoir", "examen"]);
  });

  it("fusionne série et devoir de même signature (devoir l'emporte) ; une série seule reste série", () => {
    const merged = plan(parsedLines(tsvLine({ creneau: "serie" }), tsvLine({ doc: "D07" })));
    expect(merged.missions.map((m) => [m.kind, m.sources])).toEqual([
      ["devoir", ["D06#2", "D07#2"]],
    ]);
    expect(plan(parsedLines(tsvLine({ creneau: "serie" }))).missions[0].kind).toBe("serie");
  });

  it("ignore hors-registre: dans la signature mais le garde dans la mission", () => {
    const p = plan(
      parsedLines(
        tsvLine({ competences: "math.num.proportions+hors-registre:echelle" }),
        tsvLine({ doc: "D07", competences: "math.num.proportions+hors-registre:vitesse" }),
      ),
    );
    expect(p.missions).toHaveLength(1);
    expect(p.missions[0].competences).toEqual(["math.num.proportions"]);
    expect(p.missions[0].horsRegistre).toEqual(["echelle", "vitesse"]);
  });

  it("ne retient que les créneaux demandés", () => {
    const p = plan(
      parsedLines(
        tsvLine({ creneau: "DC1" }),
        tsvLine({ doc: "D07", creneau: "DS1", archetype: "x y" }),
      ),
      { creneaux: ["DS1"] },
    );
    expect(p.missions.map((m) => m.sources)).toEqual([["D07#2"]]);
  });
});

describe("lots d'auteur et numéros de fichiers", () => {
  it("coupe un gros chapitre en lots équilibrés, regroupe les petits, laisse un moyen seul", () => {
    const p = plan(
      parsedLines(
        ...distinct("01-nombres", 10), // gros : 10 > 8 → 5 + 5
        ...distinct("03-fractions", 2, "D20"), // petit
        ...distinct("04-aires", 3, "D30"), // petit
        ...distinct("02-proportions", 4, "D40"), // moyen : seul
      ),
      { existingNn: new Map([["01-nombres", 7]]) },
    );
    expect(p.lots.map((l) => [l.id, l.chapters, l.missions.length])).toEqual([
      ["L01", ["03-fractions", "04-aires"], 5],
      ["L02", ["01-nombres"], 5],
      ["L03", ["01-nombres"], 5],
      ["L04", ["02-proportions"], 4],
    ]);
    expect(p.lots.map((l) => l.nnRanges)).toEqual([
      { "03-fractions": [1, 2], "04-aires": [1, 3] },
      { "01-nombres": [8, 12] },
      { "01-nombres": [13, 17] },
      { "02-proportions": [1, 4] },
    ]);
    // Chaque mission porte son lot et un numéro unique dans son chapitre.
    const numbers = p.missions.map((m) => `${m.chapter}/${m.nn}`);
    expect(new Set(numbers).size).toBe(p.missions.length);
    expect(
      p.missions.every((m) => p.lots.find((l) => l.id === m.lot)?.missions.includes(m.id)),
    ).toBe(true);
  });

  it("ouvre un second lot de petits chapitres quand le premier n'a plus la place", () => {
    const p = plan(parsedLines(...distinct("03-fractions", 3), ...distinct("04-aires", 3, "D30")), {
      lotMax: 5,
    });
    expect(p.lots.map((l) => l.chapters)).toEqual([["03-fractions"], ["04-aires"]]);
  });

  it("numérote d'abord les étages bas, puis les archétypes les plus fréquents", () => {
    const p = plan(
      parsedLines(
        tsvLine({ doc: "D01", archetype: "rare", etage: "d3" }),
        tsvLine({ doc: "D02", archetype: "frequent", etage: "d3" }),
        tsvLine({ doc: "D03", archetype: "frequent", etage: "d1" }),
        tsvLine({ doc: "D04", archetype: "facile", etage: "d1" }),
      ),
    );
    expect(p.missions.map((m) => [m.archetype, m.nn])).toEqual([
      ["facile", 1],
      ["frequent", 2],
      ["rare", 3],
    ]);
  });

  it("lit le plus grand NN existant d'un dossier exercices/ (fixture sur disque)", () => {
    expect(maxExistingNn(["01-a.json", "07-b.json", "notes.md", "x-09.json", "12-c.txt"])).toBe(7);
    withTmp((dir) => {
      const content = writeCorpus(dir, {
        "01-nombres": ["01-pratique.json", "09-boss.json"],
        "02-proportions": ["README.md"],
      });
      const existing = existingNnByChapter(content, SUBJECT, CHAPTERS);
      expect(Object.fromEntries(existing)).toEqual({
        "03-fractions": 0,
        "01-nombres": 9,
        "02-proportions": 0,
        "04-aires": 0,
      });
      const p = plan(parsedLines(tsvLine({ chapitres: "01-nombres" })), { existingNn: existing });
      expect(p.lots[0].nnRanges).toEqual({ "01-nombres": [10, 10] });
    });
  });

  it("refuse un lot-max qui n'est pas un entier ≥ 1", () => {
    expect(() => plan([], { lotMax: 0 })).toThrow(/lotMax/);
  });
});

describe("un plan rejouable", () => {
  const rows = [
    tsvLine(),
    tsvLine({
      doc: "D07",
      exo: "1",
      archetype: "Calculer une quatrième proportionnelle puis comparer deux prix",
    }),
    tsvLine({
      doc: "E01",
      exo: "3",
      creneau: "concours",
      chapitres: "04-aires",
      competences: "math.geo.aires",
    }),
    tsvLine({ doc: "D09", exo: "4", chapitres: "HP:systemes" }),
    ...distinct("01-nombres", 9, "D30"),
  ];

  it("rend le même JSON, octet pour octet, quel que soit l'ordre des lignes", () => {
    const once = renderPlan(plan(parsedLines(...rows)));
    expect(renderPlan(plan(parsedLines(...rows)))).toBe(once);
    expect(renderPlan(plan(parsedLines(...[...rows].reverse())))).toBe(once);
    expect(once.endsWith("}\n")).toBe(true);
  });

  it("écrit les champs de la mission dans l'ordre du contrat", () => {
    const [m] = plan(parsedLines(tsvLine({ chapitres: "HP:x+02-proportions" }))).missions;
    expect(Object.keys(m)).toEqual([
      "id",
      "kind",
      "sources",
      "chapter",
      "etage",
      "etapes",
      "competences",
      "archetype",
      "piege",
      "lot",
      "nn",
      "horsProgramme",
    ]);
  });
});

describe("les briques", () => {
  it("normalise un archétype : casse, accents, ponctuation, espaces", () => {
    expect(normalizeArchetype("  Déterminer l’aire — puis   CONCLURE ! ")).toBe(
      "determiner l aire puis conclure",
    );
    expect(normalizeArchetype("A → B → C")).toBe(normalizeArchetype("a -> b -> c"));
  });

  it("trie les sources dans l'ordre naturel", () => {
    expect(["D100#1", "D06#10", "E01#1", "D06#2", "D06#2a"].sort(compareSources)).toEqual([
      "D06#2",
      "D06#2a",
      "D06#10",
      "D100#1",
      "E01#1",
    ]);
  });

  it("coupe en parts équilibrées", () => {
    expect(splitBalanced([1, 2, 3, 4, 5, 6, 7, 8, 9], 2)).toEqual([
      [1, 2, 3, 4, 5],
      [6, 7, 8, 9],
    ]);
    expect(splitBalanced([1, 2, 3, 4, 5, 6, 7], 3).map((p) => p.length)).toEqual([3, 2, 2]);
  });
});

describe("content:gisement:plan — le CLI", () => {
  it("écrit le même plan à chaque lancement, et le résume", { timeout: 60_000 }, () => {
    withTmp((dir) => {
      writeCorpus(dir, { "02-proportions": ["01-pratique.json", "04-boss.json"] });
      writeFileSync(
        join(dir, "a.tsv"),
        `${tsvLine()}\n${tsvLine({ doc: "D07", creneau: "DS1" })}\n${tsvLine({ doc: "D08", chapitres: "HP:systemes" })}\n`,
      );
      const args = ["a.tsv", "--subject", SUBJECT, "--grade", GRADE, "--content", "content"];
      const first = runGisement("plan", [...args, "--out", "out/plan.json"], dir);
      expect(first.code).toBe(0);
      expect(first.stdout).toMatch(
        /3 ligne\(s\) retenue\(s\) sur 3 → 1 mission\(s\) \(1 devoir\), 1 hors programme/,
      );
      expect(first.stdout).toMatch(/L01 · 02-proportions \(NN 5–5\) : 1 mission\(s\)/);
      const written = readFileSync(join(dir, "out", "plan.json"), "utf8");
      expect(JSON.parse(written).missions[0]).toMatchObject({ sources: ["D06#2", "D07#2"], nn: 5 });

      const again = runGisement("plan", [...args, "--out", "out/plan.json"], dir);
      expect(readFileSync(join(dir, "out", "plan.json"), "utf8")).toBe(written);
      expect(again.code).toBe(0);

      // Sans --out : le JSON seul sur la sortie standard, le résumé sur la sortie d'erreur.
      const piped = runGisement("plan", [...args, "--creneaux", "DS1"], dir);
      expect(JSON.parse(piped.stdout).missions[0].sources).toEqual(["D07#2"]);
      expect(piped.stderr).toMatch(/1 ligne\(s\) retenue\(s\) sur 3/);
    });
  });

  it(
    "n'écrit aucun plan sur une ligne fautive, et refuse un créneau inconnu",
    { timeout: 60_000 },
    () => {
      withTmp((dir) => {
        writeCorpus(dir);
        writeFileSync(join(dir, "a.tsv"), `${tsvLine({ etage: "d9" })}\n`);
        const faulty = runGisement(
          "plan",
          ["a.tsv", "--subject", SUBJECT, "--grade", GRADE, "--out", "plan.json"],
          dir,
        );
        expect(faulty.stdout).toContain("a.tsv:1 — étage « d9 » hors échelle");
        expect(faulty.code).toBe(1);
        expect(existsSync(join(dir, "plan.json"))).toBe(false);

        const badSlot = runGisement(
          "plan",
          ["a.tsv", "--subject", SUBJECT, "--grade", GRADE, "--creneaux", "DC9"],
          dir,
        );
        expect(badSlot.stderr).toMatch(/--creneaux : « DC9 » hors liste/);
        expect(badSlot.code).toBe(2);
      });
    },
  );
});
