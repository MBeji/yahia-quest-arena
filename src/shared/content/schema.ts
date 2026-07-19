import { z } from "zod";

/**
 * Validation schemas for the versioned content pipeline.
 *
 * Pedagogical content lives as plain files under `content/<subject>/...`
 * (see content/README.md) and is compiled into idempotent Supabase
 * migrations by `scripts/content/build.ts`. These schemas are the single
 * source of truth for the shape of those files: anything that does not
 * validate never reaches the database.
 */

export const CONTENT_LANGUAGES = ["ar", "fr", "en"] as const;
export type ContentLanguage = (typeof CONTENT_LANGUAGES)[number];

/** A url, or a short free-form reference to a local repo / book. */
const sourceRefSchema = z.string().min(3, "a source reference must be at least 3 characters");

/**
 * Canonical `grades.slug` referential (closed list, kept in sync with the DB
 * seeds — `20260605120000` ladder + `20260704235000` lycée sections). Used to
 * validate `compileTo` targets at build time (étude 16 R-9): a typo'd slug must
 * fail `content:check`, never silently compile a subject whose grade subquery
 * would resolve to NULL.
 */
export const KNOWN_GRADE_SLUGS = [
  // primaire + collège ladder
  "1ere-base",
  "2eme-base",
  "3eme-base",
  "4eme-base",
  "5eme-base",
  "6eme-base",
  "7eme-base",
  "8eme-base",
  "9eme-base",
  // secondaire — tronc commun + flat legacy year nodes
  "1ere-sec",
  "2eme-sec",
  "3eme-sec",
  "bac",
  // secondaire — section nodes (docs/lycee-architecture.md §2)
  "2eme-sec-sciences",
  "2eme-sec-lettres",
  "2eme-sec-eco-services",
  "2eme-sec-info",
  "3eme-sec-math",
  "3eme-sec-sciences-exp",
  "3eme-sec-lettres",
  "3eme-sec-eco-gestion",
  "3eme-sec-techniques",
  "3eme-sec-info",
  "bac-math",
  "bac-sciences-exp",
  "bac-lettres",
  "bac-eco-gestion",
  "bac-techniques",
  "bac-info",
] as const;

/**
 * The flat legacy secondary nodes (`is_selectable = false` in DB since the
 * lycée seed): kept forever as identity, but never a valid `compileTo` target —
 * shared lycée content targets SECTION nodes only (étude 16 R-9).
 */
export const LEGACY_GRADE_SLUGS = ["2eme-sec", "3eme-sec", "bac"] as const;

const knownGradeSlugs: ReadonlySet<string> = new Set(KNOWN_GRADE_SLUGS);
const legacyGradeSlugs: ReadonlySet<string> = new Set(LEGACY_GRADE_SLUGS);

/**
 * One compiled target of a shared subject directory (étude 16 D-4): the id is
 * the ONLY subject id that reaches the DB (`<matière>-<gradeSlug>` verbatim —
 * enforced below), so UUIDv5 derivation depends on the compiled identity, never
 * on the source directory. `nameFr`/`description` default to the source values.
 */
const compileTargetSchema = z.object({
  id: z.string().regex(/^[a-z][a-z0-9-]*$/, "compileTo id must be kebab-case"),
  gradeSlug: z.string().min(1),
  nameFr: z.string().min(1).optional(),
  description: z.string().min(1).optional(),
});
export type CompileTarget = z.infer<typeof compileTargetSchema>;

