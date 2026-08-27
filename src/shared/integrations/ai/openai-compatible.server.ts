// Adaptateur `openai_compatible` — étude 29 §3.5, D-6.
//
// UN SEUL PROTOCOLE, UNE ADRESSE LIBRE
// ---------------------------------------------------------------------------
// `POST {base_url}/chat/completions` couvre OpenAI, OpenRouter, Groq, DeepSeek,
// Mistral, l'endpoint compatible de Google — et, depuis Q-4, **toute autre
// adresse saisie par l'utilisateur**. C'est le pari de l'étude : un protocole de
// plus à maintenir, contre l'essentiel du marché.
//
// La liberté d'adresse ne coûte rien ici parce qu'elle est payée ailleurs :
// chaque requête part par `egressFetch`, donc par les sept conditions de R-6.
// Cet adaptateur n'a pas le droit d'appeler `fetch` ni `https.request` en direct
// — ce serait rouvrir le SSRF que Q-4 a rendu possible.
//
// UN SERVICE QUI NE RÉPOND PAS AU FORMAT ÉCHOUE PROPREMENT (D-6) : on ne devine
// pas, on rend un code typé de l'annexe C.

import { AI_MAX_RETRIES, AI_TIMEOUT_MS } from "@/shared/constants/ai";
import { egressFetch, type EgressLookup, type HttpsRequestFn } from "./egress.server";
import { AiError, aiErrorFromStatus, isRetryableStatus, toAiError } from "./errors";
import {
  renderBlocks,
  revealSecret,
  type AiChunk,
  type AiCredential,
  type AiProvider,
  type AiRequest,
  type AiResult,
} from "./types";

type CompletionChoice = { message?: { content?: unknown } };
type CompletionUsage = {
  prompt_tokens?: unknown;
  completion_tokens?: unknown;
  prompt_tokens_details?: { cached_tokens?: unknown };
};
type CompletionBody = { choices?: CompletionChoice[]; model?: unknown; usage?: CompletionUsage };

function asInt(value: unknown): number {
  return typeof value === "number" && Number.isFinite(value) ? Math.max(0, Math.trunc(value)) : 0;
}

/** `base_url` + `/chat/completions`, en tolérant la barre finale que tout le monde colle. */
export function completionsUrl(baseUrl: string): string {
  return `${baseUrl.replace(/\/+$/, "")}/chat/completions`;
}

/**
 * Corps de la requête. L'ordre des champs est stable : certains services
 * hachent la requête pour leur propre cache, et un ordre qui varie casse ce
 * cache sans rien dire.
 */
export function buildCompletionPayload(req: AiRequest, model: string): Record<string, unknown> {
  const payload: Record<string, unknown> = {
    model,
    max_tokens: req.maxTokens,
    messages: [
      { role: "system", content: req.system },
      { role: "user", content: renderBlocks(req.blocks) },
    ],
  };

  if (req.responseSchema) {
    // Sortie structurée du protocole compatible. Un service qui ignore le champ
    // rendra du texte libre : c'est le cas « pas de `structuredOutput` », et il
    // finit en rebut compté — pas en plantage (§3.5).
    payload.response_format = {
      type: "json_schema",
      json_schema: { name: "output", strict: true, schema: req.responseSchema },
    };
  }

  return payload;
}

/** Attente entre deux essais : 400 ms puis 1 200 ms. Court — un élève attend derrière. */
function backoffMs(attempt: number): number {
  return 400 * 3 ** attempt;
}

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export type OpenAiCompatibleDeps = { lookup?: EgressLookup; requestFn?: HttpsRequestFn };

/**
 * Le fournisseur. `promptCache: false` n'est pas une lacune de notre code : le
 * protocole compatible n'expose pas de césure de cache explicite. Certains
 * services cachent d'eux-mêmes sur le préfixe, et c'est pour cela que
 * {@link buildCompletionPayload} garde un ordre stable — mais nous ne pouvons
 * pas le PROMETTRE, donc nous ne le déclarons pas.
 */
