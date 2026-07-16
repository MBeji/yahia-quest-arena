import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";

const getManuels = vi.fn();

vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...rest }, children),
}));
vi.mock("../../manuel.server", () => ({
  getSubjectManuels: (...a: unknown[]) => getManuels(...a),
}));
vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    public: {
      subject: {
        manuelTitle: "Manuel officiel",
        manuelHint: "Le manuel élève officiel (CNP) de la matière, en PDF.",
        manuelOpen: "Ouvrir le manuel",
        manuelTome: "Tome {n}",
        manuelLockedHint: "Connecte-toi pour consulter le manuel officiel.",
        manuelLoginCta: "Se connecter",
      },
    },
  }),
}));

import { ManuelEleveCard } from "../manuel-eleve-card";
import { parseManuelRefs } from "../../manuel-refs";

function wrapper({ children }: { children: React.ReactNode }) {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return <QueryClientProvider client={qc}>{children}</QueryClientProvider>;
}

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
  beforeEach(() => getManuels.mockReset());

  it("renders nothing for a subject without manuel volumes", () => {
    const { container } = render(<ManuelEleveCard manuelRefs={null} isAuthenticated={false} />, {
      wrapper,
    });
    expect(container).toBeEmptyDOMElement();
    expect(getManuels).not.toHaveBeenCalled();
  });

  it("signed-in: renders one signed link per volume (labels for multi-volume)", async () => {
    getManuels.mockResolvedValue({
      manuels: [
        { code: "102105P01", label: "الجزء الأول", url: "https://signed/t1" },
        { code: "102105P02", label: "الجزء الثاني", url: "https://signed/t2" },
      ],
    });

    render(
      <ManuelEleveCard
        manuelRefs={[
          { code: "102105P01", label: "الجزء الأول" },
          { code: "102105P02", label: "الجزء الثاني" },
        ]}
        isAuthenticated
      />,
      { wrapper },
    );

    const links = await screen.findAllByTestId("manuel-eleve-tome");
    expect(links).toHaveLength(2);
    expect(links[0]).toHaveAttribute("href", "https://signed/t1");
    expect(links[0]).toHaveAttribute("target", "_blank");
    expect(links[1]).toHaveTextContent("الجزء الثاني");
    // The gated server fn got the parsed volume list in the TanStack envelope.
    expect(getManuels).toHaveBeenCalledWith({
      data: {
        manuels: [
          { code: "102105P01", label: "الجزء الأول" },
          { code: "102105P02", label: "الجزء الثاني" },
        ],
      },
    });
  });

  it("signed-in, single volume: the link carries the generic open label", async () => {
    getManuels.mockResolvedValue({
      manuels: [{ code: "102306", label: null, url: "https://signed/one" }],
    });

    render(<ManuelEleveCard manuelRefs={[{ code: "102306" }]} isAuthenticated />, { wrapper });

    const link = await screen.findByTestId("manuel-eleve-tome");
    expect(link).toHaveTextContent("Ouvrir le manuel");
  });

  it("signed-in: a volume whose PDF is missing renders inert (no dead link)", async () => {
    getManuels.mockResolvedValue({
      manuels: [{ code: "102306", label: null, url: "https://signed/one" }],
    });

    render(
      <ManuelEleveCard manuelRefs={[{ code: "102306" }, { code: "102407" }]} isAuthenticated />,
      { wrapper },
    );

    await screen.findByTestId("manuel-eleve-tome");
    expect(screen.getByTestId("manuel-eleve-tome-pending")).toBeInTheDocument();
  });

  it("anonymous: locked teaser + login link, and never fetches", async () => {
    render(<ManuelEleveCard manuelRefs={[{ code: "102306" }]} isAuthenticated={false} />, {
      wrapper,
    });

    expect(screen.getByTestId("manuel-eleve-locked")).toBeInTheDocument();
    expect(screen.getByTestId("manuel-eleve-login")).toHaveAttribute("href", "/auth");
    await waitFor(() => expect(getManuels).not.toHaveBeenCalled());
  });
});
