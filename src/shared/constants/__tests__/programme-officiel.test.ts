// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  OFFICIAL_PROGRAMME,
  comingSoonSubjects,
  officialSubjects,
} from "@/shared/constants/programme-officiel";

/**
 * La table du programme officiel est une donnée de référence : ce qui se teste, ce n'est
 * pas « la 5ème a-t-elle bien 7 matières » (une réforme peut le changer, la table est là
 * pour ça) mais les invariants qui la rendent sûre à afficher — un id par matière et par
 * niveau, la convention d'id du lycée, les héritages figés (l'anomalie 9ème), et le
 * filtre qui refuse de doubler une matière déjà ouverte.
 */

/** Les 26 niveaux scolaires sélectionnables (`grades.slug`, thème `ecole-tn`). */
const SELECTABLE_GRADES = [
  "1ere-base",
  "2eme-base",
  "3eme-base",
  "4eme-base",
  "5eme-base",
  "6eme-base",
  "7eme-base",
  "8eme-base",
  "9eme-base",
  "1ere-sec",
  "2eme-sec-sciences",
  "2eme-sec-lettres",
  "2eme-sec-eco-services",
  "2eme-sec-info",
  "3eme-sec-math",
  "3eme-sec-sciences-exp",
  "3eme-sec-lettres",
  "3eme-sec-eco-gestion",
  "3eme-sec-techniques",
  "3eme-sec-info",
  "bac-math",
  "bac-sciences-exp",
  "bac-lettres",
  "bac-eco-gestion",
  "bac-techniques",
  "bac-info",
];

const LYCEE_GRADES = SELECTABLE_GRADES.filter((g) => !g.endsWith("-base"));

describe("programme officiel — couverture", () => {
  it("déclare les 26 niveaux scolaires, et rien d'autre", () => {
    expect(Object.keys(OFFICIAL_PROGRAMME).sort()).toEqual([...SELECTABLE_GRADES].sort());
  });

  it("ne déclare jamais un niveau vide", () => {
    for (const [grade, subjects] of Object.entries(OFFICIAL_PROGRAMME)) {
      expect(subjects.length, grade).toBeGreaterThan(0);
    }
  });

  it("donne à chaque niveau les langues du tronc (arabe, français, anglais)", () => {
    for (const grade of SELECTABLE_GRADES) {
      // Le français entre en 3ème année et l'anglais en 4ème : les deux premières
      // années du primaire sont tout en arabe.
      const expected =
        grade === "1ere-base" || grade === "2eme-base"
          ? ["ar"]
          : grade === "3eme-base"
            ? ["ar", "fr"]
            : ["ar", "fr", "en"];
      const langs = new Set(officialSubjects(grade).map((s) => s.contentLanguage));
      for (const lang of expected) expect([...langs], grade).toContain(lang);
    }
  });
});

describe("programme officiel — invariants d'id", () => {
  it("un id est unique dans son niveau", () => {
    for (const [grade, subjects] of Object.entries(OFFICIAL_PROGRAMME)) {
      const ids = subjects.map((s) => s.id);
      expect(new Set(ids).size, grade).toBe(ids.length);
    }
  });

  it("tout id est un slug kebab-case et tout intitulé est non vide", () => {
    for (const subjects of Object.values(OFFICIAL_PROGRAMME)) {
      for (const s of subjects) {
        expect(s.id).toMatch(/^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/);
        expect(s.name.trim().length).toBeGreaterThan(0);
      }
    }
  });

  it("un id du lycée se termine par le slug de son niveau (convention verbatim)", () => {
    for (const grade of LYCEE_GRADES) {
      for (const s of officialSubjects(grade))
        expect(s.id, grade).toMatch(new RegExp(`-${grade}$`));
    }
  });

  it("garde les ids nus de la 9ème, anomalie `svt` comprise", () => {
    const byId = new Map(officialSubjects("9eme-base").map((s) => [s.id, s]));
    // `svt` EST la matière « sciences physiques » ; la vraie SVT est `sciences-vie-terre`.
    expect(byId.get("svt")?.name).toBe("العلوم الفيزيائية");
    expect(byId.get("sciences-vie-terre")?.name).toBe("علوم الحياة والأرض");
    for (const id of ["math", "arabic", "french", "english"]) expect(byId.has(id)).toBe(true);
  });

  it("n'invente pas d'id suffixé pour une matière déjà nommée par le manifeste", () => {
    // Le manifeste de programme du repo privé déclare `arabe-1ere-sec` (et non `arabic-…`).
    const ids = officialSubjects("1ere-sec").map((s) => s.id);
    expect(ids).toContain("arabe-1ere-sec");
    expect(ids).not.toContain("arabic-1ere-sec");
  });

  it("laisse les matières hors périmètre (sport, musique, dessin) hors du menu", () => {
    const excluded = /^(sport|education-physique|musique|education-musicale|arts|dessin)-/;
    for (const subjects of Object.values(OFFICIAL_PROGRAMME)) {
      for (const s of subjects) expect(s.id).not.toMatch(excluded);
    }
  });
});

describe("programme officiel — langue d'enseignement", () => {
  it("bascule les sciences de l'arabe (collège) au français (lycée)", () => {
    const college = officialSubjects("9eme-base").find((s) => s.id === "math");
    expect(college?.contentLanguage).toBe("ar");
    const lycee = officialSubjects("bac-math").find((s) => s.id === "math-bac-math");
    expect(lycee?.contentLanguage).toBe("fr");
  });

  it("garde les humanités du lycée en arabe", () => {
    const philo = officialSubjects("bac-lettres").find((s) => s.id === "philosophie-bac-lettres");
    expect(philo?.contentLanguage).toBe("ar");
  });
});

describe("comingSoonSubjects", () => {
  it("retire les matières déjà ouvertes et garde l'ordre du programme", () => {
    const present = ["math-1ere", "arabic-1ere"];
    const soon = comingSoonSubjects("1ere-base", present);
    expect(soon.map((s) => s.id)).toEqual(["eveil-scientifique-1ere", "education-islamique-1ere"]);
  });

  it("rend le programme entier quand le catalogue est vide", () => {
    const soon = comingSoonSubjects("bac-info", []);
    expect(soon).toEqual(officialSubjects("bac-info"));
  });

  it("rend une liste vide pour un parcours sans niveau (les extras `libre`)", () => {
    expect(comingSoonSubjects(null, [])).toEqual([]);
    expect(comingSoonSubjects(undefined, [])).toEqual([]);
  });

  it("rend une liste vide pour un niveau inconnu plutôt que d'échouer", () => {
    expect(comingSoonSubjects("niveau-inexistant", [])).toEqual([]);
  });

  it("ne double jamais une matière du catalogue — cas des sujets mutualisés du bac", () => {
    // english-bac-math / french-bac-math sont compilés depuis un dossier commun : la
    // table doit les reconnaître sous leur id compilé, pas sous celui du dossier source.
    const soon = comingSoonSubjects("bac-math", [
      "math-bac-math",
      "english-bac-math",
      "french-bac-math",
    ]);
    expect(soon.map((s) => s.id)).not.toContain("english-bac-math");
    expect(soon.map((s) => s.id)).not.toContain("french-bac-math");
    expect(soon.map((s) => s.id)).toContain("philosophie-bac-math");
  });
});
