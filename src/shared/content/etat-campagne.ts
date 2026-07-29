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
  parcoursDuGrade,
  type OuvertureLue,
  type ParcoursOuverture,
} from "./parcours-ouverture.ts";
import {
  GRADE_ORDER,
  chapitresGenerables,
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
  /**
   * Chapters usable despite the bar (R-5 lu au chapitre) — empty when the fiche
   * is generable whole, so a non-empty list always means "restricted lot".
   */
  chapitresGenerables: string[];
}

/**
 * What the method prescribes for ONE couple, if a human chooses to work it.
 *
 * This is a RULE APPLICATION, not a choice: the method already states, per
 * fiche status and content state, which lot and which step come next (LOT A
 * from A3 when the fiche has holes, LOT B from B1 when the fiche is usable and
 * the subject is absent, …). Deriving it is deterministic; deciding WHICH
 * couple to work is not, and stays with the human (see the module header).
 */
export interface EtapeMethode {
  /** `A` = la fiche, `B` = le contenu, `null` = rien à faire ou couple bloqué. */
  lot: "A" | "B" | null;
  /** Ancre dans la méthode : `A1`, `A3`, `A5.4`, `B1`, `B2`… */
  etape: string | null;
  /** Ce que la méthode prescrit, en une phrase. */
  action: string;
  /** Le fait mesuré qui déclenche la règle. */
  motif: string;
  /** Le couple ne doit pas être lancé tel quel (réservé, ou barre R-5 non franchie). */
  bloquant: boolean;
}

export interface EtatCouple {
  grade: string;
  /** Fiche basename; null for a manifest subject no fiche declares. */
  matiere: string | null;
  fiche: EtatFiche | null;
  sujets: EtatSujet[];
  /** Ce que la méthode prescrit POUR CE COUPLE — jamais un rang, jamais un choix. */
  prochaineEtape: EtapeMethode;
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
  /**
   * Ouverture en prod des parcours du niveau, rejouée depuis les migrations
   * (`parcours-ouverture.ts`). `null` = migrations non fournies à `buildEtat`,
   * donc question non posée — jamais « pas ouvert ».
   */
  ouverture: ParcoursOuverture[] | null;
  /** Faits vérifiés au niveau du GRADE (l'ouverture n'est pas par matière). */
  constats: string[];
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
    /** Parcours à ouvrir : contenu complet derrière un parcours non `available`. */
    parcoursANouvrir: number;
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
  /**
   * Ouverture des parcours rejouée depuis `supabase/migrations`. Optionnel : le
   * rapport reste valable sans (le volet ouverture est alors `null`, pas faux).
   */
  ouvertures?: OuvertureLue;
}

/**
 * R-8 (étude 16) : le premier lot de chapitres complet ouvre la classe. Le fait
 * mesurable ici est donc « au moins un chapitre complet existe » — un chapitre
 * présent mais incomplet ne déclenche pas le seuil.
 */
function chapitresComplets(couples: EtatCouple[]): number {
  let total = 0;
  for (const couple of couples) {
    for (const sujet of couple.sujets) {
      if (!sujet.present) continue;
      total += Math.max(0, sujet.chapitresPresents - sujet.chapitresIncomplets.length);
    }
  }
  return total;
}

/**
 * Le seul constat que rien d'autre ne porte : du contenu publiable derrière un
 * parcours qui n'est pas `available`. Ni les gates de contenu ni la Content CI
 * ne le voient — c'est un fait sur les migrations du moteur, pas sur le corpus.
 */
function constatsOuverture(parcours: ParcoursOuverture[], complets: number): string[] {
  if (complets === 0) return [];
  const out: string[] = [];
  for (const p of parcours) {
    if (p.statut === "available") continue;
    const etat =
      p.statut === "coming_soon"
        ? `resté \`coming_soon\` (${p.migration})`
        : `de statut illisible dans les migrations (${p.migration})`;
    out.push(
      `R-8 : ${complets} chapitre(s) complet(s) mais parcours \`${p.id}\` ${etat} — ` +
        "la classe est invisible aux élèves jusqu'à la migration d'ouverture (PR du dépôt moteur)",
    );
  }
  return out;
}

/**
 * The method's own decision table, applied to one couple. First match wins.
 * Ordered by what BLOCKS first: a reserved couple, then the R-5 bar, then the
 * missing link (without it nothing can be said about the content), then the
 * content itself. No priority is expressed — this answers "if you pick this
 * couple, what does the method say to do?", never "pick this couple".
 */
