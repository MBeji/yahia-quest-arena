import DOMPurify from "dompurify";
import { isolateLtrRunsHtml } from "@/shared/lib/bidi";
import { sanitizeSvg } from "@/shared/lib/figure";
import {
  BLOCK_LABELS,
  isDirectiveType,
  markerBlockType,
  REVEAL_LABELS,
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
/**
 * Le séparateur question / réponse d'un `::: verifie` (étude 35, R-16). Le PREMIER de ces
 * traits scinde le bloc ; les suivants restent du markdown ordinaire (un `<hr>` dans la
 * réponse). Il est consommé par la pré-passe, donc la passe `---` → `<hr>` ne le voit jamais.
 */
const CHECK_SPLIT = /^---[ \t]*$/;
/** Une section `##`+ a commencé : au-delà, un `> 💡` n'est plus l'épigraphe. */
const SECTION_HEADING = /^#{2,}[ \t]/;

/** Une puce de premier niveau d'un `resume.md` : elle devient une carte de révision. */
const CARD_LINE = /^- (.+)$/;
/** Une ligne indentée appartient à la carte qui la précède (exemples, sous-puces). */
const CARD_CHILD = /^[ \t]+\S/;
/** `**Concept**: essence` — le motif normatif, suivi par 3 549 puces sur 3 827. */
const CARD_TITLE = /^\*\*(.+?)\*\*[ \t]*[:：]?[ \t]*([\s\S]*)$/;

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
      /**
       * `::: verifie` seulement : les lignes d'APRÈS le premier `---`, celles que le lecteur
       * déplie. `null` quand le bloc n'a pas de séparateur — il dégrade alors en bloc neutre,
       * tout visible (R-17), et `content:qa` le remonte.
       */
      answer?: string[] | null;
    };

type Ctx = { lang: ContentLang; sections: LessonSection[]; h2: number };

const escapeHtml = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

/**
 * Échappement pour un contenu d'ATTRIBUT. La légende d'auteur atterrit dans `aria-label`
 * (étude 18, R-3) : `escapeHtml` n'échappe PAS les guillemets, et un `"` dans une légende
 * fermerait l'attribut — la seule porte d'injection que ce lot pouvait ouvrir.
 */
