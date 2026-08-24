// LE BILAN HEBDOMADAIRE — étude 11 lot 6, la partie PURE (US-13, US-14, Q-5, R-14).
//
// LE SEUL ENDROIT DE L'ÉTUDE OÙ LE MODÈLE RÉDIGE (R-10)
// ---------------------------------------------------------------------------
// « Le déterministe décide, le LLM rédige. » Partout ailleurs le modèle EXPLIQUE
// un point de cours ; ici il met en phrases des chiffres que le SQL a déjà
// arrêtés — totaux, moyennes, ÉCARTS avec la semaine précédente, trois erreurs
// nommées (`get_tutor_digest_inputs`, migration 20260824120000). Il ne
// sélectionne rien, ne compare rien, n'extrapole rien. C'est écrit dans les six
// prompts système, et vérifié une fois à la sortie : un bilan qui cite un
// chiffre absent des faits est indétectable par une machine — la seule défense
// est de ne JAMAIS lui demander de calculer.
//
// CE FICHIER EST LE SECOND FILET DE VIE PRIVÉE (R-14)
// ---------------------------------------------------------------------------
// Le premier filet est en SQL, et c'est le bon endroit :
// `get_tutor_digest_inputs` est écrite pour ne rendre AUCUN identifiant — ni
// nom, ni e-mail, ni UUID d'élève, de chapitre, de matière ou de tag. C'est,
// dit sa migration, « la seule fonction du dépôt dont la sortie quitte
// l'infrastructure ».
//
// Alors pourquoi un second filet ? Parce qu'une fonction SQL se modifie. Le jour
// où quelqu'un ajoutera `'displayName', p.display_name` à son
// `jsonb_build_object` « pour personnaliser un peu », rien côté base ne
// l'arrêtera. Ici, deux choses l'arrêtent :
//
//   • un TYPE — `TutorDigestFacts` EST, à la virgule près, ce qui part chez le
//     fournisseur. `buildDigestBlocks` n'accepte que lui, et il n'a aucun champ
//     où un nom, un e-mail ou un identifiant pourrait se ranger ;
//   • un SCHÉMA — `readDigestInputs` lit par une liste blanche zod, qui ôte
//     toute clé non déclarée. Ne rien déclarer, c'est tout jeter.
//
// L'un se voit à la revue du diff, l'autre tient à l'exécution. Le premier des
// deux est le plus important : il rend la faute VISIBLE.
//
// LES IDENTIFIANTS TECHNIQUES SONT DU PII AUSSI
// ---------------------------------------------------------------------------
// Un UUID de chapitre n'est pas un nom, mais il ré-identifie : croisé avec le
// catalogue public, il désigne l'élève à une classe près. On n'envoie donc que
// des LIBELLÉS (« Fractions », « Mathématiques »). Même raisonnement pour le
// `tag` d'une erreur, qui est de surcroît un jargon interne que R-A1.2-1
// interdit déjà d'afficher à un élève — la migration le laisse d'ailleurs en
// base et ne rend que les trois libellés traduits.
//
// DEUX REGISTRES, PAS UN AVEC UNE VARIABLE
// ---------------------------------------------------------------------------
// L'élève est TUTOYÉ par El Ostedh, en 4 à 6 phrases, dans le vocabulaire de sa
// bande d'âge. Le parent est VOUVOYÉ, sobrement, sans un mot de jeu — ni XP, ni
// pièces, ni badge, ni quête, ni donjon — en 4 phrases de constat plus UN
// conseil applicable le soir même. Ce ne sont pas deux tons du même texte : ce
// sont deux destinataires, dont l'un ne joue pas.
//
// Les six prompts (2 registres × 3 langues) sont écrits NATIVEMENT, annexe B :
// un prompt arabe traduit du français produit un arabe de manuel importé, et
// c'est encore plus visible dans une lettre à un parent que dans une explication.

import { z } from "zod";

import { HTML_TAG, violatesNotation } from "@/shared/integrations/ai/notation";
import type { AiBlock } from "@/shared/integrations/ai/types";
import { TUTOR_AGE_BANDS, TUTOR_LANGS, type TutorAgeBand, type TutorLang } from "./prompt";
import { countWords, validateTutorOutput } from "./validator";

/** Les deux destinataires. Fermé : la table de stockage porte le même CHECK. */
export const TUTOR_DIGEST_AUDIENCES = ["student", "parent"] as const;
export type TutorDigestAudience = (typeof TUTOR_DIGEST_AUDIENCES)[number];

