import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import { Inbox } from "lucide-react";

import { PageShell } from "@/components/ui/page-shell";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { BackLink } from "@/components/ui/back-link";

// BackLink wraps the router Link; a real router is irrelevant to what we
// assert (classes, RTL icon flip), so Link renders as a plain anchor.
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    className,
    to,
  }: {
    children: React.ReactNode;
    className?: string;
    to: string;
  }) => (
    <a className={className} href={to}>
      {children}
    </a>
  ),
}));

describe("PageShell", () => {
  it("applies the reading gabarit by default with uniform padding", () => {
    const { container } = render(<PageShell>content</PageShell>);
    const shell = container.firstElementChild!;
    expect(shell.className).toContain("max-w-3xl");
    expect(shell.className).toContain("mx-auto");
    expect(shell.className).toContain("px-4");
  });

  it("supports the narrow and wide gabarits", () => {
    const { container: narrow } = render(<PageShell width="narrow">x</PageShell>);
    expect(narrow.firstElementChild!.className).toContain("max-w-2xl");
    const { container: wide } = render(<PageShell width="wide">x</PageShell>);
    expect(wide.firstElementChild!.className).toContain("max-w-6xl");
  });
});

describe("BackLink", () => {
  it("renders a link with the standard idiom and an RTL-flipped arrow", () => {
    render(<BackLink to="/dashboard">Retour</BackLink>);
    const link = screen.getByRole("link", { name: "Retour" });
    expect(link.className).toContain("min-h-11");
    expect(link.querySelector("svg")?.getAttribute("class")).toContain("rtl:-scale-x-100");
  });

  it("lets the page override the default margin", () => {
    render(
      <BackLink to="/dashboard" className="mb-0">
        Retour
      </BackLink>,
    );
    expect(screen.getByRole("link", { name: "Retour" }).className).toContain("mb-0");
  });
});

describe("EmptyState", () => {
  it("renders title, description, icon and action", () => {
    render(
      <EmptyState
        icon={Inbox}
        title="Aucun badge"
        description="Termine une quête pour en gagner."
        action={<button>Explorer</button>}
      />,
    );
    expect(screen.getByText("Aucun badge")).toBeInTheDocument();
    expect(screen.getByText("Termine une quête pour en gagner.")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Explorer" })).toBeInTheDocument();
  });

  it("renders with only a title", () => {
    const { container } = render(<EmptyState title="Rien ici" />);
    expect(screen.getByText("Rien ici")).toBeInTheDocument();
    expect(container.querySelector("svg")).toBeNull();
  });
});

describe("LoadingState", () => {
  it("announces itself as a status with the label", () => {
    render(<LoadingState label="Chargement…" />);
    const status = screen.getByRole("status");
    expect(status).toHaveTextContent("Chargement…");
    expect(status.querySelector("svg")?.getAttribute("class")).toContain("animate-spin");
  });
});
