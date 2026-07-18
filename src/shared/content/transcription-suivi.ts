/**
 * Transcription tracking registry (programmes officiels CNP → fiches).
 *
 * The transcription layer used to be tracked by a hand-maintained `_INDEX.md`
 * (free-text statuses, drifting totals) plus per-session conventions — which
 * produced REAL double-transcriptions (2026-07-12 collège campaign; 2026-07-17
 * vague-A). This module replaces that with a machine-checked registry:
 *
 *   - `suivi/corpus-cnp.json`    — generated snapshot of the whole CNP corpus
 *                                  (one entry per PDF file — exhaustive);
 *   - `suivi/affectations.json`  — editorial decisions: per-subject-code
 *                                  category (principale / annexe / …) + per-code
 *                                  overrides;
 *   - `suivi/<grade>.json`       — the state of each fiche (normalized status,
 *                                  sources with EXPLICIT page-range coverage,
 *                                  R-7 verdict, author, date);
 *   - `programme/_INDEX.md`      — now a GENERATED view (never hand-edited).
 *
 * Invariants enforced by {@link checkSuivi} (CI gate `programme:check`):
 *   1. every corpus PDF resolves to a category (unknown subject code = error);
 *   2. a source PDF is claimed by at most ONE fiche (anti-double-transcription);
 *   3. fiche on disk ⇔ registry entry (no untracked fiche, no ghost entry);
 *   4. cited sources exist in the corpus (code, tomes, role);
 *   5. page ranges are valid, sorted, non-overlapping, within bounds;
 *   6. status `complete`/`validee-r7`/`promue` requires 100 % coverage of every
 *      source (a "complete" claim with holes is an error, not a nuance);
 *   7. `validee-r7`/`promue` require a recorded R-7 verdict.
 *
 * Pure module (no I/O): the CLI in `scripts/content/suivi.ts` loads JSON +
 * disk state and calls into here. Same pattern as `program-manifest.ts`.
 */
import { z } from "zod";

// --------------------------------------------------------------------------
// Corpus snapshot — generated from cnp-officiel/catalogue.csv, do not edit.
// --------------------------------------------------------------------------

export const corpusDocumentSchema = z.object({
  /** 6-digit CNP code (identity of the work; a work may span several tomes). */
  code: z.string().regex(/^\d{6}$/),
  /** Tome suffix of the PDF file name (P00, P01, …). */
  tome: z.string().regex(/^P\d{2}$/),
  cycle: z.enum(["base", "secondaire"]),
  role: z.enum(["eleve", "enseignant"]),
  /** 4th digit of the code: grade year (base 1-9, secondaire 1-4; 0 = transverse). */
  classe: z.number().int().min(0).max(9),
  /** Digits 2-3 of the code: subject code (keys `affectations.matieres`). */
  matiere: z.string().regex(/^\d{2}$/),
  titre: z.string().min(1),
  /** File name inside the corpus tree (e.g. `501109P00.pdf`). */
  fichier: z.string().min(1),
  octets: z.number().int().nonnegative(),
});
export type CorpusDocument = z.infer<typeof corpusDocumentSchema>;

export const corpusSchema = z.object({
  generatedFrom: z.string(),
  count: z.number().int().nonnegative(),
  documents: z.array(corpusDocumentSchema),
});
export type Corpus = z.infer<typeof corpusSchema>;

// --------------------------------------------------------------------------
// Affectations — editorial categorisation of the corpus (editable).
// --------------------------------------------------------------------------

/**
 * - `principale`     — carries the school programme: must eventually be transcribed;
 * - `annexe`         — out of scope for now by decision 2026-07-14 (musique, dessin, EPS…);
 * - `hors-perimetre` — never targeted (3èmes langues, section sport);
 * - `differee`       — product decision pending (tracked, not required);
 * - `enrichissement` — optional support material (BD, مدونة القسم…), never a fiche source of truth.
 */
export const AFFECTATION_CATEGORIES = [
  "principale",
  "annexe",
  "hors-perimetre",
  "differee",
  "enrichissement",
] as const;
export const affectationCategorySchema = z.enum(AFFECTATION_CATEGORIES);
export type AffectationCategory = z.infer<typeof affectationCategorySchema>;

