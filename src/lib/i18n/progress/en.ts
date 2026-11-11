import type { ProgressTranslations } from "../progress.types";

export const enProgress: ProgressTranslations = {
  progress: {
    chapterStars: {
      tier1: "foundation",
      tier2: "practice",
      tier3: "boss",
      tier4: "elite",
      gaugeLabel: "{star} of {total} stars",
      mastered: "Mastered ✓",
      masteredWithNew: "Mastered ✓ · ✨ {n} new",
      rungCount: "{done}/{total}",
      legend: "Earn star {star} by clearing every mission up to {tier}.",
      countedRule: "A mission counts from 60 % up, as long as you take your time.",
      none: "No stars yet",
    },
    newMissions: "✨ {n} new mission(s)",
    newChapter: "✨ New chapter",
    familyMissions: "Family missions {done}/{total}",
    familyMissionsHint: "They earn XP; stars stay tied to the school programme.",
    seal: {
      heading: "Subject seals",
      title: "Seal {stars}",
      none: "No seal yet",
      earnedOn: "earned on {date}",
      next: "Next seal {stars}: {ready}/{total} chapters ready",
      nextWithNew: "Next seal {stars}: {ready}/{total} chapters ready, {n} of them new",
      rule: "A seal lands when EVERY chapter of the subject holds the star.",
    },
    effort: {
      heading: "Your work here",
      missions: "{n} missions cleared",
      xp: "{n} XP",
      chaptersStarted: "{started} chapters started",
      chaptersMastered: "{mastered} mastered",
    },
    celebration: {
      starTitle: "Chapter star!",
      starTitlePlural: "{n} stars at once!",
      starBody: "You hold star {star} of this chapter. It is yours for good.",
      starMastered: "Chapter mastered: there is nothing left to do here.",
      sealTitle: "Seal {stars}",
      sealBody: "Every chapter of this subject holds the star. It is dated, and it never fades.",
      sealHint: "Tap to go back to your result.",
    },
    anonPromise: "Sign in to keep your stars.",
  },
};
