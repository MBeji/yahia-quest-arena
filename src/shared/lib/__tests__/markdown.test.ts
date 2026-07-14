import { describe, it, expect } from "vitest";
import { renderLesson } from "@/shared/lib/markdown";

// Substitution PUREMENT mécanique : renderLesson remplace renderMarkdown et retourne
// désormais { html, sections, figureCount }. Toutes les assertions ci-dessous — dont les
// 8 tests XSS — restent identiques au caractère près (étude 18, stop-point du lot 1 :
// devoir amender une assertion XSS signifierait que l'invariant R-1 a été cassé).
const html = (md: string) => renderLesson(md).html;

describe("renderLesson", () => {
  describe("HTML escaping", () => {
    it("escapes < and >", () => {
      const result = html("<script>alert('xss')</script>");
      expect(result).not.toContain("<script>");
      expect(result).toContain("&lt;script&gt;");
    });

    it("escapes ampersands", () => {
      const result = html("A & B");
      expect(result).toContain("&amp;");
    });

    it("escapes event handler attributes", () => {
      const result = html('<img src=x onerror="alert(1)" />');
      expect(result).not.toContain("<img");
      expect(result).toContain('&lt;img src=x onerror="alert(1)" /&gt;');
    });

    it("escapes javascript URLs", () => {
      const result = html("[x](javascript:alert(1))");
      expect(result).toContain("javascript:alert(1)");
      expect(result).not.toContain("<a href=");
    });

    it("escapes quotes in raw html blocks", () => {
      const result = html('<div title="x"y">ok</div>');
      expect(result).not.toContain("<div");
      expect(result).toContain("&lt;div title=");
      expect(result).toContain("&gt;ok&lt;/div&gt;");
    });
  });

  describe("Headings", () => {
    it("renders h1", () => {
      const result = html("# Title");
      expect(result).toContain('<h1 class="lesson-h1">Title</h1>');
    });

    it("renders h2 with incremented IDs", () => {
      const result = html("## First\n## Second");
      expect(result).toContain('<h2 class="lesson-h2" id="section-0">First</h2>');
      expect(result).toContain('<h2 class="lesson-h2" id="section-1">Second</h2>');
    });

    it("renders h3", () => {
      const result = html("### Subtitle");
      expect(result).toContain('<h3 class="lesson-h3">Subtitle</h3>');
    });
  });

  describe("Inline formatting", () => {
    it("renders bold", () => {
      const result = html("This is **bold** text");
      expect(result).toContain("<strong>bold</strong>");
    });

    it("renders italic", () => {
      const result = html("This is *italic* text");
      expect(result).toContain("<em>italic</em>");
    });

    it("renders bold inside italic", () => {
      const result = html("***both***");
      expect(result).toContain("<strong>");
      expect(result).toContain("<em>");
    });
  });

  describe("Math blocks", () => {
    it("renders $$ math as div.lesson-math", () => {
      const result = html("$$x^2 + 1 = 0$$");
      expect(result).toContain('<div class="lesson-math">x^2 + 1 = 0</div>');
    });
  });

  describe("Blockquotes", () => {
    it("renders > as blockquote", () => {
      const result = html("> Important note");
      expect(result).toContain('<blockquote class="lesson-quote">Important note</blockquote>');
    });
  });

  describe("Horizontal rules", () => {
    it("renders --- as hr", () => {
      const result = html("---");
      expect(result).toContain('<hr class="lesson-hr"');
    });
  });

  describe("Lists", () => {
    it("renders unordered list items", () => {
      const result = html("- Item one\n- Item two");
      expect(result).toContain('<li class="lesson-li">Item one</li>');
      expect(result).toContain('<li class="lesson-li">Item two</li>');
    });

    it("wraps consecutive li in ul", () => {
      const result = html("- A\n- B\n- C");
      expect(result).toContain('<ul class="lesson-ul">');
    });

    it("renders ordered list items", () => {
      const result = html("1. First\n2. Second");
      expect(result).toContain("lesson-oli");
      expect(result).toContain("First");
      expect(result).toContain("Second");
    });

    it("wraps consecutive ordered li in ol (not orphan li)", () => {
      const result = html("1. First\n2. Second\n3. Third");
      expect(result).toContain('<ol class="lesson-ol">');
      expect(result).toContain("</ol>");
      // Ordered items must not be wrapped in <ul>
      expect(result).not.toContain('<ul class="lesson-ul"><li class="lesson-li lesson-oli">');
      // No orphan <li> outside a list container
      expect(result).not.toContain('<p><li class="lesson-li lesson-oli">');
    });
  });

  describe("Tables", () => {
    it("renders table rows", () => {
      const md = "| A | B |\n|---|---|\n| 1 | 2 |";
      const result = html(md);
      expect(result).toContain('<table class="lesson-table">');
      expect(result).toContain("<td>A</td>");
      expect(result).toContain("<td>1</td>");
    });

    it("removes table separator rows", () => {
      const md = "| H1 | H2 |\n|---|---|\n| D1 | D2 |";
      const result = html(md);
      expect(result).not.toContain("<!--table-sep-->");
    });
  });

  describe("Paragraphs", () => {
    it("wraps plain text in <p>", () => {
      const result = html("Just text");
      expect(result).toContain("<p>Just text</p>");
    });

    it("does not wrap HTML tags in <p>", () => {
      const result = html("# Heading");
      expect(result).not.toContain("<p><h1");
    });

    it("removes empty lines", () => {
      const result = html("Line 1\n\nLine 2");
      const lines = result.split("\n").filter(Boolean);
      expect(lines.every((l) => l.length > 0)).toBe(true);
    });
  });

  describe("Inline SVG figures", () => {
    const FIGURE = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4" fill="#fff"/></svg>';

    it("renders an inline svg as a real figure, not escaped text", () => {
      const result = html(`Look:\n\n${FIGURE}\n\ndone`);
      expect(result).toContain('<figure class="lesson-figure"');
      expect(result).toContain('<div class="lesson-figure__plate">');
      expect(result).toContain("<svg");
      expect(result).toContain("<circle");
      // Must NOT have been escaped into literal text
      expect(result).not.toContain("&lt;svg");
    });

    it("keeps surrounding markdown working around a figure", () => {
      const result = html(`# Title\n\n${FIGURE}\n\n**bold**`);
      expect(result).toContain('<h1 class="lesson-h1">Title</h1>');
      expect(result).toContain("<strong>bold</strong>");
      expect(result).toContain('<figure class="lesson-figure"');
      expect(result).toContain('<div class="lesson-figure__plate">');
    });

    it("does not wrap the figure in a paragraph", () => {
      const result = html(FIGURE);
      expect(result).not.toContain("<p><figure");
      expect(result).not.toMatch(/<p>svgfigureplaceholder/);
    });

    it("renders multiple figures independently", () => {
      const result = html(`${FIGURE}\n\ntext\n\n${FIGURE}`);
      expect(result.match(/<figure class="lesson-figure"/g)).toHaveLength(2);
      expect(result).not.toContain("svgfigureplaceholder");
    });

    it("sanitizes script and event handlers out of an embedded svg", () => {
      const evil =
        '<svg viewBox="0 0 10 10"><script>alert(1)</script><circle cx="5" cy="5" r="4" onclick="alert(2)"/></svg>';
      const result = html(evil);
      expect(result).toContain('<figure class="lesson-figure"');
      expect(result).toContain('<div class="lesson-figure__plate">');
      expect(result).not.toContain("<script");
      expect(result).not.toContain("onclick");
    });

    it("strips external references from an embedded svg", () => {
      const evil =
        '<svg viewBox="0 0 10 10"><image href="https://evil.example/x.png"/><use xlink:href="#x"/></svg>';
      const result = html(evil);
      expect(result).not.toContain("evil.example");
      expect(result).not.toContain("<image");
      expect(result).not.toContain("<use");
    });
  });

  describe("Complex content", () => {
    it("handles Arabic text without mangling", () => {
      const result = html("# درس الرياضيات\n\nمرحبا بكم");
      expect(result).toContain("درس الرياضيات");
      expect(result).toContain("مرحبا بكم");
    });

    it("handles mixed Arabic and math", () => {
      const result = html("حل المعادلة: $$x + 2 = 5$$");
      expect(result).toContain("حل المعادلة:");
      expect(result).toContain('<div class="lesson-math">x + 2 = 5</div>');
    });
  });
});

