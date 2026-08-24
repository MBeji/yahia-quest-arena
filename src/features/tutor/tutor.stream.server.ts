// `POST /api/tutor/stream` — la première route STREAMÉE du produit (é11 lot 3, D-7).
//
// POURQUOI UNE ROUTE ET PAS UNE SERVER FN
// ---------------------------------------------------------------------------
// Une server fn rend une valeur ; le chat rend un FLUX. Le point d'insertion est
// l'interception de pathname dans le `fetch()` de `src/server.ts`, avant le
// handler SSR — même mécanique que `/api/cron/notify` et `/sitemap.xml`, seule
// forme existante dans ce produit pour rendre une `Response` à `ReadableStream`.
//
// Pas de cookie ⇒ pas de surface CSRF ; `guardRequest` (bot-guard) s'applique
// déjà en amont dans `server.ts`.
//
// L'ORDRE DES GARDES EST LE CONTRAT, ET IL SE LIT DE HAUT EN BAS
// ---------------------------------------------------------------------------
//   1. auth            — un flux anonyme n'existe pas
//   2. schéma          — zod, comme toute server fn
//   3. can_use_tutor   — R-1, l'état des sessions fait foi
//   4. rate limit      — 10/min, EN PLUS de l'énergie (anti-rafale)
//   5. âge             — Q-6 : le champ libre commence au collège
//   6. bien-être       — R-6 : cette catégorie n'atteint JAMAIS le modèle
//   7. bornage         — R-5 : longueur, URL, vide
//   8. contexte        — R-2 : le cours, et rien d'autre (pas de clé : R-16)
//   9. streamAi        — é29 : la porte unique, même chemin d'argent que callAi
//  10. validateur      — §3.4 : la sortie est vérifiée AVANT d'être persistée
//
// Les gardes 5, 6 et 7 sont AVANT la garde 9, et c'est le point : aucune d'elles
// ne dépense d'énergie ni un centime. Un enfant qui écrit sa détresse ne doit
// pas voir son quota baisser pour avoir reçu une phrase gentille.

import { z } from "zod";

import { streamAi } from "@/features/ai";
import { TUTOR_FREE_TEXT_MAX } from "@/shared/constants/ai";
import { resolveSupabaseAuth } from "@/shared/integrations/supabase/auth-request";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import {
  allowsFreeText,
  boundFreeText,
  buildChatBlocks,
  buildSummaryBlocks,
  chatSystem,
  isWellbeingMessage,
  summarySystem,
  TUTOR_CHAT_INTENTS,
  type TutorChapterContext,
  type TutorMessage,
} from "./chat";
import { TUTOR_AGE_BANDS, TUTOR_LANGS, type TutorLang } from "./prompt";
import { validateTutorOutput } from "./validator";

/** Un fil dont le nombre de messages franchit ce palier gagne un résumé roulant. */
const SUMMARY_EVERY = 10;

const bodySchema = z.object({
  chapterId: z.guid(),
  intent: z.enum(TUTOR_CHAT_INTENTS),
  freeText: z.string().max(4000).optional(),
});

const chapterContextSchema = z.object({
  found: z.literal(true),
  chapter_id: z.string(),
  chapter_title: z.string(),
  chapter_summary: z.string().nullable(),
  lesson_excerpt: z.string().default(""),
  subject_title: z.string(),
  lang: z.enum(TUTOR_LANGS),
  age_band: z.enum(TUTOR_AGE_BANDS),
});

const threadSchema = z.object({
  thread_id: z.string(),
  summary: z.string().nullable(),
  messages: z.array(z.object({ role: z.string(), content: z.string() })).default([]),
  message_count: z.number().default(0),
});