// ---------------------------------------------------------------------------
// LES FAITS — le périmètre EXACT de ce qui quitte le produit (R-14)
// ---------------------------------------------------------------------------

/** Une semaine, telle que `get_tutor_digest_inputs` la mesure. */
export type TutorDigestWeek = {
  readonly missions: number;
  readonly minutes: number;
  readonly avgScore: number;
  readonly daysActive: number;
};

/**
 * L'écart avec la semaine précédente, calculé EN SQL (R-10).
 *
 * `avgScore` est `null` quand l'une des deux semaines n'a aucune mission : un
 * écart de moyenne contre une semaine vide produirait « +67 points de
 * progression » sur une reprise après vacances — un compliment mécanique et
 * faux. `null` veut dire « pas comparable », et le prompt le traduit par le
 * silence. Le remplacer par 0 ici annulerait la garde posée dans la migration.
 */
export type TutorDigestDelta = {
  readonly missions: number;
  readonly minutes: number;
  readonly avgScore: number | null;
  readonly daysActive: number;
};

/** Un chapitre, par son LIBELLÉ. Ni `chapterId`, ni `subjectId` : voir l'en-tête. */
export type TutorDigestChapter = {
  readonly chapter: string;
  readonly subject: string;
  readonly attempts: number;
  readonly avgScore: number;
};

/** Une erreur, par son libellé traduit. Le `tag` technique ne quitte pas la base. */
export type TutorDigestMistake = {
  readonly label: string;
  readonly occurrences: number;
};

/**
 * TOUT ce que le modèle reçoit, et RIEN d'autre.
 *
 * Ce type n'est pas une commodité de passage : c'est le contrat de vie privée du
 * lot, rendu vérifiable par le compilateur. Ajouter ici un champ nominatif —
 * `displayName`, `email`, `studentId`, une date de naissance — serait la seule
 * façon d'ouvrir la fuite, et cela se verrait dans une revue de diff en une
 * ligne. C'est exactement ce qu'on veut : que la faute soit VISIBLE.
 *
 * Ce qui est délibérément ABSENT et ne doit pas revenir :
 *  • la SEMAINE (`weekStart`) — c'est une clé de stockage, pas un fait à
 *    raconter ; le modèle n'a pas à dater ce qu'il rédige, et une date est le
 *    premier élément ré-identifiant qu'on cesse de voir à force de le lire ;
 *  • les compteurs d'usage du tuteur — Q-5 les sert déjà côté parent par
 *    `get_tutor_parent_counters` (lot 4), et les faire voyager en plus ne dirait
 *    rien de la scolarité de la semaine ;
 *  • tout identifiant, y compris technique. Un UUID de chapitre ré-identifie :
 *    croisé avec le catalogue public, il désigne l'élève à une classe près.
 */
export type TutorDigestFacts = {
  readonly lang: TutorLang;
  readonly ageBand: TutorAgeBand;
  readonly thisWeek: TutorDigestWeek;
  readonly lastWeek: TutorDigestWeek;
  readonly delta: TutorDigestDelta;
  readonly chapters: readonly TutorDigestChapter[];
  readonly mistakes: readonly TutorDigestMistake[];
};

// ---------------------------------------------------------------------------
// LA PROJECTION — le second filet, à l'exécution
// ---------------------------------------------------------------------------

const numberish = z.coerce.number().catch(0);
const ZERO_WEEK = {
  missions: 0,
  minutes: 0,
  avgScore: 0,
  daysActive: 0,
} as const;

const weekSchema = z
  .object({
    missions: numberish,
    minutes: numberish,
    avgScore: numberish,
    daysActive: numberish,
  })
  .catch({ ...ZERO_WEEK });

/**
 * ⚠️ CE SCHÉMA EST LA LISTE BLANCHE, ET C'EST LE SECOND FILET DE R-14.
 *
 * `get_tutor_digest_inputs` est déjà dépersonnalisée en SQL — c'est le premier
 * filet, et le meilleur. Celui-ci existe parce qu'une fonction SQL se modifie :
 * le jour où quelqu'un ajoutera `'displayName', p.display_name` à son
 * `jsonb_build_object` « pour personnaliser un peu », zod le jettera avant qu'il
 * n'atteigne un fournisseur, sans que personne ait eu à y penser. Zod ôte les
 * clés non déclarées : ne rien déclarer, c'est tout jeter.
 *
 * Tout est `.catch()` : un bilan doit se calculer même si une clé manque parce
 * que la migration vient d'être déployée. Dégrader, pas lever (R-15) — c'est la
 * posture déjà tenue par `parent-report.server.ts`.
 */
