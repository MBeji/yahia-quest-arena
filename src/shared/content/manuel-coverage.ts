/**
 * Couverture des manuels élèves officiels — étude 21 lot 4 (§3.5).
 *
 * Croise, par chapitre, ce que le MANIFESTE de programme déclare du manuel avec
 * ce que les missions DÉCLARENT reprendre, et rend de quoi piloter une campagne :
 * un taux quand on l'a, une liste nominale de ce qui reste quand on l'a.
 *
 * ⚠️ **ADVISORY, ET SEULEMENT ADVISORY.** Rien d'ici n'entre dans le
 * `findingCount` qui pilote `audit --strict` sur les grades `sealed`. Une
 * couverture partielle n'est pas une régression : c'est l'état normal d'une
 * campagne en cours, et un tableau de bord qui fait rougir la CI devient un
 * tableau de bord qu'on désactive. Le seul gate que l'étude accepte est un
 * `[warn]` de cohérence de pages, posé ailleurs (`qa-checks.ts`).
 *
 * Module PUR : zéro I/O, zéro `process`, zéro chemin de fichier — même posture
 * que `program-manifest.ts`. L'appelant lit le disque et passe des structures.
 */

/** Ce que le manifeste déclare du manuel pour un chapitre attendu. */
export interface DeclaredManuel {
  readonly code: string;
  readonly pages?: string;
  /** Combien d'exercices le manuel porte sur ce chapitre — donne un taux. */
  readonly exerciseCount?: number;
  /** Leurs libellés — donne le diff nominal. */
  readonly exerciseItems?: readonly string[];
}

/** Une mission qui déclare reprendre des exercices du manuel. */
export interface TakenUpExercise {
  readonly exerciseSlug: string;
  /** Déjà résolu par le loader (héritage du chapitre). */
  readonly code: string;
  readonly pages?: string;
  readonly items: readonly string[];
}

/** L'entrée d'un chapitre : ce qui est déclaré, ce qui est repris. */
export interface ChapterCoverageInput {
  readonly slug: string;
  /** Libellé officiel de la notion, pour le rapport seulement. */
  readonly notion?: string;
  /** `manifest.chapters[].manuel` — absent = couverture non mesurable. */
  readonly declared?: DeclaredManuel;
  /** `chapter.json` → `manuel.code`. Son absence est le constat R-9. */
  readonly chapterManuelCode?: string;
  readonly takenUp: readonly TakenUpExercise[];
}

/** Les trois profondeurs assumées par l'étude (§3.2). */
export type CoveragePrecision = "none" | "count" | "items";

export interface ChapterCoverage {
  readonly slug: string;
  readonly notion?: string;
  readonly precision: CoveragePrecision;
  /** Items DISTINCTS repris — deux missions qui reprennent « ex. 12 » comptent 1. */
  readonly takenUpCount: number;
  /** Ce que le manuel porte, quand on le sait. */
  readonly declaredCount: number | null;
  /** Ce qui reste, nommé — seulement en précision `items`. */
  readonly remaining: readonly string[] | null;
  /**
   * Items tracés qu'on ne retrouve pas dans la liste déclarée : une typo bien
   * plus probablement qu'un exercice fantôme. Jamais bloquant, mais dit.
   */
  readonly unknownItems: readonly string[];
  /** R-9 : le chapitre ne déclare aucun manuel alors que la matière en a un. */
  readonly missingChapterManuel: boolean;
  /** Le manifeste et la mission ne parlent pas du même livre. */
  readonly codeMismatches: readonly string[];
}

export interface SubjectCoverage {
  readonly subjectId: string;
  readonly chapters: readonly ChapterCoverage[];
  /** Somme des items distincts repris, tous chapitres confondus. */
  readonly takenUpTotal: number;
  /** Somme des déclarés MESURABLES (les chapitres sans déclaration sont hors). */
  readonly declaredTotal: number;
  /** Chapitres dont la couverture n'est pas mesurable, faute de déclaration. */
  readonly unmeasurable: number;
}

