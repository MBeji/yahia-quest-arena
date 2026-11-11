/**
 * Les lignes du lecteur — étude 36 (le gisement), étage G2 : le format fermé.
 *
 * Le lecteur est le seul à ouvrir un devoir ; l'auteur qui écrira la mission n'en verra qu'une
 * ligne. Ce qui franchit cette frontière est donc un vocabulaire FERMÉ — des codes, des slugs du
 * manifeste de la classe, des ids du registre des compétences — plus deux champs de prose courts
 * (archétype, piège) d'où tout nombre de la source est exclu. Le pilote de l'é27 vérifiait ce
 * format par un script de session réécrit à chaque fois ; ce module est ce format, écrit une fois.
 *
 * Une ligne = dix colonnes séparées par des tabulations, sans en-tête :
 *
 *   doc · créneau · exo · barème · chapitres · compétences · archétype · étapes · piège · étage
 *
 * Deux marqueurs échappent au vocabulaire fermé, et sont nommés comme tels :
 *   • `HP:<mot-clé>` dans `chapitres` — une notion hors du programme en vigueur de la classe ;
 *   • `hors-registre:<mot-clé>` dans `compétences` — une compétence que le registre ne nomme pas.
 *
 * Rien ici ne lit le disque : le CLI (`lignes.ts`) charge le manifeste et le registre, ce module
 * juge.
 */
import { hasSourceNumber } from "./nombres.ts";

export const LINE_COLUMNS = [
  "doc",
  "creneau",
  "exo",
  "bareme",
  "chapitres",
  "competences",
  "archetype",
  "etapes",
  "piege",
  "etage",
] as const;

/** DC = devoir de contrôle, DS = devoir de synthèse ; `concours` = tout examen national. */
export const CRENEAUX = [
  "DC1",
  "DC2",
  "DC3",
  "DC4",
  "DC5",
  "DC6",
  "DS1",
  "DS2",
  "DS3",
  "concours",
  "serie",
  "revision",
  "autre",
] as const;
export type Creneau = (typeof CRENEAUX)[number];

/** L'échelle d'étages du portail, de l'application directe à l'enchaînement long. */
export const ETAGES = ["d1", "d2", "d3", "d4"] as const;
export type Etage = (typeof ETAGES)[number];

export const ARCHETYPE_MAX_WORDS = 16;
export const HP_PREFIX = "HP:";
export const HORS_REGISTRE_PREFIX = "hors-registre:";

const DOC_RE = /^[A-Z]\d{2,3}$/;
const EXO_RE = /^\d+[a-z]?$/;
const BAREME_RE = /^\d+(?:[.,]\d+)?$/;
const ETAPES_RE = /^[1-9]\d*$/;
const KEBAB_RE = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

export const isCreneau = (s: string): s is Creneau => (CRENEAUX as readonly string[]).includes(s);
export const isEtage = (s: string): s is Etage => (ETAGES as readonly string[]).includes(s);

/** Une ligne validée. */
export interface GisementLine {
  /** Provenance, pour les messages. */
  file: string;
  line: number;
  doc: string;
  creneau: Creneau;
  exo: string;
  /** `null` quand le document n'indique pas de barème (`-`). */
  bareme: number | null;
  /** Slugs du manifeste, dans l'ordre de la colonne. */
  chapitres: string[];
  /** Mots-clés des jetons `HP:` — notions hors du programme en vigueur de la classe. */
  horsProgramme: string[];
  /** Ids du registre de la famille. */
  competences: string[];
  /** Mots-clés des jetons `hors-registre:` — compétences que le registre ne nomme pas. */
  horsRegistre: string[];
  archetype: string;
  etapes: number;
  piege: string;
  etage: Etage;
}

/** Une ligne fautive : tous ses motifs, pour qu'une relecture suffise à la corriger. */
export interface LineFault {
  file: string;
  line: number;
  motifs: string[];
}

/** Ce contre quoi une ligne se juge. */
export interface LineVocabulary {
  /** Les slugs du sujet au manifeste de la classe, dans l'ordre d'enseignement. */
  chapters: readonly string[];
  /** Les ids du registre de la famille du sujet ; `null` : la famille n'a pas de registre. */
  competencies: ReadonlySet<string> | null;
}

