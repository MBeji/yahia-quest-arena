// LE COMPTEUR D'ÉNERGIE ET LES DEUX MESURES DU CACHE — étude 11 lot 7.
//
// CE QUE CE FICHIER FAIT, ET SURTOUT CE QU'IL NE REFAIT PAS
// ---------------------------------------------------------------------------
// Toute la MÉCANIQUE d'énergie existe déjà en base depuis la migration
// 20260823110000 : `get_tutor_energy()` lit l'état du jour, `recharge_tutor_energy()`
// échange une charge d'indice contre +3, et `tutor_daily_energy()` /
// `tutor_hard_daily_cap()` gardent les seuils. Elles sont couvertes par 27
// assertions pgTAP (`68_tutor_platform_energy.test.sql`). Ce fichier n'en
// réimplémente aucune ligne : il les APPELLE et rend un état affichable.
//
// R-15 PARTOUT : AUCUNE DES TROIS SERVER FNS NE LÈVE
// ---------------------------------------------------------------------------
// Les trois RPC appelées ici lèvent, elles. `get_tutor_energy()` et
// `recharge_tutor_energy()` font `RAISE EXCEPTION 'Not authenticated.'` quand
// `auth.uid()` est nul ; `get_tutor_cache_stats()` refuse un non-admin par
// `Unauthorized`. Un refus doit rester un ÉTAT RENDU : une jauge qui plante
// emporterait le tableau de bord entier, et un panneau d'admin qui lève laisse
// la console sur une page blanche. On rend donc `null` (ou `outcome: "unknown"`)
// et l'écran sait le dire.
//
// ⚠️ `get_tutor_energy()` REND UN OBJET JSONB, PAS UNE TABLE.
// Le parsing est `schema.safeParse(data)` DIRECTEMENT. Le motif
// `Array.isArray(data) ? data[0] : null` de `getAiAdminOverview` vaut pour un
// `RETURNS TABLE` ; l'appliquer ici rendrait `null` en silence, et le compteur
// resterait vide sans qu'aucune erreur ne soit journalisée.
//
// POURQUOI UN FICHIER À PART DE `tutor.server.ts`
// ---------------------------------------------------------------------------
// Le précédent est établi deux fois (`tutor.stream.server.ts` au lot 3,
// `tutor.practice.server.ts` au lot 5) : `tutor.server.ts` frôle son plafond
// ESLint `max-lines`. On scinde par sujet plutôt que de raboter des commentaires
// pour gagner un tour de gate.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { rechargeOutcome, type TutorEnergyReading, type TutorRechargeOutcome } from "./energy";

/**
 * Les RPC de ce lot ne sont pas dans les types générés (ils se régénèrent depuis
 * la base, et la base ne les a pas avant la migration). Contrat figé ici, motif
 * `tutor.server.ts` / `tutor.practice.server.ts` — À SUPPRIMER à la prochaine
 * régénération de `supabase/types.ts`.
 */
