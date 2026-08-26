import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * L'ORCHESTRATEUR DU TUTEUR — étude 11, lots 1, 3 et 4.
 *
 * POURQUOI CE FICHIER EXISTE, ET POURQUOI SI TARD
 * ---------------------------------------------------------------------------
 * `tutor.server.ts` est arrivé avec le lot 1 SANS un seul test, et il y est
 * resté : 959 lignes à 0 % de couverture. Ça n'avait rien cassé tant que le
 * fichier était petit — un fichier non couvert ne fait pas bouger une moyenne
 * globale à lui seul. Les lots 3 et 4 l'ont doublé, et la CI a rendu son verdict
 * le 2026-08-23 : « Coverage for branches (79,89 %) does not meet global
 * threshold (80 %) ». Une dette de couverture se paie au premier ajout, par
 * celui qui ajoute.
 *
 * Mais ce fichier n'est pas écrit POUR le pourcentage. Ce qu'il garde, ce sont
 * les trois invariants que ce module porte et que rien d'autre ne vérifie :
 *
 *   R-7  — l'escalier de registres ne se remonte pas, et ROUVRIR le panneau ne
 *          brûle pas une marche. Sans ça, un élève qui revient trois fois sur sa
 *          question a épuisé « Explique autrement » sans l'avoir demandé.
 *   R-15.2 — le pot commun AVANT la dépense. L'ordre est la raison d'être du
 *          cache : une explication déjà payée par une autre famille ne se
 *          repaie pas, et l'élève ne perd pas d'énergie pour elle.
 *   R-15  — aucun refus n'est une exception. Porte fermée, contexte illisible,
 *          fournisseur en panne : chacun rend un ÉTAT que l'écran sait afficher.
 */

/**
 * ⚠️ `vi.hoisted` et pas un `const` ordinaire : `vi.mock` est remontée en tête
 * de module, et sa fabrique s'exécute AVANT les déclarations qui la suivent.
 * Une fabrique qui lit un `const` déclaré plus bas tape dans la zone morte
 * temporelle — et ici ça ne lève pas, ça FIGE le worker (« Timeout waiting for
 * worker to respond », soixante secondes, aucun test exécuté). La signature est
 * indiscernable de la panne de contention Windows du poste : c'est un fichier
 * voisin qui tourne encore, lui, qui a tranché.
 */
