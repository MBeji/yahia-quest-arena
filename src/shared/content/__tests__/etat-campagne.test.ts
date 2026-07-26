import { describe, expect, it } from "vitest";
import { buildEtat, renderEtat, type EtatInput } from "../etat-campagne.ts";
import type { GradeAudit, SubjectAudit } from "../program-manifest.ts";
import type { Affectations, Corpus, FicheEntry, SuiviGrade } from "../transcription-suivi.ts";
import type { OuvertureLue } from "../parcours-ouverture.ts";

const corpus: Corpus = {
  generatedFrom: "test",
  count: 2,
  documents: [
    {
      code: "502304",
      tome: "P00",
      cycle: "base",
      role: "enseignant",
      classe: 4,
      matiere: "23",
      titre: "Guide maths 4ème",
      fichier: "502304P00.pdf",
      octets: 1,
    },
    // Not claimed by any fiche → backlog of the `9eme-base` slot.
    {
      code: "502309",
      tome: "P00",
      cycle: "base",
      role: "enseignant",
      classe: 9,
      matiere: "23",
      titre: "Guide maths 9ème",
      fichier: "502309P00.pdf",
      octets: 1,
    },
  ],
};

const affectations: Affectations = {
  matieres: { "23": { id: "math", categorie: "principale" } },
  overrides: {},
};

function fiche(overrides: Partial<FicheEntry>): FicheEntry {
  return {
    matiere: "mathematiques",
    statut: "complete",
    profondeur: "generation",
    sources: [
      {
        code: "502304",
        tomes: ["P00"],
        role: "enseignant",
        pagesTotal: 100,
        pagesLues: "integral",
      },
    ],
    sourcesLibres: [],
    sujets: ["math-4eme"],
    r7: null,
    maj: "2026-07-26",
    par: "test",
    notes: "",
    ...overrides,
  };
}

function sujet(overrides: Partial<SubjectAudit> = {}): SubjectAudit {
  return {
    id: "math-4eme",
    present: true,
    languageOk: true,
    chaptersCodified: true,
    expectedChapters: 4,
    presentExpected: 4,
    missingChapters: [],
    offProgramChapters: [],
    chapterCompleteness: [],
    coveragePct: 100,
    findings: [],
    ...overrides,
  };
}

function audit(overrides: Partial<GradeAudit> = {}): GradeAudit {
  return { grade: "4eme-base", sealed: false, subjects: [sujet()], findingCount: 0, ...overrides };
}

function input(
  suivis: SuiviGrade[],
  audits: GradeAudit[],
  onlyGrade?: string,
  ouvertures?: OuvertureLue,
): EtatInput {
  return {
    corpus,
    affectations,
    suivis,
    fichesOnDisk: suivis.flatMap((s) => s.fiches.map((f) => `${s.grade}/${f.matiere}`)),
    audits,
    onlyGrade,
    ouvertures,
  };
}

/** Ouverture d'un seul parcours, telle que `readOuvertures` la rendrait. */
function ouverture(statut: "available" | "coming_soon" | null): OuvertureLue {
  return {
    parcours: [
      { id: "ecole-4eme-base", grade: "4eme-base", statut, migration: "20260101000000_seed.sql" },
    ],
    ouvertsSansSeed: [],
  };
}

const gradeSuivi = (fiches: FicheEntry[], grade = "4eme-base"): SuiviGrade => ({ grade, fiches });

