/**
 * Étude 09 lot 2 — le simulateur d'économie.
 *
 * Rejoue 8 semaines de trois personas sur les **constantes réelles** et vérifie
 * les garde-fous G-1…G-4 ratifiés par l'arbitrage A9 (2026-08-02).
 *
 * ⚠️ **Les seuils sont des HYPOTHÈSES DE DÉPART, pas des vérités mesurées.**
 * Aucune donnée réelle ne les a encore confrontés — la page Économie (lot 1) est
 * là pour ça. Si une assertion casse au premier run, **le seuil a probablement
 * tort avant l'économie** : on le corrige ici, on ne retouche pas
 * `gamification.ts` pour faire passer un test. C'est écrit dans l'étude, et c'est
 * répété ici parce que c'est ici que la tentation se présente.
 *
 * R-3 — les constantes sont IMPORTÉES, jamais recopiées : un simulateur qui copie
 * ses valeurs valide une économie fantôme.
 *
 * ⚠️ **Un écart assumé à R-3, et sa raison.** Les récompenses par difficulté
 * (d1→d4) ne SONT PAS des constantes du moteur : elles sont authorées exercice par
 * exercice dans le corpus, sous une table canonique qui vit dans la doc de contenu.
 * Il n'y a donc rien à importer pour elles. Plutôt que de les recopier en douce
 * (ce que R-3 interdit), elles sont une **entrée explicite et nommée** du
 * simulateur : `CANONICAL_XP_BY_DIFFICULTY`. Si le corpus s'écarte de la table,
 * c'est le corpus qui dérive, et c'est `content:qa` qui le voit — pas ce script.
 *
 * Déterministe : PRNG à graine fixe, aucun `Math.random`. Deux exécutions
 * successives rendent exactement la même chose, sinon un garde-fou qui passe un
 * jour et casse le lendemain ne prouve rien.
 *
 * Hors `verify` / `ci:verify` (D-4) : c'est un garde-fou d'ÉQUILIBRAGE, pas un
 * test de code. Il se lance à la main et par la règle R-4 (toute PR qui touche
 * `gamification.ts` joint sa sortie avant/après).
 */

import {
  MIN_SECONDS_PER_QUESTION,
  PASS_THRESHOLD_PCT,
  STREAK_RECOVERY_COST,
  XP_PER_LEVEL,
} from "../../src/shared/constants/gamification.ts";

/**
 * La table canonique des récompenses (d1→d4), entrée explicite — voir l'écart à
 * R-3 en tête de fichier.
 */
export const CANONICAL_XP_BY_DIFFICULTY = { 1: 50, 2: 75, 3: 120, 4: 300 };

/**
 * Les coins sont un FORFAIT par exercice (`exercises.reward_coins`), pas une
 * dérivée de l'XP — vérifié dans `submit_exercise_attempt`. Le rapport « ~1 coin
 * / 5 XP » est une convention d'écriture du corpus ; la table ci-dessous suit
 * cette convention pour les quatre difficultés, comme entrée explicite.
 *
 * ⚠️ Il n'existe AUCUNE règle de demi-coins dans le moteur : l'éligibilité est
 * binaire, et elle décide de l'XP ET des coins ensemble. La règle « moitié entre
 * 40 et 59 % » que citait l'étude n'a jamais été implémentée.
 */
export const CANONICAL_COINS_BY_DIFFICULTY = { 1: 10, 2: 15, 3: 24, 4: 60 };

/** Les trois personas de l'étude — jours actifs par semaine, exercices/jour, réussite. */
export const PERSONAS = {
  assidu: { daysPerWeek: 6, exercisesPerDay: 4, successPct: 85 },
  moyen: { daysPerWeek: 3, exercisesPerDay: 2, successPct: 70 },
  occasionnel: { daysPerWeek: 1, exercisesPerDay: 2, successPct: 60 },
};

export const WEEKS = 8;

/** PRNG déterministe (mulberry32) — la reproductibilité EST une exigence, pas un confort. */
export function makeRng(seed) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

/**
 * Une tentative, scorée exactement comme le fait `submit_exercise_attempt`.
 *
 * Les trois règles qui décident du gain, et rien d'autre :
 *  - sous {@link PASS_THRESHOLD_PCT}, aucun XP (l'échec ne paie pas) ;
 *  - précipité (< {@link MIN_SECONDS_PER_QUESTION} par question), aucun XP ;
 *  - re-tentative payée seulement si elle AMÉLIORE le meilleur score.
 */
