// LA FORGE — le générateur de quiz à la demande de l'élève (étude 29 lot 4).
//
// CE QU'ELLE EST, PAR RAPPORT À é11 LOT 5
// ---------------------------------------------------------------------------
// L'étude 11 génère des exercices que LE TUTEUR choisit pour combler une lacune
// détectée. La Forge est l'inverse : c'est L'ÉLÈVE qui demande, sur un périmètre
// qu'il choisit, et il obtient un quiz jouable immédiatement (§2.3). Les deux
// coexistent — « si la brique parle de pédagogie, elle est à é11 ; si elle parle
// de ce que l'élève demande lui-même, elle est ici » (annexe B).
//
// LA CHAÎNE (§3.6), ET POURQUOI CHAQUE ÉTAPE EXISTE
// ---------------------------------------------------------------------------
//   contexte fermé        cours + 3 questions en RÉFÉRENCE DE STYLE (sans clé)
//   génération            1 appel `rich`, sortie structurée, N+2 candidats
//   filtres déterministes 0 token, aucune indulgence — voir forge/filters.ts
//   double résolution     1 appel par survivant, SANS voir la clé déclarée
//   ≥ N validés ?         oui → écriture · non → échec HONNÊTE, énergie rendue
//
// « Le double-solve DOUBLE le coût de la Forge, et c'est assumé : sans lui, un
// modèle bon marché livre des quiz dont la clé est fausse une fois sur dix, à un
// enfant qui n'a aucun moyen de le savoir. »
//
// R-18bis (Q-7) : le porteur PEUT couper cette vérification. Trois choses ne se
// coupent pas avec elle — l'échantillon de 20 % (sans lui, plus de taux de
// rebut, donc plus d'avertissement R-19), l'étiquette « non vérifié » portée par
// le quiz, et la vérification complète sur le chemin plateforme.
//
// R-16 / D-13 : ce fichier n'écrit RIEN dans `attempts`, `question_attempts` ni
// `spaced_repetition_schedule`, et ne verse aucune récompense. La correction est
// en SQL (`grade_forged_quiz`), là où l'interdiction est écrite à côté du code.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { nullableRpcArg } from "@/shared/integrations/supabase/rpc-args";
import { logger } from "@/shared/lib/logger";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
import { AI_FORGE_LIMITS, AI_VERIFY_SAMPLE_RATE, forgeTimeoutMs } from "@/shared/constants/ai";
// La difficulté d'un quiz forgé parle la MÊME échelle que celle du catalogue
// (1-4) : c'est la constante de gameplay qui fait foi, pas une échelle parallèle
// inventée pour la Forge.
import { MAX_DIFFICULTY_LEVEL, MIN_DIFFICULTY_LEVEL } from "@/shared/constants/gamification";
import { AI_MODE_ERROR_PREFIX } from "./ai-mode-status";
import { callAi } from "./ai-call.server";
import {
  candidateCount,
  filterCandidates,
  shouldSampleVerify,
  type ForgeRejection,
} from "./forge/filters";
import {
  FORGE_SOLVE_SYSTEM,
  FORGE_SYSTEM,
  buildForgeBlocks,
  buildSolveBlocks,
  stripKey,
} from "./forge/prompt";
import {
  FORGE_JSON_SCHEMA,
  FORGE_SOLVE_JSON_SCHEMA,
  forgeOutputSchema,
  forgeSolveSchema,
  servedItemSchema,
  type ForgedQuestion,
} from "./forge/schema";

const adminRpc = () => supabaseAdmin;

const contextRowSchema = z.object({
  chapter_title: z.string(),
  subject_id: z.string(),
  content_lang: z.enum(["fr", "en", "ar"]),
  grade_rank: z.number().nullable(),
  lesson_excerpt: z.string(),
  sample_prompts: z.array(z.string()),
  existing_prompts: z.array(z.string()),
});

function failWithForge(context: string, code: string, cause?: unknown): never {
  logger.warn(context, { code, error: cause ? errorMessage(cause) : undefined });
  throw new Error(`${AI_MODE_ERROR_PREFIX}${code}`);
}

/** Identifiant d'item stable dans un quiz : `q1`…`q10`. Pas d'UUID — ils voyagent en clair. */
const itemId = (index: number) => `q${index + 1}`;

/**
 * Extrait la liste de candidats d'une sortie de modèle.
 *
 * Un fournisseur sans `structuredOutput` rend du texte qui RESSEMBLE à du JSON,
 * parfois entouré d'une clôture markdown. On tolère cette enveloppe — et rien
 * d'autre : ce qui n'est pas analysable est un rebut compté, pas une exception
 * (§3.5, « avec un taux de rebut supérieur, c'est un fait à afficher »).
 */
