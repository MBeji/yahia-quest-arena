import { createFileRoute, Link } from "@tanstack/react-router";
import { lazy, Suspense, useEffect, useState } from "react";
import { motion, MotionConfig, useReducedMotion } from "motion/react";
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
  Crown,
  Sparkle,
} from "lucide-react";
import heroImg from "@/assets/hero-warrior.jpg";
import { useT } from "@/lib/i18n";
import { fr } from "@/lib/i18n/fr";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { ThemeSwitcher } from "@/components/ui/theme-switcher";
import { useIsMobile } from "@/hooks/use-mobile";
import { useLenis } from "@/components/landing/use-lenis";

// three.js only loads on the landing, only when 3D is actually shown.
const GoldenHeroCanvas = lazy(() => import("@/components/landing/golden-hero-canvas"));

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      // Route-static head (no per-request locale): default-locale (FR) catalog,
      // mirroring __root.tsx. Per-locale head = future i18n increment.
      { title: fr.meta.title },
      { name: "description", content: fr.meta.description },
      { property: "og:title", content: fr.meta.ogTitle },
      { property: "og:description", content: fr.meta.ogDescription },
    ],
  }),
  component: Landing,
});

const featureIcons = [Zap, Flame, Target, Swords, Trophy, Shield];
const subjectIcons = [Sword, BookOpen, Scroll, Leaf, Globe];
const subjectColors = [
  "subject-math",
  "subject-french",
  "subject-arabic",
  "subject-svt",
  "subject-english",
];

/** Soft gold glow used as the hero backdrop and the 3D fallback. */
function GoldGlow() {
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden">
      <div className="absolute left-1/2 top-1/2 h-[120%] w-[120%] -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle_at_center,oklch(0.83_0.15_86/0.22),transparent_60%)]" />
      <div className="animate-float absolute right-[12%] top-[18%] h-40 w-40 rounded-full bg-[radial-gradient(circle,oklch(0.92_0.12_96/0.35),transparent_70%)] blur-2xl" />
    </div>
  );
}

