import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import React from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 39 — un test : la passation puis le bilan. La route attend d'avoir lu le jeton de
 * l'appareil ET la session d'auth avant de demander le test ; elle mesure la fin
 * (`placement_completed`) et le partage, et pose la mémoire de retour sur l'invitation.
 */
const hold = vi.hoisted(() => ({
  params: { sessionId: "11111111-1111-4111-8111-111111111111" },
  auth: { user: null as { id: string } | null, loading: false },
}));
const track = vi.hoisted(() => vi.fn());
const getSession = vi.hoisted(() => vi.fn());
const finish = vi.hoisted(() => vi.fn());
const rememberCurrentPage = vi.hoisted(() => vi.fn());
const setQueryData = vi.hoisted(() => vi.fn());

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useParams: () => hold.params,
  }),
  useNavigate: () => vi.fn(),
  Link: ({
    children,
    to,
    onClick,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    onClick?: () => void;
  }) =>
    React.createElement(
      "a",
      {
        href: to,
        onClick: (e: React.MouseEvent) => {
          e.preventDefault();
          onClick?.();
        },
        ...rest,
      },
      children,
    ),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@tanstack/react-query", () => ({
  useQueryClient: () => ({ setQueryData, invalidateQueries: vi.fn() }),
  useQuery: ({
    queryKey,
    queryFn,
    enabled,
  }: {
    queryKey: unknown[];
    queryFn: () => Promise<unknown>;
    enabled?: boolean;
  }) => {
    const [state, setState] = React.useState<{
      data?: unknown;
      isLoading: boolean;
      isError: boolean;
      error?: unknown;
    }>({ isLoading: true, isError: false });
    const key = JSON.stringify(queryKey);
    React.useEffect(() => {
      if (!enabled) return;
      let alive = true;
      queryFn().then(
        (data) => alive && setState({ data, isLoading: false, isError: false }),
        (error) => alive && setState({ isLoading: false, isError: true, error }),
      );
      return () => {
        alive = false;
      };
    }, [key, enabled]); // eslint-disable-line react-hooks/exhaustive-deps
    return { ...state, refetch: vi.fn() };
  },
  useMutation: ({
    mutationFn,
    onSuccess,
  }: {
    mutationFn: (v: unknown) => Promise<unknown>;
    onSuccess: (r: unknown) => void;
  }) => {
    const [isError, setIsError] = React.useState(false);
    return {
      isPending: false,
      isError,
      mutate: (vars: unknown) => mutationFn(vars).then(onSuccess, () => setIsError(true)),
    };
  },
}));
vi.mock("@/features/auth", () => ({ useAuth: () => hold.auth }));
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => track(...a),
}));
vi.mock("@/shared/lib/return-to", () => ({ rememberCurrentPage: () => rememberCurrentPage() }));
vi.mock("@/features/placement", async () => {
  const memory = await vi.importActual<typeof import("@/features/placement/placement-memory")>(
    "@/features/placement/placement-memory",
  );
  return {
    ...memory,
    getPlacementSession: (a: unknown) => getSession(a),
    finishPlacementSession: (a: unknown) => finish(a),
    useClaimPlacementSessions: () => undefined,
    placementErrorCode: (e: unknown) =>
      e instanceof Error && e.message.includes("introuvable") ? "notFound" : null,
  };
});
vi.mock("@/lib/i18n/placement", async () => {
  const mod = await vi.importActual<typeof import("@/lib/i18n/placement")>("@/lib/i18n/placement");
  const fr = await import("@/lib/i18n/fr");
  return { ...mod, usePlacementT: () => ({ ...fr.fr, ...mod.placementTranslations("fr") }) };
});
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: "fr" }) }));

import { Route } from "../_public/test-de-niveau_.$sessionId";
import { rememberPlacement, readRememberedPlacements } from "@/features/placement";