const { USER, mockRpc, mockSupabase, mockAdminRpc, mockCallAi } = vi.hoisted(() => {
  const rpc = vi.fn();
  return {
    USER: "11111111-1111-4111-8111-111111111111",
    mockRpc: rpc,
    mockSupabase: { rpc },
    mockAdminRpc: vi.fn(async () => ({ data: null, error: null })),
    mockCallAi: vi.fn(),
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
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { rpc: mockAdminRpc },
}));
vi.mock("@/features/ai", () => ({ callAi: (r: unknown) => mockCallAi(r) }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import {
  escalateTutorThread,
  explainMistake,
  getTutorAvailability,
  getTutorChatEntry,
  getTutorHistory,
  getTutorMiniCheck,
  getTutorPrefs,
  getTutorUnderstandingSignal,
  isCuratedModel,
  nextVariant,
  rateTutorMessage,
  setTutorPlanPush,
  submitTutorMiniCheck,
} from "../tutor.server";

const QUESTION = "22222222-2222-4222-8222-222222222222";
const CHAPTER = "33333333-3333-4333-8333-333333333333";
const THREAD = "44444444-4444-4444-8444-444444444444";

/** Une explication assez longue et assez française pour passer le validateur. */
const BODY =
  "Tu as additionné les dénominateurs, alors qu'il faut les garder identiques. " +
  "Reprends la fraction et compare les parts une à une. Tu veux qu'on vérifie ensemble ?";

/** Les réponses des RPC, une par nom. Chaque test ne surcharge que ce qui l'intéresse. */
let replies: Record<string, { data: unknown; error: { message: string } | null }>;

function reply(data: unknown, error: { message: string } | null = null) {
  return { data, error };
}

beforeEach(() => {
  mockRpc.mockReset();
  mockAdminRpc.mockClear();
  mockCallAi.mockReset();

  replies = {
    can_use_tutor: reply({ allowed: true, reason: "OK" }),
    get_tutor_question_context: reply({
      question_id: QUESTION,
      prompt: "1/2 + 1/3 = ?",
      options: [
        { id: "a", text: "5/6" },
        { id: "b", text: "2/5" },
      ],
      selected_choice: "b",
      is_correct: false,
      correct_option: "a",
      explanation: "On met au même dénominateur.",
      misconception: "frac.add-denominators",
      misconception_labels: { fr: "Tu additionnes les dénominateurs", en: "x", ar: "س" },
      chapter_id: CHAPTER,
      chapter_title: "Les fractions",
      chapter_summary: null,
      lesson_excerpt: "On garde le dénominateur commun.",
      lang: "fr",
      grade_label: "9ème",
      age_band: "12-14",
    }),
    open_tutor_thread: reply({ thread_id: THREAD, variant_served: 0, resolved: null }),
    find_tutor_explanation: reply(null),
    get_tutor_learner_context: reply(null),
    append_tutor_message: reply({ message_ix: 3 }),
  };

  mockRpc.mockImplementation(async (fn: string) => replies[fn] ?? reply(null));
  mockCallAi.mockResolvedValue({
    ok: true,
    text: BODY,
    model: "claude-sonnet-5",
    payer: "family",
    costUsdMicros: 42,
    doubleSolve: true,
  });
});

const calls = (fn: string) => mockRpc.mock.calls.filter((c) => c[0] === fn);

// ---------------------------------------------------------------------------

describe("les deux fonctions pures", () => {
  it("R-15.2 : seul un modèle de la liste curée entre dans le pot commun", () => {
    expect(isCuratedModel("claude-sonnet-5")).toBe(true);
    // Sans cette barrière, la clé la moins chère du parc fixerait la qualité
    // servie à tous les enfants.
    expect(isCuratedModel("un-modele-que-personne-n-a-teste")).toBe(false);
  });

  it("⭐ et il ignore le fournisseur — une passerelle n'est pas un autre modèle", () => {
    // Le doublon supprimé le 2026-08-26 répondait `false` ici, pour la seule
    // raison que `claude-sonnet-5` est rangé sous la clé `anthropic`. Une famille
    // qui l'atteint par OpenRouter ou LiteLLM reçoit pourtant le même modèle.
    // Ce test tient l'arbitrage : c'est l'id qui décide, pas la plomberie.
    expect(isCuratedModel("claude-sonnet-5")).toBe(true);
    expect(isCuratedModel("gpt-5")).toBe(true);
    // Et la contrepartie, assumée : rien ne distingue un endpoint honnête d'un
    // endpoint qui renvoie un id curé. La barrière est le NOM, pas la route.
    expect(isCuratedModel("mistral-large-3-25-12")).toBe(true);
  });

  it("R-7 : les registres se servent dans l'ordre, et s'épuisent", () => {
    expect(nextVariant(0)).toBe("concret");
    expect(nextVariant(1)).toBe("visuel-verbal");
    expect(nextVariant(2)).toBe("formel");
    expect(nextVariant(3)).toBeNull();
  });
});

describe("R-1 — la porte", () => {
  it("une porte qu'on n'arrive pas à interroger est une porte FERMÉE", async () => {
    // Le contraire ouvrirait le tuteur pendant un donjon sur une panne de RPC.
    replies.can_use_tutor = reply(null, { message: "boom" });
    expect(await getTutorAvailability({ data: { questionId: QUESTION } })).toEqual({
      allowed: false,
      reason: "UNKNOWN",
    });
  });

  it("une forme inattendue est traitée comme un refus, pas comme un oui", async () => {
    replies.can_use_tutor = reply({ pas: "la bonne forme" });
    expect(await getTutorAvailability({ data: { questionId: QUESTION } })).toEqual({
      allowed: false,
      reason: "UNKNOWN",
    });
  });

  it("le refus porte SA raison, pour que l'écran la dise en langage d'élève", async () => {
    replies.can_use_tutor = reply({ allowed: false, reason: "ACTIVE_DUNGEON" });
    expect(await getTutorAvailability({ data: { questionId: QUESTION } })).toEqual({
      allowed: false,
      reason: "ACTIVE_DUNGEON",
    });
  });

  it("porte fermée ⇒ `explainMistake` ne demande MÊME PAS le contexte (R-16)", async () => {
    replies.can_use_tutor = reply({ allowed: false, reason: "NOT_ATTEMPTED" });
    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });

    expect(out).toEqual({ ok: false, code: "NOT_ATTEMPTED" });
    // C'est CETTE assertion qui rend légitime de mettre la clé dans le contexte
    // du modèle : tant que R-1 n'est pas franchie, elle ne sort pas de la base.
    expect(calls("get_tutor_question_context")).toHaveLength(0);
    expect(mockCallAi).not.toHaveBeenCalled();
  });
});

