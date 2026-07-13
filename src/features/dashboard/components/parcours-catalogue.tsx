import { Link } from "@tanstack/react-router";
import {
  ArrowLeft,
  Award,
  Brain,
  ChevronRight,
  Clock,
  Globe,
  GraduationCap,
  Languages,
  Sparkles,
  Trophy,
  type LucideIcon,
} from "lucide-react";
import { ParcoursInterestButton } from "./parcours-interest-button";
import type { ParcoursInterestState } from "../use-parcours-interest";
import { useI18n, useT } from "@/lib/i18n";
import { parcoursName } from "@/shared/lib/parcours-locale";
import {
  buildLyceeYears,
  buildPrograms,
  flagshipLabel,
  type LyceeYearGroup,
  type ProgramParcours,
} from "../program-families";

/**
 * Public parcours catalogue — « Référence » register (chantier C8, L1.3). Two
 * presentational views over the anon `getParcours` rows:
 *   • <ProgrammeCatalogue/> — the official school programme grouped into the 3 cycles
 *     (Primaire → 6e · Collège → 9e · Lycée → Bac); the national-concours class that
 *     closes each cycle is highlighted, and a `coming_soon` level shows a « Bientôt »
 *     badge (not yet navigable).
 *   • <ExtrasCatalogue/> — the optional `libre` tracks (langues, culture générale,
 *     muscle-cerveau), independent of the school programme.
 * Available parcours link to their level page (`/niveau/$parcoursId`). No gameplay and
 * no premium lock (the pivot is free). Copy is i18n (fr/en/ar).
 */

/** getParcours rows carry `kind` on top of the hub's ProgramParcours subset. */
export type CatalogueParcours = ProgramParcours & { kind: string };

/** Extras icon per standalone theme. */
const THEME_ICON: Record<string, LucideIcon> = {
  anglais: Languages,
  francais: Languages,
  arabe: Languages,
  "culture-generale": Globe,
  "muscle-cerveau": Brain,
  ib: Award,
};

function ParcoursCard({
  parcours,
  label,
  icon: Icon,
  highlight = false,
  badge,
}: {
  parcours: ProgramParcours;
  label: string;
  icon: LucideIcon;
  highlight?: boolean;
  badge?: string;
}) {
  const t = useT();
  const soon = parcours.status === "coming_soon";
  const cls = `flex items-center gap-3 rounded-2xl border p-4 text-start transition ${
    highlight ? "border-primary/40 bg-primary/[0.04]" : "border-border bg-card"
  } ${soon ? "opacity-70" : "hover:border-primary/60 hover:shadow-sm"}`;

  const inner = (
    <>
      <span
        className={`grid h-11 w-11 shrink-0 place-items-center rounded-xl ${
          highlight ? "bg-primary text-primary-foreground" : "bg-secondary text-primary"
        }`}
      >
        <Icon className="h-5 w-5" />
      </span>
      <span className="min-w-0 flex-1">
        <span className="flex items-center gap-2">
          <span className="truncate font-display text-base font-bold">{label}</span>
          {badge && (
            <span className="shrink-0 rounded-full bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-primary">
              {badge}
            </span>
          )}
        </span>
        {soon ? (
          <span className="mt-0.5 inline-flex items-center gap-1 text-xs text-muted-foreground">
            <Clock className="h-3 w-3" /> {t.public.catalogue.cardComingSoon}
          </span>
        ) : (
          <span className="mt-0.5 block text-xs text-muted-foreground">
            {t.public.catalogue.cardContent}
          </span>
        )}
      </span>
      {!soon && (
        <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground rtl:-scale-x-100" />
      )}
    </>
  );

  if (soon) {
    return (
      <div className={cls} aria-disabled="true">
        {inner}
      </div>
    );
  }
  return (
    <Link to="/niveau/$parcoursId" params={{ parcoursId: parcours.id }} className={cls}>
      {inner}
    </Link>
  );
}

/**
 * One drill-down row of the lycée block (étude 16 D-5/R-2): «2ème année /
 * 3ème année / Baccalauréat» links to its `/programme/lycee/$annee` page —
 * the sections never unfold inside the catalogue (one tree level per screen).
 */
