// LE BILAN HEBDOMADAIRE — étude 11 lot 6, l'étage serveur (US-13, US-14, Q-5).
//
// TROIS ENTRÉES, ET UNE SEULE DÉPENSE
// ---------------------------------------------------------------------------
//   • `getWeeklyDigest`      — LECTURE, pour l'écran. Ne produit rien, ne paie rien.
//   • `generateWeeklyDigests`— UNE TRANCHE du batch. Le seul appel de modèle du lot.
//   • `handleDigestCron`     — la porte HTTP par laquelle la tranche est déclenchée.
//
// POURQUOI UNE PORTE HTTP ET PAS UN SCRIPT QUI PARLE À LA BASE
// ---------------------------------------------------------------------------
// Un script `.mjs` de `scripts/` ne peut PAS produire de texte : il n'a ni les
// alias Vite (`@/`), ni le droit d'importer du `.server`, donc pas d'accès à
// `callAi` — et `callAi` est la seule porte qui résout l'accès, réserve la
// dépense, comptabilise et rembourse. Un batch qui écrirait en base par
// `service_role` pourrait poser des lignes, jamais les rédiger.
//
// Le seul motif du dépôt pour un traitement par lot est donc celui de
// `/api/cron/notify` : une route interceptée dans `src/server.ts` avant le
// handler SSR, gardée par `Authorization: Bearer ${CRON_SECRET}`, qui lit en
// `service_role` et rend du JSON. On le rejoue ici, on ne l'invente pas.
//
// POURQUOI DES TRANCHES, ET NON UN BATCH
// ---------------------------------------------------------------------------
// La fonction SSR est configurée à `maxDuration: 300` secondes
// (`scripts/build-vercel.mjs`). Cette valeur était à 30 s jusqu'au 2026-08-25,
// sur la foi d'une limite du plan Hobby qui n'existe plus depuis `fluid
// compute` — la contrainte avait disparu, le commentaire était resté, et le
// découpage ci-dessous en avait hérité une marge inutilement serrée.
// Un appel de modèle se compte en secondes et un élève lié à un parent
// en coûte deux. Cette route traite donc ce qu'elle peut dans un BUDGET de
// temps, rend un curseur, et c'est `scripts/ai/tutor-digests.mjs` qui rappelle
// jusqu'à épuisement. Une tranche interrompue se rejoue telle quelle : les
// bilans déjà écrits sont sautés avant toute dépense.
//
// LA CADENCE — UN SEUL RENDEZ-VOUS, DEUX HORLOGES, ET L'ORDRE COMPTE
// ---------------------------------------------------------------------------
// Le rendez-vous dominical parent existe DÉJÀ : Vercel Cron frappe
// `/api/cron/notify` chaque jour à 18:00 UTC, et le dimanche (heure de Tunis)
// `dispatchParentDigest` pousse « ton bilan hebdo est prêt » à tout parent lié.
// Cette promesse n'avait pas de contenu — c'est ce lot qui le fabrique.
//
// Le batch tourne donc le dimanche à 05:00 UTC, TREIZE HEURES AVANT la
// notification. L'ordre est le contrat : la notification ne peut plus annoncer
// un bilan qui n'existe pas. Brancher la génération DANS `handlePushCron`
// aurait donné une horloge unique, mais aurait mis un batch de plusieurs
// minutes dans une fonction qui en a 300 — et son échec aurait emporté
// l'envoi des push avec lui.
//
// R-11 — AUCUNE RÉCOMPENSE, ET RIEN QUI Y RESSEMBLE
// ---------------------------------------------------------------------------
// Ce fichier n'écrit dans aucune des tables de jeu : ni `attempts`, ni XP, ni
// pièces, ni badge, ni SM-2. Il écrit une ligne de texte et une seule, par
// `store_tutor_digest`. Le précédent qui fait foi est `submit_tutor_mini_check`.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { callAi } from "@/features/ai/ai-call.server";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { TUTOR_LANGS, type TutorLang } from "./prompt";
import {
  buildDigestBlocks,
  digestSystem,
  digestWeekStart,
  readDigestInputs,
  TUTOR_DIGEST_AUDIENCES,
  validateDigestOutput,
  type TutorDigestAudience,
  type TutorDigestFacts,
} from "./digest";

