// Centralized gameplay constants — single source of truth for all thresholds, timers, and rewards.

/** Minimum score percentage to pass an exercise */
export const PASS_THRESHOLD_PCT = 60;

/**
 * Minimum score percentage to pass a chapter's mandatory comprehension quiz.
 * Until a chapter's `mode='quiz'` exercise is passed at or above this score,
 * the chapter's practice/boss exercises stay locked (enforced server-side).
 */
export const QUIZ_PASS_THRESHOLD_PCT = 80;

/**
 * Minimum plausible seconds per question. An attempt completed faster than
 * (questions × this) is treated as "too fast to be real" — it earns no XP/coins
 * (server-enforced in submit_exercise_attempt) and does NOT satisfy the
 * comprehension-quiz gate. Mirrors the 4s/question used in the scoring RPC.
 */
export const MIN_SECONDS_PER_QUESTION = 4;

/** Minimum duration floor for speed calculation (prevents gaming via instant submit) */
export const MIN_DURATION_FLOOR_S = 15;

/** Badge: streak milestone */
export const STREAK_BADGE_THRESHOLD = 7;

/** XP per level (linear model) */
export const XP_PER_LEVEL = 200;

/** Spaced repetition intervals in milliseconds */
export const SPACED_REPETITION_INTERVALS_MS = [
  1 * 86_400_000, // 1 day
  3 * 86_400_000, // 3 days
  7 * 86_400_000, // 7 days
] as const;

/** Maximum difficulty level */
export const MAX_DIFFICULTY_LEVEL = 4;

/** Minimum difficulty level */
export const MIN_DIFFICULTY_LEVEL = 1;

/** Threshold to increase difficulty (recent average > this) */
export const DIFFICULTY_INCREASE_THRESHOLD = 75;

/** Threshold to decrease difficulty (recent average < this) */
export const DIFFICULTY_DECREASE_THRESHOLD = 40;

/** Number of recent attempts used for difficulty adaptation */
export const RECENT_ATTEMPTS_WINDOW = 10;

/** Leaderboard max entries */
export const LEADERBOARD_LIMIT = 50;

/**
 * Étude 22 R-23 (Q-1, arbitrée) — seuil à partir duquel l'onglet « Ma classe » devient
 * l'onglet PAR DÉFAUT du classement, silencieusement.
 *
 * Sous ce seuil la cohorte est trop maigre pour être motivante : arriver 2ᵉ sur 3 ne dit rien.
 * On reste alors sur « Global », et l'onglet classe montre son état d'invitation plutôt qu'un
 * podium famélique.
 */
export const GRADE_TAB_DEFAULT_MIN_RANKED = 10;

/** Dashboard recent attempts limit */
export const DASHBOARD_RECENT_LIMIT = 50;

/**
 * Étude 22 R-4 (Q-3, arbitrée) — fenêtre d'affichage de la bannière de rentrée : du 1ᵉʳ
 * septembre au 31 octobre inclus.
 *
 * Assez tôt pour accompagner la vraie rentrée, assez court pour que la bannière ne devienne pas
 * un meuble qu'on ne voit plus. La logique qui l'exploite vit dans `shared/lib/back-to-school`
 * (fenêtre, année scolaire, condition de proposition) — la promotion reste PROPOSÉE, jamais
 * imposée : il n'existe aucun batch de septembre (D-6).
 */
export const BACK_TO_SCHOOL_WINDOW = {
  startMonth: 9,
  startDay: 1,
  endMonth: 10,
  endDay: 31,
} as const;

// ---------------------------------------------------------------------------
// Boss mode — le chronomètre NOTE, il ne coupe jamais la parole.
//
// Jusqu'à ce lot, ce nombre armait un compte à rebours qui, à zéro, répondait à
// la place de l'élève (réponse fausse d'office) et passait à la question
// suivante : 20 s ne suffisent pas pour une question de boss, et se faire couper
// au milieu d'un raisonnement n'apprend rien. Le chronomètre est désormais
// OUVERT — il compte à l'endroit, sans plafond, et ne valide jamais rien seul.
//
// Ce qu'il pilote, ce sont les DÉGÂTS infligés au boss, donc la barre de HP que
// l'élève regarde pendant le combat et le rang affiché à la fin. Il ne touche
// NI la correction (une réponse juste reste juste, quel qu'ait été le temps) NI
// les XP : la prime de vitesse sur les XP a été retirée le 2026-06-04 par la
// migration anti-rush `20260604220000_harden_scoring_anti_rush.sql`, et ce lot
// ne la réintroduit pas.
// ---------------------------------------------------------------------------

