/**
 * Prépare — et, sur `--execute`, pose — un BASELINE coordonné sur les trois
 * dépôts (`yahia-quest-arena`, `yahia-quest-content`, `ScribeKit`).
 *
 * Un baseline n'est pas un tag : c'est un point de retour qui lie le code des
 * trois dépôts, l'état vivant de la base (dump + tête de migration +
 * `content_releases`), le déploiement servi et l'inventaire de configuration.
 * La procédure complète, ses garanties et ses angles morts vivent dans
 * `docs/baseline-snapshot-runbook.md` — ce script en automatise le §6.
 *
 * Prudence délibérée, dans l'esprit des runbooks : PAR DÉFAUT le script ne fait
 * QUE lire et rapporter (dry-run). Il agrège l'état des trois dépôts et de la
 * prod, calcule le nom de tag, coche la checklist §5 pour ce qu'il peut prouver
 * (et marque « à la main » ce qu'il ne peut pas — discipline #554 : ne jamais
 * prétendre vérifier ce qu'on ne vérifie pas), génère le manifeste et imprime le
 * plan. Rien n'est posé, rien n'est poussé tant que `--execute` n'est pas donné
 * ET qu'aucune précondition bloquante n'échoue ET que l'opérateur confirme.
 *
 * Helpers purs exportés (testés) ; `main()` fait l'I/O et ne s'exécute qu'appelé
 * directement.
 *
 *   node scripts/release/create-baseline.mjs --reason "pre-videos" \
 *     --arena . --content ../yahia-quest-content --scribekit ../ScribeKit
 *   node scripts/release/create-baseline.mjs … --execute
 */
import { execFileSync } from "node:child_process";
import { writeFileSync, mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

/** Tous les tags posés par ce script partagent ce préfixe. */
export const BASELINE_TAG_PREFIX = "baseline/";

/** URL de la sonde prod par défaut (publique — pas un secret). */
export const DEFAULT_PROD_URL = "https://na9ranal3ab.vercel.app";

/**
 * Réduit une raison libre en slug de tag : minuscules, sans diacritiques, mots
 * séparés par des tirets, tronqué. Chaîne vide si rien d'exploitable — le tag
 * reste alors purement daté.
 *
 * @param {string} [reason]
 * @returns {string}
 */
export function slugifyReason(reason = "") {
  return String(reason)
    .normalize("NFD")
    .replace(/[^ -~]/g, "") // retire les diacritiques combinants et tout non-ASCII
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 32)
    .replace(/-+$/g, "");
}

/**
 * Nomme le tag de baseline pour une date : `baseline/AAAA-MM-JJ`, plus un slug
 * de raison si fourni, plus un suffixe `.2`, `.3`… si un baseline du même jour
 * existe déjà (un second snapshot le même jour reste possible). La date est
 * lue en UTC pour être stable quel que soit le fuseau de l'opérateur.
 *
 * @param {Date} date
 * @param {{ reason?: string, existingTags?: string[] }} [opts]
 * @returns {string}
 */
export function baselineTagFor(date, { reason = "", existingTags = [] } = {}) {
  const day = date.toISOString().slice(0, 10); // AAAA-MM-JJ (UTC)
  const slug = slugifyReason(reason);
  const base = `${BASELINE_TAG_PREFIX}${day}${slug ? `-${slug}` : ""}`;
  if (!existingTags.includes(base)) return base;
  for (let n = 2; n < 100; n += 1) {
    const candidate = `${base}.${n}`;
    if (!existingTags.includes(candidate)) return candidate;
  }
  /* c8 ignore next */
  throw new Error(`Impossible de nommer un baseline pour ${base} (100 collisions).`);
}

/**
 * Lit la réponse de `GET /api/health` (sonde #569). Robuste : un JSON invalide
 * ou une sonde injoignable ne jette pas, il renvoie un rapport « inconnu » que
 * la checklist traduira en « à vérifier à la main » plutôt qu'en faux vert.
 *
 * @param {string} [text] corps brut de la réponse
 * @returns {{ ok: boolean, status: string|null, database: string|null, commit: string|null }}
 */
