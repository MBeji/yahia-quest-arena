import type { Flag } from "./qa-checks.ts";

/* --------------------------------------------------------------------------
 * L'équation mêlée au texte de l'énoncé — la règle « une formule, une ligne ».
 *
 * Signalé en capture le 2026-08-24 sur `math/04-equations-inequations` :
 * « بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟ » s'affichait avec
 * l'équation coupée en deux lignes, `(x − 4)` finissant l'une et `(x + 2) = 0`
 * ouvrant l'autre — chaque ligne étant réordonnée POUR ELLE-MÊME par l'algorithme
 * bidi, l'élève lisait deux moitiés de formule mêlées à la prose arabe.
 *
 * Le rendu ne coupe plus une formule (`.math-run`, `src/shared/lib/bidi.ts`), donc
 * cette règle-ci ne corrige pas un bug : elle porte la demande de LISIBILITÉ qui
 * l'accompagne — dans un énoncé RTL, une formule d'un certain poids se pose SEULE
 * sur sa ligne, hors de la phrase. `RichField` rend alors cette ligne en bloc
 * centré LTR (`.math-equation`).
 *
 * Trois gardes la tiennent sans faux positif :
 *   — la ligne porte de la VRAIE prose arabe autour de la formule (deux mots au
 *     moins) : c'est là que le mélange coûte à la lecture ; en prose latine la
 *     formule suit le sens du texte et ne gêne pas ;
 *   — l'énoncé NOMME l'objet mathématique qu'il donne à traiter — « المعادلة »,
 *     « المتراجحة », « العبارة », « الجملة », « الدالة … تُعرَّف بـ », « المجموعة »,
 *     « قانون », « علاقة », « الحصر » (voir {@link EQUATION_FRAME}). C'est le cadre
 *     de phrase, pas la forme de la formule, qui sépare l'OBJET donné à traiter
 *     de la DONNÉE citée dans un récit. Aucune écriture de regex ne distingue
 *     `m = 1500 g` (une masse, à sa place dans la phrase) de `x = 5` ; le mot qui
 *     les introduit, si. Sont donc hors visée, à dessein : les données de physique
 *     et de chimie (`ρ = 0.7 g/cm³`, `M(S) = 32 g/mol`, `f = 20 cm`), les longueurs
 *     d'une figure (`BC = 10 cm`) et l'arithmétique d'un énoncé de primaire
 *     (`في العمليّة 40 + 25 = 65، ما هما الحدّان؟`) ;
 *   — la formule porte une RELATION et pèse au moins {@link INLINE_EQUATION_MIN}
 *     signes : `f(2) = 7` ou `n = 5` restent dans la phrase, c'est leur place.
 * ------------------------------------------------------------------------ */

/**
 * Sévérité de la règle « équation mêlée au texte de l'énoncé ».
 *
 * WARN, le temps que la campagne de réécriture passe sur le corpus : l'état des
 * lieux du 2026-08-24 compte **145 énoncés** concernés (85 en `math`, 27 en
 * `math-8eme`, 25 en `math-7eme`, 7 en `svt`). Les deux dépôts ne se livrant jamais dans la même PR
 * (AGENTS.md § Content pipeline), poser `error` ici ferait rougir la Content CI
 * privée entre le merge du moteur et celui du corpus. Bascule d'une ligne une fois
 * la campagne mergée — précédent : `OPTION_REFERENCE_LEVEL`.
 */
export const INLINE_EQUATION_LEVEL: Flag["level"] = "warn";

/** Poids minimal d'une formule pour qu'on exige sa propre ligne. */
const INLINE_EQUATION_MIN = 10;

const ARABIC_LETTER =
  "\\u0621-\\u064A\\u066E-\\u06FF\\u0750-\\u077F\\u08A0-\\u08FF\\uFB50-\\uFDFF\\uFE70-\\uFEFF";
/**
 * Deux mots arabes d'au moins deux lettres sur la ligne : il y a bien de la PROSE
 * autour de la formule, et pas seulement une unité ou une lettre isolée.
 */
