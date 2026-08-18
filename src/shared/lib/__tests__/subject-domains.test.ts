import { describe, it, expect } from "vitest";
import { groupChaptersByDomain } from "../subject-domains";

/** Un chapitre réduit à ce que le regroupement lit, plus un id pour l'assertion. */
const ch = (id: string, domain?: string | null) => ({ id, domain });

describe("groupChaptersByDomain", () => {
  it("groupe par domaine, dans l'ordre de première apparition", () => {
    // Le cas réel du programme tunisien de maths : les activités numériques et
    // géométriques ALTERNENT. Regrouper ne doit pas réordonner les domaines selon
    // l'alphabet ou le nombre de chapitres — le premier chapitre décide.
    const groups = groupChaptersByDomain([
      ch("c1", "Algèbre"),
      ch("c2", "Géométrie"),
      ch("c3", "Algèbre"),
      ch("c4", "Géométrie"),
    ]);
    expect(groups?.map((g) => g.label)).toEqual(["Algèbre", "Géométrie"]);
    expect(groups?.[0]?.chapters.map((c) => c.id)).toEqual(["c1", "c3"]);
    expect(groups?.[1]?.chapters.map((c) => c.id)).toEqual(["c2", "c4"]);
  });

  it("range les chapitres non rattachés dans un groupe sans libellé", () => {
    const groups = groupChaptersByDomain([ch("c1", "Grammaire"), ch("c2", null), ch("c3")]);
    expect(groups?.map((g) => g.label)).toEqual(["Grammaire", null]);
    expect(groups?.[1]?.chapters.map((c) => c.id)).toEqual(["c2", "c3"]);
  });

  it("place le fourre-tout là où il apparaît, sans le reléguer à la fin", () => {
    // Une seule règle d'ordre — la première apparition — pour tous les groupes.
    // Un chapitre d'introduction non rattaché reste donc en tête du programme,
    // là où l'auteur l'a mis, au lieu d'être renvoyé sous les domaines nommés.
    const groups = groupChaptersByDomain([ch("intro"), ch("c1", "Algèbre")]);
    expect(groups?.map((g) => g.label)).toEqual([null, "Algèbre"]);
  });

  it("réunit deux graphies d'un même domaine et affiche la première", () => {
    // `content:qa` refuse la faute en amont, mais le contenu des migrations
    // écrites à la main ne passe pas par lui : deux en-têtes jumeaux seraient
    // pires que le regroupement.
    const groups = groupChaptersByDomain([
      ch("c1", "Géométrie"),
      ch("c2", "geometrie"),
      ch("c3", "Algèbre"),
    ]);
    expect(groups).toHaveLength(2);
    expect(groups?.[0]?.label).toBe("Géométrie");
    expect(groups?.[0]?.chapters.map((c) => c.id)).toEqual(["c1", "c2"]);
  });

  it("rend null quand aucun chapitre n'est rattaché — l'état du corpus au jour de la colonne", () => {
    expect(groupChaptersByDomain([ch("c1"), ch("c2", null)])).toBeNull();
  });

  it("rend null quand un domaine unique couvre toute la matière — un groupe ne groupe rien", () => {
    expect(groupChaptersByDomain([ch("c1", "Grammaire"), ch("c2", "Grammaire")])).toBeNull();
  });

  it("ignore un libellé qui n'est que de l'espace, comme s'il était absent", () => {
    const groups = groupChaptersByDomain([ch("c1", "   "), ch("c2", "Algèbre")]);
    expect(groups?.map((g) => g.label)).toEqual([null, "Algèbre"]);
  });

  it("rend une clé stable et distincte par domaine", () => {
    const groups = groupChaptersByDomain([ch("c1", "Algèbre"), ch("c2", "Géométrie"), ch("c3")]);
    const keys = groups?.map((g) => g.key) ?? [];
    expect(new Set(keys).size).toBe(3);
  });

  it("groupe aussi une matière arabe, tashkil et hamza pliés", () => {
    const groups = groupChaptersByDomain([
      ch("c1", "قواعد اللغة"),
      ch("c2", "قواعد اللّغة"),
      ch("c3", "فهم المقروء"),
    ]);
    expect(groups?.map((g) => g.label)).toEqual(["قواعد اللغة", "فهم المقروء"]);
    expect(groups?.[0]?.chapters.map((c) => c.id)).toEqual(["c1", "c2"]);
  });

  it("rend null sur une matière sans chapitre", () => {
    expect(groupChaptersByDomain([])).toBeNull();
  });
});
