import type { BadgeTranslations } from "../badge.types";

export const arBadges: BadgeTranslations = {
  badgeCollection: {
    families: {
      debut: "الخطوات الأولى",
      serie: "السلاسل",
      maitrise: "الإتقان",
      arene: "الحلبة",
      saison: "الموسم",
    },
    labels: {
      first_quest: { name: "أوّل مهمّة", condition: "إنهاء أوّل تمرين" },
      level_10: { name: "الرتبة 10", condition: "بلوغ المستوى 10" },
      streak_7: { name: "شعلة 7 أيّام", condition: "المواظبة 7 أيّام متتالية" },
      streak_30: { name: "الشعلة الأسطوريّة", condition: "المواظبة 30 يوما متتاليا" },
      perfect_score: { name: "نتيجة كاملة", condition: "الحصول على 100 % في تمرين" },
      speed_demon: {
        name: "عفريت السرعة",
        condition: "إنجاح تمرين في أقلّ من 60 ثانية",
      },
      math_blitz: {
        name: "برق الحساب",
        condition: "الحصول على 95 % أو أكثر في تمرين رياضيات",
      },
      math_master: {
        name: "سيّد الرياضيات",
        condition: "إنجاح 10 تمارين رياضيات بنسبة 80 % أو أكثر",
      },
      polyglot: {
        name: "متعدّد اللغات",
        condition: "إنجاح تمرين في ثلاث لغات محتوى مختلفة",
      },
      boss_slayer: { name: "قاهر الوحوش", condition: "اجتياز 10 طوابق من السرداب إجمالا" },
      collector: { name: "جامع الكنوز", condition: "امتلاك 5 أغراض مختلفة" },
      rich_kid: { name: "الوريث الثريّ", condition: "بلوغ 500 قطعة" },
      league_podium: {
        name: "منصّة الدوري",
        condition: "إنهاء أسبوع دوري في الذهب أو البلاتين أو الألماس",
      },
      event_rentree: {
        name: "العودة المدرسيّة 2026",
        condition: "إنجاز تحدّي العودة المدرسيّة خلال نافذته",
      },
      event_synthese: {
        name: "فروض التأليف",
        condition: "النجاح في 3 مهامّ بنسبة 90٪ خلال أسبوعَي فروض التأليف",
      },
      event_ramadan: {
        name: "رمضان 1448",
        condition: "إنجاز 3 مهامّ خلال أسبوعَي تحدّي رمضان",
      },
      event_revisions: {
        name: "مراجعات مايو",
        condition: "النجاح في 5 مهامّ بنسبة 90٪ خلال أسبوعَي مراجعات مايو",
      },
    },
    familyProgress: "{n}/{total}",
    locked: "لم يُفتح بعد",
    collectionProgress: "{n} من {total} شارة",
  },
};
