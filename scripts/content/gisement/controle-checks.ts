/**
 * Le contrôle local contre les snapshots — étude 36 (le gisement), étage G6.
 *
 * La garde de la Content CI (`verbatim-checks.ts`) ne voit que les fiches versionnées ; les
 * transcriptions des devoirs lus, elles, restent HORS git (é27 R-10). Ce contrôle rejoue donc la
 * garde là où elles sont, sur la machine de la session, avec deux mesures :
 *
 *   1. **verbatim** — les séquences de 8 mots des transcriptions (et de 6, à titre indicatif)
 *      retrouvées dans nos textes, par les fonctions mêmes de la garde ;
 *   2. **données** — chaque transcription se découpe en exercices ; une question qui partage
 *      au moins trois nombres non triviaux avec un MÊME exercice source en reprend les données,
 *      même par coïncidence : la règle est mécanique.
 *
 * Ce module ne rend que des COMPTES rattachés à nos identifiants (`fichier#q3`, `lignes.tsv:12`),
 * jamais un fragment de la source : le rapport d'un contrôle anti-copie ne doit pas être le
 * véhicule de la copie.
 *
 * Rien ici ne lit le disque : le CLI (`controle.ts`) charge, ce module mesure.
 */
import {
  buildVerbatimIndex,
  findVerbatimHits,
  foldMarks,
  questionTextSurface,
  type VerbatimIndex,
} from "../verbatim-checks.ts";
import { LINE_COLUMNS } from "./lignes-checks.ts";
import { nonTrivialNumbers } from "./nombres.ts";

/** La garde de la CI : une plage de 8 mots est une copie. */
export const CONTROLE_NGRAM = 8;
/** Mesure indicative : une plage de 6 mots est « à regarder », jamais bloquante. */
export const CONTROLE_NGRAM_INDICATIF = 6;
/** À partir de trois nombres non triviaux communs avec un même exercice, la question se réécrit. */
export const SHARED_DATA_LIMIT = 3;

export interface Snapshot {
  slug: string;
  text: string;
}

export interface ControleIndex {
  v8: VerbatimIndex;
  v6: VerbatimIndex;
  /** Les exercices sources qui portent au moins un nombre non trivial. */
  exercises: Array<{ doc: string; numbers: ReadonlySet<string> }>;
}

/** Un texte à contrôler, sous NOTRE identifiant. */
export interface ControleTarget {
  where: string;
  text: string;
}

export interface ControleRow {
  where: string;
  /** Plages ≥ 8 mots communes avec une source. */
  v8: number;
  /** Longueur, en mots, de la plus longue d'entre elles. */
  longest: number;
  /** Plages ≥ 6 mots (indicatif). */
  v6: number;
  /** Le plus grand nombre de données non triviales partagées avec un même exercice source. */
  shared: number;
}

/**
 * Début d'exercice : en tête de ligne (après au plus vingt signes qui ne sont pas des lettres —
 * `## `, `**`, `3) `), `تمرين`, `التمرين`, `Exercice` ou `EXERCICE`, suivi d'autre chose qu'une
 * lettre (`Exercices` est un titre de section, pas un exercice). Le texte est plié de ses
 * diacritiques avant découpe (`التَّمرين`) — les chiffres n'en ont pas.
 */
const EXERCISE_START = /\n(?=[^\p{L}\n]{0,20}(?:التمرين|تمرين|Exercice|EXERCICE)(?!\p{L}))/u;

/** Les exercices d'une transcription ; à défaut de marqueur, le document entier. */
export function splitExercises(text: string): string[] {
  const parts = foldMarks(text).split(EXERCISE_START);
  return parts.length > 1 ? parts : [text];
}

export function buildControleIndex(snapshots: readonly Snapshot[]): ControleIndex {
  return {
    v8: buildVerbatimIndex(snapshots, CONTROLE_NGRAM),
    v6: buildVerbatimIndex(snapshots, CONTROLE_NGRAM_INDICATIF),
    exercises: snapshots
      .flatMap((s) =>
        splitExercises(s.text).map((ex) => ({ doc: s.slug, numbers: nonTrivialNumbers(ex) })),
      )
      .filter((ex) => ex.numbers.size > 0),
  };
}

