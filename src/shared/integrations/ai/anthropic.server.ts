// Adaptateur `anthropic` — étude 29 §3.5, D-6.
//
// POURQUOI UN SDK ICI, ET UN `fetch` DURCI EN FACE
// ---------------------------------------------------------------------------
// L'asymétrie est voulue et elle tient à R-6. L'adresse d'un fournisseur
// `openai_compatible` est SAISIE par l'utilisateur : elle doit passer par les
// sept conditions de sortie, dont l'épinglage d'IP — ce qu'aucun SDK ne permet.
// L'adresse d'Anthropic, elle, est FIXE (le schéma l'impose :
// `CHECK ((provider = 'openai_compatible') OR base_url IS NULL)`), donc la
// surface SSRF est nulle et le SDK officiel apporte ce qu'un `fetch` maison
// n'apporterait pas : le cache de prompt et le typage de l'API Messages.
//
// C'est le seul chemin qui exploite le prompt caching et les paliers de é11.
//
// CE QUE L'ADAPTATEUR GARANTIT, quel que soit le fournisseur (§3.5) :
// timeout et retries PAR SURFACE (`AI_TIMEOUT_MS`, `AI_MAX_RETRIES` — 30 s et
// 2 essais partout, sauf la Forge) sur 429/5xx uniquement ; **aucun retry sur 401/403**
// (une clé invalide le reste — sinon on brûle le quota du parent) ; erreurs
// re-typées (R-5, annexe C) ; usage rapporté ; absence du bundle client prouvée
// par `build:check`.

// ⚠️ LE SDK EST IMPORTÉ EN `type` UNIQUEMENT — sa valeur arrive par
// `await import(…)` dans la fabrique ci-dessous (#909).
//
// `@anthropic-ai/sdk` tire `node:fs` et `node:path`. En dev, Vite sert les
// modules non bundlés : un composant client qui importe un `*.server.ts` fait
// charger au navigateur tout le graphe STATIQUE de ce module — le plugin
// TanStack Start vide les corps de server functions mais laisse leurs imports.
// Ce SDK entrait donc dans le graphe client par
// `ai-call.server` → `provider.server` → ce fichier. Il n'y levait pas (ses
// accès `fs` sont gardés) : il masquait simplement le voisin qui, lui, levait.
// Un import de type disparaît à la compilation ; la coupure est posée ici, au
// point d'entrée du paquet, pour qu'aucun appelant ne puisse le réintroduire.
import type Anthropic from "@anthropic-ai/sdk";
import { AI_EGRESS_RULES, AI_MAX_RETRIES, AI_TIMEOUT_MS } from "@/shared/constants/ai";
import { AiError, toAiError } from "./errors";
import {
  cacheBoundaryIndex,
  revealSecret,
  type AiChunk,
  type AiCredential,
  type AiProvider,
  type AiRequest,
  type AiResult,
} from "./types";

/**
 * Fabrique du client — paramétrable pour que les tests n'ouvrent aucune socket.
 *
 * Elle rend `Anthropic` OU une promesse : la fabrique par défaut charge le SDK
 * paresseusement (voir l'en-tête), les fabriques de test le rendent
 * directement, et les deux appels (`generate`, `stream`) sont déjà `async`.
 */
export type AnthropicFactory = (apiKey: string) => Anthropic | Promise<Anthropic>;

const defaultFactory: AnthropicFactory = async (apiKey) => {
  const { default: AnthropicSdk } = await import("@anthropic-ai/sdk");
  return new AnthropicSdk({
    apiKey,
    // DÉFAUTS du client, surchargés par surface à chaque appel (voir `generate`).
    // Ils ne servent donc qu'aux chemins qui ne passent pas de surface — mais un
    // défaut du SDK vaudrait dix minutes, alors on pose le nôtre.
    //
    // Le SDK compte en MILLISECONDES (piège documenté : Python compte en
    // secondes). 30 s, comme la condition 6 de R-6 pour l'autre adaptateur —
    // un élève ne doit pas attendre deux fois plus longtemps selon la clé de
    // sa famille.
    timeout: AI_EGRESS_RULES.timeoutMs,
    // Le SDK retente 408/409/429/5xx et JAMAIS 401/403 : exactement la règle de
    // §3.5. On aligne le compte sur `AI_EGRESS_RULES` plutôt que sur son défaut,
    // pour que les deux adaptateurs soient réglés au même endroit.
    maxRetries: AI_EGRESS_RULES.maxRetries,
  });
};

/**
 * Les blocs, traduits en contenu Messages avec la césure de cache.
 *
 * L'ordre stable → volatil de `AiRequest.blocks` (é11 §3.4) n'a d'intérêt que si
 * la césure est posée : sans `cache_control`, un préfixe identique est refacturé
 * plein tarif à chaque appel, et la promesse de l'annexe A (« la facture d'un
 * porteur de clé baisse à mesure que le pot commun se remplit ») tombe.
 */
