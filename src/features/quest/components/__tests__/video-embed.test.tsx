import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, afterEach } from "vitest";

const trackVideoOpen = vi.fn();
vi.mock("@/shared/lib/analytics", () => ({
  trackVideoOpen: (...a: unknown[]) => trackVideoOpen(...a),
}));
vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    public: {
      reader: {
        videoSectionTitle: "En vidéo",
        videoPlay: "Regarder : {title} ({m} min)",
        videoHostedBy: "Vidéo hébergée par {host}",
        videoDuration: "{m} min",
        videoLoadHint: "En appuyant, tu charges une vidéo YouTube (Google).",
      },
    },
  }),
}));

import { VideoEmbed, type CompiledVideo } from "../video-embed";

const video: CompiledVideo = {
  id: "math.thales-configuration",
  provider: "youtube",
  videoId: "AbCdEfGhIjK",
  title: "Théorème de Thalès",
  channel: "Maths et tiques",
  lang: "fr",
  durationSec: 480,
};

afterEach(() => {
  trackVideoOpen.mockReset();
  document.querySelector('link[data-video-preconnect="youtube"]')?.remove();
});

describe("VideoEmbed — privacy facade invariant", () => {
  it("renders NO iframe and NO third-party URL before the click (poster is local)", () => {
    const { container } = render(
      <VideoEmbed video={video} context="lesson" subjectId="math-9eme" />,
    );
    expect(container.querySelector("iframe")).toBeNull();
    expect(container.innerHTML).not.toContain("youtube-nocookie");
    expect(container.innerHTML).not.toContain("youtube.com");
    expect(container.innerHTML).not.toContain("ytimg");
    const img = container.querySelector("img");
    expect(img?.getAttribute("src")).toBe("/video-posters/math.thales-configuration.jpg");
    expect(img?.getAttribute("loading")).toBe("lazy");
  });

  it("exposes an aria-label with the title and duration, and a hosting attribution", () => {
    render(<VideoEmbed video={video} context="lesson" subjectId="math-9eme" />);
    expect(screen.getByRole("button")).toHaveAttribute(
      "aria-label",
      "Regarder : Théorème de Thalès (8 min)",
    );
    expect(screen.getByText(/Vidéo hébergée par YouTube/)).toBeInTheDocument();
  });

  it("mounts the youtube-nocookie iframe with the exact params after the click", () => {
    const { container } = render(
      <VideoEmbed video={video} context="lesson" subjectId="math-9eme" />,
    );
    fireEvent.click(screen.getByTestId("video-facade"));
    const iframe = container.querySelector("iframe");
    expect(iframe).not.toBeNull();
    const src = iframe!.getAttribute("src")!;
    expect(src.startsWith("https://www.youtube-nocookie.com/embed/AbCdEfGhIjK?")).toBe(true);
    expect(src).toContain("autoplay=1");
    expect(src).toContain("rel=0");
    expect(src).toContain("playsinline=1");
    expect(src).toContain("hl=fr");
    expect(src).not.toContain("start=");
    expect(src).not.toContain("enablejsapi");
    expect(iframe!.getAttribute("title")).toBe("Théorème de Thalès");
    expect(iframe).not.toHaveAttribute("referrerpolicy");
  });

  it("emits start/end when the entry defines an extract", () => {
    const { container } = render(
      <VideoEmbed
        video={{ ...video, startSec: 60, endSec: 180 }}
        context="lesson"
        subjectId="math-9eme"
      />,
    );
    fireEvent.click(screen.getByTestId("video-facade"));
    const src = container.querySelector("iframe")!.getAttribute("src")!;
    expect(src).toContain("start=60");
    expect(src).toContain("end=180");
  });

  it("fires the video_open analytics event on open", () => {
    render(<VideoEmbed video={video} context="result" subjectId="math-9eme" />);
    fireEvent.click(screen.getByTestId("video-facade"));
    expect(trackVideoOpen).toHaveBeenCalledWith({
      videoId: "AbCdEfGhIjK",
      context: "result",
      subjectId: "math-9eme",
    });
  });

  it("degrades to a poster-less facade when the local image is missing", () => {
    const { container } = render(
      <VideoEmbed video={video} context="lesson" subjectId="math-9eme" />,
    );
    fireEvent.error(container.querySelector("img")!);
    expect(container.querySelector("img")).toBeNull();
    // Still a working facade — the button and its label survive.
    expect(screen.getByTestId("video-facade")).toBeInTheDocument();
  });

  it("renders nothing for a videoId that fails the provider regex (defense in depth)", () => {
    const { container } = render(
      <VideoEmbed
        video={{ ...video, videoId: "not-valid" }}
        context="lesson"
        subjectId="math-9eme"
      />,
    );
    expect(container.firstChild).toBeNull();
  });

  it("warms up the embed host with a preconnect link on first hover only", () => {
    render(<VideoEmbed video={video} context="lesson" subjectId="math-9eme" />);
    expect(document.querySelector('link[data-video-preconnect="youtube"]')).toBeNull();
    fireEvent.mouseEnter(screen.getByTestId("video-facade"));
    const links = document.querySelectorAll('link[data-video-preconnect="youtube"]');
    expect(links.length).toBe(1);
    expect(links[0].getAttribute("href")).toBe("https://www.youtube-nocookie.com");
    fireEvent.mouseEnter(screen.getByTestId("video-facade"));
    expect(document.querySelectorAll('link[data-video-preconnect="youtube"]').length).toBe(1);
  });

  it("keeps the video title in a dir=auto node (RTL-safe)", () => {
    render(<VideoEmbed video={video} context="lesson" subjectId="math-9eme" />);
    const title = screen.getByText("Théorème de Thalès");
    expect(title).toHaveAttribute("dir", "auto");
  });
});
