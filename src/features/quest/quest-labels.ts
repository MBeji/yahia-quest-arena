// Per-quest localized labels keyed by the EXERCISE's content language (ar/fr/en),
// which can differ from the UI locale (e.g. an Arabic subject viewed in a French
// UI). Kept out of the quest route to keep that file under the max-lines cap.

export type QuestContentLang = "ar" | "fr" | "en";

export type QuestLabels = {
  lockedTitle: string;
  lockedBody: string;
  takeQuiz: string;
  review: string;
  back: string;
  quizPassedBanner: string;
  quizFailedBanner: string;
  quizTooFast: string;
  quizRecorded: string;
  eliteLockedTitle: string;
};

export function buildQuestLabels(qlang: QuestContentLang): QuestLabels {
  return {
    lockedTitle: {
      ar: "🔒 التمرين مقفل",
      fr: "🔒 Exercice verrouillé",
      en: "🔒 Exercise locked",
    }[qlang],
    lockedBody: {
      ar: "عليك أوّلًا اجتياز اختبار فهم الدرس بنجاح للوصول إلى التمارين. عُد لمراجعة الدرس ثمّ أعِد المحاولة.",
      fr: "Tu dois d'abord réussir le quiz de compréhension du chapitre pour accéder aux exercices. Relis le cours, puis réessaie.",
      en: "You must first pass the chapter comprehension quiz to unlock the exercises. Review the lesson, then try again.",
    }[qlang],
    takeQuiz: {
      ar: "🧠 إجراء اختبار الفهم",
      fr: "🧠 Passer le quiz de compréhension",
      en: "🧠 Take the comprehension quiz",
    }[qlang],
    review: { ar: "📖 مراجعة الدرس", fr: "📖 Réviser le cours", en: "📖 Review the lesson" }[qlang],
    back: { ar: "العودة إلى المادة", fr: "Retour à la matière", en: "Back to subject" }[qlang],
    quizPassedBanner: {
      ar: "✅ تهانينا! لقد فهمت الدرس، وفُتحت لك التمارين.",
      fr: "✅ Bravo ! Tu as compris le cours, les exercices sont débloqués.",
      en: "✅ Well done! You understood the lesson — the exercises are unlocked.",
    }[qlang],
    quizFailedBanner: {
      ar: "❌ لم تبلغ 80% المطلوبة. عُد لقراءة الدرس جيّدًا ثمّ أعِد الاختبار.",
      fr: "❌ Tu n'as pas atteint les 80% requis. Relis bien le cours, puis refais le quiz.",
      en: "❌ You did not reach the required 80%. Re-read the lesson, then retake the quiz.",
    }[qlang],
    // Shown when a quiz reaches the score but was rushed (< 4s/question): the
    // chapter stays locked, mirroring the connected gate's anti-rush rule.
    quizTooFast: {
      ar: "⏱️ أجبت بسرعة كبيرة. خذ وقتك لقراءة كلّ سؤال، ثمّ أعِد المحاولة.",
      fr: "⏱️ Tu as répondu trop vite. Prends le temps de lire chaque question, puis réessaie.",
      en: "⏱️ You answered too fast. Take your time to read each question, then try again.",
    }[qlang],
    // Quiz answers are deliberately NOT corrected on screen — the student must
    // validate on their own. So the in-quiz message must not promise a correction.
    quizRecorded: {
      ar: "تم تسجيل إجابتك. ستظهر نتيجتك في نهاية الاختبار.",
      fr: "Réponse enregistrée. Ton résultat s'affichera à la fin du quiz.",
      en: "Answer recorded. Your result will appear at the end of the quiz.",
    }[qlang],
    eliteLockedTitle: {
      ar: "👑 تحدّي النخبة مقفل",
      fr: "👑 Défi élite verrouillé",
      en: "👑 Elite challenge locked",
    }[qlang],
  };
}
