import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/shared/lib/analytics", () => ({ trackVideoOpen: vi.fn() }));
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

import { ChapterVideosSection } from "../chapter-videos-section";
import type { CompiledVideo } from "../video-embed";

const mk = (n: number): CompiledVideo => ({
  id: `math.v${n}`,
  provider: "youtube",
  videoId: `AbCdEfGhIj${n}`,
  title: `Vidéo ${n}`,
  channel: "Chaîne",
  lang: "fr",
  durationSec: 300,
});

describe("ChapterVideosSection", () => {
  it("renders nothing when there is no video", () => {
    const { container } = render(<ChapterVideosSection videos={[]} subjectId="math-9eme" />);
    expect(container.firstChild).toBeNull();
  });

  it("renders one facade per video, in order, under the section title", () => {
    render(<ChapterVideosSection videos={[mk(1), mk(2), mk(3)]} subjectId="math-9eme" />);
    expect(screen.getByRole("heading", { name: "En vidéo" })).toBeInTheDocument();
    const facades = screen.getAllByTestId("video-facade");
    expect(facades).toHaveLength(3);
    expect(facades[0]).toHaveAttribute("aria-label", expect.stringContaining("Vidéo 1"));
    expect(facades[2]).toHaveAttribute("aria-label", expect.stringContaining("Vidéo 3"));
  });

  it("plays only one video at a time — opening a second unloads the first", () => {
    const { container } = render(
      <ChapterVideosSection videos={[mk(1), mk(2)]} subjectId="math-9eme" />,
    );
    fireEvent.click(screen.getAllByTestId("video-facade")[0]);
    expect(container.querySelectorAll("iframe")).toHaveLength(1);
    expect(container.querySelector("iframe")!.getAttribute("src")).toContain("AbCdEfGhIj1");

    // Opening the second facade replaces the first iframe (single active).
    fireEvent.click(screen.getByTestId("video-facade"));
    expect(container.querySelectorAll("iframe")).toHaveLength(1);
    expect(container.querySelector("iframe")!.getAttribute("src")).toContain("AbCdEfGhIj2");
  });
});
