import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const CSS = readFileSync(resolve(import.meta.dirname, "../../../styles.css"), "utf-8");

/**
 * Les règles de la feuille, découpées en `{ selector, body }`.
 *
 * Découpage par `split`, pas par une expression qui tenterait de décrire un sélecteur : une
 * règle groupée (`a, b { … }`) pousse à écrire un groupe répété, et le premier jet ici
 * (`(?:… \s*,?\s*)+`) a valu une alerte CodeQL « inefficient regular expression » — deux
 * quantificateurs d'espaces adjacents dans un groupe répété, c'est-à-dire un backtracking
 * exponentiel sur une entrée qui ne matche pas. Un `split` est linéaire et se lit mieux.
 * Les commentaires tombent d'abord, sinon leur prose entre dans les sélecteurs.
 */
const RULES = CSS.replace(/\/\*[\s\S]*?\*\//g, "")
  .split("}")
  .map((chunk) => {
    const [selector = "", body = ""] = chunk.split("{");
    return { selector: selector.trim(), body };
  })
  .filter((rule) => rule.selector && rule.body);

const rtlTableRule = RULES.find(
  (rule) => rule.selector.includes('[dir="rtl"]') && /\.lesson-table\s*$/.test(rule.selector),
);
const rtlCellRule = RULES.find(
  (rule) =>
    rule.selector.includes('[dir="rtl"]') && /\.lesson-table\s+(?:td|th)\b/.test(rule.selector),
);

describe("RTL — tableaux de leçon", () => {
  it("ne force AUCUNE direction sur le tableau : les colonnes suivent le sens de la page", () => {
    // Régression : `[dir="rtl"] .lesson-table { direction: ltr }` inversait l'ordre des
    // colonnes de tous les cours arabes — le lecteur ouvrait la ligne sur la DERNIÈRE
    // colonne et finissait sur le « # ». La direction du tableau doit rester héritée.
    // La règle n'existe plus du tout aujourd'hui ; si elle revenait, elle serait muette.
    expect(rtlTableRule?.body ?? "").not.toMatch(/direction\s*:/);
  });

  it("laisse chaque cellule résoudre sa direction, pour la notation nue", () => {
    // `isolateLtrRunsHtml` n'isole une formule que s'il y a de l'arabe contre quoi la
    // découper : une cellule de notation PURE (`√50 = √(25 × 2)`) n'a aucun caractère fort
    // et héritait donc du RTL, qui la lisait à l'envers (`(2 × 25)√ = 50√`).
    expect(rtlCellRule?.body).toMatch(/unicode-bidi\s*:\s*plaintext/);
  });

  it("garde une colonne alignée d'un seul bord malgré `plaintext`", () => {
    // Sans cela, `text-align: start` se résout cellule par cellule : la formule à gauche,
    // sa voisine arabe à droite, dans la même colonne.
    expect(rtlCellRule?.body).toMatch(/text-align\s*:\s*right/);
  });

  it("traite l'en-tête comme une cellule : `th` suit `td`", () => {
    // L'en-tête est passé de `<td>` à `<th scope="col">` — une règle qui n'aurait pas suivi
    // laisserait la ligne d'en-tête arabe hors du traitement bidi appliqué à ses colonnes.
    expect(rtlCellRule?.selector).toContain("td");
    expect(rtlCellRule?.selector).toContain("th");
  });
});
