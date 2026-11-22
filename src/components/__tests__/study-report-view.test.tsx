/**
 * Le bilan complet et son geste « chapitres vus en classe ».
 *
 * Ce que ces tests protègent : cocher répond tout de suite (optimiste), puis le SERVEUR est
 * relu — c'est lui qui recompose le programme ; et un refus remet l'écran dans l'état d'avant
 * en le disant.
 */
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import React from "react";
import { describe, expect, it, vi } from "vitest";

import { report } from "@/shared/lib/__tests__/study-report.fixture";
import type { StudyReport } from "@/shared/lib/study-report";

vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: "fr" }) }));
vi.mock("@/lib/i18n/study", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/study")>();
  return { ...actual, useStudyT: () => actual.studyTranslations("fr") };
});
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { StudyReportView } from "../study-report/study-report-view";

const KEY = ["study-report-test"] as const;

function setup(
  save: (subjectId: string, chapterIds: string[]) => Promise<unknown>,
  savePreferences?: (prefs: {
    dailyMinutes?: number;
    focusSubjectIds?: string[];
  }) => Promise<unknown>,
) {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  client.setQueryData(KEY, report());
  const invalidate = vi.spyOn(client, "invalidateQueries");

  function Harness() {
    const data = client.getQueryData<StudyReport>(KEY) ?? report();
    return (
      <StudyReportView
        report={data}
        audience="student"
        queryKey={KEY}
        save={save}
        savePreferences={savePreferences}
        alsoInvalidate={[["dashboard"]]}
      />
    );
  }
  render(
    <QueryClientProvider client={client}>
      <Harness />
    </QueryClientProvider>,
  );
  return { client, invalidate };
}

describe("StudyReportView", () => {
  it("rend le programme puis le bilan par matière", () => {
    setup(vi.fn().mockResolvedValue(undefined));
    expect(screen.getByTestId("study-plan-card")).toBeInTheDocument();
    expect(screen.getByTestId("study-subjects")).toBeInTheDocument();
  });

  it("cocher : mise à jour immédiate, écriture, puis relecture du serveur", async () => {
    const save = vi.fn().mockResolvedValue({ count: 4 });
    const { client, invalidate } = setup(save);

    fireEvent.click(screen.getAllByRole("checkbox")[3]!);

    await waitFor(() => expect(save).toHaveBeenCalledWith("math", ["c1", "c2", "c3", "c4"]));
    expect(client.getQueryData<StudyReport>(KEY)?.subjects[0]?.chaptersSeen).toBe(4);
    await waitFor(() => expect(invalidate).toHaveBeenCalledWith({ queryKey: KEY }));
    expect(invalidate).toHaveBeenCalledWith({ queryKey: ["dashboard"] });
  });

  it("refus : l'état d'avant revient", async () => {
    const save = vi.fn().mockRejectedValue(new Error("non"));
    const { client } = setup(save);

    fireEvent.click(screen.getAllByRole("checkbox")[3]!);

    await waitFor(() => expect(save).toHaveBeenCalled());
    await waitFor(() =>
      expect(client.getQueryData<StudyReport>(KEY)?.subjects[0]?.chaptersSeen).toBe(3),
    );
  });

  it("sans écriture des réglages, ni objectif ni priorité à régler", () => {
    setup(vi.fn().mockResolvedValue(undefined));
    expect(screen.queryByTestId("study-target")).not.toBeInTheDocument();
    expect(screen.queryByTestId("study-focus-toggle")).not.toBeInTheDocument();
  });

  it("régler l'objectif : mise à jour immédiate, écriture, relecture", async () => {
    const savePreferences = vi.fn().mockResolvedValue({ ok: true });
    const { client, invalidate } = setup(vi.fn(), savePreferences);

    fireEvent.click(screen.getByRole("button", { name: "60 min" }));

    await waitFor(() => expect(savePreferences).toHaveBeenCalledWith({ dailyMinutes: 60 }));
    expect(client.getQueryData<StudyReport>(KEY)?.targetMinutes).toBe(60);
    await waitFor(() => expect(invalidate).toHaveBeenCalledWith({ queryKey: ["dashboard"] }));
  });

  it("rendre une matière prioritaire, puis refus : l'état d'avant revient", async () => {
    const savePreferences = vi.fn().mockRejectedValue(new Error("non"));
    const { client } = setup(vi.fn(), savePreferences);

    fireEvent.click(screen.getByTestId("study-focus-toggle"));

    await waitFor(() =>
      expect(savePreferences).toHaveBeenCalledWith({ focusSubjectIds: ["math"] }),
    );
    await waitFor(() =>
      expect(client.getQueryData<StudyReport>(KEY)?.subjects[0]?.focus).toBeUndefined(),
    );
  });
});