/** `subject.json` — maps onto the `subjects` table (one per subject). */
export const subjectMetaSchema = z.object({
  id: z.string().regex(/^[a-z][a-z0-9-]*$/, "subject id must be kebab-case (e.g. 'math')"),
  /**
   * The subject's display name, written in its OWN `contentLanguage`
   * (ar → "الرياضيات", en → "English", fr → "Français"). The field name is
   * legacy — it predates multilingual subjects — and is kept only for
   * DB/column compatibility (`subjects.name_fr`); the value is native, not French.
   */
  nameFr: z.string().min(1),
  description: z.string().min(1),
  attribute: z.string().min(1),
  colorToken: z.string().min(1),
  icon: z.string().min(1),
  displayOrder: z.number().int().positive(),
  contentLanguage: z.enum(CONTENT_LANGUAGES),
  /**
   * Theme this subject belongs to (FK → `themes.id`). Required: every subject
   * lives under exactly one theme, e.g. `ecole-tn` (Tunisian school program) or
   * a standalone module theme such as `francais`.
   */
  themeId: z.string().regex(/^[a-z][a-z0-9-]*$/, "themeId must be kebab-case (e.g. 'ecole-tn')"),
  /**
   * Grade within the theme's ladder, referenced by its stable `grades.slug`
   * (e.g. `9eme-base`). `null` for grade-agnostic subjects — only graded themes
   * (today `ecole-tn`) carry a grade. The compiled SQL resolves the slug to the
   * grade UUID, so content never hard-codes ids. Defaults to `null`.
   */
  gradeSlug: z.string().min(1).nullable().default(null),
  /**
   * Premium module: when true, the whole subject (chapters, exercises, quiz) is
   * reserved to users with an active subscription (gated server-side). Used by
   * the standalone "Maîtrise du français" module. Defaults to false.
   */
  isPremium: z.boolean().default(false),
  /**
   * Optional link to the official student textbook (manuel élève) as FULL PDF
   * volume(s): the CNP book `code` per volume (bucket object `<code>.pdf`) plus
   * an optional display `label` (e.g. "الجزء الأول") for multi-volume books.
   * Compiled into `subjects.manuel_refs` JSONB and surfaced as a login-gated
   * « Manuel officiel » card on the public subject page.
   */
  manuels: z
    .array(
      z.object({
        code: z
          .string()
          .regex(/^[A-Za-z0-9_-]+$/, "manuels[].code must be an alphanumeric book code"),
        label: z.string().min(1).optional(),
      }),
    )
    .min(1)
    .optional(),
  /**
   * Mutualisation (étude 16 D-4): compile this ONE authored directory into N
   * subjects — one per section-grade target. When present, the root `id` is a
   * VIRTUAL source id (convention `<matière>-<année>`, e.g. `anglais-3eme-sec`)
   * that never reaches the DB, and the root `gradeSlug` must stay null. Each
   * target id must keep the `<matière>-<gradeSlug>` verbatim convention so the
   * UUIDv5 derivation depends on the compiled identity (fork-without-loss,
   * étude 16 R-7). Chapters/exercises may narrow their targets via their own
   * `gradeSlugs` field. Expansion happens in `expandSubjects` (loader.ts).
   */
  compileTo: z.array(compileTargetSchema).min(2).optional(),
});

export const subjectMetaWithCompileToSchema = subjectMetaSchema.superRefine((meta, ctx) => {
  if (!meta.compileTo) return;
  if (meta.gradeSlug !== null) {
    ctx.addIssue({
      code: "custom",
      message: "a shared subject (compileTo) must not set a root gradeSlug — targets carry them",
      path: ["gradeSlug"],
    });
  }
  const ids = new Set<string>();
  const slugs = new Set<string>();
  meta.compileTo.forEach((t, i) => {
    if (ids.has(t.id)) {
      ctx.addIssue({
        code: "custom",
        message: `duplicate compileTo target id '${t.id}'`,
        path: ["compileTo", i, "id"],
      });
    }
    ids.add(t.id);
    if (slugs.has(t.gradeSlug)) {
      ctx.addIssue({
        code: "custom",
        message: `duplicate compileTo target gradeSlug '${t.gradeSlug}'`,
        path: ["compileTo", i, "gradeSlug"],
      });
    }
    slugs.add(t.gradeSlug);
    if (!knownGradeSlugs.has(t.gradeSlug)) {
      ctx.addIssue({
        code: "custom",
        message: `unknown gradeSlug '${t.gradeSlug}' — must be one of the canonical grades (KNOWN_GRADE_SLUGS)`,
        path: ["compileTo", i, "gradeSlug"],
      });
    } else if (legacyGradeSlugs.has(t.gradeSlug)) {
      ctx.addIssue({
        code: "custom",
        message: `gradeSlug '${t.gradeSlug}' is a non-selectable legacy node — target the section nodes instead`,
        path: ["compileTo", i, "gradeSlug"],
      });
    }
    if (!t.id.endsWith(`-${t.gradeSlug}`)) {
      ctx.addIssue({
        code: "custom",
        message: `target id '${t.id}' must be '<matière>-${t.gradeSlug}' (subject-id convention, docs/lycee-architecture.md §2)`,
        path: ["compileTo", i, "id"],
      });
    }
    if (t.id === meta.id) {
      ctx.addIssue({
        code: "custom",
        message: `target id '${t.id}' collides with the source id — the source id is virtual and must differ`,
        path: ["compileTo", i, "id"],
      });
    }
  });
});
export type SubjectMeta = z.infer<typeof subjectMetaSchema>;

/**
 * Expand a manuel page-range expression into a sorted, de-duplicated list of
 * 1-based page numbers. Single pages and inclusive ranges, comma-separated:
 *   "12"            → [12]
 *   "12-15"         → [12, 13, 14, 15]
 *   "12-15, 18, 20" → [12, 13, 14, 15, 18, 20]
 * Throws on a malformed token or a descending range (start > end).
 */
