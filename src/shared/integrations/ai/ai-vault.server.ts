// LE COFFRE, CÔTÉ ADMINISTRATION — lire un secret, marquer un état, tourner la KEK.
//
// POURQUOI CE MODULE EXISTE, ET IL EXISTE POUR UNE RAISON DE FORME
// ---------------------------------------------------------------------------
// Ces trois gestes servent DEUX appelants qui ne se connaissent pas :
// l'orchestrateur d'appels (`ai-call.server`), à chaque appel de modèle, et la
// console du porteur (`ai-credentials.server`), qui doit lire la clé du coffre
// pour re-vérifier un changement de modèle (2026-08-28).
//
// Les laisser chez l'un des deux fabriquait un CYCLE d'imports — la console
// voulait `openOwnerSecret` de l'orchestrateur, qui voulait `markCredentialState`
// de la console. ESM s'en sort par hissage, mais un cycle entre deux modules
// serveur est une dette qu'aucun bundler ne garantit de porter éternellement, et
// personne ne devrait avoir à vérifier ce genre de chose à chaque refonte.
//
// Ce qu'on gagne accessoirement : les trois écritures privilégiées de la table
// `ai_credentials` sont à un seul endroit, sous les yeux, plutôt que dispersées
// entre un orchestrateur et un écran de réglages.

import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { z } from "zod";

import { AI_ENC_VERSION, AI_PROVIDERS, type AiProviderId } from "@/shared/constants/ai";
import type { AiErrorCode } from "@/shared/integrations/ai";
import type { OpaqueSecret } from "@/shared/integrations/ai/types";
// `crypto.server` — le coffre — n'est PAS importé statiquement : il tire
// `node:crypto` au niveau module. Ses deux fonctions sont chargées à l'usage,
// dans les fonctions async ci-dessous (#909). `AI_ENC_VERSION`, qui n'est qu'un
// nombre, vient de `@/shared/constants/ai`.

/**
 * La lecture du CHIFFRÉ (`openOwnerSecret`), et d'elle seule. L'étude la décrit
 * ainsi : « le chargement du chiffré se fait en Node, avec le client
 * `service_role` » (§3.4). Trois colonnes, jamais une de plus ; `secret_enc` en
 * sort sous sa forme CHIFFRÉE, et son seul consommateur est le coffre. Le
 * fournisseur y est relu contre ce schéma.
 */
const providerSchema = z.enum(AI_PROVIDERS);

const rpc = () => supabaseAdmin;

/**
 * Marque l'état d'une clé après un appel — ou après une rotation de KEK. Jamais
 * appelé par un client : c'est l'orchestrateur qui constate, pas l'utilisateur
 * qui déclare.
 *
 * Un 401 fait basculer la clé en `invalid` : elle le restera jusqu'à ce que son
 * porteur la remplace. Ne pas le faire condamnerait chaque appel suivant à
 * re-découvrir la même chose, sur le quota du parent.
 */
export async function markCredentialState(
  ownerUserId: string,
  status: "active" | "invalid",
  errorCode: AiErrorCode | null,
): Promise<void> {
  const { error } = await rpc().rpc("set_ai_credential_state", {
    p_owner: ownerUserId,
    p_status: status,
    // `p_error_code TEXT DEFAULT NULL` : l'omettre vaut NULL.
    p_error_code: errorCode ?? undefined,
    p_touch_used: true,
  });
  if (error) logger.error("ai.credential.state", { error: errorMessage(error) });
}

/**
 * Ouvre le secret d'un porteur. `null` ⇒ clé illisible (RISK-10), et la ligne a
 * déjà basculé en `invalid` avant que cette fonction rende la main.
 *
 * C'est LA lecture du coffre, en un seul exemplaire : la notation `bytea`, la
 * bascule sur clé illisible et la rotation paresseuse de KEK ne doivent exister
 * qu'ici — trois gestes qui, dupliqués, dériveraient sans que rien ne le dise.
 */
export async function openOwnerSecret(
  ownerUserId: string,
): Promise<{ secret: OpaqueSecret; provider: AiProviderId } | null> {
  const { data: row, error } = await supabaseAdmin
    .from("ai_credentials")
    .select("secret_enc, enc_version, provider")
    .eq("owner_user_id", ownerUserId)
    .maybeSingle();

  if (error || !row) {
    logger.error("ai.credential.load", { error: error ? errorMessage(error) : "missing" });
    return null;
  }

  // `provider` est un TEXT sous CHECK côté SQL ; le type généré n'en garde que
  // `string`. Il choisit l'adaptateur ET entre dans l'AAD du chiffré : un
  // fournisseur inconnu est une clé inutilisable, pas un appel à tenter.
  const provider = providerSchema.safeParse(row.provider);
  if (!provider.success) {
    logger.error("ai.credential.load", { error: "unknown provider" });
    return null;
  }

  // PostgREST rend un `bytea` en notation `\x…`. C'est le seul endroit du
  // système qui reconstitue le tampon, et il le passe immédiatement au coffre.
  const blob = Buffer.from(row.secret_enc.replace(/^\\x/, ""), "hex");
  const { openSecret } = await import("./crypto.server");
  const opened = openSecret(blob, {
    ownerUserId,
    provider: provider.data,
    encVersion: row.enc_version ?? AI_ENC_VERSION,
  });

  if (!opened) {
    // Clé illisible : KEK perdue ou remplacée sans rotation, chiffré déplacé.
    // Aucune donnée d'apprentissage n'est perdue — seule la clé l'est, et son
    // porteur est invité à la re-saisir (RISK-10).
    await markCredentialState(ownerUserId, "invalid", "AI_KEY_INVALID");
    return null;
  }

  if (opened.needsRewrite) {
    // Rotation paresseuse : la lecture a réussi avec la KEK précédente. On ne
    // bloque pas l'appel là-dessus — la ré-écriture est un effet de bord, et son
    // échec se rattrape à la lecture suivante.
    void rewriteSecret(ownerUserId, blob, provider.data, row.enc_version ?? AI_ENC_VERSION);
  }

  return { secret: opened.secret, provider: provider.data };
}

async function rewriteSecret(
  ownerUserId: string,
  blob: Buffer,
  provider: AiProviderId,
  encVersion: number,
): Promise<void> {
  const { rewriteUnderCurrentKek } = await import("./crypto.server");
  const next = rewriteUnderCurrentKek(blob, { ownerUserId, provider, encVersion });
  if (!next) return;
  const { error } = await rpc().rpc("rewrite_ai_credential_secret", {
    p_owner: ownerUserId,
    p_secret_enc: `\\x${next.toString("hex")}`,
    p_enc_version: encVersion,
  });
  if (error) logger.warn("ai.credential.rotate", { error: errorMessage(error) });
}