describe("⭐ R-15.2 — le pot commun AVANT la dépense", () => {
  it("un cache plein sert l'explication sans appeler le modèle", async () => {
    replies.find_tutor_explanation = reply({
      body: BODY,
      model: "claude-sonnet-5",
      shared: true,
    });

    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });

    expect(out).toMatchObject({ ok: true, cached: true, body: BODY });
    // L'ordre EST la raison d'être du cache : une explication déjà payée par une
    // autre famille ne se repaie pas, et l'élève ne perd pas d'énergie pour elle.
    expect(mockCallAi).not.toHaveBeenCalled();
  });

  it("un cache vide dépense, valide, puis ÉCRIT dans le pot commun", async () => {
    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });

    expect(out).toMatchObject({ ok: true, cached: false, variant: "concret" });
    expect(mockCallAi).toHaveBeenCalledTimes(1);
    expect(mockCallAi.mock.calls[0][0]).toMatchObject({ feature: "explain", tier: "rich" });
    // Le cache s'écrit avec le client ADMIN : `shared` est un fait constaté au
    // serveur, que personne ne peut retourner depuis un écran.
    expect(mockAdminRpc).toHaveBeenCalledWith(
      "store_tutor_explanation",
      expect.objectContaining({ p_body: BODY }),
    );
  });

  it("⭐ un modèle PLATEFORME hors liste curée n'écrit RIEN — pas une ligne illisible", async () => {
    // Le piège que #871 a armé sans le vouloir : la clé plateforme est devenue
    // agnostique, donc son modèle est une variable d'environnement libre. Le
    // verser au pot commun sans condition ferait fixer la qualité servie à TOUS
    // les élèves par un identifiant tapé dans Vercel.
    //
    // Et l'écrire en privé serait pire qu'inutile : le payeur plateforme n'a pas
    // d'`owner_user_id`, donc `find_tutor_explanation` (`e.shared OR
    // e.owner_user_id = v_user`) ne pourrait la relire pour personne. Une ligne
    // morte à l'écriture, qui en plus pèse au dénominateur du ratio de
    // mutualisation de /admin/ia. Donc : aucune écriture du tout.
    mockCallAi.mockResolvedValue({
      ok: true,
      text: BODY,
      model: "glm-4.5-air",
      payer: "platform",
      costUsdMicros: 42,
      doubleSolve: true,
    });

    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });

    // L'élève est servi quand même — R-15.2 n'a jamais parlé de le priver.
    expect(out).toMatchObject({ ok: true, cached: false, body: BODY });
    expect(mockAdminRpc).not.toHaveBeenCalled();
  });

  it("un modèle plateforme CURÉ, lui, entre au pot commun — et sans propriétaire", async () => {
    mockCallAi.mockResolvedValue({
      ok: true,
      text: BODY,
      model: "claude-haiku-4-5",
      payer: "platform",
      costUsdMicros: 42,
      doubleSolve: true,
    });

    await explainMistake({ data: { questionId: QUESTION, again: false } });

    expect(mockAdminRpc).toHaveBeenCalledWith(
      "store_tutor_explanation",
      expect.objectContaining({ p_model: "claude-haiku-4-5", p_shared: true, p_owner: null }),
    );
  });

  it("côté FAMILLE, un modèle hors liste s'écrit encore — mais privé à son payeur", async () => {
    mockCallAi.mockResolvedValue({
      ok: true,
      text: BODY,
      model: "un-modele-que-personne-n-a-teste",
      payer: "family",
      costUsdMicros: 42,
      doubleSolve: true,
    });

    await explainMistake({ data: { questionId: QUESTION, again: false } });

    // La réserve privée de R-15.2 : elle a un propriétaire, donc quelqu'un peut
    // la relire. C'est ce qui la distingue du cas plateforme ci-dessus.
    expect(mockAdminRpc).toHaveBeenCalledWith(
      "store_tutor_explanation",
      expect.objectContaining({ p_shared: false, p_owner: USER }),
    );
  });

  it("« Explique autrement » se journalise comme une REFORMULATION", async () => {
    replies.open_tutor_thread = reply({ thread_id: THREAD, variant_served: 1, resolved: null });
    await explainMistake({ data: { questionId: QUESTION, again: true } });
    expect(mockCallAi.mock.calls[0][0]).toMatchObject({ feature: "reformulate" });
  });
});

