/**
 * Caviardage commun au journal (`logger.ts`) et à Sentry (`monitoring.ts`).
 *
 * Deux façons pour un secret d'atteindre un journal :
 *  - sous une CLÉ qui le nomme (`token`, `authorization`…) — à n'importe quelle profondeur ;
 *  - dans une VALEUR qui n'annonce rien : le message d'erreur d'un fournisseur d'IA qui
 *    recopie la clé refusée, une URL de rappel avec son jeton, un en-tête collé dans un
 *    texte. Les formes ci-dessous sont celles que le produit manipule réellement.
 *
 * Constat du 2026-11-12 : le journal ne caviardait que les clés de PREMIER niveau, et aucune
 * valeur. `{ headers: { authorization } }` ou `{ error: "Incorrect API key provided: sk-…" }`
 * partaient en clair vers les logs Vercel et vers Sentry.
 */

export const REDACTED = "********";

const SENSITIVE_KEY_PARTS = [
  "token",
  "secret",
  "password",
  "key",
  "authorization",
  "bearer",
  "cookie",
] as const;

/** Une clé dont le NOM annonce un secret (comparaison insensible à la casse, en sous-chaîne). */
export function isSensitiveKey(key: string): boolean {
  const lowered = key.toLowerCase();
  return SENSITIVE_KEY_PARTS.some((part) => lowered.includes(part));
}

const SECRET_VALUE_PATTERNS: RegExp[] = [
  // JWT (jeton Supabase d'un élève, clé anon/service historique) : trois segments base64url.
  /\beyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}/g,
  // En-tête d'autorisation recopié dans un texte.
  /\b(?:Bearer|Basic)\s+[A-Za-z0-9._~+/=-]{8,}/gi,
  // Clés Supabase nouvelle génération.
  /\bsb_(?:secret|publishable)_[A-Za-z0-9_-]{8,}/g,
  // Clés de fournisseurs d'IA et assimilés : sk-…, sk-ant-…, sk-proj-…, rk-…, xai-…
  /\b(?:sk|rk|xai)-[A-Za-z0-9_-]{16,}/g,
  // Google (Gemini) et Groq.
  /\bAIza[0-9A-Za-z_-]{30,}/g,
  /\bgsk_[A-Za-z0-9]{16,}/g,
  // Jetons GitHub (PAT d'automatisation).
  /\b(?:ghp|gho|ghs|github_pat)_[A-Za-z0-9_]{16,}/g,
];

/** Remplace, dans un texte, tout ce qui a la FORME d'un secret. */
export function redactSecrets(value: string): string {
  let out = value;
  for (const pattern of SECRET_VALUE_PATTERNS) out = out.replace(pattern, REDACTED);
  return out;
}

const MAX_DEPTH = 6;

/**
 * Copie caviardée d'une valeur quelconque : clés sensibles masquées à toute profondeur,
 * formes de secret masquées dans les chaînes, `Error` réduite à son nom et son message
 * (une `Error` passée telle quelle à `JSON.stringify` donne `{}` — elle se perdait).
 * Bornée en profondeur : un objet cyclique ne boucle pas.
 */
export function redactDeep(value: unknown, depth = 0): unknown {
  if (typeof value === "string") return redactSecrets(value);
  if (value === null || typeof value !== "object") return value;
  if (value instanceof Error) {
    return { name: value.name, message: redactSecrets(value.message) };
  }
  if (depth >= MAX_DEPTH) return "[depth]";
  if (Array.isArray(value)) return value.map((item) => redactDeep(item, depth + 1));
  const out: Record<string, unknown> = {};
  for (const [key, inner] of Object.entries(value)) {
    out[key] = isSensitiveKey(key) ? REDACTED : redactDeep(inner, depth + 1);
  }
  return out;
}
