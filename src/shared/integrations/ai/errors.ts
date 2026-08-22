// Codes d'erreur STABLES de l'étage IA — annexe C de l'étude 29.
//
// LA RÈGLE QUE CE FICHIER EXISTE POUR TENIR (R-5)
// ---------------------------------------------------------------------------
// Le corps d'erreur brut d'un fournisseur n'est **jamais** propagé. Ce n'est pas
// de la cosmétique d'UI : certains fournisseurs répètent un fragment de la clé
// dans leur message d'erreur, et une exception qui remonte telle quelle jusqu'à
// un log ou une réponse d'API met ce fragment en clair dans un endroit qui n'est
// pas prévu pour ça.
//
// Toute sortie d'un appel fournisseur passe donc par `toAiError()`, qui produit
// un {@link AiError} portant UNIQUEMENT un code de la liste ci-dessous, un
// statut HTTP et une durée. Le message d'origine ne franchit pas cette frontière.
//
// Ce module est ISOMORPHE : les codes sont traduits côté client (motif des codes
// stables de `parent-code-errors.ts`), donc ils doivent être importables là-bas.

/**
 * Les codes stables, tels qu'ils sont écrits dans
 * `ai_credentials.last_error_code` et `ai_usage_events.error_code`.
 */
export const AI_ERROR_CODES = [
  /** 401 / 403 — la clé est refusée par le fournisseur. Aucun retry : elle le restera. */
  "AI_KEY_INVALID",
  /** 404 / 400 sur l'id de modèle — ce modèle n'existe pas chez ce fournisseur. */
  "AI_MODEL_UNKNOWN",
  /** 402, ou 429 « insufficient quota » — le compte fournisseur n'a plus de crédit. */
  "AI_CREDIT_EXHAUSTED",
  /** 429 de débit — trop d'appels d'un coup. 2 retries, puis dégradé silencieux. */
  "AI_RATE_LIMITED",
  /** 5xx, timeout — le fournisseur ne répond pas. Dégradé silencieux, énergie remboursée. */
  "AI_PROVIDER_DOWN",
  /** L'adresse est recalée par une des sept conditions de sortie de R-6. */
  "AI_HOST_NOT_ALLOWED",
  /** Interne (R-11) — plafond journalier ou mensuel atteint : l'appel n'est pas émis. */
  "AI_BUDGET_REACHED",
  /** Le validateur de sortie a refusé la réponse (é11 §3.4). Compté dans le taux de rebut. */
  "AI_OUTPUT_REJECTED",
  /** La Forge n'a pas réuni N items validés (§3.6). Échec honnête, énergie remboursée. */
  "AI_FORGE_NO_QUORUM",
  /** Le mode IA est éteint (kill-switch, pas de clé, pas d'activation). */
  "AI_MODE_OFF",
  /** Rien de ce qui précède : une erreur que le produit n'a pas su nommer. */
  "AI_UNKNOWN",
] as const;

export type AiErrorCode = (typeof AI_ERROR_CODES)[number];

const CODES: ReadonlySet<string> = new Set(AI_ERROR_CODES);

/** Un code inconnu (base plus récente que le code, ou l'inverse) dégrade en `AI_UNKNOWN`. */
export function asAiErrorCode(raw: string | null | undefined): AiErrorCode {
  return raw && CODES.has(raw) ? (raw as AiErrorCode) : "AI_UNKNOWN";
}

/**
 * L'erreur re-typée. Elle ne porte AUCUN texte venu du fournisseur : son
 * `message` est le code lui-même, pour qu'un log accidentel reste inoffensif.
 */
export class AiError extends Error {
  readonly code: AiErrorCode;
  /** Statut HTTP observé, quand il y en avait un. Utile au diagnostic, jamais au client. */
  readonly httpStatus?: number;
  /** Détail NON sensible, écrit par NOUS (jamais par le fournisseur) — ex. la condition R-6 violée. */
  readonly detail?: string;

