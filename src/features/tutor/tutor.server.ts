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
//   7. store + append + lien  le cache, le fil, et de quoi ÉVINCER (é29 R-15.3)
//
// La troisième pièce de l'étape 7 est arrivée après les deux autres, et elle
// répare un trou : `tutor_feedback` porte un RANG dans un fil, pas l'identité de
// l'entrée de cache qui a produit le message. Un 👎 n'était donc imputable à
// rien, et rien ne sortait jamais du pot commun — pendant que l'entrée la plus
// servie restait la plus collante (`ORDER BY serve_count DESC`). Le lien est
// posé ici, sur les DEUX chemins (cache plein comme cache vide) ; l'éviction
// elle-même est en SQL, dans `rate_tutor_message`.
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
// Le pack élève : validation + choix de langue, deux gestes purs sortis d'ici (é30 lot 3bis).
import { learnerContextSchema, toLearnerContext } from "./learner-context";
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
  type TutorQuestionContext,
  type TutorVariant,
} from "./prompt";
import { allowsFreeText, type TutorMessage } from "./chat";
import { escalationStep, escalationStepFromAction, type TutorEscalationStep } from "./escalation";
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
      // é29 R-15.3 — le lien message → entrée de cache (migration 20260826120000).
      // `service_role` SEUL : c'est ce lien qui décide d'une éviction.
      | "record_tutor_explanation_serving"
      | "rate_tutor_message"
      | "set_tutor_prefs"
      | "get_tutor_prefs"
      | "set_tutor_plan_push"
      | "get_tutor_chapter_context"
      | "list_tutor_threads"
      | "get_tutor_thread"
      // Lot 4 — la boucle de compréhension (migration 20260823140000).
      | "get_tutor_mini_check"
      | "submit_tutor_mini_check"
      | "tutor_understanding_signal"
      | "escalate_tutor_thread",
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

const threadSchema = z.object({
  thread_id: z.string(),
  variant_served: z.number(),
  resolved: z.boolean().nullable(),
});

