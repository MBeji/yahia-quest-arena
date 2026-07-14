import DOMPurify from "dompurify";
import { isolateLtrRunsHtml } from "@/shared/lib/bidi";
import { sanitizeSvg } from "@/shared/lib/figure";
import {
  BLOCK_LABELS,
  isDirectiveType,
  markerBlockType,
  type ContentLang,
  type LessonBlockType,
} from "@/shared/lib/lesson-blocks";

/** A lesson may embed inline `<svg>…</svg>` figures (anatomy, geometry, diagrams). */
const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/gi;
/** Placeholder marker used to shelter an SVG figure from HTML-escaping and the final sanitize. */
const figurePlaceholder = (i: number) => `svgfigureplaceholder${i}end`;

/** `::: <type>[ <titre>]` … `:::` — la seule syntaxe d'auteur ajoutée par l'étude 18 (R-6). */
const DIRECTIVE_OPEN = /^:::[ \t]+([a-z]+)(?:[ \t]+(.*))?$/;
const DIRECTIVE_CLOSE = /^:::[ \t]*$/;
/** Une ligne de citation, `> ` retiré. */
const QUOTE_LINE = /^>[ \t]?(.*)$/;
/** Une section `##`+ a commencé : au-delà, un `> 💡` n'est plus l'épigraphe. */
const SECTION_HEADING = /^#{2,}[ \t]/;

export type LessonSection = { id: string; title: string };

export type RenderedLesson = {
  /** HTML assaini, prêt pour `dangerouslySetInnerHTML`. */
  html: string;
  /** Sections `##` dans l'ordre du document — le sommaire est construit en React,
   *  pour qu'aucun `href` n'entre dans la chaîne HTML injectée. */
  sections: LessonSection[];
  figureCount: number;
};

type Segment =
  | { kind: "raw"; lines: string[] }
  /** `type: null` = directive de type inconnu → bloc neutre, jamais une page cassée (R-7). */
  | {
      kind: "block";
      type: LessonBlockType | null;
      title: string | null;
      lines: string[];
      epigraph: boolean;
    };

type Ctx = { lang: ContentLang; sections: LessonSection[]; h2: number };

const escapeHtml = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

/** Inverse exact de `escapeHtml` (on n'échappe que ces trois entités) + emphase markdown
 *  retirée : le sommaire est du TEXTE rendu par React, pas du HTML. */
const toPlainText = (s: string) =>
  s
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&amp;/g, "&")
    .replace(/\*\*/g, "")
    .replace(/\*/g, "")
    .trim();

/**
 * Découpe la leçon en segments AVANT tout échappement : blocs `:::`, callouts promus, et
 * le reste (« raw ») qui traverse le pipeline historique inchangé.
 */
function segment(src: string): Segment[] {
  const lines = src.split("\n");
  const out: Segment[] = [];
  let raw: string[] = [];
  let sectionStarted = false;
  let epigraphTaken = false;

  const flushRaw = () => {
    if (raw.length) out.push({ kind: "raw", lines: raw });
    raw = [];
  };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    const open = DIRECTIVE_OPEN.exec(line);
    if (open) {
      flushRaw();
      const body: string[] = [];
      let j = i + 1;
      while (
        j < lines.length &&
        !DIRECTIVE_CLOSE.test(lines[j]) &&
        !DIRECTIVE_OPEN.test(lines[j])
      ) {
        body.push(lines[j]);
        j++;
      }
      const closed = j < lines.length && DIRECTIVE_CLOSE.test(lines[j]);
      const declared = open[1];
      out.push({
        kind: "block",
        type: isDirectiveType(declared) ? declared : null,
        title: open[2]?.trim() || null,
        lines: body,
        epigraph: false,
      });
      // Une directive non fermée est implicitement close en fin de document (ou devant la
      // directive suivante) : une faute d'auteur dégrade le style, jamais la lecture (R-7).
      i = closed ? j : j - 1;
      continue;
    }

    const quote = QUOTE_LINE.exec(line);
    const promoted = quote ? markerBlockType(quote[1]) : null;
    if (quote && promoted) {
      flushRaw();
      const body = [promoted.rest];
      // Lignes de continuation : les `> …` suivantes qui n'ouvrent PAS un nouveau callout.
      let j = i + 1;
      while (j < lines.length) {
        const next = QUOTE_LINE.exec(lines[j]);
        if (!next || markerBlockType(next[1])) break;
        body.push(next[1]);
        j++;
      }
      // Le premier `> 💡` posé avant la première section est l'épigraphe du chapitre
      // (style-guide.md § squelette cours.md, ligne 21) ; les suivants sont des éclairages.
      const epigraph = promoted.type === "insight" && !sectionStarted && !epigraphTaken;
      if (epigraph) epigraphTaken = true;
      out.push({ kind: "block", type: promoted.type, title: null, lines: body, epigraph });
      i = j - 1;
      continue;
    }

    if (SECTION_HEADING.test(line)) sectionStarted = true;
    raw.push(line);
  }

  flushRaw();
  return out;
}

/**
 * Le pipeline historique, appliqué à un segment. Inchangé dans son comportement : c'est ce
 * qui garantit qu'aucune assertion des tests existants (échappement, listes, tableaux,
 * figures, RTL) ne bouge. Seul le compteur de `##` devient partagé, pour que les ancres
 * restent uniques d'un segment à l'autre.
 */
