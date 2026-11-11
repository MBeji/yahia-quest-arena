// @vitest-environment node
/**
 * ÉTOILES & SCEAUX, côté client — étude 34, lot 2.
 *
 * Ce fichier ne teste aucune règle de progression : elles sont en base, et pgTAP 99 à 102
 * les tient. Il teste ce que ce module fait vraiment — **lire sans jamais décider** :
 *
 *   - un cran s'allume au GRAND LIVRE (`star`), jamais au vivant (`starLive`) : c'est
 *     l'invariant de l'étude, et c'est ici sa seule ligne de code côté client ;
 *   - une charge tordue (RPC en erreur, champ manquant, forme inattendue) ne casse pas
 *     le hub — elle retombe sur l'expérience anonyme, qui est complète ;
 *   - la jauge de l'anonyme a la MÊME forme que celle du serveur, crans présents
 *     seulement (D-3), sans qu'aucune donnée d'élève soit inventée.
 */
import { describe, it, expect } from "vitest";
import {
  emptyRungs,
  isCatalogueMission,
  missionTier,
  nextRung,
  nextSealOf,
  parseAttemptProgress,
  parseSubjectProgress,
  readSubjectStars,
  rungNovelties,
  rungTally,
  sealToCelebrate,
  starBuckets,
  type CatalogueExercise,
} from "../progress-stars";

const ex = (id: string, over: Partial<CatalogueExercise> = {}): CatalogueExercise => ({
  id,
  chapter_id: "c1",
  mode: "practice",
  difficulty: 1,
  ...over,
});

/** Une charge minimale mais complète, à la forme exacte de `get_subject_progress`. */
function payload(over: Record<string, unknown> = {}) {
  return {
    subjectId: "math",
    seals: [{ star: 1, reachedAt: "2026-09-01T10:00:00+00:00" }],
    nextSeal: { star: 2, chaptersReady: 12, chaptersTotal: 20, newChapters: 1 },
    effort: { missionsCounted: 26, xp: 1540, chaptersStarted: 12, chaptersMastered: 0 },
    chapters: [
      {
        chapterId: "c1",
        star: 2,
        starLive: 1,
        mastered: false,
        isNew: false,
        newMissions: 1,
        quiz: { gated: true, cleared: true },
        rungs: [
          { difficulty: 1, total: 1, counted: 1, new: 0 },
          { difficulty: 2, total: 2, counted: 1, new: 1 },
          { difficulty: 3, total: 1, counted: 0, new: 0 },
        ],
        family: { total: 2, counted: 1 },
      },
    ],
    missions: [
      {
        exerciseId: "m1",
        chapterId: "c1",
        source: "admin",
        counted: true,
        bestClassic: 100,
        mastered: true,
        isNew: false,
      },
      {
        exerciseId: "m2",
        chapterId: "c1",
        source: "admin",
        counted: false,
        bestClassic: 65,
        mastered: false,
        isNew: false,
      },
    ],
    ...over,
  };
}

describe("isCatalogueMission / missionTier — la seule règle de CONTENU restée côté client", () => {
  it("une mission `admin` hors quiz est du catalogue", () => {
    expect(isCatalogueMission(ex("m1"))).toBe(true);
    expect(isCatalogueMission(ex("m1", { source: undefined }))).toBe(true);
  });

  it("le quiz et les missions d'une AUTRE source n'en sont pas", () => {
    // R-2 : la règle est prospective — `student` / `ai` suivront `parent` sans y toucher.
    expect(isCatalogueMission(ex("q1", { mode: "quiz" }))).toBe(false);
    expect(isCatalogueMission(ex("p1", { source: "parent" }))).toBe(false);
    expect(isCatalogueMission(ex("i1", { source: "ai" }))).toBe(false);
  });

  it("borne la difficulté à [1, 4], exactement comme la base", () => {
    // `LEAST(GREATEST(e.difficulty, 1), 4)` : une difficulté hors échelle ne doit pas
    // créer un cran qu'aucune étoile ne pourrait franchir.
    expect(missionTier(ex("a", { difficulty: 0 }))).toBe(1);
    expect(missionTier(ex("b", { difficulty: null }))).toBe(1);
    expect(missionTier(ex("c", { difficulty: 3 }))).toBe(3);
    expect(missionTier(ex("d", { difficulty: 9 }))).toBe(4);
  });
});

