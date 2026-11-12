/**
 * Règles du garde RTL (étude 14, D-4 / R-2) — la partie PURE, testée par
 * `__tests__/rtl-rules.test.mjs`. Le script `check-rtl-classes.mjs` parcourt les
 * fichiers et affiche ; ici on dit seulement ce qui est une faute dans un texte.
 *
 * Renforcé le 2026-11-12 (issue #1228, `rtl-physical-classes-missed-by-lint`). Le
 * garde d'origine ne voyait ni `ml-auto` (valeur non numérique), ni `sm:left-2`
 * (variante devant la classe), ni `float-left`, ni un style en ligne
 * (`marginLeft`), ni `src/components/ui`, ni la feuille de style, ni une flèche
 * écrite en dur, ni un « + » collé à un nombre. Chacun de ces trous avait laissé
 * passer un défaut réel, visible en arabe.
 */

/** Classes Tailwind physiques. `[\s"'`:!]` devant : début de classe OU variante (`sm:`, `rtl:`). */
export const CLASS_RULES = [
  {
    name: "margin/padding physiques",
    // Toute valeur : `ml-2`, `ml-[3px]`, `ml-px`, `ml-auto`, `-mr-1`, `sm:pl-4`.
    re: /(?:^|[\s"'`:!])-?(?:ml|mr|pl|pr)-[\w[]/,
    fix: "ms-/me-/ps-/pe-",
  },
  {
    name: "text-left/text-right",
    re: /\btext-(?:left|right)\b/,
    fix: "text-start/text-end",
  },
  {
    name: "position left-/right- physique",
    // `left-1/2` et `left-[50%]` (centrage avec -translate-x-1/2) sont symétriques.
    // `left-to-right`, `right-hand` : de la prose, pas une classe.
    re: /(?:^|[\s"'`:!])-?(?:left|right)-(?!1\/2|\[50%\]|to-|hand)[\w[]/,
    fix: "start-/end-",
  },
  {
    name: "rounded-l/r physiques",
    re: /\brounded-(?:l|r|tl|tr|bl|br)(?:\b|-)/,
    fix: "rounded-s/e (ss/se/es/ee)",
  },
  {
    name: "border-l/r physiques",
    re: /\bborder-(?:l|r)(?:\b|-(?:\d|\[))/,
    fix: "border-s/border-e",
  },
  {
    name: "float/clear physiques",
    re: /\b(?:float|clear)-(?:left|right)\b/,
    fix: "float-start/float-end, clear-start/clear-end",
  },
  {
    name: "scroll-margin/padding physiques",
    re: /\bscroll-(?:ml|mr|pl|pr)-[\w[]/,
    fix: "scroll-ms-/scroll-me-/scroll-ps-/scroll-pe-",
  },
  {
    name: "glissement physique (tw-animate)",
    // `data-[side=left]:slide-in-from-right` (Radix) suit un placement physique
    // calculé par la librairie : ce n'est pas un choix de mise en page.
    re: /(?<!data-\[side=(?:left|right|top|bottom)\]:)\bslide-(?:in-from|out-to)-(?:left|right)\b/,
    fix: "slide-in-from-start/end, slide-out-to-start/end",
  },
];

/** Styles en ligne (objets `style={{…}}`) : mêmes propriétés, écrites en camelCase. */
export const INLINE_STYLE_RULES = [
  {
    name: "style en ligne physique",
    re: /\b(?:margin|padding)(?:Left|Right)\s*:|\bborder(?:Left|Right)\w*\s*:|\bborder(?:Top|Bottom)(?:Left|Right)Radius\s*:/,
    fix: "marginInlineStart/End, paddingInlineStart/End, borderInlineStart/End, borderStartStartRadius…",
  },
  {
    name: "textAlign left/right",
    re: /\btextAlign\s*:\s*["'](?:left|right)["']/,
    fix: 'textAlign: "start" / "end"',
  },
];

/**
 * Texte rendu : une flèche écrite en dur pointe toujours du même côté, et un signe
 * collé à un nombre passe à droite des chiffres en arabe.
 */
export const TEXT_RULES = [
  {
    name: "flèche littérale",
    re: /[←→]/,
    // Déjà retournée en RTL par la classe posée sur son élément (ligne ou 2 au-dessus).
    unless: "rtl:-scale-x-100",
    fix: 'une icône ou `<span className="inline-block rtl:-scale-x-100">→</span>`',
  },
  {
    name: "signe collé à un nombre interpolé",
    // `+{n}` dans du JSX, `+${n}` dans un gabarit : le signe se détache en RTL.
    re: /(?:^|[\s>"'`(·:])[+−]\$?\{/,
    fix: "plus(n) / signedNumber(n) de @/shared/lib/bidi",
  },
];

/** Feuille de style : propriétés physiques. */
export const CSS_RULES = [
  {
    name: "propriété CSS physique",
    re: /(?:^|[\s;{])(?:margin|padding|border)-(?:left|right)(?:-[a-z]+)?\s*:|(?:^|[\s;{])border-(?:top|bottom)-(?:left|right)-radius\s*:|(?:^|[\s;{])(?:left|right)\s*:/,
    fix: "margin-inline-*, padding-inline-*, border-inline-*, border-start-start-radius…, inset-inline-*",
  },
  {
    name: "text-align/float physiques",
    re: /(?:^|[\s;{])(?:text-align|float|clear)\s*:\s*(?:left|right)\b/,
    fix: "text-align: start/end, float: inline-start/inline-end",
  },
  {
    name: "border-radius à coins inégaux",
    // 3 ou 4 valeurs dont deux diffèrent : l'arrondi ne se retourne pas en RTL.
    re: /(?:^|[\s;{])border-radius\s*:\s*(\S+)\s+(\S+)\s+(\S+)(?:\s+(\S+))?\s*;/,
    test: (match) => {
      const [, a, b, c, d = b] = match;
      return a !== b || c !== d;
    },
    fix: "border-start-start-radius / border-start-end-radius / border-end-start-radius / border-end-end-radius",
  },
];

const EXCEPTION = "rtl-ok";

/**
 * Remplace les commentaires par des espaces (longueur et numéros de ligne
 * conservés) : une flèche dans un commentaire n'est pas du texte rendu. Suit les
 * chaînes pour ne pas prendre `"https://…"` pour un commentaire.
 */
export function blankComments(source) {
  let out = "";
  let i = 0;
  let quote = null;
  while (i < source.length) {
    const ch = source[i];
    const next = source[i + 1];
    if (quote) {
      out += ch;
      if (ch === "\\") {
        out += next ?? "";
        i += 2;
        continue;
      }
      if (ch === quote || (quote !== "`" && ch === "\n")) quote = null;
      i += 1;
    } else if (ch === "/" && next === "*") {
      const end = source.indexOf("*/", i + 2);
      const stop = end === -1 ? source.length : end + 2;
      out += source.slice(i, stop).replace(/[^\n]/g, " ");
      i = stop;
    } else if (ch === "/" && next === "/" && source[i - 1] !== ":") {
      const end = source.indexOf("\n", i);
      const stop = end === -1 ? source.length : end;
      out += " ".repeat(stop - i);
      i = stop;
    } else {
      if (ch === '"' || ch === "`") quote = ch;
      out += ch;
      i += 1;
    }
  }
  return out;
}

function matches(rule, line) {
  const match = rule.re.exec(line);
  return match !== null && (rule.test ? rule.test(match) : true);
}

/**
 * Les fautes d'un fichier : `[{ line, rule, fix, text }]`.
 * `kind` : "tsx" (classes + styles en ligne + texte rendu), "ts" (classes + styles
 * en ligne), "css".
 * Exception documentée : `rtl-ok` sur la ligne ou jusqu'à 3 lignes au-dessus.
 */
export function findRtlViolations(source, kind) {
  const raw = source.split("\n");
  const code = kind === "css" ? raw : blankComments(source).split("\n");
  const rules =
    kind === "css"
      ? CSS_RULES
      : kind === "tsx"
        ? [...CLASS_RULES, ...INLINE_STYLE_RULES, ...TEXT_RULES]
        : [...CLASS_RULES, ...INLINE_STYLE_RULES];
  const violations = [];
  code.forEach((line, i) => {
    for (let back = 0; back <= 3; back++) {
      if (raw[i - back]?.includes(EXCEPTION)) return;
    }
    for (const rule of rules) {
      if (rule.unless && [0, 1, 2].some((back) => raw[i - back]?.includes(rule.unless))) continue;
      if (matches(rule, line)) {
        violations.push({ line: i + 1, rule: rule.name, fix: rule.fix, text: raw[i].trim() });
      }
    }
  });
  return violations;
}
