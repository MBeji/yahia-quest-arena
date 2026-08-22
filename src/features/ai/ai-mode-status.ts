// Le contrat ISOMORPHE de la section « Mode IA » — étude 29 lot 2.
//
// Ce module traverse la frontière serveur/client : la server fn le remplit, la
// section des Réglages le lit. Il ne contient donc que des types et des
// fonctions pures — et surtout, il définit par sa FORME ce qui a le droit de
// descendre au navigateur.
//
// R-4, exprimée en TypeScript : il n'y a pas de champ pour la clé. Ni en clair,
// ni chiffrée, ni son empreinte. `last4` est le seul fragment qui existe, et
// c'est un champ à part entière pour qu'on voie, en lisant ce fichier, exactement
// ce que le porteur peut lire de sa propre clé.

import type { AiProviderId } from "@/shared/constants/ai";
import type { AiErrorCode } from "@/shared/integrations/ai";
import type { TranslationKeys } from "@/lib/i18n";

/** Préfixe des erreurs typées du mode IA — motif des codes stables de `parent-code-errors.ts`. */
export const AI_MODE_ERROR_PREFIX = "AI_MODE_ERROR:";

export type AiCredentialStatus = "unverified" | "active" | "invalid" | "revoked";

/** Ce que le PORTEUR voit de sa propre clé. La liste est la spécification de R-4. */
export type AiCredentialView = {
  readonly provider: AiProviderId;
  readonly baseUrl: string | null;
  readonly modelFast: string;
  readonly modelRich: string;
  /** Les 4 derniers caractères. Le seul fragment de clé qui existe en clair. */
  readonly last4: string;
  readonly status: AiCredentialStatus;
  readonly lastErrorCode: AiErrorCode;
  readonly hasError: boolean;
  readonly verifiedAt: string | null;
  readonly lastUsedAt: string | null;
  readonly dailyBudgetUsd: number;
  readonly monthlyBudgetUsd: number;
  readonly doubleSolve: boolean;
  /** R-20 : le texte de consentement a changé depuis la signature — il faut le redemander. */
  readonly consentStale: boolean;
  /**
   * Les plafonds argent + énergie COUPENT-ILS ? Défaut `false` depuis le
   * 2026-08-22 : ils sont mesurés et alertés, ils n'interrompent plus. Le
   * porteur peut les réarmer depuis les Réglages, sans redéploiement.
   */
  readonly limitsEnforced: boolean;
};

export type AiModeStatus = {
  /**
   * Le chemin FAMILLE est-il ouvert ? Faux si le kill-switch global est baissé,
   * si le BYOK est coupé, ou si le coffre n'a pas sa clé maîtresse. L'écran n'a
   * pas à distinguer les trois — le log, si.
   */
  readonly available: boolean;
  readonly consentVersion: string;
  /** R-2a : sous la 4ᵉ année secondaire — ou niveau inconnu — un adulte doit être présent. */
  readonly requiresAdultConfirmation: boolean;
  readonly credential: AiCredentialView | null;
};

/** Extrait le code stable d'une erreur de server fn, ou `null` si ce n'en est pas une. */
export function aiModeErrorCode(raw: string): AiErrorCode | null {
  const index = raw.indexOf(AI_MODE_ERROR_PREFIX);
  if (index === -1) return null;
  return raw.slice(index + AI_MODE_ERROR_PREFIX.length).trim() as AiErrorCode;
}

/**
 * Le code → la phrase, dans la langue du lecteur.
 *
 * L'annexe C impose ce détour : « le corps d'erreur brut d'un fournisseur n'est
 * jamais propagé ». Le serveur envoie un code, le client le traduit — sinon un
 * parent arabophone lirait le message d'erreur anglais d'OpenAI.
 */
export function aiErrorLabel(code: AiErrorCode | null, t: TranslationKeys): string {
  switch (code) {
    case "AI_KEY_INVALID":
      return t.ai.errKeyInvalid;
    case "AI_MODEL_UNKNOWN":
      return t.ai.errModelUnknown;
    case "AI_CREDIT_EXHAUSTED":
      return t.ai.errCreditExhausted;
    case "AI_RATE_LIMITED":
      return t.ai.errRateLimited;
    case "AI_PROVIDER_DOWN":
      return t.ai.errProviderDown;
    case "AI_HOST_NOT_ALLOWED":
      return t.ai.errHostNotAllowed;
    case "AI_BUDGET_REACHED":
      return t.ai.errBudgetReached;
    case "AI_MODE_OFF":
      return t.ai.errModeOff;
    default:
      return t.ai.errGeneric;
  }
}
