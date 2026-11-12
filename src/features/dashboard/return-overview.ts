import { z } from "zod";

/**
 * Étude 40 lot 0 — la FORME de la mesure du retour (`admin_return_overview`), et sa lecture.
 *
 * Séparé de `engagement.server.ts` pour une raison : les deux décisions de lecture qui peuvent
 * mentir vivent ici, pures et testées sans base.
 *
 *   1. « pas encore mesurable » ≠ « perdu ». `*_base` ne compte que les comptes dont la fenêtre de
 *      sept jours est écoulée. Les autres sont EN ATTENTE : ni perdus, ni gagnés.
 *   2. un taux sans base est `null`, jamais 0 %.
 */

/** Une cohorte d'inscription hebdomadaire (lundi, jour de Tunis). */
export const returnCohortSchema = z.object({
  week: z.string(),
  signups: z.coerce.number(),
  /** `auth.users.email_confirmed_at IS NOT NULL` — la perte d'AVANT le premier écran. */
  confirmed: z.coerce.number(),
  /** Au moins un jour d'activité entre J et J+7, jour J INCLUS : la première quête. */
  played_7d: z.coerce.number(),
  played_7d_base: z.coerce.number(),
  /** Au moins un jour entre J+1 et J+7 : le retour (définition de KPI-B). */
  back_7d: z.coerce.number(),
  back_7d_base: z.coerce.number(),
});

export const returnOverviewSchema = z.object({
  cohorts: z.array(returnCohortSchema),
  /** Tous les élèves — le dénominateur de `never_played`. */
  students: z.coerce.number(),
  /** Élèves sans AUCUN jour d'activité, toutes dates confondues. */
  never_played: z.coerce.number(),
  push: z.object({
    students_active_30d: z.coerce.number(),
    /** Au moins un abonnement push — une personne, quel que soit le nombre d'appareils. */
    students_reachable: z.coerce.number(),
    /** Parents ayant au moins un lien ACTIF vers un élève. */
    parents_linked: z.coerce.number(),
    parents_reachable: z.coerce.number(),
  }),
  generated_at: z.string(),
});

export type ReturnOverview = z.infer<typeof returnOverviewSchema>;
export type ReturnCohort = z.infer<typeof returnCohortSchema>;

/** Un taux à une décimale, ou `null` quand il n'y a rien à diviser. */
export function ratePct(part: number, base: number): number | null {
  return base > 0 ? Math.round((1000 * part) / base) / 10 : null;
}

/** Ce qu'une cohorte dit, une fois « mesurable », « en attente » et « perdu » séparés. */
export type ReturnCohortReading = {
  /** Comptes dont la fenêtre est écoulée. */
  readonly measurable: number;
  /** Comptes trop récents pour être jugés — NI perdus NI gagnés. */
  readonly pending: number;
  /** Mesurables qui n'ont PAS joué dans leur première semaine. */
  readonly lost: number;
  readonly playedPct: number | null;
  readonly backPct: number | null;
};

export function readReturnCohort(cohort: ReturnCohort): ReturnCohortReading {
  const measurable = cohort.played_7d_base;
  return {
    measurable,
    pending: Math.max(0, cohort.signups - measurable),
    lost: Math.max(0, measurable - cohort.played_7d),
    playedPct: ratePct(cohort.played_7d, measurable),
    backPct: ratePct(cohort.back_7d, cohort.back_7d_base),
  };
}

/** Le cumul des huit semaines — le « x/y » que le relevé publie. */
export function sumReturnCohorts(cohorts: readonly ReturnCohort[]): {
  readonly signups: number;
  readonly played: number;
  readonly playedBase: number;
  readonly back: number;
  readonly backBase: number;
  readonly pending: number;
} {
  const total = { signups: 0, played: 0, playedBase: 0, back: 0, backBase: 0, pending: 0 };
  for (const cohort of cohorts) {
    total.signups += cohort.signups;
    total.played += cohort.played_7d;
    total.playedBase += cohort.played_7d_base;
    total.back += cohort.back_7d;
    total.backBase += cohort.back_7d_base;
    total.pending += readReturnCohort(cohort).pending;
  }
  return total;
}
