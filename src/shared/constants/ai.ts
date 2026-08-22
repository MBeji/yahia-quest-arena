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
 * absent d'ici (Q-4). Un modèle inconnu est facturé au tarif de repli de son
 * fournisseur ({@link AI_UNKNOWN_MODEL_PRICE}), jamais à zéro — un prix inconnu
 * ne doit pas ouvrir une vanne (§3.7).
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
 * hors de cette liste est servie à son demandeur et reste privée à son payeur :
 * sans quoi la clé la moins chère du parc fixerait la qualité pour tous les
 * enfants.
 *
 * La liste est une PROPOSITION, jamais une contrainte : la saisie libre d'un id
 * reste ouverte (D-11 — c'est sa clé, son choix).
 */
export const AI_CURATED_MODELS: Readonly<Record<AiProviderId, readonly string[]>> = {
  anthropic: ["claude-opus-5", "claude-sonnet-5", "claude-haiku-4-5"],
  openai_compatible: ["gpt-5", "gpt-5-mini"],
} as const;

/** Défauts proposés à la création d'un crédential, par fournisseur. */
export const AI_DEFAULT_MODELS: Readonly<
  Record<AiProviderId, { readonly fast: string; readonly rich: string }>
> = {
  anthropic: { fast: "claude-haiku-4-5", rich: "claude-sonnet-5" },
  openai_compatible: { fast: "gpt-5-mini", rich: "gpt-5" },
} as const;

/** Un modèle est-il dans la liste curée de son fournisseur ? (R-15.2) */
export function isCuratedModel(provider: AiProviderId, model: string): boolean {
  return AI_CURATED_MODELS[provider].includes(model);
}

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
 * Sous ce niveau scolaire (rang du parcours dans les 13 niveaux tunisiens), la
 * saisie d'une clé exige une confirmation explicite qu'un adulte responsable est
 * présent (R-2a). 11 = 4ᵉ année secondaire ; un compte sans niveau renseigné est
 * traité comme mineur — c'est la consigne du §7 (« dans ce cas, traiter comme
 * mineur »).
 */
export const AI_ADULT_CONFIRM_GRADE_RANK = 11 as const;
