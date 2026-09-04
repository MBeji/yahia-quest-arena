#!/usr/bin/env node
/**
 * Recensement des runs GitHub Actions — la mesure qui manquait à l'étude 32 (D-11).
 *
 * POURQUOI CE SCRIPT EXISTE. L'audit du 2026-09-03 a établi que 21 % des runs du dépôt
 * privé sont des `failure` à ZÉRO JOB — l'événement `pull_request: opened` d'une PR
 * ouverte par le `GITHUB_TOKEN`, que GitHub enregistre puis refuse. Ce chiffre a demandé
 * huit pages d'API, une agrégation à la main et une sonde par run suspect. Personne ne
 * refera ça à la main, donc personne ne saurait dire si un lot a amélioré quoi que ce
 * soit : une étude dont le « avant » n'est pas rejouable n'a pas de « après ».
 *
 * Il ne juge rien et ne garde rien — c'est un RAPPORT, pas un gate (même statut que
 * `programme:etat`). Il ne sort jamais en échec sur un chiffre : seul un problème
 * d'exécution (dépôt introuvable, `gh` absent) l'arrête.
 *
 * CE QU'IL COMPTE, et pourquoi chaque colonne a coûté une erreur à quelqu'un :
 *
 *   1. les runs par workflow × conclusion × événement — la vue que trois sessions ont
 *      reconstruite à la main, chacune à sa façon (#280, #291, #293) ;
 *   2. les FANTÔMES : un run dont `jobs.total_count == 0` n'a RIEN évalué. C'est le seul
 *      test qui tranche, et il est déjà le critère de `auto-pr.yml` et de
 *      `guard-watch.yml` ; ici il sert à mesurer combien de rouges du dépôt sont faux ;
 *   3. les minutes de runner, comptées `run_started_at → updated_at`, ARRONDIES À LA
 *      MINUTE SUPÉRIEURE par job : c'est la règle de facturation d'un dépôt privé, et
 *      c'est elle qui rend un job de 9 secondes coûteux. Sur un dépôt public la colonne
 *      reste indicative (les minutes y sont gratuites) ;
 *   4. les runs par branche poussée — le nombre que le lot 1 de l'étude 32 doit diviser.
 *
 * LIMITE ASSUMÉE, dite ici plutôt que découverte plus tard : la fenêtre observée est
 * celle des N dernières pages, pas une durée choisie. Sur un dépôt actif, 800 runs
 * couvrent six jours ; sur un dépôt calme, six semaines. Le rapport imprime toujours ses
 * bornes réelles et ramène tout à une cadence par jour — comparer deux relevés, c'est
 * comparer des cadences, jamais des totaux bruts.
 *
 *   node scripts/ci/actions-census.mjs --repo MBeji/yahia-quest-content
 *   node scripts/ci/actions-census.mjs --repo MBeji/yahia-quest-arena --pages 4 --json
 *   node scripts/ci/actions-census.mjs --from dump.json --from dump2.json   # hors ligne
 *
 * `--from` rejoue un DUMP déjà sauvegardé (`{"workflow_runs": [...]}`, la réponse brute de
 * l'API, ou un simple tableau) au lieu d'appeler le réseau. Deux usages : rejouer un relevé
 * ancien pour le comparer à aujourd'hui, et travailler là où `gh` n'existe pas — la session
 * qui a écrit ce script était dans ce cas, et c'est ainsi qu'elle a vérifié qu'il reproduit
 * les chiffres du §2.2 de l'étude 32. ⚠️ Un dump ne porte pas le compte de jobs, donc les
 * fantômes ne peuvent pas y être sondés : le rapport le DIT au lieu d'afficher un zéro qui
 * ressemblerait à une mesure. Le chemin réseau (`gh api`) n'a, lui, jamais tourné dans la
 * session qui l'a écrit : le vérifier est le premier geste de qui l'utilisera.
 *
 * Les fonctions pures sont exportées et testées ; `main()` fait les appels réseau et ne
 * s'exécute que si ce fichier est lancé directement.
 */
import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/** Une conclusion qui PEUT être un fantôme : seuls ces runs valent une sonde `jobs`. */
export const PHANTOM_CANDIDATE_CONCLUSIONS = new Set(["failure", "startup_failure"]);