describe("⭐ R-7 — l'escalier de registres", () => {
  it("rouvrir le panneau RE-SERT le registre déjà servi, il n'en brûle pas un", async () => {
    // Le cas qui compte : un élève revient trois fois sur sa question. Sans
    // cette règle, il a épuisé l'escalier sans jamais demander « explique
    // autrement ».
    replies.open_tutor_thread = reply({ thread_id: THREAD, variant_served: 1, resolved: null });

    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });

    expect(out).toMatchObject({ ok: true, variant: "concret" });
    expect(calls("append_tutor_message")[0][1]).toMatchObject({ p_advance_variant: false });
  });

  it("demander autrement AVANCE, et le dit à la base", async () => {
    replies.open_tutor_thread = reply({ thread_id: THREAD, variant_served: 1, resolved: null });
    const out = await explainMistake({ data: { questionId: QUESTION, again: true } });

    expect(out).toMatchObject({ ok: true, variant: "visuel-verbal", canReformulate: true });
    expect(calls("append_tutor_message")[0][1]).toMatchObject({ p_advance_variant: true });
  });

  it("le dernier registre servi ferme le bouton", async () => {
    replies.open_tutor_thread = reply({ thread_id: THREAD, variant_served: 2, resolved: null });
    const out = await explainMistake({ data: { questionId: QUESTION, again: true } });
    expect(out).toMatchObject({ variant: "formel", canReformulate: false });
  });

  it("au-delà des trois registres, on refuse au lieu d'en inventer un quatrième", async () => {
    replies.open_tutor_thread = reply({ thread_id: THREAD, variant_served: 3, resolved: null });
    const out = await explainMistake({ data: { questionId: QUESTION, again: true } });

    expect(out).toEqual({ ok: false, code: "TUTOR_VARIANTS_EXHAUSTED" });
    expect(mockCallAi).not.toHaveBeenCalled();
  });
});