function prochaineEtapeOf(
  fiche: EtatFiche | null,
  sujets: EtatSujet[],
  lienDeclare: boolean,
): EtapeMethode {
  if (!fiche) {
    const present = sujets.some((s) => s.present);
    return {
      lot: "A",
      etape: present ? "A5.4" : "A1",
      action: present
        ? "rattacher ce sujet à la fiche qui porte son scope (`sujets`), ou transcrire la source"
        : "transcrire la source du couple — aucune fiche ne porte ce sujet du programme",
      motif: present
        ? "sujet présent dans content/ mais aucune fiche ne le déclare : scope non tracé"
        : "sujet attendu par le manifeste, ni fiche ni contenu",
      bloquant: false,
    };
  }

  if (fiche.statut === "en-cours") {
    return {
      lot: null,
      etape: null,
      action: "ne pas lancer — le couple est réservé par une session en cours",
      motif: 'statut "en-cours" au registre',
      bloquant: true,
    };
  }

  if (!fiche.generationAutorisee) {
    const couverture =
      fiche.couverturePct === null ? "couverture inconnue" : `${fiche.couverturePct} %`;
    const etat = `${fiche.statut}/${fiche.profondeur}, ${couverture}${
      fiche.trous.length > 0 ? `, ${fiche.trous.length} source(s) à trous` : ""
    }`;

    // R-5 lu au chapitre (décision 2026-07-29) : la barre porte sur ce qu'une
    // génération CONSOMME — la section de son chapitre — pas sur la fiche
    // entière. Une fiche trouée dont certaines sections sont transcrites en
    // profondeur les rend générables ; le reste attend toujours le LOT A.
    // Non bloquant, donc : il y a un lot livrable ici, restreint et nommé.
    const restreint = fiche.chapitresGenerables;
    if (restreint.length > 0) {
      const aFaire = sujets.flatMap((s) => [...s.chapitresManquants, ...s.chapitresIncomplets]);
      const cibles = aFaire.length > 0 ? restreint.filter((c) => aFaire.includes(c)) : restreint;
      if (cibles.length > 0) {
        return {
          lot: "B",
          etape: "B2",
          action:
            `générer uniquement les chapitres dont la fiche est en profondeur ` +
            `(${cibles.length}) : ${cibles.slice(0, 3).join(", ")}${cibles.length > 3 ? ", …" : ""}`,
          motif:
            `${etat} — la fiche entière reste sous la barre, mais ces chapitres y sont ` +
            `déclarés en profondeur (chapitresGeneration)`,
          bloquant: false,
        };
      }
    }

    return {
      lot: "A",
      etape: "A3",
      action: "compléter la fiche (lecture des plages manquantes puis profondeur R-5)",
      motif: `${etat} — la génération reste interdite${
        restreint.length > 0 ? " (les chapitres déjà en profondeur sont tous couverts)" : ""
      }`,
      bloquant: true,
    };
  }

  if (!lienDeclare) {
    return {
      lot: "A",
      etape: "A5.4",
      action: "déclarer `sujets` dans le registre avant de statuer sur le contenu",
      motif: "fiche exploitable mais lien fiche → contenu non déclaré",
      bloquant: false,
    };
  }

  const absents = sujets.filter((s) => !s.present);
  if (sujets.length > 0 && absents.length === sujets.length) {
    return {
      lot: "B",
      etape: "B1",
      action: `générer le contenu depuis la fiche (profil sans-source) : ${absents
        .map((s) => s.id)
        .join(", ")}`,
      motif: "fiche exploitable, aucun sujet correspondant sous content/",
      bloquant: false,
    };
  }

  const manquants = sujets.flatMap((s) => s.chapitresManquants);
  if (manquants.length > 0) {
    const apercu = manquants.slice(0, 3).join(", ");
    return {
      lot: "B",
      etape: "B2",
      action: `générer les chapitres manquants par tranches (${manquants.length}) : ${apercu}${
        manquants.length > 3 ? ", …" : ""
      }`,
      motif: "sujet présent, chapitrage du manifeste incomplet",
      bloquant: false,
    };
  }

  const incomplets = sujets.flatMap((s) => s.chapitresIncomplets);
  if (incomplets.length > 0) {
    return {
      lot: "B",
      etape: "B2",
      action: `compléter les chapitres incomplets (${incomplets.length}) : ${incomplets
        .slice(0, 3)
        .join(", ")}${incomplets.length > 3 ? ", …" : ""}`,
      motif: "chapitres présents mais sans cours, résumé, quiz ou mission",
      bloquant: false,
    };
  }

  return {
    lot: null,
    etape: null,
    action: "rien à faire sur ce couple",
    motif: "fiche exploitable et contenu complet vis-à-vis du manifeste",
    bloquant: false,
  };
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
    chapitresGenerables: chapitresGenerables(entry),
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
  const { corpus, affectations, suivis, audits, onlyGrade, ouvertures } = input;
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

      const etatFiche = toEtatFiche(entry);
      couples.push({
        grade,
        matiere: entry.matiere,
        fiche: etatFiche,
        sujets,
        prochaineEtape: prochaineEtapeOf(etatFiche, sujets, lienDeclare),
        lienDeclare,
        constats,
      });
    }

    for (const subject of audit?.subjects ?? []) {
      if (declared.has(subject.id)) continue;
      const sujets = [toEtatSujet(subject)];
      couples.push({
        grade,
        matiere: null,
        fiche: null,
        sujets,
        prochaineEtape: prochaineEtapeOf(null, sujets, true),
        lienDeclare: true,
        constats: [],
      });
    }

    const ouverture = ouvertures ? parcoursDuGrade(ouvertures, grade) : null;
    return {
      grade,
      manifeste: audit !== undefined,
      scelle: audit?.sealed ?? null,
      couples,
      ouverture,
      constats: ouverture ? constatsOuverture(ouverture, chapitresComplets(couples)) : [],
    };
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
      parcoursANouvrir: grades.reduce((n, g) => n + g.constats.length, 0),
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