  constructor(code: AiErrorCode, options?: { httpStatus?: number; detail?: string }) {
    super(code);
    this.name = "AiError";
    this.code = code;
    this.httpStatus = options?.httpStatus;
    this.detail = options?.detail;
  }
}

/**
 * Un statut HTTP est-il retentable ? 429 et 5xx uniquement. **Jamais 401/403** :
 * une clé invalide le reste, et réessayer brûle le quota du parent pour rien
 * (§3.5).
 */
export function isRetryableStatus(status: number): boolean {
  return status === 429 || (status >= 500 && status <= 599);
}

/**
 * Un 429 peut vouloir dire deux choses très différentes : « tu vas trop vite »
 * (retentable) et « ton compte n'a plus de crédit » (définitif). Les
 * fournisseurs ne les distinguent que dans le corps — le seul endroit où nous
 * regardons ce corps, sans jamais le conserver ni le propager.
 */
function isQuotaExhausted(bodyHint: string | undefined): boolean {
  if (!bodyHint) return false;
  const m = bodyHint.toLowerCase();
  return (
    m.includes("insufficient_quota") ||
    m.includes("insufficient quota") ||
    m.includes("exceeded your current quota") ||
    m.includes("credit balance is too low") ||
    m.includes("billing")
  );
}

/**
 * Un 400 peut viser l'id de modèle (donc l'enregistrement est refusé, US-2) ou
 * autre chose. Même posture que ci-dessus : on renifle, on ne conserve rien.
 */
function mentionsModel(bodyHint: string | undefined): boolean {
  if (!bodyHint) return false;
  return /model/i.test(bodyHint);
}

/**
 * Statut HTTP (+ un indice de corps, consommé et jeté) → code stable.
 *
 * `bodyHint` ne sort JAMAIS de cette fonction : il sert à choisir entre deux
 * codes, puis disparaît. C'est le seul point du système autorisé à le lire.
 */
export function aiErrorFromStatus(status: number, bodyHint?: string): AiError {
  if (status === 401 || status === 403)
    return new AiError("AI_KEY_INVALID", { httpStatus: status });
  if (status === 402) return new AiError("AI_CREDIT_EXHAUSTED", { httpStatus: status });
  if (status === 404) return new AiError("AI_MODEL_UNKNOWN", { httpStatus: status });
  if (status === 400) {
    return new AiError(mentionsModel(bodyHint) ? "AI_MODEL_UNKNOWN" : "AI_UNKNOWN", {
      httpStatus: status,
    });
  }
  if (status === 429) {
    return new AiError(isQuotaExhausted(bodyHint) ? "AI_CREDIT_EXHAUSTED" : "AI_RATE_LIMITED", {
      httpStatus: status,
    });
  }
  if (status >= 500) return new AiError("AI_PROVIDER_DOWN", { httpStatus: status });
  return new AiError("AI_UNKNOWN", { httpStatus: status });
}

/**
 * Le filet de sécurité : TOUTE exception qui traverse un adaptateur ressort
 * d'ici. Une `AiError` passe telle quelle ; n'importe quoi d'autre — y compris
 * une erreur du SDK Anthropic dont le `message` pourrait citer la requête —
 * devient un code, et rien de plus.
 */
export function toAiError(error: unknown): AiError {
  if (error instanceof AiError) return error;

  // Les erreurs du SDK Anthropic et un `Response` recalé exposent un `status`
  // numérique. On l'utilise pour choisir le code, sans jamais lire le message.
  const status = (error as { status?: unknown } | null)?.status;
  if (typeof status === "number") return aiErrorFromStatus(status);

  // Abandon volontaire (timeout de l'adaptateur) et coupure réseau : côté
  // produit c'est la même chose — le fournisseur n'a pas répondu.
  const name = (error as { name?: unknown } | null)?.name;
  if (name === "AbortError" || name === "TimeoutError") {
    return new AiError("AI_PROVIDER_DOWN", { detail: "timeout" });
  }

  return new AiError("AI_UNKNOWN");
}
