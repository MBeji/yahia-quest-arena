// @vitest-environment node
import { describe, expect, it, vi } from "vitest";

import { SITE_URL } from "@/shared/constants/site";

import {
  ATTEMPTS,
  DEFAULT_SITE_URL,
  RETRY_DELAY_MS,
  pushVerdict,
  readHealth,
} from "../check-prod-push.mjs";

describe("veille nocturne du push — étude 40, lot 1", () => {
  it("vise le site canonique", () => {
    expect(DEFAULT_SITE_URL).toBe(SITE_URL);
  });

  it("passe quand la production dit le push armé", () => {
    expect(pushVerdict({ status: "ok", push: "configured", commit: "abc1234" })).toEqual({
      ok: true,
      message: "push armé en production (déploiement abc1234)",
    });
  });

  it("échoue quand la production dit le push éteint, et dit où regarder", () => {
    const verdict = pushVerdict({ status: "ok", push: "unconfigured", commit: "abc1234" });
    expect(verdict.ok).toBe(false);
    expect(verdict.message).toMatch(/ÉTEINT/);
    expect(verdict.message).toContain("environment-variables.md");
  });

  it("échoue quand le champ manque — un vieux déploiement ne passe pas pour armé", () => {
    expect(pushVerdict({ status: "ok", commit: "abc1234" }).ok).toBe(false);
  });

  describe("trois essais espacés de 15 s", () => {
    const ok = { json: async () => ({ push: "configured" }) };

    it("une coupure d'un instant ne compte pas : le deuxième essai lit la réponse", async () => {
      const sleep = vi.fn(async () => {});
      const fetchImpl = vi
        .fn()
        .mockRejectedValueOnce(new Error("ECONNRESET"))
        .mockResolvedValueOnce(ok);
      await expect(readHealth(DEFAULT_SITE_URL, { fetchImpl, sleep })).resolves.toEqual({
        push: "configured",
      });
      expect(fetchImpl).toHaveBeenCalledTimes(2);
      expect(sleep).toHaveBeenCalledWith(RETRY_DELAY_MS);
    });

    it("trois échecs ⇒ l'erreur remonte, après deux attentes", async () => {
      const sleep = vi.fn(async () => {});
      const fetchImpl = vi.fn().mockRejectedValue(new Error("timeout"));
      await expect(readHealth(DEFAULT_SITE_URL, { fetchImpl, sleep })).rejects.toThrow("timeout");
      expect(fetchImpl).toHaveBeenCalledTimes(ATTEMPTS);
      expect(sleep).toHaveBeenCalledTimes(ATTEMPTS - 1);
    });

    it("une réponse lue n'est pas réessayée, même `unconfigured` : c'est un fait", async () => {
      const fetchImpl = vi.fn().mockResolvedValue({ json: async () => ({ push: "unconfigured" }) });
      await readHealth(DEFAULT_SITE_URL, { fetchImpl, sleep: async () => {} });
      expect(fetchImpl).toHaveBeenCalledTimes(1);
    });
  });

  it.each([null, "texte", 42, []])("échoue sur une réponse illisible (%s)", (body) => {
    expect(pushVerdict(body).ok).toBe(false);
  });
});
