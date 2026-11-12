import { render } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 38 lot 5 — LE LECTEUR PUBLIC FAIT RETENIR SON CHAPITRE À L'APPAREIL D'UN VISITEUR.
 *
 * Lire un chapitre sans compte ⇒ l'appareil le retient (c'est ce que la carte « Reprendre » de
 * l'accueil relira). Un élève connecté n'y écrit rien, et rien n'est écrit tant qu'on ne sait pas
 * qui lit. Le test surveille aussi `fetch` : retenir ne part nulle part.
 */
vi.mock("@tanstack/react-router", () => ({
  isNotFound: (err: unknown) => (err as { isNotFound?: boolean } | null)?.isNotFound === true,
  notFound: () => ({ isNotFound: true }),
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useParams: () => ({ chapterId: "ch-fractions" }),
    useSearch: () => ({}),
    useNavigate: () => vi.fn(),
    useLoaderData: () => null,
  }),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));

const query = vi.hoisted(() => ({
  result: {
    data: undefined as unknown,
    isLoading: false,
    isError: false,
    error: null as unknown,
    refetch: () => {},
  },
}));
vi.mock("@tanstack/react-query", () => ({ useQuery: () => query.result }));

vi.mock("@/features/quest", () => ({ getChapterLesson: vi.fn() }));
vi.mock("../_public/-catalogue-not-found", () => ({ CatalogueNotFound: () => null }));
vi.mock("@/features/quest/components/lesson-reader", () => ({ LessonReader: () => null }));
vi.mock("@/features/ai/components/forge-entry", () => ({ ForgeEntry: () => null }));
vi.mock("@/features/tutor/components/tutor-chat-panel", () => ({ TutorChatPanel: () => null }));
const authState = vi.hoisted(() => ({
  user: null as { id: string } | null,
  loading: false,
}));
vi.mock("@/features/auth", () => ({ useAuth: () => authState }));

import {
  LAST_CHAPTER_KEY,
  hasPassedQuizOnDevice,
  readLastChapter,
  rememberLastChapter,
  rememberQuizPassed,
} from "@/shared/lib/anon-continuity";
import { Route } from "../_public/chapitre.$chapterId";

const Page = (Route as unknown as { component: React.ComponentType }).component;

function lesson(id: string, title: string) {
  return {
    chapter: { id, title, subjects: { name_fr: "Mathématiques", content_language: "fr" } },
    allChapters: [],
    practiceExerciseId: null,
    quizGated: false,
    quizPassed: null,
    quizExerciseId: null,
  };
}

beforeEach(() => {
  window.localStorage.clear();
  authState.user = null;
  authState.loading = false;
  query.result = {
    data: lesson("ch-fractions", "Les fractions"),
    isLoading: false,
    isError: false,
    error: null,
    refetch: () => {},
  };
});

describe("le lecteur public et la mémoire de l'appareil (é38 lot 5)", () => {
  it("⭐ un visiteur sans compte lit un chapitre ⇒ l'appareil le retient, et rien ne part", () => {
    const fetchSpy = vi.spyOn(globalThis, "fetch");
    render(<Page />);

    expect(readLastChapter()).toMatchObject({
      id: "ch-fractions",
      title: "Les fractions",
      lang: "fr",
    });
    expect(fetchSpy).not.toHaveBeenCalled();
    fetchSpy.mockRestore();
  });

  it("⭐ un élève CONNECTÉ n'écrit rien sur l'appareil", () => {
    authState.user = { id: "u1" };
    render(<Page />);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
  });

  it("tant que la session n'est pas lue, rien n'est écrit — puis le visiteur est reconnu", () => {
    authState.loading = true;
    const { rerender } = render(<Page />);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();

    authState.loading = false;
    rerender(<Page />);
    expect(readLastChapter()?.id).toBe("ch-fractions");
  });

  it("un chapitre qui ne charge pas n'est pas retenu", () => {
    query.result = {
      data: undefined,
      isLoading: false,
      isError: true,
      error: new Error("panne"),
      refetch: () => {},
    };
    render(<Page />);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
  });

  it("la leçon encore affichée d'un AUTRE chapitre n'est pas retenue sous le mauvais identifiant", () => {
    query.result = {
      data: lesson("ch-autre", "Un autre chapitre"),
      isLoading: false,
      isError: false,
      error: null,
      refetch: () => {},
    };
    render(<Page />);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
  });

  it("⭐ un chapitre DISPARU du catalogue est oublié — la carte ne ramène pas à une page introuvable", () => {
    rememberLastChapter({ id: "ch-fractions", title: "Les fractions" });
    rememberQuizPassed("ch-fractions");
    query.result = {
      data: undefined,
      isLoading: false,
      isError: true,
      error: { isNotFound: true },
      refetch: () => {},
    };
    render(<Page />);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
    // Seul le chapitre est oublié : la réussite du quiz n'a rien à voir avec cette disparition.
    expect(hasPassedQuizOnDevice("ch-fractions")).toBe(true);
  });

  it("une PANNE de chargement, elle, ne fait rien oublier", () => {
    rememberLastChapter({ id: "ch-fractions", title: "Les fractions" });
    query.result = {
      data: undefined,
      isLoading: false,
      isError: true,
      error: new Error("panne"),
      refetch: () => {},
    };
    render(<Page />);
    expect(readLastChapter()?.id).toBe("ch-fractions");
  });

  it("un AUTRE chapitre introuvable ne fait pas oublier celui qu'on lisait", () => {
    rememberLastChapter({ id: "ch-ailleurs", title: "Ailleurs" });
    query.result = {
      data: undefined,
      isLoading: false,
      isError: true,
      error: { isNotFound: true },
      refetch: () => {},
    };
    render(<Page />);
    expect(readLastChapter()?.id).toBe("ch-ailleurs");
  });
});
