import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";

const getManuel = vi.fn();

vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("../../quest.server", () => ({
  getManuelPageUrls: (...a: unknown[]) => getManuel(...a),
}));
vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    public: {
      reader: {
        manuelTitle: "Pages du manuel",
        manuelHint: "Les pages du manuel élève.",
        manuelPage: "Page",
        manuelOpen: "Agrandir la page",
        manuelPrev: "Précédente",
        manuelNext: "Suivante",
      },
    },
  }),
}));

import { ManuelPagesSection } from "../manuel-pages-section";

function wrapper({ children }: { children: React.ReactNode }) {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return <QueryClientProvider client={qc}>{children}</QueryClientProvider>;
}

const CHAPTER_ID = "chapter-1";

describe("ManuelPagesSection", () => {
  beforeEach(() => getManuel.mockReset());

  it("renders a thumbnail per page and opens a lightbox on click", async () => {
    getManuel.mockResolvedValue({
      pages: [
        { page: 12, url: "https://signed/12" },
        { page: 13, url: "https://signed/13" },
      ],
    });

    render(<ManuelPagesSection chapterId={CHAPTER_ID} isAuthenticated />, { wrapper });

    const thumbs = await screen.findAllByTestId("manuel-thumb");
    expect(thumbs).toHaveLength(2);
    // The gated server fn is called with the TanStack `{ data }` envelope.
    expect(getManuel).toHaveBeenCalledWith({ data: { chapterId: CHAPTER_ID } });

    fireEvent.click(thumbs[0]);
    expect(await screen.findByRole("dialog")).toBeInTheDocument();
  });

  it("renders nothing for a chapter without manuel pages", async () => {
    getManuel.mockResolvedValue({ pages: [] });

    const { container } = render(<ManuelPagesSection chapterId={CHAPTER_ID} isAuthenticated />, {
      wrapper,
    });

    await waitFor(() => expect(getManuel).toHaveBeenCalled());
    expect(container).toBeEmptyDOMElement();
  });

  it("does not query for an anonymous reader (section stays hidden)", () => {
    render(<ManuelPagesSection chapterId={CHAPTER_ID} isAuthenticated={false} />, { wrapper });

    expect(getManuel).not.toHaveBeenCalled();
    expect(screen.queryByTestId("manuel-pages")).not.toBeInTheDocument();
  });
});
