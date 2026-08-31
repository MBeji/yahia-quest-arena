// Constantes de l'étage IA — source unique de vérité (étude 29, lot 1).
//
// POURQUOI TOUT EST ICI
// ---------------------------------------------------------------------------
// L'étude 29 §3.10 pose une règle qui n'a l'air de rien et qui tient la suite :
// **aucun identifiant de modèle, aucun prix, aucune borne de tokens ne vit
// ailleurs que dans ce fichier** (é11 D-2 étendu). Un id de modèle éparpillé
// dans une feature, c'est une bascule de modèle qui devient une chasse ; un prix
// recopié à côté d'un appel, c'est une estimation de dépense qui ment le jour où
// le fournisseur change sa grille.
//
// Ce module est ISOMORPHE : aucun secret, aucun accès réseau, aucun import
// `.server`. Il est importable depuis le client (l'écran des Réglages affiche la
// liste curée de modèles et les plafonds par défaut) — c'est justement pour cela
// qu'il ne contient rien qui ne puisse être public.
//
// Ce qui n'est PAS ici, et pourquoi : les clés (`AI_KEY_ENC_KEY`,
// `ANTHROPIC_API_KEY`) et les kill-switches sont des variables d'environnement
// serveur (§3.10) — lues dans `src/shared/integrations/ai/provider.server.ts`,
// jamais inlinées dans un bundle.

// ---------------------------------------------------------------------------
// 1. Surfaces IA — le vocabulaire fermé que la base contraint aussi
// ---------------------------------------------------------------------------

/**
 * Les surfaces qui peuvent consommer un appel de modèle. Miroir exact du CHECK
 * de `ai_usage_events.feature` : une surface ajoutée ici sans migration se fait
 * refuser à l'écriture, et c'est voulu — la comptabilité est la référence.
 *
 * `verify` est à part : c'est l'appel de vérification de clé (US-2), le seul
 * appel que le produit émet sans qu'un élève l'ait demandé.
 */
export const AI_FEATURES = [
  "verify", // vérification de la clé à l'enregistrement (US-2)
  "explain", // explication personnalisée post-review (é11 lot 1)
  "reformulate", // reformulation d'un énoncé (é11 lot 1)
  "chat", // chat cadré (é11 lot 3)
  "check", // boucle de compréhension (é11 lot 4)
  "forge", // génération d'un quiz par la Forge (é29 lot 4)
  "forge_solve", // double résolution d'un candidat de la Forge (é29 lot 4)
  "exercise_gen", // exercices ciblés choisis par le tuteur (é11 lot 5)
  "digest_student", // bilan hebdomadaire élève (é11 lot 6)
  "digest_parent", // bilan hebdomadaire parent (é11 lot 6)
] as const;

export type AiFeature = (typeof AI_FEATURES)[number];

/**
 * Surfaces INTERNES : le produit les émet lui-même, un parent ne les active
 * jamais. `verify` vérifie une clé à sa saisie ; `forge_solve` est la seconde
 * moitié de la Forge, pas une fonctionnalité qu'on choisit.
 */
export const AI_INTERNAL_FEATURES = ["verify", "forge_solve"] as const;

/**
 * LES SURFACES QUE LA CLÉ D'UNE FAMILLE PAIE — la seule liste qu'un parent voit.
 * ---------------------------------------------------------------------------
 * `AI_FEATURES` énumère le vocabulaire de l'étude ; il sert à la comptabilité,
 * aux bornes de tokens et au CHECK en base. Il ne dit RIEN de ce qui est jouable.
 *
 * ARBITRAGE DU 2026-08-26 — LA CLÉ DE LA FAMILLE OUVRE TOUT CE QUI APPELLE UN
 * MODÈLE, et c'est l'usage NOMINAL, pas une option. Jusqu'à cette date la liste
 * ne contenait que `forge` : une famille branchait sa clé, activait son enfant,
 * et ne voyait apparaître qu'une seule surface. Le tuteur, le chat, les
 * explications et les bilans continuaient de passer par la clé PLATEFORME —
 * donc muets tant qu'`AI_PLATFORM_API_KEY` n'est pas posée. C'était la moitié
 * invisible du signalement « j'ai mis ma clé et rien n'a changé ».
 *
 * ⚠️ LA RÈGLE DE CETTE LISTE N'A PAS BOUGÉ : on n'y met que des surfaces qui
 * appellent RÉELLEMENT un modèle. Proposer « Vérification de compréhension » à
 * un parent alors qu'aucun `callAi()` n'est derrière lui fait cocher un
 * interrupteur qui n'allume rien, puis conclure que le mode est cassé. C'est la
 * même faute que l'écran qui n'annonçait que deux fournisseurs quand le moteur
 * en acceptait n'importe lequel — un écran qui promet ce que le moteur ne fait
 * pas. Ce qui reste dehors, et pourquoi :
 *
 *   * `check` — la boucle de compréhension (é11 lot 4) est 100 % DÉTERMINISTE :
 *     question tirée du stock, correction en base, phrase d'escalade en i18n.
 *     Aucun appel de modèle, donc rien à payer (`tutor.server.ts` le dit sur
 *     place, à côté des trois fonctions concernées).
 *   * `exercise_gen` — le vocabulaire existe, le PRODUCTEUR non : les exercices
 *     ciblés d'é11 lot 5 passent par la Forge (`/forge?chapitre=`), et aucun
 *     appelant n'émet cette surface. Elle entrera ici le jour où quelqu'un
 *     l'émet, pas avant.
 *   * `verify` / `forge_solve` — internes ({@link AI_INTERNAL_FEATURES}).
 *
 * LES ÉTUDES 04 ET 30 N'ONT RIEN À OUVRIR ICI, et c'est leur propriété la plus
 * utile : le moteur adaptatif (« quelle erreur tu fais ») et le tuteur
 * déterministe (« ce que tu maîtrises, ce que tu es prêt à apprendre ») sont
 * vivants SANS clé d'IA. Aucune de leurs surfaces n'appelle un modèle.
 *
 * ⚠️ `digest_student` / `digest_parent` Y ENTRENT, avec une asymétrie à
 * connaître. Les bilans sont produits par un BATCH hebdomadaire
 * (`/api/cron/digest`), et `resolve_ai_access` retombe sur le chemin plateforme
 * pour toute surface non activée. Cocher fait donc payer la famille — ce que
 * l'arbitrage demande ; décocher ne les arrête pas, ça les remet à la charge de
 * la plateforme. Ce n'est pas propre aux bilans : c'est vrai de TOUTES les
 * entrées de cette liste. Ce qu'un parent règle ici, c'est « ma clé la
 * paie-t-elle », jamais « la surface est-elle allumée ». Un vrai interrupteur
 * d'extinction serait un autre mécanisme, et il n'existe pas encore.
 *
 * ⚠️ AJOUTER UNE ENTRÉE RESTE LA DERNIÈRE ÉTAPE DU LOT QUI LIVRE SON APPELANT,
 * jamais la première.
 */
