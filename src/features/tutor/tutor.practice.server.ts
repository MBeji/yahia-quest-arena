// « ENTRAÎNE-MOI SUR MA FAIBLESSE » — étude 11 lot 5 (US-11, US-12, Q-8).
//
// POURQUOI UN FICHIER À PART ET PAS UNE FONCTION DE PLUS DANS `tutor.server.ts`
// ---------------------------------------------------------------------------
// `tutor.server.ts` est mesuré à 725 lignes EFFECTIVES pour un plafond ESLint de
// 750 (`max-lines`, blancs et commentaires exclus) : il reste vingt-cinq lignes,
// et cette server fn en fait plus. Le fichier a déjà été scindé une première
// fois pour cette raison exacte (`tutor.stream.server.ts`, lot 3) — on suit le
// précédent au lieu de raboter des commentaires pour gagner un tour de gate.
//
// LE CHOIX DE FRONTIÈRE, ET IL EST DEMANDÉ EXPLICITEMENT
// ---------------------------------------------------------------------------
// Cette server fn rend une INTENTION (`kind: "forge"`), jamais un appel à la
// Forge. Elle n'importe donc PAS `@/features/ai/forge.server`.
//
// Ce n'est pas un réflexe de pureté : `tutor.server.ts:35` importe déjà
// `callAi` depuis `@/features/ai`, et `tutor.stream.server.ts:32` importe
// `streamAi` — la frontière a été franchie deux fois, aux lots 1 et 3, et
// aucune règle ESLint ne l'interdit (`eslint.config.js` n'a qu'un
// `no-restricted-imports` sur `server-only`). L'argument est ailleurs, et il est
// spécifique à CE lot : les deux imports existants servent à PARLER AU MODÈLE,
// ce que seule la porte unique sait faire. Ici, le renvoi vers la Forge est une
// NAVIGATION — `/forge?chapitre=<uuid>`. Importer `forgeQuiz` ferait entrer
// toute la chaîne de génération (schéma zod, filtres, double résolution) dans le
// graphe du tuteur pour produire une URL. On ne paie pas un graphe d'imports
// pour une chaîne de caractères.
//
// Corollaire : c'est l'ÉCRAN qui traduit l'intention en navigation, et il n'a
// rien à décider — la décision est déjà prise ici, côté serveur (R-10).
//
// CE QUE CE FICHIER NE REFAIT PAS
// ---------------------------------------------------------------------------
// Ni la sélection (`get_targeted_exercises`, migration 20260823150000), ni le
// seuil de Q-8 (`tutor_practice_needs_generation`, même migration), ni la
// génération (la Forge, é29 lot 4). Il ORCHESTRE trois faits déjà établis
// ailleurs et rend un état affichable — R-15, jamais une exception.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { decidePractice } from "./practice";

/**
 * Les RPC de ce lot ne sont pas encore dans les types générés (ils se
 * régénèrent depuis la base, et la base ne les a pas avant la migration).
 * Contrat figé ici, motif `tutor.server.ts` — À SUPPRIMER à la prochaine
 * régénération de `supabase/types.ts`.
 */