export function parseHealth(text) {
  try {
    const body = JSON.parse(text);
    return {
      ok: body.status === "ok" && body.checks?.database === "ok",
      status: body.status ?? null,
      database: body.checks?.database ?? null,
      commit: body.commit ?? null,
    };
  } catch {
    return { ok: false, status: null, database: null, commit: null };
  }
}

/** Deux SHAs concordent si l'un est préfixe de l'autre (court vs long). */
export function shaMatches(a, b) {
  if (!a || !b) return false;
  const [x, y] = [String(a), String(b)];
  return x.startsWith(y) || y.startsWith(x);
}

/**
 * Construit la checklist §5 à partir d'un état déjà collecté. Chaque item porte
 * un `status` : `ok` (prouvé vert), `fail` (prouvé rouge), ou `manual` (le
 * script ne peut pas trancher — à confirmer à la main). `blocking` marque les
 * items dont un `fail` doit empêcher `--execute` : on refuse de taguer un état
 * qui n'est pas réellement celui de la prod, un arbre sale, ou un tag déjà pris.
 *
 * @param {object} state
 * @returns {Array<{ key: string, label: string, status: string, blocking: boolean, detail: string }>}
 */
export function checklistFrom(state) {
  const {
    tagName,
    remoteTags = { arena: [], content: [], scribekit: [] },
    cleanTrees = {},
    health = null,
    arenaSha = null,
    frozen = null,
    openPRs = null,
    dump = {},
  } = state;

  const dirty = Object.entries(cleanTrees)
    .filter(([, clean]) => clean === false)
    .map(([name]) => name);

  const tagTaken = ["arena", "content", "scribekit"].filter((r) =>
    (remoteTags[r] ?? []).includes(tagName),
  );

  // Une sonde injoignable OU illisible (réponse non-JSON : status/database/commit
  // tous absents) est un « indéterminé », pas une panne prouvée — on la classe
  // `manual` pour ne jamais bloquer `--execute` sur une lecture ratée (#554).
  const healthUnreadable =
    health == null || (health.status == null && health.database == null && health.commit == null);
  const mainEqProd = healthUnreadable
    ? {
        status: "manual",
        detail: "sonde injoignable ou illisible — vérifier /api/health à la main",
      }
    : health.ok && shaMatches(health.commit, arenaSha)
      ? { status: "ok", detail: `commit ${health.commit} == arena ${arenaSha}, base ok` }
      : {
          status: "fail",
          detail: `health.commit=${health.commit ?? "?"} vs arena=${arenaSha ?? "?"}, base=${health.database ?? "?"}`,
        };

  return [
    {
      key: "clean-trees",
      label: "Les 3 arbres de travail sont propres et à jour",
      status: dirty.length ? "fail" : Object.keys(cleanTrees).length ? "ok" : "manual",
      blocking: true,
      detail: dirty.length ? `sales : ${dirty.join(", ")}` : "git status vide sur les 3",
    },
    {
      key: "main-eq-prod",
      label: "main == prod (sonde /api/health, commit servi)",
      blocking: true,
      ...mainEqProd,
    },
    {
      key: "ci-verify",
      label: "ci:verify vert sur le commit arena visé",
      status: "manual",
      blocking: false,
      detail: "lancer `npm run ci:verify` ou confirmer un run CI vert sur ce SHA",
    },
    {
      key: "harness-pinned",
      label: "harness:check vert — épinglage des Actions (repro, §3)",
      status: "manual",
      blocking: false,
      detail: "lancer `npm run harness:check`",
    },
    {
      key: "nightly-green",
      label: "Un nightly vert (e2e + pgTAP) existe sur ce commit",
      status: "manual",
      blocking: false,
      detail: "sinon baseline « verify-only » — l'écrire dans l'annotation",
    },
    {
      key: "chain-frozen",
      label: "Chaîne gelée, aucune PR en cours de merge",
      status: frozen == null && openPRs == null ? "manual" : frozen ? "ok" : "manual",
      blocking: false,
      detail:
        (frozen == null ? "MERGE_FREEZE inconnu" : frozen ? "MERGE_FREEZE=1" : "MERGE_FREEZE≠1") +
        (openPRs == null ? "" : ` · ${openPRs} PR ouverte(s)`),
    },
    {
      key: "dump-archived",
      label: "Dump prod pris, sha256 calculé, archivé durablement (hors 14 j)",
      status: dump.sha256 ? "manual" : "manual",
      blocking: false,
      detail: dump.sha256
        ? `stamp=${dump.stamp ?? "?"} sha256=${dump.sha256.slice(0, 12)}… — confirmer l'archivage`
        : "non fourni (--dump-stamp/--dump-sha256) — étape §6.3",
    },
    {
      key: "migration-head",
      label: "Tête de migration prod relue et notée",
      status: "manual",
      blocking: false,
      detail: "`gh workflow run db-migrate-prod.yml -f mode=list`",
    },
    {
      key: "content-release",
      label: "Dernier content_releases.git_sha relu ; tag contenu sur CE sha",
      status: "manual",
      blocking: false,
      detail: "log du dernier apply-content, ou SELECT en lecture",
    },
    {
      key: "env-inventory",
      label: "Inventaire env (`vercel env ls`, noms) ; doc env à jour",
      status: "manual",
      blocking: false,
      detail: "noms uniquement — jamais les valeurs",
    },
    {
      key: "tag-free",
      label: "Le nom de tag n'existe sur aucun des 3 remotes",
      status: tagTaken.length ? "fail" : "ok",
      blocking: true,
      detail: tagTaken.length ? `déjà pris sur : ${tagTaken.join(", ")}` : `${tagName} libre`,
    },
    {
      key: "no-secret",
      label: "Aucune valeur de secret dans le tag / le manifeste",
      status: "manual",
      blocking: false,
      detail: "revue anti-fuite avant le push",
    },
  ];
}

