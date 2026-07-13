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
  name_en?: string | null;
  name_ar?: string | null;
  status: string;
  /** 'concours' | 'scolaire' | 'libre' — drives the catalogue's concours highlight. */
  kind?: string;
  is_premium: boolean;
  hasEntitlement: boolean;
  theme_id: string;
  grade_cycle?: string | null;
  grade_order?: number | null;
  /** The grade's stable slug (étude 16 lot 2) — drives the lycée year grouping. */
  grade_slug?: string | null;
  /** False on the flat legacy secondary nodes — filtered out of every surface (R-1). */
  grade_selectable?: boolean;
  /** Subjects the parcours carries (real volumetry, « N matières » — étude 15 lot 8). */
  subjects_count?: number | null;
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

/**
 * Compact display label for a concours parcours — drops the verbose, redundant
 * "Préparation Concours " prefix so the class itself reads clearly next to the
 * catalogue's "Concours" badge ("Préparation Concours 9ème" → "9ème").
 */
export function flagshipLabel(nameFr: string): string {
  return nameFr.replace(/^Préparation\s+Concours\s+/i, "").replace(/^Préparation\s+/i, "");
}

// ---------------------------------------------------------------------------
// Lycée — year → section drill-down (étude 16 D-3/D-5, R-2)
// ---------------------------------------------------------------------------

/** The four secondary years. `1ere` is the tronc commun (no sections). */
export type LyceeYear = "1ere" | "2eme" | "3eme" | "bac";

export const LYCEE_YEAR_ORDER: LyceeYear[] = ["1ere", "2eme", "3eme", "bac"];

/** The years that branch into sections (own a `/programme/lycee/$annee` page). */
export const LYCEE_SECTION_YEARS = ["2eme", "3eme", "bac"] as const;

/**
 * Secondary year of a grade slug (closed set — slugs are canonical identity):
 * `1ere-sec` → '1ere'; `2eme-sec[-*]` → '2eme'; `3eme-sec[-*]` → '3eme';
 * `bac[-*]` → 'bac'; anything else (primaire/collège/null) → null.
 */
export function lyceeYearOf(slug: string | null | undefined): LyceeYear | null {
  if (!slug) return null;
  if (slug === "1ere-sec") return "1ere";
  if (slug === "2eme-sec" || slug.startsWith("2eme-sec-")) return "2eme";
  if (slug === "3eme-sec" || slug.startsWith("3eme-sec-")) return "3eme";
  if (slug === "bac" || slug.startsWith("bac-")) return "bac";
  return null;
}

/** One drill-down row of the lycée block: a direct class OR a year of sections. */
export type LyceeYearGroup<T extends ProgramParcours = ProgramParcours> = {
  year: LyceeYear;
  /** The parcours itself when the year has no sections (1ère sec). */
  direct: T | null;
  /** The year's section parcours, in seed order. */
  sections: T[];
  /** How many of the sections are `available`. */
  available: number;
};

/**
 * Group the (already R-1-filtered) secondaire classes by year for the
 * drill-down UI. Input order (grade_order) is preserved inside each year.
 * A year absent from the catalogue is skipped. Generic so each surface keeps
 * its own richer row type (onboarding cards need icon/color, etc.).
 */
export function buildLyceeYears<T extends ProgramParcours>(classes: T[]): LyceeYearGroup<T>[] {
  return LYCEE_YEAR_ORDER.map((year): LyceeYearGroup<T> | null => {
    const members = classes.filter((p) => lyceeYearOf(p.grade_slug) === year);
    if (members.length === 0) return null;
    if (year === "1ere") {
      return { year, direct: members[0], sections: [], available: 0 };
    }
    return {
      year,
      direct: null,
      sections: members,
      available: members.filter((p) => p.status === "available").length,
    };
  }).filter((g): g is LyceeYearGroup<T> => g !== null);
}

/** Group the parcours catalogue into the 5 root programs (pure, order-stable). */
export function buildPrograms(parcours: ProgramParcours[]): Program[] {
  return PROGRAM_FAMILIES.map((fam) => {
    // R-1 (étude 16): a parcours whose grade is non-selectable (the flat legacy
    // secondary nodes 2eme-sec/3eme-sec/bac) never reaches any user-facing list.
    const members = parcours.filter(
      (p) => fam.themeIds.includes(p.theme_id) && p.grade_selectable !== false,
    );
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
