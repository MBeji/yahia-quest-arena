// La chaîne de certificats posée par le hook de session (étude cloud-first, lot 0 constaté le
// 2026-09-06) : le bundle combiné, ses exports, et le contenu vendu dans ca-chain/.
import { describe, expect, it } from "vitest";
import { spawnSync } from "node:child_process";
import { mkdirSync, mkdtempSync, readFileSync, rmSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { basename, join } from "node:path";

import {
  CA_CHAIN_DIR,
  CA_ENV_VARS,
  baseCaBundle,
  buildCaBundle,
  caEnvExports,
  defaultBundleFile,
  listIntermediates,
  pemLabel,
} from "../ca-bundle.mjs";

const FAKE_ROOT = "-----BEGIN CERTIFICATE-----\nROOT\n-----END CERTIFICATE-----\n";
const FAKE_INTER = "-----BEGIN CERTIFICATE-----\nINTER\n-----END CERTIFICATE-----";

function scratch() {
  const dir = mkdtempSync(join(tmpdir(), "ca-bundle-"));
  const base = join(dir, "base.crt");
  writeFileSync(base, FAKE_ROOT);
  const chain = join(dir, "chain");
  mkdirSync(chain);
  return { dir, base, chain };
}

const hasOpenssl = spawnSync("openssl", ["version"], { encoding: "utf8" }).status === 0;

describe("baseCaBundle", () => {
  it("préfère le magasin que l'environnement impose à curl, puis SSL_CERT_FILE, puis le système", () => {
    const { dir, base } = scratch();
    try {
      const other = join(dir, "ssl.crt");
      writeFileSync(other, FAKE_ROOT);
      expect(baseCaBundle({ CURL_CA_BUNDLE: base, SSL_CERT_FILE: other })).toBe(base);
      expect(baseCaBundle({ CURL_CA_BUNDLE: join(dir, "absent"), SSL_CERT_FILE: other })).toBe(
        other,
      );
      const fallback = baseCaBundle({});
      expect(fallback === null || fallback.startsWith("/etc/")).toBe(true);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("listIntermediates / pemLabel", () => {
  it("ne prend que les .pem, triés, et rend un nom lisible", () => {
    const { dir, chain } = scratch();
    try {
      writeFileSync(join(chain, "b-inter.pem"), FAKE_INTER);
      writeFileSync(join(chain, "a-inter.pem"), FAKE_INTER);
      writeFileSync(join(chain, "README.md"), "# pas un certificat");
      expect(listIntermediates(chain).map((f) => basename(f))).toEqual([
        "a-inter.pem",
        "b-inter.pem",
      ]);
      expect(listIntermediates(join(dir, "nulle-part"))).toEqual([]);
      expect(pemLabel("/x/sectigo-public-server-authentication-ca-dv-r36.pem")).toBe(
        "sectigo-public-server-authentication-ca-dv-r36",
      );
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("buildCaBundle", () => {
  it("écrit magasin de base + intermédiaires dans un dossier privé, et dit ce qu'il a posé", () => {
    const { dir, base, chain } = scratch();
    try {
      writeFileSync(join(chain, "inter.pem"), FAKE_INTER);
      const out = join(dir, "cache", "ca-bundle.pem");
      const built = buildCaBundle({ env: { CURL_CA_BUNDLE: base }, dir: chain, outFile: out });
      expect(built).toEqual({ file: out, base, intermediates: [join(chain, "inter.pem")] });
      expect(readFileSync(out, "utf8")).toBe(FAKE_ROOT + FAKE_INTER + "\n");
      expect(statSync(join(dir, "cache")).mode & 0o777).toBe(0o700);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("ne pose rien sans intermédiaire, ni sans magasin de base en fichier (Windows : schannel)", () => {
    const { dir, base, chain } = scratch();
    try {
      const out = join(dir, "ca-bundle.pem");
      expect(buildCaBundle({ env: { CURL_CA_BUNDLE: base }, dir: chain, outFile: out })).toBeNull();
      writeFileSync(join(chain, "inter.pem"), FAKE_INTER);
      expect(
        buildCaBundle({
          env: { CURL_CA_BUNDLE: join(dir, "absent"), SSL_CERT_FILE: join(dir, "absent2") },
          dir: chain,
          outFile: out,
        }),
      ).toEqual(baseCaBundle({}) === null ? null : expect.objectContaining({ file: out }));
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("le bundle par défaut vit sous le HOME de l'utilisateur, jamais dans le dépôt ni /tmp", () => {
    expect(defaultBundleFile("/home/mohamed")).toBe("/home/mohamed/.cache/yqa-ca/ca-bundle.pem");
    expect(defaultBundleFile()).not.toContain(tmpdir());
  });
});

describe("caEnvExports", () => {
  it("exporte les trois variables que curl, OpenSSL et Node lisent", () => {
    const lines = caEnvExports("/root/.cache/yqa-ca/ca-bundle.pem").trimEnd().split("\n");
    expect(lines).toEqual(
      CA_ENV_VARS.map((name) => `export ${name}="/root/.cache/yqa-ca/ca-bundle.pem"`),
    );
    expect(CA_ENV_VARS).toEqual(["CURL_CA_BUNDLE", "SSL_CERT_FILE", "NODE_EXTRA_CA_CERTS"]);
  });
});

describe("ca-chain/ — ce qui est vendu", () => {
  const files = listIntermediates(CA_CHAIN_DIR);

  it("chaque fichier est UN certificat public — jamais une clé, jamais deux blocs", () => {
    expect(files.length).toBeGreaterThan(0);
    for (const f of files) {
      const text = readFileSync(f, "utf8");
      expect(text).not.toMatch(/PRIVATE KEY/);
      expect(text.match(/-----BEGIN CERTIFICATE-----/g)).toHaveLength(1);
      expect(text.trimEnd().endsWith("-----END CERTIFICATE-----")).toBe(true);
      expect(text).not.toMatch(/\r/);
    }
  });

  it.skipIf(!hasOpenssl)(
    "l'intermédiaire Sectigo porte le sujet et l'empreinte du README, et se vérifie contre le magasin",
    () => {
      const file = join(CA_CHAIN_DIR, "sectigo-public-server-authentication-ca-dv-r36.pem");
      const x509 = spawnSync(
        "openssl",
        ["x509", "-noout", "-subject", "-issuer", "-fingerprint", "-sha256", "-in", file],
        { encoding: "utf8" },
      );
      expect(x509.status).toBe(0);
      expect(x509.stdout).toContain("CN = Sectigo Public Server Authentication CA DV R36");
      expect(x509.stdout).toContain("CN = Sectigo Public Server Authentication Root R46");
      expect(x509.stdout).toContain(
        "8C:54:C3:34:B6:6B:A4:E4:26:77:2A:F4:A3:F9:13:6C:19:A1:AE:C7:29:FD:B2:8C:53:5C:07:A5:A4:EF:22:E0",
      );
      const base = baseCaBundle(process.env);
      if (base) {
        const verify = spawnSync("openssl", ["verify", "-CAfile", base, file], {
          encoding: "utf8",
        });
        expect(verify.stdout.trim()).toBe(`${file}: OK`);
      }
    },
  );
});