/**
 * Boss mode: temps de RÉFÉRENCE par question, en secondes — plus une échéance.
 * Répondre en deçà porte un coup critique ; au-delà le coup s'atténue par
 * paliers, sans jamais tomber à zéro.
 */
export const BOSS_PAR_SECONDS_PER_QUESTION = 20;

/**
 * Part des dégâts d'une question selon le palier de rapidité. Aucun palier ne
 * vaut 0 : quel que soit le temps mis, une question répondue avance le combat —
 * c'est la garantie « on ne bloque pas l'élève », lue en dégâts.
 */
export const BOSS_SPEED_WEIGHTS = {
  /** ≤ 1× le temps de référence. */
  critical: 1,
  /** ≤ 2× le temps de référence. */
  fast: 0.75,
  /** au-delà. */
  steady: 0.5,
} as const;

/** Dégâts cumulés (sur 100) à partir desquels le combat vaut tel rang final. */
export const BOSS_RANK_MIN_DAMAGE = {
  critical: 90,
  fast: 65,
} as const;

// ---------------------------------------------------------------------------
// Dungeon access gate — the Dungeon requires real prior progress, and the
// number of daily runs scales with the player's level.
// NOTE: these thresholds are mirrored in SQL (get_dungeon_access /
// start_dungeon_run); keep both in sync.
// ---------------------------------------------------------------------------

/** Daily dungeon runs = min(level, this cap). Level 0 ⇒ 0 ⇒ no access. */
export const DUNGEON_MAX_RUNS_PER_DAY = 5;

/** Distinct subjects the player must have attempted to unlock the Dungeon. */
export const DUNGEON_REQUIRED_SUBJECTS = 2;

/** Distinct chapters the player must have attempted to unlock the Dungeon. */
export const DUNGEON_REQUIRED_CHAPTERS = 3;

/** Max dungeon runs allowed per day for a given level. */
export function dungeonRunsPerDay(level: number): number {
  return Math.max(0, Math.min(level, DUNGEON_MAX_RUNS_PER_DAY));
}

/** Cost in Coins to recover a lost streak */
export const STREAK_RECOVERY_COST = 15;

// ---------------------------------------------------------------------------
// Duels (étude 05 — duels temps réel & ligues). 1v1 on a frozen question set
// drawn from the two players' shared parcours. Duels are an ENGAGEMENT feature,
// open to ALL parcours (FREE + premium) — unlike the Dungeon (a premium perk) —
// so the matchmaking queue stays deep (Q-4 resolved: no entitlement gate).
// NOTE: these values are mirrored in SQL (match_duel / submit_duel_answer /
// finalize_duel); keep both in sync, same discipline as the Dungeon constants.
// ---------------------------------------------------------------------------

/** Number of questions in a duel set (frozen at matchmaking, identical for both). */
export const DUEL_QUESTION_COUNT = 5;

/** A duel with no result by this many hours after creation expires (async tolerance). */
export const DUEL_EXPIRY_HOURS = 24;

/** At most this many simultaneously-active duels per player (R-10). */
export const DUEL_MAX_ACTIVE = 3;

/**
 * At most this many REWARDED duels per player per day (anti-farm, R-7). Beyond
 * the cap a duel is still playable but grants 0 XP / 0 coins. Mirrors the
 * Dungeon daily-run cap so the two competitive loops stay balanced.
 */
export const DUEL_MAX_REWARDED_PER_DAY = 5;

/**
 * Duel reward tiers (Q-1 resolved). Anchored to the practice-exercise economy
 * (a full exercise ≈ 75 XP / 15 coins): a win is a touch below that, a loss is
 * a real participation reward (never negative — R-8), a draw sits between. A
 * forfeit win (opponent expired without finishing) pays the win tier.
 */