const inputsSchema = z.object({
  lang: z.enum(TUTOR_LANGS).catch("fr"),
  ageBand: z.enum(TUTOR_AGE_BANDS).catch("12-14"),
  /**
   * Le levier R-15 du batch, décidé en SQL : `false` ⇒ aucune mission cette
   * semaine. On ne fait pas rédiger « tu n'as rien fait » par un modèle — ça
   * coûte de l'argent et ça sonne comme un reproche.
   */
  hasActivity: z.boolean().catch(false),
  thisWeek: weekSchema,
  lastWeek: weekSchema,
  delta: z
    .object({
      missions: numberish,
      minutes: numberish,
      // Le SEUL champ qu'on ne coerce pas à 0 : `null` est une valeur porteuse
      // de sens, pas une absence à combler.
      avgScore: z.coerce.number().nullable().catch(null),
      daysActive: numberish,
    })
    .catch({ missions: 0, minutes: 0, avgScore: null, daysActive: 0 }),
  chapters: z
    .array(
      z.object({
        chapter: z.string().catch(""),
        subject: z.string().catch(""),
        attempts: numberish,
        avgScore: numberish,
      }),
    )
    .catch([]),
  topErrors: z
    .array(
      z.object({
        labelFr: z.string().catch(""),
        labelEn: z.string().catch(""),
        labelAr: z.string().catch(""),
        occurrences: numberish,
      }),
    )
    .catch([]),
});

/**
 * Ce que le batch lit d'un élève : les faits à expédier, et le drapeau qui dit
 * s'il y a lieu de dépenser. Les deux sont séparés à dessein — `hasActivity`
 * pilote une décision, il n'a rien à faire dans un prompt.
 */
export type TutorDigestSource = {
  readonly hasActivity: boolean;
  readonly facts: TutorDigestFacts;
};

/** Choisit le libellé traduit sans jamais retomber sur un identifiant technique. */
function pickLabel(
  labels: { labelFr: string; labelEn: string; labelAr: string },
  lang: TutorLang,
): string {
  if (lang === "ar") return labels.labelAr || labels.labelFr;
  if (lang === "en") return labels.labelEn || labels.labelFr;
  return labels.labelFr;
}

/**
 * Projette le payload de `get_tutor_digest_inputs` vers les faits expédiables.
 *
 * C'est LA fonction dont un défaut est une fuite de données d'enfant et non un
 * bug d'affichage. Elle est pure, sans accès réseau, et testée par un contrôle
 * NÉGATIF : un prénom et une adresse e-mail injectés dans le payload d'entrée ne
 * doivent ressortir nulle part, ni dans les faits, ni dans les blocs.
 *
 * ⚠️ Elle ne RE-COUPE rien. Le SQL borne déjà à cinq chapitres et trois erreurs,
 * avec un raisonnement écrit dans la migration ; re-trancher ici ferait deux
 * propriétaires du même cadrage, et le second dériverait au premier ajustement.
 */
export function readDigestInputs(raw: unknown): TutorDigestSource {
  const input = inputsSchema.parse(raw ?? {});
  const lang = input.lang;

  return {
    hasActivity: input.hasActivity,
    facts: {
      lang,
      ageBand: input.ageBand,
      thisWeek: roundWeek(input.thisWeek),
      lastWeek: roundWeek(input.lastWeek),
      delta: {
        missions: Math.round(input.delta.missions),
        minutes: Math.round(input.delta.minutes),
        avgScore: input.delta.avgScore === null ? null : Math.round(input.delta.avgScore),
        daysActive: Math.round(input.delta.daysActive),
      },
      chapters: input.chapters
        .filter((c) => c.chapter.length > 0)
        .map((c) => ({
          chapter: c.chapter,
          subject: c.subject,
          attempts: Math.round(c.attempts),
          avgScore: Math.round(c.avgScore),
        })),
      mistakes: input.topErrors
        .map((m) => ({
          label: pickLabel(m, lang),
          occurrences: Math.round(m.occurrences),
        }))
        .filter((m) => m.label.length > 0),
    },
  };
}

function roundWeek(week: TutorDigestWeek): TutorDigestWeek {
  return {
    missions: Math.round(week.missions),
    minutes: Math.round(week.minutes),
    avgScore: Math.round(week.avgScore),
    daysActive: Math.round(week.daysActive),
  };
}

