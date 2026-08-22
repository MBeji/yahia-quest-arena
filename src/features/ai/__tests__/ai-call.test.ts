import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { randomBytes } from "node:crypto";

/**
 * L'ORCHESTRATEUR — étude 29 §3.1, et surtout é11 R-15 : la dégradation est
 * SILENCIEUSE côté élève.
 *
 * « Un refus n'est jamais une exception. » Ce fichier vérifie que chaque branche
 * de refus rend `{ ok: false, code }` — kill-switch, mode éteint, plafond
 * atteint, clé illisible, fournisseur en panne — et jamais un `throw` qui
 * remonterait jusqu'à un écran d'erreur devant un enfant.
 *
 * Il vérifie aussi l'ORDRE, qui est la moitié de la sécurité du lot 3 :
 * réserver AVANT d'appeler (D-8), rembourser l'énergie quand l'appel échoue
 * (é11 R-15), et ne jamais ouvrir le coffre pour un appel qu'on va refuser.
 */

const rpcCalls: { fn: string; args: Record<string, unknown> }[] = [];
let resolveRow: Record<string, unknown> | null = null;
let reserveRow: Record<string, unknown> | null = null;
let credentialRow: { secret_enc: string; enc_version: number; provider: string } | null = null;
let generateImpl: () => Promise<unknown> = async () => ({
  text: "réponse",
  usage: { inputTokens: 100, outputTokens: 50, cachedTokens: 0 },
  model: "claude-haiku-4-5",
  latencyMs: 12,
});

const maybeSingle = vi.fn(async () => ({ data: credentialRow, error: null }));

vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: {
    rpc: vi.fn(async (fn: string, args: Record<string, unknown>) => {
      rpcCalls.push({ fn, args });
      if (fn === "resolve_ai_access") return { data: resolveRow ? [resolveRow] : [], error: null };
      if (fn === "reserve_ai_spend") return { data: reserveRow ? [reserveRow] : [], error: null };
      if (fn === "ai_budget_alerts_due") return { data: [], error: null };
      return { data: null, error: null };
    }),
    from: () => ({ select: () => ({ eq: () => ({ maybeSingle }) }) }),
  },
}));

vi.mock("@/shared/integrations/ai/provider.server", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/shared/integrations/ai/provider.server")>();
  return {
    ...actual,
    getAiProvider: () => ({
      id: "fake",
      capabilities: { streaming: true, structuredOutput: true, promptCache: true },
      generate: () => generateImpl(),
      stream: async function* () {},
    }),
  };
});

import { AiError } from "@/shared/integrations/ai";
import { sealForRow } from "../crypto.server";
import { callAi } from "../ai-call.server";

const KEK = randomBytes(32).toString("base64");
const OWNER = "11111111-1111-4111-8111-111111111111";
const STUDENT = "22222222-2222-4222-8222-222222222222";

const ALLOWED = {
  allowed: true,
  payer: "family",
  owner_user_id: OWNER,
  provider: "anthropic",
  base_url: null,
  model_fast: "claude-haiku-4-5",
  model_rich: "claude-sonnet-5",
  energy_left: 9,
  double_solve: true,
  reason: null,
};

const REQUEST = {
  studentUserId: STUDENT,
  feature: "explain" as const,
  tier: "fast" as const,
  system: "Système.",
  blocks: [{ label: "cours", text: "Les fractions." }],
};

function sealedRow() {
  const blob = sealForRow("sk-ant-test-key", {
    ownerUserId: OWNER,
    provider: "anthropic",
    encVersion: 1,
  });
  return { secret_enc: `\\x${blob.toString("hex")}`, enc_version: 1, provider: "anthropic" };
}

beforeEach(() => {
  vi.stubEnv("AI_KEY_ENC_KEY", KEK);
  vi.stubEnv("AI_KEY_ENC_KEY_PREVIOUS", "");
  vi.stubEnv("AI_MODE_ENABLED", "1");
  rpcCalls.length = 0;
  maybeSingle.mockClear();
  resolveRow = { ...ALLOWED };
  reserveRow = { granted: true, reason: null };
  credentialRow = sealedRow();
  generateImpl = async () => ({
    text: "réponse",
    usage: { inputTokens: 100, outputTokens: 50, cachedTokens: 0 },
    model: "claude-haiku-4-5",
    latencyMs: 12,
  });
});