export function parseArgs(argv) {
  const args = { repo: null, pages: 8, perPage: 100, json: false, probe: true, from: [] };
  for (let i = 0; i < argv.length; i += 1) {
    const flag = argv[i];
    if (flag === "--repo") args.repo = argv[++i] ?? null;
    else if (flag === "--from") {
      const file = argv[++i];
      if (file) args.from.push(file);
    } else if (flag === "--pages") args.pages = Number(argv[++i]);
    else if (flag === "--per-page") args.perPage = Number(argv[++i]);
    else if (flag === "--json") args.json = true;
    else if (flag === "--no-probe") args.probe = false;
  }
  if (!Number.isInteger(args.pages) || args.pages < 1) args.pages = 8;
  if (!Number.isInteger(args.perPage) || args.perPage < 1 || args.perPage > 100) args.perPage = 100;
  // Un dump ne porte aucun compte de jobs : la sonde n'a rien à interroger, et un zéro
  // non sondé qui se présente comme une mesure est exactement ce que ce script combat.
  if (args.from.length > 0) args.probe = false;
  return args;
}

/** Les runs d'un dump : réponse brute de l'API (`{workflow_runs}`) ou tableau nu. */
export function runsFromDump(text) {
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    return [];
  }
  if (Array.isArray(body)) return body;
  return Array.isArray(body?.workflow_runs) ? body.workflow_runs : [];
}

/**
 * Minutes FACTURÉES d'un run : la durée réelle arrondie à la minute supérieure, jamais
 * moins d'une. GitHub facture à la minute entamée sur un dépôt privé — c'est ce qui rend
 * cinq réveils d'automerge de neuf secondes plus chers qu'un gate de quatre minutes.
 */
export function billedMinutes(run) {
  const start = Date.parse(run?.run_started_at ?? run?.created_at ?? "");
  const end = Date.parse(run?.updated_at ?? "");
  if (!Number.isFinite(start) || !Number.isFinite(end) || end < start) return 1;
  return Math.max(1, Math.ceil((end - start) / 60000));
}

/** Dédoublonne par id : les pages d'API se recouvrent dès qu'un run naît pendant la lecture. */
export function dedupe(runs) {
  const byId = new Map();
  for (const run of runs ?? []) {
    if (run && run.id != null) byId.set(run.id, run);
  }
  return [...byId.values()];
}

/**
 * Agrège les runs. `phantomIds` (facultatif) est l'ensemble des ids dont on a PROUVÉ
 * qu'ils n'ont aucun job — sans lui, la colonne fantôme reste à zéro et le rapport le dit,
 * plutôt que de deviner à partir de la conclusion.
 */
export function summarise(runs, { phantomIds = new Set(), defaultBranch = "main" } = {}) {
  const all = dedupe(runs).sort((a, b) => String(a.created_at).localeCompare(String(b.created_at)));
  if (all.length === 0) {
    return { total: 0, days: 0, from: null, to: null, workflows: [], phantoms: 0, branches: 0 };
  }

  const from = all[0].created_at;
  const to = all.at(-1).created_at;
  const spanMs = Date.parse(to) - Date.parse(from);
  // Une fenêtre d'une poignée de minutes rendrait des cadences absurdes ; le plancher
  // d'une heure borne la division sans jamais gonfler une vraie fenêtre.
  const days = Math.max(spanMs, 3600_000) / 86_400_000;

  const byWorkflow = new Map();
  const branches = new Set();
  let phantoms = 0;
  let minutes = 0;

  for (const run of all) {
    const name = run.name ?? "(sans nom)";
    if (!byWorkflow.has(name)) {
      byWorkflow.set(name, {
        name,
        runs: 0,
        minutes: 0,
        phantoms: 0,
        conclusions: {},
        events: {},
      });
    }
    const entry = byWorkflow.get(name);
    const isPhantom = phantomIds.has(run.id);
    const cost = isPhantom ? 0 : billedMinutes(run);

    entry.runs += 1;
    entry.minutes += cost;
    minutes += cost;
    if (isPhantom) {
      entry.phantoms += 1;
      phantoms += 1;
    }

    const conclusion = isPhantom ? "fantôme (0 job)" : (run.conclusion ?? run.status ?? "?");
    entry.conclusions[conclusion] = (entry.conclusions[conclusion] ?? 0) + 1;
    entry.events[run.event] = (entry.events[run.event] ?? 0) + 1;

    if (run.head_branch && run.head_branch !== defaultBranch) branches.add(run.head_branch);
  }

  const workflows = [...byWorkflow.values()].sort((a, b) => b.runs - a.runs);
  const onBranches = all.filter((r) => r.head_branch && r.head_branch !== defaultBranch).length;

  return {
    total: all.length,
    from,
    to,
    days,
    minutes,
    phantoms,
    workflows,
    branches: branches.size,
    runsPerBranch: branches.size ? onBranches / branches.size : 0,
  };
}

