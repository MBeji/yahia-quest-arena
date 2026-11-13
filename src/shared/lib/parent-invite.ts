// « INVITER MON PARENT » — étude 40, lot 5 (R-19).
//
// Le message qu'un élève envoie à son parent : une phrase et le lien de SON bilan, code déjà
// rempli. Le code alliance est une clé au porteur — il se transmettait déjà ainsi, recopié à la
// main depuis le paramétrage ; ce module ne fait que l'écrire dans un lien.
//
// `?src=share` est lu puis retiré de l'adresse par `entry-source.ts` : il alimente
// `visit_returned{entry:"share"}` et ne se repartage pas avec le lien. `?code=` reste.
//
// Pur : le code entre en argument, l'hôte vient de la constante canonique.
//
// `entry-source` n'est importé qu'en TYPE (comme dans `share-text.ts`) : un import de valeur le
// détachait de `visit-beacon` en un chunk à lui, une requête de plus sur chaque page publique
// (mesuré par `perf:budget` sur `/programme`). Le test vérifie que `entry-source` relit bien `src`.

import { SITE_URL } from "@/shared/constants/site";
import type { EntrySource } from "@/shared/lib/entry-source";

const INVITE_SOURCE: EntrySource = "share";

/** R-19 — le lien du bilan, absolu (un lien relatif collé dans WhatsApp n'ouvre rien). */
export function parentInviteUrl(allianceCode: string): string {
  return `${SITE_URL}/suivi?code=${encodeURIComponent(allianceCode)}&src=${INVITE_SOURCE}`;
}

/** R-19 — met le gabarit en mots : `{url}` seul. Du texte brut ; ni prénom ni pseudo. */
export function parentInviteText(template: string, allianceCode: string): string {
  return template.replace("{url}", () => parentInviteUrl(allianceCode));
}
