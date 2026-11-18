import { describe, expect, it } from "vitest";
import { renderLesson, renderSummary } from "@/shared/lib/markdown";

const html = (md: string) => renderLesson(md).html;

// Constat du 2026-11-18, laissé de côté le 15 : le corpus barre les FORMES FAUTIVES qu'il
// refuse (`jamais ~~tu parle~~`, 197 lignes) et le rendu les affichait avec leurs `~~` ; et les
// listes numérotées montraient un éclair à la place du numéro.
describe("renderLesson — le barré", () => {
  it("rend `~~forme fautive~~` en <del>, sans afficher les tildes", () => {
    const out = html("On écrit _tu parles_ (jamais ~~tu parle~~).");
    expect(out).toContain("<del>tu parle</del>");
    expect(out).not.toContain("~");
  });

  it("garde l'italique DANS le barré et le barré DANS l'italique (les deux ordres du corpus)", () => {
    expect(html("~~_a powerful argument_~~ (less idiomatic)")).toContain(
      "<del><em>a powerful argument</em></del>",
    );
    expect(html("jamais _~~je lui ai lu~~_.")).toContain("<em><del>je lui ai lu</del></em>.");
    expect(html("(et non _~~le ami~~_)")).toContain("(et non <em><del>le ami</del></em>)");
  });

  it("barre aussi dans une cellule de tableau", () => {
    const out = html(
      "| bon | faux |\n| --- | --- |\n| _She used to have._ | ~~She would have.~~ |",
    );
    expect(out).toContain("<td><del>She would have.</del></td>");
  });

  it("n'y voit pas un `~` d'approximation, ni des tildes vides ou isolés", () => {
    const out = html("De ~3 °C à ~5 °C, puis ~~ ~~ et ~~seul");
    expect(out).not.toContain("<del>");
    expect(out).toContain("De ~3 °C à ~5 °C, puis ~~ ~~ et ~~seul");
  });

  it("barre un texte arabe, et dans un résumé comme dans un cours", () => {
    expect(html("قل ~~اذهبوا~~ ذهبوا")).toContain("<del>اذهبوا</del>");
    expect(renderSummary("- **Piège** : jamais ~~tu parle~~").html).toContain(
      "<del>tu parle</del>",
    );
  });

  it("l'échappement passe d'abord : le contenu d'un barré ne devient jamais du balisage", () => {
    const out = html("~~<script>alert(1)</script>~~");
    expect(out).toContain("<del>&lt;script&gt;alert(1)&lt;/script&gt;</del>");
    expect(out).not.toContain("<script");
  });
});

describe("renderLesson — l'italique dans un gras", () => {
  it("ouvre et ferme l'italique contre la balise du gras (363 passages du corpus)", () => {
    expect(html("**_x_**")).toContain("<strong><em>x</em></strong>");
    expect(html("et **_gras italique_** fin")).toContain("<strong><em>gras italique</em></strong>");
  });

  it("ne prend toujours pas un indice de formule pour de l'italique", () => {
    expect(html("**S_D** et **t_u**")).not.toContain("<em>");
  });
});

describe("renderLesson — les listes numérotées portent leur numéro", () => {
  const numbers = (out: string) =>
    [...out.matchAll(/<span class="lesson-li__n">(\d+)<\/span>/g)].map((m) => Number(m[1]));

  it("écrit le numéro de chaque item dans une pastille, à l'intérieur du <li>", () => {
    const out = html("1. Premier\n2. Deuxième\n3. Troisième");
    expect(numbers(out)).toEqual([1, 2, 3]);
    expect(out).toContain(
      '<li class="lesson-li lesson-oli"><span class="lesson-li__n">1</span>Premier</li>',
    );
    expect(out.match(/<ol class="lesson-ol">/g)).toHaveLength(1);
  });

  it("garde le numéro de l'AUTEUR : une liste reprise après un paragraphe ne repart pas de 1", () => {
    const out = html("1. un\n2. deux\n\nUn paragraphe.\n\n3. trois\n4. quatre");
    expect(numbers(out)).toEqual([1, 2, 3, 4]);
    expect(out.match(/<ol class="lesson-ol">/g)).toHaveLength(2);
  });

  it("garde une numérotation voulue irrégulière (articles, étapes citées)", () => {
    expect(numbers(html("1. a\n5. b\n9. c"))).toEqual([1, 5, 9]);
  });

  it("numérote un item arabe, renvoyé à la ligne, sans toucher à son texte", () => {
    const out = html(
      [
        "3. نحسب الترتيب بتعويض 3 في إحدى الدالتَين ثمّ نتحقّق بالدالّة الأخرى حتّى نتأكّد من أنّ النقطة",
        "   مشتركة بين المستقيمين.",
        "4. نكتب الجواب.",
      ].join("\n"),
    );
    expect(numbers(out)).toEqual([3, 4]);
    expect(out).toContain("أنّ النقطة مشتركة بين المستقيمين.</li>");
  });

  it("ne numérote pas une puce", () => {
    expect(html("- un\n- deux")).not.toContain("lesson-li__n");
  });
});

describe("renderSummary — le corps d'une carte est une phrase, pas une liste", () => {
  const card =
    "- **Substituts lexicaux** : 1. la **répétition** · 2. un autre terme · 3. un pronom";

  it("garde « 1. » dans le texte quand le corps de la carte commence par un numéro", () => {
    const out = renderSummary(card).html;
    expect(out).not.toContain("<ol");
    expect(out).not.toContain("lesson-li__n");
    expect(out).toContain("1. la <strong>répétition</strong> · 2. un autre terme · 3. un pronom");
  });

  it("n'y touche pas quand le numéro n'est pas en tête du corps", () => {
    expect(renderSummary("- **Étapes** : d'abord 1. puis 2.").html).toContain("d'abord 1. puis 2.");
  });
});

describe("renderLesson — `\\.` : un numéro qui n'ouvre pas une liste", () => {
  it("rend `1\\. texte` en paragraphe, point nu, sans le contre-oblique", () => {
    const out = html("1\\. Une phrase qui commence par un numéro.");
    expect(out).toBe("<p>1. Une phrase qui commence par un numéro.</p>");
  });
});
