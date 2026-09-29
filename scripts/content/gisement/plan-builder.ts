/**
 * Le plan d'écriture — étude 36 (le gisement), étage G4 : des lignes du lecteur aux missions.
 *
 * Quatre décisions, chacune fermée par l'étude (D-5) et appliquée ici mécaniquement :
 *
 *   1. **Placement** — un exercice va dans le chapitre le PLUS AVANCÉ, dans l'ordre du manifeste
 *      de la classe, parmi ceux qu'il mobilise : tout ce qu'il teste est enseigné avant ou dans ce
 *      chapitre. Un exercice dont tous les chapitres sont `HP:` (hors programme en vigueur) n'est
 *      pas placé : il est compté à part, avec son `doc#exo`.
 *   2. **Dédoublonnage** — un devoir ou une série donne une mission par SIGNATURE distincte
 *      (chapitre de placement + compétences triées + archétype normalisé) : un archétype vu dans
 *      six devoirs est une mission, pas six. Elle garde ses sources, l'étage le plus haut et le
 *      plus grand nombre d'étapes. Un sujet d'examen (`concours`) ne se dédoublonne jamais : une
 *      mission par exercice, puisqu'il se reprend fidèlement.
 *   3. **Lots d'auteur** — par chapitre, `lotMax` missions au plus (un chapitre plus gros se coupe
 *      en lots équilibrés) ; les petits chapitres (≤ 3 missions) se regroupent jusqu'à `lotMax`.
 *   4. **Numéros de fichiers** — chaque lot reçoit, par chapitre, une plage `NN` disjointe des
 *      autres lots, à la suite du plus grand `NN` existant du chapitre.
 *
 * Le plan est une fonction de l'ENSEMBLE des lignes : ni l'ordre des fichiers ni celui des lignes
 * ne le changent, et une même entrée rend le même JSON, octet pour octet.
 *
 * Rien ici ne lit le disque : le CLI (`plan.ts`) charge, ce module décide.
 */
import { foldMarks } from "../verbatim-checks.ts";
import { type Creneau, type Etage, type GisementLine, ETAGES, sourceRef } from "./lignes-checks.ts";

export type MissionKind = "devoir" | "examen" | "serie";

export const DEFAULT_LOT_MAX = 8;
/** Un chapitre d'au plus autant de missions peut partager son lot avec d'autres. */
export const SMALL_CHAPTER_MAX = 3;

export interface Mission {
  id: string;
  kind: MissionKind;
  /** `doc#exo`, en ordre naturel (`D06#2` < `D06#10` < `D100#1`). */
  sources: string[];
  chapter: string;
  etage: Etage;
  etapes: number;
  /** Ids du registre, triés. */
  competences: string[];
  archetype: string;
  /** Les pièges distincts des sources, joints par « ; » ; `-` si aucun. */
  piege: string;
  lot: string;
  nn: number;
  /** Notions `HP:` d'une ligne qui mêle slugs et hors-programme (absent sinon). */
  horsProgramme?: string[];
  /** Compétences `hors-registre:` (absent sinon) — hors de la signature, gardées pour l'auteur. */
  horsRegistre?: string[];
}

export interface Lot {
  id: string;
  chapters: string[];
  missions: string[];
  /** Par chapitre du lot, la plage `[de, à]` de ses numéros de fichiers. */
  nnRanges: Record<string, [number, number]>;
}

/** Un exercice non placé : tous ses chapitres sont hors du programme en vigueur. */
export interface HorsProgrammeEntry {
  source: string;
  notions: string[];
}

export interface GisementPlan {
  subject: string;
  grade: string;
  missions: Mission[];
  lots: Lot[];
  horsProgramme: HorsProgrammeEntry[];
}

export interface PlanInput {
  subject: string;
  grade: string;
  /** Les slugs du sujet au manifeste, dans l'ordre d'enseignement. */
  chapters: readonly string[];
  /** Par chapitre, le plus grand `NN` existant (absent ou 0 : aucun fichier). */
  existingNn: ReadonlyMap<string, number>;
  lotMax?: number;
  /** Ne retenir que ces créneaux (absent : tous). */
  creneaux?: readonly Creneau[];
}

export function missionKind(creneau: Creneau): MissionKind {
  if (creneau === "concours") return "examen";
  if (creneau === "serie") return "serie";
  return "devoir";
}

/** Minuscules, accents et ponctuation retirés, espaces réduits — « Calculer l'aire. » = « calculer l aire ». */
export function normalizeArchetype(text: string): string {
  return foldMarks(text)
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s]+/gu, " ")
    .replace(/\s+/g, " ")
    .trim();
}

const SOURCE_RE = /^([A-Z])(\d+)#(\d+)([a-z]?)$/;

