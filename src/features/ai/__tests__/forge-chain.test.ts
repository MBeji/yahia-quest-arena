import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * LA CHAÎNE DE LA FORGE, bout à bout (§3.6) — avec un faux fournisseur, jamais
 * un vrai (§5 : « aucun appel réel vers un fournisseur, jamais »).
 *
 * Les trois cas que l'étude nomme au §4 : candidat invalide rejeté, doublon
 * rejeté, désaccord de double-solve ⇒ rebut. Plus les deux que Q-7 a rendus
 * possibles et qu'il faut donc garder : la vérification COUPÉE échantillonne
 * quand même, et le quiz qui en sort est étiqueté `verified = false`.
 */

type Call = { feature: string; accessFeature?: string; energyCost?: number };

const calls: Call[] = [];
const rpcCalls: { fn: string; args: Record<string, unknown> }[] = [];
let generationText = "";
let solveAnswers: string[] = [];
let doubleSolve = true;
let quotaLeft = 3;

vi.mock("../ai-call.server", () => ({
  callAi: vi.fn(async (request: Call & { feature: string }) => {
    calls.push({
      feature: request.feature,
      accessFeature: request.accessFeature,
      energyCost: request.energyCost,
    });
    if (request.feature === "forge") {
      return {
        ok: true,
        text: generationText,
        model: "claude-haiku-4-5",
        payer: "family",
        costUsdMicros: 1000,
        doubleSolve,
      };
    }
    const answer = solveAnswers.shift() ?? "b";
    return {
      ok: true,
      text: JSON.stringify({ answer }),
      model: "claude-haiku-4-5",
      payer: "family",
      costUsdMicros: 100,
      doubleSolve,
    };
  }),
}));

vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: {
    rpc: vi.fn(async (fn: string, args: Record<string, unknown>) => {
      rpcCalls.push({ fn, args });
      if (fn === "ai_forge_quota_left") return { data: quotaLeft, error: null };
      if (fn === "get_forge_context") {
        return {
          data: [
            {
              chapter_title: "Les fractions",
              subject_id: "math-6",
              content_lang: "fr",
              grade_rank: 6,
              lesson_excerpt: "Une fraction représente une part.",
              sample_prompts: ["Combien vaut un demi ?"],
              existing_prompts: ["Combien vaut un demi ?"],
            },
          ],
          error: null,
        };
      }
      if (fn === "create_forged_quiz") return { data: "quiz-1", error: null };
      return { data: null, error: null };
    }),
  },
}));

// `createServerFn` est remplacé par une chaîne qui rend le handler LUI-MÊME :
// `forgeQuiz` devient donc une fonction appelable directement, avec le `context`
// que le middleware d'authentification aurait fourni. C'est le même patron que
// `parametrage-pseudo.test.tsx`.
vi.mock("@tanstack/react-start", () => ({
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: (fn: unknown) => fn,
    };
    return chain;
  },
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
}));

type HandlerFn = (args: {
  data: unknown;
  context: { userId: string; supabase: unknown };
}) => Promise<unknown>;

import { parseForgeOutput, readSolvedAnswer } from "../forge.server";

const STUDENT = "22222222-2222-4222-8222-222222222222";
const CHAPTER = "33333333-3333-4333-8333-333333333333";

function question(prompt: string, key = "b") {
  return {
    // Le schéma exige au moins 10 caractères d'énoncé : les libellés courts des
    // scénarios ci-dessous sont complétés, sinon ils seraient rejetés par le
    // filtre de schéma et le test mesurerait autre chose que ce qu'il annonce.
    prompt: prompt.length >= 10 ? prompt : `Question ${prompt} — combien font 2 + 3 ?`,
    options: [
      { id: "a", text: "4" },
      { id: "b", text: "5" },
      { id: "c", text: "6" },
      { id: "d", text: "7" },
    ],
    correctOption: key,
    explanation: `La bonne réponse est ${key}, parce que le calcul donne cette valeur.`,
    difficulty: 2,
  };
}