describe("emptyRungs — la jauge de l'anonyme (R-16, D-3)", () => {
  it("n'a que les crans PRÉSENTS, jamais quatre par principe", () => {
    // US-5 : un chapitre ⭐·⭐⭐ a deux crans. Afficher un palier qu'aucun contenu ne
    // permet d'atteindre serait promettre un travail qui n'existe pas.
    const rungs = emptyRungs([
      ex("m1", { difficulty: 1 }),
      ex("m2", { difficulty: 2 }),
      ex("m3", { difficulty: 2 }),
    ]);
    expect(rungs.map((r) => r.tier)).toEqual([1, 2]);
    expect(rungs.map((r) => r.total)).toEqual([1, 2]);
  });

  it("garde les crans hauts d'un chapitre qui n'a ni ⭐ ni ⭐⭐", () => {
    // 57 chapitres du corpus sont dans ce cas — la vacuité n'est pas un cas d'école.
    expect(
      emptyRungs([ex("m1", { difficulty: 3 }), ex("m2", { difficulty: 4 })]).map((r) => r.tier),
    ).toEqual([3, 4]);
  });

  it("n'allume rien et ne compte rien — aucune donnée d'élève sans compte", () => {
    const rungs = emptyRungs([ex("m1"), ex("m2", { difficulty: 2 })]);
    expect(rungs.every((r) => !r.lit && r.counted === 0 && r.newMissions === 0)).toBe(true);
  });

  it("ignore le quiz et les missions familiales", () => {
    const rungs = emptyRungs([
      ex("q1", { mode: "quiz", difficulty: 1 }),
      ex("p1", { source: "parent", difficulty: 2 }),
      ex("m1", { difficulty: 3 }),
    ]);
    expect(rungs.map((r) => r.tier)).toEqual([3]);
  });

  it("rend une jauge VIDE pour un chapitre non publié", () => {
    // Pas de mission de catalogue, donc rien à jouer : pas de jauge (R-8).
    expect(emptyRungs([ex("q1", { mode: "quiz" })])).toEqual([]);
  });
});

describe("parseSubjectProgress — lire le grand livre", () => {
  it("allume les crans sur l'ACQUIS, pas sur le vivant — l'invariant de l'étude", () => {
    // Le décor : étoile 2 au grand livre, étoile 1 au vivant (une ⭐⭐ vient d'arriver).
    // Les deux premiers crans restent allumés. C'est toute la promesse R-6.
    const p = parseSubjectProgress(payload());
    const rungs = p!.chapters.c1!.rungs;
    expect(rungs.map((r) => r.lit)).toEqual([true, true, false]);
    expect(p!.chapters.c1!.star).toBe(2);
    expect(p!.chapters.c1!.starLive).toBe(1);
  });

  it("trie les crans par difficulté, quel que soit l'ordre reçu", () => {
    const p = parseSubjectProgress(
      payload({
        chapters: [
          {
            chapterId: "c1",
            star: 0,
            starLive: 0,
            mastered: false,
            isNew: false,
            newMissions: 0,
            quiz: { gated: false, cleared: true },
            rungs: [
              { difficulty: 3, total: 1, counted: 0, new: 0 },
              { difficulty: 1, total: 1, counted: 0, new: 0 },
            ],
            family: { total: 0, counted: 0 },
          },
        ],
      }),
    );
    expect(p!.chapters.c1!.rungs.map((r) => r.tier)).toEqual([1, 3]);
  });

  it("lit les sceaux, le prochain, et l'effort", () => {
    const p = parseSubjectProgress(payload())!;
    expect(p.sealStar).toBe(1);
    expect(p.seals[0]?.reachedAt).toBe("2026-09-01T10:00:00+00:00");
    expect(p.nextSeal).toEqual({ star: 2, chaptersReady: 12, chaptersTotal: 20, newChapters: 1 });
    expect(p.effort).toEqual({
      missionsCounted: 26,
      xp: 1540,
      chaptersStarted: 12,
      chaptersMastered: 0,
    });
  });

  it("garde `bestClassic` à part de `counted` — un score n'est pas un verdict", () => {
    // 65 % expédié : le score s'affiche, la mission ne compte pas. C'est la divergence
    // que le lot 2 supprime, et elle doit rester LISIBLE plutôt que masquée.
    const p = parseSubjectProgress(payload())!;
    expect(p.missions.m2).toMatchObject({ counted: false, bestClassic: 65 });
    expect(p.missions.m1).toMatchObject({ counted: true, bestClassic: 100 });
  });

  it("rend `null` sur une charge absente ou méconnaissable", () => {
    // Une RPC en erreur ne doit pas casser le hub : le contenu reste lisible, seule la
    // progression disparaît — exactement l'expérience anonyme.
    for (const bad of [null, undefined, 42, "nope", [], {}, { seals: [] }]) {
      expect(parseSubjectProgress(bad)).toBeNull();
    }
  });

  it("survit à un chapitre ou une mission sans identifiant", () => {
    const p = parseSubjectProgress(
      payload({ chapters: [{ star: 3 }, null, 7], missions: [{ counted: true }] }),
    )!;
    expect(p.chapters).toEqual({});
    expect(p.missions).toEqual({});
  });

  it("comble les champs manquants sans inventer de progression", () => {
    const p = parseSubjectProgress({ subjectId: "math" })!;
    expect(p.sealStar).toBe(0);
    expect(p.nextSeal).toBeNull();
    expect(p.effort).toEqual({
      missionsCounted: 0,
      xp: 0,
      chaptersStarted: 0,
      chaptersMastered: 0,
    });
  });
});

