/**
 * Garde anti-verbatim — étude 27 (sources web tierces), lot 2 : R-8 / D-7.
 *
 * La doctrine de l'étude 27 autorise à **calibrer** la génération sur une source
 * tierce (tier T2′ : la carte notionnelle et typologique se reprend) et interdit
 * d'en **reprendre l'expression** (un énoncé, une explication, un corrigé). Cette
 * frontière-là ne tient pas par bonne volonté : elle tient parce qu'un gate la
 * vérifie. Ce module est ce gate.
 *
 * Principe : pour chaque fiche de source externe dont les droits n'autorisent PAS
 * la reprise, on indexe les séquences de N mots de sa transcription, puis on
 * cherche ces séquences dans le contenu généré. Une seule suffit à faire échouer
 * `content:qa --strict`.
 *
 * Deux choix qui décident de la précision :
 *
 *   • **La notation sort du calcul.** Figures SVG, maths en bloc ou en ligne,
 *     commandes LaTeX, code : retirés. Les nombres disparaissent avec eux (seules
 *     les suites de LETTRES font des jetons), donc « la masse de 12 g » et « la
 *     masse de 45 g » se comparent sur « la masse de g ». Sans cela, toute
 *     équation serait un faux positif — et avec, c'est le **squelette de prose**
 *     qu'on compare, ce qui est exactement l'objet du droit d'auteur.
 *   • **Les accents et le tashkîl sont pliés.** Une copie ne cesse pas d'en être
 *     une parce qu'elle a perdu ses diacritiques, et l'arabe du corpus s'écrit
 *     tantôt vocalisé tantôt non.
 *
 * Le seuil N reste ouvert (étude 27, Q-4) : il se tranche sur les faux positifs
 * mesurés du corpus réel, pas à l'avance. `DEFAULT_NGRAM` est le point de départ.
 */

import type { Flag } from "./qa-checks.ts";

/** Longueur par défaut des séquences comparées, en mots (étude 27 Q-4 : à calibrer). */
export const DEFAULT_NGRAM = 8;

/** Clés de l'en-tête de provenance d'une fiche `source-web` (étude 27, annexe B). */
export const PROVENANCE_KEYS = [
  "url",
  "titulaire",
  "consulte_le",
  "cgu",
  "robots",
  "autorisation",
  "tier",
  "snapshot",
] as const;

export type ProvenanceKey = (typeof PROVENANCE_KEYS)[number];
export type Provenance = Partial<Record<ProvenanceKey, string>>;

const PROVENANCE_LINE = new RegExp(
  `^\\s*(${PROVENANCE_KEYS.join("|")})\\s*:\\s*(\\S.*?)\\s*$`,
  "i",
);

/** NFD → retrait des marques combinantes (accents latins, tashkîl arabe) → NFC. */
export function foldMarks(s: string): string {
  return s
    .normalize("NFD")
    .replace(/\p{M}+/gu, "")
    .normalize("NFC");
}

/**
 * Lit l'en-tête de provenance d'une fiche. Tolérant par construction : les paires
 * `clé: valeur` sont reconnues où qu'elles soient (bloc YAML clôturé ou non), la
 * première occurrence gagne. Une fiche mal formée ne doit pas faire *taire* la
 * garde — elle doit tomber du côté surveillé (voir `isSurveilled`).
 */
export function parseProvenance(md: string): Provenance {
  const out: Provenance = {};
  for (const line of md.split(/\r?\n/)) {
    const m = PROVENANCE_LINE.exec(line);
    if (!m) continue;
    const key = m[1].toLowerCase() as ProvenanceKey;
    if (out[key] === undefined) out[key] = m[2];
  }
  return out;
}

/**
 * Cette source est-elle sous surveillance verbatim ?
 *
 * **Défaut sûr : oui.** Seule une autorisation explicitement `accordée` lève la
 * surveillance. Une fiche sans en-tête, avec une autorisation `aucune`,
 * `demandée le …`, ou rédigée d'une façon qu'on ne sait pas lire, reste
 * surveillée — se tromper dans ce sens coûte une reformulation, se tromper dans
 * l'autre coûte une contrefaçon.
 */
export function isSurveilled(p: Provenance): boolean {
  return !/^accord(e|ee)/.test(foldMarks((p.autorisation ?? "").trim().toLowerCase()));
}

/** Retire les lignes de l'en-tête de provenance : elles ne sont pas de la transcription. */
export function stripProvenanceHeader(md: string): string {
  return md
    .split(/\r?\n/)
    .filter((line) => !PROVENANCE_LINE.test(line))
    .join("\n");
}

/**
 * Découpe un texte en jetons comparables : des suites de LETTRES, minuscules,
 * sans diacritiques, la notation retirée en amont.
 *
 * Les jetons d'une seule lettre sont écartés — ce sont des variables (`x`, `y`)
 * ou les débris d'un nombre collé à son unité (`12g` → `g`), jamais de la prose.
 */