const escapeAttr = (s: string) => escapeHtml(s).replace(/"/g, "&quot;").replace(/'/g, "&#39;");

/** Le jeton d'abri d'une figure porte son index — donc son ORDRE dans le document. */
const FIGURE_TOKEN = /svgfigureplaceholder(\d+)end/;

/**
 * Habillage d'une figure. Le numéro est l'index du `<svg>` dans le document : l'abri des
 * figures les collecte dans l'ordre, la numérotation est donc juste sans compteur séparé.
 * Le jeton reste en place ici ; il devient le SVG assaini après la passe de sanitize.
 */
function figureMarkup(token: string, index: number, caption: string | null, lang: ContentLang) {
  const number = `${BLOCK_LABELS.figure[lang]} ${index + 1}`;
  const aria = caption ? `${number} — ${caption}` : number;
  return (
    `<figure class="lesson-figure" role="button" tabindex="0" aria-label="${escapeAttr(aria)}">` +
    `<div class="lesson-figure__plate">${token}</div>` +
    `<figcaption class="lesson-figure__caption">` +
    `<span class="lesson-figure__num">${escapeHtml(number)}</span>` +
    (caption ? `<span>${escapeHtml(caption)}</span>` : "") +
    `</figcaption>` +
    `</figure>`
  );
}

/** Inverse exact de `escapeHtml` (on n'échappe que ces trois entités) + emphase markdown
 *  retirée : le sommaire est du TEXTE rendu par React, pas du HTML. */
/**
 * Prettier, qui formate tout le corpus, réécrit l'italique `*mot*` en `_mot_` et protège
 * un astérisque littéral en `\*`. Le rendu ne connaissait que `*…*` : 700+ leçons
 * affichaient leurs `_…_` et leurs `\` tels quels. L'italique souligné n'ouvre qu'après un
 * blanc ou une ponctuation ouvrante et ne ferme qu'avant un blanc ou une ponctuation : les
 * indices de formule (`S_D`, `t_u⃗`, `∫_{1/2}`) ne sont jamais pris pour de l'italique.
 *
 * Ce qui SUIT le souligné ouvrant peut être une lettre, un chiffre, un guillemet ou une
 * parenthèse ouvrante, ou un gras (`<strong>`, déjà émis à ce stade). La règle n'acceptait
 * qu'une lettre ou un chiffre : un exemple cité (`_« Faut-il vraiment… »_`, `_"Where do you
 * live?"_`) ou qui s'ouvre sur un mot en gras (`_**Certes**, la réforme…_`) gardait ses deux
 * soulignés à l'écran — ~1 950 passages dans 135 cours, surtout de français et d'anglais
 * (mesuré le 2026-11-15). C'est le caractère qui PRÉCÈDE le souligné qui protège les indices
 * de formule, et il n'a pas changé ; un blanc à compléter (`___`) n'ouvre toujours rien.
 */
const UNDERSCORE_ITALIC =
  /(^|[\s([«"'“‘’—–-])_(?=[\p{L}\p{N}«"“‘([¿¡]|<strong>)([^_\n]*?[^\s_])_(?=$|[\s.,;:!?)\]»"'”’…—–-])/gmu;
/** Un `\*` ou `\_` d'auteur (échappement Markdown) : mis à l'abri du formatage, rendu nu. */
const ESCAPED_MARK = /\\([*_])/g;
const SHELTER: Record<string, string> = { "*": "\uE000", _: "\uE001" };
const unshelter = (s: string) => s.replace(/\uE000/g, "*").replace(/\uE001/g, "_");

const toPlainText = (s: string) =>
  unshelter(
    s
      .replace(/&lt;/g, "<")
      .replace(/&gt;/g, ">")
      .replace(/&amp;/g, "&")
      .replace(ESCAPED_MARK, (_m, c: string) => SHELTER[c])
      .replace(/\*\*/g, "")
      .replace(/\*/g, "")
      .replace(UNDERSCORE_ITALIC, "$1$2"),
  ).trim();

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
      const type = isDirectiveType(declared) ? declared : null;
      // Un `::: verifie` a DEUX côtés : la question, puis la réponse, séparés par le premier
      // `---` seul sur sa ligne (R-16). Sans séparateur — ou avec un côté vide — le bloc
      // dégrade en bloc neutre tout visible (R-17) : mieux vaut une réponse montrée qu'une
      // page cassée, et `content:qa` fait rougir l'auteur (C-4).
      const split = type === "verifie" ? body.findIndex((l) => CHECK_SPLIT.test(l)) : -1;
      const hasSides =
        split > -1 &&
        body.slice(0, split).some((l) => l.trim()) &&
        body.slice(split + 1).some((l) => l.trim());
      out.push({
        kind: "block",
        type,
        title: open[2]?.trim() || null,
        lines: hasSides ? body.slice(0, split) : body,
        epigraph: false,
        answer: hasSides ? body.slice(split + 1) : null,
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
      out.push({
        kind: "block",
        type: promoted.type,
        title: null,
        lines: joinQuoteParagraphs(body),
        epigraph,
      });
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
 * Une ligne qui ouvre une construction de bloc — puce, liste numérotée, ligne de tableau, titre,
 * formule `$$`, trait, directive, jeton de figure : elle ne se recolle jamais à la précédente.
 */
const BLOCK_START =
  /^\s*(?:[-*+][ \t]|\d+\.[ \t]|\||#{1,6}[ \t]|\$\$|---\s*$|:::|svgfigureplaceholder)/;
/** Un saut de ligne FORCÉ (`\` ou deux espaces en fin de ligne) : la ligne suivante reste à part. */
const HARD_BREAK = /(?:\\| {2,})$/;

/**
 * Recolle les lignes d'un même paragraphe de citation, comme Markdown standard.
 *
 * Un callout `> ⚠️ …` s'écrit sur plusieurs lignes `> …` (le texte est renvoyé à la ligne vers
 * 100 signes dans le corpus : 973 lignes de continuation dans les callouts des cours). Rendue
 * ligne à ligne, la citation devenait un fragment nu suivi d'un `<p>` par ligne : la phrase coupée
 * au milieu, en deux blocs. Une ligne de prose qui suit une ligne de prose la CONTINUE ; une ligne
 * `>` vide sépare deux paragraphes, et une construction de bloc ({@link BLOCK_START}) ou un saut
 * forcé ({@link HARD_BREAK}) garde sa ligne.
 */
function joinQuoteParagraphs(lines: string[]): string[] {
  const out: string[] = [];
  let previous: string | null = null;
  for (const line of lines) {
    const prose = line.trim() !== "" && !BLOCK_START.test(line);
    if (prose && previous !== null && !HARD_BREAK.test(previous)) {
      previous = `${previous.trimEnd()} ${line.trimStart()}`;
      out[out.length - 1] = previous;
      continue;
    }
    out.push(line);
    previous = prose ? line : null;
  }
  return out;
}

/** Une clôture de bloc de code : ce qu'elle enferme garde ses lignes telles qu'écrites. */
const CODE_FENCE = /^\s*```/;
/** Une ligne que le rendu transforme en `<li>` : une puce `- ` ou un numéro `1. `, en colonne 0. */
const LIST_ITEM = /^(?:- |\d+\. )/;
/** Une ligne en retrait : sous un item de liste, elle lui appartient. */
const INDENTED = /^[ \t]+\S/;
/** Une sous-puce (`  - …`) ou un sous-numéro (`   1. …`) sous un item. */
const NESTED_BULLET = /^[ \t]+[-*+][ \t]+(.*)$/;
const NESTED_NUMBER = /^[ \t]+\d+\.[ \t]/;
/**
 * Sentinelles privées (comme {@link SHELTER}) : dans la ligne d'un item, elles marquent où
 * commence une ligne qui lui appartient sans le continuer — un exemple posé dessous, une
 * sous-puce. Elles deviennent des `<span class="lesson-li__more">` une fois le `<li>` émis.
 */
const SUB_LINE = "\uE002";
const SUB_BULLET = "\uE003";

/**
 * Longueur à partir de laquelle une ligne inachevée se lit comme un RENVOI À LA LIGNE de
 * l'auteur et non comme une ligne voulue. Voir {@link isWidthWrap}.
 */
const WRAP_MIN = 75;
/** Fin de phrase, de proposition annoncée ou d'élément : rien n'y « continue » à la ligne suivante. */
const SENTENCE_END = /[.!?؟:…✓✗)\]»”"][\s*_]*$/u;

/**
 * La ligne a-t-elle été coupée parce qu'elle était PLEINE (la suivante la continue), ou parce
 * que l'auteur voulait une ligne (la suivante est un autre paragraphe) ?
 *
 * Le rendu faisait de CHAQUE ligne du fichier un paragraphe. Or la moitié du corpus est écrite
 * avec des paragraphes renvoyés à la ligne vers 100 signes : 483 cours sur 968, ~20 000 lignes
 * de continuation (constat du 2026-11-15, sur une capture du propriétaire — une phrase arabe
 * coupée en quatre paragraphes, au milieu d'une proposition). Markdown standard recollerait
 * toute ligne à la précédente ; ce serait trop : le reste du corpus a été écrit CONTRE le rendu
 * ligne à ligne, et compte sur lui — paires d'exemples (`_Direct:_ …` / `_Reported:_ …`),
 * égalités posées une par ligne, vers, répliques.
 *
 * Mesuré sur les 7 394 paires de lignes de prose consécutives du corpus, deux populations se
 * séparent nettement :
 *   - la ligne finit EN COURS de phrase (4 689) : 95 % font 80 à 109 signes — des renvois ;
 *     44 seulement font moins de 70 signes, et ce sont des lignes voulues (une égalité, un
 *     exemple suivi d'une parenthèse) ;
 *   - la ligne finit sur une ponctuation finale (2 705) : toutes longueurs — une phrase par
 *     ligne, voulue, ou de longs paragraphes écrits l'un sous l'autre.
 * D'où la règle : une ligne d'au moins {@link WRAP_MIN} signes qui ne finit pas une phrase est
 * continuée par la suivante. Un renvoi tombé pile en fin de phrase reste coupé là — deux
 * paragraphes au lieu d'un, à une frontière de phrase : c'est le rendu d'hier, sans dommage.
 * Un saut forcé ({@link HARD_BREAK}) n'est jamais un renvoi.
 */
function isWidthWrap(line: string): boolean {
  return line.length >= WRAP_MIN && !HARD_BREAK.test(line) && !SENTENCE_END.test(line.trimEnd());
}

/**
 * Recolle ce que l'auteur a renvoyé à la ligne, AVANT tout rendu.
 *
 *  - Prose : une ligne continue la précédente si celle-ci est un renvoi ({@link isWidthWrap}).
 *  - Liste : une ligne en retrait sous un item lui APPARTIENT. Rendue à part, elle sortait de la
 *    liste — le texte de l'item coupé en deux, la suite dans un paragraphe dessous, et la liste
 *    rouverte après elle (538 listes numérotées et 133 listes à puces se referment sur le
 *    corpus). 1 131 lignes, dont 1 042 sont des renvois (recollés d'une espace) ; les autres —
 *    un exemple sous sa règle, une sous-puce — restent sur leur ligne, DANS l'item.
 *  - Jamais dans un bloc de code, ni vers ou depuis une construction de bloc (titre, tableau,
 *    formule `$$`, trait, figure, citation).
 */
function joinSoftBreaks(lines: string[]): string[] {
  const out: string[] = [];
  let kind: "prose" | "item" | null = null;
  // La dernière ligne PHYSIQUE du paragraphe ou de l'item en cours : c'est elle qu'on juge.
  let last = "";
  let fenced = false;
  for (const line of lines) {
    if (CODE_FENCE.test(line)) {
      fenced = !fenced;
      out.push(line);
      kind = null;
      continue;
    }
    if (fenced || line.trim() === "") {
      out.push(line);
      kind = null;
      continue;
    }
    if (kind === "item" && INDENTED.test(line)) {
      const bullet = NESTED_BULLET.exec(line);
      const own = bullet !== null || NESTED_NUMBER.test(line) || !isWidthWrap(last);
      // Une espace de part et d'autre de la sentinelle : pour l'emphase (`_exemple._` en fin
      // de ligne), elle vaut une fin de ligne — sans elle l'italique ne se fermait plus.
      const glue = bullet ? ` ${SUB_BULLET} ` : own ? ` ${SUB_LINE} ` : " ";
      out[out.length - 1] =
        `${out[out.length - 1].trimEnd()}${glue}${bullet ? bullet[1] : line.trim()}`;
      last = line;
      continue;
    }
    if (BLOCK_START.test(line) || QUOTE_LINE.test(line)) {
      out.push(line);
      kind = LIST_ITEM.test(line) ? "item" : null;
      last = line;
      continue;
    }
    if (kind === "prose" && isWidthWrap(last)) {
      out[out.length - 1] = `${out[out.length - 1].trimEnd()} ${line.trimStart()}`;
    } else {
      out.push(line);
    }
    kind = "prose";
    last = line;
  }
  return out;
}

/**
 * Une ligne déjà rendue en BLOC par {@link renderChunk} — elle ouvre ou ferme un titre, une
 * citation, une formule, un trait, un tableau ou une liste : elle n'est pas un paragraphe.
 *
 * Le test était « la ligne commence par une balise » (`/^<[a-z]/`), et il se trompait dans
 * les deux sens (constaté le 2026-11-15 dans le HTML servi en production) :
 *   - une ligne qui commence par du GRAS ou de l'ITALIQUE (`<strong>`, `<em>`) n'était pas un
 *     paragraphe. Deux définitions écrites l'une sous l'autre (`**Terme** : …`), une paire
 *     d'exemples (`_Direct:_ …` / `_Reported:_ …`) se fondaient en une seule ligne de texte ;
 *   - une balise FERMANTE (`</ul>`, `</table>`), seule sur sa ligne, en devenait un :
 *     `<p></ul></p>`, que le navigateur répare en paragraphes vides — un blanc de trop après
 *     chaque liste et chaque tableau, et un HTML différent entre le serveur et le navigateur.
 */
const BLOCK_LINE = /^<\/?(?:h[1-3]|blockquote|div|hr|table|tr|ul|ol|li)\b|^<!--/;

/** Le corps d'un `<li>` : son texte, puis chaque ligne qui lui appartient, sur sa propre ligne. */
function listItemBody(item: string): string {
  const [text, ...more] = item.split(/(?=[\uE002\uE003])/u);
  return (
    (more.length ? text.trimEnd() : text) +
    more
      .map((part) => {
        const className =
          part[0] === SUB_BULLET ? "lesson-li__more lesson-li__more--bullet" : "lesson-li__more";
        return `<span class="${className}">${part.slice(1).trim()}</span>`;
      })
      .join("")
  );
}

/**
 * Le pipeline historique, appliqué à un segment : échappement d'abord, puis les seules balises
 * que ce module émet (R-1). Le compteur de `##` est partagé, pour que les ancres restent
 * uniques d'un segment à l'autre. `resolved` : les lignes sont déjà celles qu'on veut rendre
 * (une carte de résumé, qui a jugé ses renvois sur ses lignes d'origine).
 */
function renderChunk(lines: string[], ctx: Ctx, resolved = false): string {
  let html = escapeHtml((resolved ? lines : joinSoftBreaks(lines)).join("\n"))
    .replace(ESCAPED_MARK, (_m, c: string) => SHELTER[c])
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
    .replace(UNDERSCORE_ITALIC, "$1<em>$2</em>")
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
      // Toutes les cellules naissent `<td>` : à ce stade on traite une ligne isolée, et rien
      // ne dit encore laquelle est l'en-tête. C'est le séparateur, plus bas, qui le désigne.
      return `<tr>${cells.map((c) => `<td>${c}</td>`).join("")}</tr>`;
    })
    // Lists (simple)
    .replace(
      /^- (.+)$/gm,
      (_match, item: string) => `<li class="lesson-li">${listItemBody(item)}</li>`,
    )
    .replace(
      /^(\d+)\. (.+)$/gm,
      (_match, _n: string, item: string) =>
        `<li class="lesson-li lesson-oli">${listItemBody(item)}</li>`,
    );

  // Le séparateur d'alignement (`|---|`) tombe AVANT le wrap, et l'ordre est tout le sujet :
  // tant qu'il reste sur sa ligne, il coupe la série de `<tr>` consécutifs, l'en-tête part
  // dans SA propre `<table>` et le corps dans une seconde. Deux tables `display:block`
  // voisines ne partagent aucune largeur de colonne — en-tête ratatiné au-dessus d'un corps
  // pleine largeur — et `tr:first-child td` peint alors aussi la première ligne de données.
  //
  // Il désigne au passage la ligne qu'il suit comme l'EN-TÊTE : ses cellules deviennent des
  // `<th scope="col">`. Sans ça un lecteur d'écran annonce un tableau sans en-tête et ne
  // rattache aucune valeur à sa colonne — le fond violet ne parle qu'aux voyants. On s'en
  // tient à `th` : ajouter `thead`/`tbody` obligerait à élargir l'allowlist du sanitize,
  // alors que `scope` suffit à porter l'information (et que DOMPurify pose déjà un `tbody`).
  html = html.replace(
    /(<tr>.*?<\/tr>)\n?<!--table-sep-->\n?/g,
    (_match, headerRow: string) =>
      `${headerRow.replace(/<td>/g, '<th scope="col">').replace(/<\/td>/g, "</th>")}\n`,
  );
  // Un séparateur orphelin (tableau malformé, sans ligne au-dessus) disparaît quand même.
  html = html.replace(/<!--table-sep-->\n?/g, "");
  // La balise fermante d'une liste ou d'un tableau reste SEULE sur sa ligne. Le groupe avale le
  // saut de ligne qui suit sa dernière rangée : le texte de la ligne suivante se retrouvait
  // collé derrière `</ul>`, sur la même ligne — donc jamais un paragraphe.
  const wrap = (open: string, close: string) => (rows: string) =>
    `${open}${rows}${close}${rows.endsWith("\n") ? "\n" : ""}`;
  // Wrap consecutive <tr> in table
  html = html.replace(/((?:<tr>.*<\/tr>\n?)+)/g, wrap('<table class="lesson-table">', "</table>"));

  // Wrap consecutive ordered <li> (class includes "lesson-oli") in <ol>
  html = html.replace(
    /((?:<li class="lesson-li lesson-oli">.*<\/li>\n?)+)/g,
    wrap('<ol class="lesson-ol">', "</ol>"),
  );
  // Wrap consecutive unordered <li> (exact "lesson-li") in <ul>
  html = html.replace(
    /((?:<li class="lesson-li">.*<\/li>\n?)+)/g,
    wrap('<ul class="lesson-ul">', "</ul>"),
  );

  // Paragraphs: toute ligne qui n'ouvre ni ne ferme un BLOC émis plus haut.
  return unshelter(html)
    .split("\n")
    .map((line) => {
      if (!line.trim()) return "";
      if (BLOCK_LINE.test(line)) return line;
      return `<p>${line}</p>`;
    })
    .join("\n");
}

function renderBlock(seg: Extract<Segment, { kind: "block" }>, ctx: Ctx): string {
  // Une figure n'est pas un encadré à libellé : c'est une planche légendée.
  if (seg.type === "figure") {
    const token = seg.lines.join("\n").match(FIGURE_TOKEN);
    // `::: figure` sans figure : on ne casse pas la page, on dégrade en bloc neutre —
    // c'est `content:qa` (lot 4) qui remontera l'erreur, pas le lecteur (R-7).
    if (token) return figureMarkup(token[0], Number(token[1]), seg.title, ctx.lang);
  }

  const inner = renderChunk(seg.lines, ctx);

  // L'épigraphe ouvre le chapitre : c'est une exergue, pas un encadré à libellé.
  if (seg.epigraph) return `<blockquote class="lesson-epigraph">${inner}</blockquote>`;

  const label = seg.type && seg.type !== "figure" ? BLOCK_LABELS[seg.type][ctx.lang] : null;
  const className = seg.type ? `lesson-blk lesson-blk--${seg.type}` : "lesson-blk";
  const head =
    (label ? `<span class="lesson-blk__label">${escapeHtml(label)}</span>` : "") +
    // Le titre est du texte d'auteur : échappé, jamais interprété (R-1).
    (seg.title ? `<p class="lesson-blk__title">${escapeHtml(seg.title)}</p>` : "");

  // Le contrôle sur place : la réponse est REPLIÉE dans un `<details>` natif (étude 35 D-2).
  // Pas une ligne de script, pas un état React, pas un attribut de plus dans l'allowlist :
  // le navigateur sait déplier, il le fait au clavier, et il l'imprime si on le lui demande.
  if (seg.type === "verifie" && seg.answer) {
    const answer = renderChunk(seg.answer, ctx);
    return (
      `<section class="${className}">${head}` +
      `<div class="lesson-check__question">${inner}</div>` +
      `<details class="lesson-check">` +
      `<summary class="lesson-check__toggle">${escapeHtml(REVEAL_LABELS[ctx.lang])}</summary>` +
      `<div class="lesson-check__answer">${answer}</div>` +
      `</details>` +
      `</section>`
    );
  }

  return `<section class="${className}">${head}${inner}</section>`;
}

/**
 * Extrait les `<svg>` AVANT tout échappement et les remplace par des jetons. Chacun est
 * assaini au passage par le profil SVG vetté (`sanitizeSvg`, qui échoue fermé sans DOM).
 * Sans cet abri, l'échappement transformerait le markup en texte littéral visible.
 */
function shelterFigures(md: string): { sheltered: string; figures: string[] } {
  const figures: string[] = [];
  const sheltered = md.replace(SVG_BLOCK, (svg) => {
    const token = figurePlaceholder(figures.length);
    figures.push(sanitizeSvg(svg));
    return `\n\n${token}\n\n`;
  });
  return { sheltered, figures };
}

/**
 * Passe finale, commune au cours et au résumé : isolation bidi, sanitize, ré-injection des
 * figures. Le corps est déjà HTML-échappé en amont, donc sûr même sans le sanitize ; quand
 * DOMPurify n'a pas de DOM (SSR), on saute explicitement l'appel no-op plutôt que de
 * dépendre de son comportement pass-through.
 */
function finalize(body: string, figures: string[], lang: ContentLang): string {
  // Keep inline math (`√64`, `√(25 × 2) = 5√2`, …) a contiguous LTR run inside
  // RTL prose; `$$ … $$` display blocks are already isolated via CSS.
  const html = isolateLtrRunsHtml(body);

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
          // étude 18 — des balises INERTES, porteuses des blocs et des figures légendées.
          // Ni `style`, ni `href`, ni `on*` : la surface d'injection est inchangée.
          // Les cartes de révision réutilisent `ul`/`li`/`h3` : un paquet de cartes EST
          // une liste, et l'allowlist n'a donc pas à grandir pour le lot 3.
          "section",
          "span",
          "figure",
          "figcaption",
          // étude 35 — le contrôle sur place. Deux balises natives, INERTES et sans attribut
          // nouveau : `ALLOWED_ATTR` ne bouge pas (R-20), et `open` n'y est PAS — l'état
          // « déplié » ne peut donc pas venir du contenu.
          "details",
          "summary",
        ],
        // `role`/`tabindex`/`aria-label` rendent la figure agrandissable au clavier.
        // Trois attributs INERTES : ils ne peuvent porter aucun script. `scope` rejoint la
        // liste pour la même raison — il rattache un `<th>` à sa colonne pour les lecteurs
        // d'écran, et ne peut rien exécuter.
        ALLOWED_ATTR: ["class", "id", "dir", "role", "tabindex", "aria-label", "scope"],
      })
    : html;

  if (figures.length === 0) return safe;

  return figures.reduce((out, svg, i) => {
    const token = figurePlaceholder(i);
    // Une figure NUE dans la prose (les 186 figures des 66 cours legacy) reçoit exactement
    // le même habillage que celle d'une directive : une seule figure, un seul markup, un
    // seul chemin de code. Elle n'a pas de légende — `content:qa` (lot 4) le signalera.
    const bare = figureMarkup(token, i, null, lang);
    // Function replacers avoid `$`-pattern interpretation inside the SVG markup.
    return (
      out
        .replace(`<p>${token}</p>`, () => bare)
        // Le jeton restant vit désormais dans une planche (celle qu'on vient de poser, ou
        // celle d'une directive `::: figure`) : il devient le SVG assaini, sans habillage.
        .replace(token, () => svg)
    );
  }, safe);
}

/**
 * Rend une leçon (`cours.md`) en HTML assaini.
 *
 * Invariant de sécurité (étude 18, R-1) — l'ordre des passes EST la garantie : le corps est
 * intégralement HTML-échappé AVANT qu'aucune balise ne soit émise, et les seules balises qui
 * survivent sont celles que ce module produit lui-même. Un auteur ne peut donc pas injecter
 * de markup, quoi qu'il écrive. L'unique exception est le bloc `<svg>`, extrait avant
 * l'échappement et ré-injecté après le sanitize final — dont l'`ALLOWED_TAGS` exclut
 * délibérément le SVG. Voir `docs/xss-rendering-policy.md`.
 */
export function renderLesson(md: string, opts: { lang?: ContentLang } = {}): RenderedLesson {
  const { sheltered, figures } = shelterFigures(md);
  const ctx: Ctx = { lang: opts.lang ?? "fr", sections: [], h2: 0 };

  const body = segment(sheltered)
    .map((seg) => (seg.kind === "raw" ? renderChunk(seg.lines, ctx) : renderBlock(seg, ctx)))
    .filter(Boolean)
    .join("\n");

  return {
    html: finalize(body, figures, ctx.lang),
    sections: ctx.sections,
    figureCount: figures.length,
  };
}

/**
 * Une puce de résumé → une carte de révision.
 *
 * Le contenu porte DÉJÀ la structure : `course-quality.md` (axe 3, « resume ↔ course
 * bijection ») impose « concept en gras + essence en une ligne », et 3 549 puces sur 3 827
 * le respectent. Une carte se déduit donc — on ne réécrit aucun résumé (D-6).
 */
function renderCard(text: string, children: string[], ctx: Ctx): string {
  // Un `- ⚠️ …` de résumé est une carte-piège (117 puces dans 81 résumés), un `- 🏆 …` une
  // carte « à retenir » (10 puces). Le marqueur est consommé, comme dans le cours.
  const marked = markerBlockType(text);
  const body = marked ? marked.rest : text;

  const titled = CARD_TITLE.exec(body);
  const title = titled ? titled[1] : null;
  const essence = titled ? titled[2] : body;

  const className = marked ? `lesson-card lesson-card--${marked.type}` : "lesson-card";
  // Le titre est du texte d'auteur : échappé, jamais interprété (R-1).
  const head = title ? `<h3 class="lesson-card__title">${escapeHtml(title)}</h3>` : "";
  // L'essence et les sous-puces (exemples) forment le corps de la carte : elles lui
  // appartiennent, elles ne sont pas des cartes sœurs.
  // `resolved` : les renvois à la ligne ont été jugés par `renderSummary`, sur les lignes
  // d'origine — ici l'essence a perdu son titre, sa longueur ne dit plus rien.
  const inner = renderChunk(
    [essence, ...children].filter((line) => line.trim().length > 0),
    ctx,
    true,
  );

  return `<li class="${className}"><div class="lesson-card__body">${head}${inner}</div></li>`;
}

/**
 * Rend un résumé (`resume.md`) en jeu de CARTES de révision.
 *
 * La veille du concours, un élève ne relit pas des puces grises — il révise des cartes.
 * Même invariant de sécurité que `renderLesson` (R-1) : le corps est échappé avant qu'aucune
 * balise ne soit émise. Un paquet de cartes est une LISTE (`ul`/`li`), donc l'allowlist du
 * sanitize n'a pas eu à grandir.
 */
export function renderSummary(md: string, opts: { lang?: ContentLang } = {}): RenderedLesson {
  const { sheltered, figures } = shelterFigures(md);
  const ctx: Ctx = { lang: opts.lang ?? "fr", sections: [], h2: 0 };
  const lines = sheltered.split("\n");

  const out: string[] = [];
  let raw: string[] = [];
  let cards: string[] = [];

  const flushRaw = () => {
    if (raw.length) out.push(renderChunk(raw, ctx));
    raw = [];
  };
  const flushCards = () => {
    if (cards.length) out.push(`<ul class="lesson-cards">${cards.join("")}</ul>`);
    cards = [];
  };

  for (let i = 0; i < lines.length; i++) {
    const bullet = CARD_LINE.exec(lines[i]);
    if (!bullet) {
      flushCards();
      raw.push(lines[i]);
      continue;
    }
    flushRaw();

    // Les lignes indentées qui suivent (27 résumés en ont) sont les exemples de CETTE
    // carte : on les dé-indente et on les lui rattache, au lieu d'en faire des cartes.
    // Une ligne en retrait qui CONTINUE la précédente (renvoi à la ligne de l'auteur,
    // {@link isWidthWrap}) s'y recolle : la carte montrait sa phrase coupée en deux paragraphes.
    let text = bullet[1];
    const children: string[] = [];
    let j = i + 1;
    while (j < lines.length && CARD_CHILD.test(lines[j])) {
      const child = lines[j].replace(/^[ \t]+/, "");
      if (isWidthWrap(lines[j - 1]) && !BLOCK_START.test(child)) {
        if (children.length) children[children.length - 1] += ` ${child}`;
        else text += ` ${child}`;
      } else {
        children.push(child);
      }
      j++;
    }
    cards.push(renderCard(text, children, ctx));
    i = j - 1;
  }

  flushCards();
  flushRaw();

  return {
    html: finalize(out.filter(Boolean).join("\n"), figures, ctx.lang),
    sections: ctx.sections,
    figureCount: figures.length,
  };
}
