import type { TranslationKeys } from "@/lib/i18n";

/**
 * Suppression de compte — la part PURE : comparer une saisie à une adresse, et
 * nommer un échec dans la langue du visiteur.
 *
 * Pourquoi un module à part plutôt que deux lignes dans la server fn : la
 * comparaison est faite DEUX FOIS, à deux endroits qui ne peuvent pas diverger
 * sans conséquence. Le client s'en sert pour armer le bouton (l'utilisateur doit
 * voir « ça correspond » avant de cliquer) ; le serveur s'en sert comme garde
 * réelle, parce qu'un client peut appeler la server fn sans passer par le
 * formulaire. Si les deux normalisaient différemment — l'un `trim()`, l'autre
 * pas — on obtiendrait le pire des deux mondes : un bouton actif qui échoue, ou
 * pire, une garde plus laxiste que l'affichage. Une seule fonction, importée des
 * deux côtés, rend la divergence impossible.
 *
 * Les codes d'erreur suivent l'idiome déjà posé par `parent-code-errors.ts`
 * (étude 15, lot 3) : le serveur jette `<PREFIX><code>`, le client traduit. Un
 * message français en dur remonterait tel quel à un parent arabophone.
 */
export type AccountDeleteErrorCode = "email_mismatch" | "generic";

export const ACCOUNT_DELETE_ERROR_PREFIX = "ACCOUNT_DELETE_ERROR:";

/**
 * La forme comparable d'une adresse : sans espaces de bord, en minuscules.
 *
 * On ne va pas plus loin volontairement. Normaliser DAVANTAGE (retirer les points
 * d'un compte Gmail, couper un suffixe `+quelque-chose`) rendrait la confirmation
 * plus permissive que l'identité réelle du compte : deux adresses distinctes
 * deviendraient équivalentes, et le geste cesserait de prouver que la personne
 * sait quel compte elle efface. La casse et les espaces, eux, ne distinguent
 * jamais deux comptes — un correcteur mobile en ajoute sans qu'on le demande.
 */
export function normalizeAccountEmail(value: string): string {
  return value.trim().toLowerCase();
}

/** La saisie désigne-t-elle bien le compte connecté ? */
export function confirmsAccountEmail(typed: string, accountEmail: string | null): boolean {
  if (!accountEmail) return false;
  const normalized = normalizeAccountEmail(typed);
  return normalized.length > 0 && normalized === normalizeAccountEmail(accountEmail);
}

const CODES: ReadonlySet<string> = new Set([
  "email_mismatch",
  "generic",
] satisfies AccountDeleteErrorCode[]);

/**
 * Traduire l'erreur remontée par la server fn. Tout ce qui ne porte pas le
 * préfixe (panne réseau, message hérité) retombe sur le libellé générique.
 */
export function accountDeleteErrorLabel(message: string, t: TranslationKeys): string {
  const labels = t.settings.deleteErrors;
  if (!message.startsWith(ACCOUNT_DELETE_ERROR_PREFIX)) return labels.generic;
  const code = message.slice(ACCOUNT_DELETE_ERROR_PREFIX.length);
  if (!CODES.has(code) || code === "generic") return labels.generic;
  return labels[code as Exclude<AccountDeleteErrorCode, "generic">];
}
