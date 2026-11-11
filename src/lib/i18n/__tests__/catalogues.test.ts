// @vitest-environment node
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it, vi } from "vitest";

/**
 * Découpage du catalogue par locale (H2-fe, 2026-10-31).
 *
 * Jusque-là, `provider.tsx` et `__root.tsx` importaient fr, en ET ar statiquement :
 * le chunk trilingue (192 215 octets, 66 303 gz) descendait chez chaque élève et
 * était préchargé sur chaque page, pour une seule langue utile. Depuis, seul `fr`
 * est dans le graphe synchrone ; `en`/`ar` sont tirés par `loadCatalogue`, une fois.
 *
 * Deux sondes : les modules `en` et `ar` sont remplacés par des fabriques qui notent
 * leur évaluation — charger le provider ne doit pas les déclencher ; et le graphe
 * source lui-même est relu, parce que le piège (mesuré) est silencieux : un module
 * partagé par les fichiers de locale est fondu par rolldown dans le premier chunk
 * rencontré et ramène `ar` dans les imports statiques d'index sans que rien ne
 * rougisse.
 */
const sonde = vi.hoisted(() => ({ en: 0, ar: 0 }));

vi.mock("../en", () => {
  sonde.en += 1;
  return { en: { common: { loading: "Loading…" } } };
});
vi.mock("../ar", () => {
  sonde.ar += 1;
  return { ar: { common: { loading: "جارٍ التحميل…" } } };
});

const I18N_DIR = join(process.cwd(), "src", "lib", "i18n");
const LOCALE_FILES = ["fr", "en", "ar", "fr-public", "en-public", "ar-public"] as const;

function runtimeImports(file: string): string[] {
  const source = readFileSync(file, "utf8");
  return [...source.matchAll(/^import\s+(?!type\s)[^;]*?from\s+"([^"]+)"/gm)].map((m) => m[1]);
}

describe("catalogues i18n — un chunk par locale", () => {
  it("charger le provider et le barrel n'évalue ni en ni ar", async () => {
    await import("../provider");
    await import("../index");
    const { loadedCatalogue } = await import("../catalogues");
    expect(loadedCatalogue("fr")).toBeDefined();
    expect(loadedCatalogue("en")).toBeUndefined();
    expect(loadedCatalogue("ar")).toBeUndefined();
    expect(sonde).toEqual({ en: 0, ar: 0 });
  });

  it("tire le chunk d'une locale une seule fois, même demandé deux fois en vol", async () => {
    const { loadCatalogue, loadedCatalogue } = await import("../catalogues");
    const first = loadCatalogue("ar");
    const second = loadCatalogue("ar");
    expect(second).toBe(first);
    const ar = await first;
    expect(ar.common.loading).toBe("جارٍ التحميل…");
    expect(loadedCatalogue("ar")).toBe(ar);
    await loadCatalogue("ar");
    expect(sonde.ar).toBe(1);
    expect(sonde.en).toBe(0);
    // fr est toujours là : aucune promesse réseau, le catalogue lui-même.
    await expect(loadCatalogue("fr")).resolves.toBe(loadedCatalogue("fr"));
  });

  it("hors navigateur, la locale persistée est celle par défaut", async () => {
    const { persistedLocale } = await import("../catalogues");
    expect(persistedLocale()).toBe("fr");
  });

  it("les fichiers de locale ne partagent aucun module (piège rolldown)", () => {
    for (const name of LOCALE_FILES) {
      const imports = runtimeImports(join(I18N_DIR, `${name}.ts`));
      // Le seul import d'exécution permis : le fichier public de la MÊME locale.
      const twin = name.endsWith("-public") ? [] : [`./${name}-public`];
      expect({ name, imports }).toEqual({ name, imports: twin });
    }
  });

  it("seul fr est importé statiquement par le graphe toujours chargé", () => {
    const statique = [
      join(I18N_DIR, "provider.tsx"),
      join(I18N_DIR, "context.ts"),
      join(I18N_DIR, "hooks.ts"),
      join(I18N_DIR, "index.ts"),
      join(I18N_DIR, "catalogues.ts"),
      join(I18N_DIR, "meta.ts"),
      join(process.cwd(), "src", "routes", "__root.tsx"),
    ];
    for (const file of statique) {
      const imports = runtimeImports(file);
      const catalogues = imports.filter((spec) => /(^|\/)(en|ar)(-public)?$/.test(spec));
      expect({ file, catalogues }).toEqual({ file, catalogues: [] });
    }
  });
});
