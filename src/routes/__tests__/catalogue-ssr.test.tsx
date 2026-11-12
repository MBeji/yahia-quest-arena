import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

/**
 * Ce qu'un moteur de recherche lit d'une page du catalogue, au rendu serveur.
 *
 * Constats du 2026-11-12, en production :
 *  - `/programme`, `/programme/lycee/$annee` et `/extras` partaient du serveur avec
 *    « Chargement… » : aucun lien vers un niveau dans le HTML. Un robot qui ne joue
 *    pas le JavaScript ne pouvait pas entrer dans le catalogue par sa porte d'entrée.
 *  - 88 pages de matière sur 129 partageaient leur `<title>` (« English » × 21) :
 *    le niveau n'est jamais résolu pour un visiteur anonyme.
 *  - aucune page ne portait de fil d'Ariane.
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

// Seuls les loaders tournent : les composants (et leurs barrels) sont remplacés.
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
vi.mock("@/features/dashboard", () => ({
  getParcours: vi.fn(),
  getParcoursSubjects: vi.fn(),
  lyceeYearOf: () => null,
  useParcoursInterest: () => ({}),
}));
vi.mock("@/features/dashboard/components/parcours-subjects", () => ({
  ParcoursSubjects: () => null,
}));
vi.mock("@/features/dashboard/components/parcours-catalogue", () => ({
  ProgrammeCatalogue: () => null,
  ExtrasCatalogue: () => null,
  LyceeYearSections: () => null,
}));

const getChapterLesson = vi.fn();
const getSubjectParcours = vi.fn();
vi.mock("@/features/quest/quest.lesson.server", () => ({
  getChapterLesson: (...a: unknown[]) => getChapterLesson(...a),
  getSubjectParcours: (...a: unknown[]) => getSubjectParcours(...a),
  checkSubjectExists: vi.fn(),
}));
const getSubject = vi.fn();
vi.mock("@/features/quest/quest.server", () => ({
  getSubject: (...a: unknown[]) => getSubject(...a),
}));
const getParcours = vi.fn();
const getParcoursSubjects = vi.fn();
vi.mock("@/features/dashboard/dashboard.server", () => ({
  getParcours: (...a: unknown[]) => getParcours(...a),
  getParcoursSubjects: (...a: unknown[]) => getParcoursSubjects(...a),
}));

import { Route as ChapitreRoute } from "../_public/chapitre.$chapterId";
import { Route as MatiereRoute } from "../_public/matiere.$subjectId";
import { Route as NiveauRoute } from "../_public/niveau.$parcoursId";
import { Route as ProgrammeRoute } from "../_public/programme";
import { Route as LyceeRoute } from "../_public/programme_.lycee.$annee";
import { Route as ExtrasRoute } from "../_public/extras";

type Head = {
  meta: Array<Record<string, string>>;
  scripts?: Array<{ type: string; children: string }>;
};
type Seeded = { head: Head } | null;
type RouteOptions<P> = {
  loader: (ctx: { params: P }) => Promise<unknown> | unknown;
  head: (ctx: { loaderData: unknown }) => Head;
};
const options = <P,>(route: unknown) => route as RouteOptions<P>;

const titleOf = (head: Head) => head.meta.find((tag) => "title" in tag)?.title;
const metaOf = (head: Head, property: string) =>
  head.meta.find((tag) => tag.property === property)?.content;
const jsonLdOf = (head: Head, type: string) =>
  (head.scripts ?? [])
    .map((script) => JSON.parse(script.children) as Record<string, unknown>)
    .find((data) => data["@type"] === type);
const namesOf = (list: Record<string, unknown> | undefined) =>
  (list?.itemListElement as Array<{ name: string }> | undefined)?.map((item) => item.name);

const CHAPTER_ID = "6e7219be-5c5a-586e-bedd-318a6262ec8f";
const PARCOURS = { id: "ecole-6eme-base", name_fr: "6ème année", name_en: null, name_ar: null };

beforeEach(() => {
  vi.clearAllMocks();
  vi.stubEnv("SSR", true);
});
afterEach(() => {
  vi.unstubAllEnvs();
});

describe("/chapitre/$chapterId — titre, langue, fil d'Ariane", () => {
  it("nomme le niveau, déclare la langue du contenu et le fil niveau › matière › cours", async () => {
    getChapterLesson.mockResolvedValue({
      chapter: {
        title: "الكسور",
        description: "درس الكسور.",
        subject_id: "math-6eme",
        subjects: { name_fr: "الرياضيات", content_language: "ar" },
      },
      parcours: PARCOURS,
    });
    const seeded = (await options<{ chapterId: string }>(ChapitreRoute).loader({
      params: { chapterId: CHAPTER_ID },
    })) as Seeded;
    const head = seeded!.head;

    expect(titleOf(head)).toBe("الكسور — الرياضيات · 6ème année · Na9ra Nal3ab");
    expect(metaOf(head, "og:locale")).toBe("ar_AR");
    expect(jsonLdOf(head, "LearningResource")).toMatchObject({
      inLanguage: "ar",
      educationalLevel: "6ème année",
    });
    const trail = jsonLdOf(head, "BreadcrumbList");
    expect(namesOf(trail)).toEqual(["6ème année", "الرياضيات", "الكسور"]);
    expect((trail?.itemListElement as Array<{ item: string }>).map((i) => i.item)).toEqual([
      "https://www.na9ranal3ab.tn/niveau/ecole-6eme-base",
      "https://www.na9ranal3ab.tn/matiere/math-6eme",
      `https://www.na9ranal3ab.tn/chapitre/${CHAPTER_ID}`,
    ]);
  });

  it("niveau illisible : le fil commence à la matière, le titre ne l'invente pas", async () => {
    getChapterLesson.mockResolvedValue({
      chapter: {
        title: "Les fractions",
        subject_id: "math-6eme",
        subjects: { name_fr: "Mathématiques", content_language: "fr" },
      },
      parcours: null,
    });
    const seeded = (await options<{ chapterId: string }>(ChapitreRoute).loader({
      params: { chapterId: CHAPTER_ID },
    })) as Seeded;
    expect(titleOf(seeded!.head)).toBe("Les fractions — Mathématiques · Na9ra Nal3ab");
    expect(namesOf(jsonLdOf(seeded!.head, "BreadcrumbList"))).toEqual([
      "Mathématiques",
      "Les fractions",
    ]);
  });
});

describe("/matiere/$subjectId — le niveau d'un visiteur sans compte", () => {
  const subjectData = {
    subject: { name_fr: "English", description: "", content_language: "en" },
    // `getSubject` ne rend jamais le niveau à l'anonyme (RPC refusée).
    parcours: null,
    chapters: [
      { id: "c1", title: "Greetings" },
      { id: "c2", title: "Numbers" },
    ],
  };

  it("résout le niveau à part : titre distinct, fil d'Ariane, liste des cours", async () => {
    getSubject.mockResolvedValue(subjectData);
    getSubjectParcours.mockResolvedValue(PARCOURS);
    const seeded = (await options<{ subjectId: string }>(MatiereRoute).loader({
      params: { subjectId: "anglais-6eme" },
    })) as Seeded & { parcours: unknown };
    const head = seeded.head;

    expect(getSubjectParcours).toHaveBeenCalledWith({ data: { subjectId: "anglais-6eme" } });
    expect(seeded.parcours).toEqual(PARCOURS);
    expect(titleOf(head)).toBe("English — 6ème année · Na9ra Nal3ab");
    expect(metaOf(head, "og:locale")).toBe("en_US");
    expect(namesOf(jsonLdOf(head, "BreadcrumbList"))).toEqual(["6ème année", "English"]);
    const list = jsonLdOf(head, "ItemList");
    expect(list).toMatchObject({ numberOfItems: 2 });
    expect((list?.itemListElement as Array<{ url: string }>).map((i) => i.url)).toEqual([
      "https://www.na9ranal3ab.tn/chapitre/c1",
      "https://www.na9ranal3ab.tn/chapitre/c2",
    ]);
  });

  it("niveau déjà rendu par getSubject (élève connecté) : aucune lecture en plus", async () => {
    getSubject.mockResolvedValue({ ...subjectData, parcours: PARCOURS });
    await options<{ subjectId: string }>(MatiereRoute).loader({
      params: { subjectId: "anglais-6eme" },
    });
    expect(getSubjectParcours).not.toHaveBeenCalled();
  });

  it("lecture du niveau en panne : la page est servie quand même, sans niveau", async () => {
    getSubject.mockResolvedValue(subjectData);
    getSubjectParcours.mockRejectedValue(new Error("db down"));
    const seeded = (await options<{ subjectId: string }>(MatiereRoute).loader({
      params: { subjectId: "anglais-6eme" },
    })) as Seeded;
    expect(titleOf(seeded!.head)).toBe("English · Na9ra Nal3ab");
    expect(namesOf(jsonLdOf(seeded!.head, "BreadcrumbList"))).toEqual(["English"]);
  });
});

describe("/niveau/$parcoursId — fil d'Ariane et liste des matières", () => {
  it("programme › niveau, et les matières en ItemList", async () => {
    getParcoursSubjects.mockResolvedValue({
      parcours: { id: "ecole-6eme-base", name_fr: "6ème année" },
      subjects: [
        { id: "math-6eme", name_fr: "Mathématiques" },
        { id: "arabe-6eme", name_fr: "اللغة العربية" },
      ],
    });
    const seeded = (await options<{ parcoursId: string }>(NiveauRoute).loader({
      params: { parcoursId: "ecole-6eme-base" },
    })) as Seeded;
    expect(namesOf(jsonLdOf(seeded!.head, "BreadcrumbList"))).toEqual(["Programme", "6ème année"]);
    expect(namesOf(jsonLdOf(seeded!.head, "ItemList"))).toEqual(["Mathématiques", "اللغة العربية"]);
  });
});

describe("le catalogue part du serveur avec ses niveaux — /programme, /programme/lycee, /extras", () => {
  const catalogue = { parcours: [{ id: "ecole-6eme-base" }] };

  it.each([
    ["/programme", () => options<object>(ProgrammeRoute).loader({ params: {} })],
    ["/extras", () => options<object>(ExtrasRoute).loader({ params: {} })],
    [
      "/programme/lycee/bac",
      () => options<{ annee: string }>(LyceeRoute).loader({ params: { annee: "bac" } }),
    ],
  ])("%s : précharge le catalogue anonyme au rendu serveur", async (_path, load) => {
    getParcours.mockResolvedValue(catalogue);
    await expect(load()).resolves.toEqual(catalogue);
  });

  it("panne du catalogue : `null`, le client recharge", async () => {
    getParcours.mockRejectedValue(new Error("db down"));
    await expect(options<object>(ProgrammeRoute).loader({ params: {} })).resolves.toBeNull();
  });

  it("dans le navigateur, aucun loader ne lit rien", () => {
    vi.stubEnv("SSR", false);
    expect(options<object>(ProgrammeRoute).loader({ params: {} })).toBeNull();
    expect(options<object>(ExtrasRoute).loader({ params: {} })).toBeNull();
    expect(options<{ annee: string }>(LyceeRoute).loader({ params: { annee: "bac" } })).toBeNull();
    expect(getParcours).not.toHaveBeenCalled();
  });

  // Une année qui n'existe pas : 404, au serveur comme en navigation client.
  it("/programme/lycee/<année inconnue> : 404 sans lecture", () => {
    for (const ssr of [true, false]) {
      vi.stubEnv("SSR", ssr);
      expect(() =>
        options<{ annee: string }>(LyceeRoute).loader({ params: { annee: "xyz" } }),
      ).toThrow(expect.objectContaining({ isNotFound: true }));
    }
    expect(getParcours).not.toHaveBeenCalled();
  });
});
