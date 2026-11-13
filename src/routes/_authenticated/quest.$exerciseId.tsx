import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useMemo, useState } from "react";
import { ArrowLeft, Crown } from "lucide-react";
import { toast } from "sonner";
import {
  RECALL_LOCKED_MESSAGE,
  RECALL_NOT_ELIGIBLE_MESSAGE,
  checkQuestion,
  getExerciseParcours,
  revealHint,
  startExerciseSession,
  getAttemptProgress,
  submitAttempt,
} from "@/features/quest";
// La ROUTE compose aussi l'accueil différé (étude 38, lot 2) : la carte de classe est
// une primitive de présentation, et ce sont les fonctions serveur de l'assistant —
// les mêmes, pas des copies — que la route lui passe.
import { claimWelcomePack, setCurrentParcours, useMyRole } from "@/features/auth";
import { ParcoursQuickPick } from "@/components/game/parcours-quick-pick";
import { PageShell } from "@/components/ui/page-shell";
import { NudgeSlot } from "@/components/public/nudge-slot";
import { useInstallCandidate } from "@/components/public/use-install-candidate";
import { parcoursName } from "@/shared/lib/parcours-locale";
import { trackProductEvent } from "@/shared/lib/product-events";
import { hasPostponedQuickPick, postponeQuickPick } from "@/shared/lib/quick-pick-later";
import {
  ExercisePlayer,
  type ExercisePlayerStrategy,
  type PlayerResult,
  type StartOutcome,
} from "@/features/quest/components/exercise-player";
import { QuestResultActions } from "@/features/quest/components/quest-result-actions";
// La ROUTE compose les deux features — c'est ici, et nulle part dans ,
// que le tuteur entre dans l'écran de correction (AGENTS.md : une feature n'en
// importe pas une autre).
import { TutorPanel } from "@/features/tutor";
import { buildQuestLabels } from "@/shared/lib/quest-labels";
import { useI18n, useT } from "@/lib/i18n";
import { ReportErrorButton } from "@/features/content-report";
import { SubscriptionPaywall } from "@/features/subscription";

/**
 * Connected « quête » register. Thin: builds the connected strategy (session-based
 * scoring + XP/badges, hints, boss timer, premium gate, next/replay) and hands it
 * to the shared <ExercisePlayer/>. The play loop itself lives in the player, which
 * the public `/exercice` register reuses with an anonymous strategy — one
 * implementation, no drift.
 */
export const Route = createFileRoute("/_authenticated/quest/$exerciseId")({
  head: () => ({ meta: [{ title: "Quête · Na9ra Nal3ab" }] }),
  // Recall mode (étude 17) travels as a search param. Optional (not defaulted)
  // so every existing link to `/quest/$exerciseId` stays valid without passing a
  // search — the component treats an absent value as classic. Hand-rolled (no zod)
  // to keep the validator out of the eager index chunk (bundle budget).
  validateSearch: (search: Record<string, unknown>): { variant?: "classic" | "recall" } => {
    const variant = search.variant;
    return variant === "recall" || variant === "classic" ? { variant } : {};
  },
  component: QuestPage,
});

