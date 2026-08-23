// « DEMANDER AU PROF » — étude 11 lot 1, la première brique PÉDAGOGIQUE de l'IA.
//
// CE QUE CE FICHIER ORCHESTRE, ET CE QU'IL DÉLÈGUE
// ---------------------------------------------------------------------------
// Il orchestre la pédagogie : qui a le droit de demander (R-1), ce que le modèle
// a le droit de savoir (R-16), quel registre servir (R-7), ce qui est resservi
// depuis le pot commun (R-15.2), et ce qui est refusé en sortie (§3.4).
//
// Il ne décide RIEN de l'argent, de l'énergie, du fournisseur ni du modèle :
// `callAi()` (étude 29 lot 1) est la porte unique, et elle enchaîne dans une
// seule transaction la résolution d'accès, la réservation d'énergie et d'argent,
// l'appel, et la comptabilité. Q-1 l'a tranché — « il n'y a qu'un seul socle ».
//
// L'ORDRE DES ÉTAPES EST LE CONTRAT
// ---------------------------------------------------------------------------
//   1. can_use_tutor           R-1 — sinon rien ne se passe, et l'écran le dit
//   2. get_tutor_question_context  R-16 — la clé ne sort qu'après soumission
//   3. open_tutor_thread       R-7 — quel registre a déjà été servi ?
//   4. find_tutor_explanation  R-15.2 — le pot commun d'abord : GRATUIT
//   5. callAi                  é29 — et seulement ici on dépense
//   6. validateTutorOutput     §3.4 — un retry, puis dégradé
//   7. store + append          le cache et le fil
//
// L'étape 4 avant l'étape 5 n'est pas une optimisation : c'est la raison d'être
// du cache mutualisé. Une explication déjà payée par une autre famille sur la
// même question, la même erreur, la même langue et le même âge n'a aucune raison
// d'être repayée — et l'élève ne perd pas d'énergie pour elle.
//
// R-15, PARTOUT : ce fichier ne LÈVE jamais pour un refus métier. Un élève sans
// énergie, une clé invalide, un fournisseur en panne : chacun rend un état que
// l'écran sait afficher. Les exceptions sont réservées aux bugs.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { callAi } from "@/features/ai";
import { AI_CURATED_MODELS } from "@/shared/constants/ai";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import {
  buildExplainBlocks,
  tutorSystem,
  TUTOR_AGE_BANDS,
  TUTOR_INTERESTS,
  TUTOR_LANGS,
  TUTOR_VARIANTS,
  type TutorLang,
  type TutorLearnerContext,
  type TutorQuestionContext,
  type TutorVariant,
} from "./prompt";
import { allowsFreeText, type TutorMessage } from "./chat";
import { validateTutorOutput } from "./validator";

