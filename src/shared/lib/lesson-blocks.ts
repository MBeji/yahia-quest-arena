/**
 * Vocabulaire des blocs pédagogiques du lecteur de cours (étude 18, lot 1).
 *
 * Le renderer de leçons ne connaissait que `p`/`blockquote`/`ul` : une définition, une
 * propriété, un exemple résolu, un piège et un « à retenir » retombaient tous sur le même
 * gris. Ce module définit les types de blocs et leurs libellés.
 *
 * Deux façons d'obtenir un bloc :
 *  - la **promotion** d'un callout déjà écrit dans le contenu (`> ⚠️`, `> 🗡️`, `> 💡`, `> 🏆`) —
 *    ces marqueurs sont normatifs (`content-engine/references/style-guide.md` § squelette
 *    cours.md) et présents 2 637 fois dans 512 cours sur 541 : les promouvoir ne touche
 *    AUCUN fichier de contenu ;
 *  - la **directive** explicite `::: <type> … :::`, pour la sémantique que la prose n'encode
 *    pas encore.
 */

/** Types authorables via `::: <type>`. Liste CLOSE (étude 18, R-6). */
export const DIRECTIVE_TYPES = [
  "definition",
  "propriete",
  "exemple",
  "methode",
  "piege",
  "astuce",
  "retenir",
] as const;

export type DirectiveType = (typeof DIRECTIVE_TYPES)[number];

/** `insight` n'est pas authorable : il naît de la promotion d'un `> 💡` en cours de leçon. */
export type LessonBlockType = DirectiveType | "insight";

/** Langue du CONTENU (≠ locale de l'interface — voir BLOCK_LABELS). */
export type ContentLang = "fr" | "en" | "ar";

const CONTENT_LANGS: readonly string[] = ["fr", "en", "ar"];

export function isDirectiveType(value: string): value is DirectiveType {
  return (DIRECTIVE_TYPES as readonly string[]).includes(value);
}

/** Narrow `subjects.content_language` (texte libre côté DB) vers une langue connue. */
export function asContentLang(
  value: string | null | undefined,
  fallback: ContentLang,
): ContentLang {
  return value && CONTENT_LANGS.includes(value) ? (value as ContentLang) : fallback;
}

/**
 * Le libellé d'un bloc suit la langue du CONTENU, pas la locale de l'interface (étude 18, R-8).
 * Une leçon est un document ; son appareil en fait partie. Un chip « PIÈGE » français au milieu
 * d'une prose arabe RTL serait une faute de composition (docs/content-voice-and-composition.md).
 */
export const BLOCK_LABELS: Record<LessonBlockType, Record<ContentLang, string>> = {
  definition: { fr: "Définition", en: "Definition", ar: "تعريف" },
  propriete: { fr: "Propriété", en: "Property", ar: "خاصّية" },
  exemple: { fr: "Exemple résolu", en: "Worked example", ar: "مثال محلول" },
  methode: { fr: "Méthode", en: "Method", ar: "طريقة" },
  piege: { fr: "Piège", en: "Pitfall", ar: "تحذير" },
  astuce: { fr: "Astuce", en: "Tip", ar: "حيلة" },
  retenir: { fr: "À retenir", en: "Remember", ar: "للحفظ" },
  insight: { fr: "Éclairage", en: "Insight", ar: "إضاءة" },
};

/**
 * Marqueur de callout en tête de blockquote. Le sélecteur de variante emoji (U+FE0F) est
 * OPTIONNEL : le contenu l'écrit tantôt avec, tantôt sans, et un marqueur non reconnu
 * dégraderait silencieusement en `<blockquote>` gris — exactement le bug qu'on corrige.
 */
const CALLOUT_MARK = /^([⚠\u{1F5E1}\u{1F4A1}\u{1F3C6}])️?[ \t]*/u;

const CALLOUT_TYPE: Record<string, LessonBlockType> = {
  "⚠": "piege", // ⚠️ le piège classique
  "\u{1F5E1}": "astuce", // 🗡️ l'astuce du prof
  "\u{1F4A1}": "insight", // 💡 l'éclairage (le premier de la leçon = l'épigraphe)
  "\u{1F3C6}": "retenir", // 🏆 la clôture « chapitre validé »
};

/**
 * Reconnaît un callout promu et rend son type + le texte débarrassé de son marqueur.
 * `null` quand la citation n'en est pas un : elle reste alors un `<blockquote>` ordinaire —
 * la promotion est conservatrice, elle ne casse aucune citation existante.
 */
export function markerBlockType(text: string): { type: LessonBlockType; rest: string } | null {
  const match = CALLOUT_MARK.exec(text);
  if (!match) return null;
  const type = CALLOUT_TYPE[match[1]];
  return type ? { type, rest: text.slice(match[0].length) } : null;
}