describe("buildEtat — jointure fiche × contenu", () => {
  it("joint la fiche à son sujet déclaré, sans constat quand tout est en place", () => {
    const etat = buildEtat(input([gradeSuivi([fiche({})])], [audit()]));
    const couple = etat.grades[0].couples[0];
    expect(couple.matiere).toBe("mathematiques");
    expect(couple.fiche?.generationAutorisee).toBe(true);
    expect(couple.fiche?.couverturePct).toBe(100);
    expect(couple.sujets.map((s) => s.id)).toEqual(["math-4eme"]);
    expect(couple.constats).toEqual([]);
  });

  it("signale une fiche sans lien déclaré — sans deviner le sujet", () => {
    const etat = buildEtat(input([gradeSuivi([fiche({ sujets: [] })])], [audit()]));
    const couple = etat.grades[0].couples[0];
    expect(couple.sujets).toEqual([]);
    expect(couple.lienDeclare).toBe(false);
    expect(etat.totaux.fichesSansLien).toBe(1);
    // Le sujet du manifeste que personne ne déclare apparaît comme couple orphelin.
    const orphelin = etat.grades[0].couples.find((c) => c.matiere === null);
    expect(orphelin?.sujets.map((s) => s.id)).toEqual(["math-4eme"]);
  });

  it("signale une fiche exploitable dont le contenu n'existe pas encore", () => {
    const etat = buildEtat(
      input([gradeSuivi([fiche({})])], [audit({ subjects: [sujet({ present: false })] })]),
    );
    expect(etat.grades[0].couples[0].constats).toContain("fiche exploitable, aucun contenu généré");
  });

  it("signale du contenu généré sur une fiche sous la barre R-5", () => {
    const etat = buildEtat(
      input([gradeSuivi([fiche({ statut: "partielle", profondeur: "first-pass" })])], [audit()]),
    );
    const couple = etat.grades[0].couples[0];
    expect(couple.fiche?.generationAutorisee).toBe(false);
    expect(couple.constats.join(" ")).toContain("sous la barre R-5");
  });

  it("signale un sujet déclaré qui n'existe pas au manifeste du niveau", () => {
    const etat = buildEtat(input([gradeSuivi([fiche({ sujets: ["math-9eme"] })])], [audit()]));
    expect(etat.grades[0].couples[0].constats).toContain(
      "sujet déclaré « math-9eme » absent du manifeste 4eme-base",
    );
  });

  it("distingue « absent du manifeste » de « manifeste non chargé »", () => {
    const etat = buildEtat(input([gradeSuivi([fiche({})])], []));
    expect(etat.grades[0].manifeste).toBe(false);
    expect(etat.grades[0].couples[0].constats).toContain(
      "sujet déclaré « math-4eme » invérifiable : aucun manifeste 4eme-base",
    );
  });

  it("rapporte les trous de lecture, source par source", () => {
    const etat = buildEtat(
      input(
        [
          gradeSuivi([
            fiche({
              statut: "partielle",
              profondeur: "mixte",
              sources: [
                {
                  code: "502304",
                  tomes: ["P00"],
                  role: "enseignant",
                  pagesTotal: 100,
                  pagesLues: [[1, 60]],
                },
              ],
            }),
          ]),
        ],
        [audit()],
      ),
    );
    expect(etat.grades[0].couples[0].fiche?.trous).toEqual(["502304 p.61–100"]);
    expect(etat.grades[0].couples[0].fiche?.couverturePct).toBe(60);
  });
});

describe("buildEtat — périmètre et dérivations", () => {
  it("restreint le RAPPORT à un niveau sans fausser le reliquat de corpus", () => {
    // La fiche de 4eme-base revendique 502304. Filtrer sur 9eme-base ne doit pas
    // faire réapparaître cette œuvre comme « à rattacher ».
    const etat = buildEtat(
      input([gradeSuivi([fiche({})]), gradeSuivi([], "9eme-base")], [], "9eme-base"),
    );
    expect(etat.grades.map((g) => g.grade)).toEqual(["9eme-base"]);
    const codes = etat.aRattacher.flatMap((c) => c.matieres.flatMap((m) => m.codes));
    expect(codes).toEqual(["502309"]);
    expect(codes).not.toContain("502304");
  });

  it("compte les totaux sans jamais classer les couples par priorité", () => {
    const etat = buildEtat(
      input(
        [gradeSuivi([fiche({}), fiche({ matiere: "arabe", statut: "partielle", sujets: [] })])],
        [audit({ subjects: [sujet(), sujet({ id: "arabe-4eme", present: false })] })],
      ),
    );
    expect(etat.totaux).toMatchObject({
      fiches: 2,
      fichesGenerables: 1,
      sujetsAttendus: 2,
      sujetsPresents: 1,
      fichesSansLien: 1,
    });
    expect(etat.totaux.oeuvresARattacher).toBe(1);
    // Ordre = registre (alphabétique dans le niveau), pas un ordre de priorité.
    expect(etat.grades[0].couples.map((c) => c.matiere)).toEqual(["arabe", "mathematiques", null]);
  });
});

