import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import {
  DAILY_PLAN_MAX_ITEMS,
  DASHBOARD_RECENT_LIMIT,
  LEADERBOARD_LIMIT,
  PASS_THRESHOLD_PCT,
} from "@/shared/constants/gamification";
import type { BadgeRow, DashboardShopItem, InventoryRow } from "@/shared/types/gamification";
import type { DailyPlanItem } from "@/shared/types/daily-plan";
import type { CompetencyBlocker, CompetencyMasteryRow } from "@/shared/types/competency";
import { getCurrentWeekStartUtc, getTodayUtc } from "@/shared/lib/dates";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import { resolveNextAction } from "@/shared/lib/next-action";
import { resolvePromotionTarget, shouldOfferPromotion } from "@/shared/lib/back-to-school";
import { lyceeYearOf } from "./program-families";

const DASHBOARD_ERROR_FR = "Impossible de charger le tableau de bord. Veuillez réessayer.";

/**
 * Progression par matière — étude 22 R-16 (chapitres complétés / chapitres publiés).
 *
 * La RPC `get_user_parcours_progress` (migration `20260720120000`) n'est pas encore dans les
 * types Supabase générés : `supabase gen types` exige un accès DB indisponible en session et
 * le fichier est généré (hook anti-édition). Même précédent que la colonne `chapters.videos`
 * de l'étude 23 (lot 2) — narrowing local ici, types régénérés au prochain accès DB. Le
 * contrat est figé par la migration, pas par ce type.
 */
type ParcoursProgressRow = {
  subject_id: string;
  chapters_total: number;
  chapters_completed: number;
};

/**
 * Vue étroite du client Supabase, limitée à cette seule RPC. Les types générés n'exposent que
 * les fonctions qu'ils connaissent, donc `rpc` refuse un nom inconnu : c'est l'unique point de
 * cast de ce fichier, et il disparaîtra à la prochaine régénération des types. L'appel reste
 * une méthode de l'objet pour ne pas perdre son `this`.
 */
type ParcoursProgressRpcClient = {
  rpc: (
    fn: "get_user_parcours_progress",
    args: { p_subject_ids: string[] },
  ) => PromiseLike<{ data: ParcoursProgressRow[] | null; error: { message: string } | null }>;
};

/**
 * Ligne du classement de cohorte — étude 22 R-23. Même contrat que `get_global_leaderboard`.
 * `get_grade_leaderboard` (migration `20260720210000`) manque aux types Supabase générés pour
 * la même raison que la RPC de progression ci-dessus : `supabase gen types` exige un accès DB
 * et le fichier est généré. Le contrat est figé par la migration, pas par ce type.
 */
type GradeLeaderboardRow = {
  rank: number;
  display_name: string;
  hero_class: string;
  level: number;
  xp: number;
  current_streak: number;
  avatar_tier: number;
  is_me: boolean;
};

type GradeLeaderboardRpcClient = {
  rpc: (
    fn: "get_grade_leaderboard",
    args: { p_limit: number },
  ) => PromiseLike<{ data: GradeLeaderboardRow[] | null; error: { message: string } | null }>;
};

/**
 * « Révision du jour » — étude 04, lot A1.1. Même raison d'être que les deux vues étroites
 * ci-dessus : `get_daily_plan` (migration `20260721120000`) est postérieure aux types Supabase
 * générés, qui ne peuvent être régénérés sans accès DB. Le contrat est figé par la migration.
 */
type DailyPlanRpcClient = {
  rpc: (
    fn: "get_daily_plan",
    args: { p_limit: number },
  ) => PromiseLike<{ data: DailyPlanItem[] | null; error: { message: string } | null }>;
};

/**
 * Le plan de révision du jour — LA source de la priorité 1 de `resolveNextAction` (étude 22,
 * R-18/D-8), et la matière du panneau « Révision du jour ».
 *
 * Une seule lecture pour les deux usages : la bande focus et le panneau ne peuvent donc pas
 * désigner deux exercices différents au même instant, ce qui est exactement ce que D-8
 * interdit. Elle remplace la requête directe sur `spaced_repetition_schedule` qui tenait ce
 * rôle depuis le lot 6 de l'étude 22 — la RPC sait en plus arbitrer par les misconceptions
 * (D-3) et passer la porte d'accès (R-3), ce qu'une requête cliente ne peut pas faire.
 *
 * Dégradation gracieuse comme `stats` et `progress` : si la RPC manque (déploiement en cours,
 * migration pas encore appliquée), le tableau de bord s'affiche sans révision plutôt que de
 * casser. Le pire cas est une priorité 1 muette, pas une page blanche.
 */
async function fetchDailyPlan(supabase: unknown, limit: number): Promise<DailyPlanItem[]> {
  const client = supabase as DailyPlanRpcClient;
  const res = await client.rpc("get_daily_plan", { p_limit: limit });

  if (res.error) {
    logger.warn("getDashboard.dailyPlan: daily-plan RPC failed, defaulting to empty", {
      error: res.error.message,
    });
    return [];
  }
  return res.data ?? [];
}

/**
 * Carte de compétences (étude 07 lot 4, US-1) + « ce qui te bloque » (R-5). Deux RPC
 * postérieures aux types Supabase générés — contrat figé ici, comme `get_daily_plan`.
 */
