import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";

/**
 * Duel feature — server functions (étude 05, lot 3). Thin wrappers over the
 * lot-2 SECURITY DEFINER RPCs (match_duel / submit_duel_answer / get_duel_state)
 * plus two direct participant-scoped reads (queue leave, history, the frozen
 * question set). Scoring/matchmaking/finalize stay 100% server-side; the client
 * never sees the answer key before the duel is finished (R-3/R-6).
 *
 * How the play screen gets its questions (design note — the lot-2 RPCs expose
 * prompts only in the post-game `review`): a participant may read their own
 * `duels.question_ids` (participant RLS) and the KEY-MASKED `questions` columns
 * (`id/prompt/options/question_type` are granted; `correct_option`,`answer_key`,
 * `explanation`,`distractor_tags` are column-revoked). So `getDuelQuestions`
 * fetches the frozen set with no key leak — R-6 holds without a new RPC.
 */

export type DuelReviewItem = {
  questionId: string;
  prompt: string;
  correctChoice: string | null;
  explanation: string | null;
};

export type DuelState = {
  duelId: string;
  status: "pending" | "active" | "finished" | "expired";
  total: number;
  myAnswered: number;
  myScore: number;
  opponentAnswered: number;
  opponentFinished: boolean;
  /** The opponent's FINAL score — revealed only once the duel is settled (R-3
   *  keeps it null while active); powers the recap's win/loss/draw verdict. */
  opponentScore: number | null;
  review: DuelReviewItem[] | null;
};

export type DuelQuestion = {
  id: string;
  prompt: string;
  options: { id: string; text: string }[];
  questionType: string;
};

export type DuelSubmitResult = {
  answered: number;
  total: number;
  finished: boolean;
  tooFast: boolean;
};

export type DuelHistoryEntry = {
  duelId: string;
  status: "pending" | "active" | "finished" | "expired";
  createdAt: string;
  total: number;
  myScore: number;
  myFinished: boolean;
};

export type DuelLeagueRow = {
  rank: number;
  displayName: string | null;
  heroClass: string | null;
  avatarTier: number;
  points: number;
  wins: number;
  played: number;
  tier: string;
  isMe: boolean;
};

export type DuelLastAward = {
  weekStart: string;
  tier: string;
  rank: number;
  points: number;
  coins: number;
} | null;

const DUEL_STATUSES = ["pending", "active", "finished", "expired"] as const;
const asStatus = (v: unknown): DuelState["status"] =>
  DUEL_STATUSES.includes(v as DuelState["status"]) ? (v as DuelState["status"]) : "pending";

function parseDuelState(value: unknown): DuelState {
  if (!value || typeof value !== "object") throw new Error("Unexpected duel state response.");
  const row = value as Record<string, unknown>;
  const review = Array.isArray(row.review)
    ? row.review
        .filter((r): r is Record<string, unknown> => !!r && typeof r === "object")
        .map((r) => ({
          questionId: typeof r.questionId === "string" ? r.questionId : "",
          prompt: typeof r.prompt === "string" ? r.prompt : "",
          correctChoice: typeof r.correctChoice === "string" ? r.correctChoice : null,
          explanation: typeof r.explanation === "string" ? r.explanation : null,
        }))
    : null;
  return {
    duelId: typeof row.duelId === "string" ? row.duelId : "",
    status: asStatus(row.status),
    total: Number(row.total ?? 0),
    myAnswered: Number(row.myAnswered ?? 0),
    myScore: Number(row.myScore ?? 0),
    opponentAnswered: Number(row.opponentAnswered ?? 0),
    opponentFinished: row.opponentFinished === true,
    opponentScore: null,
    review,
  };
}

function parseSubmitResult(value: unknown): DuelSubmitResult {
  if (!value || typeof value !== "object") throw new Error("Unexpected duel answer response.");
  const row = value as Record<string, unknown>;
  return {
    answered: Number(row.answered ?? 0),
    total: Number(row.total ?? 0),
    finished: row.finished === true,
    tooFast: row.tooFast === true,
  };
}

