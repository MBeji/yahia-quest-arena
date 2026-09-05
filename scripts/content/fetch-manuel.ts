/**
 * Télécharge un manuel du CNP par son CODE dans un dossier de travail hors dépôt, et rend ses
 * pages en images pour la lecture en vision — étude cloud-first, lot 3
 * (docs/agents/etude-cloud-first.md §7, docs/agents/campagnes-contenu.md).
 *
 *   npm run content:manuel:fetch -- 102905                          # → ~/.cache/yqa-manuels/102905P00.pdf
 *   npm run content:manuel:fetch -- 102905 --render --pages 18-24   # + 102905P00-p-18.png … -24.png
 *   npm run content:manuel:fetch -- 102105P01 --out /var/tmp/manuels --dpi 120
 *
 * Trois propriétés, les mêmes que pour le lien du lecteur (manuel-cnp.ts) :
 *   1. l'URL se DÉRIVE du code — jamais saisie : une coquille produit un fichier manquant, pas
 *      une destination arbitraire ;
 *   2. rien n'entre dans git — le dossier de sortie est un cache PRIVÉ de l'utilisateur
 *      (`~/.cache/yqa-manuels`, créé en 0700, jamais le répertoire temporaire partagé), et un
 *      fichier existant n'est jamais écrasé ; les manuels sont l'œuvre du CNP
 *      (LICENSE-CONTENT.md), on lie, on ne copie pas ;
 *   3. un refus réseau se DIT : en session cloud, un hôte hors liste blanche est refusé par le
 *      proxy de la plateforme, et le message nomme le lot 0 de l'étude — pas « le CNP est tombé ».
 *
 * Le transfert est fait par `curl` (présent sur la VM cloud comme sur Windows) : il suit le proxy
 * de la session nativement, écrit en flux, et Node ne manipule jamais les octets du réseau —
 * il vérifie la signature `%PDF-` du fichier écrit et supprime ce qui n'est pas un PDF. Le rendu
 * passe par `pdftoppm` (poppler — `npm run db:test:local` l'installe avec pgTAP, ou
 * `apt-get install poppler-utils`) ; sans lui, la commande dit quoi installer.
 *
 * Code de sortie : 0 téléchargé (et rendu) ; 1 code invalide ou erreur d'outillage ; 2 le CNP
 * ou le réseau ont refusé — le message dit lequel.
 */
import { execFileSync, spawnSync } from "node:child_process";
import {
  closeSync,
  existsSync,
  mkdirSync,
  openSync,
  readSync,
  readdirSync,
  statSync,
  unlinkSync,
} from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join } from "node:path";
import { argv, exit, stderr, stdout } from "node:process";
import { pathToFileURL } from "node:url";
import {
  type CurlOutcome,
  type Failure,
  classifyCurlFailure,
  classifyDownloadedHead,
  curlArgs,
  parseCurlReport,
  parsePages,
  planManuelDownload,
  renderArgs,
} from "../../src/shared/content/manuel-fetch.ts";

export type DownloadResult =
  { ok: true; file: string; bytes: number; ms: number } | { ok: false; failure: Failure };

export type CurlRunner = (args: string[]) => CurlOutcome;

/** curl sans shell : les arguments sont un tableau, l'URL et le chemin ne traversent rien. */
const runCurl: CurlRunner = (args) => {
  const r = spawnSync("curl", args, { encoding: "utf8" });
  return { status: r.error ? null : r.status, stdout: r.stdout ?? "", stderr: r.stderr ?? "" };
};

/** Les premiers octets d'un fichier, pour la signature. */
function readHead(file: string, length = 8): Uint8Array {
  const fd = openSync(file, "r");
  try {
    const buf = new Uint8Array(length);
    const n = readSync(fd, buf, 0, length, 0);
    return buf.subarray(0, n);
  } finally {
    closeSync(fd);
  }
}

function removeIfExists(file: string): void {
  if (existsSync(file)) unlinkSync(file);
}

/**
 * Télécharge `url` dans `file` via curl. Le dossier est créé privé (0700) ; un fichier déjà
 * présent n'est jamais écrasé ; un téléchargement qui échoue ou qui n'est pas un PDF ne laisse
 * rien derrière lui.
 */