/**
 * Comparaison des libellés d'items.
 *
 * Le manuel imprime « ex. 12 », l'auteur tape parfois « Ex 12 » ou « ex.12 ».
 * Traiter ces trois formes comme trois exercices différents produirait un
 * rapport qui a l'air précis et qui ment : on normalise donc les espaces, la
 * casse et les points. On ne va PAS plus loin — « ex. 15a » et « ex. 15 » sont
 * bien deux items, et les confondre effacerait un reste réel.
 */
export function normalizeItem(item: string): string {
  // `\s` couvre déjà l'insécable et la fine insécable que la typographie
  // française glisse dans « ex. 12 » : seul le point demande un traitement.
  return item.trim().toLocaleLowerCase("fr").replace(/\./g, " ").replace(/\s+/g, " ").trim();
}

/** La couverture d'UN chapitre. */
export function chapterCoverage(input: ChapterCoverageInput): ChapterCoverage {
  const declared = input.declared;
  const declaredItems = declared?.exerciseItems;
  const precision: CoveragePrecision = declaredItems
    ? "items"
    : declared?.exerciseCount !== undefined
      ? "count"
      : "none";

  // Distinct : deux missions peuvent légitimement se partager un même exercice
  // du manuel (une reprise directe + une reprise adaptée). Il reste UN item.
  const takenUpKeys = new Map<string, string>();
  for (const ex of input.takenUp) {
    for (const item of ex.items) takenUpKeys.set(normalizeItem(item), item);
  }

  const declaredKeys = new Map<string, string>();
  for (const item of declaredItems ?? []) declaredKeys.set(normalizeItem(item), item);

  const remaining =
    precision === "items"
      ? [...declaredKeys].filter(([k]) => !takenUpKeys.has(k)).map(([, label]) => label)
      : null;

  // Un item inconnu ne se signale QUE si on a une liste à laquelle le comparer.
  const unknownItems =
    precision === "items"
      ? [...takenUpKeys].filter(([k]) => !declaredKeys.has(k)).map(([, label]) => label)
      : [];

  const codeMismatches = declared
    ? [...new Set(input.takenUp.filter((e) => e.code !== declared.code).map((e) => e.exerciseSlug))]
    : [];

  return {
    slug: input.slug,
    ...(input.notion === undefined ? {} : { notion: input.notion }),
    precision,
    takenUpCount: takenUpKeys.size,
    declaredCount: declaredItems ? declaredKeys.size : (declared?.exerciseCount ?? null),
    remaining,
    unknownItems,
    // R-9 se lit sur le chapitre, pas sur le manifeste : c'est `chapter.json`
    // qui alimente la galerie de pages, et son absence est ce qu'on veut voir.
    missingChapterManuel: input.chapterManuelCode === undefined,
    codeMismatches,
  };
}

/** La couverture d'une matière entière. */
export function subjectCoverage(
  subjectId: string,
  chapters: readonly ChapterCoverageInput[],
): SubjectCoverage {
  const rows = chapters.map(chapterCoverage);
  return {
    subjectId,
    chapters: rows,
    takenUpTotal: rows.reduce((n, c) => n + c.takenUpCount, 0),
    // Les chapitres non mesurables ne gonflent PAS le dénominateur : un taux
    // calculé sur ce qu'on ignore serait faux dans le sens flatteur.
    declaredTotal: rows.reduce((n, c) => n + (c.declaredCount ?? 0), 0),
    unmeasurable: rows.filter((c) => c.precision === "none").length,
  };
}

/**
 * Le taux, en pourcentage entier — ou `null` quand rien n'est mesurable.
 *
 * `null` et non `0` : « aucune campagne n'a commencé » et « rien n'est
 * déclaré » sont deux états différents, et les afficher pareil ferait passer
 * une transcription incomplète pour un retard de contenu.
 */
export function coverageRate(
  c: Pick<SubjectCoverage, "takenUpTotal" | "declaredTotal">,
): number | null {
  if (c.declaredTotal <= 0) return null;
  return Math.round((c.takenUpTotal / c.declaredTotal) * 100);
}