type CompetencyMapRpcClient = {
  rpc: (
    fn: "get_my_competency_map",
    args: { p_subject_family: string | null },
  ) => PromiseLike<{ data: CompetencyMasteryRow[] | null; error: { message: string } | null }>;
};
type CompetencyBlockersRpcClient = {
  rpc: (
    fn: "get_competency_blockers",
    args: { p_competency: string },
  ) => PromiseLike<{ data: CompetencyBlocker[] | null; error: { message: string } | null }>;
};

/** Seuil « compétence en échec » (R-5) : sous 50, on cherche ses prérequis faibles. */
const COMPETENCY_FAILING_THRESHOLD = 50;

/**
 * La carte de compétences de l'élève, toutes familles confondues (le panneau la groupe par
 * matière puis domaine). Une seule lecture ; dégradation gracieuse comme `stats`/`dailyPlan` :
 * une RPC absente (migration en cours de déploiement) laisse le tableau de bord s'afficher sans
 * la carte plutôt que de casser la page.
 */
async function fetchCompetencyMap(supabase: unknown): Promise<CompetencyMasteryRow[]> {
  const client = supabase as CompetencyMapRpcClient;
  const res = await client.rpc("get_my_competency_map", { p_subject_family: null });
  if (res.error) {
    logger.warn("getDashboard.competencyMap: RPC failed, defaulting to empty", {
      error: res.error.message,
    });
    return [];
  }
  return res.data ?? [];
}

/**
 * Les prérequis faibles de la compétence en échec la PLUS faible (R-5). On borne le tableau de
 * bord à UN appel supplémentaire : la compétence la plus basse sous 50 est celle dont l'élève a
 * le plus besoin de comprendre le blocage. Rien sous le seuil → pas d'appel, pas de bloc.
 */
async function fetchWeakestBlockers(
  supabase: unknown,
  map: CompetencyMasteryRow[],
): Promise<{ blockedSlug: string | null; blockers: CompetencyBlocker[] }> {
  const weakest = map
    .filter((c) => c.mastery < COMPETENCY_FAILING_THRESHOLD)
    .sort((a, b) => a.mastery - b.mastery)[0];
  if (!weakest) return { blockedSlug: null, blockers: [] };

  const client = supabase as CompetencyBlockersRpcClient;
  const res = await client.rpc("get_competency_blockers", { p_competency: weakest.slug });
  if (res.error) {
    logger.warn("getDashboard.competencyBlockers: RPC failed, defaulting to empty", {
      error: res.error.message,
    });
    return { blockedSlug: weakest.slug, blockers: [] };
  }
  return { blockedSlug: weakest.slug, blockers: res.data ?? [] };
}

async function fetchParcoursProgress(
  supabase: unknown,
  subjectIds: string[],
): Promise<Record<string, { total: number; completed: number }>> {
  const progress: Record<string, { total: number; completed: number }> = {};
  if (subjectIds.length === 0) return progress;

  const client = supabase as ParcoursProgressRpcClient;
  const res = await client.rpc("get_user_parcours_progress", { p_subject_ids: subjectIds });

  // Dégradation gracieuse, comme `stats` : si la RPC échoue (migration pas encore appliquée
  // pendant un déploiement), la carte s'affiche sans progression plutôt que de casser la page.
  if (res.error) {
    logger.warn("getDashboard.progress: parcours-progress RPC failed, defaulting to empty", {
      error: res.error.message,
    });
    return progress;
  }

  for (const row of res.data ?? []) {
    progress[row.subject_id] = {
      total: Number(row.chapters_total),
      completed: Number(row.chapters_completed),
    };
  }
  return progress;
}

function resolveFallbackDisplayName(claims: Record<string, unknown>): string {
  const userMetadata = claims.user_metadata;
  if (userMetadata && typeof userMetadata === "object") {
    const displayName = (userMetadata as Record<string, unknown>).display_name;
    if (typeof displayName === "string" && displayName.trim().length > 0) {
      return displayName.trim();
    }
  }

  return "Aspirant";
}