/**
 * Moteur de blocs pédagogiques — étude 18, lot 1.
 *
 * Deux voies vers un bloc : la PROMOTION des callouts déjà écrits dans le contenu (2 637
 * occurrences dans 512 cours sur 541 — aucun fichier de contenu n'est touché) et la
 * DIRECTIVE explicite `::: <type>`. Dans les deux cas l'invariant R-1 tient : le corps est
 * échappé avant qu'aucune balise ne soit émise.
 */
describe("renderLesson — blocs pédagogiques", () => {
  describe("Promotion des callouts existants", () => {
    it("promeut `> ⚠️` en bloc piège", () => {
      const result = renderLesson("## Section\n\n> ⚠️ MN/BC ne vaut pas AM/MB.").html;
      expect(result).toContain('<section class="lesson-blk lesson-blk--piege">');
      expect(result).toContain("MN/BC ne vaut pas AM/MB.");
      // le marqueur est consommé : il ne reste pas en tête du texte
      expect(result).not.toContain("⚠️ MN/BC");
    });

    it("promeut `> 🗡️` en astuce et `> 🏆` en à-retenir", () => {
      const result = renderLesson("## S\n\n> 🗡️ Astuce du prof.\n\n> 🏆 Chapitre validé.").html;
      expect(result).toContain('<section class="lesson-blk lesson-blk--astuce">');
      expect(result).toContain('<section class="lesson-blk lesson-blk--retenir">');
    });

    it("traite le premier `> 💡` posé avant la première section comme l'épigraphe", () => {
      const result = renderLesson("# Titre\n\n> 💡 Une maxime qui motive.\n\n## Section").html;
      expect(result).toContain('<blockquote class="lesson-epigraph">');
      expect(result).toContain("Une maxime qui motive.");
    });

    it("rend un `> 💡` postérieur à la première section en éclairage, pas en épigraphe", () => {
      const result = renderLesson("## Section\n\n> 💡 Un éclairage en cours de route.").html;
      expect(result).toContain('<section class="lesson-blk lesson-blk--insight">');
      expect(result).not.toContain("lesson-epigraph");
    });

    it("tolère l'absence du sélecteur de variante emoji (U+FE0F)", () => {
      // Le contenu écrit tantôt « ⚠️ » tantôt « ⚠ » ; un marqueur non reconnu retomberait
      // silencieusement en <blockquote> gris — précisément le bug qu'on corrige.
      const result = renderLesson("## S\n\n> ⚠ Sans variante.").html;
      expect(result).toContain('<section class="lesson-blk lesson-blk--piege">');
    });

    it("absorbe les lignes de continuation d'un callout", () => {
      const result = renderLesson("## S\n\n> ⚠️ Première ligne.\n> Deuxième ligne.").html;
      expect(result).toContain("Première ligne.");
      expect(result).toContain("Deuxième ligne.");
      expect(result.match(/lesson-blk--piege/g)).toHaveLength(1);
    });

    it("ne promeut PAS une citation ordinaire — aucune régression", () => {
      const result = renderLesson("> Simple citation.").html;
      expect(result).toContain('<blockquote class="lesson-quote">Simple citation.</blockquote>');
      expect(result).not.toContain("lesson-blk");
    });
  });

  describe("Directives `::: <type>`", () => {
    it("rend chaque type authorable avec son libellé", () => {
      const result = renderLesson("::: definition\nUn énoncé.\n:::").html;
      expect(result).toContain('<section class="lesson-blk lesson-blk--definition">');
      expect(result).toContain('<span class="lesson-blk__label">Définition</span>');
      expect(result).toContain("Un énoncé.");
    });

    it("porte le titre optionnel de la directive", () => {
      const result = renderLesson("::: exemple Calculer AN\nAM / AB = 2/5\n:::").html;
      expect(result).toContain('<p class="lesson-blk__title">Calculer AN</p>');
    });

    it("rend le markdown interne du bloc (formules, listes)", () => {
      const result = renderLesson("::: propriete\n$$ AM/AB = AN/AC $$\n- un\n- deux\n:::").html;
      expect(result).toContain('<div class="lesson-math">');
      expect(result).toContain('<ul class="lesson-ul">');
    });

    it("dégrade un type INCONNU en bloc neutre, jamais en page cassée (R-7)", () => {
      const result = renderLesson("::: nawak\nDu texte.\n:::").html;
      expect(result).toContain('<section class="lesson-blk">');
      expect(result).toContain("Du texte.");
      expect(result).not.toContain("lesson-blk--nawak");
    });

    it("ferme implicitement une directive non fermée (R-7)", () => {
      const result = renderLesson("::: piege\nJamais fermé.").html;
      expect(result).toContain('<section class="lesson-blk lesson-blk--piege">');
      expect(result).toContain("Jamais fermé.");
      expect(result).not.toContain(":::");
    });

    it("ferme une directive non fermée devant la directive suivante", () => {
      const result = renderLesson("::: astuce\nA\n::: piege\nB\n:::").html;
      expect(result).toContain("lesson-blk--astuce");
      expect(result).toContain("lesson-blk--piege");
      expect(result).toContain("A");
      expect(result).toContain("B");
    });

    it("échappe le corps ET le titre d'une directive — l'invariant R-1 vaut dans un bloc", () => {
      const result = renderLesson(
        "::: definition <img src=x onerror=alert(1)>\n<script>alert(2)</script>\n:::",
      ).html;

      // Le markup d'auteur est neutralisé en TEXTE : encore lisible, plus exécutable.
      expect(result).toContain("&lt;img src=x onerror=alert(1)&gt;");
      expect(result).toContain("&lt;script&gt;");

      // La preuve qui compte n'est pas l'absence d'une sous-chaîne (le mot « onerror »
      // survit LÉGITIMEMENT dans du texte échappé) : c'est qu'il ne reste rien de vivant
      // dans le DOM — ni balise, ni gestionnaire d'événement.
      const host = document.createElement("div");
      host.innerHTML = result;
      expect(host.querySelector("img, script")).toBeNull();
      const handlers = Array.from(host.querySelectorAll("*")).flatMap((el) =>
        el.getAttributeNames().filter((name) => name.startsWith("on")),
      );
      expect(handlers).toEqual([]);
    });
  });

  describe("Libellés, sections et figures", () => {
    it("écrit le libellé dans la langue du CONTENU, pas de l'interface (R-8)", () => {
      const result = renderLesson("::: piege\nتحذير مهم.\n:::", { lang: "ar" }).html;
      expect(result).toContain('<span class="lesson-blk__label">تحذير</span>');
      expect(result).not.toContain("Piège");
    });

    it("retourne les sections `##` dans l'ordre, en texte brut, avec leurs ancres", () => {
      const { sections } = renderLesson("## Une **section**\ntexte\n## Deux\ntexte");
      expect(sections).toEqual([
        { id: "section-0", title: "Une section" },
        { id: "section-1", title: "Deux" },
      ]);
    });

    it("garde des ancres uniques quand un `##` vit dans un bloc", () => {
      const { sections, html: out } = renderLesson("## A\n\n::: methode\n## B\n:::");
      expect(sections.map((s) => s.id)).toEqual(["section-0", "section-1"]);
      expect(out).toContain('id="section-1"');
    });

    it("compte les figures embarquées", () => {
      const svg = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>';
      expect(renderLesson(`texte\n\n${svg}`).figureCount).toBe(1);
      expect(renderLesson("aucune figure").figureCount).toBe(0);
    });
  });
});