// Les RPC de ce lot ne sont pas encore dans les types générés (ils se
// régénèrent depuis la base, et la base ne les a pas avant la migration). Le
// contrat est donc figé ici, motif `exam.server.ts` / `ai-access.server.ts` —
// À SUPPRIMER à la prochaine régénération de `supabase/types.ts`.
type TutorRpcClient = {
  rpc: (
    fn:
      | "can_use_tutor"
      | "get_tutor_question_context"
      | "get_tutor_learner_context"
      | "open_tutor_thread"
      | "append_tutor_message"
      | "find_tutor_explanation"
      | "store_tutor_explanation"
      | "rate_tutor_message"
      | "set_tutor_prefs"
      | "get_tutor_prefs"
      | "set_tutor_plan_push"
      | "get_tutor_chapter_context"
      | "list_tutor_threads"
      | "get_tutor_thread",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

const langSchema = z.enum(TUTOR_LANGS);
const ageBandSchema = z.enum(TUTOR_AGE_BANDS);

const availabilitySchema = z.object({
  allowed: z.boolean(),
  reason: z.string(),
});

const questionContextSchema = z.object({
  question_id: z.string(),
  prompt: z.string(),
  options: z.array(z.object({ id: z.string(), text: z.string() })).default([]),
  selected_choice: z.string(),
  is_correct: z.boolean(),
  correct_option: z.string().nullable(),
  explanation: z.string().nullable(),
  misconception: z.string().nullable(),
  misconception_labels: z
    .object({ fr: z.string(), en: z.string(), ar: z.string() })
    .nullable()
    .optional(),
  chapter_id: z.string().nullable(),
  chapter_title: z.string(),
  chapter_summary: z.string().nullable(),
  lesson_excerpt: z.string().default(""),
  lang: langSchema,
  grade_label: z.string().nullable(),
  age_band: ageBandSchema,
});

const learnerContextSchema = z.object({
  grade_slug: z.string().nullable(),
  goal: z.string(),
  level_band: z.string(),
  streak_band: z.string(),
  active_misconceptions: z
    .array(
      z.object({
        tag: z.string(),
        label_fr: z.string().nullable().optional(),
        label_en: z.string().nullable().optional(),
        label_ar: z.string().nullable().optional(),
      }),
    )
    .default([]),
  interests: z.array(z.string()).default([]),
  verbosity: z.enum(["courte", "normale"]).default("normale"),
});

const threadSchema = z.object({
  thread_id: z.string(),
  variant_served: z.number(),
  resolved: z.boolean().nullable(),
});

const cacheHitSchema = z.object({
  body: z.string(),
  model: z.string(),
  shared: z.boolean(),
});

/** Ce que l'écran reçoit. Un refus est un ÉTAT, jamais une exception (R-15). */
export type TutorExplanation =
  | {
      readonly ok: true;
      readonly threadId: string;
      readonly messageIx: number;
      readonly body: string;
      readonly variant: TutorVariant;
      /** Reste-t-il un registre à servir ? Pilote le bouton « Explique autrement ». */
      readonly canReformulate: boolean;
      /** Vrai quand la réponse vient du pot commun : zéro appel, zéro énergie. */
      readonly cached: boolean;
      readonly lang: TutorLang;
    }
  | { readonly ok: false; readonly code: string };

/**
 * R-15.2 — l'entrée dans le pot commun. Un modèle hors de la liste curée produit
 * une explication PRIVÉE à son payeur : sans cette barrière, la clé la moins
 * chère du parc fixerait la qualité servie à tous les enfants.
 */
export function isCuratedModel(model: string): boolean {
  return Object.values(AI_CURATED_MODELS).some((models: readonly string[]) =>
    models.includes(model),
  );
}

/** R-7 — le registre à servir, depuis ce qui a déjà été servi. */
export function nextVariant(variantServed: number): TutorVariant | null {
  return TUTOR_VARIANTS[variantServed] ?? null;
}

function toQuestionContext(raw: z.infer<typeof questionContextSchema>): TutorQuestionContext {
  return {
    questionId: raw.question_id,
    prompt: raw.prompt,
    options: raw.options,
    selectedChoice: raw.selected_choice,
    correctOption: raw.correct_option,
    explanation: raw.explanation,
    misconception: raw.misconception,
    misconceptionLabels: raw.misconception_labels ?? null,
    chapterTitle: raw.chapter_title,
    chapterSummary: raw.chapter_summary,
    lessonExcerpt: raw.lesson_excerpt,
    lang: raw.lang,
    ageBand: raw.age_band,
  };
}

function toLearnerContext(
  raw: z.infer<typeof learnerContextSchema>,
  lang: TutorLang,
): TutorLearnerContext {
  return {
    gradeSlug: raw.grade_slug,
    goal: raw.goal,
    levelBand: raw.level_band,
    streakBand: raw.streak_band,
    activeMisconceptions: raw.active_misconceptions.map((m) => ({
      tag: m.tag,
      label: (lang === "ar" ? m.label_ar : lang === "en" ? m.label_en : m.label_fr) ?? null,
    })),
    interests: raw.interests,
    verbosity: raw.verbosity,
  };
}

/** R-1 — l'écran demande la porte avant d'afficher le bouton. */
export const getTutorAvailability = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ questionId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<{ allowed: boolean; reason: string }> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data: raw, error } = await client.rpc("can_use_tutor", {
      p_scope: "question",
      p_question_id: data.questionId,
    });
    if (error) {
      // Une porte qu'on n'arrive pas à interroger est une porte FERMÉE. Le
      // contraire ouvrirait le tuteur pendant un donjon sur une panne de RPC.
      logger.error("tutor.availability", { error: errorMessage(error) });
      return { allowed: false, reason: "UNKNOWN" };
    }
    const parsed = availabilitySchema.safeParse(raw);
    return parsed.success ? parsed.data : { allowed: false, reason: "UNKNOWN" };
  });

