/**
 * Les mesures de tranche — méthode de génération, § B2 « le doublon de gabarit ».
 *
 * La méthode prescrit trois mesures « muettes » à faire AVANT chaque commit de
 * tranche, et disait qu'« un script jetable de ~40 lignes suffit ; aucun gate ne
 * les porte encore ». Un script jetable se réécrit à chaque session, différemment
 * à chaque fois, et finit par ne plus s'écrire du tout. Ce module est ce script,
 * écrit une fois et testé :
 *
 *   1. **clé strictement la plus longue** — la fuite par la forme (mesurée à
 *      57–76 % sur des lots antérieurs ; le hasard est à 1/n) ;
 *   2. **distribution des positions de clé** — l'écriture au gabarit (clé rédigée
 *      d'abord, distracteurs en remplissage) ;
 *   3. **paires proches** (Jaccard ≥ 0,45 sur énoncé + options) — les doublons
 *      LITTÉRAUX.
 *
 * Et une quatrième, que la méthode déclarait hors d'atteinte d'une mesure
 * lexicale : le **gabarit**, c'est-à-dire la même FORME de tâche avec un décor
 * changé. On ne compare donc pas les mots de l'énoncé, mais son **cadre** : la
 * consigne (première phrase) et la question (dernière phrase), une fois retirés
 * les passages cités, les nombres, les noms propres et la notation — ce qui
 * reste de « Read this passage. Sami has run a shop in Sfax for ten years… What
 * does "it" refer to? » est « read this passage what does refer to », identique
 * d'un décor à l'autre. Ce signal ne tranche rien : il nomme les groupes que
 * l'auditeur doit lire en priorité (méthode B3, mandat point 2). Il n'est jamais
 * bloquant.
 *
 * Rien ici ne lit le disque : le CLI (`tranche.ts`) charge, ce module mesure.
 */

import type { ContentQuestion, LoadedSubject } from "../../src/shared/content/schema.ts";
import { foldMarks, tokenise } from "./verbatim-checks.ts";

/** Seuil de la méthode (§ B2) pour une paire « proche ». */
export const NEAR_PAIR_JACCARD = 0.45;
/** En deçà de ce nombre de jetons, un item est « court »… */
export const SHORT_ITEM_TOKENS = 10;
/** …et n'est proche d'un autre que presque identique. */
export const SHORT_ITEM_JACCARD = 0.8;
/** Seuil de similarité de cadre (bigrammes) pour un candidat gabarit. */
export const FRAME_JACCARD = 0.6;
/** Un cadre plus court ne dit rien de la tâche (« Complete: … » est une consigne, pas un gabarit). */
export const MIN_FRAME_TOKENS = 6;
/** Bande tolérée pour la part d'une position de clé (4 options : 25 % ± 10). */
export const KEY_SHARE_BAND = { min: 0.15, max: 0.35 } as const;
/** En deçà, une distribution de positions n'est pas interprétable. */
export const MIN_ITEMS_FOR_DISTRIBUTION = 8;

export interface TrancheItem {
  /** `<chapitre>/quiz#3` ou `<chapitre>/exercices/<slug>#5` (1-based). */
  ref: string;
  chapter: string;
  inTranche: boolean;
  type: string;
  prompt: string;
  options: { id: string; text: string }[];
  /** Index de la clé dans `options` (mcq seulement). */
  keyIndex: number | null;
}