export function buildAnthropicContent(req: AiRequest): Anthropic.ContentBlockParam[] {
  const boundary = cacheBoundaryIndex(req.blocks);
  return req.blocks.map((block, index) => {
    const param: Anthropic.TextBlockParam = {
      type: "text",
      text: `<${block.label}>\n${block.text}\n</${block.label}>`,
    };
    return index === boundary ? { ...param, cache_control: { type: "ephemeral" } } : param;
  });
}

/** Concatène les blocs de texte de la réponse ; ignore tout le reste (thinking, tool_use). */
function textOf(message: Anthropic.Message): string {
  return message.content
    .filter((block): block is Anthropic.TextBlock => block.type === "text")
    .map((block) => block.text)
    .join("");
}

function usageOf(usage: Anthropic.Usage) {
  return {
    inputTokens: usage.input_tokens ?? 0,
    outputTokens: usage.output_tokens ?? 0,
    // Les tokens LUS depuis le cache sont ceux qui allègent la facture ; ceux
    // ÉCRITS dans le cache coûtent ~1,25× l'entrée et sont déjà comptés par
    // `input_tokens` chez ce fournisseur.
    cachedTokens: usage.cache_read_input_tokens ?? 0,
  };
}

export function makeAnthropicProvider(factory: AnthropicFactory = defaultFactory): AiProvider {
  return {
    id: "anthropic",
    capabilities: { streaming: true, structuredOutput: true, promptCache: true },

    async generate(req: AiRequest, cred: AiCredential): Promise<AiResult> {
      const model = req.tier === "rich" ? cred.models.rich : cred.models.fast;
      const startedAt = Date.now();
      try {
        const client = await factory(revealSecret(cred.secret));
        const message = await client.messages.create(
          {
            model,
            max_tokens: req.maxTokens,
            // Le système est STABLE d'un appel à l'autre pour une même surface :
            // c'est le premier élément du préfixe caché (é11 §3.4).
            system: [{ type: "text", text: req.system, cache_control: { type: "ephemeral" } }],
            messages: [{ role: "user", content: buildAnthropicContent(req) }],
            ...(req.responseSchema
              ? {
                  output_config: {
                    format: { type: "json_schema" as const, schema: req.responseSchema },
                  },
                }
              : {}),
          },
          {
            // Le délai et les essais se règlent PAR SURFACE, et par requête —
            // le client, lui, est construit une fois. Sans cette surcharge, un
            // élève attendrait deux fois moins longtemps selon la clé de sa
            // famille, ce que le constructeur ci-dessus refuse explicitement.
            timeout: req.timeoutMs ?? AI_TIMEOUT_MS[req.feature],
            maxRetries: AI_MAX_RETRIES[req.feature],
          },
        );

        if (message.stop_reason === "refusal") {
          // Le modèle a décliné. Ce n'est ni une panne ni une clé invalide :
          // c'est une sortie refusée, comptée dans le taux de rebut (R-13).
          throw new AiError("AI_OUTPUT_REJECTED", { detail: "refusal" });
        }

        return {
          text: textOf(message),
          usage: usageOf(message.usage),
          // L'id rapporté par l'API fait foi (R-13), pas celui demandé.
          model: message.model || model,
          latencyMs: Date.now() - startedAt,
        };
      } catch (error) {
        // R-5 : rien de ce que le SDK a mis dans son message ne franchit cette
        // ligne. Certains corps d'erreur répètent un fragment de la requête.
        throw toAiError(error);
      }
    },

    async *stream(req: AiRequest, cred: AiCredential): AsyncIterable<AiChunk> {
      const model = req.tier === "rich" ? cred.models.rich : cred.models.fast;
      const startedAt = Date.now();
      let stream;
      try {
        const client = await factory(revealSecret(cred.secret));
        stream = client.messages.stream(
          {
            model,
            max_tokens: req.maxTokens,
            system: [{ type: "text", text: req.system, cache_control: { type: "ephemeral" } }],
            messages: [{ role: "user", content: buildAnthropicContent(req) }],
          },
          // Même règle par surface que `generate` : la garantie annoncée en tête
          // de fichier ne vaut que si les DEUX chemins l'appliquent.
          {
            timeout: req.timeoutMs ?? AI_TIMEOUT_MS[req.feature],
            maxRetries: AI_MAX_RETRIES[req.feature],
          },
        );
      } catch (error) {
        throw toAiError(error);
      }

      try {
        for await (const event of stream) {
          if (event.type === "content_block_delta" && event.delta.type === "text_delta") {
            yield { type: "text", text: event.delta.text };
          }
        }
        const message = await stream.finalMessage();
        yield {
          type: "done",
          result: {
            text: textOf(message),
            usage: usageOf(message.usage),
            model: message.model || model,
            latencyMs: Date.now() - startedAt,
          },
        };
      } catch (error) {
        throw toAiError(error);
      }
    },
  };
}
