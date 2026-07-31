import { describe, expect, it } from "vitest";
import {
  checkSuivi,
  coveragePct,
  generationAutorisee,
  gradeSlotOf,
  renderIndex,
  type Affectations,
  type Corpus,
  type FicheEntry,
  type SuiviCheckInput,
} from "../transcription-suivi.ts";

const corpus: Corpus = {
  generatedFrom: "test",
  count: 3,
  documents: [
    {
      code: "501109",
      tome: "P00",
      cycle: "base",
      role: "enseignant",
      classe: 1,
      matiere: "01",
      titre: "Guide arabe 1ère",
      fichier: "501109P00.pdf",
      octets: 1,
    },
    {
      code: "101110",
      tome: "P00",
      cycle: "base",
      role: "eleve",
      classe: 1,
      matiere: "01",
      titre: "Manuel arabe 1ère",
      fichier: "101110P00.pdf",
      octets: 1,
    },
    {
      code: "512101",
      tome: "P00",
      cycle: "base",
      role: "enseignant",
      classe: 1,
      matiere: "12",
      titre: "Guide EPS",
      fichier: "512101P00.pdf",
      octets: 1,
    },
  ],
};

const affectations: Affectations = {
  matieres: {
    "01": { id: "arabe", categorie: "principale" },
    "12": { id: "eps", categorie: "annexe" },
  },
  overrides: {},
};

function entry(overrides: Partial<FicheEntry>): FicheEntry {
  return {
    matiere: "arabe",
    statut: "complete",
    profondeur: "generation",
    sources: [
      {
        code: "501109",
        tomes: ["P00"],
        role: "enseignant",
        pagesTotal: 100,
        pagesLues: "integral",
      },
    ],
    sourcesLibres: [],
    sujets: [],
    chapitresGeneration: [],
    r7: null,
    maj: "2026-07-17",
    par: "test",
    notes: "",
    ...overrides,
  };
}

function input(fiches: FicheEntry[], fichesOnDisk = ["1ere-base/arabe"]): SuiviCheckInput {
  return { corpus, affectations, suivis: [{ grade: "1ere-base", fiches }], fichesOnDisk };
}

describe("checkSuivi", () => {
  it("accepts a coherent registry", () => {
    const { errors } = checkSuivi(input([entry({})]));
    expect(errors).toEqual([]);
  });

  it("flags a source claimed by two fiches (anti-double-transcription)", () => {
    const result = checkSuivi({
      corpus,
      affectations,
      suivis: [
        { grade: "1ere-base", fiches: [entry({})] },
        { grade: "2eme-base", fiches: [entry({})] },
      ],
      fichesOnDisk: ["1ere-base/arabe", "2eme-base/arabe"],
    });
    expect(result.errors.some((e) => e.includes("DOUBLON") && e.includes("501109"))).toBe(true);
  });

  it("rejects a 'complete' status with coverage holes", () => {
    const { errors } = checkSuivi(
      input([
        entry({
          sources: [
            {
              code: "501109",
              tomes: ["P00"],
              role: "enseignant",
              pagesTotal: 100,
              pagesLues: [[1, 40]],
            },
          ],
        }),
      ]),
    );
    expect(errors.some((e) => e.includes("100 %"))).toBe(true);
  });

  it("rejects a 'complete' status with first-pass depth (R-5)", () => {
    const { errors } = checkSuivi(input([entry({ profondeur: "first-pass" })]));
    expect(errors.some((e) => e.includes("R-5"))).toBe(true);
  });

  it("rejects overlapping or unsorted page ranges", () => {
    const { errors } = checkSuivi(
      input([
        entry({
          statut: "partielle",
          profondeur: "mixte",
          sources: [
            {
              code: "501109",
              tomes: ["P00"],
              role: "enseignant",
              pagesTotal: 100,
              pagesLues: [
                [10, 30],
                [20, 40],
              ],
            },
          ],
        }),
      ]),
    );
    expect(errors.some((e) => e.includes("chevauchantes"))).toBe(true);
  });

  it("flags an on-disk fiche missing from the registry", () => {
    const { errors } = checkSuivi(input([], ["1ere-base/arabe"]));
    expect(errors.some((e) => e.includes("AUCUNE entrée de suivi"))).toBe(true);
  });

  it("flags a registry entry whose fiche is missing on disk", () => {
    const { errors } = checkSuivi(input([entry({})], []));
    expect(errors.some((e) => e.includes("absent du disque"))).toBe(true);
  });

  it("requires an r7 verdict for validee-r7", () => {
    const { errors } = checkSuivi(input([entry({ statut: "validee-r7", r7: null })]));
    expect(errors.some((e) => e.includes("sans verdict r7"))).toBe(true);
  });

  it("flags citing a tome or code absent from the corpus", () => {
    const { errors } = checkSuivi(
      input([
        entry({
          statut: "partielle",
          profondeur: "mixte",
          sources: [
            {
              code: "999999",
              tomes: ["P00"],
              role: "eleve",
              pagesTotal: null,
              pagesLues: "inconnu",
            },
          ],
        }),
      ]),
    );
    expect(errors.some((e) => e.includes("999999") && e.includes("absente du corpus"))).toBe(true);
  });
});