export function parseForgeOutput(text: string): unknown[] | null {
  const stripped = text
    .trim()
    .replace(/^```(?:json)?\s*/i, "")
    .replace(/```\s*$/, "");
  try {
    const parsed = forgeOutputSchema.partial().safeParse(JSON.parse(stripped));
    if (!parsed.success || !Array.isArray(parsed.data.items)) {
      // Le schéma complet refuserait un lot dont UN item est mauvais ; on veut
      // au contraire garder les bons et compter les mauvais. D'où le parse
      // permissif ici, et le filtre item par item ensuite.
      const loose = JSON.parse(stripped) as { items?: unknown };
      return Array.isArray(loose.items) ? loose.items : null;
    }
    return parsed.data.items;
  } catch {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Forger
// ---------------------------------------------------------------------------

const forgeInput = z.object({
  chapterId: z.guid(),
  size: z.union([z.literal(5), z.literal(8), z.literal(10)]),
  difficulty: z.number().int().min(MIN_DIFFICULTY_LEVEL).max(MAX_DIFFICULTY_LEVEL),
});

export type ForgeResult =
  | {
      readonly ok: true;
      readonly quizId: string;
      readonly kept: number;
      readonly discarded: number;
    }
  | { readonly ok: false; readonly code: string };

export const forgeQuiz = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => forgeInput.parse(d))
  .handler(async ({ data, context }): Promise<ForgeResult> => {
    const { userId } = context;

    // R-18 : le quota AVANT la dépense. La Forge est l'action la plus chère du
    // produit ; découvrir le quota après avoir payé serait absurde.
    const { data: quota } = await adminRpc().rpc("ai_forge_quota_left", { p_student: userId });
    if (typeof quota === "number" && quota <= 0) {
      return { ok: false, code: "AI_FORGE_QUOTA" };
    }

    // 1. Le contexte, DÉTERMINISTE : rien de ce qui suit n'est décidé par un modèle.
    const { data: rows, error: contextError } = await adminRpc().rpc("get_forge_context", {
      p_chapter: data.chapterId,
    });
    if (contextError) {
      failWithForge("ai.forge.context", "AI_UNKNOWN", contextError);
    }
    const parsedContext = contextRowSchema.safeParse(Array.isArray(rows) ? rows[0] : null);
    if (!parsedContext.success) return { ok: false, code: "AI_FORGE_NO_CONTEXT" };
    const ctx = parsedContext.data;

    // 2. La génération. UN appel `rich`, N+2 candidats, sortie structurée.
    //    L'énergie est débitée ici, une fois pour le quiz entier — les
    //    double-résolutions qui suivent ne coûtent que de l'argent.
    const wanted = candidateCount(data.size);
    const generation = await callAi({
      studentUserId: userId,
      feature: "forge",
      tier: "rich",
      system: FORGE_SYSTEM,
      // La patience suit le VOLUME : un modèle à raisonnement passe des
      // milliers de tokens de réflexion par candidat, et le plafond unique de
      // 90 s était calibré sur le plus petit quiz (sept candidats) alors que
      // l'écran arrive sur huit questions — donc dix.
      timeoutMs: forgeTimeoutMs(wanted),
      blocks: buildForgeBlocks(
        {
          chapterTitle: ctx.chapter_title,
          lessonExcerpt: ctx.lesson_excerpt,
          samplePrompts: ctx.sample_prompts,
          lang: ctx.content_lang,
          gradeRank: ctx.grade_rank,
        },
        { count: wanted, difficulty: data.difficulty },
      ),
      responseSchema: FORGE_JSON_SCHEMA,
    });

    if (!generation.ok) return { ok: false, code: generation.code };

    const raw = parseForgeOutput(generation.text);
    if (!raw) {
      logger.warn("ai.forge", { requested: data.size, kept: 0, discarded: wanted });
      return { ok: false, code: "AI_OUTPUT_REJECTED" };
    }

    // 3. Les filtres déterministes — 0 token.
    const { kept, rejected } = filterCandidates(raw, {
      existingPrompts: ctx.existing_prompts,
      gradeRank: ctx.grade_rank,
    });
    let discarded = rejected.length;

    // 4. La double résolution. Complète, ou échantillonnée à 20 % si le porteur
    //    l'a coupée (R-18bis.3) — jamais nulle.
    const fullVerification = generation.doubleSolve;
    const validated: ForgedQuestion[] = [];

    for (const [index, candidate] of kept.entries()) {
      const verify = fullVerification || shouldSampleVerify(index, AI_VERIFY_SAMPLE_RATE);
      if (!verify) {
        validated.push(candidate);
        continue;
      }

      const solved = await callAi({
        studentUserId: userId,
        feature: "forge_solve",
        // La surface d'ACCÈS reste `forge` : `forge_solve` est la seconde moitié
        // du même geste, pas une surface que le porteur active séparément.
        accessFeature: "forge",
        tier: "rich",
        system: FORGE_SOLVE_SYSTEM,
        // `stripKey` : le second appel ne voit NI la clé déclarée, NI
        // l'explication. C'est la garantie de Q-7, et le type l'impose.
        blocks: buildSolveBlocks(stripKey(candidate)),
        responseSchema: FORGE_SOLVE_JSON_SCHEMA,
        energyCost: 0,
      });

      if (!solved.ok) {
        // Une panne pendant la vérification n'invalide pas le candidat : elle
        // empêche de le valider. On le jette — un item non vérifiable ne part
        // pas chez un enfant sous couvert de « le fournisseur n'a pas répondu ».
        discarded += 1;
        continue;
      }

      const answer = readSolvedAnswer(solved.text);
      if (answer !== candidate.correctOption) {
        // Désaccord ⇒ rebut, compté et affiché (§3.6). C'est LE signal de R-19.
        discarded += 1;
        continue;
      }
      validated.push(candidate);
    }

    logger.info("ai.forge", { requested: data.size, kept: validated.length, discarded });

    // 5. Quorum, ou échec honnête.
    if (validated.length < data.size) {
      // « la Forge n'a pas réussi à écrire un quiz correct — réessaie ou change
      // de périmètre ». L'énergie a déjà été rendue ? Non : elle a été
      // consommée par une génération qui a bien eu lieu. Ce que l'étude
      // rembourse, c'est l'énergie d'un appel qui n'a PAS abouti (é11 R-15) —
      // ici il a abouti, et sa sortie a été jugée. La dépense réelle reste
      // journalisée, comme le §3.6 l'exige.
      return { ok: false, code: "AI_FORGE_NO_QUORUM" };
    }

    const items = validated
      .slice(0, data.size)
      .map((candidate, index) => ({ ...candidate, id: itemId(index) }));

    const { data: quizId, error: writeError } = await adminRpc().rpc("create_forged_quiz", {
      p_student: userId,
      p_owner: userId,
      p_scope: "chapter",
      p_chapter: data.chapterId,
      // Portée « chapitre » : la compétence est NULL, et `p_competency TEXT`
      // n'a pas de défaut — impossible de l'omettre.
      p_competency: nullableRpcArg<string>(null),
      p_lang: ctx.content_lang,
      p_difficulty: data.difficulty,
      p_requested: data.size,
      p_payload: { items },
      p_model: generation.model,
      p_discarded: discarded,
      // R-18bis.2 : l'étiquette voyage AVEC le contenu, pas avec l'écran qui l'a
      // créé — elle doit s'afficher au moment où la question est jouée.
      p_verified: fullVerification,
    });

    if (writeError) {
      if (writeError.message.includes("AI_FORGE_QUOTA")) {
        return { ok: false, code: "AI_FORGE_QUOTA" };
      }
      failWithForge("ai.forge.write", "AI_UNKNOWN", writeError);
    }

    return {
      ok: true,
      quizId: String(quizId),
      kept: items.length,
      discarded,
    };
  });

/** Lit la réponse de la double résolution, en tolérant une réponse nue (`b`). */
export function readSolvedAnswer(text: string): string | null {
  const trimmed = text
    .trim()
    .replace(/^```(?:json)?\s*/i, "")
    .replace(/```\s*$/, "");
  try {
    const parsed = forgeSolveSchema.safeParse(JSON.parse(trimmed));
    if (parsed.success) return parsed.data.answer;
  } catch {
    // Pas du JSON : peut-être une lettre seule, ce que rend un fournisseur sans
    // sortie structurée. On l'accepte — le refuser gonflerait le taux de rebut
    // pour une raison qui n'a rien à voir avec la qualité de la question.
  }
  const bare = /^[abcd]$/i.exec(trimmed);
  return bare ? bare[0].toLowerCase() : null;
}

// ---------------------------------------------------------------------------
// Jouer
// ---------------------------------------------------------------------------

const servedQuizSchema = z.object({
  id: z.string(),
  scope: z.string(),
  chapter_id: z.string().nullable(),
  lang: z.enum(["fr", "en", "ar"]),
  difficulty: z.number(),
  verified: z.boolean(),
  expires_at: z.string(),
  items: z.array(servedItemSchema),
});

export type ServedForgedQuiz = {
  readonly id: string;
  readonly lang: "fr" | "en" | "ar";
  readonly difficulty: number;
  /** R-18bis.2 : `false` ⇒ l'écran affiche « non vérifié » sur CHAQUE question. */
  readonly verified: boolean;
  readonly items: z.infer<typeof servedItemSchema>[];
};

export const getForgedQuiz = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ quizId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<ServedForgedQuiz> => {
    const client = context.supabase;
    const { data: rows, error } = await client.rpc("serve_forged_quiz", { p_quiz: data.quizId });
    if (error) {
      for (const code of ["AI_FORGE_NOT_FOUND", "AI_FORGE_EXPIRED"]) {
        if (error.message.includes(code)) throw new Error(`${AI_MODE_ERROR_PREFIX}${code}`);
      }
      failWithClientError("ai.getForgedQuiz", error, "Ce quiz n'est pas disponible.");
    }

    const parsed = servedQuizSchema.safeParse(Array.isArray(rows) ? rows[0] : null);
    if (!parsed.success) throw new Error(`${AI_MODE_ERROR_PREFIX}AI_FORGE_NOT_FOUND`);

    return {
      id: parsed.data.id,
      lang: parsed.data.lang,
      difficulty: parsed.data.difficulty,
      verified: parsed.data.verified,
      items: parsed.data.items,
    };
  });

