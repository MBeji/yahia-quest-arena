/**
 * Pure journey/adventure-path helpers — no React, no Supabase, fully unit
 * tested. The routes feed these with data from existing server fns
 * (getDashboard / getSubject) and pass the results to presentational components,
 * so this feature never imports another feature.
 */
import { XP_PER_LEVEL } from "@/shared/constants/gamification";

/** Visual state of a path node. */
export type NodeState = "done" | "current" | "open" | "locked" | "premium-locked";

export type SubjectNode = {
  id: string;
  nameFr: string;
  colorToken: string;
  icon: string;
  isPremium: boolean;
  attempts: number;
  avg: number;
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

/**
 * World-map subject nodes. A region unlocks once the previous (non-premium)
 * region has been started; premium regions whose parcours the caller has not
 * unlocked are surfaced as "premium-locked" (the set is computed by the caller
 * from the parcours entitlement). The mastery (>=80% avg) ones show as "done".
 */
export function buildSubjectNodes(
  subjects: SubjectLike[],
  statsBySubject: Record<string, { count: number; avg: number }>,
  lockedSubjectIds: ReadonlySet<string> = new Set(),
): SubjectNode[] {
  let unlocked = true;
  return subjects.map((s) => {
    const st = statsBySubject[s.id] ?? { count: 0, avg: 0 };
    const started = st.count > 0;
    const premium = s.is_premium ?? false;

    let state: NodeState;
    if (lockedSubjectIds.has(s.id)) state = "premium-locked";
    else if (!unlocked) state = "locked";
    else if (started && st.avg >= 80) state = "done";
    else if (started) state = "current";
    else state = "open";

    // The next core region unlocks once this core region is started.
    if (!premium) unlocked = unlocked && started;

    return {
      id: s.id,
      nameFr: s.name_fr,
      colorToken: s.color_token,
      icon: s.icon,
      isPremium: premium,
      attempts: st.count,
      avg: Math.round(st.avg),
      state,
    };
  });
}

/** Alternating side for the winding layout (0-based index). */
export const nodeSide = (i: number): "left" | "right" => (i % 2 === 0 ? "left" : "right");