// ---------------------------------------------------------------------------
// LES BLOCS — motif `buildExplainBlocks`
// ---------------------------------------------------------------------------

/**
 * Un SEUL bloc, et pas de `cacheBoundary`.
 *
 * `buildExplainBlocks` coupe le cache après le cours parce que le cours est le
 * même d'un élève à l'autre. Ici, TOUT est propre à l'élève : il n'existe aucun
 * préfixe réutilisable, et poser une frontière de cache sur des chiffres
 * personnels n'économiserait rien tout en allongeant la durée de vie de ces
 * chiffres chez le fournisseur. Le pire compromis possible.
 */
export function buildDigestBlocks(facts: TutorDigestFacts): AiBlock[] {
  const week = (w: TutorDigestWeek) =>
    `${w.missions} missions, ${w.minutes} min, ${w.avgScore}%, ${w.daysActive} jours actifs`;

  return [
    {
      label: "faits",
      text: [
        "<faits>",
        `semaine_en_cours: ${week(facts.thisWeek)}`,
        `semaine_precedente: ${week(facts.lastWeek)}`,
        `ecart_missions: ${signed(facts.delta.missions)}`,
        `ecart_minutes: ${signed(facts.delta.minutes)}`,
        `ecart_jours_actifs: ${signed(facts.delta.daysActive)}`,
        // Absent plutôt que nul : une ligne « non comparable » invite le modèle
        // à commenter l'incomparabilité, ce qu'aucun parent n'a demandé.
        facts.delta.avgScore === null
          ? ""
          : `ecart_moyenne_en_points: ${signed(facts.delta.avgScore)}`,
        facts.chapters.length
          ? `chapitres: ${facts.chapters
              .map((c) => `${c.chapter} (${c.subject}, ${c.attempts} missions, ${c.avgScore}%)`)
              .join(" ; ")}`
          : "",
        facts.mistakes.length
          ? `erreurs_recurrentes: ${facts.mistakes
              .map((m) => `${m.label} (${m.occurrences} fois)`)
              .join(" ; ")}`
          : "",
        "</faits>",
      ]
        .filter(Boolean)
        .join("\n"),
    },
  ];
}

/** Un écart se lit signé : « +3 » et « -3 » ne racontent pas la même semaine. */
function signed(value: number): string {
  return value > 0 ? `+${value}` : `${value}`;
}
// ---------------------------------------------------------------------------
// LES PROMPTS SYSTÈME — six textes, écrits nativement (annexe B, R-18)
// ---------------------------------------------------------------------------

/**
 * Plafonds de mots ANNONCÉS au modèle. Plus serrés que ceux de `validator.ts`,
 * qui borne une explication de cours : un bilan de cinq phrases qui déborde à
 * 200 mots n'est pas trop long, il est hors sujet.
 */
const STUDENT_TARGET_WORDS: Record<TutorAgeBand, number> = {
  "6-8": 55,
  "9-11": 80,
  "12-14": 110,
  "15-19": 130,
};

/** Le parent n'a pas de bande d'âge : c'est un adulte, et un seul registre. */
const PARENT_TARGET_WORDS = 130;

const STUDENT_TONE: Record<TutorLang, Record<TutorAgeBand, string>> = {
  fr: {
    "6-8": "phrases très courtes, mots concrets, une idée par phrase",
    "9-11": "phrases courtes, un chiffre à la fois",
    "12-14": "vocabulaire du collège, direct et sans flatterie",
    "15-19": "registre de lycée, précis, sans paternalisme",
  },
  en: {
    "6-8": "very short sentences, concrete words, one idea per sentence",
    "9-11": "short sentences, one number at a time",
    "12-14": "middle-school vocabulary, direct and free of flattery",
    "15-19": "upper-secondary register, precise, never patronising",
  },
  ar: {
    "6-8": "جمل قصيرة جدًّا، كلمات محسوسة، فكرة واحدة في كلّ جملة",
    "9-11": "جمل قصيرة، رقم واحد في كلّ مرّة",
    "12-14": "معجم المرحلة الإعدادية، مباشر وبلا مجاملة",
    "15-19": "لغة الثانوي، دقيقة ودون تعالٍ",
  },
};

