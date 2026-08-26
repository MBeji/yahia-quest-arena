// @vitest-environment node
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { randomBytes } from "node:crypto";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { revealSecret } from "@/shared/integrations/ai/types";
import {
  AI_ENC_VERSION,
  fingerprint,
  isVaultAvailable,
  last4,
  openSecret,
  rewriteUnderCurrentKek,
  sealForRow,
  VaultUnavailableError,
  type VaultBinding,
} from "../crypto.server";

/**
 * LE COFFRE (étude 29 §3.2). Ce fichier est l'expression exécutable de la seule
 * chose que l'étude refuse de négocier : une clé d'API confiée par une famille
 * ne fuit pas.
 *
 * Quatre propriétés, et aucune n'est décorative :
 *   1. aller-retour — sinon rien ne marche ;
 *   2. AAD — un chiffré DÉPLACÉ vers une autre ligne devient indéchiffrable.
 *      C'est la défense contre une écriture SQL malveillante, celle que le
 *      chiffrement seul ne donne pas ;
 *   3. IV distinct à chaque écriture — deux lignes portant la même clé ne se
 *      reconnaissent pas en comparant leurs octets ;
 *   4. rotation de KEK — la lecture essaie la courante puis la précédente, et
 *      SIGNALE qu'il faut ré-écrire.
 */

const KEK_A = randomBytes(32).toString("base64");
const KEK_B = randomBytes(32).toString("base64");

const binding: VaultBinding = {
  ownerUserId: "11111111-1111-4111-8111-111111111111",
  provider: "anthropic",
  encVersion: AI_ENC_VERSION,
};

const RAW_KEY = "sk-ant-api03-not-a-real-key-4f2a";

beforeEach(() => {
  vi.stubEnv("AI_KEY_ENC_KEY", KEK_A);
  vi.stubEnv("AI_KEY_ENC_KEY_PREVIOUS", "");
});

afterEach(() => {
  vi.unstubAllEnvs();
});

describe("le coffre refuse de travailler sans sa clé maîtresse", () => {
  it("est indisponible sans AI_KEY_ENC_KEY", () => {
    vi.stubEnv("AI_KEY_ENC_KEY", "");
    expect(isVaultAvailable()).toBe(false);
    expect(() => sealForRow(RAW_KEY, binding)).toThrow(VaultUnavailableError);
    expect(() => fingerprint(RAW_KEY)).toThrow(VaultUnavailableError);
  });

  it("refuse une KEK tronquée plutôt que de chiffrer sous moins d'entropie", () => {
    // Le scénario réel : un copier-coller qui perd la fin de la variable.
    vi.stubEnv("AI_KEY_ENC_KEY", randomBytes(16).toString("base64"));
    expect(isVaultAvailable()).toBe(false);
  });

  it("est disponible avec une KEK de 32 octets", () => {
    expect(isVaultAvailable()).toBe(true);
  });
});

describe("aller-retour", () => {
  it("rend la clé exacte", () => {
    const blob = sealForRow(RAW_KEY, binding);
    const opened = openSecret(blob, binding);
    expect(opened).not.toBeNull();
    expect(revealSecret(opened!.secret)).toBe(RAW_KEY);
    expect(opened!.needsRewrite).toBe(false);
  });

  it("stocke iv ‖ tag ‖ ciphertext dans UN champ", () => {
    const blob = sealForRow(RAW_KEY, binding);
    // 12 (iv) + 16 (tag) + la clé elle-même : un seul tampon, rien à
    // désynchroniser (§3.2).
    expect(blob.length).toBe(12 + 16 + Buffer.byteLength(RAW_KEY));
  });

  it("le chiffré ne contient AUCUN fragment de la clé", () => {
    const blob = sealForRow(RAW_KEY, binding);
    expect(blob.toString("utf8")).not.toContain("sk-ant");
    expect(blob.toString("hex")).not.toContain(Buffer.from(RAW_KEY).toString("hex"));
  });
});

describe("l'AAD lie le chiffré à SA ligne", () => {
  it("refuse un chiffré déplacé vers un autre propriétaire", () => {
    const blob = sealForRow(RAW_KEY, binding);
    const stolen = { ...binding, ownerUserId: "22222222-2222-4222-8222-222222222222" };
    expect(openSecret(blob, stolen)).toBeNull();
  });

  it("refuse un chiffré déplacé vers un autre fournisseur", () => {
    const blob = sealForRow(RAW_KEY, binding);
    expect(openSecret(blob, { ...binding, provider: "openai_compatible" })).toBeNull();
  });

  it("refuse un chiffré dont la version de schéma a changé", () => {
    const blob = sealForRow(RAW_KEY, binding);
    expect(openSecret(blob, { ...binding, encVersion: 2 })).toBeNull();
  });

  it("refuse un chiffré altéré, sans dire OÙ", () => {
    const blob = sealForRow(RAW_KEY, binding);
    // Un octet du ciphertext retourné : GCM échoue en bloc. On ne distingue pas
    // « mauvaise clé » de « octets altérés » — ce serait un oracle.
    const tampered = Buffer.from(blob);
    tampered[tampered.length - 1] ^= 0xff;
    expect(openSecret(tampered, binding)).toBeNull();
  });

  it("refuse un blob trop court pour contenir iv + tag", () => {
    expect(openSecret(Buffer.alloc(20), binding)).toBeNull();
  });
});