export const DUEL_REWARDS = {
  win: { xp: 60, coins: 12 },
  draw: { xp: 40, coins: 8 },
  loss: { xp: 20, coins: 4 },
} as const;

/**
 * Highest exercise difficulty included in a premium parcours' FREE PREVIEW.
 * In a premium parcours WITHOUT an entitlement, the chapter comprehension quiz
 * and difficulty-1 (⭐) missions are free; difficulty >= 2 requires unlocking the
 * parcours. The server gate (resolve_exercise_access RPC) is authoritative; this
 * mirrors the rule for the lock/preview affordances in the UI.
 */
export const FREE_PREVIEW_MAX_DIFFICULTY = 1;

// --- Recall mode (étude 17) — mirrors the SQL constants of the recall
// migrations; the server gates are authoritative, these drive the UI. ---

/**
 * XP multiplier for a successful recall session (R-5). Mirrors the `1.5`
 * factor in `submit_exercise_attempt`'s recall branch — playing without the
 * options is harder, so it pays more (same anti-farm gates apply).
 */
export const RECALL_XP_MULTIPLIER = 1.5;

/**
 * Minimum recall-eligible questions for a mission to offer the recall mode
 * (R-2). Below this the chip is never shown (US-6, no dead end). Mirrors the
 * `>= 3` eligibility check in `get_recall_availability` / the start gate.
 */
export const RECALL_MIN_QUESTIONS = 3;

/**
 * Classic score (%) that unlocks a mission's recall mode (R-3): a 100% classic
 * run (not rushed). Mirrors the `score_pct = 100` unlock check server-side.
 */
export const RECALL_UNLOCK_SCORE_PCT = 100;

/**
 * Client-side cap on a typed recall answer's length. Eligible target answers
 * are 1–60 chars by construction (R-2c), so 120 is generous; the wire bound
 * stays `MAX_CHOICE_LENGTH` (512). Purely a UI guard against runaway input.
 */
export const RECALL_MAX_ANSWER_LENGTH = 120;

// --- Révision du jour (étude 04, lot A1.1) ---

/**
 * Nombre maximum d'exercices dans la « Révision du jour » (R-4). La révision est un
 * SÉLECTEUR, pas une nouvelle économie : trois missions, c'est une séance qu'on finit —
 * au-delà, la recommandation devient une liste de corvées. `get_daily_plan` replafonne
 * côté serveur, cette constante n'est donc pas la garde, seulement la demande.
 */
export const DAILY_PLAN_MAX_ITEMS = 3;

// ---------------------------------------------------------------------------
// Examen blanc (étude 02) — la simulation du concours. Ces valeurs sont
// MIRRORÉES en SQL (`finish_mock_exam`, `get_mock_exam_percentile`) : la RPC est
// la garde, celles-ci pilotent l'affichage. Même discipline que les duels.
// ---------------------------------------------------------------------------

/**
 * Récompense d'une session CLASSÉE, au prorata du score. Ancrage sur l'économie
 * d'entraînement (un exercice complet ≈ 75 XP / 15 pièces) : un blanc vaut cinq
 * à six exercices, il est plus long, plus dur, et ne se joue qu'une fois. Une
 * session d'ENTRAÎNEMENT ne paie rien — sinon l'examen cesse d'être une mesure
 * pour devenir une ferme à XP, exactement le travers que l'étude 09 traque.
 * (Répond à la Q-1 de l'étude 02 par sa propre proposition, faute d'arbitrage
 * humain rendu ; chiffre fait pour être re-tranché sur la première lecture réelle.)
 */
export const EXAM_MAX_XP = 300;
export const EXAM_MAX_COINS = 60;

// Le seuil d'affichage du percentile (R-6 : 20 copies classées) n'est PAS
// mirroré ici volontairement — `get_mock_exam_percentile` le renvoie dans son
// payload (`minCandidates`), et l'écran affiche ce que le serveur dit. Un
// miroir de plus serait une valeur à garder synchrone pour rien.

/**
 * Cadence de la sauvegarde au fil de l'eau (R-8) : assez court pour qu'un onglet
 * fermé ne coûte presque rien, assez long pour rester loin de la limite de débit
 * serveur (120 appels/minute).
 */
export const EXAM_AUTOSAVE_INTERVAL_MS = 5000;