describe("dérivations d'affichage", () => {
  it("`nextRung` désigne le premier cran non acquis", () => {
    const p = parseSubjectProgress(payload())!;
    expect(nextRung(p.chapters.c1!.rungs)?.tier).toBe(3);
  });

  it("`nextRung` se tait sur un chapitre maîtrisé — un aboutissement n'est pas une dette", () => {
    expect(nextRung(emptyRungs([]))).toBeNull();
    const allLit = parseSubjectProgress(
      payload({
        chapters: [
          {
            chapterId: "c1",
            star: 4,
            starLive: 4,
            mastered: true,
            isNew: false,
            newMissions: 0,
            quiz: { gated: true, cleared: true },
            rungs: [{ difficulty: 1, total: 1, counted: 1, new: 0 }],
            family: { total: 0, counted: 0 },
          },
        ],
      }),
    )!;
    expect(nextRung(allLit.chapters.c1!.rungs)).toBeNull();
  });

  it("`rungTally` et `rungNovelties` totalisent tous les crans", () => {
    const p = parseSubjectProgress(payload())!;
    expect(rungTally(p.chapters.c1!.rungs)).toEqual({ counted: 2, total: 4 });
    expect(rungNovelties(p.chapters.c1!.rungs)).toBe(1);
  });
});