describe("R-15 — aucun refus n'est une exception", () => {
  it("un contexte illisible rend un état, pas un throw", async () => {
    replies.get_tutor_question_context = reply(null, { message: "boom" });
    await expect(explainMistake({ data: { questionId: QUESTION, again: false } })).resolves.toEqual(
      { ok: false, code: "AI_UNKNOWN" },
    );
  });

  it("une forme de contexte inattendue aussi", async () => {
    replies.get_tutor_question_context = reply({ incomplet: true });
    await expect(explainMistake({ data: { questionId: QUESTION, again: false } })).resolves.toEqual(
      { ok: false, code: "AI_UNKNOWN" },
    );
  });

  it("un fil qu'on n'arrive pas à ouvrir aussi", async () => {
    replies.open_tutor_thread = reply(null, { message: "boom" });
    await expect(explainMistake({ data: { questionId: QUESTION, again: false } })).resolves.toEqual(
      { ok: false, code: "AI_UNKNOWN" },
    );
  });

  it("le code de refus de la porte é29 est propagé TEL QUEL", async () => {
    // « El Ostedh revient demain » se décide sur ce code-là, pas sur un générique.
    mockCallAi.mockResolvedValue({ ok: false, code: "AI_ENERGY_SPENT" });
    await expect(explainMistake({ data: { questionId: QUESTION, again: false } })).resolves.toEqual(
      { ok: false, code: "AI_ENERGY_SPENT" },
    );
  });

  it("§3.4 : une sortie rejetée est RETENTÉE une fois, puis abandonnée", async () => {
    // Trop courte pour le validateur : c'est le symptôme d'un modèle qui a
    // répondu à côté (« D'accord ! »), pas d'une réponse brève.
    mockCallAi.mockResolvedValue({
      ok: true,
      text: "ok",
      model: "claude-sonnet-5",
      payer: "family",
      costUsdMicros: 1,
      doubleSolve: true,
    });

    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });

    expect(out).toEqual({ ok: false, code: "AI_OUTPUT_REJECTED" });
    expect(mockCallAi).toHaveBeenCalledTimes(2);
    // Rien de rejeté n'entre dans le pot commun ni dans le fil.
    expect(mockAdminRpc).not.toHaveBeenCalled();
    expect(calls("append_tutor_message")).toHaveLength(0);
  });

  it("un fil qu'on n'arrive pas à écrire ne PRIVE PAS l'élève de sa réponse", async () => {
    // Le fil est de l'auditabilité, pas de la pédagogie.
    replies.append_tutor_message = reply(null, { message: "boom" });
    const out = await explainMistake({ data: { questionId: QUESTION, again: false } });
    expect(out).toMatchObject({ ok: true, messageIx: 0 });
  });
});

describe("les gestes courts", () => {
  it("un avis se pose, et un échec se dit sans lever", async () => {
    replies.rate_tutor_message = reply(null);
    expect(
      await rateTutorMessage({ data: { threadId: THREAD, messageIx: 1, rating: -1 } }),
    ).toEqual({ ok: true });

    replies.rate_tutor_message = reply(null, { message: "boom" });
    expect(await rateTutorMessage({ data: { threadId: THREAD, messageIx: 1, rating: 1 } })).toEqual(
      { ok: false },
    );
  });

  it("le rappel du plan s'arme et se désarme", async () => {
    replies.set_tutor_plan_push = reply(null);
    expect(await setTutorPlanPush({ data: { enabled: true } })).toEqual({ ok: true });
    expect(calls("set_tutor_plan_push")[0][1]).toEqual({ p_enabled: true });
  });

  it("un réglage illisible retombe sur le DÉFAUT, jamais sur une erreur", async () => {
    // La page de paramétrage doit s'afficher même quand le tuteur est éteint.
    replies.get_tutor_prefs = reply(null, { message: "boom" });
    expect(await getTutorPrefs({})).toEqual({
      interests: [],
      verbosity: "normale",
      planPush: false,
    });
  });

  it("un historique illisible rend une liste vide, pas un écran cassé", async () => {
    replies.list_tutor_threads = reply(null, { message: "boom" });
    expect(await getTutorHistory({})).toEqual([]);
  });

  it("l'historique est mis en forme pour l'écran, pas rendu brut", async () => {
    replies.list_tutor_threads = reply([
      {
        thread_id: THREAD,
        scope: "chapter",
        chapter_id: CHAPTER,
        title: "Les fractions",
        message_count: 4,
        updated_at: "2026-08-23T10:00:00Z",
      },
    ]);
    expect(await getTutorHistory({})).toEqual([
      {
        threadId: THREAD,
        scope: "chapter",
        chapterId: CHAPTER,
        title: "Les fractions",
        messageCount: 4,
        updatedAt: "2026-08-23T10:00:00Z",
      },
    ]);
  });
});

