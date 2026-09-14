/**
 * ÉTOILES DE CHAPITRE & SCEAUX DE MATIÈRE — le côté client de l'étude 34.
 *
 * Ce module **ne décide rien**. La règle (mission comptée, étoile r, sceau r,
 * nouveauté ✨) vit en base, dans `mission_is_counted` / `chapter_star_rungs` /
 * `chapter_star_live` / `record_progress_stars`, et arrive ici toute faite par la
 * RPC `get_subject_progress`. Ce fichier ne fait que deux choses :
 *
 *   1. **lire** cette charge JSONB de façon défensive (elle traverse le réseau et
 *      la génération de types la rend en `Json`), et
 *   2. **dériver de l'affichage** : quel cran est le prochain, combien de missions
 *      sont comptées, à quoi ressemble une jauge quand on n'a pas de compte.
 *
 * ⚠️ C'est le remplaçant de `chapter-completion.ts`, supprimé au même lot. Ce
 * n'est pas un renommage : l'ancien fichier **recalculait** la complétion en TS à
 * partir des meilleurs scores, donc avec sa propre copie des seuils — et cette
 * copie avait déjà divergé. Elle ignorait l'anti-précipitation (une réussite
 * expédiée à 65 % cochait la mission au hub sans rien donner au grand livre),
 * et elle redescendait dès qu'une mission arrivait. Les deux défauts disparaissent
 * en cessant de recalculer : `counted`, `star`, `starLive` viennent du serveur.
 *
 * La seule règle qui reste écrite ici est **`isCatalogueMission`** (é22 R-15,
 * inchangée) : elle ne lit aucun score, c'est une propriété du CONTENU
 * (`source='admin'`, hors quiz), et le client en a besoin pour trier des
 * exercices qu'il a déjà en main sans repasser par le serveur.
 *
 * Doc normative : `docs/etoiles-et-sceaux.md`.
 */

/** Les quatre crans de l'échelle du contenu : socle · pratique · boss · élite. */
export type StarTier = 1 | 2 | 3 | 4;

/** Les quatre crans, dans l'ordre où une jauge les affiche. */
export const STAR_TIERS: readonly StarTier[] = [1, 2, 3, 4];

/** Le strict minimum dont la lecture d'un chapitre a besoin, côté contenu. */
export type CatalogueExercise = {
  id: string;
  chapter_id: string;
  mode: string;
  difficulty?: number | null;
  /** `admin` (catalogue) ou `parent` (mission familiale). Absent ⇒ `admin`. */
  source?: string | null;
};

/**
 * Une **mission de catalogue** : `source = 'admin'`, hors quiz de compréhension
 * (é22 R-15, é34 R-2). Les missions d'une autre source — `parent` aujourd'hui,
 * `student` / `ai` si une source naît un jour — sont du contenu hors programme :
 * elles comptent pour l'effort, jamais pour une étoile ni pour un sceau. C'est ce
 * qui garde les étoiles comparables entre élèves et empêche un tiers d'en donner.
 */
export function isCatalogueMission(exercise: CatalogueExercise): boolean {
  return (exercise.source ?? "admin") === "admin" && exercise.mode !== "quiz";
}

/**
 * Le cran d'une mission. Même bornage que la base
 * (`LEAST(GREATEST(e.difficulty, 1), 4)`) : une difficulté hors échelle — 0 par
 * défaut de colonne, 5 si le contenu en invente une — se range au cran le plus
 * proche plutôt que de créer un cran fantôme qu'aucune étoile ne pourrait franchir.
 */
export function missionTier(exercise: CatalogueExercise): StarTier {
  const raw = Math.round(exercise.difficulty ?? 1);
  return Math.min(4, Math.max(1, raw)) as StarTier;
}

/** Un cran de la jauge d'un chapitre (R-8). */
export type ChapterRung = {
  tier: StarTier;
  /** L'étoile de ce cran est **au grand livre** — elle ne s'éteint jamais. */
  lit: boolean;
  /** Missions comptées de ce cran (R-3). */
  counted: number;
  /** Missions de catalogue de ce cran, telles qu'elles existent aujourd'hui. */
  total: number;
  /** Parmi elles, celles arrivées après la dernière étoile et jamais tentées. */
  newMissions: number;
};

