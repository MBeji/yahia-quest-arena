// LE VOCABULAIRE DU REFUS D'AUTHENTIFICATION — et rien d'autre.
//
// POURQUOI CE FICHIER EXISTE, ET POURQUOI IL N'IMPORTE RIEN. Reconnaître un
// refus d'authentification intéresse quatre appelants qui n'ont aucune raison de
// se connaître : le middleware client (qui arme son rafraîchissement), le
// `QueryClient` du routeur (qui rejoue l'appel), la file locale de l'outbox (qui
// force un jeton neuf avant sa reprise) et le rendu d'un message d'erreur. Loger
// ces fonctions dans `auth-attacher.ts` les rendait indissociables de son
// `createMiddleware(...)`, exécuté à L'IMPORT : un simple helper de message
// tirait alors tout le middleware dans son sillage, et deux suites de tests du
// lecteur de mission — qui ne mockent de `@tanstack/react-start` que ce dont
// elles se servent — tombaient à l'importation. Un prédicat pur n'a besoin de
// rien : il ne coûte donc rien à importer, depuis n'importe où.

/**
 * Les messages EXACTS que lève `requireSupabaseAuth` quand l'appel n'a pas
 * d'identité UTILISABLE. Ils ne sont produits qu'à un seul endroit du serveur
 * (`auth-middleware.ts`) — `optionalSupabaseAuth`, lui, dégrade en anonyme sans
 * jamais lever —, donc les reconnaître au message n'est pas une ficelle : c'est
 * la signature d'un refus posé AVANT tout code métier.
 *
 * POURQUOI DEUX, ET PAS UN — c'est le correctif du 2026-08-31. Toute la
 * machinerie de reprise (`markTokenRejected`, `mutations.retry`, la reprise de
 * l'outbox) ne connaissait que `INVALID_TOKEN` : « le jeton a été présenté, et
 * il a été refusé ». Or la panne signalée sous le nom « Failed to load
 * dashboard » n'est PAS celle-là, et le dépôt le disait déjà en toutes lettres à
 * deux endroits (le refus `NO_HEADER` d'`auth-middleware.ts`, le type
 * `AuthFailure` d'`auth-request.ts`) : c'est `NO_HEADER`, le cas où le client n'a
 * pas pu produire de jeton DU TOUT — rafraîchissement en échec, ou lecture de
 * session qui n'a pas rendu sous les 8 s d'`auth-attacher`.
 *
 * Ce message-là ne rentrait dans aucun des deux prédicats ci-dessous, et les
 * trois conséquences s'enchaînaient sans issue : le drapeau n'était jamais armé,
 * donc l'essai suivant refaisait le `getSession()` qui venait déjà d'échouer au
 * lieu de FORCER un `refreshSession()` ; les trois reprises par défaut d'une
 * requête empruntaient toutes ce même chemin mort ; et le bouton « Réessayer »
 * de l'écran d'erreur rejouait la même chose indéfiniment. Pendant ce temps rien
 * n'avait émis `SIGNED_OUT`, donc le garde de `_authenticated` ne renvoyait pas
 * vers la connexion : l'élève restait devant « Failed to load dashboard », et
 * seule une déconnexion/reconnexion manuelle l'en sortait. Signalé le
 * 2026-08-18, puis de nouveau après #914/#915 — qui avaient traité le jeton
 * REFUSÉ sans jamais traiter le jeton ABSENT.
 *
 * L'ironie mérite d'être notée, parce qu'elle explique la rechute : #915 justifie
 * sa limite de 8 s par « passé ce délai on part SANS jeton : le serveur refuse,
 * l'échec se voit, et la reprise rejoue l'appel ». Cette reprise n'existait pas —
 * partir sans jeton produit exactement `NO_HEADER`, que la politique de reprise
 * ne reconnaissait pas. Le garde-fou anti-gel troquait donc un blocage silencieux
 * contre une erreur DÉFINITIVE. C'est cette phrase-là que la liste ci-dessous
 * rend enfin vraie.
 */
const REFUSAL_MESSAGES = [
  /** `INVALID_TOKEN` — le jeton a été présenté, le service Auth l'a refusé. */
  "Unauthorized: Invalid token",
  /** `NO_HEADER` — le client n'a pas pu produire de jeton (la panne ci-dessus). */
  "Unauthorized: No authorization header provided",
] as const;

/**
 * Cet échec est-il un refus du garde d'authentification, posé faute d'identité
 * utilisable ?
 *
 * Ce que la réponse AUTORISE compte plus que ce qu'elle nomme : `true` signifie
 * que la server fn n'a pas commencé — le middleware lève avant `next()` —, donc
 * que rien n'a été lu, écrit ni facturé. C'est ce qui rend un REJEU sûr, y
 * compris pour une mutation, et c'est vrai des DEUX messages ci-dessus : le
 * second l'est même plus franchement que le premier, puisque le serveur n'a pas
 * eu de jeton à vérifier.
 *
 * CE QUI RESTE DEHORS, et pourquoi — les quatre autres refus du middleware n'ont
 * pas cette double propriété « transitoire ET guérissable par un jeton neuf » :
 * `BAD_SCHEME` et `EMPTY_TOKEN` désignent un client qui envoie n'importe quoi,
 * qu'aucun rafraîchissement ne corrige (et notre client n'en produit ni l'un ni
 * l'autre : faute de jeton il n'envoie PAS d'en-tête, ce qui est `NO_HEADER`) ;
 * `NO_SUBJECT` est une anomalie de forme du jeton, pas sa péremption ;
 * `UNAVAILABLE` est le service Auth qui ne RÉPOND pas, et lui forcer un
 * `refreshSession()` viserait le mauvais levier — c'est la même porte qu'on
 * retrouverait fermée.
 */
export function isSessionRefusalError(error: unknown): boolean {
  return (
    error instanceof Error && REFUSAL_MESSAGES.some((message) => error.message.includes(message))
  );
}

/**
 * Faut-il rejouer cet appel ? Politique de reprise des MUTATIONS, posée en
 * défaut sur le `QueryClient` (`src/router.tsx`) — elle vit ici, avec le
 * prédicat dont elle dépend, parce que « combien de fois rejoue-t-on un refus
 * d'authentification » est une question d'authentification, pas de routage.
 *
 * UNE SEULE reprise, et seulement pour ces refus-là. Une seule, parce que le
 * premier échec a armé le drapeau d'`auth-attacher` : la reprise part donc avec
 * un jeton neuf, et si celui-là est refusé aussi, la session est morte —
 * insister ne ferait que retarder l'écran qui le dit. Seulement pour ces
 * refus-là, parce que ce sont les seuls dont on sache que la server fn n'a pas
 * commencé : partout ailleurs, rejouer une mutation écrirait deux fois.
 */
export function shouldReplaySessionRefusal(failureCount: number, error: unknown): boolean {
  return failureCount < 1 && isSessionRefusalError(error);
}
