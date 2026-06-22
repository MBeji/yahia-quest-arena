import { lazy, Suspense, useEffect, useState } from "react";
import { Link } from "@tanstack/react-router";
import {
  ArrowRight,
  Award,
  BookOpen,
  CheckCircle2,
  GraduationCap,
  Printer,
  Sparkles,
  Star,
  Trophy,
  Users,
  Zap,
} from "lucide-react";
import heroImg from "@/assets/hero-warrior.jpg";
import { useIsMobile } from "@/hooks/use-mobile";

/**
 * Public landing — « Référence » register (chantier C8, L1.2). Repositioned from the
 * old paid-concours RPG hero to the **public, free, family** entry of the platform
 * (étude §5.1): the family promise, 3 persona doors (élève/parent/enseignant), a
 * 3-parcours preview, proof of free, and ONE secondary « apprends en jouant » block —
 * the only place the Jeu (gold) register appears, where the 3D hero now lives. Rendered
 * inside the `_public` coquille (header/footer + `.register-reference`). FR literals
 * here → i18n sweep in L1.6.
 */

// three.js loads only here, only on desktop with motion enabled (the one game block).
const GoldenHeroCanvas = lazy(() => import("@/components/landing/golden-hero-canvas"));

const PERSONAS = [
  {
    icon: GraduationCap,
    title: "Je suis élève",
    desc: "Trouve ta classe, lis les cours et entraîne-toi sur les exercices.",
  },
  {
    icon: Users,
    title: "Je suis parent",
    desc: "Suis le programme officiel de ton enfant, gratuitement, sans inscription.",
  },
  {
    icon: BookOpen,
    title: "Je suis enseignant",
    desc: "Des ressources conformes au programme officiel, prêtes à imprimer.",
  },
] as const;

const CYCLES = [
  { name: "Primaire", years: "1re → 6e année", concours: "Concours 6e" },
  { name: "Collège", years: "7e → 9e année", concours: "Concours 9e" },
  { name: "Lycée", years: "1re année → Bac", concours: "Baccalauréat" },
] as const;

const PROOF = [
  {
    icon: BookOpen,
    title: "Cours & résumés",
    desc: "Rédigés pour comprendre, pas seulement pour réciter.",
  },
  {
    icon: CheckCircle2,
    title: "Exercices corrigés",
    desc: "Entraîne-toi et corrige-toi immédiatement — sans compte.",
  },
  {
    icon: Printer,
    title: "Conforme & imprimable",
    desc: "Fidèle au programme officiel tunisien, prêt à imprimer.",
  },
] as const;