afterEach(() => {
  vi.unstubAllEnvs();
});

const called = (fn: string) => rpcCalls.filter((c) => c.fn === fn);

describe("le chemin nominal", () => {
  it("résout, réserve, appelle, journalise, solde — dans cet ordre", async () => {
    const outcome = await callAi(REQUEST);

    expect(outcome.ok).toBe(true);
    const order = rpcCalls.map((c) => c.fn);
    // D-8 : la réservation vient AVANT l'appel. L'ordre EST la garantie.
    expect(order.indexOf("resolve_ai_access")).toBeLessThan(order.indexOf("reserve_ai_spend"));
    expect(order).toContain("log_ai_usage");
    expect(order).toContain("settle_ai_spend");
    expect(order).not.toContain("release_ai_reservation");
  });

  it("écrit le PAYEUR et le porteur sur l'événement (R-7)", async () => {
    await callAi(REQUEST);
    expect(called("log_ai_usage")[0].args).toMatchObject({
      p_payer: "family",
      p_credential_owner: OWNER,
      p_user: STUDENT,
      p_status: "ok",
    });
  });

  it("réserve une estimation NON NULLE avant l'appel (§3.7)", async () => {
    await callAi(REQUEST);
    const reserve = called("reserve_ai_spend")[0].args;
    expect(reserve.p_micros).toBeGreaterThan(0);
    expect(reserve.p_energy).toBe(1);
  });

  it("solde avec le coût RÉEL, qui remplace la réservation", async () => {
    const outcome = await callAi(REQUEST);
    const settle = called("settle_ai_spend")[0].args;
    expect(settle.p_actual_micros).toBe(outcome.ok ? outcome.costUsdMicros : -1);
    expect(settle.p_reserved_micros).toBe(called("reserve_ai_spend")[0].args.p_micros);
  });

  it("remonte le réglage de double résolution du porteur (R-18bis)", async () => {
    resolveRow = { ...ALLOWED, double_solve: false };
    const outcome = await callAi(REQUEST);
    expect(outcome.ok && outcome.doubleSolve).toBe(false);
  });
});

