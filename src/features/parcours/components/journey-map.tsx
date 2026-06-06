import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
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
    <div className="mx-auto max-w-3xl px-6 py-8">
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
          const sublabel =
            n.state === "locked"
              ? t.parcours.lockedHint
              : n.state === "premium-locked"
                ? t.parcours.premiumHint
                : n.attempts > 0
                  ? `${n.avg}%`
                  : undefined;
          const node = (
            <PathNode
              state={n.state}
              title={n.nameFr}
              sublabel={sublabel}
              badge={n.isPremium ? t.parcours.premium : undefined}
              icon={n.icon}
              color={color}
              clickable={n.state !== "locked"}
            />
          );
          return (
            <TrackRow key={n.id} side={nodeSide(i)} index={i}>
              {n.state === "locked" ? (
                node
              ) : n.state === "premium-locked" ? (
                <Link to="/subject/$subjectId" params={{ subjectId: n.id }} aria-label={n.nameFr}>
                  {node}
                </Link>
              ) : (
                <Link to="/parcours/$subjectId" params={{ subjectId: n.id }} aria-label={n.nameFr}>
                  {node}
                </Link>
              )}
            </TrackRow>
          );
        })}
        {nodes.length === 0 && (
          <p className="text-center text-sm text-muted-foreground">{t.parcours.empty}</p>
        )}
      </JourneyTrack>
    </div>
  );
}
