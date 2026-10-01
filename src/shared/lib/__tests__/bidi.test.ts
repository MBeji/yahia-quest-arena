// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  isDisplayEquation,
  isolateLtrRuns,
  isolateLtrRunsHtml,
  splitMathRuns,
} from "@/shared/lib/bidi";
import { isMathExpression } from "@/shared/lib/utils";

const LRI = "⁦";
const PDI = "⁩";

describe("isolateLtrRuns", () => {
  // Un exposant NÉGATIF n'a ni parenthèse ni relation pour l'ancrer : sans isolation,
  // `10⁻⁴` seul dans une phrase arabe se rend `⁴⁻10`. Le moins en exposant (U+207B) n'est
  // jamais un opérateur binaire, il n'y a donc pas de soustraction à protéger ici.
  it("isolates a bare negative exponent in Arabic prose", () => {
    expect(isolateLtrRuns("الدليل هو 10⁻⁴ هنا")).toContain(LRI);
    expect(isolateLtrRuns("القوة 2⁻³ سالبة الدليل")).toContain(LRI);
  });

  it("leaves a plain positive exponent alone (no scramble to fix)", () => {
    expect(isolateLtrRuns("المساحة 10² متر")).not.toContain(LRI);
  });

  it("wraps a square-root expression embedded in Arabic prose", () => {
    // The space + formula form one non-Arabic run; the radical stays left of 64.
    expect(isolateLtrRuns("ما قيمة √64 ؟")).toBe(`ما قيمة${LRI} √64 ${PDI}؟`);
  });

  it("wraps a multi-term equation as a single LTR run", () => {
    const out = isolateLtrRuns("الناتج √50 = √(25 × 2) = 5√2 إذن");
    expect(out).toContain(`${LRI} √50 = √(25 × 2) = 5√2 ${PDI}`);
  });

  it("isolates each formula separately across Arabic punctuation", () => {
    // The Arabic comma keeps the two formulas in distinct runs.
    const out = isolateLtrRuns("أمثلة: √9 = 3، √16 = 4.");
    expect((out.match(new RegExp(LRI, "g")) ?? []).length).toBe(2);
    expect(out).toContain(`:${LRI} √9 = 3${PDI}`);
    expect(out).toContain(`${LRI} √16 = 4${PDI}.`);
  });

  // Le point qui ferme la phrase et les deux-points qui ouvrent l'énoncé sont de la
  // PROSE. Dans l'isolat gauche-à-droite, `المجال هو [−3 ; −1].` se dessinait avec le
  // point entre le dernier mot arabe et la formule, à droite d'elle, au lieu d'être à
  // l'extrémité gauche de la ligne qui termine la phrase (dette relevée par les audits
  // du gisement : 420 énoncés de maths publiés sur 1 394).
  it("laisse la ponctuation latine qui borde une formule hors de l'isolat", () => {
    expect(isolateLtrRuns("المجال هو [−3 ; −1].")).toBe(`المجال هو${LRI} [−3 ; −1]${PDI}.`);
    expect(isolateLtrRuns("الطول هو √5.")).toBe(`الطول هو${LRI} √5${PDI}.`);
    expect(isolateLtrRuns("حلّ (x − 4)(x + 2) = 0, ثمّ")).toBe(
      `حلّ${LRI} (x − 4)(x + 2) = 0${PDI}, ثمّ`,
    );
    // La virgule arabe n'est pas latine : elle coupe déjà le segment, rien ne change.
    expect(isolateLtrRuns("حلّ (x − 4)(x + 2) = 0 ، ثمّ")).toBe(
      `حلّ${LRI} (x − 4)(x + 2) = 0 ${PDI}، ثمّ`,
    );
    // Le point d'un décimal et le contenu de la formule ne sont jamais retirés.
    expect(isolateLtrRuns("القيمة .5 √2 هنا")).toContain(`${LRI} .5 √2 ${PDI}`);
    expect(isolateLtrRuns("العدد 3.5 √2 هنا")).toContain(`${LRI} 3.5 √2 ${PDI}`);
  });

  // Le « ( » qui ouvre un membre de phrase ARABE après une formule restait dans l'isolat, à
  // droite de la formule : du mauvais côté du texte qu'il enferme (relevé dans les
  // explications de maths de 35 missions d'examen sur 38, par les audits du gisement).
  it("laisse hors de l'isolat la parenthèse qui ouvre ou ferme un membre de phrase arabe", () => {
    expect(isolateLtrRuns("لأنّ 12 + 8√2 = 5√2 (تقريبًا) دائمًا")).toContain(
      `${LRI} 12 + 8√2 = 5√2${PDI} (`,
    );
    expect(isolateLtrRuns("(الجذر) √2 = 1,41 تقريبًا")).toContain(`)${LRI} √2 = 1,41 ${PDI}`);
    // Une parenthèse qui a sa compagne DANS la formule fait partie de la formule.
    expect(isolateLtrRuns("الناتج (x − 4)(x + 2) = 0 صحيح")).toContain(
      `${LRI} (x − 4)(x + 2) = 0 ${PDI}`,
    );
  });

  // Le titre d'une mission technique — « مناظرة 2012 (تقني) · التمرين 2 » — n'a rien à
  // isoler : la seule raison d'isoler « 2012 ( » et « ) · » était une parenthèse de PROSE.
  // Isolés, ils retournaient les parenthèses dans le rapport parent.
  // Le cas inverse : la formule FERME ou OUVRE un membre de phrase arabe. `(نعلم أنّ √9 = 3)` :
  // le « ) » restait dans l'isolat, à droite de la formule, donc entre la formule et le dernier
  // mot arabe — le membre de phrase se fermait AVANT sa formule. Relevé par la re-vérification du
  // lot L12 : une cinquantaine de chaînes des missions d'examen, près de 1 700 dans le corpus.
  it("laisse hors de l'isolat la parenthèse que la formule ferme", () => {
    expect(isolateLtrRuns("(نعلم أنّ √9 = 3)")).toBe(`(نعلم أنّ${LRI} √9 = 3${PDI})`);
    // La compagne est dans un AUTRE segment : une parenthèse équilibrée reste dans la formule.
    expect(isolateLtrRuns("(نعلم أنّ (x + 3) = 5 √9)")).toContain(`${LRI} (x + 3) = 5 √9${PDI})`);
    // Un nombre seul ne demande aucun isolat : le « ) » de prose ne suffit plus à l'isoler.
    expect(isolateLtrRuns("ينطلق (من 11 إلى 99)")).toBe("ينطلق (من 11 إلى 99)");
  });

  it("laisse hors de l'isolat la parenthèse que la formule ouvre", () => {
    expect(isolateLtrRuns("ثمّ (√9 = 3 ثمّ نجد)")).toBe(`ثمّ (${LRI}√9 = 3 ${PDI}ثمّ نجد)`);
    expect(isolateLtrRuns("الفقرة (2: التكنولوجيا)")).toBe("الفقرة (2: التكنولوجيا)");
  });

  // Régression de #1141 : la « ( » d'attaque était retirée dès que le segment comptait plus
  // d'ouvrantes que de fermantes — même quand elle a sa « ) » DANS la formule et que c'est la
  // « ( » de queue qui ouvre le membre de phrase arabe. `(80 + 100) ÷ 2 = 90 ✓ (…)` sortait
  // de l'isolat par sa première parenthèse et y laissait le reste (37 chaînes du corpus).
  // Les parenthèses s'apparient désormais pour de bon, au lieu de se comparer en totaux.
  it("ne sépare jamais une parenthèse de sa compagne quand le segment les contient toutes deux", () => {
    expect(isolateLtrRuns("(80 + 100) ÷ 2 = 90 ✓ (والفرق بين مركزين متتاليين 20)")).toBe(
      `${LRI}(80 + 100) ÷ 2 = 90 ✓${PDI} (والفرق بين مركزين متتاليين 20)`,
    );
    expect(isolateLtrRuns("(−3) × (−4) = 12 (سالب × سالب = موجب)، ثمّ 12 + (−2) = 10.")).toBe(
      `${LRI}(−3) × (−4) = 12${PDI} (سالب × سالب = موجب)، ثمّ${LRI} 12 + (−2) = 10${PDI}.`,
    );
    expect(isolateLtrRuns("نجد (x + 2)(x − 2) = x² − 4 (الفرق بين مربّعين)")).toBe(
      `نجد${LRI} (x + 2)(x − 2) = x² − 4${PDI} (الفرق بين مربّعين)`,
    );
    // La « ) » finale referme une « ( » du segment : elle en fait partie, même quand une
    // fermante de prose la précède et fait pencher le total.
    expect(isolateLtrRuns("(حاسبنا AB = 16.) ✓ (12 = 4×(3))").endsWith(`4×(3))${PDI}`)).toBe(true);
  });

  // Le « ) » de `(بوحدة OI) : AB = …` ferme un membre de phrase ARABE mais tombait au MILIEU
  // de son segment : l'isolat le dessinait entre `OI` et la formule, et le couple de
  // parenthèses enfermait « بوحدة … : AB = … » en laissant `OI` dehors. Relevé par la
  // re-vérification du lot L08 : 262 chaînes du corpus. Une parenthèse dont la compagne est dans
  // UN AUTRE segment est de la prose, où qu'elle tombe ; les deux moitiés se jugent séparément.
  it("laisse hors de l'isolat la parenthèse que le texte arabe ferme ou ouvre au milieu d'un segment", () => {
    expect(isolateLtrRuns("(بوحدة OI) : AB = |−2 − (−√2)| = |√2 − 2|")).toBe(
      `(بوحدة OI) :${LRI} AB = |−2 − (−√2)| = |√2 − 2|${PDI}`,
    );
    expect(isolateLtrRuns("إذن BI = (√13 − 3)/2 cm ✓ (≈ 0,30 وهو العدد b) ثمّ")).toBe(
      `إذن${LRI} BI = (√13 − 3)/2 cm ✓${PDI} (≈ 0,30 وهو العدد b) ثمّ`,
    );
    expect(isolateLtrRuns("(نعلم أنّ 2 = 2ab) = (b − a)² ✓ ثمّ")).toBe(
      `(نعلم أنّ 2 = 2ab)${LRI} = (b − a)² ✓ ${PDI}ثمّ`,
    );
    // Deux membres de phrase arabes séparés par un signe : plus rien à isoler.
    const lines = "(المستقيم 1) ⊥ (المستقيم 2)";
    expect(isolateLtrRuns(lines)).toBe(lines);
    // Des crochets bien appariés ne retiennent pas la parenthèse ; une demi-droite, si.
    expect(isolateLtrRuns("متوازي أضلاع ([AE] ∥ [CG] و AE = CG) وله")).toBe(
      `متوازي أضلاع (${LRI}[AE] ∥ [CG] ${PDI}و AE = CG) وله`,
    );
    expect(isolateLtrRuns("(المستقيم [OI) حيث EM = 1)")).toContain(`${LRI} [OI) ${PDI}`);
  });

  // Une fermante d'attaque et une ouvrante de queue sont de la prose même quand le segment
  // les compte à égalité : `). (` ne se rend plus dans un isolat gauche-à-droite.
  it("retire la fermante d'attaque et l'ouvrante de queue d'un segment qui les compte à égalité", () => {
    const text = "(مثل: علّم، كسّر). (تمرين «صيد الخطأ».) الخطأ";
    expect(isolateLtrRuns(text)).toBe(text);
    expect(isolateLtrRuns("(الجذر) √2 = 1,41 (تقريبًا)")).toBe(
      `(الجذر)${LRI} √2 = 1,41${PDI} (تقريبًا)`,
    );
  });

  // `[OI)` est une demi-droite, `]2 ; 5)` un intervalle : la parenthèse s'apparie à un crochet.
  it("ne retire aucune parenthèse d'un segment à crochets (demi-droite, intervalle)", () => {
    expect(isolateLtrRuns("المستقيم [OI) حيث EM = 1")).toContain(`${LRI} [OI) ${PDI}`);
    expect(isolateLtrRuns("المجال ]2 ; 5) صحيح")).toContain(`${LRI} ]2 ; 5) ${PDI}`);
  });

  it("n'isole pas un titre dont la seule parenthèse est de la prose", () => {
    const title = "🏛️ مناظرة 2012 (تقني) · التمرين 2 ⭐⭐: أصوات عشرين حزبًا";
    expect(isolateLtrRuns(title)).toBe(title);
    expect(splitMathRuns(title).some((run) => run.math)).toBe(false);
  });

  it("ne perd ni n'ajoute aucun caractère en écartant la ponctuation", () => {
    for (const text of [
      "المجال هو [−3 ; −1].",
      "أمثلة: √9 = 3، √16 = 4.",
      "قيمة x = −2 ، ثمّ √5 ; و",
      "لأنّ 12 + 8√2 = 5√2 (تقريبًا) دائمًا",
      "(الجذر) √2 = 1,41 تقريبًا",
    ]) {
      expect(isolateLtrRuns(text).replaceAll(LRI, "").replaceAll(PDI, "")).toBe(text);
    }
  });

  it("leaves text with no Arabic untouched (LTR content has no bug)", () => {
    expect(isolateLtrRuns("√50 = 5√2")).toBe("√50 = 5√2");
    expect(isolateLtrRuns("Solve x² + 1 = 0")).toBe("Solve x² + 1 = 0");
  });

  it("does not isolate runs without a math signal", () => {
    // A lone variable letter between Arabic words needs no isolation.
    expect(isolateLtrRuns("العدد a الموجب")).toBe("العدد a الموجب");
  });

  it("handles empty and whitespace input", () => {
    expect(isolateLtrRuns("")).toBe("");
    expect(isolateLtrRuns("   ")).toBe("   ");
  });

  it("isolates comparisons even when escaped to HTML entities", () => {
    expect(isolateLtrRuns("حيث b &gt; 0 دائمًا")).toContain(`${LRI} b &gt; 0 ${PDI}`);
  });

  it("isolates direction-sensitive relations and arrows", () => {
    // Bidi-mirrored set relations and arrows would otherwise flip in RTL.
    expect(isolateLtrRuns("المجموعة A ⊂ B")).toContain(`${LRI} A ⊂ B${PDI}`);
    expect(isolateLtrRuns("السهم x → y معرّف")).toContain(`${LRI} x → y ${PDI}`);
  });

  // #1117 — la famille des relations d'ensemble se traite EN BLOC. `⊄` ou `∋` oublié,
  // seul dans une phrase arabe, restait au niveau RTL et se dessinait en miroir :
  // l'option « الرمز ⊄ » d'un QCM publié se lisait « ⊅ », l'énoncé inversé.
  it.each(["∈", "∉", "∋", "∌", "⊂", "⊃", "⊄", "⊅", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋"])(
    "isolates the set relation %s even when it stands alone in Arabic prose",
    (rel) => {
      expect(isolateLtrRuns(`الرمز ${rel}`)).toBe(`الرمز${LRI} ${rel}${PDI}`);
      expect(isolateLtrRuns(`نكتب A ${rel} B هنا`)).toContain(`${LRI} A ${rel} B ${PDI}`);
    },
  );

  // Regression: plain arithmetic, units and bare numbers must be left UNTOUCHED.
  // The native bidi algorithm already orders them correctly inside RTL prose;
  // isolating them reverses the run (`10 مي + 2 مي` rendered as `10مي 2 + مي`).
  // See the millime addition bug — the data was correct, the renderer over-isolated.
  it("does NOT isolate arithmetic with an Arabic unit", () => {
    const s = "10 مي + 2 مي + 2 مي = ؟";
    expect(isolateLtrRuns(s)).toBe(s);
  });

  it("does NOT isolate bare arithmetic carried by linear operators", () => {
    // +, ×, = and a trailing Arabic question mark all render fine natively.
    expect(isolateLtrRuns("احسب 3 + 5 = ؟")).toBe("احسب 3 + 5 = ؟");
    expect(isolateLtrRuns("العملية 5 × 3 = 15 قطعة")).toBe("العملية 5 × 3 = 15 قطعة");
    expect(isolateLtrRuns("النتيجة = 8 دنانير")).toBe("النتيجة = 8 دنانير");
  });

  it("does NOT isolate numbers, units, percentages, degrees or fractions", () => {
    for (const s of [
      "العدد 25 زوجي",
      "المساحة 12 صم² كبيرة",
      "الزاوية 90° قائمة",
      "الكسر 1/2 يساوي 0.5",
      "النسبة 50% من الكل",
    ]) {
      expect(isolateLtrRuns(s)).toBe(s);
    }
  });

  // A bare signed (negative/positive) number in RTL prose has no bracket or
  // relation to anchor it, so the neutral sign flips (`−5` → `5−`). It must be
  // isolated. Written tight (`−5`, not `− 5`), so it is never confused with the
  // spaced binary minus of subtraction.
  it("isolates a bare tight signed number embedded in Arabic prose", () => {
    expect(isolateLtrRuns("إذن −5 أقرب إلى الصفر")).toContain(`${LRI} −5 ${PDI}`);
    expect(isolateLtrRuns("قيمة x = −2 دائمًا")).toContain(`${LRI} x = −2 ${PDI}`);
    expect(isolateLtrRuns("الدوران +90° نحو اليمين")).toContain(`${LRI} +90° ${PDI}`);
    expect(isolateLtrRuns("الحدّ −2x صغير")).toContain(`${LRI} −2x ${PDI}`);
  });

  // `∠` est Bidi_Mirrored, comme `⊄` (#1117) : dans une phrase arabe il restait au niveau
  // RTL, se dessinait en miroir (⦣) et se détachait de ses lettres — « ∠ABy = 60° »
  // s'affichait « ABy = 60°⦣ ». Remonté par l'audit du lot L12 (gisement é36).
  it.each(["∠", "∡", "∢"])("isolates the angle sign %s even on its own", (sign) => {
    expect(isolateLtrRuns(`يحقّق ${sign}ABy = 60° دائمًا`)).toContain(
      `${LRI} ${sign}ABy = 60° ${PDI}`,
    );
    expect(isolateLtrRuns(`الرمز ${sign}`)).toBe(`الرمز${LRI} ${sign}${PDI}`);
  });

  // Une formule MÊLÉE de chiffres et de lettres qui s'ouvre par un nombre sort à moitié
  // renversée : après un mot arabe, une lettre latine est forte gauche-à-droite et tout
  // nombre qui la suit en hérite (règle W7), mais le premier terme reste au niveau RTL.
  // `25 + k = 9` s'affichait `k = 9 + 25`, `1/b` s'affichait `b/1`.
  it("isolates a formula that opens with a number and carries a letter", () => {
    expect(isolateLtrRuns("نجد 25 + k = 9 ثمّ نحلّ")).toContain(`${LRI} 25 + k = 9 ${PDI}`);
    expect(isolateLtrRuns("ما مقلوب 1/b في أبسط كتابة")).toContain(`${LRI} 1/b ${PDI}`);
    expect(isolateLtrRuns("احسب 3 − x ثمّ")).toContain(`${LRI} 3 − x ${PDI}`);
    expect(isolateLtrRuns("المقدار 10 × 3^p صحيح")).toContain(`${LRI} 10 × 3^p ${PDI}`);
    expect(isolateLtrRuns("نكتب 1/2 = x دائمًا")).toContain(`${LRI} 1/2 = x ${PDI}`);
  });

  it("isolates a sign glued to a letter that does not follow an operand", () => {
    expect(isolateLtrRuns("العدد −x موجب")).toContain(`${LRI} −x ${PDI}`);
    expect(isolateLtrRuns("نجد −x + 1 ثمّ")).toContain(`${LRI} −x + 1 ${PDI}`);
    expect(isolateLtrRuns("نجد +b هنا")).toContain(`${LRI} +b ${PDI}`);
  });

  // Ce qui s'ouvre par une LETTRE est déjà rendu gauche-à-droite (W7), et l'arithmétique
  // sans lettre se lit de droite à gauche avec la phrase : on n'y touche pas.
  it("does NOT isolate a formula that opens with a letter, nor digit-only arithmetic", () => {
    for (const s of [
      "نجد x − 3 = 5 ثمّ نحلّ",
      "نجد AB = 5 − x ثمّ نكمل",
      "نجد x = −a ثمّ نكمل",
      "المجموع 10 − 4 = 6 صحيح",
      "نجد 2x + 3 = 7 ثمّ نكمل",
      "العدد 5 cm كبير",
    ]) {
      expect(isolateLtrRuns(s)).toBe(s);
    }
  });

  // Une ponctuation de bord reste dehors, même quand la formule est isolée pour cette raison.
  it("écarte la ponctuation de bord d'une formule mêlée isolée", () => {
    expect(isolateLtrRuns("فنجد 25 + k = 9.")).toBe(`فنجد${LRI} 25 + k = 9${PDI}.`);
  });

  // Regression: subtraction/addition is written SPACED, so the sign is not glued
  // to a digit and must NOT be isolated — the native algorithm already orders it,
  // and this includes the Arabic minute unit «د» used in time subtraction.
  it("does NOT isolate spaced binary subtraction, even across an Arabic unit", () => {
    for (const s of ["الفرق 12 − 5 = 7", "المدّة 45 د − 10 د", "احسب 0 د − 1 ثانية"]) {
      expect(isolateLtrRuns(s)).toBe(s);
    }
  });

  // Standalone brackets flanking purely-Arabic content must NOT be isolated.
  // The browser's bidi algorithm mirrors ( and ) correctly in RTL prose; wrapping
  // them in LTR isolates reverses their visual order — close-paren appears before
  // open-paren in reading order.  Reproduction of user reports C5/C6/C7 (parenthesised
  // Arabic diacritics in Quran-diacritics lesson and Arabic chapter/subject titles).
  it("does NOT isolate standalone brackets around purely-Arabic content", () => {
    // C7 reproduction: diacritical mark shown in parentheses inside Arabic prose
    const sukun = "السُّكون ( ْ ) علامةٌ صغيرةٌ فوق الحرف";
    expect(isolateLtrRuns(sukun)).toBe(sukun);
    // Arabic chapter title with parenthetical Arabic subtitle (C5/C6 pattern)
    const chapter = "الكسور (الجزء الأول)";
    expect(isolateLtrRuns(chapter)).toBe(chapter);
    expect(isolateLtrRuns("الرياضيات (الجبر)")).toBe("الرياضيات (الجبر)");
    // Parentheses that DO contain LTR math content must still be isolated
    expect(isolateLtrRuns("احسب (2√3 + 5) ثم")).toContain(`${LRI} (2√3 + 5) ${PDI}`);
  });

  // The three concours-défi énoncés from the reported screenshots now render as
  // contiguous LTR runs (no scramble): abs-value inequality, difference of
  // squares, and the signed-number find-the-error prompt.
  it("renders the reported ambiguous concours prompts as clean LTR runs", () => {
    expect(isolateLtrRuns("كم عددًا يحقّق |x − 3| < 4؟")).toContain(`${LRI} |x − 3| < 4${PDI}`);
    expect(isolateLtrRuns("قيمة (2√3 − √5)(2√3 + √5) هي")).toContain(
      `${LRI} (2√3 − √5)(2√3 + √5) ${PDI}`,
    );
    const q6 = isolateLtrRuns("بما أنّ −5 < −2، فإنّ |−5| < |−2|، إذن −5 أقرب من −2");
    expect(q6).toContain(`${LRI} −5 < −2${PDI}`);
    expect(q6).toContain(`${LRI} |−5| < |−2|${PDI}`);
    // the two trailing bare negatives are now isolated too (was the ambiguous case)
    expect(q6).toContain(`${LRI} −5 ${PDI}`);
    expect(q6).toContain(`${LRI} −2${PDI}`);
    expect((q6.match(new RegExp(LRI, "g")) ?? []).length).toBe(4);
  });
});

describe("isolateLtrRunsHtml", () => {
  it("isolates math inside text but never inside tag markup", () => {
    const out = isolateLtrRunsHtml('<li class="lesson-li">التعريف: √(a²) = |a|</li>');
    expect(out).toBe(`<li class="lesson-li">التعريف:${LRI} √(a²) = |a|${PDI}</li>`);
    // class attribute must be left intact
    expect(out).toContain('class="lesson-li"');
  });

  it("leaves pure-LTR (non-Arabic) html untouched", () => {
    const html = "<p>√50 = 5√2</p>";
    expect(isolateLtrRunsHtml(html)).toBe(html);
  });
});

describe("splitMathRuns — une équation ne se coupe jamais en deux lignes", () => {
  const mathRuns = (text: string) => splitMathRuns(text).filter((run) => run.math);
  const escapeRegExp = (value: string) => value.replace(/[.*+?^${}()|[\]\\]/gu, "\\$&");
  const rebuild = (text: string) =>
    splitMathRuns(text)
      .map((run) => run.text)
      .join("");

  // Le défaut signalé en capture : l'isolat Unicode laissait le navigateur couper
  // `(x − 4)(x + 2) = 0` entre les deux facteurs, et chaque ligne était réordonnée
  // pour elle-même — deux moitiés de formule mêlées à la prose arabe.
  it("garde l'équation de l'énoncé signalé dans UN seul run insécable", () => {
    const runs = mathRuns("بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟");
    expect(runs).toHaveLength(1);
    expect(runs[0].text).toContain("(x − 4)(x + 2) = 0");
    expect(runs[0].nowrap).toBe(true);
  });

  it("ne perd ni n'ajoute aucun caractère", () => {
    for (const text of [
      "بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟",
      "Solve x² + 1 = 0 for x",
      "أمثلة: √9 = 3، √16 = 4.",
      "",
    ]) {
      expect(rebuild(text)).toBe(text);
    }
  });

  // Parité stricte avec isolateLtrRuns : le rendu doit isoler exactement les mêmes
  // runs qu'avant — ni plus (isoler `10 مي + 2 مي` le RENVERSE) ni moins.
  it("marque exactement les runs qu'isolateLtrRuns isole", () => {
    for (const text of [
      "ما قيمة √64 ؟",
      "الناتج √50 = √(25 × 2) = 5√2 إذن",
      "10 مي + 2 مي = ؟",
      "المساحة 10² متر",
      "العدد a الموجب",
      "حيث b &gt; 0 دائمًا",
      "الدليل هو 10⁻⁴ هنا",
      "المجال هو [−3 ; −1].",
      "أمثلة: √9 = 3، √16 = 4.",
      "لأنّ 12 + 8√2 = 5√2 (تقريبًا) دائمًا",
      "(الجذر) √2 = 1,41 تقريبًا",
      "نجد 25 + k = 9 ثمّ نحلّ",
      "يحقّق ∠ABy = 60° دائمًا",
      "العدد −x موجب",
      "ما مقلوب 1/b في أبسط كتابة",
      "(نعلم أنّ √9 = 3)",
      "ثمّ (√9 = 3 ثمّ نجد)",
      "المستقيم [OI) حيث EM = 1",
      "(بوحدة OI) : AB = |−2 − (−√2)| = |√2 − 2|",
      "إذن BI = (√13 − 3)/2 cm ✓ (≈ 0,30 وهو العدد b) ثمّ",
      "(نعلم أنّ 2 = 2ab) = (b − a)² ✓ ثمّ",
      "متوازي أضلاع ([AE] ∥ [CG] و AE = CG) وله",
    ]) {
      const isolated = isolateLtrRuns(text);
      expect(mathRuns(text).length).toBe((isolated.match(new RegExp(LRI, "g")) ?? []).length);
      // Les espaces de bord sont dans l'isolat d'isolateLtrRuns et dans la PROSE pour
      // splitMathRuns : la formule isolée, elle, est la même.
      for (const run of mathRuns(text)) {
        expect(isolated).toMatch(new RegExp(`${LRI}\\s*${escapeRegExp(run.text)}\\s*${PDI}`, "u"));
      }
    }
  });

  // Une liste d'intervalles (`[0 ; 10[ ، [10 ; 20[ ، …`) ne passait jamais à la ligne :
  // les espaces qui bordent chaque intervalle étaient dans le span insécable, et la
  // virgule arabe n'admet aucun saut avant elle — 14 à 582 px de débordement mesurés
  // sur un téléphone, dans 28 énoncés d'examen. Les espaces de bord sont de la prose.
  it("laisse les espaces de bord d'une formule dans la prose, entre deux formules voisines", () => {
    const text = "الفئات هي [0 ; 10[ ، [10 ; 20[ ، [20 ; 30[ فقط";
    const runs = splitMathRuns(text);
    expect(runs.filter((run) => run.math).map((run) => run.text)).toEqual([
      "[0 ; 10[",
      "[10 ; 20[",
      "[20 ; 30[",
    ]);
    // Le séparateur entre deux intervalles garde son espace AVANT et APRÈS la virgule :
    // c'est l'espace qui suit la virgule qui offre la coupure au navigateur.
    const between = runs.filter((run, index) => !run.math && index > 0 && index < runs.length - 1);
    expect(between.map((run) => run.text)).toEqual([" ، ", " ، "]);
    for (const run of runs.filter((r) => r.math)) expect(run.nowrap).toBe(true);
    expect(rebuild(text)).toBe(text);
  });

  // Même règle que pour isolateLtrRuns : le point final est de la prose, pas un morceau
  // de la formule.
  it("laisse la ponctuation latine qui borde une formule dans la prose", () => {
    expect(splitMathRuns("المجال هو [−3 ; −1].").map((run) => [run.text, run.math])).toEqual([
      ["المجال هو ", false],
      ["[−3 ; −1]", true],
      [".", false],
    ]);
    const list = splitMathRuns("أمثلة: √9 = 3، √16 = 4.").map((run) => [run.text, run.math]);
    expect(list.filter(([, math]) => math).map(([text]) => text)).toEqual(["√9 = 3", "√16 = 4"]);
    expect(list[list.length - 1]).toEqual([".", false]);
    expect(rebuild("المجال هو [−3 ; −1].")).toBe("المجال هو [−3 ; −1].");
    // le point d'un décimal reste dans la formule
    expect(mathRuns("القيمة .5 √2 هنا")[0].text).toBe(".5 √2");
    // la parenthèse qui ouvre un membre de phrase arabe est de la prose, pas de la formule
    const parenthetical = splitMathRuns("لأنّ 12 + 8√2 = 5√2 (تقريبًا) دائمًا");
    expect(parenthetical.filter((run) => run.math).map((run) => run.text)).toEqual([
      "12 + 8√2 = 5√2",
    ]);
    expect(parenthetical[parenthetical.length - 1].text.startsWith(" (")).toBe(true);
    expect(rebuild("لأنّ 12 + 8√2 = 5√2 (تقريبًا) دائمًا")).toBe(
      "لأنّ 12 + 8√2 = 5√2 (تقريبًا) دائمًا",
    );
  });

  // Même parité : la parenthèse qui a sa compagne dans la formule reste dans le run, seule la
  // « ( » de queue qui ouvre un membre de phrase arabe retourne à la prose.
  it("garde dans le run mathématique la parenthèse qui a sa compagne dans la formule", () => {
    const text = "(80 + 100) ÷ 2 = 90 ✓ (والفرق بين مركزين متتاليين 20)";
    const runs = splitMathRuns(text);
    expect(runs.filter((run) => run.math).map((run) => run.text)).toEqual([
      "(80 + 100) ÷ 2 = 90 ✓",
    ]);
    expect(runs[runs.length - 1].text.startsWith(" (")).toBe(true);
    expect(rebuild(text)).toBe(text);
  });

  it("garde la formule seule dans son run — jamais d'espace en bord d'un run mathématique", () => {
    for (const text of [
      "بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟",
      "الناتج √50 = √(25 × 2) = 5√2 إذن",
      "الفئات هي [0 ; 10[ ، [10 ; 20[ فقط",
    ]) {
      for (const run of mathRuns(text)) expect(run.text).toBe(run.text.trim());
      expect(rebuild(text)).toBe(text);
    }
  });

  // Une chaîne de calcul de corrigé ne tient sur aucune ligne : l'insécable la
  // ferait déborder de la carte. Elle reste isolée, mais cassable.
  it("n'exige pas l'insécable d'une formule trop longue pour une ligne", () => {
    const long = "الحساب p(Y = 1) = 4 × 0,368 × 0,632³ ≈ 4 × 0,368 × 0,2525 ≈ 0,372 إذن";
    const runs = mathRuns(long);
    expect(runs).toHaveLength(1);
    expect(runs[0].nowrap).toBe(false);
  });

  it("laisse la prose latine intacte — la parenthèse n'avale pas la phrase", () => {
    // `(like it), so it` était happé avant la garde « mot de prose ».
    expect(mathRuns("Use the short form (like it), so it stays natural")).toHaveLength(0);
    expect(mathRuns("Read the text below and answer the question.")).toHaveLength(0);
  });

  it("repère la formule d'un énoncé latin sans emporter les mots autour", () => {
    const runs = mathRuns("Quelle est la solution de (x − 4)(x + 2) = 0 ?");
    expect(runs).toHaveLength(1);
    expect(runs[0].text.trim()).toBe("(x − 4)(x + 2) = 0");
    expect(runs[0].nowrap).toBe(true);
  });

  it("garde un nom de fonction collé à sa parenthèse dans la formule", () => {
    const runs = mathRuns("On sait que PGCD(42 ; 56) = 14 donc");
    expect(runs).toHaveLength(1);
    expect(runs[0].text).toContain("PGCD(42 ; 56) = 14");
  });

  it("ne marque pas une énumération de lettres sans opérateur", () => {
    expect(mathRuns("Les points A B C D sont donnés")).toHaveLength(0);
  });
});

describe("isDisplayEquation — la ligne qui ne porte QUE la formule", () => {
  it("reconnaît une ligne-équation", () => {
    expect(isDisplayEquation("(x − 4)(x + 2) = 0")).toBe(true);
    expect(isDisplayEquation("  2x + 5 = 13  ")).toBe(true);
    expect(isDisplayEquation("√50 = √(25 × 2) = 5√2")).toBe(true);
    expect(isDisplayEquation("sin(x) = √3/2")).toBe(true);
  });

  // Une ligne-équation d'énoncé n'est pas toujours de l'algèbre : la chimie et la
  // physique en posent aussi, et elles doivent se centrer comme les autres.
  it("reconnaît une équation-bilan de chimie et une loi physique", () => {
    expect(isDisplayEquation("S + O₂ → SO₂")).toBe(true);
    expect(isDisplayEquation("2Al + 3Cl₂ → 2AlCl₃")).toBe(true);
    expect(isDisplayEquation("n₁ sin i₁ = n₂ sin i₂")).toBe(true);
    expect(isDisplayEquation("1/OA' − 1/OA = 1/f")).toBe(true);
  });

  // Le `?` d'un énoncé de primaire tient lieu d'inconnue quand un opérateur le
  // rattache à la formule ; ailleurs il ferme juste la phrase.
  it("garde le « ? » qui sert d'inconnue, écarte celui qui ferme la question", () => {
    expect(isDisplayEquation("AB + BC = ?")).toBe(true);
    expect(isDisplayEquation("? + 250 = 700")).toBe(true);
    expect(splitMathRuns("Quelle est la solution de (x − 4)(x + 2) = 0 ?")[1].text.trim()).toBe(
      "(x − 4)(x + 2) = 0",
    );
  });

  it("refuse une ligne de prose — y compris celle qu'isMathExpression accepte", () => {
    // `isMathExpression` sert à orienter une OPTION et accepte toute suite de
    // lettres latines ; promouvoir une phrase en bloc centré serait visible.
    expect(isMathExpression("Read the text")).toBe(true);
    expect(isDisplayEquation("Read the text")).toBe(false);
    expect(isDisplayEquation("ما حلول المعادلة ؟")).toBe(false);
    expect(isDisplayEquation("Quelle est la solution de (x − 4)(x + 2) = 0 ?")).toBe(false);
    expect(isDisplayEquation("")).toBe(false);
    expect(isDisplayEquation("A B C")).toBe(false);
  });
});