const Page = (Route as unknown as { component: React.ComponentType }).component;
const ID = hold.params.sessionId;
const TOKEN = "22222222-2222-4222-8222-222222222222";
const subject = {
  id: "math",
  nameFr: "Mathématiques",
  contentLanguage: "fr",
  gradeNameFr: "9ᵉ",
  gradeSlug: "9eme-base",
  parcoursId: "concours-9eme",
};
const running = {
  id: ID,
  status: "running",
  audience: "student",
  startedAt: "2026-11-01T10:00:00Z",
  subject,
  questions: [
    {
      id: "q1",
      chapterId: "c1",
      chapterTitle: "Fractions",
      chapterOrder: 1,
      prompt: "Un demi plus un demi ?",
      options: [
        { id: "a", text: "1" },
        { id: "b", text: "2" },
      ],
      questionType: "mcq",
    },
  ],
};
const bilan = {
  id: ID,
  status: "completed",
  audience: "student",
  startedAt: "2026-11-01T10:00:00Z",
  finishedAt: "2026-11-01T10:05:00Z",
  subject,
  correct: 1,
  total: 1,
  scoreOn20: 20,
  band: "solide",
  durationSeconds: 30,
  tooFast: false,
  chapters: [
    {
      chapterId: "c1",
      title: "Fractions",
      displayOrder: 1,
      correct: 1,
      total: 1,
      held: true,
      hasLesson: true,
    },
  ],
  firstToReview: null,
  percentile: { candidates: 1, minCandidates: 20, percentile: null },
  review: [],
  insightsLocked: true,
};

describe("/test-de-niveau/$sessionId (é39)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.localStorage.clear();
    window.sessionStorage.clear();
    hold.auth = { user: null, loading: false };
    rememberPlacement({
      id: ID,
      token: TOKEN,
      subjectId: "math",
      subjectName: "Mathématiques",
      at: Date.now(),
    });
  });

  it("relit le test par le jeton de l'appareil, joue, rend, mesure la fin et garde le résultat", async () => {
    getSession.mockResolvedValue(running);
    finish.mockResolvedValue(bilan);
    render(<Page />);

    await screen.findByTestId("placement-runner");
    expect(getSession).toHaveBeenCalledWith({ data: { sessionId: ID, token: TOKEN } });

    fireEvent.click(screen.getByRole("radio", { name: /1/ }));
    fireEvent.click(screen.getByTestId("placement-next"));

    await waitFor(() => expect(finish).toHaveBeenCalled());
    expect(finish.mock.calls[0]?.[0]).toMatchObject({
      data: { sessionId: ID, token: TOKEN, answers: [{ questionId: "q1", choice: "a" }] },
    });
    await waitFor(() => expect(setQueryData).toHaveBeenCalledWith(expect.anything(), bilan));
    expect(track).toHaveBeenCalledWith("placement_completed", {
      subject_id: "math",
      audience: "student",
      signed_in: false,
      band: "solide",
      too_fast: false,
    });
    expect(readRememberedPlacements()[0]).toMatchObject({
      finished: true,
      scoreOn20: 20,
      band: "solide",
    });
  });

  it("un test fini affiche son bilan ; l'invitation pose la mémoire de retour et se mesure", async () => {
    getSession.mockResolvedValue(bilan);
    render(<Page />);
    await screen.findByTestId("placement-summary");
    fireEvent.click(screen.getByRole("link", { name: "Créer mon compte gratuit" }));
    expect(rememberCurrentPage).toHaveBeenCalledTimes(1);
    expect(track).toHaveBeenCalledWith("account_invite_clicked", { surface: "placement" });
  });

  it("sans jeton et sans compte, le test est introuvable sur cet appareil", async () => {
    window.localStorage.clear();
    getSession.mockRejectedValue(new Error("Ce test est introuvable."));
    render(<Page />);
    expect(await screen.findByText(/introuvable sur cet appareil/)).toBeInTheDocument();
    expect(getSession).toHaveBeenCalledWith({ data: { sessionId: ID, token: null } });
  });

  it("n'appelle rien tant que la session d'auth n'est pas lue : un propriétaire sans jeton doit passer", async () => {
    window.localStorage.clear();
    hold.auth = { user: null, loading: true };
    getSession.mockResolvedValue(bilan);
    render(<Page />);
    await new Promise((r) => setTimeout(r, 20));
    expect(getSession).not.toHaveBeenCalled();
  });

  it("un identifiant qui n'est pas un UUID ne part jamais au serveur", async () => {
    hold.params = { sessionId: "nope" };
    render(<Page />);
    expect(await screen.findByText(/introuvable sur cet appareil/)).toBeInTheDocument();
    expect(getSession).not.toHaveBeenCalled();
    hold.params = { sessionId: ID };
  });
});