const ARABIC_PROSE_RUN = new RegExp(
  `[${ARABIC_LETTER}]{2,}[^${ARABIC_LETTER}]+[${ARABIC_LETTER}]{2,}`,
  "u",
);
/** Le complément : les tranches de la ligne qui ne sont PAS de l'écriture arabe. */
const NON_ARABIC_SEGMENT = new RegExp(`[^${ARABIC_LETTER}]+`, "gu");
/** Les figures sont du balisage, pas de la prose — leurs attributs ne sont pas des formules. */
const SVG_BLOCKS = /<svg[\s\S]*?<\/svg>/gi;
/** Une relation — ce qui fait d'une suite de symboles une équation. */
const EQUATION_RELATION = /[=<>≤≥≠⟺⟹]/u;
/** Ponctuation et délimiteurs de phrase à retrancher aux bords avant de peser la formule. */
const EDGE_PUNCTUATION = /^[.,;:!؟?()[\]{}\s«»"'-]+|[.,;:!؟?()[\]{}\s«»"'-]+$/gu;

/**
 * Les mots par lesquels un énoncé arabe NOMME l'objet mathématique qu'il donne à
 * traiter : équation, inéquation, expression, système, fonction (« définie par »),
 * ensemble, loi / relation / formule, encadrement. Écrits en radicaux, sans
 * article ni suffixe, pour attraper les formes fléchies (`المعادلة`, `معادلتَين`,
 * `للمعادلة`).
 *
 * Deux d'entre eux sont au SINGULIER à dessein — `عبارة` et `علاقة` : leurs pluriels
 * `العبارات` et `العلاقات` ne portent plus le sens mathématique (« lesquelles de ces
 * AFFIRMATIONS sont vraies ? », « complète la suite des ÉGALITÉS »), et la ة qui
 * ferme le singulier suffit à les écarter.
 *
 * C'est cette garde qui donne sa précision à la règle : `ما حلّ المعادلة …` désigne
 * une équation À RÉSOUDRE, quand `صخرة كتلتها m = 1500 g` cite une masse dans un
 * récit. Les deux formules se ressemblent trait pour trait ; seule la phrase les
 * sépare.
 */
const EQUATION_FRAME =
  /معادل|متراجح|متباين|عبارة|جملة|الجمل|دالّ|دال[ةه]|المجموعة|قانون|علاقة|صيغة|الحصر/u;

/**
 * Une formule assez lourde pour mériter sa propre ligne : une relation et
 * {@link INLINE_EQUATION_MIN} signes au moins.
 */
function isWeightyEquation(segment: string): boolean {
  const formula = segment.trim().replace(EDGE_PUNCTUATION, "");
  if (formula.length < INLINE_EQUATION_MIN) return false;
  return EQUATION_RELATION.test(formula);
}

/**
 * L'énoncé arabe qui garde une formule d'un certain poids DANS sa phrase. Un seul
 * flag par champ : un énoncé qui porte deux formules a une mise en forme à revoir,
 * pas deux défauts. Ne s'applique qu'au `prompt` — une explication est un corrigé,
 * où la formule se lit dans le fil du raisonnement.
 */
export function auditInlineEquation(raw: string, field: string, where: string): Flag[] {
  if (field !== "prompt") return [];
  for (const line of raw.replace(SVG_BLOCKS, " ").split(/\r?\n/)) {
    if (!ARABIC_PROSE_RUN.test(line) || !EQUATION_FRAME.test(line)) continue;
    for (const segment of line.match(NON_ARABIC_SEGMENT) ?? []) {
      if (!isWeightyEquation(segment)) continue;
      const formula = segment.trim();
      const sample = formula.length > 44 ? `${formula.slice(0, 41)}…` : formula;
      return [
        {
          level: INLINE_EQUATION_LEVEL,
          where,
          msg: `equation «${sample}» is mixed into the prompt's prose in ${field} — put it ALONE on its own line (a "\\n" before it, and again after it if the sentence continues); RichField then lays it out as a centred LTR block instead of letting it run into the Arabic sentence`,
        },
      ];
    }
  }
  return [];
}
