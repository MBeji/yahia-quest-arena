// @vitest-environment node
import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

import {
  AI_FORGE_LIMITS,
  AI_FORGE_TIMEOUT,
  AI_TIMEOUT_MS,
  forgeTimeoutMs,
} from "@/shared/constants/ai";
import { candidateCount } from "../forge/filters";

/**
 * LA PATIENCE DE LA FORGE SUIT LE VOLUME.
 *
 * `AI_TIMEOUT_MS.forge` valait 90 s, calibré le 2026-08-25 sur une mesure
 * réelle : 59 s pour SEPT candidats sur `grok-4.6`. Sept, c'est le plus petit
 * quiz du produit (5 demandés + 2 de marge) — et l'écran arrive sur 8
 * questions, soit dix candidats. Le plafond était donc réglé pour le cas que
 * personne ne choisit par défaut, et la Forge tombait en `AI_PROVIDER_DOWN` sur
 * son propre réglage (signalé en usage le 2026-08-26, sur une clé dont la
 * vérification venait pourtant de passer).
 */

/** Le `maxDuration` réel de la fonction SSR, lu à la source et non recopié. */
function ssrMaxDurationMs(): number {
  const source = readFileSync("scripts/build-vercel.mjs", "utf8");
  const match = /maxDuration:\s*(\d+)/.exec(source);
  if (!match) throw new Error("maxDuration introuvable dans scripts/build-vercel.mjs");
  return Number(match[1]) * 1000;
}

describe("forgeTimeoutMs", () => {
  it("rend la valeur MESURÉE pour le plus petit quiz — aucune régression", () => {
    // 5 questions ⇒ 7 candidats ⇒ les 90 s d'avant, à la milliseconde près. Ce
    // qui marchait hier marche encore, sinon ce correctif en casserait un autre.
    expect(forgeTimeoutMs(candidateCount(5))).toBe(AI_TIMEOUT_MS.forge);
  });

  it("accorde plus de temps aux quiz plus gros", () => {
    const sizes = [...AI_FORGE_LIMITS.allowedSizes];
    const delays = sizes.map((size) => forgeTimeoutMs(candidateCount(size)));

    // Strictement croissant : c'est tout le défaut corrigé ici.
    expect(delays).toEqual([...delays].sort((a, b) => a - b));
    expect(new Set(delays).size).toBe(sizes.length);

    // Le DÉFAUT de l'écran (8 questions) est le cas qui échouait.
    expect(forgeTimeoutMs(candidateCount(8))).toBeGreaterThan(AI_TIMEOUT_MS.forge);
  });

  it("couvre la vitesse mesurée sur un modèle à raisonnement", () => {
    // 59 s pour 7 candidats ⇒ ~8,4 s par candidat, hors coût fixe. Le barème
    // doit rester au-dessus de cette pente, sinon il re-crée la panne un cran
    // plus haut.
    const measuredPerCandidateMs = 59_000 / 7;
    for (const size of AI_FORGE_LIMITS.allowedSizes) {
      const candidates = candidateCount(size);
      expect(forgeTimeoutMs(candidates)).toBeGreaterThan(measuredPerCandidateMs * candidates);
    }
  });

  it("plafonne, et le plafond laisse la place à la double résolution", () => {
    expect(forgeTimeoutMs(10_000)).toBe(AI_FORGE_TIMEOUT.capMs);

    // ⚠️ L'invariant écrit à côté d'`AI_TIMEOUT_MS`, enfin VÉRIFIÉ : au-delà du
    // `maxDuration` de la fonction SSR, c'est la plateforme qui tue le
    // processus, et un 504 muet remplace l'erreur typée que le porteur peut
    // lire — la panne du 2026-08-25.
    const budget = ssrMaxDurationMs();
    expect(AI_FORGE_TIMEOUT.capMs).toBeLessThan(budget);
    // Et il reste de quoi re-résoudre les candidats APRÈS la génération.
    expect(budget - AI_FORGE_TIMEOUT.capMs).toBeGreaterThanOrEqual(AI_TIMEOUT_MS.forge);
  });

  it("aucun délai de surface ne dépasse le budget de la fonction SSR", () => {
    const budget = ssrMaxDurationMs();
    for (const [feature, ms] of Object.entries(AI_TIMEOUT_MS)) {
      expect(ms, feature).toBeLessThan(budget);
    }
  });
});
