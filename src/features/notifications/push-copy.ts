import type { Locale } from "@/lib/i18n";

/**
 * Étude 31 lot 4 — LES TEXTES DE NOTIFICATION, dans les trois langues (R-17).
 *
 * Avant ce lot, les trois payloads étaient du FRANÇAIS EN DUR, envoyé à tout le
 * monde : un élève qui lit l'application en arabe recevait ses rappels en
 * français. Ce n'était pas un oubli d'auteur — la locale n'existait nulle part
 * côté serveur (elle vivait dans un cookie). `profiles.locale` la porte
 * désormais, et ce dictionnaire en tire le texte.
 *
 * **Le type est le garde-fou** : `Record<PushTag, Record<Locale, …>>`. Ajouter un
 * tag sans ses trois langues ne compile pas — c'est la leçon d'`auth-refusals.ts`
 * (deux listes tenues à la main ont divergé deux fois), appliquée au canal qui a
 * déjà divergé une fois.
 *
 * **Le ton est celui d'El Ostedh** (R-4/R-8) : jamais culpabilisant. On ne dit
 * pas « tu as échoué » ni « tu as abandonné » ; on dit « ta série t'attend » et
 * « reprends où tu en étais ». Un rappel qui fait honte se coupe — et il se coupe
 * définitivement.
 */

/** Les six moments d'élève, dans l'ORDRE DE PRIORITÉ du pipeline (R-16). */
export const PUSH_PRIORITY = [
  "league-result",
  "streak-lost",
  "streak-at-risk",
  "streak-milestone",
  "tutor-daily-plan",
  "comeback",
] as const;

export type PushTag = (typeof PUSH_PRIORITY)[number];

/** Le bilan famille vise les PARENTS : il ne concourt pas avec les six ci-dessus. */
export const PARENT_DIGEST_TAG = "weekly-family-report";

/** `{n}` = le nombre interpolé (révisions, jours de série, pièces). */
type Copy = { title: string; body: string; url: string };

export const PUSH_COPY: Record<PushTag, Record<Locale, Copy>> = {
  "league-result": {
    fr: {
      title: "🏆 Le résultat de ta ligue est là",
      body: "Ta semaine est comptée : viens voir ton rang et ce que tu as gagné.",
      url: "/duel",
    },
    en: {
      title: "🏆 Your league result is in",
      body: "Your week has been counted — come and see your rank and what you won.",
      url: "/duel",
    },
    ar: {
      title: "🏆 نتيجة دوريّك جاهزة",
      body: "تمّ احتساب أسبوعك: تعال لترى ترتيبك وما ربحته.",
      url: "/duel",
    },
  },
  "streak-lost": {
    fr: {
      title: "🔥 Ta série t'attend",
      body: "Elle s'est arrêtée à {n} jours. Une quête aujourd'hui et tu repars.",
      url: "/dashboard",
    },
    en: {
      title: "🔥 Your streak is waiting",
      body: "It stopped at {n} days. One quest today and you're off again.",
      url: "/dashboard",
    },
    ar: {
      title: "🔥 سلسلتك تنتظرك",
      body: "توقّفت عند {n} أيّام. مهمّة واحدة اليوم وتنطلق من جديد.",
      url: "/dashboard",
    },
  },
  "streak-at-risk": {
    fr: {
      title: "🔥 Ta série tient encore aujourd'hui",
      body: "Une quête avant ce soir et tes {n} jours continuent.",
      url: "/dashboard",
    },
    en: {
      title: "🔥 Your streak still holds today",
      body: "One quest before tonight and your {n} days carry on.",
      url: "/dashboard",
    },
    ar: {
      title: "🔥 سلسلتك ما زالت قائمة اليوم",
      body: "مهمّة واحدة قبل المساء وتتواصل أيّامك الـ{n}.",
      url: "/dashboard",
    },
  },
  "streak-milestone": {
    fr: {
      title: "✨ {n} jours d'affilée",
      body: "C'est une belle régularité. Continue comme ça.",
      url: "/dashboard",
    },
    en: {
      title: "✨ {n} days in a row",
      body: "That is real consistency. Keep it up.",
      url: "/dashboard",
    },
    ar: {
      title: "✨ {n} يوما متتاليا",
      body: "هذه مواظبة حقيقيّة. واصل على هذا النحو.",
      url: "/dashboard",
    },
  },
  "tutor-daily-plan": {
    fr: {
      title: "🎓 El Ostedh a préparé ton plan",
      body: "{n} révisions t'attendent aujourd'hui. On commence par la plus utile ?",
      url: "/dashboard",
    },
    en: {
      title: "🎓 El Ostedh has your plan ready",
      body: "{n} reviews are waiting today. Shall we start with the most useful one?",
      url: "/dashboard",
    },
    ar: {
      title: "🎓 أعدّ الأستاذ خطّتك",
      body: "{n} مراجعات تنتظرك اليوم. نبدأ بأنفعها؟",
      url: "/dashboard",
    },
  },
  comeback: {
    fr: {
      title: "👋 Reprends où tu en étais",
      body: "Ta progression est intacte, et une quête courte suffit pour repartir.",
      url: "/dashboard",
    },
    en: {
      title: "👋 Pick up where you left off",
      body: "Your progress is untouched, and one short quest is enough to restart.",
      url: "/dashboard",
    },
    ar: {
      title: "👋 واصل من حيث توقّفت",
      body: "تقدّمك سليم كما تركته، ومهمّة قصيرة تكفي للانطلاق.",
      url: "/dashboard",
    },
  },
};

