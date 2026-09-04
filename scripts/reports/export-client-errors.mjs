/**
 * LA BOÎTE NOIRE DES REFUS D'AUTH, ENFIN LUE — étude #938, premier lot.
 *
 * `client_errors` existe depuis la migration `20260831140000` et personne ne la
 * lisait : ses seuls consommateurs dans tout le dépôt étaient son propre writer
 * (`client-log.server.ts`), son test, et deux mentions en documentation. Aucun
 * workflow, aucun script, aucune garde. C'est le mode de panne que le dépôt de
 * corpus documente à propos de `report-triage.yml`, « mort 26 jours en criant
 * dans un onglet que personne n'ouvrait » — sauf qu'ici il n'y avait même pas
 * d'onglet. Entre le 2026-08-18 et le 2026-08-31 la même panne d'authentification
 * a couru treize jours en produisant des lignes que rien ne relevait.
 *
 * Ce script est la moitié DÉTECTION. Il ne juge pas et n'écrit rien : il rend un
 * document JSON, et c'est `client-errors-watch.yml` qui décide d'ouvrir une issue.
 *
 * ── CE QU'IL MESURE, ET POURQUOI PAS AUTRE CHOSE ────────────────────────────
 *
 * • Une **fenêtre glissante**, jamais un total. Un refus d'auth isolé est
 *   routinier — toute session finit par expirer. C'est la RAFALE qui est un
 *   incident. Un compteur cumulé, lui, franchit n'importe quel seuil avec le
 *   temps et n'apprend plus rien à personne.
 *
 * • Une **ventilation par `stage` et par `err_message`**. La table des refus
 *   (`auth-refusals.ts`) donne le vocabulaire exact à agréger : un message y est
 *   écrit UNE fois, donc les regrouper rend des classes, pas du bruit.
 *
 * • Le signal le plus intéressant de tous : un refus déclaré
 *   `recovery: "fresh-token"` **qui se répète malgré la reprise**. Le contrat de
 *   `auth-refusals.ts` dit qu'un jeton neuf le guérit ; s'il revient en rafale,
 *   c'est le contrat qui est faux, pas la session de l'élève. C'est exactement la
 *   forme de #931 (`NO_HEADER` sans prédicat de reprise) et de #914.
 *
 * • Et depuis le 2026-09-04, **les soumissions de mission qui n'aboutissent
 *   pas** — le seul de ces comptes qui parle de TRAVAIL D'ÉLÈVE et pas de
 *   sessions. Il a son seuil, bien plus bas que les deux autres. Motif : le
 *   2026-09-03, un élève a fait ses exercices, validé, et le suivi parental du
 *   lendemain n'en montrait aucun ; cette garde a répondu « 0 refus dans la
 *   fenêtre » et disait vrai — `reportClientError` n'était alors appelé que
 *   derrière un refus d'auth, donc la panne n'écrivait rien. Le classement des
 *   stages vit dans `client-error-stages.ts`, lu des deux côtés.
 *
 * • Le filtrage de la fenêtre est fait **côté serveur** (`.gte("created_at", …)`),
 *   jamais en local après une lecture bornée. Piège mesuré sur ce dépôt : les
 *   100 runs les plus récents ne couvraient qu'1 h 13, donc une fenêtre filtrée
 *   après coup aurait rendu « 0 » d'un air parfaitement vert.
 *
 * ── CE QU'IL NE FAIT PAS ────────────────────────────────────────────────────
 *
 * SELECT-only par construction, comme `export-reports.mjs` : il n'émet jamais
 * qu'une lecture. `client_errors` est en RLS **sans policy** et ses privilèges
 * sont `REVOKE`d — seule la service-role key y lit, d'où le secret exigé.
 *
 * Usage :
 *   SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… node scripts/reports/export-client-errors.mjs
 *   … --window-hours 24 --out /tmp/client-errors.json
 */
