// Per-lesson localized chrome labels keyed by the SUBJECT's content language
// (ar/fr/en), which can differ from the UI locale — the lesson chrome (summary,
// TOC, prev/next nav) reads in the language of the lesson itself, mirroring
// quest-labels.ts. These were previously hardcoded in Arabic (GAP-010 phase C).

export type LessonContentLang = "ar" | "fr" | "en";

export type LessonLabels = {
  comingSoonTitle: string;
  comingSoonBody: string;
  backToSubject: string;
  summaryBtn: string;
  summaryTitle: string;
  tocBtn: string;
  tocTitle: string;
  prev: string;
  next: string;
  allChapters: string;
  /** Contains a {subject} placeholder. */
  allChaptersOf: string;
  finishedAll: string;
  /** Primary CTA from the lesson to the chapter's quiz & exercises. */
  goToExercises: string;
  /** Localized word for "chapter" (الفصل / Chapitre / Chapter); rendered as
   *  the bold, centered "<chapterWord> N" marker that opens each lesson. */
  chapterWord: string;
};

export function buildLessonLabels(lang: LessonContentLang): LessonLabels {
  return {
    comingSoonTitle: {
      ar: "الدرس قادم قريباً",
      fr: "Leçon bientôt disponible",
      en: "Lesson coming soon",
    }[lang],
    comingSoonBody: {
      ar: "درس هذا الفصل قيد الإعداد من طرف العلماء.",
      fr: "La leçon de ce chapitre est en cours de préparation par les savants.",
      en: "This chapter's lesson is being prepared by the scholars.",
    }[lang],
    backToSubject: {
      ar: "العودة إلى المادة",
      fr: "Retour à la matière",
      en: "Back to subject",
    }[lang],
    summaryBtn: { ar: "ملخّص", fr: "Résumé", en: "Summary" }[lang],
    summaryTitle: { ar: "ملخّص الدرس", fr: "Résumé du cours", en: "Lesson summary" }[lang],
    tocBtn: { ar: "فهرس", fr: "Sommaire", en: "Contents" }[lang],
    tocTitle: { ar: "فهرس الدرس", fr: "Sommaire du cours", en: "Lesson contents" }[lang],
    prev: { ar: "السابق", fr: "Précédent", en: "Previous" }[lang],
    next: { ar: "التالي", fr: "Suivant", en: "Next" }[lang],
    allChapters: { ar: "كل الفصول", fr: "Tous les chapitres", en: "All chapters" }[lang],
    allChaptersOf: {
      ar: "جميع فصول {subject}",
      fr: "Tous les chapitres de {subject}",
      en: "All {subject} chapters",
    }[lang],
    finishedAll: {
      ar: "🏆 أنهيت كل الدروس!",
      fr: "🏆 Tu as terminé toutes les leçons !",
      en: "🏆 You finished every lesson!",
    }[lang],
    goToExercises: {
      ar: "🧠 إلى الاختبار والتمارين",
      fr: "🧠 Passer au quiz et aux exercices",
      en: "🧠 Go to the quiz & exercises",
    }[lang],
    chapterWord: { ar: "الفصل", fr: "Chapitre", en: "Chapter" }[lang],
  };
}