/**
 * Le texte du plan du jour dit « une seule révision » au singulier — un rappel
 * qui compte juste se lit comme un service, un rappel qui compte faux se lit
 * comme une machine.
 */
const SINGULAR_PLAN: Record<Locale, string> = {
  fr: "Une seule révision t'attend aujourd'hui — cinq minutes et c'est réglé.",
  en: "Just one review is waiting today — five minutes and it's done.",
  ar: "مراجعة واحدة فقط تنتظرك اليوم — خمس دقائق وتنتهي.",
};

export const PARENT_DIGEST_COPY: Record<Locale, Copy> = {
  fr: {
    title: "📋 Le bilan famille de la semaine est prêt",
    body: "Points forts, chapitres à revoir et le conseil de la semaine : ouvrez le suivi de votre enfant.",
    url: "/parent-report",
  },
  en: {
    title: "📋 This week's family report is ready",
    body: "Strengths, chapters to revisit and the tip of the week: open your child's report.",
    url: "/parent-report",
  },
  ar: {
    title: "📋 تقرير الأسبوع العائلي جاهز",
    body: "نقاط القوّة والفصول التي تحتاج مراجعة ونصيحة الأسبوع: افتح متابعة ابنك.",
    url: "/parent-report",
  },
};

/** Une locale inconnue (donnée abîmée) retombe en français plutôt que de ne rien envoyer. */
export function safeLocale(locale: string | null | undefined): Locale {
  return locale === "en" || locale === "ar" ? locale : "fr";
}

export type PushPayload = { title: string; body: string; url: string; tag: string };

/** Construit le payload d'un candidat — le seul endroit qui interpole `{n}`. */
export function payloadFor(tag: PushTag, locale: Locale, arg: number | null): PushPayload {
  const copy =
    tag === "tutor-daily-plan" && arg === 1
      ? { ...PUSH_COPY[tag][locale], body: SINGULAR_PLAN[locale] }
      : PUSH_COPY[tag][locale];
  return {
    title: copy.title.replace("{n}", String(arg ?? "")),
    body: copy.body.replace("{n}", String(arg ?? "")),
    url: copy.url,
    tag,
  };
}

export function parentDigestPayload(locale: Locale): PushPayload {
  const copy = PARENT_DIGEST_COPY[locale];
  return { ...copy, tag: PARENT_DIGEST_TAG };
}
