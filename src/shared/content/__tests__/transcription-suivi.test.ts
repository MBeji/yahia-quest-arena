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
