import { motion, useReducedMotion } from "motion/react";
import { useT } from "@/lib/i18n";
import { BackLink } from "@/components/ui/back-link";
import { GoldProgress } from "@/components/game/gold-progress";
import { useEntrance } from "@/shared/lib/motion";
import type { QuestLabels } from "@/shared/lib/quest-labels";
import { BossBanner } from "@/features/quest/components/boss-chrono";
import { QuizContractHint } from "@/features/quest/components/quiz-lock-screen";
import { QuestSaveStatus } from "@/features/quest/components/quest-save-status";
import type { AutosaveStatus } from "@/features/quest/components/use-quest-autosave";

/**
 * Le haut de l'écran de jeu — lien de sortie, bandeau du rappel, bandeau du boss,
 * compteur de questions et barre de progression. Sorti de `exercise-player.tsx`
 * (2026-11-03) : c'est de la présentation pure, qui ne lit que ce que le lecteur
 * lui donne.
 */
export function QuestProgressHeader({
  subjectId,
  homeTo,
  title,
  labels,
  rtl,
  isRecall,
  isQuiz,
  bossMode,
  bossHp,
  chronoActive,
  idx,
  total,
  progress,
  saveStatus,
}: {
  subjectId: string | null;
  /** Où mène « quitter » quand la mission n'a pas de matière. */
  homeTo: "/dashboard" | "/";
  title: string;
  labels: QuestLabels;
  rtl: boolean;
  isRecall: boolean;
  isQuiz: boolean;
  bossMode: boolean;
  bossHp: number;
  /** Le chrono du boss tourne : session ouverte, ni résultat, ni correction en cours. */
  chronoActive: boolean;
  idx: number;
  total: number;
  progress: number;
  saveStatus: AutosaveStatus;
}) {
  const t = useT();
  const scaleIn = useEntrance("scale");
  // Width tweens (boss HP / progress) can't use the entrance presets (they
  // animate a value, not an entrance) — gated by hand instead.
  const reduced = useReducedMotion();
  const position = t.quest.questionOf
    .replace("{current}", String(idx + 1))
    .replace("{total}", String(total));

  return (
    <>
      {subjectId ? (
        <BackLink to="/matiere/$subjectId" params={{ subjectId }}>
          {t.quest.leaveQuest}
        </BackLink>
      ) : (
        <BackLink to={homeTo}>{t.quest.leaveQuest}</BackLink>
      )}

      {isRecall && (
        <div
          className="mb-6 rounded-2xl border border-(--gold)/40 bg-(--gold)/5 px-4 py-3 text-center text-sm font-bold text-(--gold)"
          data-testid="recall-banner"
          dir={rtl ? "rtl" : undefined}
        >
          {labels.recallBanner}
        </div>
      )}

      {bossMode && (
        <BossBanner
          title={title}
          hp={bossHp}
          questionIndex={idx}
          chronoActive={chronoActive}
          entrance={scaleIn}
          reduced={Boolean(reduced)}
          labels={{ fight: t.quest.bossFight, hp: t.quest.bossHp }}
        />
      )}

      <div className="mb-6">
        <div className="mb-2 flex items-center justify-between text-xs uppercase tracking-widest text-muted-foreground">
          <span>{position}</span>
          {!bossMode && <span className="text-gold">{title}</span>}
        </div>
        <div className="mb-2 flex justify-end">
          <QuestSaveStatus
            status={saveStatus}
            pendingLabel={t.quest.savePending}
            doneLabel={t.quest.saveDone}
          />
        </div>
        {bossMode ? (
          <div className="h-2 overflow-hidden rounded-full bg-secondary">
            <motion.div
              className="h-full rounded-full shadow-gold bg-linear-to-r from-destructive to-gold"
              initial={reduced ? false : { width: 0 }}
              animate={{ width: `${progress}%` }}
              transition={{ duration: reduced ? 0 : 0.4 }}
            />
          </div>
        ) : (
          <GoldProgress value={progress} aria-label={position} className="shadow-gold" />
        )}
        {isQuiz && <QuizContractHint className="mt-2" />}
      </div>
    </>
  );
}