export const AI_LIVE_FEATURES = [
  "explain",
  "reformulate",
  "chat",
  "forge",
  "digest_student",
  "digest_parent",
] as const satisfies readonly Exclude<AiFeature, (typeof AI_INTERNAL_FEATURES)[number]>[];

export type AiLiveFeature = (typeof AI_LIVE_FEATURES)[number];

/** Qui paie l'appel. Miroir du CHECK de `ai_usage_events.payer` (R-7). */
export const AI_PAYERS = ["family", "platform"] as const;
export type AiPayer = (typeof AI_PAYERS)[number];

/** Les deux implémentations d'adaptateur de la v1 (D-6). `fake` n'est pas un fournisseur : c'est le mode CI. */
export const AI_PROVIDERS = ["anthropic", "openai_compatible"] as const;
export type AiProviderId = (typeof AI_PROVIDERS)[number];

/**
 * Le palier demandé à l'adaptateur. `fast` et `rich` ne nomment pas un modèle :
 * ils nomment une INTENTION, que le crédential résout vers `model_fast` /
 * `model_rich`. C'est ce qui permet à une famille de brancher un modèle que nous
 * ne connaissons pas sans qu'une seule ligne de feature change (D-11).
 */
export const AI_TIERS = ["fast", "rich"] as const;
export type AiTier = (typeof AI_TIERS)[number];

// ---------------------------------------------------------------------------
// 2. Bornes de tokens — non négociables (R-10)
// ---------------------------------------------------------------------------

/**
 * Plafond de tokens de SORTIE par surface. Ni le parent, ni l'élève, ni le
 * modèle configuré ne les modifient : un contexte trop long est tronqué par la
 * règle de découpage, jamais élargi (R-10, é11 §3.11).
 *
 * `verify` est volontairement minuscule : l'appel de vérification doit prouver
 * que la clé répond, pas produire du texte (US-2 : ≤ 16 tokens de sortie).
 */
export const AI_MAX_TOKENS: Readonly<Record<AiFeature, number>> = {
  verify: 16,
  explain: 700,
  reformulate: 400,
  chat: 900,
  check: 400,
  forge: 4000,
  forge_solve: 300,
  exercise_gen: 2500,
  digest_student: 700,
  digest_parent: 900,
} as const;

// ---------------------------------------------------------------------------
// 3. Prix — table DATÉE (R-12)
// ---------------------------------------------------------------------------

/**
 * Date de relevé de la grille ci-dessous. Elle est affichée dans la console
 * parent à côté du montant : un montant estimé sans la date de sa grille est un
 * chiffre qu'on ne peut pas contredire.
 */
export const AI_MODEL_PRICES_AS_OF = "2026-08-22" as const;

/** Prix d'un modèle, en dollars par MILLION de tokens. */
export type AiModelPrice = {
  /** Tokens d'entrée facturés plein tarif. */
  readonly inputPerMTokUsd: number;
  /** Tokens de sortie. */
  readonly outputPerMTokUsd: number;
  /** Tokens d'entrée servis depuis le cache du fournisseur (≈ 0,1× l'entrée chez Anthropic). */
  readonly cachedInputPerMTokUsd: number;
};

/**
 * Grille des modèles connus, relevée le {@link AI_MODEL_PRICES_AS_OF}.
 *
 * ⚠️ Ce n'est PAS une liste d'autorisation : une famille peut brancher un modèle
 * absent d'ici (Q-4). Un modèle inconnu est facturé au tarif de repli
 * ({@link AI_UNKNOWN_MODEL_PRICE}), jamais à zéro — un prix inconnu ne doit pas
 * ouvrir une vanne (§3.7).
 *
 * MAIS LE REPLI N'EST PAS GRATUIT, ET C'EST POURQUOI CETTE GRILLE DOIT ÊTRE LARGE
 * -------------------------------------------------------------------------
 * `reserve_ai_spend` coupe sur l'ESTIMATION, avant l'appel (D-8). Un fournisseur
 * bon marché absent d'ici est donc estimé au tarif Opus et coupé bien avant son
 * plafond réel : DeepSeek V4-Flash à 0,22 $/Mtok estimé à 5 $/Mtok, c'est une
 * famille coupée après ~4 % de sa dépense. Le repli protège du dépassement ; il
 * ne remplace pas un tarif connu. Tout fournisseur qu'on NOMME dans
 * {@link AI_PROVIDER_PRESETS} doit avoir ses modèles ici.
 *
 * PALIERS DE TAILLE : ON RETIENT LA TRANCHE BASSE — l'inverse de DeepSeek
 * -------------------------------------------------------------------------
 * Plusieurs fournisseurs doublent leur tarif au-delà de 200 000 tokens d'entrée
 * (xAI, Gemini, Qwen). Contrairement aux créneaux HORAIRES de DeepSeek — que la
 * réservation ne peut pas connaître, d'où la tranche haute — un palier de TAILLE
 * est déterminé par la requête, et **aucune surface d'ici ne l'atteint** :
 * {@link AI_MAX_TOKENS} plafonne la sortie à 4 000 tokens et les entrées se
 * comptent en milliers. Retenir la tranche haute doublerait chaque estimation et
 * couperait le porteur à la moitié de son plafond pour un seuil qui ne se
 * déclenche jamais — la panne d'arena#811, prise par l'autre bout.
 */
