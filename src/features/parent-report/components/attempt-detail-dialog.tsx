import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CheckCircle2, EyeOff, XCircle } from "lucide-react";
import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { LoadingState } from "@/components/ui/loading-state";
import { RichField } from "@/components/ui/svg-figure";
import { DifficultyStars } from "@/components/game/difficulty-stars";
import { useT } from "@/lib/i18n";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import { getStudentAttemptDetail } from "../parent-report.server";
import { answerLabel, formatSeconds, type AttemptQuestion } from "../insights";
import { EmptyRow } from "./daily-primitives";

/**
 * « Cliquer sur un exercice pour voir son contenu et les réponses de l'enfant ».
 *
 * Deux règles gouvernent cet écran :
 *   * On montre TOUJOURS ce que l'enfant a répondu et si c'était juste — c'est
 *     l'intérêt du suivi.
 *   * On ne montre la bonne réponse et l'explication QUE si l'exercice n'est pas
 *     un quiz de compréhension. Le serveur les renvoie déjà à `null` dans ce cas
 *     (garde anti-mémorisation) ; ici on l'ANNONCE, au lieu de laisser un vide
 *     que le parent lirait comme un bug.
 */
export function AttemptDetailDialog({
  studentId,
  attemptId,
  onClose,
}: {
  studentId: string;
  attemptId: string | null;
  onClose: () => void;
}) {
  const t = useT();
  const fetchDetail = useServerFn(getStudentAttemptDetail);

  const { data, isLoading, isError } = useQuery({
    queryKey: ["attempt-detail", studentId, attemptId],
    queryFn: () => fetchDetail({ data: { studentId, attemptId: attemptId as string } }),
    enabled: Boolean(attemptId),
  });

  return (
    <Dialog open={attemptId !== null} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-h-[85dvh] max-w-3xl overflow-y-auto">
        <DialogTitle className="pe-6 text-base font-bold">
          {data ? isolateLtrRuns(data.exerciseTitle) : t.parentDaily.attemptDetailTitle}
        </DialogTitle>

        {isLoading && <LoadingState label={t.common.loading} className="py-10" />}
        {isError && <EmptyRow label={t.parentDaily.attemptDetailFailed} />}

        {data && (
          <div dir={data.contentLanguage === "ar" ? "rtl" : "ltr"}>
            <div className="flex flex-wrap items-center gap-x-3 gap-y-1 border-b border-border/50 pb-3 text-xs text-muted-foreground">
              <span>{isolateLtrRuns(data.subjectName)}</span>
              {data.chapterTitle && <span>· {isolateLtrRuns(data.chapterTitle)}</span>}
              <span>· {data.completedAt}</span>
              <span>· {formatSeconds(data.durationSeconds)}</span>
              {data.difficulty > 0 && <DifficultyStars level={data.difficulty} />}
              <span className="ms-auto font-bold text-foreground">
                {data.correct}/{data.total} · {data.scorePct}%
              </span>
            </div>

            {data.reviewHidden && (
              <p className="mt-3 flex items-start gap-2 rounded-lg border border-gold/40 bg-gold/5 p-3 text-xs text-muted-foreground">
                <EyeOff className="mt-0.5 h-4 w-4 shrink-0 text-gold" />
                {t.parentDaily.attemptReviewHidden}
              </p>
            )}

            {data.questions.length === 0 ? (
              <div className="mt-4">
                <EmptyRow label={t.parentDaily.attemptNoAnswers} />
              </div>
            ) : (
              <ol className="mt-4 space-y-4">
                {data.questions.map((q, i) => (
                  <QuestionRow key={q.questionId} question={q} index={i + 1} />
                ))}
              </ol>
            )}
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}

function QuestionRow({ question, index }: { question: AttemptQuestion; index: number }) {
  const t = useT();
  const Icon = question.isCorrect ? CheckCircle2 : XCircle;
  const tone = question.isCorrect ? "text-success" : "text-destructive";

  return (
    <li className="rounded-lg border border-border/50 bg-surface-3 p-3">
      <div className="flex items-start gap-2">
        <Icon className={`mt-0.5 h-4 w-4 shrink-0 ${tone}`} />
        <div className="min-w-0 flex-1">
          <div className="text-2xs font-semibold uppercase tracking-wider text-muted-foreground">
            {t.parentDaily.questionLabel.replace("{n}", String(index))}
          </div>
          {/* Un énoncé peut contenir une figure SVG : `RichField` la rend et la
              ré-assainit, exactement comme dans la quête de l'élève. */}
          <RichField raw={question.prompt} className="mt-1 text-sm text-foreground" />

          {/* La réponse enregistrée est l'identifiant de l'option (« b ») : on la
              remet en face de son libellé, sinon le parent lit une lettre. */}
          <dl className="mt-2 space-y-1 text-sm">
            <div className="flex flex-wrap gap-x-2">
              <dt className="text-muted-foreground">{t.parentDaily.childAnswer}</dt>
              <dd className={`font-semibold ${tone}`}>
                {isolateLtrRuns(answerLabel(question, question.answer) ?? "—")}
              </dd>
            </div>
            {!question.isCorrect && question.correctOption && (
              <div className="flex flex-wrap gap-x-2">
                <dt className="text-muted-foreground">{t.parentDaily.expectedAnswer}</dt>
                <dd className="font-semibold text-success">
                  {isolateLtrRuns(answerLabel(question, question.correctOption) ?? "—")}
                </dd>
              </div>
            )}
          </dl>

          {question.explanation && (
            <p className="mt-2 rounded-md bg-surface-2 p-2 text-xs text-muted-foreground">
              {isolateLtrRuns(question.explanation)}
            </p>
          )}
        </div>
      </div>
    </li>
  );
}
