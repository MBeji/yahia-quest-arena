/**
 * Le compteur de temps d'apprentissage — logique PURE (ni React, ni réseau).
 *
 * Le suivi parental « jour par jour » repose sur une mesure du temps qui doit
 * survivre à ce que font vraiment les enfants : ouvrir un cours et partir goûter,
 * laisser six onglets ouverts, verrouiller le téléphone au milieu d'un exercice.
 * Mesurer « fin de page moins début de page » donnerait des après-midis de trois
 * heures sur un chapitre lu en quatre minutes, et le tableau de bord mentirait au
 * parent — précisément ce que la demande veut éviter (temps passé ≠ apprentissage).
 *
 * D'où ce compteur : il n'accumule une tranche de temps que si, PENDANT cette
 * tranche, l'onglet était visible ET une interaction récente prouve que quelqu'un
 * est devant. Le reste ne compte pas.
 *
 * Tout est ici en fonctions pures pour que les cas limites (onglet gelé pendant
 * deux heures, machine en veille, horloge qui recule) soient testables sans DOM
 * et sans horloge : `advance` reçoit l'instant, il ne le lit jamais.
 *
 * Le serveur re-borne de toute façon (`record_learning_pulse` ne crédite jamais
 * plus que le temps réellement écoulé) : ce module optimise l'honnêteté de la
 * mesure, il n'en est pas le garant.
 */

/** Les types d'activité que le tableau de bord parental sait nommer. */
export type LearningSurface =
  "lesson" | "exercise" | "quiz" | "recall" | "dungeon" | "duel" | "browse";

/** Cadence du compteur interne — assez fin pour que l'inactivité soit détectée vite. */
export const PULSE_TICK_MS = 5_000;

/** Cadence d'envoi au serveur. Un pouls perdu (onglet tué) coûte au plus ça. */
export const PULSE_FLUSH_MS = 60_000;

/**
 * Sans clic, frappe, scroll ni toucher depuis ce délai, on cesse de compter.
 * 90 s laisse le temps de lire un paragraphe dense sans toucher à rien, tout en
 * coupant une page laissée ouverte.
 */
export const PULSE_IDLE_MS = 90_000;

/**
 * Plafond d'une tranche entre deux tics. Un onglet en arrière-plan voit ses
 * timers gelés : au réveil, le delta peut valoir des heures. On ne crédite jamais
 * plus que trois tics d'un coup.
 */
export const PULSE_MAX_TICK_MS = PULSE_TICK_MS * 3;

/** En dessous, on n'envoie rien (le serveur refuserait de toute façon). */
export const PULSE_MIN_SECONDS = 5;

/** Plafond serveur par pouls — miroir de `record_learning_pulse`. */
export const PULSE_MAX_SECONDS = 300;

export type PulseState = {
  /** Millisecondes d'activité réelle accumulées et pas encore envoyées. */
  activeMs: number;
  /** Instant du dernier tic — `null` tant qu'aucun tic n'a eu lieu. */
  lastTickAt: number | null;
};

export type PulseTick = {
  /** Instant du tic (ms epoch). */
  now: number;
  /** L'onglet est-il visible ? */
  visible: boolean;
  /** Instant de la dernière interaction utilisateur (ms epoch). */
  lastInteractionAt: number;
};

export function createPulseState(): PulseState {
  return { activeMs: 0, lastTickAt: null };
}

/**
 * Avance le compteur d'un tic. Retourne un NOUVEL état (jamais de mutation).
 *
 * La tranche écoulée n'est comptée que si l'onglet est visible et l'utilisateur
 * actif ; sinon seul `lastTickAt` avance, ce qui évite de créditer d'un coup, au
 * retour, tout le temps passé ailleurs.
 */
export function advancePulse(state: PulseState, tick: PulseTick): PulseState {
  if (state.lastTickAt === null) {
    return { activeMs: state.activeMs, lastTickAt: tick.now };
  }

  // Une horloge qui recule (correction NTP, changement d'heure système) donne un
  // delta négatif : on repart du tic courant sans rien créditer.
  const rawDelta = tick.now - state.lastTickAt;
  if (rawDelta <= 0) {
    return { activeMs: state.activeMs, lastTickAt: tick.now };
  }

  const delta = Math.min(rawDelta, PULSE_MAX_TICK_MS);
  const idle = tick.now - tick.lastInteractionAt > PULSE_IDLE_MS;
  const counts = tick.visible && !idle;

  return {
    activeMs: counts ? state.activeMs + delta : state.activeMs,
    lastTickAt: tick.now,
  };
}

/**
 * Extrait les secondes entières à envoyer et retire du compteur ce qui part.
 *
 * Le reliquat sub-seconde est conservé : sur une heure de lecture, le jeter à
 * chaque envoi coûterait plusieurs dizaines de secondes de temps réel.
 */
export function takePulseSeconds(state: PulseState): { seconds: number; next: PulseState } {
  const seconds = Math.min(Math.floor(state.activeMs / 1000), PULSE_MAX_SECONDS);

  if (seconds < PULSE_MIN_SECONDS) {
    return { seconds: 0, next: state };
  }

  return {
    seconds,
    next: { activeMs: state.activeMs - seconds * 1000, lastTickAt: state.lastTickAt },
  };
}

/**
 * Le pourcentage du contenu atteint par la lecture, à partir de la position de
 * défilement. Sert au « % du cours consulté » et, avec la durée, à distinguer un
 * cours réellement étudié d'une page seulement ouverte.
 *
 * Un contenu plus court que la fenêtre n'est pas « 0 % lu » : il est entièrement
 * visible, donc entièrement atteint.
 */
export function readingProgressPct(input: {
  /** Position du haut de la zone de contenu par rapport au haut du document. */
  contentTop: number;
  contentHeight: number;
  viewportHeight: number;
  scrollY: number;
}): number {
  const { contentTop, contentHeight, viewportHeight, scrollY } = input;

  if (!Number.isFinite(contentHeight) || contentHeight <= 0) return 0;
  if (contentHeight <= viewportHeight) return 100;

  const scrolled = scrollY + viewportHeight - contentTop;
  const pct = Math.round((scrolled / contentHeight) * 100);

  return Math.min(100, Math.max(0, pct));
}