export function PublicLanding() {
  const isMobile = useIsMobile();
  const [mounted, setMounted] = useState(false);
  const [reduce, setReduce] = useState(false);
  useEffect(() => {
    setMounted(true);
    setReduce(window.matchMedia?.("(prefers-reduced-motion: reduce)").matches ?? false);
  }, []);
  const show3D = mounted && !isMobile && !reduce;

  return (
    <>
      {/* HERO — la promesse familiale */}
      <section className="mx-auto max-w-5xl px-4 pb-12 pt-12 text-center sm:px-6 sm:pt-16">
        <div className="inline-flex items-center gap-2 rounded-full bg-secondary px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-primary">
          <Sparkles className="h-3.5 w-3.5" /> 100 % gratuit · sans inscription
        </div>
        <h1 className="mx-auto mt-5 max-w-3xl font-display text-4xl font-bold leading-tight sm:text-5xl">
          Tous les cours de l’école tunisienne. De la 1re année au Bac.
        </h1>
        <p className="mx-auto mt-4 max-w-2xl text-lg text-muted-foreground">
          Cours, résumés et exercices corrigés en accès libre — gratuit, pour toute la famille.
        </p>
        <div className="mt-7 flex flex-wrap justify-center gap-3">
          <Link
            to="/programme"
            className="inline-flex items-center gap-2 rounded-lg bg-primary px-6 py-3 text-base font-semibold text-primary-foreground transition hover:opacity-90"
          >
            Explorer le programme <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
          </Link>
          <Link
            to="/extras"
            className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-6 py-3 text-base font-semibold transition hover:border-primary/60"
          >
            Les extras
          </Link>
        </div>
      </section>

      {/* PORTES PERSONA */}
      <section className="mx-auto max-w-5xl px-4 py-6 sm:px-6">
        <div className="grid gap-4 sm:grid-cols-3">
          {PERSONAS.map((p) => (
            <Link
              key={p.title}
              to="/programme"
              className="group rounded-2xl border border-border bg-card p-6 transition hover:border-primary/60 hover:shadow-sm"
            >
              <span className="grid h-12 w-12 place-items-center rounded-xl bg-secondary text-primary">
                <p.icon className="h-6 w-6" />
              </span>
              <h2 className="mt-4 font-display text-lg font-bold">{p.title}</h2>
              <p className="mt-1 text-sm text-muted-foreground">{p.desc}</p>
              <span className="mt-3 inline-flex items-center gap-1 text-sm font-semibold text-primary">
                Découvrir
                <ArrowRight className="h-4 w-4 transition group-hover:translate-x-0.5 rtl:-scale-x-100" />
              </span>
            </Link>
          ))}
        </div>
      </section>

      {/* APERÇU DES 3 PARCOURS */}
      <section className="mx-auto max-w-5xl px-4 py-10 sm:px-6">
        <div className="mb-6 text-center">
          <h2 className="font-display text-2xl font-bold sm:text-3xl">
            Le programme officiel, en trois cycles
          </h2>
          <p className="mt-2 text-muted-foreground">Chaque cycle prépare son concours national.</p>
        </div>
        <div className="grid gap-4 sm:grid-cols-3">
          {CYCLES.map((c) => (
            <Link
              key={c.name}
              to="/programme"
              className="rounded-2xl border border-border bg-card p-6 transition hover:border-primary/60 hover:shadow-sm"
            >
              <div className="font-display text-xl font-bold">{c.name}</div>
              <div className="mt-1 text-sm text-muted-foreground">{c.years}</div>
              <div className="mt-4 inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-3 py-1 text-xs font-bold text-primary">
                <Trophy className="h-3.5 w-3.5" /> {c.concours}
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* PREUVE DE GRATUITÉ */}
      <section className="border-y border-border bg-card/50">
        <div className="mx-auto grid max-w-5xl gap-6 px-4 py-10 sm:grid-cols-3 sm:px-6">
          {PROOF.map((f) => (
            <div key={f.title} className="flex gap-3">
              <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-secondary text-primary">
                <f.icon className="h-5 w-5" />
              </span>
              <div>
                <div className="font-display font-bold">{f.title}</div>
                <p className="text-sm text-muted-foreground">{f.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* SECTION JEU — le seul bloc registre « Jeu » (doré), promesse secondaire */}
      <section className="bg-[#15120d] text-amber-50">
        <div className="mx-auto grid max-w-5xl items-center gap-8 px-4 py-14 sm:px-6 lg:grid-cols-2">
          <div>
            <div className="inline-flex items-center gap-2 rounded-full bg-amber-400/10 px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-amber-300">
              <Sparkles className="h-3.5 w-3.5" /> Et pour les enfants
            </div>
            <h2 className="mt-4 font-display text-3xl font-bold sm:text-4xl">Apprends en jouant</h2>
            <p className="mt-3 text-amber-100/80">
              Un compte gratuit transforme chaque exercice en progression : gagne des XP, débloque
              des badges, monte au classement et affronte le donjon.
            </p>
            <ul className="mt-5 space-y-2 text-sm text-amber-100/90">
              <li className="flex items-center gap-2">
                <Zap className="h-4 w-4 text-amber-400" /> XP & niveaux à chaque quête réussie
              </li>
              <li className="flex items-center gap-2">
                <Award className="h-4 w-4 text-amber-400" /> Badges & classes de héros
              </li>
              <li className="flex items-center gap-2">
                <Star className="h-4 w-4 text-amber-400" /> Classement & séries quotidiennes
              </li>
            </ul>
            <Link
              to="/signup"
              className="mt-7 inline-flex items-center gap-2 rounded-lg bg-amber-400 px-6 py-3 text-base font-bold text-[#15120d] transition hover:bg-amber-300"
            >
              Créer mon compte gratuit <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
            </Link>
          </div>
          <div className="relative aspect-square overflow-hidden rounded-3xl border border-amber-400/20 bg-black/40">
            {show3D ? (
              <Suspense
                fallback={
                  <img src={heroImg} alt="" className="h-full w-full object-cover opacity-70" />
                }
              >
                <GoldenHeroCanvas />
              </Suspense>
            ) : (
              <img src={heroImg} alt="" className="h-full w-full object-cover opacity-70" />
            )}
          </div>
        </div>
      </section>
    </>
  );
}