describe("coverage & derivations", () => {
  it("computes coverage percentage from ranges", () => {
    expect(
      coveragePct({
        code: "501109",
        tomes: ["P00"],
        role: "enseignant",
        pagesTotal: 404,
        pagesLues: [
          [1, 27],
          [86, 112],
          [150, 150],
          [225, 275],
          [316, 404],
        ],
      }),
    ).toBe(48);
  });

  it("derives generation permission from status only", () => {
    expect(generationAutorisee(entry({ statut: "partielle", profondeur: "mixte" }))).toBe(false);
    expect(generationAutorisee(entry({ statut: "complete" }))).toBe(true);
  });

  it("maps corpus documents to grade slots", () => {
    expect(gradeSlotOf(corpus.documents[0])).toBe("1ere-base");
    expect(gradeSlotOf({ ...corpus.documents[0], cycle: "secondaire", classe: 4 })).toBe("bac");
  });
});

describe("renderIndex", () => {
  it("renders a generated index with backlog and totals", () => {
    const index = renderIndex(input([entry({})]));
    expect(index).toContain("GÉNÉRÉ");
    expect(index).toContain("## 1ere-base");
    // 101110 (manuel arabe) is principale and unclaimed → derived backlog.
    expect(index).toContain("`101110`");
    // EPS is annexe → counted as excluded, never in the backlog.
    expect(index).not.toContain("`512101`");
    expect(index).toContain("**Totaux (calculés)**");
  });
});