export const affectationsSchema = z.object({
  /** Default category per subject code (digits 2-3), e.g. "01" → arabe/principale. */
  matieres: z.record(
    z.string().regex(/^\d{2}$/),
    z.object({
      id: z.string().min(1),
      categorie: affectationCategorySchema,
      note: z.string().optional(),
    }),
  ),
  /** Per-code exceptions (all tomes of the code), e.g. the section-sport SVT manual. */
  overrides: z.record(
    z.string().regex(/^\d{6}$/),
    z.object({
      categorie: affectationCategorySchema,
      note: z.string().min(1),
    }),
  ),
});
export type Affectations = z.infer<typeof affectationsSchema>;

// --------------------------------------------------------------------------
// Suivi — the state of each fiche, per grade (editable, one file per grade).
// --------------------------------------------------------------------------

/**
 * Normalized fiche statuses — the ONLY vocabulary allowed:
 * - `en-cours`    — reserved by a session (fiche may not exist on disk yet);
 * - `partielle`   — fiche exists, coverage has holes → GENERATION FORBIDDEN;
 * - `complete`    — generation-depth on 100 % of every source, no independent
 *                   re-read yet → generation allowed;
 * - `validee-r7`  — complete + independent R-7 re-read recorded;
 * - `promue`      — final human promotion (Mohamed) — never set by an agent.
 */
export const FICHE_STATUTS = ["en-cours", "partielle", "complete", "validee-r7", "promue"] as const;
export const ficheStatutSchema = z.enum(FICHE_STATUTS);
export type FicheStatut = z.infer<typeof ficheStatutSchema>;

/** Inclusive 1-based page range [from, to]. */
export const pageRangeSchema = z.tuple([z.number().int().min(1), z.number().int().min(1)]);

export const pagesLuesSchema = z.union([
  z.array(pageRangeSchema),
  z.literal("integral"),
  /** Legacy seed only — a fiche touched from now on must declare real ranges. */
  z.literal("inconnu"),
]);
export type PagesLues = z.infer<typeof pagesLuesSchema>;

export const ficheSourceSchema = z.object({
  code: z.string().regex(/^\d{6}$/),
  tomes: z.array(z.string().regex(/^P\d{2}$/)).min(1),
  role: z.enum(["eleve", "enseignant"]),
  /** Total pages of the work (all tomes combined); null when never measured. */
  pagesTotal: z.number().int().min(1).nullable(),
  pagesLues: pagesLuesSchema,
});
export type FicheSource = z.infer<typeof ficheSourceSchema>;

/**
 * Depth of the restitution (independent from page coverage!):
 * - `first-pass`  — structure/objectives only, synthesized — NOT enough to generate (R-5);
 * - `mixte`       — some units at generation depth, others first-pass;
 * - `generation`  — every covered unit at generation depth (each activity described,
 *                   official boxes verbatim, scope bounds).
 * A fiche read 100 % but restituted thin is still NOT complete (the 2026-07 collège vice).
 */
export const ficheProfondeurSchema = z.enum(["first-pass", "mixte", "generation"]);
export type FicheProfondeur = z.infer<typeof ficheProfondeurSchema>;

export const ficheEntrySchema = z.object({
  /** Basename of the fiche file: `programme/<grade>/<matiere>.md`. */
  matiere: z.string().regex(/^[a-z0-9-]+$/),
  statut: ficheStatutSchema,
  profondeur: ficheProfondeurSchema,
  sources: z.array(ficheSourceSchema),
  /** Sources outside the CNP corpus (free text), e.g. a ministry programme booklet. */
  sourcesLibres: z.array(z.string().min(1)).default([]),
  r7: z
    .object({
      date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
      portee: z.enum(["integrale", "sondage"]),
      verdict: z.string().min(1),
      corrections: z.number().int().nonnegative(),
    })
    .nullable(),
  maj: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  par: z.string().min(1),
  notes: z.string(),
});
export type FicheEntry = z.infer<typeof ficheEntrySchema>;

export const suiviGradeSchema = z.object({
  grade: z.string().regex(/^[a-z0-9-]+$/),
  fiches: z.array(ficheEntrySchema),
});
export type SuiviGrade = z.infer<typeof suiviGradeSchema>;

// --------------------------------------------------------------------------
// Checking (pure).
// --------------------------------------------------------------------------

export interface SuiviCheckInput {
  corpus: Corpus;
  affectations: Affectations;
  suivis: SuiviGrade[];
  /** Fiches actually present on disk, as `<grade>/<matiere>` (no extension). */
  fichesOnDisk: string[];
}

export interface SuiviCheckResult {
  errors: string[];
  warnings: string[];
}