/** Rejoue le module pour capturer le handler courant, avec l'état voulu. */
async function runForge(input: { size: 5 | 8 | 10; difficulty: number }) {
  vi.resetModules();
  const mod = await import("../forge.server");
  // `createServerFn` est faux : `forgeQuiz` EST son handler.
  const fn = mod.forgeQuiz as unknown as HandlerFn;
  return fn({
    data: { chapterId: CHAPTER, ...input },
    context: { userId: STUDENT, supabase: {} },
  });
}

beforeEach(() => {
  calls.length = 0;
  rpcCalls.length = 0;
  solveAnswers = [];
  doubleSolve = true;
  quotaLeft = 3;
});

afterEach(() => {
  vi.unstubAllEnvs();
});

describe("lecture de la sortie du modèle", () => {
  it("lit un JSON nu", () => {
    expect(parseForgeOutput('{"items":[{"a":1}]}')).toEqual([{ a: 1 }]);
  });

  it("tolère la clôture markdown d'un fournisseur sans sortie structurée", () => {
    expect(parseForgeOutput('```json\n{"items":[]}\n```')).toEqual([]);
  });

  it("rend `null` sur du texte libre — un rebut compté, pas une exception", () => {
    expect(parseForgeOutput("Voici tes questions !")).toBeNull();
    expect(parseForgeOutput('{"questions":[]}')).toBeNull();
  });

  it("lit une résolution en JSON ou en lettre nue", () => {
    expect(readSolvedAnswer('{"answer":"c"}')).toBe("c");
    expect(readSolvedAnswer("b")).toBe("b");
    expect(readSolvedAnswer('```json\n{"answer":"d"}\n```')).toBe("d");
    expect(readSolvedAnswer("je pense que c'est b")).toBeNull();
  });
});

describe("la chaîne complète", () => {
  it("garde N questions et compte les rebuts", async () => {
    generationText = JSON.stringify({
      items: [
        question("Combien font 2 + 3 ?"),
        question("Combien font 4 + 1 ?"),
        question("Combien font 3 + 2 ?"),
        question("Combien font 1 + 4 ?"),
        question("Combien font 5 + 0 ?"),
        // Un candidat hors schéma : 2 options au lieu de 4.
        { prompt: "Cassé", options: [{ id: "a", text: "x" }], correctOption: "a" },
        // Un doublon EXACT d'une question du catalogue.
        question("Combien vaut un demi ?"),
      ],
    });

    const outcome = (await runForge({ size: 5, difficulty: 2 })) as {
      ok: boolean;
      kept: number;
      discarded: number;
    };

    expect(outcome.ok).toBe(true);
    expect(outcome.kept).toBe(5);
    // Le candidat cassé + le doublon du catalogue.
    expect(outcome.discarded).toBe(2);
  });

  it("appelle la double résolution UNE fois par candidat retenu, sans énergie", async () => {
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?"), question("C ?"), question("D ?"), question("E ?")],
    });
    await runForge({ size: 5, difficulty: 2 });

    const solves = calls.filter((c) => c.feature === "forge_solve");
    expect(solves).toHaveLength(5);
    // L'énergie est débitée UNE fois, à la génération : un quiz coûte 3
    // d'énergie, pas 3 + une par question (R-18).
    expect(solves.every((c) => c.energyCost === 0)).toBe(true);
    // La surface d'ACCÈS reste `forge` : le porteur active « la Forge », pas
    // « la seconde moitié de la Forge ».
    expect(solves.every((c) => c.accessFeature === "forge")).toBe(true);
  });

  it("un DÉSACCORD de double-solve met le candidat au rebut", async () => {
    generationText = JSON.stringify({
      items: [
        question("A ?"),
        question("B ?"),
        question("C ?"),
        question("D ?"),
        question("E ?"),
        question("F ?"),
        question("G ?"),
      ],
    });
    // Le second candidat est résolu « c » alors que sa clé annonce « b ».
    solveAnswers = ["b", "c", "b", "b", "b", "b", "b"];

    const outcome = (await runForge({ size: 5, difficulty: 2 })) as {
      ok: boolean;
      kept: number;
      discarded: number;
    };
    expect(outcome.ok).toBe(true);
    expect(outcome.discarded).toBe(1);
  });

  it("échoue HONNÊTEMENT quand le quorum n'est pas atteint", async () => {
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?")],
    });
    const outcome = (await runForge({ size: 5, difficulty: 2 })) as {
      ok: boolean;
      code: string;
    };
    expect(outcome).toEqual({ ok: false, code: "AI_FORGE_NO_QUORUM" });
    // Rien n'est écrit : mieux vaut pas de quiz qu'un quiz de trois questions
    // quand l'élève en a demandé cinq.
    expect(rpcCalls.some((c) => c.fn === "create_forged_quiz")).toBe(false);
  });

  it("refuse sans rien dépenser quand le quota du jour est épuisé (R-18)", async () => {
    quotaLeft = 0;
    generationText = JSON.stringify({ items: [] });
    const outcome = (await runForge({ size: 5, difficulty: 2 })) as { ok: boolean; code: string };
    expect(outcome).toEqual({ ok: false, code: "AI_FORGE_QUOTA" });
    expect(calls).toHaveLength(0);
  });

  it("refuse quand la sortie du modèle n'est pas exploitable", async () => {
    generationText = "Voilà tes questions !";
    const outcome = (await runForge({ size: 5, difficulty: 2 })) as { ok: boolean; code: string };
    expect(outcome).toEqual({ ok: false, code: "AI_OUTPUT_REJECTED" });
  });
});