// ---------- Get dashboard ----------
export const getDashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const claims = (context.claims ?? {}) as Record<string, unknown>;
    const fallbackDisplayName = resolveFallbackDisplayName(claims);

    // Per-subject aggregates (#18) are computed over ALL of the user's attempts
    // by the `get_user_subject_stats` RPC (GROUP BY subject_id), so the dashboard
    // no longer transfers a user's entire attempt history to reduce it in JS
    // (perf audit M4). The result is bounded to one row per subject.
    const [profileRes, subjectsRes, recentRes, statsRes] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", userId).maybeSingle(),
      supabase.from("subjects").select("*").order("display_order"),
      supabase
        .from("attempts")
        .select("subject_id,score_pct,xp_earned,completed_at,exercise_id")
        .eq("user_id", userId)
        .order("completed_at", { ascending: false })
        .limit(DASHBOARD_RECENT_LIMIT),
      supabase.rpc("get_user_subject_stats"),
    ]);

    if (profileRes.error)
      failWithClientError("getDashboard.profile", profileRes.error, DASHBOARD_ERROR_FR);
    if (subjectsRes.error)
      failWithClientError("getDashboard.subjects", subjectsRes.error, DASHBOARD_ERROR_FR);
    if (recentRes.error)
      failWithClientError("getDashboard.recent", recentRes.error, DASHBOARD_ERROR_FR);
    // Stats degrade gracefully: if the RPC errors (e.g. the migration hasn't
    // applied yet during a deploy), show the dashboard with empty stats rather
    // than failing the whole page.
    if (statsRes.error)
      logger.warn("getDashboard.stats: subject-stats RPC failed, defaulting to empty", {
        error: statsRes.error.message,
      });

    let profile = profileRes.data;

    if (!profile) {
      const { error: profileInsertError } = await supabase
        .from("profiles")
        .insert({ id: userId, display_name: fallbackDisplayName });

      if (profileInsertError && profileInsertError.code !== "23505") {
        failWithClientError("getDashboard.profileInsert", profileInsertError, DASHBOARD_ERROR_FR);
      }

      const { data: profileData, error: profileReloadError } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", userId)
        .maybeSingle();

      if (profileReloadError)
        failWithClientError("getDashboard.profileReload", profileReloadError, DASHBOARD_ERROR_FR);
      profile = profileData;
    }

    // Build per-subject count/avg/xp from the bounded RPC aggregate (#18, M4).
    const bySubject: Record<string, { count: number; avg: number; xp: number }> = {};
    for (const r of statsRes.data ?? []) {
      bySubject[r.subject_id] = {
        count: Number(r.attempts_count),
        avg: Number(r.avg_score),
        xp: Number(r.total_xp),
      };
    }

    // Find next incomplete exercise (score < pass threshold)
    let nextExerciseId: string | null = null;
    if (recentRes.data && recentRes.data.length > 0) {
      const lastAttempt = recentRes.data[0];
      if (lastAttempt.score_pct < PASS_THRESHOLD_PCT) {
        nextExerciseId = lastAttempt.exercise_id;
      }
    }

    // Scope subjects by the student's ACTIVE parcours (#parcours-pivot). A parcours
    // pins a theme (and, for concours, a grade); the dashboard shows only that
    // parcours' subjects. Premium parcours without an entitlement surface their
    // subjects as locked (the server gate is authoritative; this only drives the
    // lock badges in the UI).
    const allSubjects = subjectsRes.data ?? [];
    const parcoursId = profile?.current_parcours_id ?? null;

    // Le catalogue des parcours est lu UNE fois : il sert au scoping des matières, à la
    // bannière de rentrée (R-4) et à la passerelle « Réviser » (R-17). Une trentaine de lignes,
    // donc on filtre ici plutôt que de refaire un aller-retour par usage.
    const { data: parcoursRows } = await supabase
      .from("parcours")
      .select("id,name_fr,theme_id,grade_id,is_premium,status");
    const parcoursList = parcoursRows ?? [];

    let subjects: typeof allSubjects = [];
    let premiumLockedSubjectIds: string[] = [];
    if (parcoursId) {
      const par = parcoursList.find((p) => p.id === parcoursId) ?? null;
      if (par) {
        subjects = allSubjects.filter(
          (s) =>
            s.theme_id === par.theme_id &&
            (par.grade_id ? s.grade_id === par.grade_id : s.grade_id == null),
        );
        if (par.is_premium) {
          const { data: ent } = await supabase.rpc("has_parcours_entitlement", {
            p_user: userId,
            p_parcours: parcoursId,
          });
          if (ent !== true) premiumLockedSubjectIds = subjects.map((s) => s.id);
        }
      }
    }
    // Other free parcours to discover (free-theme subjects not in the active parcours).
    const activeIds = new Set(subjects.map((s) => s.id));
    const otherSubjects = allSubjects.filter((s) => s.grade_id == null && !activeIds.has(s.id));

    // ---- Rentrée (étude 22, R-4 + R-17) ----------------------------------------------
    // Deux surfaces adossées aux mêmes données. La lecture des `grades` (une trentaine de
    // lignes, statiques) a lieu dès que l'élève a une classe, toute l'année : la passerelle
    // « Réviser » en dépend en permanence. La suggestion de promotion, elle, n'est calculée que
    // dans la fenêtre de rentrée — donc deux mois sur douze.
    let promotionSuggestion: {
      gradeName: string;
      /** Promotion directe : le parcours à rejoindre en un clic. */
      parcoursId: string | null;
      /**
       * Choix de section : la clé d'année de la page `/programme/lycee/$annee` (« 2eme »,
       * « 3eme », « bac »). Exclusif de `parcoursId` — l'un OU l'autre porte l'action.
       */
      drilldownYear: string | null;
    } | null = null;
    let reviseGateway: { parcoursId: string; name: string } | null = null;
    // Nom de la classe courante — la copie de la bannière l'interpelle (« tu prépares toujours
    // la 7ᵉ ? »), et un id ne se lit pas.
    let currentParcoursName: string | null = null;

    if (profile?.current_grade_id) {
      const { data: gradeRows } = await supabase
        .from("grades")
        .select("id,slug,name_fr,theme_id,display_order,is_selectable");
      const grades = gradeRows ?? [];
      const parcours = parcoursList;
      currentParcoursName = parcours.find((p) => p.id === parcoursId)?.name_fr ?? null;

      // R-4 : proposée, jamais imposée. La condition combine la fenêtre (1ᵉʳ sept → 31 oct) et
      // « le choix de classe précède cette rentrée » — sans quoi on proposerait de changer de
      // classe à quelqu'un qui vient précisément de la choisir.
      // `current_parcours_set_at` est créée par la migration `20260721090000` et manque donc
      // aux types Supabase générés (`supabase gen types` exige un accès DB, et le fichier est
      // généré). Même précédent que la RPC de progression du lot 1 : narrowing local ici,
      // types régénérés au prochain accès DB.
      const parcoursSetAt = (profile as { current_parcours_set_at?: string | null })
        .current_parcours_set_at;
      if (shouldOfferPromotion({ parcoursSetAt: parcoursSetAt ?? null })) {
        // `resolvePromotionTarget` renvoie null pour une classe terminale (bac — Q-3), et
        // signale les années à sections au lieu d'en choisir une d'office.
        const target = resolvePromotionTarget(grades, profile.current_grade_id);
        if (target) {
          // Une année à sections n'a pas de parcours propre : la bannière emmène sur la page
          // de l'année, et c'est l'élève qui choisit sa section. `lyceeYearOf` est la seule
          // traduction slug → clé d'année du projet ; on ne la réinvente pas ici.
          const drilldownYear = target.isSectionDrilldown
            ? (lyceeYearOf(target.gradeSlug) ?? null)
            : null;
          // Nommé `targetParcoursId` et non `parcoursId` : ce dernier désigne le parcours ACTIF
          // dans toute cette fonction, et le masquer ici tendrait un piège au prochain lecteur.
          const targetParcoursId = target.isSectionDrilldown
            ? null
            : (parcours.find((p) => p.grade_id === target.gradeId)?.id ?? null);
          // Sans action possible (ni parcours, ni page d'année), on ne propose rien plutôt que
          // d'afficher une bannière dont le bouton ne mène nulle part.
          if (targetParcoursId || drilldownYear) {
            promotionSuggestion = {
              gradeName: target.gradeName,
              parcoursId: targetParcoursId,
              drilldownYear,
            };
          }
        }
      }

      // R-17 : la passerelle « Réviser » pointe vers la classe PRÉCÉDENTE quand elle existe et
      // qu'elle a du contenu. C'est un lien, pas un changement de parcours (R-1) : l'ancre ne
      // bouge pas, on va simplement réviser à côté.
      const current = grades.find((g) => g.id === profile.current_grade_id);
      if (current) {
        const previous = grades
          .filter((g) => g.theme_id === current.theme_id && g.display_order < current.display_order)
          .filter((g) => g.is_selectable !== false)
          .sort((a, b) => b.display_order - a.display_order)[0];
        const previousParcours = previous
          ? parcours.find((p) => p.grade_id === previous.id && p.status === "available")
          : undefined;
        if (previousParcours) {
          reviseGateway = { parcoursId: previousParcours.id, name: previousParcours.name_fr };
        }
      }
    }

    // « Révision du jour » (étude 04, lot A1.1). Elle a remplacé la requête directe sur
    // `spaced_repetition_schedule` qui tenait la priorité 1 depuis le lot 6 de l'étude 22 :
    // même rôle, meilleure réponse — le plan arbitre par les misconceptions actives (D-3) et
    // ne propose que des exercices réellement jouables (R-3). Le moteur de priorité, lui,
    // n'a pas bougé d'une ligne (R-18, D-8) : il change de SOURCE, pas de règle.
    const dailyPlan = await fetchDailyPlan(supabase, DAILY_PLAN_MAX_ITEMS);

    // Carte de compétences (étude 07 lot 4, US-1) + « ce qui te bloque » (R-5). La carte en une
    // lecture ; les blocages en une seconde, seulement s'il existe une compétence en échec.
    const competencyMap = await fetchCompetencyMap(supabase);
    const { blockedSlug: competencyBlockedSlug, blockers: competencyBlockers } =
      await fetchWeakestBlockers(supabase, competencyMap);

    // Progression officielle par matière (étude 22 R-16) — bornée aux matières du parcours
    // actif, une seule requête. Alimente l'état `done` de la carte `/parcours`.
    const progress = await fetchParcoursProgress(
      supabase,
      subjects.map((s) => s.id),
    );

    // « Prochaine action » unifiée (R-31). Le dashboard ne charge ni chapitres ni exercices :
    // il résout donc les priorités 1, 2 et 4, et DÉLÈGUE la 3 au hub matière en désignant la
    // matière du chemin — qui la résoudra avec ce même moteur. Un seul CTA en sortira.
    const lastWorkedSubjectId = recentRes.data?.[0]?.subject_id ?? null;
    const nextAction = resolveNextAction({
      // La tête du plan EST la priorité 1 : le plan est déjà trié par urgence, donc le premier
      // élément est la révision que le moteur doit promouvoir.
      dueReviewExerciseId: dailyPlan[0]?.exercise_id ?? null,
      failedExerciseId: nextExerciseId,
      pathSubjectId: subjects.some((s) => s.id === lastWorkedSubjectId)
        ? lastWorkedSubjectId
        : null,
      untouchedSubjectId: subjects.find((s) => !bySubject[s.id])?.id ?? null,
    });

    return {
      profile,
      subjects,
      otherSubjects,
      stats: bySubject,
      progress,
      recent: recentRes.data ?? [],
      nextExerciseId,
      nextAction,
      dailyPlan,
      competencyMap,
      competencyBlockers,
      competencyBlockedSlug,
      promotionSuggestion,
      reviseGateway,
      currentParcoursName,
      premiumLockedSubjectIds,
      currentParcoursId: parcoursId,
    };
  });