import { existsSync } from "node:fs";
import { writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

import { AUTH_REFUSALS } from "../../src/shared/integrations/supabase/auth-refusals.ts";
import {
  CLIENT_ERROR_STAGES,
  UNRECOVERED_SUBMISSION_STAGES,
} from "../../src/shared/lib/client-error-stages.ts";
import { prodTargetReason } from "../shared/prod-targets.mjs";
import { transientHint, withTransientRetry } from "../shared/supabase-transient.mjs";

/** Fenêtre par défaut : un jour. Le cron passe plus souvent, les fenêtres se recouvrent. */
export const DEFAULT_WINDOW_HOURS = 24;

/**
 * Combien de refus, dans la fenêtre, font un INCIDENT plutôt qu'une journée normale.
 *
 * ⚠️ C'est une hypothèse de départ, pas une mesure — personne n'a encore lu une
 * semaine de cette table. Elle est posée haut À DESSEIN : une garde qui crie le
 * premier jour est une garde qu'on apprend à ne plus lire, et le dépôt en a déjà
 * fait les frais. Elle se corrigera sur données réelles, et le rapport porte
 * toujours les comptes bruts pour qu'on puisse la corriger en connaissance.
 */
export const SEUILS = {
  /** Rafale, tous stages confondus. */
  totalParFenetre: 25,
  /**
   * Un refus « guérissable par un jeton neuf » qui revient malgré la reprise.
   * Seuil plus bas que le total : c'est le contrat de `auth-refusals.ts` qui se
   * démentirait, et ça vaut d'être regardé bien avant une rafale ordinaire.
   */
  freshTokenParFenetre: 10,
  /**
   * Des soumissions qui n'aboutissent pas et que RIEN ne reprend derrière
   * (`UNRECOVERED_SUBMISSION_STAGES`).
   *
   * ⚠️ Le seuil le plus bas des trois, et ce n'est pas un réglage timide : les
   * deux autres comptent des sessions refusées, celui-ci compte du TRAVAIL
   * D'ÉLÈVE qui n'est pas arrivé. Trois missions perdues dans une fenêtre de
   * 8 h, c'est déjà une soirée de travail effacée pour quelqu'un — le
   * 2026-09-03 en a été une, et elle est passée sous les deux autres seuils
   * sans rien déclencher parce que rien n'écrivait ces lignes.
   */
  soumissionParFenetre: 3,
};

/** Les messages que le serveur écrit pour un refus qu'un jeton neuf est censé guérir. */
export const MESSAGES_FRESH_TOKEN = Object.values(AUTH_REFUSALS)
  .filter((r) => r.recovery === "fresh-token")
  .map((r) => r.message);

/**
 * Refuse de lire autre chose que la PRODUCTION.
 *
 * Même posture que `export-reports.mjs`, et pour la même raison vécue : pointé
 * sur le projet TEST, ce script rend un rapport parfaitement bien formé de la
 * mauvaise base. Rien n'échoue, rien n'avertit — la garde devient aveugle aux
 * vrais élèves tout en ayant l'air de travailler. Un fichier vide se remarque ;
 * un fichier plausible, non.
 *
 * @param {string} url
 * @returns {string}
 */
export function assertProdClientErrorSource(url) {
  if (prodTargetReason(url) === "supabase") return url;
  throw new Error(
    `[client-errors] Refus de lire « ${url} » : ce script ne lit QUE la production. ` +
      "Un rapport bien formé de la mauvaise base est pire qu'une erreur — il rend la garde " +
      "aveugle sans que rien ne le dise.",
  );
}

/**
 * Agrège les lignes de la fenêtre en un document lisible par un humain pressé.
 *
 * Pure : aucune I/O, donc testable sans base. C'est ici que vit la seule logique
 * qui mérite un test.
 *
 * @param {Array<Record<string, unknown>>} rows
 * @param {{ windowHours: number, since: string, generatedAt: string }} meta
 */
export function buildClientErrorReport(rows, meta) {
  const parStage = compter(rows, (r) => String(r.stage ?? "(inconnu)"));
  const parMessage = compter(rows, (r) => String(r.err_message ?? "(vide)"));

  // Le signal du contrat : un refus que `auth-refusals.ts` déclare guérissable
  // par un jeton neuf, et qui revient quand même.
  const freshToken = rows.filter((r) =>
    MESSAGES_FRESH_TOKEN.some((m) => String(r.err_message ?? "").includes(m)),
  );

  // Les trois grandeurs que `reportClientError` emporte pour départager les
  // hypothèses (#914 : horloge de l'appareil vs retour de veille).
  const ttl = rows.map((r) => Number(r.ttl_s)).filter((n) => Number.isFinite(n));
  const jetonValideRefuse = ttl.filter((s) => s > 60).length;
  const jetonExpire = ttl.filter((s) => s <= 0).length;
  const retourDeVeille = rows.filter((r) => Number(r.last_hidden_ms) > 60_000).length;

  // Le travail d'élève qui n'est pas arrivé, et que rien ne reprend derrière.
  // Le stage suffit à le dire (`client-error-stages.ts`) : c'est la table qui
  // classe, pas une liste de chaînes retapée ici.
  const soumissionsPerdues = rows.filter((r) =>
    UNRECOVERED_SUBMISSION_STAGES.includes(String(r.stage ?? "")),
  );

  const alertes = [];
  if (rows.length >= SEUILS.totalParFenetre) {
    alertes.push(
      `${rows.length} refus en ${meta.windowHours} h (seuil ${SEUILS.totalParFenetre}) — une rafale, pas des expirations isolées.`,
    );
  }
  if (freshToken.length >= SEUILS.freshTokenParFenetre) {
    alertes.push(
      `${freshToken.length} refus déclarés \`recovery: "fresh-token"\` se répètent MALGRÉ la reprise ` +
        `(seuil ${SEUILS.freshTokenParFenetre}) — c'est le contrat d'\`auth-refusals.ts\` qui se dément, pas la session de l'élève.`,
    );
  }
  if (soumissionsPerdues.length >= SEUILS.soumissionParFenetre) {
    alertes.push(
      `${soumissionsPerdues.length} soumissions de mission n'ont PAS abouti en ${meta.windowHours} h ` +
        `(seuil ${SEUILS.soumissionParFenetre}) — du travail d'élève qui n'est pas enregistré, ` +
        "donc invisible dans sa progression comme dans le suivi parental.",
    );
  }

  return {
    generatedAt: meta.generatedAt,
    window: { hours: meta.windowHours, since: meta.since },
    total: rows.length,
    parStage,
    parMessage,
    freshTokenQuiSeRepete: freshToken.length,
    soumissionsPerdues: soumissionsPerdues.length,
    /** Ce que chaque stage présent raconte, pour que l'issue se lise sans le code. */
    legendeStages: Object.fromEntries(
      Object.keys(parStage)
        .filter((stage) => stage in CLIENT_ERROR_STAGES)
        .map((stage) => [stage, CLIENT_ERROR_STAGES[stage].what]),
    ),
    horloge: { jetonValideRefuse, jetonExpire, retourDeVeille },
    seuils: SEUILS,
    alertes,
  };
}

/**
 * @param {Array<Record<string, unknown>>} rows
 * @param {(row: Record<string, unknown>) => string} cle
 */
function compter(rows, cle) {
  /** @type {Record<string, number>} */
  const out = {};
  for (const row of rows) {
    const k = cle(row);
    out[k] = (out[k] ?? 0) + 1;
  }
  return Object.fromEntries(Object.entries(out).sort((a, b) => b[1] - a[1]));
}

/** `--window-hours N`, ou le défaut. Une valeur non numérique est une erreur, pas un défaut. */
export function readWindowHours(argv) {
  const i = argv.indexOf("--window-hours");
  if (i === -1) return DEFAULT_WINDOW_HOURS;
  const n = Number(argv[i + 1]);
  if (!Number.isFinite(n) || n <= 0) {
    throw new Error(
      `[client-errors] --window-hours attend un nombre > 0, reçu « ${argv[i + 1]} ».`,
    );
  }
  return n;
}

async function main() {
  const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..", "..");
  const envPath = resolve(repoRoot, ".env");
  if (existsSync(envPath)) {
    const { default: dotenv } = await import("dotenv");
    dotenv.config({ path: envPath, override: false });
  }

  const url = process.env.SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceKey) {
    console.error(
      "[client-errors] SUPABASE_URL et/ou SUPABASE_SERVICE_ROLE_KEY manquants. " +
        "`client_errors` est en RLS sans policy et ses privilèges sont REVOKE : " +
        "seule la service-role key y lit.",
    );
    process.exit(1);
  }

  let windowHours;
  try {
    windowHours = readWindowHours(process.argv);
    assertProdClientErrorSource(url);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }

  const since = new Date(Date.now() - windowHours * 3_600_000).toISOString();

  const { createClient } = await import("@supabase/supabase-js");
  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  const res = await withTransientRetry(
    () =>
      supabase
        .from("client_errors")
        // Fenêtre filtrée CÔTÉ SERVEUR — voir l'en-tête.
        .select("id, created_at, stage, err_message, http_status, ttl_s, last_hidden_ms")
        .gte("created_at", since)
        .order("created_at", { ascending: false }),
    { label: "client_errors" },
  );
  if (res.error) {
    console.error(
      `[client-errors] Lecture impossible : ${res.error.message}${transientHint(res.error.message)}`,
    );
    process.exit(1);
  }

  const doc = buildClientErrorReport(res.data ?? [], {
    windowHours,
    since,
    generatedAt: new Date().toISOString(),
  });
  const json = JSON.stringify(doc, null, 2);

  const outIdx = process.argv.indexOf("--out");
  if (outIdx !== -1 && process.argv[outIdx + 1]) {
    await writeFile(process.argv[outIdx + 1], json, "utf8");
    console.error(
      `[client-errors] ${doc.total} refus sur ${windowHours} h → ${process.argv[outIdx + 1]}`,
    );
  } else {
    process.stdout.write(`${json}\n`);
  }
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) {
  await main();
}