/** Resolve the category of a corpus document (override wins over subject default). */
export function resolveCategorie(
  doc: CorpusDocument,
  affectations: Affectations,
): AffectationCategory | null {
  const override = affectations.overrides[doc.code];
  if (override) return override.categorie;
  return affectations.matieres[doc.matiere]?.categorie ?? null;
}

function coversFully(source: FicheSource): boolean {
  if (source.pagesLues === "integral") return true;
  if (source.pagesLues === "inconnu") return false;
  if (source.pagesTotal === null) return false;
  let next = 1;
  for (const [from, to] of source.pagesLues) {
    if (from > next) return false;
    next = Math.max(next, to + 1);
  }
  return next > source.pagesTotal;
}

/** Percentage of pages read (0-100), or null when it cannot be computed. */
export function coveragePct(source: FicheSource): number | null {
  if (source.pagesLues === "integral") return 100;
  if (source.pagesLues === "inconnu" || source.pagesTotal === null) return null;
  const read = source.pagesLues.reduce((sum, [from, to]) => sum + (to - from + 1), 0);
  return Math.round((read / source.pagesTotal) * 100);
}

const GENERATION_ALLOWED: readonly FicheStatut[] = ["complete", "validee-r7", "promue"];

/** Whether pedagogical generation may consume this fiche (derived, never stored). */
export function generationAutorisee(entry: FicheEntry): boolean {
  return GENERATION_ALLOWED.includes(entry.statut);
}