export const explainMistake = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        questionId: z.guid(),
        /** « Explique autrement » — sert le registre suivant (R-7). */
        again: z.boolean().default(false),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<TutorExplanation> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const userId = context.userId;

    // 1. R-1. La RPC re-vérifie de son côté ; on demande ici pour rendre un code
    //    parlant sans dépenser un appel.
    const gate = await client.rpc("can_use_tutor", {
      p_scope: "question",
      p_question_id: data.questionId,
    });
    const gateParsed = availabilitySchema.safeParse(gate.data);
    if (gate.error || !gateParsed.success || !gateParsed.data.allowed) {
      return { ok: false, code: gateParsed.success ? gateParsed.data.reason : "UNKNOWN" };
    }

    // 2. R-16. La clé et l'explication canonique n'existent qu'ici, et seulement
    //    parce que l'étape 1 est passée.
    const ctxRes = await client.rpc("get_tutor_question_context", {
      p_question_id: data.questionId,
    });
    const ctxParsed = questionContextSchema.safeParse(ctxRes.data);
    if (ctxRes.error || !ctxParsed.success) {
      logger.error("tutor.context", {
        error: ctxRes.error ? errorMessage(ctxRes.error) : "shape",
      });
      return { ok: false, code: "AI_UNKNOWN" };
    }
    const question = toQuestionContext(ctxParsed.data);

    // 3. R-7. Le fil dit quel registre a déjà été servi.
    const threadRes = await client.rpc("open_tutor_thread", {
      p_question_id: data.questionId,
      p_lang: question.lang,
      p_age_band: question.ageBand,
    });
    const threadParsed = threadSchema.safeParse(threadRes.data);
    if (threadRes.error || !threadParsed.success) {
      logger.error("tutor.thread", {
        error: threadRes.error ? errorMessage(threadRes.error) : "shape",
      });
      return { ok: false, code: "AI_UNKNOWN" };
    }
    // R-7 — quel registre servir, et faut-il en consommer un.
    //
    //   served = 0        première demande      → concret,      on avance
    //   again             registre suivant      → served,       on avance
    //   ni l'un ni l'autre  simple réouverture  → served − 1,   on N'AVANCE PAS
    //
    // La troisième ligne est celle qui compte : rouvrir le panneau de correction
    // doit RE-SERVIR ce qui a déjà été dit, pas brûler un registre. Sans elle, un
    // élève qui revient trois fois sur sa question a épuisé l'escalier sans avoir
    // jamais demandé « explique autrement ».
    const served = threadParsed.data.variant_served;
    const advance = data.again || served === 0;
    if (data.again && served >= TUTOR_VARIANTS.length) {
      return { ok: false, code: "TUTOR_VARIANTS_EXHAUSTED" };
    }
    const variant = nextVariant(advance ? served : served - 1) ?? "formel";
    const canReformulate = (advance ? served + 1 : served) < TUTOR_VARIANTS.length;

    const threadId = threadParsed.data.thread_id;
    const cacheKey = {
      p_question_id: data.questionId,
      p_misconception: question.misconception,
      p_lang: question.lang,
      p_age_band: question.ageBand,
      p_variant: variant,
    };

    // 4. R-15.2 — le pot commun. Gratuit, et donc AVANT toute dépense.
    const cacheRes = await client.rpc("find_tutor_explanation", cacheKey);
    const cached = cacheHitSchema.safeParse(cacheRes.data);
    if (!cacheRes.error && cached.success) {
      const appended = await appendTutorMessage(
        client,
        threadId,
        cached.data.body,
        data.again,
        advance,
      );
      return {
        ok: true,
        threadId,
        messageIx: appended,
        body: cached.data.body,
        variant,
        canReformulate,
        cached: true,
        lang: question.lang,
      };
    }

    // 5. Le pack élève, puis la porte é29. C'est le seul endroit où l'on dépense.
    const learnerRes = await client.rpc("get_tutor_learner_context");
    const learnerParsed = learnerContextSchema.safeParse(learnerRes.data);
    const learner = learnerParsed.success
      ? toLearnerContext(learnerParsed.data, question.lang)
      : null;

    const system = tutorSystem(question.lang, question.ageBand, variant);
    const blocks = buildExplainBlocks(question, learner);

    // 6. §3.4 — un retry, puis dégradé. Le retry est au MÊME tier : une sortie
    //    rejetée pour notation ou pour langue est un accident de génération, pas
    //    un manque de capacité — monter en gamme coûterait sans rien garantir.
    let lastCode = "AI_OUTPUT_REJECTED";
    for (let attempt = 0; attempt < 2; attempt += 1) {
      const outcome = await callAi({
        studentUserId: userId,
        feature: data.again ? "reformulate" : "explain",
        tier: "rich",
        system,
        blocks,
      });

      if (!outcome.ok) return { ok: false, code: outcome.code };

      const validated = validateTutorOutput(outcome.text, question.lang, question.ageBand);
      if (!validated.ok) {
        logger.info("tutor.rejected", {
          reason: validated.reason,
          model: outcome.model,
          attempt,
        });
        lastCode = "AI_OUTPUT_REJECTED";
        continue;
      }

      // 7. Le cache, puis le fil. `shared` se calcule ici et NULLE PART ailleurs.
      await (supabaseAdmin as unknown as TutorRpcClient).rpc("store_tutor_explanation", {
        ...cacheKey,
        p_body: validated.body,
        p_model: outcome.model,
        p_shared: outcome.payer === "family" ? isCuratedModel(outcome.model) : true,
        p_owner: outcome.payer === "family" ? userId : null,
      });

      const messageIx = await appendTutorMessage(
        client,
        threadId,
        validated.body,
        data.again,
        advance,
      );
      return {
        ok: true,
        threadId,
        messageIx,
        body: validated.body,
        variant,
        canReformulate,
        cached: false,
        lang: question.lang,
      };
    }

    return { ok: false, code: lastCode };
  });

