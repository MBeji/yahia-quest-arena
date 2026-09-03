/**
 * LE CATALOGUE DE LA BOUTIQUE, LU DANS LES MIGRATIONS — jamais recopié (#937).
 *
 * G-3 s'appelle « la boutique draine ce que le jeu produit » et ne mesurait pas
 * la boutique : son seul puits modélisé était le RACHAT DE SÉRIE, ce que son
 * propre commentaire disait en toutes lettres. Conséquence, mesurée :
 *
 *   • G-3 rendait 100 % parce que le rachat, à 15 coins, peut absorber presque
 *     tous les coins d'un élève — donc il récompensait un rachat BON MARCHÉ ;
 *   • G-4, qui veut un rachat CHER, lisait le même nombre en sens inverse.
 *
 * Les deux garde-fous se battaient sur une seule valeur, et l'espace où ils
 * tenaient ensemble se réduisait à quelques fenêtres de prix. Rendre à G-3 son
 * vrai sujet dissout la contradiction : G-4 gouverne seul le prix du rachat.
 *
 * ── POURQUOI LIRE LES MIGRATIONS, ET PAS UNE LISTE ICI ─────────────────────
 *
 * Les prix vivent dans `supabase/migrations/**`, qui est leur seule source de
 * vérité — c'est ce SQL qui s'applique en production. Les recopier créerait une
 * seconde liste, et le dépôt sait ce que coûtent deux listes tenues à la main :
 * « Deux listes tenues à la main ont divergé deux fois » (`auth-refusals.ts`).
 *
 * ⚠️ EN CONTREPARTIE, LE PARSEUR DOIT ÉCHOUER FORT. Un regex sur du SQL qui
 * rendrait SILENCIEUSEMENT moins d'objets ferait lire à G-3 une boutique plus
 * pauvre qu'elle ne l'est, et son verdict basculerait sans que rien ne le dise —
 * exactement le mode de panne que ce dépôt passe son temps à documenter. D'où :
 * zéro objet trouvé ⇒ on LÈVE, et un test épingle le compte et les bornes.
 */
import { readFileSync, readdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const MIGRATIONS = join(
  dirname(fileURLToPath(import.meta.url)),
  "..",
  "..",
  "supabase",
  "migrations",
);

/**
 * Une ligne de `VALUES` d'un `INSERT INTO public.shop_items`.
 *
 * Le `price_coins` est le SEUL entier nu de la ligne qui suit la description :
 * les autres colonnes sont des chaînes quotées, un `jsonb` ou un booléen. On
 * l'attrape donc entre la dernière chaîne quotée et la virgule qui précède le
 * payload — étroit, et vérifié par le test qui épingle les bornes du catalogue.
 */
const PRIX = /,\s*(\d{1,5})\s*,\s*'\{/g;

/** Les blocs `INSERT INTO public.shop_items … VALUES … ;` d'un fichier. */
function blocsInsert(sql) {
  const out = [];
  const re = /INSERT\s+INTO\s+public\.shop_items[\s\S]*?;/gi;
  for (const m of sql.matchAll(re)) out.push(m[0]);
  return out;
}

/**
 * Tous les prix du catalogue, en coins, dans l'ordre où les migrations les
 * posent. Les doublons de `code` ne sont pas dédoublonnés ici : les seeds
 * portent `ON CONFLICT (code) DO NOTHING`, et aucun code n'est répété entre les
 * migrations — le test le vérifie sur le compte.
 *
 * @returns {number[]}
 */
export function shopPrices() {
  const prices = [];
  for (const file of readdirSync(MIGRATIONS).sort()) {
    if (!file.endsWith(".sql")) continue;
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");
    if (!sql.includes("public.shop_items")) continue;
    for (const bloc of blocsInsert(sql)) {
      PRIX.lastIndex = 0;
      for (const m of bloc.matchAll(PRIX)) prices.push(Number(m[1]));
    }
  }
  if (prices.length === 0) {
    throw new Error(
      "[economy] Aucun prix de boutique trouvé dans supabase/migrations/**. " +
        "Le parseur a cessé de voir le SQL qu'il lit — G-3 mesurerait une boutique vide " +
        "et rendrait un verdict faux en silence. Corriger le parseur, pas le garde-fou.",
    );
  }
  return prices;
}

/**
 * Ce que le catalogue peut absorber, en coins — la CAPACITÉ de puits durable.
 *
 * ⚠️ Ce n'est pas un modèle d'achat, et ça ne prétend pas l'être. On ne sait pas
 * ce qu'un élève achète, et l'inventer pour faire tomber un chiffre serait la
 * même faute que régler l'économie sur le test. Ce nombre répond à UNE question,
 * celle que G-3 pose depuis toujours : « la monnaie a-t-elle où aller ? »
 *
 * Le rachat de série en est volontairement EXCLU, et c'est le cœur du correctif :
 * il est RÉPÉTABLE, donc sa capacité est infinie, donc l'inclure ferait passer
 * G-3 quoi qu'il arrive. C'est précisément ce qui se produisait.
 */
export function shopCapacityCoins() {
  return shopPrices().reduce((a, b) => a + b, 0);
}