describe("l'IV est tiré à CHAQUE écriture", () => {
  it("deux chiffrés de la même clé sont différents", () => {
    const a = sealForRow(RAW_KEY, binding);
    const b = sealForRow(RAW_KEY, binding);
    expect(a.equals(b)).toBe(false);
    // Les IV eux-mêmes diffèrent : c'est la propriété, pas un effet de bord.
    expect(a.subarray(0, 12).equals(b.subarray(0, 12))).toBe(false);
  });

  it("les deux se déchiffrent quand même", () => {
    for (const blob of [sealForRow(RAW_KEY, binding), sealForRow(RAW_KEY, binding)]) {
      expect(revealSecret(openSecret(blob, binding)!.secret)).toBe(RAW_KEY);
    }
  });

  it("l'IV n'est pas dérivé du propriétaire — deux comptes, deux IV", () => {
    const a = sealForRow(RAW_KEY, binding);
    const b = sealForRow(RAW_KEY, {
      ...binding,
      ownerUserId: "33333333-3333-4333-8333-333333333333",
    });
    expect(a.subarray(0, 12).equals(b.subarray(0, 12))).toBe(false);
  });
});

describe("rotation de la clé maîtresse (paresseuse, sans fenêtre de panne)", () => {
  it("lit un chiffré de l'ancienne KEK et DEMANDE la ré-écriture", () => {
    const blob = sealForRow(RAW_KEY, binding);

    // La rotation : l'ancienne devient PREVIOUS, une nouvelle prend sa place.
    vi.stubEnv("AI_KEY_ENC_KEY", KEK_B);
    vi.stubEnv("AI_KEY_ENC_KEY_PREVIOUS", KEK_A);

    const opened = openSecret(blob, binding);
    expect(opened).not.toBeNull();
    expect(revealSecret(opened!.secret)).toBe(RAW_KEY);
    expect(opened!.needsRewrite).toBe(true);
  });

  it("ré-écrit sous la clé courante, et la ré-écriture n'a plus besoin de l'ancienne", () => {
    const blob = sealForRow(RAW_KEY, binding);
    vi.stubEnv("AI_KEY_ENC_KEY", KEK_B);
    vi.stubEnv("AI_KEY_ENC_KEY_PREVIOUS", KEK_A);

    const rewritten = rewriteUnderCurrentKek(blob, binding);
    expect(rewritten).not.toBeNull();

    // Fin de rotation : la variable PREVIOUS est retirée.
    vi.stubEnv("AI_KEY_ENC_KEY_PREVIOUS", "");
    const opened = openSecret(rewritten!, binding);
    expect(revealSecret(opened!.secret)).toBe(RAW_KEY);
    expect(opened!.needsRewrite).toBe(false);
  });

  it("RISK-10 : KEK remplacée SANS rotation ⇒ la ligne est illisible, pas corrompue", () => {
    const blob = sealForRow(RAW_KEY, binding);
    vi.stubEnv("AI_KEY_ENC_KEY", KEK_B);
    vi.stubEnv("AI_KEY_ENC_KEY_PREVIOUS", "");
    // L'appelant en fait `status='invalid'` : aucune donnée d'apprentissage
    // n'est perdue, seule la clé devient illisible.
    expect(openSecret(blob, binding)).toBeNull();
  });
});

describe("empreinte et affichage", () => {
  it("l'empreinte est stable sous une même KEK, et ne contient pas la clé", () => {
    const a = fingerprint(RAW_KEY);
    expect(fingerprint(RAW_KEY)).toBe(a);
    expect(a).toHaveLength(32);
    expect(a).toMatch(/^[0-9a-f]{32}$/);
    expect(a).not.toContain("4f2a");
  });

  it("deux clés différentes ont deux empreintes différentes", () => {
    expect(fingerprint(RAW_KEY)).not.toBe(fingerprint(`${RAW_KEY}x`));
  });

  it("l'empreinte n'est PAS la clé de chiffrement — deux `info` HKDF distincts", () => {
    // Si les deux usages partageaient une sous-clé, l'empreinte serait un oracle
    // sur le matériel de chiffrement. Preuve indirecte : le chiffré d'une clé et
    // son empreinte ne se recoupent nulle part.
    const blob = sealForRow(RAW_KEY, binding);
    expect(blob.toString("hex")).not.toContain(fingerprint(RAW_KEY));
  });

  it("l'affichage est `…` + 4 caractères, et rien d'autre (R-4)", () => {
    expect(last4(RAW_KEY)).toBe("4f2a");
    // Une clé absurdement courte ne doit pas révéler la totalité d'elle-même.
    expect(last4("ab")).toBe("••ab");
  });
});

describe("D-3 — aucun chemin de code ne rend le clair", () => {
  it("le module n'expose aucune fonction dont le retour est une chaîne en clair", () => {
    // « Un test le vérifie par lecture du module, pas par confiance » (§3.2).
    // Les seules signatures publiques rendant une `string` sont l'empreinte et
    // les 4 derniers caractères — ni l'une ni l'autre ne reconstitue la clé.
    const source = readFileSync(join(process.cwd(), "src/features/ai/crypto.server.ts"), "utf8");
    const exported = [
      ...source.matchAll(/^export function (\w+)\([^)]*\)(?::\s*([^{]+))?\{/gms),
    ].map((m) => [m[1], (m[2] ?? "").trim()] as const);
    const stringReturners = exported.filter(([, ret]) => ret.startsWith("string"));
    expect(stringReturners.map(([name]) => name).sort()).toEqual(["fingerprint", "last4"]);
  });

  it("le secret ouvert est OPAQUE — il ne s'imprime pas", () => {
    const opened = openSecret(sealForRow(RAW_KEY, binding), binding)!;
    expect(String(opened.secret)).toBe("[secret]");
    expect(JSON.stringify({ s: opened.secret })).not.toContain("sk-ant");
  });
});