export const AI_MODEL_PRICES: Readonly<Record<string, AiModelPrice>> = {
  // — Anthropic (grille API première partie) —
  "claude-opus-5": { inputPerMTokUsd: 5, outputPerMTokUsd: 25, cachedInputPerMTokUsd: 0.5 },
  "claude-opus-4-8": { inputPerMTokUsd: 5, outputPerMTokUsd: 25, cachedInputPerMTokUsd: 0.5 },
  "claude-sonnet-5": { inputPerMTokUsd: 3, outputPerMTokUsd: 15, cachedInputPerMTokUsd: 0.3 },
  "claude-sonnet-4-6": { inputPerMTokUsd: 3, outputPerMTokUsd: 15, cachedInputPerMTokUsd: 0.3 },
  "claude-haiku-4-5": { inputPerMTokUsd: 1, outputPerMTokUsd: 5, cachedInputPerMTokUsd: 0.1 },
  // — Compatibles OpenAI les plus courants chez les familles. La grille d'un
  //   tiers change sans nous prévenir : elle est ici pour ESTIMER, et l'écran le
  //   dit (R-12). La facture qui fait foi reste celle du fournisseur.
  "gpt-5-mini": { inputPerMTokUsd: 0.25, outputPerMTokUsd: 2, cachedInputPerMTokUsd: 0.03 },
  "gpt-5": { inputPerMTokUsd: 1.25, outputPerMTokUsd: 10, cachedInputPerMTokUsd: 0.13 },
  // — DeepSeek. Tarif HEURES PLEINES, délibérément : DeepSeek facture moitié
  //   prix hors des créneaux 01:00-04:00 et 06:00-10:00 UTC, et une grille
  //   statique ne sait pas quelle heure il est au moment de la RÉSERVATION.
  //   Prendre le haut des deux surestime d'un facteur 2 au pire ; prendre le bas
  //   livrerait la facture surprise que RISK-2 interdit.
  "deepseek-v4-flash": {
    inputPerMTokUsd: 0.44,
    outputPerMTokUsd: 1.32,
    cachedInputPerMTokUsd: 0.007,
  },
  "deepseek-v4-pro": {
    inputPerMTokUsd: 1.32,
    outputPerMTokUsd: 3.96,
    cachedInputPerMTokUsd: 0.022,
  },
  // — Moonshot (Kimi) —
  "kimi-k3": { inputPerMTokUsd: 3, outputPerMTokUsd: 15, cachedInputPerMTokUsd: 0.3 },
  // — xAI (Grok). `grok-4.6` était ABSENT au motif qu'aucun tarif par token
  //   n'était publié : `docs.x.ai/docs/models` en publie un, relevé le
  //   2026-08-26 — la note qui disait le contraire est morte avec ce relevé.
  //   C'est aussi le modèle qui a servi à mesurer le délai de la Forge (59 s sur
  //   un quiz de sept questions, cf. AI_TIMEOUT_MS) : il était mesuré et non
  //   tarifé, ce qui est l'ordre inverse du normal.
  //   Ces lignes n'ont PAS fait bouger {@link AI_MODEL_PRICES_AS_OF} : le reste
  //   de la grille n'a pas été re-relevé ce jour-là, et une date qui avancerait
  //   sans relevé serait un fait inventé. Annoncer la grille plus vieille
  //   qu'elle n'est se trompe du côté sûr — l'inverse pas.
  "grok-4": { inputPerMTokUsd: 3, outputPerMTokUsd: 15, cachedInputPerMTokUsd: 0.75 },
  "grok-4-fast": { inputPerMTokUsd: 0.2, outputPerMTokUsd: 0.5, cachedInputPerMTokUsd: 0.05 },
  "grok-4.6": { inputPerMTokUsd: 2, outputPerMTokUsd: 6, cachedInputPerMTokUsd: 0.5 },
  // — Google (Gemini), joignable par son endpoint compatible OpenAI. Relevé le
  //   2026-08-26 sur ai.google.dev/gemini-api/docs/pricing. Mêmes paliers de
  //   taille que xAI, même choix de la tranche basse (voir la note ci-dessus).
  //   Aucun préréglage ne NOMME encore Google : la grille sert ici l'estimation
  //   d'un porteur passé par « Autre », et la condition d'entrée du pot commun.
  "gemini-2.5-pro": { inputPerMTokUsd: 1.25, outputPerMTokUsd: 10, cachedInputPerMTokUsd: 0.125 },
  "gemini-2.5-flash": { inputPerMTokUsd: 0.3, outputPerMTokUsd: 2.5, cachedInputPerMTokUsd: 0.03 },
  // — Z.ai (GLM). `glm-5.3` est volontairement ABSENT : aucun tarif par token
  //   n'est publié à ce jour, et inventer un chiffre serait pire que le repli
  //   haut, qui au moins ne ment pas dans le sens dangereux.
  "glm-5.2": { inputPerMTokUsd: 1.4, outputPerMTokUsd: 4.4, cachedInputPerMTokUsd: 0.26 },
  "glm-4.5": { inputPerMTokUsd: 0.6, outputPerMTokUsd: 2.2, cachedInputPerMTokUsd: 0.06 },
  "glm-4.5-air": { inputPerMTokUsd: 0.2, outputPerMTokUsd: 1.1, cachedInputPerMTokUsd: 0.03 },
  // — Mistral, joignable par son endpoint compatible OpenAI. Relevé le
  //   2026-08-26 sur docs.mistral.ai/inference/pricing. Aucun palier de taille
  //   ici : un seul tarif par modèle, donc rien à arbitrer contrairement à xAI
  //   et Google.
  //
  //   ⚠️ LES IDENTIFIANTS SONT LES INSTANTANÉS DATÉS, PAS LES ALIAS `-latest`,
  //   pour la raison exacte que dit le ⚠️ d'{@link AI_CURATED_MODELS} : nos deux
  //   adaptateurs retiennent l'id que le fournisseur ÉCHO, et La Plateforme y
  //   résout l'alias. `mistral-large-latest` ne matcherait donc jamais — un
  //   no-op silencieux, le pire des défauts. Vérifiable a posteriori dans la
  //   colonne `model` d'`ai_usage_events` (R-13).
  //
  //   Ces lignes non plus n'ont pas fait bouger {@link AI_MODEL_PRICES_AS_OF}.
  "mistral-large-3-25-12": {
    inputPerMTokUsd: 0.5,
    outputPerMTokUsd: 1.5,
    cachedInputPerMTokUsd: 0.05,
  },
  "mistral-medium-3-5-26-04": {
    inputPerMTokUsd: 1.5,
    outputPerMTokUsd: 7.5,
    cachedInputPerMTokUsd: 0.15,
  },
  "mistral-small-4-0-26-03": {
    inputPerMTokUsd: 0.15,
    outputPerMTokUsd: 0.6,
    cachedInputPerMTokUsd: 0.015,
  },
  "ministral-3-14b-25-12": {
    inputPerMTokUsd: 0.2,
    outputPerMTokUsd: 0.2,
    cachedInputPerMTokUsd: 0.02,
  },
  "ministral-3-8b-25-12": {
    inputPerMTokUsd: 0.15,
    outputPerMTokUsd: 0.15,
    cachedInputPerMTokUsd: 0.015,
  },
  "ministral-3-3b-25-12": {
    inputPerMTokUsd: 0.1,
    outputPerMTokUsd: 0.1,
    cachedInputPerMTokUsd: 0.01,
  },
} as const;

/**
 * Tarif appliqué à un modèle absent de la grille : l'estimation la PLUS HAUTE
 * du parc connu, et non une moyenne. Se tromper vers le haut coupe trop tôt ;
 * se tromper vers le bas livre une facture surprise (RISK-2).
 */
