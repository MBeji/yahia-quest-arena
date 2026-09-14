import { describe, it, expect, afterEach } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { I18nProvider, useI18n } from "@/lib/i18n";
import { useProgressT, progressTranslations } from "@/lib/i18n/progress";
import { fr } from "@/lib/i18n/fr";
import { frProgress } from "@/lib/i18n/progress/fr";
import { arProgress } from "@/lib/i18n/progress/ar";

/**
 * Le catalogue des ÉTOILES ET DES SCEAUX vit à part (chunk `i18n-progress`, é34
 * R-17 — chargé avec le hub matière, et aux lots suivants avec le QG et le suivi
 * parental). Ce fichier garde deux choses que les tests d'écran ne garderaient
 * pas :
 *
 *   - le **câblage** du découpage : `useProgressT()` doit rendre les clés
 *     app-wide ET `progress.*` sur le même objet, et suivre la langue ;
 *   - la **complétude** : trois langues, exactement les mêmes clés. Une chaîne
 *     oubliée en arabe ne se voit pas à l'écran français, et c'est très
 *     exactement comme ça qu'un produit trilingue devient bilingue.
 */
function ProgressConsumer() {
  const t = useProgressT();
  return (
    <div>
      {/* une clé app-wide et deux clés progress, lues sur le MÊME objet */}
      <span data-testid="core">{t.common.loading}</span>
      <span data-testid="mastered">{t.progress.chapterStars.mastered}</span>
      <span data-testid="seal">{t.progress.seal.heading}</span>
    </div>
  );
}

function LocaleSwitch() {
  const { setLocale } = useI18n();
  return <button data-testid="to-ar" onClick={() => setLocale("ar")} />;
}

/** Les chemins de toutes les feuilles d'un catalogue, à plat et triés. */
function leafPaths(value: unknown, prefix = ""): string[] {
  if (value === null || typeof value !== "object") return [prefix];
  return Object.entries(value as Record<string, unknown>)
    .flatMap(([k, v]) => leafPaths(v, prefix ? `${prefix}.${k}` : k))
    .sort();
}

