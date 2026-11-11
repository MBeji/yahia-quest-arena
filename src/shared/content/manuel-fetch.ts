/**
 * Helpers behind `npm run content:manuel:fetch` — how a CNP book code becomes a local PDF that
 * a session, cloud or local, can render and read in vision (étude cloud-first, lot 3).
 *
 * Doctrine, unchanged from `manuel-cnp.ts`: the URL is DERIVED from the code, never typed, so a
 * typo can only produce a missing document. And the download lands in a throwaway folder,
 * never in git — the textbooks are the CNP's (LICENSE-CONTENT.md), we link, we do not copy.
 *
 * The transfer itself is `curl`'s job, not Node's: curl honours the session proxy natively
 * (Node's `fetch` ignores HTTPS_PROXY unless NODE_USE_ENV_PROXY=1), streams to disk instead of
 * holding 40 MB in memory, and keeps network bytes out of Node's hands — CodeQL flagged the
 * `fetch` → `writeFileSync` version as "network data written to file" (#1003). Node only builds
 * the argv, reads curl's verdict, checks the `%PDF-` signature and deletes what is not a PDF.
 *
 * What is specific to a cloud session, and what these helpers name in clear text: the
 * environment's network policy. A host outside the allowlist is refused by the platform's proxy
 * at the CONNECT step: with `--fail` curl exits 22 saying `returned error: 403` — the same words
 * as a site's own 403 — but `%{http_connect}` carries the proxy's 403 while `%{http_code}` stays
 * 000 (observed 2026-09-05). That means "lot 0 of the study is not applied", not "the CNP is
 * down" — the distinction check-manuel-links had to learn.
 *
 * And one thing specific to the CNP itself (observed 2026-09-06, lot 0 applied): its server sends
 * the leaf certificate ALONE, without the Sectigo intermediate that signed it. Browsers fetch it
 * on their own (AIA); curl does not and exits 60. The session hook fixes that by adding the vendored
 * intermediate (scripts/cloud/ca-chain/) to CURL_CA_BUNDLE — so a 60 here means that chain no
 * longer matches what the CNP serves, and names where it is maintained.
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

export type FailureKind =
  "network-policy" | "tls" | "not-found" | "http" | "not-pdf" | "network" | "exists";
export type Failure = { kind: FailureKind; message: string };

export const NETWORK_POLICY_MESSAGE =
  "refusé par la politique réseau de l'environnement cloud — le lot 0 de l'étude cloud-first " +
  "(www.cnp.com.tn dans les domaines autorisés) n'est pas appliqué à cet environnement";

export const TLS_MESSAGE =
  "certificat du serveur non vérifiable — le CNP sert sa feuille sans l'intermédiaire de son " +
  "émetteur ; le hook de session le pose depuis scripts/cloud/ca-chain/ (README), hors cloud " +
  "exporter CURL_CA_BUNDLE vers un magasin qui le contient";

export const CURL_USER_AGENT = "yahia-quest-arena-manuel-fetch";

/**
 * The curl invocation: `--fail` turns any HTTP ≥ 400 into exit 22 with the code in stderr,
 * `--proto =https` pins the scheme even across redirects, `-w` reports the final status, the
 * proxy's CONNECT answer and the content type on stdout so Node can tell a refused host from a
 * site error without a second request.
 */
export function curlArgs(url: string, file: string, timeoutS = 300): string[] {
  return [
    "-sS",
    "--fail",
    "--location",
    "--proto",
    "=https",
    "--proto-redir",
    "=https",
    "--max-time",
    String(timeoutS),
    "-A",
    CURL_USER_AGENT,
    "-o",
    file,
    "-w",
    "%{http_code} %{http_connect} %{content_type}",
    url,
  ];
}

export type CurlOutcome = { status: number | null; stdout: string; stderr: string };
export type CurlReport = { status: number; connect: number; contentType: string | null };

/** curl's `-w '%{http_code} %{http_connect} %{content_type}'` line → the three values. */
export function parseCurlReport(stdout: string): CurlReport {
  const [code, connect, ...rest] = stdout.trim().split(/\s+/);
  const num = (s: string | undefined) => (Number.isFinite(Number(s)) ? Number(s) : 0);
  const contentType = rest.join(" ").trim();
  return { status: num(code), connect: num(connect), contentType: contentType || null };
}

/**
 * Reads a curl failure. A CONNECT answered ≥ 400 with no HTTP code at all is the environment
 * proxy refusing the host — the network policy (exit 56 without `--fail`, 22 with it); 60 is a
 * certificate the session cannot verify (the CNP's incomplete chain); 22 with a real HTTP code is
 * the site's answer, 404 meaning "unknown code"; 28 is the deadline; a missing binary has no
 * status at all. Everything else is reported with curl's own first line.
 */
export function classifyCurlFailure({ status, stdout, stderr }: CurlOutcome): Failure {
  const report = parseCurlReport(stdout);
  const firstLine = stderr.trim().split("\n")[0] ?? "";
  if (status === null) return { kind: "network", message: "curl indisponible sur ce poste" };
  const proxyRefused = report.connect >= 400 && report.status === 0;
  if (proxyRefused || status === 56 || /CONNECT tunnel failed|host_not_allowed/i.test(stderr)) {
    return { kind: "network-policy", message: NETWORK_POLICY_MESSAGE };
  }
  if (status === 60) return { kind: "tls", message: TLS_MESSAGE };
  if (status === 22) {
    const code = report.status || Number(/error: (\d{3})/.exec(stderr)?.[1] ?? 0);
    if (code === 404) {
      return {
        kind: "not-found",
        message: "le CNP ne connaît pas ce fichier — vérifier le code dans suivi/corpus-cnp.json",
      };
    }
    return { kind: "http", message: `HTTP ${code || "?"}` };
  }
  if (status === 28) return { kind: "network", message: "délai dépassé — le CNP ne répond pas" };
  return { kind: "network", message: `curl ${status} : ${firstLine || "cause inconnue"}` };
}

/** The verdict on what curl wrote: `null` means "this is the PDF we asked for". */
export function classifyDownloadedHead(
  head: Uint8Array,
  contentType: string | null,
): Failure | null {
  if (looksLikePdf(head)) return null;
  return {
    kind: "not-pdf",
    message: `la réponse n'est pas un PDF (${contentType ?? "type inconnu"}) — page d'erreur ou portail`,
  };
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