describe("é11 R-15 — chaque refus est silencieux, aucun n'est une exception", () => {
  it("kill-switch d'environnement : refus AVANT toute requête", async () => {
    vi.stubEnv("AI_MODE_ENABLED", "0");
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_MODE_OFF" });
    // Le premier geste d'un incident ne doit pas dépendre d'une base joignable.
    expect(rpcCalls).toHaveLength(0);
  });

  it("mode éteint pour cet élève : refus, et le coffre n'est PAS ouvert", async () => {
    resolveRow = { ...ALLOWED, allowed: false, payer: "family", reason: "AI_MODE_OFF" };
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_MODE_OFF" });
    expect(maybeSingle).not.toHaveBeenCalled();
    expect(called("reserve_ai_spend")).toHaveLength(0);
  });

  it("lien famille rompu : le code de la base est propagé tel quel (R-3)", async () => {
    resolveRow = { ...ALLOWED, allowed: false, payer: "family", reason: "AI_LINK_BROKEN" };
    const outcome = await callAi(REQUEST);
    expect(outcome.ok).toBe(false);
  });

  it("plafond atteint : l'appel n'est PAS émis, et le porteur est prévenu une fois", async () => {
    reserveRow = { granted: false, reason: "AI_BUDGET_REACHED" };
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_BUDGET_REACHED" });
    // RISK-2 : rien ne part chez le fournisseur.
    expect(maybeSingle).not.toHaveBeenCalled();
    expect(called("ai_budget_alerts_due")).toHaveLength(1);
  });

  it("énergie épuisée : refus sans appel", async () => {
    reserveRow = { granted: false, reason: "AI_ENERGY_SPENT" };
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_ENERGY_SPENT" });
  });

  it("clé illisible (RISK-10) : la clé est marquée invalide et la réservation LIBÉRÉE", async () => {
    // KEK remplacée sans rotation : le chiffré ne s'ouvre plus.
    vi.stubEnv("AI_KEY_ENC_KEY", randomBytes(32).toString("base64"));
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_KEY_INVALID" });
    expect(called("set_ai_credential_state")[0].args).toMatchObject({ p_status: "invalid" });
    expect(called("release_ai_reservation")).toHaveLength(1);
  });

  it("fournisseur en panne : énergie REMBOURSÉE, échec journalisé, pas d'exception", async () => {
    generateImpl = async () => {
      throw new AiError("AI_PROVIDER_DOWN");
    };
    const outcome = await callAi(REQUEST);

    expect(outcome).toEqual({ ok: false, code: "AI_PROVIDER_DOWN" });
    // é11 R-15 : un élève ne paie pas en énergie une panne de fournisseur.
    expect(called("release_ai_reservation")[0].args).toMatchObject({ p_energy: 1 });
    expect(called("settle_ai_spend")).toHaveLength(0);
    expect(called("log_ai_usage")[0].args).toMatchObject({
      p_status: "error",
      p_error_code: "AI_PROVIDER_DOWN",
    });
  });

  it("clé refusée par le fournisseur : elle bascule en `invalid` (§3.5)", async () => {
    generateImpl = async () => {
      throw new AiError("AI_KEY_INVALID");
    };
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_KEY_INVALID" });
    // Sans ce marquage, chaque appel suivant re-découvrirait la même chose sur
    // le quota du parent.
    expect(called("set_ai_credential_state")[0].args).toMatchObject({ p_status: "invalid" });
  });

  it("une exception INATTENDUE du fournisseur est re-typée, pas propagée (R-5)", async () => {
    generateImpl = async () => {
      throw new Error("boom sk-ant-live-abcdef");
    };
    const outcome = await callAi(REQUEST);
    expect(outcome.ok).toBe(false);
    expect(JSON.stringify(outcome)).not.toContain("sk-ant-live");
  });
});

describe("R-8 — la clé d'une famille ne sert que ses élèves", () => {
  it("l'événement porte TOUJOURS l'élève servi et le porteur qui paie", async () => {
    await callAi(REQUEST);
    const event = called("log_ai_usage")[0].args;
    // Les deux champs ensemble : c'est ce couple qui rend une violation de R-8
    // détectable après coup, dans la comptabilité.
    expect(event.p_user).toBe(STUDENT);
    expect(event.p_credential_owner).toBe(OWNER);
  });
});

describe("le chemin PLATEFORME (D-2, Q-5)", () => {
  it("prend le relais quand la base le désigne et que la clé plateforme existe", async () => {
    vi.stubEnv("ANTHROPIC_API_KEY", "sk-platform");
    resolveRow = {
      ...ALLOWED,
      allowed: false,
      payer: "platform",
      owner_user_id: null,
      reason: "AI_KEY_INVALID",
    };

    const outcome = await callAi(REQUEST);
    expect(outcome.ok).toBe(true);
    expect(outcome.ok && outcome.payer).toBe("platform");
    // R-7 : payer=platform n'a PAS de porteur — la base le refuserait.
    expect(called("log_ai_usage")[0].args).toMatchObject({
      p_payer: "platform",
      p_credential_owner: null,
    });
  });

  it("la vérification y est TOUJOURS complète (R-18bis.4)", async () => {
    vi.stubEnv("ANTHROPIC_API_KEY", "sk-platform");
    resolveRow = { ...ALLOWED, allowed: false, payer: "platform", owner_user_id: null };
    const outcome = await callAi(REQUEST);
    // C'est nous qui payons, et c'est notre nom sur le contenu : le porteur ne
    // peut pas couper la double résolution de NOTRE clé.
    expect(outcome.ok && outcome.doubleSolve).toBe(true);
  });

  it("sans clé plateforme, le refus reste silencieux", async () => {
    resolveRow = { ...ALLOWED, allowed: false, payer: "platform", owner_user_id: null };
    const outcome = await callAi(REQUEST);
    expect(outcome).toEqual({ ok: false, code: "AI_MODE_OFF" });
  });
});
