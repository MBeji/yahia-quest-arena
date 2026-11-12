import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

/**
 * Une adresse de contenu qui ne désigne rien répond 404 — et une PANNE n'en est
 * jamais une.
 *
 * Constat du 2026-11-12, en production : `/chapitre/<id inconnu>`,
 * `/chapitre/pas-un-uuid`, `/matiere/<inconnue>` et `/niveau/inexistant`
 * répondaient HTTP 200 avec un écran d'erreur (un « soft 404 » pour Google). Le
 * loader de chaque page lève maintenant `notFound()` quand la lecture a RÉUSSI
 * sans rien rendre ; une lecture en ÉCHEC garde le repli d'avant (`null` → 200,
 * le client recharge). Ces tests tiennent les deux moitiés de la règle, route par
 * route. (`/exercice` : même règle, tenue dans `exercice-public.test.tsx`.)
 */
vi.mock("@tanstack/react-router", () => ({
  notFound: () => ({ isNotFound: true }),
  isNotFound: (e: unknown) => (e as { isNotFound?: boolean } | null)?.isNotFound === true,
  createFileRoute: () => (opts: Record<string, unknown>) => opts,
  Link: () => null,
  useNavigate: () => () => undefined,
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() },
}));

// Les pages ne sont pas montées ici : seuls leurs loaders tournent. Leurs
// composants (et les barrels de feature qu'ils tirent) sont remplacés.
vi.mock("@/features/quest", () => ({
  getChapterLesson: vi.fn(),
  getSubject: vi.fn(),
  getSubjectParcours: vi.fn(),
}));
vi.mock("@/features/quest/anon-quiz-gate", () => ({ hasPassedChapterQuiz: () => false }));
vi.mock("@/features/quest/components/lesson-reader", () => ({ LessonReader: () => null }));
vi.mock("@/features/quest/components/subject-hub", () => ({ SubjectHub: () => null }));
vi.mock("@/features/quest/components/subject-hub-skeleton", () => ({
  SubjectHubSkeleton: () => null,
}));
vi.mock("@/features/ai/components/forge-entry", () => ({ ForgeEntry: () => null }));
vi.mock("@/features/tutor/components/tutor-chat-panel", () => ({ TutorChatPanel: () => null }));
vi.mock("@/features/auth", () => ({
  useAuth: () => ({ user: null, loading: false }),
  setCurrentParcours: vi.fn(),
}));
vi.mock("@/features/dashboard", () => ({ getParcoursSubjects: vi.fn() }));
vi.mock("@/features/dashboard/components/parcours-subjects", () => ({
  ParcoursSubjects: () => null,
}));

// Les fonctions serveur que les loaders importent À LA DEMANDE, par leur fichier.
const getChapterLesson = vi.fn();
const checkSubjectExists = vi.fn();
vi.mock("@/features/quest/quest.lesson.server", () => ({
  getChapterLesson: (...a: unknown[]) => getChapterLesson(...a),
  checkSubjectExists: (...a: unknown[]) => checkSubjectExists(...a),
  getSubjectParcours: vi.fn().mockResolvedValue(null),
}));
const getSubject = vi.fn();
vi.mock("@/features/quest/quest.server", () => ({
  getSubject: (...a: unknown[]) => getSubject(...a),
}));
const getParcoursSubjects = vi.fn();
vi.mock("@/features/dashboard/dashboard.server", () => ({
  getParcoursSubjects: (...a: unknown[]) => getParcoursSubjects(...a),
}));

import { Route as ChapitreRoute } from "../_public/chapitre.$chapterId";
import { Route as MatiereRoute } from "../_public/matiere.$subjectId";
import { Route as NiveauRoute } from "../_public/niveau.$parcoursId";

type Loader<P> = (ctx: { params: P }) => Promise<unknown> | null;
const loadChapitre = (ChapitreRoute as unknown as { loader: Loader<{ chapterId: string }> }).loader;
const loadMatiere = (MatiereRoute as unknown as { loader: Loader<{ subjectId: string }> }).loader;
const loadNiveau = (NiveauRoute as unknown as { loader: Loader<{ parcoursId: string }> }).loader;

const NOT_FOUND = { isNotFound: true };
const CHAPTER_ID = "6e7219be-5c5a-586e-bedd-318a6262ec8f";

beforeEach(() => {
  vi.clearAllMocks();
  vi.stubEnv("SSR", true);
});
afterEach(() => {
  vi.unstubAllEnvs();
});

describe("/chapitre/$chapterId", () => {
  it("adresse qui n'a pas la forme d'un uuid : 404 sans interroger la base", async () => {
    await expect(loadChapitre({ params: { chapterId: "pas-un-uuid" } })).rejects.toEqual(NOT_FOUND);
    expect(getChapterLesson).not.toHaveBeenCalled();
  });

  it("chapitre absent : le notFound() de la fonction serveur atteint le routeur", async () => {
    getChapterLesson.mockRejectedValue(NOT_FOUND);
    await expect(loadChapitre({ params: { chapterId: CHAPTER_ID } })).rejects.toEqual(NOT_FOUND);
  });

  it("lecture en panne : pas de 404, le client recharge", async () => {
    getChapterLesson.mockRejectedValue(new Error("db down"));
    await expect(loadChapitre({ params: { chapterId: CHAPTER_ID } })).resolves.toBeNull();
  });
});

describe("/matiere/$subjectId", () => {
  it("matière absente : la lecture d'existence tranche, la page répond 404", async () => {
    getSubject.mockRejectedValue(new Error("Impossible de charger la matière."));
    checkSubjectExists.mockResolvedValue(false);
    await expect(loadMatiere({ params: { subjectId: "inexistante" } })).rejects.toEqual(NOT_FOUND);
    expect(checkSubjectExists).toHaveBeenCalledWith({ data: { subjectId: "inexistante" } });
  });

  it("matière présente mais lecture en panne : pas de 404", async () => {
    getSubject.mockRejectedValue(new Error("db down"));
    checkSubjectExists.mockResolvedValue(true);
    await expect(loadMatiere({ params: { subjectId: "math-6eme" } })).resolves.toBeNull();
  });

  it("base injoignable — la lecture d'existence échoue aussi : pas de 404", async () => {
    getSubject.mockRejectedValue(new Error("db down"));
    checkSubjectExists.mockRejectedValue(new Error("db down"));
    await expect(loadMatiere({ params: { subjectId: "math-6eme" } })).resolves.toBeNull();
  });

  it("matière servie : aucune lecture d'existence en plus", async () => {
    getSubject.mockResolvedValue({
      subject: { name_fr: "Mathématiques", description: "Les maths de 6e." },
      parcours: null,
      chapters: [],
    });
    await expect(loadMatiere({ params: { subjectId: "math-6eme" } })).resolves.toMatchObject({
      head: expect.anything(),
    });
    expect(checkSubjectExists).not.toHaveBeenCalled();
  });
});

describe("/niveau/$parcoursId", () => {
  it("niveau absent d'une lecture réussie : 404", async () => {
    getParcoursSubjects.mockResolvedValue({ parcours: null, subjects: [] });
    await expect(loadNiveau({ params: { parcoursId: "inexistant" } })).rejects.toEqual(NOT_FOUND);
  });

  it("lecture en panne : pas de 404, le client recharge", async () => {
    getParcoursSubjects.mockRejectedValue(new Error("db down"));
    await expect(loadNiveau({ params: { parcoursId: "6eme" } })).resolves.toBeNull();
  });
});