/**
 * Figures légendées — étude 18, lot 2.
 *
 * Une figure est une PLANCHE : légende, numéro, agrandissable. Les 186 figures nues des
 * 66 cours legacy reçoivent le MÊME habillage que celles d'une directive — une seule
 * figure, un seul markup, un seul chemin de code.
 */
describe("renderLesson — figures légendées", () => {
  const SVG = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>';

  it("légende et numérote une figure déclarée par directive", () => {
    const result = renderLesson(`::: figure Configuration de Thalès\n${SVG}\n:::`).html;
    expect(result).toContain('<figcaption class="lesson-figure__caption">');
    expect(result).toContain('<span class="lesson-figure__num">Figure 1</span>');
    expect(result).toContain("Configuration de Thalès");
  });

  it("numérote les figures dans l'ordre du document, nues et déclarées confondues", () => {
    const result = renderLesson(
      `${SVG}\n\ntexte\n\n::: figure La deuxième\n${SVG}\n:::\n\n${SVG}`,
    ).html;
    expect(result).toContain(">Figure 1<");
    expect(result).toContain(">Figure 2<");
    expect(result).toContain(">Figure 3<");
    expect(result).toContain("La deuxième");
  });

  it("habille une figure nue comme les autres, sans légende (les 66 cours legacy)", () => {
    const result = renderLesson(`Regarde :\n\n${SVG}`).html;
    expect(result).toContain('<figure class="lesson-figure"');
    expect(result).toContain('<div class="lesson-figure__plate">');
    expect(result).toContain('<span class="lesson-figure__num">Figure 1</span>');
    expect(result).toContain("<circle");
  });

  it("rend la figure agrandissable au clavier (role, tabindex, aria-label)", () => {
    const result = renderLesson(`::: figure Le triangle ABC\n${SVG}\n:::`).html;
    expect(result).toContain('role="button"');
    expect(result).toContain('tabindex="0"');
    expect(result).toContain('aria-label="Figure 1 — Le triangle ABC"');
  });

  it("numérote et libelle dans la langue du CONTENU (R-8)", () => {
    const result = renderLesson(`::: figure وضعية طاليس\n${SVG}\n:::`, { lang: "ar" }).html;
    expect(result).toContain("الشكل 1");
    expect(result).not.toContain("Figure 1");
  });

  it("échappe les GUILLEMETS d'une légende — l'aria-label est un attribut", () => {
    // escapeHtml n'échappe pas les quotes : un `"` dans une légende fermerait l'attribut.
    // C'est la seule porte d'injection que ce lot pouvait ouvrir.
    const result = renderLesson(
      `::: figure Le "triangle" ABC" onmouseover="alert(1)\n${SVG}\n:::`,
    ).html;
    expect(result).toContain("&quot;");

    const host = document.createElement("div");
    host.innerHTML = result;
    const figure = host.querySelector(".lesson-figure");
    expect(figure).not.toBeNull();
    // L'attribut a tenu : rien ne s'est échappé de ses guillemets.
    expect(figure?.getAttribute("onmouseover")).toBeNull();
    expect(figure?.getAttribute("aria-label")).toContain('Le "triangle" ABC');
    const handlers = Array.from(host.querySelectorAll("*")).flatMap((el) =>
      el.getAttributeNames().filter((name) => name.startsWith("on")),
    );
    expect(handlers).toEqual([]);
  });

  it("dégrade une `::: figure` SANS figure en bloc neutre (R-7)", () => {
    const result = renderLesson("::: figure Une légende orpheline\nMais aucun SVG.\n:::").html;
    expect(result).toContain("lesson-blk");
    expect(result).toContain("Mais aucun SVG.");
    expect(result).not.toContain("lesson-figure__plate");
  });
});