export function parseManuelPages(pages: string): number[] {
  const out: number[] = [];
  for (const raw of pages.split(",")) {
    const seg = raw.trim();
    if (seg === "") continue;
    const range = seg.match(/^(\d+)\s*-\s*(\d+)$/);
    if (range) {
      const start = Number(range[1]);
      const end = Number(range[2]);
      if (start > end) throw new Error(`manuel page range "${seg}" is descending (start > end)`);
      for (let p = start; p <= end; p++) out.push(p);
    } else if (/^\d+$/.test(seg)) {
      out.push(Number(seg));
    } else {
      throw new Error(`manuel page token "${seg}" is not a page number or range`);
    }
  }
  return [...new Set(out)].sort((a, b) => a - b);
}

/**
 * Optional per-section narrowing inside a SHARED subject (étude 16 D-4): the
 * subset of the subject's `compileTo` grade slugs this piece of content is
 * compiled for. Absent = all targets. Only meaningful under a subject that
 * declares `compileTo` (enforced by `expandSubjects`).
 */
const gradeSlugsSubsetSchema = z
  .array(z.string().min(1))
  .min(1)
  .refine((a) => new Set(a).size === a.length, "gradeSlugs must be unique")
  .optional();

/**
 * A curated-video registry id — namespaced `famille.slug` (étude 23 R-1), e.g.
 * `math.thales-configuration`: lowercase dotted segments, the first being the
 * subject family. Same identity rule as misconception tags and slugs — STABLE
 * for life (create/retire, never rename). Never free text: every ref used in a
 * chapter/exercise must exist in the versioned registry `content/videos.json`
 * (cross-checked by `content:qa`; an unknown ref is an error). A ref IS an id.
 */
export const videoIdSchema = z
  .string()
  .regex(
    /^[a-z][a-z0-9]*(?:\.[a-z0-9]+(?:-[a-z0-9]+)*){1,}$/,
    "a video id must be namespaced lowercase segments (e.g. 'math.thales-configuration')",
  );

/** `chapter.json` — maps onto a row in `chapters`. */
export const chapterMetaSchema = z.object({
  title: z.string().min(1),
  description: z.string().min(1),
  displayOrder: z.number().int().positive(),
  /** Shared-subject narrowing: sections this chapter is compiled for (étude 16). */
  gradeSlugs: gradeSlugsSubsetSchema,
  /** Provenance: URLs / repos / books the chapter was built from. */
  sources: z.array(sourceRefSchema).default([]),
  /**
   * Optional link to the official student textbook (manuel élève): the CNP
   * book `code` plus the `pages` covering this chapter (a 1-based range
   * expression — "12-15", "12, 14-16"). Compiled into the `chapters.manuel_ref`
   * JSONB column and surfaced as a login-gated "Pages du manuel" gallery under
   * the course. Both fields are required when `manuel` is present.
   */
  manuel: z
    .object({
      code: z.string().regex(/^[A-Za-z0-9_-]+$/, "manuel.code must be an alphanumeric book code"),
      pages: z.string().min(1),
    })
    .refine(
      (m) => {
        try {
          const ps = parseManuelPages(m.pages);
          return ps.length > 0 && ps.every((p) => p >= 1);
        } catch {
          return false;
        }
      },
      {
        message: "manuel.pages must be a 1-based page range like '12-15' or '12, 14-16'",
        path: ["pages"],
      },
    )
    .optional(),
  /**
   * Optional curated explainer videos for this chapter (étude 23 R-11): 0–3
   * registry ids, in display order (the first is the chapter's default review
   * video — R-6). Each id must resolve to an `active` entry in
   * `content/videos.json` whose `lang` matches the subject's `contentLanguage`
   * (cross-checked by `content:qa`). Compiled into `chapters.videos` JSONB.
   */
  videos: z
    .array(videoIdSchema)
    .max(3, "a chapter may reference at most 3 videos (étude 23 R-11)")
    .refine((a) => new Set(a).size === a.length, "chapter videos must be unique")
    .optional(),
});
export type ChapterMeta = z.infer<typeof chapterMetaSchema>;

/**
 * A misconception tag id — namespaced by subject (étude 04 R-5), e.g.
 * `math.frac.add-denominators`: lowercase dotted segments, the first being the
 * subject namespace. Never free text — every tag used in content must exist in
 * the versioned registry `content/misconceptions.json` (cross-checked by
 * `content:qa`; an unknown tag is an error).
 */
export const misconceptionTagSchema = z
  .string()
  .regex(
    /^[a-z][a-z0-9]*(?:\.[a-z0-9]+(?:-[a-z0-9]+)*){1,}$/,
    "a misconception tag must be namespaced lowercase segments (e.g. 'math.frac.add-denominators')",
  );

const optionSchema = z.object({
  id: z.string().min(1),
  text: z.string().min(1),
  /**
   * Optional server-only misconception tag (étude 04 D-4/R-5): names the error a
   * student who picks THIS distractor is making. `sql-builder` routes it into the
   * server-only `questions.distractor_tags` map (keyed by option id) and STRIPS it
   * from the client-sent `options`. Meaningful on mcq (the wire `choice` equals
   * the option id, so telemetry resolves `distractor_tags->>choice`); the correct
   * option must stay untagged (enforced below). The id must exist in
   * `content/misconceptions.json`.
   */
  misconceptionTag: misconceptionTagSchema.optional(),
});

