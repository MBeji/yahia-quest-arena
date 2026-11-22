import type { StudyTranslations } from "../study.types";

export const arStudy: StudyTranslations = {
  study: {
    title: { student: "حصيلتي", parent: "الحصيلة وبرنامج العمل" },
    goal: {
      title: "هدف اليوم",
      progress: "{done} دق من {target}",
      reached: "تحقّق هدف اليوم 🎉",
      week: "آخر 7 أيام: {minutes} دق، {days} يوم عمل",
      choose: "الهدف اليومي",
      option: "{n} دق",
    },
    plan: {
      title: "برنامج اليوم",
      minutes: "≈ {n} دق",
      stepMinutes: "{n} دق",
      start: "ابدأ",
      seeReport: "عرض الحصيلة كاملة",
      doneTitle: "أُنجز اليوم",
      doneScore: "{score}%",
      emptyGoalReached: {
        student: "أنجزتَ وقت عملك اليوم. إلى الغد — أو واصل إن أحببت.",
        parent: "أُنجز وقت العمل اليوم.",
      },
      emptyUpToDate: {
        student: "أنجزتَ كلّ ما درسته في القسم. أشِّر على الفصول الجديدة لتواصل.",
        parent: "أُنجز كلّ ما دُرس في القسم. أشِّروا على الفصول الجديدة للمواصلة.",
      },
      kind: {
        retry: "للإعادة",
        quiz: "اختبار الفصل",
        start: "فصل دُرس في القسم",
        advance: "نتقدّم",
      },
    },
    levels: {
      title: "المستوى حسب المادّة",
      level: {
        "non-evalue": "لم يُقيَّم بعد",
        "a-renforcer": "يحتاج إلى دعم",
        "en-progres": "في تقدّم",
        solide: "متين",
      },
      recent: "{score} % نجاح في {n} مهمّة حديثة",
      noRecent: "المهامّ الحديثة غير كافية للحكم",
      seen: "{done} فصل مكتسب من {seen} دُرست في القسم",
      exam: "آخر اختبار: {mark}",
    },
    work: {
      title: "ما يجب العمل عليه",
      empty: "لا شيء معلَّق في الفصول المدروسة في القسم.",
      status: {
        "non-commence": "لم يُعمل عليه بعد",
        fragile: "هشّ",
        "en-cours": "جارٍ",
        acquis: "مكتسب",
        maitrise: "متقَن",
      },
      missing: "{n} خطوة قبل النجمة {star}",
    },
    classChapters: {
      title: { student: "فصولي المدروسة في القسم", parent: "الفصول المدروسة في القسم" },
      hint: {
        student: "أشِّر على ما درسته في القسم: برنامجك لن يقترح عليك غيره.",
        parent: "أشِّروا على ما دُرس في القسم: البرنامج لن يقترح غيره.",
      },
      estimated: "تقدير حسب الرزنامة المدرسيّة — يُصحَّح بلمسة.",
      declared: "{seen} فصل مؤشَّر عليه من {total}",
      through: "إلى هنا",
      error: "تعذّر الحفظ. أعد المحاولة.",
    },
    focus: {
      toggle: "اجعلها ذات أولويّة",
      active: "ذات أولويّة",
      hint: {
        student: "مادّتان ذواتا أولويّة على الأكثر: برنامجك يقدّمهما كلّ يوم، في البداية.",
        parent: "مادّتان ذواتا أولويّة على الأكثر: البرنامج يقدّمهما كلّ يوم، في البداية.",
      },
      error: "تعذّر الحفظ. أعد المحاولة.",
    },
    unavailable: "الحصيلة غير متاحة حاليًّا.",
  },
};