async function appendTutorMessage(
  client: TutorRpcClient,
  threadId: string,
  body: string,
  again: boolean,
  advance: boolean,
): Promise<number> {
  const { data, error } = await client.rpc("append_tutor_message", {
    p_thread: threadId,
    p_role: "tutor",
    p_kind: again ? "reformulate" : "explain",
    p_content: body,
    p_advance_variant: advance,
  });
  if (error) {
    // Le fil est de l'auditabilité, pas de la pédagogie : l'élève a déjà son
    // explication. On la lui rend, et on garde la trace de l'échec.
    logger.error("tutor.append", { error: errorMessage(error) });
    return 0;
  }
  const parsed = z.object({ message_ix: z.number() }).safeParse(data);
  return parsed.success ? parsed.data.message_ix : 0;
}

/** R-17 — 👍/👎. Le 👎 propose « Explique autrement » côté écran. */
export const rateTutorMessage = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        threadId: z.guid(),
        messageIx: z.number().int().min(0),
        rating: z.union([z.literal(-1), z.literal(1)]),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<{ ok: boolean }> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { error } = await client.rpc("rate_tutor_message", {
      p_thread: data.threadId,
      p_message_ix: data.messageIx,
      p_rating: data.rating,
    });
    if (error) {
      logger.error("tutor.rate", { error: errorMessage(error) });
      return { ok: false };
    }
    return { ok: true };
  });

/**
 * Ce que l'écran de chapitre doit savoir AVANT d'afficher quoi que ce soit
 * (lot 3). Un seul aller-retour, qui répond à trois questions à la fois : la
 * porte est-elle ouverte (R-1), le champ libre est-il permis à cet âge (Q-6),
 * et dans quelle langue le tuteur répondra (R-3).
 *
 * Le champ libre est décidé ICI et pas dans l'écran : un client modifié ne
 * contourne pas un âge, et la route le re-vérifie de son côté.
 */
export type TutorChatEntry = {
  readonly allowed: boolean;
  readonly reason: string;
  readonly freeText: boolean;
  readonly lang: TutorLang;
};

export const getTutorChatEntry = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ chapterId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<TutorChatEntry> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const closed: TutorChatEntry = {
      allowed: false,
      reason: "UNKNOWN",
      freeText: false,
      lang: "fr",
    };

    const gate = await client.rpc("can_use_tutor", {
      p_scope: "chapter",
      p_chapter_id: data.chapterId,
    });
    const gateParsed = availabilitySchema.safeParse(gate.data);
    if (gate.error || !gateParsed.success) {
      // Une porte qu'on n'arrive pas à interroger est une porte FERMÉE.
      logger.error("tutor.chat.entry", { error: gate.error ? errorMessage(gate.error) : "shape" });
      return closed;
    }
    if (!gateParsed.data.allowed) return { ...closed, reason: gateParsed.data.reason };

    const ctxRes = await client.rpc("get_tutor_chapter_context", {
      p_chapter_id: data.chapterId,
    });
    const ctxParsed = z
      .object({ found: z.literal(true), lang: langSchema, age_band: ageBandSchema })
      .safeParse(ctxRes.data);
    if (ctxRes.error || !ctxParsed.success) return closed;

    return {
      allowed: true,
      reason: "OK",
      freeText: allowsFreeText(ctxParsed.data.age_band),
      lang: ctxParsed.data.lang,
    };
  });

