// LA BOUCLE DE COMPRÉHENSION du tuteur (lot 4) : le mini-check, le signal de
// compréhension et l'escalade. Sortie de `tutor.server.ts` (2026-11-03), qui était à
// 700 lignes de code pour un plafond de 750 : ces quatre fonctions n'appellent ni le
// modèle ni le cache d'explications, elles ne partagent avec le reste que le schéma
// de langue. Texte déplacé à l'identique.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { TUTOR_LANGS, type TutorLang } from "./prompt";
import { escalationStep, escalationStepFromAction, type TutorEscalationStep } from "./escalation";

const langSchema = z.enum(TUTOR_LANGS);

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
  .validator((d: unknown) => z.object({ questionId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<TutorMiniCheck> => {
    const client = context.supabase;
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
  .validator((d: unknown) =>
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
    const client = context.supabase;
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
  .validator((d: unknown) => z.object({ tag: z.string().min(1).max(200) }).parse(d))
  .handler(async ({ data, context }): Promise<{ level: number; step: TutorEscalationStep }> => {
    const client = context.supabase;
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
  .validator((d: unknown) => z.object({ threadId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<TutorEscalation | null> => {
    const client = context.supabase;
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
