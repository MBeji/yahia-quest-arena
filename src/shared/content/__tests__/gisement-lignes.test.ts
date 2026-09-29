// @vitest-environment node
import { describe, it, expect } from "vitest";
import { writeFileSync } from "node:fs";
import { join } from "node:path";
import {
  ARCHETYPE_MAX_WORDS,
  competencyScope,
  parseLine,
  renderFault,
  validateLines,
  type LineVocabulary,
} from "../../../../scripts/content/gisement/lignes-checks.ts";
import { hasSourceNumber } from "../../../../scripts/content/gisement/nombres.ts";
import {
  GRADE,
  runGisement,
  SUBJECT,
  tsvLine,
  VOCAB,
  withTmp,
  writeCorpus,
} from "./gisement-fixtures.ts";

/**
 * Étude 36 lot 2 — le format fermé des lignes du lecteur. Ce que ces tests protègent, dans
 * l'ordre : (1) aucun nombre de la source ne franchit la salle blanche par une ligne, (2) le
 * vocabulaire est FERMÉ — un chapitre hors manifeste, une compétence hors registre, un étage
 * hors échelle ne passent pas —, (3) une ligne juste passe, avec ses deux marqueurs ouverts
 * (`HP:`, `hors-registre:`).
 */

const where = { file: "lignes.tsv", line: 1 };
const judge = (raw: string, vocab: LineVocabulary = VOCAB) => parseLine(raw, where, vocab);
const motifs = (raw: string, vocab: LineVocabulary = VOCAB) =>
  judge(raw, vocab).fault?.motifs ?? [];

describe("parseLine — une ligne juste", () => {
  it("accepte une ligne valide et en lit chaque colonne", () => {
    const { line, fault } = judge(tsvLine());
    expect(fault).toBeUndefined();
    expect(line).toMatchObject({
      doc: "D06",
      creneau: "DC1",
      exo: "2",
      bareme: 4.5,
      chapitres: ["02-proportions"],
      horsProgramme: [],
      competences: ["math.num.proportions"],
      horsRegistre: [],
      etapes: 3,
      piege: "inverser le rapport",
      etage: "d2",
    });
  });

  it("accepte un barème absent, un exo à lettre, un piège absent et plusieurs chapitres", () => {
    const { line } = judge(
      tsvLine({ bareme: "-", exo: "2a", piege: "-", chapitres: "03-fractions+02-proportions" }),
    );
    expect(line?.bareme).toBeNull();
    expect(line?.exo).toBe("2a");
    expect(line?.chapitres).toEqual(["03-fractions", "02-proportions"]);
  });

  it("tolère les blancs autour des colonnes", () => {
    expect(judge(tsvLine({ etage: " d3 ", competences: " math.num.fractions " })).fault).toBe(
      undefined,
    );
  });
});

describe("parseLine — le format", () => {
  it("rejette une colonne manquante", () => {
    const nine = tsvLine().split("\t").slice(0, 9).join("\t");
    expect(motifs(nine)).toEqual(["9 colonne(s) au lieu de 10"]);
  });

  it("rejette une colonne de trop (une tabulation dans la prose)", () => {
    expect(motifs(`${tsvLine()}\tx`)[0]).toMatch(/11 colonne/);
  });

  it("rejette un étage hors de l'échelle", () => {
    expect(motifs(tsvLine({ etage: "d5" }))).toEqual([
      "étage « d5 » hors échelle (d1, d2, d3, d4)",
    ]);
  });

  it.each([
    ["doc", { doc: "d06" }, /doc « d06 »/],
    ["doc", { doc: "D6" }, /doc « D6 »/],
    ["créneau", { creneau: "DC7" }, /créneau « DC7 » hors liste/],
    ["créneau", { creneau: "série" }, /créneau « série »/],
    ["exo", { exo: "II" }, /exo « II »/],
    ["barème", { bareme: "4 pts" }, /barème « 4 pts »/],
    ["étapes", { etapes: "0" }, /étapes « 0 »/],
    ["étapes", { etapes: "2,5" }, /étapes « 2,5 »/],
  ])("rejette un %s mal formé (%o)", (_label, over, motif) => {
    expect(motifs(tsvLine(over)).join(" ; ")).toMatch(motif);
  });

  it("réunit tous les motifs d'une ligne en une seule faute", () => {
    const { fault } = judge(tsvLine({ doc: "x", etage: "d9", etapes: "0" }));
    expect(fault?.motifs).toHaveLength(3);
    expect(renderFault(fault!)).toMatch(/^lignes\.tsv:1 — doc .* ; étapes .* ; étage /);
  });
});

