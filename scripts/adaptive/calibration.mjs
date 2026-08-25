/**
 * KPI-3 — la courbe de calibration, en lecture seule (étude 30 §1.4, lot 1).
 *
 * LA QUESTION QU'IL RÉPOND : quand le modèle annonçait « cet élève a ~75 % de chances de
 * réussir cet item », a-t-il réussi ~75 % du temps ? Un modèle non calibré est un modèle
 * qui ment poliment, et c'est le seul KPI de l'étude qui peut l'INVALIDER — depuis
 * l'arbitrage Q-6, c'est aussi lui, et lui seul, qui rouvrirait la porte IRT/Elo.
 *
 * COMMENT, PUISQUE RIEN N'EST ENREGISTRÉ. `question_attempts` ne stocke pas la croyance qui
 * avait cours au moment de la réponse — la table est antérieure à l'étude (é04 A0) et
 * l'étude a choisi de ne pas l'élargir pour ça (§3.8b n'ajoute que `elapsed_ms`, au lot 6).
 * Le script REJOUE donc l'historique : pour chaque (élève, compétence), il repasse les
 * tentatives dans l'ordre chronologique en appliquant le même modèle que le trigger, et note
 * à chaque item la croyance AVANT et le résultat observé. C'est exactement ce qu'est une
 * courbe de calibration — et c'est possible parce que le modèle est déterministe : rejouer
 * les mêmes entrées redonne les mêmes sorties, ce qu'aucun modèle ajusté ne permettrait.
 *
 * LECTURE SEULE PAR CONSTRUCTION : le script n'émet que des SELECT. Il ne corrige rien, ne
 * réécrit aucune croyance, et n'a pas d'inverse à annuler.
 *
 * ⚠️ LE GARDE-FOU DES EFFECTIFS, qui est la moitié du KPI. Une bande n'a le droit d'être
 * déclarée MAUVAISE qu'à partir de n ≥ 100 observations ; en dessous elle est NON CONCLUANTE.
 * Sans lui, la règle de Q-6 se déclencherait sur du bruit : avec ~40 élèves actifs une bande
 * contient une douzaine de réponses et rougit par hasard. À n = 100 et p ≈ 0,75, l'erreur-type
 * vaut ≈ 0,043, donc l'intervalle à 95 % ≈ [0,665 ; 0,835] — il tient JUSTE dans la tolérance
 * [0,65 ; 0,85]. Une courbe de calibration sans effectifs est un piège à décisions, donc le
 * tableau affiche toujours le n à côté du taux.
 *
 * Usage :
 *   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... node scripts/adaptive/calibration.mjs
 *   node scripts/adaptive/calibration.mjs -- --days 90 --json
 *
 * La clé service-role est nécessaire : `question_attempts` et `user_competency_mastery` sont
 * protégées par RLS par élève, une clé publiable lirait zéro ligne.
 */
import { existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { beliefGuess, beliefSlip, beliefUpdate, predictedSuccess } from "./belief-model.mjs";

/** Fenêtre par défaut, alignée sur `EVIDENCE_STALE_DAYS` (é04 R-2 / é30 §3.2). */
const DEFAULT_DAYS = 30;

/** En deçà, une bande est « non concluante », jamais « mauvaise » (KPI-3). */
export const MIN_BAND_OBSERVATIONS = 100;

/** La bande de référence du KPI et sa tolérance. */
export const KPI3_BAND = { min: 0.7, max: 0.8 };
export const KPI3_TOLERANCE = { min: 0.65, max: 0.85 };

/** Les dix bandes de largeur 0,1 — l'axe des abscisses de la courbe. */
export function bandOf(belief) {
  const index = Math.min(9, Math.max(0, Math.floor(belief * 10)));
  return { index, min: index / 10, max: (index + 1) / 10 };
}

/**
 * Rejoue l'historique et bâtit l'histogramme (croyance prédite × réussite observée).
 *
 * Les tentatives doivent arriver triées par date croissante — c'est l'ordre dans lequel le
 * trigger les a vues, et le seul dans lequel le rejeu a un sens. Une tentative sur une
 * question non taggée n'apporte rien (R-6) : elle n'a pas de compétence, donc pas de
 * croyance, donc pas de ligne dans la courbe.
 *
 * @param {Array<{userId: string, competencyId: string, correct: boolean, questionType: string,
 *   optionCount: number|null, difficulty: number|null, variant: string|null,
 *   weight: number, pInit: number, pTransit: number}>} evidence
 * @returns {{bands: Array<{band: {index: number, min: number, max: number}, n: number,
 *   observed: number|null, predicted: number|null}>, total: number}}
 */
export function buildCalibration(evidence) {
  /** @type {Map<string, number>} croyance courante par (élève, compétence) */
  const beliefs = new Map();
  const bands = Array.from({ length: 10 }, (_, index) => ({
    band: { index, min: index / 10, max: (index + 1) / 10 },
    n: 0,
    hits: 0,
    predictedSum: 0,
  }));

  for (const row of evidence) {
    const key = `${row.userId}:${row.competencyId}`;
    const prior = beliefs.get(key) ?? row.pInit;
    const guess = beliefGuess(row.questionType, row.optionCount, row.variant);
    // `false` : le signal de charge arrive au lot 6. Rejouer avec un p(S) que le trigger
    // n'appliquait pas fabriquerait une calibration d'un modèle qui n'a jamais tourné.
    const slip = beliefSlip(row.difficulty, false);

    // La bande est celle de la CROYANCE annoncée (KPI-3 parle de `p_known ∈ [0,7 ; 0,8]`) ;
    // le taux attendu, lui, est la P(réussite) que cette croyance implique pour CET item —
    // un QCM et une saisie libre à croyance égale n'annoncent pas la même chose (annexe A.5).
    const slot = bands[bandOf(prior).index];
    slot.n += 1;
    slot.predictedSum += predictedSuccess(prior, guess, slip);
    if (row.correct) slot.hits += 1;

    beliefs.set(key, beliefUpdate(prior, row.correct, guess, slip, row.pTransit, row.weight));
  }

  return {
    total: evidence.length,
    bands: bands.map((slot) => ({
      band: slot.band,
      n: slot.n,
      observed: slot.n > 0 ? slot.hits / slot.n : null,
      predicted: slot.n > 0 ? slot.predictedSum / slot.n : null,
    })),
  };
}

/**
 * Le verdict KPI-3 sur la bande de référence, garde-fou d'effectifs compris.
 *
 * @param {ReturnType<typeof buildCalibration>} report
 * @returns {{status: "ok"|"hors-tolerance"|"non-concluant", n: number, observed: number|null}}
 */
export function kpi3Verdict(report) {
  const slot = report.bands.find((b) => b.band.min === KPI3_BAND.min);
  const n = slot?.n ?? 0;
  const observed = slot?.observed ?? null;
  if (n < MIN_BAND_OBSERVATIONS || observed === null) {
    return { status: "non-concluant", n, observed };
  }
  const inside = observed >= KPI3_TOLERANCE.min && observed <= KPI3_TOLERANCE.max;
  return { status: inside ? "ok" : "hors-tolerance", n, observed };
}

/** Rend le tableau lisible dans un terminal — effectifs toujours à côté des taux. */
export function formatReport(report, verdict, days) {
  const pct = (v) => (v === null ? "     —" : `${(v * 100).toFixed(1).padStart(5)}%`);
  const lines = [
    `KPI-3 — calibration du modèle de croyance (fenêtre : ${days} jours, ${report.total} preuves rejouées)`,
    "",
    "  bande p_known │      n │ prédit │ observé │ écart",
    "  ──────────────┼────────┼────────┼─────────┼───────",
  ];
  for (const slot of report.bands) {
    const gap =
      slot.observed === null || slot.predicted === null
        ? "     —"
        : `${((slot.observed - slot.predicted) * 100).toFixed(1).padStart(5)}pt`;
    const marker = slot.band.min === KPI3_BAND.min ? "◄" : " ";
    lines.push(
      `  [${slot.band.min.toFixed(1)} ; ${slot.band.max.toFixed(1)}[ │ ${String(slot.n).padStart(6)} │ ${pct(slot.predicted)} │  ${pct(slot.observed)} │ ${gap} ${marker}`,
    );
  }
  lines.push("");
  if (verdict.status === "non-concluant") {
    lines.push(
      `  Verdict : NON CONCLUANT — la bande de référence [0,7 ; 0,8[ compte ${verdict.n} ` +
        `observation(s), il en faut ${MIN_BAND_OBSERVATIONS}. Une bande sous l'effectif n'est ` +
        `jamais « mauvaise » : elle est muette, et la règle de Q-6 ne s'y applique pas.`,
    );
  } else if (verdict.status === "ok") {
    lines.push(
      `  Verdict : CALIBRÉ — ${(verdict.observed * 100).toFixed(1)} % observé sur ${verdict.n} ` +
        `items, dans la tolérance [65 % ; 85 %].`,
    );
  } else {
    lines.push(
      `  Verdict : HORS TOLÉRANCE — ${(verdict.observed * 100).toFixed(1)} % observé sur ` +
        `${verdict.n} items, hors de [65 % ; 85 %]. C'est le signal de Q-6 : le modèle ment ` +
        `poliment, et la porte IRT/Elo s'ouvre.`,
    );
  }
  return lines.join("\n");
}

/** Lit `--days N` et `--json` derrière le `--` de npm. */
export function parseArgs(argv) {
  const days = Number(argv[argv.indexOf("--days") + 1]);
  return {
    days: argv.includes("--days") && Number.isFinite(days) && days > 0 ? days : DEFAULT_DAYS,
    json: argv.includes("--json"),
  };
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
      "[calibration] SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY sont requis : " +
        "les tentatives sont protégées par RLS par élève, une clé publiable lirait zéro ligne.",
    );
    process.exit(1);
  }

  const { days, json } = parseArgs(process.argv.slice(2));
  const since = new Date(Date.now() - days * 86_400_000).toISOString();

  const { createClient } = await import("@supabase/supabase-js");
  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  // Un seul aller-retour, trié à la source : le rejeu exige l'ordre chronologique.
  const { data, error } = await supabase
    .from("question_attempts")
    .select(
      "user_id, is_correct, created_at, session_id, " +
        "questions!inner(question_type, options, exercises!inner(difficulty), " +
        "question_competencies!inner(competency_id, competencies!inner(p_init, p_transit)))",
    )
    .gte("created_at", since)
    .order("created_at", { ascending: true });

  if (error) {
    console.error(`[calibration] Lecture impossible : ${error.message}`);
    process.exit(1);
  }

  // Les fils de tuteur : le poids d'un mini-check est 0,5 (§3.2). Une soumission dont le
  // `session_id` n'est pas un fil pèse plein — c'est la même détection que le trigger.
  const sessionIds = [...new Set((data ?? []).map((r) => r.session_id))];
  const threadIds = new Set();
  for (let i = 0; i < sessionIds.length; i += 500) {
    const { data: threads } = await supabase
      .from("tutor_threads")
      .select("id")
      .in("id", sessionIds.slice(i, i + 500));
    for (const thread of threads ?? []) threadIds.add(thread.id);
  }

  const evidence = [];
  for (const row of data ?? []) {
    const question = row.questions;
    if (!question) continue;
    for (const mapping of question.question_competencies ?? []) {
      evidence.push({
        userId: row.user_id,
        competencyId: mapping.competency_id,
        correct: row.is_correct,
        questionType: question.question_type,
        optionCount: Array.isArray(question.options) ? question.options.length : null,
        difficulty: question.exercises?.difficulty ?? null,
        // La variante vit sur `exercise_sessions`; l'absence de jointure ici est assumée —
        // le rappel actif est marginal sur la matière pilote et le sur-lire coûterait un
        // aller-retour par session pour déplacer une poignée d'items d'une bande.
        variant: "classic",
        weight: threadIds.has(row.session_id) ? 0.5 : 1,
        pInit: mapping.competencies?.p_init ?? 0.2,
        pTransit: mapping.competencies?.p_transit ?? 0.15,
      });
    }
  }

  const report = buildCalibration(evidence);
  const verdict = kpi3Verdict(report);
  console.log(
    json
      ? JSON.stringify({ days, verdict, ...report }, null, 2)
      : formatReport(report, verdict, days),
  );
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) {
  main().catch((error) => {
    console.error(`[calibration] ${error instanceof Error ? error.message : String(error)}`);
    process.exit(1);
  });
}
