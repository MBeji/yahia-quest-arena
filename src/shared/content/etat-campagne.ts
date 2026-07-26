/**
 * État des lieux d'une campagne de contenu (pure).
 *
 * Joint les deux moitiés de la chaîne, que rien ne reliait jusqu'ici : le
 * REGISTRE de transcription (où en est la fiche — `transcription-suivi.ts`) et
 * l'AUDIT DE PROGRAMME (où en est le contenu — `program-manifest.ts`).
 *
 * Décision de conception (2026-07-26) : ce module n'ordonne RIEN et ne désigne
 * jamais « le prochain couple ». Choisir ce qu'on lance reste une décision
 * humaine ; l'outil se contente d'établir, en le vérifiant, l'état sur lequel
 * cette décision s'appuie. Tout ce qui suit est donc un constat mesurable —
 * jamais un conseil, jamais un classement par priorité. Une évolution qui
 * ajouterait un tri par priorité contredirait cette décision.
 *
 * Le lien fiche → contenu est DÉCLARÉ (`sujets` d'une entrée de suivi), jamais
 * deviné : les noms ne concordent pas (`mathematiques` alimente
 * `math-1ere-sec`, `chimie` n'alimente aucun sujet propre), donc une jointure
 * heuristique se tromperait une fois sur deux. Non déclaré, le couple le dit.
 *
 * Pur (aucune I/O) : le CLI `scripts/content/etat.ts` charge le disque et
 * appelle ici — même partage que `suivi.ts` / `audit-program.ts`.
 */
import type { GradeAudit, SubjectAudit } from "./program-manifest.ts";
import {
  GRADE_ORDER,
  coveragePct,
  deriveBacklog,
  generationAutorisee,
  gradeSortKey,
  missingRanges,
  type FicheEntry,
  type FicheProfondeur,
  type FicheStatut,
  type SuiviCheckInput,
} from "./transcription-suivi.ts";

/** Content-side facts for one manifest subject, as measured by `auditGrade`. */
export interface EtatSujet {
  id: string;
  /** false = the program expects it, `content/` has no such subject. */
  present: boolean;
  /** null when the grade's chapter list is not codified in the manifest. */
  chapitresAttendus: number | null;
  chapitresPresents: number;
  chapitresManquants: string[];
  chapitresIncomplets: string[];
  horsProgramme: string[];
  langueOk: boolean | null;
}

/** Fiche-side facts, all derived from the registry (never re-declared). */
export interface EtatFiche {
  statut: FicheStatut;
  profondeur: FicheProfondeur;
  /** Lowest coverage across sources; null as soon as one is unmeasured. */
  couverturePct: number | null;
  /** Unread page ranges, per source: `502304 p.61–120`. */
  trous: string[];
  r7: string | null;
  /** Derived from the status: a fiche under the R-5 bar must not be generated. */
  generationAutorisee: boolean;
}

export interface EtatCouple {
  grade: string;
  /** Fiche basename; null for a manifest subject no fiche declares. */
  matiere: string | null;
  fiche: EtatFiche | null;
  sujets: EtatSujet[];
  /**
   * The fiche declares which subjects it feeds. Structured rather than a
   * sentence in `constats`: it is the most frequent state today, and a consumer
   * should be able to count it without parsing French. Always true for a
   * subject-only couple (there is no fiche to declare anything).
   */
  lienDeclare: boolean;
  /** Verified facts a human may want to act on — never a recommendation. */
  constats: string[];
}

export interface EtatGrade {
  grade: string;
  /** A program manifest was found for this grade. */
  manifeste: boolean;
  scelle: boolean | null;
  couples: EtatCouple[];
}

export interface EtatDesLieux {
  grades: EtatGrade[];
  /** Corpus left to attach, by grade slot (année) — same derivation as `_INDEX.md`. */
  aRattacher: Array<{ creneau: string; matieres: Array<{ matiere: string; codes: string[] }> }>;
  totaux: {
    fiches: number;
    fichesGenerables: number;
    sujetsAttendus: number;
    sujetsPresents: number;
    fichesSansLien: number;
    oeuvresARattacher: number;
  };
}

export interface EtatInput extends SuiviCheckInput {
  /** One entry per grade manifest, as produced by `auditGrade`. */
  audits: GradeAudit[];
  /**
   * Narrow the REPORT to one grade. The registry is still read whole: the
   * backlog is derived from every fiche, so filtering the input would make
   * works look unattached that another grade's fiche already claims.
   */
  onlyGrade?: string;
}

function couvertureOf(entry: FicheEntry): number | null {
  if (entry.sources.length === 0) return null;
  const pcts = entry.sources.map(coveragePct);
  return pcts.some((p) => p === null) ? null : Math.min(...(pcts as number[]));
}

