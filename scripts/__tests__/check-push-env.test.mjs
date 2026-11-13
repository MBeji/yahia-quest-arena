// @vitest-environment node
import { describe, expect, it } from "vitest";

import { SITE_URL } from "@/shared/constants/site";

import {
  CANONICAL_HOST,
  PUSH_BUILD_ENV_KEYS,
  assertPushBuildEnv,
  checkPushBuildEnv,
} from "../check-push-env.mjs";

const PROD_WWW = { VERCEL_ENV: "production", VERCEL_PROJECT_PRODUCTION_URL: "www.na9ranal3ab.tn" };
const KEYS = {
  VITE_VAPID_PUBLIC_KEY: "BPub",
  VAPID_PUBLIC_KEY: "BPub",
  VAPID_PRIVATE_KEY: "priv",
  VAPID_SUBJECT: "mailto:contact@example.org",
  CRON_SECRET: "s3cret",
};

describe("garde de build du push — étude 40, lot 1", () => {
  it("vise l'hôte de SITE_URL, et lui seul", () => {
    expect(new URL(SITE_URL).host).toBe(CANONICAL_HOST);
  });

  it("laisse passer la production de www quand les cinq variables sont posées", () => {
    expect(checkPushBuildEnv({ ...PROD_WWW, ...KEYS })).toEqual({
      applies: true,
      ok: true,
      problems: [],
    });
    expect(() => assertPushBuildEnv({ ...PROD_WWW, ...KEYS })).not.toThrow();
  });

  it.each(PUSH_BUILD_ENV_KEYS)("refuse la production de www quand %s manque", (key) => {
    const env = { ...PROD_WWW, ...KEYS };
    delete env[key];
    const verdict = checkPushBuildEnv(env);
    expect(verdict.ok).toBe(false);
    expect(verdict.problems).toContain(`${key} absente`);
    expect(() => assertPushBuildEnv(env)).toThrow(/Garde du push/);
  });

  it("tient une valeur faite d'espaces pour absente", () => {
    expect(checkPushBuildEnv({ ...PROD_WWW, ...KEYS, CRON_SECRET: "  " }).ok).toBe(false);
  });

  it("refuse une clé publique du client différente de celle du serveur", () => {
    const verdict = checkPushBuildEnv({ ...PROD_WWW, ...KEYS, VITE_VAPID_PUBLIC_KEY: "BAutre" });
    expect(verdict.problems).toEqual(["VITE_VAPID_PUBLIC_KEY diffère de VAPID_PUBLIC_KEY"]);
  });

  it("reconnaît le projet quand Vercel le désigne par l'apex, son domaine le plus court", () => {
    const env = {
      ...KEYS,
      VERCEL_ENV: "production",
      VERCEL_PROJECT_PRODUCTION_URL: "na9ranal3ab.tn",
    };
    expect(checkPushBuildEnv(env).applies).toBe(true);
    const bare = { VERCEL_ENV: "production", VERCEL_PROJECT_PRODUCTION_URL: "na9ranal3ab.tn" };
    expect(checkPushBuildEnv(bare).ok).toBe(false);
  });

  it("accepte l'URL de production écrite avec son schéma", () => {
    const env = {
      ...KEYS,
      VERCEL_ENV: "production",
      VERCEL_PROJECT_PRODUCTION_URL: "https://www.na9ranal3ab.tn",
    };
    expect(checkPushBuildEnv(env).applies).toBe(true);
  });

  it.each([
    ["un build local ou de CI", {}],
    [
      "une prévisualisation",
      { VERCEL_ENV: "preview", VERCEL_PROJECT_PRODUCTION_URL: "www.na9ranal3ab.tn" },
    ],
    [
      "la production d'un autre projet Vercel du même dépôt",
      { VERCEL_ENV: "production", VERCEL_PROJECT_PRODUCTION_URL: "yahia-quest-arena.vercel.app" },
    ],
  ])("ne s'applique pas à %s, même sans aucune clé", (_label, env) => {
    expect(checkPushBuildEnv(env)).toEqual({ applies: false, ok: true, problems: [] });
    expect(() => assertPushBuildEnv(env)).not.toThrow();
  });

  it("n'écrit jamais une valeur dans son message d'erreur", () => {
    const env = { ...PROD_WWW, ...KEYS, VITE_VAPID_PUBLIC_KEY: "BClientSecretish" };
    delete env.CRON_SECRET;
    let message = "";
    try {
      assertPushBuildEnv(env);
    } catch (error) {
      message = String(error);
    }
    expect(message).toContain("CRON_SECRET absente");
    expect(message).not.toMatch(/BClientSecretish|BPub|priv|s3cret|mailto/);
  });
});