export function checkSuivi(input: SuiviCheckInput): SuiviCheckResult {
  const errors: string[] = [];
  const warnings: string[] = [];
  const { corpus, affectations, suivis, fichesOnDisk } = input;

  // 1. Every corpus PDF resolves to a category.
  const corpusByCode = new Map<string, CorpusDocument[]>();
  for (const doc of corpus.documents) {
    if (resolveCategorie(doc, affectations) === null) {
      errors.push(
        `corpus: code matière inconnu "${doc.matiere}" (${doc.code}${doc.tome} — ${doc.titre}) : ` +
          `ajouter la matière dans affectations.json`,
      );
    }
    const list = corpusByCode.get(doc.code) ?? [];
    list.push(doc);
    corpusByCode.set(doc.code, list);
  }
  if (corpus.count !== corpus.documents.length) {
    errors.push(`corpus: count=${corpus.count} ≠ documents.length=${corpus.documents.length}`);
  }

  // 2-7. Per-fiche invariants + anti-double-transcription.
  const claimedBy = new Map<string, string>(); // source code → "<grade>/<matiere>"
  const entriesByPath = new Map<string, FicheEntry>();
  for (const suivi of suivis) {
    const seenMatieres = new Set<string>();
    for (const entry of suivi.fiches) {
      const path = `${suivi.grade}/${entry.matiere}`;
      if (seenMatieres.has(entry.matiere)) {
        errors.push(`suivi ${suivi.grade}: entrée dupliquée pour "${entry.matiere}"`);
        continue;
      }
      seenMatieres.add(entry.matiere);
      entriesByPath.set(path, entry);

      // 3. fiche on disk ⇔ entry (en-cours may not have a file yet).
      const onDisk = fichesOnDisk.includes(path);
      if (entry.statut !== "en-cours" && !onDisk) {
        errors.push(
          `suivi ${path}: statut "${entry.statut}" mais programme/${path}.md absent du disque`,
        );
      }

      if (
        entry.sources.length === 0 &&
        entry.sourcesLibres.length === 0 &&
        entry.statut !== "en-cours"
      ) {
        errors.push(`suivi ${path}: aucune source déclarée (corpus ou libre)`);
      }

      // 6b. a "complete"-or-better status also requires generation depth (R-5).
      if (GENERATION_ALLOWED.includes(entry.statut) && entry.profondeur !== "generation") {
        errors.push(
          `suivi ${path}: statut "${entry.statut}" mais profondeur "${entry.profondeur}" — ` +
            `une fiche first-pass/mixte ne se déclare pas complète (R-5)`,
        );
      }

      for (const source of entry.sources) {
        // 2. anti-double-transcription: one code, one fiche.
        const claimant = claimedBy.get(source.code);
        if (claimant && claimant !== path) {
          errors.push(
            `DOUBLON: la source ${source.code} est revendiquée par "${claimant}" ET "${path}" — ` +
              `une source n'alimente qu'une fiche (R-4)`,
          );
        } else {
          claimedBy.set(source.code, path);
        }

        // 4. cited sources exist in the corpus.
        const docs = corpusByCode.get(source.code);
        if (!docs) {
          errors.push(
            `suivi ${path}: source ${source.code} absente du corpus (suivi/corpus-cnp.json)`,
          );
        } else {
          for (const tome of source.tomes) {
            if (!docs.some((d) => d.tome === tome)) {
              errors.push(`suivi ${path}: tome ${source.code}${tome} absent du corpus`);
            }
          }
          if (!docs.some((d) => d.role === source.role)) {
            errors.push(
              `suivi ${path}: la source ${source.code} n'a pas le rôle "${source.role}" au corpus`,
            );
          }
        }

        // 5. page ranges valid, sorted, non-overlapping, within bounds.
        if (Array.isArray(source.pagesLues)) {
          let prevTo = 0;
          for (const [from, to] of source.pagesLues) {
            if (from > to) {
              errors.push(`suivi ${path}: plage invalide [${from}, ${to}] (source ${source.code})`);
            }
            if (from <= prevTo) {
              errors.push(
                `suivi ${path}: plages non triées ou chevauchantes autour de [${from}, ${to}] (source ${source.code})`,
              );
            }
            prevTo = Math.max(prevTo, to);
          }
          if (source.pagesTotal !== null && prevTo > source.pagesTotal) {
            errors.push(
              `suivi ${path}: pagesLues dépasse pagesTotal=${source.pagesTotal} (source ${source.code})`,
            );
          }
          if (source.pagesTotal === null) {
            warnings.push(
              `suivi ${path}: plages déclarées sans pagesTotal (source ${source.code})`,
            );
          }
        }
        if (source.pagesLues === "inconnu") {
          warnings.push(
            `suivi ${path}: couverture "inconnu" (seed legacy, source ${source.code}) — à préciser à la prochaine touche`,
          );
        }

        // 6. a "complete"-or-better status requires full coverage of every source.
        if (GENERATION_ALLOWED.includes(entry.statut) && !coversFully(source)) {
          errors.push(
            `suivi ${path}: statut "${entry.statut}" mais la source ${source.code} n'est pas couverte à 100 % ` +
              `(pagesLues=${JSON.stringify(source.pagesLues)}, pagesTotal=${source.pagesTotal}) — ` +
              `un statut "complet" avec des trous est une fausse déclaration`,
          );
        }
      }

      // 7. R-7 consistency.
      if ((entry.statut === "validee-r7" || entry.statut === "promue") && entry.r7 === null) {
        errors.push(`suivi ${path}: statut "${entry.statut}" sans verdict r7 enregistré`);
      }
      if (
        entry.statut === "partielle" &&
        entry.sources.every((s) => coversFully(s)) &&
        entry.sources.length > 0
      ) {
        warnings.push(
          `suivi ${path}: statut "partielle" mais toutes les sources sont couvertes à 100 % — promouvoir ?`,
        );
      }
    }
  }

  // 3b. No untracked fiche on disk.
  for (const path of fichesOnDisk) {
    if (!entriesByPath.has(path)) {
      errors.push(
        `disque: programme/${path}.md existe mais n'a AUCUNE entrée de suivi — ` +
          `toute fiche doit être enregistrée (suivi/<grade>.json)`,
      );
    }
  }

  return { errors, warnings };
}

// --------------------------------------------------------------------------
// Derived backlog + generated _INDEX.md rendering (pure).
// --------------------------------------------------------------------------

const BASE_GRADE_BY_CLASSE: Record<number, string> = {
  1: "1ere-base",
  2: "2eme-base",
  3: "3eme-base",
  4: "4eme-base",
  5: "5eme-base",
  6: "6eme-base",
  7: "7eme-base",
  8: "8eme-base",
  9: "9eme-base",
};
const SEC_GRADE_BY_CLASSE: Record<number, string> = {
  1: "1ere-sec",
  2: "2eme-sec",
  3: "3eme-sec",
  4: "bac",
};

/** Grade slot a corpus document belongs to (year-level; lycée sections refine later). */
export function gradeSlotOf(doc: CorpusDocument): string | null {
  const table = doc.cycle === "base" ? BASE_GRADE_BY_CLASSE : SEC_GRADE_BY_CLASSE;
  return table[doc.classe] ?? null;
}

const STATUT_BADGE: Record<FicheStatut, string> = {
  "en-cours": "⏳ en cours",
  partielle: "🚧 partielle — ⛔ génération interdite",
  complete: "✅ complète",
  "validee-r7": "✅ validée R-7",
  promue: "⭐ promue",
};