const reviewSchema = z.array(
  z.object({
    questionId: z.string(),
    prompt: z.string(),
    selectedChoice: z.string(),
    correctChoice: z.string(),
    isCorrect: z.boolean(),
    explanation: z.string().nullable(),
  }),
);

export type ForgedQuizResult = {
  readonly correct: number;
  readonly total: number;
  readonly review: z.infer<typeof reviewSchema>;
};

export const gradeForgedQuiz = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        quizId: z.guid(),
        // Une réponse par question, bornée au volume maximal d'un quiz forgé.
        answers: z.record(z.string().max(8), z.string().max(8)),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<ForgedQuizResult> => {
    const client = context.supabase;
    const { data: rows, error } = await client.rpc("grade_forged_quiz", {
      p_quiz: data.quizId,
      p_answers: data.answers,
    });
    if (error) {
      failWithClientError("ai.gradeForgedQuiz", error, "La correction a échoué.");
    }

    const row = (Array.isArray(rows) ? rows[0] : null) as {
      correct: number;
      total: number;
      review: unknown;
    } | null;
    const review = reviewSchema.safeParse(row?.review ?? []);

    // R-16, rappelé ici parce que c'est le point de retour d'un quiz joué : il
    // n'y a AUCUNE récompense à propager. Le résultat est une correction, pas un
    // score — et l'écran ne montre ni XP, ni pièce, ni badge.
    return {
      correct: row?.correct ?? 0,
      total: row?.total ?? 0,
      review: review.success ? review.data : [],
    };
  });

