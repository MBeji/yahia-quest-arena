#!/usr/bin/env node
/**
 * LA VEILLE NOCTURNE DU PUSH — étude 40, lot 1.
 *
 * Lit `GET /api/health` sur le site canonique et exige `push: "configured"`. Le champ dit si
 * les quatre variables serveur du canal push sont posées sur le déploiement qui répond (la
 * cinquième, la clé du bundle, est tenue par la garde de build `check-push-env.mjs`).
 *
 * Pourquoi la production et pas un test : la panne qu'elle surveille n'existe QUE là. Le push a
 * été éteint cinq mois en production pendant que toutes les suites étaient vertes (étude 40,
 * T-1) — les variables vivent dans Vercel, aucun test du dépôt ne peut les voir.
 *
 * Sortie : 0 si armé ; 1 si `unconfigured`, si le champ manque, ou si le site ne répond pas.
 *   node scripts/ci/check-prod-push.mjs [--url https://www.na9ranal3ab.tn]
 */
import { pathToFileURL } from "node:url";

export const DEFAULT_SITE_URL = "https://www.na9ranal3ab.tn";

/**
 * Trois essais espacés de 15 s : une coupure d'un instant entre GitHub et le site ne doit pas
 * rouvrir l'issue `nightly-failure`. Seule une réponse LUE compte ; un `unconfigured` lu n'est
 * pas réessayé — c'est un fait, pas un aléa du réseau.
 */
export const ATTEMPTS = 3;
export const RETRY_DELAY_MS = 15_000;

/**
 * Lit `/api/health`, en réessayant ce qui n'a pas abouti (réseau, délai, corps illisible).
 * `fetchImpl` et `sleep` sont injectés pour les tests.
 */
export async function readHealth(
  base,
  {
    fetchImpl = fetch,
    sleep = (ms) => new Promise((r) => setTimeout(r, ms)),
    attempts = ATTEMPTS,
  } = {},
) {
  let lastError;
  for (let attempt = 1; attempt <= attempts; attempt += 1) {
    try {
      const response = await fetchImpl(new URL("/api/health", base), {
        headers: { accept: "application/json" },
        signal: AbortSignal.timeout(15_000),
      });
      return await response.json();
    } catch (error) {
      lastError = error;
      if (attempt < attempts) await sleep(RETRY_DELAY_MS);
    }
  }
  throw lastError;
}

/**
 * @param {unknown} body le JSON de `/api/health`
 * @returns {{ ok: boolean, message: string }}
 */
export function pushVerdict(body) {
  const push = body && typeof body === "object" ? body.push : undefined;
  const commit =
    body && typeof body === "object" && typeof body.commit === "string" ? body.commit : "?";
  if (push === "configured") {
    return { ok: true, message: `push armé en production (déploiement ${commit})` };
  }
  if (push === "unconfigured") {
    return {
      ok: false,
      message:
        `push ÉTEINT en production (déploiement ${commit}) : une des variables serveur Web Push ` +
        "manque dans le projet Vercel du site — docs/environment-variables.md § Web Push.",
    };
  }
  return {
    ok: false,
    message: `réponse de /api/health sans champ « push » (déploiement ${commit}) : la production sert-elle un code antérieur à l'étude 40, lot 1 ?`,
  };
}

async function main() {
  const i = process.argv.indexOf("--url");
  const base = i !== -1 && process.argv[i + 1] ? process.argv[i + 1] : DEFAULT_SITE_URL;
  let body;
  try {
    body = await readHealth(base);
  } catch (error) {
    console.error(
      `[prod-push] /api/health injoignable : ${error instanceof Error ? error.message : error}`,
    );
    process.exit(1);
  }
  const { ok, message } = pushVerdict(body);
  (ok ? console.log : console.error)(`[prod-push] ${message}`);
  process.exit(ok ? 0 : 1);
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main();
}
