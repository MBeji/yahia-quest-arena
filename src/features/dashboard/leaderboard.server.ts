import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * Les CLASSEMENTS — global, ma classe, par matière, et (é31 lot 5) la semaine.
 *
 * Sortis de `dashboard.server.ts` avec le lot 5 : ils forment un sujet à eux
 * seuls (quatre lectures, un seul contrat de sortie), et le module de lecture du
 * tableau de bord était au plafond de complexité.
 *
 * Un invariant commun aux quatre, et il ne se relâche jamais : **aucun `user_id`
 * de tiers ne sort d'ici.** Les RPC rendent un pseudo, un rang et des nombres ;
 * l'appelant est le seul à être identifiable, par `is_me`.
 */

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

/** Taille du tableau — la ligne de l'appelant s'y ajoute même hors du top. */
const LEADERBOARD_LIMIT = 50;

// ⚠️ Le MÊME message que `dashboard.server.ts` : cette extraction est un
// déplacement, pas une amélioration. Changer le texte au passage rendrait le
// diff illisible et ferait mentir « rien d'autre n'a bougé ».
const DASHBOARD_ERROR_FR = "Impossible de charger le tableau de bord. Veuillez réessayer.";

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

/**
 * é31 lot 5 (US-7, R-15, Q-3) — LE CLASSEMENT DE LA SEMAINE.
 *
 * L'XP du classement était CUMULÉ À VIE : un compte de septembre ne rattraperait
 * jamais un compte de juin. C'est l'anti-« fresh start » exact, et il décourage
 * précisément celui qui vient d'arriver. La semaine ISO redonne à chacun une
 * course où il peut exister — le cumulatif reste, en second onglet.
 *
 * ⚠️ `get_weekly_leaderboard` est postérieure aux types générés : contrat étroit,
 * comme les autres RPC récentes.
 */
type WeeklyLeaderboardClient = {
  rpc: (
    fn: "get_weekly_leaderboard",
    args: { p_scope: string; p_limit: number },
  ) => PromiseLike<{
    data:
      | {
          rank: number;
          display_name: string;
          hero_class: string;
          level: number;
          xp: number;
          current_streak: number;
          avatar_tier: number;
          is_me: boolean;
        }[]
      | null;
    error: { message: string } | null;
  }>;
};

export const getWeeklyLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ scope: z.string().min(1).max(64) }).parse(d))
  .handler(async ({ context, data }) => {
    const client = context.supabase as unknown as WeeklyLeaderboardClient;
    const { data: rows, error } = await client.rpc("get_weekly_leaderboard", {
      p_scope: data.scope,
      p_limit: LEADERBOARD_LIMIT,
    });
    if (error) failWithClientError("getWeeklyLeaderboard", error, DASHBOARD_ERROR_FR);

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

    return {
      leaderboard: mapped.filter((r) => !r.isMe),
      myRank: mapped.find((r) => r.isMe) ?? null,
    };
  });