/** US-9 — l'historique, en lecture seule. R-14 dans l'autre sens : l'élève relit. */
export type TutorThreadSummary = {
  readonly threadId: string;
  readonly scope: string;
  readonly chapterId: string | null;
  readonly title: string;
  readonly messageCount: number;
  readonly updatedAt: string;
};

export const getTutorHistory = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<TutorThreadSummary[]> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data, error } = await client.rpc("list_tutor_threads", { p_limit: 20 });
    if (error) {
      logger.warn("tutor.history", { error: errorMessage(error) });
      return [];
    }
    const parsed = z
      .array(
        z.object({
          thread_id: z.string(),
          scope: z.string(),
          chapter_id: z.string().nullable(),
          title: z.string(),
          message_count: z.number(),
          updated_at: z.string(),
        }),
      )
      .safeParse(data);
    if (!parsed.success) return [];
    return parsed.data.map((row) => ({
      threadId: row.thread_id,
      scope: row.scope,
      chapterId: row.chapter_id,
      title: row.title,
      messageCount: row.message_count,
      updatedAt: row.updated_at,
    }));
  });

export const getTutorThread = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ threadId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<{ messages: TutorMessage[] }> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data: raw, error } = await client.rpc("get_tutor_thread", { p_thread: data.threadId });
    if (error) {
      logger.warn("tutor.thread.read", { error: errorMessage(error) });
      return { messages: [] };
    }
    const parsed = z
      .object({
        found: z.boolean(),
        messages: z.array(z.object({ role: z.string(), content: z.string() })).default([]),
      })
      .safeParse(raw);
    return { messages: parsed.success && parsed.data.found ? parsed.data.messages : [] };
  });

/** Les préférences d'accompagnement, défauts compris (lot 2). */
export type TutorPrefs = {
  readonly interests: readonly string[];
  readonly verbosity: "courte" | "normale";
  readonly planPush: boolean;
};

const prefsSchema = z.object({
  interests: z.array(z.string()).default([]),
  verbosity: z.enum(["courte", "normale"]).default("normale"),
  planPush: z.boolean().default(false),
});

const DEFAULT_PREFS: TutorPrefs = { interests: [], verbosity: "normale", planPush: false };

export const getTutorPrefs = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<TutorPrefs> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data, error } = await client.rpc("get_tutor_prefs");
    if (error) {
      // Un réglage illisible retombe sur le DÉFAUT, jamais sur une erreur : la
      // page de paramétrage doit s'afficher même quand le tuteur est éteint.
      logger.warn("tutor.prefs.read", { error: errorMessage(error) });
      return DEFAULT_PREFS;
    }
    const parsed = prefsSchema.safeParse(data);
    return parsed.success ? parsed.data : DEFAULT_PREFS;
  });

/** US-7 — l'élève arme ou désarme son rappel du plan du jour. */
export const setTutorPlanPush = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ enabled: z.boolean() }).parse(d))
  .handler(async ({ data, context }): Promise<{ ok: boolean }> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { error } = await client.rpc("set_tutor_plan_push", { p_enabled: data.enabled });
    if (error) {
      logger.error("tutor.planPush", { error: errorMessage(error) });
      return { ok: false };
    }
    return { ok: true };
  });

export const setTutorPrefs = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        interests: z.array(z.enum(TUTOR_INTERESTS)).max(3),
        verbosity: z.enum(["courte", "normale"]),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<{ ok: boolean }> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { error } = await client.rpc("set_tutor_prefs", {
      p_interests: data.interests,
      p_verbosity: data.verbosity,
    });
    if (error) {
      logger.error("tutor.prefs", { error: errorMessage(error) });
      return { ok: false };
    }
    return { ok: true };
  });