function trousOf(entry: FicheEntry): string[] {
  const out: string[] = [];
  for (const source of entry.sources) {
    const holes = missingRanges(source);
    if (holes.length === 0) continue;
    const ranges = holes.map(([a, b]) => (a === b ? `${a}` : `${a}–${b}`)).join(", p.");
    out.push(`${source.code} p.${ranges}`);
  }
  return out;
}

function toEtatFiche(entry: FicheEntry): EtatFiche {
  return {
    statut: entry.statut,
    profondeur: entry.profondeur,
    couverturePct: couvertureOf(entry),
    trous: trousOf(entry),
    r7: entry.r7 ? `${entry.r7.date} (${entry.r7.portee}, ${entry.r7.corrections} corr.)` : null,
    generationAutorisee: generationAutorisee(entry),
  };
}

function toEtatSujet(audit: SubjectAudit): EtatSujet {
  return {
    id: audit.id,
    present: audit.present,
    chapitresAttendus: audit.chaptersCodified ? audit.expectedChapters : null,
    chapitresPresents: audit.presentExpected,
    chapitresManquants: audit.missingChapters,
    chapitresIncomplets: audit.chapterCompleteness.filter((c) => !c.complete).map((c) => c.slug),
    horsProgramme: audit.offProgramChapters,
    langueOk: audit.languageOk,
  };
}

export function buildEtat(input: EtatInput): EtatDesLieux {
  const { corpus, affectations, suivis, audits, onlyGrade } = input;
  const auditByGrade = new Map(audits.map((a) => [a.grade, a]));
  const suiviByGrade = new Map(suivis.map((s) => [s.grade, s]));

  const gradeNames = [...new Set([...suivis.map((s) => s.grade), ...audits.map((a) => a.grade)])]
    .filter((g) => !onlyGrade || g === onlyGrade)
    .sort((a, b) => gradeSortKey(a) - gradeSortKey(b) || a.localeCompare(b));

  let fiches = 0;
  let fichesGenerables = 0;
  let fichesSansLien = 0;

  const grades: EtatGrade[] = gradeNames.map((grade) => {
    const audit = auditByGrade.get(grade);
    const subjectById = new Map((audit?.subjects ?? []).map((s) => [s.id, s]));
    const entries = [...(suiviByGrade.get(grade)?.fiches ?? [])].sort((a, b) =>
      a.matiere.localeCompare(b.matiere),
    );
    const declared = new Set<string>();
    const couples: EtatCouple[] = [];

    for (const entry of entries) {
      fiches += 1;
      const generable = generationAutorisee(entry);
      if (generable) fichesGenerables += 1;

      const constats: string[] = [];
      const sujets: EtatSujet[] = [];
      for (const id of entry.sujets) {
        declared.add(id);
        const subject = subjectById.get(id);
        if (!subject) {
          constats.push(
            audit
              ? `sujet déclaré « ${id} » absent du manifeste ${grade}`
              : `sujet déclaré « ${id} » invérifiable : aucun manifeste ${grade}`,
          );
          continue;
        }
        sujets.push(toEtatSujet(subject));
      }
      const lienDeclare = entry.sujets.length > 0;
      if (!lienDeclare) fichesSansLien += 1;

      const contenuPresent = sujets.some((s) => s.present);
      if (generable && sujets.length > 0 && !contenuPresent) {
        constats.push("fiche exploitable, aucun contenu généré");
      }
      if (!generable && contenuPresent) {
        constats.push(
          `contenu présent alors que la fiche est ${entry.statut}/${entry.profondeur} — ` +
            `la génération a consommé une fiche sous la barre R-5`,
        );
      }

      couples.push({
        grade,
        matiere: entry.matiere,
        fiche: toEtatFiche(entry),
        sujets,
        lienDeclare,
        constats,
      });
    }

    for (const subject of audit?.subjects ?? []) {
      if (declared.has(subject.id)) continue;
      couples.push({
        grade,
        matiere: null,
        fiche: null,
        sujets: [toEtatSujet(subject)],
        lienDeclare: true,
        constats: [],
      });
    }

    return { grade, manifeste: audit !== undefined, scelle: audit?.sealed ?? null, couples };
  });

  const backlog = deriveBacklog(corpus, affectations, suivis);
  const aRattacher: EtatDesLieux["aRattacher"] = [];
  let oeuvresARattacher = 0;
  for (const creneau of GRADE_ORDER) {
    const bySubject = backlog.get(creneau);
    if (!bySubject) continue;
    // A section grade (`bac-math`) belongs to its year slot (`bac`).
    if (onlyGrade && onlyGrade !== creneau && !onlyGrade.startsWith(`${creneau}-`)) continue;
    const matieres = [...bySubject.entries()]
      .sort((a, b) => a[0].localeCompare(b[0]))
      .map(([matiere, docs]) => {
        const codes = [...new Set(docs.map((d) => d.code))].sort();
        oeuvresARattacher += codes.length;
        return { matiere, codes };
      });
    aRattacher.push({ creneau, matieres });
  }

  const allSubjects = audits.flatMap((a) => a.subjects);
  return {
    grades,
    aRattacher,
    totaux: {
      fiches,
      fichesGenerables,
      sujetsAttendus: allSubjects.length,
      sujetsPresents: allSubjects.filter((s) => s.present).length,
      fichesSansLien,
      oeuvresARattacher,
    },
  };
}

