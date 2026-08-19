#!/usr/bin/env node
/**
 * Manuel-link health check — « le lien répond-il, et sert-il TOUJOURS le même
 * document ? »
 *
 * La carte « Manuel officiel » d'une matière pointe vers le manuel élève chez
 * son éditeur (voir `src/shared/content/manuel-cnp.ts`). Rien n'est hébergé de
 * notre côté, donc rien ne nous prévient si l'éditeur déplace, retire ou
 * republie un document : l'élève tomberait sur un 404 sans que personne ne le
 * sache. Cette sonde est là pour l'apprendre en ≤ 7 jours.
 *
 * ⚠️ **Elle ne télécharge aucun manuel.** Un `HEAD` suffit, et il rend deux
 * informations qui, ensemble, valent bien mieux qu'un simple « ça répond » :
 *   - le statut HTTP dit si le document est encore là ;
 *   - `Content-Length` dit sa TAILLE, que le registre CNP connaît déjà
 *     (`suivi/corpus-cnp.json`, champ `octets`, relevé au téléchargement du
 *     corpus). Même taille ⇒ c'est le même document ; taille différente ⇒ il a
 *     bougé à la source, et il faut aller voir.
 * Coût : une requête par code DISTINCT (une douzaine aujourd'hui), zéro octet
 * de corps téléchargé, quelques secondes.
 *
 * Quand un serveur refuse `HEAD` (405) ou tait sa taille, on retombe sur un GET
 * d'UN SEUL octet (`Range: bytes=0-0`) : la taille totale arrive alors dans
 * `Content-Range`. Toujours pas de téléchargement.
 *
 *   ok       le document répond et sa taille correspond au registre
 *   changed  il répond, mais sa taille a changé → republié/remplacé à la source
 *   broken   404/410 — les DEUX seuls statuts où le serveur dit « ce n'est plus là »
 *   unknown  tout le reste : réseau, 5xx, 401/403 (proxy/WAF ?), corps non-PDF,
 *            taille illisible. Un humain tranche.
 *
 * `unknown` est délibéré, comme pour les vidéos : un réseau capricieux ne doit
 * JAMAIS produire un faux `broken`. La sonde ne PROPOSE qu'un verdict — elle
 * n'écrit jamais dans `content/`.
 *
 * Elle n'a donc rien à faire dans `verify` / les checks requis d'une PR : la
 * disponibilité d'un site tiers ne doit pas bloquer la file (leçon `audit:deps`,
 * AGENTS.md). Sa place est la non-régression périodique.
 *
 * Usage :
 *   node --experimental-strip-types scripts/content/check-manuel-links.ts \
 *     [--content-dir content] [--throttle-ms 250]
 *
 * Sortie : JSON sur stdout. Code de retour 1 s'il existe au moins un `broken`
 * ou un `changed` (c'est un constat, pas une panne du job) ; 0 sinon —
 * `unknown` compris, l'incertitude réseau n'étant pas un défaut de contenu.
 */
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join, resolve } from "node:path";
import { argv, cwd, exit, stdout } from "node:process";
import { pathToFileURL } from "node:url";
import { cnpManuelFileName, cnpManuelUrl } from "../../src/shared/content/manuel-cnp.ts";

/** Le registre CNP, dans le corpus privé — branché dans le moteur par la CI. */
export const CORPUS_JSON =
  ".claude/skills/content-ecole-tn/references/programmes-officiels/suivi/corpus-cnp.json";

/** Les types de contenu qu'un manuel peut légitimement annoncer. */
const PDF_CONTENT_TYPE = /^application\/(pdf|octet-stream|force-download|x-pdf)\b/i;

/**
 * La taille annoncée par une réponse, ou `null` si elle se tait.
 * Un 206 porte la taille TOTALE dans `Content-Range` (`bytes 0-0/5686665`) —
 * son `Content-Length` ne vaut que la tranche demandée, ici 1 octet.
 */
export function sizeFromHeaders(status: number, headers: Record<string, string>): number | null {
  if (status === 206) {
    const total = /\/(\d+)\s*$/.exec(headers["content-range"] ?? "");
    return total ? Number(total[1]) : null;
  }
  const len = headers["content-length"];
  return len !== undefined && /^\d+$/.test(len) ? Number(len) : null;
}

