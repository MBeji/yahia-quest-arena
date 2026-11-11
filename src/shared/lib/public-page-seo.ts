import { SITE_URL } from "@/shared/constants/site";
import { logger } from "@/shared/lib/logger";

/**
 * Ce que voit un moteur de recherche (ou l'aperçu d'un lien partagé) d'une page
 * publique du catalogue.
 *
 * Constat du 2026-11-11, sondé en production : les ~2 000 pages de cours, de
 * matière, de niveau et d'entraînement partaient du serveur avec « Chargement… »
 * pour seul texte, le MÊME titre (« Cours · Na9ra Nal3ab ») et la MÊME
 * description. Google voyait donc des milliers de pages identiques, et un lien
 * collé dans WhatsApp n'annonçait jamais le chapitre. Deux outils ici :
 *
 *  - {@link seedOnServer} précharge, PENDANT LE RENDU SERVEUR SEULEMENT, la donnée
 *    publique d'une page ; la route la passe à React Query en `placeholderData`.
 *  - {@link publicPageMeta} en tire titre, description et carte Open Graph.
 */

/** Une description utile tient dans l'extrait de Google (~155 caractères). */
export const META_DESCRIPTION_MAX = 160;

/**
 * Charge la donnée publique d'une page pendant le rendu serveur, et seulement là.
 *
 * - **Serveur** : la requête d'une page HTML ne porte jamais d'en-tête
 *   `Authorization` (le jeton vit côté client, `auth-attacher`), donc
 *   `optionalSupabaseAuth` répond TOUJOURS en anonyme — le HTML ne contient que
 *   ce que n'importe quel visiteur peut lire.
 * - **Client** : `null`, sans appel. En navigation client la route garde son
 *   chargement d'avant ; à l'hydratation elle relit la valeur du serveur.
 * - **Panne** : `null` et une ligne de journal. Une page qui n'a pas pu être
 *   préchargée retombe sur le chargement client, elle ne casse jamais le rendu.
 *
 * ⚠️ Dans `load`, la fonction serveur s'importe À LA DEMANDE (`await import(…)`),
 * jamais en tête de la route. Le `loader` d'une route vit dans le chunk d'entrée,
 * que tout visiteur télécharge (seul son composant est découpé) : un import
 * statique y embarque les souches de TOUTES les fonctions serveur du fichier visé
 * — un `createServerFn(…)` au niveau module ne s'élimine pas. Mesuré le
 * 2026-11-11 : quatre routes, +1,9 Ko sur `index-`, budget dépassé. Importée
 * dans la fonction SSR, elle disparaît du bundle client avec elle.
 */
export async function seedOnServer<T>(label: string, load: () => Promise<T>): Promise<T | null> {
  if (!import.meta.env.SSR) return null;
  try {
    return await load();
  } catch (error) {
    logger.warn("public page SSR seed failed — falling back to client fetch", { label, error });
    return null;
  }
}

/**
 * Texte brut d'un champ de contenu (markdown léger, éventuellement du HTML ou des
 * directives `:::`), réduit à une phrase de description : sans balisage, sans
 * retours à la ligne, coupé au dernier mot avant `max` avec une ellipse.
 */
export function plainExcerpt(
  source: string | null | undefined,
  max = META_DESCRIPTION_MAX,
): string {
  if (!source) return "";
  const text = source
    .replace(/<[^>]*>/g, " ")
    .replace(/^:::.*$/gm, " ")
    .replace(/!\[[^\]]*\]\([^)]*\)/g, " ")
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/^\s{0,3}(#{1,6}|>|[-*+]|\d+\.)\s+/gm, "")
    .replace(/[*_`~|$\\]/g, "")
    .replace(/\s+/g, " ")
    .trim();
  if (text.length <= max) return text;
  const cut = text.slice(0, max - 1);
  const lastSpace = cut.lastIndexOf(" ");
  return `${(lastSpace > max / 2 ? cut.slice(0, lastSpace) : cut).trimEnd()}…`;
}

type MetaTag =
  { title: string } | { name: string; content: string } | { property: string; content: string };

type JsonLdScript = { type: "application/ld+json"; children: string };

export type PublicPageHead = { meta: MetaTag[]; scripts?: JsonLdScript[] };

/**
 * JSON-LD sérialisé pour un `<script>` : `<` échappé en `\u003c`, de sorte qu'un
 * titre de contenu contenant `</script>` ne puisse jamais fermer la balise.
 */
export function serializeJsonLd(data: Record<string, unknown>): string {
  return JSON.stringify(data).replace(/</g, "\\u003c");
}

export type PublicPageMetaInput = {
  /** Le nom propre de la page, sans le nom du site (il est ajouté). */
  title: string;
  /** Une phrase ; vide → la description par défaut de la racine reste en place. */
  description?: string;
  /** `article` pour une leçon ; `website` (défaut) pour un sommaire. */
  type?: "website" | "article";
  /** Chemin relatif au site, pour `og:url`. */
  path: string;
  /** Données structurées schema.org, servies en `application/ld+json`. */
  jsonLd?: Record<string, unknown>;
};

/** Le suffixe de marque commun à tous les titres d'onglet du site public. */
export const SITE_TITLE_SUFFIX = " · Na9ra Nal3ab";

/**
 * Le `<head>` propre à une page publique. TanStack Router fait gagner la route la
 * plus profonde pour un même `name`/`property` : ces balises remplacent donc
 * celles, génériques, de la racine, sans les dupliquer.
 */
export function publicPageHead(input: PublicPageMetaInput): PublicPageHead {
  const fullTitle = `${input.title}${SITE_TITLE_SUFFIX}`;
  const description = plainExcerpt(input.description);
  const meta: MetaTag[] = [
    { title: fullTitle },
    { property: "og:title", content: fullTitle },
    { property: "og:type", content: input.type ?? "website" },
    { property: "og:url", content: `${SITE_URL}${input.path}` },
  ];
  if (description) {
    meta.push(
      { name: "description", content: description },
      { property: "og:description", content: description },
    );
  }
  if (!input.jsonLd) return { meta };
  return {
    meta,
    scripts: [{ type: "application/ld+json", children: serializeJsonLd(input.jsonLd) }],
  };
}