describe("Q-6 — l'entrée du chat décide de l'âge côté SERVEUR", () => {
  beforeEach(() => {
    replies.get_tutor_chapter_context = reply({ found: true, lang: "fr", age_band: "12-14" });
  });

  it("le champ libre s'ouvre au collège", async () => {
    expect(await getTutorChatEntry({ data: { chapterId: CHAPTER } })).toEqual({
      allowed: true,
      reason: "OK",
      freeText: true,
      lang: "fr",
    });
  });

  it("…et reste fermé en primaire, quoi qu'en dise l'écran", async () => {
    replies.get_tutor_chapter_context = reply({ found: true, lang: "fr", age_band: "9-11" });
    expect(await getTutorChatEntry({ data: { chapterId: CHAPTER } })).toMatchObject({
      allowed: true,
      freeText: false,
    });
  });

  it("une porte fermée n'ouvre aucun champ", async () => {
    replies.can_use_tutor = reply({ allowed: false, reason: "ACTIVE_DUEL" });
    expect(await getTutorChatEntry({ data: { chapterId: CHAPTER } })).toEqual({
      allowed: false,
      reason: "ACTIVE_DUEL",
      freeText: false,
      lang: "fr",
    });
  });

  it("un contexte illisible ferme tout", async () => {
    replies.get_tutor_chapter_context = reply(null, { message: "boom" });
    expect(await getTutorChatEntry({ data: { chapterId: CHAPTER } })).toMatchObject({
      allowed: false,
      freeText: false,
    });
  });
});

// ---------------------------------------------------------------------------
// LOT 4 — la boucle de compréhension. Aucune de ces quatre fonctions n'appelle
// `callAi()`, et c'est le fait que ces tests gardent : le mini-check et
// l'escalade sont 100 % déterministes (R-10). La question vient du stock, la
// correction de la base, la phrase du catalogue i18n.
// ---------------------------------------------------------------------------

describe("US-4 — le mini-check", () => {
  it("sert une question du STOCK, sans jamais sa clé (R-16)", async () => {
    replies.get_tutor_mini_check = reply({
      served: true,
      reason: "OK",
      question_id: QUESTION,
      prompt: "2/4 vaut-il 1/2 ?",
      options: [
        { id: "a", text: "oui" },
        { id: "b", text: "non" },
      ],
      tag: "frac.add-denominators",
      lang: "fr",
      match: "tag",
    });

    const out = await getTutorMiniCheck({ data: { questionId: QUESTION } });

    expect(out).toMatchObject({ ok: true, questionId: QUESTION, tag: "frac.add-denominators" });
    // La clé n'est pas dans la charge : l'écran ne peut pas la révéler par accident.
    expect(JSON.stringify(out)).not.toContain("correct_option");
    expect(mockCallAi).not.toHaveBeenCalled();
  });

  it("un vivier vide se dit, il n'invente pas une question", async () => {
    replies.get_tutor_mini_check = reply({ served: false, reason: "NO_CANDIDATE" });
    expect(await getTutorMiniCheck({ data: { questionId: QUESTION } })).toEqual({
      ok: false,
      code: "NO_CANDIDATE",
    });
  });

  it("une RPC en panne rend un état, pas une exception", async () => {
    replies.get_tutor_mini_check = reply(null, { message: "boom" });
    expect(await getTutorMiniCheck({ data: { questionId: QUESTION } })).toEqual({
      ok: false,
      code: "UNKNOWN",
    });
  });

  it("R-11 : la correction ne porte AUCUNE récompense", async () => {
    replies.submit_tutor_mini_check = reply({
      graded: true,
      reason: "OK",
      correct: true,
      correct_option: "a",
      explanation: "2/4 se simplifie en 1/2.",
      tag: "frac.add-denominators",
    });

    const out = await submitTutorMiniCheck({ data: { questionId: QUESTION, choice: "a" } });

    expect(out).toMatchObject({ ok: true, correct: true });
    // Ni XP, ni pièce, ni badge : le tuteur ne récompense pas, il renvoie vers
    // les missions réelles. On vérifie les CLÉS et non une sous-chaîne — un
    // `not.toMatch(/xp/)` passerait son temps à trébucher sur « explanation ».
    expect(Object.keys(out).sort()).toEqual([
      "correct",
      "correctOption",
      "explanation",
      "ok",
      "tag",
    ]);
  });

  it("un refus de correction porte SA raison", async () => {
    replies.submit_tutor_mini_check = reply({ graded: false, reason: "ACTIVE_DUNGEON" });
    expect(await submitTutorMiniCheck({ data: { questionId: QUESTION, choice: "a" } })).toEqual({
      ok: false,
      code: "ACTIVE_DUNGEON",
    });
  });
});