function Landing() {
  const t = useT();
  const isMobile = useIsMobile();
  const prefersReduced = useReducedMotion();

  const [mounted, setMounted] = useState(false);
  const [reduceAnims, setReduceAnims] = useState(false);
  useEffect(() => setMounted(true), []);
  useEffect(() => setReduceAnims(!!prefersReduced), [prefersReduced]);

  const animate = !reduceAnims;
  const show3D = mounted && animate && !isMobile;
  useLenis(animate && !isMobile);

  const features = [
    { icon: featureIcons[0], title: t.landing.featureXpTitle, desc: t.landing.featureXpDesc },
    {
      icon: featureIcons[1],
      title: t.landing.featureStreakTitle,
      desc: t.landing.featureStreakDesc,
    },
    { icon: featureIcons[2], title: t.landing.featureRadarTitle, desc: t.landing.featureRadarDesc },
    { icon: featureIcons[3], title: t.landing.featureArenaTitle, desc: t.landing.featureArenaDesc },
    { icon: featureIcons[4], title: t.landing.featureBossTitle, desc: t.landing.featureBossDesc },
    {
      icon: featureIcons[5],
      title: t.landing.featureCurriculumTitle,
      desc: t.landing.featureCurriculumDesc,
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

  const ranks: [string, string][] = [
    ["Lvl 1-5", t.landing.rankCivilian],
    ["Lvl 6-10", t.landing.rankAspirant],
    ["Lvl 11-20", t.landing.rankWarrior],
    ["Lvl 21-30", t.landing.rankMaster],
    ["Lvl 31-45", t.landing.rankElite],
    ["Lvl 50+", t.landing.rankLegend],
  ];

  const goldCta =
    "group inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-7 py-3.5 text-base font-bold text-black shadow-gold transition-transform hover:scale-105";

  return (
    <MotionConfig reducedMotion={reduceAnims ? "always" : "never"}>
      <main className="relative min-h-screen overflow-hidden bg-black-deep text-foreground">
        {/* reduce-motion toggle */}
        <button
          type="button"
          onClick={() => setReduceAnims((v) => !v)}
          aria-pressed={reduceAnims}
          className="fixed bottom-4 right-4 z-50 flex items-center gap-1.5 rounded-full glass-gold px-3 py-1.5 text-[11px] font-semibold text-champagne backdrop-blur-md transition hover:scale-105"
        >
          <Sparkle className="h-3.5 w-3.5" />
          {reduceAnims ? "Activer les animations" : "Réduire les animations"}
        </button>

        {/* NAV */}
        <header className="relative z-20">
          <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-5">
            <Link to="/" className="flex items-center gap-2">
              <div className="relative grid h-10 w-10 place-items-center rounded-lg bg-[image:var(--gradient-gold)] shadow-gold">
                <Crown className="h-5 w-5 text-black" />
              </div>
              <span className="font-display text-xl font-bold tracking-wider">
                XP <span className="text-gradient-gold gold-sheen">SCHOLARS</span>
              </span>
            </Link>
            <nav className="hidden items-center gap-8 text-sm text-muted-foreground md:flex">
              <a href="#features" className="transition hover:text-champagne">
                {t.landing.navSystem}
              </a>
              <a href="#subjects" className="transition hover:text-champagne">
                {t.landing.navSubjects}
              </a>
              <a href="#ranks" className="transition hover:text-champagne">
                {t.landing.navRanks}
              </a>
            </nav>
            <div className="flex items-center gap-2">
              <LanguageSwitcher />
              <ThemeSwitcher />
              <Link
                to="/login"
                className="rounded-md px-4 py-2 text-sm text-muted-foreground transition hover:text-champagne"
              >
                {t.landing.signIn}
              </Link>
              <Link
                to="/signup"
                className="rounded-md bg-[image:var(--gradient-gold)] px-4 py-2 text-sm font-semibold text-black shadow-gold"
              >
                {t.landing.joinAcademy}
              </Link>
            </div>
          </div>
        </header>

        {/* HERO */}
        <section className="relative">
          <div className="absolute inset-0 bg-gold-grid opacity-70" />
          <div className="relative mx-auto grid max-w-7xl grid-cols-1 gap-12 px-6 pb-24 pt-12 lg:grid-cols-2 lg:items-center lg:pt-20">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7 }}
              className="relative z-10"
            >
              <div className="mb-6 inline-flex items-center gap-2 rounded-full glass-gold px-4 py-1.5 text-xs uppercase tracking-widest text-champagne">
                <Flame className="h-3.5 w-3.5 animate-flame text-[color:var(--gold)]" />
                {t.landing.badge}
              </div>
              <h1 className="font-display text-5xl font-black leading-[1.05] sm:text-6xl lg:text-7xl">
                {t.landing.heroTitle1}{" "}
                <span className="text-gradient-gold gold-sheen">{t.landing.heroTitle2}</span>
                <br />
                <span className="text-champagne">{t.landing.heroTitle3}</span>
              </h1>
              <p className="mt-6 max-w-xl text-lg text-muted-foreground">{t.landing.heroDesc}</p>
              <div className="mt-8 flex flex-wrap gap-3">
                <Link to="/signup" className={goldCta}>
                  {t.landing.ctaStart}{" "}
                  <Swords className="h-5 w-5 transition-transform group-hover:rotate-12" />
                </Link>
                <Link
                  to="/login"
                  className="inline-flex items-center gap-2 rounded-lg border-gold bg-white/5 px-7 py-3.5 text-base font-semibold text-champagne backdrop-blur-md transition hover:bg-[color:var(--gold)]/10"
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
                  <div key={s.l} className="glass-gold rounded-xl px-2 py-3">
                    <div className="font-display text-2xl font-bold text-gradient-gold">{s.v}</div>
                    <div className="text-xs uppercase tracking-wider text-muted-foreground">
                      {s.l}
                    </div>
                  </div>
                ))}
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, scale: 0.92 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.9, delay: 0.1 }}
              className="relative"
            >
              <div className="absolute -inset-6 rounded-[2rem] bg-[radial-gradient(circle_at_center,oklch(0.83_0.15_86/0.25),transparent_65%)] blur-2xl" />
              <div className="animate-gold-pulse relative aspect-square overflow-hidden rounded-[2rem] border-gold bg-black/40">
                {show3D ? (
                  <Suspense fallback={<GoldGlow />}>
                    <GoldenHeroCanvas />
                  </Suspense>
                ) : (
                  <>
                    <GoldGlow />
                    <img
                      src={heroImg}
                      alt="Shonen warrior wielding a katana made of equations"
                      width={1600}
                      height={1280}
                      className="h-full w-full object-cover opacity-70 mix-blend-luminosity"
                    />
                  </>
                )}
                <div className="pointer-events-none absolute inset-x-0 bottom-0 flex items-end justify-between gap-4 bg-gradient-to-t from-black via-black/60 to-transparent p-5">
                  <div>
                    <div className="text-xs uppercase tracking-widest text-[color:var(--gold)]">
                      {t.landing.heroOverlayLevel}
                    </div>
                    <div className="font-display text-lg">{t.landing.heroOverlayName}</div>
                  </div>
                  <div className="flex items-center gap-1.5 rounded-full bg-[color:var(--gold)]/15 px-3 py-1.5 text-sm font-bold text-[color:var(--gold)]">
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
            <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--gold)]">
              {t.landing.featuresLabel}
            </div>
            <h2 className="font-display text-4xl font-bold sm:text-5xl">
              {t.landing.featuresTitle1}{" "}
              <span className="text-gradient-gold">{t.landing.featuresTitle2}</span>
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
                className="group relative overflow-hidden rounded-2xl glass-gold p-6 transition-all hover:-translate-y-1 hover:shadow-gold"
              >
                <div className="mb-4 grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--gold)]/15 text-[color:var(--gold)]">
                  <f.icon className="h-6 w-6" />
                </div>
                <h3 className="font-display text-lg font-bold">{f.title}</h3>
                <p className="mt-2 text-sm text-muted-foreground">{f.desc}</p>
              </motion.div>
            ))}
          </div>
        </section>

        {/* SUBJECTS */}
        <section id="subjects" className="relative border-y border-[color:var(--gold)]/15 py-24">
          <div className="mx-auto max-w-7xl px-6">
            <div className="mb-12 text-center">
              <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--gold)]">
                {t.landing.subjectsLabel}
              </div>
              <h2 className="font-display text-4xl font-bold sm:text-5xl">
                {t.landing.subjectsTitle1}{" "}
                <span className="text-gradient-gold">{t.landing.subjectsTitle2}</span>
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
                  className="group relative overflow-hidden rounded-2xl glass-gold p-5 transition-all hover:-translate-y-1 hover:shadow-gold"
                >
                  <div
                    className="absolute -right-6 -top-6 h-24 w-24 rounded-full blur-2xl opacity-30 transition-opacity group-hover:opacity-70"
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
          <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--gold)]">
            {t.landing.ranksLabel}
          </div>
          <h2 className="font-display text-4xl font-bold sm:text-5xl">
            {t.landing.ranksTitle1}{" "}
            <span className="text-gradient-gold">{t.landing.ranksTitle2}</span>
          </h2>
          <div className="mt-12 space-y-3">
            {ranks.map(([range, name]) => (
              <div
                key={name}
                className="glass-gold flex items-center justify-between rounded-xl px-5 py-4 text-left"
              >
                <div className="text-xs font-mono uppercase tracking-widest text-muted-foreground">
                  {range}
                </div>
                <div className="font-display text-lg font-bold text-gradient-gold">{name}</div>
              </div>
            ))}
          </div>
          <Link to="/signup" className={`${goldCta} mt-14`}>
            {t.landing.ranksCta} <Sparkles className="h-5 w-5" />
          </Link>
        </section>

        <footer className="border-t border-[color:var(--gold)]/15 py-8 text-center text-xs text-muted-foreground">
          © {new Date().getFullYear()} XP Scholars · {t.landing.footer}
        </footer>
      </main>
    </MotionConfig>
  );
}