function studentSystem(lang: TutorLang, ageBand: TutorAgeBand): string {
  const maxWords = STUDENT_TARGET_WORDS[ageBand];
  const tone = STUDENT_TONE[lang][ageBand];

  if (lang === "ar") {
    return [
      "أنت «الأستاذ»، معلّم خصوصي لطيف في أكاديمية تونسية.",
      "تكتب حصيلة الأسبوع للتلميذ نفسه، وتخاطبه مباشرة.",
      `التلميذ في الفئة العمرية ${ageBand}. اضبط أسلوبك: ${tone}.`,
      "قواعد مطلقة:",
      "1. تكتب بالعربية فقط. الأرقام 0-9 الغربية، ولا LaTeX ولا HTML ولا أيّ عنوان إنترنت.",
      "2. الأرقام المعطاة هي الوقائع الوحيدة المسموح بها: تصوغها جملًا، ولا تحسب شيئًا ولا تستنتج رقمًا غير موجود.",
      "3. من 4 إلى 6 جمل: ما أنجزه، ما نجح فيه، ما تعثّر فيه، وخطوة واحدة للأسبوع القادم.",
      "4. لا تَعِد بأيّ مكافأة: لا نقاط خبرة ولا قطع نقدية ولا شارات — لا وجود لها هنا.",
      "5. لا تذكر أبدًا اشتراكًا ولا خدمة مدفوعة: كلّ شيء مجّانيّ.",
      "6. كن لطيفًا دون تأنيب. إذا كان الأسبوع فارغًا فقل ذلك بهدوء واقترح خطوة صغيرة واحدة.",
      `7. ${maxWords} كلمة على الأكثر.`,
    ].join("\n");
  }

  if (lang === "en") {
    return [
      'You are "El Ostedh", a kind private tutor in a Tunisian academy.',
      "You are writing the student's own weekly review, addressed to them directly.",
      `The student is in age band ${ageBand}. Match your style: ${tone}.`,
      "Absolute rules:",
      "1. Write in English only. Digits 0-9, NO LaTeX, NO HTML, no web address.",
      "2. The numbers given are the ONLY facts you may use: put them into sentences. Never compute, never extrapolate, never state a number that is not there.",
      "3. Four to six sentences: what was done, what went well, what is stuck, ONE step for next week.",
      "4. Promise no reward: no XP, no coins, no badges — there are none here.",
      "5. Never mention a subscription or anything paid: everything is free.",
      "6. Be kind, never guilt-inducing. If the week was empty, say so calmly and offer one small step.",
      `7. At most ${maxWords} words.`,
    ].join("\n");
  }

  return [
    "Tu es « El Ostedh », professeur particulier bienveillant d'une académie tunisienne.",
    "Tu écris le bilan de la semaine de l'élève, et tu t'adresses à lui directement.",
    `L'élève est dans la bande d'âge ${ageBand}. Adapte ton style : ${tone}.`,
    "RÈGLES ABSOLUES :",
    "1. Tu écris UNIQUEMENT en français. Chiffres 0-9, PAS de LaTeX, PAS de HTML, aucune adresse web.",
    "2. Les chiffres fournis sont les SEULS faits autorisés : tu les mets en phrases. Tu ne calcules rien, tu n'extrapoles rien, tu ne cites aucun chiffre absent.",
    "3. Quatre à six phrases : ce qui a été fait, ce qui va bien, ce qui coince, UN pas pour la semaine prochaine.",
    "4. Tu ne promets aucune récompense : ni XP, ni pièces, ni badge — il n'y en a pas ici.",
    "5. Tu ne mentionnes jamais d'abonnement ni quoi que ce soit de payant : tout est gratuit.",
    "6. Bienveillant, jamais culpabilisant. Si la semaine a été vide, dis-le calmement et propose un petit pas.",
    `7. Maximum ${maxWords} mots.`,
  ].join("\n");
}

/**
 * Le registre PARENT. Trois choses le séparent de celui de l'élève, et aucune
 * n'est cosmétique :
 *
 *  • le VOUVOIEMENT — on écrit à un adulte, pas à un enfant plus grand ;
 *  • l'INTERDICTION du vocabulaire de jeu — un parent qui lit « il a gagné 340
 *    XP » n'apprend rien sur la scolarité de son enfant, et le produit perd sa
 *    crédibilité auprès du seul lecteur qui décide s'il reste installé ;
 *  • le CONSEIL final, unique et applicable à la maison — c'est la seule ligne
 *    du bilan sur laquelle un parent peut agir le soir même (é04 A2.2).
 *
 * Et une quatrième, invisible : « ne nommez jamais l'élève ». Le modèle ne
 * reçoit aucun prénom (R-14) ; sans cette ligne, il en inventerait un.
 */
