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
    const response = await fetch(new URL("/api/health", base), {
      headers: { accept: "application/json" },
      signal: AbortSignal.timeout(15_000),
    });
    body = await response.json();
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
