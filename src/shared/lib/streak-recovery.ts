import { STREAK_RECOVERY_WINDOW_DAYS } from "@/shared/constants/gamification";
import { getDateDaysAgoUtc, getYesterdayUtc } from "@/shared/lib/dates";

/**
 * QUAND UNE SÉRIE PEUT-ELLE ÊTRE RACHETÉE — déclaré ICI, et nulle part ailleurs.
 *
 * Ce module existe à cause d'une panne précise. Le serveur (`recoverStreak`) et
 * le client (la bannière du tableau de bord) tenaient chacun leur propre version
 * de la condition. Le serveur a été corrigé — il lit un `last_active_date`
 * périmé, et son commentaire nomme même le défaut : « `current_streak === 0` …
 * that was the dead gate ». Le client, lui, est resté sur cette porte morte.
 *
 * `award_xp` n'écrit JAMAIS `current_streak = 0` : ses branches donnent 1,
 * `current` ou `current + 1`. La bannière ne s'affichait donc jamais, et
 * `recoverStreak` — un chemin complet, testé, avec sa RPC de dépense — n'avait
 * aucun appelant atteignable. Une fonctionnalité murée, invisible dans les
 * tests parce que chaque moitié était juste de son côté.
 *
 * C'est la même classe que les refus d'auth (`auth-refusals.ts`) : deux listes
 * tenues à la main ont divergé deux fois. Le remède est le même — une
 * déclaration unique, et les deux surfaces la lisent.
 */
export type StreakRecoveryBlock =
  /** La série court encore (activité aujourd'hui ou hier) : rien à racheter. */
  | "streak-actif"
  /** Aucune série n'a jamais existé : il n'y a rien à récupérer. */
  | "aucun-streak"
  /**
   * La série est perdue depuis TROP LONGTEMPS — plus de
   * `STREAK_RECOVERY_WINDOW_DAYS` jours manqués. Ce cas n'existait pas : la porte
   * ne regardait que « périmé ou non », donc une absence de dix jours ouvrait le
   * rachat comme une absence d'un jour.
   */
  | "fenetre-expiree"
  /** Aucun blocage — le rachat est ouvert. */
  | null;

export type StreakRecoveryProfile = {
  readonly last_active_date: string | null;
  readonly longest_streak: number | null;
};

/**
 * Rend ce qui EMPÊCHE le rachat, ou `null` s'il est ouvert.
 *
 * `now` est injectable pour les tests uniquement. Les deux surfaces passent
 * l'heure réelle et la MÊME fonction UTC : deux calculs de « hier » qui
 * divergent sur un fuseau, c'est un bouton actif que le serveur refuse — la
 * panne #914/#915 rejouée.
 */
export function streakRecoveryBlock(
  profile: StreakRecoveryProfile,
  now: Date = new Date(),
): StreakRecoveryBlock {
  const lastActive = profile.last_active_date;
  if (lastActive != null && lastActive >= getYesterdayUtc(now)) return "streak-actif";
  if ((profile.longest_streak ?? 0) === 0) return "aucun-streak";

  // ⭐ LA BORNE HAUTE. Une série rachetable est perdue depuis au plus
  // `STREAK_RECOVERY_WINDOW_DAYS` jours. `last_active_date` étant le DERNIER jour
  // actif, la veille de ce jour-là ne compte pas comme manquée : un élève actif
  // avant-hier n'a manqué qu'hier. La plus vieille date encore rachetable est donc
  // à `fenêtre + 1` jours.
  //
  // Une date ABSENTE ne peut pas être dans une fenêtre : `null` avec une série au
  // palmarès est un profil que `award_xp` ne produit pas (il écrit toujours
  // `last_active_date` en même temps que la série), et on ne devine pas une date
  // pour ouvrir une dépense de pièces.
  const plusVieilleRachetable = getDateDaysAgoUtc(STREAK_RECOVERY_WINDOW_DAYS + 1, now);
  if (lastActive == null || lastActive < plusVieilleRachetable) return "fenetre-expiree";

  return null;
}