const quizListSchema = z.array(
  z.object({
    id: z.string(),
    scope: z.string(),
    chapter_id: z.string().nullable(),
    chapter_title: z.string().nullable(),
    lang: z.string(),
    difficulty: z.number(),
    question_count: z.number(),
    verified: z.boolean(),
    created_at: z.string(),
    expires_at: z.string(),
  }),
);

export type ForgedQuizSummary = {
  readonly id: string;
  readonly chapterTitle: string | null;
  readonly difficulty: number;
  readonly questionCount: number;
  readonly verified: boolean;
  readonly expiresAt: string;
};

export const listForgedQuizzes = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ quizzes: ForgedQuizSummary[]; quotaLeft: number }> => {
    const client = context.supabase;
    const [{ data: rows }, { data: quota }] = await Promise.all([
      client.rpc("list_forged_quizzes"),
      client.rpc("ai_forge_quota_left", { p_student: context.userId }),
    ]);

    const parsed = quizListSchema.safeParse(rows ?? []);
    return {
      quizzes: parsed.success
        ? parsed.data.map((q) => ({
            id: q.id,
            chapterTitle: q.chapter_title,
            difficulty: q.difficulty,
            questionCount: q.question_count,
            verified: q.verified,
            expiresAt: q.expires_at,
          }))
        : [],
      quotaLeft: typeof quota === "number" ? quota : AI_FORGE_LIMITS.dailyQuizzesPerStudent,
    };
  });

