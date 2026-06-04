import { Link } from "@tanstack/react-router";
import { ArrowLeft } from "lucide-react";
import { useT } from "@/lib/i18n";
import { JourneyHeader } from "./journey-header";
import { JourneyTrack, TrackRow } from "./journey-track";
import { PathNode } from "./path-node";
import { nodeSide, type ChapterNode } from "../journey";

export type SubjectPathProps = {
  subjectName: string;
  chapters: ChapterNode[];
  profile: { level: number; xp: number; heroClass: string };
};

/** A subject's chapter path (the zigzag of stages within one subject). */
export function SubjectPath({ subjectName, chapters, profile }: SubjectPathProps) {
  const t = useT();

  return (
    <div className="mx-auto max-w-3xl px-6 py-8">
      <Link
        to="/parcours"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.parcours.backToMap}
      </Link>

      <JourneyHeader
        title={subjectName}
        level={profile.level}
        xp={profile.xp}
        heroClass={profile.heroClass}
      />
      <JourneyTrack>
        {chapters.map((c, i) => {
          const sublabel =
            c.state === "locked"
              ? t.parcours.lockedHint
              : `${c.completed}/${c.total} · ${c.xpReward} ${t.parcours.xpToEarn}`;
          const node = (
            <PathNode
              state={c.state}
              title={c.title}
              sublabel={sublabel}
              badge={c.hasPremium ? t.parcours.premium : undefined}
              icon="BookOpen"
              clickable={c.state !== "locked"}
            />
          );
          return (
            <TrackRow key={c.id} side={nodeSide(i)} index={i}>
              {c.state === "locked" ? (
                node
              ) : (
                <Link to="/lesson/$chapterId" params={{ chapterId: c.id }} aria-label={c.title}>
                  {node}
                </Link>
              )}
            </TrackRow>
          );
        })}
        {chapters.length === 0 && (
          <p className="text-center text-sm text-muted-foreground">{t.parcours.empty}</p>
        )}
      </JourneyTrack>
    </div>
  );
}
