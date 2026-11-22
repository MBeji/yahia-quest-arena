import type { StudyTranslations } from "../study.types";

export const enStudy: StudyTranslations = {
  study: {
    title: { student: "My report", parent: "Report and study plan" },
    goal: {
      title: "Today's goal",
      progress: "{done} min out of {target}",
      reached: "Today's goal reached 🎉",
      week: "Last 7 days: {minutes} min, {days} day(s) of work",
    },
    plan: {
      title: "Today's plan",
      minutes: "≈ {n} min",
      stepMinutes: "{n} min",
      start: "Start",
      seeReport: "See the full report",
      doneTitle: "Done today",
      doneScore: "{score}%",
      emptyGoalReached: {
        student:
          "You've done your study time for today. See you tomorrow — or keep going if you like.",
        parent: "Today's study time is done.",
      },
      emptyUpToDate: {
        student:
          "You're up to date with what you've covered in class. Tick your new chapters to go on.",
        parent: "Everything covered in class has been practised. Tick the new chapters to go on.",
      },
      kind: {
        retry: "Try again",
        quiz: "Chapter quiz",
        start: "Covered in class",
        advance: "Moving on",
      },
    },
    levels: {
      title: "Level by subject",
      level: {
        "non-evalue": "Not assessed yet",
        "a-renforcer": "Needs work",
        "en-progres": "Improving",
        solide: "Solid",
      },
      recent: "{score}% success over {n} recent mission(s)",
      noRecent: "Not enough recent missions to tell",
      seen: "{done} chapter(s) acquired out of {seen} covered in class",
      exam: "Latest mock paper: {mark}/20",
    },
    work: {
      title: "To work on",
      empty: "Nothing pending in the chapters covered in class.",
      status: {
        "non-commence": "Not practised yet",
        fragile: "Shaky",
        "en-cours": "In progress",
        acquis: "Acquired",
        maitrise: "Mastered",
      },
      missing: "{n} step(s) before star {star}",
    },
    classChapters: {
      title: { student: "My chapters covered in class", parent: "Chapters covered in class" },
      hint: {
        student: "Tick what you've already done in class: your plan will only suggest that.",
        parent: "Tick what has been done in class: the plan will only suggest that.",
      },
      estimated: "Estimated from the school calendar — fix it with one tap.",
      declared: "{seen} chapter(s) ticked out of {total}",
      through: "I'm up to here",
      error: "Could not save. Try again.",
    },
    unavailable: "The report is not available right now.",
  },
};
