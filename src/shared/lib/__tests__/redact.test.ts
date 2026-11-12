// @vitest-environment node
import { describe, expect, it } from "vitest";
import { REDACTED, isSensitiveKey, redactDeep, redactSecrets } from "@/shared/lib/redact";

const JWT =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U";

describe("redactSecrets — la FORME d'un secret dans un texte", () => {
  it.each([
    ["un JWT Supabase", `jwt expired: ${JWT}`, JWT],
    [
      "un en-tête Bearer",
      "upstream said: Authorization: Bearer abcdef0123456789",
      "abcdef0123456789",
    ],
    [
      "une clé OpenAI",
      "Incorrect API key provided: sk-proj-AbCdEf0123456789AbCdEf",
      "sk-proj-AbCdEf",
    ],
    ["une clé Anthropic", "bad key sk-ant-api03-AbCdEf0123456789AbCdEf", "sk-ant-api03"],
    ["une clé Gemini", "API key AIzaSyA0123456789abcdefghijklmnopqrstuv not valid", "AIzaSyA0123"],
    ["une clé Groq", "invalid gsk_AbCdEf0123456789AbCdEf", "gsk_AbCdEf"],
    ["une clé service Supabase", "key sb_secret_AbCdEf0123456789 rejected", "sb_secret_AbCdEf"],
    ["un PAT GitHub", "token github_pat_11ABCDEFG0123456789_abcdef", "github_pat_11"],
  ])("masque %s", (_label, input, leaked) => {
    const out = redactSecrets(input);
    expect(out).not.toContain(leaked);
    expect(out).toContain(REDACTED);
  });

  it("laisse intact un texte ordinaire, un uuid, un identifiant d'exercice", () => {
    const text =
      "quest.getExerciseMeta: lookup failed for 0027dc3e-b5b6-5199-a3f4-047601737cc1 (sk-1 court, risk-free)";
    expect(redactSecrets(text)).toBe(text);
  });
});

describe("redactDeep — clés sensibles et valeurs, à toute profondeur", () => {
  it("masque une clé sensible IMBRIQUÉE (le trou d'avant : seul le premier niveau l'était)", () => {
    const out = redactDeep({
      request: { headers: { Authorization: `Bearer ${JWT}`, accept: "text/html" } },
      items: [{ apiKey: "sk-live", label: "ok" }],
    }) as {
      request: { headers: Record<string, string> };
      items: Array<Record<string, string>>;
    };
    expect(out.request.headers.Authorization).toBe(REDACTED);
    expect(out.request.headers.accept).toBe("text/html");
    expect(out.items[0].apiKey).toBe(REDACTED);
    expect(out.items[0].label).toBe("ok");
  });

  it("masque un secret porté par une valeur sous une clé anodine", () => {
    const out = redactDeep({ error: `Incorrect API key provided: sk-proj-AbCdEf0123456789AbCdEf` });
    expect(JSON.stringify(out)).not.toContain("sk-proj-AbCdEf");
  });

  it("réduit une Error à son nom et son message caviardé (au lieu de {})", () => {
    const out = redactDeep({ cause: new TypeError(`fetch failed with ${JWT}`) }) as {
      cause: { name: string; message: string };
    };
    expect(out.cause.name).toBe("TypeError");
    expect(out.cause.message).toBe(`fetch failed with ${REDACTED}`);
  });

  it("ne boucle pas sur un objet cyclique", () => {
    const loop: Record<string, unknown> = { name: "a" };
    loop.self = loop;
    expect(() => JSON.stringify(redactDeep(loop))).not.toThrow();
  });

  it("laisse passer nombres, booléens, null", () => {
    expect(redactDeep({ status: 200, ok: true, none: null })).toEqual({
      status: 200,
      ok: true,
      none: null,
    });
  });
});

describe("isSensitiveKey", () => {
  it("reconnaît les noms qui annoncent un secret, sans tenir compte de la casse", () => {
    for (const key of ["accessToken", "SECRET_KEY", "password", "Authorization", "set-cookie"]) {
      expect(isSensitiveKey(key)).toBe(true);
    }
    expect(isSensitiveKey("path")).toBe(false);
  });
});