describe("parseLine — aucun nombre de la source dans la prose", () => {
  it("rejette un nombre à deux chiffres dans l'archétype", () => {
    expect(motifs(tsvLine({ archetype: "calculer le prix de douze objets à 15 dinars" }))).toEqual([
      "archétype : un nombre de deux chiffres ou plus, ou un décimal — un nombre de la source n'a rien à faire dans une ligne",
    ]);
  });

  it("rejette un décimal dans le piège, virgule ou point", () => {
    expect(motifs(tsvLine({ piege: "oublier le 2,5 du coefficient" }))[0]).toMatch(/^piège :/);
    expect(motifs(tsvLine({ piege: "arrondir 0.5 à l'unité" }))[0]).toMatch(/^piège :/);
  });

  it("rejette aussi les chiffres arabo-indiens", () => {
    expect(hasSourceNumber("احسب ١٢ مترا")).toBe(true);
    expect(motifs(tsvLine({ archetype: "calculer ١٢ longueurs" }))[0]).toMatch(/^archétype :/);
  });

  it("accepte un chiffre isolé", () => {
    expect(judge(tsvLine({ archetype: "résoudre 2 équations puis comparer" })).fault).toBe(
      undefined,
    );
  });

  it(`rejette un archétype de plus de ${ARCHETYPE_MAX_WORDS} mots`, () => {
    const long = Array.from({ length: ARCHETYPE_MAX_WORDS + 1 }, () => "mot").join(" ");
    expect(motifs(tsvLine({ archetype: long }))).toEqual([
      `archétype de ${ARCHETYPE_MAX_WORDS + 1} mots (${ARCHETYPE_MAX_WORDS} au plus)`,
    ]);
  });

  it("rejette une prose vide", () => {
    expect(motifs(tsvLine({ archetype: "" }))).toContain("archétype vide");
  });
});

describe("parseLine — chapitres : le manifeste, ou HP:", () => {
  it("rejette un chapitre absent du manifeste", () => {
    expect(motifs(tsvLine({ chapitres: "02-proportions+09-volumes" }))).toEqual([
      "chapitre « 09-volumes » absent du manifeste (ou HP:<mot-clé>)",
    ]);
  });

  it("accepte des jetons HP:, seuls ou mêlés aux slugs, et les range à part", () => {
    expect(judge(tsvLine({ chapitres: "HP:systemes" })).line).toMatchObject({
      chapitres: [],
      horsProgramme: ["systemes"],
    });
    expect(judge(tsvLine({ chapitres: "01-nombres+HP:fonction-affine" })).line).toMatchObject({
      chapitres: ["01-nombres"],
      horsProgramme: ["fonction-affine"],
    });
  });

  it("rejette un jeton HP: mal formé, un jeton vide, un chapitre répété", () => {
    expect(motifs(tsvLine({ chapitres: "HP:Systèmes" }))[0]).toMatch(/« HP:Systèmes » mal formé/);
    expect(motifs(tsvLine({ chapitres: "HP:" }))[0]).toMatch(/mal formé/);
    expect(motifs(tsvLine({ chapitres: "01-nombres+" }))).toEqual(["chapitres : jeton vide"]);
    expect(motifs(tsvLine({ chapitres: "01-nombres+01-nombres" }))).toEqual([
      "chapitres : « 01-nombres » répété",
    ]);
  });
});

describe("parseLine — compétences : le registre, hors-registre:, ou -", () => {
  it("rejette une compétence hors du registre", () => {
    expect(motifs(tsvLine({ competences: "math.num.fractions+math.num.inconnue" }))).toEqual([
      "compétence « math.num.inconnue » absente du registre (ou hors-registre:<mot-clé>)",
    ]);
  });

  it("accepte des jetons hors-registre: et les range à part", () => {
    expect(
      judge(tsvLine({ competences: "math.geo.aires+hors-registre:centre-de-gravite" })).line,
    ).toMatchObject({ competences: ["math.geo.aires"], horsRegistre: ["centre-de-gravite"] });
    expect(motifs(tsvLine({ competences: "hors-registre:Centre" }))[0]).toMatch(/mal formé/);
  });

  it("exige des compétences quand la famille a un registre", () => {
    expect(motifs(tsvLine({ competences: "-" }))[0]).toMatch(/la famille a un registre/);
  });

  it("exige - quand aucun registre ne couvre le sujet", () => {
    const sansRegistre: LineVocabulary = { chapters: VOCAB.chapters, competencies: null };
    expect(judge(tsvLine({ competences: "-" }), sansRegistre).fault).toBeUndefined();
    expect(motifs(tsvLine(), sansRegistre)).toEqual([
      "compétences : la famille n'a pas de registre, la colonne vaut -",
    ]);
  });
});