// ---------- Get dashboard secondary sections (badges + inventory + shop) ----------
// Split out of getDashboard (#15): these heavy joins back the lazy/deferred
// radar/inventory and badges/shop sections, so they load via their own query
// once the primary dashboard has rendered.
export const getDashboardSecondary = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const [badgesRes, inventoryRes, shopRes] = await Promise.all([
      supabase
        .from("student_badges")
        .select("awarded_at, awarded_reason, badge:badges(code,name,rarity,icon_name)")
        .eq("student_user_id", userId)
        .order("awarded_at", { ascending: false }),
      supabase
        .from("inventory_items")
        .select(
          "quantity, is_equipped, is_active, acquired_at, item:shop_items(id,code,name,item_type,description,price_coins,effect_payload)",
        )
        .eq("student_user_id", userId)
        .order("acquired_at", { ascending: false }),
      supabase
        .from("shop_items")
        .select("id,code,name,item_type,description,price_coins,is_active,effect_payload")
        .eq("is_active", true)
        .order("price_coins", { ascending: true }),
    ]);

    if (badgesRes.error)
      failWithClientError("getDashboardSecondary.badges", badgesRes.error, DASHBOARD_ERROR_FR);
    if (inventoryRes.error)
      failWithClientError(
        "getDashboardSecondary.inventory",
        inventoryRes.error,
        DASHBOARD_ERROR_FR,
      );
    if (shopRes.error)
      failWithClientError("getDashboardSecondary.shop", shopRes.error, DASHBOARD_ERROR_FR);

    const badges = (badgesRes.data ?? []).flatMap((row: BadgeRow) => {
      if (!row.badge) return [];

      return [
        {
          code: row.badge.code,
          name: row.badge.name,
          rarity: row.badge.rarity,
          iconName: row.badge.icon_name,
          awardedAt: row.awarded_at,
          awardedReason: row.awarded_reason,
        },
      ];
    });

    // Armable consumables fall into two independent arming slots, derived from the
    // effect payload (mirrors activate_inventory_item):
    //   * "next-quest": multiplier potions (xpMultiplier/coinMultiplier) + the retry
    //     shield (retries) — applied to the next quest, one armed at a time.
    //   * "passive": the streak shield (streakShield) — protects a missed day
    //     automatically, armed independently of the next-quest slot.
    // Hint potions (hintBoost) carry no armable effect and stay out of scope.
    const armSlotFor = (
      itemType: string,
      payload: Record<string, unknown>,
    ): "next-quest" | "passive" | null => {
      if (itemType !== "potion" && itemType !== "shield") return null;
      if ("streakShield" in payload) return "passive";
      if ("xpMultiplier" in payload || "coinMultiplier" in payload || "retries" in payload) {
        return "next-quest";
      }
      return null;
    };

    // Hint consumables (booster_hint / potion_rappel) are NOT armed — they are
    // spent on demand during a quest via the "Indice" button. Each owned unit is
    // one reveal charge. The inventory UI labels them "à utiliser en quête" (no
    // "Activer" button). Mirrors the consume_hint RPC's eligibility check.
    const isHintConsumableFor = (itemType: string, payload: Record<string, unknown>): boolean =>
      (itemType === "booster" || itemType === "potion") &&
      ("hints" in payload || "hintBoost" in payload);

    const inventory = (inventoryRes.data ?? []).flatMap((row: InventoryRow) => {
      if (!row.item) return [];

      const payload =
        row.item.effect_payload && typeof row.item.effect_payload === "object"
          ? (row.item.effect_payload as Record<string, unknown>)
          : {};
      const armSlot = armSlotFor(row.item.item_type, payload);

      return [
        {
          code: row.item.code,
          name: row.item.name,
          itemType: row.item.item_type,
          description: row.item.description,
          priceCoins: row.item.price_coins,
          quantity: row.quantity,
          isEquipped: row.is_equipped,
          isActive: row.is_active,
          isArmable: armSlot !== null,
          armSlot,
          isHintConsumable: isHintConsumableFor(row.item.item_type, payload),
          acquiredAt: row.acquired_at,
        },
      ];
    });

    const inventoryByCode = new Map(inventory.map((item) => [item.code, item]));
    const shopItems: DashboardShopItem[] = (shopRes.data ?? []).map((item) => {
      const owned = inventoryByCode.get(item.code);
      const payload =
        item.effect_payload && typeof item.effect_payload === "object"
          ? (item.effect_payload as Record<string, unknown>)
          : {};
      const avatarSlug = typeof payload.avatarSlug === "string" ? payload.avatarSlug : null;
      const armSlot = armSlotFor(item.item_type, payload);

      return {
        code: item.code,
        name: item.name,
        itemType: item.item_type,
        description: item.description,
        priceCoins: item.price_coins,
        isOwned: Boolean(owned),
        isEquipped: owned?.isEquipped ?? false,
        quantity: owned?.quantity ?? 0,
        avatarSlug,
        isArmable: Boolean(owned) && armSlot !== null,
        armSlot,
        isActive: owned?.isActive ?? false,
      };
    });

    return { badges, inventory, shopItems };
  });