export function tokenise(text: string): string[] {
  const prose = text
    .replace(/<svg[\s\S]*?<\/svg>/gi, " ") // figures (étude 18/19)
    .replace(/```[\s\S]*?```/g, " ") // blocs de code
    .replace(/<[^>]*>/g, " ") // toute autre balise
    .replace(/\$\$[\s\S]*?\$\$/g, " ") // maths en bloc (le seul LaTeX légal)
    .replace(/\$[^$\n]*\$/g, " ") // maths en ligne (illégales, mais on ne parie pas)
    .replace(/\\[a-zA-Z]+(\s*\{[^}]*\})*/g, " ") // commandes LaTeX résiduelles
    .replace(/`[^`\n]*`/g, " ") // code en ligne
    .replace(/\]\([^)]*\)/g, "] "); // cible d'un lien markdown (le libellé reste)

  return foldMarks(prose)
    .toLowerCase()
    .split(/[^\p{L}]+/u)
    .filter((t) => t.length > 1);
}

/** Les séquences glissantes de `n` mots d'une suite de jetons. */
export function wordNgrams(tokens: string[], n: number = DEFAULT_NGRAM): string[] {
  if (n < 1 || tokens.length < n) return [];
  const grams: string[] = [];
  for (let i = 0; i + n <= tokens.length; i++) grams.push(tokens.slice(i, i + n).join(" "));
  return grams;
}

/** Une source dont la transcription est surveillée. */
export type SurveilledText = { slug: string; text: string };

/**
 * Index des séquences interdites. `grams` associe une séquence au slug de la
 * source d'où elle vient (première source gagnante — le message n'a besoin que
 * d'une piste, pas de l'exhaustivité).
 */
export type VerbatimIndex = { n: number; grams: Map<string, string> };

export function buildVerbatimIndex(
  sources: readonly SurveilledText[],
  n: number = DEFAULT_NGRAM,
): VerbatimIndex {
  const grams = new Map<string, string>();
  for (const { slug, text } of sources) {
    for (const gram of wordNgrams(tokenise(stripProvenanceHeader(text)), n)) {
      if (!grams.has(gram)) grams.set(gram, slug);
    }
  }
  return { n, grams };
}

/** Une plage de mots du contenu retrouvée telle quelle dans une source surveillée. */
export type VerbatimHit = { source: string; words: string[] };

/**
 * Les recouvrements d'un texte avec l'index, **fusionnés en plages maximales**.
 *
 * Une phrase de 20 mots recopiée produit 13 n-grammes qui se chevauchent : les
 * rapporter un par un dirait « 13 séquences » là où il y a UNE phrase. On étend
 * donc chaque amorce tant que la séquence suivante vient de la même source, et
 * on reprend après la plage.
 */
export function findVerbatimHits(text: string, index: VerbatimIndex): VerbatimHit[] {
  if (index.grams.size === 0) return [];
  const tokens = tokenise(text);
  const n = index.n;
  const hits: VerbatimHit[] = [];

  let i = 0;
  while (i + n <= tokens.length) {
    const source = index.grams.get(tokens.slice(i, i + n).join(" "));
    if (source === undefined) {
      i++;
      continue;
    }
    let end = i + n;
    while (
      end < tokens.length &&
      index.grams.get(tokens.slice(end - n + 1, end + 1).join(" ")) === source
    ) {
      end++;
    }
    hits.push({ source, words: tokens.slice(i, end) });
    i = end;
  }
  return hits;
}

/**
 * La surface textuelle d'une question — les trois champs qu'un auteur pourrait
 * transposer d'une source : l'énoncé, le **texte** des options, l'explication.
 *
 * Fonction à part et non une expression inline dans `qa.ts` : les options sont
 * des objets `{ id, text }`, et les épandre telles quelles produit
 * `[object Object]` — un câblage qui ne casse rien, ne lève aucun type, et
 * désarme silencieusement le contrôle sur un tiers de la surface.
 */
export function questionTextSurface(q: {
  prompt: string;
  options?: ReadonlyArray<{ text: string }>;
  explanation: string;
}): string {
  return [q.prompt, ...(q.options ?? []).map((o) => o.text), q.explanation].join("\n");
}

/**
 * Le contrôle lui-même : un `[error]` par champ recouvrant, citant jusqu'à
 * `max` plages pour que l'auteur voie quoi reformuler sans ouvrir la fiche.
 *
 * `error` et non `warn` : R-8 dit que la ligne T2′/T2 est un gate. Un
 * avertissement se traverse, et une contrefaçon ne se traverse pas.
 */
export function auditVerbatim(
  text: string,
  index: VerbatimIndex,
  where: string,
  { max = 3 }: { max?: number } = {},
): Flag[] {
  const hits = findVerbatimHits(text, index);
  if (hits.length === 0) return [];

  const shown = hits
    .slice(0, max)
    .map((h) => `« ${h.words.join(" ")} » (${h.source}, ${h.words.length} mots)`)
    .join(" · ");
  const rest = hits.length > max ? ` … et ${hits.length - max} autre(s)` : "";

  return [
    {
      level: "error",
      where,
      msg:
        `recouvrement verbatim avec une source non autorisée (étude 27 R-8) — ` +
        `${hits.length} plage(s) : ${shown}${rest}. ` +
        `Reformule : une notion se reprend, une expression non.`,
    },
  ];
}
