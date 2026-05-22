import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useEffect, useMemo, useRef, useState } from "react";
import { ArrowLeft, Check, X, Zap, Flame, Sparkles, Loader2, Trophy } from "lucide-react";
import { toast } from "sonner";
import { getExercise, submitAttempt } from "@/lib/gamification.functions";

export const Route = createFileRoute("/_authenticated/quest/$exerciseId")({
  head: () => ({ meta: [{ title: "Quête · YahiaAcademy" }] }),
  component: QuestPage,
});

type Answer = { questionId: string; choice: string };

function QuestPage() {
  const { exerciseId } = Route.useParams();
  const navigate = useNavigate();
  const qc = useQueryClient();
  const fetchExercise = useServerFn(getExercise);
  const submit = useServerFn(submitAttempt);

  const { data, isLoading } = useQuery({
    queryKey: ["exercise", exerciseId],
    queryFn: () => fetchExercise({ data: { exerciseId } }),
  });

  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<Answer[]>([]);
  const [selected, setSelected] = useState<string | null>(null);
  const [reveal, setReveal] = useState(false);
  const startRef = useRef<number>(Date.now());
  const [result, setResult] = useState<Awaited<ReturnType<typeof submitAttempt>> | null>(null);

  useEffect(() => { startRef.current = Date.now(); }, [exerciseId]);

  const mutation = useMutation({
    mutationFn: (payload: { exerciseId: string; answers: Answer[]; durationSeconds: number }) => submit({ data: payload }),
    onSuccess: (res) => {
      setResult(res);
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      qc.invalidateQueries({ queryKey: ["subject"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : "Erreur"),
  });

  const questions = data?.questions ?? [];
  const total = questions.length;
  const current = questions[idx];
  const progress = useMemo(() => (total > 0 ? ((idx) / total) * 100 : 0), [idx, total]);

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Préparation de l'arène…</div>;
  }

  // RESULTS SCREEN
  if (result) {
    const passed = result.scorePct >= 60;
    return (
      <div className="mx-auto max-w-2xl px-6 py-12">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-violet)]/40 bg-card/60 p-8 text-center backdrop-blur-xl shadow-neon"
        >
          <div className="absolute -top-20 left-1/2 h-48 w-48 -translate-x-1/2 rounded-full bg-[color:var(--neon-violet)]/40 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon animate-pulse-neon">
              <Trophy className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold">{passed ? "Victoire !" : "Bien tenté, guerrier"}</h1>
            <p className="mt-1 text-muted-foreground">
              {result.correct} / {result.total} bonnes réponses · {Math.round(result.scorePct)}%
            </p>
            <div className="mt-6 grid grid-cols-3 gap-3">
              <div className="rounded-xl bg-[color:var(--neon-gold)]/15 p-4">
                <Zap className="mx-auto h-5 w-5 text-[color:var(--neon-gold)]" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--neon-gold)]">+{result.xpEarned}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">XP</div>
              </div>
              <div className="rounded-xl bg-[color:var(--neon-violet)]/15 p-4">
                <Sparkles className="mx-auto h-5 w-5 text-[color:var(--neon-violet)]" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--neon-violet)]">{result.profile?.level ?? "?"}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Niveau</div>
              </div>
              <div className="rounded-xl bg-[color:var(--flame)]/15 p-4">
                <Flame className="mx-auto h-5 w-5 text-[color:var(--flame)] animate-flame" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--flame)]">{result.profile?.current_streak ?? 0}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Flamme</div>
              </div>
            </div>
            <div className="mt-6 text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">
              {result.profile?.hero_class}
            </div>
            <div className="mt-8 flex flex-wrap justify-center gap-3">
              <Link to="/dashboard" className="rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80">Retour au hall</Link>
              <button
                onClick={() => { setResult(null); setIdx(0); setAnswers([]); setSelected(null); setReveal(false); startRef.current = Date.now(); }}
                className="rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-neon hover:scale-105"
              >
                Rejouer la quête
              </button>
            </div>
          </div>
        </motion.div>
      </div>
    );
  }

  function handleSelect(optId: string) {
    if (reveal) return;
    setSelected(optId);
    setReveal(true);
    const newAns: Answer = { questionId: current.id, choice: optId };
    setAnswers((prev) => [...prev, newAns]);
  }

  function next() {
    setSelected(null);
    setReveal(false);
    if (idx + 1 >= total) {
      const duration = Math.round((Date.now() - startRef.current) / 1000);
      mutation.mutate({ exerciseId, answers, durationSeconds: duration });
    } else {
      setIdx((i) => i + 1);
    }
  }

  const options = (current.options as { id: string; text: string }[]) ?? [];
  const isCorrect = selected === current.correct_option;

  return (
    <div className="mx-auto max-w-2xl px-6 py-8">
      <Link to=".." className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-4 w-4" /> Quitter la quête
      </Link>

      <div className="mb-6">
        <div className="mb-2 flex items-center justify-between text-xs uppercase tracking-widest text-muted-foreground">
          <span>Question {idx + 1} / {total}</span>
          <span className="text-[color:var(--neon-cyan)]">{data.exercise.title}</span>
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-secondary">
          <motion.div
            className="h-full rounded-full bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon"
            initial={{ width: 0 }} animate={{ width: `${progress}%` }} transition={{ duration: 0.4 }}
          />
        </div>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={current.id}
          initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
          transition={{ duration: 0.3 }}
          className="rounded-3xl border border-border/50 bg-card/60 p-6 backdrop-blur-xl sm:p-8"
        >
          <h2 className="font-display text-xl font-semibold sm:text-2xl">{current.prompt}</h2>
          <div className="mt-6 space-y-3">
            {options.map((opt) => {
              const isSel = selected === opt.id;
              const isAns = current.correct_option === opt.id;
              let cls = "border-border bg-background/40 hover:border-[color:var(--neon-violet)]/60 hover:bg-background/70";
              if (reveal && isAns) cls = "border-[color:var(--success)] bg-[color:var(--success)]/15 text-[color:var(--success)]";
              else if (reveal && isSel && !isAns) cls = "border-destructive bg-destructive/15 text-destructive";
              else if (isSel) cls = "border-[color:var(--neon-violet)] bg-[color:var(--neon-violet)]/15";
              return (
                <button
                  key={opt.id}
                  disabled={reveal}
                  onClick={() => handleSelect(opt.id)}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition ${cls}`}
                >
                  <span className="flex items-center gap-3">
                    <span className="grid h-7 w-7 place-items-center rounded-md border border-current font-mono text-xs uppercase">{opt.id}</span>
                    <span>{opt.text}</span>
                  </span>
                  {reveal && isAns && <Check className="h-5 w-5" />}
                  {reveal && isSel && !isAns && <X className="h-5 w-5" />}
                </button>
              );
            })}
          </div>

          {reveal && (
            <motion.div
              initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
              className={`mt-5 rounded-xl border p-4 text-sm ${isCorrect ? "border-[color:var(--success)]/40 bg-[color:var(--success)]/10" : "border-destructive/40 bg-destructive/10"}`}
            >
              <div className="font-bold">{isCorrect ? "Coup parfait." : "Esquive ratée."}</div>
              {current.explanation && <p className="mt-1 text-muted-foreground">{current.explanation}</p>}
            </motion.div>
          )}

          <div className="mt-6 flex justify-end">
            <button
              disabled={!reveal || mutation.isPending}
              onClick={next}
              className="inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-6 py-2.5 text-sm font-bold text-primary-foreground shadow-neon transition disabled:opacity-40"
            >
              {mutation.isPending && <Loader2 className="h-4 w-4 animate-spin" />}
              {idx + 1 >= total ? "Terminer la quête" : "Question suivante"}
            </button>
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}