function LyceeYearRow({ group }: { group: LyceeYearGroup }) {
  const t = useT();
  const yearLabel: Record<string, string> = {
    "2eme": t.lycee.year2,
    "3eme": t.lycee.year3,
    bac: t.lycee.yearBac,
  };
  const meta = [
    t.lycee.sections.replace("{n}", String(group.sections.length)),
    t.lycee.available.replace("{n}", String(group.available)),
  ].join(" · ");
  const isBac = group.year === "bac";
  const Icon = isBac ? Trophy : GraduationCap;

  return (
    <Link
      to="/programme/lycee/$annee"
      params={{ annee: group.year }}
      className={`flex items-center gap-3 rounded-2xl border p-4 text-start transition hover:shadow-sm ${
        isBac
          ? "border-primary/40 bg-primary/[0.04] hover:border-primary/60"
          : "border-border bg-card hover:border-primary/60"
      }`}
    >
      <span
        className={`grid h-11 w-11 shrink-0 place-items-center rounded-xl ${
          isBac ? "bg-primary text-primary-foreground" : "bg-secondary text-primary"
        }`}
      >
        <Icon className="h-5 w-5" />
      </span>
      <span className="min-w-0 flex-1">
        <span className="block truncate font-display text-base font-bold">
          {yearLabel[group.year]}
        </span>
        <span className="mt-0.5 block text-xs text-muted-foreground">{meta}</span>
      </span>
      <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground rtl:-scale-x-100" />
    </Link>
  );
}

export function ProgrammeCatalogue({ parcours }: { parcours: CatalogueParcours[] }) {
  const t = useT();
  const { locale } = useI18n();
  const school = buildPrograms(parcours).find((p) => p.kind === "school");
  const cycles = school?.cycles ?? [];

  // Cycle labels (the public register uses « Lycée » for the secondaire cycle).
  const cycleLabel: Record<string, string> = {
    primaire: t.public.cycles.primaire,
    college: t.public.cycles.college,
    secondaire: t.public.cycles.lycee,
  };
  const cycleConcours: Record<string, string> = {
    primaire: t.public.cycles.concours6,
    college: t.public.cycles.concours9,
    secondaire: t.public.cycles.bac,
  };

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <header className="mb-8">
        <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          {t.public.catalogue.programmeKicker}
        </div>
        <h1 className="mt-1 font-display text-2xl font-bold leading-tight sm:text-3xl md:text-4xl">
          {t.public.catalogue.programmeTitle}
        </h1>
        <p className="mt-2 text-muted-foreground">{t.public.catalogue.programmeDesc}</p>
      </header>

      {cycles.length === 0 ? (
        <p className="text-center text-sm text-muted-foreground">
          {t.public.catalogue.programmeEmpty}
        </p>
      ) : (
        <div className="space-y-10">
          {cycles.map((c) => (
            <section key={c.cycle}>
              <div className="mb-3 flex items-baseline justify-between gap-3">
                <h2 className="font-display text-xl font-bold">{cycleLabel[c.cycle] ?? c.cycle}</h2>
                <span className="text-xs font-semibold text-muted-foreground">
                  → {cycleConcours[c.cycle] ?? ""}
                </span>
              </div>
              {c.cycle === "secondaire" ? (
                // Lycée drill-down (étude 16 D-5/R-2) : la 1ère (tronc commun)
                // est une carte directe ; chaque année à sections ouvre SA page
                // (/programme/lycee/$annee) — jamais 17 cartes à plat.
                <div className="grid gap-3 sm:grid-cols-2">
                  {buildLyceeYears(c.classes).map((g) =>
                    g.direct ? (
                      <ParcoursCard
                        key={g.direct.id}
                        parcours={g.direct}
                        label={parcoursName(g.direct, locale)}
                        icon={GraduationCap}
                      />
                    ) : (
                      <LyceeYearRow key={g.year} group={g} />
                    ),
                  )}
                </div>
              ) : (
                <div className="grid gap-3 sm:grid-cols-2">
                  {c.classes.map((p) => {
                    // Phase gratuite (lot 2) : is_premium est false partout — le
                    // surlignage concours suit désormais le KIND du parcours.
                    const concours = p.kind === "concours";
                    const label = parcoursName(p, locale);
                    return (
                      <ParcoursCard
                        key={p.id}
                        parcours={p}
                        label={concours ? flagshipLabel(label) : label}
                        icon={concours ? Trophy : GraduationCap}
                        highlight={concours}
                        badge={concours ? t.public.catalogue.cardConcoursBadge : undefined}
                      />
                    );
                  })}
                </div>
              )}
            </section>
          ))}
        </div>
      )}

      <div className="mt-12 rounded-2xl border border-border bg-card p-5 text-center">
        <p className="text-sm text-muted-foreground">{t.public.catalogue.extrasLinkQuestion}</p>
        <Link
          to="/extras"
          className="mt-2 inline-flex items-center gap-1.5 font-semibold text-primary hover:underline"
        >
          {t.public.catalogue.extrasLinkCta} <ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
        </Link>
      </div>
    </div>
  );
}

