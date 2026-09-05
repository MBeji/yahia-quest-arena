/**
 * Télécharge un manuel du CNP par son CODE dans un dossier de travail hors dépôt, et rend ses
 * pages en images pour la lecture en vision — étude cloud-first, lot 3
 * (docs/agents/etude-cloud-first.md §7, docs/agents/campagnes-contenu.md).
 *
 *   npm run content:manuel:fetch -- 102905                          # → $TMPDIR/yqa-manuels/102905P00.pdf
 *   npm run content:manuel:fetch -- 102905 --render --pages 18-24   # + 102905P00-p-18.png … -24.png
 *   npm run content:manuel:fetch -- 102105P01 --out /var/tmp/manuels --dpi 120
 *
 * Trois propriétés, les mêmes que pour le lien du lecteur (manuel-cnp.ts) :
 *   1. l'URL se DÉRIVE du code — jamais saisie : une coquille produit un fichier manquant, pas
 *      une destination arbitraire ;
 *   2. rien n'entre dans git — le dossier de sortie est jetable, par défaut sous le répertoire
 *      temporaire ; les manuels sont l'œuvre du CNP (LICENSE-CONTENT.md), on lie, on ne copie pas ;
 *   3. un refus réseau se DIT : en session cloud, un hôte hors liste blanche est refusé par le
 *      proxy de la plateforme, et le message nomme le lot 0 de l'étude — pas « le CNP est tombé ».
 *
 * Le rendu passe par `pdftoppm` (poppler — `npm run db:test:local` l'installe avec pgTAP, ou
 * `apt-get install poppler-utils`) ; sans lui, la commande dit quoi installer.
 *
 * Code de sortie : 0 téléchargé (et rendu) ; 1 code invalide ou erreur d'outillage ; 2 le CNP
 * ou le réseau ont refusé — le message dit lequel.
 */
import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, readdirSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { basename, dirname, join } from "node:path";
import { argv, env, exit, stderr, stdout } from "node:process";
import { pathToFileURL } from "node:url";
import {
  classifyFetchError,
  classifyResponse,
  parsePages,
  planManuelDownload,
  renderArgs,
  type Failure,
} from "../../src/shared/content/manuel-fetch.ts";

export type DownloadResult =
  { ok: true; file: string; bytes: number; ms: number } | { ok: false; failure: Failure };

type DownloadOptions = {
  fetchImpl?: typeof fetch;
  environment?: { HTTPS_PROXY?: string; NODE_USE_ENV_PROXY?: string };
  timeoutMs?: number;
};

/**
 * Télécharge `url` dans `file`. Le corps est lu en mémoire (un manuel pèse 5 à 40 Mo) pour
 * vérifier la signature `%PDF-` AVANT d'écrire : une page d'erreur ne devient jamais un
 * « manuel » sur le disque. Toute exception est classée, jamais relancée telle quelle.
 */
export async function downloadManuel(
  url: string,
  file: string,
  { fetchImpl = fetch, environment = env, timeoutMs = 120_000 }: DownloadOptions = {},
): Promise<DownloadResult> {
  const t0 = Date.now();
  let res: Response;
  try {
    res = await fetchImpl(url, { redirect: "follow", signal: AbortSignal.timeout(timeoutMs) });
  } catch (err) {
    return { ok: false, failure: classifyFetchError(err, environment) };
  }
  const bytes = new Uint8Array(await res.arrayBuffer());
  const failure = classifyResponse({
    status: res.status,
    denyReason: res.headers.get("x-deny-reason"),
    contentType: res.headers.get("content-type"),
    head: bytes.subarray(0, 8),
  });
  if (failure) return { ok: false, failure };
  mkdirSync(dirname(file), { recursive: true });
  writeFileSync(file, bytes);
  return { ok: true, file, bytes: bytes.length, ms: Date.now() - t0 };
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
  const outDir = readFlag(args, "--out") ?? join(tmpdir(), "yqa-manuels");
  const plan = planManuelDownload(code, outDir);
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
    const result = await downloadManuel(plan.url, plan.file);
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
