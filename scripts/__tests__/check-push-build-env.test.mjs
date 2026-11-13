// @vitest-environment node
import { describe, expect, it, vi } from "vitest";

import {
  checkPushBuildEnv,
  enforcePushBuildEnv,
  servesPublicDomain,
} from "../check-push-build-env.mjs";

// Forme d'une vraie clé publique VAPID (87 caractères base64url, commence par B) — factice.
const KEY = `B${"A".repeat(86)}`;
const WWW = { VERCEL_ENV: "production", VERCEL_PROJECT_PRODUCTION_URL: "www.na9ranal3ab.tn" };
const OTHER = {
  VERCEL_ENV: "production",
  VERCEL_PROJECT_PRODUCTION_URL: "yahia-quest-arena.vercel.app",
};

describe("checkPushBuildEnv — la garde du build Vercel", () => {
  it("échoue quand le build de production qui sert www n'a pas la clé publique", () => {
    expect(checkPushBuildEnv({ ...WWW }).level).toBe("fail");
    expect(checkPushBuildEnv({ ...WWW, VITE_VAPID_PUBLIC_KEY: "   " }).level).toBe("fail");
  });

  it("échoue aussi sur une valeur qui n'a pas la forme d'une clé VAPID", () => {
    expect(checkPushBuildEnv({ ...WWW, VITE_VAPID_PUBLIC_KEY: '"' + KEY + '"' }).level).toBe(
      "fail",
    );
  });

  it("passe quand la clé est là", () => {
    expect(checkPushBuildEnv({ ...WWW, VITE_VAPID_PUBLIC_KEY: KEY }).level).toBe("ok");
  });

  it("n'avertit que sur le projet Vercel secondaire : il ne rougit pas chaque commit de main", () => {
    expect(checkPushBuildEnv({ ...OTHER }).level).toBe("warn");
    expect(checkPushBuildEnv({ VERCEL_ENV: "production" }).level).toBe("warn");
  });

  it("ne s'applique ni aux aperçus, ni au build local ou CI", () => {
    expect(
      checkPushBuildEnv({
        VERCEL_ENV: "preview",
        VERCEL_PROJECT_PRODUCTION_URL: "www.na9ranal3ab.tn",
      }).level,
    ).toBe("ok");
    expect(checkPushBuildEnv({}).level).toBe("ok");
  });

  it("n'imprime jamais la valeur de la clé", () => {
    const malformed = "Bsecret-looking-value";
    for (const env of [
      { ...WWW, VITE_VAPID_PUBLIC_KEY: malformed },
      { ...OTHER, VITE_VAPID_PUBLIC_KEY: malformed },
      { ...WWW, VITE_VAPID_PUBLIC_KEY: KEY },
    ]) {
      const { message } = checkPushBuildEnv(env);
      expect(message).not.toContain(malformed);
      expect(message).not.toContain(KEY);
    }
  });
});

describe("servesPublicDomain", () => {
  it("reconnaît le domaine public, avec ou sans schéma, apex ou sous-domaine", () => {
    expect(servesPublicDomain({ VERCEL_PROJECT_PRODUCTION_URL: "na9ranal3ab.tn" })).toBe(true);
    expect(
      servesPublicDomain({ VERCEL_PROJECT_PRODUCTION_URL: "https://www.na9ranal3ab.tn" }),
    ).toBe(true);
  });

  it("ne se laisse pas tromper par un domaine qui ne fait que le contenir", () => {
    expect(servesPublicDomain({ VERCEL_PROJECT_PRODUCTION_URL: "na9ranal3ab.tn.evil.app" })).toBe(
      false,
    );
    expect(servesPublicDomain({ VERCEL_PROJECT_PRODUCTION_URL: "fakena9ranal3ab.tn" })).toBe(false);
    expect(servesPublicDomain({})).toBe(false);
  });
});

describe("enforcePushBuildEnv", () => {
  const log = () => ({ log: vi.fn(), warn: vi.fn(), error: vi.fn() });

  it("lève — donc fait échouer build-vercel.mjs — sur le verdict fail", () => {
    const l = log();
    expect(() => enforcePushBuildEnv({ ...WWW }, l)).toThrow(/Garde Web Push/);
    expect(l.error).toHaveBeenCalledOnce();
  });

  it("avertit sans lever sur le projet secondaire", () => {
    const l = log();
    expect(() => enforcePushBuildEnv({ ...OTHER }, l)).not.toThrow();
    expect(l.warn).toHaveBeenCalledOnce();
  });

  it("se tait presque quand tout va bien", () => {
    const l = log();
    enforcePushBuildEnv({ ...WWW, VITE_VAPID_PUBLIC_KEY: KEY }, l);
    expect(l.error).not.toHaveBeenCalled();
    expect(l.warn).not.toHaveBeenCalled();
  });
});
