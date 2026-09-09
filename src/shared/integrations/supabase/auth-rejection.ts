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
// rien : il ne coûte donc rien à importer, depuis n'importe où. `auth-refusals.ts`
// respecte la même règle — il n'importe rien non plus, à dessein.
import { RECOVERABLE_REFUSAL_MESSAGES } from "./auth-refusals";

/**
 * Les messages qu'un jeton neuf peut guérir — LUS dans `auth-refusals.ts`,
 * jamais recopiés ici. C'est le correctif de fond du 2026-08-31, et il vaut
 * qu'on dise ce qu'il remplace.
 *
 * CE QUI ÉTAIT ÉCRIT ICI, ET POURQUOI ÇA A CASSÉ DEUX FOIS. Ce fichier tenait sa
 * PROPRE liste de messages, à la main, en face des sept refus que
 * `auth-middleware.ts` sait lever. Rien ne reliait les deux. Il n'en connaissait
 * qu'un — « Unauthorized: Invalid token », le jeton posé et refusé (#914) — et
 * ignorait « pas d'en-tête d'autorisation », qui est PRÉCISÉMENT la panne
 * « Failed to load dashboard » : le drapeau n'était jamais armé, aucun jeton neuf
 * n'était forcé, et l'écran d'erreur se rejouait à l'identique (2026-08-18, puis
 * 2026-08-31 après #931). Le bouton « Valider » grisé sans fin (#915) était de la
 * même famille : un refus sans sortie côté client.
 *
 * Ajouter le message manquant aurait corrigé CE cas et laissé la porte ouverte au
 * suivant. La table, elle, ferme la porte : `Record<AuthFailure, …>` oblige tout
 * nouveau refus à déclarer sa conduite client AVANT de compiler, et le message
 * n'existe plus qu'à un seul endroit — donc il ne peut plus diverger entre celui
 * qui le lève et celui qui le reconnaît.
 */
const REFUSAL_MESSAGES = RECOVERABLE_REFUSAL_MESSAGES;

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
 * CE QUI RESTE DEHORS, et pourquoi : la réponse n'est plus ici mais dans
 * `auth-refusals.ts`, où chaque refus porte son `recovery` ET la raison de ce
 * choix. C'est délibéré — tant que « quels messages ? » se répondait dans ce
 * fichier et « quels refus le serveur lève-t-il ? » dans un autre, les deux
 * pouvaient diverger, et elles l'ont fait.
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