/** One entry of the misconception registry: subject + trilingual student labels. */
export const misconceptionEntrySchema = z.object({
  subject: z.string().regex(/^[a-z][a-z0-9-]*$/, "subject must be kebab-case (e.g. 'math')"),
  labels: z.object({
    fr: z.string().min(1),
    en: z.string().min(1),
    ar: z.string().min(1),
  }),
});
export type MisconceptionEntry = z.infer<typeof misconceptionEntrySchema>;

/**
 * `content/misconceptions.json` — the versioned, closed vocabulary of
 * misconception tags (étude 04 D-4/R-5). Maps each namespaced tag id to its
 * subject + student-facing FR/EN/AR labels (the tag is an id, never displayed;
 * the labels feed `get_my_weaknesses` in a later lot). Content may only
 * reference tags declared here.
 */
export const misconceptionRegistrySchema = z.record(
  misconceptionTagSchema,
  misconceptionEntrySchema,
);
export type MisconceptionRegistry = z.infer<typeof misconceptionRegistrySchema>;

/**
 * A competency id — namespaced `matière.domaine.competence` (étude 07 R-1),
 * e.g. `math.geo.thales-direct`: exactly three lowercase dotted segments.
 * Ids are STABLE for life (create/deprecate only, never rename — same identity
 * rule as slugs) and never displayed: the trilingual labels are.
 */
export const competencyIdSchema = z
  .string()
  .regex(
    /^[a-z][a-z0-9]*\.[a-z0-9]+(?:-[a-z0-9]+)*\.[a-z0-9]+(?:-[a-z0-9]+)*$/,
    "a competency id must be 'matiere.domaine.competence' lowercase segments (e.g. 'math.geo.thales-direct')",
  );

/** One competency of a family registry: stable id + student labels + prereq edges. */
export const competencyEntrySchema = z.object({
  id: competencyIdSchema,
  labels: z.object({
    fr: z.string().min(1),
    en: z.string().min(1),
    ar: z.string().min(1),
  }),
  /** Direct prerequisites — ids of the SAME family (étude 07 R-3). */
  prereqs: z.array(competencyIdSchema).max(8).default([]),
});
export type CompetencyEntry = z.infer<typeof competencyEntrySchema>;

/**
 * Detect a prerequisite cycle (étude 07 R-3: the graph must be a DAG).
 * Returns the offending path (`a → b → a`) or `null`. Edges pointing at ids
 * not declared in `entries` are ignored (they are reported separately).
 */
export function findCompetencyCycle(
  entries: ReadonlyArray<Pick<CompetencyEntry, "id" | "prereqs">>,
): string[] | null {
  const prereqsOf = new Map(entries.map((e) => [e.id, e.prereqs]));
  const state = new Map<string, "visiting" | "done">();
  const path: string[] = [];

  const visit = (id: string): string[] | null => {
    if (state.get(id) === "done") return null;
    if (state.get(id) === "visiting") return [...path.slice(path.indexOf(id)), id];
    state.set(id, "visiting");
    path.push(id);
    for (const prereq of prereqsOf.get(id) ?? []) {
      if (!prereqsOf.has(prereq)) continue;
      const cycle = visit(prereq);
      if (cycle) return cycle;
    }
    path.pop();
    state.set(id, "done");
    return null;
  };

  for (const entry of entries) {
    const cycle = visit(entry.id);
    if (cycle) return cycle;
  }
  return null;
}

/**
 * `content/competences/<famille>.json` — one versioned registry per subject
 * family (étude 07 D-1: the graph lives in the content pipeline, never in an
 * admin UI). Compiled by the generator into the relational `competencies` /
 * `competency_prereqs` tables (deterministic UUIDv5, idempotent, pruned).
 */
