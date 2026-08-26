// @vitest-environment node
import { describe, it, expect } from "vitest";
import { domainKey, DOMAIN_LABEL_MAX } from "../chapter-domain";
import { chapterMetaSchema } from "../schema";
import { buildMigrationSql } from "../sql-builder";
import { auditChapterDomains } from "../../../../scripts/content/qa-checks.ts";

/**
 * Les domaines de programme (« sections » d'une matière : Algèbre / Géométrie,
 * قواعد اللغة / فهم المقروء) traversent quatre étages — identité, schéma
 * d'écriture, SQL compilé, QA. Ce fichier tient les quatre bout à bout ; le
 * regroupement à l'écran, lui, est testé dans `shared/lib/subject-domains`.
 */

describe("domainKey — l'identité d'un domaine de programme", () => {
  it("plie la casse et les accents latins", () => {
    expect(domainKey("Géométrie")).toBe(domainKey("geometrie"));
    expect(domainKey("ALGÈBRE")).toBe(domainKey("algebre"));
  });

  it("plie le tashkil, le tatweel et les variantes de lettres arabes", () => {
    expect(domainKey("قواعد اللّغة")).toBe(domainKey("قواعد اللغه"));
    expect(domainKey("الهندسـة")).toBe(domainKey("الهندسة"));
    expect(domainKey("أنشطة عددية")).toBe(domainKey("انشطة عددية"));
  });

  it("plie la ponctuation et les espaces multiples", () => {
    expect(domainKey("Activités  numériques")).toBe(domainKey("activités-numériques"));
  });

  it("ne confond PAS deux domaines réellement différents", () => {
    expect(domainKey("Algèbre")).not.toBe(domainKey("Géométrie"));
    expect(domainKey("قواعد اللغة")).not.toBe(domainKey("فهم المقروء"));
    // Un pluriel n'est pas une graphie : deux libellés qui diffèrent d'une lettre
    // restent deux domaines, et c'est à l'auteur de trancher.
    expect(domainKey("Fonction")).not.toBe(domainKey("Fonctions"));
  });

  it("ne rend jamais la clé réservée au groupe des non rattachés", () => {
    // `subject-domains` réserve `domain:none` ; la clé d'un vrai domaine ne peut
    // pas contenir de « : », toute ponctuation étant réduite à une coupure de mot.
    for (const label of ["domain:none", "Domain: none", "a:b"]) {
      expect(domainKey(label)).not.toContain(":");
    }
  });
});

describe("chapterMetaSchema — le champ `domain` de chapter.json", () => {
  const base = { title: "Thalès", description: "La configuration", displayOrder: 1 };

  it("est facultatif — une matière non sectionnée n'écrit rien", () => {
    const parsed = chapterMetaSchema.parse(base);
    expect(parsed.domain).toBeUndefined();
  });

  it("accepte un libellé dans la langue de la matière", () => {
    expect(chapterMetaSchema.parse({ ...base, domain: "Géométrie" }).domain).toBe("Géométrie");
    expect(chapterMetaSchema.parse({ ...base, domain: "قواعد اللغة" }).domain).toBe("قواعد اللغة");
  });

  it("refuse un libellé vide, à espaces de bord, ou long comme une phrase", () => {
    expect(chapterMetaSchema.safeParse({ ...base, domain: "" }).success).toBe(false);
    expect(chapterMetaSchema.safeParse({ ...base, domain: " Géométrie" }).success).toBe(false);
    expect(chapterMetaSchema.safeParse({ ...base, domain: "Géométrie " }).success).toBe(false);
    expect(
      chapterMetaSchema.safeParse({ ...base, domain: "x".repeat(DOMAIN_LABEL_MAX + 1) }).success,
    ).toBe(false);
  });
});

// --------------------------------------------------------------------------
// sql-builder — le domaine voyage dans le SQL compilé, comme le titre.
// --------------------------------------------------------------------------

const subjectWith = (domain?: string) => ({
  meta: {
    id: "math",
    nameFr: "Mathématiques",
    description: "desc",
    attribute: "Force" as const,
    colorToken: "subject-math",
    icon: "Calculator",
    displayOrder: 1,
    contentLanguage: "fr" as const,
    themeId: "ecole-tn",
    gradeSlug: "9eme-base",
    isPremium: false,
  },
  chapters: [
    {
      slug: "01-thales",
      meta: {
        title: "Thalès",
        description: "d",
        displayOrder: 1,
        sources: [],
        ...(domain ? { domain } : {}),
      },
      lesson: "# cours",
      summary: "## résumé",
      quiz: {
        questions: [
          {
            type: "mcq" as const,
            prompt: "q ?",
            options: [
              { id: "a", text: "1" },
              { id: "b", text: "2" },
            ],
            correctOption: "a",
            explanation: "parce que",
          },
        ],
      },
      exercises: [],
    },
  ],
});

