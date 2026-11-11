// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  auditCoursePitfalls,
  auditLesson,
  isSpatialChapter,
} from "../../../../scripts/content/qa-checks.ts";
import { DIRECTIVE_TYPES } from "../../lib/lesson-blocks.ts";

/**
 * Gate contenu des LEÇONS — étude 18, lot 4.
 *
 * Jusqu'ici `content:qa` ne lisait QUE les questions : les 541 `cours.md` / `resume.md`
 * étaient hors de tout contrôle déterministe. C'est précisément pour cela que la dérive
 * « aucune figure en géométrie » a pu durer sans qu'aucune CI ne bronche — et que le
 * premier passage a révélé 46 violations de notation dans 22 fichiers.
 */

const SVG = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>';
type LessonOpts = { spatial?: boolean; pattern?: "error" | "warn"; summary?: boolean };
const errors = (md: string, opts?: LessonOpts) =>
  auditLesson(md, "test/chapitre/cours", opts).filter((f) => f.level === "error");
const warns = (md: string, opts?: LessonOpts) =>
  auditLesson(md, "test/chapitre/cours", opts).filter((f) => f.level === "warn");

describe("auditLesson", () => {
  describe("directives `:::`", () => {
    it("accepte les huit types authorables", () => {
      expect(errors("::: definition\nUn énoncé.\n:::")).toEqual([]);
      expect(errors(`::: figure Le triangle ABC\n${SVG}\n:::`)).toEqual([]);
    });

    // Un checkout Windows matérialise le corpus en CRLF. Avec un `split("\n")`,
    // chaque ligne gardait un `\r` final et TOUTES les regex ancrées sur `$`
    // cessaient de matcher : l'ouverture n'était plus vue, la fermeture était
    // rapportée « stray `:::` closes nothing ». Le gate inventait deux erreurs
    // par chapitre à figure, en local seulement — la CI (Linux, LF) restait
    // verte, ce qui rendait l'écart incompréhensible côté auteur.
    it("lit une leçon en CRLF comme une leçon en LF (piège du checkout Windows)", () => {
      const lf = `::: figure Le triangle ABC\n${SVG}\n:::`;
      expect(errors(lf.replace(/\n/g, "\r\n"))).toEqual([]);
    });

    it("refuse un type inconnu", () => {
      const flags = errors("::: nawak\nDu texte.\n:::");
      expect(flags).toHaveLength(1);
      expect(flags[0].msg).toMatch(/unknown block directive/);
    });

    it("refuse une directive jamais fermée", () => {
      const flags = errors("::: piege\nJamais fermé.");
      expect(flags.some((f) => /never closed/.test(f.msg))).toBe(true);
    });

    it("refuse un `:::` orphelin", () => {
      const flags = errors("Du texte.\n:::");
      expect(flags.some((f) => /stray/.test(f.msg))).toBe(true);
    });

    it("refuse une `::: figure` sans légende — toute figure de cours est légendée (R-9)", () => {
      const flags = errors(`::: figure\n${SVG}\n:::`);
      expect(flags.some((f) => /no caption/.test(f.msg))).toBe(true);
    });
  });

  describe("figures", () => {
    it("refuse un cours qui DÉSIGNE une figure sans en porter aucune — le contrôle le plus discriminant", () => {
      // L'élève est envoyé vers une image qui n'existe pas.
      expect(
        errors("Observe le triangle ci-dessous.").some((f) => /points at a figure/.test(f.msg)),
      ).toBe(true);
      expect(
        errors("لاحظ المثلّث في الشكل المجاور.").some((f) => /points at a figure/.test(f.msg)),
      ).toBe(true);
    });

    it("laisse passer la même prose dès qu'une figure est là", () => {
      expect(errors(`Observe le triangle ci-dessous.\n\n${SVG}`)).toEqual([]);
    });

    it("avertit sur un chapitre spatial dépourvu de tout dessin (axe 5)", () => {
      const flags = warns("Le théorème de Thalès énonce que…", { spatial: true });
      expect(flags.some((f) => /no figure at all/.test(f.msg))).toBe(true);
    });

    it("n'avertit pas quand le chapitre spatial est illustré", () => {
      expect(warns(`Thalès.\n\n${SVG}`, { spatial: true })).toEqual([]);
    });

    it("refuse un `<svg>` sans viewBox — il s'effondrerait au rendu", () => {
      const flags = errors("<svg><circle cx='5' cy='5' r='4'/></svg>");
      expect(flags.some((f) => /viewBox/.test(f.msg))).toBe(true);
    });
  });

  describe("notation — ces contrôles n'avaient JAMAIS tourné sur une leçon", () => {
    it("refuse la virgule arabe comme séparateur dans une notation (46 cas trouvés au 1er passage)", () => {
      const flags = errors("الموضع (2، 3) في الشبكة.");
      expect(flags.some((f) => /Arabic comma/.test(f.msg))).toBe(true);
    });

    it("accepte le point-virgule, le séparateur normatif", () => {
      expect(errors("الموضع (2 ; 3) في الشبكة.")).toEqual([]);
    });

    it("laisse la virgule arabe tranquille dans la PROSE — la règle ne vise que la notation", () => {
      expect(errors("هذا مثلّث، وهذا مربّع.")).toEqual([]);
    });
  });

  describe("isSpatialChapter", () => {
    it("reconnaît les familles de FORMES", () => {
      for (const slug of [
        "08-thales",
        "09-triangle-rectangle-trigo",
        "10-angles-cercle",
        "11-vecteurs-translation",
        "13-geometrie-espace",
        "23-solides-cube-pave",
        "17-perimetre",
        // Deux familles que la première version de la liste laissait passer, découvertes
        // en illustrant math-1ere-sec : une rotation et des sections de solides.
        "07-quart-tour",
        "08-sections-planes",
        // Le primaire (6 ans) — les plus visuels de tous, ajoutés le 2026-07-14 après
        // le signalement de «التموقع في الفضاء» resté sans la moindre image.
        "07-reperage-espace",
        "06-formes-geometriques",
        "10-lignes",
        "07-formes-lignes",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(true);
      }
    });

    it("reconnaît les familles GRAPHIQUES — une fonction sans sa droite décrit ce qu'il fallait montrer", () => {
      for (const slug of [
        "12-fonctions-lineaires",
        "14-fonctions-affines",
        "06-fonctions-lineaires-affines",
        "16-exploitation-information",
        "07-statistiques",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(true);
      }
    });

    it("ne réclame pas de figure là où la notion n'est ni spatiale ni graphique", () => {
      for (const slug of [
        "01-nombres-reels",
        "03-calcul-litteral",
        "09-activites-numeriques-i",
        "11-activites-algebriques",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(false);
      }
    });

    /**
     * Troisième famille — le schéma légendé (généralisation é35 au concours 9ᵉ, 2026-09-17).
     * Les slugs sont ceux, réels, de `sciences-vie-terre` : translittérés de l'arabe, donc
     * invisibles aux deux premières familles, bâties sur du vocabulaire français.
     */
    it("réclame une figure pour un mécanisme, un cycle ou une coupe", () => {
      for (const slug of [
        "04-zalazil",
        "05-barakin",
        "06-safaih-taktuniya",
        "03-wiratha",
        "01-takathur-insan",
        "02-manaa",
        "03-seismes-et-volcans",
        "05-heredite-et-genetique",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(true);
      }
    });

    /**
     * Les trois faux positifs MESURÉS sur le corpus le 2026-09-17, tous de la même famille :
     * un mot de forme attrapé à l'intérieur d'un mot de grammaire. `forme` dans « formes de
     * phrases » (forme grammaticale, pas géométrique) et `donn[ée]es` dans « subor-donnees »,
     * coupé en plein milieu. Exiger un dessin d'une leçon sur les subordonnées, c'est réclamer
     * une figure qui n'existe pas — et un auteur qui obéit à un signal faux produit du
     * remplissage.
     */
    it("ne réclame pas de figure d'un chapitre de grammaire", () => {
      for (const slug of [
        "01-types-et-formes-de-phrases",
        "02-propositions-subordonnees",
        "02-vivre-ensemble-formes-de-phrases",
        "04-discours-direct-et-indirect",
        "05-modes-et-temps-verbaux",
        "07-lexique-et-figures-de-style",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(false);
      }
    });

    /**
     * La première version de la famille « schéma » testait aussi le TITRE arabe, et en
     * sous-chaîne libre. Elle a reproduit en arabe le défaut qu'elle corrigeait en français :
     * `ضوء` (lumière) attrapé DANS وضوء (ablution) sur six chapitres d'éducation islamique, et
     * `takathur` dans **سورة التكاثر**, une sourate. La morphologie arabe (préfixes ال، و، ب)
     * rend la sous-chaîne inexploitable ; le segment de slug, délimité par des tirets, non.
     */
    it("ne confond pas une sourate ni une ablution avec un chapitre de sciences", () => {
      for (const slug of [
        "04-sourate-at-takathur-al-qaria",
        "06-al-woudou",
        "04-al-woudou",
        "05-al-wudoo",
        "02-mujibat-al-wudu-wal-ghusl",
        "04-sifat-al-wudu",
      ]) {
        expect(isSpatialChapter(slug), slug).toBe(false);
      }
    });
  });
});

/**
 * Lot LC1 (étude « IA → déterministe », volet contenu) : la leçon est le champ où le trou a
 * fait le plus de dégâts — l'app n'a pas de moteur de rendu, donc `\dfrac{BC}{2}` est
 * littéralement ce que l'élève lit.
 */
describe("auditLesson — notation non rendue (lot LC1)", () => {
  it("errors sur une commande LaTeX dans un cours", () => {
    const flags = auditLesson("# Titre\n\n$$ R = \\dfrac{BC}{2} $$\n", "math-8eme/12");
    expect(flags.some((f) => f.level === "error" && /LaTeX command/.test(f.msg))).toBe(true);
  });

  it("laisse passer le même cours réécrit en Unicode", () => {
    const flags = auditLesson("# Titre\n\n$$ R = BC/2 $$\n", "math-8eme/12");
    expect(flags.some((f) => /LaTeX command|inline math|Arabic-Indic/.test(f.msg))).toBe(false);
  });
});

/**
 * Le patron de notion — étude 35, lot 1.
 *
 * Six contrôles de FORME, et rien de plus : ils comptent des blocs et des lignes, ils ne
 * jugent pas qu'une prose est « concrète » (D-7 — le reniflage de prose est fragile en trois
 * langues et faux silencieusement, é18 D-1 le disait déjà). Le fond reste l'affaire de
 * `content-audit`, qui note sur grille et re-résout chaque exemple à l'aveugle.
 *
 * Deux régimes : `warn` tant que la matière n'a pas déclaré `coursePattern` (c'est son
 * backlog), `error` quand elle l'a fait (c'est son gate). Les 773 cours du corpus du jour
 * tombent donc tous dans le premier — le lot 1 ne fait rougir personne.
 */
describe("auditCoursePattern — le patron de notion (étude 35)", () => {
  /** Les messages d'un jeu de constats, concaténés — on assert sur le contrôle visé. */
  const msgs = (flags: Array<{ msg: string }>) => flags.map((f) => f.msg).join(" | ");

  // Une section conforme : une amorce concrète, la règle, l'exemple, l'erreur, le contrôle.
  const NOTION = [
    "## La fonction linéaire",
    "",
    "La tomate est à 3 dinars le kilo. Combien pour x kilos ?",
    "Toujours « 3 × la quantité ».",
    "",
    "::: definition",
    "f(x) = ax",
    ":::",
    "",
    "::: exemple",
    "f(2) = 6, car la quantité est multipliée par le prix du kilo.",
    ":::",
    "",
    "> ⚠️ Écrire f(x) = x + 3 : le prix se MULTIPLIE, il ne s'ajoute pas.",
    "",
    "::: verifie",
    "Que vaut f(5) ?",
    "---",
    "f(5) = 15.",
    ":::",
  ].join("\n");

  it("laisse passer une section écrite au patron", () => {
    expect(errors(NOTION, { pattern: "error" })).toEqual([]);
    expect(warns(NOTION)).toEqual([]);
  });

  describe("C-1 — une règle, un exemple", () => {
    const RULE_ONLY =
      "## Titre\n\nUne amorce concrète.\nEt sa question ?\n\n::: propriete\nÉnoncé.\n:::\n\n> ⚠️ Le piège.";

    it("signale une règle sans exemple résolu", () => {
      expect(msgs(warns(RULE_ONLY))).toContain("no `::: exemple`");
    });

    it("l'érige en erreur sous `coursePattern`", () => {
      expect(msgs(errors(RULE_ONLY, { pattern: "error" }))).toContain("C-1");
    });

    it("refuse, SOUS patron, un cours qui n'emploie pas l'appareil — sinon le drapeau est décoratif", () => {
      const noApparatus = "## Titre\n\nDe la prose seule.\n\n> ⚠️ Un piège.";
      expect(msgs(errors(noApparatus, { pattern: "error" }))).toContain(
        "the pattern is a way of writing, not a flag",
      );
      // Hors patron, l'absence d'appareil est le backlog de la campagne, pas une faute.
      expect(msgs(warns(noApparatus))).not.toContain("not a flag");
    });

    it("ne réclame rien d'une section qui n'énonce aucun savoir (synthèse, rappel)", () => {
      expect(
        warns(
          "## Pour aller plus loin\n\nUn paragraphe libre.\n\n> ⚠️ Un piège.\n\n> 🗡️ Une astuce.",
        ),
      ).toEqual([]);
    });
  });

  describe("C-2 — le concret d'abord", () => {
    it("signale une section qui ouvre droit sur sa définition", () => {
      const msgs = warns(
        "## Titre\n\n::: definition\nÉnoncé.\n:::\n\n::: exemple\nX.\n:::\n\n::: verifie\nQ\n---\nR\n:::",
      ).map((f) => f.msg);
      expect(msgs.some((m) => m.includes("opens straight on its rule"))).toBe(true);
    });

    it("accepte une FIGURE comme amorce — montrer la situation, c'est la poser", () => {
      const md = `## Titre\n\n::: figure Le carré d'aire 9\n${SVG}\n:::\n\n::: definition\nÉnoncé.\n:::\n\n::: exemple\nX.\n:::\n\n::: verifie\nQ\n---\nR\n:::`;
      expect(
        warns(md)
          .map((f) => f.msg)
          .some((m) => m.includes("opens straight")),
      ).toBe(false);
    });

    it("exige deux lignes de prose, pas une ligne de politesse", () => {
      const md =
        "## Titre\n\nUne seule ligne.\n\n::: definition\nÉnoncé.\n:::\n\n::: exemple\nX.\n:::\n\n::: verifie\nQ\n---\nR\n:::";
      expect(
        warns(md)
          .map((f) => f.msg)
          .some((m) => m.includes("opens straight")),
      ).toBe(true);
    });
  });

  describe("C-3 — vérifier sur place", () => {
    it("signale un exemple qu'on ne peut pas essayer", () => {
      const md =
        "## Titre\n\nAmorce concrète.\nSa question ?\n\n::: definition\nÉnoncé.\n:::\n\n::: exemple\nX.\n:::";
      expect(
        warns(md)
          .map((f) => f.msg)
          .some((m) => m.includes("never lets the student try")),
      ).toBe(true);
    });
  });

  describe("C-4 — la réponse est repliée", () => {
    it("refuse un `::: verifie` sans séparateur — la réponse s'afficherait sous la question", () => {
      expect(errors("::: verifie\nUne question.\n:::")[0].msg).toContain("no `---` separator");
    });

    it("refuse un côté vide, et nomme lequel", () => {
      expect(errors("::: verifie\nQ\n---\n:::")[0].msg).toContain("empty answer");
      expect(errors("::: verifie\n\n---\nR\n:::")[0].msg).toContain("empty question");
    });

    it("accepte la forme complète", () => {
      expect(errors("::: verifie\nQ\n---\nR\n:::")).toEqual([]);
    });

    it("refuse un `::: verifie` dans un RÉSUMÉ — les cartes répondent, elles ne demandent pas", () => {
      expect(errors("::: verifie\nQ\n---\nR\n:::", { summary: true })[0].msg).toContain(
        "no place in a summary",
      );
    });

    it("n'applique AUCUN contrôle de patron à un résumé — ce n'est pas le cours", () => {
      expect(warns("## Titre\n\n::: definition\nÉnoncé.\n:::", { summary: true })).toEqual([]);
    });
  });

  describe("C-5 — l'erreur est nommée", () => {
    it("signale un cours qui ne montre aucune erreur typique", () => {
      const msgs = warns("## Titre\n\nUne amorce.\nSa question ?").map((f) => f.msg);
      expect(msgs.some((m) => m.includes("no classic mistake"))).toBe(true);
    });

    it("compte le callout promu `> ⚠️` autant que la directive — le corpus écrit surtout ainsi", () => {
      const withCallout = "## Titre\n\nUne amorce.\n\n> ⚠️ Le piège classique.";
      expect(
        warns(withCallout)
          .map((f) => f.msg)
          .some((m) => m.includes("classic mistake")),
      ).toBe(false);
      const withDirective = "## Titre\n\nUne amorce.\n\n::: piege\nLe piège.\n:::";
      expect(
        warns(withDirective)
          .map((f) => f.msg)
          .some((m) => m.includes("classic mistake")),
      ).toBe(false);
    });
  });

  describe("C-6 — segmenter", () => {
    it("avertit au-delà de 60 lignes, dans les DEUX régimes (une longueur n'est pas une faute)", () => {
      const long = `## Titre\n${"Une ligne de prose.\n".repeat(70)}`;
      expect(
        warns(long)
          .map((f) => f.msg)
          .some((m) => m.includes("over 60")),
      ).toBe(true);
      expect(
        errors(long, { pattern: "error" })
          .map((f) => f.msg)
          .some((m) => m.includes("over 60")),
      ).toBe(false);
    });

    it("ne compte PAS les lignes vides — la mise en forme n'ajoute pas de notion", () => {
      // 40 lignes de prose entrecoupées de vides : 80 lignes physiques, 40 de contenu.
      const aere = `## Titre\n${"Une ligne de prose.\n\n".repeat(40)}`;
      expect(aere.split("\n").length).toBeGreaterThan(60);
      expect(
        warns(aere)
          .map((f) => f.msg)
          .some((m) => m.includes("over 60")),
      ).toBe(false);
    });

    it("compte un `<svg>` pour UNE ligne — une figure est une figure, pas cinquante", () => {
      // Le cas réel : « شبه المنحرف » de 18-quadrilateres, signalée à 72 lignes pour 19 de fond.
      const svg = ['<svg viewBox="0 0 10 10">', ...Array(80).fill('  <path d="M0 0" />'), "</svg>"];
      const avecFigure = `## Titre\nDeux lignes d'ancrage ici.\nEt la question qu'elles posent.\n\n::: figure une légende\n${svg.join("\n")}\n:::\n`;
      expect(avecFigure.split("\n").length).toBeGreaterThan(80);
      expect(
        warns(avecFigure)
          .map((f) => f.msg)
          .some((m) => m.includes("over 60")),
      ).toBe(false);
    });

    it("avertit encore quand ce sont bien 61 lignes de CONTENU", () => {
      const dense = `## Titre\n${"Une ligne de prose.\n".repeat(61)}`;
      expect(
        warns(dense)
          .map((f) => f.msg)
          .some((m) => m.includes("61 content lines")),
      ).toBe(true);
    });
  });
});

describe("auditCoursePitfalls — la boucle se referme, ou elle n'existe pas (é35 C-5)", () => {
  const known = new Set(["math.fn.additive-au-lieu-de-multiplicative", "math.fn.origine-oubliee"]);
  const carried = new Set(["math.fn.additive-au-lieu-de-multiplicative"]);
  const pitfalls = (declared: string[] | undefined, level: "error" | "warn" = "warn") =>
    auditCoursePitfalls(declared, carried, known, "math/06-fonctions", level);

  it("accepte un tag du registre que les distracteurs du chapitre encodent", () => {
    expect(pitfalls(["math.fn.additive-au-lieu-de-multiplicative"])).toEqual([]);
  });

  it("refuse un tag inconnu du registre", () => {
    expect(pitfalls(["math.fn.inventee"])[0].msg).toContain("unknown misconception tag");
  });

  it("refuse un tag qu'AUCUN distracteur du chapitre ne porte — le cœur du contrôle", () => {
    const flags = pitfalls(["math.fn.origine-oubliee"]);
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toContain("fight an error the exercises never measure");
  });

  it("n'exige une déclaration que d'une matière SOUS patron", () => {
    expect(pitfalls([])).toEqual([]);
    expect(pitfalls(undefined)).toEqual([]);
    expect(pitfalls([], "error")[0].msg).toContain("declares no coursePitfalls");
  });
});

describe("le gate et le renderer partagent un vocabulaire, ou ils divergent", () => {
  it("connaît exactement les types que le renderer sait rendre", () => {
    // Un type que le renderer rend et que le gate ignore laisse passer une faute ; l'inverse
    // fait rougir un contenu parfaitement rendu. Les deux listes ne se croisent nulle part
    // ailleurs — ce test est le seul lien.
    // Chaque type avec le corps MINIMAL que le gate exige de lui : une figure porte sa
    // légende et son dessin, un contrôle ses deux côtés, les autres un corps quelconque.
    const sample: Record<string, string> = {
      figure: `::: figure Une légende\n${SVG}\n:::`,
      verifie: "::: verifie\nQuestion.\n---\nRéponse.\n:::",
    };
    for (const type of DIRECTIVE_TYPES) {
      expect(errors(sample[type] ?? `::: ${type}\nCorps.\n:::`)).toEqual([]);
    }
    expect(errors("::: remarque\nCorps.\n:::")[0].msg).toContain("unknown block directive");
  });

  /**
   * C-7 « une glose, pas une phrase » (R-14 amendée le 2026-09-17).
   *
   * Les cas « DOIT ALERTER » ne sont pas inventés : ce sont les phrases RÉELLES qui ont fui
   * pendant la campagne pilote et qu'il a fallu purger à la main, trois fois. C'est la raison
   * d'être du contrôle — une règle qu'aucune machine ne tient revient.
   */
  describe("C-7 — une glose, pas une phrase", () => {
    const c7 = (md: string, opts?: LessonOpts) =>
      auditLesson(md, "test/chapitre/cours", opts).filter((f) => f.msg.includes("C-7"));
    // Assez d'arabe pour que le document soit RTL, comme un vrai chapitre.
    const AR = "## الدرس\n\nهذا نصّ عربيّ طويل بما يكفي ليكون المستند عربيًّا بوضوح تامّ.\n";

    it("attrape les phrases françaises qui ont réellement fui de la campagne", () => {
      for (const fuite of [
        "ثلاث نسب égales, pas deux",
        "jamais الاثنين dans la même égalité",
        "التكرار الكلّي، jamais sur le nombre de lignes",
        "ثلاث قواعد تعود dans presque chaque exercice.",
        "القيم donnent المعدّل sans jamais l'égaler",
      ]) {
        expect(c7(AR + fuite), fuite).not.toEqual([]);
      }
    });

    it("attrape le mot français SEUL, que le premier prototype laissait passer", () => {
      // La règle « deux mots latins consécutifs » ratait ce cas, qui est pourtant la faute :
      // un adjectif français accroché à une proposition arabe.
      expect(c7(AR + "ثلاثة عدّات différentes")).not.toEqual([]);
    });

    it("laisse passer la glose entre parenthèses, qui est la règle R-14", () => {
      expect(c7(AR + "**الوتر** (hypoténuse) هو أطول ضلع في المثلّث القائم.")).toEqual([]);
      expect(c7(AR + "المعيّن (losange) والمربّع (carré) لهما نفس الخاصيّة.")).toEqual([]);
    });

    it("laisse passer la notation : points, formules, code, unités, fonctions", () => {
      expect(c7(AR + "في مثلّث ABC القائم في A نحسب الوتر [BC].")).toEqual([]);
      expect(c7(AR + "نحسب $$ IA = IB = IC = BC/2 $$ إذن النقطة على الدائرة.")).toEqual([]);
      expect(c7(AR + "الرمز `misconceptionTag` يوضع على المشتّت.")).toEqual([]);
      expect(c7(AR + "العلاقة: 1 h = 60 min، و 1 min = 60 s.")).toEqual([]);
      expect(c7(AR + "وحدات الطول بالترتيب: km، hm، dam، m، dm، cm.")).toEqual([]);
      expect(c7(AR + "نحسب cos الزاوية ثمّ sin الزاوية.")).toEqual([]);
    });

    it("ne traverse pas le corps d'une figure, plein d'attributs latins", () => {
      expect(c7(AR + `::: figure الشكل المجاور\n${SVG}\n:::`)).toEqual([]);
    });

    it("ne prend pas le mot-clé d'une directive pour de la prose — mais lit sa légende", () => {
      // `figure`, `exemple`… sont la grammaire de é18. Les compter faisait 500 constats sur
      // 550 au premier jet. La LÉGENDE, elle, reste contrôlée.
      expect(c7(AR + "::: exemple مثلّث ABC حيث BC = 18\nالحلّ.\n:::")).toEqual([]);
      expect(c7(AR + "::: figure الشكل, vu de dessus\n" + SVG + "\n:::")).not.toEqual([]);
    });

    it("se tait sur une leçon française qui cite un nom arabe", () => {
      // Le document décide, pas la ligne : `rendersRtl` compte sur l'ensemble.
      const fr =
        "# Annales\n\nL'épreuve de français de fin d'études de base (ختم التعليم الأساسي) " +
        "repose sur un texte suivi de trois grandes parties, et le temps est limité.\n";
      expect(c7(fr)).toEqual([]);
    });

    it("suit les deux régimes, et vaut aussi pour le résumé", () => {
      expect(c7(AR + "ثلاثة عدّات différentes")[0].level).toBe("warn");
      expect(c7(AR + "ثلاثة عدّات différentes", { pattern: "error" })[0].level).toBe("error");
      // Le résumé a fui autant que le cours — c'est la surface relue la veille du devoir.
      expect(c7(AR + "القيم donnent المعدّل", { summary: true })).not.toEqual([]);
    });
  });
});
