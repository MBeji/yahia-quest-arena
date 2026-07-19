import { useRef, useState } from "react";
import { Play } from "lucide-react";
import { useT } from "@/lib/i18n";
import { trackVideoOpen, type VideoOpenContext } from "@/shared/lib/analytics";
import type { CompiledVideo } from "@/shared/content/schema";

export type { CompiledVideo };

/** The privacy-enhanced YouTube embed host (étude 23 R-5): zero cookie before Play. */
const YT_EMBED_HOST = "https://www.youtube-nocookie.com";
/** Defense in depth (D-10): the schema already guarantees this shape. */
const YOUTUBE_ID = /^[A-Za-z0-9_-]{11}$/;

/** Warm up the TLS connection to the embed host on first intent — zero data. */
function preconnect(): void {
  if (typeof document === "undefined") return;
  if (document.querySelector('link[data-video-preconnect="youtube"]')) return;
  const link = document.createElement("link");
  link.rel = "preconnect";
  link.href = YT_EMBED_HOST;
  link.setAttribute("data-video-preconnect", "youtube");
  document.head.appendChild(link);
}

/** Build the embed URL by template from validated fields (never from raw data — D-10). */
function embedSrc(video: CompiledVideo): string {
  const params = new URLSearchParams({
    autoplay: "1", // the iframe is born from the Play click, so this is an interaction-gated autoplay (R-5)
    rel: "0", // suggestions limited to the same channel (since 2018)
    playsinline: "1", // iOS: play in place, not fullscreen
    hl: video.lang,
  });
  if (video.startSec !== undefined) params.set("start", String(video.startSec));
  if (video.endSec !== undefined) params.set("end", String(video.endSec));
  return `${YT_EMBED_HOST}/embed/${video.videoId}?${params.toString()}`;
}

/**
 * A single curated explainer video (étude 23), rendered as a privacy facade:
 * before the click NOTHING is loaded from YouTube — the poster is a LOCAL image
 * (`/video-posters/<id>.jpg`, D-11) with a styled fallback, and no iframe exists
 * in the DOM (R-4). The click mounts the `youtube-nocookie` iframe in place
 * (16:9 reserved → zero CLS) and emits the `video_open` analytics event.
 *
 * Open state is controlled when `onOpen` is provided (the lesson section enforces
 * "one active at a time"); otherwise the component manages its own (result screen).
 * The whole facade is RTL-safe: layout follows the ambient `dir`, and the play
 * glyph is direction-independent.
 */
export function VideoEmbed({
  video,
  context,
  subjectId,
  isOpen: isOpenProp,
  onOpen,
}: {
  video: CompiledVideo;
  context: VideoOpenContext;
  subjectId: string;
  isOpen?: boolean;
  onOpen?: () => void;
}) {
  const t = useT();
  const [internalOpen, setInternalOpen] = useState(false);
  const [posterFailed, setPosterFailed] = useState(false);
  const preconnected = useRef(false);
  const iframeRef = useRef<HTMLIFrameElement>(null);

  // Defense in depth: an id that does not match the provider regex renders
  // nothing (the schema already guaranteed it upstream — this is belt & braces).
  if (video.provider !== "youtube" || !YOUTUBE_ID.test(video.videoId)) return null;

  const controlled = onOpen !== undefined;
  const isOpen = controlled ? !!isOpenProp : internalOpen;

  const minutes = Math.max(1, Math.round(video.durationSec / 60));
  const durationLabel = t.public.reader.videoDuration.replace("{m}", String(minutes));
  const playLabel = t.public.reader.videoPlay
    .replace("{title}", video.title)
    .replace("{m}", String(minutes));

  const warmUp = () => {
    if (preconnected.current) return;
    preconnected.current = true;
    preconnect();
  };

  const open = () => {
    if (isOpen) return;
    if (controlled) onOpen?.();
    else setInternalOpen(true);
    trackVideoOpen({ videoId: video.videoId, context, subjectId });
  };

  if (isOpen) {
    return (
      <div className="relative aspect-video w-full overflow-hidden rounded-xl bg-black">
        <iframe
          ref={iframeRef}
          src={embedSrc(video)}
          title={video.title}
          allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
          allowFullScreen
          className="absolute inset-0 h-full w-full border-0"
        />
      </div>
    );
  }

  return (
    <button
      type="button"
      onClick={open}
      onMouseEnter={warmUp}
      onTouchStart={warmUp}
      onFocus={warmUp}
      aria-label={playLabel}
      data-testid="video-facade"
      className="group relative block aspect-video w-full overflow-hidden rounded-xl bg-muted text-start ring-1 ring-border transition hover:ring-primary focus:outline-none focus-visible:ring-2 focus-visible:ring-primary"
    >
      {!posterFailed ? (
        <img
          src={`/video-posters/${video.id}.jpg`}
          alt=""
          loading="lazy"
          onError={() => setPosterFailed(true)}
          className="absolute inset-0 h-full w-full object-cover"
        />
      ) : (
        <span
          aria-hidden="true"
          className="absolute inset-0 bg-gradient-to-br from-primary/25 to-primary/5"
        />
      )}

      {/* token-ok-block: overlay posé sur un poster/scrim NOIR fixe (vidéo) —
          le blanc est correct dans les deux thèmes, indépendant du token. */}
      {/* Play glyph — centered, direction-independent. */}
      <span aria-hidden="true" className="absolute inset-0 flex items-center justify-center">
        <span className="flex h-14 w-14 items-center justify-center rounded-full bg-black/60 text-white shadow-lg transition group-hover:scale-105 group-hover:bg-black/70">
          <Play className="h-6 w-6 translate-x-[1px]" fill="currentColor" />
        </span>
      </span>

      {/* Duration badge — top corner, Western digits. */}
      <span className="absolute top-2 end-2 rounded-md bg-black/70 px-1.5 py-0.5 text-xs font-medium text-white">
        {durationLabel}
      </span>

      {/* Caption: title + channel + hosting attribution + child-readable consent hint. */}
      <span className="absolute inset-x-0 bottom-0 flex flex-col gap-0.5 bg-gradient-to-t from-black/80 to-transparent p-3 pt-8 text-white">
        <span className="line-clamp-2 text-sm font-semibold" dir="auto">
          {video.title}
        </span>
        <span className="text-xs opacity-90" dir="auto">
          {video.channel}
        </span>
        <span className="text-[11px] opacity-80">
          {t.public.reader.videoHostedBy.replace("{host}", "YouTube")} ·{" "}
          {t.public.reader.videoLoadHint}
        </span>
      </span>
      {/* /token-ok-block */}
    </button>
  );
}