/** Texte visible d'un fragment : figures, balises et notation retirées. */
export function visibleText(s: string): string {
  return s
    .replace(/<svg[\s\S]*?<\/svg>/gi, " ")
    .replace(/<[^>]*>/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function questionItem(
  q: ContentQuestion,
  ref: string,
  chapter: string,
  inTranche: boolean,
): TrancheItem {
  const options = "options" in q && Array.isArray(q.options) ? q.options : [];
  const keyIndex = q.type === "mcq" ? options.findIndex((o) => o.id === q.correctOption) : -1;
  return {
    ref,
    chapter,
    inTranche,
    type: q.type,
    prompt: q.prompt,
    options: options.map((o) => ({ id: o.id, text: o.text })),
    keyIndex: keyIndex >= 0 ? keyIndex : null,
  };
}

/**
 * Aplatit une matière en items. `tranche` = slugs des chapitres mesurés ; les
 * autres sont les chapitres PUBLIÉS, contre lesquels on croise (méthode B2 c).
 */
export function collectItems(subject: LoadedSubject, tranche: ReadonlySet<string>): TrancheItem[] {
  const items: TrancheItem[] = [];
  for (const ch of subject.chapters) {
    const inTranche = tranche.has(ch.slug);
    ch.quiz.questions.forEach((q, i) =>
      items.push(questionItem(q, `${ch.slug}/quiz#${i + 1}`, ch.slug, inTranche)),
    );
    for (const ex of ch.exercises) {
      ex.data.questions.forEach((q, i) =>
        items.push(questionItem(q, `${ch.slug}/exercices/${ex.slug}#${i + 1}`, ch.slug, inTranche)),
      );
    }
  }
  return items;
}

// ── 1. La clé est-elle strictement l'option la plus longue ? ────────────────

export interface LongestKeyReport {
  measured: number;
  longest: string[];
  rate: number;
  /** Taux attendu par hasard : moyenne de 1/n sur les items mesurés. */
  chance: number;
  ok: boolean;
}

export function longestKey(items: TrancheItem[]): LongestKeyReport {
  const mcq = items.filter((it) => it.keyIndex !== null && it.options.length >= 2);
  const longest: string[] = [];
  let chanceSum = 0;
  for (const it of mcq) {
    chanceSum += 1 / it.options.length;
    const lens = it.options.map((o) => visibleText(o.text).length);
    const key = lens[it.keyIndex as number];
    if (lens.every((l, i) => i === it.keyIndex || l < key)) longest.push(it.ref);
  }
  const rate = mcq.length ? longest.length / mcq.length : 0;
  const chance = mcq.length ? chanceSum / mcq.length : 0;
  return { measured: mcq.length, longest, rate, chance, ok: rate <= chance };
}

// ── 2. Distribution des positions de clé ────────────────────────────────────

export interface KeyDistributionReport {
  /** Items à 4 options — la seule population où « 25 % chacune » a un sens. */
  measured: number;
  counts: number[];
  ok: boolean;
}

export function keyDistribution(items: TrancheItem[]): KeyDistributionReport {
  const four = items.filter((it) => it.keyIndex !== null && it.options.length === 4);
  const counts = [0, 0, 0, 0];
  for (const it of four) counts[it.keyIndex as number]++;
  const n = four.length;
  const ok =
    n < MIN_ITEMS_FOR_DISTRIBUTION ||
    counts.every((c) => c / n >= KEY_SHARE_BAND.min && c / n <= KEY_SHARE_BAND.max);
  return { measured: n, counts, ok };
}

// ── 3. Paires proches (doublons littéraux) ──────────────────────────────────

export function jaccard<T>(a: ReadonlySet<T>, b: ReadonlySet<T>): number {
  if (a.size === 0 && b.size === 0) return 0;
  let inter = 0;
  for (const x of a) if (b.has(x)) inter++;
  return inter / (a.size + b.size - inter);
}

export interface NearPair {
  a: string;
  b: string;
  score: number;
  interChapter: boolean;
}

/**
 * Les jetons d'un item, notation comprise : `tokenise` (garde anti-verbatim) ne
 * garde que les lettres, ce qui rend « Calcule 3 × 4 » et « Calcule 7 × 9 »
 * identiques — or en maths, ce sont le nombre et le symbole qui font la
 * question. On coupe donc aux blancs et on ne rogne que la ponctuation de bord.
 */
function surfaceTokens(it: TrancheItem): Set<string> {
  const text = visibleText([it.prompt, ...it.options.map((o) => o.text)].join(" "));
  return new Set(
    foldMarks(text)
      .toLowerCase()
      .split(/\s+/)
      .map((t) => t.replace(/^[\p{P}]+|[\p{P}]+$/gu, ""))
      .filter(Boolean),
  );
}

/** Les figures d'un énoncé, telles quelles : deux figures différentes font deux questions. */
function figures(it: TrancheItem): string {
  return (it.prompt.match(/<svg[\s\S]*?<\/svg>/gi) ?? []).join("\n");
}

/**
 * Paires ≥ seuil dont au moins un membre est dans la tranche, triées par score.
 * Le seuil 0,45 de la méthode a été posé sur de la prose (anglais 1ère sec) ;
 * sur un item court — « ما ناتج 4/9 − 1/9 ؟ » — un mot commun et deux nombres
 * suffisent à le franchir. Un item court n'est donc « proche » que presque
 * identique, et deux énoncés aux figures différentes ne le sont jamais.
 */
export function nearPairs(items: TrancheItem[], threshold = NEAR_PAIR_JACCARD): NearPair[] {
  const toks = items.map(surfaceTokens);
  const figs = items.map(figures);
  const out: NearPair[] = [];
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      if (!items[i].inTranche && !items[j].inTranche) continue;
      if (figs[i] !== figs[j]) continue;
      const score = jaccard(toks[i], toks[j]);
      const short = Math.min(toks[i].size, toks[j].size) < SHORT_ITEM_TOKENS;
      if (score >= (short ? Math.max(threshold, SHORT_ITEM_JACCARD) : threshold)) {
        out.push({
          a: items[i].ref,
          b: items[j].ref,
          score,
          interChapter: items[i].chapter !== items[j].chapter,
        });
      }
    }
  }
  return out.sort((x, y) => y.score - x.score);
}

// ── 4. Candidats gabarit (même forme de tâche, décor changé) ────────────────

