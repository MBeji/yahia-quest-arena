import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { MIN_SECONDS_PER_QUESTION, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
import { MAX_CHOICE_LENGTH } from "@/shared/lib/answer-formats";
import { assertAnswerFormats } from "@/features/quest/answer-format-guard";
import { logger } from "@/shared/lib/logger";
import type { UnlockedBadge } from "@/shared/types/gamification";
import type { Database, Json } from "@/shared/integrations/supabase/types";
import { resolveCorrectionVideo } from "./correction-video";
import { fetchSessionReveals } from "./quest.check.server";
import { mergeRevealedAnswers } from "./quest-reveals";
import {
  RECALL_LOCKED_MESSAGE,
  RECALL_NOT_ELIGIBLE_MESSAGE,
  fetchRecallQuestions,
  fetchRecallAvailability,
  buildAttemptReview,
  toPerQuestion,
} from "./quest.recall";
import type { AttemptReviewItem } from "./quest.recall";
import { isUnrestrictedViewer, openEveryGate } from "./quest.access";
import {
  arbitrateQuestOpenAnswers,
  canPlayOpenQuestions,
  filterOpenQuestions,
} from "./quest.open-questions";

/** Error message thrown when an exercise is locked behind its chapter quiz. */
export const QUIZ_LOCKED_MESSAGE =
  "Réussis d'abord le quiz de compréhension du chapitre pour débloquer cet exercice.";

/**
 * Thrown when a premium parcours' mission is started without an entitlement and
 * outside the free preview. The "Parcours premium" prefix is matched by the quest
 * UI to show the paywall; keep it stable.
 */
export const PARCOURS_LOCKED_MESSAGE =
  "Parcours premium : débloque ce parcours pour accéder à cette mission.";
/** Thrown when the resolved parcours is not yet available (coming soon). */
export const PARCOURS_COMING_SOON_MESSAGE =
  "Parcours premium : ce parcours sera bientôt disponible.";

/**
 * Recall mode (étude 17). The gate-signal → localized message mapping and the
 * data helpers live in the co-located `quest.recall.ts` module; re-exported here
 * so callers importing from `./quest.server` keep working.
 */
export { RECALL_LOCKED_MESSAGE, RECALL_NOT_ELIGIBLE_MESSAGE } from "./quest.recall";

/**
 * Le geste « m'entraîner » (A12) vit dans son propre module : `quest.server.ts`
 * atteignait la limite `max-lines`, et une server fn de six lignes n'avait pas à
 * la faire sauter. Re-exporté ici pour les appelants qui visent ce chemin.
 */
export { getTrainingForMisconception } from "./quest.training";

type ProfileSnapshot = Database["public"]["Tables"]["profiles"]["Row"];

/** Multiplier potion applied to a reward-earning attempt (null when none armed). */
export type PotionApplied = {
  itemCode: string;
  itemName: string;
  xpMultiplier: number;
  coinMultiplier: number;
};

type AtomicSubmitResponse = {
  /**
   * La session était DÉJÀ rendue : ce résultat est relu, pas recalculé.
   *
   * Le cas honnête que la RPC servait par un refus jusqu'à
   * 20260831130000 — la soumission aboutit, sa réponse se perd au retour. Les
   * champs de récompense sont alors neutres côté serveur (rien n'est crédité
   * deux fois) et le client s'en sert pour ne pas rejouer les animations.
   */
  replayed: boolean;
  correct: number;
  total: number;
  scorePct: number;
  xpEarned: number;
  coinsEarned: number;
  durationSeconds: number;
  /**
   * Prime de rapidité appliquée aux XP (mode boss uniquement) : 1 = aucune,
   * 1.5 = maximale. Décidée SERVEUR d'après sa propre mesure de durée — le
   * client ne fait que l'afficher.
   */
  speedBonus: number;
  tooFast: boolean;
  improved: boolean;
  profile: ProfileSnapshot | null;
  unlockedBadges: UnlockedBadge[];
  potionApplied: PotionApplied | null;
  /**
   * True when an armed retry shield suppressed this failed attempt's penalty (it
   * was consumed). The result UI nudges an immediate replay — the higher of the
   * two scores wins via the existing best-score eligibility gate.
   */
  retryShieldUsed: boolean;
  /** The session's scoring variant (étude 17): "classic" (default) or "recall". */
  variant: "classic" | "recall";
  /** Per-question verdicts, RECALL only (D-4); null in classic. */
  perQuestion: Array<{ questionId: string; isCorrect: boolean }> | null;
};

function toUnlockedBadges(value: unknown): UnlockedBadge[] {
  if (!Array.isArray(value)) return [];

  return value
    .map((entry) => {
      if (!entry || typeof entry !== "object") return null;

      const row = entry as Record<string, unknown>;
      if (
        typeof row.code !== "string" ||
        typeof row.name !== "string" ||
        typeof row.rarity !== "string"
      ) {
        return null;
      }

      return {
        code: row.code,
        name: row.name,
        rarity: row.rarity,
        iconName: typeof row.iconName === "string" || row.iconName === null ? row.iconName : null,
      };
    })
    .filter((badge): badge is UnlockedBadge => badge !== null);
}

function toPotionApplied(value: unknown): PotionApplied | null {
  if (!value || typeof value !== "object") return null;

  const row = value as Record<string, unknown>;
  if (typeof row.itemCode !== "string") return null;

  return {
    itemCode: row.itemCode,
    itemName: typeof row.itemName === "string" ? row.itemName : "",
    xpMultiplier: Number(row.xpMultiplier ?? 1),
    coinMultiplier: Number(row.coinMultiplier ?? 1),
  };
}

function parseAtomicSubmitResponse(payload: unknown): AtomicSubmitResponse {
  if (!payload || typeof payload !== "object") {
    throw new Error("Unexpected quest submission response.");
  }

  const row = payload as Record<string, unknown>;

  return {
    // Absent d'une RPC antérieure à 20260831130000 : `false` est exactement ce
    // qu'elle voulait dire, puisqu'elle ne rendait jamais de rejeu.
    replayed: row.replayed === true,
    correct: Number(row.correct ?? 0),
    total: Number(row.total ?? 0),
    scorePct: Number(row.scorePct ?? 0),
    xpEarned: Number(row.xpEarned ?? 0),
    coinsEarned: Number(row.coinsEarned ?? 0),
    durationSeconds: Number(row.durationSeconds ?? 0),
    // Une RPC antérieure à 20260816140000 ne renvoie pas le champ : 1, donc
    // « aucune prime », est exactement ce qu'elle faisait.
    speedBonus: Number(row.speedBonus ?? 1),
    tooFast: row.tooFast === true,
    improved: row.improved === true,
    profile:
      row.profile && typeof row.profile === "object" ? (row.profile as ProfileSnapshot) : null,
    unlockedBadges: toUnlockedBadges(row.unlockedBadges),
    potionApplied: toPotionApplied(row.potionApplied),
    retryShieldUsed: row.retryShieldUsed === true,
    // A missing/legacy shape (pre-lot-2 RPC) defaults to classic with no verdicts.
    variant: row.variant === "recall" ? "recall" : "classic",
    perQuestion: toPerQuestion(row.perQuestion),
  };
}

// ---------- Get a subject with chapters & exercises ----------
export const getSubject = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d) => z.object({ subjectId: z.string() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // La progression est un concept de COMPTE : l'anonyme n'en a aucune, et la RPC
    // ne lui est pas accordée (`GRANT ... TO authenticated`). Retour dégradé et
    // journalisé si elle échoue — une progression indisponible rend le hub
    // exactement à l'expérience anonyme, jamais une page cassée.
    //
    // ⭐ Elle REMPLACE `get_best_scores_by_exercise` pour cet écran, à
    // aller-retour constant, et c'est ce qui fait disparaître une divergence
    // réelle : cette RPC-là rend le meilleur score classique SANS regarder la
    // durée, quand la règle des étoiles exige en plus « non précipitée »
    // (`mission_is_counted`, étude 34 R-3). Une réussite expédiée à 65 % cochait
    // donc la mission au hub sans rien donner au grand livre. Le hub reçoit
    // maintenant `counted`, déjà tranché, et ne re-seuille plus rien.
    // (La RPC reste en base : d'autres lecteurs restent à inventorier, et sa
    // dépose serait une migration destructive — DoD §7, merge séparé.)
    //
    // Elle voyage dans le MÊME `Promise.all` que les requêtes de contenu (audit
    // perf L1) : elle n'a besoin que de `subjectId` + la session, donc attendre la
    // matière coûtait un aller-retour série sur chaque page connectée — et la
    // fonction SSR est épinglée à une région, donc un aller-retour n'est pas
    // gratuit. Compromis assumé : sur le chemin d'erreur rare où la matière ne
    // charge pas, on aura émis une RPC que l'ancien code aurait évitée.
    const progressPromise: Promise<Json | null> = userId
      ? Promise.resolve(
          supabase.rpc("get_subject_progress", { p_subject_id: data.subjectId }),
        ).then(
          (res) => {
            if (res.error) {
              logger.warn("quest.getSubject: get_subject_progress failed", {
                subjectId: data.subjectId,
                error: res.error.message,
              });
              return null;
            }
            return res.data ?? null;
          },
          (err: unknown) => {
            logger.warn("quest.getSubject: get_subject_progress threw", {
              subjectId: data.subjectId,
              error: errorMessage(err),
            });
            return null;
          },
        )
      : Promise.resolve(null);

    const [subj, chaps, exs, progress, unrestricted] = await Promise.all([
      supabase.from("subjects").select("*").eq("id", data.subjectId).single(),
      supabase.from("chapters").select("*").eq("subject_id", data.subjectId).order("display_order"),
      supabase
        .from("exercises")
        .select("*")
        .eq("subject_id", data.subjectId)
        .order("display_order"),
      progressPromise,
      // Compte de test (admin) : même aller-retour, pas un de plus — quest.access.ts.
      isUnrestrictedViewer(supabase, userId),
    ]);
    if (subj.error) {
      failWithClientError("quest.getSubject", subj.error, "Impossible de charger la matière.");
    }

    // Recall availability (étude 17) — resolved for EVERYONE, anon included
    // (override de R-9, 2026-07-15) : l'éligibilité est dérivée du contenu, donc
    // calculable sans session ; unlocked/best restent des concepts de compte
    // (false/null pour l'anonyme). Le hub affiche ainsi les missions Rappel
    // verrouillées même déconnecté. Graceful empty fallback dans le helper.
    const recall = await fetchRecallAvailability(supabase, data.subjectId);

    // Comprehension-quiz gate: a chapter's exercises stay locked until the
    // user passes that chapter's mode='quiz' exercise at/above the threshold.
    const exercises = exs.data ?? [];
    // The comprehension-quiz gate applies only to the school program (grade-bound
    // subjects). Non-school themes (culture-générale, muscle-cerveau/IQ, languages)
    // have no theory to validate, so their chapters are never quiz-gated.
    const isSchoolSubject =
      ((subj.data as { grade_id?: string | null } | null)?.grade_id ?? null) !== null;
    const quizExercises = exercises.filter((e) => e.mode === "quiz");
    const quizPassedByChapter: Record<string, boolean> = {};
    for (const quiz of quizExercises) {
      // Non-school chapters start unlocked; school chapters lock until the quiz passes.
      if (quiz.chapter_id) quizPassedByChapter[quiz.chapter_id] = !isSchoolSubject;
    }
    const quizIds = quizExercises.map((e) => e.id);
    if (isSchoolSubject && quizIds.length > 0 && userId && !unrestricted) {
      const { data: passedRows } = await supabase
        .from("attempts")
        .select("exercise_id,duration_seconds,total_count")
        .eq("user_id", userId)
        .in("exercise_id", quizIds)
        .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT);
      // A quiz only counts as passed if the qualifying attempt was not rushed
      // (>= 4s/question) — a fast random pass must not unlock the chapter.
      const passedQuizIds = new Set(
        (passedRows ?? [])
          .filter(
            (r) => (r.duration_seconds ?? 0) >= (r.total_count ?? 0) * MIN_SECONDS_PER_QUESTION,
          )
          .map((r) => r.exercise_id),
      );
      for (const quiz of quizExercises) {
        if (quiz.chapter_id && passedQuizIds.has(quiz.id)) {
          quizPassedByChapter[quiz.chapter_id] = true;
        }
      }
    }

    // Compte de test (admin) : la RPC de démarrage ne lui oppose aucune porte de
    // progression, le hub n'en affiche donc aucune (quest.access.ts).
    const gates = unrestricted
      ? openEveryGate({ quizPassedByChapter, recall })
      : { quizPassedByChapter, recall };

    // Parcours that owns this subject — powers the hub's level anchor + back link
    // (étude 15 lot 7, D-6 : the kicker shows the CLASS, not the RPG attribute, and
    // the hub gets a way back up to /niveau). Resolved for EVERYONE (anon included);
    // a resolution failure degrades to "no anchor", never a broken page.
    type ParcoursAnchorRow = {
      id: string;
      name_fr: string;
      name_en: string | null;
      name_ar: string | null;
      is_premium: boolean;
    };
    let parcoursRow: ParcoursAnchorRow | null = null;
    try {
      const themeId = (subj.data as { theme_id?: string | null }).theme_id ?? null;
      const gradeId = (subj.data as { grade_id?: string | null }).grade_id ?? null;
      if (themeId) {
        // resolve_subject_parcours matches grade_id with IS NOT DISTINCT FROM, so a
        // null grade is valid (grade-agnostic themes resolve their own parcours); the
        // generated arg type narrows p_grade to string, hence the cast on the nullable.
        const parcoursIdRes = await supabase.rpc("resolve_subject_parcours", {
          p_theme: themeId,
          p_grade: gradeId as string,
        });
        const parcoursId = (parcoursIdRes as { data?: string | null }).data ?? null;
        if (parcoursId) {
          const { data: p } = await supabase
            .from("parcours")
            .select("id,name_fr,name_en,name_ar,is_premium")
            .eq("id", parcoursId)
            .maybeSingle();
          parcoursRow = (p as ParcoursAnchorRow | null) ?? null;
        }
      }
    } catch (err) {
      logger.warn("quest.getSubject: parcours anchor fetch failed", {
        subjectId: data.subjectId,
        error: errorMessage(err),
      });
    }

    // Parcours access context for premium gating of missions on the page.
    // Assigned on every path below (both try branches + the catch's locked-safe default),
    // so it needs no initializer — and an unread one trips eslint's no-useless-assignment.
    let viewer: { level: number; isPremium: boolean; hasEntitlement: boolean };
    if (!userId) {
      // Anonymous visitor: the public catalogue is open (premium is being retired).
      viewer = { level: 0, isPremium: false, hasEntitlement: true };
    } else {
      try {
        const viewerProfile = await supabase
          .from("profiles")
          .select("level")
          .eq("id", userId)
          .maybeSingle();
        const level = viewerProfile.data?.level ?? 0;
        if (parcoursRow) {
          const isPremium = parcoursRow.is_premium ?? false;
          const entRes = isPremium
            ? await supabase.rpc("has_parcours_entitlement", {
                p_user: userId,
                p_parcours: parcoursRow.id,
              })
            : null;
          viewer = { level, isPremium, hasEntitlement: isPremium ? entRes?.data === true : true };
        } else {
          viewer = { level, isPremium: false, hasEntitlement: true };
        }
      } catch (err) {
        logger.warn("quest.getSubject: parcours access fetch failed", {
          subjectId: data.subjectId,
          error: errorMessage(err),
        });
        viewer = { level: 0, isPremium: true, hasEntitlement: false }; // safe default: show locked
      }
    }

    return {
      subject: subj.data,
      chapters: chaps.data ?? [],
      exercises,
      /**
       * La charge brute de `get_subject_progress` (JSONB) — étoiles de chapitre,
       * sceaux, effort, état de chaque mission. `null` pour l'anonyme et sur une
       * RPC en échec ; le hub la lit par `parseSubjectProgress`, qui retombe alors
       * sur l'expérience anonyme plutôt que de casser (étude 34 R-16).
       */
      progress,
      quizPassedByChapter: gates.quizPassedByChapter,
      // `unrestricted` est ce que le hub affiche (bandeau « accès test ») ; le droit
      // d'accès suit, la porte du parcours étant franchie elle aussi.
      viewer: { ...viewer, unrestricted, hasEntitlement: viewer.hasEntitlement || unrestricted },
      recall: gates.recall,
      parcours: parcoursRow
        ? {
            id: parcoursRow.id,
            name_fr: parcoursRow.name_fr,
            name_en: parcoursRow.name_en,
            name_ar: parcoursRow.name_ar,
          }
        : null,
    };
  });

