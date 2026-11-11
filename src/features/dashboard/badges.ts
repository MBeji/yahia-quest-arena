import type { BadgeCatalogueRow, BadgeCollectionEntry } from "@/shared/types/gamification";

/**
 * Étude 31 lot 2 — l'assemblage de la COLLECTION de badges (US-3).
 *
 * Sorti de `dashboard.server.ts` : c'est une fonction pure, elle se teste sans
 * client Supabase, et le module de lecture du tableau de bord est déjà au
 * plafond de complexité.
 */

/**
 * Contrat étroit pour la lecture du catalogue : `badges.family` est arrivée avec
 * é31 lot 2, après la dernière génération des types Supabase (qui ne peuvent pas
 * être régénérés sans accès DB). Même patron que les RPC de `economy.server.ts`
 * et `progression.server.ts` — à supprimer à la prochaine régénération.
 */
export type BadgeCatalogueClient = {
  from: (table: "badges") => {
    select: (columns: string) => PromiseLike<{
      data: BadgeCatalogueRow[] | null;
      error: { message: string } | null;
    }>;
  };
};

/**
 * Le catalogue entier, marqué de ce que l'élève a obtenu. L'ORDRE n'est pas
 * décidé ici : le serveur rend des faits, le client groupe par famille.
 */
export function buildBadgeCollection(
  catalogue: readonly BadgeCatalogueRow[],
  earned: readonly { code: string; awardedAt: string }[],
): BadgeCollectionEntry[] {
  const awardedAt = new Map(earned.map((b) => [b.code, b.awardedAt]));
  return catalogue.map((row) => ({
    code: row.code,
    name: row.name,
    description: row.description,
    rarity: row.rarity,
    iconName: row.icon_name,
    family: row.family,
    awardedAt: awardedAt.get(row.code) ?? null,
  }));
}