export const competencyRegistrySchema = z
  .object({
    /** Trans-grade subject family (`math`, `physique`, `arabe`…). */
    family: z.string().regex(/^[a-z][a-z0-9]*$/, "family must be a lowercase word (e.g. 'math')"),
    /**
     * Subject-id prefixes this family covers (`math` matches `math` and
     * `math-*`). Explicit because family names are semantic, not derivable
     * from subject ids (e.g. a future `physique` family covers subject `svt`).
     * Feeds the content:qa family≠matière warning.
     */
    subjectPrefixes: z
      .array(z.string().regex(/^[a-z][a-z0-9-]*$/, "subjectPrefixes must be kebab-case ids"))
      .min(1),
    competencies: z.array(competencyEntrySchema).min(1),
  })
  .superRefine((reg, ctx) => {
    const ids = new Set<string>();
    reg.competencies.forEach((c, i) => {
      if (ids.has(c.id)) {
        ctx.addIssue({
          code: "custom",
          message: `duplicate competency id "${c.id}"`,
          path: ["competencies", i, "id"],
        });
      }
      ids.add(c.id);
    });
    reg.competencies.forEach((c, i) => {
      if (!c.id.startsWith(`${reg.family}.`)) {
        ctx.addIssue({
          code: "custom",
          message: `competency id "${c.id}" must start with the family namespace "${reg.family}."`,
          path: ["competencies", i, "id"],
        });
      }
      const seen = new Set<string>();
      c.prereqs.forEach((p, j) => {
        if (p === c.id) {
          ctx.addIssue({
            code: "custom",
            message: "a competency cannot be its own prerequisite",
            path: ["competencies", i, "prereqs", j],
          });
        } else if (!ids.has(p)) {
          ctx.addIssue({
            code: "custom",
            message: `prereq "${p}" is not declared in this family (R-3: same-family edges only)`,
            path: ["competencies", i, "prereqs", j],
          });
        }
        if (seen.has(p)) {
          ctx.addIssue({
            code: "custom",
            message: `duplicate prereq "${p}"`,
            path: ["competencies", i, "prereqs", j],
          });
        }
        seen.add(p);
      });
    });
    const cycle = findCompetencyCycle(reg.competencies);
    if (cycle) {
      ctx.addIssue({
        code: "custom",
        message: `prerequisite cycle ${cycle.join(" → ")} (R-3: the graph must be a DAG)`,
        path: ["competencies"],
      });
    }
  });
export type CompetencyRegistry = z.infer<typeof competencyRegistrySchema>;

/** Closed set of video providers (étude 23 D-6/D-10). v1 implements only youtube. */
export const VIDEO_PROVIDERS = ["youtube"] as const;
export const videoProviderSchema = z.enum(VIDEO_PROVIDERS);
export type VideoProvider = (typeof VIDEO_PROVIDERS)[number];

/** Per-provider video-id shape (étude 23 §3): the ONLY field used to build the embed URL. */
const VIDEO_ID_PATTERNS: Record<VideoProvider, RegExp> = {
  youtube: /^[A-Za-z0-9_-]{11}$/,
};

/** Lifecycle status of a registry entry (étude 23 R-12). Only `active` is compiled. */
export const VIDEO_STATUSES = ["active", "broken", "retired"] as const;
export const videoStatusSchema = z.enum(VIDEO_STATUSES);

/** Provenance of a video (étude 23 §3): external teacher, official channel, or AI (phase B). */
export const VIDEO_KINDS = ["teacher", "official", "ai"] as const;
export const videoKindSchema = z.enum(VIDEO_KINDS);

const isoDateSchema = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "must be an ISO date (YYYY-MM-DD)");

/**
 * One entry of the curated-video registry (`content/videos.json`, étude 23 D-2).
 * The full curation record: what to embed (`provider` + `videoId` — the only
 * fields that reach the client, D-10), display metadata (title/channel/lang/
 * duration), the curation trail (`kind`, `grades`, `notions`, `verifiedOn`/
 * `verifiedBy`, `notes`, `status`) and platform-compliance data (`madeForKids`,
 * R-14). `channelUrl`/`notes`/`verifiedBy`… stay in the registry — never compiled.
 */
export const videoEntrySchema = z
  .object({
    provider: videoProviderSchema,
    videoId: z.string().min(1),
    /** Title in the video's own `lang` (registry data, shown with dir=auto). */
    title: z.string().min(1),
    channel: z.string().min(1),
    /** Registry-only (never compiled to the client, D-10). */
    channelUrl: z.string().url().optional(),
    lang: z.enum(CONTENT_LANGUAGES),
    /** Duration of the played segment (the extract when start/end are set). */
    durationSec: z.number().int().positive(),
    kind: videoKindSchema,
    /** Curation hints — canonical grade slugs (informative, étude 23 §3). */
    grades: z
      .array(z.string().min(1))
      .default([])
      .refine(
        (a) => a.every((s) => knownGradeSlugs.has(s)),
        "grades must be canonical grade slugs (KNOWN_GRADE_SLUGS)",
      ),
    notions: z.array(z.string().min(1)).default([]),
    /** Optional evaluated competencies (étude 07 ids) — cross-checked by content:qa. */
    competencies: z.array(competencyIdSchema).optional(),
    /** Optional extract of a longer format: emitted as ?start= / ?end=. */
    startSec: z.number().int().nonnegative().optional(),
    endSec: z.number().int().positive().optional(),
    /** Relevé à la curation (R-14): a made-for-kids video only gets non-personalised ads. */
    madeForKids: z.boolean(),
    addedOn: isoDateSchema,
    /** Required for `status: active` (R-3) — enforced by content:qa. */
    verifiedOn: isoDateSchema.optional(),
    verifiedBy: z.string().min(1).optional(),
    status: videoStatusSchema,
    notes: z.string().optional(),
  })
  .superRefine((v, ctx) => {
    if (!VIDEO_ID_PATTERNS[v.provider].test(v.videoId)) {
      ctx.addIssue({
        code: "custom",
        message: `videoId "${v.videoId}" is not a valid ${v.provider} id`,
        path: ["videoId"],
      });
    }
  });