/**
 * Public lycée year page body (étude 16 D-5 — `/programme/lycee/$annee`): the
 * sections of ONE year, one tree level per screen (R-2). An available section
 * links to its level page; a « Bientôt » section shows the live interest count
 * (D-7) and the vote button (an anonymous tap is routed to /auth by the hook).
 */
export function LyceeYearSections({
  year,
  sections,
  interest,
}: {
  year: "2eme" | "3eme" | "bac";
  sections: CatalogueParcours[];
  interest: ParcoursInterestState;
}) {
  const t = useT();
  const { locale } = useI18n();
  const yearLabel: Record<string, string> = {
    "2eme": t.lycee.year2,
    "3eme": t.lycee.year3,
    bac: t.lycee.yearBac,
  };
  const available = sections.filter((p) => p.status === "available").length;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link
        to="/programme"
        className="mb-6 inline-flex min-h-11 items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.public.niveau.backProgramme}
      </Link>
      <header className="mb-8">
        <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          {t.public.cycles.lycee}
        </div>
        <h1 className="mt-1 font-display text-2xl font-bold leading-tight sm:text-3xl md:text-4xl">
          {yearLabel[year]}
          {year === "bac" && <Trophy className="ms-2 inline h-6 w-6 text-primary" />}
        </h1>
        <p className="mt-2 text-muted-foreground">
          {t.lycee.sections.replace("{n}", String(sections.length))} ·{" "}
          {t.lycee.available.replace("{n}", String(available))} — {t.public.catalogue.lyceeYearDesc}
        </p>
      </header>

      {sections.length === 0 ? (
        <p className="text-center text-sm text-muted-foreground">
          {t.public.catalogue.programmeEmpty}
        </p>
      ) : (
        <div className="grid gap-3">
          {sections.map((p) => {
            const soon = p.status === "coming_soon";
            const concours = p.kind === "concours";
            const label = concours
              ? flagshipLabel(parcoursName(p, locale))
              : parcoursName(p, locale);
            const Icon = concours ? Trophy : GraduationCap;
            if (!soon) {
              return (
                <ParcoursCard
                  key={p.id}
                  parcours={p}
                  label={label}
                  icon={Icon}
                  highlight={concours}
                  badge={concours ? t.public.catalogue.cardConcoursBadge : undefined}
                />
              );
            }
            return (
              <div
                key={p.id}
                className="rounded-2xl border border-border bg-card p-4"
                aria-disabled="true"
              >
                <div className="flex items-center gap-3">
                  <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-secondary text-primary">
                    <Icon className="h-5 w-5" />
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="block truncate font-display text-base font-bold">{label}</span>
                    <span className="mt-0.5 inline-flex items-center gap-1 text-xs text-muted-foreground">
                      <Clock className="h-3 w-3" /> {t.public.catalogue.cardComingSoon}
                    </span>
                  </span>
                </div>
                <ParcoursInterestButton
                  count={interest.counts[p.id] ?? 0}
                  interested={interest.mine.has(p.id)}
                  isPending={interest.togglingId === p.id}
                  onToggle={() => interest.onToggle(p.id)}
                />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

export function ExtrasCatalogue({ parcours }: { parcours: CatalogueParcours[] }) {
  const t = useT();
  const { locale } = useI18n();
  // getParcours returns rows already ordered by display_order; filtering preserves it.
  // The Arabic language track is intentionally excluded from the extras menu.
  const extras = parcours.filter((p) => p.kind === "libre" && p.theme_id !== "arabe");

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <header className="mb-8">
        <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          {t.public.catalogue.extrasKicker}
        </div>
        <h1 className="mt-1 font-display text-2xl font-bold leading-tight sm:text-3xl md:text-4xl">
          {t.public.catalogue.extrasTitle}
        </h1>
        <p className="mt-2 text-muted-foreground">{t.public.catalogue.extrasDesc}</p>
      </header>

      {extras.length === 0 ? (
        <p className="text-center text-sm text-muted-foreground">
          {t.public.catalogue.extrasEmpty}
        </p>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2">
          {extras.map((p) => (
            <ParcoursCard
              key={p.id}
              parcours={p}
              label={parcoursName(p, locale)}
              icon={THEME_ICON[p.theme_id] ?? Sparkles}
            />
          ))}
        </div>
      )}
    </div>
  );
}
