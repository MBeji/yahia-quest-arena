/**
 * LA GARDE DE BUILD DU PUSH — étude 40, lot 1.
 *
 * Du 2026-06-13 au 2026-11-13, le canal push a été déclaré livré alors que le build de
 * production ne portait pas sa clé publique : `VITE_VAPID_PUBLIC_KEY` est incrustée dans le
 * bundle client À LA COMPILATION, et sans elle `usePush` se compile en « unconfigured » — la
 * carte d'activation se masque pour tout le monde, sans un mot. Zéro souscription en cinq mois,
 * et rien pour le dire (étude 40, T-1).
 *
 * Cette garde fait échouer le SEUL build qui compte — la production du projet qui sert le site
 * canonique — quand une des cinq variables Web Push manque, ou quand la clé publique du client
 * diffère de celle du serveur (une souscription signée pour l'une serait refusée par l'autre).
 *
 * Elle ne touche à rien d'autre :
 *   • un build local, de CI ou de prévisualisation n'a pas `VERCEL_ENV=production` ;
 *   • un projet Vercel de production qui ne sert pas `www` (le dépôt en alimente deux) n'a pas
 *     la bonne `VERCEL_PROJECT_PRODUCTION_URL` : y exiger les clés le ferait rougir pour rien.
 *
 * Elle ne lit que la PRÉSENCE des secrets ; elle n'écrit ni valeur ni empreinte dans le journal.
 */

/** Hôte du site canonique — doit égaler celui de `SITE_URL` (`src/shared/constants/site.ts`, test). */
export const CANONICAL_HOST = "www.na9ranal3ab.tn";

/**
 * Les noms sous lesquels Vercel peut désigner ce projet dans `VERCEL_PROJECT_PRODUCTION_URL` :
 * Vercel y met « le plus court » des domaines de production — l'apex, qui redirige vers `www`,
 * l'emporte sur `www` lui-même.
 */
const CANONICAL_PRODUCTION_HOSTS = new Set([CANONICAL_HOST, CANONICAL_HOST.replace(/^www\./, "")]);

/** Les cinq variables de `docs/environment-variables.md` § Web Push. */
export const PUSH_BUILD_ENV_KEYS = [
  "VITE_VAPID_PUBLIC_KEY",
  "VAPID_PUBLIC_KEY",
  "VAPID_PRIVATE_KEY",
  "VAPID_SUBJECT",
  "CRON_SECRET",
];

const value = (env, key) => (env[key] ?? "").trim();

/**
 * @param {Record<string, string | undefined>} env
 * @returns {{ applies: boolean, ok: boolean, problems: string[] }}
 */
export function checkPushBuildEnv(env) {
  const productionUrl = value(env, "VERCEL_PROJECT_PRODUCTION_URL").replace(/^https?:\/\//, "");
  const applies =
    value(env, "VERCEL_ENV") === "production" && CANONICAL_PRODUCTION_HOSTS.has(productionUrl);
  if (!applies) return { applies, ok: true, problems: [] };

  const problems = PUSH_BUILD_ENV_KEYS.filter((key) => value(env, key) === "").map(
    (key) => `${key} absente`,
  );
  const client = value(env, "VITE_VAPID_PUBLIC_KEY");
  const server = value(env, "VAPID_PUBLIC_KEY");
  if (client && server && client !== server) {
    problems.push("VITE_VAPID_PUBLIC_KEY diffère de VAPID_PUBLIC_KEY");
  }
  return { applies, ok: problems.length === 0, problems };
}

/** Appelée par `build-vercel.mjs` avant la compilation : lève, et le build s'arrête. */
export function assertPushBuildEnv(env = process.env) {
  const { applies, ok, problems } = checkPushBuildEnv(env);
  if (!applies) return;
  if (!ok) {
    throw new Error(
      `Garde du push (étude 40, lot 1) — build de production de ${CANONICAL_HOST} refusé : ` +
        `${problems.join(" ; ")}. Poser les variables de docs/environment-variables.md § Web Push ` +
        "dans le projet Vercel qui sert le site, puis redéployer sans cache.",
    );
  }
  console.log("▶ Garde du push : les cinq variables Web Push sont posées.");
}
