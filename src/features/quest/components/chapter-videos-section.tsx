import { useState } from "react";
import { Clapperboard } from "lucide-react";
import { useT } from "@/lib/i18n";
import { VideoEmbed, type CompiledVideo } from "./video-embed";

/**
 * The « En vidéo » section under the course (étude 23): 1–3 curated explainer
 * videos, each a privacy facade (nothing loads from YouTube before a click).
 * Only ONE video plays at a time — clicking a second facade unloads the first.
 * Renders nothing when the chapter has no video (no placeholder). Hidden in
 * print. Section chrome is UI-localised; each video's title/channel is content
 * data shown with `dir="auto"`.
 */
export function ChapterVideosSection({
  videos,
  subjectId,
}: {
  videos: CompiledVideo[];
  subjectId: string;
}) {
  const t = useT();
  const [activeId, setActiveId] = useState<string | null>(null);

  if (videos.length === 0) return null;

  return (
    <section className="mt-10 print:hidden" data-testid="chapter-videos">
      <h2 className="mb-4 flex items-center gap-2 text-lg font-semibold text-foreground">
        <Clapperboard className="h-5 w-5 text-primary" aria-hidden="true" />
        {t.public.reader.videoSectionTitle}
      </h2>
      <div className="grid gap-4 sm:grid-cols-2">
        {videos.map((video) => (
          <VideoEmbed
            key={video.id}
            video={video}
            context="lesson"
            subjectId={subjectId}
            isOpen={activeId === video.id}
            onOpen={() => setActiveId(video.id)}
          />
        ))}
      </div>
    </section>
  );
}
