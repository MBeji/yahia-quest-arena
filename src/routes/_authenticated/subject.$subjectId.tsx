import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import {
  ArrowLeft,
  Swords,
  Zap,
  ChevronRight,
  Star,
  Skull,
  BookOpen,
  Lock,
  Brain,
  CheckCircle2,
  Crown,
} from "lucide-react";
import { getSubject } from "@/features/quest";
import { CHALLENGE_MIN_LEVEL } from "@/shared/constants/gamification";
import { isRtlText } from "@/shared/lib/utils";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/subject/$subjectId")({
  head: () => ({ meta: [{ title: "Quests · XP Scholars" }] }),
  component: SubjectPage,
});

function SubjectPage() {
  const { subjectId } = Route.useParams();
  const t = useT();
  const fetchSubject = useServerFn(getSubject);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20 text-center">
        <div className="rounded-2xl border border-destructive/30 bg-destructive/5 p-8">
          <Skull className="mx-auto h-10 w-10 text-destructive" />
          <h2 className="mt-4 font-display text-xl font-bold">{t.dashboard.failedLoad}</h2>
          <p className="mt-2 text-sm text-muted-foreground">{t.dashboard.failedLoadDesc}</p>
          <Link
            to="/dashboard"
            className="mt-4 inline-block rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground"
          >
            {t.common.backToHall}
          </Link>
        </div>
      </div>
    );
  }

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">
        {t.common.loading}
      </div>
    );
  }
  const { subject, chapters, exercises, bestByExercise, quizPassedByChapter, viewer } = data;
  const premiumUnlocked = viewer.hasSubscription && viewer.level >= CHALLENGE_MIN_LEVEL;
  const color = `var(--subject-${subject.color_token})`;
  const lang = ((subject as { content_language?: string }).content_language ?? "fr") as
    | "ar"
    | "fr"
    | "en";
  const isRtlSubject = lang === "ar";
  const L = {
    quiz: { ar: "اختبار الفهم", fr: "Quiz de compréhension", en: "Comprehension quiz" }[lang],
    required: { ar: "إجباري", fr: "Obligatoire", en: "Required" }[lang],
    passed: { ar: "✓ ناجح", fr: "✓ Réussi", en: "✓ Passed" }[lang],
    lockedNote: {
      ar: "انجح في اختبار الفهم لفتح التمارين",
      fr: "Réussis le quiz pour débloquer les exercices",
      en: "Pass the quiz to unlock the exercises",
    }[lang],
    review: { ar: "📖 راجع الدرس", fr: "📖 Réviser le cours", en: "📖 Review the lesson" }[lang],
    elite: { ar: "تحدّي النخبة", fr: "Défi élite", en: "Elite challenge" }[lang],
    premium: { ar: "مدفوع", fr: "Premium", en: "Premium" }[lang],
    premiumLock: {
      ar: `يتطلب اشتراكًا والمستوى ${CHALLENGE_MIN_LEVEL}`,
      fr: `Abonnement + niveau ${CHALLENGE_MIN_LEVEL} requis`,
      en: `Subscription + level ${CHALLENGE_MIN_LEVEL} required`,
    }[lang],
  };

  return (
    <div className="mx-auto max-w-5xl px-6 py-8" dir={isRtlSubject ? "rtl" : undefined}>
      <Link
        to="/dashboard"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> Heroes Hall
      </Link>

      <div className="relative overflow-hidden rounded-3xl border border-border/50 bg-card/60 p-8 backdrop-blur-xl">
        <div
          className="absolute -right-10 -top-10 h-52 w-52 rounded-full blur-3xl opacity-50"
          style={{ background: color }}
        />
        <div className="relative">
          <div className="text-xs uppercase tracking-[0.3em]" style={{ color }}>
            Attribute · {subject.attribute}
          </div>
          <h1 className="mt-1 font-display text-4xl font-bold sm:text-5xl">{subject.name_fr}</h1>
          {subject.description && (
            <p className="mt-2 text-muted-foreground">{subject.description}</p>
          )}
        </div>
      </div>

      <div className="mt-8 space-y-8">
        {chapters.map((c, ci) => {
          const chapEx = exercises.filter((e) => e.chapter_id === c.id);
          const quiz = chapEx.find((e) => e.mode === "quiz");
          const realEx = chapEx.filter((e) => e.mode !== "quiz");
          const quizPassed = quiz ? (quizPassedByChapter[c.id] ?? false) : true;
          const locked = !!quiz && !quizPassed;
          const completed = realEx.filter((e) => (bestByExercise[e.id] ?? 0) >= 40).length;
          const progressPct = realEx.length > 0 ? (completed / realEx.length) * 100 : 0;
          return (
            <motion.section
              key={c.id}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: ci * 0.05 }}
            >
              <div className="mb-3">
                <div className="flex items-center justify-between gap-3">
                  <h2
                    className="font-display text-xl font-bold"
                    dir={isRtlText(c.title) ? "rtl" : undefined}
                  >
                    {c.title}
                  </h2>
                  <div className="flex items-center gap-2 text-xs text-muted-foreground">
                    <span>
                      {completed}/{realEx.length}
                    </span>
                    {progressPct === 100 && realEx.length > 0 && (
                      <span className="text-emerald-400">✓</span>
                    )}
                  </div>
                </div>
                {/* Progress bar */}
                <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-secondary/60">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${progressPct}%`,
                      background: progressPct === 100 ? "var(--success, #10b981)" : color,
                    }}
                  />
                </div>
                {c.description && (
                  <p
                    className="mt-2 text-sm text-muted-foreground"
                    dir={isRtlText(c.description) ? "rtl" : undefined}
                  >
                    {c.description}
                  </p>
                )}
                <Link
                  to="/lesson/$chapterId"
                  params={{ chapterId: c.id }}
                  className="mt-2 inline-flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/10 px-3 py-1.5 text-xs font-semibold text-[color:var(--neon-cyan)] transition hover:bg-[color:var(--neon-cyan)]/20"
                >
                  <BookOpen className="h-3.5 w-3.5" /> {L.review}
                </Link>
              </div>
              {/* Mandatory comprehension quiz — gates the chapter exercises */}
              {quiz && (
                <Link
                  to="/quest/$exerciseId"
                  params={{ exerciseId: quiz.id }}
                  dir={isRtlSubject ? "rtl" : undefined}
                  className={`mb-3 flex items-center justify-between gap-3 rounded-xl border p-4 backdrop-blur-md transition hover:-translate-y-0.5 ${
                    quizPassed
                      ? "border-emerald-500/40 bg-emerald-500/5 hover:border-emerald-500/60"
                      : "border-[color:var(--neon-gold)]/50 bg-[color:var(--neon-gold)]/10 hover:border-[color:var(--neon-gold)]/70"
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <div className="grid h-10 w-10 place-items-center rounded-lg bg-[color:var(--neon-gold)]/15 text-[color:var(--neon-gold)]">
                      {quizPassed ? (
                        <CheckCircle2 className="h-5 w-5 text-emerald-400" />
                      ) : (
                        <Brain className="h-5 w-5" />
                      )}
                    </div>
                    <div>
                      <div className="flex items-center gap-2 font-semibold">
                        🧠 {L.quiz}
                        {!quizPassed && (
                          <span className="rounded-full bg-[color:var(--neon-gold)]/15 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[color:var(--neon-gold)]">
                            {L.required}
                          </span>
                        )}
                      </div>
                      <div className="text-xs text-muted-foreground">
                        {quizPassed ? L.passed : L.lockedNote}
                      </div>
                    </div>
                  </div>
                  <ChevronRight className="h-5 w-5 text-muted-foreground" />
                </Link>
              )}
              <div className="grid gap-3 sm:grid-cols-2">
                {realEx.map((ex) => {
                  const best = bestByExercise[ex.id];
                  const stars =
                    best == null ? 0 : best >= 90 ? 3 : best >= 70 ? 2 : best >= 40 ? 1 : 0;
                  const isBoss = ex.mode === "boss";
                  const isChallenge = ex.mode === "challenge";
                  const premiumLocked = isChallenge && !premiumUnlocked;
                  const left = (
                    <div className="flex items-center gap-3">
                      <div
                        className={`grid h-10 w-10 place-items-center rounded-lg ${
                          isChallenge
                            ? "bg-gradient-to-br from-[color:var(--neon-gold)]/30 to-[color:var(--neon-magenta)]/20 text-[color:var(--neon-gold)]"
                            : isBoss
                              ? "bg-gradient-to-br from-destructive/30 to-[color:var(--neon-magenta)]/20"
                              : ""
                        }`}
                        style={
                          !isBoss && !isChallenge
                            ? {
                                background: `color-mix(in oklab, ${color} 25%, transparent)`,
                                color,
                              }
                            : undefined
                        }
                      >
                        {locked ? (
                          <Lock className="h-5 w-5 text-muted-foreground" />
                        ) : isChallenge ? (
                          <Crown className="h-5 w-5" />
                        ) : isBoss ? (
                          <Skull className="h-5 w-5 text-destructive" />
                        ) : (
                          <Swords className="h-5 w-5" />
                        )}
                      </div>
                      <div>
                        <div
                          className="flex items-center gap-2 font-semibold"
                          dir={isRtlText(ex.title) ? "rtl" : undefined}
                        >
                          {ex.title}
                          {isBoss && (
                            <span className="rounded-full bg-destructive/15 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-destructive">
                              Boss
                            </span>
                          )}
                          {isChallenge && (
                            <span className="flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/15 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[color:var(--neon-gold)]">
                              <Crown className="h-3 w-3" /> {L.elite}
                            </span>
                          )}
                        </div>
                        <div className="flex items-center gap-2 text-xs text-muted-foreground">
                          <span>
                            Difficulty {ex.difficulty}/{isChallenge ? 4 : 3}
                          </span>
                          <span className="flex items-center gap-0.5 text-[color:var(--neon-gold)]">
                            <Zap className="h-3 w-3" />
                            {ex.xp_reward}
                          </span>
                          {premiumLocked && (
                            <span className="flex items-center gap-1 text-[color:var(--neon-gold)]">
                              <Lock className="h-3 w-3" /> {L.premiumLock}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                  if (locked) {
                    return (
                      <div
                        key={ex.id}
                        title={L.lockedNote}
                        aria-disabled="true"
                        className="flex cursor-not-allowed items-center justify-between gap-3 rounded-xl border border-border/40 bg-card/30 p-4 opacity-60"
                      >
                        {left}
                        <Lock className="h-5 w-5 text-muted-foreground" />
                      </div>
                    );
                  }
                  return (
                    <Link
                      key={ex.id}
                      to="/quest/$exerciseId"
                      params={{ exerciseId: ex.id }}
                      className={`group flex items-center justify-between gap-3 rounded-xl border p-4 backdrop-blur-md transition hover:-translate-y-0.5 ${
                        isChallenge
                          ? "border-[color:var(--neon-gold)]/50 bg-[color:var(--neon-gold)]/5 hover:border-[color:var(--neon-gold)]/70"
                          : isBoss
                            ? "border-destructive/40 bg-destructive/5 hover:border-destructive/70"
                            : "border-border/50 bg-card/60 hover:border-[color:var(--neon-violet)]/50"
                      }`}
                    >
                      {left}
                      <div className="flex items-center gap-2">
                        <div className="flex gap-0.5">
                          {[1, 2, 3].map((i) => (
                            <Star
                              key={i}
                              className={`h-3.5 w-3.5 ${i <= stars ? "fill-[color:var(--neon-gold)] text-[color:var(--neon-gold)]" : "text-muted-foreground/30"}`}
                            />
                          ))}
                        </div>
                        <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 rtl:-scale-x-100 rtl:group-hover:-translate-x-1 group-hover:text-foreground" />
                      </div>
                    </Link>
                  );
                })}
                {realEx.length === 0 && (
                  <div className="text-xs italic text-muted-foreground">No quests yet.</div>
                )}
              </div>
            </motion.section>
          );
        })}
      </div>
    </div>
  );
}
