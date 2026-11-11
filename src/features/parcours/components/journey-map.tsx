import { Link } from "@tanstack/react-router";
import { Map as MapIcon } from "lucide-react";
import { PageShell } from "@/components/ui/page-shell";
import { useT } from "@/lib/i18n";
import { EmptyState } from "@/components/ui/empty-state";
import { JourneyHeader } from "./journey-header";
import { JourneyTrack, TrackRow } from "./journey-track";
import { PathNode } from "./path-node";
import { nodeSide, type SubjectNode } from "../journey";

export type JourneyMapProps = {
  nodes: SubjectNode[];
  profile: { level: number; xp: number; heroClass: string };
};

/** World map: subject regions as nodes on the winding adventure path. */
export function JourneyMap({ nodes, profile }: JourneyMapProps) {
  const t = useT();

  return (
    <PageShell>
      <JourneyHeader
        title={t.parcours.worldTitle}
        subtitle={t.parcours.worldSubtitle}
        level={profile.level}
        xp={profile.xp}
        heroClass={profile.heroClass}
      />
      <JourneyTrack>
        {nodes.map((n, i) => {
          const color = `var(--subject-${n.colorToken.replace(/^subject-/, "")})`;
          // ⭐ Sous-libellé = le SCEAU, et ce qui manque pour le suivant (étude 34, R-9).
          // Le pourcentage a disparu, et ce n'est pas une question de format : il divisait
          // un travail par un catalogue qui bouge, donc il faisait reculer l'élève quand
          // c'était le produit qui grandissait. Glyphes et chiffres, sans mot — la légende
          // sous la carte porte le sens, une fois, pour tous les nœuds.
          const seal = "⭐".repeat(n.sealStar);
          const sublabel =
            [seal, n.nextSeal ? `${n.nextSeal.chaptersReady}/${n.nextSeal.chaptersTotal}` : ""]
              .filter(Boolean)
              .join(" · ") || undefined;
          const ariaLabel = n.nextSeal
            ? t.parcours.nodeSealAria
                .replace("{subject}", n.nameFr)
                .replace("{stars}", seal || "—")
                .replace("{ready}", String(n.nextSeal.chaptersReady))
                .replace("{total}", String(n.nextSeal.chaptersTotal))
            : n.nameFr;
          return (
            <TrackRow key={n.id} side={nodeSide(i)} index={i}>
              <Link to="/matiere/$subjectId" params={{ subjectId: n.id }} aria-label={ariaLabel}>
                <PathNode
                  state={n.state}
                  title={n.nameFr}
                  sublabel={sublabel}
                  badge={n.state === "next" ? t.parcours.nodeNext : undefined}
                  icon={n.icon}
                  color={color}
                />
              </Link>
            </TrackRow>
          );
        })}
        {nodes.length === 0 && <EmptyState icon={MapIcon} title={t.parcours.empty} />}
      </JourneyTrack>
      {nodes.length > 0 && (
        <p className="mt-6 text-center text-xs text-muted-foreground" data-testid="seal-legend">
          {t.parcours.sealLegend}
        </p>
      )}
    </PageShell>
  );
}