describe("checkSuivi — lien fiche → sujets (déclaré, jamais deviné)", () => {
  const manifestSubjectsByGrade = { "1ere-base": ["arabe-1ere", "math-1ere"] };

  it("accepte un sujet déclaré qui existe au manifeste du niveau", () => {
    const { errors } = checkSuivi({
      ...input([entry({ sujets: ["arabe-1ere"] })]),
      manifestSubjectsByGrade,
    });
    expect(errors).toEqual([]);
  });

  it("rejette un sujet déclaré absent du manifeste", () => {
    const { errors } = checkSuivi({
      ...input([entry({ sujets: ["arabe-9eme"] })]),
      manifestSubjectsByGrade,
    });
    expect(
      errors.some((e) => e.includes("arabe-9eme") && e.includes("absent de TOUS les manifestes")),
    ).toBe(true);
  });

  // Mutualisation (compileTo, étude 16 D-4) : un manuel qui dessert deux
  // sections produit un sujet compilé par section, et R-4 n'autorise qu'UNE
  // fiche par code source — donc la fiche d'une section doit pouvoir déclarer
  // le sujet compilé de l'autre. Le filet reste entier sur les ids fictifs.
  it("avertit — sans bloquer — quand un sujet déclaré vit dans le manifeste d'un autre niveau", () => {
    const { errors, warnings } = checkSuivi({
      ...input([entry({ sujets: ["math-9eme"] })]),
      manifestSubjectsByGrade: {
        "1ere-base": ["arabe-1ere", "math-1ere"],
        "9eme-base": ["math-9eme"],
      },
    });
    expect(errors).toEqual([]);
    expect(warnings.some((w) => w.includes("math-9eme") && w.includes("mutualisation"))).toBe(true);
  });

  it("rejette encore un sujet absent de TOUS les manifestes", () => {
    const { errors } = checkSuivi({
      ...input([entry({ sujets: ["sujet-inexistant"] })]),
      manifestSubjectsByGrade: {
        "1ere-base": ["arabe-1ere", "math-1ere"],
        "9eme-base": ["math-9eme"],
      },
    });
    expect(
      errors.some(
        (e) => e.includes("sujet-inexistant") && e.includes("absent de TOUS les manifestes"),
      ),
    ).toBe(true);
  });

  it("ne vérifie rien quand les manifestes ne sont pas chargés", () => {
    const { errors } = checkSuivi(input([entry({ sujets: ["nimporte-quoi"] })]));
    expect(errors).toEqual([]);
  });

  it("rejette un sujet déclaré deux fois dans la même fiche", () => {
    const { errors } = checkSuivi(input([entry({ sujets: ["arabe-1ere", "arabe-1ere"] })]));
    expect(errors.some((e) => e.includes("sujet déclaré en double"))).toBe(true);
  });

  describe("chapitresGeneration — la levée R-5 au chapitre ne peut pas être bluffée", () => {
    const manifestChaptersByGrade = {
      "1ere-base": { "arabe-1ere": ["01-alphabet", "02-syllabes"] },
    };
    // Une fiche sous la barre, ce que la levée suppose.
    const trouee = (chapitresGeneration: string[]) =>
      entry({
        statut: "partielle",
        profondeur: "mixte",
        sujets: ["arabe-1ere"],
        chapitresGeneration,
        sources: [
          {
            code: "501109",
            tomes: ["P00"],
            role: "enseignant",
            pagesTotal: 100,
            pagesLues: [[1, 40]],
          },
        ],
      });

    it("accepte des chapitres qui existent au chapitrage du sujet déclaré", () => {
      const { errors } = checkSuivi({
        ...input([trouee(["01-alphabet"])]),
        manifestSubjectsByGrade,
        manifestChaptersByGrade,
      });
      expect(errors).toEqual([]);
    });

    it("rejette un chapitre absent du chapitrage — on ne s'exempte pas sur une fiction", () => {
      const { errors } = checkSuivi({
        ...input([trouee(["99-inventé"])]),
        manifestSubjectsByGrade,
        manifestChaptersByGrade,
      });
      expect(
        errors.some((e) => e.includes("99-invent") && e.includes("absent du chapitrage")),
      ).toBe(true);
    });

    it("rejette une levée déclarée sans lien fiche → contenu", () => {
      const { errors } = checkSuivi(
        input([
          entry({
            statut: "partielle",
            profondeur: "mixte",
            sujets: [],
            chapitresGeneration: ["01-alphabet"],
            sources: [
              {
                code: "501109",
                tomes: ["P00"],
                role: "enseignant",
                pagesTotal: 100,
                pagesLues: [[1, 40]],
              },
            ],
          }),
        ]),
      );
      expect(errors.some((e) => e.includes("sans `sujets`"))).toBe(true);
    });

    it("rejette un chapitre déclaré en double", () => {
      const { errors } = checkSuivi(input([trouee(["01-alphabet", "01-alphabet"])]));
      expect(errors.some((e) => e.includes("double dans chapitresGeneration"))).toBe(true);
    });

    it("rejette une levée sur une fiche réservée par une session", () => {
      const { errors } = checkSuivi(
        input([
          entry({
            statut: "en-cours",
            profondeur: "mixte",
            sujets: ["arabe-1ere"],
            chapitresGeneration: ["01-alphabet"],
          }),
        ]),
      );
      expect(errors.some((e) => e.includes('statut "en-cours"'))).toBe(true);
    });

    it("avertit — sans bloquer — quand la levée est renseignée au-dessus de la barre", () => {
      const { errors, warnings } = checkSuivi(
        input([entry({ chapitresGeneration: ["01-alphabet"], sujets: ["arabe-1ere"] })]),
      );
      expect(errors).toEqual([]);
      expect(warnings.some((w) => w.includes("sans effet"))).toBe(true);
    });
  });

  it("avertit — sans bloquer — quand deux fiches déclarent le même sujet", () => {
    const result = checkSuivi({
      corpus,
      affectations,
      suivis: [
        { grade: "1ere-base", fiches: [entry({ sujets: ["arabe-1ere"] })] },
        {
          grade: "2eme-base",
          fiches: [entry({ matiere: "arabe2", sources: [], sujets: ["arabe-1ere"] })],
        },
      ],
      fichesOnDisk: ["1ere-base/arabe", "2eme-base/arabe2"],
    });
    expect(result.warnings.some((w) => w.includes("est déclaré par"))).toBe(true);
    expect(result.errors.some((e) => e.includes("arabe-1ere"))).toBe(false);
  });
});
