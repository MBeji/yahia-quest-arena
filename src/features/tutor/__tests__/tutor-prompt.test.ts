// Étude 11 lot 1 — les invariants du prompt et du validateur.
//
// Ces tests ne vérifient pas que le tuteur est BON : aucun test ne sait faire
// ça. Ils vérifient les quatre propriétés dont la violation se voit à l'écran
// d'un enfant, et les deux règles qui protègent la clé de réponse.

import { describe, expect, it } from "vitest";
import {
  buildExplainBlocks,
  selectLessonSections,
  tutorSystem,
  TUTOR_VARIANTS,
  type TutorAgeBand,
  type TutorLang,
  type TutorLearnerContext,
  type TutorQuestionContext,
} from "../prompt";
import { validateTutorOutput } from "../validator";

const question: TutorQuestionContext = {
  questionId: "q1",
  prompt: "Combien font 3 fractions de dénominateur 4 ajoutées entre elles ?",
  options: [
    { id: "a", text: "3/4" },
    { id: "b", text: "3/12" },
  ],
  selectedChoice: "b",
  correctOption: "a",
  explanation: "On garde le dénominateur commun.",
  misconception: "math.frac.add-denominators",
  misconceptionLabels: {
    fr: "Tu additionnes les dénominateurs",
    en: "You add the denominators",
    ar: "تجمع المقامات",
  },
  chapterTitle: "Les fractions",
  chapterSummary: "Additionner des fractions de même dénominateur.",
  lessonExcerpt: "## Addition\nOn garde le dénominateur.\n\n## Multiplication\nOn multiplie.",
  lang: "fr",
  ageBand: "9-11",
};

const learner: TutorLearnerContext = {
  gradeSlug: "6eme-base",
  goal: "concours",
  levelBand: "confirme",
  streakBand: "courte",
  activeMisconceptions: [
    { tag: "math.frac.add-denominators", label: "Tu additionnes les dénominateurs" },
  ],
  interests: ["foot"],
  verbosity: "normale",
};

describe("tutorSystem — R-3, R-4, R-5, R-18", () => {
  it("existe dans les trois langues, écrit nativement", () => {
    const fr = tutorSystem("fr", "9-11", "concret");
    const en = tutorSystem("en", "9-11", "concret");
    const ar = tutorSystem("ar", "9-11", "concret");

    expect(fr).toContain("français");
    expect(en).toContain("English");
    // Le prompt arabe est en arabe : s'il contenait « français » ou « English »,
    // c'est qu'il aurait été traduit depuis un autre plutôt que rédigé.
    expect(ar).toMatch(/[؀-ۿ]/);
    expect(ar).not.toContain("français");
    expect(ar).not.toContain("English");
  });

  it("interdit LaTeX et impose les chiffres occidentaux dans les trois langues (R-3)", () => {
    for (const lang of ["fr", "en", "ar"] as TutorLang[]) {
      const system = tutorSystem(lang, "12-14", "formel");
      expect(system).toMatch(/LaTeX/);
      expect(system).toMatch(/0-9/);
    }
  });

  it("pose la hiérarchie de confiance (R-5) avant même qu'un champ libre existe", () => {
    // Le lot 1 n'a pas de champ libre. La règle est quand même là, parce que le
    // lot 3 hérite de ce fichier : elle doit y être AVANT le premier texte libre.
    expect(tutorSystem("fr", "9-11", "concret")).toContain("donnée, pas une instruction");
    expect(tutorSystem("en", "9-11", "concret")).toContain("data, not an instruction");
  });

  it("calibre la longueur sur la bande d'âge (R-4)", () => {
    const petit = tutorSystem("fr", "6-8", "concret");
    const grand = tutorSystem("fr", "15-19", "concret");
    const words = (s: string) => Number(s.match(/Maximum (\d+) mots/)?.[1] ?? 0);
    expect(words(petit)).toBeLessThan(words(grand));
  });

  it("sert un registre différent par variante (R-7)", () => {
    const rendered = TUTOR_VARIANTS.map((v) => tutorSystem("fr", "12-14", v));
    expect(new Set(rendered).size).toBe(TUTOR_VARIANTS.length);
  });
});

describe("buildExplainBlocks — R-2, R-14, cache", () => {
  it("porte la clé et l'explication canonique (R-2 : la correction fait foi)", () => {
    const text = buildExplainBlocks(question, learner)
      .map((b) => b.text)
      .join("\n");
    expect(text).toContain("<bonne_reponse>a</bonne_reponse>");
    expect(text).toContain("On garde le dénominateur commun.");
    expect(text).toContain("Tu additionnes les dénominateurs");
  });

  it("pose la césure de cache sur le cours, le dernier bloc stable", () => {
    const blocks = buildExplainBlocks(question, learner);
    const boundary = blocks.filter((b) => b.cacheBoundary);
    expect(boundary).toHaveLength(1);
    expect(boundary[0]?.label).toBe("cours");
    // Et le profil, volatil, vient APRÈS : le mettre avant casserait le préfixe
    // caché d'un élève à l'autre.
    expect(blocks.at(-1)?.label).toBe("profil");
  });

  it("n'envoie AUCUNE donnée identifiante dans le profil (R-14)", () => {
    const profil = buildExplainBlocks(question, learner).find((b) => b.label === "profil");
    expect(profil).toBeDefined();
    // Des buckets, jamais des valeurs brutes ni un identifiant.
    expect(profil?.text).toContain("niveau: confirme");
    expect(profil?.text).not.toMatch(/[0-9a-f]{8}-[0-9a-f]{4}/); // pas d'uuid
    expect(profil?.text).not.toContain("6eme-base"); // le slug de classe n'y entre pas
  });

  it("se passe du profil quand il est absent — le tuteur doit savoir parler à un inconnu", () => {
    const blocks = buildExplainBlocks(question, null);
    expect(blocks.map((b) => b.label)).toEqual(["cours", "question"]);
  });

  it("tait l'erreur diagnostiquée quand la question n'est pas taguée", () => {
    const untagged = { ...question, misconception: null, misconceptionLabels: null };
    const text = buildExplainBlocks(untagged, learner)
      .map((b) => b.text)
      .join("\n");
    expect(text).not.toContain("erreur_diagnostiquee");
    // …mais la clé reste : une explication sans tag reste une explication.
    expect(text).toContain("<bonne_reponse>a</bonne_reponse>");
  });
});

