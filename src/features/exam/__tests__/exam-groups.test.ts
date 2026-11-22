// @vitest-environment node
import { describe, expect, it } from "vitest";
import { MIXED_EXAM_GROUP_KEY, groupExamsBySubject } from "../exam-groups";

/**
 * Le rangement du catalogue. Ce qu'il ne doit jamais faire : réordonner. L'ordre
 * vient du corpus (`displayOrder`), via `list_mock_exams` ; un tri de plus ici
 * serait un second réglage, que personne ne penserait à tenir.
 */

const exam = (id: string, subjectId: string | null, subjectName: string | null = subjectId) => ({
  id,
  subjectId,
  subjectName,
});

describe("groupExamsBySubject", () => {
  it("ne rend aucun groupe pour une liste vide", () => {
    expect(groupExamsBySubject([])).toEqual([]);
  });

  it("garde un seul groupe sans matière quand il n'y a que des concours blancs", () => {
    const groups = groupExamsBySubject([exam("a", null), exam("b", null)]);
    expect(groups).toHaveLength(1);
    expect(groups[0]).toMatchObject({ key: MIXED_EXAM_GROUP_KEY, subjectId: null });
    expect(groups[0]?.exams.map((e) => e.id)).toEqual(["a", "b"]);
  });

  it("place les concours blancs multi-matières en tête, où qu'ils soient dans la liste", () => {
    const groups = groupExamsBySubject([
      exam("fr-1", "french", "Français"),
      exam("blanc", null),
      exam("ar-1", "arabic", "العربية"),
    ]);
    expect(groups.map((g) => g.key)).toEqual([MIXED_EXAM_GROUP_KEY, "french", "arabic"]);
  });

  it("range les matières dans l'ordre de leur premier examen, et les examens dans l'ordre reçu", () => {
    const groups = groupExamsBySubject([
      exam("ar-1", "arabic", "العربية"),
      exam("fr-1", "french", "Français"),
      exam("ar-2", "arabic", "العربية"),
      exam("fr-2", "french", "Français"),
    ]);
    expect(groups.map((g) => g.subjectName)).toEqual(["العربية", "Français"]);
    expect(groups[0]?.exams.map((e) => e.id)).toEqual(["ar-1", "ar-2"]);
    expect(groups[1]?.exams.map((e) => e.id)).toEqual(["fr-1", "fr-2"]);
  });

  it("retrouve le nom de la matière sur un examen suivant quand le premier ne le porte pas", () => {
    const groups = groupExamsBySubject([
      exam("fr-1", "french", null),
      exam("fr-2", "french", "Français"),
    ]);
    expect(groups[0]?.subjectName).toBe("Français");
  });

  it("ne modifie pas la liste reçue", () => {
    const input = [exam("fr-1", "french", "Français"), exam("blanc", null)];
    const copy = structuredClone(input);
    groupExamsBySubject(input);
    expect(input).toEqual(copy);
  });
});
