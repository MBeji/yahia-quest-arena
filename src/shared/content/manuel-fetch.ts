/**
 * Helpers behind `npm run content:manuel:fetch` — how a CNP book code becomes a local PDF that
 * a session, cloud or local, can render and read in vision (étude cloud-first, lot 3).
 *
 * Doctrine, unchanged from `manuel-cnp.ts`: the URL is DERIVED from the code, never typed, so a
 * typo can only produce a missing document. And the download lands in a throwaway folder,
 * never in git — the textbooks are the CNP's (LICENSE-CONTENT.md), we link, we do not copy.
 *
 * What is specific to a cloud session, and what these helpers name in clear text: the
 * environment's network policy. A host outside the allowlist is refused by the platform's proxy
 * — as a CONNECT 403 when Node uses the proxy (`NODE_USE_ENV_PROXY=1`), as a bare HTTP 403 with
 * `x-deny-reason: host_not_allowed` when it does not. Both mean "lot 0 of the study is not
 * applied", not "the CNP is down" — the distinction check-manuel-links had to learn the hard way.
 *
 * Kept free of Node imports so the pure parts are cheap to test; the CLI does the I/O.
 */
import { cnpManuelFileName, cnpManuelUrl } from "./manuel-cnp.ts";

export type DownloadPlan = { code: string; url: string; fileName: string; file: string };

/** Where a code downloads from and to — `null` when the code is not a shape we accept. */
export function planManuelDownload(code: string, outDir: string): DownloadPlan | null {
  const fileName = cnpManuelFileName(code);
  const url = cnpManuelUrl(code);
  if (!fileName || !url) return null;
  return { code, url, fileName, file: `${outDir.replace(/[\\/]+$/, "")}/${fileName}` };
}

const PDF_MAGIC = "%PDF-";

/** A PDF starts with `%PDF-` — an HTML error page or a captive portal does not. */
export function looksLikePdf(head: Uint8Array): boolean {
  if (head.length < PDF_MAGIC.length) return false;
  for (let i = 0; i < PDF_MAGIC.length; i++) {
    if (head[i] !== PDF_MAGIC.charCodeAt(i)) return false;
  }
  return true;
}

export type FailureKind = "network-policy" | "not-found" | "http" | "not-pdf" | "network";
export type Failure = { kind: FailureKind; message: string };

export const NETWORK_POLICY_MESSAGE =
  "refusé par la politique réseau de l'environnement cloud — le lot 0 de l'étude cloud-first " +
  "(www.cnp.com.tn dans les domaines autorisés) n'est pas appliqué à cet environnement";

type ProxyEnv = { HTTPS_PROXY?: string; NODE_USE_ENV_PROXY?: string };

/** Flattens an error and its `cause` chain into one searchable line. */
function describeChain(err: unknown): string {
  const parts: string[] = [];
  let cur: unknown = err;
  for (let depth = 0; cur && depth < 5; depth++) {
    const e = cur as { name?: string; code?: string; message?: string; cause?: unknown };
    parts.push([e.code, e.message].filter(Boolean).join(" "));
    cur = e.cause;
  }
  return parts.filter(Boolean).join(" | ");
}

/**
 * Reads a failed `fetch`. Through the proxy, a refused host surfaces as undici's
 * `Proxy response (403) !== 200 when HTTP Tunneling`, buried two `cause`s deep under a plain
 * "fetch failed" — that is the network policy. A session that has a proxy but whose Node does
 * not use it (`NODE_USE_ENV_PROXY` unset) fails on every host: the hint names the variable.
 */
export function classifyFetchError(err: unknown, env: ProxyEnv = {}): Failure {
  const text = describeChain(err);
  if (/Proxy response \(403\)|host_not_allowed|CONNECT tunnel failed/i.test(text)) {
    return { kind: "network-policy", message: NETWORK_POLICY_MESSAGE };
  }
  if (env.HTTPS_PROXY && env.NODE_USE_ENV_PROXY !== "1") {
    return {
      kind: "network",
      message:
        `échec réseau (${text}) — cette session passe par un proxy (HTTPS_PROXY) que Node ` +
        "n'utilise qu'avec NODE_USE_ENV_PROXY=1 ; le hook de session l'exporte, relancer dans " +
        "une session neuve ou préfixer la commande",
    };
  }
  return { kind: "network", message: `échec réseau : ${text || "cause inconnue"}` };
}

export type ResponseShape = {
  status: number;
  denyReason: string | null;
  contentType: string | null;
  head: Uint8Array;
};

/** Reads a response that did arrive — `null` means "this is the PDF we asked for". */
export function classifyResponse({
  status,
  denyReason,
  contentType,
  head,
}: ResponseShape): Failure | null {
  if (status === 403 && denyReason)
    return { kind: "network-policy", message: NETWORK_POLICY_MESSAGE };
  if (status === 404) {
    return {
      kind: "not-found",
      message: "le CNP ne connaît pas ce fichier — vérifier le code dans suivi/corpus-cnp.json",
    };
  }
  if (status < 200 || status >= 300) return { kind: "http", message: `HTTP ${status}` };
  if (!looksLikePdf(head)) {
    return {
      kind: "not-pdf",
      message: `la réponse n'est pas un PDF (${contentType ?? "type inconnu"}) — page d'erreur ou portail`,
    };
  }
  return null;
}

export type PageRange = { first?: number; last?: number };

/** `18-24` → pages 18 to 24 ; `7` → page 7 ; empty → everything ; anything else → `null`. */
export function parsePages(spec: string | undefined): PageRange | null {
  if (spec === undefined || spec.trim() === "") return {};
  const m = /^(\d+)(?:-(\d+))?$/.exec(spec.trim());
  if (!m) return null;
  const first = Number(m[1]);
  const last = m[2] ? Number(m[2]) : first;
  if (first < 1 || last < first) return null;
  return { first, last };
}

export type RenderSpec = { file: string; outPrefix: string; dpi?: number } & PageRange;

/** The `pdftoppm` argv for a render — ~150 dpi is what the campaign playbook reads well. */
export function renderArgs({ file, outPrefix, dpi = 150, first, last }: RenderSpec): string[] {
  const args = ["-r", String(dpi), "-png"];
  if (first !== undefined) args.push("-f", String(first));
  if (last !== undefined) args.push("-l", String(last));
  args.push(file, outPrefix);
  return args;
}