/** L'état d'un chapitre, tel que le serveur le tient. */
export type ChapterProgress = {
  chapterId: string;
  /** L'étoile ACQUISE, lue au grand livre (0 à 4). Monotone (R-6). */
  star: number;
  /** L'étoile que le contenu d'aujourd'hui donnerait. Peut être < `star`. */
  starLive: number;
  /** Le verdict, et le seul : étoile 4 (R-5, Q-2). */
  mastered: boolean;
  /** Le chapitre est arrivé après la dernière étoile de la matière (R-7). */
  isNew: boolean;
  newMissions: number;
  rungs: ChapterRung[];
  quiz: { gated: boolean; cleared: boolean };
  /** Les missions créées par un parent — leur propre ligne, jamais une étoile. */
  family: { total: number; counted: number };
};

/** L'état d'une mission, tel que le serveur le tient. */
export type MissionProgress = {
  exerciseId: string;
  chapterId: string;
  source: string;
  /** Comptée pour une étoile : ≥ 60 % en classique, sans se précipiter (R-3). */
  counted: boolean;
  /** Meilleur score `variant='classic'`, pour l'affichage — jamais un verdict. */
  bestClassic: number | null;
  /** 100 % en classique — ce qui ouvre le mode Rappel (étude 17). */
  mastered: boolean;
  isNew: boolean;
};

/** Un sceau inscrit, daté. */
export type SubjectSeal = { star: StarTier; reachedAt: string | null };

/** Le prochain sceau, et la seule fraction de l'étude (R-9). */
export type NextSeal = {
  star: StarTier;
  chaptersReady: number;
  chaptersTotal: number;
  newChapters: number;
};

/** Ce que l'élève A FAIT, jamais un pourcentage (R-10). */
export type SubjectEffort = {
  missionsCounted: number;
  xp: number;
  chaptersStarted: number;
  chaptersMastered: number;
};

/** La charge de `get_subject_progress`, lue. */
export type SubjectProgress = {
  subjectId: string;
  seals: SubjectSeal[];
  /** Le sceau le plus haut inscrit — 0 quand il n'y en a aucun. */
  sealStar: number;
  nextSeal: NextSeal | null;
  effort: SubjectEffort;
  chapters: Record<string, ChapterProgress>;
  missions: Record<string, MissionProgress>;
};

// --------------------------------------------------------------------------
// Lecture défensive de la charge JSONB
// --------------------------------------------------------------------------

function asRecord(value: unknown): Record<string, unknown> | null {
  return value && typeof value === "object" && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : null;
}

function asArray(value: unknown): unknown[] {
  return Array.isArray(value) ? value : [];
}

function asInt(value: unknown): number {
  const n = Number(value);
  return Number.isFinite(n) ? Math.round(n) : 0;
}

function asTier(value: unknown): StarTier {
  return Math.min(4, Math.max(1, asInt(value))) as StarTier;
}

function asNullableNumber(value: unknown): number | null {
  if (value == null) return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
}

function readRung(raw: unknown): ChapterRung | null {
  const r = asRecord(raw);
  if (!r) return null;
  return {
    tier: asTier(r.difficulty),
    // Rempli par `readChapter`, qui seul connaît l'étoile du chapitre.
    lit: false,
    counted: asInt(r.counted),
    total: asInt(r.total),
    newMissions: asInt(r.new),
  };
}

function readChapter(raw: unknown): ChapterProgress | null {
  const c = asRecord(raw);
  const chapterId = c?.chapterId;
  if (!c || typeof chapterId !== "string") return null;
  const star = asInt(c.star);
  const quiz = asRecord(c.quiz);
  const family = asRecord(c.family);
  const rungs = asArray(c.rungs)
    .map(readRung)
    .filter((r): r is ChapterRung => r !== null)
    // Un cran est ALLUMÉ à partir du grand livre, jamais du vivant : c'est toute
    // la promesse de l'étude, et c'est la seule ligne de ce fichier qui la porte.
    .map((r) => ({ ...r, lit: star >= r.tier }))
    .sort((a, b) => a.tier - b.tier);
  return {
    chapterId,
    star,
    starLive: asInt(c.starLive),
    mastered: c.mastered === true,
    isNew: c.isNew === true,
    newMissions: asInt(c.newMissions),
    rungs,
    quiz: { gated: quiz?.gated === true, cleared: quiz?.cleared === true },
    family: { total: asInt(family?.total), counted: asInt(family?.counted) },
  };
}

