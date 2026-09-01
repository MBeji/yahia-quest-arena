// LE CONTRAT DES REFUS D'AUTHENTIFICATION — une table, deux côtés, zéro mémoire.
//
// POURQUOI CE FICHIER EXISTE
// ---------------------------------------------------------------------------
// Deux pannes en trois semaines, la même cause de fond : le serveur sait
// refuser de SEPT façons, et le client décidait quoi en faire à partir d'une
// liste de messages tenue À LA MAIN, dans un autre fichier, sans rien qui relie
// les deux.
//
//   * 2026-08-18 puis 2026-08-31 — « Failed to load dashboard » (#931). Le refus
//     `NO_HEADER` n'était dans aucun prédicat de reprise : le client ne forçait
//     jamais de jeton neuf, et l'écran d'erreur se rejouait à l'identique.
//   * 2026-08-2x — le bouton « Valider » grisé qui tourne sans fin (#914, #915).
//     Même famille : un refus dont le client n'avait pas de sortie.
//
// Chaque correctif a ajouté SON cas. Aucun n'a fermé la porte par laquelle le
// suivant est entré : rien n'obligeait à se demander, pour chacun des sept
// refus, « et le client, il en fait quoi ? ». C'est cette question-là que la
// table ci-dessous rend OBLIGATOIRE — pas par discipline, par compilation.
//
// CE QU'ELLE GARANTIT, ET COMMENT
// ---------------------------------------------------------------------------
//  1. `Record<AuthFailure, AuthRefusal>` est exhaustif par construction :
//     ajouter un huitième refus à `AuthFailure` NE COMPILE PAS tant que sa
//     ligne n'est pas écrite ici — message ET conduite du client. L'oubli n'est
//     plus un bug qu'on découvre en production, c'est une erreur `tsc`.
//  2. Le message n'existe QU'UNE FOIS. Il était écrit deux fois — levé par
//     `auth-middleware.ts`, reconnu par `auth-rejection.ts` — donc une
//     reformulation d'un côté cassait silencieusement la reprise de l'autre,
//     sans qu'aucun test ne tombe (chaque côté testait sa propre copie).
//     Désormais les deux LISENT cette table.
//
// POURQUOI IL N'IMPORTE RIEN, ET NE DOIT JAMAIS RIEN IMPORTER
// ---------------------------------------------------------------------------
// Il est lu par le middleware SERVEUR et par le prédicat CLIENT. Une seule
// dépendance vers `auth-request.ts` (qui tire `@supabase/supabase-js`) suffirait
// à faire entrer le SDK serveur dans le bundle du navigateur. D'où le type
// `AuthFailure` posé ICI plutôt qu'importé : c'est le fichier le plus bas de la
// pile d'authentification, et il doit le rester. Même raison que
// `auth-rejection.ts`, qui documente déjà ce piège.

/**
 * Pourquoi une requête n'a pas d'identité. Chaque appelant le traduit à sa façon
 * — une server fn lève une `Error`, la route SSE du tuteur rend un statut HTTP.
 *
 * La granularité n'est pas décorative : fondre ces cas en « pas de jeton » ferait
 * perdre la différence entre « le client n'a pas pu produire de jeton »
 * (rafraîchissement raté — la panne du 2026-08-18) et « le client envoie un
 * schéma d'autorisation qui n'existe pas ».
 */
export type AuthFailure =
  /** Aucun en-tête `Authorization` — typiquement un rafraîchissement raté côté client. */
  | "NO_HEADER"
  /** En-tête présent, mais pas `Bearer `. */
  | "BAD_SCHEME"
  /** `Bearer ` suivi de rien. */
  | "EMPTY_TOKEN"
  /** Jeton expiré, malformé, signé par une autre clé — se reconnecter. */
  | "INVALID_TOKEN"
  /** Jeton vérifié, mais sans `sub` : il n'identifie personne. */
  | "NO_SUBJECT"
  /** Le service Auth n'a pas RÉPONDU — réessayer a du sens. */
  | "UNAVAILABLE"
  /** Variables d'environnement manquantes : c'est une panne de déploiement. */
  | "MISCONFIGURED";

/**
 * Ce que le CLIENT fait de ce refus. Le champ existe pour qu'on ne puisse pas
 * ajouter un refus sans répondre à la question qui a coûté les deux pannes.
 *
 * `"fresh-token"` — un jeton neuf peut guérir ce refus. Le client arme alors un
 * `refreshSession()` forcé (`markTokenRejected`) et s'accorde UNE reprise. Ne
 * mérite cette valeur qu'un refus qui satisfait les DEUX conditions : il est
 * transitoire, et il est levé AVANT `next()` — donc aucun code métier n'a
 * tourné, rien n'a été lu ni écrit, et rejouer même une mutation est sûr.
 *
 * `"none"` — aucun rejeu ne le guérira. Le message remonte tel quel, et c'est
 * volontaire : il nomme une panne de déploiement, un client fautif ou un service
 * indisponible, trois choses qu'un jeton neuf ne change pas.
 */