const pct = (part, whole) => (whole ? `${Math.round((part / whole) * 100)} %` : "0 %");

const counts = (record) =>
  Object.entries(record)
    .sort((a, b) => b[1] - a[1])
    .map(([key, n]) => `${key} ${n}`)
    .join(" · ");

export function formatReport(summary, { repo = "?", probed = true } = {}) {
  if (summary.total === 0) return `[census] ${repo} — aucun run lu.`;

  const lines = [
    `[census] ${repo}`,
    `  fenêtre   ${summary.from} → ${summary.to} (${summary.days.toFixed(1)} j)`,
    `  runs      ${summary.total} (${(summary.total / summary.days).toFixed(0)}/j)`,
    probed
      ? `  fantômes  ${summary.phantoms} (${pct(summary.phantoms, summary.total)}) — runs à zéro job, ils n'ont RIEN évalué`
      : `  fantômes  non sondés (--no-probe) — la colonne reste à zéro, elle n'est pas une mesure`,
    `  minutes   ${summary.minutes} facturables (~${Math.round((summary.minutes / summary.days) * 30)}/30 j, minute entamée)`,
    `  branches  ${summary.branches} branche(s) hors défaut, ${summary.runsPerBranch.toFixed(1)} run(s) par branche`,
    "",
  ];

  for (const wf of summary.workflows) {
    lines.push(
      `  ${wf.name.slice(0, 42).padEnd(42)} ${String(wf.runs).padStart(4)} runs ` +
        `${(wf.runs / summary.days).toFixed(1).padStart(5)}/j ${String(wf.minutes).padStart(5)} min`,
    );
    lines.push(`      ${counts(wf.conclusions)}`);
    lines.push(`      ${counts(wf.events)}`);
  }

  return lines.join("\n");
}

/** Appelle l'API GitHub via `gh` — le seul client déjà authentifié partout où ceci tourne. */
function ghApi(path) {
  const raw = execFileSync("gh", ["api", path], { encoding: "utf8", maxBuffer: 64 * 1024 * 1024 });
  return JSON.parse(raw);
}

function fetchRuns({ repo, pages, perPage }) {
  const runs = [];
  for (let page = 1; page <= pages; page += 1) {
    const body = ghApi(`repos/${repo}/actions/runs?per_page=${perPage}&page=${page}`);
    const batch = body?.workflow_runs ?? [];
    runs.push(...batch);
    if (batch.length < perPage) break; // dernière page atteinte
  }
  return runs;
}

/**
 * Sonde `jobs.total_count` sur les seuls candidats. Une sonde qui échoue ne rend pas un
 * run fantôme : dans le doute, il compte comme un vrai rouge — l'erreur inverse ferait
 * disparaître un échec réel du rapport, ce qui est bien pire qu'un fantôme de trop.
 */
function probePhantoms(repo, runs) {
  const phantomIds = new Set();
  for (const run of runs) {
    if (!PHANTOM_CANDIDATE_CONCLUSIONS.has(run.conclusion)) continue;
    try {
      if (ghApi(`repos/${repo}/actions/runs/${run.id}/jobs`)?.total_count === 0) {
        phantomIds.add(run.id);
      }
    } catch {
      // sonde indisponible → on garde le rouge tel quel
    }
  }
  return phantomIds;
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (!args.repo && args.from.length === 0) {
    console.error(
      "usage: node scripts/ci/actions-census.mjs --repo <owner/name> [--pages N] [--json] [--no-probe]\n" +
        "       node scripts/ci/actions-census.mjs --from <dump.json> [--from ...]",
    );
    process.exit(2);
  }

  const runs = dedupe(
    args.from.length > 0
      ? args.from.flatMap((file) => runsFromDump(readFileSync(file, "utf8")))
      : fetchRuns(args),
  );
  const phantomIds = args.probe ? probePhantoms(args.repo, runs) : new Set();
  const summary = summarise(runs, { phantomIds });

  if (args.json) {
    console.log(JSON.stringify({ repo: args.repo, probed: args.probe, ...summary }, null, 2));
    return;
  }
  console.log(
    formatReport(summary, {
      repo: args.repo ?? `${args.from.length} dump(s)`,
      probed: args.probe,
    }),
  );
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
