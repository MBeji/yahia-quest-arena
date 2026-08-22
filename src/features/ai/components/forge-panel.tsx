import { useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Hammer, TriangleAlert } from "lucide-react";

import { useT, type TranslationKeys } from "@/lib/i18n";
import { AI_FORGE_LIMITS } from "@/shared/constants/ai";
import { MAX_DIFFICULTY_LEVEL, MIN_DIFFICULTY_LEVEL } from "@/shared/constants/gamification";
import { forgeQuiz, listForgedQuizzes, type ForgedQuizSummary } from "../forge.server";
import { ForgedQuizPlayer } from "./forged-quiz-player";

/**
 * L'écran de la Forge — US-6 (étude 29 §2.3).
 *
 * Tout ce que l'élève choisit est DÉTERMINISTE : le périmètre, le volume, la
 * difficulté. « Aucun de ces champs n'est décidé par le modèle. » La langue
 * n'est même pas un choix : c'est celle de la matière (é11 R-3), et elle est
 * imposée côté serveur.
 *
 * R-14a — CE QUE CET ÉCRAN NE MONTRE JAMAIS
 * -------------------------------------------------------------------------
 * Ni dollar, ni token, ni « il te reste 0,42 $ ». L'étude est explicite :
 * « l'estimation est côté parent, et l'élève ne voit que le coût en énergie ».
 * Le seul compteur ici est le quota de quiz du jour (R-18), qui est une règle de
 * jeu — pas de l'argent.
 */

function forgeErrorLabel(raw: string, t: TranslationKeys): string {
  if (raw.includes("AI_FORGE_QUOTA")) return t.ai.errForgeQuota;
  if (raw.includes("AI_FORGE_NO_QUORUM")) return t.ai.errForgeNoQuorum;
  if (raw.includes("AI_FORGE_NO_CONTEXT")) return t.ai.errForgeNoContext;
  if (raw.includes("AI_BUDGET_REACHED")) return t.ai.errBudgetReached;
  return t.ai.errGeneric;
}