/**
 * Les RPC du lot 6 (migration 20260824120000) sont postérieures aux types
 * Supabase générés — contrat figé ici, motif `tutor.server.ts` /
 * `ai-call.server.ts`. À SUPPRIMER à la prochaine régénération de
 * `src/shared/integrations/supabase/types.ts`.
 */
/**
 * Les LECTURES de table que le batch fait en direct. Aucune n'a de RPC, et
 * aucune n'en mérite une :
 *
 *  • `profiles` sert à ÉNUMÉRER les élèves, par ordre d'id. C'est une pagination,
 *    pas une règle métier — et elle passe par le client TYPÉ, comme partout.
 *  • `parent_student_links` répond à « cet élève a-t-il un parent lié ACTIF ? ».
 *    `is_parent_of_student(parent, élève)` exige les DEUX côtés, et le batch n'a
 *    pas de parent en main. Le précédent est `dispatchParentDigest`
 *    (`notifications.cron.server.ts`), qui filtre exactement de la même façon —
 *    `.eq("is_active", true)` — pour choisir à qui pousser la notification que
 *    ce bilan-ci vient remplir. Deux lectures cohérentes de la même colonne,
 *    pas deux juges.
 *  • `tutor_digests` dit ce qui est DÉJÀ écrit pour la semaine. C'est la garde
 *    anti-double-facture : `store_tutor_digest` remplace la ligne sur conflit,
 *    donc sans cette lecture un rejeu paierait une seconde fois. Cette table est
 *    postérieure aux types générés — contrat local, à supprimer à la prochaine
 *    régénération.
 */
type DigestRowReader = {
  from: (table: "tutor_digests") => {
    select: (cols: "audience") => {
      eq: (
        col: "user_id",
        val: string,
      ) => {
        eq: (
          col: "week_start",
          val: string,
        ) => PromiseLike<{ data: { audience: string }[] | null; error: unknown }>;
      };
    };
  };
};

// ---------------------------------------------------------------------------
// LECTURE — l'écran
// ---------------------------------------------------------------------------

/**
 * Ce que l'écran rend. Quatre états, JAMAIS une exception (R-15) :
 *
 *   • `digest`      — il y en a un, le voici ;
 *   • `not-yet`     — la semaine n'en a pas encore produit (cas nominal du lundi
 *                     au samedi, et de tout compte neuf) ;
 *   • `not-linked`  — le lien parent est coupé ou inactif ;
 *   • `unavailable` — on n'a pas pu lire. Panne, pas absence.
 *
 * `not-linked` est SÉPARÉ de `not-yet`, et la migration explique pourquoi mieux
 * que ce commentaire ne le ferait : « lien inactif » se règle en rétablissant le
 * lien, « pas encore de bilan » en attendant dimanche. Les confondre ferait
 * attendre indéfiniment un parent dont le lien est simplement à réactiver.
 */
export type TutorDigestView =
  | {
      readonly kind: "digest";
      readonly audience: TutorDigestAudience;
      readonly weekStart: string;
      readonly lang: TutorLang;
      readonly body: string;
    }
  | { readonly kind: "none"; readonly reason: "not-yet" | "not-linked" | "unavailable" };

const storedDigestSchema = z.object({
  available: z.boolean(),
  weekStart: z.string().nullable().catch(null),
  lang: z.enum(TUTOR_LANGS).nullable().catch(null),
  body: z.string().nullable().catch(null),
});

