import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useEffect, useState } from "react";
import { CloudOff, Compass } from "lucide-react";

import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { PageShell } from "@/components/ui/page-shell";
import { useAuth } from "@/features/auth";
import {
  clearPlacementDraft,
  finishPlacementSession,
  getPlacementSession,
  placementErrorCode,
  rememberPlacement,
  rememberedToken,
  useClaimPlacementSessions,
  type PlacementBilan,
} from "@/features/placement";
import { PlacementRunner } from "@/features/placement/components/placement-runner";
import { PlacementSummary } from "@/features/placement/components/placement-summary";
import { usePlacementT } from "@/lib/i18n/placement";
import { trackProductEvent } from "@/shared/lib/product-events";
import { rememberCurrentPage } from "@/shared/lib/return-to";

/**
 * UN TEST (étude 39) — la passation puis le bilan, une route, deux états.
 *
 * L'accès est le JETON de l'appareil (R-14, mémoire R-15) ou la propriété du compte (R-12) ;
 * la route attend d'avoir lu les deux — la mémoire après montage, la session d'auth — avant de
 * demander le test, pour qu'un propriétaire sans jeton passe. Le segment `test-de-niveau_`
 * sort de l'imbrication sous `/test-de-niveau` (une feuille, pas une coquille — motif de
 * `programme_.lycee.$annee`).
 */
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export const Route = createFileRoute("/_public/test-de-niveau_/$sessionId")({
  head: () => ({ meta: [{ title: "Test de niveau · Na9ra Nal3ab" }] }),
  component: PlacementSessionPage,
});

function PlacementSessionPage() {
  const { sessionId } = Route.useParams();
  const t = usePlacementT();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { user, loading: authLoading } = useAuth();
  const isAuthenticated = user != null;

  // La mémoire de l'appareil se lit APRÈS montage (SSR : rien) ; `undefined` = pas encore lue.
  const [token, setToken] = useState<string | null | undefined>(undefined);
  useEffect(() => setToken(UUID.test(sessionId) ? rememberedToken(sessionId) : null), [sessionId]);

  const fetchSession = useServerFn(getPlacementSession);
  const finish = useServerFn(finishPlacementSession);

  const queryKey = ["placement-session", sessionId, token ?? null, user?.id ?? null] as const;
  const ready = token !== undefined && !authLoading && UUID.test(sessionId);
  const sessionQuery = useQuery({
    queryKey,
    queryFn: () => fetchSession({ data: { sessionId, token: token ?? null } }),
    enabled: ready,
    retry: false,
    staleTime: Infinity,
    refetchOnWindowFocus: false,
  });

  // R-16 : rattaché à l'instant → le bilan se relit en propriétaire (explications, erreurs nommées).
  useClaimPlacementSessions(isAuthenticated && !authLoading, () => {
    queryClient.invalidateQueries({ queryKey: ["placement-session", sessionId] });
  });

  const finishMutation = useMutation({
    mutationFn: (vars: {
      answers: Array<{ questionId: string; choice: string }>;
      durationSeconds: number;
    }) =>
      finish({
        data: {
          sessionId,
          token: token ?? null,
          answers: vars.answers,
          durationSeconds: vars.durationSeconds,
        },
      }),
    onSuccess: (bilan: PlacementBilan) => {
      clearPlacementDraft(sessionId);
      if (token) {
        rememberPlacement({
          id: bilan.id,
          token,
          subjectId: bilan.subject.id,
          subjectName: bilan.subject.nameFr,
          at: Date.now(),
          scoreOn20: bilan.scoreOn20,
          band: bilan.band,
          finished: true,
        });
      }
      // é39 R-21 — le second fait : un test fini, sa bande, et s'il a été bâclé.
      trackProductEvent("placement_completed", {
        subject_id: bilan.subject.id,
        audience: bilan.audience,
        signed_in: isAuthenticated,
        band: bilan.band,
        too_fast: bilan.tooFast,
      });
      queryClient.setQueryData(queryKey, bilan);
    },
  });

  if (
    !UUID.test(sessionId) ||
    (sessionQuery.isError && placementErrorCode(sessionQuery.error) === "notFound")
  ) {
    return (
      <PageShell width="narrow" className="py-16">
        <EmptyState
          icon={Compass}
          title={t.placement.summary.notFound}
          action={
            <Link
              to="/test-de-niveau"
              className="inline-flex min-h-11 items-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              {t.placement.summary.retake}
            </Link>
          }
        />
      </PageShell>
    );
  }

  if (sessionQuery.isError) {
    return (
      <PageShell width="narrow" className="py-16">
        <EmptyState
          icon={CloudOff}
          tone="error"
          title={t.placement.summary.loadFailed}
          action={
            <Button variant="outline" onClick={() => sessionQuery.refetch()}>
              {t.common.retry}
            </Button>
          }
        />
      </PageShell>
    );
  }

  const session = sessionQuery.data;
  if (!ready || sessionQuery.isLoading || !session) {
    return <LoadingState label={t.placement.runner.loading} className="min-h-[60dvh]" />;
  }

  if (session.status === "running") {
    const finishError = finishMutation.isError ? t.placement.runner.finishFailed : null;
    return (
      <PageShell width="narrow" className="py-8">
        <PlacementRunner
          key={session.id}
          sessionId={session.id}
          questions={session.questions}
          contentLanguage={session.subject.contentLanguage}
          finishing={finishMutation.isPending}
          finishError={finishError}
          onFinish={(answers, durationSeconds) =>
            finishMutation.mutate({ answers, durationSeconds })
          }
          onLeave={() => navigate({ to: "/test-de-niveau" })}
        />
      </PageShell>
    );
  }

  return (
    <PageShell width="narrow" className="py-8">
      <PlacementSummary
        bilan={session}
        isAuthenticated={isAuthenticated}
        authLoading={authLoading}
        onShared={(method) =>
          trackProductEvent("placement_shared", { subject_id: session.subject.id, method })
        }
        onInviteClick={() => {
          // é38 lot 1 : revenir ICI après l'inscription — le rattachement ouvrira la correction.
          rememberCurrentPage();
          trackProductEvent("account_invite_clicked", { surface: "placement" });
        }}
      />
      <div className="mt-8 flex flex-wrap justify-center gap-3">
        <Link
          to="/test-de-niveau"
          search={{ matiere: session.subject.id }}
          className="inline-flex min-h-11 items-center rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
        >
          {t.placement.summary.retake}
        </Link>
        <Link
          to="/test-de-niveau"
          className="inline-flex min-h-11 items-center rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
        >
          {t.placement.summary.otherSubject}
        </Link>
      </div>
    </PageShell>
  );
}
