import { Link } from "@tanstack/react-router";
import {
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
import { buildPrograms, flagshipLabel, type ProgramParcours } from "../program-families";

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
 * no premium lock (the pivot is free). FR literals here → i18n sweep in L1.6.
 */

/** getParcours rows carry `kind` on top of the hub's ProgramParcours subset. */
export type CatalogueParcours = ProgramParcours & { kind: string };

const CYCLE_LABEL: Record<string, string> = {
  primaire: "Primaire",
  college: "Collège",
  secondaire: "Lycée",
};

/** The national exam that closes each cycle — shown as the section's destination. */
const CYCLE_CONCOURS: Record<string, string> = {
  primaire: "Concours 6ème",
  college: "Concours 9ème",
  secondaire: "Baccalauréat",
};

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
  const soon = parcours.status === "coming_soon";
  const cls = `flex items-center gap-3 rounded-2xl border p-4 text-left transition ${
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
            <Clock className="h-3 w-3" /> Bientôt disponible
          </span>
        ) : (
          <span className="mt-0.5 block text-xs text-muted-foreground">
            Cours · résumés · exercices
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

export function ProgrammeCatalogue({ parcours }: { parcours: CatalogueParcours[] }) {
  const school = buildPrograms(parcours).find((p) => p.kind === "school");
  const cycles = school?.cycles ?? [];

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <header className="mb-8">
        <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          Programme officiel
        </div>
        <h1 className="mt-1 font-display text-3xl font-bold leading-tight sm:text-4xl">
          Toute l’école tunisienne
        </h1>
        <p className="mt-2 text-muted-foreground">
          De la 1ère année de base au Baccalauréat, en trois cycles — chacun préparant son concours
          national. Cours, résumés et exercices en accès libre, sans compte.
        </p>
      </header>

      {cycles.length === 0 ? (
        <p className="text-center text-sm text-muted-foreground">
          Catalogue indisponible pour le moment.
        </p>
      ) : (
        <div className="space-y-10">
          {cycles.map((c) => (
            <section key={c.cycle}>
              <div className="mb-3 flex items-baseline justify-between gap-3">
                <h2 className="font-display text-xl font-bold">
                  {CYCLE_LABEL[c.cycle] ?? c.cycle}
                </h2>
                <span className="text-xs font-semibold text-muted-foreground">
                  → {CYCLE_CONCOURS[c.cycle] ?? ""}
                </span>
              </div>
              <div className="grid gap-3 sm:grid-cols-2">
                {c.classes.map((p) => {
                  const concours = p.is_premium;
                  return (
                    <ParcoursCard
                      key={p.id}
                      parcours={p}
                      label={concours ? flagshipLabel(p.name_fr) : p.name_fr}
                      icon={concours ? Trophy : GraduationCap}
                      highlight={concours}
                      badge={concours ? "Concours" : undefined}
                    />
                  );
                })}
              </div>
            </section>
          ))}
        </div>
      )}

      <div className="mt-12 rounded-2xl border border-border bg-card p-5 text-center">
        <p className="text-sm text-muted-foreground">
          Envie d’aller plus loin que le programme&nbsp;?
        </p>
        <Link
          to="/extras"
          className="mt-2 inline-flex items-center gap-1.5 font-semibold text-primary hover:underline"
        >
          Découvrir les extras <ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
        </Link>
      </div>
    </div>
  );
}

export function ExtrasCatalogue({ parcours }: { parcours: CatalogueParcours[] }) {
  // getParcours returns rows already ordered by display_order; filtering preserves it.
  const extras = parcours.filter((p) => p.kind === "libre");

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <header className="mb-8">
        <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
          Au-delà du programme
        </div>
        <h1 className="mt-1 font-display text-3xl font-bold leading-tight sm:text-4xl">Extras</h1>
        <p className="mt-2 text-muted-foreground">
          Des parcours optionnels pour aller plus loin : langues, culture générale, jeux de logique.
          Indépendants du programme scolaire.
        </p>
      </header>

      {extras.length === 0 ? (
        <p className="text-center text-sm text-muted-foreground">Aucun extra pour le moment.</p>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2">
          {extras.map((p) => (
            <ParcoursCard
              key={p.id}
              parcours={p}
              label={p.name_fr}
              icon={THEME_ICON[p.theme_id] ?? Sparkles}
            />
          ))}
        </div>
      )}
    </div>
  );
}
