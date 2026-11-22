import { useState } from "react";
import { useMutation, useQueryClient, type QueryKey } from "@tanstack/react-query";

import {
  withSeenChapters,
  withStudyPreferences,
  type StudyReport,
} from "@/shared/lib/study-report";
import { StudyPlanCard } from "./study-plan-card";
import { StudySubjects } from "./study-subjects";

type StudyPreferences = { dailyMinutes?: number; focusSubjectIds?: string[] };

/**
 * Le bilan complet — programme du jour, puis matière par matière — et le geste « chapitres vus
 * en classe ». Servi tel quel à l'élève (`/bilan`) et à son parent (suivi parental) : chacun
 * apporte SA lecture (`queryKey`) et SON écriture (`save`), ce composant ne connaît ni l'une ni
 * l'autre feature.
 *
 * Cocher est optimiste : la case répond tout de suite, le serveur est relu ensuite — c'est lui
 * qui recompose le programme, jamais l'écran.
 */
export function StudyReportView({
  report,
  audience,
  queryKey,
  save,
  savePreferences,
  alsoInvalidate = [],
}: {
  report: StudyReport;
  audience: "student" | "parent";
  /** La clé de la lecture qui a fourni `report` — c'est elle qu'on met à jour et qu'on relit. */
  queryKey: QueryKey;
  save: (subjectId: string, chapterIds: string[]) => Promise<unknown>;
  /** Règle l'objectif quotidien et les matières prioritaires. Absent : pas de réglage. */
  savePreferences?: (prefs: StudyPreferences) => Promise<unknown>;
  /** D'autres lectures qui dépendent du programme (le tableau de bord de l'élève). */
  alsoInvalidate?: QueryKey[];
}) {
  const queryClient = useQueryClient();
  const [errorSubjectId, setErrorSubjectId] = useState<string | null>(null);

  const mutation = useMutation({
    mutationFn: (v: { subjectId: string; chapterIds: string[] }) => save(v.subjectId, v.chapterIds),
    onMutate: async (v) => {
      setErrorSubjectId(null);
      await queryClient.cancelQueries({ queryKey });
      const previous = queryClient.getQueryData<StudyReport | null>(queryKey);
      if (previous) {
        queryClient.setQueryData(queryKey, withSeenChapters(previous, v.subjectId, v.chapterIds));
      }
      return { previous };
    },
    onError: (_error, v, context) => {
      if (context?.previous) queryClient.setQueryData(queryKey, context.previous);
      setErrorSubjectId(v.subjectId);
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey });
      for (const key of alsoInvalidate) void queryClient.invalidateQueries({ queryKey: key });
    },
  });

  const [preferencesError, setPreferencesError] = useState(false);
  const preferences = useMutation({
    mutationFn: (prefs: StudyPreferences) =>
      savePreferences ? savePreferences(prefs) : Promise.resolve(null),
    onMutate: async (prefs) => {
      setPreferencesError(false);
      await queryClient.cancelQueries({ queryKey });
      const previous = queryClient.getQueryData<StudyReport | null>(queryKey);
      if (previous) queryClient.setQueryData(queryKey, withStudyPreferences(previous, prefs));
      return { previous };
    },
    onError: (_error, _prefs, context) => {
      if (context?.previous) queryClient.setQueryData(queryKey, context.previous);
      setPreferencesError(true);
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey });
      for (const key of alsoInvalidate) void queryClient.invalidateQueries({ queryKey: key });
    },
  });

  return (
    <div className="space-y-6" data-testid="study-report">
      <StudyPlanCard
        report={report}
        audience={audience}
        onSetTarget={
          savePreferences ? (dailyMinutes) => preferences.mutate({ dailyMinutes }) : undefined
        }
        saving={preferences.isPending}
      />
      <StudySubjects
        report={report}
        audience={audience}
        onSetChapters={(subjectId, chapterIds) => mutation.mutate({ subjectId, chapterIds })}
        savingSubjectId={mutation.isPending ? (mutation.variables?.subjectId ?? null) : null}
        errorSubjectId={errorSubjectId}
        onSetFocus={
          savePreferences ? (focusSubjectIds) => preferences.mutate({ focusSubjectIds }) : undefined
        }
        savingFocus={preferences.isPending}
        focusError={preferencesError}
      />
    </div>
  );
}
