import type { BadgeTranslations } from "../badge.types";

export const enBadges: BadgeTranslations = {
  badgeCollection: {
    families: {
      debut: "First steps",
      serie: "Streaks",
      maitrise: "Mastery",
      arene: "Arena",
      saison: "Season",
    },
    labels: {
      first_quest: { name: "First Quest", condition: "Finish your first exercise" },
      level_10: { name: "Rank 10", condition: "Reach level 10" },
      streak_7: { name: "7-Day Flame", condition: "Keep a 7-day streak" },
      streak_30: { name: "Legendary Flame", condition: "Keep a 30-day streak" },
      perfect_score: { name: "Perfect Score", condition: "Score 100% on an exercise" },
      speed_demon: {
        name: "Speed Demon",
        condition: "Pass an exercise in under 60 seconds",
      },
      math_blitz: {
        name: "Number Lightning",
        condition: "Score 95% or more on a maths exercise",
      },
      math_master: {
        name: "Maths Master",
        condition: "Pass 10 maths exercises at 80% or more",
      },
      polyglot: {
        name: "Polyglot",
        condition: "Pass an exercise in three different content languages",
      },
      boss_slayer: { name: "Boss Slayer", condition: "Clear 10 dungeon floors in total" },
      collector: { name: "Collector", condition: "Own 5 different items" },
      rich_kid: { name: "Rich Heir", condition: "Reach 500 coins" },
      league_podium: {
        name: "League Podium",
        condition: "Finish a league week in gold, platinum or diamond",
      },
      event_rentree: {
        name: "Back to school 2026",
        condition: "Complete the back-to-school challenge during its window",
      },
    },
    familyProgress: "{n}/{total}",
    locked: "Locked",
    collectionProgress: "{n} of {total} badges",
  },
};
