import { createFileRoute, Link } from "@tanstack/react-router";
import { motion } from "motion/react";
import {
  Flame,
  Swords,
  Trophy,
  Sparkles,
  Zap,
  Target,
  Shield,
  BookOpen,
  Sword,
  Globe,
  Scroll,
  Leaf,
} from "lucide-react";
import heroImg from "@/assets/hero-warrior.jpg";
import { useT } from "@/lib/i18n";
import { LanguageSwitcher } from "@/components/ui/language-switcher";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "XP Scholars — The Shonen Academy for the 9th Grade Exam" },
      {
        name: "description",
        content:
          "Turn your study sessions into epic quests. XP, streaks, duels and bosses to prepare for the 9th grade exam.",
      },
      { property: "og:title", content: "XP Scholars" },
      { property: "og:description", content: "9th Grade Exam in RPG mode." },
    ],
  }),
  component: Landing,
});

const featureIcons = [Zap, Flame, Target, Swords, Trophy, Shield];
const featureColors = ["neon-violet", "flame", "neon-cyan", "neon-magenta", "neon-gold", "success"];
const subjectIcons = [Sword, BookOpen, Scroll, Leaf, Globe];
const subjectColors = [
  "subject-math",
  "subject-french",
  "subject-arabic",
  "subject-svt",
  "subject-english",
];

