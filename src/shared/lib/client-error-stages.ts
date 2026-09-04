// LE VOCABULAIRE DE LA BOÎTE NOIRE — une table, trois côtés, zéro mémoire.
//
// POURQUOI CE FICHIER EXISTE
// ---------------------------------------------------------------------------
// Le 2026-09-03, un élève a ouvert ses exercices, répondu question par question,
// appuyé sur « Valider » — et le suivi parental du lendemain n'en montrait
// AUCUN. Les faits, relus dans le rapport : des `exercise_sessions` commencées,
// pas une seule `completed_at`, donc pas une seule ligne dans `attempts`. La
// soumission n'a jamais abouti.
//
// Ce qui manquait n'était pas l'instrumentation — `client_errors` existe depuis
// `20260831140000` et `client-errors-watch.yml` la relève toutes les 6 h. C'est
// que `reportClientError` n'était appelé QUE derrière `isSessionRefusalError` :
// un échec de soumission pour toute AUTRE raison ne produisait pas une ligne.
// Côté élève, un `toast.error` ; côté serveur, rien. La garde a répondu « 0
// refus dans la fenêtre » ce soir-là, et elle disait vrai — elle ne regardait
// simplement pas la panne qui se produisait.
//
// C'est la moitié qui restait de #938. La table était lue ; il manquait qu'on y
// écrive ce qui coûte le plus cher : le travail d'un élève qui n'arrive pas.
//
// POURQUOI UNE TABLE PLUTÔT QUE DES CHAÎNES ÉPARPILLÉES
// ---------------------------------------------------------------------------
// Le `stage` est la clé d'agrégation de la garde (`parStage`) ET le critère de
// son nouveau seuil. Il est donc écrit à trois endroits — l'outbox, la
// soumission de quête, l'attacheur de jeton — et LU par un quatrième, un script
// Node hors du bundle. Quatre copies d'une chaîne, c'est la divergence que
// `auth-refusals.ts` a déjà payée deux fois (#931, #914/#915) : un stage
// renommé d'un côté ferait taire un seuil de l'autre, sans qu'un test tombe.
//
// D'où `Record<ClientErrorStage, …>` : ajouter un stage NE COMPILE PAS tant que
// sa ligne n'est pas écrite — sa nature, et ce qu'il advient du travail.
//
// POURQUOI IL N'IMPORTE RIEN, ET NE DOIT JAMAIS RIEN IMPORTER
// ---------------------------------------------------------------------------
// Il est lu par du code CLIENT (bundle navigateur) et par
// `scripts/reports/export-client-errors.mjs`, un module Node qui importe ce
// `.ts` directement. Une seule dépendance — un alias `@/…`, le SDK Supabase —
// et le script cesse de se charger hors du bundler. Même contrainte, et même
// raison, que `auth-refusals.ts`.

/** D'où vient une ligne de `client_errors`. */
export type ClientErrorStage =
  /** La soumission directe d'une mission a levé — le premier signe, côté élève. */
  | "quest-submit"
  /** Un rejeu de la file a échoué pour une raison qui n'est PAS un refus d'auth. */
  | "outbox-send"
  /** Un rejeu de la file s'est heurté à un refus d'auth (repris en ligne juste après). */
  | "outbox-flush"
  /** Le rejeu a été refusé DE NOUVEAU, jeton neuf en main. */
  | "outbox-replay"
  /** L'attacheur de jeton s'est fait refuser. */
  | "token-attach";

export type ClientErrorStageSpec = {
  /**
   * Ce qui est en jeu. `submission` = du travail d'élève qui n'est pas arrivé ;
   * `auth` = une session refusée, sans qu'on sache ce qu'elle portait.
   */
  readonly concern: "submission" | "auth";
  /**
   * Le chemin qui écrit cette ligne enchaîne-t-il TOUT DE SUITE sur une reprise
   * dont on sait qu'elle guérit le cas ordinaire ?
   *
   * C'est ce qui sépare le bruit du signal. `outbox-flush` est suivi, deux
   * lignes plus bas, d'un `ensureFreshSession(true)` puis d'un second envoi :
   * une expiration de jeton y produit une ligne et se répare seule. Les autres
   * n'ont personne derrière eux — une ligne y vaut une soumission qui n'a pas
   * abouti.
   */
  readonly recoversInline: boolean;
  /** Ce que la ligne raconte, en clair, pour le corps de l'issue. */
  readonly what: string;
};

export const CLIENT_ERROR_STAGES: Record<ClientErrorStage, ClientErrorStageSpec> = {
  "quest-submit": {
    concern: "submission",
    recoversInline: false,
    what: "une mission validée par l'élève que le serveur n'a pas enregistrée",
  },
  "outbox-send": {
    concern: "submission",
    recoversInline: false,
    what: "un rejeu de la file refusé pour une raison autre qu'un jeton",
  },
  "outbox-flush": {
    concern: "submission",
    recoversInline: true,
    what: "un jeton refusé pendant un rejeu, repris dans la foulée",
  },
  "outbox-replay": {
    concern: "submission",
    recoversInline: false,
    what: "un rejeu refusé MALGRÉ un jeton neuf",
  },
  "token-attach": {
    concern: "auth",
    recoversInline: false,
    what: "l'attacheur de jeton s'est fait refuser",
  },
};

/**
 * Les stages qui désignent une soumission qui n'a PAS abouti et que rien ne
 * reprend derrière — la mesure de « du travail d'élève se perd ».
 *
 * Dérivée de la table, jamais retapée : c'est tout l'intérêt d'avoir une table.
 */
export const UNRECOVERED_SUBMISSION_STAGES: readonly ClientErrorStage[] = (
  Object.keys(CLIENT_ERROR_STAGES) as ClientErrorStage[]
).filter(
  (stage) =>
    CLIENT_ERROR_STAGES[stage].concern === "submission" &&
    !CLIENT_ERROR_STAGES[stage].recoversInline,
);
