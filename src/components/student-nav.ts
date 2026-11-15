import { Compass, LayoutDashboard, Map, Swords } from "lucide-react";
import type { useT } from "@/lib/i18n";

/**
 * Les quatre destinations d'un ÉLÈVE — une seule liste, rendue par la barre du haut de la
 * coquille connectée (dès `lg`) et par la barre d'onglets du bas (`StudentTabBar`, en
 * dessous). Étude 15, lot 5 (D-4) : Donjon · Duels · Classement sont regroupés sous
 * « Arène », la barre tient donc en quatre entrées sur un téléphone.
 *
 * Une fonction, pas un hook : la coquille connectée la lit après ses retours anticipés.
 */
export function studentNavItems(t: ReturnType<typeof useT>) {
  return [
    { to: "/dashboard", Icon: LayoutDashboard, label: t.layout.heroesHall },
    { to: "/parcours", Icon: Map, label: t.layout.parcours },
    { to: "/programme", Icon: Compass, label: t.layout.themes },
    { to: "/arene", Icon: Swords, label: t.layout.arena },
  ] as const;
}

/**
 * La place que la barre d'onglets prend en bas de la page, à réserver par la coquille qui la
 * monte : sans elle, la fin du contenu (et le pied de page) reste sous la barre.
 */
export const TAB_BAR_CLEARANCE =
  "pb-[calc(4.5rem+env(safe-area-inset-bottom))] lg:pb-[env(safe-area-inset-bottom)] print:pb-0";
