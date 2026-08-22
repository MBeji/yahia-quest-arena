// LE COFFRE — chiffrement enveloppe des clés d'API (étude 29 §3.2).
//
// CE QUE CE MODULE EST, ET CE QU'IL N'EST PAS
// ---------------------------------------------------------------------------
// Il chiffre et déchiffre. Il ne déchiffre JAMAIS pour afficher, jamais pour
// exporter, jamais pour un support. Il n'existe **aucun chemin de code** dont la
// sortie contient le clair : `openSecret()` rend un {@link OpaqueSecret}, un type
// que seul l'adaptateur sait ouvrir, dans le même appel (D-3).
//
// Un test le vérifie par LECTURE DU MODULE, pas par confiance (§3.2) : voir
// `__tests__/crypto.test.ts`.
//
// LA SPÉCIFICATION, EXACTEMENT (§3.2)
// ---------------------------------------------------------------------------
//   Primitive    AES-256-GCM via `node:crypto`. Aucune dépendance nouvelle —
//                ni pgcrypto, ni pgsodium, ni Vault, ni KMS tiers (D-5).
//   KEK          `AI_KEY_ENC_KEY`, 32 octets en base64, JAMAIS préfixée `VITE_`.
//   Dérivation   HKDF-SHA256(KEK, salt='ai-cred-v1', info='enc') pour le
//                chiffrement ; info='fp' pour l'empreinte. Une seule variable
//                d'environnement pour deux usages, jamais la même valeur des
//                deux côtés.
//   IV           12 octets ALÉATOIRES par écriture. Jamais réutilisé, jamais
//                dérivé du `user_id` — en GCM, réutiliser un IV sous la même clé
//                casse la confidentialité ET l'authenticité.
//   AAD          `${owner_user_id}:${enc_version}:${provider}` — lie le chiffré
//                à SA ligne : déplacer un chiffré vers une autre ligne le rend
//                indéchiffrable. C'est la défense contre une écriture SQL
//                malveillante, celle que le chiffrement seul ne donne pas.
//   Stockage     iv (12) ‖ tag (16) ‖ ciphertext, en UN champ `bytea`.
//   Empreinte    HMAC-SHA256(HKDF(…,'fp'), clé brute) tronqué à 32 hex.
//   Rotation     `AI_KEY_ENC_KEY_PREVIOUS` : la lecture essaie la courante puis
//                la précédente et signale qu'il faut ré-écrire (paresseuse).

import { createDecipheriv, createCipheriv, createHmac, hkdfSync, randomBytes } from "node:crypto";
import { sealSecret, type OpaqueSecret } from "@/shared/integrations/ai/types";
import type { AiProviderId } from "@/shared/constants/ai";

/** Version du SCHÉMA de chiffrement. Elle entre dans l'AAD — voir la note ci-dessous. */
export const AI_ENC_VERSION = 1;

const IV_BYTES = 12;
const TAG_BYTES = 16;
const KEY_BYTES = 32;
const HKDF_SALT = "ai-cred-v1";

/** L'identité qui lie un chiffré à sa ligne. Toute divergence rend le déchiffrement impossible. */
export type VaultBinding = {
  readonly ownerUserId: string;
  readonly provider: AiProviderId;
  /**
   * La version du SCHÉMA, pas de la clé maîtresse.
   *
   * Elle ne bouge PAS pendant une rotation de KEK, et c'est indispensable : si
   * elle bougeait, l'AAD changerait, et « essayer la clé précédente » ne pourrait
   * jamais réussir. Une rotation change la clé, pas le format.
   */
  readonly encVersion: number;
};

/** Le coffre est fermé quand la KEK manque : le mode famille est éteint, pas dégradé. */
export class VaultUnavailableError extends Error {
  constructor() {
    super("AI_VAULT_UNAVAILABLE");
    this.name = "VaultUnavailableError";
  }
}

function decodeKek(raw: string | undefined): Buffer | null {
  if (!raw) return null;
  const key = Buffer.from(raw, "base64");
  // Une KEK trop courte est une KEK qu'on croit avoir. Refuser bruyamment vaut
  // mieux que chiffrer sous 8 octets d'entropie parce qu'une variable a été
  // tronquée au copier-coller.
  return key.length === KEY_BYTES ? key : null;
}

/** La KEK courante. `null` ⇒ le coffre refuse d'écrire ET de lire (§3.10). */
function currentKek(): Buffer | null {
  return decodeKek(process.env.AI_KEY_ENC_KEY);
}

/** La KEK précédente, présente uniquement pendant une rotation. */
function previousKek(): Buffer | null {
  return decodeKek(process.env.AI_KEY_ENC_KEY_PREVIOUS);
}

/** Le coffre est-il ouvrable ? Lu à chaque appel : une variable retirée ferme le coffre tout de suite. */
export function isVaultAvailable(): boolean {
  return currentKek() !== null;
}

/**
 * Sous-clé dédiée à un usage. Deux `info` distincts ⇒ deux clés distinctes,
 * même KEK : la clé qui chiffre ne peut pas servir à calculer une empreinte, et
 * une fuite de l'une n'aide pas contre l'autre.
 */
function subKey(kek: Buffer, info: "enc" | "fp"): Buffer {
  return Buffer.from(hkdfSync("sha256", kek, Buffer.from(HKDF_SALT), Buffer.from(info), KEY_BYTES));
}

