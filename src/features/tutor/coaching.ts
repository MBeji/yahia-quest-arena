// LA BIBLIOTHÈQUE DE COACHING — étude 11 lot 2 (US-5, US-15), R-10.
//
// POURQUOI CE FICHIER NE CONTIENT AUCUN TEXTE
// ---------------------------------------------------------------------------
// Il choisit une CLÉ, jamais une phrase. Les phrases vivent dans les trois
// dictionnaires i18n, comme toute microcopy (R-18) ; ici ne vit que la règle de
// choix — et elle est déterministe, pure, et sans horloge.
//
// C'est l'étage 0 de §3.7, celui qui rend gratuite l'essentiel de la
// personnalisation perçue : « le déterministe décide, le LLM rédige » (D-3), et
// pour le coaching quotidien le LLM ne rédige même pas. Un élève qui ouvre son
// tableau de bord chaque matin verrait sinon partir un appel de modèle par jour
// et par item — pour dire « cinq minutes et c'est réglé ».
//
// R-10, textuellement : « Les phrases de coach quotidiennes viennent de la
// bibliothèque ; seule la rédaction des bilans hebdo est générée. »

import type { DailyPlanItem } from "@/shared/types/daily-plan";

/**
 * Les registres de phrase pour un item du plan. L'ordre du type n'a aucune
 * importance ; c'est {@link planCoachKey} qui porte la priorité.
 */
export const TUTOR_PLAN_COACH_KINDS = ["weak", "late", "due", "today"] as const;
export type TutorPlanCoachKind = (typeof TUTOR_PLAN_COACH_KINDS)[number];

/** Deux variantes par registre : trois items d'affilée ne disent pas la même chose. */
export const TUTOR_COACH_VARIANTS = 2;

/** Au-delà de ce retard, ce n'est plus « à revoir », c'est « en train de partir ». */
const LATE_AFTER_DAYS = 7;

/**
 * Le registre d'un item.
 *
 * La priorité n'est pas cosmétique : quand une misconception ACTIVE vit dans ce
 * chapitre (`weak_tags > 0`), c'est ce fait-là qu'il faut dire — l'élève ne
 * révise pas « parce que ça date », il révise parce qu'il se trompe encore, et
 * c'est la seule des deux raisons qu'il peut reconnaître.
 */
export function planCoachKind(item: DailyPlanItem): TutorPlanCoachKind {
  if (item.weak_tags > 0) return "weak";
  if (item.days_overdue >= LATE_AFTER_DAYS) return "late";
  if (item.days_overdue >= 1) return "due";
  return "today";
}

/**
 * La clé i18n complète d'un item, position comprise.
 *
 * La variante tourne sur la POSITION dans le plan, pas sur un hasard : le même
 * plan rendu deux fois de suite (retour arrière, re-rendu React) doit dire la
 * même chose. Une phrase de coach qui change à chaque peinture donne l'impression
 * d'un écran qui bavarde.
 */
export function planCoachKey(item: DailyPlanItem, index: number): string {
  const variant = (index % TUTOR_COACH_VARIANTS) + 1;
  return `${planCoachKind(item)}${variant}`;
}

/**
 * Les moments clés de US-15. Trois d'entre eux se lisent sur l'état du tableau
 * de bord ; le quatrième est l'état neutre, et il compte autant que les autres —
 * un écran qui n'a rien à célébrer ne doit pas se taire, il doit accueillir.
 */
export const TUTOR_MOMENTS = ["comeback", "streak", "clear", "steady"] as const;
export type TutorMoment = (typeof TUTOR_MOMENTS)[number];

export type TutorMomentState = {
  /** Jours pleins depuis la dernière venue. 0 = venu aujourd'hui. */
  readonly daysAway: number;
  readonly streakDays: number;
  /** Le plan du jour est-il vide ? (personne n'est en retard) */
  readonly planEmpty: boolean;
};

/** Au-delà, le retour mérite d'être nommé — en dessous, le dire serait un reproche. */
const COMEBACK_AFTER_DAYS = 3;

/** En dessous, une « série » n'en est pas encore une. */
const STREAK_WORTH_SAYING = 3;

/**
 * Le moment à saluer.
 *
 * L'ordre des trois premiers cas est celui de la RARETÉ : un retour après une
 * semaine est un événement, une série de douze jours aussi, un plan vide est
 * fréquent. Dire le plus rare, c'est dire ce que l'élève ne sait pas déjà.
 *
 * Aucun de ces registres n'est culpabilisant — R-15 et l'étude 15 l'exigent
 * ensemble : « jamais culpabilisant ». « Ça faisait longtemps ! » accueille ;
 * « tu as disparu 8 jours » accuse. Le premier est une phrase de bibliothèque,
 * le second n'y entrera jamais.
 */
export function momentKind(state: TutorMomentState): TutorMoment {
  if (state.daysAway >= COMEBACK_AFTER_DAYS) return "comeback";
  if (state.streakDays >= STREAK_WORTH_SAYING) return "streak";
  if (state.planEmpty) return "clear";
  return "steady";
}

/**
 * La clé du moment. La variante tourne sur le JOUR (jours écoulés depuis
 * l'époque), pas sur l'horloge : deux visites le même matin disent la même
 * phrase, et le lendemain change de registre sans que rien n'ait à être stocké.
 */
export function momentKey(state: TutorMomentState, dayIndex: number): string {
  const variant = (Math.abs(dayIndex) % TUTOR_COACH_VARIANTS) + 1;
  return `${momentKind(state)}${variant}`;
}

/** Le numéro de jour local, seul argument temporel de {@link momentKey}. */
export function dayIndexOf(date: Date): number {
  return Math.floor(date.getTime() / 86_400_000);
}

/**
 * Jours pleins depuis la dernière venue, depuis la date civile stockée sur le
 * profil (`YYYY-MM-DD`). `null` — un compte qui n'a jamais joué — vaut 0 : on
 * n'accueille pas un nouveau venu par « ça faisait longtemps ».
 */
export function daysAwayFrom(lastActiveDate: string | null, todayLocal: string): number {
  if (!lastActiveDate) return 0;
  const last = Date.parse(`${lastActiveDate}T00:00:00Z`);
  const today = Date.parse(`${todayLocal}T00:00:00Z`);
  if (Number.isNaN(last) || Number.isNaN(today)) return 0;
  return Math.max(0, Math.round((today - last) / 86_400_000));
}