function parentSystem(lang: TutorLang): string {
  if (lang === "ar") {
    return [
      "تكتب حصيلة أسبوعية موجّهة إلى وليّ تلميذ في أكاديمية تونسية.",
      "قواعد مطلقة:",
      "1. تخاطب الوليّ بصيغة الاحترام، وتكتب بالعربية فقط.",
      "2. أسلوب رصين ووقائعيّ: بلا مبالغة، بلا رموز تعبيريّة، بلا عنوان ولا قائمة.",
      "3. الأرقام المعطاة هي الوقائع الوحيدة المسموح بها: تصوغها جملًا ولا تحسب ولا تخترع شيئًا.",
      "4. لا تستعمل أيّ لفظ من ألفاظ اللعب: لا نقاط خبرة، ولا قطع نقدية، ولا شارات، ولا مهمّات، ولا زنزانات، ولا مبارزات، ولا رتب.",
      "5. لا تذكر اشتراكًا ولا خدمة مدفوعة: كلّ شيء مجّانيّ.",
      "6. لا تسمِّ التلميذ أبدًا: قل «ابنكم» أو «ابنتكم».",
      "7. أربع جمل من الملاحظة، ثمّ جملة واحدة فيها نصيحة عمليّة قابلة للتطبيق في البيت هذا الأسبوع.",
      "8. الأرقام 0-9 الغربية، ولا LaTeX ولا HTML ولا أيّ عنوان إنترنت.",
      `9. ${PARENT_TARGET_WORDS} كلمة على الأكثر.`,
    ].join("\n");
  }

  if (lang === "en") {
    return [
      "You are writing the weekly review addressed to the PARENT of a student in a Tunisian academy.",
      "Absolute rules:",
      "1. Address the parent respectfully, and write in English only.",
      "2. Sober, factual tone: no emphasis, no emoji, no heading, no bullet list.",
      "3. The numbers given are the ONLY facts you may use: put them into sentences. Never compute, never invent.",
      "4. NO game vocabulary whatsoever: no XP, no coins, no badges, no quests, no dungeons, no duels, no leagues, no ranks.",
      "5. Never mention a subscription or anything paid: everything is free.",
      '6. Never name the student: write "your child".',
      "7. Four sentences of observation, then ONE sentence of concrete advice that can be applied at home this week.",
      "8. Digits 0-9, NO LaTeX, NO HTML, no web address.",
      `9. At most ${PARENT_TARGET_WORDS} words.`,
    ].join("\n");
  }

  return [
    "Vous rédigez le bilan hebdomadaire adressé au PARENT d'un élève d'une académie tunisienne.",
    "RÈGLES ABSOLUES :",
    "1. Vous vouvoyez le parent, et vous écrivez UNIQUEMENT en français.",
    "2. Ton sobre et factuel : sans emphase, sans emoji, sans titre, sans liste à puces.",
    "3. Les chiffres fournis sont les SEULS faits autorisés : vous les mettez en phrases. Vous ne calculez rien, vous n'inventez rien.",
    "4. AUCUN vocabulaire de jeu : ni XP, ni points d'expérience, ni pièces, ni badge, ni quête, ni donjon, ni duel, ni ligue, ni classe de héros.",
    "5. Vous ne mentionnez jamais d'abonnement ni quoi que ce soit de payant : tout est gratuit.",
    "6. Vous ne nommez jamais l'élève : écrivez « votre enfant ».",
    "7. Quatre phrases de constat, puis UNE phrase de conseil concret, applicable à la maison cette semaine.",
    "8. Chiffres 0-9, PAS de LaTeX, PAS de HTML, aucune adresse web.",
    `9. Maximum ${PARENT_TARGET_WORDS} mots.`,
  ].join("\n");
}

/** L'aiguillage des deux registres. Aucune donnée d'élève : ce préfixe est figé. */
export function digestSystem(
  audience: TutorDigestAudience,
  lang: TutorLang,
  ageBand: TutorAgeBand,
): string {
  return audience === "parent" ? parentSystem(lang) : studentSystem(lang, ageBand);
}

// ---------------------------------------------------------------------------
// LA VALIDATION DE SORTIE — deux registres, une seule mécanique
// ---------------------------------------------------------------------------

export type TutorDigestRejection =
  | "EMPTY"
  | "TOO_SHORT"
  | "TOO_LONG"
  | "NOT_PROSE"
  | "GAME_JARGON"
  | "PAYWALL"
  | "WRONG_SCRIPT"
  | "NOTATION"
  | "MARKUP";

