import { createFileRoute, Link } from "@tanstack/react-router";
import { motion } from "motion/react";
import { Flame, Swords, Trophy, Sparkles, Zap, Target, Shield, BookOpen, Sword, Globe, Scroll, Leaf } from "lucide-react";
import heroImg from "@/assets/hero-warrior.jpg";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "XP Scholars — The Shonen Academy for the 9th Grade Exam" },
      { name: "description", content: "Turn your study sessions into epic quests. XP, streaks, duels and bosses to prepare for the 9th grade exam." },
      { property: "og:title", content: "XP Scholars" },
      { property: "og:description", content: "9th Grade Exam in RPG mode." },
    ],
  }),
  component: Landing,
});

const features = [
  { icon: Zap, title: "XP & Levels", desc: "Every correct answer earns you experience. Rise from Civilian Candidate to S-Rank Legend.", color: "neon-violet" },
  { icon: Flame, title: "Daily Streak", desc: "Study every day to keep your flame alive. 7 days in a row = warrior bonus.", color: "flame" },
  { icon: Target, title: "Success Radar", desc: "Strength, Spirit, Observation, Agility, Wisdom: visualize your true strengths.", color: "neon-cyan" },
  { icon: Swords, title: "Quest Arena", desc: "Timed MCQs. The faster and more accurate you are, the more points you score.", color: "neon-magenta" },
  { icon: Trophy, title: "Chapter Boss", desc: "Complete a chapter by defeating its Boss. HP bar, damage with every answer.", color: "neon-gold" },
  { icon: Shield, title: "Official Curriculum", desc: "Math, French, Arabic, Science, English. Aligned with the 9th grade exam.", color: "success" },
];

const subjects = [
  { icon: Sword, name: "Mathematics", attr: "Strength", color: "subject-math" },
  { icon: BookOpen, name: "French", attr: "Spirit", color: "subject-french" },
  { icon: Scroll, name: "العربية", attr: "Wisdom", color: "subject-arabic" },
  { icon: Leaf, name: "Science", attr: "Observation", color: "subject-svt" },
  { icon: Globe, name: "English", attr: "Agility", color: "subject-english" },
];

