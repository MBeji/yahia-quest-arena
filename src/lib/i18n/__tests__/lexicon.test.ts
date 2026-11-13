// @vitest-environment node
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

/**
 * Le lexique trilingue (docs/content-voice-and-composition.md §2) tenu par un test :
 * « un concept = un mot par langue, partout ». L'audit d'affichage (issue #1228) a
 * relevé des dérives qu'aucun gate ne voyait — `lexicon-drift-banned-terms`,
 * `ar-landing-banned-dungeon-word`, `suivi-public-parent-tunnel`. On relit ici les
 * SOURCES des catalogues : une valeur fautive est rouge où qu'elle soit rangée.
 */
const I18N_DIR = join(process.cwd(), "src", "lib", "i18n");
const SPLIT_DIRS = [
  "parent",
  "badges",
  "progress",
  "guide",
  "placement",
  "install",
  "keep",
  "invite",
];

function sources(locale: "fr" | "en" | "ar"): { file: string; values: string[] }[] {
  const files = [
    join(I18N_DIR, `${locale}.ts`),
    join(I18N_DIR, `${locale}-public.ts`),
    ...SPLIT_DIRS.filter((dir) => readdirSync(join(I18N_DIR, dir)).includes(`${locale}.ts`)).map(
      (dir) => join(I18N_DIR, dir, `${locale}.ts`),
    ),
  ];
  return files.map((file) => ({
    file,
    // Les VALEURS seulement (chaînes entre guillemets doubles) : les noms de clés
    // (`allianceCodeLabel`, `dashboard:`) et les commentaires ne sont pas du texte d'écran.
    values: [...readFileSync(file, "utf8").matchAll(/"((?:[^"\\]|\\.)*)"/g)].map((m) => m[1]),
  }));
}

function offenders(locale: "fr" | "en" | "ar", banned: RegExp): string[] {
  return sources(locale).flatMap(({ file, values }) =>
    values
      .filter((value) => banned.test(value))
      .map((value) => `${file.slice(I18N_DIR.length + 1)}: ${value}`),
  );
}

describe("lexique — arabe", () => {
  it("« الزنزانة » (cellule de prison) est banni : le donjon est « القبو »", () => {
    expect(offenders("ar", /الزنزانة/)).toEqual([]);
  });

  it("le classement est « الترتيب », jamais « لوحة المتصدرين »", () => {
    expect(offenders("ar", /لوحة المتصدرين/)).toEqual([]);
  });

  it("un seul nom pour le code du tunnel parent : « رمز التحالف »", () => {
    expect(offenders("ar", /^رمز التلميذ$/)).toEqual([]);
  });

  it("un signe devant un nombre interpolé porte sa marque gauche-à-droite", () => {
    // Sans U+200E, « +{xp} » s'affiche « 50+ » dans une page arabe (bidi.ts, `plus`).
    expect(offenders("ar", /(?<!\\u200E)[+−]\{/)).toEqual([]);
  });

  it("une flèche « retour » en tête de libellé pointe à droite", () => {
    expect(offenders("ar", /^←/)).toEqual([]);
  });
});

describe("lexique — français", () => {
  it("« code alliance », un seul nom sur tout le tunnel parent", () => {
    expect(offenders("fr", /Alliance Code|Code Alliance|code d'alliance|Code élève/)).toEqual([]);
  });

  it("jamais de jargon non traduit : « dashboard », « streak »", () => {
    expect(offenders("fr", /\b(?:dashboard|streak)\b/i)).toEqual([]);
  });
});

describe("lexique — anglais", () => {
  it("« alliance code », une seule graphie", () => {
    expect(offenders("en", /Alliance Code|Student code/)).toEqual([]);
  });
});