describe("l'agrégat par matière — sceaux, distribution, prochain palier (lot 3)", () => {
  /** Une ligne telle que `get_user_subject_stars` la rend : bornes CUMULÉES, snake_case. */
  const row = (over: Record<string, unknown> = {}) => ({
    subject_id: "math",
    chapters_total: 20,
    chapters_started: 18,
    chapters_star1: 14,
    chapters_star2: 9,
    chapters_star3: 3,
    chapters_star4: 1,
    seal_star: 1,
    seal_at: "2026-09-01T10:00:00+00:00",
    new_chapters: 2,
    new_missions: 5,
    ...over,
  });

  it("lit la forme du serveur ET celle du suivi parental — une seule lecture", () => {
    // Les deux surfaces décrivent la même chose ; en avoir deux interprétations
    // serait le début d'une divergence, et c'est exactement ce que l'étude corrige.
    const fromRpc = readSubjectStars(row());
    const fromParent = readSubjectStars({
      subjectId: "math",
      chaptersTotal: 20,
      chaptersStarted: 18,
      star1: 14,
      star2: 9,
      star3: 3,
      star4: 1,
      sealStar: 1,
      newChapters: 2,
      newMissions: 5,
    });
    expect(fromRpc!.cumulative).toEqual([14, 9, 3, 1]);
    expect(fromParent!.cumulative).toEqual(fromRpc!.cumulative);
    expect(fromParent!.sealStar).toBe(1);
  });

  it("⭐ dérive les cinq crans EXACTS des bornes cumulées", () => {
    // Sans cette différence, empiler les bornes compterait quatre fois le chapitre
    // maîtrisé et la barre du parent déborderait de son total.
    const buckets = starBuckets(readSubjectStars(row())!);
    expect(buckets).toEqual([6, 5, 6, 2, 1]);
    expect(buckets.reduce((a, b) => a + b, 0)).toBe(20);
  });

  it("ne rend jamais de cran négatif sur une donnée incohérente", () => {
    // Un total plus petit que ses bornes ne doit pas produire une barre à l'envers.
    const buckets = starBuckets(readSubjectStars(row({ chapters_total: 2 }))!);
    expect(buckets.every((n) => n >= 0)).toBe(true);
  });

  it("nomme le PROCHAIN sceau et ce qui l'en sépare", () => {
    // Sceau ⭐ acquis → le suivant est ⭐⭐, et 9 chapitres sur 20 le tiennent déjà.
    expect(nextSealOf(readSubjectStars(row())!)).toEqual({
      star: 2,
      chaptersReady: 9,
      chaptersTotal: 20,
      newChapters: 2,
    });
  });

  it("se tait au sceau ⭐⭐⭐⭐ — un aboutissement n'est pas une dette", () => {
    expect(nextSealOf(readSubjectStars(row({ seal_star: 4 }))!)).toBeNull();
  });

  it("vise la PREMIÈRE étoile quand aucun sceau n'est encore tombé", () => {
    const next = nextSealOf(readSubjectStars(row({ seal_star: null }))!);
    expect(next).toMatchObject({ star: 1, chaptersReady: 14 });
  });

  it("rend `null` sur une ligne sans identifiant de matière", () => {
    expect(readSubjectStars({ chapters_total: 20 })).toBeNull();
    expect(readSubjectStars(null)).toBeNull();
  });
});

describe("le delta d'une soumission — ce que l'écran a le droit de célébrer (lot 4)", () => {
  const delta = (over: Record<string, unknown> = {}) => ({
    chapterId: "c1",
    starBefore: 1,
    starAfter: 3,
    newStars: [2, 3],
    newSeals: [
      { subjectId: "math", star: 1 },
      { subjectId: "math", star: 3 },
    ],
    newBadges: [{ code: "first_seal", name: "Premier sceau", rarity: "rare", iconName: "Stamp" }],
    rungs: [
      { difficulty: 1, total: 1, counted: 1, new: 0 },
      { difficulty: 3, total: 2, counted: 2, new: 0 },
    ],
    ...over,
  });

  it("allume la jauge sur l'étoile APRÈS — c'est celle que le bloc montre", () => {
    const p = parseAttemptProgress(delta())!;
    expect(p.rungs.map((r) => r.lit)).toEqual([true, true]);
    expect(p.starBefore).toBe(1);
    expect(p.starAfter).toBe(3);
  });

  it("⭐ ne garde QU'UN sceau à fêter : le plus haut (R-12)", () => {
    // Une matière maîtrisée d'un coup inscrit ses quatre sceaux dans la même
    // transaction. Les fêter tous enchaînerait quatre modales — é31 R-6 l'interdit,
    // et ça transformerait un sommet en corvée.
    expect(sealToCelebrate(parseAttemptProgress(delta()))).toEqual({
      subjectId: "math",
      star: 3,
    });
  });

  it("ne fête aucun sceau quand aucun n'est tombé", () => {
    expect(sealToCelebrate(parseAttemptProgress(delta({ newSeals: [] })))).toBeNull();
    expect(sealToCelebrate(null)).toBeNull();
  });

  it("lit les badges de CETTE soumission, pas la collection", () => {
    const p = parseAttemptProgress(delta())!;
    expect(p.newBadges).toHaveLength(1);
    expect(p.newBadges[0]).toMatchObject({ code: "first_seal", iconName: "Stamp" });
  });

  it("rend `null` sur une charge méconnaissable — l'écran se tait alors", () => {
    for (const bad of [null, undefined, 42, {}, { starAfter: 3 }]) {
      expect(parseAttemptProgress(bad)).toBeNull();
    }
  });

  it("survit à un sceau ou un badge sans identifiant", () => {
    const p = parseAttemptProgress(
      delta({ newSeals: [{ star: 2 }, null], newBadges: [{ name: "sans code" }] }),
    )!;
    expect(p.newSeals).toEqual([]);
    expect(p.newBadges).toEqual([]);
  });
});
