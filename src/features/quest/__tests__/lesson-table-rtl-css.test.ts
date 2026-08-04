import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const CSS = readFileSync(resolve(import.meta.dirname, "../../../styles.css"), "utf-8");

/** Le corps de la règle `[dir="rtl"] .lesson-table { … }`, si elle existe encore. */
const rtlTableBlock = CSS.match(/\[dir="rtl"\]\s+\.lesson-table\s*\{([^}]*)\}/)?.[1] ?? "";

describe("RTL — tableaux de leçon", () => {
  it("ne force AUCUNE direction sur le tableau : les colonnes suivent le sens de la page", () => {
    // Régression : `[dir="rtl"] .lesson-table { direction: ltr }` inversait l'ordre des
    // colonnes de tous les cours arabes — le lecteur ouvrait la ligne sur la DERNIÈRE
    // colonne et finissait sur le « # ». La direction du tableau doit rester héritée.
    expect(rtlTableBlock).not.toMatch(/direction\s*:/);
  });

  /**
   * La règle groupe désormais `td` ET `th` — on l'attrape par sa déclaration plutôt que par
   * une forme de sélecteur figée, pour ne pas re-casser au prochain regroupement.
   */
  const cellRule =
    CSS.match(/((?:\[dir="rtl"\]\s+\.lesson-table\s+(?:td|th)\s*,?\s*)+)\{([^}]*)\}/) ?? [];
  const cellSelector = cellRule[1] ?? "";
  const cellBody = cellRule[2] ?? "";

  it("laisse chaque cellule résoudre sa direction, pour la notation nue", () => {
    // `isolateLtrRunsHtml` n'isole une formule que s'il y a de l'arabe contre quoi la
    // découper : une cellule de notation PURE (`√50 = √(25 × 2)`) n'a aucun caractère fort
    // et héritait donc du RTL, qui la lisait à l'envers (`(2 × 25)√ = 50√`).
    expect(cellBody).toMatch(/unicode-bidi\s*:\s*plaintext/);
  });

  it("garde une colonne alignée d'un seul bord malgré `plaintext`", () => {
    // Sans cela, `text-align: start` se résout cellule par cellule : la formule à gauche,
    // sa voisine arabe à droite, dans la même colonne.
    expect(cellBody).toMatch(/text-align\s*:\s*right/);
  });

  it("traite l'en-tête comme une cellule : `th` suit `td`", () => {
    // L'en-tête est passé de `<td>` à `<th scope="col">` — une règle qui n'aurait pas suivi
    // laisserait la ligne d'en-tête arabe hors du traitement bidi appliqué à ses colonnes.
    expect(cellSelector).toContain("td");
    expect(cellSelector).toContain("th");
  });
});
