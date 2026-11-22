import type { MockExamRegistry } from "../schema.ts";

/**
 * Les deux états du registre que rejoue `supabase/tests/115_mock_exams_from_corpus.test.sql`.
 *
 * Le SQL que le test pgTAP exécute est COPIÉ de `buildMockExamRegistrySql` sur ces
 * fixtures ; `content-pipeline-mock-exams.test.ts` compare les deux, caractère pour
 * caractère. Sans ce lien, le test de base vérifierait un SQL que plus personne ne
 * génère — vert, et sans objet.
 */
const label = (fr: string, en: string, ar: string) => ({ fr, en, ar });

/** v1 : une épreuve de matière (deux parties) et un blanc qui mêle deux matières. */
export const MOCK_EXAM_FIXTURE_V1: MockExamRegistry = {
  "fixture-epreuve-langue-1": {
    parcours: "concours-9eme",
    subject: "exam-reg-a",
    title: label("Épreuve de l'élève", "The student's paper", "اختبار التلميذ"),
    durationMinutes: 60,
    displayOrder: 110,
    papers: [
      {
        exercise: "exam-reg-a/01-chapitre/04-comprehension",
        label: label("I. Compréhension", "I. Reading", "الفهم"),
        points: 70,
      },
      {
        exercise: "exam-reg-a/01-chapitre/05-langue",
        label: label("II. Langue", "II. Language", "اللغة"),
        points: 60,
      },
    ],
  },
  "fixture-blanc-deux-matieres": {
    parcours: "concours-9eme",
    title: label("Blanc à deux matières", "Two-subject mock", "تجريبي بمادتين"),
    durationMinutes: 90,
    displayOrder: 120,
    papers: [
      {
        exercise: "exam-reg-a/01-chapitre/04-comprehension",
        label: label("Langue", "Language", "اللغة"),
        points: 40,
      },
      {
        exercise: "exam-reg-b/01-chapitre/01-calcul",
        label: label("Calcul", "Arithmetic", "الحساب"),
        points: 10,
      },
    ],
  },
};

/**
 * v2 : l'épreuve de matière est retirée (elle doit être ARCHIVÉE, épreuves gardées)
 * et le blanc perd sa seconde épreuve (elle doit être retirée, et l'examen rester publié).
 */
export const MOCK_EXAM_FIXTURE_V2: MockExamRegistry = {
  "fixture-blanc-deux-matieres": {
    parcours: "concours-9eme",
    title: label("Blanc à une matière", "One-subject mock", "تجريبي بمادة"),
    durationMinutes: 45,
    displayOrder: 120,
    papers: [
      {
        exercise: "exam-reg-a/01-chapitre/04-comprehension",
        label: label("Langue", "Language", "اللغة"),
        points: 40,
      },
    ],
  },
};