// ---------- Leaderboard ----------
// Reads through the SECURITY DEFINER `get_global_leaderboard` RPC rather than
// `profiles` directly: since migration 20260522153000 the profiles SELECT policy
// is "own or linked profiles", so a direct query returned ONLY the caller's row
// (you could see your own score but no one else's). The RPC aggregates across all
// students despite per-row RLS and — like the per-subject board — returns no peer
// `user_id`, only the public-safe fields plus the `is_me` flag. Rows past the
// visible window are dropped; the caller's own row is always returned so "my rank"
// is known even when outside the top `LEADERBOARD_LIMIT`.
export const getLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;

    const { data: rows, error } = await supabase.rpc("get_global_leaderboard", {
      p_limit: LEADERBOARD_LIMIT,
    });
    if (error) failWithClientError("getLeaderboard", error, DASHBOARD_ERROR_FR);

    const mapped = (rows ?? []).map((r) => ({
      rank: Number(r.rank),
      displayName: r.display_name,
      heroClass: r.hero_class,
      level: r.level,
      xp: Number(r.xp),
      streak: r.current_streak,
      avatarTier: r.avatar_tier,
      isMe: r.is_me,
    }));

    // Cold-start (étude 15 lot 11, D-7): never show a rank without XP. A brand-new
    // player with 0 XP must not surface as a « fictitious #1 » (nor be told they
    // rank Nth). They appear only once they've earned their first XP.
    const ranked = mapped.filter((r) => r.xp > 0);
    const leaderboard = ranked.filter((r) => r.rank <= LEADERBOARD_LIMIT);
    const myRank = ranked.find((r) => r.isMe) ?? null;

    return { leaderboard, myRank };
  });