export const AI_UNKNOWN_MODEL_PRICE: AiModelPrice = {
  inputPerMTokUsd: 5,
  outputPerMTokUsd: 25,
  cachedInputPerMTokUsd: 0.5,
} as const;

/**
 * Modèles CURÉS, proposés à la saisie et — c'est là que ça compte — **condition
 * d'entrée du cache mutualisé** (R-15.2). Une explication produite par un modèle
 * hors de cette liste est servie à son demandeur sans entrer dans le pot commun :
 * sans quoi la clé la moins chère du parc fixerait la qualité pour tous les
 * enfants.
 *
 * ⚠️ CETTE BARRIÈRE VAUT POUR LES DEUX PAYEURS, ET ELLE NE COÛTE PAS LA MÊME CHOSE
 * AUX DEUX. Elle est née pour les clés de FAMILLE, où le hors-liste retombe sur une
 * réserve PRIVÉE — l'explication est écrite, simplement pas partagée. Depuis #872
 * elle gouverne aussi le chemin PLATEFORME, où il n'y a pas de réserve privée où
 * retomber : le payeur plateforme n'a pas d'`owner_user_id`, donc une entrée
 * `shared = false` y serait morte à l'écriture (illisible par
 * `find_tutor_explanation`, et comptée au dénominateur de
 * `get_tutor_cache_stats`). Sur ce chemin, hors-liste veut donc dire **rien
 * d'écrit du tout**, et chaque explication est régénérée.
 *
 * Conséquence pratique, à peser au moment de choisir `AI_PLATFORM_PROVIDER` : un
 * modèle bon marché mais non curé peut coûter PLUS en agrégat qu'un modèle plus
 * cher et curé, et le panneau de cache de `/admin/ia` lira 0 % sans en dire la
 * raison. C'est écrit là où le choix se fait —
 * `docs/environment-variables.md` § « Mode IA » — et dans le rang 0 de `STATUS.md`.
 *
 * La liste est une PROPOSITION, jamais une contrainte : la saisie libre d'un id
 * reste ouverte (D-11 — c'est sa clé, son choix).
 *
 * ⚠️ Le prédicat qui DÉCIDE vit à un seul endroit : `isCuratedModel()`, dans
 * `src/features/tutor/tutor.server.ts`, qui explique aussi pourquoi il ignore le
 * fournisseur. Un jumeau strict a vécu ici — né le même soir (#807, 18 h 35),
 * trois heures et demie avant celui qui décide (#816, 22 h 07), et jamais
 * appelé : deux réponses possibles à la même question, dont une que personne
 * ne posait.
 *
 * ⚠️ CES CHAÎNES SONT CELLES QUE LE FOURNISSEUR RENVOIE, pas celles qu'on lui
 * envoie. Les deux adaptateurs retiennent l'id ÉCHO par la réponse
 * (`openai-compatible.server.ts`, `anthropic.server.ts` — « un service qui
 * substitue un modèle doit se voir dans la console qualité »). Conséquence
 * directe : un ALIAS (`…-latest`) ou un nom commercial n'a rien à faire ici. Il
 * ne matcherait jamais, et l'entrée serait un no-op SILENCIEUX — le pire des
 * défauts, puisqu'il laisse croire le modèle curé. Pour savoir ce qu'un
 * fournisseur écho réellement, lire la colonne `model` d'`ai_usage_events`
 * (R-13) : c'est cet id-là qui y est journalisé.
 *
 * ⚠️ Et tout modèle inscrit ici doit avoir un tarif dans {@link AI_MODEL_PRICES}
 * — un test le vérifie. Ce n'est pas une formalité : curer, c'est encourager, et
 * encourager vers le tarif de repli coupe le porteur à ~4 % de sa dépense.
 */
export const AI_CURATED_MODELS: Readonly<Record<AiProviderId, readonly string[]>> = {
  anthropic: ["claude-opus-5", "claude-sonnet-5", "claude-haiku-4-5"],
  openai_compatible: [
    "gpt-5",
    "gpt-5-mini",
    // Élargie le 2026-08-26 : la liste ne comptait que les deux modèles OpenAI,
    // ce qui revenait à dire qu'aucun fournisseur chinois ni xAI ne pouvait
    // alimenter le pot commun — alors que le produit les branche depuis #811.
    // Depuis #872 cette liste gouverne AUSSI le chemin plateforme.
    "deepseek-v4-pro",
    "deepseek-v4-flash",
    "kimi-k3",
    "grok-4.6",
    "gemini-2.5-pro",
    "gemini-2.5-flash",
    // Second tour de la même décision, 2026-08-26 : GLM et Mistral manquaient à
    // l'appel. `glm-5.2` était déjà tarifé et suggéré par son préréglage sans
    // pouvoir alimenter le pot — la seule famille du parc à être proposée et
    // exclue à la fois. Pour Mistral, la grille arrive avec cette liste.
    //
    // ⚠️ `glm-5.3` n'y est pas, et ne peut PAS y être : la règle du tarif
    // s'applique, et il n'en a toujours pas de relevé (voir la grille). Curer
    // sans tarifer couperait le porteur à ~4 % de sa dépense.
    "glm-5.2",
    "mistral-large-3-25-12",
    "mistral-medium-3-5-26-04",
    "mistral-small-4-0-26-03",
    "ministral-3-14b-25-12",
    "ministral-3-8b-25-12",
    "ministral-3-3b-25-12",
  ],
} as const;

/** Défauts proposés à la création d'un crédential, par fournisseur. */
export const AI_DEFAULT_MODELS: Readonly<
  Record<AiProviderId, { readonly fast: string; readonly rich: string }>
> = {
  anthropic: { fast: "claude-haiku-4-5", rich: "claude-sonnet-5" },
  openai_compatible: { fast: "gpt-5-mini", rich: "gpt-5" },
} as const;

// ---------------------------------------------------------------------------
// 3bis. Préréglages — NOMMER ce que le protocole accepte déjà
// ---------------------------------------------------------------------------