/**
 * Lit le bilan de la semaine — celui de l'élève, ou celui écrit POUR le parent.
 *
 * Deux RPC et non une, parce que la base en expose deux : `get_tutor_digest()`
 * lit `auth.uid()` sous sa propre policy, `get_tutor_parent_digest(élève)` juge
 * le lien par `is_parent_of_student` puis lit. Aucune des deux ne peut servir
 * l'autre audience — c'est la table qui le garantit, par sa colonne `audience`.
 *
 * ⚠️ Un parent ne reçoit JAMAIS le texte écrit pour son enfant, et
 * réciproquement. Q-5 : « compteur + thèmes agrégés + digest hebdo, jamais le
 * verbatim des conversations » — et le bilan élève, tutoyé, est adressé à
 * l'enfant, pas à son dossier.
 */
export const getWeeklyDigest = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        audience: z.enum(TUTOR_DIGEST_AUDIENCES).default("student"),
        /** Requis pour l'audience `parent`, ignoré pour l'élève (la RPC lit `auth.uid()`). */
        studentId: z.guid().nullable().default(null),
        /** `null` ⇒ le plus récent, et c'est le défaut utile : le bilan naît le dimanche. */
        weekStart: z.iso.date().nullable().default(null),
      })
      .parse(d ?? {}),
  )
  .handler(async ({ data, context }): Promise<TutorDigestView> => {
    const client = context.supabase;

    if (data.audience === "parent" && !data.studentId) {
      // Un écran parent sans élève désigné est un bug d'appelant, pas un état de
      // la base — mais il se rend quand même, plutôt que de lever (R-15).
      return { kind: "none", reason: "unavailable" };
    }

    // Le `&& data.studentId` est REDONDANT avec la garde ci-dessus — et c'est
    // exactement son intérêt : il rend au compilateur ce que la garde promettait
    // en commentaire. Élargir le type serait faux ici, parce que le SQL REFUSE
    // NULL : `is_parent_of_student(v_parent, NULL)` est faux, donc `NOT_LINKED`.
    // `p_week_start`, lui, est `DATE DEFAULT NULL` des deux côtés : l'omettre
    // vaut NULL, et NULL veut dire « le bilan le plus récent ».
    const { data: raw, error } =
      data.audience === "parent" && data.studentId
        ? await client.rpc("get_tutor_parent_digest", {
            p_student_id: data.studentId,
            p_week_start: data.weekStart ?? undefined,
          })
        : await client.rpc("get_tutor_digest", { p_week_start: data.weekStart ?? undefined });

    if (error) {
      // `get_tutor_parent_digest` LÈVE `NOT_LINKED` sur un lien coupé : c'est le
      // seul cas d'erreur qu'on distingue, parce que c'est le seul auquel le
      // lecteur peut faire quelque chose.
      const linkCut = /NOT_LINKED|NOT_AUTHENTICATED/.test(error.message);
      logger.warn("tutor.digest.read", { audience: data.audience, error: errorMessage(error) });
      return { kind: "none", reason: linkCut ? "not-linked" : "unavailable" };
    }

    const parsed = storedDigestSchema.safeParse(raw);
    if (!parsed.success) return { kind: "none", reason: "unavailable" };
    const row = parsed.data;
    if (!row.available || !row.body || !row.weekStart) return { kind: "none", reason: "not-yet" };

    return {
      kind: "digest",
      audience: data.audience,
      weekStart: row.weekStart,
      lang: row.lang ?? "fr",
      body: row.body,
    };
  });

// ---------------------------------------------------------------------------
// GÉNÉRATION — la seule dépense du lot
// ---------------------------------------------------------------------------

export type TutorDigestBatchSummary = {
  readonly weekStart: string;
  readonly dryRun: boolean;
  /** Élèves EXAMINÉS dans cette tranche, y compris ceux qu'on a sautés. */
  readonly examined: number;
  readonly written: number;
  /** Semaine sans une seule mission : rien à raconter, donc rien de dépensé. */
  readonly skippedEmpty: number;
  /** Bilan déjà écrit pour cette semaine : un rejeu ne repaie pas. */
  readonly skippedDone: number;
  /** Le modèle a refusé, ou sa sortie a été rejetée deux fois. */
  readonly degraded: number;
  /** Le curseur à repasser. `null` quand il n'y a plus d'élève après. */
  readonly lastStudentId: string | null;
};

