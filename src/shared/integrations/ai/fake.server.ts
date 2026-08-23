// Le fournisseur FACTICE — CI, e2e, développement sans clé (`AI_FAKE_PROVIDER=1`).
//
// L'étude est catégorique au §5 : « aucun appel réel vers un fournisseur, jamais,
// sous aucun prétexte (ni clé de test en secret CI, ni "un petit appel de
// fumée") ». Le seul appel réel du système est celui de la vérification (US-2),
// déclenché par un humain avec sa propre clé.
//
// Ce fournisseur est donc la seule chose que la CI voit. Deux propriétés le
// rendent utile plutôt que décoratif :
//
//   * il est DÉTERMINISTE — même requête, même sortie, à l'octet près. Un test
//     de la chaîne de la Forge peut donc affirmer « ce candidat est rejeté »
//     sans dépendre de la météo d'un modèle ;
//   * il rapporte un USAGE plausible, donc les tests de comptabilité et de
//     plafond exercent le vrai calcul de coût, pas un `0` qui passe partout.
//
// Il n'imite pas la qualité d'un modèle : il imite son CONTRAT.

import { AI_MAX_TOKENS } from "@/shared/constants/ai";
import { AiError } from "./errors";
import {
  renderBlocks,
  type AiCapabilities,
  type AiChunk,
  type AiCredential,
  type AiProvider,
  type AiRequest,
  type AiResult,
} from "./types";

/**
 * Hachage stable et court d'une chaîne (FNV-1a 32 bits). Sert à produire une
 * sortie qui VARIE avec l'entrée sans jamais varier dans le temps : deux tests
 * différents ne reçoivent pas la même réponse, et le même test la reçoit
 * toujours identique.
 */
function stableHash(input: string): string {
  let hash = 0x811c9dc5;
  for (let i = 0; i < input.length; i += 1) {
    hash ^= input.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return hash.toString(16).padStart(8, "0");
}

/**
 * Sortie par surface. Chaque forme est celle que le validateur de la surface
 * attend, pour que le test exerce le validateur et pas un cas dégénéré.
 *
 * `verify` répond exactement `OK` : c'est ce que l'appel de vérification (US-2)
 * demande au modèle, et sa brièveté est le point — ≤ 16 tokens de sortie.
 */
function fakeText(req: AiRequest, fingerprint: string): string {
  switch (req.feature) {
    case "verify":
      return "OK";
    case "forge":
      // Un payload structuré valide : la chaîne de la Forge doit pouvoir aller
      // jusqu'aux filtres déterministes, pas caler sur du texte libre.
      return JSON.stringify({ items: [] });
    case "forge_solve":
      return JSON.stringify({ answer: 0 });
    default:
      return `[fake:${req.feature}:${fingerprint}]`;
  }
}

/**
 * Le contrat, sans le réseau. `capabilities` déclare tout à `true` : la CI doit
 * exercer le chemin NOMINAL. Les chemins dégradés (pas de streaming, pas de
 * sortie structurée) se testent en construisant un faux avec des capacités
 * réduites — {@link makeFakeAiProvider} le permet.
 */
export function makeFakeAiProvider(
  capabilities: AiCapabilities = { streaming: true, structuredOutput: true, promptCache: true },
): AiProvider {
  return {
    id: "fake",
    capabilities,

    async generate(req: AiRequest, cred: AiCredential): Promise<AiResult> {
      // Le faux applique la MÊME borne que les vrais : un appelant qui dépasse
      // `AI_MAX_TOKENS` doit échouer en CI, pas seulement en production (R-10).
      if (req.maxTokens > AI_MAX_TOKENS[req.feature]) {
        throw new AiError("AI_OUTPUT_REJECTED", { detail: "max_tokens_exceeded" });
      }

      const context = `${req.system}\n${renderBlocks(req.blocks)}`;
      const fingerprint = stableHash(`${req.feature}|${req.tier}|${context}`);
      const text = fakeText(req, fingerprint);

      return {
        text,
        usage: {
          // Dérivés du volume réel : les tests de coût manipulent des nombres
          // qui bougent quand le contexte bouge.
          inputTokens: Math.max(1, Math.ceil(context.length / 4)),
          outputTokens: Math.max(1, Math.ceil(text.length / 4)),
          cachedTokens: 0,
        },
        model: req.tier === "rich" ? cred.models.rich : cred.models.fast,
        latencyMs: 1,
      };
    },

    async *stream(req: AiRequest, cred: AiCredential): AsyncIterable<AiChunk> {
      if (!capabilities.streaming) {
        throw new AiError("AI_UNKNOWN", { detail: "streaming_unsupported" });
      }
      const result = await this.generate(req, cred);
      // Deux morceaux plutôt qu'un : un consommateur qui ne concatène pas se
      // fait prendre par le test le plus simple du monde.
      const cut = Math.ceil(result.text.length / 2);
      yield { type: "text", text: result.text.slice(0, cut) };
      yield { type: "text", text: result.text.slice(cut) };
      yield { type: "done", result };
    },
  };
}