/**
 * POURQUOI CES PRÉRÉGLAGES EXISTENT
 * -------------------------------------------------------------------------
 * Le moteur accepte depuis le premier jour n'importe quelle adresse compatible
 * OpenAI (Q-4) et n'importe quel identifiant de modèle : DeepSeek, Kimi et GLM
 * étaient branchables sans qu'une ligne change. Mais l'écran n'affichait que
 * « Compatible OpenAI » et ne suggérait que des modèles OpenAI — un porteur y
 * lisait, à raison, que le produit ne connaissait que deux fournisseurs.
 *
 * Un préréglage ne restreint rien : il NOMME. « Autre » reste la porte ouverte
 * de Q-4, et l'adresse saisie passe les sept conditions de R-6 dans tous les cas.
 *
 * ⚠️ On ne nomme un fournisseur que si ses modèles ont un tarif dans
 * {@link AI_MODEL_PRICES} — sinon le préréglage inviterait le porteur vers une
 * estimation au tarif de repli, et la coupure tomberait bien avant son plafond.
 * Adresses relevées le {@link AI_MODEL_PRICES_AS_OF}.
 */
export type AiProviderPreset = {
  readonly id: string;
  /** Nom affiché. Ce n'est pas une traduction : c'est une marque. */
  readonly label: string;
  readonly provider: AiProviderId;
  /** `null` pour Anthropic (adresse fixe dans le SDK) et pour « Autre » (saisie libre). */
  readonly baseUrl: string | null;
  /** `true` ⇒ l'écran laisse l'adresse et les modèles entièrement à la saisie. */
  readonly freeform: boolean;
  readonly models: { readonly fast: string; readonly rich: string } | null;
  /**
   * Modèles PROPOSÉS à la saisie pour ce fournisseur, et base des suggestions
   * de R-19. À ne PAS confondre avec {@link AI_CURATED_MODELS}, qui est la
   * condition d'entrée du cache mutualisé (R-15.2) : y verser un modèle bon
   * marché laisserait la clé la moins chère du parc fixer la qualité servie à
   * tous les enfants. Deux notions, deux listes, volontairement.
   */
  readonly suggested: readonly string[];
};

export const AI_PROVIDER_PRESETS: readonly AiProviderPreset[] = [
  {
    id: "anthropic",
    label: "Anthropic (Claude)",
    provider: "anthropic",
    baseUrl: null,
    freeform: false,
    models: AI_DEFAULT_MODELS.anthropic,
    suggested: AI_CURATED_MODELS.anthropic,
  },
  {
    id: "openai",
    label: "OpenAI",
    provider: "openai_compatible",
    baseUrl: "https://api.openai.com/v1",
    freeform: false,
    models: { fast: "gpt-5-mini", rich: "gpt-5" },
    suggested: ["gpt-5", "gpt-5-mini"],
  },
  {
    id: "deepseek",
    label: "DeepSeek",
    provider: "openai_compatible",
    baseUrl: "https://api.deepseek.com",
    freeform: false,
    models: { fast: "deepseek-v4-flash", rich: "deepseek-v4-pro" },
    suggested: ["deepseek-v4-flash", "deepseek-v4-pro"],
  },
  {
    id: "moonshot",
    label: "Kimi (Moonshot)",
    provider: "openai_compatible",
    baseUrl: "https://api.moonshot.ai/v1",
    freeform: false,
    models: { fast: "kimi-k3", rich: "kimi-k3" },
    suggested: ["kimi-k3"],
  },
  {
    id: "zai",
    label: "GLM (Z.ai)",
    provider: "openai_compatible",
    baseUrl: "https://api.z.ai/api/openai/v1",
    freeform: false,
    models: { fast: "glm-4.5-air", rich: "glm-5.2" },
    suggested: ["glm-5.2", "glm-4.5", "glm-4.5-air"],
  },
  {
    // xAI. Nommé le 2026-08-26, en retard sur l'usage : `grok-4.6` était déjà
    // branché par la porte « Autre » — c'est LUI qui a servi à mesurer le délai
    // de la Forge (cf. AI_TIMEOUT_MS). Un fournisseur qu'on utilise pour
    // calibrer le produit et qu'on n'affiche pas est exactement l'écart que les
    // préréglages existent pour fermer.
    //
    // Les modèles proposés sont ceux dont le tarif est relevé ; `grok-4.6` reste
    // accessible à la saisie libre, sans être suggéré (D-11 + la règle ⚠️
    // ci-dessus : ne jamais pousser un porteur vers le tarif de repli).
    id: "xai",
    label: "Grok (xAI)",
    provider: "openai_compatible",
    baseUrl: "https://api.x.ai/v1",
    freeform: false,
    models: { fast: "grok-4-fast", rich: "grok-4" },
    suggested: ["grok-4", "grok-4-fast"],
  },
  {
    // La porte de Q-4, explicitement. Sans cette entrée, l'écran redeviendrait
    // une liste blanche déguisée — ce que l'arbitrage a précisément refusé.
    id: "custom",
    label: "Autre — adresse compatible OpenAI",
    provider: "openai_compatible",
    baseUrl: null,
    freeform: true,
    models: null,
    suggested: [],
  },
] as const;

/** Le préréglage d'un identifiant, ou `undefined` s'il n'existe plus. */
export function presetById(id: string): AiProviderPreset | undefined {
  return AI_PROVIDER_PRESETS.find((p) => p.id === id);
}

/**
 * Le préréglage correspondant à un crédential enregistré, déduit de son adresse.
 *
 * C'est ce qui permet à R-19 de suggérer les modèles du BON fournisseur : avant,
 * l'avis se déduisait du protocole, et conseillait `gpt-5` à un porteur DeepSeek
 * — un identifiant qui n'existe pas sur son endpoint.
 */
export function presetForCredential(
  provider: AiProviderId,
  baseUrl: string | null,
): AiProviderPreset | undefined {
  if (provider === "anthropic") return presetById("anthropic");
  if (!baseUrl) return undefined;
  const normalized = baseUrl.replace(/\/+$/, "").toLowerCase();
  return AI_PROVIDER_PRESETS.find(
    (p) => p.baseUrl !== null && p.baseUrl.replace(/\/+$/, "").toLowerCase() === normalized,
  );
}

// ---------------------------------------------------------------------------
// 3ter. La clé PLATEFORME — la même liberté que celle d'une famille (é11, A5)
// ---------------------------------------------------------------------------

/**
 * LES DEUX PAYEURS CHOISISSENT DANS LA MÊME LISTE
 * ---------------------------------------------------------------------------
 * Le chemin plateforme a longtemps été câblé sur Anthropic : la clé s'appelait
 * `ANTHROPIC_API_KEY`, le crédential naissait avec `provider: "anthropic"` et
 * les deux modèles étaient écrits en dur dans l'orchestrateur — donc HORS de ce
 * fichier, contre la règle qui ouvre le module. Une famille pouvait brancher
 * DeepSeek, Kimi, GLM ou Grok ; nous, non.
 *
 * L'asymétrie qui reste est la seule qui soit structurelle : la clé d'une
 * famille vit au coffre, la nôtre est une variable d'environnement — « nous ne
 * stockons pas notre propre clé dans la base que nous exploitons ». Le CHOIX du
 * fournisseur, lui, n'avait aucune raison de différer : c'est
 * {@link AI_PROVIDER_PRESETS}, la même liste, préréglages et porte « Autre »
 * comprises.
 *
 * Résolution : `src/shared/integrations/ai/provider.server.ts`.
 */