/**
 * Le cadre d'un énoncé : sa consigne et sa question, sans le décor. Passages
 * cités, nombres, noms propres (latins, hors début de phrase) et notation
 * sortent ; il reste la forme de la tâche.
 */
export function taskFrame(prompt: string): string[] {
  const text = prompt
    .replace(/<svg[\s\S]*?<\/svg>/gi, " ")
    .replace(/<[^>]*>/g, " ")
    .replace(/\$\$[\s\S]*?\$\$/g, " ")
    .replace(/"[^"\n]*"|“[^”\n]*”|«[^»\n]*»|„[^“”\n]*[“”]/g, " ");
  const sentences = text
    .split(/(?<=[.!?؟:;])\s+|\n+/)
    .map((s) => s.trim())
    .filter((s) => /\p{L}/u.test(s));
  const picked = sentences.length > 2 ? [sentences[0], sentences[sentences.length - 1]] : sentences;
  // Noms propres latins : une majuscule hors début de phrase. L'arabe n'a pas
  // de casse — son décor reste, ce qui rend le signal plus prudent, pas faux.
  const withoutNames = picked.map((s) =>
    s
      .split(/\s+/)
      .filter((w, i) => i === 0 || !/^\p{Lu}/u.test(w))
      .join(" "),
  );
  return tokenise(withoutNames.join(" "));
}

function bigrams(tokens: string[]): Set<string> {
  const out = new Set<string>();
  for (let i = 0; i + 1 < tokens.length; i++) out.add(`${tokens[i]} ${tokens[i + 1]}`);
  return out;
}

export interface TemplateCluster {
  /** Le cadre partagé, lisible (celui du premier membre). */
  frame: string;
  refs: string[];
  chapters: string[];
}

/**
 * Groupes d'items de même type dont les cadres se ressemblent (bigrammes,
 * Jaccard ≥ seuil), qui touchent la tranche ET s'étendent sur ≥ 2 chapitres —
 * le cas que l'auteur, enfermé dans son chapitre, ne peut pas voir. Triés du
 * plus gros au plus petit : un cadre servi quinze fois est une consigne à
 * varier, un cadre servi deux fois est une paire à trancher.
 */
export function templateClusters(
  items: TrancheItem[],
  threshold = FRAME_JACCARD,
): TemplateCluster[] {
  const frames = items.map((it) => taskFrame(it.prompt));
  const grams = frames.map(bigrams);
  const parent = items.map((_, i) => i);
  const find = (i: number): number => (parent[i] === i ? i : (parent[i] = find(parent[i])));
  for (let i = 0; i < items.length; i++) {
    if (frames[i].length < MIN_FRAME_TOKENS) continue;
    for (let j = i + 1; j < items.length; j++) {
      if (frames[j].length < MIN_FRAME_TOKENS || items[i].type !== items[j].type) continue;
      if (jaccard(grams[i], grams[j]) >= threshold) parent[find(j)] = find(i);
    }
  }
  const groups = new Map<number, number[]>();
  items.forEach((_, i) => {
    const r = find(i);
    groups.set(r, [...(groups.get(r) ?? []), i]);
  });
  const out: TemplateCluster[] = [];
  for (const members of groups.values()) {
    if (members.length < 2 || !members.some((i) => items[i].inTranche)) continue;
    const chapters = [...new Set(members.map((i) => items[i].chapter))];
    if (chapters.length < 2) continue;
    out.push({
      frame: frames[members[0]].join(" "),
      refs: members.map((i) => items[i].ref),
      chapters,
    });
  }
  return out.sort((a, b) => b.refs.length - a.refs.length);
}

// ── Le rapport de tranche ───────────────────────────────────────────────────

export interface TrancheReport {
  subject: string;
  tranche: string[];
  items: number;
  longestKey: LongestKeyReport;
  keyDistribution: KeyDistributionReport;
  nearPairs: NearPair[];
  templates: TemplateCluster[];
  /**
   * Vrai quand la clé ne fuit pas par sa longueur et qu'aucune paire n'est
   * proche. La distribution des positions n'y entre pas : toutes les surfaces
   * mélangent les options à l'affichage (`shuffleOptions`), donc une position
   * ne fuit rien — son déséquilibre est un SYMPTÔME d'écriture au gabarit, à
   * lire, pas à « corriger » en déplaçant des clés. Le gabarit non plus.
   */
  ok: boolean;
}

export function measureTranche(
  subject: LoadedSubject,
  tranche: ReadonlySet<string>,
): TrancheReport {
  const all = collectItems(subject, tranche);
  const mine = all.filter((it) => it.inTranche);
  const lk = longestKey(mine);
  const kd = keyDistribution(mine);
  const np = nearPairs(all);
  return {
    subject: subject.meta.id,
    tranche: subject.chapters.filter((c) => tranche.has(c.slug)).map((c) => c.slug),
    items: mine.length,
    longestKey: lk,
    keyDistribution: kd,
    nearPairs: np,
    templates: templateClusters(all),
    ok: lk.ok && np.length === 0,
  };
}
