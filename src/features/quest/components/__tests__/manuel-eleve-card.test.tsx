import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    public: {
      subject: {
        manuelTitle: "Manuel officiel",
        manuelHint: "Le manuel élève officiel de cette matière, à consulter en ligne.",
        manuelOpen: "Ouvrir le manuel",
        manuelTome: "Tome {n}",
      },
    },
  }),
}));

import { ManuelEleveCard } from "../manuel-eleve-card";
import { parseManuelRefs } from "../../manuel-refs";
import { CNP_MANUEL_BASE_URL } from "@/shared/content/manuel-cnp";

describe("parseManuelRefs", () => {
  it("parses a valid volume list and normalizes labels", () => {
    expect(
      parseManuelRefs([{ code: "102306" }, { code: "102105P01", label: "الجزء الأول" }]),
    ).toEqual([
      { code: "102306", label: null },
      { code: "102105P01", label: "الجزء الأول" },
    ]);
  });

  it("rejects wholesale on any malformed entry (defensive)", () => {
    expect(parseManuelRefs(null)).toEqual([]);
    expect(parseManuelRefs({})).toEqual([]);
    expect(parseManuelRefs([{ code: "../evil" }])).toEqual([]);
    expect(parseManuelRefs([{ code: "102306" }, { nope: true }])).toEqual([]);
  });
});

describe("ManuelEleveCard", () => {
  it("renders nothing for a subject without manuel volumes", () => {
    const { container } = render(<ManuelEleveCard manuelRefs={null} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("links a single volume straight to the publisher's copy", () => {
    render(<ManuelEleveCard manuelRefs={[{ code: "102905" }]} />);
    const link = screen.getByTestId("manuel-eleve-tome");
    expect(link).toHaveAttribute("href", `${CNP_MANUEL_BASE_URL}/102905P00.pdf`);
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noopener noreferrer");
    expect(link).toHaveTextContent("Ouvrir le manuel");
  });

  it("needs no account and no data fetch — it renders outside any query provider", () => {
    // The card mounts no hook beyond useT: were it still fetching signed URLs,
    // rendering it without a QueryClientProvider would throw.
    render(<ManuelEleveCard manuelRefs={[{ code: "102905" }]} />);
    expect(screen.getByTestId("manuel-eleve-tome")).toBeInTheDocument();
    expect(screen.queryByTestId("manuel-eleve-locked")).not.toBeInTheDocument();
    expect(screen.queryByTestId("manuel-eleve-login")).not.toBeInTheDocument();
  });

  it("never writes the destination out — the reader sees a label, not an address", () => {
    const { container } = render(<ManuelEleveCard manuelRefs={[{ code: "102905" }]} />);
    expect(container.textContent).not.toMatch(/cnp\.com\.tn|https?:|\.pdf/i);
  });

  it("labels each volume of a multi-volume work", () => {
    render(
      <ManuelEleveCard
        manuelRefs={[
          { code: "102105P01", label: "الجزء الأوّل" },
          { code: "102105P02", label: "الجزء الثّاني" },
        ]}
      />,
    );
    const links = screen.getAllByTestId("manuel-eleve-tome");
    expect(links).toHaveLength(2);
    expect(links[0]).toHaveAttribute("href", `${CNP_MANUEL_BASE_URL}/102105P01.pdf`);
    expect(links[0]).toHaveTextContent("الجزء الأوّل");
    expect(links[1]).toHaveAttribute("href", `${CNP_MANUEL_BASE_URL}/102105P02.pdf`);
  });

  it("numbers unlabelled volumes rather than repeating the same wording", () => {
    render(<ManuelEleveCard manuelRefs={[{ code: "201202" }, { code: "201203" }]} />);
    const links = screen.getAllByTestId("manuel-eleve-tome");
    expect(links[0]).toHaveTextContent("Tome 1");
    expect(links[1]).toHaveTextContent("Tome 2");
  });

  it("renders nothing rather than a dead link when no URL can be built", () => {
    const { container } = render(<ManuelEleveCard manuelRefs={[{ code: "../evil" }]} />);
    expect(container).toBeEmptyDOMElement();
  });
});