export const AI_PLATFORM_DEFAULT_PRESET_ID = "anthropic" as const;

/**
 * Pourquoi le chemin plateforme est éteint, quand il l'est.
 *
 * `no_key` n'est pas une panne : c'est l'état par défaut, et le produit y est
 * complet (R-1). Les quatre autres le sont — une clé a été posée et le chemin
 * reste fermé. Sans ce mot, une faute de frappe dans une adresse se lit
 * `AI_MODE_OFF` côté élève et RIEN côté exploitant ; elle se découvre à
 * l'absence d'appels, des jours plus tard.
 *
 * Le vocabulaire vit ici — donc isomorphe — parce que la console admin doit
 * pouvoir le lire sans importer un module serveur.
 */
export const AI_PLATFORM_ISSUES = [
  "no_key",
  "unknown_preset",
  "missing_base_url",
  "insecure_base_url",
  "missing_model",
] as const;

export type AiPlatformIssue = (typeof AI_PLATFORM_ISSUES)[number];

// ---------------------------------------------------------------------------
// 4. Argent — plafonds, alertes (R-11, Q-6)
// ---------------------------------------------------------------------------

/**
 * Plafonds par défaut, arbitrés le 2026-08-20 (Q-6, contre la recommandation de
 * l'architecte qui proposait 0,50 $/jour et 5 $/mois). Ils sont LARGES : c'est
 * assumé, et c'est précisément ce qui rend {@link AI_ANOMALY_FACTOR} obligatoire
 * — 80 % de 20 $ alerte après 16 $ dépensés, ce qui est trop tard.
 */
export const AI_DEFAULT_BUDGETS = { dailyUsd: 2, monthlyUsd: 20 } as const;

/** Bornes dures de saisie, miroir des CHECK de `ai_credentials` (§3.3). */
export const AI_BUDGET_LIMITS = {
  minDailyUsd: 0.01,
  maxDailyUsd: 50,
  minMonthlyUsd: 0.01,
  maxMonthlyUsd: 500,
} as const;

/**
 * Alerte d'ANOMALIE, indépendante des seuils de plafond (R-11) : une journée
 * dont la dépense dépasse `AI_ANOMALY_FACTOR` × la médiane des sept jours
 * précédents prévient le porteur le jour même. C'est elle qui attrape une
 * boucle, un abus ou un bug ; le plafond mensuel, lui, n'attrape que la
 * conséquence.
 */
export const AI_ANOMALY_FACTOR = 3 as const;

/** Plancher de l'alerte d'anomalie : en deçà, 3× la médiane n'est que du bruit. */
export const AI_ANOMALY_FLOOR_USD = 0.5 as const;

/** Seuils de plafond MENSUEL notifiés, une fois par seuil et par mois (jamais par appel). */
export const AI_BUDGET_ALERT_THRESHOLDS = [50, 80, 100] as const;

/** Les montants sont comptés en micro-dollars ENTIERS : pas de flottant dans un compteur d'argent. */
export const MICROS_PER_USD = 1_000_000 as const;

// ---------------------------------------------------------------------------
// 5. Énergie — la mécanique de jeu (é11 R-12), dont é29 ne change que le plafond
// ---------------------------------------------------------------------------

/** Énergie IA quotidienne par défaut d'un élève activé (é11 R-12). */
export const TUTOR_DAILY_ENERGY = 10 as const;

/**
 * Plafond DUR d'énergie quotidienne. Le parent peut monter le plafond de son
 * enfant jusqu'ici, jamais au-delà (R-9) : ce n'est pas un garde-fou de coût,
 * c'est un garde-fou pédagogique (é09 anti-farm). Il ne se règle pas.
 */
export const TUTOR_HARD_DAILY_CAP = 30 as const;

/**
 * Énergie regagnée en consommant UNE charge d'indice de l'inventaire (é11 R-12,
 * D-9). C'est l'économie existante des indices qui finance l'usage intensif : des
 * pièces gagnées en jouant, jamais de l'argent réel — le wording de la phase
 * gratuite reste tenable (D-14).
 *
 * Miroir SQL : la constante est répétée dans `recharge_tutor_energy()`, avec le
 * plafond dur, parce que la base doit pouvoir décider seule dans la transaction
 * qui décrémente l'inventaire.
 */
export const TUTOR_ENERGY_PER_HINT = 3 as const;

/**
 * Longueur maximale d'un message libre de l'élève (é11 R-5, §3.11).
 *
 * Ce n'est pas un confort de saisie : c'est une borne de SURFACE D'ATTAQUE. Le
 * champ libre est la seule entrée non fiable du système (RISK-4), et une
 * instruction d'injection tient rarement en trois cents caractères sans se
 * voir. Le bornage s'ajoute — il ne remplace pas — au bloc de données balisé,
 * à la hiérarchie posée par le prompt système et au validateur de sortie.
 */
export const TUTOR_FREE_TEXT_MAX = 300 as const;

/**
 * Nombre de messages transmis au modèle dans un fil (§3.4, §1.5).
 *
 * « Pas de mémoire conversationnelle longue : fils courts par sujet + résumé
 * roulant borné. » La borne est aussi appliquée EN BASE
 * (`tutor_thread_window`) — la même règle des deux côtés, parce qu'elle relève
 * de la vie privée autant que du coût.
 */
export const TUTOR_CHAT_WINDOW = 10 as const;

/**
 * Nombre de VOIX en 👎 qui retirent une explication du pot commun (é29 R-15.3,
 * « éviction sur signal »).
 *
 * DES VOIX, PAS DES CLICS. Le même élève peut se faire resservir la même entrée
 * — rouvrir le panneau de correction re-sert le registre déjà servi (é11 R-7) —
 * et cliquer 👎 deux fois. Compter ces deux-là évincerait sur l'avis d'un seul
 * enfant, et donnerait à un seul compte le pouvoir de vider le pot commun ; le
 * SQL compte donc des `user_id` DISTINCTS.
 *
 * Miroir SQL : `tutor_eviction_downvotes()`, parce que l'éviction se décide dans
 * la transaction qui enregistre le 👎 (é29 D-8 : la coupure est dans le chemin
 * de requête, jamais dans un cron qui la découvrirait le lendemain).
 */
export const TUTOR_EVICTION_DOWNVOTES = 2 as const;