/** Ré-exporté pour la console qualité du lot 5 : le vocabulaire des rebuts. */
export type { ForgeRejection };

// ---------------------------------------------------------------------------
// LE CHOIX DU CHAPITRE — la porte du tableau de bord n'était pas une porte
// ---------------------------------------------------------------------------
// L'étude 29 §2.1 demande DEUX entrées vers la Forge : « depuis le hub d'un
// chapitre ET depuis le dashboard élève ». La seconde était livrée sans le
// moyen de s'en servir : le panneau ne montre ses réglages que s'il a reçu un
// chapitre, et le tableau de bord n'en passe aucun. Un élève qui vient de faire
// brancher la clé de sa famille arrivait donc sur un écran vide — un titre, une
// phrase, « aucun quiz forgé pour l'instant » — et concluait, à raison, que la
// Forge ne faisait rien.
//
// Cette fonction rend ce que l'élève peut FORGER, pas le catalogue entier :
//
//   * les matières de son parcours ACTIF, exactement comme le tableau de bord
//     les cadre (`current_parcours_id` → thème + niveau) ;
//   * les chapitres qui ont un COURS. `get_forge_context` accepte un chapitre
//     sans leçon et rend un extrait vide : la Forge partirait alors générer un
//     quiz à partir de rien, brûlerait l'argent de la famille et échouerait au
//     quorum. Un chapitre non enseigné n'est pas proposé.
//
// Elle ne porte AUCUN montant (R-14a) : ce sont des titres de chapitres.

const forgeableChapterSchema = z.object({
  id: z.string(),
  title: z.string(),
  subject_id: z.string(),
});

export type ForgeableChapter = {
  readonly id: string;
  readonly title: string;
  readonly subjectName: string;
};

/** Borne de la liste — un parcours en compte quelques dizaines, jamais mille. */
const FORGEABLE_CHAPTERS_MAX = 200;

export const listForgeableChapters = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<ForgeableChapter[]> => {
    const { supabase } = context;

    const { data: profile } = await supabase
      .from("profiles")
      .select("current_parcours_id")
      .eq("id", context.userId)
      .maybeSingle();
    const parcoursId = profile?.current_parcours_id ?? null;
    // Sans parcours actif, l'élève n'a pas encore de matières : l'écran le dira
    // lui-même et l'emmènera les choisir. Rendre le catalogue entier ici serait
    // pire que rien — des chapitres qu'il n'étudie pas.
    if (!parcoursId) return [];

    const { data: parcours } = await supabase
      .from("parcours")
      .select("theme_id,grade_id")
      .eq("id", parcoursId)
      .maybeSingle();
    if (!parcours) return [];

    // Le MÊME cadrage que le tableau de bord (#parcours-pivot) : un parcours
    // épingle un thème, et un niveau quand il en a un. `grade_id` nul se lit
    // « les matières hors niveau scolaire », pas « toutes ».
    const themeSubjects = supabase
      .from("subjects")
      .select("id,name_fr")
      .eq("theme_id", parcours.theme_id);
    // Les filtres AVANT le tri : `.order()` rend un builder de transformation,
    // qui n'a plus `.eq()` ni `.is()`. L'ordre des appels est un contrat de
    // supabase-js, pas une préférence de style.
    const { data: subjects } = await (
      parcours.grade_id
        ? themeSubjects.eq("grade_id", parcours.grade_id)
        : themeSubjects.is("grade_id", null)
    ).order("display_order");

    const subjectNames = new Map((subjects ?? []).map((s) => [s.id, s.name_fr]));
    if (subjectNames.size === 0) return [];

    const { data: rows, error } = await supabase
      .from("chapters")
      // JAMAIS `lesson_content` : le cours ne traverse pas le réseau pour
      // remplir une liste déroulante. On filtre sur sa présence, on ne le lit
      // pas — même motif que `getCatalogueStats`.
      .select("id,title,subject_id")
      .in("subject_id", [...subjectNames.keys()])
      .not("lesson_content", "is", null)
      .order("display_order")
      .limit(FORGEABLE_CHAPTERS_MAX);

    if (error) {
      failWithClientError(
        "ai.listForgeableChapters",
        error,
        "Impossible de charger les chapitres.",
      );
    }

    const parsed = z.array(forgeableChapterSchema).safeParse(rows ?? []);
    if (!parsed.success) return [];

    return parsed.data.map((row) => ({
      id: row.id,
      title: row.title,
      subjectName: subjectNames.get(row.subject_id) ?? "—",
    }));
  });
