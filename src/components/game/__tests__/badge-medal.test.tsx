import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { BadgeMedal } from "@/components/game/badge-medal";

/** La couleur de rareté est portée en `style` par le conteneur de la médaille. */
function medalOf(container: HTMLElement): HTMLElement {
  return container.firstElementChild as HTMLElement;
}

describe("BadgeMedal", () => {
  it("prend la couleur du cran de rareté, pas une couleur d'accent générique", () => {
    const { container } = render(<BadgeMedal iconName="Flame" rarity="epic" />);
    expect(medalOf(container).style.color).toBe("var(--rarity-epic)");
  });

  it("retombe sur « commun » plutôt que de rendre un cadre sans couleur", () => {
    // Un badge semé avec une rareté hors échelle doit rester une médaille.
    const { container } = render(<BadgeMedal iconName="Flame" rarity="mythique-inventé" />);
    expect(medalOf(container).style.color).toBe("var(--rarity-common)");
  });

  it("distingue le cran le plus haut par la FORME, pas seulement par la couleur", () => {
    // Sans ça, l'échelle disparaît pour qui ne distingue pas les teintes.
    const legendary = render(<BadgeMedal iconName="Zap" rarity="legendary" />);
    const rare = render(<BadgeMedal iconName="Zap" rarity="rare" />);
    expect(legendary.container.querySelectorAll("polygon").length).toBeGreaterThan(
      rare.container.querySelectorAll("polygon").length,
    );
  });

  it("rend un glyphe même quand la base n'en déclare aucun", () => {
    const { container } = render(<BadgeMedal iconName={null} rarity="common" />);
    expect(container.querySelector("svg.lucide")).not.toBeNull();
  });

  it("se tait pour le lecteur d'écran : le nom du badge est déjà écrit à côté", () => {
    const { container } = render(<BadgeMedal iconName="Star" rarity="rare" />);
    expect(medalOf(container).getAttribute("aria-hidden")).toBe("true");
  });
});

/**
 * ⭐ LE REPLI EST UN FILET, PAS UNE CARTE DE GLYPHES.
 *
 * `GLYPHS[iconName] || Award` fait qu'un `icon_name` inconnu rend une médaille —
 * la bonne conduite — mais SANS que rien ne le signale. `event_rentree` a été semé
 * en `Sparkles` par le lot 8 de é31 alors que la carte ne connaissait pas ce nom :
 * le badge de la rentrée a porté le glyphe générique, et aucun test n'a rougi.
 *
 * C'est la même classe que R-13 (« un badge sans règle ») et que `auth-refusals` :
 * deux listes tenues à la main, chacune juste de son côté. Ce test les confronte.
 */
describe("les glyphes semés en base sont tous connus du composant", () => {
  const MIGRATIONS = join(process.cwd(), "supabase/migrations");
  const sql = readdirSync(MIGRATIONS)
    .filter((f) => f.endsWith(".sql"))
    .map((f) => readFileSync(join(MIGRATIONS, f), "utf8"))
    .join("\n");

  /**
   * Les `icon_name` écrits par les seeds de `public.badges`.
   *
   * Ancrés sur la RARETÉ, qui précède toujours immédiatement `icon_name` dans les
   * quatre formes de seed du dépôt — avec ou sans colonne `id` en tête, avec ou
   * sans `family` en queue. Un `'Moon'` de commentaire ou d'un autre INSERT
   * n'entre donc pas.
   */
  function seededGlyphs(): string[] {
    // D'abord les seuls INSERT qui écrivent des badges — un `'common', 'rare'`
    // adjacent ailleurs dans la chaîne (échelles de rareté, objets de boutique)
    // ferait autrement passer « rare » pour un glyphe.
    const inserts = [...sql.matchAll(/INSERT INTO public\.badges[\s\S]*?;/g)].map((m) => m[0]);
    return [
      ...new Set(
        inserts.flatMap((stmt) =>
          [...stmt.matchAll(/'(?:common|rare|epic|legendary)',\s*'([A-Za-z]+)'/g)].map((m) => m[1]),
        ),
      ),
    ];
  }

  it("⭐ aucun glyphe en bonne casse ne tombe sur le repli", () => {
    const canonique = seededGlyphs().filter((g) => /^[A-Z]/.test(g));
    // Le test ne peut pas passer à vide : s'il ne trouve presque rien, c'est
    // l'extraction qui est cassée, pas la carte qui est complète.
    expect(canonique.length).toBeGreaterThan(10);

    const repli = render(<BadgeMedal iconName="glyphe-qui-n-existe-pas" rarity="common" />);
    const classeDuRepli = repli.container.querySelector("svg.lucide")?.getAttribute("class");

    for (const glyph of canonique) {
      // On compare au REPLI rendu plutôt qu'en lisant la carte : c'est le pixel
      // qui compte, pas la structure interne du module.
      const rendu = render(<BadgeMedal iconName={glyph} rarity="common" />);
      const classe = rendu.container.querySelector("svg.lucide")?.getAttribute("class");
      expect(classe, `${glyph} n'est pas dans GLYPHS — il rend le glyphe générique`).not.toBe(
        classeDuRepli,
      );
    }
  });

  it("⭐ et tout glyphe semé en mauvaise casse est NORMALISÉ par une migration", () => {
    // Le premier seed (2026-05-22) écrit `'flame'`, `'swords'`, `'zap'` en
    // minuscules ; le seed plus riche du même jour écrit la bonne casse mais porte
    // `ON CONFLICT DO NOTHING`, donc il n'a jamais rien corrigé. Quatre mois de
    // flammes invisibles. La casse ne peut pas se rattraper côté composant sans
    // ouvrir la porte à n'importe quelle graphie : elle se corrige en base.
    const mauvaiseCasse = seededGlyphs().filter((g) => /^[a-z]/.test(g));
    expect(mauvaiseCasse.length).toBeGreaterThan(0); // sinon ce test ne garde rien
    for (const glyph of mauvaiseCasse) {
      const attendu = glyph[0].toUpperCase() + glyph.slice(1);
      expect(
        sql.includes(`SET icon_name = '${attendu}'`),
        `'${glyph}' est semé sans qu'aucune migration ne le normalise en '${attendu}'`,
      ).toBe(true);
    }
  });
});
