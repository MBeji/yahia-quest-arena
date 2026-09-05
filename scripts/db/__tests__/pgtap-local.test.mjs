// @vitest-environment node
import { describe, expect, it } from "vitest";
import { readFileSync, statSync } from "node:fs";
import { join } from "node:path";

const ROOT = join(import.meta.dirname, "..", "..", "..");
const SCRIPT = join(ROOT, "scripts", "db", "local", "pgtap.sh");

describe("scripts/db/local/pgtap.sh — la suite pgTAP en une commande (étude cloud-first, lot 4)", () => {
  const text = readFileSync(SCRIPT, "utf8");

  it("est un script bash exécutable qui rejoue le shim, la chaîne et pg_prove", () => {
    expect(text.startsWith("#!/usr/bin/env bash")).toBe(true);
    expect(statSync(SCRIPT).mode & 0o111).not.toBe(0);
    for (const needle of [
      "supabase-shim.sql",
      "supabase/migrations/*.sql",
      "pg_prove",
      "initdb",
      "fsync=off",
    ]) {
      expect(text).toContain(needle);
    }
  });

  it("sait tourner en root (la VM cloud) : le cluster appartient à postgres, pgTAP s'installe à la demande", () => {
    expect(text).toContain("su postgres");
    expect(text).toContain("postgresql-${PG_MAJOR}-pgtap");
    expect(text).toMatch(/id -u/);
  });

  it("est branché comme `npm run db:test:local`, hors des gates (ce n'est pas un contrôle de CI)", () => {
    const pkg = JSON.parse(readFileSync(join(ROOT, "package.json"), "utf8"));
    expect(pkg.scripts["db:test:local"]).toBe("bash scripts/db/local/pgtap.sh");
    expect(pkg.scripts.verify).not.toContain("db:test:local");
    expect(pkg.scripts["ci:verify"]).not.toContain("db:test:local");
  });
});