// ---------- Grade cohort leaderboard (étude 22, R-23) ----------
// « Ma classe » : la même lecture que le classement global, ramenée aux élèves de MÊME
// `current_grade_id` — la cohorte scolaire, pas le parcours (D-5 : un « Concours 9ème » et un
// « 9ème » sont des pairs). Un élève sans grade (parcours libre) n'a pas de cohorte : la RPC
// renvoie vide et `hasCohort` dit au client de masquer l'onglet plutôt que d'afficher un
// classement vide sans raison.
//
// `rankedCount` porte la décision d'onglet par défaut (R-23/Q-1) : c'est le nombre d'élèves
// réellement classés dans la cohorte, pas la taille du top affiché — c'est lui que le seuil
// GRADE_TAB_DEFAULT_MIN_RANKED interroge.
export const getGradeLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: profile } = await supabase
      .from("profiles")
      .select("current_grade_id")
      .eq("id", userId)
      .maybeSingle();
    const hasCohort = Boolean(profile?.current_grade_id);
    if (!hasCohort) {
      return { leaderboard: [], myRank: null, hasCohort: false, rankedCount: 0 };
    }

    const { data: rows, error } = await (supabase as unknown as GradeLeaderboardRpcClient).rpc(
      "get_grade_leaderboard",
      { p_limit: LEADERBOARD_LIMIT },
    );
    if (error) failWithClientError("getGradeLeaderboard", error, DASHBOARD_ERROR_FR);

    const mapped = (rows ?? []).map((r) => ({
      rank: Number(r.rank),
      displayName: r.display_name,
      heroClass: r.hero_class,
      level: r.level,
      xp: Number(r.xp),
      streak: r.current_streak,
      avatarTier: r.avatar_tier,
      isMe: r.is_me,
    }));

    // La RPC filtre déjà `xp > 0` ; on garde le même filet que le global par symétrie.
    const ranked = mapped.filter((r) => r.xp > 0);
    const leaderboard = ranked.filter((r) => r.rank <= LEADERBOARD_LIMIT);
    const myRank = ranked.find((r) => r.isMe) ?? null;

    // Minorant du nombre de classés dans la cohorte. Deux sources, dont on prend le max :
    // le NOMBRE de lignes remontées (exact tant que la cohorte tient sous la limite, et seul
    // fiable en cas d'ex aequo — `rank()` partage le rang, donc dix élèves à égalité sont tous
    // rang 1), et le RANG le plus élevé vu (seul à révéler la profondeur réelle quand
    // l'appelant se situe au-delà du top remonté).
    const rankedCount = Math.max(
      ranked.length,
      ranked.reduce((max, r) => Math.max(max, r.rank), 0),
    );

    return { leaderboard, myRank, hasCohort: true, rankedCount };
  });

// ---------- Parcours catalogue (sellable journeys: concours + free libre tracks) ----------
// Each row is enriched with `hasEntitlement`: always true for free parcours, and for
// premium parcours the result of the `has_parcours_entitlement` RPC for the caller.
// The Explorer hub + onboarding read this to drive the Crown/Lock badges; the server
// gate (`resolve_exercise_access`) stays authoritative — this only shapes the UI.
// Anon-capable (chantier C8): the public catalogue (`/programme`, `/extras`) reads it
// without a session. An anonymous visitor holds no entitlement, so every parcours is
// returned `hasEntitlement: true` (the public register has no premium lock — the pivot
// is free) and the RPC is skipped. Authenticated behaviour is unchanged.
export const getParcours = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("parcours")
      .select(
        "id,name_fr,name_en,name_ar,kind,is_premium,status,display_order,icon,color,theme_id,grade_id",
      )
      .order("display_order");
    if (error) failWithClientError("getParcours", error, DASHBOARD_ERROR_FR);
    const rows = data ?? [];

    // Enrich each parcours with its grade's cycle + pedagogical order so the
    // school group can be grouped by cycle (primaire/collège/secondaire) and
    // ordered 1ère année → Bac. One cheap lookup beats N embedded joins.
    // `slug` + `is_selectable` (étude 16 lot 2) let the client group the lycée
    // year → section and hide the flat legacy nodes (R-1/R-2 — filter lives in
    // `buildPrograms`, lot 3); a grade-less (libre) parcours stays selectable.
    const { data: gradeRows } = await supabase
      .from("grades")
      .select("id,slug,cycle,display_order,is_selectable");
    const gradeById = new Map((gradeRows ?? []).map((g) => [g.id, g]));

    // Real volumetry per parcours (« N matières », étude 15 lot 8): a parcours pins a
    // (theme, grade) pair — grade null for the libre extras — and its subjects are the
    // ones sharing that pair. One cheap catalogue-wide scan → a count map keyed by pair.
    const { data: subjectRows } = await supabase.from("subjects").select("theme_id,grade_id");
    const subjectsCountByPair = new Map<string, number>();
    for (const s of subjectRows ?? []) {
      const key = `${s.theme_id}::${s.grade_id ?? ""}`;
      subjectsCountByPair.set(key, (subjectsCountByPair.get(key) ?? 0) + 1);
    }

    const enriched = await Promise.all(
      rows.map(async (p) => {
        const grade = p.grade_id ? gradeById.get(p.grade_id) : undefined;
        const base = {
          ...p,
          grade_cycle: grade?.cycle ?? null,
          grade_order: grade?.display_order ?? null,
          grade_slug: grade?.slug ?? null,
          grade_selectable: grade?.is_selectable ?? true,
          subjects_count: subjectsCountByPair.get(`${p.theme_id}::${p.grade_id ?? ""}`) ?? 0,
        };
        // Free parcours — and every parcours for an anonymous visitor — carry no
        // lock in the public register; skip the entitlement RPC (anon has none).
        if (!p.is_premium || !userId) return { ...base, hasEntitlement: true };
        const { data: ent } = await supabase.rpc("has_parcours_entitlement", {
          p_user: userId,
          p_parcours: p.id,
        });
        return { ...base, hasEntitlement: ent === true };
      }),
    );

    return { parcours: enriched };
  });