/** Coût en énergie d'un appel, par surface. La Forge est l'action la plus chère du produit. */
export const AI_ENERGY_COST: Readonly<Record<AiFeature, number>> = {
  verify: 0, // geste du porteur de clé, hors énergie élève
  explain: 1,
  reformulate: 1,
  chat: 1,
  check: 1,
  forge: 3, // R-18
  forge_solve: 0, // inclus dans le coût du `forge` qui l'a déclenché
  exercise_gen: 2,
  digest_student: 0, // produit par un batch, pas par un geste d'élève
  digest_parent: 0,
} as const;

// ---------------------------------------------------------------------------
// 6. La Forge — bornes (R-18)
// ---------------------------------------------------------------------------

export const AI_FORGE_LIMITS = {
  /** Volumes proposés à l'élève. Jamais plus de 10 questions (R-18). */
  allowedSizes: [5, 8, 10] as const,
  /** Candidats générés = demandés + cette marge, pour absorber les rebuts. */
  candidateOverhead: 2,
  /** Quiz forgés par élève et par jour. */
  dailyQuizzesPerStudent: 3,
  /** Générations simultanées par élève (verrou). */
  concurrentPerStudent: 1,
  /** Durée de vie d'un quiz forgé (R-17). */
  expiryDays: 30,
  /** Options d'un QCM forgé — v1 : QCM 4 options, pas de types natifs. */
  optionsPerQuestion: 4,
} as const;

/**
 * Part des candidats re-résolus quand le porteur a COUPÉ la double résolution
 * (R-18bis.3). Ce n'est pas un demi-compromis : sans échantillon on perd le taux
 * de rebut, donc l'avertissement R-19 n'a plus de données et un mauvais modèle
 * devient indétectable.
 */
export const AI_VERIFY_SAMPLE_RATE = 0.2 as const;

/** Taux de rebut sur 7 jours au-delà duquel le modèle du porteur est nommé (R-19). */
export const AI_DISCARD_ADVICE_THRESHOLD = 0.5 as const;

// ---------------------------------------------------------------------------
// 7. Sortie réseau — les sept conditions de R-6 (Q-4 : l'adresse est libre)
// ---------------------------------------------------------------------------

/**
 * Les bornes chiffrées des sept conditions de sortie. Leur MISE EN ŒUVRE est
 * dans `src/shared/integrations/ai/egress.server.ts` — ici ne vivent que les
 * nombres, pour qu'un test puisse les citer sans importer du code serveur.
 */
export const AI_EGRESS_RULES = {
  /** 1. https, et rien d'autre. */
  protocol: "https:",
  /** 1. port 443, et rien d'autre. */
  port: 443,
  /** 5. aucune redirection suivie — un 302 vers l'adresse de métadonnées annulerait tout le reste. */
  maxRedirects: 0,
  /** 6. délai plafonné. */
  timeoutMs: 30_000,
  /** 6. taille de réponse plafonnée (2 Mio). */
  maxResponseBytes: 2 * 1024 * 1024,
  /** Retries : 429/5xx uniquement. JAMAIS sur 401/403 — une clé invalide le reste. */
  maxRetries: 2,
} as const;

/**
 * LE BUDGET DES SURFACES QUI RÉPONDENT DEVANT UN ÉLÈVE.
 * ---------------------------------------------------------------------------
 * Le 2026-08-25 avait tiré la bonne conclusion pour la seule Forge : un modèle à
 * raisonnement ne tient pas dans trente secondes. Le chat, l'explication, la
 * reformulation et le mini-contrôle sont restés sur le plafond commun — le même
 * mur, jamais déplacé. Mesuré le 2026-08-28 en prod sur `grok-4.6`, palier
 * `fast`, un tour de chat : **27,1 s jusqu'au premier octet**, pour 611 octets
 * de réponse. La médiane passait donc de justesse, et tout ce qui dépassait
 * tombait en `AI_PROVIDER_DOWN` — un appel sur deux dans le journal du porteur.
 *
 * POURQUOI SOIXANTE, ET POURQUOI C'EST UNE ATTENTE PLUS COURTE
 * ---------------------------------------------------------------------------
 * Le chiffre paraît doubler la patience ; il la RÉDUIT. Ces surfaces réessayaient
 * (`AI_MAX_RETRIES` = 2) et rejouaient le timeout lui-même : trois tentatives de
 * trente secondes plus les reculs, soit ≈ 92 s avant que l'enfant lise « il ne
 * répond pas » — et trois générations facturées par un fournisseur qui compte ce
 * qu'il a calculé, même quand nous raccrochons. Un timeout ne se rejouant plus
 * (cf. `openai-compatible.server.ts`), le pire cas devient UNE tentative de 60 s.
 * L'élève attend donc strictement moins qu'avant, et reçoit une réponse là où il
 * n'en recevait aucune.
 *
 * `verify` reste au plafond commun, à dessein : c'est le ping de 16 tokens qui
 * décide si une clé est utilisable, et il est le seul de la liste à n'avoir
 * jamais échoué sur la mesure.
 */
export const AI_STUDENT_TIMEOUT_MS = 60_000;

/**
 * Délai par SURFACE. Prime sur {@link AI_EGRESS_RULES}.timeoutMs, qui reste le
 * défaut de tout appel qui ne passe pas de surface.
 *
 * POURQUOI UNE SURFACE MÉRITE PLUS DE TEMPS QUE LES AUTRES
 * ---------------------------------------------------------------------------
 * La condition 6 de R-6 plafonne le délai pour qu'une adresse lente ne retienne
 * pas une fonction serverless indéfiniment. Elle protège l'HÉBERGEMENT, et
 * l'hébergement ne distingue pas les surfaces. Elles ne se ressemblent pourtant
 * pas : `chat` et `explain` répondent DEVANT un élève, où trente secondes sont
 * déjà une éternité ; `forge` est une commande qu'on passe et dont on attend le
 * résultat.
 *
 * Et surtout, les modèles à RAISONNEMENT consomment des milliers de tokens de
 * réflexion avant d'écrire un caractère. Mesuré le 2026-08-25 sur `grok-4.6` :
 * 59 s pour un quiz de sept questions, dont 2547 tokens de raisonnement. Sous
 * trente secondes, la Forge ne peut pas fonctionner — pas « fonctionne mal » :
 * ne peut pas.
 *
 * ⚠️ INVARIANT : chaque valeur doit rester STRICTEMENT INFÉRIEURE au
 * `maxDuration` de la fonction SSR (`scripts/build-vercel.mjs`). Sinon c'est la
 * plateforme qui tue le processus avant nous, et un 504 muet remplace l'erreur
 * typée que le porteur peut lire — c'est exactement la panne du 2026-08-25.
 */
