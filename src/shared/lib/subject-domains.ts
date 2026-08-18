/**
 * Regroupement des chapitres d'une matière par **domaine de programme** — les
 * « sections » qu'un élève cherche sous sa matière : Algèbre / Géométrie en
 * mathématiques, قواعد اللغة / فهم المقروء en arabe et dans les langues.
 *
 * Helper pur (aucun React, aucun Supabase). Le domaine est une donnée de contenu
 * (`chapters.domain`, écrite par l'auteur, compilée comme le titre) : cette
 * fonction ne devine rien, elle ne fait que lire.
 *
 * Deux règles, et rien d'autre :
 *
 * 1. **L'ordre des domaines se lit dans les chapitres** — celui de leur première
 *    apparition. Aucun ordre n'est stocké, donc aucun ne peut diverger de la
 *    progression du programme. Un programme de maths qui entrelace activités
 *    numériques et géométriques garde ainsi sa propre logique : le premier
 *    domaine affiché est celui de son premier chapitre.
 * 2. **Il faut deux groupes pour grouper.** Une matière dont aucun chapitre n'est
 *    rattaché — l'état de tout le corpus tant que la campagne n'a pas tourné —,
 *    ou dont tous les chapitres partagent un seul domaine, ne gagne rien à un
 *    en-tête : la fonction rend `null` et l'appelant affiche sa liste à plat.
 *    C'est ce qui rend la bascule sans risque, matière par matière.
 *
 * Le regroupement se fait sur la CLÉ d'identité (`domainKey`), pas sur le texte
 * brut : deux graphies d'un même domaine tombent dans le même groupe plutôt que
 * d'ouvrir deux en-têtes jumeaux. L'affichage garde la première graphie
 * rencontrée. `content:qa` refuse la faute en amont ; ceci la rend inoffensive
 * pour le contenu qui n'est pas passé par lui (migrations écrites à la main).
 */
import { domainKey } from "@/shared/content/chapter-domain";

/** Le strict minimum dont le regroupement a besoin. */
export type DomainChapter = { domain?: string | null };

/** Un domaine et ses chapitres, dans l'ordre du programme. */
export type ChapterDomainGroup<T> = {
  /** Clé d'identité du domaine — stable, utilisable comme clé de rendu. */
  key: string;
  /**
   * Libellé à afficher, dans la langue de la matière et la graphie de son premier
   * chapitre. `null` = le groupe des chapitres non rattachés.
   */
  label: string | null;
  chapters: T[];
};

/** Clé du groupe fourre-tout : jamais rendue par `domainKey` (elle contient un `:`). */
const UNGROUPED_KEY = "domain:none";

/**
 * Groupe les chapitres d'une matière par domaine, dans l'ordre où les domaines
 * apparaissent. Rend `null` quand il n'y a pas au moins deux groupes — la
 * matière n'est alors pas sectionnée et se lit à plat.
 *
 * L'ordre d'entrée est conservé tel quel : le hub reçoit déjà ses chapitres
 * triés par `display_order`, et ce tri EST la progression du programme.
 */
export function groupChaptersByDomain<T extends DomainChapter>(
  chapters: readonly T[],
): ChapterDomainGroup<T>[] | null {
  const groups = new Map<string, ChapterDomainGroup<T>>();

  for (const chapter of chapters) {
    const label = chapter.domain?.trim() ? chapter.domain.trim() : null;
    const key = label ? domainKey(label) : UNGROUPED_KEY;
    const existing = groups.get(key);
    if (existing) existing.chapters.push(chapter);
    else groups.set(key, { key, label, chapters: [chapter] });
  }

  const ordered = [...groups.values()];
  return ordered.length >= 2 ? ordered : null;
}