const cacheHitSchema = z.object({
  /**
   * R-15.3 — l'identité de l'entrée servie, pour que le 👎 qui suivra sache
   * QUOI évincer. OPTIONNELLE à dessein : la migration qui l'ajoute et ce code
   * partent dans le même merge, mais Vercel déploie et `db-migrate-prod`
   * applique en parallèle. Exiger la clé ferait échouer le `safeParse` pendant
   * la fenêtre — donc traiter un HIT comme un MISS et REPAYER l'explication.
   * Un lien manquant coûte une éviction ratée ; un cache manquant coûte de
   * l'argent à chaque correction.
   */
  id: z.guid().optional(),
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
 * R-15.2 — l'entrée dans le pot commun. La condition porte sur le MODÈLE, jamais
 * sur le payeur : é29 D-9 retire explicitement le payeur du calcul (« mutualisé,
 * quel que soit le payeur »), et R-15.2 ne connaît que la liste curée et le
 * validateur. Un modèle hors liste ne rejoint donc pas le pot commun, qu'il soit
 * payé par une famille ou par la plateforme — sans cette barrière, le modèle le
 * moins cher fixerait la qualité servie à tous les enfants.
 *
 * LE FOURNISSEUR NON PLUS NE COMPTE PAS, ET C'EST DÉLIBÉRÉ. `AI_CURATED_MODELS`
 * est indexée par fournisseur parce que l'écran s'en sert pour PROPOSER ; ce qui
 * décide de la qualité servie à un enfant, lui, est l'identité du MODÈLE — pas
 * le protocole qui l'a transporté. `claude-sonnet-5` servi par une passerelle
 * compatible OpenAI reste `claude-sonnet-5`, et Q-4 ouvre l'adresse à la saisie
 * libre exprès. Depuis #871 le chemin plateforme se configure de la même façon :
 * un test par fournisseur y viderait le pot commun de TOUT le parc sur une
 * question de transport — le symétrique exact du défaut fermé au §7.
 *
 * Ce que ce choix n'attrape pas, dit sans détour : un porteur qui pointe une
 * adresse à lui et déclare `claude-sonnet-5` entre dans le pot. Un test par
 * fournisseur ne l'attraperait pas davantage — il lui suffirait de déclarer
 * `gpt-5`, curé côté `openai_compatible` où l'adresse est libre par
 * construction. Le garde-fou contre une explication FAUSSE est ailleurs, et il
 * s'applique déjà : `validateTutorOutput` (é11 §3.4), avant l'écriture du §7.
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
      // R-15.3 — sur un HIT aussi, et surtout sur un HIT : c'est l'entrée
      // resservie en boucle qui fait le plus de dégâts quand elle est mauvaise.
      await recordServing(threadId, appended, cached.data.id ?? null);
      return {
        ok: true,
        threadId,
        messageIx: appended ?? 0,
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
      //
      //    R-15.2 VAUT POUR LES DEUX PAYEURS, Y COMPRIS LE CHEMIN PLATEFORME.
      //    Tant que la clé plateforme était câblée sur Anthropic, la question ne
      //    se posait pas : ses deux modèles étaient curés. Depuis #871 elle est
      //    agnostique, et son modèle est une variable d'environnement libre
      //    (`AI_PLATFORM_PROVIDER` / `AI_PLATFORM_MODEL_FAST|RICH`) : un partage
      //    inconditionnel laisserait un identifiant tapé dans Vercel fixer la
      //    qualité servie à TOUS les élèves — RISK-4 d'é29, atteint par l'autre
      //    porte. Pour verser un modèle plateforme au pot commun, on l'inscrit
      //    dans `AI_CURATED_MODELS` : une décision écrite et relue, pas un effet
      //    de bord de configuration. (À ne pas confondre avec R-18bis.4, qui
      //    force la vérification complète sur ce même chemin : « c'est notre nom
      //    sur le contenu » y ajoute une exigence, il n'en lève aucune.)
      //
      //    ET QUAND LE MODÈLE N'ENTRE PAS, ON N'ÉCRIT RIEN SUR CE CHEMIN. La
      //    réserve privée de R-15.2 appartient au PAYEUR, et le payeur plateforme
      //    n'a pas d'`owner_user_id` : `shared = false` avec `p_owner = NULL`
      //    produirait une ligne que `find_tutor_explanation` ne peut relire pour
      //    personne (`e.shared OR e.owner_user_id = v_user`) — morte à
      //    l'écriture, et comptée au dénominateur de `get_tutor_cache_stats`.
      const curated = isCuratedModel(outcome.model);
      // R-15.3 — l'entrée fraîchement écrite est déjà évinçable. Une explication
      // n'a pas besoin d'avoir vieilli dans le pot pour être mauvaise : le 👎 de
      // l'élève qui vient de la recevoir compte comme celui d'un autre.
      let servedId: string | null = null;
      if (curated || outcome.payer === "family") {
        const stored = await (supabaseAdmin as unknown as TutorRpcClient).rpc(
          "store_tutor_explanation",
          {
            ...cacheKey,
            p_body: validated.body,
            p_model: outcome.model,
            p_shared: curated,
            p_owner: outcome.payer === "family" ? userId : null,
          },
        );
        if (stored.error) {
          // L'élève a son explication ; c'est le cache qui a échoué, pas la
          // pédagogie. On le dit, et on ne lie rien à une ligne inexistante.
          logger.error("tutor.cache.store", { error: errorMessage(stored.error) });
        } else {
          const id = z.guid().safeParse(stored.data);
          servedId = id.success ? id.data : null;
        }
      } else {
        // Sans cette trace, « le pot commun ne se remplit plus » ne se lit que
        // sur un ratio qui baisse dans /admin/ia, des semaines plus tard. Avec
        // elle, le modèle en cause est nommé le jour où il est configuré.
        logger.info("tutor.cache.skipped", {
          reason: "PLATFORM_MODEL_NOT_CURATED",
          model: outcome.model,
        });
      }

      const messageIx = await appendTutorMessage(
        client,
        threadId,
        validated.body,
        data.again,
        advance,
      );
      await recordServing(threadId, messageIx, servedId);
      return {
        ok: true,
        threadId,
        messageIx: messageIx ?? 0,
        body: validated.body,
        variant,
        canReformulate,
        cached: false,
        lang: question.lang,
      };
    }

    return { ok: false, code: lastCode };
  });

/**
 * Le rang du message écrit, ou `null` si le fil n'a rien enregistré.
 *
 * ⚠️ LA DISTINCTION EST NEUVE, ET ELLE COMPTE. Cette fonction rendait `0` sur
 * échec — un rang parfaitement valide. Tant que le rang ne servait qu'à noter un
 * message, confondre « le message 0 » et « pas de message » ne coûtait qu'un 👍
 * mal rangé. Depuis R-15.3 ce rang DÉSIGNE une entrée de cache : lier l'entrée
 * qu'on vient de servir au message 0 d'un fil qui en compte déjà dix ferait
 * porter à une explication les 👎 d'une autre. `null` remonte donc jusqu'au
 * lien, qui s'abstient ; l'écran, lui, garde son `0` de repli.
 */
