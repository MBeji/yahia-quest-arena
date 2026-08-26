// @vitest-environment node
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * ⚠️ Les fabriques de `vi.mock` passent par `vi.hoisted()`.
 *
 * Ce n'est pas un style : sous Windows, une fabrique qui lit un `const` déclaré
 * plus bas ne LÈVE pas — elle fige le worker soixante secondes avant de mourir
 * sans message utile. Le piège a été mesuré, il est écrit dans les briefs, et il
 * coûte une session à chaque fois qu'on l'oublie.
 */
const { USER, PARENT, mockRpc, mockCallAi, mockSupabase, tableReplies } = vi.hoisted(() => {
  type Reply = { data: unknown[] | null; error: { message: string } | null };
  type Builder = {
    select: () => Builder;
    eq: () => Builder;
    gt: () => Builder;
    order: () => Builder;
    limit: () => Promise<Reply>;
    then: (res: (v: Reply) => unknown, rej?: (e: unknown) => unknown) => Promise<unknown>;
  };

  const replies: Record<string, Reply> = {};
  const rpc = vi.fn();

  // Un constructeur de requête PostgREST réduit à ce que le batch en utilise :
  // il ignore les filtres et rend la réponse posée pour la table. Ce que les
  // filtres valent se vérifie sur les RPC, qui portent les décisions.
  const build = (table: string): Builder => {
    const result = () => Promise.resolve(replies[table] ?? { data: [], error: null });
    const builder: Builder = {
      select: () => builder,
      eq: () => builder,
      gt: () => builder,
      order: () => builder,
      limit: () => result(),
      then: (res, rej) => result().then(res, rej),
    };
    return builder;
  };

  return {
    USER: "11111111-1111-4111-8111-111111111111",
    PARENT: "99999999-9999-4999-8999-999999999999",
    mockRpc: rpc,
    mockCallAi: vi.fn(),
    tableReplies: replies,
    mockSupabase: { rpc, from: (table: string) => build(table) },
  };
});

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      inputValidator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: unknown) => {
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({ data, context: { supabase: mockSupabase, userId: USER } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
// Le client `service_role` du batch ET celui de la session partagent le même
// double : on aiguille par NOM de fonction et par table, comme le vrai code.
vi.mock("@/shared/integrations/supabase/client.server", () => ({ supabaseAdmin: mockSupabase }));
vi.mock("@/features/ai", () => ({ callAi: mockCallAi }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import {
  buildDigestBlocks,
  countSentences,
  digestSystem,
  digestWeekStart,
  readDigestInputs,
  validateDigestOutput,
} from "../digest";
import { generateWeeklyDigests, getWeeklyDigest, handleDigestCron } from "../digest.server";

/**
 * Étude 11 lot 6 — le bilan hebdomadaire.
 *
 * CE QUE CES TESTS GARDENT
 * ---------------------------------------------------------------------------
 * Deux choses, et la première n'est pas un bug d'affichage.
 *
 * 1. LA VIE PRIVÉE (R-14). `get_tutor_digest_inputs` est « la seule fonction du
 *    dépôt dont la sortie quitte l'infrastructure », et elle est écrite pour ne
 *    rendre aucun identifiant. Ces tests gardent le SECOND filet : le jour où
 *    quelqu'un ajoutera un prénom à ce `jsonb_build_object` « pour personnaliser
 *    un peu », la liste blanche zod doit le jeter avant qu'il n'atteigne un
 *    fournisseur. D'où le contrôle négatif — on INJECTE dans le payload d'entrée
 *    exactement ce que le SQL ne rend pas aujourd'hui, et on exige que rien n'en
 *    ressorte.
 *
 * 2. LES DEUX REGISTRES. Le bilan parent est le seul texte du produit lu par un
 *    adulte qui décide s'il reste installé. Un « il a gagné 340 XP » y détruit
 *    plus de crédibilité qu'une panne, et une mention d'abonnement viole D-14
 *    dans une phase où tout est gratuit. Le prompt système le demande ; ces
 *    tests vérifient que la SORTIE est contrôlée, parce qu'une consigne à un
 *    modèle est une demande, pas une garde.
 */

// Un prénom, un e-mail, deux identifiants : les chaînes qui ne doivent JAMAIS
// quitter le produit. Choisies improbables pour qu'une correspondance
// accidentelle soit impossible.
const NAME = "Yahia-Zied";
const EMAIL = "yahia.zied@example.test";
const CHAPTER_ID = "chap-9f1c-e4a7";
const MISCONCEPTION_TAG = "tag_perimeter_area_confusion";

const SECRETS = [NAME, EMAIL, CHAPTER_ID, MISCONCEPTION_TAG, USER];

/**
 * Le payload de `get_tutor_digest_inputs`, AUGMENTÉ des clés que la migration ne
 * rend pas. C'est délibéré : ce fichier teste la liste blanche, pas le SQL.
 */
function rawInputs(over: Record<string, unknown> = {}) {
  return {
    weekStart: "2026-08-17",
    weekEnd: "2026-08-23",
    ageBand: "12-14",
    lang: "fr",
    hasActivity: true,
    thisWeek: { missions: 12, minutes: 40, avgScore: 72, daysActive: 3 },
    lastWeek: { missions: 8, minutes: 25, avgScore: 68, daysActive: 2 },
    delta: { missions: 4, minutes: 15, avgScore: 4, daysActive: 1 },
    chapters: [
      {
        chapter: "Fractions",
        subject: "Mathématiques",
        attempts: 5,
        avgScore: 88,
        chapterId: CHAPTER_ID,
      },
      { chapter: "Périmètre et aire", subject: "Mathématiques", attempts: 4, avgScore: 52 },
    ],
    topErrors: [
      {
        tag: MISCONCEPTION_TAG,
        labelFr: "Confond périmètre et aire",
        labelEn: "Confuses perimeter and area",
        labelAr: "يخلط بين المحيط والمساحة",
        occurrences: 5,
      },
    ],
    // Ce que le SQL ne rend PAS aujourd'hui, et qui doit rester dehors demain.
    displayName: NAME,
    email: EMAIL,
    userId: USER,
    ...over,
  };
}

const factsFrom = (over: Record<string, unknown> = {}) => readDigestInputs(rawInputs(over)).facts;

// ---------------------------------------------------------------------------

describe("la projection des agrégats vers les faits (R-10)", () => {
  it("reprend les chiffres du SQL sans en recalculer un seul", () => {
    const facts = factsFrom();
    expect(facts.thisWeek).toEqual({ missions: 12, minutes: 40, avgScore: 72, daysActive: 3 });
    expect(facts.lastWeek).toEqual({ missions: 8, minutes: 25, avgScore: 68, daysActive: 2 });
    // 12 - 8 = 4, mais on ne le DÉDUIT pas : `delta` vient de la migration, qui
    // porte la garde d'incomparabilité. Le recalculer ici la contournerait.
    expect(facts.delta).toEqual({ missions: 4, minutes: 15, avgScore: 4, daysActive: 1 });
  });

  it("garde `delta.avgScore` à null, et ne le remplace jamais par zéro", () => {
    // `null` veut dire « pas comparable » — une semaine précédente vide. Le
    // combler à 0 produirait « +72 points de progression » sur une reprise après
    // vacances : un compliment mécanique et faux.
    const facts = factsFrom({
      delta: { missions: 12, minutes: 40, avgScore: null, daysActive: 3 },
    });
    expect(facts.delta.avgScore).toBeNull();
  });

  it("traduit les libellés d'erreur dans la langue du bilan", () => {
    expect(factsFrom().mistakes[0]?.label).toBe("Confond périmètre et aire");
    expect(factsFrom({ lang: "en" }).mistakes[0]?.label).toBe("Confuses perimeter and area");
    expect(factsFrom({ lang: "ar" }).mistakes[0]?.label).toBe("يخلط بين المحيط والمساحة");
  });

  it("ne re-coupe pas les listes que le SQL a déjà bornées", () => {
    // Cinq chapitres et trois erreurs sont cadrés dans la migration, avec son
    // raisonnement. Re-trancher ici ferait deux propriétaires du même cadrage.
    expect(factsFrom().chapters).toHaveLength(2);
  });

  it("survit à un payload amputé plutôt que de lever (R-15)", () => {
    // Une migration en cours de déploiement, un compte neuf : le bilan doit
    // pouvoir se calculer sur des zéros au lieu de faire tomber la tranche.
    const source = readDigestInputs({});
    expect(source.hasActivity).toBe(false);
    expect(source.facts.thisWeek).toEqual({ missions: 0, minutes: 0, avgScore: 0, daysActive: 0 });
    expect(source.facts.lang).toBe("fr");
    expect(source.facts.ageBand).toBe("12-14");
    expect(source.facts.mistakes).toEqual([]);
  });

  it("lit `hasActivity` du SQL et ne le redevine pas", () => {
    expect(readDigestInputs(rawInputs()).hasActivity).toBe(true);
    expect(readDigestInputs(rawInputs({ hasActivity: false })).hasActivity).toBe(false);
  });
});

describe("R-14 — le contrôle négatif : rien de nominatif ne sort", () => {
  it("écarte le prénom, l'e-mail et les identifiants des FAITS", () => {
    const serialized = JSON.stringify(factsFrom());
    for (const secret of SECRETS) {
      expect(serialized).not.toContain(secret);
    }
  });

  it("les écarte aussi des BLOCS envoyés au fournisseur", () => {
    // Le test qui compte : c'est cette chaîne-là qui part sur le réseau.
    const serialized = JSON.stringify(buildDigestBlocks(factsFrom()));
    for (const secret of SECRETS) {
      expect(serialized).not.toContain(secret);
    }
  });

  it("n'envoie AUCUNE date — la semaine est une clé de stockage, pas un fait", () => {
    // Une date est le premier élément ré-identifiant qu'on cesse de voir à force
    // de le lire. Une expression qui refuse TOUTE date attrape aussi celles
    // qu'on n'a pas prévues.
    expect(JSON.stringify(buildDigestBlocks(factsFrom()))).not.toMatch(/\d{4}-\d{2}-\d{2}/);
  });

  it("laisse passer les chiffres et les libellés, eux — sinon il n'y a rien à écrire", () => {
    const text = buildDigestBlocks(factsFrom())[0]?.text ?? "";
    expect(text).toContain("12 missions");
    expect(text).toContain("Fractions");
    expect(text).toContain("Périmètre et aire");
    expect(text).toContain("Confond périmètre et aire (5 fois)");
  });

  it("écrit les écarts SIGNÉS — « +3 » et « -3 » ne racontent pas la même semaine", () => {
    expect(buildDigestBlocks(factsFrom())[0]?.text).toContain("ecart_missions: +4");
    const worse = buildDigestBlocks(
      factsFrom({ delta: { missions: -4, minutes: -15, avgScore: -6, daysActive: -1 } }),
    )[0]?.text;
    expect(worse).toContain("ecart_missions: -4");
  });

  it("OMET l'écart de moyenne quand il n'est pas comparable", () => {
    // Absent plutôt que nul : une ligne « non comparable » inviterait le modèle
    // à commenter l'incomparabilité, ce qu'aucun parent n'a demandé.
    const text =
      buildDigestBlocks(
        factsFrom({ delta: { missions: 12, minutes: 40, avgScore: null, daysActive: 3 } }),
      )[0]?.text ?? "";
    expect(text).not.toContain("ecart_moyenne");
    expect(buildDigestBlocks(factsFrom())[0]?.text).toContain("ecart_moyenne_en_points: +4");
  });
});

// ---------------------------------------------------------------------------

describe("les deux registres (R-18 : les trois langues dans la même livraison)", () => {
  it("tutoie l'élève et vouvoie le parent, en français", () => {
    expect(digestSystem("student", "fr", "12-14")).toContain("Tu es « El Ostedh »");
    const parent = digestSystem("parent", "fr", "12-14");
    expect(parent).toContain("Vous vouvoyez le parent");
    expect(parent).not.toContain("El Ostedh");
  });

  it("interdit le vocabulaire de jeu au parent, et à lui seul", () => {
    // L'élève, lui, VIT dans ce vocabulaire : le lui interdire serait absurde.
    // Ce qu'on lui interdit, c'est de PROMETTRE une récompense (R-11).
    expect(digestSystem("parent", "fr", "12-14")).toContain("AUCUN vocabulaire de jeu");
    expect(digestSystem("student", "fr", "12-14")).toContain("Tu ne promets aucune récompense");
  });

  it("interdit l'abonnement et le payant dans les six prompts (D-14)", () => {
    for (const audience of ["student", "parent"] as const) {
      for (const lang of ["fr", "en", "ar"] as const) {
        const system = digestSystem(audience, lang, "12-14");
        const forbids =
          lang === "ar" ? system.includes("اشتراك") : /subscription|abonnement/i.test(system);
        expect(forbids, `${audience}/${lang} doit interdire l'offre payante`).toBe(true);
      }
    }
  });

  it("rappelle dans les six prompts que les chiffres fournis sont les seuls faits (R-10)", () => {
    for (const audience of ["student", "parent"] as const) {
      for (const lang of ["fr", "en", "ar"] as const) {
        const system = digestSystem(audience, lang, "12-14");
        const anchored =
          lang === "ar"
            ? system.includes("الوقائع الوحيدة")
            : /SEULS faits|ONLY facts/i.test(system);
        expect(anchored, `${audience}/${lang} doit ancrer les faits`).toBe(true);
      }
    }
  });

  it("est écrit NATIVEMENT en arabe — pas une traduction posée sur du latin", () => {
    for (const audience of ["student", "parent"] as const) {
      const system = digestSystem(audience, "ar", "9-11");
      const arabic = (system.match(/[؀-ۿ]/g) ?? []).length;
      const latin = (system.match(/[A-Za-zÀ-ÿ]/g) ?? []).length;
      // Le seul latin toléré est celui des acronymes techniques (LaTeX, HTML)
      // et de la bande d'âge — jamais une phrase.
      expect(arabic).toBeGreaterThan(latin * 5);
    }
  });

  it("annonce une borne de mots à chaque bande d'âge, et elle croît avec l'âge", () => {
    const bornes = (["6-8", "9-11", "12-14", "15-19"] as const).map((band) => {
      const match = digestSystem("student", "fr", band).match(/Maximum (\d+) mots/);
      return Number(match?.[1] ?? 0);
    });
    expect(bornes).toEqual([...bornes].sort((a, b) => a - b));
    expect(bornes[0]).toBeGreaterThan(0);
  });
});

// ---------------------------------------------------------------------------

const STUDENT_FR = [
  "Cette semaine tu as fait douze missions en quarante minutes, avec une moyenne de",
  "soixante-douze pour cent. Les fractions avancent bien, et ça se voit dans tes scores.",
  "En géométrie tu confonds encore le périmètre et l'aire. Reprends une mission courte",
  "demain, et on en reparle ensemble.",
].join(" ");

const PARENT_FR = [
  "Votre enfant a réalisé douze missions cette semaine, pour environ quarante minutes",
  "de travail. La moyenne s'établit à soixante-douze pour cent, en légère hausse par",
  "rapport à la semaine précédente. Les fractions semblent acquises, tandis que le",
  "périmètre et l'aire restent confondus. Proposez-lui de refaire un exercice de",
  "géométrie mardi soir, pendant dix minutes.",
].join(" ");

const PARENT_AR = [
  "أنجز ابنكم اثني عشر تمرينًا هذا الأسبوع في نحو أربعين دقيقة.",
  "بلغ معدّله اثنين وسبعين في المائة، وهو في تحسّن طفيف عن الأسبوع الفارط.",
  "الكسور صارت مكتسبة، أمّا المحيط والمساحة فما زال يخلط بينهما.",
  "اقترحوا عليه إعادة تمرين واحد في الهندسة مساء الثلاثاء لمدّة عشر دقائق.",
].join(" ");

describe("la validation de sortie du bilan", () => {
  it("accepte un bilan élève et un bilan parent bien formés", () => {
    expect(validateDigestOutput(STUDENT_FR, "student", "fr", "12-14")).toEqual({
      ok: true,
      body: STUDENT_FR,
    });
    expect(validateDigestOutput(PARENT_FR, "parent", "fr", "12-14").ok).toBe(true);
    expect(validateDigestOutput(PARENT_AR, "parent", "ar", "12-14").ok).toBe(true);
  });

  it("refuse le jargon de jeu dans un bilan PARENT", () => {
    const withJargon = `${PARENT_FR} Il a également gagné deux badges cette semaine.`;
    expect(validateDigestOutput(withJargon, "parent", "fr", "12-14")).toEqual({
      ok: false,
      reason: "GAME_JARGON",
    });
  });

  it("laisse ce même mot passer dans un bilan ÉLÈVE — il joue, lui", () => {
    const withJargon = `${STUDENT_FR} Continue et tu décrocheras un badge.`;
    expect(validateDigestOutput(withJargon, "student", "fr", "12-14").ok).toBe(true);
  });

  it("refuse le vocabulaire payant dans les DEUX registres (D-14)", () => {
    const paid = `${PARENT_FR} Un abonnement vous donnerait accès à davantage.`;
    expect(validateDigestOutput(paid, "parent", "fr", "12-14")).toEqual({
      ok: false,
      reason: "PAYWALL",
    });
    const upsell = `${STUDENT_FR} Passe en premium pour continuer.`;
    expect(validateDigestOutput(upsell, "student", "fr", "12-14")).toEqual({
      ok: false,
      reason: "PAYWALL",
    });
  });

  it("refuse une sortie dans la mauvaise écriture", () => {
    expect(validateDigestOutput(PARENT_FR, "parent", "ar", "12-14")).toEqual({
      ok: false,
      reason: "WRONG_SCRIPT",
    });
  });

  it("refuse ce qui n'est pas de la prose", () => {
    const wall = "mot ".repeat(30).trim();
    expect(validateDigestOutput(wall, "student", "fr", "12-14")).toEqual({
      ok: false,
      reason: "NOT_PROSE",
    });
  });

  it("refuse le vide, le trop court et le trop long", () => {
    expect(validateDigestOutput("   ", "student", "fr", "12-14")).toEqual({
      ok: false,
      reason: "EMPTY",
    });
    expect(validateDigestOutput("Bien joué. Continue.", "student", "fr", "12-14")).toEqual({
      ok: false,
      reason: "TOO_SHORT",
    });
    // La borne du registre est PLUS SERRÉE que celle de `validator.ts` : un
    // bilan de cinq phrases qui déborde à 200 mots n'est pas long, il est hors
    // sujet. C'est précisément ce que la délégation ne devait pas relâcher.
    const long = `${STUDENT_FR} `.repeat(4).trim();
    expect(validateDigestOutput(long, "student", "fr", "12-14")).toEqual({
      ok: false,
      reason: "TOO_LONG",
    });
  });

  it("refuse le balisage et la notation hors manuel", () => {
    expect(validateDigestOutput(`${PARENT_FR} <div>`, "parent", "fr", "12-14")).toEqual({
      ok: false,
      reason: "MARKUP",
    });
    expect(
      validateDigestOutput(`${PARENT_FR} Voir https://exemple.tn`, "parent", "fr", "12-14"),
    ).toEqual({ ok: false, reason: "NOTATION" });
  });

  it("ne prend pas un nombre décimal pour une fin de phrase", () => {
    expect(countSentences("Il a fait 12.5 missions. Puis il a arrêté.")).toBe(2);
  });
});

// ---------------------------------------------------------------------------

describe("la semaine de stockage", () => {
  it("rend le LUNDI de la semaine en cours quand le batch tourne le dimanche", () => {
    // 2026-08-23 est un dimanche : le bilan couvre la semaine ouverte le 17.
    // L'erreur classique — reculer d'un jour au lieu de six — daterait la ligne
    // du 22 et raterait le rattrapage du lundi suivant.
    expect(digestWeekStart(new Date("2026-08-23T05:00:00Z"))).toBe("2026-08-17");
  });

  it("est stable tout au long de la semaine — donc le batch est rejouable", () => {
    for (const day of ["17", "19", "22", "23"]) {
      expect(digestWeekStart(new Date(`2026-08-${day}T05:00:00Z`))).toBe("2026-08-17");
    }
    expect(digestWeekStart(new Date("2026-08-24T05:00:00Z"))).toBe("2026-08-24");
  });
});

// ---------------------------------------------------------------------------
// L'ÉTAGE SERVEUR — la dépense, et ce qui part sur le réseau
// ---------------------------------------------------------------------------

const WEEK_SUNDAY = new Date("2026-08-23T05:00:00Z");
const MODEL = "fournisseur/modele-x";

function aiOk(text: string) {
  return { ok: true, text, model: MODEL, payer: "platform", costUsdMicros: 12, doubleSolve: false };
}

let rpcReplies: Record<string, { data: unknown; error: { message: string } | null }>;

const rpcCalls = (fn: string) => mockRpc.mock.calls.filter((c) => c[0] === fn);
const aiCalls = () =>
  mockCallAi.mock.calls.map(
    (c) => c[0] as { feature: string; tier: string; system: string; studentUserId: string },
  );

const batch = (over: Record<string, unknown> = {}) =>
  generateWeeklyDigests({ dryRun: false, limit: 3, after: null, now: WEEK_SUNDAY, ...over });

beforeEach(() => {
  mockRpc.mockReset();
  mockCallAi.mockReset();

  // L'état nominal : un élève, un parent lié ACTIF, aucun bilan encore écrit.
  for (const key of Object.keys(tableReplies)) delete tableReplies[key];
  tableReplies.profiles = { data: [{ id: USER }], error: null };
  tableReplies.parent_student_links = { data: [{ parent_user_id: PARENT }], error: null };
  tableReplies.tutor_digests = { data: [], error: null };

  rpcReplies = {
    get_tutor_digest_inputs: { data: rawInputs(), error: null },
    store_tutor_digest: { data: "digest-id", error: null },
    get_tutor_digest: { data: { available: false }, error: null },
    get_tutor_parent_digest: { data: { available: false }, error: null },
  };
  mockRpc.mockImplementation(async (fn: string) => rpcReplies[fn] ?? { data: null, error: null });
  mockCallAi.mockImplementation(async (req: { feature: string }) =>
    aiOk(req.feature === "digest_parent" ? PARENT_FR : STUDENT_FR),
  );
});

describe("R-14 sur le fil — ce que le fournisseur reçoit vraiment", () => {
  it("n'expédie ni prénom, ni e-mail, ni identifiant, même s'ils arrivent du SQL", async () => {
    // Le contrôle négatif de bout en bout : le payload d'entrée porte les quatre
    // chaînes interdites, et on inspecte les ARGUMENTS RÉELS de `callAi`.
    await batch();
    expect(mockCallAi).toHaveBeenCalledTimes(2);
    const wire = JSON.stringify(mockCallAi.mock.calls.map((c) => [c[0].system, c[0].blocks]));
    for (const secret of SECRETS) {
      expect(wire).not.toContain(secret);
    }
  });

  it("passe l'élève à la porte IA, parce que c'est LUI qui a un budget", async () => {
    // `resolve_ai_access` se résout sur l'élève, y compris pour le bilan parent :
    // un parent n'a pas de compte élève, et le payeur est une colonne.
    await batch();
    expect(aiCalls().map((c) => c.studentUserId)).toEqual([USER, USER]);
  });
});

describe("le batch et sa facture", () => {
  it("écrit les deux bilans quand un parent est lié ACTIF", async () => {
    const summary = await batch();
    expect(aiCalls().map((c) => c.feature)).toEqual(["digest_student", "digest_parent"]);
    expect(summary).toMatchObject({ examined: 1, written: 2, degraded: 0 });
  });

  it("n'écrit QUE le bilan élève quand aucun lien parent n'est actif", async () => {
    // Le filtre est le même que celui de `dispatchParentDigest`, qui choisit à
    // qui pousser la notification que ce bilan vient remplir.
    tableReplies.parent_student_links = { data: [], error: null };
    await batch();
    expect(aiCalls().map((c) => c.feature)).toEqual(["digest_student"]);
  });

  it("ne repaie PAS un bilan déjà écrit cette semaine", async () => {
    // `store_tutor_digest` REMPLACE la ligne sur conflit : sans cette garde, un
    // rejeu du dimanche paierait une seconde fois pour le même texte.
    tableReplies.tutor_digests = { data: [{ audience: "student" }], error: null };
    await batch();
    expect(aiCalls().map((c) => c.feature)).toEqual(["digest_parent"]);
  });

  it("saute entièrement l'élève dont les deux bilans sont écrits", async () => {
    tableReplies.tutor_digests = {
      data: [{ audience: "student" }, { audience: "parent" }],
      error: null,
    };
    const summary = await batch();
    expect(mockCallAi).not.toHaveBeenCalled();
    // La garde la moins chère passe AVANT : on n'interroge même pas les faits.
    expect(rpcCalls("get_tutor_digest_inputs")).toHaveLength(0);
    expect(summary).toMatchObject({ skippedDone: 1, written: 0 });
  });

  it("ne dépense RIEN pour une semaine sans mission", async () => {
    rpcReplies.get_tutor_digest_inputs = { data: rawInputs({ hasActivity: false }), error: null };
    const summary = await batch();
    expect(mockCallAi).not.toHaveBeenCalled();
    expect(summary).toMatchObject({ skippedEmpty: 1, written: 0, degraded: 0 });
  });

  it("ne dépense RIEN en répétition, mais compte ce qu'il écrirait", async () => {
    const summary = await batch({ dryRun: true });
    expect(mockCallAi).not.toHaveBeenCalled();
    expect(rpcCalls("store_tutor_digest")).toHaveLength(0);
    expect(summary).toMatchObject({ dryRun: true, written: 2 });
  });

  it("choisit le palier rapide — un batch sur toute la base ne se paie pas en rich", async () => {
    await batch();
    expect(aiCalls().map((c) => c.tier)).toEqual(["fast", "fast"]);
  });

  it("écrit le bilan avec sa semaine, sa langue et son modèle", async () => {
    await batch();
    const stored = rpcCalls("store_tutor_digest").map((c) => c[1]);
    expect(stored[0]).toEqual({
      p_user: USER,
      p_week_start: "2026-08-17",
      p_audience: "student",
      p_body: STUDENT_FR,
      p_model: MODEL,
      p_lang: "fr",
    });
    expect(stored[1]).toMatchObject({ p_audience: "parent", p_body: PARENT_FR });
  });

  it("interroge les faits par élève et par semaine", async () => {
    await batch();
    expect(rpcCalls("get_tutor_digest_inputs")[0]?.[1]).toEqual({
      p_user: USER,
      p_week_start: "2026-08-17",
    });
  });

  it("R-11 — ne touche AUCUNE table de jeu", async () => {
    // Le contrôle négatif qui compte : deux RPC, et seulement celles-là. Ni XP,
    // ni pièce, ni badge, ni attempts, ni SM-2 — précédent submit_tutor_mini_check.
    await batch();
    expect([...new Set(mockRpc.mock.calls.map((c) => c[0]))].sort()).toEqual([
      "get_tutor_digest_inputs",
      "store_tutor_digest",
    ]);
  });
});

describe("§3.4 — un retry au même palier, puis dégradé (R-15)", () => {
  it("réessaie UNE fois quand la sortie est rejetée, puis renonce", async () => {
    mockCallAi.mockResolvedValue(aiOk("Bien joué."));
    const summary = await batch();
    // Deux audiences × deux tentatives. Le troisième essai n'existe pas : un
    // modèle qui rate deux fois le même format ratera le troisième.
    expect(mockCallAi).toHaveBeenCalledTimes(4);
    expect(rpcCalls("store_tutor_digest")).toHaveLength(0);
    expect(summary).toMatchObject({ written: 0, degraded: 2 });
  });

  it("ne réessaie PAS un refus de la porte — le budget ne change pas en une seconde", async () => {
    mockCallAi.mockResolvedValue({ ok: false, code: "AI_PLATFORM_BUDGET" });
    const summary = await batch();
    expect(mockCallAi).toHaveBeenCalledTimes(2);
    expect(summary).toMatchObject({ written: 0, degraded: 2 });
  });

  it("compte un échec d'écriture comme un dégradé, sans faire tomber la tranche", async () => {
    rpcReplies.store_tutor_digest = { data: null, error: { message: "boom" } };
    const summary = await batch();
    expect(summary).toMatchObject({ written: 0, degraded: 2 });
  });

  it("passe à l'élève suivant quand SES faits sont illisibles", async () => {
    rpcReplies.get_tutor_digest_inputs = { data: null, error: { message: "down" } };
    const summary = await batch();
    expect(mockCallAi).not.toHaveBeenCalled();
    expect(summary).toMatchObject({ examined: 1, degraded: 1 });
  });
});

describe("le curseur des tranches", () => {
  it("avance sur le dernier élève EXAMINÉ, même si aucun n'a produit de bilan", async () => {
    // Sans cela, une tranche entière en « semaine vide » ferait boucler le
    // script à l'infini sur les mêmes élèves.
    const last = "22222222-2222-4222-8222-222222222222";
    tableReplies.profiles = { data: [{ id: USER }, { id: last }], error: null };
    rpcReplies.get_tutor_digest_inputs = { data: rawInputs({ hasActivity: false }), error: null };
    const summary = await batch();
    expect(summary.lastStudentId).toBe(last);
    expect(summary).toMatchObject({ examined: 2, skippedEmpty: 2 });
  });

  it("rend un curseur nul quand il n'y a plus personne — le script s'arrête là", async () => {
    tableReplies.profiles = { data: [], error: null };
    const summary = await batch();
    expect(summary).toMatchObject({ examined: 0, lastStudentId: null });
  });

  it("s'arrête au plafond d'élèves rédigés, sans en examiner un de plus", async () => {
    const ids = ["a", "b", "c", "d"].map((c) => `${c}${"1".repeat(7)}-1111-4111-8111-111111111111`);
    tableReplies.profiles = { data: ids.map((id) => ({ id })), error: null };
    const summary = await batch({ limit: 2 });
    expect(summary.examined).toBe(2);
    expect(summary.lastStudentId).toBe(ids[1]);
  });
});

describe("la porte HTTP du batch", () => {
  const previous = process.env.CRON_SECRET;
  afterEach(() => {
    if (previous === undefined) delete process.env.CRON_SECRET;
    else process.env.CRON_SECRET = previous;
  });

  const post = (headers: Record<string, string>, body: unknown = {}) =>
    handleDigestCron(
      new Request("https://exemple.test/api/cron/digest", {
        method: "POST",
        headers: { "content-type": "application/json", ...headers },
        body: JSON.stringify(body),
      }),
      WEEK_SUNDAY,
    );

  it("refuse quand le secret n'est pas configuré — sans secret, la route est FERMÉE", async () => {
    delete process.env.CRON_SECRET;
    expect((await post({ authorization: "Bearer nimporte" })).status).toBe(401);
    expect(mockCallAi).not.toHaveBeenCalled();
  });

  it("refuse un jeton qui n'est pas le bon", async () => {
    process.env.CRON_SECRET = "le-vrai";
    expect((await post({ authorization: "Bearer le-faux" })).status).toBe(401);
    expect((await post({})).status).toBe(401);
  });

  it("RÉPÈTE par défaut — un clic de trop ne déclenche pas une facture", async () => {
    process.env.CRON_SECRET = "le-vrai";
    const res = await post({ authorization: "Bearer le-vrai" });
    expect(res.status).toBe(200);
    expect(await res.json()).toMatchObject({ ok: true, dryRun: true, written: 2 });
    expect(mockCallAi).not.toHaveBeenCalled();
  });

  it("produit quand la dépense est demandée explicitement", async () => {
    process.env.CRON_SECRET = "le-vrai";
    const res = await post({ authorization: "Bearer le-vrai" }, { dryRun: false });
    expect(await res.json()).toMatchObject({ ok: true, dryRun: false, written: 2 });
    expect(mockCallAi).toHaveBeenCalledTimes(2);
  });

  it("plafonne la tranche demandée — la route ne devient pas un batch complet", async () => {
    process.env.CRON_SECRET = "le-vrai";
    // 500 dépasserait de loin les 30 s de maxDuration : le schéma le refuse, et
    // le repli est le défaut prudent, jamais la valeur demandée.
    const res = await post({ authorization: "Bearer le-vrai" }, { limit: 500 });
    expect(await res.json()).toMatchObject({ examined: 1 });
  });

  it("rend un 500 JSON quand la base est injoignable, jamais une page d'erreur", async () => {
    process.env.CRON_SECRET = "le-vrai";
    tableReplies.profiles = { data: null, error: { message: "down" } };
    const res = await post({ authorization: "Bearer le-vrai" }, { dryRun: false });
    expect(res.status).toBe(500);
    expect(await res.json()).toEqual({ ok: false, error: "batch_failed" });
  });
});

describe("la lecture par l'écran (R-15 : quatre états, jamais une exception)", () => {
  it("rend le bilan de l'élève par sa propre RPC", async () => {
    rpcReplies.get_tutor_digest = {
      data: { available: true, weekStart: "2026-08-17", lang: "fr", body: STUDENT_FR },
      error: null,
    };
    await expect(getWeeklyDigest({ data: {} })).resolves.toEqual({
      kind: "digest",
      audience: "student",
      weekStart: "2026-08-17",
      lang: "fr",
      body: STUDENT_FR,
    });
    expect(rpcCalls("get_tutor_digest")[0]?.[1]).toEqual({ p_week_start: null });
  });

  it("rend le bilan parent par LA RPC DU PARENT, jamais celle de l'élève", async () => {
    // Q-5 : le parent lit le texte écrit POUR lui. Les deux audiences ne se
    // croisent pas, et c'est la colonne `audience` de la table qui le garantit.
    rpcReplies.get_tutor_parent_digest = {
      data: { available: true, weekStart: "2026-08-17", lang: "ar", body: PARENT_AR },
      error: null,
    };
    await expect(
      getWeeklyDigest({ data: { audience: "parent", studentId: USER } }),
    ).resolves.toMatchObject({ kind: "digest", audience: "parent", lang: "ar" });
    expect(rpcCalls("get_tutor_digest")).toHaveLength(0);
  });

  it("dit « pas encore » quand la semaine n'en a pas produit", async () => {
    await expect(getWeeklyDigest({ data: {} })).resolves.toEqual({
      kind: "none",
      reason: "not-yet",
    });
  });

  it("distingue le lien coupé de la panne — les deux ne se règlent pas pareil", async () => {
    // « Lien inactif » se règle en rétablissant le lien, « pas encore de bilan »
    // en attendant dimanche. Les confondre ferait attendre indéfiniment un
    // parent dont le lien est simplement à réactiver.
    rpcReplies.get_tutor_parent_digest = { data: null, error: { message: "NOT_LINKED" } };
    await expect(
      getWeeklyDigest({ data: { audience: "parent", studentId: USER } }),
    ).resolves.toEqual({ kind: "none", reason: "not-linked" });

    rpcReplies.get_tutor_parent_digest = { data: null, error: { message: "connection reset" } };
    await expect(
      getWeeklyDigest({ data: { audience: "parent", studentId: USER } }),
    ).resolves.toEqual({ kind: "none", reason: "unavailable" });
  });

  it("n'appelle rien quand l'écran parent oublie l'élève", async () => {
    await expect(getWeeklyDigest({ data: { audience: "parent" } })).resolves.toEqual({
      kind: "none",
      reason: "unavailable",
    });
    expect(rpcCalls("get_tutor_parent_digest")).toHaveLength(0);
  });
});