/** `null` when the method prescribes nothing — silence is the readable form. */
function renderEtape(etape: EtapeMethode): string | null {
  if (etape.bloquant) return `⛔ ${etape.action} — ${etape.motif}`;
  if (!etape.lot) return null;
  return `→ [LOT ${etape.lot} ${etape.etape}] ${etape.action}`;
}

/** Human-readable report. Deterministic: no date, no ordering by priority. */
export function renderEtat(etat: EtatDesLieux): string {
  const lines: string[] = [];
  lines.push("État des lieux — registre de transcription × programme codifié × contenu.");
  lines.push(
    "Aucune priorité n'est calculée ici : le choix de ce qu'on lance reste humain (méthode, Phase 0.4).",
  );
  lines.push(
    "Le « → [LOT …] » d'un couple dit ce que la méthode prescrit SI on le choisit — pas de le choisir.",
  );

  for (const grade of etat.grades) {
    const manifeste = grade.manifeste
      ? `manifeste ${grade.scelle ? "scellé" : "non scellé"}`
      : "AUCUN manifeste";
    lines.push("");
    lines.push(`━━ ${grade.grade} — ${manifeste} ━━`);
    if (grade.couples.length === 0) lines.push("  (aucune fiche, aucun sujet attendu)");

    // Le « lien non déclaré », de loin l'état le plus fréquent aujourd'hui, se
    // regroupe en fin de niveau : répété ligne à ligne, il noierait les faits
    // propres à chaque fiche. Les sujets sans fiche passent après les fiches.
    const sansLien: string[] = [];

    for (const couple of grade.couples) {
      if (!couple.fiche) continue;
      const f = couple.fiche;
      const bits = [`${f.statut} / ${f.profondeur}`];
      bits.push(f.couverturePct === null ? "couverture ?" : `couverture ${f.couverturePct} %`);
      if (f.trous.length > 0) bits.push(`trous ${f.trous.join(" · ")}`);
      if (f.r7) bits.push(`R-7 ${f.r7}`);
      bits.push(
        f.generationAutorisee
          ? "génération autorisée"
          : f.chapitresGenerables.length > 0
            ? `génération restreinte à ${f.chapitresGenerables.length} ch. (R-5 au chapitre)`
            : "⛔ génération interdite",
      );
      lines.push(`  fiche ${couple.matiere} — ${bits.join(" · ")}`);
      for (const sujet of couple.sujets) lines.push(`      └ ${renderSujet(sujet)}`);
      for (const constat of couple.constats) lines.push(`      ! ${constat}`);
      const etape = renderEtape(couple.prochaineEtape);
      if (etape) lines.push(`      ${etape}`);
      if (!couple.lienDeclare && couple.matiere) sansLien.push(couple.matiere);
    }

    for (const couple of grade.couples) {
      if (couple.fiche) continue;
      for (const sujet of couple.sujets) {
        const etape = renderEtape(couple.prochaineEtape);
        lines.push(
          `  sujet sans fiche déclarée — ${renderSujet(sujet)}${etape ? `  ${etape}` : ""}`,
        );
      }
    }
    if (sansLien.length > 0) {
      lines.push(`  ! lien fiche → sujets non déclaré (\`sujets: []\`) : ${sansLien.join(", ")}`);
    }
    if (grade.ouverture && grade.ouverture.length > 0) {
      const parts = grade.ouverture.map((p) => `${p.id} : ${p.statut ?? "statut inconnu"}`);
      lines.push(`  prod — ${parts.join(" · ")}`);
    }
    for (const constat of grade.constats) lines.push(`  ! ${constat}`);
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
      `${t.oeuvresARattacher} œuvre(s) à rattacher · ` +
      `${t.parcoursANouvrir} parcours à ouvrir.`,
  );
  return `${lines.join("\n")}\n`;
}