export function downloadManuel(
  url: string,
  file: string,
  { run = runCurl, timeoutS = 300 } = {},
): DownloadResult {
  if (existsSync(file)) {
    return {
      ok: false,
      failure: {
        kind: "exists",
        message: `${file} existe déjà — relancer avec un autre --out pour re-télécharger`,
      },
    };
  }
  mkdirSync(dirname(file), { recursive: true, mode: 0o700 });
  const t0 = Date.now();
  const outcome = run(curlArgs(url, file, timeoutS));
  if (outcome.status !== 0) {
    removeIfExists(file);
    return { ok: false, failure: classifyCurlFailure(outcome) };
  }
  const { contentType } = parseCurlReport(outcome.stdout);
  const failure = classifyDownloadedHead(readHead(file), contentType);
  if (failure) {
    removeIfExists(file);
    return { ok: false, failure };
  }
  return { ok: true, file, bytes: statSync(file).size, ms: Date.now() - t0 };
}

/** Rend les pages en PNG avec pdftoppm ; rend la liste des fichiers produits. */
export function renderPages(
  file: string,
  spec: { first?: number; last?: number; dpi: number },
): string[] {
  const outPrefix = file.replace(/\.pdf$/i, "") + "-p";
  execFileSync("pdftoppm", renderArgs({ file, outPrefix, ...spec }), {
    stdio: ["ignore", "ignore", "pipe"],
  });
  const prefix = basename(outPrefix);
  return readdirSync(dirname(file))
    .filter((name) => name.startsWith(prefix) && name.endsWith(".png"))
    .sort()
    .map((name) => join(dirname(file), name));
}

/** Le cache privé de l'utilisateur — jamais le répertoire temporaire partagé. */
export function defaultOutDir(home = homedir()): string {
  return join(home, ".cache", "yqa-manuels");
}

function readFlag(args: string[], name: string): string | undefined {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : undefined;
}

async function main(): Promise<void> {
  const args = argv.slice(2);
  const code = args.find(
    (a, i) => !a.startsWith("--") && (i === 0 || !args[i - 1].startsWith("--")),
  );
  if (!code) {
    stderr.write(
      "usage : npm run content:manuel:fetch -- <code> [--out <dir>] [--render] [--pages a-b] [--dpi 150]\n",
    );
    exit(1);
  }
  const plan = planManuelDownload(code, readFlag(args, "--out") ?? defaultOutDir());
  if (!plan) {
    stderr.write(
      `[manuel] ✗ code « ${code} » invalide — un code CNP est alphanumérique (102905, 102105P01).\n`,
    );
    exit(1);
  }
  const pages = parsePages(readFlag(args, "--pages"));
  if (pages === null) {
    stderr.write("[manuel] ✗ --pages attend « a-b » ou « a » (pages à partir de 1).\n");
    exit(1);
  }
  const dpi = Number(readFlag(args, "--dpi") ?? 150);

  stdout.write(`[manuel] ${plan.code} → ${plan.url}\n`);
  if (existsSync(plan.file)) {
    stdout.write(
      `[manuel] déjà présent : ${plan.file} (relancer avec un autre --out pour re-télécharger)\n`,
    );
  } else {
    const result = downloadManuel(plan.url, plan.file);
    if (!result.ok) {
      stderr.write(`[manuel] ✗ ${result.failure.kind} : ${result.failure.message}\n`);
      exit(2);
    }
    stdout.write(
      `[manuel] ✓ ${(result.bytes / 1_048_576).toFixed(1)} Mo en ${(result.ms / 1000).toFixed(1)} s → ${result.file}\n`,
    );
  }

  if (args.includes("--render")) {
    try {
      execFileSync("pdftoppm", ["-v"], { stdio: "ignore" });
    } catch {
      stderr.write(
        "[manuel] ✗ pdftoppm absent — `apt-get install -y poppler-utils` (npm run db:test:local l'installe aussi) " +
          "ou `pip install pymupdf` et rendre en Python.\n",
      );
      exit(1);
    }
    const files = renderPages(plan.file, { ...pages, dpi });
    stdout.write(
      `[manuel] ${files.length} page(s) rendue(s) à ${dpi} dpi :\n${files.map((f) => `  ${f}`).join("\n")}\n`,
    );
  }
}

if (argv[1] && pathToFileURL(argv[1]).href === import.meta.url) await main();