/** Les items dont un `fail` doit empêcher `--execute`. */
export function blockingFailures(checklist) {
  return checklist.filter((c) => c.blocking && c.status === "fail");
}

const REPO_ORDER = [
  ["arena", "MBeji/yahia-quest-arena"],
  ["content", "MBeji/yahia-quest-content"],
  ["scribekit", "MBeji/ScribeKit"],
];

/**
 * Le manifeste = l'annotation du tag (source de vérité, §4 du runbook). Même
 * texte pour les trois dépôts : c'est ce qui les relie. `<…>` là où une valeur
 * n'a pas pu être collectée automatiquement — à compléter avant le push.
 *
 * @param {object} input
 * @returns {string}
 */
export function buildManifest({
  tag,
  date,
  reason,
  repos = {},
  db = {},
  runtime = {},
  proofs = {},
} = {}) {
  const day = (date ?? new Date()).toISOString().slice(0, 10);
  const repoLine = ([key, remote]) => {
    const r = repos[key] ?? {};
    return `  ${key.padEnd(9)} ${remote.padEnd(27)} ${(r.sha ?? "<sha>").padEnd(12)} ${r.version ?? "—"}`;
  };
  return [
    `Baseline système ${day} — ${reason || "<raison>"}`,
    ``,
    `Tag : ${tag}`,
    ``,
    `DÉPÔTS (code + migrations + CI + harness + infra + docs)`,
    ...REPO_ORDER.map(repoLine),
    ``,
    `BASE (état vivant — hors git)`,
    `  tête de migration        : ${db.migrationHead ?? "<à relire — db-migrate-prod.yml -f mode=list>"}`,
    `  content_releases git_sha : ${db.contentReleaseSha ?? "<dernier appliqué en prod>"}`,
    `  dump prod                : ${db.dumpStamp ? `db-prod-${db.dumpStamp}.dump` : "<db-prod-<stamp>.dump>"} (pg_dump -Fc, PG17)`,
    `    run     : ${db.dumpRunUrl ?? "<url run db-backup.yml>"}`,
    `    sha256  : ${db.dumpSha256 ?? "<checksum>"}`,
    `    archivé : ${db.dumpArchive ?? "<emplacement durable, accès restreint — PII>"}`,
    ``,
    `RUNTIME`,
    `  déploiement Vercel servi : ${runtime.deployment ?? "<url déploiement>"} (commit ${runtime.commit ?? "<sha>"})`,
    `  env (noms uniquement)    : environment-variables.md @ tag + snapshot \`vercel env ls\``,
    ``,
    `PREUVES (au gel)`,
    `  ci:verify ${proofs.verify ?? "<run>"}  ·  harness:check ${proofs.harness ?? "épinglage OK"}  ·  nightly ${proofs.nightly ?? "<run>"}`,
    `  /api/health commit == ${proofs.healthCommit ?? repos.arena?.sha ?? "<sha arena>"}`,
  ].join("\n");
}

