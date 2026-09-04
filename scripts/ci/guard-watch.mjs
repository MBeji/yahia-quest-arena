#!/usr/bin/env node
/**
 * La DÉCISION de « la garde des gardes », partagée par les deux dépôts (étude 32, D-6/L3b).
 *
 * POURQUOI CE FICHIER EXISTE. `guard-watch.yml` vivait en deux exemplaires — 170 lignes ici,
 * 208 au corpus — sans une ligne commune, pour deux différences de fond seulement (voir
 * `selectRelevant`). Le reste, c'est-à-dire tout le raisonnement, était recopié : le
 * regroupement par workflow, le tableau, le texte qui oriente le lecteur. Deux copies d'une
 * même règle divergent — ce projet l'a vu trois fois sur le seul test « zéro job », et une
 * fois de plus sur `pin-check` (é32 lot 2). Ici la règle est écrite une fois, et testée.
 *
 * CE QUI RESTE EN YAML, ET POURQUOI. Les appels `gh` (lister les runs, sonder les jobs, ouvrir
 * ou refermer l'issue) restent dans le workflow : ils portent l'authentification, et un script
 * qui les avalerait devrait ré-inventer un client GitHub pour être testable. Ce module ne fait
 * que ce qui se teste sans réseau — choisir quels runs comptent, les regrouper, écrire le
 * corps de l'issue. L'entrée arrive par fichier JSON, la sortie part par fichier Markdown.
 *
 * ⚠️ LE SENS DE L'ERREUR. Une garde se trompe en CRIANT, jamais en se taisant : à mesure
 * douteuse on garde le rouge. C'est l'inverse exact de la sonde d'`auto-pr.yml`, où une API
 * muette doit valoir « dispatche ». La même ligne de shell veut dire deux choses opposées
 * selon ce qu'elle garde — d'où le choix de construire ici la liste de ce qu'on ÉCARTE
 * (`dropIds`) plutôt que celle de ce qu'on garde : si le calcul en amont échoue, la liste
 * reste vide et l'alarme part entière.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/** Les deux conclusions qui valent « rouge ». Un `cancelled` ne l'est pas : quelqu'un a voulu. */
export const RED_CONCLUSIONS = new Set(["failure", "timed_out"]);

/**
 * Les runs qui comptent comme un rouge que PERSONNE ne regarde.
 *
 * Les deux paramètres sont les deux seules divergences historiques entre les deux dépôts :
 *
 * • `includePullRequest` — au MOTEUR, un échec sur `pull_request` a déjà un propriétaire (la
 *   DoD §8 met la session qui a poussé de garde jusqu'au merge) et les checks requis bloquent
 *   le merge d'eux-mêmes ; les relever ferait de l'issue un miroir bruyant de la file de PR.
 *   Au CORPUS il n'y a AUCUN check requis — dépôt privé sur un compte Free, où les rulesets
 *   répondent 403 — donc une PR rouge n'y bloque rien d'ostensible : elle dort, et c'est
 *   exactement le silence que cette garde existe pour rompre.
 *
 * • `dropIds` — les runs dont l'appelant a CONSTATÉ qu'ils n'ont aucun job. Un run à zéro job
 *   n'a rien évalué, il ne peut donc pas avoir échoué. C'était la signature des `pull_request`
 *   mort-nés du corpus, et les compter a produit une alarme entièrement fausse (privé#293,
 *   « 37 run(s) rouge(s) »). Depuis é32 lot 1 la cause est supprimée à la racine et un
 *   invariant de `harness:check --corpus` empêche la rechute ; ce filtre reste comme filet,
 *   pour une poignée d'appels d'API par fenêtre.
 */
export function selectRelevant(runs, { includePullRequest = false, dropIds = [] } = {}) {
  if (!Array.isArray(runs)) return [];
  const dropped = new Set((dropIds ?? []).map(String));
  return runs.filter((run) => {
    if (!run || typeof run !== "object") return false;
    if (!RED_CONCLUSIONS.has(run.conclusion)) return false;
    if (!includePullRequest && run.event === "pull_request") return false;
    return !dropped.has(String(run.databaseId ?? run.id ?? ""));
  });
}

/**
 * Un résumé par WORKFLOW, jamais par run : dix échecs du même cron sont UN problème, pas dix.
 * C'est la différence entre une issue qu'on lit et une issue qu'on ferme sans lire. Les plus
 * bruyants d'abord, et à égalité l'ordre alphabétique — pour qu'un même état rende toujours le
 * même tableau, sans quoi chaque passage réécrirait l'issue pour rien.
 */
