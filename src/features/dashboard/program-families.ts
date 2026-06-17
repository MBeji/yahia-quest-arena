// The "Découvrir" hub groups the parcours catalogue into 5 root PROGRAMS. This is
// a presentation grouping over the existing themes/parcours (no DB table): a stable
// config + a pure builder, both unit-testable. `getParcours` feeds it the enriched
// parcours rows (with theme_id / grade_cycle / grade_order / status / hasEntitlement).

/** Sub-parcours disclosure rule for a root program. */
export type ProgramKind = "school" | "languages" | "enter" | "coming_soon";

/** A parcours row as consumed by the hub (subset of `getParcours`). */
export type ProgramParcours = {
  id: string;
  name_fr: string;
  status: string;
  is_premium: boolean;
  hasEntitlement: boolean;
  theme_id: string;
  grade_cycle?: string | null;
  grade_order?: number | null;
};

export type FamilyConfig = {
  id: string;
  themeIds: string[];
  kind: ProgramKind;
  icon: string; // lucide icon name
  color: string; // color token (→ --subject-*)
};

/** Order school cycles primaire → collège → secondaire. */
export const CYCLE_ORDER = ["primaire", "college", "secondaire"] as const;

/** The 5 root programs of the academy, in display order around the hub. */
export const PROGRAM_FAMILIES: FamilyConfig[] = [
  {
    id: "tunisien",
    themeIds: ["ecole-tn"],
    kind: "school",
    icon: "GraduationCap",
    color: "subject-math",
  },
  {
    id: "langues",
    themeIds: ["anglais", "francais", "arabe"],
    kind: "languages",
    icon: "Languages",
    color: "subject-french",
  },
  {
    id: "culture",
    themeIds: ["culture-generale"],
    kind: "enter",
    icon: "Globe",
    color: "subject-svt",
  },
  {
    id: "cerveau",
    themeIds: ["muscle-cerveau"],
    kind: "enter",
    icon: "Brain",
    color: "subject-arabic",
  },
  { id: "ib", themeIds: ["ib"], kind: "coming_soon", icon: "Award", color: "subject-english" },
];

export type SchoolCycle = { cycle: string; classes: ProgramParcours[] };

/** A resolved root program ready to render in the hub. */
export type Program = {
  id: string;
  kind: ProgramKind;
  icon: string;
  color: string;
  /** Single target parcours for `enter` / `coming_soon` kinds (null if absent). */
  parcours: ProgramParcours | null;
  /** Ordered language parcours for the `languages` kind. */
  languages: ProgramParcours[];
  /** Non-empty cycles (each with its classes) for the `school` kind. */
  cycles: SchoolCycle[];
  /** Number of sub-items (languages / classes / 1). */
  total: number;
  /** The whole program is coming soon (votable, not enterable). */
  comingSoon: boolean;
};

/** Group the parcours catalogue into the 5 root programs (pure, order-stable). */
export function buildPrograms(parcours: ProgramParcours[]): Program[] {
  return PROGRAM_FAMILIES.map((fam) => {
    const members = parcours.filter((p) => fam.themeIds.includes(p.theme_id));
    const base: Program = {
      id: fam.id,
      kind: fam.kind,
      icon: fam.icon,
      color: fam.color,
      parcours: null,
      languages: [],
      cycles: [],
      total: 0,
      comingSoon: false,
    };

    if (fam.kind === "languages") {
      const languages = fam.themeIds
        .map((tid) => members.find((p) => p.theme_id === tid))
        .filter((p): p is ProgramParcours => Boolean(p));
      return { ...base, languages, total: languages.length };
    }

    if (fam.kind === "school") {
      const sorted = [...members].sort((a, b) => (a.grade_order ?? 0) - (b.grade_order ?? 0));
      const cycles = CYCLE_ORDER.map((cycle) => ({
        cycle,
        classes: sorted.filter((p) => p.grade_cycle === cycle),
      })).filter((c) => c.classes.length > 0);
      return { ...base, cycles, total: sorted.length };
    }

    // enter / coming_soon → a single target parcours.
    const parcours_ = members[0] ?? null;
    return {
      ...base,
      parcours: parcours_,
      total: members.length,
      comingSoon: fam.kind === "coming_soon",
    };
  });
}