describe("R-8 — le signal d'incompréhension", () => {
  it("remonte le niveau recommandé par le SQL, et le NOMME", async () => {
    replies.tutor_understanding_signal = reply({
      tag: "frac.add-denominators",
      signal_a: true,
      signal_b: false,
      signal_c: false,
      recommended_level: 2,
    });
    // Niveau 2 = « prerequisite » : l'échelle est reteach(0) → lesson(1) →
    // prerequisite(2) → plan(3) → parentDigest(4).
    expect(await getTutorUnderstandingSignal({ data: { tag: "frac.add-denominators" } })).toEqual({
      level: 2,
      step: "prerequisite",
    });
  });

  it("⭐ un diagnostic illisible vaut « aucun signal », jamais une escalade", async () => {
    // L'inverse escaladerait sur une panne : un élève qui n'a rien raté se
    // verrait proposer un prérequis parce qu'une RPC a échoué.
    replies.tutor_understanding_signal = reply(null, { message: "boom" });
    expect(await getTutorUnderstandingSignal({ data: { tag: "x" } })).toMatchObject({ level: 0 });
  });

  it("une forme inattendue aussi", async () => {
    replies.tutor_understanding_signal = reply({ pas: "la bonne forme" });
    expect(await getTutorUnderstandingSignal({ data: { tag: "x" } })).toMatchObject({ level: 0 });
  });
});

describe("R-8 — l'escalade, marche par marche", () => {
  it("la marche « cours » porte une cible qu'un lien peut suivre", async () => {
    replies.escalate_tutor_thread = reply({
      escalation_level: 2,
      action: "lesson",
      target: { chapter_id: CHAPTER, chapter_title: "Les fractions", subject_id: "math" },
    });

    expect(await escalateTutorThread({ data: { threadId: THREAD } })).toEqual({
      level: 2,
      step: "lesson",
      target: {
        kind: "lesson",
        chapterId: CHAPTER,
        chapterTitle: "Les fractions",
        subjectId: "math",
      },
    });
  });

  it("la marche « prérequis » porte la compétence, dans les trois langues", async () => {
    replies.escalate_tutor_thread = reply({
      escalation_level: 3,
      action: "prerequisite",
      target: {
        competency: "frac.equivalence",
        label_fr: "Fractions équivalentes",
        label_en: "Equivalent fractions",
        label_ar: "الكسور المتكافئة",
      },
    });

    const out = await escalateTutorThread({ data: { threadId: THREAD } });
    expect(out).toMatchObject({ step: "prerequisite", target: { kind: "prerequisite" } });
  });

  it("la dernière marche ne mène NULLE PART dans l'app de l'élève (Q-5)", async () => {
    // Le digest parent la porte ; il n'y a pas d'écran à lui montrer.
    replies.escalate_tutor_thread = reply({
      escalation_level: 4,
      action: "parent_digest",
      target: null,
    });
    expect(await escalateTutorThread({ data: { threadId: THREAD } })).toMatchObject({
      step: "parentDigest",
      target: null,
    });
  });

  it("une escalade impossible rend `null`, pas une marche inventée", async () => {
    replies.escalate_tutor_thread = reply(null, { message: "boom" });
    expect(await escalateTutorThread({ data: { threadId: THREAD } })).toBeNull();
  });

  it("une cible dont la forme ne correspond pas à la marche est ÉCARTÉE", async () => {
    // Un composant qui lirait `target.chapterId` sur une cible de prérequis
    // rendrait un lien mort. Mieux vaut pas de cible qu'une fausse.
    replies.escalate_tutor_thread = reply({
      escalation_level: 2,
      action: "lesson",
      target: { competency: "pas-un-chapitre" },
    });
    expect(await escalateTutorThread({ data: { threadId: THREAD } })).toMatchObject({
      step: "lesson",
      target: null,
    });
  });
});
