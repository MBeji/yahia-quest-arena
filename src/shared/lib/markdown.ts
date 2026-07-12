import DOMPurify from "dompurify";
import { isolateLtrRunsHtml } from "@/shared/lib/bidi";
import { sanitizeSvg } from "@/shared/lib/figure";

/** A lesson may embed inline `<svg>…</svg>` figures (anatomy, geometry, diagrams). */
const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/gi;
/** Placeholder marker used to shelter an SVG figure from HTML-escaping and the final sanitize. */
const figurePlaceholder = (i: number) => `svgfigureplaceholder${i}end`;

/** Simple markdown-to-HTML renderer for lesson content */
export function renderMarkdown(md: string): string {
  // Pull inline <svg> figures out before HTML-escaping so their markup survives.
  // Each is sanitized through the vetted SVG profile (see docs/xss-rendering-policy.md)
  // and re-injected after the final sanitize pass, whose ALLOWED_TAGS deliberately
  // excludes SVG. Without this, escaping turns the markup into visible literal text.
  const figures: string[] = [];
  const sheltered = md.replace(SVG_BLOCK, (svg) => {
    const token = figurePlaceholder(figures.length);
    figures.push(sanitizeSvg(svg));
    return `\n\n${token}\n\n`;
  });

  let h2Counter = 0;
  let html = sheltered
    // Escape HTML
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    // Headings
    .replace(/^### (.+)$/gm, '<h3 class="lesson-h3">$1</h3>')
    .replace(/^## (.+)$/gm, (_match, title) => {
      const id = `section-${h2Counter++}`;
      return `<h2 class="lesson-h2" id="${id}">${title}</h2>`;
    })
    .replace(/^# (.+)$/gm, '<h1 class="lesson-h1">$1</h1>')
    // Bold
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
    // Italic
    .replace(/\*(.+?)\*/g, "<em>$1</em>")
    // Blockquotes
    .replace(/^&gt; (.+)$/gm, '<blockquote class="lesson-quote">$1</blockquote>')
    // Inline code / math $$
    .replace(/\$\$(.+?)\$\$/g, '<div class="lesson-math">$1</div>')
    // Horizontal rule
    .replace(/^---$/gm, '<hr class="lesson-hr" />')
    // Tables
    .replace(/^\|(.+)\|$/gm, (match) => {
      const cells = match
        .split("|")
        .filter(Boolean)
        .map((c) => c.trim());
      if (cells.every((c) => /^[-:]+$/.test(c))) return "<!--table-sep-->";
      const tag = "td";
      return `<tr>${cells.map((c) => `<${tag}>${c}</${tag}>`).join("")}</tr>`;
    })
    // Lists (simple)
    .replace(/^- (.+)$/gm, '<li class="lesson-li">$1</li>')
    .replace(/^(\d+)\. (.+)$/gm, '<li class="lesson-li lesson-oli">$2</li>');

  // Wrap consecutive <tr> in table
  html = html.replace(/((?:<tr>.*<\/tr>\n?)+)/g, '<table class="lesson-table">$1</table>');
  html = html.replace(/<!--table-sep-->\n?/g, "");

  // Wrap consecutive ordered <li> (class includes "lesson-oli") in <ol>
  html = html.replace(
    /((?:<li class="lesson-li lesson-oli">.*<\/li>\n?)+)/g,
    '<ol class="lesson-ol">$1</ol>',
  );
  // Wrap consecutive unordered <li> (exact "lesson-li") in <ul>
  html = html.replace(/((?:<li class="lesson-li">.*<\/li>\n?)+)/g, '<ul class="lesson-ul">$1</ul>');

  // Paragraphs: lines not starting with HTML tags
  html = html
    .split("\n")
    .map((line) => {
      if (!line.trim()) return "";
      if (/^<[a-z]/.test(line) || /^<!--/.test(line)) return line;
      return `<p>${line}</p>`;
    })
    .join("\n");

  // Keep inline math (`√64`, `√(25 × 2) = 5√2`, …) a contiguous LTR run inside
  // RTL prose; `$$ … $$` display blocks are already isolated via CSS.
  html = isolateLtrRunsHtml(html);

  const safe = DOMPurify.sanitize(html, {
    ALLOWED_TAGS: [
      "h1",
      "h2",
      "h3",
      "p",
      "strong",
      "em",
      "blockquote",
      "div",
      "hr",
      "table",
      "tr",
      "td",
      "th",
      "ul",
      "ol",
      "li",
    ],
    ALLOWED_ATTR: ["class", "id", "dir"],
  });

  if (figures.length === 0) return safe;
  // Re-inject each already-sanitized figure, replacing the paragraph the placeholder
  // ended up wrapped in (or the bare token, defensively).
  return figures.reduce((out, svg, i) => {
    const token = figurePlaceholder(i);
    // Function replacers avoid `$`-pattern interpretation inside the SVG markup.
    return out
      .replace(`<p>${token}</p>`, () => `<div class="lesson-figure">${svg}</div>`)
      .replace(token, () => `<div class="lesson-figure">${svg}</div>`);
  }, safe);
}