/** `D06#3` — l'identifiant d'un exercice source, tel que le plan le cite. */
export const sourceRef = (l: Pick<GisementLine, "doc" | "exo">): string => `${l.doc}#${l.exo}`;

/** Un registre de compétences, réduit à ce que la portée en lit. */
export interface RegistryLike {
  family: string;
  subjectPrefixes: readonly string[];
  competencies: ReadonlyArray<{ id: string }>;
}

/**
 * Les compétences admises pour un sujet : celles des familles dont un préfixe couvre son id
 * (`math` couvre `math` et `math-6eme`, pas `mathx`) — la règle de `content:qa`. `null` quand
 * aucune famille ne le couvre : la colonne vaut alors `-`.
 */
export function competencyScope(
  registries: readonly RegistryLike[],
  subject: string,
): { families: string[]; ids: Set<string> } | null {
  const covering = registries.filter((r) =>
    r.subjectPrefixes.some((p) => subject === p || subject.startsWith(`${p}-`)),
  );
  if (covering.length === 0) return null;
  return {
    families: covering.map((r) => r.family),
    ids: new Set(covering.flatMap((r) => r.competencies.map((c) => c.id))),
  };
}

/** Découpe une colonne `a+b+HP:c` en jetons ; un jeton vide ou répété est un motif. */
function tokens(column: string, label: string, motifs: string[]): string[] {
  const out: string[] = [];
  for (const raw of column.split("+")) {
    const t = raw.trim();
    if (t === "") motifs.push(`${label} : jeton vide`);
    else if (out.includes(t)) motifs.push(`${label} : « ${t} » répété`);
    else out.push(t);
  }
  return out;
}

/** Un jeton `<préfixe><mot-clé-kebab>` : le mot-clé, ou un motif. */
function keyword(token: string, prefix: string, label: string, motifs: string[]): string | null {
  const kw = token.slice(prefix.length);
  if (KEBAB_RE.test(kw)) return kw;
  motifs.push(`${label} : « ${token} » mal formé (${prefix}<mot-clé-kebab>)`);
  return null;
}

function parseChapitres(column: string, vocab: LineVocabulary, motifs: string[]) {
  const chapitres: string[] = [];
  const horsProgramme: string[] = [];
  for (const t of tokens(column, "chapitres", motifs)) {
    if (t.startsWith(HP_PREFIX)) {
      const kw = keyword(t, HP_PREFIX, "chapitres", motifs);
      if (kw !== null) horsProgramme.push(kw);
    } else if (vocab.chapters.includes(t)) {
      chapitres.push(t);
    } else {
      motifs.push(`chapitre « ${t} » absent du manifeste (ou HP:<mot-clé>)`);
    }
  }
  return { chapitres, horsProgramme };
}

function parseCompetences(column: string, vocab: LineVocabulary, motifs: string[]) {
  const competences: string[] = [];
  const horsRegistre: string[] = [];
  if (vocab.competencies === null) {
    if (column !== "-") {
      motifs.push("compétences : la famille n'a pas de registre, la colonne vaut -");
    }
    return { competences, horsRegistre };
  }
  if (column === "-") {
    motifs.push(
      "compétences : la famille a un registre — nommer ses compétences, ou hors-registre:<mot-clé>",
    );
    return { competences, horsRegistre };
  }
  for (const t of tokens(column, "compétences", motifs)) {
    if (t.startsWith(HORS_REGISTRE_PREFIX)) {
      const kw = keyword(t, HORS_REGISTRE_PREFIX, "compétences", motifs);
      if (kw !== null) horsRegistre.push(kw);
    } else if (vocab.competencies.has(t)) {
      competences.push(t);
    } else {
      motifs.push(`compétence « ${t} » absente du registre (ou hors-registre:<mot-clé>)`);
    }
  }
  return { competences, horsRegistre };
}

/** La prose d'une ligne (archétype, piège) : non vide, et sans nombre de la source. */
function checkProse(value: string, label: string, motifs: string[]): void {
  if (value === "") motifs.push(`${label} vide`);
  else if (hasSourceNumber(value)) {
    motifs.push(
      `${label} : un nombre de deux chiffres ou plus, ou un décimal — un nombre de la source n'a rien à faire dans une ligne`,
    );
  }
}