export type TutorDigestBatchOptions = {
  readonly dryRun: boolean;
  /** Plafond d'élèves RÉDIGÉS dans la tranche — le second frein, après le temps. */
  readonly limit: number;
  /** Curseur : n'examiner que les élèves dont l'id est APRÈS celui-ci. */
  readonly after: string | null;
  readonly now?: Date;
};

/**
 * Combien d'élèves une tranche RÉDIGE au plus.
 *
 * Trois, parce que la fonction SSR est bornée (`maxDuration: 300`) et qu'un
 * élève lié à un parent coûte deux appels de modèle. Ce n'est pas une
 * pagination : le vrai frein est le budget de temps ci-dessous, qui s'arrête
 * même quand les appels sont lents. Celui-ci est la ceinture.
 */
export const TUTOR_DIGEST_DEFAULT_LIMIT = 3;

/**
 * Le budget de temps d'une tranche. On veut RENDRE un curseur, pas se faire
 * couper au milieu d'une écriture — un 504 perd le curseur, et le script doit
 * alors rejouer la tranche entière.
 *
 * La valeur date de l'époque où la plateforme coupait à trente secondes ; elle
 * en gardait juste la marge d'un appel en cours. Le plafond est passé à 300 s
 * le 2026-08-25 et cette tranche est donc devenue très prudente — ce qui reste
 * SANS DANGER (des tranches plus courtes, simplement plus nombreuses) et se
 * remonte le jour où le débit des bilans le demandera, mesures à l'appui.
 */
const ROUND_BUDGET_MS = 20_000;

/** Combien d'élèves on lit d'un coup dans `profiles`. Une lecture, pas une dépense. */
const PROFILE_PAGE = 40;

/**
 * Produit UN bilan et l'écrit. Rend `true` s'il a été stocké.
 *
 * §3.4 — un retry au MÊME palier, puis dégradé. Le motif est celui
 * d'`explainMistake` : une sortie rejetée pour longueur ou pour langue est un
 * accident de génération, pas un manque de capacité, et monter en gamme
 * coûterait sans rien garantir.
 *
 * Le palier est `fast`, et c'est un choix de coût assumé : un bilan est une mise
 * en phrases de chiffres déjà fournis — la tâche la plus proche de ce que le
 * palier rapide sait faire — et ce batch passe sur TOUTE la base. `rich`
 * multiplierait la facture hebdomadaire sans améliorer une phrase de constat.
 */
async function produceDigest(
  studentUserId: string,
  facts: TutorDigestFacts,
  audience: TutorDigestAudience,
  weekStart: string,
): Promise<"written" | "degraded"> {
  const system = digestSystem(audience, facts.lang, facts.ageBand);
  const blocks = buildDigestBlocks(facts);
  const feature = audience === "parent" ? "digest_parent" : "digest_student";

  for (let attempt = 0; attempt < 2; attempt += 1) {
    const outcome = await callAi({
      studentUserId,
      feature,
      tier: "fast",
      system,
      blocks,
      // `energyCost` n'est PAS surchargé : le barème donne déjà 0 pour les deux
      // surfaces (« produit par un batch, pas par un geste d'élève »). D-14 —
      // l'énergie est une mécanique de jeu, et personne ne joue le dimanche
      // matin à la place de l'élève.
    });

    if (!outcome.ok) {
      // Un refus de la porte (budget, mode coupé, accès) n'est pas un rebut :
      // réessayer produirait le même refus et une seconde ligne de journal.
      logger.info("tutor.digest.degraded", { audience, code: outcome.code });
      return "degraded";
    }

    const validated = validateDigestOutput(outcome.text, audience, facts.lang, facts.ageBand);
    if (!validated.ok) {
      // Jamais le corps rejeté dans un journal : le COMMENT d'`ai_usage_events`
      // porte déjà la règle (« aucun contenu »), et un bilan rejeté reste un
      // texte écrit sur un enfant réel.
      logger.info("tutor.digest.rejected", {
        audience,
        reason: validated.reason,
        model: outcome.model,
        attempt,
      });
      continue;
    }

    const stored = await supabaseAdmin.rpc("store_tutor_digest", {
      p_user: studentUserId,
      p_week_start: weekStart,
      p_audience: audience,
      p_body: validated.body,
      p_model: outcome.model,
      p_lang: facts.lang,
    });
    if (stored.error) {
      logger.error("tutor.digest.store", { audience, error: errorMessage(stored.error) });
      return "degraded";
    }
    return "written";
  }

  return "degraded";
}