describe("R-18bis — la vérification coupée ne devient jamais nulle", () => {
  it("échantillonne 20 % des candidats quand le porteur l'a coupée", async () => {
    doubleSolve = false;
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?"), question("C ?"), question("D ?"), question("E ?")],
    });

    const outcome = (await runForge({ size: 5, difficulty: 2 })) as { ok: boolean };
    expect(outcome.ok).toBe(true);

    const solves = calls.filter((c) => c.feature === "forge_solve");
    // Un candidat sur cinq. Sans cet échantillon, plus de taux de rebut — donc
    // plus d'avertissement R-19, et un mauvais modèle devient indétectable.
    expect(solves).toHaveLength(1);
  });

  it("étiquette le quiz `verified = false` — l'étiquette voyage avec le CONTENU", async () => {
    doubleSolve = false;
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?"), question("C ?"), question("D ?"), question("E ?")],
    });
    await runForge({ size: 5, difficulty: 2 });

    const write = rpcCalls.find((c) => c.fn === "create_forged_quiz");
    // R-18bis.2 : « chaque question d'un quiz produit sans vérification affiche
    // "non vérifié" AU MOMENT OÙ ELLE EST JOUÉE ». Donc le drapeau est stocké.
    expect(write?.args.p_verified).toBe(false);
  });

  it("étiquette `verified = true` quand la vérification est complète", async () => {
    doubleSolve = true;
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?"), question("C ?"), question("D ?"), question("E ?")],
    });
    await runForge({ size: 5, difficulty: 2 });
    expect(rpcCalls.find((c) => c.fn === "create_forged_quiz")?.args.p_verified).toBe(true);
  });
});

describe("ce que l'écriture porte", () => {
  it("journalise le rebut, le modèle réel et la langue de la MATIÈRE", async () => {
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?"), question("C ?"), question("D ?"), question("E ?")],
    });
    await runForge({ size: 5, difficulty: 3 });

    expect(rpcCalls.find((c) => c.fn === "create_forged_quiz")?.args).toMatchObject({
      p_lang: "fr", // é11 R-3 : jamais la langue de l'interface
      p_difficulty: 3,
      p_requested: 5,
      p_model: "claude-haiku-4-5", // R-13 : le modèle RÉEL
      p_scope: "chapter",
    });
  });

  it("les items stockés portent un identifiant stable q1…qN", async () => {
    generationText = JSON.stringify({
      items: [question("A ?"), question("B ?"), question("C ?"), question("D ?"), question("E ?")],
    });
    await runForge({ size: 5, difficulty: 2 });

    const payload = rpcCalls.find((c) => c.fn === "create_forged_quiz")?.args.p_payload as {
      items: { id: string }[];
    };
    expect(payload.items.map((i) => i.id)).toEqual(["q1", "q2", "q3", "q4", "q5"]);
  });
});