export type VideoEntry = z.infer<typeof videoEntrySchema>;

/**
 * `content/videos.json` — the versioned, closed registry of curated explainer
 * videos (étude 23 D-2), keyed by stable namespaced id. Content (`chapter.json`,
 * `exercices/*.json`) references only these ids; the compiled DB columns carry
 * only a display subset (see `CompiledVideo`).
 */
export const videoRegistrySchema = z.record(videoIdSchema, videoEntrySchema);
export type VideoRegistry = z.infer<typeof videoRegistrySchema>;

/**
 * The display subset of a registry entry that reaches the client (compiled into
 * `chapters.videos` / `exercises.correction_video`). No free URL ever crosses
 * this boundary (étude 23 D-10): `provider` (enum) + `videoId` (validated) are
 * all the embed needs; the client builds the URL by template.
 */
export const compiledVideoSchema = z
  .object({
    id: z.string().min(1),
    provider: videoProviderSchema,
    videoId: z.string().min(1),
    title: z.string().min(1),
    channel: z.string().min(1),
    lang: z.enum(CONTENT_LANGUAGES),
    durationSec: z.number().int().positive(),
    startSec: z.number().int().nonnegative().optional(),
    endSec: z.number().int().positive().optional(),
  })
  .superRefine((v, ctx) => {
    if (!VIDEO_ID_PATTERNS[v.provider].test(v.videoId)) {
      ctx.addIssue({
        code: "custom",
        message: `videoId "${v.videoId}" is not a valid ${v.provider} id`,
        path: ["videoId"],
      });
    }
  });
export type CompiledVideo = z.infer<typeof compiledVideoSchema>;

/** Project a registry entry onto its compiled display subset (étude 23 §3). */
export function toCompiledVideo(id: string, entry: VideoEntry): CompiledVideo {
  return {
    id,
    provider: entry.provider,
    videoId: entry.videoId,
    title: entry.title,
    channel: entry.channel,
    lang: entry.lang,
    durationSec: entry.durationSec,
    ...(entry.startSec !== undefined ? { startSec: entry.startSec } : {}),
    ...(entry.endSec !== undefined ? { endSec: entry.endSec } : {}),
  };
}

const questionCoreSchema = z.object({
  prompt: z.string().min(1),
  explanation: z.string().min(1),
  /**
   * Per-question difficulty (1 = easy … 3 = hard). Questions within an
   * exercise/quiz are emitted ordered by ascending difficulty. Optional;
   * untagged questions default to medium (2) for ordering.
   */
  difficulty: z.number().int().min(1).max(3).optional(),
  /**
   * Optional competencies this question evaluates (étude 07 D-2/R-2): 1–3 ids
   * from the versioned registries `content/competences/<famille>.json`, the
   * FIRST being the primary one. Unlike misconception tags (server-only, étude
   * 04 D-1) these describe the QUESTION, not its options, so they never reveal
   * the key — the compiled `question_competencies` junction is client-readable.
   * Applies to every question type; tagging is progressive (untagged = neutral,
   * never blocking). Unknown ids are flagged by content:qa (vocabulary check).
   */
  competencies: z.array(competencyIdSchema).min(1).max(3).optional(),
});

/** The classic QCM — `type` may be omitted in files (defaulted to 'mcq'). */
const mcqQuestionSchema = questionCoreSchema.extend({
  type: z.literal("mcq"),
  options: z.array(optionSchema).min(2).max(6),
  correctOption: z.string().min(1),
});

/** Typed key of a native `numeric` question → `questions.answer_key`. */
export const numericAnswerKeySchema = z.object({
  /** The canonical answer (standard Western-digit notation). */
  value: z.number().finite(),
  /** Accepted absolute deviation; omitted = exact match (0). */
  tolerance: z.number().nonnegative().finite().optional(),
  /** Optional unit label — informative only; the unit hint belongs in the prompt. */
  unit: z.string().min(1).optional(),
});
export type NumericAnswerKey = z.infer<typeof numericAnswerKeySchema>;

/**
 * Native free-numeric-entry question (Tier B, phase B1 — see
 * docs/interactive-question-types.md). No options: the student types the
 * number; the server scores `abs(x − value) <= tolerance` via `score_answer`.
 */
const numericQuestionSchema = questionCoreSchema.extend({
  type: z.literal("numeric"),
  answerKey: numericAnswerKeySchema,
});