export function scoreAttempt({ difficulty, scorePct, secondsPerQuestion, previousBestPct }) {
  const baseXp = CANONICAL_XP_BY_DIFFICULTY[difficulty] ?? 0;
  const tooFast = secondsPerQuestion < MIN_SECONDS_PER_QUESTION;
  const passed = scorePct >= PASS_THRESHOLD_PCT;
  const improved = previousBestPct === null || scorePct > previousBestPct;

  // Éligibilité BINAIRE, exactement comme le RPC : elle décide de l'XP et des
  // coins ensemble. Pas de demi-mesure, pas de lot de consolation.
  if (tooFast || !passed || !improved) return { xp: 0, coins: 0, tooFast, passed, improved };

  // L'XP est proportionnel au score ; les coins sont le forfait de l'exercice.
  const xp = Math.round(baseXp * (scorePct / 100));
  const coins = CANONICAL_COINS_BY_DIFFICULTY[difficulty] ?? 0;
  return { xp, coins, tooFast, passed, improved };
}

/** Le niveau atteint pour un cumul d'XP — la seule formule de progression. */
export const levelFor = (xp) => Math.floor(xp / XP_PER_LEVEL) + 1;

/**
 * Rejoue 8 semaines pour un persona. Rend une trace par semaine (lisible) et les
 * agrégats dont les garde-fous ont besoin.
 */
export function simulate(personaName, { seed = 42 } = {}) {
  const persona = PERSONAS[personaName];
  if (!persona) throw new Error(`Persona inconnu : ${personaName}`);
  const rng = makeRng(seed);

  let xpTotal = 0;
  let coinsEarned = 0;
  let daysActive = 0;
  let daysMissed = 0;
  let maxXpInADay = 0;
  let dayIndex = 0;
  let levelFiveDay = null;
  /** Meilleur score par « exercice », pour que l'anti-farm `improved` morde. */
  const bestByExercise = new Map();
  const weeks = [];

  for (let week = 0; week < WEEKS; week++) {
    let weekXp = 0;
    let weekCoins = 0;

    for (let dow = 0; dow < 7; dow++) {
      dayIndex++;
      const active = dow < persona.daysPerWeek;
      if (!active) {
        daysMissed++;
        continue;
      }
      daysActive++;

      let dayXp = 0;
      for (let i = 0; i < persona.exercisesPerDay; i++) {
        // Le persona rejoue un petit pool : c'est ce qui fait mordre `improved`
        // au fil des semaines, exactement comme un élève qui refait ses missions.
        const exercise = `ex-${Math.floor(rng() * 12)}`;
        const difficulty = 1 + Math.floor(rng() * 3);
        // Le score oscille autour du taux du persona (±10 pts), borné à [0, 100].
        const scorePct = Math.max(
          0,
          Math.min(100, Math.round(persona.successPct + (rng() * 20 - 10))),
        );
        const previousBestPct = bestByExercise.get(exercise) ?? null;
        const res = scoreAttempt({
          difficulty,
          scorePct,
          // Un élève ordinaire n'est pas précipité : l'anti-rush n'est pas ce que
          // ce persona teste (G-2 le teste par le plafond, pas par la vitesse).
          secondsPerQuestion: 10,
          previousBestPct,
        });
        if (res.improved) bestByExercise.set(exercise, Math.max(previousBestPct ?? 0, scorePct));
        dayXp += res.xp;
        weekCoins += res.coins;
      }

      weekXp += dayXp;
      maxXpInADay = Math.max(maxXpInADay, dayXp);
      const before = xpTotal;
      xpTotal += dayXp;
      if (levelFiveDay === null && before < 4 * XP_PER_LEVEL && xpTotal >= 4 * XP_PER_LEVEL) {
        // Niveau 5 = 4 paliers franchis = 800 XP. ⚠️ L'étude écrit « niveau 5
        // (1 000 XP) » : les deux ne collent pas avec XP_PER_LEVEL = 200, où
        // 1 000 XP est le niveau 6. On suit le NIVEAU, pas le nombre.
        levelFiveDay = dayIndex;
      }
    }

    coinsEarned += weekCoins;
    weeks.push({
      week: week + 1,
      xpTotal,
      level: levelFor(xpTotal),
      coinsEarned,
      weekXp,
    });
  }

  return {
    persona: personaName,
    weeks,
    xpTotal,
    level: levelFor(xpTotal),
    coinsEarned,
    daysActive,
    daysMissed,
    maxXpInADay,
    levelFiveDay,
    /** Combien de jours manqués un shield pourrait couvrir, au prix courant. */
    shieldCoverableDays: Math.floor(coinsEarned / STREAK_RECOVERY_COST),
  };
}
