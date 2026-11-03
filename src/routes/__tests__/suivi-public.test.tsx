import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import type React from "react";

/**
 * Étude 38 lot 1 (R-14) — `/suivi` renvoie le parent CONNECTÉ sur son espace, sauf quand le lien
 * porte un code.
 *
 * Le hook a ses propres tests (qui part, qui reste). Ici on prouve le câblage de la route : la
 * demande précise d'un lien partagé `/suivi?code=…` la garde, et le visiteur garde sa page.
 */
const hold = vi.hoisted(() => ({ search: {} as { code?: string } }));
const redirect = vi.hoisted(() => vi.fn());

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useSearch: () => hold.search,
    useNavigate: () => vi.fn(),
  }),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@tanstack/react-query", () => ({
  useMutation: () => ({
    mutate: vi.fn(),
    reset: vi.fn(),
    data: undefined,
    variables: undefined,
    error: null,
    isPending: false,
    isError: false,
    isSuccess: false,
  }),
}));
vi.mock("@/features/auth", () => ({
  useRedirectConnectedParent: (options: { enabled: boolean }) => redirect(options),
}));
vi.mock("@/features/parent-report", () => ({
  buildFamilyReportShareText: vi.fn(),
  DailyDashboard: () => null,
  forgetRememberedCode: vi.fn(),
  getStudentReportByCode: vi.fn(),
  parentCodeErrorLabel: vi.fn(),
  readRememberedCode: () => null,
  rememberCode: vi.fn(),
  ReportContent: () => null,
}));
vi.mock("@/components/guide/guide-intro-card", () => ({ GuideIntroCard: () => null }));

import { Route } from "../_public/suivi";

const Page = (Route as unknown as { component: React.ComponentType }).component;

describe("/suivi — le parent connecté a son espace (é38 lot 1, R-14)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    hold.search = {};
  });

  it("sans code dans le lien, la redirection du parent connecté est armée", () => {
    render(<Page />);

    expect(redirect).toHaveBeenCalledWith({ enabled: true });
  });

  it("avec un code dans le lien, elle est désarmée : le lien vise CE bilan, la page le sert", () => {
    hold.search = { code: "ABCD1234" };
    render(<Page />);

    expect(redirect).toHaveBeenCalledWith({ enabled: false });
    expect(redirect).not.toHaveBeenCalledWith({ enabled: true });
  });

  it("le visiteur garde sa page : le formulaire de code est là", () => {
    render(<Page />);

    expect(screen.getByRole("textbox")).toBeInTheDocument();
  });
});
