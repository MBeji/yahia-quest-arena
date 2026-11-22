/**
 * La section « Bilan et programme » du suivi parental : elle porte SA lecture, rend le
 * composant que l'élève voit, et disparaît sans bruit quand le bilan n'arrive pas.
 */
import { render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { report } from "@/shared/lib/__tests__/study-report.fixture";

const query = vi.hoisted(() => ({ data: undefined as unknown, key: undefined as unknown }));
vi.mock("@tanstack/react-query", () => ({
  useQuery: (opts: { queryKey: unknown }) => {
    query.key = opts.queryKey;
    return { data: query.data };
  },
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("../parent-report.server", () => ({
  getStudentStudyReport: vi.fn(),
  setStudentClassChapters: vi.fn(),
  setStudentStudyPreferences: vi.fn(),
}));
vi.mock("@/lib/i18n/study", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/study")>();
  return { ...actual, useStudyT: () => actual.studyTranslations("fr") };
});
const view = vi.hoisted(() => ({ props: undefined as unknown }));
vi.mock("@/components/study-report/study-report-view", () => ({
  StudyReportView: (props: unknown) => {
    view.props = props;
    return <div data-testid="view" />;
  },
}));

import { StudyReportSection } from "../components/study-report-section";

beforeEach(() => {
  query.data = undefined;
  view.props = undefined;
});

describe("StudyReportSection", () => {
  it("rend le bilan de l'enfant, côté parent, sous sa propre clé de lecture", () => {
    query.data = report();
    render(<StudyReportSection studentId="s-1" />);
    expect(screen.getByTestId("report-study")).toHaveTextContent("Bilan et programme");
    expect(query.key).toEqual(["parent-study-report", "s-1"]);
    expect(view.props).toMatchObject({
      audience: "parent",
      queryKey: ["parent-study-report", "s-1"],
    });
  });

  it("ne rend rien tant que le bilan manque (chargement, refus, panne)", () => {
    query.data = null;
    const { container } = render(<StudyReportSection studentId="s-1" />);
    expect(container).toBeEmptyDOMElement();
  });
});