const learnerSchema = z.object({
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

type StreamRpcClient = {
  rpc: (
    fn:
      | "can_use_tutor"
      | "get_tutor_chapter_context"
      | "get_tutor_learner_context"
      | "open_tutor_chapter_thread"
      | "append_tutor_message"
      | "set_tutor_thread_summary"
      | "check_rate_limit",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

/**
 * Les réponses fixes de la catégorie BIEN-ÊTRE (R-6).
 *
 * Elles sont ICI et non dans le catalogue i18n, pour une raison qui n'est pas de
 * commodité : la langue d'une réponse du tuteur est celle de la MATIÈRE (R-3),
 * pas celle de l'interface, et le catalogue i18n ne connaît que la seconde.
 *
 * Aucune ne diagnostique, aucune ne rassure à tort, aucune ne promet le secret :
 * chacune nomme un adulte de confiance. Et aucune ne déclenche de signal parent
 * automatique — Q-5 l'a tranché, la confiance de l'élève prime.
 */
const WELLBEING_REPLY: Record<TutorLang, string> = {
  fr: "Je vois que ça ne va pas fort, et je suis content que tu le dises. Moi je ne sais parler que de cours — mais un adulte en qui tu as confiance, lui, saura t'aider : un parent, ton professeur principal, l'infirmière ou le psychologue de ton établissement. Parle-lui aujourd'hui. Je reste là pour le chapitre quand tu voudras.",
  en: "I can see things are hard right now, and I am glad you said it. I only know how to talk about lessons — but an adult you trust will know how to help: a parent, your form teacher, the school nurse or counsellor. Talk to them today. I will be here for the chapter whenever you want.",
  ar: "أرى أنّ الأمور صعبة الآن، وسعيد لأنّك قلتها. أنا لا أعرف الحديث إلّا في الدروس — لكنّ شخصًا بالغًا تثق به يعرف كيف يساعدك: أحد والديك، أستاذك الرئيسيّ، أو ممرّضة المؤسّسة أو أخصّائيّها النفسيّ. تحدّث إليه اليوم. وأنا هنا من أجل الفصل متى شئت.",
};

function sseFrame(event: string, data: unknown): Uint8Array {
  return new TextEncoder().encode(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
}

/** Une réponse à un seul message : le flux existe, il n'a simplement qu'un morceau. */
function singleFrameStream(threadId: string, text: string): Response {
  const stream = new ReadableStream<Uint8Array>({
    start(controller) {
      controller.enqueue(sseFrame("token", { text }));
      controller.enqueue(sseFrame("done", { threadId, cached: true }));
      controller.close();
    },
  });
  return sseResponse(stream);
}

function errorResponse(code: string, status = 200): Response {
  // 200 avec une trame `error`, et non un statut HTTP : côté client, un flux SSE
  // qui échoue par le statut n'a pas de corps à lire, donc pas de CODE à
  // traduire — et l'écran ne saurait pas dire « reviens demain » plutôt que
  // « une erreur est survenue ». Les vrais statuts restent pour ce qui précède
  // le flux : 401, 405, 400.
  if (status !== 200) {
    return new Response(JSON.stringify({ code }), {
      status,
      headers: { "content-type": "application/json; charset=utf-8" },
    });
  }
  const stream = new ReadableStream<Uint8Array>({
    start(controller) {
      controller.enqueue(sseFrame("error", { code }));
      controller.close();
    },
  });
  return sseResponse(stream);
}

function sseResponse(stream: ReadableStream<Uint8Array>): Response {
  return new Response(stream, {
    status: 200,
    headers: {
      "content-type": "text/event-stream; charset=utf-8",
      "cache-control": "no-store, no-transform",
      connection: "keep-alive",
    },
  });
}

export async function handleTutorStream(request: Request): Promise<Response> {
  if (request.method !== "POST") return errorResponse("METHOD_NOT_ALLOWED", 405);

  // 1. L'auth, par le helper PARTAGÉ avec le middleware des server fns : deux
  //    vérifications de jeton qui divergent, c'est une porte qui finit par
  //    s'ouvrir moins fort que l'autre.
  const auth = await resolveSupabaseAuth(request);
  if (!auth.ok) return errorResponse("UNAUTHORIZED", 401);

  const client = auth.supabase as unknown as StreamRpcClient;
  const userId = auth.userId;

  // 2. Le schéma, comme toute server fn.
  let body: z.infer<typeof bodySchema>;
  try {
    body = bodySchema.parse(await request.json());
  } catch {
    return errorResponse("BAD_REQUEST", 400);
  }

  // 3. R-1 — la porte. `chapter` : hors de toute session active.
  const gate = await client.rpc("can_use_tutor", {
    p_scope: "chapter",
    p_chapter_id: body.chapterId,
  });
  const gateParsed = z.object({ allowed: z.boolean(), reason: z.string() }).safeParse(gate.data);
  if (gate.error || !gateParsed.success || !gateParsed.data.allowed) {
    return errorResponse(gateParsed.success ? gateParsed.data.reason : "UNKNOWN");
  }

  // 4. Anti-rafale, EN PLUS de l'énergie (§3.3). L'énergie borne la journée ; le
  //    limiteur borne la minute, et c'est lui qui tient devant un script.
  if (await isRateLimited(client, `tutor:${userId}`, 10, 60_000)) {
    return errorResponse("RATE_LIMITED");
  }

  // 8. Le contexte du chapitre — il porte la langue et la bande d'âge, donc il
  //    précède les gardes qui en dépendent.
  const ctxRes = await client.rpc("get_tutor_chapter_context", { p_chapter_id: body.chapterId });
  const ctxParsed = chapterContextSchema.safeParse(ctxRes.data);
  if (ctxRes.error || !ctxParsed.success) {
    logger.error("tutor.chat.context", {
      error: ctxRes.error ? errorMessage(ctxRes.error) : "shape",
    });
    return errorResponse("AI_UNKNOWN");
  }

  const chapter: TutorChapterContext = {
    chapterId: ctxParsed.data.chapter_id,
    chapterTitle: ctxParsed.data.chapter_title,
    chapterSummary: ctxParsed.data.chapter_summary,
    lessonExcerpt: ctxParsed.data.lesson_excerpt,
    subjectTitle: ctxParsed.data.subject_title,
    lang: ctxParsed.data.lang,
    ageBand: ctxParsed.data.age_band,
  };

  // 5. Q-6 — le champ libre commence au collège. Décidé sur la bande d'âge
  //    dérivée de la classe, côté SERVEUR : un client modifié ne contourne pas
  //    un âge.
  let freeText: string | null = null;
  if (body.intent === "free") {
    if (!allowsFreeText(chapter.ageBand)) return errorResponse("FREE_TEXT_NOT_ALLOWED");

    const bounded = boundFreeText(body.freeText ?? "");
    if (!bounded.ok) return errorResponse(`FREE_TEXT_${bounded.reason}`);
    freeText = bounded.text;

    // 6. R-6 — la catégorie bien-être n'atteint JAMAIS le modèle, et ne coûte
    //    rien. Le fil garde la trace : l'élève doit pouvoir relire ce qu'on lui
    //    a répondu, et personne d'autre n'en est prévenu (Q-5).
    if (isWellbeingMessage(freeText)) {
      const thread = await openThread(client, chapter);
      if (thread) {
        await appendMessage(client, thread.thread_id, "student", "chat", freeText);
        await appendMessage(
          client,
          thread.thread_id,
          "tutor",
          "wellbeing",
          WELLBEING_REPLY[chapter.lang],
        );
        logger.info("tutor.chat.wellbeing", { lang: chapter.lang });
        return singleFrameStream(thread.thread_id, WELLBEING_REPLY[chapter.lang]);
      }
      return errorResponse("AI_UNKNOWN");
    }
  }

  const thread = await openThread(client, chapter);
  if (!thread) return errorResponse("AI_UNKNOWN");

  const learnerRes = await client.rpc("get_tutor_learner_context");
  const learnerParsed = learnerSchema.safeParse(learnerRes.data);
  const learner = learnerParsed.success
    ? {
        gradeSlug: null,
        goal: learnerParsed.data.goal,
        levelBand: learnerParsed.data.level_band,
        streakBand: learnerParsed.data.streak_band,
        activeMisconceptions: learnerParsed.data.active_misconceptions.map((m) => ({
          tag: m.tag,
          label:
            (chapter.lang === "ar"
              ? m.label_ar
              : chapter.lang === "en"
                ? m.label_en
                : m.label_fr) ?? null,
        })),
        interests: learnerParsed.data.interests,
        verbosity: learnerParsed.data.verbosity,
      }
    : null;

  if (freeText) {
    await appendMessage(client, thread.thread_id, "student", "chat", freeText);
  }

  const blocks = buildChatBlocks({
    chapter,
    learner,
    intent: body.intent,
    freeText,
    window: thread.messages as TutorMessage[],
    summary: thread.summary,
  });

  // 9-10. La porte é29, puis le validateur. La sortie est vérifiée AVANT d'être
  //       persistée : ce qui entre dans le fil est ce qui a été validé.
  const stream = new ReadableStream<Uint8Array>({
    async start(controller) {
      let full = "";
      try {
        for await (const chunk of streamAi({
          studentUserId: userId,
          feature: "chat",
          tier: "fast",
          system: chatSystem(chapter.lang, chapter.ageBand),
          blocks,
        })) {
          if (chunk.type === "text") {
            full += chunk.text;
            controller.enqueue(sseFrame("token", { text: chunk.text }));
            continue;
          }

          if (chunk.type === "error") {
            controller.enqueue(sseFrame("error", { code: chunk.code }));
            controller.close();
            return;
          }

          const validated = validateTutorOutput(chunk.text || full, chapter.lang, chapter.ageBand);
          if (!validated.ok) {
            // Le flux a déjà montré du texte : on ne peut pas le reprendre. On
            // le DIT, et l'écran affiche l'avertissement sous la réponse plutôt
            // que de faire comme si de rien n'était.
            logger.info("tutor.rejected", { reason: validated.reason, feature: "chat" });
            controller.enqueue(sseFrame("error", { code: "AI_OUTPUT_REJECTED" }));
            controller.close();
            return;
          }

          await appendMessage(client, thread.thread_id, "tutor", "chat", validated.body);
          controller.enqueue(sseFrame("done", { threadId: thread.thread_id, cached: false }));
          controller.close();

          // Le résumé roulant, APRÈS avoir fermé le flux : l'élève n'attend pas
          // un appel qui ne le regarde pas.
          void maybeSummarize(client, thread, chapter.lang, userId, validated.body, freeText);
          return;
        }
      } catch (error) {
        logger.error("tutor.chat.stream", { error: errorMessage(error) });
        controller.enqueue(sseFrame("error", { code: "AI_UNKNOWN" }));
        controller.close();
      }
    },
  });

  return sseResponse(stream);
}

async function openThread(
  client: StreamRpcClient,
  chapter: TutorChapterContext,
): Promise<z.infer<typeof threadSchema> | null> {
  const res = await client.rpc("open_tutor_chapter_thread", {
    p_chapter_id: chapter.chapterId,
    p_lang: chapter.lang,
    p_age_band: chapter.ageBand,
  });
  const parsed = threadSchema.safeParse(res.data);
  if (res.error || !parsed.success) {
    logger.error("tutor.chat.thread", { error: res.error ? errorMessage(res.error) : "shape" });
    return null;
  }
  return parsed.data;
}

async function appendMessage(
  client: StreamRpcClient,
  threadId: string,
  role: string,
  kind: string,
  content: string,
): Promise<void> {
  const { error } = await client.rpc("append_tutor_message", {
    p_thread: threadId,
    p_role: role,
    p_kind: kind,
    p_content: content,
    p_advance_variant: false,
  });
  // Le fil est de l'auditabilité, pas de la pédagogie : l'élève a déjà sa
  // réponse. On la lui rend, et on garde la trace de l'échec.
  if (error) logger.error("tutor.chat.append", { error: errorMessage(error) });
}

/**
 * Le résumé roulant, tous les dix messages (§3.4).
 *
 * Il ne coûte AUCUNE énergie à l'élève : c'est un geste du serveur, pas une
 * demande de l'enfant, et le faire payer reviendrait à lui facturer notre borne
 * de mémoire. Un échec est silencieux — un fil sans résumé reste utilisable, il
 * oublie simplement plus vite.
 */
async function maybeSummarize(
  client: StreamRpcClient,
  thread: z.infer<typeof threadSchema>,
  lang: TutorLang,
  userId: string,
  tutorReply: string,
  studentMessage: string | null,
): Promise<void> {
  const count = thread.message_count + (studentMessage ? 1 : 0) + 1;
  if (count < SUMMARY_EVERY || count % SUMMARY_EVERY !== 0) return;

  const messages: TutorMessage[] = [
    ...(thread.messages as TutorMessage[]),
    ...(studentMessage ? [{ role: "student", content: studentMessage }] : []),
    { role: "tutor", content: tutorReply },
  ];

  try {
    let summary = "";
    for await (const chunk of streamAi({
      studentUserId: userId,
      feature: "chat",
      tier: "fast",
      system: summarySystem(lang),
      blocks: buildSummaryBlocks(messages, thread.summary),
      energyCost: 0,
    })) {
      if (chunk.type === "done") summary = chunk.text;
      if (chunk.type === "error") return;
    }
    if (summary) {
      await client.rpc("set_tutor_thread_summary", {
        p_thread: thread.thread_id,
        p_summary: summary,
      });
    }
  } catch (error) {
    logger.warn("tutor.chat.summary", { error: errorMessage(error) });
  }
}

/** Exporté pour les tests : la borne que l'écran doit refléter, pas re-décider. */
export const TUTOR_CHAT_FREE_TEXT_MAX = TUTOR_FREE_TEXT_MAX;