// ---------- Catalogue stats (landing proof band — real compiled numbers) ----------
// Anon-capable (étude 15 lot 8). The public landing replaces the "conforme au
// programme" *claim* with *proof*: the REAL compiled size of the free catalogue —
// how many subjects, taught chapters (each = one cours + one résumé) and corrected
// missions already exist — plus `sampleChapterId`, the first taught chapter of the
// richest subject, so « Voir un exemple de cours » deep-links into the public reader.
// Numbers are computed server-side (never hardcoded) and degrade to 0 on error. Only
// aggregate counts + one id cross the wire — no lesson content is transferred.
export const getCatalogueStats = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;
    const [subjectsRes, lessonsRes, exercisesRes, taughtRes] = await Promise.all([
      supabase.from("subjects").select("id", { count: "exact", head: true }),
      supabase
        .from("chapters")
        .select("id", { count: "exact", head: true })
        .not("lesson_content", "is", null),
      supabase.from("exercises").select("id", { count: "exact", head: true }),
      // id + subject only (never lesson_content); ordered so the first match per
      // subject is its lowest display_order chapter.
      supabase
        .from("chapters")
        .select("id,subject_id")
        .not("lesson_content", "is", null)
        .order("display_order"),
    ]);

    // Richest subject = the one with the most taught chapters; its first taught
    // chapter is the sample. Deterministic given the stable display_order sort.
    const taught = taughtRes.data ?? [];
    const perSubject = new Map<string, number>();
    for (const c of taught) perSubject.set(c.subject_id, (perSubject.get(c.subject_id) ?? 0) + 1);
    let richest: string | null = null;
    let richestCount = 0;
    for (const [subjectId, n] of perSubject) {
      if (n > richestCount) {
        richestCount = n;
        richest = subjectId;
      }
    }
    const sampleChapterId = richest
      ? (taught.find((c) => c.subject_id === richest)?.id ?? null)
      : null;

    return {
      subjects: subjectsRes.count ?? 0,
      lessons: lessonsRes.count ?? 0,
      exercises: exercisesRes.count ?? 0,
      sampleChapterId,
    };
  });

// ---------- Subjects of one parcours (public drill: catalogue → level → subjects) ----------
// Anon-capable (chantier C8). The public catalogue drills a parcours/level down to its
// subjects, each linking to the public subject hub (`/matiere/$subjectId`). A parcours
// pins a (theme, grade) pair — grade is null for the `libre` extras — and subjects are
// filtered exactly like getDashboard's active-parcours scoping. No gameplay and no
// premium lock here (free pivot); the server gate stays authoritative on `/quest`. A
// `coming_soon` parcours simply has no subjects yet → the page shows its "bientôt" state.
export const getParcoursSubjects = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) => z.object({ parcoursId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: parcours, error: parErr } = await supabase
      .from("parcours")
      .select("id,name_fr,name_en,name_ar,kind,is_premium,status,theme_id,grade_id")
      .eq("id", data.parcoursId)
      .maybeSingle();
    if (parErr) failWithClientError("getParcoursSubjects.parcours", parErr, DASHBOARD_ERROR_FR);
    if (!parcours) return { parcours: null, subjects: [] };

    let query = supabase
      .from("subjects")
      .select("id,name_fr,attribute,description,content_language")
      .eq("theme_id", parcours.theme_id)
      .order("display_order");
    query = parcours.grade_id
      ? query.eq("grade_id", parcours.grade_id)
      : query.is("grade_id", null);
    const { data: subjects, error } = await query;
    if (error) failWithClientError("getParcoursSubjects.subjects", error, DASHBOARD_ERROR_FR);

    return { parcours, subjects: subjects ?? [] };
  });

