import { domainKey } from "../../src/shared/content/chapter-domain.ts";
import type { Flag } from "./qa-checks.ts";

/* --------------------------------------------------------------------------
 * Cohérence des DOMAINES de programme d'une matière — ses « sections » : Algèbre
 * et Géométrie en mathématiques, قواعد اللغة et فهم المقروء en arabe et dans les
 * langues.
 *
 * `chapters.domain` est un LIBELLÉ sans table de référence : le texte est
 * l'identité (voir `src/shared/content/chapter-domain.ts`, la règle partagée
 * avec le hub matière). Rien d'autre que cette passe ne peut donc voir qu'un
 * auteur a écrit deux fois le même domaine autrement, ou qu'il n'en a rattaché
 * que la moitié — le schéma Zod ne voit qu'un `chapter.json` à la fois, et la
 * faute n'existe qu'ENTRE chapitres frères. D'où une passe par MATIÈRE.
 *
 * Vit dans son propre module, comme `qa-option-reference` : `qa-checks.ts` tient
 * son plafond de lignes, et une règle qui se lit d'un bloc se relit mieux.
 * ------------------------------------------------------------------------ */

/** A chapter as the domain audit needs to see it. */
export type QADomainChapter = { slug: string; domain?: string };

/**
 * Les quatre constats, sur les chapitres d'UNE matière :
 *
 *   [error] domaine sur une matière HORS PROGRAMME → une section est une notion
 *           de PROGRAMME scolaire. Une matière sans niveau (`gradeSlug` nul :
 *           parcours libre, entraînement, culture générale) n'a pas de programme
 *           officiel dont on pourrait tirer des domaines — ce qu'on y écrirait
 *           serait un découpage inventé. Arbitrage du 2026-08-18.
 *   [error] deux orthographes d'un même domaine → le hub regroupe par identité
 *           (accents, casse, tashkil pliés), donc l'une des deux graphies
 *           disparaît de l'écran sans que personne ne le voie. Précision totale :
 *           même clé + libellés différents = faute de frappe, jamais un choix.
 *   [warn]  rattachement partiel → les chapitres restants tombent dans « autres
 *           chapitres ». Légitime en cours de campagne, d'où le warn.
 *   [warn]  un seul domaine pour toute la matière → il ne groupe rien : le hub
 *           n'affiche des en-têtes qu'à partir de deux groupes. Le champ est
 *           écrit, il ne produit rien — l'auteur doit le savoir.
 */
export function auditChapterDomains(
  chapters: QADomainChapter[],
  where: string,
  /** Niveau de la matière — `null` pour une matière hors programme scolaire. */
  gradeSlug: string | null,
): Flag[] {
  const flags: Flag[] = [];
  const declared = chapters.filter((c) => c.domain);
  if (gradeSlug === null && declared.length > 0) {
    return [
      {
        level: "error",
        where,
        msg:
          `${declared.length} chapter(s) declare a domain, but this subject has no grade — ` +
          `a domain is a notion of the SCHOOL PROGRAM, and a free track has no official program ` +
          `to take its sections from`,
      },
    ];
  }
  // Insertion order = program order: the first spelling met is the one the hub
  // will display, so it is also the one the message tells the author to keep.
  const spellings = new Map<string, string[]>();
  const withDomain: string[] = [];
  const without: string[] = [];

  for (const c of chapters) {
    if (!c.domain) {
      without.push(c.slug);
      continue;
    }
    withDomain.push(c.slug);
    const key = domainKey(c.domain);
    const seen = spellings.get(key);
    if (!seen) spellings.set(key, [c.domain]);
    else if (!seen.includes(c.domain)) seen.push(c.domain);
  }

  for (const variants of spellings.values()) {
    if (variants.length < 2) continue;
    flags.push({
      level: "error",
      where,
      msg:
        `domain written ${variants.length} ways for one and the same domain: ` +
        `${variants.map((v) => `"${v}"`).join(", ")} — the hub groups them together and keeps ` +
        `only "${variants[0]}"; pick one spelling`,
    });
  }

  if (withDomain.length > 0 && without.length > 0) {
    const shown = without.slice(0, 5).join(", ");
    flags.push({
      level: "warn",
      where,
      msg:
        `${without.length} chapter(s) carry no domain while ${withDomain.length} do ` +
        `(${shown}${without.length > 5 ? ", …" : ""}) — they land under "other chapters" in the hub`,
    });
  }

  if (spellings.size === 1 && without.length === 0 && chapters.length > 1) {
    flags.push({
      level: "warn",
      where,
      msg: `every chapter declares the same domain ("${[...spellings.values()][0]?.[0]}") — one group is no grouping, the hub shows headings from two domains on`,
    });
  }

  return flags;
}