export function controleText(target: ControleTarget, index: ControleIndex): ControleRow {
  const hits = findVerbatimHits(target.text, index.v8);
  const mine = nonTrivialNumbers(target.text);
  let shared = 0;
  for (const ex of index.exercises) {
    let n = 0;
    for (const x of mine) if (ex.numbers.has(x)) n++;
    shared = Math.max(shared, n);
  }
  return {
    where: target.where,
    v8: hits.length,
    longest: hits.reduce((max, h) => Math.max(max, h.words.length), 0),
    v6: findVerbatimHits(target.text, index.v6).length,
    shared,
  };
}

/** Bloquant : une plage ≥ 8 mots, ou ≥ 3 données communes avec un même exercice. */
export const isFlagged = (r: ControleRow): boolean => r.v8 > 0 || r.shared >= SHARED_DATA_LIMIT;

/** À regarder : une plage ≥ 6 mots ou deux données communes, sans rien de bloquant. */
export const isWatched = (r: ControleRow): boolean =>
  !isFlagged(r) && (r.v6 > 0 || r.shared === SHARED_DATA_LIMIT - 1);

const isRecord = (v: unknown): v is Record<string, unknown> =>
  typeof v === "object" && v !== null && !Array.isArray(v);
const asString = (v: unknown): string => (typeof v === "string" ? v : "");
const strings = (v: unknown): string[] =>
  Array.isArray(v) ? v.filter((s): s is string => typeof s === "string") : [];

/**
 * La surface d'une question : énoncé, TEXTE des options, explication (`questionTextSurface`,
 * celle de la garde), plus les réponses acceptées, la clé lisible (`answerKey.text` d'une
 * question libre, `answerKey.value` d'une numérique — une donnée) et les erreurs attendues.
 *
 * Lecture défensive : un brouillon d'auteur n'a pas à être valide pour être contrôlé, et une clé
 * objet épandue telle quelle donnerait `[object Object]` — le piège que `questionTextSurface`
 * documente.
 */
export function questionText(q: unknown): string {
  if (!isRecord(q)) return "";
  const options = Array.isArray(q.options)
    ? q.options.filter((o): o is { text: string } => isRecord(o) && typeof o.text === "string")
    : [];
  const key = isRecord(q.answerKey) ? q.answerKey : {};
  const mistakes = Array.isArray(q.expectedMistakes) ? q.expectedMistakes : [];
  return [
    questionTextSurface({
      prompt: asString(q.prompt),
      options,
      explanation: asString(q.explanation),
    }),
    ...strings(q.acceptedAnswers),
    asString(key.text),
    typeof key.value === "number" ? String(key.value) : "",
    ...mistakes.map((m) => (isRecord(m) ? asString(m.text) : "")),
  ].join("\n");
}

/** Une cible JSON (exercice, quiz) : une cible par question, ou `null` sans `questions[]`. */
export function questionTargets(data: unknown, where: string): ControleTarget[] | null {
  if (!isRecord(data) || !Array.isArray(data.questions)) return null;
  return data.questions.map((q, i) => ({ where: `${where}#q${i + 1}`, text: questionText(q) }));
}

const ARCHETYPE_COL = LINE_COLUMNS.indexOf("archetype");
const PIEGE_COL = LINE_COLUMNS.indexOf("piege");

/**
 * Des lignes du lecteur : une cible par ligne (`fichier:ligne`), réduite à sa PROSE — archétype
 * et piège. Le reste est codes, slugs et identifiants ; le barème, lui, est une métadonnée de
 * la source que la ligne porte par construction : pris dans le texte entier du fichier, les
 * barèmes décimaux de soixante lignes partageraient trois valeurs avec n'importe quel exercice
 * qui en compte. Une ligne qui n'a pas ses dix colonnes est contrôlée entière.
 */
export function lineTargets(text: string, where: string): ControleTarget[] {
  const out: ControleTarget[] = [];
  text
    .replace(/^\uFEFF/, "")
    .split("\n")
    .forEach((rawLine, i) => {
      const raw = rawLine.replace(/\r$/, "");
      if (raw.trim() === "") return;
      const cols = raw.split("\t");
      out.push({
        where: `${where}:${i + 1}`,
        text:
          cols.length === LINE_COLUMNS.length ? `${cols[ARCHETYPE_COL]}\n${cols[PIEGE_COL]}` : raw,
      });
    });
  return out;
}