function renderSujet(sujet: EtatSujet): string {
  const chapitres =
    sujet.chapitresAttendus === null
      ? `${sujet.chapitresPresents} ch (chapitrage non codifié)`
      : `${sujet.chapitresPresents}/${sujet.chapitresAttendus} ch`;
  const bits = [chapitres];
  if (sujet.chapitresIncomplets.length > 0) {
    bits.push(`${sujet.chapitresIncomplets.length} incomplet(s)`);
  }
  if (sujet.horsProgramme.length > 0) bits.push(`${sujet.horsProgramme.length} hors-programme`);
  if (sujet.langueOk === false) bits.push("langue ≠ programme");
  return `${sujet.present ? sujet.id : `${sujet.id} — ABSENT de content/`} : ${bits.join(" · ")}`;
}

/** Human-readable report. Deterministic: no date, no ordering by priority. */
export function renderEtat(etat: EtatDesLieux): string {
  const lines: string[] = [];
  lines.push("État des lieux — registre de transcription × programme codifié × contenu.");
  lines.push(
    "Aucune priorité n'est calculée ici : le choix de ce qu'on lance reste humain (méthode, Phase 0.4).",
  );

  for (const grade of etat.grades) {
    const manifeste = grade.manifeste
      ? `manifeste ${grade.scelle ? "scellé" : "non scellé"}`
      : "AUCUN manifeste";
    lines.push("");
    lines.push(`━━ ${grade.grade} — ${manifeste} ━━`);
    if (grade.couples.length === 0) lines.push("  (aucune fiche, aucun sujet attendu)");

    // Les deux états les plus fréquents (lien non déclaré, sujet sans fiche) se
    // regroupent en fin de niveau : répétés ligne à ligne, ils noieraient les
    // faits propres à chaque fiche.
    const sansLien: string[] = [];
    const orphelins: EtatSujet[] = [];

    for (const couple of grade.couples) {
      if (!couple.fiche) {
        orphelins.push(...couple.sujets);
        continue;
      }
      const f = couple.fiche;
      const bits = [`${f.statut} / ${f.profondeur}`];
      bits.push(f.couverturePct === null ? "couverture ?" : `couverture ${f.couverturePct} %`);
      if (f.trous.length > 0) bits.push(`trous ${f.trous.join(" · ")}`);
      if (f.r7) bits.push(`R-7 ${f.r7}`);
      bits.push(f.generationAutorisee ? "génération autorisée" : "⛔ génération interdite");
      lines.push(`  fiche ${couple.matiere} — ${bits.join(" · ")}`);
      for (const sujet of couple.sujets) lines.push(`      └ ${renderSujet(sujet)}`);
      for (const constat of couple.constats) lines.push(`      ! ${constat}`);
      if (!couple.lienDeclare && couple.matiere) sansLien.push(couple.matiere);
    }

    for (const sujet of orphelins) {
      lines.push(`  sujet sans fiche déclarée — ${renderSujet(sujet)}`);
    }
    if (sansLien.length > 0) {
      lines.push(`  ! lien fiche → sujets non déclaré (\`sujets: []\`) : ${sansLien.join(", ")}`);
    }
  }

  if (etat.aRattacher.length > 0) {
    lines.push("");
    lines.push("━━ Corpus principal non rattaché à une fiche (dérivé) ━━");
    for (const { creneau, matieres } of etat.aRattacher) {
      const parts = matieres.map((m) => `${m.matiere} (${m.codes.join(", ")})`);
      lines.push(`  ${creneau} : ${parts.join(" · ")}`);
    }
  }

  const t = etat.totaux;
  lines.push("");
  lines.push(
    `Totaux : ${t.fiches} fiche(s) dont ${t.fichesGenerables} exploitable(s) · ` +
      `${t.sujetsPresents}/${t.sujetsAttendus} sujet(s) du programme présents · ` +
      `${t.fichesSansLien} fiche(s) sans lien déclaré · ` +
      `${t.oeuvresARattacher} œuvre(s) à rattacher.`,
  );
  return `${lines.join("\n")}\n`;
}
