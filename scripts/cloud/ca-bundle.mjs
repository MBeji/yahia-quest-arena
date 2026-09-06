/**
 * La chaîne de certificats d'une session cloud — les intermédiaires que des sites oublient de
 * servir, vendus dans `scripts/cloud/ca-chain/` et posés dans la session par le hook
 * `.claude/hooks/session-start.mjs` (étude cloud-first, lot 0 constaté le 2026-09-06).
 *
 * Le cas fondateur : `www.cnp.com.tn` sert son certificat feuille SEUL, sans l'intermédiaire
 * Sectigo qui l'a signé. Un navigateur va le chercher de lui-même (AIA) ; curl, OpenSSL et le
 * `fetch` de Node ne le font pas et rendent « unable to get local issuer certificate » (curl 60),
 * même quand la politique réseau de l'environnement autorise l'hôte. L'entrepôt AIA de
 * l'émetteur (crt.sectigo.com) est hors liste blanche ; l'intermédiaire, lui, est public,
 * vérifiable contre le magasin système, et se trouve dans la chaîne d'hôtes déjà autorisés
 * (nodejs.org, ghcr.io) — c'est de là qu'il a été extrait (README du dossier ca-chain).
 *
 * Mécanique : magasin de base + intermédiaires → UN fichier dans le cache privé de
 * l'utilisateur, et trois variables exportées dans $CLAUDE_ENV_FILE — `CURL_CA_BUNDLE` (curl),
 * `SSL_CERT_FILE` (OpenSSL, Python), `NODE_EXTRA_CA_CERTS` (Node). Le magasin de base est
 * celui que la plateforme impose déjà à curl (il porte la CA de son proxy), sinon celui du
 * système ; sans magasin de base en fichier (Windows : schannel), on ne pose rien — un poste
 * va chercher l'intermédiaire tout seul.
 */
import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

/** Le dossier des intermédiaires vendus : un certificat PEM par fichier, nommé par son sujet. */
export const CA_CHAIN_DIR = join(dirname(fileURLToPath(import.meta.url)), "ca-chain");

/** Les variables que le bundle combiné remplace — dans l'ordre où elles sont exportées. */
export const CA_ENV_VARS = ["CURL_CA_BUNDLE", "SSL_CERT_FILE", "NODE_EXTRA_CA_CERTS"];

const SYSTEM_STORES = ["/etc/ssl/certs/ca-certificates.crt", "/etc/pki/tls/certs/ca-bundle.crt"];

/**
 * Le magasin de base : celui que l'environnement impose à curl d'abord (il contient la CA du
 * proxy de la plateforme, indispensable aux hôtes qu'il termine), sinon `SSL_CERT_FILE`, sinon
 * le magasin du système. `null` quand aucun n'existe en fichier.
 */
export function baseCaBundle(env = process.env) {
  return (
    [env.CURL_CA_BUNDLE, env.SSL_CERT_FILE, ...SYSTEM_STORES]
      .filter(Boolean)
      .find((p) => existsSync(p)) ?? null
  );
}

/** Les intermédiaires vendus, triés par nom — seuls les `.pem` comptent. */
export function listIntermediates(dir = CA_CHAIN_DIR) {
  if (!existsSync(dir)) return [];
  return readdirSync(dir)
    .filter((f) => f.endsWith(".pem"))
    .sort()
    .map((f) => join(dir, f));
}

/** `…/sectigo-public-server-authentication-ca-dv-r36.pem` → son nom, pour le rapport. */
export function pemLabel(file) {
  return basename(file, ".pem");
}

/** Le bundle combiné vit dans le cache privé de l'utilisateur — jamais dans le dépôt. */
export function defaultBundleFile(home = homedir()) {
  return join(home, ".cache", "yqa-ca", "ca-bundle.pem");
}

/**
 * Écrit magasin de base + intermédiaires dans `outFile` (dossier créé en 0700) et rend
 * `{ file, base, intermediates }` — ou `null` quand il n'y a rien à poser : aucun intermédiaire
 * vendu, ou aucun magasin de base en fichier.
 */
export function buildCaBundle({
  env = process.env,
  dir = CA_CHAIN_DIR,
  outFile = defaultBundleFile(),
} = {}) {
  const base = baseCaBundle(env);
  const intermediates = listIntermediates(dir);
  if (!base || intermediates.length === 0) return null;
  const parts = [base, ...intermediates].map((f) => readFileSync(f, "utf8").trimEnd() + "\n");
  mkdirSync(dirname(outFile), { recursive: true, mode: 0o700 });
  writeFileSync(outFile, parts.join(""));
  return { file: outFile, base, intermediates };
}

/** Les lignes à ajouter à $CLAUDE_ENV_FILE pour que curl, OpenSSL et Node lisent le bundle. */
export function caEnvExports(file) {
  return CA_ENV_VARS.map((name) => `export ${name}="${file}"\n`).join("");
}
