import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

const MOCK_REPORTS = [
  {
    id: "r1",
    message: "err A",
    status: "open",
    createdAt: "2026-07-14T00:00:00Z",
    exerciseId: "ex1",
    exerciseTitle: "Fractions",
    subjectId: "s-math",
    questionId: null,
  },
  {
    id: "r2",
    message: "err B",
    status: "open",
    createdAt: "2026-07-14T00:00:00Z",
    exerciseId: "ex1",
    exerciseTitle: "Fractions",
    subjectId: "s-math",
    questionId: null,
  },
  {
    id: "r3",
    message: "err C",
    status: "open",
    createdAt: "2026-07-14T00:00:00Z",
    exerciseId: "ex2",
    exerciseTitle: "Pythagore",
    subjectId: "s-math",
    questionId: null,
  },
];

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
  }) =>
    React.createElement(
      "a",
      { href: params ? to.replace(/\$(\w+)/g, (_m, k: string) => params[k] ?? `$${k}`) : to },
      children,
    ),
}));
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: (fn: unknown) => fn,
    };
    return chain;
  },
}));
vi.mock("@tanstack/react-query", () => ({
  useQuery: () => ({ data: { reports: MOCK_REPORTS }, isLoading: false, isError: false }),
  useMutation: () => ({ mutate: vi.fn(), isPending: false }),
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));
vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));
vi.mock("@/shared/lib/utils", () => ({ isRtlText: () => false }));
const t = new Proxy(
  {},
  { get: (_o, k1) => new Proxy({}, { get: (_o2, k2) => `${String(k1)}.${String(k2)}` }) },
);
vi.mock("@/lib/i18n", () => ({ useT: () => t }));

import { ContentReportsAdmin } from "../components/content-reports-admin";

describe("ContentReportsAdmin — grouping + deep-links (étude 15 lot 13, D-10)", () => {
  it("clusters reports by target and links each group to its content", () => {
    const { container } = render(<ContentReportsAdmin />);
    // Two targets (ex1 with 2 reports, ex2 with 1) → 2 group headers, each linked.
    expect(screen.getByText("Fractions")).toBeInTheDocument();
    expect(screen.getByText("Pythagore")).toBeInTheDocument();
    expect(container.querySelectorAll('a[href="/matiere/s-math"]')).toHaveLength(2);
    // Every individual report message is still shown for triage.
    expect(screen.getByText("err A")).toBeInTheDocument();
    expect(screen.getByText("err B")).toBeInTheDocument();
    expect(screen.getByText("err C")).toBeInTheDocument();
  });
});
