// @vitest-environment node
import { describe, it, expect } from "vitest";
import { mkdtempSync, mkdirSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";
import {
  auditVerbatim,
  buildVerbatimIndex,
  DEFAULT_NGRAM,
  findVerbatimHits,
  foldMarks,
  isSurveilled,
  parseProvenance,
  questionTextSurface,
  stripProvenanceHeader,
  tokenise,
  wordNgrams,
} from "../../../../scripts/content/verbatim-checks.ts";
import { loadSurveilledSources } from "../../../../scripts/content/programmes-io.ts";

/**
 * Étude 27 lot 2 — la garde anti-verbatim. Ce que ces tests protègent, dans
 * l'ordre d'importance : (1) une copie est détectée, (2) une paraphrase et une
 * formule partagée ne le sont PAS — un gate qui crie au loup se désarme tout
 * seul —, (3) l'absence d'autorisation met par défaut sous surveillance.
 */

const SOURCE = `
url: https://exemple.tn/serie-forces
titulaire: inconnu
autorisation: aucune
tier: T2-prime

## Exercice 3

Un solide de masse 250 g est posé sur un plan incliné faisant un angle de 30°
avec l'horizontale. Déterminer la valeur de la réaction normale du support en
négligeant tout frottement.
`;

const index = () => buildVerbatimIndex([{ slug: "web-exemple", text: SOURCE }]);

describe("parseProvenance — l'en-tête de la fiche source-web", () => {
  it("lit les paires clé: valeur où qu'elles soient", () => {
    const p = parseProvenance(SOURCE);
    expect(p.url).toBe("https://exemple.tn/serie-forces");
    expect(p.autorisation).toBe("aucune");
    expect(p.tier).toBe("T2-prime");
  });

  it("garde la première occurrence d'une clé répétée", () => {
    expect(parseProvenance("autorisation: aucune\nautorisation: accordée").autorisation).toBe(
      "aucune",
    );
  });

  it("ignore une clé sans valeur", () => {
    expect(parseProvenance("autorisation:\n").autorisation).toBeUndefined();
  });
});

describe("isSurveilled — le défaut est sûr", () => {
  it("surveille une source sans autorisation", () => {
    expect(isSurveilled({})).toBe(true);
    expect(isSurveilled({ autorisation: "aucune" })).toBe(true);
    expect(isSurveilled({ autorisation: "demandee le 13/08" })).toBe(true);
  });

  it("lève la surveillance sur une autorisation accordée, accentuée ou non", () => {
    expect(isSurveilled({ autorisation: "accordée le 13/08 par X" })).toBe(false);
    expect(isSurveilled({ autorisation: "Accordee le 13/08" })).toBe(false);
  });

  it("surveille une autorisation rédigée d'une façon qu'on ne sait pas lire", () => {
    expect(isSurveilled({ autorisation: "voir le mail de Karim" })).toBe(true);
  });
});

describe("tokenise — ce qui sort du calcul", () => {
  it("plie accents et tashkîl", () => {
    expect(foldMarks("négligeant")).toBe("negligeant");
    expect(tokenise("Déterminer")).toEqual(["determiner"]);
    expect(tokenise("الكِتَابُ").join(" ")).toBe(foldMarks("الكتاب"));
  });

  it("écarte les nombres et garde les mots", () => {
    expect(tokenise("une masse de 250 g")).toEqual(["une", "masse", "de"]);
    expect(tokenise("une masse de 45 g")).toEqual(["une", "masse", "de"]);
  });

  it("retire figures, maths et code — pas la prose autour", () => {
    expect(tokenise('avant <svg viewBox="0 0 4 4"><circle/></svg> apres')).toEqual([
      "avant",
      "apres",
    ]);
    expect(tokenise("le calcul $$x^2 + y^2$$ conclut")).toEqual(["le", "calcul", "conclut"]);
    expect(tokenise("la fraction \\dfrac{BC}{2} vaut")).toEqual(["la", "fraction", "vaut"]);
    expect(tokenise("le code `npm run verify` passe")).toEqual(["le", "code", "passe"]);
  });

  it("garde le libellé d'un lien, jette sa cible", () => {
    expect(tokenise("voir [le programme](https://cnp.com.tn/x.pdf) officiel")).toEqual([
      "voir",
      "le",
      "programme",
      "officiel",
    ]);
  });
});

describe("wordNgrams", () => {
  it("glisse sur la suite de jetons", () => {
    expect(wordNgrams(["a", "b", "c"], 2)).toEqual(["a b", "b c"]);
  });

  it("ne rend rien sous la longueur demandée", () => {
    expect(wordNgrams(["a", "b"], 3)).toEqual([]);
  });
});

describe("buildVerbatimIndex", () => {
  it("n'indexe pas l'en-tête de provenance", () => {
    const grams = [...buildVerbatimIndex([{ slug: "s", text: SOURCE }]).grams.keys()];
    expect(grams.some((g) => g.includes("autorisation"))).toBe(false);
    expect(grams.some((g) => g.includes("titulaire"))).toBe(false);
  });

  it("attribue chaque séquence à sa source", () => {
    const built = buildVerbatimIndex([{ slug: "web-exemple", text: SOURCE }]);
    expect(new Set(built.grams.values())).toEqual(new Set(["web-exemple"]));
    expect(built.n).toBe(DEFAULT_NGRAM);
  });

  it("reste vide pour une source autorisée écartée en amont", () => {
    expect(buildVerbatimIndex([]).grams.size).toBe(0);
  });
});

describe("stripProvenanceHeader", () => {
  it("conserve les encadrés verbatim de la fiche (R-5), qui sont le vrai risque", () => {
    const kept = stripProvenanceHeader(SOURCE);
    expect(kept).toContain("plan incliné");
    expect(kept).not.toContain("autorisation:");
  });
});

describe("auditVerbatim — le cœur du gate", () => {
  it("détecte une reprise mot pour mot", () => {
    const flags = auditVerbatim(
      "Un solide de masse 900 g est posé sur un plan incliné faisant un angle de 45° avec l'horizontale.",
      index(),
      "physique/forces/quiz · Q1",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toMatch(/recouvrement verbatim/);
    expect(flags[0].msg).toMatch(/web-exemple/);
    expect(flags[0].msg).toMatch(/étude 27 R-8/);
  });

  it("laisse passer une paraphrase lointaine de la même notion", () => {
    expect(
      auditVerbatim(
        "Une caisse repose sans glisser sur une rampe. Quelle force le support exerce-t-il perpendiculairement à celle-ci ?",
        index(),
        "où",
      ),
    ).toEqual([]);
  });

  it("laisse passer un énoncé qui partage la formule mais pas la prose", () => {
    expect(
      auditVerbatim(
        "Calculer la réaction normale : R = m × g × cos(30°). Donner le résultat en newtons.",
        index(),
        "où",
      ),
    ).toEqual([]);
  });

  it("ne dit rien quand l'index est vide — le cas du repo public", () => {
    expect(auditVerbatim(SOURCE, buildVerbatimIndex([]), "où")).toEqual([]);
  });

  it("fusionne une phrase recopiée en UNE plage, pas en autant de n-grammes", () => {
    const hits = findVerbatimHits(
      "Un solide de masse 250 g est posé sur un plan incliné faisant un angle de 30° avec l'horizontale.",
      index(),
    );
    expect(hits).toHaveLength(1);
    expect(hits[0].words.length).toBeGreaterThan(DEFAULT_NGRAM);
    expect(auditVerbatim("x", index(), "où")).toEqual([]);
  });

  it("borne le nombre de plages citées mais annonce le total", () => {
    const long = Array.from({ length: 6 }, (_, i) =>
      `bloc ${i} alpha beta gamma delta epsilon zeta eta theta iota kappa`.replace(/\d/g, ""),
    ).join(" ; ");
    const built = buildVerbatimIndex([{ slug: "s", text: long }]);
    const flags = auditVerbatim(long, built, "où", { max: 1 });
    expect(flags[0].msg).toMatch(/plage/);
  });
});

describe("questionTextSurface — les trois champs surveillés", () => {
  it("inclut le TEXTE des options, pas les objets", () => {
    const surface = questionTextSurface({
      prompt: "énoncé",
      options: [{ text: "premier choix" }, { text: "second choix" }],
      explanation: "parce que",
    });
    expect(surface).toContain("premier choix");
    expect(surface).not.toContain("[object Object]");
  });

  it("détecte donc une copie logée dans une option", () => {
    const built = buildVerbatimIndex([
      { slug: "s", text: "la reaction normale du support vaut le poids multiplie par le cosinus" },
    ]);
    const surface = questionTextSurface({
      prompt: "Que vaut R ?",
      options: [
        { text: "la réaction normale du support vaut le poids multiplié par le cosinus" },
        { text: "zéro" },
      ],
      explanation: "e",
    });
    expect(auditVerbatim(surface, built, "où")).toHaveLength(1);
  });

  it("tolère une question sans options (types natifs numeric / short_answer)", () => {
    expect(questionTextSurface({ prompt: "p", explanation: "e" })).toBe("p\ne");
  });
});

describe("loadSurveilledSources — découverte sur disque", () => {
  const withTmp = (fn: (dir: string) => void) => {
    const dir = mkdtempSync(join(tmpdir(), "verbatim-"));
    try {
      fn(dir);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  };

  it("ne rend rien quand l'arbre est absent (repo public)", () => {
    withTmp((dir) => expect(loadSurveilledSources(dir)).toEqual([]));
  });

  it("retient les fiches non autorisées de content/_sources et écarte les autorisées", () => {
    withTmp((dir) => {
      const write = (theme: string, slug: string, autorisation: string) => {
        const d = join(dir, "_sources", theme, slug);
        mkdirSync(d, { recursive: true });
        writeFileSync(join(d, "fiche.md"), `autorisation: ${autorisation}\n\ndu texte source\n`);
      };
      write("culture-generale", "web-libre", "accordée le 13/08 par l'auteur");
      write("culture-generale", "web-surveille", "aucune");

      const found = loadSurveilledSources(dir);
      expect(found.map((s) => s.slug)).toEqual(["web-surveille"]);
      expect(found[0].text).toContain("du texte source");
    });
  });

  it("met sous surveillance une fiche sans en-tête du tout", () => {
    withTmp((dir) => {
      const d = join(dir, "_sources", "theme", "web-sans-entete");
      mkdirSync(d, { recursive: true });
      writeFileSync(join(d, "fiche.md"), "# fiche bâclée\n\ndu texte\n");
      expect(loadSurveilledSources(dir).map((s) => s.slug)).toEqual(["web-sans-entete"]);
    });
  });
});

/**
 * Le câblage, pas seulement la logique : R-8 promet que `content:qa --strict`
 * ÉCHOUE sur une copie. Les tests ci-dessus prouvent que le détecteur détecte ;
 * celui-ci prouve que le gate est branché dessus — la seule chose qui rende la
 * promesse opposable. On lance donc le vrai CLI sur un corpus jouet.
 */
describe("content:qa --strict — le gate est réellement armé", () => {
  const REPO_ROOT = join(import.meta.dirname, "../../../..");
  const PHRASE =
    "Un solide de masse 250 g est posé sur un plan incliné faisant un angle de 30 degrés avec l'horizontale";

  const question = (prompt: string) => ({
    prompt,
    options: [
      { id: "a", text: "2,1 N" },
      { id: "b", text: "3,4 N" },
    ],
    correctOption: "a",
    explanation: "On projette le poids sur la normale au support.",
  });

  /** Un corpus minimal valide + une fiche source, la copie plantée ou non. */
  const buildCorpus = (opts: { autorisation: string; planted: boolean }) => {
    const root = mkdtempSync(join(tmpdir(), "verbatim-qa-"));
    const content = join(root, "content");
    const chapter = join(content, "physique", "01-forces");
    mkdirSync(join(chapter, "exercices"), { recursive: true });

    const fiche = join(content, "_sources", "ecole", "web-exemple");
    mkdirSync(fiche, { recursive: true });
    writeFileSync(
      join(fiche, "fiche.md"),
      `url: https://exemple.tn/serie\nautorisation: ${opts.autorisation}\ntier: T2-prime\n\n${PHRASE}. Déterminer la réaction normale.\n`,
    );

    writeFileSync(
      join(content, "physique", "subject.json"),
      JSON.stringify({
        id: "physique",
        nameFr: "Physique",
        description: "desc",
        attribute: "Force",
        colorToken: "subject-math",
        icon: "Calculator",
        displayOrder: 1,
        contentLanguage: "fr",
        themeId: "ecole-tn",
        gradeSlug: "1ere-sec",
      }),
    );
    writeFileSync(
      join(chapter, "chapter.json"),
      JSON.stringify({ title: "Forces", description: "d", displayOrder: 1, sources: [] }),
    );
    writeFileSync(join(chapter, "cours.md"), "# Forces\n\nUne force se représente par un vecteur.");
    writeFileSync(join(chapter, "resume.md"), "## Résumé\n\nLa normale est perpendiculaire.");
    writeFileSync(
      join(chapter, "quiz.json"),
      JSON.stringify({
        title: "Contrôle",
        questions: [
          question(
            opts.planted
              ? `${PHRASE}. Que vaut la réaction normale ?`
              : "Que vaut la réaction normale du support ?",
          ),
          question("Comment se représente une force ?"),
          question("La normale est-elle perpendiculaire au support ?"),
        ],
      }),
    );
    writeFileSync(
      join(chapter, "exercices", "01-pratique.json"),
      JSON.stringify({
        title: "exo",
        difficulty: 1,
        mode: "practice",
        xpReward: 50,
        rewardCoins: 10,
        displayOrder: 1,
        questions: [question("Projeter le poids sur la normale.")],
      }),
    );
    return root;
  };

  const runQa = (cwd: string) => {
    try {
      const out = execFileSync(
        process.execPath,
        ["--experimental-strip-types", join(REPO_ROOT, "scripts/content/qa.ts"), "--strict"],
        { cwd, encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] },
      );
      return { code: 0, out };
    } catch (err) {
      const e = err as { status: number; stdout?: string; stderr?: string };
      return { code: e.status, out: `${e.stdout ?? ""}${e.stderr ?? ""}` };
    }
  };

  const withCorpus = (opts: { autorisation: string; planted: boolean }) => {
    const root = buildCorpus(opts);
    try {
      return runQa(root);
    } finally {
      rmSync(root, { recursive: true, force: true });
    }
  };

  it("échoue en nommant la source quand une copie est plantée", { timeout: 60_000 }, () => {
    const { code, out } = withCorpus({ autorisation: "aucune", planted: true });
    expect(out).toMatch(/recouvrement verbatim/);
    expect(out).toMatch(/web-exemple/);
    expect(out).toMatch(/1 source\(s\) surveillée\(s\)/);
    expect(code).toBe(1);
  });

  it("passe sur le même corpus sans la copie (zéro faux positif)", { timeout: 60_000 }, () => {
    const { code, out } = withCorpus({ autorisation: "aucune", planted: false });
    expect(out).not.toMatch(/recouvrement verbatim/);
    expect(code).toBe(0);
  });

  it("annonce le compte même à zéro — un gate muet ne se voit pas", { timeout: 60_000 }, () => {
    const { code, out } = withCorpus({
      autorisation: "accordée le 13/08 par l'auteur",
      planted: true,
    });
    expect(out).toMatch(/0 source sous surveillance/);
    expect(code).toBe(0);
  });
});
