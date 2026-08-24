import { describe, it, expect } from "vitest";
import {
  auditInlineEquation,
  auditQuestion,
  INLINE_EQUATION_LEVEL,
  type QAQuestion,
} from "../../../../scripts/content/qa-checks.ts";

const base = (over: Partial<QAQuestion>): QAQuestion => ({
  prompt: "Question ?",
  options: [
    { id: "a", text: "Alpha" },
    { id: "b", text: "Beta" },
    { id: "c", text: "Gamma" },
    { id: "d", text: "Delta" },
  ],
  correctOption: "a",
  explanation: "Une explication suffisamment longue pour passer le seuil de brièveté.",
  ...over,
});

describe("auditInlineEquation — une formule d'énoncé se pose seule sur sa ligne", () => {
  const run = (prompt: string, field = "prompt") =>
    auditInlineEquation(prompt, field, "math/04-equations/01#3");

  it("signale l'énoncé de la capture — équation collée à la phrase arabe", () => {
    const flags = run("بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟");
    expect(flags).toHaveLength(1);
    expect(flags[0].level).toBe(INLINE_EQUATION_LEVEL);
    expect(flags[0].msg).toContain("(x − 4)(x + 2) = 0");
    expect(flags[0].msg).toContain("own line");
  });

  it("accepte la même question une fois la formule posée sur sa ligne", () => {
    expect(
      run("بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة التالية؟\n(x − 4)(x + 2) = 0"),
    ).toEqual([]);
  });

  it("ne signale qu'une fois un énoncé qui porte deux formules", () => {
    expect(
      run("حُلَّ المعادلتان (x − 1)(x + 3) = 0 و (y − 2)(y + 5) = 0. فما المجموع؟"),
    ).toHaveLength(1);
  });

  // L'arithmétique linéaire se rend nativement en RTL et la phrase la porte bien
  // (`src/shared/lib/bidi.ts` refuse d'ailleurs de l'isoler) : rien à déplacer.
  it("laisse l'arithmétique linéaire dans la phrase", () => {
    expect(run("في العمليّة 40 + 25 = 65، ما هما الحدّان؟")).toEqual([]);
    expect(run("نعلم أنّ 138 + 6 = 144، فكم يساوي 6 + 138؟")).toEqual([]);
  });

  it("laisse une formule courte dans la phrase", () => {
    expect(run("الدالة f معرّفة. ما قيمة f(2) ؟")).toEqual([]);
    expect(run("إذا كان n = 5، فما الناتج؟")).toEqual([]);
  });

  // Le cadre de phrase est ce qui sépare l'objet donné à traiter de la donnée
  // citée dans un récit : `m = 1500 g` et `x = 5` s'écrivent pareil, seul le mot
  // qui les introduit les distingue. Sans « معادلة / عبارة / دالة / قانون … »,
  // on ne touche à rien.
  it("laisse la donnée d'un énoncé de physique ou de chimie dans son récit", () => {
    expect(run("صخرة كتلتها m = 1500 g وحجمها V = 500 cm³. ما كتلتها الحجمية؟")).toEqual([]);
    expect(run("قطعة فلّين كتلتها الحجمية ρ = 0.7 g/cm³ وُضعت في حوض ماء. ماذا يحدث لها؟")).toEqual(
      [],
    );
    expect(
      run("عيّنة من الماء H₂O كتلتها 36 g، والكتلة المولية M(H₂O) = 18 g/mol. كم مولًا؟"),
    ).toEqual([]);
    expect(run("في مثلّث ABC قائم في B، AB = 5 cm وBC = 5√3 cm. ما قيمة ظا(A)؟")).toEqual([]);
  });

  it("vise la loi physique que l'énoncé nomme, elle", () => {
    expect(run("بقانون سنيل–ديكارت n₁ sin i₁ = n₂ sin i₂، ما قيمة sin i₂؟")).toHaveLength(1);
  });

  // `العبارات` / `العلاقات` au pluriel ne portent plus le sens mathématique.
  it("ne prend pas « أيّ العبارات صحيحة » pour une expression algébrique", () => {
    expect(
      run("محلولان: A حجمه 250 mL و B حجمه 500 mL (M = 36.5 g/mol). أيّ العبارات صحيحة؟"),
    ).toEqual([]);
  });

  it("ne vise ni la prose latine ni les autres champs", () => {
    expect(run("Quelle est la solution de (x − 4)(x + 2) = 0 ?")).toEqual([]);
    expect(run("نطبّق المبدأ: (3x − 9)(2x + 4) = 0 إذن x = 3.", "explanation")).toEqual([]);
    expect(run("(x − 4)(x + 2) = 0", "option a")).toEqual([]);
  });

  it("ne prend pas les attributs d'une figure SVG pour une équation", () => {
    const svg = '<svg viewBox="0 0 10 10"><path d="M0 0 L10 10"/></svg>';
    expect(run(`ما نوع هذا الشكل الهندسي المرسوم أمامك؟ ${svg}`)).toEqual([]);
  });

  it("est branché sur auditQuestion", () => {
    const flags = auditQuestion(
      base({ prompt: "بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟" }),
      "math/04-equations/01#3",
    );
    expect(flags.some((f) => f.msg.includes("own line"))).toBe(true);
  });
});