/** Juge une ligne. `raw` est la ligne sans son saut de ligne. */
export function parseLine(
  raw: string,
  where: { file: string; line: number },
  vocab: LineVocabulary,
): { line: GisementLine; fault?: undefined } | { line?: undefined; fault: LineFault } {
  const fault = (motifs: string[]) => ({ fault: { ...where, motifs } });
  const cols = raw.split("\t").map((c) => c.trim());
  if (cols.length !== LINE_COLUMNS.length) {
    return fault([`${cols.length} colonne(s) au lieu de ${LINE_COLUMNS.length}`]);
  }
  const [doc, creneau, exo, bareme, chapitresCol, competencesCol, archetype, etapes, piege, etage] =
    cols;
  const motifs: string[] = [];

  if (!DOC_RE.test(doc)) {
    motifs.push(`doc « ${doc} » : une majuscule et deux ou trois chiffres (D06)`);
  }
  if (!isCreneau(creneau)) {
    motifs.push(`créneau « ${creneau} » hors liste (${CRENEAUX.join(", ")})`);
  }
  if (!EXO_RE.test(exo)) motifs.push(`exo « ${exo} » : un numéro, une lettre en option (2a)`);
  if (bareme !== "-" && !BAREME_RE.test(bareme)) {
    motifs.push(`barème « ${bareme} » : un nombre (virgule ou point) ou -`);
  }
  const { chapitres, horsProgramme } = parseChapitres(chapitresCol, vocab, motifs);
  const { competences, horsRegistre } = parseCompetences(competencesCol, vocab, motifs);
  checkProse(archetype, "archétype", motifs);
  const words = archetype.split(/\s+/).filter(Boolean).length;
  if (words > ARCHETYPE_MAX_WORDS) {
    motifs.push(`archétype de ${words} mots (${ARCHETYPE_MAX_WORDS} au plus)`);
  }
  if (!ETAPES_RE.test(etapes)) motifs.push(`étapes « ${etapes} » : un entier ≥ 1`);
  checkProse(piege, "piège", motifs);
  if (!isEtage(etage)) motifs.push(`étage « ${etage} » hors échelle (${ETAGES.join(", ")})`);

  if (motifs.length > 0 || !isCreneau(creneau) || !isEtage(etage)) return fault(motifs);
  return {
    line: {
      ...where,
      doc,
      creneau,
      exo,
      bareme: bareme === "-" ? null : Number(bareme.replace(",", ".")),
      chapitres,
      horsProgramme,
      competences,
      horsRegistre,
      archetype,
      etapes: Number(etapes),
      piege,
      etage,
    },
  };
}

/**
 * Juge un ou plusieurs fichiers de lignes. Les lignes blanches sont ignorées ; un même
 * exercice (`doc#exo`) décrit deux fois est fautif à sa seconde occurrence. Une ligne fautive
 * n'entre pas dans `lines`, et ses motifs sont réunis dans UNE faute.
 */
export function validateLines(
  files: ReadonlyArray<{ file: string; text: string }>,
  vocab: LineVocabulary,
): { lines: GisementLine[]; faults: LineFault[]; count: number } {
  const lines: GisementLine[] = [];
  const faults: LineFault[] = [];
  const seen = new Map<string, string>();
  let count = 0;

  for (const { file, text } of files) {
    text
      .replace(/^\uFEFF/, "")
      .split("\n")
      .forEach((rawLine, i) => {
        const raw = rawLine.replace(/\r$/, "");
        if (raw.trim() === "") return;
        count++;
        const where = { file, line: i + 1 };
        const parsed = parseLine(raw, where, vocab);
        if (parsed.fault) {
          faults.push(parsed.fault);
          return;
        }
        const ref = sourceRef(parsed.line);
        const first = seen.get(ref);
        if (first !== undefined) {
          faults.push({ ...where, motifs: [`« ${ref} » déjà décrit en ${first}`] });
          return;
        }
        seen.set(ref, `${file}:${where.line}`);
        lines.push(parsed.line);
      });
  }
  return { lines, faults, count };
}

/** `fichier:ligne — motif ; motif` : la sortie d'une faute, une ligne par ligne fautive. */
export const renderFault = (f: LineFault): string =>
  `${f.file}:${f.line} — ${f.motifs.join(" ; ")}`;
