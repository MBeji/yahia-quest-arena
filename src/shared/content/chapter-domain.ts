/**
 * Identité d'un **domaine de programme** (« section » d'une matière) — la règle
 * partagée entre l'auteur, la QA du contenu et le hub matière.
 *
 * Un domaine (`chapters.domain`) est un LIBELLÉ, écrit dans la langue de la
 * matière : « Algèbre », « Géométrie », « قواعد اللغة », « فهم المقروء ». Il n'a
 * pas de table, pas d'identifiant — le texte EST l'identité. Il faut donc un
 * point unique qui dise quand deux libellés désignent le même domaine, sinon
 * « Géométrie » et « geometrie » ouvrent deux colonnes dans le hub pendant que
 * la QA les croit distincts.
 *
 * Pas de réemploi de `normalizeRecallText` (free-answer.ts) : celui-là est une
 * réplique fidèle d'une fonction SQL, pinned à son contrat de correction de
 * réponses. Deux besoins, deux règles — les fusionner ferait dériver l'un avec
 * l'autre.
 */

/**
 * Longueur maximale d'un libellé de domaine. C'est un EN-TÊTE de groupe dans le
 * hub, pas une phrase : au-delà il déborde de sa ligne sur mobile. Tenu par le
 * schéma Zod d'écriture (où l'auteur voit l'erreur), jamais par la base — voir
 * la migration `20260818120000_chapter_domain.sql` D-3.
 */
export const DOMAIN_LABEL_MAX = 60;

/** Marques combinantes (accents latins, tashkil arabe) + tatweel. */
const COMBINING = /\p{M}+/gu;
const TATWEEL = /ـ/g;
/** Tout ce qui n'est ni lettre ni chiffre devient une simple coupure de mot. */
const NON_ALPHANUMERIC = /[^\p{L}\p{N}]+/gu;

/**
 * Clé d'identité d'un libellé de domaine : deux libellés qui rendent la même clé
 * désignent le même domaine.
 *
 * Plie ce qui varie sans changer le sens — casse, accents (« Géométrie » /
 * « geometrie »), tashkil et tatweel arabes, hamza portée (أ/إ/آ → ا), ى → ي,
 * ة → ه, ponctuation et espaces multiples. Ne plie RIEN d'autre : deux domaines
 * réellement différents ne doivent jamais se confondre.
 *
 * L'affichage, lui, garde le libellé tel qu'il a été écrit — la clé ne sert qu'à
 * regrouper et à comparer.
 */
export function domainKey(label: string): string {
  return label
    .normalize("NFKD")
    .replace(COMBINING, "")
    .replace(TATWEEL, "")
    .toLowerCase()
    .replaceAll("ى", "ي")
    .replaceAll("ة", "ه")
    .replace(NON_ALPHANUMERIC, " ")
    .trim();
}