/**
 * Ids used in the B2 wire formats travel inside CSV/pair encodings, so they
 * may not contain `,`, `:` or whitespace. Kebab/alnum, like the `a`–`d` and
 * `l1`/`r1` conventions.
 */
const wireIdSchema = z
  .string()
  .regex(/^[A-Za-z0-9_-]+$/, "B2 option ids must be alphanumeric (no ',', ':' or spaces)");

const wireOptionSchema = z.object({ id: wireIdSchema, text: z.string().min(1) });

/**
 * Native drag-&-drop sequencing question (Tier B, phase B2): `options` are the
 * steps (shuffled at render); `answerKey.order` is the correct id sequence —
 * validated below as an exact permutation of the option ids.
 */
const orderingQuestionSchema = questionCoreSchema.extend({
  type: z.literal("ordering"),
  options: z.array(wireOptionSchema).min(3).max(6),
  answerKey: z.object({ order: z.array(wireIdSchema).min(3).max(6) }),
});

/**
 * Native drag-&-drop pair-alignment question (Tier B, phase B2): `options`
 * carry the fixed left items (`l…` ids) and the movable right items (`r…`
 * ids); `answerKey.pairs` is the correct left→right association — validated
 * below as a bijection between the two sides.
 */
const matchingQuestionSchema = questionCoreSchema.extend({
  type: z.literal("matching"),
  options: z.array(wireOptionSchema).min(4).max(12),
  answerKey: z.object({
    pairs: z
      .array(z.tuple([wireIdSchema, wireIdSchema]))
      .min(2)
      .max(6),
  }),
});

/**
 * Native multi-select judgment question (Tier B, phase B3 — the last Tier-B
 * type): `options` are the candidates (checkboxes); `answerKey.correct` is the
 * set of correct ids — validated below as a PROPER, non-trivial subset (at
 * least 2 correct, and at least one candidate must be wrong, or the "select
 * ALL" instruction is vacuous — US-3).
 */
const multiQuestionSchema = questionCoreSchema.extend({
  type: z.literal("multi"),
  options: z.array(wireOptionSchema).min(3).max(6),
  answerKey: z.object({ correct: z.array(wireIdSchema).min(2).max(5) }),
});

/**
 * A question file entry — discriminated on `type`, defaulting to `'mcq'` so
 * every pre-existing content file stays valid without edits (spec D-4).
 */
export const questionSchema = z
  .preprocess(
    (val) =>
      val !== null && typeof val === "object" && !("type" in val)
        ? { ...(val as Record<string, unknown>), type: "mcq" }
        : val,
    z.discriminatedUnion("type", [
      mcqQuestionSchema,
      numericQuestionSchema,
      orderingQuestionSchema,
      matchingQuestionSchema,
      multiQuestionSchema,
    ]),
  )
  .superRefine((q, ctx) => {
    // Evaluated competencies (étude 07 R-2, any type): no duplicate ids.
    if (q.competencies && new Set(q.competencies).size !== q.competencies.length) {
      ctx.addIssue({
        code: "custom",
        message: "competency ids must be unique",
        path: ["competencies"],
      });
    }
    if (q.type === "numeric") return;
    if (new Set(q.options.map((o) => o.id)).size !== q.options.length) {
      ctx.addIssue({ code: "custom", message: "option ids must be unique", path: ["options"] });
    }
    if (q.type === "mcq") {
      if (!q.options.some((o) => o.id === q.correctOption)) {
        ctx.addIssue({
          code: "custom",
          message: "correctOption must match one of the option ids",
          path: ["correctOption"],
        });
      }
      // The correct option must stay untagged (étude 04 D-1): a right answer has
      // no misconception, and it must remain the only option without a tag so
      // `distractor_tags->>choice` never diagnoses a correct choice.
      if (q.options.some((o) => o.id === q.correctOption && o.misconceptionTag)) {
        ctx.addIssue({
          code: "custom",
          message: "the correct option must not carry a misconceptionTag",
          path: ["options"],
        });
      }
      return;
    }
    if (q.type === "ordering") {
      // The key must arrange EXACTLY the authored steps (a permutation).
      const ids = q.options.map((o) => o.id).sort();
      const order = [...q.answerKey.order].sort();
      if (ids.length !== order.length || ids.some((id, i) => id !== order[i])) {
        ctx.addIssue({
          code: "custom",
          message: "answerKey.order must be a permutation of the option ids",
          path: ["answerKey", "order"],
        });
      }
      return;
    }
    if (q.type === "multi") {
      const ids = new Set(q.options.map((o) => o.id));
      const correct = q.answerKey.correct;
      if (new Set(correct).size !== correct.length || !correct.every((id) => ids.has(id))) {
        ctx.addIssue({
          code: "custom",
          message: "answerKey.correct must be unique ids drawn from the options",
          path: ["answerKey", "correct"],
        });
      } else if (correct.length >= q.options.length) {
        ctx.addIssue({
          code: "custom",
          message:
            "answerKey.correct must be a PROPER subset — at least one option must be wrong, or 'select ALL' is vacuous",
          path: ["answerKey", "correct"],
        });
      }
      return;
    }
    // matching: options split into l*/r* sides; pairs must be a bijection.
    const lefts = q.options.filter((o) => o.id.startsWith("l")).map((o) => o.id);
    const rights = q.options.filter((o) => o.id.startsWith("r")).map((o) => o.id);
    if (lefts.length + rights.length !== q.options.length) {
      ctx.addIssue({
        code: "custom",
        message: "matching option ids must start with 'l' (left) or 'r' (right)",
        path: ["options"],
      });
      return;
    }
    if (lefts.length < 2 || lefts.length !== rights.length) {
      ctx.addIssue({
        code: "custom",
        message: "matching needs >= 2 left items and as many right items",
        path: ["options"],
      });
      return;
    }
    const pairLefts = q.answerKey.pairs.map(([l]) => l).sort();
    const pairRights = q.answerKey.pairs.map(([, r]) => r).sort();
    const wantLefts = [...lefts].sort();
    const wantRights = [...rights].sort();
    if (
      pairLefts.length !== wantLefts.length ||
      pairLefts.some((id, i) => id !== wantLefts[i]) ||
      pairRights.some((id, i) => id !== wantRights[i])
    ) {
      ctx.addIssue({
        code: "custom",
        message: "answerKey.pairs must pair every left id with every right id exactly once",
        path: ["answerKey", "pairs"],
      });
    }
  });
