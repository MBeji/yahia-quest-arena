// @vitest-environment node
import { describe, it, expect, beforeAll, afterAll } from "vitest";
import { mkdtempSync, mkdirSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { collectFigures, OVERFLOW_TOLERANCE } from "../check-overflow.mjs";

/**
 * Ces tests ne lancent AUCUN navigateur : la mesure est faite par Chromium (et
 * prouvée à chaque passage par `--calibrate`, contre un cas mesuré dans l'app en
 * production). Ce qui se teste ici est la moitié qui décide QUOI mesurer — et
 * qui rate silencieusement si elle oublie un champ.
 */
const FIG = (id) => `<svg viewBox="0 0 10 10"><text>${id}</text></svg>`;

let dir;
beforeAll(() => {
  dir = mkdtempSync(join(tmpdir(), "overflow-"));
  mkdirSync(join(dir, "matiere", "01-chap", "exercices"), { recursive: true });
  const chap = join(dir, "matiere", "01-chap");

  writeFileSync(join(chap, "cours.md"), `# Titre\n\n${FIG("A")}\n\ntexte\n\n${FIG("B")}\n`);
  writeFileSync(join(chap, "resume.md"), `- puce\n\n${FIG("C")}\n`);
  writeFileSync(
    join(chap, "quiz.json"),
    JSON.stringify({
      questions: [
        {
          prompt: `Question ?\n${FIG("D")}`,
          explanation: `Parce que.\n${FIG("E")}`,
          options: [{ text: `oui ${FIG("F")}` }, { text: "non" }],
        },
        { prompt: "Sans figure", options: [{ text: "a" }] },
      ],
    }),
  );
  // Un tableau nu — l'autre forme que prend un fichier d'exercices.
  writeFileSync(
    join(chap, "exercices", "01.json"),
    JSON.stringify([{ prompt: `Énoncé ${FIG("G")}` }]),
  );
  // Ni contenu, ni JSON valide : ne doit rien casser.
  writeFileSync(join(chap, "notes.json"), "{ pas du json");
  writeFileSync(join(chap, "notes.txt"), FIG("IGNORÉ"));
});
afterAll(() => rmSync(dir, { recursive: true, force: true }));

describe("collectFigures", () => {
  const ids = (figures) => figures.map((f) => f.svg.match(/<text>([^<]+)/)[1]).sort();

  it("ramasse les figures des .md et des .json, et rien d'autre", () => {
    expect(ids(collectFigures(dir))).toEqual(["A", "B", "C", "D", "E", "F", "G"]);
  });

  it("n'oublie ni l'explication ni les options — pas seulement le prompt", () => {
    const found = collectFigures(dir);
    const wheres = found.map((f) => f.where);
    expect(wheres).toContain("q1.prompt");
    expect(wheres).toContain("q1.explanation");
    expect(wheres).toContain("q1.option 1");
  });

  it("numérote les figures d'une leçon dans l'ordre du document", () => {
    const cours = collectFigures(dir).filter((f) => f.file.endsWith("cours.md"));
    expect(cours.map((f) => f.where)).toEqual(["figure 1", "figure 2"]);
    expect(cours[0].svg).toContain("<text>A</text>");
  });

  it("survit à un JSON illisible plutôt que d'abandonner le dossier", () => {
    // notes.json est cassé ; G, dans un dossier voisin, doit quand même sortir.
    expect(ids(collectFigures(dir))).toContain("G");
  });

  it("rend le chemin du fichier avec chaque figure — un constat sans adresse est inutile", () => {
    for (const f of collectFigures(dir)) expect(f.file).toMatch(/\.(md|json)$/);
  });
});

describe("OVERFLOW_TOLERANCE", () => {
  it("laisse passer l'arrondi de rendu, pas un défaut visible", () => {
    expect(OVERFLOW_TOLERANCE).toBeGreaterThan(0);
    expect(OVERFLOW_TOLERANCE).toBeLessThan(1);
  });
});