function readMission(raw: unknown): MissionProgress | null {
  const m = asRecord(raw);
  const exerciseId = m?.exerciseId;
  if (!m || typeof exerciseId !== "string") return null;
  return {
    exerciseId,
    chapterId: typeof m.chapterId === "string" ? m.chapterId : "",
    source: typeof m.source === "string" ? m.source : "admin",
    counted: m.counted === true,
    bestClassic: asNullableNumber(m.bestClassic),
    mastered: m.mastered === true,
    isNew: m.isNew === true,
  };
}

/**
 * Lit la charge de `get_subject_progress`. Rend `null` sur une charge absente ou
 * méconnaissable — l'appelant retombe alors sur l'expérience anonyme, qui est
 * complète (R-16). Une RPC qui échoue ne doit jamais casser le hub : le contenu
 * reste lisible, seule la progression disparaît.
 */
export function parseSubjectProgress(raw: unknown): SubjectProgress | null {
  const p = asRecord(raw);
  if (!p || typeof p.subjectId !== "string") return null;

  const seals: SubjectSeal[] = asArray(p.seals)
    .map((s) => {
      const r = asRecord(s);
      if (!r) return null;
      return {
        star: asTier(r.star),
        reachedAt: typeof r.reachedAt === "string" ? r.reachedAt : null,
      };
    })
    .filter((s): s is SubjectSeal => s !== null)
    .sort((a, b) => a.star - b.star);

  const nextSealRaw = asRecord(p.nextSeal);
  const effort = asRecord(p.effort);

  const chapters: Record<string, ChapterProgress> = {};
  for (const raw of asArray(p.chapters)) {
    const chapter = readChapter(raw);
    if (chapter) chapters[chapter.chapterId] = chapter;
  }

  const missions: Record<string, MissionProgress> = {};
  for (const raw of asArray(p.missions)) {
    const mission = readMission(raw);
    if (mission) missions[mission.exerciseId] = mission;
  }

  return {
    subjectId: p.subjectId,
    seals,
    sealStar: seals.reduce((max, s) => Math.max(max, s.star), 0),
    nextSeal: nextSealRaw
      ? {
          star: asTier(nextSealRaw.star),
          chaptersReady: asInt(nextSealRaw.chaptersReady),
          chaptersTotal: asInt(nextSealRaw.chaptersTotal),
          newChapters: asInt(nextSealRaw.newChapters),
        }
      : null,
    effort: {
      missionsCounted: asInt(effort?.missionsCounted),
      xp: asInt(effort?.xp),
      chaptersStarted: asInt(effort?.chaptersStarted),
      chaptersMastered: asInt(effort?.chaptersMastered),
    },
    chapters,
    missions,
  };
}

// --------------------------------------------------------------------------
// Dérivations d'affichage
// --------------------------------------------------------------------------

/**
 * La jauge d'un chapitre pour qui n'a pas de compte (R-16) : les crans PRÉSENTS
 * dans le contenu, tous éteints, sans aucun compteur. Aucune donnée d'élève n'est
 * calculée — il n'y en a pas — et l'anonyme voit malgré tout la forme du chapitre,
 * donc ce qu'un compte lui ferait gagner.
 *
 * Même définition que `chapter_star_rungs` côté base : un cran par difficulté
 * présente parmi les missions de catalogue, bornée à [1, 4]. Un chapitre sans
 * mission de catalogue n'a pas de jauge (tableau vide) — il n'est pas publié.
 */
export function emptyRungs(exercisesOfChapter: CatalogueExercise[]): ChapterRung[] {
  const tiers = new Map<StarTier, number>();
  for (const exercise of exercisesOfChapter) {
    if (!isCatalogueMission(exercise)) continue;
    const tier = missionTier(exercise);
    tiers.set(tier, (tiers.get(tier) ?? 0) + 1);
  }
  return [...tiers.entries()]
    .sort(([a], [b]) => a - b)
    .map(([tier, total]) => ({ tier, lit: false, counted: 0, total, newMissions: 0 }));
}

/**
 * Le prochain cran à gagner : le premier qui n'est pas encore au grand livre.
 * `null` quand le chapitre est maîtrisé — il n'y a alors plus de geste à nommer,
 * et en inventer un serait transformer un aboutissement en dette.
 */
export function nextRung(rungs: ChapterRung[]): ChapterRung | null {
  return rungs.find((r) => !r.lit) ?? null;
}

/** Missions comptées / missions de catalogue, tous crans confondus. */
export function rungTally(rungs: ChapterRung[]): { counted: number; total: number } {
  return rungs.reduce(
    (acc, r) => ({ counted: acc.counted + r.counted, total: acc.total + r.total }),
    { counted: 0, total: 0 },
  );
}

