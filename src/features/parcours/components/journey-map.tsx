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
          // Sous-libellé = la progression officielle R-16, pas la moyenne des scores : « 40 % »
          // veut dire « 40 % des chapitres terminés », ce que l'élève peut vérifier au hub.
          const sublabel = n.progressionPct != null ? `${n.progressionPct}%` : undefined;
          return (
            <TrackRow key={n.id} side={nodeSide(i)} index={i}>
              <Link to="/matiere/$subjectId" params={{ subjectId: n.id }} aria-label={n.nameFr}>
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
    </PageShell>
  );
}
