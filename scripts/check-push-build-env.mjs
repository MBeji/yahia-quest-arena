/**
 * Garde de build Web Push (étude 40, lot 1 — « le push se prouve »).
 *
 * POURQUOI. La clé publique VAPID du navigateur (`VITE_VAPID_PUBLIC_KEY`) s'incruste à la
 * COMPILATION : absente du build, `usePush` compile en « unconfigured » et la carte
 * d'activation ne propose jamais rien. C'est arrivé pendant des mois en production sans que
 * personne le voie. Cette garde fait échouer le build plutôt que de livrer cette panne muette.
 *
 * OÙ ELLE TOURNE. Dans `scripts/build-vercel.mjs`, c'est-à-dire dans le build que Vercel
 * exécute — pas dans `build:check` (CI), qui ne protège pas la production.
 *
 * DEUX PROJETS VERCEL. Le dépôt se déploie dans `na9ranal3ab` (sert `www.na9ranal3ab.tn`, porte
 * les variables) ET dans `yahia-quest-arena` (sans domaine propre, sans les variables). Échouer
 * sur tout `VERCEL_ENV=production` rougirait chaque déploiement de production du second projet,
 * donc chaque commit de `main`. La garde n'ÉCHOUE donc que pour le projet qui sert le domaine
 * public (`VERCEL_PROJECT_PRODUCTION_URL` sous `na9ranal3ab.tn`) ; ailleurs elle AVERTIT.
 * Si Vercel cessait d'exposer cette variable, la garde avertirait au lieu d'échouer — le
 * nightly (`/api/health` → `push`) et la vérification du chunk servi restent le filet.
 *
 * Elle n'imprime JAMAIS la valeur de la clé.
 */

/** Le domaine public que sert le projet Vercel de production. */
export const PUBLIC_DOMAIN = "na9ranal3ab.tn";

/**
 * Une clé publique VAPID est un point P-256 non compressé (65 octets, premier octet 0x04),
 * soit 87 caractères base64url sans remplissage, dont le premier est toujours `B`.
 */
const VAPID_PUBLIC_KEY_RE = /^B[A-Za-z0-9_-]{86}$/;

/** Hôte de `VERCEL_PROJECT_PRODUCTION_URL` (Vercel le donne sans schéma). */
function hostOf(url) {
  if (!url) return "";
  try {
    return new URL(url.includes("://") ? url : `https://${url}`).hostname.toLowerCase();
  } catch {
    return "";
  }
}

/** Ce build est-il celui du projet qui sert le domaine public ? */
export function servesPublicDomain(env) {
  const host = hostOf(env.VERCEL_PROJECT_PRODUCTION_URL);
  return host === PUBLIC_DOMAIN || host.endsWith(`.${PUBLIC_DOMAIN}`);
}

/**
 * Verdict pur : `ok` (rien à dire), `warn` (on avertit, le build continue) ou `fail`
 * (le build doit échouer). Le message ne contient jamais la valeur de la clé.
 *
 * @param {Record<string, string | undefined>} env
 * @returns {{ level: "ok" | "warn" | "fail", message: string }}
 */
export function checkPushBuildEnv(env) {
  if (env.VERCEL_ENV !== "production") {
    return { level: "ok", message: "Web Push : build hors production, garde non appliquée." };
  }

  const key = (env.VITE_VAPID_PUBLIC_KEY ?? "").trim();
  let problem = null;
  if (key === "") {
    problem = "VITE_VAPID_PUBLIC_KEY est vide";
  } else if (!VAPID_PUBLIC_KEY_RE.test(key)) {
    problem =
      "VITE_VAPID_PUBLIC_KEY n'a pas la forme d'une clé publique VAPID (87 car. base64url, commence par B)";
  }
  if (problem === null) {
    return {
      level: "ok",
      message: "Web Push : VITE_VAPID_PUBLIC_KEY présente au build de production.",
    };
  }

  const consequence =
    "la carte d'activation compilerait en « unconfigured » : aucun élève ne pourrait activer le push. " +
    "Voir docs/environment-variables.md § Web Push.";
  if (servesPublicDomain(env)) {
    return {
      level: "fail",
      message: `✖ Web Push : ${problem} dans le build qui sert ${PUBLIC_DOMAIN} — ${consequence}`,
    };
  }
  return {
    level: "warn",
    message:
      `⚠ Web Push : ${problem} dans ce build de production, qui ne sert pas ${PUBLIC_DOMAIN} ` +
      `(projet Vercel secondaire) — avertissement seulement ; ${consequence}`,
  };
}

/** Applique le verdict : imprime, et lève quand le build doit échouer. */
export function enforcePushBuildEnv(env = process.env, log = console) {
  const { level, message } = checkPushBuildEnv(env);
  if (level === "fail") {
    log.error(message);
    throw new Error("Garde Web Push : build de production refusé (voir le message ci-dessus).");
  }
  if (level === "warn") log.warn(message);
  else log.log(message);
}