export const AI_TIMEOUT_MS: Readonly<Record<AiFeature, number>> = {
  verify: AI_EGRESS_RULES.timeoutMs,
  explain: AI_STUDENT_TIMEOUT_MS,
  reformulate: AI_STUDENT_TIMEOUT_MS,
  chat: AI_STUDENT_TIMEOUT_MS,
  check: AI_STUDENT_TIMEOUT_MS,
  forge: 90_000,
  forge_solve: AI_EGRESS_RULES.timeoutMs,
  exercise_gen: AI_EGRESS_RULES.timeoutMs,
  digest_student: AI_EGRESS_RULES.timeoutMs,
  digest_parent: AI_EGRESS_RULES.timeoutMs,
} as const;

/**
 * LA PATIENCE DE LA FORGE DÉPEND DU NOMBRE DE CANDIDATS, pas de la surface.
 * ---------------------------------------------------------------------------
 * `AI_TIMEOUT_MS.forge` valait 90 s, calibré le 2026-08-25 sur la mesure
 * ci-dessus : 59 s pour **sept** candidats sur `grok-4.6`. Sept candidats, c'est
 * le plus PETIT quiz du produit (5 demandés + 2 de marge). L'écran, lui, propose
 * 5, 8 ou 10 questions et **arrive sur 8** — soit dix candidats, ~40 % de
 * production en plus. Le plafond était donc réglé pour le cas que personne ne
 * choisit par défaut, et la Forge tombait en `AI_PROVIDER_DOWN` sur son propre
 * réglage d'origine (signalé en usage le 2026-08-26 : « failed to save » après
 * l'attente, sur une clé dont la vérification venait pourtant de passer).
 *
 * Le barème : un coût fixe (connexion, prompt, premiers tokens de réflexion)
 * plus un coût par candidat. Il rend 90 s à sept candidats — exactement la
 * valeur mesurée, donc aucun quiz qui marchait hier ne se met à échouer — et
 * monte à 120 s pour dix, 140 s pour douze.
 *
 * ⚠️ MÊME INVARIANT que {@link AI_TIMEOUT_MS} : le résultat doit rester
 * STRICTEMENT INFÉRIEUR au `maxDuration` de la fonction SSR (300 s,
 * `scripts/build-vercel.mjs`), et il faut y laisser la place de la double
 * résolution qui SUIT la génération. D'où le plafond dur : au-delà, ce n'est
 * plus une génération lente, c'est un modèle qui ne convient pas à la Forge, et
 * l'écran doit le dire au lieu de faire attendre trois minutes pour rien.
 */
export const AI_FORGE_TIMEOUT = {
  /** Connexion, prompt, premiers tokens de raisonnement — indépendant du volume. */
  baseMs: 20_000,
  /** Par candidat demandé, marge comprise. */
  perCandidateMs: 10_000,
  /** Plafond dur : la double résolution doit tenir dans ce qui reste des 300 s. */
  capMs: 180_000,
} as const;

/** Le délai accordé à UNE génération de la Forge, pour `candidates` candidats. */
export function forgeTimeoutMs(candidates: number): number {
  const wanted = AI_FORGE_TIMEOUT.baseMs + AI_FORGE_TIMEOUT.perCandidateMs * candidates;
  return Math.min(wanted, AI_FORGE_TIMEOUT.capMs);
}

/**
 * Retries par SURFACE. Prime sur {@link AI_EGRESS_RULES}.maxRetries.
 *
 * `forge` est à ZÉRO, et ce n'est pas de la frilosité. Une génération qui a
 * échoué au bout de quatre-vingt-dix secondes a presque toujours échoué pour
 * une raison que le second essai ne change pas : un modèle trop lent le reste.
 * Rejouer coûterait quatre minutes et demie d'attente à l'élève ET trois
 * générations au fournisseur — qui facture ce qu'il a calculé, même quand nous
 * raccrochons avant la fin.
 *
 * `forge_solve` garde ses deux essais : trois cents tokens rejoués sont sans
 * commune mesure, et un candidat non vérifié est un candidat jeté (§3.6).
 */
export const AI_MAX_RETRIES: Readonly<Record<AiFeature, number>> = {
  verify: AI_EGRESS_RULES.maxRetries,
  explain: AI_EGRESS_RULES.maxRetries,
  reformulate: AI_EGRESS_RULES.maxRetries,
  chat: AI_EGRESS_RULES.maxRetries,
  check: AI_EGRESS_RULES.maxRetries,
  forge: 0,
  forge_solve: AI_EGRESS_RULES.maxRetries,
  exercise_gen: AI_EGRESS_RULES.maxRetries,
  digest_student: AI_EGRESS_RULES.maxRetries,
  digest_parent: AI_EGRESS_RULES.maxRetries,
} as const;

/**
 * Liste de REFUS (Q-4 : la liste blanche est écartée). Elle ne remplace aucune
 * des sept conditions de R-6 — elle s'y ajoute, pour un hôte signalé après coup.
 * Comparaison sur le nom d'hôte normalisé, sous-domaines compris.
 */
export const AI_HOST_DENYLIST: readonly string[] = [
  // L'adresse de métadonnées du cloud est déjà bloquée par la condition 3 (plage
  // lien-local) ; elle est répétée ici pour que le refus soit lisible dans un log
  // même si la résolution DNS échoue avant l'inspection d'IP.
  "metadata.google.internal",
] as const;

// ---------------------------------------------------------------------------
// 8. Consentement (R-20)
// ---------------------------------------------------------------------------

/**
 * Version du texte de consentement. Un changement de fournisseur OU de version
 * de ce texte redemande le consentement (R-20). Le format est daté pour qu'une
 * ligne `consent_version` en base se lise sans table de correspondance.
 */
export const AI_CONSENT_VERSION = "2026-08-22" as const;

/**
 * Rang (`grades.display_order`) à partir duquel la saisie d'une clé N'EXIGE PLUS
 * de confirmation qu'un adulte responsable est présent (R-2a).
 *
 * 13 = Baccalauréat, la 4ᵉ année secondaire tunisienne. L'étude dit « sous la
 * 4ᵉ année secondaire » : un compte de rang strictement inférieur doit confirmer.
 *
 * Un compte **sans niveau renseigné** — parcours libre, compte ancien, parent —
 * est traité comme MINEUR : c'est la consigne explicite du §7 (« dans ce cas,
 * traiter comme mineur »). Se tromper dans ce sens coûte une case à cocher ; se
 * tromper dans l'autre laisse un enfant engager de l'argent sans un mot.
 */
export const AI_ADULT_CONFIRM_GRADE_RANK = 13 as const;
