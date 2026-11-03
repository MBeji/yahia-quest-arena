import { fireEvent } from "@testing-library/react";

// Décors partagés des tests du hub de matière (`SubjectHub`), répartis en quatre
// fichiers pour rester sous le plafond `max-lines` : un seul fichier de 842 lignes
// avait fini à 740 lignes de code pour un plafond de 750. Le `vi.mock` du routeur
// reste dans CHAQUE fichier — Vitest le remonte en tête du fichier où il est écrit,
// il ne s'applique pas depuis un module importé.

export const subject = {
  name_fr: "Mathématiques",
  attribute: "Logique",
  description: "Le calcul et les nombres.",
  content_language: "fr",
};
export const chapters = [
  { id: "c1", title: "Les nombres", description: "Compter et comparer." },
  { id: "c2", title: "Les fractions", description: null },
];
export const exercises = [
  {
    id: "e1",
    chapter_id: "c1",
    mode: "quiz",
    title: "Quiz : les nombres",
    difficulty: 1,
    xp_reward: 10,
  },
  {
    id: "e2",
    chapter_id: "c1",
    mode: "normal",
    title: "Additionner",
    difficulty: 2,
    xp_reward: 20,
  },
  { id: "e3", chapter_id: "c2", mode: "normal", title: "Un demi", difficulty: 1, xp_reward: 15 },
];
export const parcours = { id: "ecole-3eme-base", name_fr: "3ème année de base" };

/**
 * Une charge `get_subject_progress` à la forme EXACTE de la RPC (étude 34) — la
 * même que celle dont pgTAP 101 vérifie la structure. Les décors parlent donc en
 * étoiles et en missions comptées, comme le produit, et non plus en « meilleurs
 * scores » que le hub re-seuillerait : c'est tout l'objet du lot.
 */
type ChapterSpec = {
  star?: number;
  starLive?: number;
  quizCleared?: boolean;
  quizGated?: boolean;
  isNew?: boolean;
  family?: { total: number; counted: number };
  rungs?: { difficulty: number; total: number; counted: number; new?: number }[];
};
type MissionSpec = {
  chapterId?: string;
  source?: string;
  counted?: boolean;
  bestClassic?: number | null;
  isNew?: boolean;
};
export function progressOf({
  chapters: chapterSpecs = {},
  missions: missionSpecs = {},
  seals = [],
  nextSeal = null,
  effort = {},
}: {
  chapters?: Record<string, ChapterSpec>;
  missions?: Record<string, MissionSpec>;
  seals?: { star: number; reachedAt: string }[];
  nextSeal?: {
    star: number;
    chaptersReady: number;
    chaptersTotal: number;
    newChapters: number;
  } | null;
  effort?: Partial<{
    missionsCounted: number;
    xp: number;
    chaptersStarted: number;
    chaptersMastered: number;
  }>;
}) {
  return {
    subjectId: "math",
    seals,
    nextSeal,
    effort: {
      missionsCounted: 0,
      xp: 0,
      chaptersStarted: 0,
      chaptersMastered: 0,
      ...effort,
    },
    chapters: Object.entries(chapterSpecs).map(([chapterId, c]) => ({
      chapterId,
      star: c.star ?? 0,
      starLive: c.starLive ?? c.star ?? 0,
      mastered: (c.star ?? 0) >= 4,
      isNew: c.isNew ?? false,
      newMissions: (c.rungs ?? []).reduce((n, r) => n + (r.new ?? 0), 0),
      quiz: { gated: c.quizGated ?? true, cleared: c.quizCleared ?? false },
      rungs: (c.rungs ?? []).map((r) => ({ ...r, new: r.new ?? 0 })),
      family: c.family ?? { total: 0, counted: 0 },
    })),
    missions: Object.entries(missionSpecs).map(([exerciseId, m]) => ({
      exerciseId,
      chapterId: m.chapterId ?? "c1",
      source: m.source ?? "admin",
      counted: m.counted ?? false,
      bestClassic: m.bestClassic ?? null,
      mastered: (m.bestClassic ?? 0) >= 100,
      isNew: m.isNew ?? false,
    })),
  };
}
/** Expand every collapsed chapter (idempotent — the default already opens one). */
export function expandAll(container: HTMLElement) {
  for (const btn of Array.from(container.querySelectorAll('button[aria-expanded="false"]'))) {
    fireEvent.click(btn);
  }
}