export type ContentQuestion = z.infer<typeof questionSchema>;
export type ContentMcqQuestion = Extract<ContentQuestion, { type: "mcq" }>;
export type ContentNumericQuestion = Extract<ContentQuestion, { type: "numeric" }>;
export type ContentOrderingQuestion = Extract<ContentQuestion, { type: "ordering" }>;
export type ContentMatchingQuestion = Extract<ContentQuestion, { type: "matching" }>;
export type ContentMultiQuestion = Extract<ContentQuestion, { type: "multi" }>;

/**
 * `quiz.json` — the mandatory comprehension quiz of a chapter. Compiled into
 * an `exercises` row with `mode='quiz'` that gates the chapter's exercises.
 */
export const quizSchema = z.object({
  title: z.string().min(1).optional(),
  questions: z.array(questionSchema).min(3).max(10),
});
export type ContentQuiz = z.infer<typeof quizSchema>;

/** An exercise file under `<chapter>/exercices/*.json`. */
export const exerciseSchema = z.object({
  title: z.string().min(1),
  /**
   * Exercise tier: 1 (easy) … 3 (boss). 4 is the premium "Défi élite" tier —
   * exercises clearly above the chapter average, gated behind a paid
   * subscription + a minimum player level (see startExerciseSession).
   */
  difficulty: z.number().int().min(1).max(4),
  mode: z.enum(["practice", "boss", "challenge"]),
  xpReward: z.number().int().positive(),
  rewardCoins: z.number().int().nonnegative(),
  displayOrder: z.number().int().positive(),
  /**
   * Shared-subject narrowing (étude 16 D-4): sections this exercise is compiled
   * for — enables per-section d3/d4 tiers inside one shared directory (e.g. a
   * `bac-lettres`-only défi in `arabe-bac`). Subset of the chapter's effective
   * targets; absent = all. Never emitted to SQL (the builder reads named fields).
   */
  gradeSlugs: gradeSlugsSubsetSchema,
  /**
   * Optional dedicated correction video (étude 23 R-6): a registry id that
   * overrides the chapter fallback on this exercise's failure screen. Must
   * resolve to an `active` entry in `content/videos.json` (content:qa).
   * Compiled into `exercises.correction_video` JSONB.
   */
  correctionVideo: videoIdSchema.optional(),
  questions: z.array(questionSchema).min(1).max(50),
});
export type ContentExercise = z.infer<typeof exerciseSchema>;

/** A fully loaded exercise (file contents + its source slug). */
export interface LoadedExercise {
  slug: string;
  data: ContentExercise;
}

/** A fully loaded chapter: metadata + markdown bodies + exercises. */
export interface LoadedChapter {
  slug: string;
  meta: ChapterMeta;
  /** Full theoretical course (markdown), stored in `chapters.lesson_content`. */
  lesson: string;
  /** Course summary (markdown), stored in `chapters.summary`. */
  summary: string;
  /** Mandatory comprehension quiz (compiled to a `mode='quiz'` exercise). */
  quiz: ContentQuiz;
  exercises: LoadedExercise[];
}

/** A fully loaded subject and all of its chapters. */
export interface LoadedSubject {
  meta: SubjectMeta;
  chapters: LoadedChapter[];
}