function QuestPage() {
  const { exerciseId } = Route.useParams();
  const { variant = "classic" } = Route.useSearch();
  const t = useT();
  const startSession = useServerFn(startExerciseSession);
  const submit = useServerFn(submitAttempt);
  const reveal = useServerFn(revealHint);
  const check = useServerFn(checkQuestion);
  // ⭐ Étude 34 lot 4 : ce que la dernière soumission a fait tomber. Branchée sur
  // la SEULE route connectée — sans compte il n'y a pas de grand livre à lire,
  // et le registre anonyme laisse donc `loadProgress` absente.
  const loadProgress = useServerFn(getAttemptProgress);

  const strategy = useMemo<ExercisePlayerStrategy>(
    () => ({
      capabilities: { rewards: true, hints: true, boss: true, next: true, instantFeedback: true },
      quizExerciseTo: "/quest/$exerciseId",
      homeTo: "/dashboard",
      startSession: async ({ exerciseId: exId, variant: v }): Promise<StartOutcome> => {
        try {
          const res = await startSession({ data: { exerciseId: exId, variant: v } });
          return { ok: true, sessionId: res.sessionId, revealed: res.revealed };
        } catch (e) {
          const msg = e instanceof Error ? e.message : "";
          // The server fn raises localized, stable messages per gate.
          if (msg.startsWith("Parcours premium")) {
            return { ok: false, kind: "premium", message: msg };
          }
          if (msg.includes("quiz de compréhension")) return { ok: false, kind: "quiz" };
          if (msg === RECALL_LOCKED_MESSAGE) return { ok: false, kind: "recall", reason: "locked" };
          if (msg === RECALL_NOT_ELIGIBLE_MESSAGE) {
            return { ok: false, kind: "recall", reason: "not-eligible" };
          }
          throw e instanceof Error ? e : new Error(t.errors.sessionStartFailed);
        }
      },
      submit: async ({ sessionId, exerciseId: exId, answers }): Promise<PlayerResult> => {
        const res = await submit({ data: { sessionId, exerciseId: exId, answers } });
        return {
          replayed: res.replayed,
          correct: res.correct,
          total: res.total,
          scorePct: res.scorePct,
          durationSeconds: res.durationSeconds,
          speedBonus: res.speedBonus,
          reviewHidden: res.reviewHidden,
          review: res.review,
          xpEarned: res.xpEarned,
          coinsEarned: res.coinsEarned,
          profile: res.profile as Record<string, unknown> | null,
          unlockedBadges: res.unlockedBadges,
          potionApplied: res.potionApplied
            ? {
                xpMultiplier: res.potionApplied.xpMultiplier,
                coinMultiplier: res.potionApplied.coinMultiplier,
              }
            : null,
          retryShieldUsed: res.retryShieldUsed,
          tooFast: res.tooFast,
          improved: res.improved,
        };
      },
      loadProgress: (exId: string) => loadProgress({ data: { exerciseId: exId } }),
      revealHint: async (questionId) => {
        const r = await reveal({ data: { questionId } });
        return { questionId: r.questionId, hint: r.hint, consumed: r.consumed };
      },
      checkAnswer: ({ exerciseId: exId, sessionId, questionId, choice }) =>
        check({ data: { exerciseId: exId, sessionId, questionId, choice } }),
      renderPremiumLock: ({ message, subjectId, contentLang }) => {
        const QL = buildQuestLabels(contentLang);
        return (
          <div className="mx-auto max-w-md px-6 py-12 text-center">
            <div className="rounded-3xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-8">
              <Crown className="mx-auto h-12 w-12 text-[color:var(--neon-gold)]" />
              <h1 className="mt-4 font-display text-2xl font-bold">{QL.eliteLockedTitle}</h1>
              <p className="mt-3 text-sm text-muted-foreground">{message}</p>
              <SubscriptionPaywall />
              {subjectId && (
                <Link
                  to="/matiere/$subjectId"
                  params={{ subjectId }}
                  className="mt-5 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
                >
                  <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {QL.back}
                </Link>
              )}
            </div>
          </div>
        );
      },
      // Étude 11 lot 1 — « Demander au Prof ». La porte R-1 est tranchée par le
      // serveur à l'appel : sur l'écran de correction, la session est terminée
      // par construction, et un aller-retour de plus pour l'apprendre serait payé
      // par l'élève en attente.
      renderTutor: (questionId: string) => <TutorPanel questionId={questionId} />,
      renderResultFooter: ({ exerciseId: exId, subjectId, nextExerciseId, onReplay, passed }) => (
        <>
          <QuestResultActions
            subjectId={subjectId}
            nextExerciseId={nextExerciseId}
            onReplay={onReplay}
          />
          <QuestResultNudge passed={passed} />
          <ReportErrorButton exerciseId={exId} />
        </>
      ),
    }),
    [startSession, submit, reveal, check, loadProgress, t],
  );

  // Plus de conteneur porteur de thème (levier 03) : le lecteur tire ses surfaces
  // des tokens `surface-*`, donc il rend identiquement dans les deux registres
  // sans qu'aucune classe ne doive lui repeindre le noir en blanc.
  return (
    <>
      <QuestParcoursCard exerciseId={exerciseId} />
      <ExercisePlayer exerciseId={exerciseId} strategy={strategy} variant={variant} />
    </>
  );
}