type PracticeRpcClient = {
  rpc: (
    fn: "can_use_tutor" | "get_targeted_exercises" | "tutor_practice_needs_generation",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

/** `ai_student_access` est postérieure aux types générés — même contrat local que `ai-access.server.ts`. */
type SurfacesReader = {
  from: (table: "ai_student_access") => {
    select: (cols: "enabled, features") => {
      eq: (
        col: "student_user_id",
        val: string,
      ) => {
        maybeSingle: () => PromiseLike<{
          data: { enabled: boolean | null; features: string[] | null } | null;
          error: unknown;
        }>;
      };
    };
  };
};

/**
 * Une ligne de la sélection. R-16 : ni clé, ni explication, ni `distractor_tags`
 * — la RPC ne les nomme même pas dans son `RETURNS TABLE`.
 */
export type TutorPracticeItem = {
  readonly questionId: string;
  readonly exerciseId: string;
  readonly chapterId: string | null;
  readonly exerciseTitle: string;
  readonly difficulty: number;
  /** Question de REPLI (même chapitre, difficulté voisine), pas sur l'erreur. */
  readonly isFallback: boolean;
};

/**
 * L'état rendu à l'écran. `locked` est un ÉTAT, pas une erreur : R-1 refuse
 * pendant un donjon ou un duel, et l'écran le dit en langage d'élève.
 */
export type TutorPracticeResult =
  | { readonly kind: "locked"; readonly reason: string }
  | {
      readonly kind: "exercises";
      readonly onTarget: boolean;
      readonly items: readonly TutorPracticeItem[];
    }
  | { readonly kind: "forge"; readonly chapterId: string }
  | { readonly kind: "none"; readonly reason: "no-chapter" | "no-material" };

const rowSchema = z.object({
  question_id: z.string(),
  exercise_id: z.string(),
  chapter_id: z.string().nullable(),
  subject_id: z.string().nullable(),
  exercise_title: z.string(),
  difficulty: z.number().int(),
  is_fallback: z.boolean(),
  fresh_count: z.number().int(),
});

const gateSchema = z.object({ allowed: z.boolean(), reason: z.string() });

/**
 * L'ORDRE DES ÉTAPES EST LE CONTRAT :
 *
 *   1. can_use_tutor('chapter')  R-1 — mais seulement si un chapitre est connu
 *   2. get_targeted_exercises    US-11 — le stock, porte d'accès comprise
 *   3. tutor_practice_needs_...  Q-8 — le SEUIL, et il vit en SQL
 *   4. ai_student_access         la Forge est-elle ouverte à cet élève ?
 *   5. decidePractice            la règle, pure et testée
 *
 * ⚠️ L'ÉTAPE 3 EST TOUJOURS APPELÉE, ET C'EST DÉLIBÉRÉ.
 * Il serait tentant de l'éviter quand `fresh_count >= 3` — une RPC de moins.
 * Mais écrire `fresh_count >= 3` ICI, c'est faire vivre le seuil de Q-8 à deux
 * endroits : en SQL et en TypeScript. C'est exactement la faute que
 * `active_misconceptions` a dû réparer pour R-2, dont le triplet avait fini
 * recopié à quatre endroits qui divergeaient. On paie une RPC bornée (40
 * candidats au plus) pour que le seuil n'ait qu'un seul propriétaire.
 */
export const startTargetedPractice = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        /** Le tag de l'erreur — `get_my_weaknesses.tag`. Jamais affiché (R-A1.2-1). */
        tag: z.string().min(1).max(120),
        /** Un SLUG de compétence (`competencies.slug`), pas un UUID. Nullable par conception. */
        competency: z.string().min(1).max(120).nullable().default(null),
        /** `get_my_weaknesses.chapter_id` — nullable, et c'est un cas réel. */
        chapterId: z.guid().nullable().default(null),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<TutorPracticeResult> => {
    const client = context.supabase as unknown as PracticeRpcClient;

    // ÉTAPE 1 — R-1, quand elle est interrogeable.
    //
    // `can_use_tutor('chapter', NULL, NULL)` rend BAD_SCOPE : sans chapitre, la
    // porte ne peut pas être interrogée. On ne l'appelle donc pas — et on ne
    // fabrique surtout pas un scope 'practice', qui obligerait à modifier une
    // fonction EN PRODUCTION plutôt qu'à en appeler une.
    //
    // Sauter la garde est sans risque ici, et c'est la position déjà tenue par
    // le produit : la seule branche atteignable sans chapitre est « jouer des
    // exercices RÉELS du catalogue » — ce que le bouton « S'entraîner » de la
    // carte de compétences (é07 lot 4) fait depuis toujours SANS aucune garde.
    // R-1 protège le TUTEUR (une explication pendant une épreuve serait une
    // antisèche), pas le fait de jouer une quête. Et la branche `forge`, elle,
    // est inatteignable sans chapitre.
    if (data.chapterId) {
      const gate = await client.rpc("can_use_tutor", {
        p_scope: "chapter",
        p_question_id: null,
        p_chapter_id: data.chapterId,
      });
      if (gate.error) {
        // Une porte qu'on n'arrive pas à interroger est une porte FERMÉE — le
        // contraire ouvrirait l'entraînement en plein donjon sur une panne.
        logger.error("tutor.practice.gate", { error: errorMessage(gate.error) });
        return { kind: "locked", reason: "UNKNOWN" };
      }
      const parsed = gateSchema.safeParse(gate.data);
      if (!parsed.success) return { kind: "locked", reason: "UNKNOWN" };
      if (!parsed.data.allowed) return { kind: "locked", reason: parsed.data.reason };
    }

    // ÉTAPE 2 — le stock. Trois destinations au plus : c'est une relance, pas
    // un programme de révision (même esprit que le plan du jour, R-4).
    const selection = await client.rpc("get_targeted_exercises", {
      p_tag: data.tag,
      p_competency: data.competency,
      p_limit: 3,
    });
    if (selection.error) {
      // Dégradation gracieuse, motif `getCompetencyExercises` : on ne casse pas
      // le tableau de bord parce qu'une sélection a échoué.
      logger.warn("tutor.practice.selection", { error: errorMessage(selection.error) });
      return { kind: "none", reason: "no-material" };
    }
    const rows = z.array(rowSchema).safeParse(selection.data ?? []);
    const items: TutorPracticeItem[] = rows.success
      ? rows.data.map((r) => ({
          questionId: r.question_id,
          exerciseId: r.exercise_id,
          chapterId: r.chapter_id,
          exerciseTitle: r.exercise_title,
          difficulty: r.difficulty,
          isFallback: r.is_fallback,
        }))
      : [];

    // ÉTAPE 3 — LE seuil de Q-8, et il n'est pas recalculé ici (voir l'en-tête).
    const gen = await client.rpc("tutor_practice_needs_generation", { p_tag: data.tag });
    if (gen.error) {
      // La génération est la voie qui DÉPENSE. Un doute sur la porte se tranche
      // donc en faveur du stock : `false`, pas `true`.
      logger.warn("tutor.practice.gate-q8", { error: errorMessage(gen.error) });
    }
    const needsGeneration = gen.error ? false : gen.data === true;

    // ÉTAPE 4 — la Forge est-elle ouverte à CET élève ? Lecture de table sous sa
    // propre RLS (deux colonnes, jamais `owner_user_id` — R-14a), et non un
    // import de `@/features/ai` : une feature n'en importe pas une autre, et
    // c'est le précédent de `quest.training.ts`, qui a préféré dupliquer six
    // lignes plutôt que déplacer une lecture dans `shared/`.
    let forgeEnabled = false;
    try {
      const surfaces = context.supabase as unknown as SurfacesReader;
      const { data: row } = await surfaces
        .from("ai_student_access")
        .select("enabled, features")
        .eq("student_user_id", context.userId)
        .maybeSingle();
      forgeEnabled = row?.enabled === true && (row.features ?? []).includes("forge");
    } catch (err) {
      // Une Forge dont on ignore l'état est une Forge FERMÉE : on retombe sur le
      // stock plutôt que de promettre un quiz qui n'arrivera pas.
      logger.warn("tutor.practice.surfaces", { error: errorMessage(err) });
    }

    // ÉTAPE 5 — la règle, pure et testée (`practice.ts`).
    const intent = decidePractice({
      needsGeneration,
      itemCount: items.length,
      chapterId: data.chapterId,
      forgeEnabled,
    });

    if (intent.kind === "exercises") {
      return { kind: "exercises", onTarget: intent.onTarget, items };
    }
    return intent;
  });
