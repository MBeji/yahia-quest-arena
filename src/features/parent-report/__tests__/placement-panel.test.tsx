import { render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";
import type { ReactNode } from "react";

const byStudent = vi.fn();
const byCode = vi.fn();
vi.mock("../parent-report.server", () => ({
  getStudentPlacementSummary: "by-student",
  getStudentPlacementSummaryByCode: "by-code",
}));
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: string) => (fn === "by-student" ? byStudent : byCode),
}));
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: "fr" }) }));
vi.mock("@/lib/i18n/parent", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/parent")>();
  return { ...actual, useParentT: () => actual.parentTranslations("fr") };
});

import { PlacementPanel } from "../components/placement-panel";

const summary = {
  tests: [
    {
      sessionId: "s1",
      subjectId: "math",
      subjectNameFr: "Mathématiques",
      gradeNameFr: "9ème année de base",
      finishedAt: "2026-11-20T11:41:01Z",
      correct: 6,
      total: 10,
      scoreOn20: 12,
      band: "en-route" as const,
      chaptersHeld: ["Valeur absolue"],
      chaptersToReview: ["Racines carrées"],
      scope: { throughTitle: "Racines carrées", chaptersInScope: 4, chaptersTotal: 20 },
    },
  ],
};

function wrap(children: ReactNode) {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return <QueryClientProvider client={client}>{children}</QueryClientProvider>;
}

beforeEach(() => {
  byStudent.mockReset();
  byCode.mockReset();
});

describe("PlacementPanel — au-dessus des onglets du rapport (2026-11-24)", () => {
  it("parent connecté : lit par l'élève lié et affiche le test", async () => {
    byStudent.mockResolvedValue(summary);
    render(wrap(<PlacementPanel source={{ kind: "student", studentId: "kid-1" }} />));
    await waitFor(() => expect(screen.getByTestId("report-placement")).toBeInTheDocument());
    expect(byStudent).toHaveBeenCalledWith({ data: { studentId: "kid-1" } });
    expect(byCode).not.toHaveBeenCalled();
  });

  it("/suivi : lit par le code d'alliance", async () => {
    byCode.mockResolvedValue(summary);
    render(wrap(<PlacementPanel source={{ kind: "code", studentCode: "abcd-1234-efgh" }} />));
    await waitFor(() => expect(screen.getByTestId("report-placement")).toBeInTheDocument());
    expect(byCode).toHaveBeenCalledWith({ data: { studentCode: "abcd-1234-efgh" } });
    expect(byStudent).not.toHaveBeenCalled();
  });

  it("aucun test ou panne : rien à l'écran", async () => {
    byStudent.mockResolvedValue(null);
    const { container } = render(
      wrap(<PlacementPanel source={{ kind: "student", studentId: "kid-2" }} />),
    );
    await waitFor(() => expect(byStudent).toHaveBeenCalled());
    expect(container).toBeEmptyDOMElement();
  });
});