export type TutorDigestValidation =
  | { readonly ok: true; readonly body: string }
  | { readonly ok: false; readonly reason: TutorDigestRejection };

/** Bornes RÉELLES tolérées à la sortie — la marge d'usage au-dessus de la consigne. */
const STUDENT_MAX_WORDS: Record<TutorAgeBand, number> = {
  "6-8": 90,
  "9-11": 130,
  "12-14": 170,
  "15-19": 200,
};
const PARENT_MAX_WORDS = 200;
/** Un bilan de moins de vingt mots n'est pas court, il est vide. */
const MIN_WORDS = 20;

/**
 * Le vocabulaire de jeu, dans les trois langues, refusé DANS LE BILAN PARENT.
 *
 * Une consigne dans le prompt système ne suffit pas : c'est une demande, pas une
 * garde — même raisonnement que `chat.ts` pour R-5. Ici le coût d'un manquement
 * est réputationnel et il tombe sur le seul lecteur adulte du produit.
 *
 * La liste est volontairement étroite. On y met ce qui est SANS AMBIGUÏTÉ du
 * jargon de jeu, et on laisse dehors « niveau » (une classe scolaire est un
 * niveau) ou « série » (une série d'exercices) : un faux positif ici jette un
 * bilan correct et fait retomber le parent sur le repli déterministe.
 */