// ---------- Get exercise + questions ----------
export const getExercise = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d) =>
    z
      .object({
        exerciseId: z.guid(),
        variant: z.enum(["classic", "recall"]).default("classic"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const isRecall = data.variant === "recall";
    const [ex, qs, unrestricted, openAllowed] = await Promise.all([
      supabase
        .from("exercises")
        .select(
          "*, subjects(id,name_fr,color_token,icon,content_language,grade_id), chapters(id,title,subject_id)",
        )
        .eq("id", data.exerciseId)
        .single(),
      // Classic questions carry `options`. In recall we never fetch them here —
      // the play set (prompt only, no options — R-1) comes from get_recall_questions.
      isRecall
        ? Promise.resolve({ data: null, error: null })
        : supabase
            .from("questions")
            .select("id,prompt,options,display_order,question_type")
            .eq("exercise_id", data.exerciseId)
            .order("display_order"),
      isUnrestrictedViewer(supabase, userId),
      // Étude 33 : les questions OUVERTES (`short_answer` — aucune proposition,
      // une réponse tapée) ne sont servies qu'à un élève dont le mode IA peut
      // JUGER une formulation imprévue. La base applique la même porte au
      // dénominateur du score, sinon une question retirée de l'écran resterait
      // dans le total, sans réponse, donc fausse.
      canPlayOpenQuestions(supabase, userId),
    ]);
    if (ex.error) {
      failWithClientError("quest.getExercise", ex.error, "Impossible de charger l'exercice.");
    }

    // Recall play set: prompt only, options empty by construction (the answer is
    // typed, never chosen — R-1). Rendered by the same 'mcq' input contract.
    const recallQuestions = isRecall ? await fetchRecallQuestions(supabase, data.exerciseId) : null;

    // Hint consumables are an account perk; anonymous practice has none. Each owned
    // unit = one reveal, so we sum the quantities (mirrors consume_hint's filter).
    // Recall never offers hints (R-11) — the point is to retrieve from memory.
    let hintCharges = 0;
    if (userId && !isRecall) {
      const { data: hintInv } = await supabase
        .from("inventory_items")
        .select("quantity, item:shop_items!inner(item_type, effect_payload)")
        .eq("student_user_id", userId)
        .in("shop_items.item_type", ["booster", "potion"]);
      for (const row of hintInv ?? []) {
        const item = (row as { item?: { effect_payload?: unknown } | null }).item;
        const payload =
          item?.effect_payload && typeof item.effect_payload === "object"
            ? (item.effect_payload as Record<string, unknown>)
            : {};
        if ("hints" in payload || "hintBoost" in payload) {
          hintCharges += Number((row as { quantity?: number }).quantity ?? 0);
        }
      }
    }

    // Direct unlock target for the comprehension-quiz gate: when a non-quiz
    // exercise is gated, the lock screen links straight to the chapter's quiz
    // instead of bouncing the student to the subject hub to hunt for it.
    let chapterQuizId: string | null = null;
    const exRow = ex.data as { chapter_id?: string | null; mode?: string | null } | null;
    if (exRow?.chapter_id && exRow.mode !== "quiz") {
      const { data: quizRow } = await supabase
        .from("exercises")
        .select("id")
        .eq("chapter_id", exRow.chapter_id)
        .eq("mode", "quiz")
        .maybeSingle();
      chapterQuizId = (quizRow as { id?: string } | null)?.id ?? null;
    }

    // The comprehension-quiz gate applies to SCHOOL subjects only (grade-bound):
    // a non-quiz exercise whose chapter has a quiz is gated until that quiz is
    // passed. Non-school themes leave grade_id NULL -> never gated. Computed here
    // so BOTH the connected (`/quest`) and anonymous (`/exercice`) players share
    // one definition of "is this locked behind the quiz?" — the connected start is
    // still enforced server-side in start_exercise_session; the anon player reads
    // this flag and checks the session-local pass state.
    const subjectGradeId =
      (ex.data as { subjects?: { grade_id?: string | null } | null } | null)?.subjects?.grade_id ??
      null;
    // Compte de test (admin) : jamais gaté — la RPC de démarrage dit la même chose.
    const quizGated = chapterQuizId !== null && subjectGradeId !== null && !unrestricted;

    return {
      exercise: ex.data,
      // Le Rappel n'est pas concerné : son jeu est fait de QCM maîtrisés
      // rejoués en saisie libre, et une `short_answer` n'y entre jamais
      // (é20 R-11). Le filtre porte sur le jeu CLASSIQUE, et lui seul.
      questions: recallQuestions ?? filterOpenQuestions(qs.data ?? [], openAllowed),
      hintCharges,
      chapterQuizId,
      quizGated,
      // Ouvre le navigateur de questions du lecteur (question-navigator.tsx).
      unrestricted,
      // Review video for the failure screen (étude 23 R-6) — server-resolved
      // here so BOTH registers (connected + anonymous) receive it.
      correctionVideo: await resolveCorrectionVideo(supabase, ex.data),
      variant: data.variant,
    };
  });

// ---------- Start a secure exercise session ----------
// The start gate is server-authoritative inside the start_exercise_session
// SECURITY DEFINER RPC (GAP-021): it enforces the per-parcours premium gate and
// the school comprehension-quiz gate, then inserts the session as the owner —
// direct client INSERTs on exercise_sessions are revoked, so a session can no
// longer be forged to bypass either gate. This wrapper just invokes the RPC and
// maps its raised gate signals to the localized client messages.
export const startExerciseSession = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d) =>
    z
      .object({
        exerciseId: z.guid(),
        // Closed set (étude 17). Defaults to classic so every existing caller
        // (which sends no variant) keeps its exact behaviour.
        variant: z.enum(["classic", "recall"]).default("classic"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: rows, error } = await supabase.rpc("start_exercise_session", {
      p_exercise_id: data.exerciseId,
      p_variant: data.variant,
    });

    if (error) {
      // The RPC raises a stable token per gate; surface the matching message.
      const signal = error.message ?? "";
      if (signal.includes("PARCOURS_COMING_SOON")) {
        failWithClientError("quest.startExerciseSession", null, PARCOURS_COMING_SOON_MESSAGE);
      }
      if (signal.includes("PARCOURS_LOCKED")) {
        failWithClientError("quest.startExerciseSession", null, PARCOURS_LOCKED_MESSAGE);
      }
      if (signal.includes("QUIZ_LOCKED")) {
        failWithClientError("quest.startExerciseSession", null, QUIZ_LOCKED_MESSAGE);
      }
      if (signal.includes("RECALL_LOCKED")) {
        failWithClientError("quest.startExerciseSession", null, RECALL_LOCKED_MESSAGE);
      }
      if (signal.includes("RECALL_NOT_ELIGIBLE") || signal.includes("INVALID_VARIANT")) {
        failWithClientError("quest.startExerciseSession", null, RECALL_NOT_ELIGIBLE_MESSAGE);
      }
      failWithClientError(
        "quest.startExerciseSession",
        error,
        "Impossible de démarrer la session.",
      );
    }

    const session = rows?.[0];
    if (!session) {
      failWithClientError("quest.startExerciseSession", null, "Impossible de démarrer la session.");
    }

    return {
      sessionId: session.session_id,
      startedAt: session.started_at,
      // Une partie REPRISE (ou héritière) arrive avec ses réponses déjà corrigées,
      // définitives : le lecteur les repose au lieu de les laisser rejouer.
      revealed: await fetchSessionReveals(supabase, session.session_id),
    };
  });