/** Comparaison par unités de code : indépendante de la locale de la machine. */
const cmp = (a: string, b: string): number => (a < b ? -1 : a > b ? 1 : 0);

/** Ordre naturel des `doc#exo` : lettre, numéro du document, numéro de l'exercice, suffixe. */
export function compareSources(a: string, b: string): number {
  const ma = SOURCE_RE.exec(a);
  const mb = SOURCE_RE.exec(b);
  if (!ma || !mb) return cmp(a, b);
  return (
    cmp(ma[1], mb[1]) ||
    Number(ma[2]) - Number(mb[2]) ||
    Number(ma[3]) - Number(mb[3]) ||
    cmp(ma[4], mb[4]) ||
    cmp(a, b)
  );
}

/** Le chapitre le plus avancé de la ligne dans l'ordre du manifeste, ou `null` (tout `HP:`). */
export function placementChapter(
  line: Pick<GisementLine, "chapitres">,
  order: readonly string[],
): string | null {
  let best: string | null = null;
  for (const slug of line.chapitres) {
    if (best === null || order.indexOf(slug) > order.indexOf(best)) best = slug;
  }
  return best;
}

/** Chapitre de placement + compétences triées + archétype normalisé. */
export function missionSignature(
  chapter: string,
  line: Pick<GisementLine, "competences" | "archetype">,
): string {
  return [chapter, [...line.competences].sort().join("+"), normalizeArchetype(line.archetype)].join(
    "|",
  );
}

/** Le plus grand `NN` des fichiers `NN-*.json` d'un dossier `exercices/` (0 s'il n'y en a pas). */
export function maxExistingNn(fileNames: readonly string[]): number {
  let max = 0;
  for (const name of fileNames) {
    const m = /^(\d+)-.*\.json$/.exec(name);
    if (m) max = Math.max(max, Number(m[1]));
  }
  return max;
}

/** `parts` morceaux consécutifs dont les tailles diffèrent d'au plus un (9 en 2 → 5 + 4). */
export function splitBalanced<T>(items: readonly T[], parts: number): T[][] {
  const out: T[][] = [];
  const base = Math.floor(items.length / parts);
  const extra = items.length % parts;
  let at = 0;
  for (let i = 0; i < parts; i++) {
    const size = base + (i < extra ? 1 : 0);
    out.push(items.slice(at, at + size));
    at += size;
  }
  return out;
}

const uniqueSorted = (values: Iterable<string>): string[] => [...new Set(values)].sort();
const etageRank = (e: Etage): number => ETAGES.indexOf(e);
const pad = (n: number, width: number): string => String(n).padStart(width, "0");

type Draft = Omit<Mission, "id" | "lot" | "nn">;

/** Une mission à partir de ses lignes (une seule pour un examen). */
function draftMission(chapter: string, group: GisementLine[]): Draft {
  const sorted = [...group].sort((a, b) => compareSources(sourceRef(a), sourceRef(b)));
  const first = sorted[0];
  const kinds = new Set(sorted.map((l) => missionKind(l.creneau)));
  const pieges = new Map<string, string>();
  for (const l of sorted) {
    const key = normalizeArchetype(l.piege);
    if (l.piege !== "-" && !pieges.has(key)) pieges.set(key, l.piege);
  }
  const horsProgramme = uniqueSorted(sorted.flatMap((l) => l.horsProgramme));
  const horsRegistre = uniqueSorted(sorted.flatMap((l) => l.horsRegistre));
  return {
    kind: kinds.has("examen") ? "examen" : kinds.has("devoir") ? "devoir" : "serie",
    sources: sorted.map(sourceRef),
    chapter,
    etage: sorted.reduce<Etage>(
      (hi, l) => (etageRank(l.etage) > etageRank(hi) ? l.etage : hi),
      first.etage,
    ),
    etapes: Math.max(...sorted.map((l) => l.etapes)),
    competences: [...first.competences].sort(),
    archetype: first.archetype,
    piege: pieges.size > 0 ? [...pieges.values()].join(" ; ") : "-",
    ...(horsProgramme.length > 0 ? { horsProgramme } : {}),
    ...(horsRegistre.length > 0 ? { horsRegistre } : {}),
  };
}

/**
 * Dans un chapitre : les étages dans l'ordre (la numérotation suit la progression), puis les
 * archétypes les plus fréquents d'abord, puis la première source.
 */
function compareInChapter(a: Draft, b: Draft): number {
  return (
    etageRank(a.etage) - etageRank(b.etage) ||
    b.sources.length - a.sources.length ||
    compareSources(a.sources[0], b.sources[0])
  );
}

