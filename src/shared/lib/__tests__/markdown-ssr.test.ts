// @vitest-environment node
import DOMPurify from "dompurify";
import { describe, expect, it } from "vitest";
import { renderLesson, renderSummary } from "@/shared/lib/markdown";

/**
 * LE RENDU SERVEUR D'UN COURS N'A PAS DOMPurify.
 *
 * Depuis novembre 2026 les pages `/chapitre/…` partent du serveur avec leur leçon rendue
 * (`public-page-seo.ts`). Sans DOM, `DOMPurify.isSupported` est faux : `finalize` saute
 * l'assainissement et `sanitizeSvg` rend une chaîne vide. Et l'hydratation ne répare rien —
 * React ne réécrit pas un `dangerouslySetInnerHTML` déjà présent. Sur ces pages, la SEULE
 * garantie est donc l'ordre des passes du moteur (tout échapper, puis n'émettre que ses
 * propres balises). Ce fichier tourne en environnement `node` pour le prouver là où
 * `markdown.test.ts` (jsdom) ne le peut pas : chez lui, DOMPurify rattrape tout.
 */

const ALLOWED_TAGS = new Set([
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
  "section",
  "span",
  "figure",
  "figcaption",
  "details",
  "summary",
  "br",
  "sup",
  "sub",
  "code",
  "pre",
  "bdi",
]);
const ALLOWED_ATTRS = new Set(["class", "id", "dir", "role", "tabindex", "aria-label", "scope"]);

/** Balises et attributs réellement émis, lus dans le HTML comme le ferait un navigateur. */
function emitted(html: string): { tags: Set<string>; attrs: Set<string> } {
  const tags = new Set<string>();
  const attrs = new Set<string>();
  for (const match of html.matchAll(/<([a-zA-Z][a-zA-Z0-9-]*)((?:\s+[^<>]*?)?)\/?>/g)) {
    tags.add(match[1].toLowerCase());
    for (const attr of match[2].matchAll(/([a-zA-Z_:][-a-zA-Z0-9_:.]*)\s*=\s*"[^"]*"/g)) {
      attrs.add(attr[1].toLowerCase());
    }
    // Ce qui reste une fois les attributs `nom="valeur"` retirés doit être vide : ni
    // attribut sans guillemets, ni fragment de guillemet échappé d'une valeur d'auteur.
    const leftover = match[2].replace(/([a-zA-Z_:][-a-zA-Z0-9_:.]*)\s*=\s*"[^"]*"/g, "").trim();
    if (leftover) attrs.add(`<<reste : ${leftover}>>`);
  }
  return { tags, attrs };
}

const PAYLOADS = [
  `<script>alert(1)</script>`,
  `<img src=x onerror=alert(1)>`,
  `<a href="javascript:alert(1)">clic</a>`,
  `[clic](javascript:alert(1))`,
  `![x](x" onerror="alert(1))`,
  `<iframe src="https://evil.example"></iframe>`,
  `<style>body{display:none}</style>`,
  `" onmouseover="alert(1)`,
  `'><svg/onload=alert(1)>`,
  `</section><script>alert(1)</script>`,
  `<svg><script>alert(1)</script><circle r="1"/></svg>`,
  `<svg onload="alert(1)"><foreignObject><body onload="alert(1)"/></foreignObject></svg>`,
];

/** Chaque charge, posée dans chaque position qu'un auteur peut atteindre. */
function lessonsFor(payload: string): string[] {
  return [
    payload,
    `## ${payload}`,
    `### ${payload}`,
    `> ${payload}`,
    `> ⚠️ ${payload}`,
    `- ${payload}\n- **${payload}**`,
    `1. ${payload}`,
    `| ${payload} | b |\n| --- | --- |\n| c | ${payload} |`,
    `**${payload}** et *${payload}*`,
    `::: definition ${payload}\n${payload}\n:::`,
    `::: ${payload}\ncorps\n:::`,
    `::: figure ${payload}\n<svg viewBox="0 0 1 1"><circle r="1"/></svg>\n:::`,
    `::: verifie ${payload}\n${payload}\n---\n${payload}\n:::`,
    `$$ ${payload} $$`,
  ];
}

describe("renderLesson / renderSummary — rendu serveur, sans DOM", () => {
  it("tourne bien sans DOMPurify : c'est le chemin du rendu serveur", () => {
    expect(DOMPurify.isSupported).toBe(false);
  });

  it.each(PAYLOADS)("n'émet que ses propres balises, quoi qu'écrive l'auteur : %s", (payload) => {
    for (const md of lessonsFor(payload)) {
      for (const html of [renderLesson(md).html, renderSummary(md).html]) {
        const { tags, attrs } = emitted(html);
        expect(
          [...tags].filter((tag) => !ALLOWED_TAGS.has(tag)),
          md,
        ).toEqual([]);
        expect(
          [...attrs].filter((attr) => !ALLOWED_ATTRS.has(attr)),
          md,
        ).toEqual([]);
      }
    }
  });

  it("une figure SVG échoue FERMÉE sans DOM : rien du balisage de l'auteur ne sort", () => {
    const html = renderLesson(
      `Avant.\n\n<svg viewBox="0 0 10 10"><script>alert(1)</script><circle r="4"/></svg>\n\nAprès.`,
    ).html;
    expect(html).not.toContain("<svg");
    expect(html).not.toContain("<script");
    expect(html).not.toContain("<circle");
    expect(html).toContain("Avant.");
    expect(html).toContain("Après.");
  });

  it("les titres de section rendus à la page (sommaire, JSON-LD) sont du texte, pas du balisage", () => {
    const { sections } = renderLesson(`## <img src=x onerror=alert(1)>\n\ncorps`);
    for (const section of sections) {
      expect(section.id).toMatch(/^section-\d+$/);
    }
  });
});