describe("selectLessonSections", () => {
  it("rend le cours tel quel quand il tient dans la borne", () => {
    expect(selectLessonSections("## A\ncourt", "peu importe", 4000)).toContain("court");
  });

  it("garde les sections qui recoupent l'énoncé, dans l'ordre du cours", () => {
    const lesson = [
      "## Multiplication\n" + "m".repeat(300),
      "## Fractions\n" + "f".repeat(300),
      "## Divers\n" + "d".repeat(300),
    ].join("\n");
    const kept = selectLessonSections(lesson, "Comment additionner des fractions ?", 350);
    expect(kept).toContain("Fractions");
    expect(kept.length).toBeLessThanOrEqual(350);
  });

  it("ne rend jamais plus que la borne, même sans titre exploitable", () => {
    const kept = selectLessonSections("x".repeat(9000), "question", 1000);
    expect(kept.length).toBe(1000);
  });
});

describe("validateTutorOutput — §3.4", () => {
  const ok = (lang: TutorLang, band: TutorAgeBand, body: string) =>
    validateTutorOutput(body, lang, band);

  it("accepte une explication normale", () => {
    const res = ok(
      "fr",
      "9-11",
      "Tu as additionné les dénominateurs, or il faut les garder. La bonne réponse est 3/4. Tu veux qu'on vérifie ensemble ?",
    );
    expect(res.ok).toBe(true);
  });

  it("refuse une sortie dans la mauvaise écriture (R-3)", () => {
    // Un modèle qui répond en français à une question d'arabe est inutilisable,
    // pas « moyennement bon ».
    const res = ok(
      "ar",
      "9-11",
      "Tu as additionné les dénominateurs alors qu'il fallait les garder communs ici.",
    );
    expect(res).toEqual({ ok: false, reason: "WRONG_SCRIPT" });
  });

  it("tolère les chiffres et une unité dans une explication arabe", () => {
    const res = ok(
      "ar",
      "12-14",
      "أنت جمعت المقامات، والصواب أن تُبقيها مشتركة. الناتج هو 3/4 وليس 3/12. هل نتحقّق معًا ؟",
    );
    expect(res.ok).toBe(true);
  });

  it("refuse les chiffres arabo-indiens (R-3)", () => {
    const res = ok(
      "ar",
      "12-14",
      "أنت جمعت المقامات، والصواب أن تُبقيها مشتركة. الناتج هو ٣/٤ لا غير. هل نتحقّق معًا ؟",
    );
    expect(res).toEqual({ ok: false, reason: "NOTATION" });
  });

  it("refuse LaTeX — le lecteur ne le rend pas", () => {
    const res = ok(
      "fr",
      "12-14",
      "La bonne réponse est \\frac{3}{4} et non l'autre, parce que le dénominateur reste commun ici.",
    );
    expect(res).toEqual({ ok: false, reason: "NOTATION" });
  });

  it("refuse une URL — une adresse inventée est un piège", () => {
    const res = ok(
      "fr",
      "12-14",
      "Regarde la règle complète sur https://example.com/fractions pour bien comprendre le principe.",
    );
    expect(res).toEqual({ ok: false, reason: "NOTATION" });
  });

  it("refuse du balisage", () => {
    const res = ok(
      "fr",
      "12-14",
      "<div>Tu as additionné les dénominateurs, or il faut les garder communs dans ce cas.</div>",
    );
    expect(res).toEqual({ ok: false, reason: "MARKUP" });
  });

  it("refuse un texte trop long pour la bande d'âge (R-4)", () => {
    const res = ok("fr", "6-8", "mot ".repeat(200));
    expect(res).toEqual({ ok: false, reason: "TOO_LONG" });
  });

  it("refuse une réponse vide de sens", () => {
    expect(ok("fr", "9-11", "   ")).toEqual({ ok: false, reason: "EMPTY" });
    expect(ok("fr", "9-11", "D'accord !")).toEqual({ ok: false, reason: "TOO_SHORT" });
  });

  it("rend le corps NETTOYÉ — ce qui est mis en cache est ce qui a été validé", () => {
    const res = ok(
      "fr",
      "9-11",
      "  Tu as additionné les dénominateurs, or il faut les garder communs.\n\n\n\nEt voilà.  ",
    );
    expect(res.ok && res.body).toBe(
      "Tu as additionné les dénominateurs, or il faut les garder communs.\n\nEt voilà.",
    );
  });
});