describe("renderEtat", () => {
  it("dit explicitement qu'aucune priorité n'est calculée", () => {
    const rendu = renderEtat(buildEtat(input([gradeSuivi([fiche({})])], [audit()])));
    expect(rendu).toContain("Aucune priorité n'est calculée ici");
    expect(rendu).toContain("fiche mathematiques");
    expect(rendu).toContain("math-4eme");
  });

  it("marque la génération interdite et les sujets absents du contenu", () => {
    const rendu = renderEtat(
      buildEtat(
        input(
          [gradeSuivi([fiche({ statut: "partielle", profondeur: "first-pass" })])],
          [audit({ subjects: [sujet({ present: false })] })],
        ),
      ),
    );
    expect(rendu).toContain("⛔ génération interdite");
    expect(rendu).toContain("ABSENT de content/");
  });

  it("regroupe les liens manquants et les sujets orphelins en fin de niveau", () => {
    const rendu = renderEtat(
      buildEtat(
        input(
          [gradeSuivi([fiche({ sujets: [] }), fiche({ matiere: "arabe", sujets: [] })])],
          [audit()],
        ),
      ),
    );
    // Une seule ligne pour les deux fiches, pas une par fiche.
    expect(rendu).toContain(
      "! lien fiche → sujets non déclaré (`sujets: []`) : arabe, mathematiques",
    );
    expect(rendu.match(/lien fiche/g)).toHaveLength(1);
    expect(rendu).toContain("sujet sans fiche déclarée — math-4eme");
  });
});

describe("prochaineEtape — la méthode appliquée à un couple, jamais un rang", () => {
  const etapeDe = (suivis: SuiviGrade[], audits: GradeAudit[], i = 0) =>
    buildEtat(input(suivis, audits)).grades[0].couples[i].prochaineEtape;

  it("bloque un couple réservé par une autre session", () => {
    const e = etapeDe(
      [gradeSuivi([fiche({ statut: "en-cours", profondeur: "first-pass" })])],
      [audit()],
    );
    expect(e).toMatchObject({ lot: null, bloquant: true });
    expect(e.action).toContain("réservé");
  });

  it("renvoie en A3 tant que la barre R-5 n'est pas franchie — et le marque bloquant", () => {
    const e = etapeDe(
      [
        gradeSuivi([
          fiche({
            statut: "partielle",
            profondeur: "mixte",
            sources: [
              {
                code: "502304",
                tomes: ["P00"],
                role: "enseignant",
                pagesTotal: 100,
                pagesLues: [[1, 40]],
              },
            ],
          }),
        ]),
      ],
      [audit()],
    );
    expect(e).toMatchObject({ lot: "A", etape: "A3", bloquant: true });
    expect(e.motif).toContain("40 %");
  });

  it("demande le lien avant de statuer sur le contenu", () => {
    const e = etapeDe([gradeSuivi([fiche({ sujets: [] })])], [audit()]);
    expect(e).toMatchObject({ lot: "A", etape: "A5.4", bloquant: false });
  });

  it("envoie en B1 quand la fiche est exploitable et le sujet absent", () => {
    const e = etapeDe(
      [gradeSuivi([fiche({})])],
      [audit({ subjects: [sujet({ present: false })] })],
    );
    expect(e).toMatchObject({ lot: "B", etape: "B1" });
    expect(e.action).toContain("math-4eme");
  });

  it("envoie en B2 sur les chapitres manquants, puis sur les incomplets", () => {
    const manquants = etapeDe(
      [gradeSuivi([fiche({})])],
      [audit({ subjects: [sujet({ presentExpected: 2, missingChapters: ["03-a", "04-b"] })] })],
    );
    expect(manquants).toMatchObject({ lot: "B", etape: "B2" });
    expect(manquants.action).toContain("03-a");

    const incomplets = etapeDe(
      [gradeSuivi([fiche({})])],
      [
        audit({
          subjects: [
            sujet({
              chapterCompleteness: [
                {
                  slug: "01-x",
                  hasCourse: true,
                  hasSummary: false,
                  hasQuiz: true,
                  exerciseCount: 1,
                  hasBoss: false,
                  complete: false,
                  issues: ["résumé manquant"],
                },
              ],
            }),
          ],
        }),
      ],
    );
    expect(incomplets.action).toContain("01-x");
  });

  it("ne prescrit rien quand la fiche est exploitable et le contenu complet", () => {
    const e = etapeDe([gradeSuivi([fiche({})])], [audit()]);
    expect(e).toMatchObject({ lot: null, etape: null, bloquant: false });
    expect(e.action).toContain("rien à faire");
  });

  it("rattache un sujet orphelin selon qu'il a du contenu ou non", () => {
    // Sujet présent dans content/ mais qu'aucune fiche ne déclare : le scope
    // existe quelque part, il n'est pas tracé — on rattache (A5.4).
    const avecContenu = buildEtat(input([gradeSuivi([])], [audit()]));
    expect(avecContenu.grades[0].couples[0].prochaineEtape).toMatchObject({
      lot: "A",
      etape: "A5.4",
    });
    // Ni fiche ni contenu : il faut transcrire la source (A1).
    const vierge = buildEtat(
      input([gradeSuivi([])], [audit({ subjects: [sujet({ present: false })] })]),
    );
    expect(vierge.grades[0].couples[0].prochaineEtape).toMatchObject({ lot: "A", etape: "A1" });
  });

  it("n'apparaît pas dans le rendu quand il n'y a rien à faire", () => {
    const rendu = renderEtat(buildEtat(input([gradeSuivi([fiche({})])], [audit()])));
    // L'en-tête cite « [LOT …] » pour expliquer la notation : c'est une étape
    // RÉELLE (A/B) qu'on ne doit pas voir.
    expect(rendu).not.toContain("[LOT A");
    expect(rendu).not.toContain("[LOT B");
    expect(rendu).toContain("pas de le choisir");
  });
});