type TutorEnergyRpcClient = {
  rpc: (
    fn: "get_tutor_energy" | "recharge_tutor_energy" | "get_tutor_cache_stats",
    args?: Record<string, unknown>,
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

/**
 * Les cinq clés de `get_tutor_energy()`, aux noms exacts de son
 * `jsonb_build_object`. Les entiers d'un JSONB arrivent en NOMBRES (et non en
 * chaînes comme les BIGINT d'un `RETURNS TABLE` via PostgREST) : pas de
 * `z.coerce` ici, qui masquerait un jour un champ devenu texte.
 */
const readingSchema = z.object({
  used: z.number().int().min(0),
  bonus: z.number().int().min(0),
  max: z.number().int().min(0),
  left: z.number().int().min(0),
  canRecharge: z.boolean(),
});

/**
 * L'énergie du jour de l'élève courant. `null` = « on n'a pas su lire », et
 * l'écran se tait plutôt que d'afficher un 0 qui ressemblerait à « épuisé ».
 * Confondre les deux enverrait un enfant se coucher alors qu'il lui restait ses
 * dix questions.
 *
 * Aucun `.inputValidator` : la RPC ne prend pas d'argument et lit `auth.uid()`
 * elle-même. C'est le cas de 27 des 68 server fns du dépôt, et la règle ESLint
 * `local/require-server-fn-auth` documente explicitement pourquoi elle n'exige
 * que le middleware — sans validateur, TanStack type déjà `data` à `undefined`.
 */
export const getTutorEnergy = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<TutorEnergyReading | null> => {
    const client = context.supabase as unknown as TutorEnergyRpcClient;
    const { data, error } = await client.rpc("get_tutor_energy");
    const parsed = readingSchema.safeParse(data);
    if (error || !parsed.success) {
      logger.warn("tutor.energy.read", { error: error ? errorMessage(error) : "shape" });
      return null;
    }
    return parsed.data;
  });

/**
 * Le retour d'un échange. `count` porte les trois compteurs que la RPC rend dans
 * ses TROIS branches — y compris les refus, qui n'écrivent rien mais disent
 * quand même où en est l'élève.
 *
 * ⚠️ `bonus` et `canRecharge` n'y sont PAS : `recharge_tutor_energy()` ne les
 * rend pas. C'est pourquoi l'écran ré-interroge `getTutorEnergy` après un
 * échange réussi au lieu de reconstruire une lecture complète à partir d'ici —
 * une lecture partielle promue en lecture complète est une invention.
 */
export type TutorRechargeResult = {
  readonly outcome: TutorRechargeOutcome;
  /** Le nom de l'objet consommé — jamais renseigné quand rien n'a été pris. */
  readonly itemName: string | null;
  /** `null` quand l'appel n'a rien rendu de lisible. */
  readonly count: { readonly used: number; readonly max: number; readonly left: number } | null;
};

const rechargeSchema = z.object({
  consumed: z.boolean(),
  reason: z.string(),
  /** Présent uniquement quand `consumed` est vrai — d'où le `nullish`. */
  itemName: z.string().nullish(),
  used: z.number().int().min(0),
  max: z.number().int().min(0),
  left: z.number().int().min(0),
});

/**
 * Échanger une charge d'indice contre de l'énergie (R-12, D-9).
 *
 * R-11 : AUCUNE RÉCOMPENSE N'EST ATTRIBUÉE ICI — ni XP, ni pièce, ni badge. Le
 * seul mouvement est un ÉCHANGE, et il va dans l'autre sens : l'élève dépense
 * quelque chose qu'il a gagné en jouant. C'est ce qui rend le wording de la
 * phase gratuite tenable (D-14) — l'énergie ne s'achète pas, elle se joue.
 *
 * Trois issues, jamais deux : réussi, déjà au plafond, pas de charge. Les deux
 * refus ne consomment RIEN (invariant anti-gaspillage repris de `consume_hint`),
 * et l'écran doit le dire — un enfant qui croit avoir perdu son indice pour rien
 * ne réessaiera pas.
 */
export const rechargeTutorEnergy = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<TutorRechargeResult> => {
    const client = context.supabase as unknown as TutorEnergyRpcClient;
    const { data, error } = await client.rpc("recharge_tutor_energy");
    const parsed = rechargeSchema.safeParse(data);
    if (error || !parsed.success) {
      logger.warn("tutor.energy.recharge", { error: error ? errorMessage(error) : "shape" });
      return { outcome: "unknown", itemName: null, count: null };
    }

    const outcome = rechargeOutcome(parsed.data);
    // Sans PII (R-14) : le verdict, rien d'autre. Ni identifiant d'élève, ni nom
    // d'objet — c'est la trace d'un usage, pas un journal de comportement.
    logger.info("tutor.energy.recharge", { outcome });

    return {
      outcome,
      // Ceinture ET bretelles : la RPC n'attache `itemName` qu'à un échange
      // réussi, et l'écran ne l'affichera jamais autrement. Une phrase qui nomme
      // un objet est comprise comme « il a été pris ».
      itemName: outcome === "recharged" ? (parsed.data.itemName ?? null) : null,
      count: { used: parsed.data.used, max: parsed.data.max, left: parsed.data.left },
    };
  });