function formatCoverage(entry: FicheEntry): string {
  if (entry.sources.length === 0) return "—";
  return entry.sources
    .map((s) => {
      const pct = coveragePct(s);
      const tomes = s.tomes.length > 1 ? `×${s.tomes.length}` : "";
      if (s.pagesLues === "integral") return `\`${s.code}\`${tomes} 100 %`;
      if (pct === null) return `\`${s.code}\`${tomes} ?`;
      const holes = Array.isArray(s.pagesLues) && s.pagesTotal !== null ? missingRanges(s) : [];
      const holeTxt =
        holes.length > 0
          ? ` (manque p.${holes.map(([a, b]) => (a === b ? a : `${a}–${b}`)).join(", p.")})`
          : "";
      return `\`${s.code}\`${tomes} ${pct} %${holeTxt}`;
    })
    .join(" · ");
}

function missingRanges(source: FicheSource): Array<[number, number]> {
  if (!Array.isArray(source.pagesLues) || source.pagesTotal === null) return [];
  const holes: Array<[number, number]> = [];
  let next = 1;
  for (const [from, to] of source.pagesLues) {
    if (from > next) holes.push([next, from - 1]);
    next = Math.max(next, to + 1);
  }
  if (next <= source.pagesTotal) holes.push([next, source.pagesTotal]);
  return holes;
}

const GRADE_ORDER = [
  "1ere-base",
  "2eme-base",
  "3eme-base",
  "4eme-base",
  "5eme-base",
  "6eme-base",
  "7eme-base",
  "8eme-base",
  "9eme-base",
  "1ere-sec",
  "2eme-sec",
  "3eme-sec",
  "bac",
];

function gradeSortKey(grade: string): number {
  const exact = GRADE_ORDER.indexOf(grade);
  if (exact >= 0) return exact * 10;
  // Section grades (e.g. bac-math, 2eme-sec-sciences) sort right after their year.
  const year = GRADE_ORDER.findIndex((g) => grade.startsWith(`${g}-`));
  return year >= 0 ? year * 10 + 1 : 999;
}