/**
 * Le verdict, à partir de ce que la réponse a dit et de ce que le registre
 * attendait. Fonction PURE : c'est elle que les tests exercent, sans réseau.
 */
export type Verdict = { verdict: "ok" | "changed" | "broken" | "unknown"; reason: string };

export function verdictFor(
  { status, size, contentType }: { status: number; size: number | null; contentType?: string },
  expectedOctets: number,
): Verdict {
  // SEULS 404/410 sont un « broken » : ce sont les deux seuls statuts où le
  // serveur affirme que la ressource n'est plus là. Tout le reste est ambigu,
  // et la doctrine est stricte — jamais de faux broken.
  if (status === 404 || status === 410)
    return { verdict: "broken", reason: `document absent (HTTP ${status})` };

  // 401/403 ne disent PAS que le manuel a disparu : un proxy d'entreprise, un
  // WAF, un filtre anti-robot ou un blocage géographique répondent pareil.
  // Constaté en vrai le 2026-08-19 : la passerelle de sortie d'une session
  // agent répond 403 au CONNECT, ce qui aurait déclaré morts les 12 manuels
  // d'un coup. La sonde ne tranche pas ça — un humain le fait.
  if (status === 401 || status === 403) {
    return {
      verdict: "unknown",
      reason: `HTTP ${status} — document restreint OU intermédiaire (proxy, WAF, blocage géo) : à vérifier à la main`,
    };
  }
  if (status !== 200 && status !== 206)
    return { verdict: "unknown", reason: `HTTP ${status} inattendu` };

  // Un 200 qui rend du HTML PEUT être un faux 404 (page d'erreur) — mais aussi
  // une page de défi anti-robot. Même ambiguïté, même prudence.
  if (contentType && !PDF_CONTENT_TYPE.test(contentType)) {
    return {
      verdict: "unknown",
      reason: `répond 200 mais ce n'est pas un PDF (content-type "${contentType}") — page d'erreur ou de défi ?`,
    };
  }
  if (size === null) {
    return { verdict: "unknown", reason: "taille non annoncée — identité invérifiable" };
  }
  if (size !== expectedOctets) {
    return {
      verdict: "changed",
      reason: `taille ${size} o, le registre en attend ${expectedOctets} o — document republié ou remplacé à la source`,
    };
  }
  return { verdict: "ok", reason: `${size} o, conforme au registre` };
}

/** Normalise les en-têtes d'une réponse fetch en objet minuscule/plat. */
function headersOf(res: Response): Record<string, string> {
  const out: Record<string, string> = {};
  res.headers?.forEach?.((v, k) => {
    out[k.toLowerCase()] = v;
  });
  return out;
}

/**
 * Sonde UNE URL : `HEAD` d'abord, puis un GET d'un seul octet si le serveur
 * refuse `HEAD` ou tait sa taille. Toute exception (DNS, réseau, délai) dégrade
 * en `unknown`, jamais en `broken`.
 */
export async function probe(
  url: string,
  expectedOctets: number,
  { fetchImpl = fetch, timeoutMs = 10_000 }: { fetchImpl?: typeof fetch; timeoutMs?: number } = {},
): Promise<Verdict> {
  const call = (init: RequestInit) =>
    fetchImpl(url, { redirect: "follow", signal: AbortSignal.timeout(timeoutMs), ...init });
  try {
    let res = await call({ method: "HEAD" });
    let headers = headersOf(res);
    let size = sizeFromHeaders(res.status, headers);
    // 405/501 = HEAD non supporté ; 200 sans taille = serveur bavard mais muet.
    if (res.status === 405 || res.status === 501 || (res.status === 200 && size === null)) {
      res = await call({ method: "GET", headers: { Range: "bytes=0-0" } });
      headers = headersOf(res);
      size = sizeFromHeaders(res.status, headers);
    }
    return verdictFor(
      { status: res.status, size, contentType: headers["content-type"] },
      expectedOctets,
    );
  } catch (err) {
    // « fetch failed » tout seul n'est pas diagnosticable : undici range la vraie
    // raison (ENOTFOUND, ECONNREFUSED, CERT_HAS_EXPIRED, délai dépassé…) dans
    // `cause`. Sans elle, un passage tout-`unknown` ne dit pas s'il faut aller
    // voir le CNP, le DNS, ou la passerelle de sortie — et la sonde ne sert alors
    // qu'à dire « je n'ai rien vu », sans dire pourquoi.
    const msg = err instanceof Error ? err.message : String(err);
    const cause = err instanceof Error ? err.cause : undefined;
    const detail =
      cause instanceof Error
        ? `${(cause as NodeJS.ErrnoException).code ?? cause.name}: ${cause.message}`
        : undefined;
    return { verdict: "unknown", reason: `échec réseau: ${msg}${detail ? ` — ${detail}` : ""}` };
  }
}