describe("competencyScope — la famille d'un sujet", () => {
  const registries = [
    { family: "math", subjectPrefixes: ["math"], competencies: [{ id: "math.a.b" }] },
    {
      family: "physique",
      subjectPrefixes: ["svt", "physique"],
      competencies: [{ id: "physique.a.b" }],
    },
  ];

  it("couvre l'id exact et ses déclinaisons par classe, pas un simple préfixe de lettres", () => {
    expect(competencyScope(registries, "math")?.families).toEqual(["math"]);
    expect(competencyScope(registries, "math-6eme")?.ids).toEqual(new Set(["math.a.b"]));
    expect(competencyScope(registries, "svt")?.families).toEqual(["physique"]);
    expect(competencyScope(registries, "mathx")).toBeNull();
    expect(competencyScope(registries, "arabic")).toBeNull();
  });
});

describe("validateLines — plusieurs fichiers", () => {
  it("ignore les lignes blanches, tolère CRLF et BOM, et compte", () => {
    const bom = String.fromCodePoint(0xfeff);
    const { lines, faults, count } = validateLines(
      [{ file: "a.tsv", text: `${bom}${tsvLine()}\r\n\r\n${tsvLine({ exo: "3" })}\r\n` }],
      VOCAB,
    );
    expect(faults).toEqual([]);
    expect(count).toBe(2);
    expect(lines.map((l) => `${l.file}:${l.line}`)).toEqual(["a.tsv:1", "a.tsv:3"]);
  });

  it("refuse un même exercice décrit deux fois, même d'un fichier à l'autre", () => {
    const { lines, faults } = validateLines(
      [
        { file: "a.tsv", text: tsvLine() },
        {
          file: "b.tsv",
          text: `${tsvLine({ exo: "3" })}\n${tsvLine({ archetype: "autre chose" })}`,
        },
      ],
      VOCAB,
    );
    expect(lines).toHaveLength(2);
    expect(faults.map(renderFault)).toEqual(["b.tsv:2 — « D06#2 » déjà décrit en a.tsv:1"]);
  });

  it("écarte les lignes fautives des lignes valides", () => {
    const { lines, faults, count } = validateLines(
      [{ file: "a.tsv", text: `${tsvLine({ etage: "d7" })}\n${tsvLine({ exo: "5" })}` }],
      VOCAB,
    );
    expect(count).toBe(2);
    expect(lines.map((l) => l.exo)).toEqual(["5"]);
    expect(faults.map((f) => f.line)).toEqual([1]);
  });
});

/** Le câblage : le vrai CLI, sur un corpus jouet, avec ses trois codes de sortie. */
describe("content:gisement:lignes — le CLI", () => {
  it("sort en 1 et nomme fichier:ligne — motif", { timeout: 60_000 }, () => {
    withTmp((dir) => {
      writeCorpus(dir);
      writeFileSync(
        join(dir, "lignes.tsv"),
        `${tsvLine()}\n${tsvLine({ exo: "3", etage: "d5" })}\n`,
      );
      const r = runGisement("lignes", ["lignes.tsv", "--subject", SUBJECT, "--grade", GRADE], dir);
      expect(r.stdout).toMatch(
        /math · 7eme-base : 4 chapitre\(s\) au manifeste ; registre math \(4 compétence\(s\)\)/,
      );
      expect(r.stdout).toMatch(/2 ligne\(s\) : 1 valide\(s\), 1 fautive\(s\)/);
      expect(r.stdout).toContain("lignes.tsv:2 — étage « d5 » hors échelle");
      expect(r.code).toBe(1);
    });
  });

  it(
    "sort en 0 sur des lignes conformes, --content désignant le corpus",
    { timeout: 60_000 },
    () => {
      withTmp((dir) => {
        const content = writeCorpus(dir);
        writeFileSync(join(dir, "l.tsv"), `${tsvLine()}\n`);
        const r = runGisement(
          "lignes",
          ["l.tsv", "--subject", SUBJECT, "--grade", GRADE, "--content", content],
          dir,
        );
        expect(r.stdout).toMatch(/✓ lignes conformes/);
        expect(r.code).toBe(0);
      });
    },
  );

  it(
    "annonce l'absence de registre, et sort en 2 quand il ne peut pas juger",
    { timeout: 60_000 },
    () => {
      withTmp((dir) => {
        writeCorpus(dir);
        writeFileSync(
          join(dir, "l.tsv"),
          `${tsvLine({ chapitres: "01-jumla", competences: "-" })}\n`,
        );
        const arabic = runGisement(
          "lignes",
          ["l.tsv", "--subject", "arabic", "--grade", GRADE],
          dir,
        );
        expect(arabic.stdout).toMatch(/aucun registre de compétences ne couvre « arabic »/);
        expect(arabic.code).toBe(0);

        const absent = runGisement("lignes", ["l.tsv", "--subject", "svt", "--grade", GRADE], dir);
        expect(absent.stderr).toMatch(/ne liste pas le sujet « svt »/);
        expect(absent.code).toBe(2);

        const noGrade = runGisement("lignes", ["l.tsv", "--subject", SUBJECT], dir);
        expect(noGrade.stderr).toMatch(/usage : content:gisement:lignes/);
        expect(noGrade.code).toBe(2);
      });
    },
  );
});