export function makeOpenAiCompatibleProvider(deps: OpenAiCompatibleDeps = {}): AiProvider {
  return {
    id: "openai_compatible",
    capabilities: { streaming: false, structuredOutput: true, promptCache: false },

    async generate(req: AiRequest, cred: AiCredential): Promise<AiResult> {
      if (!cred.baseUrl) throw new AiError("AI_HOST_NOT_ALLOWED", { detail: "missing_base_url" });

      const model = req.tier === "rich" ? cred.models.rich : cred.models.fast;
      const url = completionsUrl(cred.baseUrl);
      const body = JSON.stringify(buildCompletionPayload(req, model));
      const startedAt = Date.now();

      let lastError: AiError = new AiError("AI_UNKNOWN");

      // Le délai et le compte d'essais se lisent PAR SURFACE : une Forge et un
      // chat n'ont pas la même patience, et un modèle à raisonnement ne rend
      // pas un quiz en trente secondes (§3.5, mesure du 2026-08-25).
      const timeoutMs = req.timeoutMs ?? AI_TIMEOUT_MS[req.feature];
      const maxRetries = AI_MAX_RETRIES[req.feature];

      for (let attempt = 0; attempt <= maxRetries; attempt += 1) {
        let response;
        try {
          response = await egressFetch(
            url,
            {
              method: "POST",
              headers: {
                // Condition 7 : la clé de l'utilisateur, le type de contenu, et
                // RIEN d'autre. Aucun identifiant de la plateforme ne part.
                authorization: `Bearer ${revealSecret(cred.secret)}`,
                "content-type": "application/json",
                accept: "application/json",
                "content-length": String(Buffer.byteLength(body)),
              },
              body,
              timeoutMs,
            },
            deps,
          );
        } catch (error) {
          lastError = toAiError(error);
          // Une adresse recalée par R-6 ne devient pas valide en réessayant, et
          // un timeout a déjà consommé 30 secondes : on ne les rejoue pas.
          if (lastError.code === "AI_HOST_NOT_ALLOWED") throw lastError;
          if (attempt < maxRetries && lastError.code === "AI_PROVIDER_DOWN") {
            await sleep(backoffMs(attempt));
            continue;
          }
          throw lastError;
        }

        if (response.status >= 200 && response.status < 300) {
          return parseCompletion(response.body, model, Date.now() - startedAt);
        }

        // Le corps ne sert qu'à choisir entre deux codes (429 débit vs crédit
        // épuisé), puis il est jeté : il n'entre ni dans l'erreur, ni dans un log.
        lastError = aiErrorFromStatus(response.status, response.body);
        if (!isRetryableStatus(response.status) || attempt === maxRetries) {
          throw lastError;
        }
        // 429 « crédit épuisé » est définitif malgré son statut retentable :
        // réessayer brûlerait le quota du parent pour rien (§3.5).
        if (lastError.code === "AI_CREDIT_EXHAUSTED") throw lastError;
        await sleep(backoffMs(attempt));
      }

      throw lastError;
    },

    // Le protocole compatible sait streamer (`stream: true`, SSE), mais tous les
    // services qui l'implémentent ne le font pas de la même façon, et R-6
    // plafonne la TAILLE d'une réponse — ce qui ne se marie pas avec un flux
    // qu'on lit au fil de l'eau. La dégradation est PRÉVUE (§3.5) : le chat de
    // é11 retombe en réponse non streamée. L'implémenter à moitié serait pire.
    async *stream(req: AiRequest, cred: AiCredential): AsyncIterable<AiChunk> {
      const result = await this.generate(req, cred);
      yield { type: "text", text: result.text };
      yield { type: "done", result };
    },
  };
}

/** Lecture stricte de la réponse : un service hors format échoue sur un code typé (D-6). */
export function parseCompletion(raw: string, model: string, latencyMs: number): AiResult {
  let parsed: CompletionBody;
  try {
    parsed = JSON.parse(raw) as CompletionBody;
  } catch {
    throw new AiError("AI_OUTPUT_REJECTED", { detail: "not_json" });
  }

  const content = parsed.choices?.[0]?.message?.content;
  if (typeof content !== "string") {
    throw new AiError("AI_OUTPUT_REJECTED", { detail: "no_text_content" });
  }

  return {
    text: content,
    usage: {
      inputTokens: asInt(parsed.usage?.prompt_tokens),
      outputTokens: asInt(parsed.usage?.completion_tokens),
      cachedTokens: asInt(parsed.usage?.prompt_tokens_details?.cached_tokens),
    },
    // L'id rapporté par le service fait foi : c'est LUI qui est journalisé
    // (R-13), pas celui que nous avons demandé. Un service qui substitue un
    // modèle doit se voir dans la console qualité.
    model: typeof parsed.model === "string" && parsed.model ? parsed.model : model,
    latencyMs,
  };
}