/**
 * L'INVITATION de l'écran de résultat connecté (étude 40, R-11 et R-12) : UNE SEULE carte au plus,
 * après une réussite, choisie par `NudgeSlot` dans l'ordre rappel → installation → inviter son
 * parent. C'est la ROUTE qui compose : chaque invitation vient d'une feature différente.
 *
 * Aujourd'hui seule l'installation existe (lot 3). Le rappel (lot 2) et le parent (lot 5)
 * s'ajoutent à la liste des candidats — l'ordre et la règle « une seule » sont déjà tenus.
 */
function QuestResultNudge({ passed }: { passed: boolean }) {
  const install = useInstallCandidate("student", passed);
  const candidates = useMemo(() => [install], [install]);
  return (
    <div className="mt-6 empty:hidden">
      <NudgeSlot candidates={candidates} />
    </div>
  );
}

/**
 * L'accueil différé (étude 38, lot 2 — R-5, US-2). Un élève sans classe qui a demandé
 * une quête la joue ; au-dessus du lecteur, cette carte lui propose la classe du
 * chapitre en un geste.
 *
 * - Montée pour un `student` SANS parcours, et pour lui seul : un parent, un admin
 *   ou un élève déjà inscrit ne déclenchent même pas la lecture du parcours.
 * - « Choisir » fait exactement ce que fait l'assistant : `setCurrentParcours`, puis
 *   le pack de bienvenue (`claimWelcomePack`, idempotent côté SQL — é31 R-19).
 *   L'élève ne perd rien à ne pas être passé par l'assistant.
 * - « Plus tard » ferme la carte pour la session de navigation.
 * - Un parcours introuvable ou une lecture en échec : pas de carte. La quête, elle,
 *   se joue toujours — la carte n'ouvre rien.
 */
function QuestParcoursCard({ exerciseId }: { exerciseId: string }) {
  const t = useT();
  const { locale } = useI18n();
  const queryClient = useQueryClient();
  const { role, currentParcoursId, hasProfile, isLoaded } = useMyRole();
  const [closed, setClosed] = useState(() => hasPostponedQuickPick());

  const eligible =
    isLoaded && hasProfile && role === "student" && currentParcoursId == null && !closed;

  const fetchParcours = useServerFn(getExerciseParcours);
  const { data: parcours } = useQuery({
    queryKey: ["exercise-parcours", exerciseId],
    queryFn: () => fetchParcours({ data: { exerciseId } }),
    enabled: eligible,
    staleTime: Infinity,
  });

  const saveParcours = useServerFn(setCurrentParcours);
  const claimWelcome = useServerFn(claimWelcomePack);
  const choose = useMutation({
    mutationFn: async (parcoursId: string) => {
      await saveParcours({ data: { parcoursId } });
      // Le pack est versé ICI, comme à la fin de l'assistant. Son échec ne défait pas
      // le choix : l'élève a sa classe, c'est ce qui compte.
      try {
        return await claimWelcome();
      } catch {
        return null;
      }
    },
    onSuccess: async (welcome) => {
      setClosed(true);
      trackProductEvent("onboarding_completed", { intent: "unknown", source: "quest_card" });
      toast.success(
        welcome?.granted
          ? `${t.onboarding.celebrateTitle} ${t.onboarding.welcomeCoins.replace("{coins}", String(welcome.coins))}`
          : t.onboarding.celebrateTitle,
      );
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
        queryClient.invalidateQueries({ queryKey: ["me-role"] }),
        queryClient.invalidateQueries({ queryKey: ["me-parcours"] }),
      ]);
    },
    onError: () => {
      toast.error(t.onboarding.saveError);
    },
  });

  if (!eligible || !parcours) return null;

  return (
    <PageShell width="narrow" className="pb-0">
      <ParcoursQuickPick
        parcoursName={parcoursName(parcours, locale)}
        isChoosing={choose.isPending}
        onChoose={() => choose.mutate(parcours.id)}
        onLater={() => {
          postponeQuickPick();
          setClosed(true);
        }}
      />
    </PageShell>
  );
}
