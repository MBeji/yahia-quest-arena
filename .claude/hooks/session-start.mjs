#!/usr/bin/env node
// Claude Code SessionStart hook — l'amorçage d'une session CLOUD, versionné et sondé
// (étude cloud-first, lot 1 — docs/agents/etude-cloud-first.md §7).
//
// Hors cloud (CLAUDE_CODE_REMOTE ≠ "true") : ne fait RIEN, exit 0 — un poste garde ses
// habitudes. En cloud, trois gestes puis un constat, et jamais d'échec bloquant :
//   1. Node — la VM démarre sous Node 22 quand `.nvmrc` exige 24 ; sans ce pas, le hook
//      `pre-push` rejoue le piège « Node trop vieux » (docs/agents/poste-windows.md). On installe
//      via nvm (nodejs.org est dans la liste Trusted) et on exporte le PATH dans
//      $CLAUDE_ENV_FILE, pour que toute commande de la session — `git push` compris — tourne
//      sous le bon Node.
//   2. Dépendances — `npm install` (jamais `npm ci`) si node_modules manque ou si
//      package-lock.json est plus récent que ce qui est installé. Pose aussi les hooks husky.
//   3. pgTAP — présent ou non (`npm run db:test:local` l'installe à la demande, lot 4).
//   4. La sonde réseau — chaque domaine du lot 0 (scripts/cloud/allowed-domains.mjs) reçoit un
//      HEAD via le proxy. Un « CONNECT 403 » est une politique réseau, pas une panne du site :
//      la distinction que check-manuel-links a dû apprendre à faire sur le poste.
// Le rapport part sur stdout : Claude Code l'ajoute au CONTEXTE de la session, qui sait donc ce
// qui lui manque avant de commencer, au lieu de le découvrir sur un 403 en pleine campagne.
//
// Sécurité : aucune interpolation dans un shell — execFile/spawn avec des tableaux d'arguments.
// Le seul `bash -c` porte un script FIXE et reçoit ses valeurs en arguments positionnels.
import { execFileSync, spawn } from "node:child_process";
import { appendFileSync, existsSync, readFileSync, statSync } from "node:fs";
import { dirname, join } from "node:path";
import { pathToFileURL } from "node:url";
import { ALLOWED_DOMAINS } from "../../scripts/cloud/allowed-domains.mjs";

const ROOT = process.env.CLAUDE_PROJECT_DIR || process.cwd();
const PGTAP_CONTROL = "/usr/share/postgresql/16/extension/pgtap.control";
export const PROBE_TIMEOUT_S = 8;
const PROBE_UA = "yahia-quest-arena-session-start";

/**
 * Ce que bash joue pour poser Node : $0 = nvm.sh, $1 = la version majeure. `source nvm.sh`
 * se termine par un `nvm use default` implicite et RETOURNE SON CODE — 3 quand l'alias par
 * défaut (`lts` sur la VM) n'est pas installé, ce qui est le cas d'une VM neuve. Chaîner le
 * `source` avec `&&` faisait donc échouer tout l'amorçage avant même `nvm install` (constaté
 * à la première reprise de session, 2026-09-05). D'où le `;` : on source, on ignore son code,
 * et seul `nvm which` décide.
 */
export const NVM_SCRIPT =
  'source "$0" >/dev/null 2>&1; nvm install "$1" >/dev/null 2>&1 && nvm alias default "$1" >/dev/null 2>&1; nvm which "$1"';

/** Le hook n'agit qu'en session cloud — la VM porte `CLAUDE_CODE_REMOTE=true`, jamais un poste. */
export function isCloud(env = process.env) {
  return env.CLAUDE_CODE_REMOTE === "true";
}

/** `.nvmrc` → version majeure voulue (`24`, `v24.2.0`, `lts/*` → null). */
export function parseWantedMajor(nvmrc) {
  const m = /^v?(\d+)/.exec(String(nvmrc ?? "").trim());
  return m ? Number(m[1]) : null;
}

/** `v24.20.0` → 24. */
export function majorOf(version) {
  return Number(String(version).replace(/^v/, "").split(".")[0]);
}

/**
 * Faut-il (ré)installer ? Oui sans node_modules, oui si npm n'a jamais écrit son
 * `.package-lock.json`, oui si le lockfile du dépôt est plus récent que celui-ci (un `git pull`
 * qui bouge les dépendances). Sinon non — et une session repart en une seconde.
 */
export function needsInstall({ hasNodeModules, lockMtimeMs, installedLockMtimeMs }) {
  if (!hasNodeModules) return true;
  if (installedLockMtimeMs === null || installedLockMtimeMs === undefined) return true;
  if (lockMtimeMs === null || lockMtimeMs === undefined) return false;
  return lockMtimeMs > installedLockMtimeMs;
}