// ---------- Reveal a hint (on-demand consumable) ----------
// Spends one charge of a hint consumable (booster_hint / potion_rappel) to reveal
// a hint for the given question. All ownership/charge validation + the atomic
// decrement happen inside the `consume_hint` SECURITY DEFINER RPC; the hint text
// comes from the question's `explanation` (null/empty → graceful fallback). This
// is purely informational: it grants no XP/coins and never touches scoring or the
// arm/slot system.
export const revealHint = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d) => z.object({ questionId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 10 reveals per 10 seconds (the client also guards against
    // re-spending on an already-revealed question).
    if (await isRateLimited(supabase, `hint_${userId}`, 10, 10_000)) {
      throw new Error("Too many hint requests. Please slow down.");
    }

    const { data: result, error } = await supabase.rpc("consume_hint", {
      p_question_id: data.questionId,
    });
    if (error) {
      failWithClientError("quest.revealHint", error, "Impossible de révéler un indice.");
    }

    const row = result && typeof result === "object" ? (result as Record<string, unknown>) : {};
    return {
      questionId: typeof row.questionId === "string" ? row.questionId : data.questionId,
      hint: typeof row.hint === "string" && row.hint.length > 0 ? row.hint : null,
      // A charge is spent only when the RPC actually revealed a hint; when the
      // question has no explanation, consumed is false and no charge was used.
      consumed: row.consumed === true,
      itemCode: typeof row.itemCode === "string" ? row.itemCode : "",
      itemName: typeof row.itemName === "string" ? row.itemName : "",
    };
  });

// ---------- Submit attempt ----------
export const submitAttempt = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d) =>
    z
      .object({
        sessionId: z.guid(),
        exerciseId: z.guid(),
        answers: z
          .array(
            z.object({ questionId: z.guid(), choice: z.string().min(1).max(MAX_CHOICE_LENGTH) }),
          )
          .min(1)
          .max(100),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 5 submissions per 10 seconds
    if (await isRateLimited(supabase, `submit_${userId}`, 5, 10_000)) {
      throw new Error("Too many submissions. Please slow down.");
    }

    await assertAnswerFormats(supabase, "quest.submitAttempt", data.exerciseId, data.answers);
    // Les réponses FIGÉES par la correction immédiate l'emportent sur le payload. Le
    // barème SQL l'impose de toute façon ; les réunir ici garde l'arbitrage et la
    // correction de fin de partie d'accord avec la note (20260929120000).
    const answers = mergeRevealedAnswers(
      data.answers,
      await fetchSessionReveals(supabase, data.sessionId),
    );

    // Comprehension quizzes are validated by the student alone: we never return
    // the correct answers / explanations for a quiz, so they cannot be memorised
    // and the quiz re-passed blindly. Practice/boss get the full end-of-quest
    // correction, built AFTER submit from the get_attempt_review SECURITY DEFINER
    // RPC (the answer key is no longer client-readable — GAP-020).
    const { data: exerciseRow } = await supabase
      .from("exercises")
      .select("mode")
      .eq("id", data.exerciseId)
      .single();
    const isQuiz = (exerciseRow as { mode?: string } | null)?.mode === "quiz";

    // La forme de la correction est celle que `buildAttemptReview` produit — on la
    // réutilise au lieu de la redéclarer, sinon un champ ajouté là-bas (le tag de
    // misconception d'A1.2) se perd silencieusement ici.
    type ReviewItem = AttemptReviewItem;
    // Ensure today's daily objective & this week's weekly quest rows exist
    // before the atomic RPC increments them (they are created on demand, so a
    // first-of-the-day submission isn't lost). Best-effort: never block a submit.
    await supabase.rpc("ensure_daily_weekly_goals", { p_user: userId });

    // Étude 33 — LE FILET, avant la note et pas après. Les réponses libres que
    // l'ensemble { canonique } ∪ `acceptedAnswers` a REFUSÉES passent devant un
    // juge, qui peut renverser le refus (jamais l'inverse : il ne voit pas les
    // acceptations). Le verdict s'écrit en base ; c'est la RPC ci-dessous qui
    // le lit, une seule fois, et qui reste le seul barème.
    //
    // Ce `await` est ce que l'élève attend en plus devant son écran de
    // validation — et seulement quand une de ses réponses libres a été refusée,
    // c'est-à-dire rarement, et précisément dans le cas où il avait peut-être
    // raison. Une panne ici ne coûte rien : le verdict déterministe tient.
    await arbitrateQuestOpenAnswers(userId, answers);

    const { data: submitData, error: submitErr } = await supabase.rpc("submit_exercise_attempt", {
      p_session_id: data.sessionId,
      p_exercise_id: data.exerciseId,
      p_answers: answers,
    });
    if (submitErr) {
      failWithClientError(
        "quest.submitAttempt",
        submitErr,
        "Impossible d'enregistrer votre tentative.",
      );
    }

    const atomic = parseAtomicSubmitResponse(submitData);
    // The correction is served only for non-quiz exercises, so the answer key is
    // never client-readable before/around answering (GAP-020). In recall its
    // verdicts come from the submit RPC (D-4), assembled in the shared helper.
    const review: ReviewItem[] = isQuiz
      ? []
      : await buildAttemptReview(supabase, data.sessionId, answers, {
          isRecall: atomic.variant === "recall",
          perQuestion: atomic.perQuestion,
        });

    return {
      replayed: atomic.replayed,
      correct: atomic.correct,
      total: atomic.total,
      scorePct: atomic.scorePct,
      xpEarned: atomic.xpEarned,
      coinsEarned: atomic.coinsEarned,
      durationSeconds: atomic.durationSeconds,
      speedBonus: atomic.speedBonus,
      tooFast: atomic.tooFast,
      improved: atomic.improved,
      profile: atomic.profile,
      review,
      reviewHidden: isQuiz,
      unlockedBadges: atomic.unlockedBadges,
      potionApplied: atomic.potionApplied,
      retryShieldUsed: atomic.retryShieldUsed,
      variant: atomic.variant,
    };
  });