export function groupByWorkflow(runs) {
  const byName = new Map();
  for (const run of runs) {
    const name = run.workflowName ?? run.name ?? "(workflow sans nom)";
    if (!byName.has(name)) byName.set(name, []);
    byName.get(name).push(run);
  }
  const groups = [];
  for (const [name, list] of byName) {
    const latest = [...list].sort((a, b) =>
      String(a.createdAt ?? "").localeCompare(String(b.createdAt ?? "")),
    )[list.length - 1];
    groups.push({ name, count: list.length, latest });
  }
  return groups.sort((a, b) => b.count - a.count || a.name.localeCompare(b.name));
}

/** Le corps Markdown de l'issue. Il doit tenir seul : son lecteur n'a que lui. */
export function formatIssueBody(groups, { windowHours = 8, since = "", includePullRequest }) {
  const lines = [
    "### 🚨 Gardes en échec",
    "",
    `Fenêtre observée : les **${windowHours} dernières heures** (depuis \`${since}\` UTC).`,
  ];
  if (!includePullRequest) {
    lines.push(
      "Les échecs sur `pull_request` sont volontairement exclus — ils ont déjà un propriétaire",
      "(DoD §8) et les checks requis les bloquent d'eux-mêmes.",
    );
  }
  lines.push(
    "",
    "| Workflow | Échecs | Dernier | Déclencheur |",
    "| --- | --- | --- | --- |",
    ...groups.map(
      (g) =>
        `| ${g.name} | ${g.count} | [${String(g.latest?.createdAt ?? "").slice(0, 16)}](${g.latest?.url ?? ""}) | \`${g.latest?.event ?? ""}\` |`,
    ),
    "",
    "**Un échec répété sur un arbre qui n'a pas bougé** désigne presque toujours une entrée hors",
    "dépôt (secret, variable, jeton) — donc quelque chose qu'aucune PR ne répare. C'était le cas",
    "des 26 jours de `report-triage` : la réponse n'a pas été de reposer le secret mais de",
    "**supprimer le besoin** (l'URL n'en était pas un). Voir `docs/agents/zero-intervention.md`",
    "du dépôt moteur — l'échelle de traitement et le tableau des murs.",
    "",
    "_Cette issue se referme toute seule dès qu'une fenêtre entière est verte._",
    "",
  );
  return lines.join("\n");
}

export function parseArgs(argv) {
  const out = {
    runs: null,
    out: "corps.md",
    windowHours: 8,
    since: "",
    includePullRequest: false,
    dropIds: [],
  };
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === "--runs") out.runs = argv[++i] ?? null;
    else if (arg === "--out") out.out = argv[++i] ?? out.out;
    else if (arg === "--since") out.since = argv[++i] ?? "";
    else if (arg === "--window-hours") out.windowHours = Number(argv[++i]) || out.windowHours;
    else if (arg === "--include-pull-request") out.includePullRequest = true;
    // Les ids écartés arrivent en une chaîne séparée par des espaces ou des sauts de ligne :
    // c'est ce qu'une boucle shell produit naturellement, sans quoting à réussir.
    else if (arg === "--drop-ids")
      out.dropIds = String(argv[++i] ?? "")
        .split(/\s+/)
        .filter(Boolean);
  }
  return out;
}

/** Lit un dump `gh run list --json …`, tolérant : un fichier illisible ne doit pas taire la garde. */
export function runsFromFile(path) {
  try {
    const parsed = JSON.parse(readFileSync(path, "utf8"));
    return Array.isArray(parsed) ? parsed : (parsed?.workflow_runs ?? []);
  } catch {
    return [];
  }
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const runs = args.runs ? runsFromFile(args.runs) : [];
  const relevant = selectRelevant(runs, {
    includePullRequest: args.includePullRequest,
    dropIds: args.dropIds,
  });
  if (relevant.length > 0) {
    writeFileSync(args.out, formatIssueBody(groupByWorkflow(relevant), args), "utf8");
  }
  // La seule sortie que le workflow lit : le nombre décide d'ouvrir ou de refermer.
  process.stdout.write(`${relevant.length}\n`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    // Une garde ne se tait pas sur une erreur : le workflow verra le code de sortie.
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
