/**
 * Les nombres de la source — étude 36 (le gisement), deux règles et une seule définition.
 *
 * Une salle blanche fuit d'abord par les nombres : un auteur qui n'a jamais vu un devoir peut
 * en reproduire les données si la ligne du lecteur les lui transmet, et une question qui reprend
 * trois valeurs d'un même exercice source en est une copie, quel que soit son habillage. Deux
 * mesures en découlent, volontairement mécaniques :
 *
 *   • **dans une ligne du lecteur** (archétype, piège), aucun nombre de deux chiffres ou plus,
 *     aucun décimal — les seuls nombres permis sont le n° d'exercice, le barème et les étapes ;
 *   • **dans le contrôle local**, les nombres NON TRIVIAUX (trois chiffres ou plus, ou un
 *     décimal) d'une question se comparent à ceux de chaque exercice source.
 *
 * Les chiffres arabo-indiens (٠…٩, ۰…۹) sont ramenés aux chiffres latins avant toute mesure :
 * une règle qu'un changement d'alphabet contourne n'en est pas une.
 */

/** ٠…٩ (U+0660…) et ۰…۹ (U+06F0…) → 0…9 : les deux blocs ont le chiffre dans leur quartet bas. */
export function toLatinDigits(text: string): string {
  return text.replace(/[\u0660-\u0669\u06f0-\u06f9]/g, (d) =>
    String((d.codePointAt(0) ?? 0) & 0xf),
  );
}

/**
 * Un nombre qui n'a rien à faire dans une ligne du lecteur : deux chiffres ou plus, ou un
 * décimal (`\d{2,}` ou `\d[.,]\d`).
 */
export function hasSourceNumber(text: string): boolean {
  return /\d{2,}|\d[.,]\d/.test(toLatinDigits(text));
}

/** Espaces qui séparent les milliers (`1 000`, insécable, fine insécable). */
const THOUSANDS_SEPARATOR = /[ \u00a0\u202f]/g;

/**
 * Les nombres non triviaux d'un texte, sous une forme canonique comparable :
 *
 *   • les figures `<svg>…</svg>` sont retirées d'abord — leurs coordonnées ne sont pas des
 *     données (le faux positif du pilote de l'é27) ;
 *   • `1 000` s'écrit `1000` (un seul espace entre groupes de trois chiffres) ;
 *   • un décimal prend le point et perd ses zéros de fin (`2,50` = `2.5`), un entier ses zéros
 *     de tête (`0125` = `125`).
 */
export function nonTrivialNumbers(text: string): Set<string> {
  const plain = toLatinDigits(text)
    .replace(/<svg[\s\S]*?<\/svg>/gi, " ")
    .replace(/(?<!\d)\d{1,3}(?:[ \u00a0\u202f]\d{3})+(?!\d)/g, (m) =>
      m.replace(THOUSANDS_SEPARATOR, ""),
    );
  const out = new Set<string>();
  for (const [raw] of plain.matchAll(/\d+[.,]\d+|\d{3,}/g)) {
    out.add(
      /[.,]/.test(raw) ? String(Number(raw.replace(",", "."))) : raw.replace(/^0+(?=\d)/, ""),
    );
  }
  return out;
}