/**
 * US-1: join the matchmaking queue and try to pair immediately. Returns the new
 * duel id when paired, or `null` when still waiting (a normal state — the hub
 * polls / re-invokes). match_duel is server-authoritative and idempotent on the
 * queue (PK user_id).
 */
export const matchDuel = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    if (await isRateLimited(supabase, `duel_match_${userId}`, 20, 60_000)) {
      throw new Error("Trop de tentatives d'appariement. Patiente un instant.");
    }
    const { data, error } = await supabase.rpc("match_duel");
    if (error) {
      failWithClientError(
        "duel.matchDuel: match_duel RPC failed",
        error,
        "Impossible de rejoindre la file des duels.",
      );
    }
    return { duelId: typeof data === "string" && data.length > 0 ? data : null };
  });

/** US-1: leave the queue (owner-only DELETE — RLS scopes it to the caller). */
export const leaveDuelQueue = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const { error } = await supabase.from("duel_queue").delete().eq("user_id", userId);
    if (error) {
      failWithClientError(
        "duel.leaveDuelQueue: delete failed",
        error,
        "Impossible de quitter la file.",
      );
    }
    return { ok: true };
  });

/**
 * Close/abandon an ACTIVE duel the caller is in. Fair settlement is server-side
 * (finalize_duel): if the caller already finished they win by forfait against a
 * no-show; if they hadn't finished they get nothing. Frees the active-duel cap.
 */
export const forfeitDuel = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ duelId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("forfeit_duel", { p_duel: data.duelId });
    if (error) {
      failWithClientError(
        "duel.forfeitDuel: forfeit_duel RPC failed",
        error,
        "Impossible d'abandonner le duel.",
      );
    }
    return { ok: true };
  });

/** US-3/US-5: the polled duel snapshot (progress + review once finished). */
export const getDuelState = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ duelId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const { data: payload, error } = await supabase.rpc("get_duel_state", { p_duel: data.duelId });
    if (error) {
      failWithClientError(
        "duel.getDuelState: get_duel_state RPC failed",
        error,
        "Duel introuvable.",
      );
    }
    const state = parseDuelState(payload);
    // Reveal the opponent's FINAL score only once the duel is settled (R-3 keeps
    // it hidden while active). Participant RLS already permits reading the row.
    if (state.status === "finished" || state.status === "expired") {
      const { data: opp } = await supabase
        .from("duel_participants")
        .select("score")
        .eq("duel_id", data.duelId)
        .neq("user_id", userId)
        .maybeSingle();
      state.opponentScore = opp ? Number(opp.score ?? 0) : null;
    }
    return state;
  });

/**
 * US-2: the FROZEN question set for the play screen (prompt/options/type only —
 * no key, R-6). Read the participant-visible `duels.question_ids` then the
 * key-masked `questions` columns, reordered to the frozen order.
 */
export const getDuelQuestions = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ duelId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: duel, error: duelErr } = await supabase
      .from("duels")
      .select("question_ids")
      .eq("id", data.duelId)
      .maybeSingle();
    if (duelErr) {
      failWithClientError("duel.getDuelQuestions: duel read failed", duelErr, "Duel introuvable.");
    }
    const ids = duel?.question_ids ?? [];
    if (ids.length === 0) return { questions: [] as DuelQuestion[] };

    const { data: rows, error: qErr } = await supabase
      .from("questions")
      .select("id, prompt, options, question_type")
      .in("id", ids);
    if (qErr) {
      failWithClientError(
        "duel.getDuelQuestions: questions read failed",
        qErr,
        "Duel introuvable.",
      );
    }
    const byId = new Map((rows ?? []).map((r) => [r.id, r]));
    const questions: DuelQuestion[] = ids
      .map((id) => byId.get(id))
      .filter((r): r is NonNullable<typeof r> => !!r)
      .map((r) => ({
        id: r.id,
        prompt: r.prompt,
        options: Array.isArray(r.options) ? (r.options as DuelQuestion["options"]) : [],
        questionType: typeof r.question_type === "string" ? r.question_type : "mcq",
      }));
    return { questions };
  });

