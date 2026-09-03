import {
  Award,
  BookOpen,
  Calculator,
  Coins,
  Flame,
  Languages,
  Moon,
  Package,
  Shield,
  Sparkles,
  Star,
  Sun,
  Sword,
  Swords,
  Timer,
  TrendingUp,
  Trophy,
  Zap,
  type LucideIcon,
} from "lucide-react";
import { cn } from "@/shared/lib/utils";

// =============================================================================
// La médaille d'un badge (levier 02). Jusqu'ici un badge débloqué s'affichait en
// carte de TEXTE — son nom et sa rareté — alors que la table en porte déjà le
// glyphe (`badges.icon_name`) et le cran (`badges.rarity`). La donnée était là,
// la récompense ne se voyait pas.
//
// Volontairement géométrique : un cadre facetté, pas une illustration. Ça se
// dessine en tokens, ça tient dans les deux thèmes, ça pèse quelques centaines
// d'octets et ça reste remplaçable — le jour où un illustrateur fournit de
// vraies médailles, seul ce composant change.
// =============================================================================

/**
 * Les glyphes semés en base (`badges.icon_name`), plus un repli.
 *
 * ⚠️ Cette carte doit couvrir TOUT `icon_name` semé par une migration. Un nom
 * absent ne casse rien — il retombe sur `Award` — et c'est bien le problème :
 * `event_rentree` a été semé en `Sparkles` par le lot 8 de é31 et a porté le
 * glyphe de repli sans que rien ne rougisse. `badge-medal.test.tsx` compare
 * désormais cette carte au semis des migrations, dans les deux sens.
 */
const GLYPHS: Record<string, LucideIcon> = {
  Sword,
  Flame,
  Zap,
  Star,
  Timer,
  Calculator,
  Languages,
  Shield,
  TrendingUp,
  Package,
  Coins,
  Moon,
  // é31 lot 8 et sa suite — les badges saisonniers du calendrier.
  Sparkles,
  BookOpen,
  Sun,
  // Semés et JAMAIS rendus : `league_podium` en `Trophy` (lot 5) et `boss_slayer`
  // en `swords` (le tout premier seed, 2026-05-22). Le second est normalisé en
  // `Swords` par `20260903120000` — la casse du seed d'origine ne rendait rien.
  Trophy,
  Swords,
};

const RARITY_COLOR: Record<string, string> = {
  common: "var(--rarity-common)",
  rare: "var(--rarity-rare)",
  epic: "var(--rarity-epic)",
  legendary: "var(--rarity-legendary)",
};

const SIZES = {
  sm: { box: "h-10 w-10", glyph: "h-4 w-4" },
  md: { box: "h-14 w-14", glyph: "h-6 w-6" },
} as const;

export function BadgeMedal({
  iconName,
  rarity,
  size = "md",
  className,
}: {
  iconName?: string | null;
  rarity: string;
  size?: keyof typeof SIZES;
  className?: string;
}) {
  const Glyph = (iconName && GLYPHS[iconName]) || Award;
  // Une rareté inconnue retombe sur « commun » plutôt que de rendre un cadre
  // sans couleur : un badge mal semé doit rester une médaille, pas un trou.
  const color = RARITY_COLOR[rarity] ?? RARITY_COLOR.common;
  const dims = SIZES[size];
  // Le cran le plus haut gagne une couronne de pointes — la seule différence de
  // FORME de l'échelle, pour qu'elle se lise aussi sans la couleur.
  const crowned = rarity === "legendary";

  return (
    <span
      className={cn("relative grid shrink-0 place-items-center", dims.box, className)}
      style={{ color }}
      // Le badge est déjà nommé en toutes lettres à côté de la médaille : la
      // répéter ici ferait bégayer le lecteur d'écran.
      aria-hidden="true"
    >
      <svg viewBox="0 0 48 48" className="absolute inset-0 h-full w-full" focusable="false">
        <polygon
          points="24,3 38,10 45,24 38,38 24,45 10,38 3,24 10,10"
          fill="currentColor"
          fillOpacity="0.14"
          stroke="currentColor"
          strokeOpacity="0.75"
          strokeWidth="2"
          strokeLinejoin="round"
        />
        <polygon
          points="24,9 33,13.5 38.5,24 33,34.5 24,39 15,34.5 9.5,24 15,13.5"
          fill="none"
          stroke="currentColor"
          strokeOpacity="0.3"
          strokeWidth="1"
          strokeLinejoin="round"
        />
        {crowned &&
          [0, 90, 180, 270].map((angle) => (
            <polygon
              key={angle}
              points="24,0 26.5,5 21.5,5"
              fill="currentColor"
              fillOpacity="0.9"
              transform={`rotate(${angle} 24 24)`}
            />
          ))}
      </svg>
      <Glyph className={cn("relative", dims.glyph)} strokeWidth={2.25} />
    </span>
  );
}