/**
 * Les élèves suivants, par ordre d'id.
 *
 * L'ordre doit être TOTAL et stable, sinon le curseur saute des lignes ou en
 * rejoue : `profiles.id` est la clé primaire, c'est le seul tri qui le garantit
 * sans ajouter un index pour un batch hebdomadaire.
 */
async function nextProfiles(after: string | null): Promise<string[]> {
  const base = supabaseAdmin.from("profiles").select("id").order("id", { ascending: true });
  const { data, error } = await (after ? base.gt("id", after) : base).limit(PROFILE_PAGE);
  if (error) {
    logger.error("tutor.digest.profiles", { error: errorMessage(error) });
    throw new Error("digest_profiles");
  }
  return (data ?? []).map((r) => r.id);
}

/** Les audiences qu'il RESTE à écrire pour cet élève cette semaine. */
async function pendingAudiences(
  studentUserId: string,
  weekStart: string,
): Promise<TutorDigestAudience[]> {
  const done = await (supabaseAdmin as unknown as DigestRowReader)
    .from("tutor_digests")
    .select("audience")
    .eq("user_id", studentUserId)
    .eq("week_start", weekStart);
  const already = new Set((done.data ?? []).map((r) => r.audience));

  const link = await supabaseAdmin
    .from("parent_student_links")
    .select("parent_user_id")
    .eq("student_user_id", studentUserId)
    .eq("is_active", true)
    .limit(1);
  const hasParent = (link.data ?? []).length > 0;

  const wanted: TutorDigestAudience[] = hasParent ? ["student", "parent"] : ["student"];
  return wanted.filter((a) => !already.has(a));
}

/**
 * UNE tranche du batch. Séquentielle, et délibérément.
 *
 * Paralléliser tiendrait dans dix lignes et ferait gagner des secondes sur un
 * traitement qui a treize heures d'avance sur son échéance. En échange, il
 * mettrait N appels simultanés sur une clé de fournisseur dont le débit est
 * limité, et un 429 en rafale se solderait par des bilans manquants — pas plus
 * rapides, absents. On ne dépense pas de la fiabilité pour du temps dont on n'a
 * pas besoin.
 *
 * L'ORDRE DES GARDES EST LE CONTRAT, et il va du moins cher au plus cher :
 *   1. ce qui est déjà écrit (une lecture de table) ;
 *   2. la semaine vide (un appel SQL, décidé par `hasActivity`) ;
 *   3. et seulement alors, le modèle.
 */
