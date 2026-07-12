import { lazy, Suspense, useEffect, useState } from "react";
import { Link } from "@tanstack/react-router";
import {
  ArrowRight,
  Award,
  BookOpen,
  CheckCircle2,
  ClipboardList,
  Globe,
  GraduationCap,
  Languages,
  Lightbulb,
  Printer,
  Sparkles,
  Star,
  Target,
  Trophy,
  Users,
  Zap,
} from "lucide-react";
import heroImg from "@/assets/hero-warrior.jpg";
import { useAuth } from "@/features/auth";
import { useIsMobile } from "@/hooks/use-mobile";
import { useT } from "@/lib/i18n";

/**
 * Public landing — « Référence » register (chantier C8, L1.2). Repositioned from the
 * old paid-concours RPG hero to the **public, free, family** entry of the platform
 * (étude §5.1): the family promise, 3 persona doors (élève/parent/enseignant), a
 * 3-parcours preview, proof of free, and ONE secondary « apprends en jouant » block —
 * the only place the Jeu (gold) register appears, where the 3D hero now lives. Rendered
 * inside the `_public` coquille (header/footer + `.public-shell`). Copy is i18n.
 */

// three.js loads only here, only on desktop with motion enabled (the one game block).
const GoldenHeroCanvas = lazy(() => import("@/components/landing/golden-hero-canvas"));

/** The CEFR ladder (Common European Framework) shared by both language tracks. */
const CEFR_LEVELS = ["A1", "A2", "B1", "B2", "C1", "C2"];