export function renderIndex(input: SuiviCheckInput): string {
  const { corpus, affectations, suivis, fichesOnDisk } = input;
  const lines: string[] = [];
  lines.push("# `_INDEX.md` — suivi de transcription du programme CNP (GÉNÉRÉ)");
  lines.push("");
  lines.push(
    "<!-- FICHIER GÉNÉRÉ par `npm run programme:index` depuis suivi/*.json — NE PAS ÉDITER. -->",
  );
  lines.push("");
  lines.push(
    "> **Ne pas éditer à la main.** La source de vérité est le registre machine-vérifiable " +
      "[`../suivi/`](../suivi/) (`corpus-cnp.json` + `affectations.json` + `<grade>.json`), " +
      "validé en CI par `npm run programme:check`. Pour mettre à jour : éditer `suivi/<grade>.json` " +
      "puis régénérer cette vue avec `npm run programme:index`. Statuts normés : `en-cours` → " +
      "`partielle` (⛔ génération interdite) → `complete` → `validee-r7` → `promue` (humain " +
      "uniquement). La couverture se déclare en **plages de pages par source** — le % est calculé, " +
      "jamais écrit à la main.",
  );
  lines.push("");

  const sortedSuivis = [...suivis].sort(
    (a, b) => gradeSortKey(a.grade) - gradeSortKey(b.grade) || a.grade.localeCompare(b.grade),
  );
  let totalFiches = 0;
  const statutCounts = new Map<FicheStatut, number>();
  for (const suivi of sortedSuivis) {
    if (suivi.fiches.length === 0) continue;
    lines.push(`## ${suivi.grade}`);
    lines.push("");
    lines.push(
      "| statut | matière | profondeur | sources (couverture calculée) | R-7 | maj | notes |",
    );
    lines.push("| --- | --- | --- | --- | --- | --- | --- |");
    const sorted = [...suivi.fiches].sort((a, b) => a.matiere.localeCompare(b.matiere));
    for (const entry of sorted) {
      totalFiches += 1;
      statutCounts.set(entry.statut, (statutCounts.get(entry.statut) ?? 0) + 1);
      const r7 = entry.r7
        ? `${entry.r7.date} (${entry.r7.portee}, ${entry.r7.verdict}, ${entry.r7.corrections} corr.)`
        : "—";
      const notes = entry.notes.replace(/\\/g, "\\\\").replace(/\|/g, "\\|");
      const sources =
        entry.sourcesLibres.length > 0
          ? [formatCoverage(entry), ...entry.sourcesLibres.map((s) => `_${s}_`)]
              .filter((s) => s !== "—")
              .join(" · ")
          : formatCoverage(entry);
      lines.push(
        `| ${STATUT_BADGE[entry.statut]} | **${entry.matiere}** | ${entry.profondeur} | ${sources} | ${r7} | ${entry.maj} (${entry.par}) | ${notes} |`,
      );
    }
    lines.push("");
  }

  // Derived backlog: principale PDFs whose grade-slot × matière has no fiche at all.
  const coveredCodes = new Set<string>();
  for (const suivi of suivis)
    for (const f of suivi.fiches) for (const s of f.sources) coveredCodes.add(s.code);
  const fichesByGradePrefix = new Map<string, Set<string>>();
  for (const path of fichesOnDisk) {
    const [grade] = path.split("/");
    const year = GRADE_ORDER.find((g) => grade === g || grade.startsWith(`${g}-`)) ?? grade;
    const set = fichesByGradePrefix.get(year) ?? new Set<string>();
    set.add(path);
    fichesByGradePrefix.set(year, set);
  }
  const backlog = new Map<string, Map<string, CorpusDocument[]>>(); // slot → matiereId → docs
  const excluded = new Map<AffectationCategory, number>();
  for (const doc of corpus.documents) {
    const cat = resolveCategorie(doc, affectations);
    if (cat === null) continue;
    if (cat !== "principale") {
      excluded.set(cat, (excluded.get(cat) ?? 0) + 1);
      continue;
    }
    if (coveredCodes.has(doc.code)) continue;
    const slot = gradeSlotOf(doc);
    if (slot === null) continue;
    const matiereId = affectations.matieres[doc.matiere]?.id ?? doc.matiere;
    const bySubject = backlog.get(slot) ?? new Map<string, CorpusDocument[]>();
    const docs = bySubject.get(matiereId) ?? [];
    docs.push(doc);
    bySubject.set(matiereId, docs);
    backlog.set(slot, bySubject);
  }

  lines.push("## À transcrire (dérivé du corpus — PDF `principale` non rattachés à une fiche)");
  lines.push("");
  lines.push(
    "> Calculé automatiquement : tout PDF de matière principale qu'aucune fiche ne cite. " +
      "Au secondaire, le créneau est l'**année** (les sections se précisent à la transcription — " +
      "matrice : `docs/lycee-architecture.md`). Ordre de priorité de campagne : lycée d'abord " +
      "(méthode, Phase 0.4).",
  );
  lines.push("");
  let backlogCount = 0;
  for (const slot of GRADE_ORDER) {
    const bySubject = backlog.get(slot);
    if (!bySubject) continue;
    const parts: string[] = [];
    for (const [matiereId, docs] of [...bySubject.entries()].sort((a, b) =>
      a[0].localeCompare(b[0]),
    )) {
      const codes = [...new Set(docs.map((d) => d.code))].sort();
      backlogCount += codes.length;
      parts.push(`**${matiereId}** (${codes.map((c) => `\`${c}\``).join(", ")})`);
    }
    lines.push(`- **${slot}** : ${parts.join(" · ")}`);
  }
  if (backlogCount === 0) lines.push("- _(rien — tout le corpus principal est rattaché)_");
  lines.push("");

  lines.push("## Corpus hors transcription (classé, exhaustif)");
  lines.push("");
  const catOrder: AffectationCategory[] = [
    "annexe",
    "hors-perimetre",
    "differee",
    "enrichissement",
  ];
  for (const cat of catOrder) {
    lines.push(`- **${cat}** : ${excluded.get(cat) ?? 0} PDF`);
  }
  const differes = corpus.documents.filter((d) => resolveCategorie(d, affectations) === "differee");
  if (differes.length > 0) {
    const byCode = [...new Set(differes.map((d) => `\`${d.code}\``))].sort();
    lines.push(`  - décisions en attente (\`differee\`) : ${byCode.join(", ")}`);
  }
  lines.push("");

  const statutSummary = FICHE_STATUTS.filter((s) => (statutCounts.get(s) ?? 0) > 0)
    .map((s) => `${statutCounts.get(s)} ${s}`)
    .join(" · ");
  lines.push(
    `**Totaux (calculés)** : ${totalFiches} fiches suivies (${statutSummary}) · ` +
      `${corpus.documents.length} PDF au corpus · ${backlogCount} œuvres principales restant à rattacher.`,
  );
  lines.push("");
  return lines.join("\n");
}
