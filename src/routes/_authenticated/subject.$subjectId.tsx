import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { ArrowLeft, Swords, Zap, ChevronRight, Star, Skull, BookOpen } from "lucide-react";
import { getSubject } from "@/lib/gamification.functions";
import { isRtlText } from "@/lib/utils";

export const Route = createFileRoute("/_authenticated/subject/$subjectId")({
  head: () => ({ meta: [{ title: "Quests · XP Scholars" }] }),
  component: SubjectPage,
});

function SubjectPage() {
  const { subjectId } = Route.useParams();
  const fetchSubject = useServerFn(getSubject);
  const { data, isLoading } = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
  });

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Loading…</div>;
  }
  const { subject, chapters, exercises, bestByExercise } = data;
  const color = `var(--subject-${subject.color_token})`;

  return (
    <div className="mx-auto max-w-5xl px-6 py-8">
      <Link to="/dashboard" className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-4 w-4" /> Heroes Hall
      </Link>

      <div className="relative overflow-hidden rounded-3xl border border-border/50 bg-card/60 p-8 backdrop-blur-xl">
        <div className="absolute -right-10 -top-10 h-52 w-52 rounded-full blur-3xl opacity-50" style={{ background: color }} />
        <div className="relative">
          <div className="text-xs uppercase tracking-[0.3em]" style={{ color }}>Attribute · {subject.attribute}</div>
          <h1 className="mt-1 font-display text-4xl font-bold sm:text-5xl">{subject.name_fr}</h1>
          {subject.description && <p className="mt-2 text-muted-foreground">{subject.description}</p>}
        </div>
      </div>

      <div className="mt-8 space-y-8">
        {chapters.map((c, ci) => {
          const chapEx = exercises.filter((e) => e.chapter_id === c.id);
          return (
            <motion.section
              key={c.id}
              initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: ci * 0.05 }}
            >
              <div className="mb-3">
                <h2 className="font-display text-xl font-bold" dir={isRtlText(c.title) ? "rtl" : undefined}>{c.title}</h2>
                {c.description && <p className="text-sm text-muted-foreground" dir={isRtlText(c.description) ? "rtl" : undefined}>{c.description}</p>}
                <Link
                  to="/lesson/$chapterId" params={{ chapterId: c.id }}
                  className="mt-2 inline-flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/10 px-3 py-1.5 text-xs font-semibold text-[color:var(--neon-cyan)] transition hover:bg-[color:var(--neon-cyan)]/20"
                >
                  <BookOpen className="h-3.5 w-3.5" /> 📖 ملخص الدرس
                </Link>
              </div>
              <div className="grid gap-3 sm:grid-cols-2">
                {chapEx.map((ex) => {
                  const best = bestByExercise[ex.id];
                  const stars = best == null ? 0 : best >= 90 ? 3 : best >= 70 ? 2 : best >= 40 ? 1 : 0;
                  const isBoss = ex.mode === "boss";
                  return (
                    <Link
                      key={ex.id}
                      to="/quest/$exerciseId" params={{ exerciseId: ex.id }}
                      className={`group flex items-center justify-between gap-3 rounded-xl border p-4 backdrop-blur-md transition hover:-translate-y-0.5 ${
                        isBoss
                          ? "border-destructive/40 bg-destructive/5 hover:border-destructive/70"
                          : "border-border/50 bg-card/60 hover:border-[color:var(--neon-violet)]/50"
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <div className={`grid h-10 w-10 place-items-center rounded-lg ${isBoss ? "bg-gradient-to-br from-destructive/30 to-[color:var(--neon-magenta)]/20" : ""}`} style={!isBoss ? { background: `color-mix(in oklab, ${color} 25%, transparent)`, color } : undefined}>
                          {isBoss ? <Skull className="h-5 w-5 text-destructive" /> : <Swords className="h-5 w-5" />}
                        </div>
                        <div>
                          <div className="flex items-center gap-2 font-semibold" dir={isRtlText(ex.title) ? "rtl" : undefined}>
                            {ex.title}
                            {isBoss && <span className="rounded-full bg-destructive/15 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-destructive">Boss</span>}
                          </div>
                          <div className="flex items-center gap-2 text-xs text-muted-foreground">
                            <span>Difficulty {ex.difficulty}/3</span>
                            <span className="flex items-center gap-0.5 text-[color:var(--neon-gold)]"><Zap className="h-3 w-3" />{ex.xp_reward}</span>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="flex gap-0.5">
                          {[1, 2, 3].map((i) => (
                            <Star key={i} className={`h-3.5 w-3.5 ${i <= stars ? "fill-[color:var(--neon-gold)] text-[color:var(--neon-gold)]" : "text-muted-foreground/30"}`} />
                          ))}
                        </div>
                        <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
                      </div>
                    </Link>
                  );
                })}
                {chapEx.length === 0 && <div className="text-xs italic text-muted-foreground">No quests yet.</div>}
              </div>
            </motion.section>
          );
        })}
      </div>
    </div>
  );
}