async function appendTutorMessage(
  client: TutorRpcClient,
  threadId: string,
  body: string,
  again: boolean,
  advance: boolean,
): Promise<number | null> {
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
    return null;
  }
  const parsed = z.object({ message_ix: z.number() }).safeParse(data);
  return parsed.success ? parsed.data.message_ix : null;
}

/**
 * R-15.3 — LE LIEN QUI MANQUAIT : ce message vient de CETTE entrée de cache.
 *
 * Sans lui, un 👎 ne porte que sur `(thread_id, message_ix)` — un rang dans un
 * fil — et l'entrée qui a produit la mauvaise explication reste dans le pot,
 * d'autant plus servie qu'elle l'a déjà été (`ORDER BY serve_count DESC`).
 *
 * ÉCRIT AVEC LE CLIENT ADMIN, comme le cache lui-même. La RPC n'est GRANT qu'à
 * `service_role` : si un client pouvait la joindre, il DÉSIGNERAIT l'entrée que
 * son propre 👎 va faire sortir du pot commun.
 *
 * Ne lève jamais et ne change rien à ce que reçoit l'élève : un lien perdu coûte
 * une éviction manquée, pas une explication.
 */
async function recordServing(
  threadId: string,
  messageIx: number | null,
  explanationId: string | null,
): Promise<void> {
  if (messageIx === null || !explanationId) return;
  const { error } = await (supabaseAdmin as unknown as TutorRpcClient).rpc(
    "record_tutor_explanation_serving",
    { p_thread: threadId, p_message_ix: messageIx, p_explanation: explanationId },
  );
  if (error) logger.error("tutor.serving", { error: errorMessage(error) });
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
// ---------------------------------------------------------------------------
// LOT 4 — LA BOUCLE DE COMPRÉHENSION (US-4, R-8).
// ---------------------------------------------------------------------------
// Aucune de ces trois fonctions n'appelle `callAi()`, et c'est le fait le plus
// important du lot : le mini-check et l'escalade sont 100 % DÉTERMINISTES.
// R-10 le demande — « le déterministe décide, le LLM rédige » — et ici le LLM ne
// rédige même pas : la question vient du stock, la correction de la base, et la
// phrase d'escalade du catalogue i18n.
//
// Conséquence directe : la surface `check` n'entre PAS dans `AI_LIVE_FEATURES`.
// L'y ajouter ouvrirait au parent un interrupteur qui n'allume rien — la faute
// que le bloc de doc de cette constante décrit mot pour mot.

const miniCheckSchema = z.object({
  served: z.boolean(),
  reason: z.string(),
  question_id: z.string().optional(),
  prompt: z.string().optional(),
  options: z.array(z.object({ id: z.string(), text: z.string() })).default([]),
  chapter_id: z.string().nullable().optional(),
  tag: z.string().nullable().optional(),
  lang: langSchema.optional(),
  match: z.enum(["tag", "competency"]).optional(),
});

const miniCheckGradeSchema = z.object({
  graded: z.boolean(),
  reason: z.string(),
  correct: z.boolean().optional(),
  correct_option: z.string().nullable().optional(),
  explanation: z.string().nullable().optional(),
  tag: z.string().nullable().optional(),
});

const understandingSignalSchema = z.object({
  tag: z.string(),
  signal_a: z.boolean(),
  signal_b: z.boolean(),
  signal_c: z.boolean(),
  recommended_level: z.number(),
});

const escalationSchema = z.object({
  escalation_level: z.number(),
  action: z.string().nullable(),
  // Volontairement `unknown` ICI : la forme dépend de la marche, et c'est
  // `toEscalationTarget` qui la lit avec le bon schéma.
  target: z.unknown().nullable(),
});

/** Ce que l'écran reçoit du mini-check : une question, ou une raison de ne rien montrer. */
export type TutorMiniCheck =
  | {
      ok: true;
      questionId: string;
      prompt: string;
      options: { id: string; text: string }[];
      tag: string | null;
      lang: TutorLang;
    }
  | { ok: false; code: string };

/** La correction d'un mini-check. Aucune récompense n'y figure — il n'y en a pas (R-11). */
export type TutorMiniCheckResult =
  | {
      ok: true;
      correct: boolean;
      correctOption: string | null;
      explanation: string | null;
      tag: string | null;
    }
  | { ok: false; code: string };

/**
 * LA CIBLE d'une marche — une union DISCRIMINÉE, pas un sac de clés.
 *
 * Deux raisons, et la première est mécanique : un `Record<string, unknown>` ne
 * franchit pas la frontière d'une server fn (le sérialiseur de TanStack Start
 * refuse `unknown`). La seconde vaut mieux : « montre le cours » et « reprends
 * ce prérequis » ne pointent pas vers la même chose, et un composant qui lit
 * `target.chapterId` sur une cible de prérequis doit rougir à la compilation,
 * pas rendre un lien mort.
 *
 * La marche `parentDigest` n'a PAS de cible : elle ne mène nulle part dans
 * l'application de l'élève, c'est le digest hebdomadaire qui la porte (Q-5).
 */
export type TutorEscalationTarget =
  | { kind: "lesson"; chapterId: string; chapterTitle: string; subjectId: string }
  | { kind: "prerequisite"; competency: string; labelFr: string; labelEn: string; labelAr: string }
  | {
      kind: "plan";
      exerciseId: string;
      exerciseTitle: string;
      chapterId: string;
      subjectId: string;
    };

/** La marche proposée après un échec, déjà traduite en clé i18n. */
export type TutorEscalation = {
  level: number;
  step: TutorEscalationStep;
  target: TutorEscalationTarget | null;
};

const lessonTargetSchema = z.object({
  chapter_id: z.string(),
  chapter_title: z.string(),
  subject_id: z.string(),
});

const prerequisiteTargetSchema = z.object({
  competency: z.string(),
  label_fr: z.string(),
  label_en: z.string(),
  label_ar: z.string(),
});

const planTargetSchema = z.object({
  exercise_id: z.string(),
  exercise_title: z.string(),
  chapter_id: z.string(),
  subject_id: z.string(),
});

/**
 * La cible, lue selon la MARCHE et non par essais successifs.
 *
 * Une `z.union` serait piégeuse ici : la cible d'un item de plan porte elle
 * aussi `chapter_id` et `subject_id`, donc le schéma « cours » l'accepterait en
 * premier et on perdrait l'exercice en route. C'est la marche qui dit quoi lire.
 *
 * Une cible illisible vaut `null` : la phrase d'escalade reste affichée, seul le
 * lien disparaît. R-15 — on dégrade, on ne plante pas.
 */
function toEscalationTarget(step: TutorEscalationStep, raw: unknown): TutorEscalationTarget | null {
  if (step === "lesson") {
    const parsed = lessonTargetSchema.safeParse(raw);
    return parsed.success
      ? {
          kind: "lesson",
          chapterId: parsed.data.chapter_id,
          chapterTitle: parsed.data.chapter_title,
          subjectId: parsed.data.subject_id,
        }
      : null;
  }
  if (step === "prerequisite") {
    const parsed = prerequisiteTargetSchema.safeParse(raw);
    return parsed.success
      ? {
          kind: "prerequisite",
          competency: parsed.data.competency,
          labelFr: parsed.data.label_fr,
          labelEn: parsed.data.label_en,
          labelAr: parsed.data.label_ar,
        }
      : null;
  }
  if (step === "plan") {
    const parsed = planTargetSchema.safeParse(raw);
    return parsed.success
      ? {
          kind: "plan",
          exerciseId: parsed.data.exercise_id,
          exerciseTitle: parsed.data.exercise_title,
          chapterId: parsed.data.chapter_id,
          subjectId: parsed.data.subject_id,
        }
      : null;
  }
  // `reteach` et `parentDigest` ne pointent nulle part, et c'est normal.
  return null;
}

/**
 * US-4 — sert la question de vérification.
 *
 * R-15 : jamais d'exception métier. Une porte fermée, un vivier vide ou une RPC
 * en panne rendent tous `{ ok: false, code }`, et l'écran décide de se taire.
 * Un mini-check absent n'est pas une panne visible — c'est l'absence d'une
 * proposition, ce qu'un enfant ne remarque même pas.
 */
export const getTutorMiniCheck = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ questionId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<TutorMiniCheck> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data: raw, error } = await client.rpc("get_tutor_mini_check", {
      p_question_id: data.questionId,
    });
    if (error) {
      logger.error("tutor.miniCheck", { error: errorMessage(error) });
      return { ok: false, code: "UNKNOWN" };
    }
    const parsed = miniCheckSchema.safeParse(raw);
    if (!parsed.success) return { ok: false, code: "UNKNOWN" };
    const value = parsed.data;
    // `served: false` porte SA raison (porte fermée, vivier vide) : on la
    // transmet telle quelle, l'écran sait déjà traduire les codes de R-1.
    if (!value.served || !value.question_id || !value.prompt) {
      return { ok: false, code: value.reason };
    }
    return {
      ok: true,
      questionId: value.question_id,
      prompt: value.prompt,
      options: value.options,
      tag: value.tag ?? null,
      lang: value.lang ?? "fr",
    };
  });