/**
 * Lit une sonde curl. Un code HTTP — n'importe lequel, 401 et 403 du SITE compris — prouve
 * que l'hôte est joignable ; le `CONNECT tunnel failed` (curl 56) est le refus du proxy
 * d'environnement, donc la politique réseau ; 28 est un délai ; le reste est une erreur nommée.
 */
export function classifyProbe({ exitCode, httpCode = "", stderr = "" }) {
  const code = String(httpCode).trim();
  if (exitCode === 0 && /^[1-5]\d\d$/.test(code)) {
    return { state: "ok", label: `joignable (HTTP ${code})` };
  }
  if (/CONNECT tunnel failed|host_not_allowed/i.test(stderr) || exitCode === 56) {
    return { state: "blocked", label: "REFUSÉ par la politique réseau de l'environnement" };
  }
  if (exitCode === 28) return { state: "timeout", label: `sans réponse en ${PROBE_TIMEOUT_S} s` };
  if (exitCode === -1 || /ENOENT/.test(stderr))
    return { state: "error", label: "curl indisponible" };
  const detail = stderr.trim().split("\n")[0];
  return { state: "error", label: `erreur curl ${exitCode}${detail ? ` (${detail})` : ""}` };
}

const secs = (n) => `${Math.round(n)} s`;

/** Deux lignes, lues par la session : l'amorçage, puis le réseau — et ce que chaque refus interdit. */
export function buildReport({ node, nodeProxy = false, deps, pgtap, probes, durationMs }) {
  const head = [
    node.ok ? `Node ${node.version} (${node.how})` : `Node : ${node.error}`,
    ...(nodeProxy ? ["fetch Node via le proxy (NODE_USE_ENV_PROXY=1)"] : []),
    !deps.ok
      ? `dépendances : ${deps.error}`
      : deps.ran
        ? `dépendances : ${deps.packages ?? "?"} paquets installés (${secs(deps.seconds)})`
        : "dépendances : déjà en place",
    `pgTAP : ${pgtap ? "présent" : "absent (npm run db:test:local l'installe)"}`,
    secs(durationMs / 1000),
  ];
  const blocked = probes.filter((p) => p.state !== "ok");
  let net = `les ${probes.length} domaines du lot 0 sont joignables`;
  if (blocked.length > 0) {
    // Un libellé par état (« REFUSÉ par… »), puis chaque hôte avec ce qu'il interdit — quatre
    // refus identiques ne méritent pas quatre fois la même phrase.
    const byLabel = new Map();
    for (const p of blocked) byLabel.set(p.label, [...(byLabel.get(p.label) ?? []), p]);
    net = [...byLabel]
      .map(([label, ps]) => `${label} : ${ps.map((p) => `${p.host} → ${p.ifBlocked}`).join(" ; ")}`)
      .join(" · ");
    if (blocked.length === probes.length) {
      net +=
        " — le lot 0 de l'étude cloud-first (docs/agents/etude-cloud-first.md §7) n'est pas appliqué";
    }
  }
  return `[session-start · cloud] ${head.join(" · ")}\n[session-start · réseau] ${net}\n`;
}

// ---------------------------------------------------------------------------------------------
// I/O — rien de ce qui suit ne tourne sous vitest.

function readIfExists(path) {
  try {
    return readFileSync(path, "utf8");
  } catch {
    return null;
  }
}

function mtimeMs(path) {
  try {
    return statSync(path).mtimeMs;
  } catch {
    return null;
  }
}

function ensureNode(root, env) {
  const wanted = parseWantedMajor(readIfExists(join(root, ".nvmrc")));
  if (wanted === null) return { ok: true, version: process.version, how: "pas de .nvmrc" };
  if (majorOf(process.version) === wanted) {
    return { ok: true, version: process.version, how: "déjà en place" };
  }
  const nvmSh = [env.NVM_DIR, "/opt/nvm", env.HOME ? join(env.HOME, ".nvm") : null]
    .filter(Boolean)
    .map((dir) => join(dir, "nvm.sh"))
    .find((p) => existsSync(p));
  if (!nvmSh) {
    return {
      ok: false,
      error: `.nvmrc exige Node ${wanted}, ${process.version} en place et nvm introuvable`,
    };
  }
  const t0 = Date.now();
  // Script FIXE ; $0 = nvm.sh, $1 = la version — jamais interpolés.
  const out = execFileSync("bash", ["-c", NVM_SCRIPT, nvmSh, String(wanted)], {
    encoding: "utf8",
    timeout: 180_000,
    stdio: ["ignore", "pipe", "pipe"],
  });
  const nodeBin = out.trim().split("\n").at(-1);
  const binDir = dirname(nodeBin);
  const version = execFileSync(nodeBin, ["-v"], { encoding: "utf8" }).trim();
  let how = `nvm, ${secs((Date.now() - t0) / 1000)}`;
  if (env.CLAUDE_ENV_FILE) appendFileSync(env.CLAUDE_ENV_FILE, `export PATH="${binDir}:$PATH"\n`);
  else how += ", PATH non exporté (CLAUDE_ENV_FILE absent)";
  return { ok: true, version, binDir, how };
}

