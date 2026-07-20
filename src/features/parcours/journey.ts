/**
 * Pure journey/adventure-path helpers — no React, no Supabase, fully unit
 * tested. The routes feed these with data from existing server fns
 * (getDashboard / getSubject) and pass the results to presentational components,
 * so this feature never imports another feature.
 */
import { XP_PER_LEVEL } from "@/shared/constants/gamification";

/**
 * Visual state of a path node (étude 22, R-11).
 *
 * Il n'y a **pas** d'état `locked` : la carte ne verrouille plus rien. Le seul état non
 * cliquable est `premium-locked`, câblé mais dormant tant que la phase gratuite dure.
 */
export type NodeState = "done" | "current" | "next" | "open" | "premium-locked";

export type SubjectNode = {
  id: string;
  nameFr: string;
  colorToken: string;
  icon: string;
  isPremium: boolean;
  attempts: number;
  avg: number;
  /**
   * Progression officielle (R-16) : chapitres complétés / chapitres publiés, en pourcentage.
   * `null` quand la matière n'a aucun chapitre publié ou que la RPC n'a rien renvoyé — surtout
   * pas 0/0 = 100 %, qui allumerait `done` sur une matière vide.
   */
  progressionPct: number | null;
  state: NodeState;
};

export type XpProgress = {
  level: number;
  intoLevel: number;
  perLevel: number;
  toNext: number;
  pct: number;
  isMax: boolean;
};

/** Progress within the current level (200 XP/level curve). */
export function xpProgress(xp: number, level: number, maxLevel = 50): XpProgress {
  const safeXp = Math.max(0, Math.floor(xp || 0));
  const intoLevel = safeXp % XP_PER_LEVEL;
  const isMax = level >= maxLevel;
  return {
    level,
    intoLevel,
    perLevel: XP_PER_LEVEL,
    toNext: isMax ? 0 : XP_PER_LEVEL - intoLevel,
    pct: isMax ? 100 : Math.round((intoLevel / XP_PER_LEVEL) * 100),
    isMax,
  };
}

type SubjectLike = {
  id: string;
  name_fr: string;
  color_token: string;
  icon: string;
  is_premium?: boolean;
};

export type SubjectProgress = { total: number; completed: number };

export type BuildSubjectNodesOptions = {
  /** Progression par matière (R-16), telle que servie par `get_user_parcours_progress`. */
  progressBySubject?: Record<string, SubjectProgress>;
  /** Matière la plus récemment travaillée — porte l'état `current` (R-11). */
  lastActivitySubjectId?: string | null;
};

/**
 * Progression d'une matière (R-16) en pourcentage entier, ou `null` si elle n'est pas
 * calculable — aucune donnée, ou aucun chapitre publié. Ne jamais renvoyer 100 % pour 0/0.
 */
function progressionPctOf(progress: SubjectProgress | undefined): number | null {
  if (!progress || progress.total <= 0) return null;
  return Math.round((progress.completed / progress.total) * 100);
}

/**
 * World-map subject nodes (étude 22, R-11 et R-16).
 *
 * **La carte ne verrouille plus.** L'ancien flag séquentiel — une région restait `locked` tant
 * que la précédente n'avait pas ≥ 1 tentative — affichait un verrou qu'aucun refus serveur ne
 * soutenait : le hub matière, le catalogue et le serveur laissaient tous jouer ce même contenu.
 * Une carte qui ment détruit la confiance dans les vrais verrous (P2), donc l'état a disparu.
 *
 * États restants, dans l'ordre de priorité :
 *   - `premium-locked` — le seul non cliquable ; dormant en phase gratuite ;
 *   - `done` — progression R-16 à 100 % (et non plus « moyenne ≥ 80 % », qui déclarait une
 *     matière terminée sur trois exercices réussis) ;
 *   - `current` — la matière la plus récemment travaillée, une seule ;
 *   - `next` — la première matière du chemin sans aucune tentative (halo « recommandé ») ;
 *   - `open` — tout le reste.
 *
 * L'ordre reste **recommandé, jamais contraignant** (R-12) : tous les nœuds non-premium sont
 * cliquables quel que soit leur état.
 */
export function buildSubjectNodes(
  subjects: SubjectLike[],
  statsBySubject: Record<string, { count: number; avg: number }>,
  lockedSubjectIds: ReadonlySet<string> = new Set(),
  options: BuildSubjectNodesOptions = {},
): SubjectNode[] {
  const { progressBySubject = {}, lastActivitySubjectId = null } = options;

  // `next` ne désigne qu'UNE matière : la première du chemin encore jamais tentée.
  const nextSubjectId =
    subjects.find((s) => !lockedSubjectIds.has(s.id) && (statsBySubject[s.id]?.count ?? 0) === 0)
      ?.id ?? null;

  return subjects.map((s) => {
    const st = statsBySubject[s.id] ?? { count: 0, avg: 0 };
    const premium = s.is_premium ?? false;
    const progressionPct = progressionPctOf(progressBySubject[s.id]);

    let state: NodeState;
    if (lockedSubjectIds.has(s.id)) state = "premium-locked";
    else if (progressionPct === 100) state = "done";
    else if (s.id === lastActivitySubjectId) state = "current";
    else if (s.id === nextSubjectId) state = "next";
    else state = "open";

    return {
      id: s.id,
      nameFr: s.name_fr,
      colorToken: s.color_token,
      icon: s.icon,
      isPremium: premium,
      attempts: st.count,
      avg: Math.round(st.avg),
      progressionPct,
      state,
    };
  });
}

/** Alternating side for the winding layout (0-based index). */
export const nodeSide = (i: number): "left" | "right" => (i % 2 === 0 ? "left" : "right");
