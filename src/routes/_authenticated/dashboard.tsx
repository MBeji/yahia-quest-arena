import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { Flame, Zap, Trophy, Swords, Sword, BookOpen, Scroll, Leaf, Globe, ChevronRight, Sparkles } from "lucide-react";
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, ResponsiveContainer } from "recharts";
import { getDashboard } from "@/lib/gamification.functions";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Hall des héros · YahiaAcademy" }] }),
  component: Dashboard,
});

const ICONS: Record<string, React.ComponentType<{ className?: string }>> = {
  Sword, BookOpen, Scroll, Leaf, Globe,
};

function Dashboard() {
  const fetchDashboard = useServerFn(getDashboard);
  const { data, isLoading } = useQuery({ queryKey: ["dashboard"], queryFn: () => fetchDashboard() });

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Chargement de ton héros…</div>;
  }

  const { profile, subjects, stats } = data;
  if (!profile) return <div className="p-8 text-center text-muted-foreground">Profil introuvable.</div>;

  const xpInLevel = profile.xp % 200;
  const xpPct = (xpInLevel / 200) * 100;

  const radarData = subjects.map((s) => ({
    subject: s.attribute,
    value: Math.round(stats[s.id]?.avg ?? 0),
  }));

  return (
    <div className="mx-auto max-w-7xl px-6 py-8">
      {/* HERO HEADER */}
      <motion.div
        initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
        className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-violet)]/30 bg-card/40 p-6 backdrop-blur-xl shadow-card sm:p-8"
      >
        <div className="absolute -right-10 -top-10 h-48 w-48 rounded-full bg-[color:var(--neon-violet)]/30 blur-3xl" />
        <div className="absolute -bottom-10 -left-10 h-48 w-48 rounded-full bg-[color:var(--neon-cyan)]/20 blur-3xl" />
        <div className="relative grid gap-6 sm:grid-cols-[auto,1fr,auto] sm:items-center">
          <div className="grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon animate-pulse-neon">
            <Sparkles className="h-9 w-9 text-primary-foreground" />
          </div>
          <div>
            <div className="text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">{profile.hero_class}</div>
            <h1 className="font-display text-3xl font-bold sm:text-4xl">{profile.display_name}</h1>
            <div className="mt-3 flex flex-wrap items-center gap-3">
              <div className="rounded-full bg-[color:var(--neon-violet)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-violet)]">Lvl {profile.level}</div>
              <div className="flex items-center gap-1 rounded-full bg-[color:var(--flame)]/20 px-3 py-1 text-sm font-bold text-[color:var(--flame)]">
                <Flame className="h-4 w-4 animate-flame" /> {profile.current_streak} {profile.current_streak > 1 ? "jours" : "jour"}
              </div>
              <div className="flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-gold)]">
                <Zap className="h-4 w-4" /> {profile.xp} XP
              </div>
            </div>
            <div className="mt-4">
              <div className="mb-1 flex justify-between text-xs text-muted-foreground">
                <span>Niveau {profile.level}</span><span>{xpInLevel} / 200 XP</span>
              </div>
              <div className="h-2.5 overflow-hidden rounded-full bg-secondary">
                <div
                  className="h-full rounded-full bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon transition-all"
                  style={{ width: `${xpPct}%` }}
                />
              </div>
            </div>
          </div>
          <div className="hidden sm:block">
            <div className="text-right text-xs uppercase tracking-widest text-muted-foreground">Plus longue flamme</div>
            <div className="text-right font-display text-2xl font-bold text-[color:var(--flame)]">{profile.longest_streak}j</div>
          </div>
        </div>
      </motion.div>

      <div className="mt-8 grid gap-6 lg:grid-cols-[1fr,360px]">
        {/* SUBJECTS GRID */}
        <section>
          <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
            <Swords className="h-5 w-5 text-[color:var(--neon-violet)]" /> Les voies à conquérir
          </h2>
          <div className="grid gap-4 sm:grid-cols-2">
            {subjects.map((s, i) => {
              const Icon = ICONS[s.icon] ?? Sword;
              const st = stats[s.id];
              return (
                <motion.div
                  key={s.id}
                  initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05 }}
                >
                  <Link
                    to="/subject/$subjectId" params={{ subjectId: s.id }}
                    className="group relative block overflow-hidden rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-md transition hover:-translate-y-1 hover:border-[color:var(--neon-violet)]/60"
                  >
                    <div
                      className="absolute -right-8 -top-8 h-28 w-28 rounded-full blur-2xl opacity-50 transition-opacity group-hover:opacity-90"
                      style={{ background: `var(--${s.color_token === 'math' ? 'subject-math' : s.color_token === 'french' ? 'subject-french' : s.color_token === 'arabic' ? 'subject-arabic' : s.color_token === 'svt' ? 'subject-svt' : 'subject-english'})` }}
                    />
                    <div className="relative flex items-start justify-between">
                      <Icon className="h-8 w-8" style={{ color: `var(--subject-${s.color_token})` }} />
                      <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
                    </div>
                    <div className="relative mt-4">
                      <div className="font-display text-lg font-bold">{s.name_fr}</div>
                      <div className="text-xs uppercase tracking-wider text-muted-foreground">Attribut · {s.attribute}</div>
                    </div>
                    <div className="relative mt-4 flex items-center justify-between text-xs">
                      <span className="text-muted-foreground">{st ? `${st.count} quête${st.count > 1 ? "s" : ""}` : "Pas encore tentée"}</span>
                      <span className="font-bold" style={{ color: `var(--subject-${s.color_token})` }}>
                        {st ? `${Math.round(st.avg)}%` : "—"}
                      </span>
                    </div>
                  </Link>
                </motion.div>
              );
            })}
          </div>
        </section>

        {/* RADAR */}
        <section>
          <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
            <Trophy className="h-5 w-5 text-[color:var(--neon-gold)]" /> Radar du succès
          </h2>
          <div className="rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
            <div className="h-72 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <RadarChart data={radarData}>
                  <PolarGrid stroke="oklch(0.66 0.27 295 / 0.25)" />
                  <PolarAngleAxis dataKey="subject" tick={{ fill: "oklch(0.72 0.04 270)", fontSize: 11 }} />
                  <Radar
                    name="Maîtrise"
                    dataKey="value"
                    stroke="oklch(0.66 0.27 295)"
                    fill="oklch(0.66 0.27 295)"
                    fillOpacity={0.4}
                  />
                </RadarChart>
              </ResponsiveContainer>
            </div>
            <p className="px-2 pb-2 text-center text-xs text-muted-foreground">Tes scores moyens par attribut.</p>
          </div>
        </section>
      </div>
    </div>
  );
}
