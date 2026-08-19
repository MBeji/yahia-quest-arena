import React from "react";
import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    public: {
      reader: {
        manuelBookTitle: "Manuel officiel",
        manuelBookHint: "Le manuel élève officiel de cette matière, à consulter en ligne.",
        manuelBookOpen: "Ouvrir le manuel",
        manuelBookTome: "Tome {n}",
        manuelBookPages: "p. {pages}",
      },
    },
  }),
}));

import { ManuelCnpCard } from "../manuel-cnp-card";
import { parseChapterManuelRef } from "../../manuel-refs";
import { CNP_MANUEL_BASE_URL } from "@/shared/content/manuel-cnp";

const chapterRef = { code: "102905", pages: "18-30", pageNumbers: [18, 19, 20] };

describe("parseChapterManuelRef", () => {
  it("parses the shape the build stores in chapters.manuel_ref", () => {
    expect(parseChapterManuelRef(chapterRef)).toEqual(chapterRef);
  });

  it("collapses anything malformed to null (defensive)", () => {
    expect(parseChapterManuelRef(null)).toBeNull();
    expect(parseChapterManuelRef([chapterRef])).toBeNull();
    expect(parseChapterManuelRef({ ...chapterRef, code: "../evil" })).toBeNull();
    expect(parseChapterManuelRef({ ...chapterRef, pages: "p. dix-huit" })).toBeNull();
    expect(parseChapterManuelRef({ ...chapterRef, pageNumbers: [] })).toBeNull();
    expect(parseChapterManuelRef({ ...chapterRef, pageNumbers: [0] })).toBeNull();
    expect(parseChapterManuelRef({ code: "102905" })).toBeNull();
  });
});

describe("ManuelCnpCard", () => {
  it("renders nothing when neither the chapter nor the subject names a manuel", () => {
    const { container } = render(<ManuelCnpCard manuelRef={null} subjectManuelRefs={null} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("links to the chapter's own pages, anchored on the first one", () => {
    render(<ManuelCnpCard manuelRef={chapterRef} subjectManuelRefs={[{ code: "999999" }]} />);
    const link = screen.getByTestId("manuel-cnp-link");
    expect(link).toHaveAttribute("href", `${CNP_MANUEL_BASE_URL}/102905P00.pdf#page=18`);
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noopener noreferrer");
    // The chapter ref wins over the subject's volume list.
    expect(screen.getAllByTestId("manuel-cnp-link")).toHaveLength(1);
    expect(link).toHaveTextContent("Ouvrir le manuel");
    expect(link).toHaveTextContent("p. 18-30");
  });

  it("never writes the destination out — the reader sees a label, not an address", () => {
    const { container } = render(<ManuelCnpCard manuelRef={chapterRef} subjectManuelRefs={null} />);
    expect(container.textContent).not.toMatch(/cnp\.com\.tn|https?:|\.pdf/i);
  });

  it("needs no account: the link is there without an isAuthenticated prop at all", () => {
    render(<ManuelCnpCard manuelRef={chapterRef} subjectManuelRefs={null} />);
    expect(screen.getByTestId("manuel-cnp-link")).toBeInTheDocument();
    expect(screen.queryByText(/connecte-toi/i)).not.toBeInTheDocument();
  });

  it("falls back to the subject's volumes, at the cover, when the chapter has none", () => {
    render(
      <ManuelCnpCard
        manuelRef={null}
        subjectManuelRefs={[
          { code: "102105P01", label: "الجزء الأول" },
          { code: "102105P02", label: "الجزء الثاني" },
        ]}
      />,
    );
    const links = screen.getAllByTestId("manuel-cnp-link");
    expect(links).toHaveLength(2);
    expect(links[0]).toHaveAttribute("href", `${CNP_MANUEL_BASE_URL}/102105P01.pdf`);
    expect(links[0]).toHaveTextContent("الجزء الأول");
    expect(links[1]).toHaveAttribute("href", `${CNP_MANUEL_BASE_URL}/102105P02.pdf`);
    // No page range to show when the link opens at the cover.
    expect(links[0].textContent).not.toMatch(/p\./);
  });

  it("numbers unlabelled volumes rather than repeating the same wording", () => {
    render(
      <ManuelCnpCard
        manuelRef={null}
        subjectManuelRefs={[{ code: "201202" }, { code: "201203" }]}
      />,
    );
    const links = screen.getAllByTestId("manuel-cnp-link");
    expect(links[0]).toHaveTextContent("Tome 1");
    expect(links[1]).toHaveTextContent("Tome 2");
  });

  it("drops a volume whose code cannot become a file name instead of dead-linking", () => {
    const { container } = render(
      <ManuelCnpCard manuelRef={{ ...chapterRef, code: "102905" }} subjectManuelRefs={null} />,
    );
    expect(container.querySelectorAll('[data-testid="manuel-cnp-link"]')).toHaveLength(1);

    const { container: empty } = render(
      <ManuelCnpCard manuelRef={null} subjectManuelRefs={[{ code: "../evil" }]} />,
    );
    expect(empty).toBeEmptyDOMElement();
  });
});