/**
 * US-4 — corrige le mini-check.
 *
 * ⚠️ Cette fonction ne verse RIEN et n'a aucune raison de le faire un jour :
 * l'interdiction vit dans la RPC (R-11), pas ici. Ce qui vit ici, c'est le
 * refus de faire croire à l'écran qu'une correction a eu lieu quand elle a
 * échoué — d'où le `ok: false` plutôt qu'un `correct: false` par défaut, qui
 * dirait à l'élève qu'il s'est trompé alors qu'on n'en sait rien.
 */
export const submitTutorMiniCheck = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        questionId: z.guid(),
        // Un identifiant d'option (« a », « b »…), borné : le contenu de la
        // réponse n'est jamais du texte libre en QCM.
        choice: z.string().min(1).max(64),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<TutorMiniCheckResult> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data: raw, error } = await client.rpc("submit_tutor_mini_check", {
      p_question_id: data.questionId,
      p_choice: data.choice,
    });
    if (error) {
      logger.error("tutor.miniCheck.submit", { error: errorMessage(error) });
      return { ok: false, code: "UNKNOWN" };
    }
    const parsed = miniCheckGradeSchema.safeParse(raw);
    if (!parsed.success) return { ok: false, code: "UNKNOWN" };
    const value = parsed.data;
    if (!value.graded || typeof value.correct !== "boolean") {
      return { ok: false, code: value.reason };
    }
    return {
      ok: true,
      correct: value.correct,
      correctOption: value.correct_option ?? null,
      explanation: value.explanation ?? null,
      tag: value.tag ?? null,
    };
  });