function aad(binding: VaultBinding): Buffer {
  return Buffer.from(`${binding.ownerUserId}:${binding.encVersion}:${binding.provider}`, "utf8");
}

/**
 * L'empreinte d'une clé. Elle sert à reconnaître une clé DÉJÀ CONNUE — la même
 * recollée après révocation, ou partagée entre deux comptes — sans permettre de
 * remonter à la clé.
 *
 * Elle est déterministe SOUS UNE KEK DONNÉE : après rotation, la même clé brute
 * produit une empreinte différente. C'est acceptable — l'empreinte est un signal
 * de détection, pas une identité stable.
 */
export function fingerprint(rawKey: string): string {
  const kek = currentKek();
  if (!kek) throw new VaultUnavailableError();
  return createHmac("sha256", subKey(kek, "fp")).update(rawKey, "utf8").digest("hex").slice(0, 32);
}

/** R-4 : les 4 derniers caractères, le seul fragment qui existera en clair. */
export function last4(rawKey: string): string {
  return rawKey.slice(-4).padStart(4, "•");
}

/**
 * Chiffre une clé pour SA ligne. Rend le `bytea` prêt à écrire.
 *
 * L'IV est tiré à chaque appel : deux écritures de la MÊME clé produisent deux
 * chiffrés différents. Un test l'exige explicitement — c'est la propriété qui
 * empêche de deviner « ces deux familles ont branché la même clé » en comparant
 * deux lignes de la base (l'empreinte, elle, est faite pour ça, et elle est hors
 * de portée d'un client).
 */
export function sealForRow(rawKey: string, binding: VaultBinding): Buffer {
  const kek = currentKek();
  if (!kek) throw new VaultUnavailableError();

  const iv = randomBytes(IV_BYTES);
  const cipher = createCipheriv("aes-256-gcm", subKey(kek, "enc"), iv);
  cipher.setAAD(aad(binding));
  const ciphertext = Buffer.concat([cipher.update(rawKey, "utf8"), cipher.final()]);
  return Buffer.concat([iv, cipher.getAuthTag(), ciphertext]);
}

function decryptWith(kek: Buffer, blob: Buffer, binding: VaultBinding): string | null {
  if (blob.length <= IV_BYTES + TAG_BYTES) return null;
  try {
    const decipher = createDecipheriv(
      "aes-256-gcm",
      subKey(kek, "enc"),
      blob.subarray(0, IV_BYTES),
    );
    decipher.setAAD(aad(binding));
    decipher.setAuthTag(blob.subarray(IV_BYTES, IV_BYTES + TAG_BYTES));
    return Buffer.concat([
      decipher.update(blob.subarray(IV_BYTES + TAG_BYTES)),
      decipher.final(),
    ]).toString("utf8");
  } catch {
    // GCM échoue en bloc : mauvaise clé, AAD qui ne correspond pas (chiffré
    // déplacé vers une autre ligne), ou octets altérés. On ne distingue pas — et
    // surtout on ne dit pas laquelle : ce serait un oracle.
    return null;
  }
}

export type OpenedSecret = {
  /** Le secret, sous une forme que seul l'adaptateur sait ouvrir (D-3). */
  readonly secret: OpaqueSecret;
  /**
   * `true` quand le déchiffrement a réussi avec la KEK PRÉCÉDENTE : l'appelant
   * doit ré-écrire le chiffré sous la clé courante (rotation paresseuse, §3.2).
   * Ne pas le faire ne casse rien tant que `AI_KEY_ENC_KEY_PREVIOUS` est là —
   * ce qui est exactement la fenêtre que la rotation cherche à refermer.
   */
  readonly needsRewrite: boolean;
};

/**
 * Ouvre le coffre. Rend `null` quand la ligne est illisible — clé maîtresse
 * perdue ou remplacée sans rotation (RISK-10), chiffré déplacé vers une autre
 * ligne, octets altérés.
 *
 * L'appelant traite `null` comme `status='invalid'` : aucune donnée
 * d'apprentissage n'est perdue, seule la clé devient illisible, et le porteur
 * est invité à la re-saisir.
 */
export function openSecret(blob: Buffer, binding: VaultBinding): OpenedSecret | null {
  const kek = currentKek();
  if (!kek) throw new VaultUnavailableError();

  const clear = decryptWith(kek, blob, binding);
  if (clear !== null) return { secret: sealSecret(clear), needsRewrite: false };

  const previous = previousKek();
  if (!previous) return null;

  const rotated = decryptWith(previous, blob, binding);
  if (rotated === null) return null;
  return { secret: sealSecret(rotated), needsRewrite: true };
}

/**
 * Ré-écrit un chiffré sous la KEK courante, à partir d'un secret ouvert.
 *
 * C'est le SEUL endroit du système qui a besoin du clair après une lecture, et
 * il ne le rend à personne : il le re-chiffre. La fonction prend le blob et son
 * `binding`, refait l'ouverture, et rend le nouveau blob — pour que le clair ne
 * transite pas par la signature d'une fonction publique.
 */
export function rewriteUnderCurrentKek(blob: Buffer, binding: VaultBinding): Buffer | null {
  const kek = currentKek();
  const previous = previousKek();
  if (!kek || !previous) return null;
  const clear = decryptWith(previous, blob, binding);
  if (clear === null) return null;
  return sealForRow(clear, binding);
}
