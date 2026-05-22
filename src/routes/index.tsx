import { createFileRoute, Link } from "@tanstack/react-router";
import { motion } from "motion/react";
import { Flame, Swords, Trophy, Sparkles, Zap, Target, Shield, BookOpen, Sword, Globe, Scroll, Leaf } from "lucide-react";
import heroImg from "@/assets/hero-warrior.jpg";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "YahiaAcademy — L'académie shonen du concours 9ème" },
      { name: "description", content: "Transforme la révision en quête épique. XP, flamme, duels et boss pour préparer le concours de 9ème année." },
      { property: "og:title", content: "YahiaAcademy" },
      { property: "og:description", content: "Concours 9ème en mode RPG manga." },
    ],
  }),
  component: Landing,
});

const features = [
  { icon: Zap, title: "XP & Niveaux", desc: "Chaque bonne réponse te fait gagner de l'expérience. Passe de Candidat Civil à Légende S-Rank.", color: "neon-violet" },
  { icon: Flame, title: "Flamme quotidienne", desc: "Révise chaque jour pour entretenir ta flamme. 7 jours d'affilée = bonus de guerrier.", color: "flame" },
  { icon: Target, title: "Radar du Succès", desc: "Force, Esprit, Observation, Agilité, Sagesse : visualise tes vraies forces.", color: "neon-cyan" },
  { icon: Swords, title: "Arène de quêtes", desc: "QCM minutés. Plus tu es rapide et juste, plus tu marques de points.", color: "neon-magenta" },
  { icon: Trophy, title: "Boss de chapitre", desc: "Termine un chapitre en battant son Boss. Barre de HP, dégâts à chaque réponse.", color: "neon-gold" },
  { icon: Shield, title: "Programme officiel", desc: "Maths, Français, Arabe, SVT, Anglais. Conforme au concours de 9ème année.", color: "success" },
];

const subjects = [
  { icon: Sword, name: "Mathématiques", attr: "Force", color: "subject-math" },
  { icon: BookOpen, name: "Français", attr: "Esprit", color: "subject-french" },
  { icon: Scroll, name: "العربية", attr: "Sagesse", color: "subject-arabic" },
  { icon: Leaf, name: "SVT", attr: "Observation", color: "subject-svt" },
  { icon: Globe, name: "English", attr: "Agilité", color: "subject-english" },
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
            <span className="font-display text-xl font-bold tracking-wider">YAHIA<span className="text-gradient-cyan">ACADEMY</span></span>
          </Link>
          <nav className="hidden items-center gap-8 text-sm text-muted-foreground md:flex">
            <a href="#features" className="hover:text-foreground">Système</a>
            <a href="#subjects" className="hover:text-foreground">Matières</a>
            <a href="#ranks" className="hover:text-foreground">Rangs</a>
          </nav>
          <div className="flex items-center gap-2">
            <Link to="/login" className="rounded-md px-4 py-2 text-sm text-muted-foreground hover:text-foreground">Connexion</Link>
            <Link to="/signup" className="rounded-md bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-4 py-2 text-sm font-semibold text-primary-foreground shadow-neon">Rejoindre l'académie</Link>
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
              Concours 9ème · Mode RPG
            </div>
            <h1 className="font-display text-5xl font-black leading-[1.05] sm:text-6xl lg:text-7xl">
              Deviens la <span className="text-gradient-primary">Légende</span><br />
              du concours de <span className="text-gradient-cyan">9ème</span>
            </h1>
            <p className="mt-6 max-w-xl text-lg text-muted-foreground">
              YahiaAcademy transforme tes révisions en quêtes manga. Gagne de l'XP, allume ta flamme,
              monte de rang et bats les Boss de chapitre pour décrocher le concours.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/signup"
                className="group inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-7 py-3.5 text-base font-bold text-primary-foreground shadow-neon transition-transform hover:scale-105"
              >
                Commencer ma quête <Swords className="h-5 w-5 transition-transform group-hover:rotate-12" />
              </Link>
              <Link
                to="/login"
                className="inline-flex items-center gap-2 rounded-lg border border-[color:var(--neon-cyan)]/40 bg-background/40 px-7 py-3.5 text-base font-semibold text-[color:var(--neon-cyan)] backdrop-blur-md hover:bg-[color:var(--neon-cyan)]/10"
              >
                J'ai déjà un héros
              </Link>
            </div>
            <div className="mt-10 grid max-w-md grid-cols-3 gap-4 text-center">
              {[
                { v: "5", l: "Matières" },
                { v: "200+", l: "Quêtes" },
                { v: "∞", l: "Flamme" },
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
                alt="Guerrier shonen brandissant un katana fait d'équations dans une arène néon"
                width={1600}
                height={1280}
                className="h-full w-full object-cover"
              />
              <div className="absolute inset-x-0 bottom-0 flex items-end justify-between gap-4 bg-gradient-to-t from-background via-background/70 to-transparent p-5">
                <div>
                  <div className="text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">Lvl 42 · Guerrier des Équations</div>
                  <div className="font-display text-lg">Yahia "Le Tranchant"</div>
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
          <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">Le système</div>
          <h2 className="font-display text-4xl font-bold sm:text-5xl">Pas une appli. <span className="text-gradient-primary">Une arène.</span></h2>
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
            <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">Les 5 voies</div>
            <h2 className="font-display text-4xl font-bold sm:text-5xl">Choisis ton <span className="text-gradient-cyan">chemin du héros</span></h2>
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
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Attribut · {s.attr}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* RANKS */}
      <section id="ranks" className="mx-auto max-w-5xl px-6 py-24 text-center">
        <div className="mb-3 text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">Progression</div>
        <h2 className="font-display text-4xl font-bold sm:text-5xl">De Civil à <span className="text-gradient-primary">Légende S-Rank</span></h2>
        <div className="mt-12 space-y-3">
          {[
            ["Niv. 1-5", "Candidat Civil", "neon-cyan"],
            ["Niv. 6-10", "Aspirant Académicien", "neon-cyan"],
            ["Niv. 11-20", "Guerrier des Équations", "neon-violet"],
            ["Niv. 21-30", "Maître des Langues", "neon-violet"],
            ["Niv. 31-45", "Élite du Concours", "neon-magenta"],
            ["Niv. 50+", "S-Rank Legend", "neon-gold"],
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
          Forger mon héros <Sparkles className="h-5 w-5" />
        </Link>
      </section>

      <footer className="border-t border-border/40 py-8 text-center text-xs text-muted-foreground">
        © {new Date().getFullYear()} YahiaAcademy · Concours de 9ème année · Tunisie
      </footer>
    </main>
  );
}