/** Les lots d'auteur, dans l'ordre du manifeste de leur premier chapitre. */
function formLots(
  byChapter: ReadonlyMap<string, Draft[]>,
  order: readonly string[],
  lotMax: number,
): Array<{ chapters: string[]; missions: Draft[] }> {
  const lots: Array<{ chapters: string[]; missions: Draft[] }> = [];
  let open: { chapters: string[]; missions: Draft[] } | null = null;
  for (const chapter of order) {
    const missions = byChapter.get(chapter) ?? [];
    if (missions.length === 0) continue;
    if (missions.length > lotMax) {
      for (const part of splitBalanced(missions, Math.ceil(missions.length / lotMax))) {
        lots.push({ chapters: [chapter], missions: part });
      }
    } else if (missions.length <= SMALL_CHAPTER_MAX) {
      if (open !== null && open.missions.length + missions.length <= lotMax) {
        open.chapters.push(chapter);
        open.missions.push(...missions);
      } else {
        open = { chapters: [chapter], missions: [...missions] };
        lots.push(open);
      }
    } else {
      lots.push({ chapters: [chapter], missions });
    }
  }
  return lots;
}

export function buildPlan(lines: readonly GisementLine[], input: PlanInput): GisementPlan {
  const lotMax = input.lotMax ?? DEFAULT_LOT_MAX;
  if (!Number.isInteger(lotMax) || lotMax < 1) {
    throw new Error(`lotMax doit être un entier ≥ 1 (reçu ${lotMax})`);
  }
  const allowed = input.creneaux;
  const kept = allowed ? lines.filter((l) => allowed.includes(l.creneau)) : [...lines];

  // 1–2. Placement, puis regroupement par signature (un examen reste seul).
  const groups = new Map<string, { chapter: string; lines: GisementLine[] }>();
  const horsProgramme: HorsProgrammeEntry[] = [];
  for (const line of kept) {
    // Une ligne se juge contre le manifeste AVANT le plan (`validateLines`) ; un slug inconnu
    // ici disparaîtrait des lots sans bruit — mieux vaut refuser.
    const unknown = line.chapitres.filter((c) => !input.chapters.includes(c));
    if (unknown.length > 0) {
      throw new Error(
        `${sourceRef(line)} : chapitre(s) absent(s) du manifeste : ${unknown.join(", ")}`,
      );
    }
    const chapter = placementChapter(line, input.chapters);
    if (chapter === null) {
      horsProgramme.push({ source: sourceRef(line), notions: uniqueSorted(line.horsProgramme) });
      continue;
    }
    const key =
      missionKind(line.creneau) === "examen"
        ? `examen|${sourceRef(line)}`
        : missionSignature(chapter, line);
    const group = groups.get(key) ?? { chapter, lines: [] };
    group.lines.push(line);
    groups.set(key, group);
  }

  const byChapter = new Map<string, Draft[]>();
  for (const { chapter, lines: group } of groups.values()) {
    byChapter.set(chapter, [...(byChapter.get(chapter) ?? []), draftMission(chapter, group)]);
  }
  for (const drafts of byChapter.values()) drafts.sort(compareInChapter);

  // 3–4. Lots, puis numéros de fichiers à la suite de l'existant, chapitre par chapitre.
  const drafts = formLots(byChapter, input.chapters, lotMax);
  const next = new Map(input.chapters.map((c) => [c, (input.existingNn.get(c) ?? 0) + 1]));
  const lotWidth = Math.max(2, String(drafts.length).length);
  const missionCount = drafts.reduce((n, l) => n + l.missions.length, 0);
  const missionWidth = Math.max(3, String(missionCount).length);

  const missions: Mission[] = [];
  const lots: Lot[] = drafts.map((draft, i) => {
    const lot: Lot = {
      id: `L${pad(i + 1, lotWidth)}`,
      chapters: draft.chapters,
      missions: [],
      nnRanges: {},
    };
    for (const chapter of draft.chapters) {
      const from = next.get(chapter) ?? 1;
      let nn = from;
      for (const d of draft.missions.filter((m) => m.chapter === chapter)) {
        const { horsProgramme: hp, horsRegistre: hr, ...core } = d;
        const mission: Mission = {
          id: `m${pad(missions.length + 1, missionWidth)}`,
          ...core,
          lot: lot.id,
          nn: nn++,
          ...(hp ? { horsProgramme: hp } : {}),
          ...(hr ? { horsRegistre: hr } : {}),
        };
        missions.push(mission);
        lot.missions.push(mission.id);
      }
      lot.nnRanges[chapter] = [from, nn - 1];
      next.set(chapter, nn);
    }
    return lot;
  });

  horsProgramme.sort((a, b) => compareSources(a.source, b.source));
  return { subject: input.subject, grade: input.grade, missions, lots, horsProgramme };
}

/** Le plan tel qu'il s'écrit : JSON indenté, saut de ligne final. */
export const renderPlan = (plan: GisementPlan): string => `${JSON.stringify(plan, null, 2)}\n`;