/**
 * R-8 — le diagnostic. Trois signaux OBJECTIFS, calculés en base.
 *
 * L'écran s'en sert pour une seule décision, mais elle compte : faut-il escalader
 * du tout ? Un enfant qui rate un mini-check sans qu'aucun des trois signaux ne
 * soit levé n'a pas besoin qu'on remonte au prérequis — il a besoin d'une autre
 * explication. Escalader sur la première erreur transformerait une aide en
 * procédure.
 *
 * Le niveau vient du SQL ; `escalation.ts` ne fait que le nommer. Les deux
 * portent la même matrice, et `tutor-escalation.test.ts` en fige les huit cases.
 */
export const getTutorUnderstandingSignal = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ tag: z.string().min(1).max(200) }).parse(d))
  .handler(async ({ data, context }): Promise<{ level: number; step: TutorEscalationStep }> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data: raw, error } = await client.rpc("tutor_understanding_signal", {
      p_tag: data.tag,
    });
    if (error) {
      // Un diagnostic illisible vaut « aucun signal » : on re-explique, ce qui
      // est la marche la plus douce. L'inverse escaladerait sur une panne.
      logger.warn("tutor.signal", { error: errorMessage(error) });
      return { level: 0, step: escalationStep(0) };
    }
    const parsed = understandingSignalSchema.safeParse(raw);
    if (!parsed.success) return { level: 0, step: escalationStep(0) };
    const level = parsed.data.recommended_level;
    return { level, step: escalationStep(level) };
  });

/**
 * R-8 — monte le fil d'UNE marche et rend la proposition suivante.
 *
 * Une marche à la fois, jamais un saut : c'est le mot « ORDONNÉE » de R-8. La
 * RPC dégrade elle-même quand une cible est introuvable (pas de compétence
 * associée au tag, aucun prérequis mesuré) et rend le niveau réellement ATTEINT.
 */
export const escalateTutorThread = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ threadId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<TutorEscalation | null> => {
    const client = context.supabase as unknown as TutorRpcClient;
    const { data: raw, error } = await client.rpc("escalate_tutor_thread", {
      p_thread: data.threadId,
    });
    if (error) {
      // `null` et non un niveau par défaut : l'écran ne doit pas annoncer une
      // marche que la base n'a pas enregistrée. Le fil resterait au niveau
      // précédent et la promesse faite à l'élève serait fausse.
      logger.error("tutor.escalate", { error: errorMessage(error) });
      return null;
    }
    const parsed = escalationSchema.safeParse(raw);
    if (!parsed.success) return null;
    const step = escalationStepFromAction(parsed.data.action);
    return {
      level: parsed.data.escalation_level,
      step,
      target: toEscalationTarget(step, parsed.data.target),
    };
  });