// ---------- Subjects of the caller's ACTIVE parcours (leaderboard tabs) ----------
// The leaderboard offers one tab per subject of the active parcours only (GAP-018):
// listing every academy subject produced ~30 tabs, with homonym subjects across
// grades (e.g. "Mathématiques" in 9ème AND 6ème) indistinguishable. Scoping to the
// parcours both trims the tab row and removes the ambiguity (one grade → one
// subject per name). Same resolution as getDashboard: profile → parcours →
// subjects of its (theme, grade) pair. No parcours (pre-onboarding) → empty list,
// the page then shows the Global tab alone.
export const getLeaderboardSubjects = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: profile } = await supabase
      .from("profiles")
      .select("current_parcours_id")
      .eq("id", userId)
      .maybeSingle();
    const parcoursId = profile?.current_parcours_id ?? null;
    if (!parcoursId) return { subjects: [] };

    const { data: par } = await supabase
      .from("parcours")
      .select("theme_id,grade_id")
      .eq("id", parcoursId)
      .maybeSingle();
    if (!par) return { subjects: [] };

    let query = supabase
      .from("subjects")
      .select("id,name_fr,color_token,icon,content_language")
      .eq("theme_id", par.theme_id)
      .order("display_order");
    query = par.grade_id ? query.eq("grade_id", par.grade_id) : query.is("grade_id", null);
    const { data: rows, error } = await query;
    if (error) failWithClientError("getLeaderboardSubjects", error, DASHBOARD_ERROR_FR);
    return { subjects: rows ?? [] };
  });

// ---------- Per-subject leaderboard (ranked by XP earned in the subject) ----------
export const getSubjectLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ subjectId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: rows, error } = await supabase.rpc("get_subject_leaderboard", {
      p_subject: data.subjectId,
      p_limit: LEADERBOARD_LIMIT,
    });
    if (error) failWithClientError("getSubjectLeaderboard", error, DASHBOARD_ERROR_FR);

    // SECURITY: the RPC no longer returns peer `user_id`s (UUID-leak fix). Rows
    // are identified to the client by `rank` (stable, unique per board) and the
    // self row by the RPC's `is_me` flag — no other user's id is ever exposed.
    const mapped = (rows ?? []).map((r) => ({
      rank: Number(r.rank),
      displayName: r.display_name,
      heroClass: r.hero_class,
      level: r.level,
      xp: Number(r.subject_xp),
      streak: r.current_streak,
      avatarTier: r.avatar_tier,
      isMe: r.is_me,
    }));

    // Cold-start (D-7): never show a rank without XP — same rule as the global board.
    const ranked = mapped.filter((r) => r.xp > 0);
    const leaderboard = ranked.filter((r) => r.rank <= LEADERBOARD_LIMIT);
    const myRank = ranked.find((r) => r.isMe) ?? null;

    return { leaderboard, myRank };
  });

// ---------- Get Sprint 2 dashboard data (daily objectives + weekly quests + spaced rep) ----------
export const getSprint2Dashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const currentWeekStart = getCurrentWeekStartUtc();
    const today = getTodayUtc();

    // Create today's daily objective & this week's weekly quest if missing, so
    // the widgets show a real goal (and the submit RPC has a row to increment).
    await supabase.rpc("ensure_daily_weekly_goals", { p_user: userId });

    const [dailyObjs, weeklyQs, spacedRep] = await Promise.all([
      supabase
        .from("daily_objectives")
        .select(
          "id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at",
        )
        .eq("user_id", userId)
        // #2: only today's objectives (UTC). A 24h-ago lower bound returned
        // yesterday + today, inflating daily XP and producing duplicate rows.
        .eq("objective_date", today),
      supabase
        .from("weekly_quests")
        .select(
          "id,quest_type,target_value,current_value,xp_reward,coin_reward,status,completed_at",
        )
        .eq("user_id", userId)
        .eq("week_start_date", currentWeekStart),
      supabase
        .from("spaced_repetition_schedule")
        .select("id,retry_level,scheduled_for,exercises(id,title)")
        .eq("user_id", userId)
        .eq("status", "pending")
        .lte("scheduled_for", new Date().toISOString())
        .limit(3),
    ]);

    if (dailyObjs.error)
      failWithClientError(
        "getSprint2Dashboard.dailyObjectives",
        dailyObjs.error,
        DASHBOARD_ERROR_FR,
      );
    if (weeklyQs.error)
      failWithClientError("getSprint2Dashboard.weeklyQuests", weeklyQs.error, DASHBOARD_ERROR_FR);
    if (spacedRep.error)
      failWithClientError("getSprint2Dashboard.spacedRep", spacedRep.error, DASHBOARD_ERROR_FR);

    return {
      dailyObjectives: dailyObjs.data ?? [],
      weeklyQuests: weeklyQs.data ?? [],
      pendingSpacedReps: spacedRep.data ?? [],
    };
  });

// ---------- Family weekly goal (set by a linked parent) ----------
const familyGoalSchema = z
  .object({
    weekStart: z.string().catch(""),
    target: z.coerce.number().catch(0),
    done: z.coerce.number().catch(0),
  })
  .nullable()
  .catch(null);

/**
 * The student's current-week family goal (target set by a linked parent +
 * live progress). Null when no goal is set — and, defensively, when the RPC
 * is not deployed yet (graceful degradation, same pattern as best-scores).
 */
export const getMyFamilyGoal = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data, error } = await supabase.rpc("get_family_weekly_goal", {
      p_student: userId,
    });
    if (error) {
      logger.warn("getMyFamilyGoal: RPC unavailable, degrading to null", {
        message: error.message,
      });
      return null;
    }

    return familyGoalSchema.parse(data ?? null);
  });