/**
 * Les codes qui produisent RÉELLEMENT un lien public, c'est-à-dire ceux des
 * matières (`subject.json` → `manuels[]`). Les codes de chapitre servent la
 * galerie de pages, pas une URL — et `content:qa` les contrôle déjà hors ligne.
 * Dédupliqué : deux matières peuvent citer la même œuvre.
 */
export type ManuelCode = { code: string; subjects: string[] };

export function collectManuelCodes(contentDir: string): ManuelCode[] {
  const byCode = new Map<string, ManuelCode>();
  for (const entry of readdirSync(contentDir, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const file = join(contentDir, entry.name, "subject.json");
    if (!existsSync(file)) continue;
    const meta = JSON.parse(readFileSync(file, "utf8"));
    for (const m of (meta.manuels ?? []) as Array<{ code: string }>) {
      const seen = byCode.get(m.code) ?? { code: m.code, subjects: [] };
      seen.subjects.push(entry.name);
      byCode.set(m.code, seen);
    }
  }
  return [...byCode.values()].sort((a, b) => a.code.localeCompare(b.code));
}

/** `<code><tome>.pdf` → octets, d'après le registre CNP. */
export function sizeIndex(corpus: {
  documents: Array<{ code: string; tome: string; octets: number }>;
}): Map<string, number> {
  return new Map(corpus.documents.map((d) => [`${d.code}${d.tome}.pdf`, d.octets]));
}

const flag = (name: string, fallback: string): string => {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 && argv[i + 1] !== undefined ? argv[i + 1] : fallback;
};

async function main() {
  const root = cwd();
  const contentDir = resolve(root, flag("content-dir", "content"));
  const throttleMs = Number(flag("throttle-ms", "250"));
  const corpusPath = resolve(root, CORPUS_JSON);
  if (!existsSync(corpusPath)) {
    stdout.write(
      JSON.stringify({ error: `registre CNP introuvable: ${CORPUS_JSON} — corpus non branché` }) +
        "\n",
    );
    exit(1);
  }
  const sizes = sizeIndex(JSON.parse(readFileSync(corpusPath, "utf8")));

  const results: Array<{ code: string; subjects: string[]; file?: string } & Verdict> = [];
  for (const { code, subjects } of collectManuelCodes(contentDir)) {
    const file = cnpManuelFileName(code);
    const url = cnpManuelUrl(code);
    const expected = file ? sizes.get(file) : undefined;
    if (!url || expected === undefined) {
      // Impossible ici en pratique : `content:qa` refuse déjà un code absent du
      // registre. Filet de sécurité, pour ne jamais sonder dans le vide.
      results.push({ code, subjects, verdict: "broken", reason: "code absent du registre CNP" });
      continue;
    }
    results.push({ code, subjects, file: file ?? undefined, ...(await probe(url, expected)) });
    if (throttleMs > 0) await new Promise((r) => setTimeout(r, throttleMs));
  }

  const by = (v: Verdict["verdict"]) => results.filter((r) => r.verdict === v);
  const report = {
    total: results.length,
    ok: by("ok").length,
    broken: by("broken"),
    changed: by("changed"),
    unknown: by("unknown"),
    // Rien n'a pu être vérifié : la sonde était AVEUGLE (réseau, proxy, WAF).
    // Sans ce drapeau, un tel passage se lirait « 0 broken » — donc « tout va
    // bien » — alors qu'il n'a rien prouvé du tout.
    blind: results.length > 0 && by("unknown").length === results.length,
  };
  stdout.write(JSON.stringify(report, null, 2) + "\n");
  exit(report.broken.length + report.changed.length > 0 ? 1 : 0);
}

// Exécuté en CLI seulement — les tests importent les fonctions pures.
if (argv[1] && pathToFileURL(argv[1]).href === import.meta.url) await main();
