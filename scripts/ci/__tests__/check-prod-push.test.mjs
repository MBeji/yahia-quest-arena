// @vitest-environment node
import { describe, expect, it } from "vitest";

import { SITE_URL } from "@/shared/constants/site";

import { DEFAULT_SITE_URL, pushVerdict } from "../check-prod-push.mjs";

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

  it.each([null, "texte", 42, []])("échoue sur une réponse illisible (%s)", (body) => {
    expect(pushVerdict(body).ok).toBe(false);
  });
});