/** Nouveautés d'un chapitre : les missions ✨ de tous ses crans. */
export function rungNovelties(rungs: ChapterRung[]): number {
  return rungs.reduce((sum, r) => sum + r.newMissions, 0);
}

// --------------------------------------------------------------------------
// L'AGRÉGAT PAR MATIÈRE (étude 34, lot 3)
//
// `get_user_subject_stars` (carte, QG) et la clé `subjectStars` de l'enveloppe du
// suivi parental servent la MÊME forme : des bornes CUMULÉES (`star >= r`), telles
// que la base les compte. Les deux surfaces en tirent des choses différentes — un
// sceau ici, une barre empilée là — mais aucune ne redéfinit la règle.
// --------------------------------------------------------------------------

/** Ce qu'une matière vaut pour un élève, en un enregistrement. */
export type SubjectStarSummary = {
  subjectId: string;
  chaptersTotal: number;
  chaptersStarted: number;
  /**
   * Bornes CUMULÉES, index 0 → étoile 1 : `cumulative[r - 1]` = nombre de chapitres
   * publiés dont l'étoile est **≥ r**, au grand livre. Cumulé et non exact parce que
   * c'est la forme naturelle d'un seuil : « combien de chapitres ont au moins la
   * ⭐⭐⭐ » est la question que pose un sceau.
   */
  cumulative: [number, number, number, number];
  /** Le sceau le plus haut inscrit — 0 quand il n'y en a aucun. */
  sealStar: number;
  sealAt: string | null;
  newChapters: number;
  newMissions: number;
};

/**
 * Les cinq seaux EXACTS, de l'étoile 0 à l'étoile 4 — ce que dessine la barre
 * empilée du parent (R-13).
 *
 * Cumulé → exact par différences successives, et le cran 0 est le reste. C'est
 * l'opération qui rend la barre honnête : sans elle, empiler les bornes cumulées
 * compterait quatre fois le chapitre maîtrisé et la barre déborderait du total.
 */
export function starBuckets(summary: SubjectStarSummary): [number, number, number, number, number] {
  const [c1, c2, c3, c4] = summary.cumulative;
  return [
    Math.max(0, summary.chaptersTotal - c1),
    Math.max(0, c1 - c2),
    Math.max(0, c2 - c3),
    Math.max(0, c3 - c4),
    Math.max(0, c4),
  ];
}

/** Le prochain sceau à gagner, et ce qui l'en sépare. `null` au sceau ⭐⭐⭐⭐. */
export function nextSealOf(summary: SubjectStarSummary): NextSeal | null {
  if (summary.sealStar >= 4) return null;
  const star = Math.min(4, Math.max(1, summary.sealStar + 1)) as StarTier;
  return {
    star,
    chaptersReady: summary.cumulative[star - 1] ?? 0,
    chaptersTotal: summary.chaptersTotal,
    newChapters: summary.newChapters,
  };
}

/**
 * Lit une ligne de `get_user_subject_stars` (snake_case) ou une entrée de
 * `subjectStars` du suivi parental (camelCase) — les deux formes, une seule
 * lecture, parce qu'elles décrivent la même chose et qu'en avoir deux
 * interprétations serait le début d'une divergence.
 */
export function readSubjectStars(raw: unknown): SubjectStarSummary | null {
  const r = asRecord(raw);
  if (!r) return null;
  const subjectId = r.subject_id ?? r.subjectId;
  if (typeof subjectId !== "string") return null;
  const at = r.seal_at ?? r.sealAt;
  return {
    subjectId,
    chaptersTotal: asInt(r.chapters_total ?? r.chaptersTotal),
    chaptersStarted: asInt(r.chapters_started ?? r.chaptersStarted),
    cumulative: [
      asInt(r.chapters_star1 ?? r.star1),
      asInt(r.chapters_star2 ?? r.star2),
      asInt(r.chapters_star3 ?? r.star3),
      asInt(r.chapters_star4 ?? r.star4),
    ],
    sealStar: Math.min(4, Math.max(0, asInt(r.seal_star ?? r.sealStar))),
    sealAt: typeof at === "string" ? at : null,
    newChapters: asInt(r.new_chapters ?? r.newChapters),
    newMissions: asInt(r.new_missions ?? r.newMissions),
  };
}