const GAME_JARGON: Record<TutorLang, RegExp> = {
  fr: /\b(xp|points? d'exp[ée]rience|pi[èe]ces?|badges?|qu[êe]tes?|donjons?|duels?|ligues?)\b/i,
  en: /\b(xp|coins?|badges?|quests?|dungeons?|duels?|leagues?)\b/i,
  // Pas de `\b` en arabe : les lettres arabes ne sont pas des `\w` pour JS, et
  // la frontière de mot se déclencherait au mauvais endroit ou pas du tout.
  ar: /(نقاط الخبرة|قطع نقدية|شارة|شارات|مهمّة|مهمة|زنزانة|مبارزة|دوري)/,
};

/**
 * D-14 — « premium », « abonnement », « payant » sont interdits dans TOUTE
 * surface élève, et un bilan parent parle de la scolarité d'un élève. Le
 * validateur existant ne teste pas ce vocabulaire ; il le teste ici, pour les
 * deux registres, parce qu'un modèle qui a lu Internet propose spontanément de
 * passer à l'offre supérieure.
 */
const PAYWALL_WORDS =
  /\b(premium|abonnements?|abonner|souscri(?:re|ption)|payantes?|payants?|subscriptions?|subscribe|paid plan|upgrade)\b|(اشتراك|مدفوع|بريميوم)/i;

/**
 * Combien de phrases ? Mesure GROSSIÈRE et assumée : un point suivi d'un blanc
 * ou d'une fin, jamais un point entre deux chiffres (« 12.5 » n'est pas une fin
 * de phrase), plus les ponctuations finales arabes.
 *
 * Elle ne sert qu'à attraper UN cas — le pavé sans ponctuation — et surtout pas
 * à imposer « exactement 4 phrases » : une borne stricte sur un compte aussi
 * fragile rejetterait des bilans corrects et ferait tomber tout le monde sur le
 * repli. La borne qui protège vraiment l'écran est celle des MOTS.
 */
export function countSentences(body: string): number {
  const matches = body.match(/(?<![0-9])[.!?…؟](?=\s|$)/gu);
  return matches ? matches.length : 0;
}

/**
 * Valide un bilan.
 *
 * L'ordre compte : d'abord les contrôles PROPRES au registre (longueur, prose,
 * jargon, offre payante), puis la délégation à `validateTutorOutput` pour les
 * trois contrôles mécaniques déjà écrits une fois — script de la langue,
 * notation du manuel, balisage.
 *
 * ⚠️ La délégation passe la bande d'âge LA PLUS LARGE (`15-19`) et c'est
 * délibéré : `validateTutorOutput` a besoin d'une bande pour dimensionner SON
 * plafond de mots, et le registre parent n'a pas de bande. Comme le plafond de
 * ce registre vient d'être appliqué juste au-dessus, et qu'il est STRICTEMENT
 * plus serré, la borne déléguée ne peut plus se déclencher : elle est inerte.
 * C'est ce qui permet de réutiliser le validateur au lieu d'en recopier la
 * moitié — recopier `scriptMatches` aurait créé une seconde vérité sur la
 * langue, exactement ce que `shared/integrations/ai/notation.ts` a été extrait
 * pour éviter.
 */
export function validateDigestOutput(
  raw: string,
  audience: TutorDigestAudience,
  lang: TutorLang,
  ageBand: TutorAgeBand,
): TutorDigestValidation {
  const body = raw
    .replace(/\r\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();

  if (body.length === 0) return { ok: false, reason: "EMPTY" };

  const words = countWords(body);
  if (words < MIN_WORDS) return { ok: false, reason: "TOO_SHORT" };
  const ceiling = audience === "parent" ? PARENT_MAX_WORDS : STUDENT_MAX_WORDS[ageBand];
  if (words > ceiling) return { ok: false, reason: "TOO_LONG" };

  // Deux phrases au moins, dix au plus : le pavé sans ponctuation d'un côté, la
  // liste déguisée en paragraphe de l'autre.
  const sentences = countSentences(body);
  if (sentences < 2 || sentences > 10) return { ok: false, reason: "NOT_PROSE" };

  if (audience === "parent" && GAME_JARGON[lang].test(body)) {
    return { ok: false, reason: "GAME_JARGON" };
  }
  if (PAYWALL_WORDS.test(body)) return { ok: false, reason: "PAYWALL" };
  if (HTML_TAG.test(body)) return { ok: false, reason: "MARKUP" };
  if (violatesNotation(body)) return { ok: false, reason: "NOTATION" };

  const mechanical = validateTutorOutput(body, lang, "15-19");
  if (!mechanical.ok) {
    // Les seules causes encore atteignables sont celles qu'on délègue : la
    // longueur et le vide ont déjà été tranchés ci-dessus, avec des bornes plus
    // serrées. Tout autre code ne peut venir que d'un durcissement futur de
    // `validator.ts` — on le refuse alors comme un rebut de script, ce qui
    // dégrade proprement au lieu de laisser passer.
    const reason: TutorDigestRejection =
      mechanical.reason === "NOTATION"
        ? "NOTATION"
        : mechanical.reason === "MARKUP"
          ? "MARKUP"
          : "WRONG_SCRIPT";
    return { ok: false, reason };
  }

  return { ok: true, body: mechanical.body };
}

// ---------------------------------------------------------------------------
// LA SEMAINE — la clé de stockage, et la garantie d'idempotence
// ---------------------------------------------------------------------------

/**
 * Le LUNDI de la semaine en cours, en UTC, au format `YYYY-MM-DD`.
 *
 * ⚠️ CE N'EST PAS LE JUGE DE LA SEMAINE — `public.tutor_week_start(DATE)` l'est,
 * et les trois RPC du lot y passent leur paramètre avant de l'utiliser. Cette
 * fonction-ci ne fait que produire le jour à ENVOYER, et il n'y a donc aucun
 * risque de divergence : même si elle se trompait, le SQL renormaliserait.
 *
 * Elle existe quand même, pour deux raisons. La première : le batch doit
 * comparer la semaine visée à ce qui est DÉJÀ stocké, pour ne pas repayer un
 * bilan écrit — et cette comparaison se fait côté Node, sur une chaîne. La
 * seconde : un résumé de run qui affiche « semaine du 2026-08-17 » se lit ; un
 * résumé qui affiche la date du dimanche laisse croire à un décalage.
 *
 * POURQUOI LE LUNDI DE LA SEMAINE EN COURS, ET NON LA PRÉCÉDENTE
 * -------------------------------------------------------------------------
 * Le batch tourne le dimanche matin et la notification parent part le dimanche
 * soir (`PARENT_DIGEST_WEEKDAY`, heure de Tunis) : le jour où il s'exécute est
 * le DERNIER de la semaine qu'il résume. Dater la ligne du lundi précédent la
 * ferait paraître vieille d'une semaine, et un rattrapage le lundi suivant
 * écraserait la mauvaise ligne.
 *
 * L'UTC est sans conséquence ici : 05:00 UTC est 06:00 à Tunis, à dix-huit
 * heures de la seule frontière de jour qui pourrait changer de semaine ISO.
 */
export function digestWeekStart(now: Date): string {
  const d = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  // getUTCDay() : 0 = dimanche. Le lundi est l'origine ISO, donc dimanche recule
  // de six jours et non d'un — l'erreur classique, et elle décale tout d'une
  // semaine précisément le jour où le batch tourne.
  const shift = (d.getUTCDay() + 6) % 7;
  d.setUTCDate(d.getUTCDate() - shift);
  return d.toISOString().slice(0, 10);
}