export function ForgePanel({ chapterId }: { chapterId: string | null }) {
  const t = useT();
  const queryClient = useQueryClient();
  const fetchList = useServerFn(listForgedQuizzes);
  const forge = useServerFn(forgeQuiz);

  const { data } = useQuery({
    queryKey: ["forged-quizzes"],
    queryFn: () => fetchList(),
    staleTime: 30_000,
  });

  const [size, setSize] = useState<5 | 8 | 10>(8);
  const [difficulty, setDifficulty] = useState(2);
  const [busy, setBusy] = useState(false);
  const [playing, setPlaying] = useState<string | null>(null);

  if (playing) {
    return <ForgedQuizPlayer quizId={playing} onLeave={() => setPlaying(null)} />;
  }

  const quotaLeft = data?.quotaLeft ?? AI_FORGE_LIMITS.dailyQuizzesPerStudent;

  async function run() {
    if (!chapterId || busy) return;
    setBusy(true);
    try {
      const outcome = await forge({ data: { chapterId, size, difficulty } });
      if (outcome.ok) {
        await queryClient.invalidateQueries({ queryKey: ["forged-quizzes"] });
        setPlaying(outcome.quizId);
      } else {
        toast.error(forgeErrorLabel(outcome.code, t));
      }
    } catch (error) {
      toast.error(forgeErrorLabel(error instanceof Error ? error.message : "", t));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div data-testid="forge-panel">
      <p className="flex items-center gap-2 font-display text-lg font-bold">
        <Hammer className="h-5 w-5 text-[color:var(--gold)]" />
        {t.ai.forgeTitle}
      </p>
      {/* R-16, dit d'emblée : un élève doit savoir AVANT de jouer que ce quiz ne
          rapporte rien. L'apprendre à l'écran de résultat serait une déception. */}
      <p className="text-sm text-muted-foreground">{t.ai.forgeDesc}</p>

      {chapterId && (
        <div className="mt-3 grid gap-3">
          <Choice
            label={t.ai.forgeSize}
            values={AI_FORGE_LIMITS.allowedSizes}
            current={size}
            onPick={(v) => setSize(v as 5 | 8 | 10)}
            testId="forge-size"
          />
          <Choice
            label={t.ai.forgeDifficulty}
            values={Array.from(
              { length: MAX_DIFFICULTY_LEVEL - MIN_DIFFICULTY_LEVEL + 1 },
              (_, i) => MIN_DIFFICULTY_LEVEL + i,
            )}
            current={difficulty}
            onPick={setDifficulty}
            testId="forge-difficulty"
            render={(v) => "⭐".repeat(v)}
          />

          <div className="flex flex-wrap items-center gap-3">
            <button
              type="button"
              onClick={() => void run()}
              disabled={busy || quotaLeft <= 0}
              data-testid="forge-run"
              className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 px-4 py-1.5 text-sm font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-50"
            >
              <Hammer className="h-4 w-4" />
              {busy ? t.ai.forgeWorking : t.ai.forgeStart}
            </button>
            {/* R-18 : un quota de quiz, pas un montant. C'est une règle de jeu. */}
            <span className="text-xs text-muted-foreground" data-testid="forge-quota">
              {t.ai.forgeQuota.replace("{left}", String(quotaLeft))}
            </span>
          </div>
        </div>
      )}

      <ul className="mt-4 grid gap-2">
        {(data?.quizzes ?? []).length === 0 && (
          <li className="text-xs text-muted-foreground">{t.ai.forgeNoQuiz}</li>
        )}
        {(data?.quizzes ?? []).map((quiz) => (
          <QuizRow key={quiz.id} quiz={quiz} onPlay={() => setPlaying(quiz.id)} />
        ))}
      </ul>
    </div>
  );
}

function Choice({
  label,
  values,
  current,
  onPick,
  testId,
  render,
}: {
  label: string;
  values: readonly number[];
  current: number;
  onPick: (value: number) => void;
  testId: string;
  render?: (value: number) => string;
}) {
  return (
    <div>
      <span className="text-xs font-semibold text-muted-foreground">{label}</span>
      <div className="mt-1 flex gap-2">
        {values.map((value) => (
          <button
            key={value}
            type="button"
            aria-pressed={current === value}
            data-testid={`${testId}-${value}`}
            onClick={() => onPick(value)}
            className={`min-h-11 flex-1 rounded-lg border px-3 py-1.5 text-sm font-semibold transition ${
              current === value
                ? "border-[color:var(--gold)] bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                : "border-border/60 text-muted-foreground hover:bg-accent"
            }`}
          >
            {render ? render(value) : value}
          </button>
        ))}
      </div>
    </div>
  );
}

function QuizRow({ quiz, onPlay }: { quiz: ForgedQuizSummary; onPlay: () => void }) {
  const t = useT();
  return (
    <li className="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-border/60 p-2.5 text-sm">
      <span className="min-w-0">
        <span className="block truncate font-semibold">{quiz.chapterTitle ?? "—"}</span>
        <span className="block text-xs text-muted-foreground">
          {"⭐".repeat(quiz.difficulty)} · {quiz.questionCount} ·{" "}
          {t.ai.forgeExpires.replace("{date}", new Date(quiz.expiresAt).toLocaleDateString())}
        </span>
      </span>
      <span className="flex items-center gap-2">
        {/* R-18bis.2 : l'étiquette suit le quiz jusque dans la liste. */}
        {!quiz.verified && (
          <span className="inline-flex items-center gap-1 rounded-full border border-destructive/50 px-2 py-0.5 text-2xs font-semibold text-destructive">
            <TriangleAlert className="h-3 w-3" />
            {t.ai.forgeUnverified}
          </span>
        )}
        <button
          type="button"
          onClick={onPlay}
          data-testid={`forge-play-${quiz.id}`}
          className="inline-flex min-h-11 items-center rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10"
        >
          {t.ai.forgePlay}
        </button>
      </span>
    </li>
  );
}
