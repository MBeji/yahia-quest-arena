import { describe, it, expect } from "vitest";
import { renderMarkdown } from "@/shared/lib/markdown";

describe("renderMarkdown", () => {
  describe("HTML escaping", () => {
    it("escapes < and >", () => {
      const result = renderMarkdown("<script>alert('xss')</script>");
      expect(result).not.toContain("<script>");
      expect(result).toContain("&lt;script&gt;");
    });

    it("escapes ampersands", () => {
      const result = renderMarkdown("A & B");
      expect(result).toContain("&amp;");
    });

    it("escapes event handler attributes", () => {
      const result = renderMarkdown('<img src=x onerror="alert(1)" />');
      expect(result).not.toContain("<img");
      expect(result).toContain('&lt;img src=x onerror="alert(1)" /&gt;');
    });

    it("escapes javascript URLs", () => {
      const result = renderMarkdown("[x](javascript:alert(1))");
      expect(result).toContain("javascript:alert(1)");
      expect(result).not.toContain("<a href=");
    });

    it("escapes quotes in raw html blocks", () => {
      const result = renderMarkdown('<div title="x"y">ok</div>');
      expect(result).not.toContain("<div");
      expect(result).toContain("&lt;div title=");
      expect(result).toContain("&gt;ok&lt;/div&gt;");
    });
  });

  describe("Headings", () => {
    it("renders h1", () => {
      const result = renderMarkdown("# Title");
      expect(result).toContain('<h1 class="lesson-h1">Title</h1>');
    });

    it("renders h2 with incremented IDs", () => {
      const result = renderMarkdown("## First\n## Second");
      expect(result).toContain('<h2 class="lesson-h2" id="section-0">First</h2>');
      expect(result).toContain('<h2 class="lesson-h2" id="section-1">Second</h2>');
    });

    it("renders h3", () => {
      const result = renderMarkdown("### Subtitle");
      expect(result).toContain('<h3 class="lesson-h3">Subtitle</h3>');
    });
  });

  describe("Inline formatting", () => {
    it("renders bold", () => {
      const result = renderMarkdown("This is **bold** text");
      expect(result).toContain("<strong>bold</strong>");
    });

    it("renders italic", () => {
      const result = renderMarkdown("This is *italic* text");
      expect(result).toContain("<em>italic</em>");
    });

    it("renders bold inside italic", () => {
      const result = renderMarkdown("***both***");
      expect(result).toContain("<strong>");
      expect(result).toContain("<em>");
    });
  });

  describe("Math blocks", () => {
    it("renders $$ math as div.lesson-math", () => {
      const result = renderMarkdown("$$x^2 + 1 = 0$$");
      expect(result).toContain('<div class="lesson-math">x^2 + 1 = 0</div>');
    });
  });

  describe("Blockquotes", () => {
    it("renders > as blockquote", () => {
      const result = renderMarkdown("> Important note");
      expect(result).toContain('<blockquote class="lesson-quote">Important note</blockquote>');
    });
  });

  describe("Horizontal rules", () => {
    it("renders --- as hr", () => {
      const result = renderMarkdown("---");
      expect(result).toContain('<hr class="lesson-hr"');
    });
  });

  describe("Lists", () => {
    it("renders unordered list items", () => {
      const result = renderMarkdown("- Item one\n- Item two");
      expect(result).toContain('<li class="lesson-li">Item one</li>');
      expect(result).toContain('<li class="lesson-li">Item two</li>');
    });

    it("wraps consecutive li in ul", () => {
      const result = renderMarkdown("- A\n- B\n- C");
      expect(result).toContain('<ul class="lesson-ul">');
    });

    it("renders ordered list items", () => {
      const result = renderMarkdown("1. First\n2. Second");
      expect(result).toContain("lesson-oli");
      expect(result).toContain("First");
      expect(result).toContain("Second");
    });

    it("wraps consecutive ordered li in ol (not orphan li)", () => {
      const result = renderMarkdown("1. First\n2. Second\n3. Third");
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
      const result = renderMarkdown(md);
      expect(result).toContain('<table class="lesson-table">');
      expect(result).toContain("<td>A</td>");
      expect(result).toContain("<td>1</td>");
    });

    it("removes table separator rows", () => {
      const md = "| H1 | H2 |\n|---|---|\n| D1 | D2 |";
      const result = renderMarkdown(md);
      expect(result).not.toContain("<!--table-sep-->");
    });
  });

  describe("Paragraphs", () => {
    it("wraps plain text in <p>", () => {
      const result = renderMarkdown("Just text");
      expect(result).toContain("<p>Just text</p>");
    });

    it("does not wrap HTML tags in <p>", () => {
      const result = renderMarkdown("# Heading");
      expect(result).not.toContain("<p><h1");
    });

    it("removes empty lines", () => {
      const result = renderMarkdown("Line 1\n\nLine 2");
      const lines = result.split("\n").filter(Boolean);
      expect(lines.every((l) => l.length > 0)).toBe(true);
    });
  });

  describe("Inline SVG figures", () => {
    const FIGURE = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4" fill="#fff"/></svg>';

    it("renders an inline svg as a real figure, not escaped text", () => {
      const result = renderMarkdown(`Look:\n\n${FIGURE}\n\ndone`);
      expect(result).toContain('<div class="lesson-figure">');
      expect(result).toContain("<svg");
      expect(result).toContain("<circle");
      // Must NOT have been escaped into literal text
      expect(result).not.toContain("&lt;svg");
    });

    it("keeps surrounding markdown working around a figure", () => {
      const result = renderMarkdown(`# Title\n\n${FIGURE}\n\n**bold**`);
      expect(result).toContain('<h1 class="lesson-h1">Title</h1>');
      expect(result).toContain("<strong>bold</strong>");
      expect(result).toContain('<div class="lesson-figure">');
    });

    it("does not wrap the figure in a paragraph", () => {
      const result = renderMarkdown(FIGURE);
      expect(result).not.toContain("<p><div");
      expect(result).not.toMatch(/<p>svgfigureplaceholder/);
    });

    it("renders multiple figures independently", () => {
      const result = renderMarkdown(`${FIGURE}\n\ntext\n\n${FIGURE}`);
      expect(result.match(/<div class="lesson-figure">/g)).toHaveLength(2);
      expect(result).not.toContain("svgfigureplaceholder");
    });

    it("sanitizes script and event handlers out of an embedded svg", () => {
      const evil =
        '<svg viewBox="0 0 10 10"><script>alert(1)</script><circle cx="5" cy="5" r="4" onclick="alert(2)"/></svg>';
      const result = renderMarkdown(evil);
      expect(result).toContain('<div class="lesson-figure">');
      expect(result).not.toContain("<script");
      expect(result).not.toContain("onclick");
    });

    it("strips external references from an embedded svg", () => {
      const evil =
        '<svg viewBox="0 0 10 10"><image href="https://evil.example/x.png"/><use xlink:href="#x"/></svg>';
      const result = renderMarkdown(evil);
      expect(result).not.toContain("evil.example");
      expect(result).not.toContain("<image");
      expect(result).not.toContain("<use");
    });
  });

  describe("Complex content", () => {
    it("handles Arabic text without mangling", () => {
      const result = renderMarkdown("# درس الرياضيات\n\nمرحبا بكم");
      expect(result).toContain("درس الرياضيات");
      expect(result).toContain("مرحبا بكم");
    });

    it("handles mixed Arabic and math", () => {
      const result = renderMarkdown("حل المعادلة: $$x + 2 = 5$$");
      expect(result).toContain("حل المعادلة:");
      expect(result).toContain('<div class="lesson-math">x + 2 = 5</div>');
    });
  });
});