const ICON = { ok: "✅", fail: "❌", manual: "⚠️ " };

/* c8 ignore start — coquille I/O, exercée à la main / en session, pas en unit-test. */
function sh(file, args, cwd) {
  return execFileSync(file, args, { cwd, encoding: "utf8" }).trim();
}

function flag(argv, name, fallback = null) {
  const i = argv.indexOf(name);
  return i === -1 || i + 1 >= argv.length ? fallback : argv[i + 1];
}

function safe(fn, fallback = null) {
  try {
    return fn();
  } catch {
    return fallback;
  }
}

function collectRepo(path) {
  if (!path) return { sha: null, version: null, remoteTags: [], clean: null };
  safe(() => sh("git", ["fetch", "--quiet", "origin"], path));
  const sha = safe(() => sh("git", ["rev-parse", "--short", "origin/main"], path));
  const version = safe(() => {
    const pkg = sh("node", ["-p", "require('./package.json').version"], path);
    return pkg && !pkg.includes("Error") ? pkg : null;
  });
  const remoteTags = safe(
    () =>
      sh("git", ["ls-remote", "--tags", "origin"], path)
        .split("\n")
        .map((l) =>
          l
            .split("\t")[1]
            ?.replace("refs/tags/", "")
            .replace(/\^\{\}$/, ""),
        )
        .filter(Boolean),
    [],
  );
  const clean = safe(() => sh("git", ["status", "--porcelain"], path) === "");
  return { sha, version, remoteTags, clean };
}

async function confirm(question) {
  const { createInterface } = await import("node:readline/promises");
  const rl = createInterface({ input: process.stdin, output: process.stdout });
  const answer = (await rl.question(question)).trim().toLowerCase();
  rl.close();
  return answer === "oui" || answer === "o" || answer === "yes" || answer === "y";
}

