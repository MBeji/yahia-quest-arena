import type { GuideTranslations } from "../guide.types";

export const enGuide: GuideTranslations = {
  guide: {
    sheetTitle: "How does it work?",
    sheetSubtitle: "This screen's user guide, in plain words.",
    onThisScreen: "The buttons on this screen",
    rule: {
      title: "The golden rule: in order",
      intro: "Each chapter is done in 3 steps. Each step opens the next one.",
      lesson: {
        title: "1. Read the lesson",
        text: "Read the lesson and its summary. They are always open: come back whenever you like.",
      },
      quiz: {
        title: "2. Check you understood",
        text: "Take the chapter's short quiz 🧠. It checks that you understood: aim for {pct}% correct answers, taking at least {sec} seconds per question.",
      },
      missions: {
        title: "3. Take on the missions",
        text: "Quiz passed: every mission in the chapter opens at once. Start with ⭐ (easy), then climb to ⭐⭐⭐ (boss).",
      },
    },
    stepper: {
      label: "The chapter's 3 steps",
      lesson: "Lesson",
      quiz: "Quiz",
      missions: "Missions",
      done: "done",
      current: "do this now",
      next: "next",
      locked: "closed for now",
    },
    locked: {
      title: "Why is this mission closed?",
      body: "Missions open once you have shown you understood the lesson. Read the lesson, then pass the comprehension quiz with {pct}%: every mission in this chapter will open.",
      aria: "Closed mission: {title}. Tap to find out why.",
      why: "Why?",
      readCourse: "Read the lesson",
      takeQuiz: "Take the quiz",
    },
    tips: {
      toggleLabel: "“?” help bubbles",
      toggleHint:
        "A small golden “?” appears next to important buttons. Tap it to find out what the button does.",
      aria: "Help: {label}",
      readCourse:
        "Always start here: the lesson explains everything with examples. It is always open.",
      quizRow:
        "This short quiz checks you understood the lesson. Pass it with {pct}% (at least {sec} seconds per question) and every mission in the chapter opens.",
      lessonQuizCta:
        "Finished reading? This button starts the comprehension quiz. Once you pass it, the missions open.",
      lessonPracticeCta:
        "The quiz is already passed: this button takes you straight to the missions to practise.",
      parentLink:
        "The code is in your child's account: gear ⚙️ › “All settings” › “My account” › “Alliance Code”. They copy it and give it to you.",
    },
    intro: {
      badge: "First visit",
      gotIt: "Got it",
      more: "See all the help",
    },
    footer: "Lost? The “Help” button at the top of the screen is always there.",
    screens: {
      dashboard: {
        title: "Your Heroes Hall",
        intro: "This is your home page. It tells you what to do now.",
        items: [
          {
            icon: "▶️",
            label: "The big “Continue” button",
            text: "It takes you straight to the next thing to do. When in doubt, tap it.",
          },
          {
            icon: "🎯",
            label: "Today's goal",
            text: "The ring fills up with the XP earned today. XP are points: you earn them by passing missions.",
          },
          {
            icon: "🔥",
            label: "The chips under your name",
            text: "Level, day streak, XP and coins. Tap a chip to find out what it means.",
          },
          {
            icon: "🧭",
            label: "The 4 navigation buttons",
            text: "Heroes Hall = home · Adventure = the map of your subjects · Discover = the whole programme · Arena = challenges against others.",
          },
        ],
      },
      parcours: {
        title: "The adventure map",
        intro: "All the subjects of your class, on one map.",
        items: [
          {
            icon: "📍",
            label: "The steps on the map",
            text: "Each step is a subject. “Suggested” shows where to start.",
          },
          {
            icon: "👆",
            label: "Tapping a subject",
            text: "It opens with its list of chapters. In each chapter: lesson, then quiz, then missions.",
          },
          {
            icon: "⭐",
            label: "Stars and seals",
            text: "You earn stars by passing missions. All the stars of a subject = a seal.",
          },
        ],
      },
      programme: {
        title: "Discover the programme",
        intro: "Every class and every subject. Everything is free.",
        items: [
          {
            icon: "🏫",
            label: "Pick a class",
            text: "Tap your class to see its subjects.",
          },
          {
            icon: "📚",
            label: "Pick a subject",
            text: "It opens with its chapters. Start with the first chapter and follow the order.",
          },
        ],
      },
      arena: {
        title: "The Arena",
        intro: "Challenges for fun, once your chapters are done.",
        items: [
          {
            icon: "🏰",
            label: "Dungeon",
            text: "Questions against the clock, floor after floor.",
          },
          {
            icon: "⚔️",
            label: "Duels",
            text: "Face another student on the same questions.",
          },
          {
            icon: "🏆",
            label: "Leaderboard",
            text: "Your place among students, based on your XP.",
          },
        ],
      },
      subject: {
        title: "A subject, chapter by chapter",
        intro: "Open a chapter, then follow its 3 steps in order.",
        items: [
          {
            icon: "📂",
            label: "“Chapter 1, 2, 3…”",
            text: "Tap a chapter's row to open or close it.",
          },
          {
            icon: "📖",
            label: "“Read the lesson”",
            text: "The first step. The lesson is always open.",
          },
          {
            icon: "🧠",
            label: "The chapter quiz",
            text: "The second step: it checks you understood and opens the missions.",
          },
          {
            icon: "🔒",
            label: "Missions with a padlock",
            text: "They are waiting for the quiz to be passed. Tap a closed mission to see what to do.",
          },
          {
            icon: "⭐",
            label: "The stars next to missions",
            text: "Difficulty: ⭐ easy, ⭐⭐ medium, ⭐⭐⭐ boss, ⭐⭐⭐⭐ challenge.",
          },
        ],
      },
      lesson: {
        title: "The lesson",
        intro: "Read calmly, then go to the quiz at the bottom of the page.",
        items: [
          {
            icon: "📖",
            label: "The lesson and the summary",
            text: "Read them in order. You can come back here whenever you like.",
          },
          {
            icon: "🔍",
            label: "Figures",
            text: "Tap a figure to enlarge it.",
          },
          {
            icon: "🧠",
            label: "The button at the bottom",
            text: "It starts the comprehension quiz. Once passed, it takes you to the missions.",
          },
          {
            icon: "↔️",
            label: "Previous / next chapter",
            text: "At the very bottom, to move from one chapter to another.",
          },
        ],
      },
      quest: {
        title: "A mission",
        intro: "One question at a time. Take your time.",
        items: [
          {
            icon: "👆",
            label: "Pick an answer",
            text: "Tap the answer you think is right, then validate.",
          },
          {
            icon: "⏱️",
            label: "Take your time",
            text: "Answer too fast and the mission does not count: a few seconds per question at least.",
          },
          {
            icon: "✅",
            label: "The result",
            text: "From 60% correct answers, the mission counts and you earn XP. You can redo it to beat your score.",
          },
        ],
      },
      parent: {
        title: "Follow your child",
        intro: "Three steps are enough to see what your child is doing.",
        items: [
          {
            icon: "1️⃣",
            label: "Ask your child for their code",
            text: "In their account: gear ⚙️ › “All settings” › “My account” › “Alliance Code”.",
          },
          {
            icon: "2️⃣",
            label: "“Link a student via Alliance Code”",
            text: "Type the code in the box, then tap the golden button.",
          },
          {
            icon: "3️⃣",
            label: "Read the report",
            text: "Every day: time spent, chapters worked on, successes and difficulties.",
          },
          {
            icon: "📤",
            label: "Share / Print",
            text: "Send the report by message or print it.",
          },
        ],
      },
      suivi: {
        title: "Tracking without an account",
        intro: "You don't need an account: your child's code is enough.",
        items: [
          {
            icon: "🔑",
            label: "Your child's code",
            text: "In their account: gear ⚙️ › “All settings” › “My account” › “Alliance Code”.",
          },
          {
            icon: "⌨️",
            label: "Type the code",
            text: "Paste it in the box and confirm: the report appears.",
          },
          {
            icon: "💾",
            label: "“Remember this code on this device”",
            text: "Tick it so you don't retype the code on every visit (avoid on a shared computer).",
          },
        ],
      },
      settings: {
        title: "Settings",
        intro: "Everything you can adjust, in one place.",
        items: [
          {
            icon: "🔑",
            label: "“Alliance Code”",
            text: "The code to give your parent so they can follow your progress. Tap “Copy”.",
          },
          {
            icon: "🎒",
            label: "Your class",
            text: "You can change class or track here.",
          },
          {
            icon: "⚙️",
            label: "The gear at the top",
            text: "Language, light or dark theme, sound, sign out.",
          },
        ],
      },
      general: {
        title: "Welcome to Na9ra Nal3ab",
        intro: "Learn by playing, at your own pace. Everything is free.",
        items: [
          {
            icon: "📚",
            label: "“Programme”",
            text: "Pick a class, then a subject to get started.",
          },
          {
            icon: "👨‍👩‍👧",
            label: "“Parent tracking”",
            text: "For parents: follow your child with their code, no account needed.",
          },
          {
            icon: "⚙️",
            label: "The gear at the top",
            text: "Language (French, English, Arabic), theme and sound.",
          },
        ],
      },
    },
  },
};