export async function generateWeeklyDigests(
  options: TutorDigestBatchOptions,
): Promise<TutorDigestBatchSummary> {
  const weekStart = digestWeekStart(options.now ?? new Date());
  const admin = supabaseAdmin;
  const deadline = Date.now() + ROUND_BUDGET_MS;

  const summary = { examined: 0, written: 0, skippedEmpty: 0, skippedDone: 0, degraded: 0 };
  let cursor = options.after;
  let students = 0;

  const page = await nextProfiles(cursor);
  for (const studentUserId of page) {
    if (students >= options.limit || Date.now() > deadline) break;
    cursor = studentUserId;
    summary.examined += 1;

    const pending = await pendingAudiences(studentUserId, weekStart);
    if (pending.length === 0) {
      summary.skippedDone += 1;
      continue;
    }

    const inputs = await admin.rpc("get_tutor_digest_inputs", {
      p_user: studentUserId,
      p_week_start: weekStart,
    });
    if (inputs.error) {
      // Un élève dont les faits sont illisibles ne fait pas tomber la tranche :
      // on le compte comme dégradé et on passe au suivant (R-15).
      logger.warn("tutor.digest.inputs", { error: errorMessage(inputs.error) });
      summary.degraded += 1;
      continue;
    }

    const source = readDigestInputs(inputs.data);
    // La semaine sans une seule mission : le modèle n'aurait que des zéros et il
    // broderait. On ne paie pas pour ça, et l'écran rend « pas de bilan cette
    // semaine », qui est exact et déjà traduit.
    if (!source.hasActivity) {
      summary.skippedEmpty += 1;
      continue;
    }

    students += 1;
    for (const audience of pending) {
      // En répétition, `written` compte ce qui SERAIT écrit : le résumé porte
      // `dryRun` à côté, et c'est ce couple qu'on lit dans le journal du
      // workflow. Un second compteur « would_write » n'aurait servi qu'à
      // laisser les deux diverger.
      if (options.dryRun) {
        summary.written += 1;
        continue;
      }
      const result = await produceDigest(studentUserId, source.facts, audience, weekStart);
      if (result === "written") summary.written += 1;
      else summary.degraded += 1;
    }
  }

  // Le curseur est le dernier élève EXAMINÉ, et non le dernier élève ÉCRIT.
  // Rendre le second ferait boucler le script à l'infini dès qu'une tranche
  // entière tombe en « semaine vide » : ces élèves-là reviendraient sans fin.
  const lastStudentId = summary.examined > 0 ? cursor : null;

  logger.info("tutor.digest.batch", { weekStart, dryRun: options.dryRun, ...summary });
  return { weekStart, dryRun: options.dryRun, ...summary, lastStudentId };
}

// ---------------------------------------------------------------------------
// LA PORTE HTTP — motif `/api/cron/notify`
// ---------------------------------------------------------------------------

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}

/**
 * `POST /api/cron/digest` — à intercepter dans `src/server.ts` AVANT le handler
 * SSR, exactement comme `/api/cron/notify` : cette route porte sa propre
 * authentification et rend du JSON, pas la page d'erreur brandée.
 *
 * `dryRun` par défaut à `true` : une exécution manuelle qui se trompe de bouton
 * ne doit pas déclencher une facture. Le déclencheur planifié, lui, passe
 * explicitement `{"dryRun": false}` — l'intention de dépenser s'écrit.
 *
 * L'absence de `CRON_SECRET` rend 401 et non 500 : une route de batch sans
 * secret est une route FERMÉE, jamais une route ouverte.
 */
export async function handleDigestCron(
  request: Request,
  now: Date = new Date(),
): Promise<Response> {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return new Response("Unauthorized", { status: 401 });
  }

  const body = await request
    .json()
    .then((v: unknown) => v)
    .catch(() => ({}));
  const options = z
    .object({
      dryRun: z.boolean().default(true),
      // Plafond DUR de 10, très au-dessus du défaut de 3 mais très en dessous de
      // ce qui ferait exploser les 30 s : un appelant ne peut pas transformer
      // cette route en batch complet, même en le demandant poliment.
      limit: z.number().int().min(1).max(10).default(TUTOR_DIGEST_DEFAULT_LIMIT),
      /** Curseur de tranche — le `lastStudentId` de la réponse précédente. */
      after: z.guid().nullable().default(null),
    })
    .safeParse(body ?? {});
  const parsed = options.success
    ? options.data
    : { dryRun: true, limit: TUTOR_DIGEST_DEFAULT_LIMIT, after: null };

  try {
    const summary = await generateWeeklyDigests({ ...parsed, now });
    return jsonResponse({ ok: true, ...summary });
  } catch (err) {
    logger.error("tutor.digest.cron", { error: errorMessage(err) });
    return jsonResponse({ ok: false, error: "batch_failed" }, 500);
  }
}