function ensureDeps(root, env, binDir) {
  const need = needsInstall({
    hasNodeModules: existsSync(join(root, "node_modules")),
    lockMtimeMs: mtimeMs(join(root, "package-lock.json")),
    installedLockMtimeMs: mtimeMs(join(root, "node_modules", ".package-lock.json")),
  });
  if (!need) return { ok: true, ran: false };
  const t0 = Date.now();
  // Le npm livré avec le Node voulu, pour que `prepare` (husky) et les binaires natifs suivent.
  const npm = binDir ? join(binDir, "npm") : "npm";
  const out = execFileSync(npm, ["install", "--no-audit", "--no-fund"], {
    cwd: root,
    env: binDir ? { ...env, PATH: `${binDir}:${env.PATH ?? ""}` } : env,
    encoding: "utf8",
    timeout: 240_000,
    stdio: ["ignore", "pipe", "pipe"],
  });
  const m = /added (\d+) packages?/.exec(out);
  return {
    ok: true,
    ran: true,
    packages: m ? Number(m[1]) : null,
    seconds: (Date.now() - t0) / 1000,
  };
}

/**
 * Le `fetch` de Node ignore HTTPS_PROXY par défaut : dans la VM, un `fetch` direct reçoit un 403
 * du bac à sable (`x-deny-reason: host_not_allowed`) MÊME pour un hôte autorisé, pendant que
 * `curl` passe. Avec NODE_USE_ENV_PROXY=1, Node emprunte le proxy comme curl (constaté le
 * 2026-09-05 : api.github.com 403 sans, 200 avec). Exporté dans la session pour que
 * `content:manuel:fetch`, `content:manuel:check` et tout script Node voient le même réseau.
 */
export function exportNodeProxy(env) {
  if (!env.HTTPS_PROXY || !env.CLAUDE_ENV_FILE || env.NODE_USE_ENV_PROXY === "1") return false;
  appendFileSync(env.CLAUDE_ENV_FILE, "export NODE_USE_ENV_PROXY=1\n");
  return true;
}

function hasPgTap(env) {
  if (existsSync(PGTAP_CONTROL)) return true;
  return (env.PATH ?? "").split(":").some((dir) => dir && existsSync(join(dir, "pg_prove")));
}

function probeDomain(domain) {
  return new Promise((resolve) => {
    const args = ["-sS", "-o", "/dev/null", "-I", "--max-time", String(PROBE_TIMEOUT_S)];
    args.push("-A", PROBE_UA, "-w", "%{http_code}", domain.probe);
    const child = spawn("curl", args, { stdio: ["ignore", "pipe", "pipe"] });
    let out = "";
    let err = "";
    child.stdout.on("data", (c) => (out += c));
    child.stderr.on("data", (c) => (err += c));
    child.on("error", (e) => {
      resolve({
        ...domain,
        ...classifyProbe({ exitCode: -1, httpCode: "", stderr: String(e.message) }),
      });
    });
    child.on("close", (code) => {
      resolve({ ...domain, ...classifyProbe({ exitCode: code, httpCode: out, stderr: err }) });
    });
  });
}

function attempt(step, run) {
  try {
    return run();
  } catch (err) {
    return {
      ok: false,
      error: `${step} : ${err instanceof Error ? err.message.split("\n")[0] : String(err)}`,
    };
  }
}

async function main() {
  if (!isCloud()) return;
  const t0 = Date.now();
  const env = process.env;
  const node = attempt("nvm", () => ensureNode(ROOT, env));
  const nodeProxy = attempt("proxy", () => exportNodeProxy(env)) === true;
  const deps = attempt("npm install", () => ensureDeps(ROOT, env, node.binDir ?? null));
  const pgtap = hasPgTap(env);
  const probes = await Promise.all(ALLOWED_DOMAINS.map(probeDomain));
  process.stdout.write(
    buildReport({ node, nodeProxy, deps, pgtap, probes, durationMs: Date.now() - t0 }),
  );
}

// CLI only — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main().catch((err) => {
    // Jamais bloquant : un amorçage qui échoue se DIT, il n'empêche pas la session de démarrer.
    process.stdout.write(
      `[session-start · cloud] erreur : ${err instanceof Error ? err.message : String(err)}\n`,
    );
    process.exit(0);
  });
}