/** US-2/US-6: submit the next answer in the frozen order (server-scored). */
export const submitDuelAnswer = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        duelId: z.guid(),
        questionId: z.guid(),
        choice: z.string().min(1).max(MAX_CHOICE_LENGTH),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    if (await isRateLimited(supabase, `duel_answer_${userId}`, 60, 60_000)) {
      throw new Error("Trop de réponses envoyées. Ralentis un peu.");
    }
    const { data: payload, error } = await supabase.rpc("submit_duel_answer", {
      p_duel: data.duelId,
      p_question: data.questionId,
      p_choice: data.choice,
    });
    if (error) {
      failWithClientError(
        "duel.submitDuelAnswer: submit_duel_answer RPC failed",
        error,
        "Impossible de valider la réponse.",
      );
    }
    return parseSubmitResult(payload);
  });

/** US-7: the current week's league standings (top-N + the caller's own row). */
export const getDuelLeague = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("get_duel_league", { p_limit: 20 });
    if (error) {
      failWithClientError(
        "duel.getDuelLeague: get_duel_league RPC failed",
        error,
        "Impossible de charger la ligue.",
      );
    }
    const rows: DuelLeagueRow[] = (data ?? []).map((r) => ({
      rank: Number(r.rank ?? 0),
      displayName: typeof r.display_name === "string" ? r.display_name : null,
      heroClass: typeof r.hero_class === "string" ? r.hero_class : null,
      avatarTier: Number(r.avatar_tier ?? 1),
      points: Number(r.points ?? 0),
      wins: Number(r.wins ?? 0),
      played: Number(r.played ?? 0),
      tier: typeof r.tier === "string" ? r.tier : "bronze",
      isMe: r.is_me === true,
    }));
    return { rows };
  });

/** US-7: the caller's most recent end-of-week league award (owner RLS read). */
export const getDuelLastAward = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("duel_league_awards")
      .select("week_start, tier, rank, points, coins_awarded")
      .eq("user_id", userId)
      .order("week_start", { ascending: false })
      .limit(1)
      .maybeSingle();
    if (error) {
      failWithClientError("duel.getDuelLastAward: read failed", error, "");
    }
    const award: DuelLastAward = data
      ? {
          weekStart: data.week_start,
          tier: data.tier,
          rank: Number(data.rank ?? 0),
          points: Number(data.points ?? 0),
          coins: Number(data.coins_awarded ?? 0),
        }
      : null;
    return { award };
  });

/** US-1 hub: the caller's recent duels (participant RLS scopes the read). */
export const getDuelHistory = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("duel_participants")
      .select("score, finished_at, duels(id, status, created_at, question_ids)")
      .eq("user_id", userId)
      .order("duel_id", { ascending: false })
      .limit(20);
    if (error) {
      failWithClientError(
        "duel.getDuelHistory: read failed",
        error,
        "Impossible de charger l'historique.",
      );
    }
    const entries: DuelHistoryEntry[] = (data ?? [])
      .map((row) => {
        const duel = row.duels as unknown as {
          id: string;
          status: string;
          created_at: string;
          question_ids: string[];
        } | null;
        if (!duel) return null;
        return {
          duelId: duel.id,
          status: asStatus(duel.status),
          createdAt: duel.created_at,
          total: Array.isArray(duel.question_ids) ? duel.question_ids.length : 0,
          myScore: Number(row.score ?? 0),
          myFinished: row.finished_at != null,
        };
      })
      .filter((e): e is DuelHistoryEntry => e !== null)
      .sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1));
    return { entries };
  });
