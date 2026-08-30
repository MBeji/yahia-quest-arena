// LE VOCABULAIRE DU REFUS D'AUTHENTIFICATION — et rien d'autre.
//
// POURQUOI CE FICHIER EXISTE, ET POURQUOI IL N'IMPORTE RIEN. Reconnaître un
// jeton refusé intéresse trois appelants qui n'ont aucune raison de se
// connaître : le middleware client (qui arme son rafraîchissement), le
// `QueryClient` du routeur (qui rejoue l'appel) et le rendu d'un message
// d'erreur. Loger ces fonctions dans `auth-attacher.ts` les rendait
// indissociables de son `createMiddleware(...)`, exécuté à L'IMPORT : un simple
// helper de message tirait alors tout le middleware dans son sillage, et deux
// suites de tests du lecteur de mission — qui ne mockent de
// `@tanstack/react-start` que ce dont elles se servent — tombaient à
// l'importation. Un prédicat pur n'a besoin de rien : il ne coûte donc rien à
// importer, depuis n'importe où.

/**
 * Le message EXACT que lève `requireSupabaseAuth` quand le service Auth a
 * répondu « ce jeton ne vaut rien ». C'est le seul endroit du serveur qui le
 * produit (`auth-middleware.ts`) — `optionalSupabaseAuth`, lui, dégrade en
 * anonyme sans jamais lever —, donc le reconnaître au message n'est pas une
 * ficelle : c'est la signature d'un refus posé AVANT tout code métier.
 */
const REJECTED_TOKEN_MESSAGE = "Unauthorized: Invalid token";

/**
 * Cet échec est-il le refus d'un jeton par le garde d'authentification ?
 *
 * Ce que la réponse AUTORISE compte plus que ce qu'elle nomme : `true` signifie
 * que la server fn n'a pas commencé — le middleware lève avant `next()` —, donc
 * que rien n'a été lu, écrit ni facturé. C'est ce qui rend un REJEU sûr, y
 * compris pour une mutation. Aucun autre échec ne donne cette garantie, d'où un
 * prédicat exact plutôt qu'un « ça ressemble à de l'authentification ».
 */
export function isRejectedTokenError(error: unknown): boolean {
  return error instanceof Error && error.message.includes(REJECTED_TOKEN_MESSAGE);
}

/**
 * Faut-il rejouer cet appel ? Politique de reprise des MUTATIONS, posée en
 * défaut sur le `QueryClient` (`src/router.tsx`) — elle vit ici, avec le
 * prédicat dont elle dépend, parce que « combien de fois rejoue-t-on un refus
 * d'authentification » est une question d'authentification, pas de routage.
 *
 * UNE SEULE reprise, et seulement pour ce refus-là. Une seule, parce que le
 * premier échec a armé le drapeau d'`auth-attacher` : la reprise part donc avec
 * un jeton neuf, et si celui-là est refusé aussi, la session est morte —
 * insister ne ferait que retarder l'écran qui le dit. Seulement pour ce refus-là,
 * parce que c'est le seul dont on sache que la server fn n'a pas commencé :
 * partout ailleurs, rejouer une mutation écrirait deux fois.
 */
export function shouldReplayRejectedToken(failureCount: number, error: unknown): boolean {
  return failureCount < 1 && isRejectedTokenError(error);
}