export function PublicLanding() {
  const t = useT();
  const { user } = useAuth();
  const isAuthed = user != null;
  const isMobile = useIsMobile();
  const [mounted, setMounted] = useState(false);
  const [reduce, setReduce] = useState(false);
  useEffect(() => {
    setMounted(true);
    setReduce(window.matchMedia?.("(prefers-reduced-motion: reduce)").matches ?? false);
  }, []);
  const show3D = mounted && !isMobile && !reduce;

  // The parent door deep-links to the « Espace Famille » section below; the two
  // other personas enter the public catalogue.
  const personas = [
    {
      icon: GraduationCap,
      title: t.public.landing.personaStudentTitle,
      desc: t.public.landing.personaStudentDesc,
      hash: undefined,
    },
    {
      icon: Users,
      title: t.public.landing.personaParentTitle,
      desc: t.public.landing.personaParentDesc,
      hash: "espace-famille",
    },
    {
      icon: BookOpen,
      title: t.public.landing.personaTeacherTitle,
      desc: t.public.landing.personaTeacherDesc,
      hash: undefined,
    },
  ];
  const cycles = [
    {
      name: t.public.cycles.primaire,
      years: t.public.cycles.primaireYears,
      concours: t.public.cycles.concours6,
    },
    {
      name: t.public.cycles.college,
      years: t.public.cycles.collegeYears,
      concours: t.public.cycles.concours9,
    },
    {
      name: t.public.cycles.lycee,
      years: t.public.cycles.lyceeYears,
      concours: t.public.cycles.bac,
    },
  ];
  const proof = [
    {
      icon: BookOpen,
      title: t.public.landing.proofCoursesTitle,
      desc: t.public.landing.proofCoursesDesc,
    },
    {
      icon: CheckCircle2,
      title: t.public.landing.proofExercisesTitle,
      desc: t.public.landing.proofExercisesDesc,
    },
    {
      icon: Printer,
      title: t.public.landing.proofConformTitle,
      desc: t.public.landing.proofConformDesc,
    },
  ];
  // Two transverse language tracks (free `libre` parcours; parcours id = theme id),
  // surfaced next to the official programme. CEFR-aligned, independent of school grade.
  const langues = [
    {
      parcoursId: "francais",
      name: t.public.landing.languesFrName,
      standard: t.public.landing.languesFrStandard,
    },
    {
      parcoursId: "anglais",
      name: t.public.landing.languesEnName,
      standard: t.public.landing.languesEnStandard,
    },
  ];

  return (
    <>
      {/* HERO — la promesse familiale */}
      <section className="mx-auto max-w-5xl px-4 pb-12 pt-12 text-center sm:px-6 sm:pt-16">
        <div className="inline-flex items-center gap-2 rounded-full bg-secondary px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-primary">
          <Sparkles className="h-3.5 w-3.5" /> {t.public.landing.freeBadge}
        </div>
        <h1 className="mx-auto mt-5 max-w-3xl font-display text-4xl font-bold leading-tight sm:text-5xl">
          {t.public.landing.heroTitle}
        </h1>
        <p className="mx-auto mt-4 max-w-2xl text-lg text-muted-foreground">
          {t.public.landing.heroSubtitle}
        </p>
        <div className="mt-7 flex flex-wrap justify-center gap-3">
          <Link
            to="/programme"
            className="inline-flex items-center gap-2 rounded-lg bg-primary px-6 py-3 text-base font-semibold text-primary-foreground transition hover:opacity-90"
          >
            {t.public.landing.ctaProgramme} <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
          </Link>
          <Link
            to="/extras"
            className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-6 py-3 text-base font-semibold transition hover:border-primary/60"
          >
            {t.public.landing.ctaExtras}
          </Link>
        </div>
      </section>

      {/* PORTES PERSONA */}
      <section className="mx-auto max-w-5xl px-4 py-6 sm:px-6">
        <div className="grid gap-4 sm:grid-cols-3">
          {personas.map((p) => (
            <Link
              key={p.title}
              to={p.hash ? "/" : "/programme"}
              hash={p.hash}
              data-testid="persona-door"
              className="group rounded-2xl border border-border bg-card p-6 transition hover:border-primary/60 hover:shadow-sm"
            >
              <span className="grid h-12 w-12 place-items-center rounded-xl bg-secondary text-primary">
                <p.icon className="h-6 w-6" />
              </span>
              <h2 className="mt-4 font-display text-lg font-bold">{p.title}</h2>
              <p className="mt-1 text-sm text-muted-foreground">{p.desc}</p>
              <span className="mt-3 inline-flex items-center gap-1 text-sm font-semibold text-primary">
                {t.public.landing.personaCta}
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
            {t.public.landing.cyclesTitle}
          </h2>
          <p className="mt-2 text-muted-foreground">{t.public.landing.cyclesSubtitle}</p>
        </div>
        <div className="grid gap-4 sm:grid-cols-3">
          {cycles.map((c) => (
            <Link
              key={c.name}
              to="/programme"
              data-testid="cycle-card"
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

      {/* DEUX LANGUES TRANSVERSES — Français & Anglais, alignés CECRL, atout indépendant de la classe */}
      <section className="mx-auto max-w-5xl px-4 py-10 sm:px-6">
        <div className="mb-6 text-center">
          <div className="inline-flex items-center gap-2 rounded-full bg-secondary px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-primary">
            <Globe className="h-3.5 w-3.5" /> {t.public.landing.languesKicker}
          </div>
          <h2 className="mx-auto mt-4 max-w-2xl font-display text-2xl font-bold sm:text-3xl">
            {t.public.landing.languesTitle}
          </h2>
          <p className="mx-auto mt-2 max-w-2xl text-muted-foreground">
            {t.public.landing.languesSubtitle}
          </p>
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          {langues.map((l) => (
            <Link
              key={l.parcoursId}
              to="/niveau/$parcoursId"
              params={{ parcoursId: l.parcoursId }}
              data-testid="langue-card"
              className="group rounded-2xl border border-border bg-card p-6 transition hover:border-primary/60 hover:shadow-sm"
            >
              <div className="flex items-center gap-3">
                <span className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-secondary text-primary">
                  <Languages className="h-6 w-6" />
                </span>
                <div className="min-w-0">
                  <h3 className="font-display text-lg font-bold">{l.name}</h3>
                  <p className="text-xs font-semibold text-muted-foreground">{l.standard}</p>
                </div>
              </div>
              <div className="mt-4 flex flex-wrap gap-1.5">
                {CEFR_LEVELS.map((lvl) => (
                  <span
                    key={lvl}
                    className="rounded-md bg-secondary px-2 py-1 text-xs font-bold text-primary"
                  >
                    {lvl}
                  </span>
                ))}
              </div>
              <span className="mt-4 inline-flex items-center gap-1 text-sm font-semibold text-primary">
                {t.public.landing.languesCta}
                <ArrowRight className="h-4 w-4 transition group-hover:translate-x-0.5 rtl:-scale-x-100" />
              </span>
            </Link>
          ))}
        </div>
      </section>

      {/* PREUVE DE GRATUITÉ */}
      <section className="border-y border-border bg-card/50">
        <div className="mx-auto grid max-w-5xl gap-6 px-4 py-10 sm:grid-cols-3 sm:px-6">
          {proof.map((f) => (
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

      {/* ESPACE FAMILLE — la promesse parents : suivi réel + bilan actionnable.
          Cible du deep-link de la porte persona « Je suis parent » (#espace-famille). */}
      <section
        id="espace-famille"
        data-testid="famille-block"
        className="mx-auto max-w-5xl scroll-mt-20 px-4 py-12 sm:px-6"
      >
        <div className="mb-8 text-center">
          <div className="inline-flex items-center gap-2 rounded-full bg-secondary px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-primary">
            <Users className="h-3.5 w-3.5" /> {t.public.landing.familleKicker}
          </div>
          <h2 className="mx-auto mt-4 max-w-2xl font-display text-2xl font-bold sm:text-3xl">
            {t.public.landing.familleTitle}
          </h2>
          <p className="mx-auto mt-2 max-w-2xl text-muted-foreground">
            {t.public.landing.familleSubtitle}
          </p>
        </div>
        <div className="grid gap-6 lg:grid-cols-2">
          <ul className="space-y-3">
            {[
              { icon: ClipboardList, text: t.public.landing.familleFeatTrack },
              { icon: Target, text: t.public.landing.familleFeatInsights },
              { icon: Lightbulb, text: t.public.landing.familleFeatAdvice },
              { icon: Printer, text: t.public.landing.familleFeatPrint },
            ].map((f) => (
              <li
                key={f.text}
                className="flex items-center gap-3 rounded-2xl border border-border bg-card p-4"
              >
                <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-secondary text-primary">
                  <f.icon className="h-5 w-5" />
                </span>
                <span className="text-sm font-medium">{f.text}</span>
              </li>
            ))}
          </ul>
          <div className="flex flex-col rounded-2xl border border-border bg-card p-6">
            <h3 className="font-display text-lg font-bold">{t.public.landing.familleStepsTitle}</h3>
            <ol className="mt-4 flex-1 space-y-3">
              {[
                t.public.landing.familleStep1,
                t.public.landing.familleStep2,
                t.public.landing.familleStep3,
              ].map((step, i) => (
                <li key={step} className="flex items-start gap-3">
                  <span className="grid h-7 w-7 shrink-0 place-items-center rounded-full bg-primary/10 text-sm font-bold text-primary">
                    {i + 1}
                  </span>
                  <span className="text-sm text-muted-foreground">{step}</span>
                </li>
              ))}
            </ol>
            {/* Signé : ouvre le suivi ; sinon inscription avec le rôle Parent pré-choisi. */}
            {isAuthed ? (
              <Link
                to="/parent-report"
                className="mt-6 inline-flex items-center justify-center gap-2 rounded-lg bg-primary px-6 py-3 text-base font-semibold text-primary-foreground transition hover:opacity-90"
              >
                {t.public.landing.familleCtaAuthed}
                <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
              </Link>
            ) : (
              <Link
                to="/suivi"
                className="mt-6 inline-flex items-center justify-center gap-2 rounded-lg bg-primary px-6 py-3 text-base font-semibold text-primary-foreground transition hover:opacity-90"
              >
                {t.public.landing.familleCtaAuthed}
                <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
              </Link>
            )}
            {/* Suivi sans compte : le code d'alliance suffit. La création d'un
                compte parent reste possible (extras qui écrivent) mais optionnelle. */}
            {!isAuthed && (
              <Link
                to="/auth"
                search={{ mode: "signup", role: "parent" }}
                className="mt-3 inline-flex items-center justify-center gap-1.5 text-sm font-medium text-muted-foreground transition hover:text-foreground"
              >
                {t.public.landing.familleCta}
              </Link>
            )}
          </div>
        </div>
      </section>

      {/* SECTION JEU — le seul bloc registre « Jeu » (doré), promesse secondaire */}
      {/* token-ok-block: vitrine « Apprends en jouant » — section sombre FIXE
          (identique dans les 2 thèmes) : son or est le vrai or de la marque jeu,
          volontairement hors tokens (l'or thémé devient teal en clair). */}
      <section data-testid="game-block" className="bg-[#15120d] text-amber-50">
        <div className="mx-auto grid max-w-5xl items-center gap-8 px-4 py-14 sm:px-6 lg:grid-cols-2">
          <div>
            <div className="inline-flex items-center gap-2 rounded-full bg-amber-400/10 px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-amber-300">
              <Sparkles className="h-3.5 w-3.5" /> {t.public.landing.gameKicker}
            </div>
            <h2 className="mt-4 font-display text-3xl font-bold sm:text-4xl">
              {t.public.landing.gameTitle}
            </h2>
            <p className="mt-3 text-amber-100/80">{t.public.landing.gameDesc}</p>
            <ul className="mt-5 space-y-2 text-sm text-amber-100/90">
              <li className="flex items-center gap-2">
                <Zap className="h-4 w-4 text-amber-400" /> {t.public.landing.gameFeatXp}
              </li>
              <li className="flex items-center gap-2">
                <Award className="h-4 w-4 text-amber-400" /> {t.public.landing.gameFeatBadges}
              </li>
              <li className="flex items-center gap-2">
                <Star className="h-4 w-4 text-amber-400" /> {t.public.landing.gameFeatRanking}
              </li>
            </ul>
            {/* Auth-aware CTA: a signed-in visitor already has an account → send them to
                their gameplay home, not the signup page (mirrors the auth-aware header). */}
            <Link
              to={isAuthed ? "/dashboard" : "/signup"}
              className="mt-7 inline-flex items-center gap-2 rounded-lg bg-amber-400 px-6 py-3 text-base font-bold text-[#15120d] transition hover:bg-amber-300"
            >
              {isAuthed ? t.public.landing.gameCtaAuthed : t.public.landing.gameCta}{" "}
              <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
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
      {/* /token-ok-block */}
    </>
  );
}