function Landing() {
  const t = useT();

  const features = [
    {
      icon: featureIcons[0],
      title: t.landing.featureXpTitle,
      desc: t.landing.featureXpDesc,
      color: featureColors[0],
    },
    {
      icon: featureIcons[1],
      title: t.landing.featureStreakTitle,
      desc: t.landing.featureStreakDesc,
      color: featureColors[1],
    },
    {
      icon: featureIcons[2],
      title: t.landing.featureRadarTitle,
      desc: t.landing.featureRadarDesc,
      color: featureColors[2],
    },
    {
      icon: featureIcons[3],
      title: t.landing.featureArenaTitle,
      desc: t.landing.featureArenaDesc,
      color: featureColors[3],
    },
    {
      icon: featureIcons[4],
      title: t.landing.featureBossTitle,
      desc: t.landing.featureBossDesc,
      color: featureColors[4],
    },
    {
      icon: featureIcons[5],
      title: t.landing.featureCurriculumTitle,
      desc: t.landing.featureCurriculumDesc,
      color: featureColors[5],
    },
  ];

  const subjects = [
    {
      icon: subjectIcons[0],
      name: t.landing.subjectMath,
      attr: t.landing.attrStrength,
      color: subjectColors[0],
    },
    {
      icon: subjectIcons[1],
      name: t.landing.subjectFrench,
      attr: t.landing.attrSpirit,
      color: subjectColors[1],
    },
    {
      icon: subjectIcons[2],
      name: t.landing.subjectArabic,
      attr: t.landing.attrWisdom,
      color: subjectColors[2],
    },
    {
      icon: subjectIcons[3],
      name: t.landing.subjectScience,
      attr: t.landing.attrObservation,
      color: subjectColors[3],
    },
    {
      icon: subjectIcons[4],
      name: t.landing.subjectEnglish,
      attr: t.landing.attrAgility,
      color: subjectColors[4],
    },
  ];

  const ranks = [
    ["Lvl 1-5", t.landing.rankCivilian, "neon-cyan"],
    ["Lvl 6-10", t.landing.rankAspirant, "neon-cyan"],
    ["Lvl 11-20", t.landing.rankWarrior, "neon-violet"],
    ["Lvl 21-30", t.landing.rankMaster, "neon-violet"],
    ["Lvl 31-45", t.landing.rankElite, "neon-magenta"],
    ["Lvl 50+", t.landing.rankLegend, "neon-gold"],
  ];

  return (
    <main className="min-h-screen overflow-hidden">
      {/* NAV */}
      <header className="relative z-20">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-5">
          <Link to="/" className="flex items-center gap-2">
            <div className="relative grid h-10 w-10 place-items-center rounded-lg bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
              <Sparkles className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="font-display text-xl font-bold tracking-wider">
              XP <span className="text-gradient-cyan">SCHOLARS</span>
            </span>
          </Link>
          <nav className="hidden items-center gap-8 text-sm text-muted-foreground md:flex">
            <a href="#features" className="hover:text-foreground">
              {t.landing.navSystem}
            </a>
            <a href="#subjects" className="hover:text-foreground">
              {t.landing.navSubjects}
            </a>
            <a href="#ranks" className="hover:text-foreground">
              {t.landing.navRanks}
            </a>
          </nav>
          <div className="flex items-center gap-2">
            <LanguageSwitcher />
            <Link
              to="/login"
              className="rounded-md px-4 py-2 text-sm text-muted-foreground hover:text-foreground"
            >
              {t.landing.signIn}
            </Link>
            <Link
              to="/signup"
              className="rounded-md bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-4 py-2 text-sm font-semibold text-primary-foreground shadow-neon"
            >
              {t.landing.joinAcademy}
            </Link>
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
              {t.landing.badge}
            </div>
            <h1 className="font-display text-5xl font-black leading-[1.05] sm:text-6xl lg:text-7xl">
              {t.landing.heroTitle1}{" "}
              <span className="text-gradient-primary">{t.landing.heroTitle2}</span>
              <br />
              <span className="text-gradient-cyan">{t.landing.heroTitle3}</span>
            </h1>
            <p className="mt-6 max-w-xl text-lg text-muted-foreground">{t.landing.heroDesc}</p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/signup"
                className="group inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-7 py-3.5 text-base font-bold text-primary-foreground shadow-neon transition-transform hover:scale-105"
              >
                {t.landing.ctaStart}{" "}
                <Swords className="h-5 w-5 transition-transform group-hover:rotate-12" />
              </Link>
              <Link
                to="/login"
                className="inline-flex items-center gap-2 rounded-lg border border-[color:var(--neon-cyan)]/40 bg-background/40 px-7 py-3.5 text-base font-semibold text-[color:var(--neon-cyan)] backdrop-blur-md hover:bg-[color:var(--neon-cyan)]/10"
              >
                {t.landing.ctaLogin}
              </Link>
            </div>
            <div className="mt-10 grid max-w-md grid-cols-3 gap-4 text-center">
              {[
                { v: "5", l: t.landing.statSubjects },
                { v: "200+", l: t.landing.statQuests },
                { v: "∞", l: t.landing.statStreak },
              ].map((s) => (
                <div key={s.l} className="glass rounded-xl px-2 py-3">
                  <div className="font-display text-2xl font-bold text-gradient-primary">{s.v}</div>
                  <div className="text-xs uppercase tracking-wider text-muted-foreground">
                    {s.l}
                  </div>
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
                  <div className="text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">
                    {t.landing.heroOverlayLevel}
                  </div>
                  <div className="font-display text-lg">{t.landing.heroOverlayName}</div>
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
          <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">
            {t.landing.featuresLabel}
          </div>
          <h2 className="font-display text-4xl font-bold sm:text-5xl">
            {t.landing.featuresTitle1}{" "}
            <span className="text-gradient-primary">{t.landing.featuresTitle2}</span>
          </h2>
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
                style={{
                  background: `color-mix(in oklab, var(--${f.color}) 25%, transparent)`,
                  color: `var(--${f.color})`,
                }}
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
            <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">
              {t.landing.subjectsLabel}
            </div>
            <h2 className="font-display text-4xl font-bold sm:text-5xl">
              {t.landing.subjectsTitle1}{" "}
              <span className="text-gradient-cyan">{t.landing.subjectsTitle2}</span>
            </h2>
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
                <div className="text-xs uppercase tracking-wider text-muted-foreground">
                  {t.landing.attributePrefix} · {s.attr}
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* RANKS */}
      <section id="ranks" className="mx-auto max-w-5xl px-6 py-24 text-center">
        <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">
          {t.landing.ranksLabel}
        </div>
        <h2 className="font-display text-4xl font-bold sm:text-5xl">
          {t.landing.ranksTitle1}{" "}
          <span className="text-gradient-primary">{t.landing.ranksTitle2}</span>
        </h2>
        <div className="mt-12 space-y-3">
          {ranks.map(([range, name, color]) => (
            <div
              key={name}
              className="glass flex items-center justify-between rounded-xl px-5 py-4 text-left"
            >
              <div className="text-xs font-mono uppercase tracking-widest text-muted-foreground">
                {range}
              </div>
              <div className="font-display text-lg font-bold" style={{ color: `var(--${color})` }}>
                {name}
              </div>
            </div>
          ))}
        </div>
        <Link
          to="/signup"
          className="mt-14 inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-8 py-4 text-base font-bold text-primary-foreground shadow-neon transition-transform hover:scale-105"
        >
          {t.landing.ranksCta} <Sparkles className="h-5 w-5" />
        </Link>
      </section>

      <footer className="border-t border-border/40 py-8 text-center text-xs text-muted-foreground">
        © {new Date().getFullYear()} XP Scholars · {t.landing.footer}
      </footer>
    </main>
  );
}