describe("catalogue i18n de la progression (é34)", () => {
  afterEach(() => localStorage.clear());

  it("fusionne le catalogue app-wide et celui de la progression sur le même `t`", () => {
    render(
      <I18nProvider>
        <ProgressConsumer />
      </I18nProvider>,
    );
    expect(screen.getByTestId("core").textContent).toBe(fr.common.loading);
    expect(screen.getByTestId("mastered").textContent).toBe(
      frProgress.progress.chapterStars.mastered,
    );
    expect(screen.getByTestId("seal").textContent).toBe(frProgress.progress.seal.heading);
  });

  it("suit le changement de langue comme le catalogue app-wide", () => {
    render(
      <I18nProvider>
        <LocaleSwitch />
        <ProgressConsumer />
      </I18nProvider>,
    );
    expect(screen.getByTestId("mastered").textContent).toBe(
      frProgress.progress.chapterStars.mastered,
    );
    fireEvent.click(screen.getByTestId("to-ar"));
    expect(screen.getByTestId("mastered").textContent).toBe(
      arProgress.progress.chapterStars.mastered,
    );
  });

  it("les trois langues portent EXACTEMENT les mêmes clés", () => {
    const fr = leafPaths(progressTranslations("fr"));
    expect(leafPaths(progressTranslations("en"))).toEqual(fr);
    expect(leafPaths(progressTranslations("ar"))).toEqual(fr);
    expect(fr.length).toBeGreaterThan(20);
  });

  it("aucune chaîne vide, dans aucune langue", () => {
    for (const locale of ["fr", "en", "ar"] as const) {
      const catalog = progressTranslations(locale);
      const walk = (v: unknown, path: string) => {
        if (typeof v === "string") {
          expect(v.trim(), `${locale}.${path}`).not.toBe("");
          return;
        }
        for (const [k, child] of Object.entries(v as Record<string, unknown>)) {
          walk(child, `${path}.${k}`);
        }
      };
      walk(catalog, locale);
    }
  });

  it("chaque substitution déclarée est présente dans les trois langues", () => {
    // Une phrase traduite sans son `{n}` perd l'information, silencieusement : rien
    // ne plante, le chiffre disparaît simplement de l'écran arabe.
    const required: Record<string, string[]> = {
      "progress.chapterStars.gaugeLabel": ["{star}", "{total}"],
      "progress.chapterStars.masteredWithNew": ["{n}"],
      "progress.chapterStars.rungCount": ["{done}", "{total}"],
      "progress.chapterStars.legend": ["{star}", "{tier}"],
      "progress.newMissions": ["{n}"],
      "progress.familyMissions": ["{done}", "{total}"],
      "progress.seal.title": ["{stars}"],
      "progress.seal.earnedOn": ["{date}"],
      "progress.seal.next": ["{stars}", "{ready}", "{total}"],
      "progress.seal.nextWithNew": ["{stars}", "{ready}", "{total}", "{n}"],
      "progress.effort.missions": ["{n}"],
      "progress.effort.xp": ["{n}"],
      "progress.effort.chaptersStarted": ["{started}"],
      "progress.effort.chaptersMastered": ["{mastered}"],
    };
    for (const locale of ["fr", "en", "ar"] as const) {
      const catalog = progressTranslations(locale) as unknown as Record<string, unknown>;
      for (const [path, tokens] of Object.entries(required)) {
        const value = path
          .split(".")
          .reduce<unknown>((acc, k) => (acc as Record<string, unknown>)?.[k], catalog);
        expect(typeof value, `${locale}.${path}`).toBe("string");
        for (const token of tokens) {
          expect(String(value), `${locale}.${path} manque ${token}`).toContain(token);
        }
      }
    }
  });

  it("l'arabe écrit ses nombres en chiffres OCCIDENTAUX (R-17)", () => {
    // Le produit affiche « 3/4 », jamais « ٣/٤ » : les substitutions reçoivent des
    // nombres rendus par `String(n)`, et la phrase doit les accueillir tels quels.
    // Écrit par échappements : les classes littérales de chiffres arabo-indiens sont
    // illisibles en revue, et c'est justement ce que ce test interdit à l'écran.
    const arabicIndicDigits = new RegExp("[\\u0660-\\u0669\\u06F0-\\u06F9]");
    const walk = (v: unknown, path: string) => {
      if (typeof v === "string") {
        expect(arabicIndicDigits.test(v), `ar.${path}`).toBe(false);
        return;
      }
      for (const [k, child] of Object.entries(v as Record<string, unknown>)) {
        walk(child, `${path}.${k}`);
      }
    };
    walk(progressTranslations("ar"), "progress");
  });

  it("n'emploie AUCUN mot interdit par R-1", () => {
    // « niveau » pour une étoile, « palier » (réservé à l'avatar), « rang »
    // (classement), les métaux de la ligue, et toute formule de perte. Ces mots
    // existent ailleurs dans le produit avec un autre sens : les réutiliser ici
    // ferait deux vocabulaires pour une seule échelle.
    const banned = [
      /\bniveaux?\b/i,
      /\bpaliers?\b/i,
      /\brangs?\b/i,
      /\bplatine\b/i,
      /\bdiamant\b/i,
      /\bperdu(e|s)?\b/i,
      /\brégression\b/i,
      /\ben retard\b/i,
    ];
    const walk = (v: unknown, path: string) => {
      if (typeof v === "string") {
        for (const re of banned) {
          expect(re.test(v), `fr.${path} : « ${v} »`).toBe(false);
        }
        return;
      }
      for (const [k, child] of Object.entries(v as Record<string, unknown>)) {
        walk(child, `${path}.${k}`);
      }
    };
    walk(progressTranslations("fr"), "progress");
  });
});
