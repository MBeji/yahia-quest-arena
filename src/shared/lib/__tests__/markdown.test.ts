import { describe, it, expect } from "vitest";
import { renderLesson, renderSummary } from "@/shared/lib/markdown";

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

    // Prettier normalise `*x*` en `_x_` sur tout le corpus : les deux formes sont de l'italique.
    it("renders underscore italic, including after an apostrophe", () => {
      const result = html("Ne confonds pas l'_éminent_ et l'_imminent_, ni _accepter_.");
      expect(result).toContain("l'<em>éminent</em>");
      expect(result).toContain("l'<em>imminent</em>,");
      expect(result).toContain("<em>accepter</em>.");
      expect(result).not.toContain("_");
    });

    // 2026-11-15 — un exemple cité ou qui s'ouvre sur un mot en gras gardait ses soulignés à
    // l'écran : ~1 950 passages dans 135 cours, surtout de français et d'anglais.
    it("renders underscore italic that opens on a quote, a bracket or a bold word", () => {
      const result = html(
        [
          "_« Faut-il vraiment rappeler que la liberté n'a pas de prix ? »_ → question rhétorique.",
          "",
          '_"Where do you live?"_ becomes reported speech.',
          "",
          "_**Certes**, la réforme a un coût ; **mais** il est dérisoire._ → concession.",
          "",
          "_(a plan I already made)_",
        ].join("\n"),
      );
      expect(result).toContain(
        "<em>« Faut-il vraiment rappeler que la liberté n'a pas de prix ? »</em>",
      );
      expect(result).toContain('<em>"Where do you live?"</em>');
      expect(result).toContain(
        "<em><strong>Certes</strong>, la réforme a un coût ; <strong>mais</strong> il est dérisoire.</em>",
      );
      expect(result).toContain("<em>(a plan I already made)</em>");
      expect(result).not.toContain("_");
    });

    it("leaves a fill-in blank alone", () => {
      const result = html("Complète : il ___ parti, puis elle ___ arrivée.");
      expect(result).not.toContain("<em>");
      expect(result).toContain("il ___ parti");
    });

    it("leaves formula subscripts alone", () => {
      const result = html("L'aire S_D vaut 4, t_u(M) = M' et ∫_{1} f + ∫_{2} g.");
      expect(result).not.toContain("<em>");
      expect(result).toContain("S_D");
      expect(result).toContain("∫_{1} f + ∫_{2} g");
    });

    it("renders an escaped asterisk or underscore as the bare character", () => {
      const result = html("Note \\* : le signe \\_ reste tel quel, et *ceci* est en italique.");
      expect(result).toContain("Note * : le signe _ reste tel quel");
      expect(result).toContain("<em>ceci</em>");
      expect(result).not.toContain("\\");
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
      expect(result).toContain('<th scope="col">A</th>');
      expect(result).toContain("<td>1</td>");
    });

    it("removes table separator rows", () => {
      const md = "| H1 | H2 |\n|---|---|\n| D1 | D2 |";
      const result = html(md);
      expect(result).not.toContain("<!--table-sep-->");
    });

    // Le séparateur `|---|` coupait la série de `<tr>` consécutifs AVANT le wrap : l'en-tête
    // partait dans SON propre `<table>`, le corps dans un second. Deux tables `display:block`
    // côte à côte ne partagent aucune largeur de colonne — d'où l'en-tête ratatiné à gauche
    // au-dessus d'un corps pleine largeur, vu en prod sur un cours (tableau des fardhs).
    it("keeps the header row in the SAME table as the body rows", () => {
      const md = "| H1 | H2 |\n|---|---|\n| D1 | D2 |\n| D3 | D4 |";
      const result = html(md);
      expect(result.match(/<table class="lesson-table">/g)).toHaveLength(1);
      // Les trois lignes vivent dans LA table — `tbody` est ajouté par DOMPurify, pas par nous.
      const table = result.match(/<table class="lesson-table">([\s\S]*?)<\/table>/)?.[1] ?? "";
      expect(table).toContain('<tr><th scope="col">H1</th><th scope="col">H2</th></tr>');
      expect(table).toContain("<tr><td>D1</td><td>D2</td></tr>");
      expect(table).toContain("<tr><td>D3</td><td>D4</td></tr>");
    });

    // Corollaire du même défaut : le fond d'en-tête se posait sur `tr:first-child`. Avec la
    // table coupée en deux, la PREMIÈRE ligne de données était aussi un `tr:first-child` et
    // héritait de ce fond (ligne « النيّة » surlignée dans la capture).
    it("leaves a single first row to carry the header styling", () => {
      const md = "| H1 | H2 |\n|---|---|\n| D1 | D2 |\n| D3 | D4 |";
      const rows = html(md).split("<tr>").length - 1;
      expect(rows).toBe(3);
      expect(html(md).indexOf("<tr><td>D1")).toBeGreaterThan(html(md).indexOf("<tr><th scope"));
    });

    it("still separates two tables split by a blank line", () => {
      const md = "| A | B |\n|---|---|\n| 1 | 2 |\n\n| C | D |\n|---|---|\n| 3 | 4 |";
      const result = html(md);
      expect(result.match(/<table class="lesson-table">/g)).toHaveLength(2);
      // Chaque table a SON en-tête — le second séparateur promeut la ligne « C | D ».
      expect(result.match(/<th scope="col">/g)).toHaveLength(4);
    });

    // La ligne de séparation est ce qui DÉSIGNE l'en-tête. Sans elle, pas d'en-tête : la
    // position d'une ligne ne dit pas son rôle, et un `<th>` posé au jugé mentirait au
    // lecteur d'écran.
    it("emits no header cell when the table has no separator row", () => {
      const result = html("| A | B |\n| 1 | 2 |");
      expect(result).toContain('<table class="lesson-table">');
      expect(result).not.toContain("<th");
      expect(result).toContain("<td>A</td>");
    });

    // `scope` rattache la colonne pour un lecteur d'écran — il ne sert à rien s'il tombe au
    // sanitize, et l'allowlist de DOMPurify le rejetait jusqu'ici.
    it("keeps scope through the sanitize step", () => {
      const result = html("| H1 | H2 |\n|---|---|\n| D1 | D2 |");
      expect(result).toContain('scope="col"');
      expect(result.match(/<th scope="col">/g)).toHaveLength(2);
    });

    it("drops an orphan separator with no row above it", () => {
      const result = html("|---|---|\n| 1 | 2 |");
      expect(result).not.toContain("<!--table-sep-->");
      expect(result).not.toContain("<th");
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

    // 2026-11-15, constaté dans le HTML servi en production : une ligne qui commence par du
    // gras ou de l'italique n'était pas un paragraphe — deux définitions écrites l'une sous
    // l'autre se fondaient en une seule ligne de texte.
    it("fait un paragraphe d'une ligne qui commence par du gras ou de l'italique", () => {
      const result = html(
        "**المشبَّهُ**: الشّيءُ الذي نتحدّثُ عنه.\n**المشبَّهُ به**: الشّيءُ الذي نشبّهُ به.\n_Direct:_ exemple.",
      );
      expect(result.match(/<p>/g)).toHaveLength(3);
      expect(result).toContain("<p><strong>المشبَّهُ</strong>: الشّيءُ الذي نتحدّثُ عنه.</p>");
      expect(result).toContain("<p><em>Direct:</em> exemple.</p>");
    });

    // Même constat : `<p></ul></p>` derrière chaque liste, que le navigateur répare en
    // paragraphes vides — un blanc de trop, et un HTML différent entre serveur et navigateur.
    it("n'enveloppe jamais la balise fermante d'une liste ou d'un tableau", () => {
      const result = renderLesson(
        "- un\n- deux\n\nSuite.\n\n| a | b |\n|---|---|\n| 1 | 2 |\n\nFin.",
      );
      expect(result.html).not.toMatch(/<p>\s*<\/(?:ul|ol|table)>/);
      expect(result.html).not.toContain("<p></p>");
      expect(result.html).toContain("<p>Suite.</p>");
      expect(result.html).toContain("<p>Fin.</p>");
    });

    it("fait un paragraphe du texte qui suit une liste ou un tableau sans ligne vide", () => {
      expect(html("- un\n- deux\nUne phrase qui suit la liste.")).toContain(
        "<p>Une phrase qui suit la liste.</p>",
      );
      expect(html("| a | b |\nUne phrase qui suit le tableau.")).toContain(
        "<p>Une phrase qui suit le tableau.</p>",
      );
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

// Audits arabe 9ᵉ (chapitres 09 et 10) : le guillemet était enfermé dans l'isolat LTR avec le
// numéro de phrase ou la flèche, et se dessinait du mauvais côté. Dans le cours rendu, aucun
// isolat ne contient plus de guillemet, et la flèche de prose n'est plus isolée.
describe("renderLesson — guillemets et flèche de prose en arabe", () => {
  it("laisse les guillemets hors des isolats et la flèche de prose sans isolat", () => {
    const out = renderLesson(
      [
        "«(1) في رأيي أنّ الصدقَ أساسُ الثقةِ. (2) فقد قالَ المثلُ.» ما الركنُ الغائبُ؟",
        "",
        "2. **ولو قالتْ** «الشمسُ تُشرقُ من المشرقِ» ← لا يعترضُ أحدٌ ← لا حجاجَ.",
      ].join("\n"),
      { lang: "ar" },
    ).html;
    expect(out).toContain("«\u2066(1)\u2069 في رأيي");
    expect(out).not.toMatch(/\u2066[^\u2069]*[«»][^\u2069]*\u2069/u);
    expect(out).toContain("«الشمسُ تُشرقُ من المشرقِ» ← لا يعترضُ أحدٌ ← لا حجاجَ.");
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

    // Forme réelle (maths 6ᵉ, chapitre 01) : le piège est renvoyé à la ligne vers 100 signes.
    // Rendu ligne à ligne, il devenait un fragment nu puis un `<p>` par ligne suivante — la
    // phrase « يقرأ «مئتان / وثلاثون مليونًا…» » coupée au milieu, en deux blocs.
    it("recolle les lignes d'un même paragraphe de piège, comme Markdown standard", () => {
      const md = [
        "## S",
        "",
        "> ⚠️ **الخطأ الشائع (1)**: التجميع من اليسار. من يجمّع 2305040 هكذا: 230 | 504 | 0، يقرأ «مئتان",
        "> وثلاثون مليونًا…»، وهو عدد أكبر بمئة مرّة. الأصناف تُقرأ من اليمين: 2 | 305 | 040.",
      ].join("\n");
      const block = renderLesson(md, { lang: "ar" }).html.split('lesson-blk--piege">')[1];
      // UN paragraphe — et c'en est un, même s'il commence par du gras : nu, il restait collé
      // au libellé du bloc (« تحذير » puis « الخطأ الشائع » sans espace, sur la même ligne).
      expect(block.match(/<p>/g)).toHaveLength(1);
      expect(block).toContain("</span><p><strong>");
      expect(block).not.toContain("\n");
      expect(block).toContain("يقرأ «مئتان وثلاثون مليونًا…»");
    });

    it("recolle un piège de trois lignes et plus en un seul paragraphe", () => {
      const result = html("## S\n\n> ⚠️ Une phrase qui\n> continue ici\n> et finit là.");
      expect(result).toContain("<p>Une phrase qui continue ici et finit là.</p>");
      expect(result.match(/<p>/g)).toHaveLength(1);
    });

    it("garde deux paragraphes séparés par une ligne `>` vide", () => {
      const result = html(
        "## S\n\n> ⚠️ Premier paragraphe\n> sur deux lignes.\n>\n> Second\n> paragraphe.",
      );
      expect(result).toContain("Premier paragraphe sur deux lignes.");
      expect(result).toContain("<p>Second paragraphe.</p>");
    });

    it("ne recolle ni une liste, ni un tableau, ni une formule, ni un saut forcé", () => {
      const list = html("## S\n\n> ⚠️ Pièges classiques :\n>\n> - premier\n> - second");
      expect(list).toContain('<li class="lesson-li">premier</li>');
      expect(list).toContain('<li class="lesson-li">second</li>');

      const table = html("## S\n\n> 🗡️ Deux colonnes :\n> | a | b |\n> | 1 | 2 |");
      expect(table).toContain('<table class="lesson-table">');
      expect(table).not.toContain("colonnes : |");

      const math = html("## S\n\n> ⚠️ On a :\n> $$ x = 2 $$");
      expect(math).toContain('<div class="lesson-math"> x = 2 </div>');

      const forced = html("## S\n\n> ⚠️ Ligne une  \n> Ligne deux.");
      expect(forced).toContain("<p>Ligne deux.</p>");
    });

    it("ne recolle pas deux callouts consécutifs", () => {
      const result = html("## S\n\n> 🗡️ Une astuce.\n> ⚠️ Un piège.");
      expect(result.match(/lesson-blk--astuce/g)).toHaveLength(1);
      expect(result.match(/lesson-blk--piege/g)).toHaveLength(1);
      expect(result).not.toContain("astuce. Un piège");
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

/**
 * Le contrôle sur place — étude 35, lot 1.
 *
 * Le couple « exemple résolu → à toi de jouer » est le résultat le mieux établi de tout le
 * corpus de preuves rassemblé par l'étude, et il n'avait AUCUNE syntaxe : le renderer ne
 * savait rien replier. Ce bloc est le seul du vocabulaire dont le corps a deux côtés.
 */
describe("renderLesson — le bloc `verifie` (étude 35)", () => {
  const CHECK = [
    "::: verifie",
    "Un robinet donne 4 litres par minute. Que vaut f(7) ?",
    "---",
    "f(7) = 28 litres, car f(x) = 4x.",
    ":::",
  ].join("\n");

  it("replie la réponse dans un `details` natif et laisse la question visible", () => {
    const out = html(CHECK);
    expect(out).toContain('<section class="lesson-blk lesson-blk--verifie">');
    expect(out).toContain('<div class="lesson-check__question">');
    expect(out).toContain('<details class="lesson-check">');
    expect(out).toContain('<summary class="lesson-check__toggle">Voir la réponse</summary>');
    expect(out).toContain('<div class="lesson-check__answer">');
    // La question est dehors, la réponse dedans — l'ordre est ce qui fait le contrôle.
    expect(out.indexOf("Que vaut f(7)")).toBeLessThan(out.indexOf("<details"));
    expect(out.indexOf("<details")).toBeLessThan(out.indexOf("f(7) = 28"));
  });

  it("n'émet JAMAIS `open` — le contenu ne décide pas qu'une réponse est déjà révélée", () => {
    expect(html(CHECK)).not.toContain("open");
    // Et un auteur qui l'écrirait à la main ne peut pas l'obtenir non plus.
    expect(html("::: verifie\nQ\n---\n<details open>R</details>\n:::")).not.toContain(
      "<details open>",
    );
  });

  it("écrit le libellé du bloc ET du bouton dans la langue du CONTENU (R-8/R-18)", () => {
    const ar = renderLesson(CHECK, { lang: "ar" }).html;
    expect(ar).toContain("جرّب بنفسك");
    expect(ar).toContain("أظهر الإجابة");
    const en = renderLesson(CHECK, { lang: "en" }).html;
    expect(en).toContain("Your turn");
    expect(en).toContain("Show the answer");
  });

  it("scinde au PREMIER `---` — les suivants restent du markdown dans la réponse", () => {
    const out = html("::: verifie\nQ\n---\nR1\n---\nR2\n:::");
    expect(out.match(/<details/g)).toHaveLength(1);
    expect(out).toContain('<hr class="lesson-hr">');
  });

  it("dégrade en bloc neutre SANS séparateur — tout visible, jamais de page cassée (R-17)", () => {
    const out = html("::: verifie\nUne question sans réponse.\n:::");
    expect(out).toContain("lesson-blk lesson-blk--verifie");
    expect(out).not.toContain("<details");
    expect(out).toContain("Une question sans réponse.");
  });

  it("dégrade de même quand un côté est vide", () => {
    expect(html("::: verifie\nQ\n---\n\n:::")).not.toContain("<details");
    expect(html("::: verifie\n\n---\nR\n:::")).not.toContain("<details");
  });

  it("laisse un `---` hors bloc devenir un `<hr>` — aucune régression", () => {
    expect(html("Avant\n\n---\n\nAprès")).toContain('<hr class="lesson-hr">');
  });

  it("échappe les deux côtés — l'invariant R-1 ne connaît pas d'exception", () => {
    const out = html(
      "::: verifie\n<img src=x onerror=alert(1)>\n---\n<script>alert(2)</script>\n:::",
    );
    expect(out).not.toContain("<img");
    expect(out).not.toContain("<script>");
    expect(out).toContain("&lt;script&gt;");
  });

  it("rend le markdown des deux côtés (formule isolée, liste)", () => {
    const out = html("::: verifie\n$$ f(x) = 4x $$\n---\n- Première étape\n- Seconde étape\n:::");
    expect(out).toContain('<div class="lesson-math">');
    expect(out).toContain('<ul class="lesson-ul">');
  });

  it("garde la formule LTR au milieu d'une prose arabe, des deux côtés", () => {
    const out = renderLesson("::: verifie\nما قيمة √64 ؟\n---\nالجواب √64 = 8\n:::", {
      lang: "ar",
    }).html;
    expect(out).toContain("√64");
    expect(out).toContain("<details");
  });

  it("porte son titre libre, échappé comme tout texte d'auteur", () => {
    const out = html('::: verifie Le robinet & "la citerne"\nQ\n---\nR\n:::');
    expect(out).toContain('<p class="lesson-blk__title">Le robinet &amp; "la citerne"</p>');
  });
});

describe("renderSummary — le résumé ne pose pas de question (é35 R-21)", () => {
  it("ne replie RIEN : un résumé n'a pas de grammaire de blocs, donc rien à cacher", () => {
    const out = renderSummary("- **Concept** : essence\n\n::: verifie\nQ\n---\nR\n:::").html;
    expect(out).not.toContain("<details");
    expect(out).toContain('<ul class="lesson-cards">');
  });
});

// Capture du propriétaire, 2026-11-15 — cours « الأعداد الحقيقية » (9ᵉ) : une phrase arabe
// coupée en quatre paragraphes, au milieu d'une proposition. Le rendu faisait un paragraphe de
// CHAQUE ligne du fichier, et la moitié du corpus renvoie ses paragraphes à la ligne vers
// 100 signes (483 cours sur 968).
describe("renderLesson — les renvois à la ligne de l'auteur", () => {
  const paragraphs = (md: string) => html(md).match(/<p>[\s\S]*?<\/p>/g) ?? [];
  // Le paragraphe de la capture, tel qu'il est écrit dans le corpus.
  const WRAPPED = [
    "عُدَّ تلاميذ قسمك: 28. عدد صحيح طبيعي، ولا حاجة إلى غيره. لكن سجّل درجة الحرارة في ليلة شتاء",
    "بالقصرين: −3 °C، فقد خرجتَ من ℕ. زِن كيلوغرامًا ونصفًا من اللحم: 1,5 kg، فقد خرجتَ من ℤ. اقسم",
    "رغيفًا على ثلاثة: 1/3، وقد خرجتَ من العشريّات. فهل ينتهي الأمر هنا، أم يوجد عدد لا يُكتب حتى",
    "على شكل كسر؟",
  ].join("\n");

  it("recolle un paragraphe renvoyé à la ligne : une phrase, un paragraphe", () => {
    const out = paragraphs(WRAPPED);
    expect(out).toHaveLength(1);
    expect(out[0]).toContain("في ليلة شتاء بالقصرين");
    expect(out[0]).toContain("اقسم رغيفًا على ثلاثة");
    expect(out[0]).toContain("حتى على شكل كسر؟");
  });

  it("garde une ligne par phrase quand l'auteur l'a voulu — la ligne finit sa phrase", () => {
    const md = [
      "**Non, il l'infirme** : il montre une limite du travail en groupe et s'oppose donc à la thèse.",
      "Un argument qui la confirmerait : chacun explique aux autres ce qu'il a compris.",
    ].join("\n");
    expect(paragraphs(md)).toHaveLength(2);
  });

  it("garde les lignes courtes : paires d'exemples, égalités, répliques", () => {
    expect(
      paragraphs('_Direct:_ _"Where do you live?"_\n_Reported:_ _He asked me **where I lived**._'),
    ).toHaveLength(2);
    expect(paragraphs("f(x) = 5x + 3\nما صورة العدد −2؟ وما سابقة العدد 18؟")).toHaveLength(2);
    expect(
      paragraphs(
        "• échanger deux de ses vecteurs change son orientation ;\n• une permutation la conserve ;",
      ),
    ).toHaveLength(2);
  });

  it("ne recolle pas après deux points : la ligne suivante est ce qu'ils annoncent", () => {
    const md = [
      "المقام المشترك 8: 3/4 = 6/8، و 1/2 = 4/8، و 5/8 يبقى كما هو. تنازليًّا نبدأ بالبسط الأكبر:",
      "6 > 5 > 4، إذن 3/4 > 5/8 > 1/2.",
    ].join("\n");
    expect(paragraphs(md)).toHaveLength(2);
  });

  it("respecte un saut de ligne forcé, même sur une ligne longue et inachevée", () => {
    const long =
      "Une ligne assez longue pour ressembler à un renvoi, mais que son auteur a terminée par un saut forcé";
    expect(paragraphs(`${long}\\\nla suite`)).toHaveLength(2);
    expect(paragraphs(`${long}  \nla suite`)).toHaveLength(2);
    expect(paragraphs(`${long}\nla suite`)).toHaveLength(1);
  });

  it("ne recolle rien à un titre, un tableau, une formule ou un trait", () => {
    const long =
      "Une ligne assez longue pour ressembler à un renvoi à la ligne, et qui ne finit pas sa phrase";
    const out = html(`## Titre\n${long}\n| a | b |\n${long}\n$$x = 1$$\n${long}\n---\n${long}`);
    expect(out.match(/<p>/g)).toHaveLength(4);
    expect(out).toContain(">Titre</h2>");
    expect(out).toContain('<div class="lesson-math">x = 1</div>');
  });

  it("laisse un bloc de code ligne à ligne", () => {
    const code = [
      "```pascal",
      "While (c1 <= n1) And (c2 <= n2) And (trouve = False) And (fin_de_fichier = False) Do",
      "  Begin",
      "```",
    ].join("\n");
    expect(html(code)).toContain("Do</p>\n<p>  Begin</p>");
  });

  // Un gras ouvert sur une ligne et fermé sur la suivante gardait ses astérisques à l'écran.
  it("rend le gras qui enjambe un renvoi à la ligne", () => {
    const md = [
      "Le pronom relatif se choisit d'après la construction du verbe de la subordonnée, **jamais",
      "d'après l'antécédent seul**.",
    ].join("\n");
    const out = html(md);
    expect(out).toContain("<strong>jamais d'après l'antécédent seul</strong>.");
    expect(out).not.toContain("*");
  });

  it("recolle aussi dans un bloc `:::` et dans la réponse d'un `verifie`", () => {
    const body = WRAPPED.split("\n").slice(0, 2).join("\n");
    const out = html(`::: definition\n${body}\n:::`);
    expect(out.match(/<p>/g)).toHaveLength(1);
    expect(out).toContain("lesson-blk--definition");
  });
});

describe("renderLesson — ce qui appartient à un item de liste y reste", () => {
  const ITEM =
    "- **الدّورة الدّمويّة الكبرى**: مسار الدّم من القلب إلى بقيّة أعضاء الجسم ومنها إلى القلب، حيث يضخّ";

  it("recolle la suite d'un item renvoyé à la ligne : un item, une liste", () => {
    const out = html(`${ITEM}\n  البطين الأيسر الدّم المؤكسج.\n- **الصّغرى**: من القلب إلى الرّئتين.`);
    expect(out.match(/<ul class="lesson-ul">/g)).toHaveLength(1);
    expect(out.match(/<li class="lesson-li">/g)).toHaveLength(2);
    expect(out).toContain("حيث يضخّ البطين الأيسر الدّم المؤكسج.</li>");
    expect(out).not.toContain("<p>");
  });

  it("garde sous son item, sur sa propre ligne, un exemple qui ne le continue pas", () => {
    const out = html(
      "- **Auxiliaire ÊTRE** → le participe s'accorde avec le **sujet**.\n  _Elles **sont parties**._\n- **Auxiliaire AVOIR** → pas d'accord avec le sujet.",
    );
    expect(out.match(/<ul class="lesson-ul">/g)).toHaveLength(1);
    expect(out).toContain(
      '<strong>sujet</strong>.<span class="lesson-li__more"><em>Elles <strong>sont parties</strong>.</em></span></li>',
    );
  });

  it("range une sous-puce dans son item, sans son tiret", () => {
    const out = html(
      "- Les états de la matière :\n  - solide\n  - liquide\n- Les changements d'état.",
    );
    expect(out.match(/<ul class="lesson-ul">/g)).toHaveLength(1);
    expect(out).toContain(
      'matière :<span class="lesson-li__more lesson-li__more--bullet">solide</span><span class="lesson-li__more lesson-li__more--bullet">liquide</span></li>',
    );
  });

  it("garde une liste numérotée d'un seul tenant quand ses items sont renvoyés à la ligne", () => {
    const out = html(
      [
        "1. نحسب الترتيب بتعويض 3 في إحدى الدالتَين ثمّ نتحقّق بالدالّة الأخرى حتّى نتأكّد من أنّ النقطة",
        "   مشتركة بين المستقيمين.",
        "2. نستنتج إحداثيّتي نقطة التقاطع.",
        "3. نكتب الجواب.",
      ].join("\n"),
    );
    expect(out.match(/<ol class="lesson-ol">/g)).toHaveLength(1);
    expect(out.match(/lesson-oli/g)).toHaveLength(3);
    expect(out).toContain("أنّ النقطة مشتركة بين المستقيمين.</li>");
  });

  it("une ligne NON indentée après une liste reste un paragraphe à part", () => {
    const out = html("- un\n- deux\nUne phrase qui suit la liste.");
    expect(out).toContain("</ul>");
    expect(out).toContain("<p>Une phrase qui suit la liste.</p>");
  });
});