export type ClientRecovery = "fresh-token" | "none";

export type AuthRefusal = {
  /** Le message EXACT que voit le client. Écrit ici, et nulle part ailleurs. */
  readonly message: string;
  /** Ce que le client en fait — voir `ClientRecovery`. */
  readonly recovery: ClientRecovery;
  /** Pourquoi cette conduite-là. Lu par un humain, pas par le code. */
  readonly why: string;
};

/**
 * Les sept refus, leur message et la conduite du client.
 *
 * ⚠️ AJOUTER UN REFUS ? Le compilateur exigera sa ligne ici. Avant d'écrire
 * `recovery: "fresh-token"`, vérifier les deux conditions de `ClientRecovery` :
 * dans le doute, `"none"` est le défaut sûr — il rend le refus visible au lieu
 * de le rejouer en boucle.
 */
export const AUTH_REFUSALS: Record<AuthFailure, AuthRefusal> = {
  NO_HEADER: {
    message: "Unauthorized: No authorization header provided",
    recovery: "fresh-token",
    why:
      "Le client n'a pas pu produire de jeton : rafraîchissement en échec, ou " +
      "lecture de session qui n'a pas rendu sous les 8 s d'`auth-attacher`. " +
      "C'est la panne « Failed to load dashboard » (2026-08-18, #931) — un " +
      "`refreshSession()` forcé est exactement ce qui en sort.",
  },
  INVALID_TOKEN: {
    message: "Unauthorized: Invalid token",
    recovery: "fresh-token",
    why:
      "auth-js ne juge de la péremption que sur l'horloge de L'APPAREIL, sans " +
      "vérifier la signature : une horloge en retard fait rendre un jeton mort. " +
      "Seul un aller-retour de rafraîchissement fait émettre un jeton par le " +
      "serveur, seule autorité sur l'heure et la signature (#914).",
  },
  BAD_SCHEME: {
    message: "Unauthorized: Only Bearer tokens are supported",
    recovery: "none",
    why:
      "Le client envoie un schéma d'autorisation qui n'existe pas — un bug de " +
      "client, pas une session fatiguée. Notre client ne produit jamais ce cas.",
  },
  EMPTY_TOKEN: {
    message: "Unauthorized: No token provided",
    recovery: "none",
    why:
      "`Bearer ` suivi de rien. Notre client ne produit pas ce cas non plus : " +
      "faute de jeton il n'envoie PAS d'en-tête, ce qui est `NO_HEADER`.",
  },
  NO_SUBJECT: {
    message: "Unauthorized: No user ID found in token",
    recovery: "none",
    why:
      "Le jeton est valide mais n'identifie personne. C'est une anomalie de " +
      "FORME, pas une péremption : un jeton neuf aurait le même défaut.",
  },
  UNAVAILABLE: {
    message: "Auth verification unavailable. Please try again.",
    recovery: "none",
    why:
      "Le service Auth n'a pas RÉPONDU. Réessayer a du sens, mais pas en " +
      "forçant un rafraîchissement : celui-ci passe par la MÊME porte, qu'on " +
      "retrouverait fermée. La reprise ordinaire des requêtes suffit, et c'est " +
      "un incident — `auth-middleware.ts` le journalise en `error`.",
  },
  MISCONFIGURED: {
    message: "Missing Supabase environment variable(s)",
    recovery: "none",
    why:
      "Panne de déploiement : une variable d'environnement manque. Aucun jeton " +
      "n'y peut rien. Seul refus dont le message est un PRÉFIXE — le middleware " +
      "y ajoute les variables manquantes, qu'il faut nommer pour agir.",
  },
};

/** Le message exact de ce refus. L'unique source, pour les deux côtés. */
export function refusalMessage(failure: AuthFailure): string {
  return AUTH_REFUSALS[failure].message;
}

/**
 * Les messages qu'un jeton neuf peut guérir — DÉRIVÉS de la table, jamais
 * recopiés. C'est ce qui garantit qu'un refus déclaré `"fresh-token"` est
 * réellement rattrapé par le client : il n'y a pas de seconde liste à tenir.
 */
export const RECOVERABLE_REFUSAL_MESSAGES: readonly string[] = Object.values(AUTH_REFUSALS)
  .filter((refusal) => refusal.recovery === "fresh-token")
  .map((refusal) => refusal.message);