describe("buildEtat — volet prod : l'ouverture des parcours (R-8)", () => {
  it("ne dit rien quand les migrations ne sont pas fournies", () => {
    const etat = buildEtat(input([gradeSuivi([fiche({})])], [audit()]));
    // `null` ≠ « pas ouvert » : la question n'a pas été posée.
    expect(etat.grades[0].ouverture).toBeNull();
    expect(etat.grades[0].constats).toEqual([]);
    expect(etat.totaux.parcoursANouvrir).toBe(0);
  });

  it("signale un contenu complet derrière un parcours resté coming_soon", () => {
    const etat = buildEtat(
      input([gradeSuivi([fiche({})])], [audit()], undefined, ouverture("coming_soon")),
    );
    const grade = etat.grades[0];
    expect(grade.ouverture).toEqual([
      expect.objectContaining({ id: "ecole-4eme-base", statut: "coming_soon" }),
    ]);
    expect(grade.constats).toHaveLength(1);
    expect(grade.constats[0]).toContain("R-8 : 4 chapitre(s) complet(s)");
    expect(grade.constats[0]).toContain("invisible aux élèves");
    expect(etat.totaux.parcoursANouvrir).toBe(1);
  });

  it("ne signale rien quand le parcours est ouvert", () => {
    const etat = buildEtat(
      input([gradeSuivi([fiche({})])], [audit()], undefined, ouverture("available")),
    );
    expect(etat.grades[0].constats).toEqual([]);
    expect(etat.totaux.parcoursANouvrir).toBe(0);
  });

  it("attend un chapitre COMPLET : des chapitres tous incomplets n'ouvrent rien", () => {
    const incomplets = audit({
      subjects: [
        sujet({
          chapterCompleteness: [
            {
              slug: "01-a",
              hasCourse: true,
              hasSummary: true,
              hasQuiz: false,
              exerciseCount: 0,
              hasBoss: false,
              complete: false,
              issues: ["quiz manquant"],
            },
            {
              slug: "02-b",
              hasCourse: true,
              hasSummary: true,
              hasQuiz: false,
              exerciseCount: 0,
              hasBoss: false,
              complete: false,
              issues: ["quiz manquant"],
            },
            {
              slug: "03-c",
              hasCourse: true,
              hasSummary: true,
              hasQuiz: false,
              exerciseCount: 0,
              hasBoss: false,
              complete: false,
              issues: ["quiz manquant"],
            },
            {
              slug: "04-d",
              hasCourse: true,
              hasSummary: true,
              hasQuiz: false,
              exerciseCount: 0,
              hasBoss: false,
              complete: false,
              issues: ["quiz manquant"],
            },
          ],
        }),
      ],
    });
    const etat = buildEtat(
      input([gradeSuivi([fiche({})])], [incomplets], undefined, ouverture("coming_soon")),
    );
    expect(etat.grades[0].constats).toEqual([]);
  });

  it("dit « statut inconnu » plutôt que de trancher, et le rend visible", () => {
    const etat = buildEtat(input([gradeSuivi([fiche({})])], [audit()], undefined, ouverture(null)));
    expect(etat.grades[0].constats[0]).toContain("statut illisible");
    const rendu = renderEtat(etat);
    expect(rendu).toContain("prod — ecole-4eme-base : statut inconnu");
    expect(rendu).toContain("1 parcours à ouvrir");
  });
});