function renderChunk(lines: string[], ctx: Ctx): string {
  let html = escapeHtml(lines.join("\n"))
    // Headings
    .replace(/^### (.+)$/gm, '<h3 class="lesson-h3">$1</h3>')
    .replace(/^## (.+)$/gm, (_match, title: string) => {
      const id = `section-${ctx.h2++}`;
      ctx.sections.push({ id, title: toPlainText(title) });
      return `<h2 class="lesson-h2" id="${id}">${title}</h2>`;
    })
    .replace(/^# (.+)$/gm, '<h1 class="lesson-h1">$1</h1>')
    // Bold
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
    // Italic
    .replace(/\*(.+?)\*/g, "<em>$1</em>")
    // Blockquotes — celles qui n'ont pas été promues en bloc typé
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
  return html
    .split("\n")
    .map((line) => {
      if (!line.trim()) return "";
      if (/^<[a-z]/.test(line) || /^<!--/.test(line)) return line;
      return `<p>${line}</p>`;
    })
    .join("\n");
}

function renderBlock(seg: Extract<Segment, { kind: "block" }>, ctx: Ctx): string {
  const inner = renderChunk(seg.lines, ctx);

  // L'épigraphe ouvre le chapitre : c'est une exergue, pas un encadré à libellé.
  if (seg.epigraph) return `<blockquote class="lesson-epigraph">${inner}</blockquote>`;

  const label = seg.type ? BLOCK_LABELS[seg.type][ctx.lang] : null;
  const className = seg.type ? `lesson-blk lesson-blk--${seg.type}` : "lesson-blk";
  const head =
    (label ? `<span class="lesson-blk__label">${escapeHtml(label)}</span>` : "") +
    // Le titre est du texte d'auteur : échappé, jamais interprété (R-1).
    (seg.title ? `<p class="lesson-blk__title">${escapeHtml(seg.title)}</p>` : "");

  return `<section class="${className}">${head}${inner}</section>`;
}

/**
 * Rend une leçon (`cours.md`) ou un résumé (`resume.md`) en HTML assaini.
 *
 * Invariant de sécurité (étude 18, R-1) — l'ordre des passes EST la garantie : le corps est
 * intégralement HTML-échappé AVANT qu'aucune balise ne soit émise, et les seules balises qui
 * survivent sont celles que ce module produit lui-même. Un auteur ne peut donc pas injecter
 * de markup, quoi qu'il écrive. L'unique exception est le bloc `<svg>`, extrait avant
 * l'échappement, passé par le profil SVG vetté (`sanitizeSvg`, qui échoue fermé sans DOM) et
 * ré-injecté après le sanitize final — dont l'`ALLOWED_TAGS` exclut délibérément le SVG.
 * Voir `docs/xss-rendering-policy.md`.
 */
export function renderLesson(md: string, opts: { lang?: ContentLang } = {}): RenderedLesson {
  const figures: string[] = [];
  const sheltered = md.replace(SVG_BLOCK, (svg) => {
    const token = figurePlaceholder(figures.length);
    figures.push(sanitizeSvg(svg));
    return `\n\n${token}\n\n`;
  });

  const ctx: Ctx = { lang: opts.lang ?? "fr", sections: [], h2: 0 };

  let html = segment(sheltered)
    .map((seg) => (seg.kind === "raw" ? renderChunk(seg.lines, ctx) : renderBlock(seg, ctx)))
    .filter(Boolean)
    .join("\n");

  // Keep inline math (`√64`, `√(25 × 2) = 5√2`, …) a contiguous LTR run inside
  // RTL prose; `$$ … $$` display blocks are already isolated via CSS.
  html = isolateLtrRunsHtml(html);

  // The body is already HTML-escaped above, so it is safe even without the
  // sanitize pass; when DOMPurify is unavailable (no DOM at SSR) we skip the
  // no-op call explicitly rather than depend on its pass-through behavior. Any
  // embedded figure is sheltered and fails closed in sanitizeSvg.
  const safe = DOMPurify.isSupported
    ? DOMPurify.sanitize(html, {
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
          // étude 18 — deux balises INERTES, porteuses des blocs pédagogiques.
          // Ni `style`, ni `href`, ni `on*` : la surface d'injection est inchangée.
          "section",
          "span",
        ],
        ALLOWED_ATTR: ["class", "id", "dir"],
      })
    : html;

  if (figures.length === 0) return { html: safe, sections: ctx.sections, figureCount: 0 };

  // Re-inject each already-sanitized figure, replacing the paragraph the placeholder
  // ended up wrapped in (or the bare token, defensively).
  const withFigures = figures.reduce((out, svg, i) => {
    const token = figurePlaceholder(i);
    // Function replacers avoid `$`-pattern interpretation inside the SVG markup.
    return out
      .replace(`<p>${token}</p>`, () => `<div class="lesson-figure">${svg}</div>`)
      .replace(token, () => `<div class="lesson-figure">${svg}</div>`);
  }, safe);

  return { html: withFigures, sections: ctx.sections, figureCount: figures.length };
}