function Landing() {
  return (
    <main className="min-h-screen overflow-hidden">
      {/* NAV */}
      <header className="relative z-20">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-5">
          <Link to="/" className="flex items-center gap-2">
            <div className="relative grid h-10 w-10 place-items-center rounded-lg bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
              <Sparkles className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="font-display text-xl font-bold tracking-wider">XP <span className="text-gradient-cyan">SCHOLARS</span></span>
          </Link>
          <nav className="hidden items-center gap-8 text-sm text-muted-foreground md:flex">
            <a href="#features" className="hover:text-foreground">System</a>
            <a href="#subjects" className="hover:text-foreground">Subjects</a>
            <a href="#ranks" className="hover:text-foreground">Ranks</a>
          </nav>
          <div className="flex items-center gap-2">
            <Link to="/login" className="rounded-md px-4 py-2 text-sm text-muted-foreground hover:text-foreground">Sign in</Link>
            <Link to="/signup" className="rounded-md bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-4 py-2 text-sm font-semibold text-primary-foreground shadow-neon">Join the Academy</Link>
          </div>
        </div>
      </header>

      {/* HERO */}
      <section className="relative">
        <div className="absolute inset-0 bg-hero" />
        <div className="absolute inset-0 bg-grid opacity-60" />
        <div className="relative mx-auto grid max-w-7xl grid-cols-1 gap-12 px-6 pb-24 pt-12 lg:grid-cols-2 lg:items-center lg:pt-20">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7 }}
            className="relative z-10"
          >
            <div className="mb-6 inline-flex items-center gap-2 rounded-full glass px-4 py-1.5 text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">
              <Flame className="h-3.5 w-3.5 animate-flame text-[color:var(--flame)]" />
              9th Grade Exam · RPG Mode
            </div>
            <h1 className="font-display text-5xl font-black leading-[1.05] sm:text-6xl lg:text-7xl">
              Become the <span className="text-gradient-primary">Legend</span><br />
              of the <span className="text-gradient-cyan">9th Grade</span> Exam
            </h1>
            <p className="mt-6 max-w-xl text-lg text-muted-foreground">
              XP Scholars turns your study sessions into manga quests. Earn XP, ignite your streak,
              rank up and defeat Chapter Bosses to ace the exam.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/signup"
                className="group inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-7 py-3.5 text-base font-bold text-primary-foreground shadow-neon transition-transform hover:scale-105"
              >
                Start my quest <Swords className="h-5 w-5 transition-transform group-hover:rotate-12" />
              </Link>
              <Link
                to="/login"
                className="inline-flex items-center gap-2 rounded-lg border border-[color:var(--neon-cyan)]/40 bg-background/40 px-7 py-3.5 text-base font-semibold text-[color:var(--neon-cyan)] backdrop-blur-md hover:bg-[color:var(--neon-cyan)]/10"
              >
                I already have a hero
              </Link>
            </div>
            <div className="mt-10 grid max-w-md grid-cols-3 gap-4 text-center">
              {[
                { v: "5", l: "Subjects" },
                { v: "200+", l: "Quests" },
                { v: "∞", l: "Streak" },
              ].map((s) => (
                <div key={s.l} className="glass rounded-xl px-2 py-3">
                  <div className="font-display text-2xl font-bold text-gradient-primary">{s.v}</div>
                  <div className="text-xs uppercase tracking-wider text-muted-foreground">{s.l}</div>
                </div>
              ))}
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.9, delay: 0.1 }}
            className="relative"
          >
            <div className="absolute -inset-4 rounded-3xl bg-gradient-to-br from-[color:var(--neon-violet)]/30 to-[color:var(--neon-cyan)]/20 blur-3xl" />
            <div className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-violet)]/30 shadow-neon">
              <img
                src={heroImg}
                alt="Shonen warrior wielding a katana made of equations in a neon arena"
                width={1600}
                height={1280}
                className="h-full w-full object-cover"
              />
              <div className="absolute inset-x-0 bottom-0 flex items-end justify-between gap-4 bg-gradient-to-t from-background via-background/70 to-transparent p-5">
                <div>
                  <div className="text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">Lvl 42 · Equation Warrior</div>
                  <div className="font-display text-lg">XP "The Blade"</div>
                </div>
                <div className="flex items-center gap-1.5 rounded-full bg-[color:var(--flame)]/20 px-3 py-1.5 text-sm font-bold text-[color:var(--flame)]">
                  <Flame className="h-4 w-4 animate-flame" /> 27
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </section>

      {/* FEATURES */}
      <section id="features" className="relative mx-auto max-w-7xl px-6 py-24">
        <div className="mb-14 text-center">
          <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">The System</div>
          <h2 className="font-display text-4xl font-bold sm:text-5xl">Not an app. <span className="text-gradient-primary">An arena.</span></h2>
        </div>
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {features.map((f, i) => (
            <motion.div
              key={f.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-50px" }}
              transition={{ duration: 0.5, delay: i * 0.05 }}
              className="group relative overflow-hidden rounded-2xl glass p-6 transition-all hover:-translate-y-1 hover:border-[color:var(--neon-violet)]/60"
            >
              <div
                className="mb-4 grid h-12 w-12 place-items-center rounded-xl"
                style={{ background: `color-mix(in oklab, var(--${f.color}) 25%, transparent)`, color: `var(--${f.color})` }}
              >
                <f.icon className="h-6 w-6" />
              </div>
              <h3 className="font-display text-lg font-bold">{f.title}</h3>
              <p className="mt-2 text-sm text-muted-foreground">{f.desc}</p>
            </motion.div>
          ))}
        </div>
      </section>

      {/* SUBJECTS */}
      <section id="subjects" className="relative border-y border-border/40 bg-card/30 py-24">
        <div className="mx-auto max-w-7xl px-6">
          <div className="mb-12 text-center">
            <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">The 5 Paths</div>
            <h2 className="font-display text-4xl font-bold sm:text-5xl">Choose your <span className="text-gradient-cyan">hero's path</span></h2>
          </div>
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
            {subjects.map((s, i) => (
              <motion.div
                key={s.name}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: i * 0.06 }}
                className="group relative overflow-hidden rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-md transition-all hover:scale-105"
                style={{ boxShadow: `0 0 0 0 var(--${s.color})` }}
              >
                <div
                  className="absolute -right-6 -top-6 h-24 w-24 rounded-full blur-2xl opacity-40 transition-opacity group-hover:opacity-80"
                  style={{ background: `var(--${s.color})` }}
                />
                <s.icon className="h-8 w-8" style={{ color: `var(--${s.color})` }} />
                <div className="mt-4 font-display text-lg font-bold">{s.name}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Attribute · {s.attr}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* RANKS */}
      <section id="ranks" className="mx-auto max-w-5xl px-6 py-24 text-center">
        <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">Progression</div>
        <h2 className="font-display text-4xl font-bold sm:text-5xl">From Civilian to <span className="text-gradient-primary">S-Rank Legend</span></h2>
        <div className="mt-12 space-y-3">
          {[
            ["Lvl 1-5", "Civilian Candidate", "neon-cyan"],
            ["Lvl 6-10", "Academy Aspirant", "neon-cyan"],
            ["Lvl 11-20", "Equation Warrior", "neon-violet"],
            ["Lvl 21-30", "Language Master", "neon-violet"],
            ["Lvl 31-45", "Exam Elite", "neon-magenta"],
            ["Lvl 50+", "S-Rank Legend", "neon-gold"],
          ].map(([range, name, color]) => (
            <div key={name} className="glass flex items-center justify-between rounded-xl px-5 py-4 text-left">
              <div className="text-xs font-mono uppercase tracking-widest text-muted-foreground">{range}</div>
              <div className="font-display text-lg font-bold" style={{ color: `var(--${color})` }}>{name}</div>
            </div>
          ))}
        </div>
        <Link
          to="/signup"
          className="mt-14 inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-8 py-4 text-base font-bold text-primary-foreground shadow-neon transition-transform hover:scale-105"
        >
          Forge my hero <Sparkles className="h-5 w-5" />
        </Link>
      </section>

      <footer className="border-t border-border/40 py-8 text-center text-xs text-muted-foreground">
                © {new Date().getFullYear()} XP Scholars · 9th Grade Exam · Tunisia
      </footer>
    </main>
  );
}
