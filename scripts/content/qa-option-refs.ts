/**
 * Le renvoi positionnel : une explication qui désigne une option par sa LETTRE.
 *
 * Toutes les surfaces mélangent les options à l'affichage (`shuffleOptions`) : la lettre
 * `(b)` que l'auteur voyait n'est pas celle que l'élève voit. « الخطأ الشائع (b): نسيان الحدّ
 * الأوسط » envoie donc l'élève sur une option au hasard — l'explication, le seul endroit où
 * il apprend de son erreur, lui ment. L'audit de l'arabe 8ᵉ l'a trouvé dans une question sur
 * cinq des chapitres relus (corpus #531 → #555) ; mesuré le 2026-09-27 sur tout le corpus :
 * environ 300 questions.
 *
 * Le remède est de CITER le texte de l'option. Contrôle `warn` : il nomme le défaut sans
 * bloquer la dette publiée ; le cliquet de la Content CI ne mesure pas les avertissements.
 *
 * Les faux amis écartés, parce qu'ils sont la notation, pas un renvoi :
 *  - une lettre collée à ce qui la précède (`f′(a)`, `arg(a)`, `(f⁻¹)′(7)`) : un argument ;
 *  - une MAJUSCULE (`(B)`) : un point ;
 *  - `(d)` en géométrie : une droite (`(d) ∥ (d′)`), d'où l'exemption des chapitres spatiaux ;
 *  - une lettre qui n'est l'identifiant d'aucune option de la question.
 */

import type { Flag } from "./qa-checks.ts";

/** Les lettres arabes d'énumération, ramenées aux identifiants d'option. */
const ARABIC_LETTER: Record<string, string> = { أ: "a", ب: "b", ج: "c", د: "d" };

/**
 * `(b)` ou `(ج)` isolé, ou « option b / réponse b / choix b / answer b / piège b ». Le
 * look-behind écarte l'argument de fonction (`f(a)`) et l'indice (`x²(a)`) ; la casse est
 * tenue (pas de drapeau `i`) pour qu'un point `(B)` ne passe pas pour l'option `b`.
 */
const POSITIONAL =
  /(?<![\p{L}\p{N}′’'⁻¹²³)\]])\(([a-f]|[أبجد])\)|\b(?:[Oo]ption|[Rr]éponse|[Aa]nswer|[Cc]hoice|[Cc]hoix|[Pp]iège)\s+\(?([a-f])\)?(?![\p{L}\p{N}’'])/gu;

/** Un nom de droite ou de segment juste avant : `المستقيم (d)`, `la droite (d)`. */
const GEOMETRY_NAME = /(?:droite|segment|axe|line|المستقيم|مستقيم|محور|قطعة)\s*$/iu;

export function auditPositionalOptionRef(
  q: { explanation: string; options: ReadonlyArray<{ id: string }> },
  where: string,
  spatial: boolean,
): Flag[] {
  const ids = new Set(q.options.map((o) => o.id.toLowerCase()));
  for (const m of q.explanation.matchAll(POSITIONAL)) {
    const raw = m[1] ?? m[2];
    const letter = ARABIC_LETTER[raw] ?? raw;
    if (!ids.has(letter)) continue;
    if (spatial && letter === "d") continue;
    const before = q.explanation.slice(Math.max(0, (m.index ?? 0) - 14), m.index);
    if (GEOMETRY_NAME.test(before)) continue;
    return [
      {
        level: "warn",
        where,
        msg: `explanation points at an option by its letter ("${m[0].trim()}") — options are shuffled on screen, quote the option's text instead`,
      },
    ];
  }
  return [];
}