describe("sql-builder — chapters.domain", () => {
  it("compile le domaine déclaré", () => {
    const sql = buildMigrationSql(subjectWith("Géométrie"));
    expect(sql).toContain("display_order, domain, manuel_ref, videos) VALUES");
    expect(sql).toContain("'Géométrie'");
    expect(sql).toContain("domain = EXCLUDED.domain");
  });

  it("compile NULL quand le chapitre n'en déclare aucun — retirer le champ efface la colonne", () => {
    // La colonne est TOUJOURS écrite : sans cela, un chapitre qui perd son domaine
    // garderait l'ancien à la ré-application, et le hub le rangerait dans une
    // section que le contenu ne déclare plus.
    const sql = buildMigrationSql(subjectWith());
    expect(sql).toMatch(/, 1, NULL, NULL, '\[\]'::jsonb\)/);
    expect(sql).toContain("domain = EXCLUDED.domain");
  });

  it("échappe une apostrophe dans le libellé", () => {
    expect(buildMigrationSql(subjectWith("Géométrie de l'espace"))).toContain(
      "'Géométrie de l''espace'",
    );
  });
});

// --------------------------------------------------------------------------
// content:qa — la seule passe qui puisse voir une matière mal sectionnée.
// --------------------------------------------------------------------------

describe("auditChapterDomains", () => {
  const where = "math/domaines";

  it("ne dit rien d'une matière proprement sectionnée", () => {
    expect(
      auditChapterDomains(
        [
          { slug: "01", domain: "Algèbre" },
          { slug: "02", domain: "Géométrie" },
          { slug: "03", domain: "Algèbre" },
        ],
        where,
        "9eme-base",
      ),
    ).toEqual([]);
  });

  it("ne dit rien d'une matière sans aucun domaine — l'état du corpus au jour de la colonne", () => {
    expect(auditChapterDomains([{ slug: "01" }, { slug: "02" }], where, "9eme-base")).toEqual([]);
  });

  it("refuse deux graphies d'un même domaine, et nomme celle qui survivra", () => {
    const flags = auditChapterDomains(
      [
        { slug: "01", domain: "Géométrie" },
        { slug: "02", domain: "geometrie" },
        { slug: "03", domain: "Algèbre" },
      ],
      where,
      "9eme-base",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0]?.level).toBe("error");
    expect(flags[0]?.msg).toContain('"Géométrie"');
    expect(flags[0]?.msg).toContain('"geometrie"');
  });

  it("signale un rattachement partiel, sans le refuser", () => {
    const flags = auditChapterDomains(
      [
        { slug: "01", domain: "Grammaire" },
        { slug: "02", domain: "Compréhension" },
        { slug: "03" },
      ],
      where,
      "9eme-base",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0]?.level).toBe("warn");
    expect(flags[0]?.msg).toContain("03");
  });

  it("signale un domaine unique — il ne groupe rien", () => {
    const flags = auditChapterDomains(
      [
        { slug: "01", domain: "Grammaire" },
        { slug: "02", domain: "Grammaire" },
      ],
      where,
      "9eme-base",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0]?.level).toBe("warn");
    expect(flags[0]?.msg).toContain("Grammaire");
  });

  it("refuse un domaine sur une matière HORS programme scolaire", () => {
    // Une matière sans niveau (parcours libre) n'a pas de programme officiel dont
    // tirer des sections : ce qu'on y écrirait serait un découpage inventé.
    const flags = auditChapterDomains(
      [
        { slug: "01", domain: "العبادات" },
        { slug: "02", domain: "المعاملات" },
      ],
      where,
      null,
    );
    expect(flags).toHaveLength(1);
    expect(flags[0]?.level).toBe("error");
    expect(flags[0]?.msg).toContain("no grade");
  });

  it("laisse tranquille une matière hors programme qui ne déclare rien", () => {
    expect(auditChapterDomains([{ slug: "01" }, { slug: "02" }], where, null)).toEqual([]);
  });

  it("ne signale rien sur une matière à chapitre unique", () => {
    expect(auditChapterDomains([{ slug: "01", domain: "Grammaire" }], where, "9eme-base")).toEqual(
      [],
    );
  });
});
