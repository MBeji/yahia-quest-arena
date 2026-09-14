import type { ProgressTranslations } from "../progress.types";

/**
 * ⚠️ Chiffres OCCIDENTAUX (R-17) : le produit affiche « 3/4 », jamais « ٣/٤ ».
 * Les substitutions `{n}`, `{done}`, `{total}`, `{ready}` reçoivent donc des
 * nombres rendus par `String(n)`, et la phrase arabe est écrite pour les
 * accueillir tels quels.
 */
export const arProgress: ProgressTranslations = {
  progress: {
    chapterStars: {
      tier1: "الأساس",
      tier2: "التمرّن",
      tier3: "الوحش",
      tier4: "النخبة",
      gaugeLabel: "{star} نجمة من {total}",
      mastered: "متقَن ✓",
      masteredWithNew: "متقَن ✓ · ✨ {n} جديد",
      rungCount: "{done}/{total}",
      legend: "تنال النجمة {star} بإنجاح كلّ المهامّ إلى غاية {tier}.",
      countedRule: "تُحتسب المهمّة من 60 % فما فوق، شرط ألّا تستعجل.",
      none: "لا نجوم بعد",
    },
    newMissions: "✨ {n} مهمّة جديدة",
    newChapter: "✨ فصل جديد",
    familyMissions: "مهامّ العائلة {done}/{total}",
    familyMissionsHint: "تمنحك نقاط خبرة؛ أمّا النجوم فتبقى للبرنامج الدراسيّ.",
    seal: {
      heading: "أختام المادّة",
      title: "ختم {stars}",
      none: "لا ختم بعد",
      earnedOn: "نِلته في {date}",
      next: "الختم القادم {stars}: {ready}/{total} فصلا جاهزا",
      nextWithNew: "الختم القادم {stars}: {ready}/{total} فصلا جاهزا، منها {n} جديدة",
      rule: "يسقط الختم عندما تنال كلّ فصول المادّة النجمة.",
    },
    effort: {
      heading: "عملك هنا",
      missions: "{n} مهمّة ناجحة",
      xp: "{n} نقطة خبرة",
      chaptersStarted: "{started} فصلا بدأته",
      chaptersMastered: "{mastered} متقَنا",
    },
    celebration: {
      starTitle: "نجمة الفصل!",
      starTitlePlural: "{n} نجوم دفعة واحدة!",
      starBody: "نلت النجمة {star} في هذا الفصل. صارت لك إلى الأبد.",
      starMastered: "فصل متقَن: لم يبق فيه ما تفعله.",
      sealTitle: "ختم {stars}",
      sealBody: "كلّ فصول هذه المادّة نالت النجمة. الأمر مؤرّخ، ولا يُمحى.",
      sealHint: "المس للعودة إلى نتيجتك.",
    },
    anonPromise: "سجّل دخولك لتحتفظ بنجومك.",
  },
};