/**
 * LES DEUX MESURES DU LOT 7, telles que `get_tutor_cache_stats(p_days INT)` les
 * rend — un JSONB, comme les deux RPC ci-dessus.
 *
 * ⚠️ CONTRAT DE CLÉS, ET IL EST PARTAGÉ AVEC LA MIGRATION.
 * Les deux TAUX sont OBLIGATOIRES et volontairement sans `.catch()` : un
 * `.catch(0)` sur un nom de clé qui aurait dérivé afficherait « 0 % » pour
 * toujours, sans erreur nulle part — exactement le piège que ces mesures
 * existent pour éviter. Une clé manquante rend donc `null`, et le panneau dit
 * « mesure indisponible » : un aveu se corrige, un zéro silencieux se croit.
 *
 * Les DÉTAILS (numérateurs, dénominateurs, fenêtre) sont `optional` : ils
 * enrichissent l'affichage sans le conditionner, et leur absence se voit à
 * l'écran (« — ») au lieu de se maquiller en zéro.
 *
 * Taux attendus en RATIO 0 → 1 (`ROUND(x, 3)`), comme `forge_discard_rate` de
 * `get_ai_console` dont la formule est reprise à l'identique côté plateforme.
 */
const cacheStatsSchema = z.object({
  /** Part des explications servies depuis le pot commun, sans nouvel appel (R-15.2). */
  hitRate: z.coerce.number(),
  /** Part des candidats de la Forge jetés par la double résolution (R-18bis). */
  discardRate: z.coerce.number(),
  /**
   * R-15.3 — part de ce qui est ENTRÉ au pot commun qui en est RESSORTI, sur la
   * cohorte : deux voix distinctes en 👎 retirent une explication du service.
   *
   * ⚠️ `optional`, contrairement aux deux taux ci-dessus, et pas par confort :
   * ce panneau est déployé avant que sa migration ne soit forcément appliquée
   * (Vercel et `db-migrate-prod` courent en parallèle sur le même merge). Exiger
   * la clé éteindrait TOUT le panneau — hit-rate et rebut compris — pour une
   * mesure qui manque. Absente, elle affiche « — », et les deux autres tiennent.
   */
  evictionRate: z.coerce.number().optional(),
  hits: z.coerce.number().optional(),
  misses: z.coerce.number().optional(),
  evictedRows: z.coerce.number().optional(),
  sharedRows: z.coerce.number().optional(),
  discarded: z.coerce.number().optional(),
  kept: z.coerce.number().optional(),
  /** La fenêtre réellement appliquée par le SQL, en jours. */
  days: z.coerce.number().optional(),
  /**
   * Le hit-rate est-il « depuis toujours » plutôt que fenêtré ? `serve_count`
   * est cumulatif et non daté : si la migration a tranché pour le ratio à vie,
   * l'écran doit l'ANNONCER — un ratio sans sa fenêtre est un chiffre qu'on ne
   * peut pas contredire.
   */
  lifetimeHitRate: z.boolean().optional(),
});

export type TutorCacheStats = z.infer<typeof cacheStatsSchema>;

/**
 * Les deux mesures, pour la console admin. `null` couvre les deux refus
 * possibles — non-admin (`Unauthorized`) et forme illisible — parce que le
 * panneau ne fait pas la différence : dans les deux cas il n'a rien à montrer.
 * La porte autoritaire reste la RPC, `SECURITY DEFINER` : le fait que la route
 * masque le panneau aux non-admins est un confort d'affichage, pas un contrôle.
 */
export const getTutorCacheStats = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        /**
         * La fenêtre demandée. Bornée : une valeur absurde ferait balayer toute
         * la table à un écran qui se recharge à chaque visite.
         */
        days: z.number().int().min(1).max(365).default(30),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<TutorCacheStats | null> => {
    const client = context.supabase as unknown as TutorEnergyRpcClient;
    const { data: raw, error } = await client.rpc("get_tutor_cache_stats", { p_days: data.days });
    const parsed = cacheStatsSchema.safeParse(raw);
    if (error || !parsed.success) {
      // `warn` et non `error` : un non-admin qui atteint cette route est un cas
      // prévu, pas un incident. Mais on le journalise quand même — c'est ici que
      // se verrait une dérive de noms de clés entre le SQL et ce schéma.
      logger.warn("tutor.cacheStats", { error: error ? errorMessage(error) : "shape" });
      return null;
    }
    return parsed.data;
  });