export async function main(argv = process.argv.slice(2)) {
  const reason = flag(argv, "--reason", "");
  const date = flag(argv, "--date") ? new Date(flag(argv, "--date")) : new Date();
  const prodUrl = flag(argv, "--prod-url", DEFAULT_PROD_URL);
  const execute = argv.includes("--execute");
  const paths = {
    arena: flag(argv, "--arena", "."),
    content: flag(argv, "--content"),
    scribekit: flag(argv, "--scribekit"),
  };

  const repos = {
    arena: collectRepo(paths.arena),
    content: collectRepo(paths.content),
    scribekit: collectRepo(paths.scribekit),
  };
  const existingTags = [
    ...repos.arena.remoteTags,
    ...repos.content.remoteTags,
    ...repos.scribekit.remoteTags,
  ];
  const tag = baselineTagFor(date, { reason, existingTags });

  const healthRaw = safe(() => sh("curl", ["-s", "--max-time", "10", `${prodUrl}/api/health`]));
  const health = healthRaw ? parseHealth(healthRaw) : null;
  const frozen = safe(() => {
    const out = sh("gh", ["variable", "list"]);
    return /MERGE_FREEZE\s+1\b/.test(out);
  });
  const openPRs = safe(() => {
    const out = sh("gh", ["pr", "list", "--state", "open", "--json", "number", "--jq", "length"]);
    return Number(out);
  });

  const dump = {
    stamp: flag(argv, "--dump-stamp"),
    sha256: flag(argv, "--dump-sha256"),
    runUrl: flag(argv, "--dump-run"),
    archive: flag(argv, "--dump-archive"),
  };

  const state = {
    tagName: tag,
    remoteTags: {
      arena: repos.arena.remoteTags,
      content: repos.content.remoteTags,
      scribekit: repos.scribekit.remoteTags,
    },
    cleanTrees: Object.fromEntries(
      Object.entries(repos)
        .filter(([, r]) => r.clean !== null)
        .map(([k, r]) => [k, r.clean]),
    ),
    health,
    arenaSha: repos.arena.sha,
    frozen,
    openPRs,
    dump,
  };
  const checklist = checklistFrom(state);

  const manifest = buildManifest({
    tag,
    date,
    reason,
    repos: {
      arena: { sha: repos.arena.sha, version: repos.arena.version },
      content: { sha: repos.content.sha, version: repos.content.version },
      scribekit: { sha: repos.scribekit.sha, version: repos.scribekit.version },
    },
    db: {
      dumpStamp: dump.stamp,
      dumpSha256: dump.sha256,
      dumpRunUrl: dump.runUrl,
      dumpArchive: dump.archive,
    },
    runtime: { deployment: null, commit: health?.commit },
    proofs: { healthCommit: health?.commit },
  });

  console.log(`\n═══ Baseline ${tag} ═══\n`);
  for (const [key, remote] of REPO_ORDER) {
    const r = repos[key];
    console.log(`  ${key.padEnd(9)} ${remote.padEnd(27)} ${r.sha ?? "?"}  ${r.version ?? "—"}`);
  }
  console.log(`\n── Checklist §5 ──`);
  for (const c of checklist) {
    console.log(`  ${ICON[c.status]} ${c.label}\n       ${c.detail}`);
  }
  console.log(`\n── Manifeste (annotation du tag) ──\n${manifest}\n`);

  const blockers = blockingFailures(checklist);
  if (!execute) {
    console.log(`Dry-run. Pour poser le baseline : relancer avec --execute.`);
    console.log(`Étapes hors script (§6) : gel MERGE_FREEZE, dump db-backup.yml, dégel.`);
    return { tag, checklist, manifest, blockers, executed: false };
  }

  if (blockers.length) {
    console.error(`\n✗ ${blockers.length} précondition(s) bloquante(s) — pose refusée :`);
    for (const b of blockers) console.error(`  ❌ ${b.label} — ${b.detail}`);
    process.exit(1);
  }

  const targets = REPO_ORDER.map(([key]) => [key, paths[key], repos[key].sha]).filter(
    ([, path, sha]) => path && sha,
  );
  console.log(`Va poser et pousser ${tag} sur : ${targets.map(([k]) => k).join(", ")}`);
  if (!(await confirm(`Confirmer la pose + push des tags ? (oui/non) `))) {
    console.log("Annulé — rien n'a été posé.");
    return { tag, checklist, manifest, blockers, executed: false };
  }

  const dir = mkdtempSync(join(tmpdir(), "baseline-"));
  const msgFile = join(dir, "manifest.txt");
  writeFileSync(msgFile, manifest, "utf8");
  for (const [key, path, sha] of targets) {
    sh("git", ["tag", "-a", tag, sha, "-F", msgFile], path);
    sh("git", ["push", "origin", tag], path);
    const landed = safe(() => sh("git", ["ls-remote", "--tags", "origin", tag], path));
    console.log(
      landed ? `  ✅ ${key} : ${tag} poussé` : `  ⚠️  ${key} : push non confirmé — relire`,
    );
  }
  console.log(
    `\nBaseline ${tag} posé. Ne pas oublier le dégel (§6.8) et la copie docs/baselines/.`,
  );
  return { tag, checklist, manifest, blockers, executed: true };
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) {
  main();
}
/* c8 ignore stop */
