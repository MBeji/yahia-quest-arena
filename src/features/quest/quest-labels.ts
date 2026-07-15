// Per-quest localized labels keyed by the EXERCISE's content language (ar/fr/en),
// which can differ from the UI locale (e.g. an Arabic subject viewed in a French
// UI). Kept out of the quest route to keep that file under the max-lines cap.

export type QuestContentLang = "ar" | "fr" | "en";

/**
 * Recall mode (étude 17, R-12) — the "extra characters" bar shown under the
 * recall input. STATICALLY defined per content language, NEVER derived from the
 * expected answer (a per-answer bar would leak its letters — same anti-leak
 * posture as R-1). Arabic chips render in RTL order at the call site. English
 * needs no bar (its answers use plain ASCII); an empty palette hides it.
 */
export const RECALL_CHAR_BAR: Record<QuestContentLang, string[]> = {
  fr: ["à", "â", "ç", "é", "è", "ê", "ë", "î", "ï", "ô", "û", "ù", "œ"],
  ar: ["أ", "إ", "آ", "ء", "ؤ", "ئ", "ة", "ى"],
  en: [],
};

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
  numericPlaceholder: string;
  numericHint: string;
  numericInvalid: string;
  orderingHint: string;
  matchingHint: string;
  moveUp: string;
  moveDown: string;
  multiHint: string;
  unsupportedTitle: string;
  unsupportedBody: string;
  // Recall mode (étude 17) — driven by the CONTENT language (an Arabic mission
  // shows its recall banner/placeholder in Arabic even in a French UI).
  recallBanner: string;
  recallPlaceholder: string;
  recallHint: string;
  recallInsertChar: string;
  recallLockedTitle: string;
  recallLockedBody: string;
  recallNotEligibleTitle: string;
  recallNotEligibleBody: string;
  recallReplayQcm: string;
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
    // Native numeric entry (Tier B — B1). Math notation stays LTR/Western digits
    // in every language (project rule), hence the Western example in Arabic too.
    numericPlaceholder: {
      ar: "إجابتك (عدد)",
      fr: "Ta réponse (nombre)",
      en: "Your answer (number)",
    }[qlang],
    numericHint: {
      ar: "اكتب عددًا — مثال: 3.14 أو -5",
      fr: "Saisis un nombre — ex. 3,14 ou -5",
      en: "Type a number — e.g. 3.14 or -5",
    }[qlang],
    numericInvalid: {
      ar: "أدخل عددًا صحيحًا أو عشريًّا فقط.",
      fr: "Entre uniquement un nombre (entier ou décimal).",
      en: "Enter a number only (integer or decimal).",
    }[qlang],
    // Native drag-&-drop boards (Tier B — B2): ordering (arrange the steps) and
    // matching (align each right-hand item with its left-hand partner).
    orderingHint: {
      ar: "اسحب العناصر (أو استعمل الأسهم) لترتيبها في الترتيب الصحيح.",
      fr: "Fais glisser les éléments (ou utilise les flèches) pour les ranger dans le bon ordre.",
      en: "Drag the items (or use the arrows) to arrange them in the right order.",
    }[qlang],
    matchingHint: {
      ar: "أعد ترتيب العمود الثاني (سحب أو أسهم) حتى يقابل كلّ عنصر شريكه.",
      fr: "Réordonne la colonne de droite (glisser ou flèches) pour aligner chaque élément avec son partenaire.",
      en: "Reorder the second column (drag or arrows) so each item faces its partner.",
    }[qlang],
    moveUp: { ar: "تحريك لأعلى", fr: "Monter", en: "Move up" }[qlang],
    moveDown: { ar: "تحريك لأسفل", fr: "Descendre", en: "Move down" }[qlang],
    // Native multi-select (Tier B — B3): the explicit "select ALL" mention (US-3)
    // is the whole point — a checkbox list is fair only when this is unmistakable.
    multiHint: {
      ar: "⚠️ اختر كلّ الإجابات الصحيحة — قد يكون هناك أكثر من إجابة واحدة.",
      fr: "⚠️ Sélectionne TOUTES les bonnes réponses — il peut y en avoir plusieurs.",
      en: "⚠️ Select ALL the correct answers — there may be more than one.",
    }[qlang],
    // R-3 rollback posture: an item whose type this client can't render is shown
    // as cleanly unavailable (it scores as unanswered), never a crashed session.
    unsupportedTitle: {
      ar: "⚠️ سؤال غير متاح",
      fr: "⚠️ Question indisponible",
      en: "⚠️ Question unavailable",
    }[qlang],
    unsupportedBody: {
      ar: "هذا النوع من الأسئلة غير مدعوم في هذه النسخة. تقدّم إلى السؤال الموالي.",
      fr: "Ce type de question n'est pas encore pris en charge ici. Passe à la question suivante.",
      en: "This question type isn't supported here yet. Move on to the next question.",
    }[qlang],
    // Recall mode (étude 17). The header banner announces the stake before play
    // (no options, XP ×1,5); the input placeholder/hint frame the free-text
    // answer; the char-bar aria template names each inserted character; the two
    // lock screens mirror QuizLockScreen for the R-3 gates.
    recallBanner: {
      ar: "🧠 وضع الاسترجاع · بلا خيارات · نقاط الخبرة ×1.5",
      fr: "🧠 Mode Rappel · sans options · XP ×1,5",
      en: "🧠 Recall mode · no options · XP ×1.5",
    }[qlang],
    recallPlaceholder: {
      ar: "اكتب إجابتك",
      fr: "Tape ta réponse",
      en: "Type your answer",
    }[qlang],
    recallHint: {
      ar: "اكتب إجابتك ثمّ اضغط Enter للتحقّق.",
      fr: "Tape ta réponse, puis Entrée pour valider.",
      en: "Type your answer, then press Enter to validate.",
    }[qlang],
    // {char} is the character inserted by the tapped chip.
    recallInsertChar: {
      ar: "إدراج {char}",
      fr: "insérer {char}",
      en: "insert {char}",
    }[qlang],
    recallLockedTitle: {
      ar: "🔒 وضع الاسترجاع مقفل",
      fr: "🔒 Mode Rappel verrouillé",
      en: "🔒 Recall mode locked",
    }[qlang],
    recallLockedBody: {
      ar: "أنجِز هذه المهمّة أوّلًا بنسبة 100% في نمط الاختيار من متعدّد لفتح وضع الاسترجاع.",
      fr: "Réussis d'abord cette mission à 100 % en QCM pour débloquer le mode Rappel.",
      en: "First complete this mission at 100% in multiple-choice to unlock recall mode.",
    }[qlang],
    recallNotEligibleTitle: {
      ar: "الاسترجاع غير متاح",
      fr: "Rappel indisponible",
      en: "Recall unavailable",
    }[qlang],
    recallNotEligibleBody: {
      ar: "لا يمكن لعب هذه المهمّة في وضع الاسترجاع.",
      fr: "Cette mission ne peut pas être jouée en mode Rappel.",
      en: "This mission can't be played in recall mode.",
    }[qlang],
    recallReplayQcm: {
      ar: "أعِد لعب المهمّة في نمط الاختيار من متعدّد",
      fr: "Rejouer la mission en QCM",
      en: "Replay the mission in multiple-choice",
    }[qlang],
  };
}
