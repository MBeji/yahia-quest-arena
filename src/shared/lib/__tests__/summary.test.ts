import { describe, it, expect } from "vitest";
import { renderSummary } from "@/shared/lib/markdown";

/**
 * Résumé en cartes de révision — étude 18, lot 3.
 *
 * La veille du concours, un élève ne relit pas des puces grises : il révise des cartes.
 * Le contenu porte DÉJÀ la structure — `course-quality.md` (axe 3, « resume ↔ course
 * bijection ») impose « concept en gras + essence », et 3 549 puces sur 3 827 le
 * respectent. Les cartes se DÉDUISENT : aucun des 541 résumés n'est réécrit (D-6).
 */
describe("renderSummary — cartes de révision", () => {
  it("transforme chaque puce en carte, le gras devenant son titre (R-14)", () => {
    const out = renderSummary(
      "- **La formule**: AM/AB = AN/AC\n- **Le piège**: MN/BC ≠ AM/MB",
    ).html;
    expect(out).toContain('<ul class="lesson-cards">');
    expect(out.match(/<li class="lesson-card">/g)).toHaveLength(2);
    expect(out).toContain('<h3 class="lesson-card__title">La formule</h3>');
    expect(out).toContain('<h3 class="lesson-card__title">Le piège</h3>');
    expect(out).toContain("AM/AB = AN/AC");
  });

  it("rend une puce SANS gras en carte sans titre — les 16 résumés non conformes (R-14)", () => {
    const out = renderSummary("- Une puce toute simple.").html;
    expect(out).toContain('<li class="lesson-card">');
    expect(out).not.toContain("lesson-card__title");
    expect(out).toContain("Une puce toute simple.");
  });

  it("rattache les puces INDENTÉES à leur carte parente, sans en faire des sœurs", () => {
    // Le vrai cas limite : 27 résumés portent des sous-puces, qui sont les EXEMPLES de
    // leur puce parente. Un parseur naïf en ferait des cartes orphelines.
    const out = renderSummary(
      [
        "- **Short answers**: echo the auxiliary only.",
        "  - Do you like it? → Yes, I do.",
        "  - Is she ready? → Yes, she is.",
        "- **Autre carte**: la suite.",
      ].join("\n"),
    ).html;

    expect(out.match(/<li class="lesson-card"/g)).toHaveLength(2);
    expect(out).toContain("Do you like it?");
    expect(out).toContain("Is she ready?");
    // Les exemples vivent DANS la carte, en sous-liste.
    expect(out).toContain('<ul class="lesson-ul">');
  });

  it("type une puce `- ⚠️` en carte-piège et `- 🏆` en carte à retenir", () => {
    const out = renderSummary(
      "- ⚠️ **Attention**: le tag est inversé.\n- 🏆 Chapitre bouclé.",
    ).html;
    expect(out).toContain('<li class="lesson-card lesson-card--piege">');
    expect(out).toContain('<li class="lesson-card lesson-card--retenir">');
    // Le marqueur est consommé, pas laissé en tête du texte…
    expect(out).not.toContain("⚠️ Attention");
    // …et il n'empêche pas la carte d'avoir son titre.
    expect(out).toContain('<h3 class="lesson-card__title">Attention</h3>');
  });

  it("laisse le titre `#` et la prose libre HORS du paquet de cartes", () => {
    const out = renderSummary("# 📜 Résumé : Thalès\n\n- **A**: x\n\nUne phrase libre.").html;
    expect(out).toContain('<h1 class="lesson-h1">📜 Résumé : Thalès</h1>');
    expect(out).toContain('<ul class="lesson-cards">');
    expect(out).toContain("<p>Une phrase libre.</p>");
    expect(out.match(/<li class="lesson-card"/g)).toHaveLength(1);
  });

  it("échappe le titre d'une carte — l'invariant R-1 vaut aussi dans le résumé", () => {
    const out = renderSummary("- **<img src=x onerror=alert(1)>**: essence").html;
    const host = document.createElement("div");
    host.innerHTML = out;
    expect(host.querySelector("img, script")).toBeNull();
    const handlers = Array.from(host.querySelectorAll("*")).flatMap((el) =>
      el.getAttributeNames().filter((name) => name.startsWith("on")),
    );
    expect(handlers).toEqual([]);
  });

  it("rend un résumé arabe en cartes, notation standard préservée", () => {
    const out = renderSummary(
      "- **الوضعية**: مثلّث ABC ومستقيم (MN) يقطع [AB] في M.\n- ⚠️ النسبة تُقاس على الضلع كاملًا.",
      { lang: "ar" },
    ).html;
    expect(out).toContain('<h3 class="lesson-card__title">الوضعية</h3>');
    expect(out).toContain("lesson-card--piege");
    // Chiffres/lettres latines : la notation reste standard en prose arabe.
    expect(out).toContain("ABC");
  });

  it("ne produit aucun paquet vide sur un résumé sans puce", () => {
    const out = renderSummary("Juste une phrase.").html;
    expect(out).not.toContain("lesson-cards");
    expect(out).toContain("<p>Juste une phrase.</p>");
  });
});
