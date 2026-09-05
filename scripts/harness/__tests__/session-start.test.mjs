// @vitest-environment node
import { describe, expect, it } from "vitest";
import { spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

import {
  NVM_SCRIPT,
  PROBE_TIMEOUT_S,
  buildReport,
  classifyProbe,
  exportNodeProxy,
  isCloud,
  majorOf,
  needsInstall,
  parseWantedMajor,
} from "../../../.claude/hooks/session-start.mjs";
import {
  ALLOWED_DOMAINS,
  CNP_HOST,
  PROD_APP_HOST,
  TEST_SUPABASE_REF,
  renderAllowlist,
} from "../../cloud/allowed-domains.mjs";
import { TEST_REF } from "../../db/push-prod.mjs";
import { PROD_APP_HOSTS, PROD_SUPABASE_REF } from "../../shared/prod-targets.mjs";
import { CNP_MANUEL_BASE_URL } from "../../../src/shared/content/manuel-cnp.ts";

const HOOK = join(import.meta.dirname, "..", "..", "..", ".claude", "hooks", "session-start.mjs");

describe("isCloud", () => {
  it("ne reconnaît que la variable de la VM cloud, jamais un poste", () => {
    expect(isCloud({ CLAUDE_CODE_REMOTE: "true" })).toBe(true);
    expect(isCloud({ CLAUDE_CODE_REMOTE: "1" })).toBe(false);
    expect(isCloud({})).toBe(false);
  });
});

describe("parseWantedMajor / majorOf", () => {
  it("lit la majeure de .nvmrc sous ses formes usuelles", () => {
    expect(parseWantedMajor("24\n")).toBe(24);
    expect(parseWantedMajor("v20.11.1")).toBe(20);
    expect(parseWantedMajor("lts/*")).toBeNull();
    expect(parseWantedMajor(null)).toBeNull();
  });

  it("extrait la majeure d'un process.version", () => {
    expect(majorOf("v24.20.0")).toBe(24);
    expect(majorOf("22.22.2")).toBe(22);
  });
});

describe("needsInstall", () => {
  it("installe sans node_modules ou sans trace d'installation", () => {
    expect(
      needsInstall({ hasNodeModules: false, lockMtimeMs: 10, installedLockMtimeMs: null }),
    ).toBe(true);
    expect(
      needsInstall({ hasNodeModules: true, lockMtimeMs: 10, installedLockMtimeMs: null }),
    ).toBe(true);
  });

  it("réinstalle quand le lockfile du dépôt est plus récent que l'installation", () => {
    expect(needsInstall({ hasNodeModules: true, lockMtimeMs: 20, installedLockMtimeMs: 10 })).toBe(
      true,
    );
    expect(needsInstall({ hasNodeModules: true, lockMtimeMs: 10, installedLockMtimeMs: 20 })).toBe(
      false,
    );
  });

  it("ne réinstalle pas quand le lockfile manque mais qu'une installation existe", () => {
    expect(
      needsInstall({ hasNodeModules: true, lockMtimeMs: null, installedLockMtimeMs: 10 }),
    ).toBe(false);
  });
});

describe("classifyProbe", () => {
  it("un code HTTP — même 401 ou 403 du site — prouve que l'hôte est joignable", () => {
    expect(classifyProbe({ exitCode: 0, httpCode: "200" })).toMatchObject({ state: "ok" });
    expect(classifyProbe({ exitCode: 0, httpCode: "401\n" }).label).toContain("401");
    expect(classifyProbe({ exitCode: 0, httpCode: "403" })).toMatchObject({ state: "ok" });
  });

  it("le CONNECT 403 du proxy d'environnement est une politique réseau, pas une panne", () => {
    const v = classifyProbe({
      exitCode: 56,
      httpCode: "000",
      stderr: "curl: (56) CONNECT tunnel failed, response 403",
    });
    expect(v.state).toBe("blocked");
    expect(v.label).toMatch(/politique réseau/);
  });

  it("distingue le délai et l'absence de curl d'une erreur quelconque", () => {
    expect(classifyProbe({ exitCode: 28, httpCode: "000" })).toMatchObject({ state: "timeout" });
    expect(classifyProbe({ exitCode: 28 }).label).toContain(String(PROBE_TIMEOUT_S));
    expect(classifyProbe({ exitCode: -1, stderr: "spawn curl ENOENT" })).toMatchObject({
      state: "error",
      label: "curl indisponible",
    });
    expect(
      classifyProbe({ exitCode: 6, stderr: "curl: (6) Could not resolve host" }).label,
    ).toMatch(/erreur curl 6 \(curl: \(6\)/);
  });
});

describe("buildReport", () => {
  const base = {
    node: { ok: true, version: "v24.20.0", how: "nvm, 6 s" },
    deps: { ok: true, ran: true, packages: 523, seconds: 22 },
    pgtap: false,
    durationMs: 31_000,
  };

  it("dit ce que chaque refus interdit, et nomme le lot 0 quand tout est refusé", () => {
    const probes = ALLOWED_DOMAINS.map((d) => ({
      ...d,
      state: "blocked",
      label: "REFUSÉ par la politique réseau de l'environnement",
    }));
    const report = buildReport({ ...base, probes });
    expect(report).toContain("Node v24.20.0 (nvm, 6 s)");
    expect(report).toContain("523 paquets installés (22 s)");
    expect(report).toContain("pgTAP : absent");
    for (const d of ALLOWED_DOMAINS) {
      expect(report).toContain(d.host);
      expect(report).toContain(d.ifBlocked);
    }
    expect(report).toMatch(/lot 0 de l'étude cloud-first .* n'est pas appliqué/);
    expect(report.trimEnd().split("\n")).toHaveLength(2);
  });

  it("reste court quand tout est joignable et que rien n'a été installé", () => {
    const probes = ALLOWED_DOMAINS.map((d) => ({
      ...d,
      state: "ok",
      label: "joignable (HTTP 200)",
    }));
    const report = buildReport({ ...base, deps: { ok: true, ran: false }, pgtap: true, probes });
    expect(report).toContain("dépendances : déjà en place");
    expect(report).toContain("pgTAP : présent");
    expect(report).toContain(`les ${ALLOWED_DOMAINS.length} domaines du lot 0 sont joignables`);
    expect(report).not.toContain("n'est pas appliqué");
  });

  it("rapporte un amorçage en échec au lieu de le taire", () => {
    const report = buildReport({
      ...base,
      node: { ok: false, error: "nvm : introuvable" },
      deps: { ok: false, error: "npm install : ETIMEDOUT" },
      probes: [],
    });
    expect(report).toContain("Node : nvm : introuvable");
    expect(report).toContain("dépendances : npm install : ETIMEDOUT");
  });
});

describe("NVM_SCRIPT — poser Node malgré le code de retour de nvm.sh", () => {
  it("survit à un `source nvm.sh` qui rend 3 (alias par défaut absent) et rend le chemin de node", () => {
    const dir = mkdtempSync(join(tmpdir(), "nvm-fake-"));
    try {
      // Un faux nvm.sh : définit `nvm`, puis se termine comme le vrai sur une VM neuve — en échec.
      writeFileSync(
        join(dir, "nvm.sh"),
        [
          "nvm() {",
          '  case "$1" in',
          "    install) return 0 ;;",
          "    alias) return 0 ;;",
          '    which) echo "/fake/versions/node/v$2.0.0/bin/node" ;;',
          "  esac",
          "}",
          "return 3",
          "",
        ].join("\n"),
      );
      const run = spawnSync("bash", ["-c", NVM_SCRIPT, join(dir, "nvm.sh"), "24"], {
        encoding: "utf8",
      });
      expect(run.status).toBe(0);
      expect(run.stdout.trim().split("\n").at(-1)).toBe("/fake/versions/node/v24.0.0/bin/node");
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("échoue quand nvm ne connaît pas la version — l'amorçage le dira au lieu de le taire", () => {
    const dir = mkdtempSync(join(tmpdir(), "nvm-fake-"));
    try {
      writeFileSync(join(dir, "nvm.sh"), "nvm() { return 1; }\nreturn 3\n");
      const run = spawnSync("bash", ["-c", NVM_SCRIPT, join(dir, "nvm.sh"), "24"], {
        encoding: "utf8",
      });
      expect(run.status).not.toBe(0);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("exportNodeProxy — le fetch de Node emprunte le proxy de la session", () => {
  it("écrit l'export dans le fichier d'environnement quand la session a un proxy", () => {
    const dir = mkdtempSync(join(tmpdir(), "env-file-"));
    try {
      const file = join(dir, "env");
      writeFileSync(file, "");
      expect(exportNodeProxy({ HTTPS_PROXY: "http://127.0.0.1:1", CLAUDE_ENV_FILE: file })).toBe(
        true,
      );
      expect(readFileSync(file, "utf8")).toBe("export NODE_USE_ENV_PROXY=1\n");
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("ne fait rien sans proxy, sans fichier d'environnement, ou quand c'est déjà réglé", () => {
    expect(exportNodeProxy({ CLAUDE_ENV_FILE: "/nonexistent/env" })).toBe(false);
    expect(exportNodeProxy({ HTTPS_PROXY: "http://127.0.0.1:1" })).toBe(false);
    expect(
      exportNodeProxy({
        HTTPS_PROXY: "http://127.0.0.1:1",
        CLAUDE_ENV_FILE: "/nonexistent/env",
        NODE_USE_ENV_PROXY: "1",
      }),
    ).toBe(false);
  });
});

describe("le hook, hors cloud", () => {
  it("ne fait rien et ne dit rien — exit 0, stdout vide", () => {
    const env = { ...process.env };
    delete env.CLAUDE_CODE_REMOTE;
    const run = spawnSync(process.execPath, [HOOK], { env, input: "{}", encoding: "utf8" });
    expect(run.status).toBe(0);
    expect(run.stdout).toBe("");
  });
});

describe("allowed-domains — la liste du lot 0 reste alignée sur les constantes partagées", () => {
  it("porte quatre hôtes, chacun avec sa raison et sa conséquence", () => {
    expect(ALLOWED_DOMAINS).toHaveLength(4);
    for (const d of ALLOWED_DOMAINS) {
      expect(d.probe.startsWith(`https://${d.host}/`)).toBe(true);
      expect(d.why.length).toBeGreaterThan(10);
      expect(d.ifBlocked.length).toBeGreaterThan(10);
    }
  });

  it("l'hôte du CNP est celui de CNP_MANUEL_BASE_URL", () => {
    expect(new URL(CNP_MANUEL_BASE_URL).host).toBe(CNP_HOST);
  });

  it("les refs Supabase sont ceux des scripts qui les font foi", () => {
    expect(TEST_SUPABASE_REF).toBe(TEST_REF);
    expect(ALLOWED_DOMAINS.map((d) => d.host)).toContain(`${PROD_SUPABASE_REF}.supabase.co`);
  });

  it("l'hôte de l'app est l'hôte canonique de la prod", () => {
    expect(PROD_APP_HOSTS).toContain(PROD_APP_HOST);
    expect(PROD_APP_HOST.startsWith("www.")).toBe(true);
  });

  it("s'imprime un hôte par ligne, prêt à coller dans claude.ai", () => {
    expect(renderAllowlist()).toBe(`${ALLOWED_DOMAINS.map((d) => d.host).join("\n")}\n`);
  });
});
