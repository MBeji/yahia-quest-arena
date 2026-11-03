import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import React from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 39 — l'entrée du test : la classe puis la matière, un lien partagé qui présélectionne,
 * le départ qui retient le jeton, mesure (`placement_started`) et navigue vers le test.
 * La route compose (catalogue, matières testables, départ) ; ses composants sont réels, ses
 * lectures sont remplacées.
 */
const hold = vi.hoisted(() => ({
  search: {} as { matiere?: string; niveau?: string },
  auth: { user: null as { id: string } | null, loading: false },
}));
const navigate = vi.hoisted(() => vi.fn());
const track = vi.hoisted(() => vi.fn());
const getParcours = vi.hoisted(() => vi.fn());
const listSubjects = vi.hoisted(() => vi.fn());
const getSubjectCard = vi.hoisted(() => vi.fn());
const start = vi.hoisted(() => vi.fn());

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useSearch: () => hold.search,
  }),
  useNavigate: () => navigate,
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...rest }, children),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("@tanstack/react-query", () => ({
  useQuery: ({
    queryKey,
    queryFn,
    enabled,
  }: {
    queryKey: unknown[];
    queryFn: () => Promise<unknown>;
    enabled?: boolean;
  }) => {
    const [state, setState] = React.useState<{ data?: unknown; isLoading: boolean }>({
      isLoading: enabled !== false,
    });
    const key = JSON.stringify(queryKey);
    React.useEffect(() => {
      if (enabled === false) return;
      let alive = true;
      setState({ isLoading: true });
      void queryFn().then((data) => alive && setState({ data, isLoading: false }));
      return () => {
        alive = false;
      };
    }, [key, enabled]); // eslint-disable-line react-hooks/exhaustive-deps
    return { ...state, isError: false };
  },
  useMutation: ({
    mutationFn,
    onSuccess,
    onError,
  }: {
    mutationFn: (v: unknown) => Promise<unknown>;
    onSuccess: (r: unknown, v: unknown) => void;
    onError: (e: unknown) => void;
  }) => ({
    isPending: false,
    mutate: (vars: unknown) => mutationFn(vars).then((r) => onSuccess(r, vars), onError),
  }),
}));
vi.mock("@/features/auth", () => ({ useAuth: () => hold.auth }));
vi.mock("@/features/dashboard", () => ({ getParcours: () => getParcours() }));
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => track(...a),
}));
vi.mock("@/features/placement", async () => {
  // Jamais le vrai barrel : il tire la couche serveur (`createMiddleware`). Les modules PURS
  // (mémoire, bilan) sont les vrais ; les server fns et le hook sont remplacés.
  const memory = await vi.importActual<typeof import("@/features/placement/placement-memory")>(
    "@/features/placement/placement-memory",
  );
  const bilan = await vi.importActual<typeof import("@/features/placement/placement-bilan")>(
    "@/features/placement/placement-bilan",
  );
  return {
    ...memory,
    ...bilan,
    listPlacementSubjects: (a: unknown) => listSubjects(a),
    getPlacementSubject: (a: unknown) => getSubjectCard(a),
    startPlacementSession: (a: unknown) => start(a),
    useClaimPlacementSessions: () => undefined,
    placementErrorCode: (e: unknown) =>
      e instanceof Error && e.message.includes("assez de questions") ? "notEnough" : null,
  };
});
vi.mock("@/lib/i18n/placement", async () => {
  const mod = await vi.importActual<typeof import("@/lib/i18n/placement")>("@/lib/i18n/placement");
  const fr = await import("@/lib/i18n/fr");
  return { ...mod, usePlacementT: () => ({ ...fr.fr, ...mod.placementTranslations("fr") }) };
});
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: "fr" }) }));

import { Route } from "../_public/test-de-niveau";
import { readRememberedPlacements } from "@/features/placement";

const Page = (Route as unknown as { component: React.ComponentType }).component;

const catalogue = {
  parcours: [
    {
      id: "concours-9eme",
      name_fr: "Concours 9ᵉ",
      kind: "concours",
      status: "available",
      grade_id: "g9",
      grade_cycle: "college",
      grade_order: 9,
      grade_selectable: true,
    },
    {
      id: "scolaire-6eme",
      name_fr: "6ᵉ année",
      kind: "scolaire",
      status: "available",
      grade_id: "g6",
      grade_cycle: "primaire",
      grade_order: 6,
      grade_selectable: true,
    },
    {
      id: "culture",
      name_fr: "Culture G",
      kind: "libre",
      status: "available",
      grade_id: null,
      grade_cycle: null,
      grade_order: null,
      grade_selectable: true,
    },
    {
      id: "lycee-flat",
      name_fr: "Secondaire",
      kind: "scolaire",
      status: "available",
      grade_id: "gsec",
      grade_cycle: "secondaire",
      grade_order: 20,
      grade_selectable: false,
    },
  ],
};
const started = {
  id: "11111111-1111-4111-8111-111111111111",
  token: "22222222-2222-4222-8222-222222222222",
  status: "running",
  audience: "student",
  startedAt: "2026-11-01T10:00:00Z",
  subject: {
    id: "math",
    nameFr: "Mathématiques",
    contentLanguage: "fr",
    gradeNameFr: "9ᵉ",
    gradeSlug: "9eme-base",
    parcoursId: "concours-9eme",
  },
  questions: [],
};

describe("/test-de-niveau — l'entrée (é39 US-1)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.localStorage.clear();
    hold.search = {};
    hold.auth = { user: null, loading: false };
    getParcours.mockResolvedValue(catalogue);
    listSubjects.mockResolvedValue([
      { id: "math", nameFr: "Mathématiques", contentLanguage: "fr", chapters: 20, questions: 800 },
    ]);
    start.mockResolvedValue(started);
  });

  it("liste les classes de l'école (jamais les extras ni les nœuds non choisissables), puis les matières testables", async () => {
    render(<Page />);
    await screen.findByRole("radio", { name: "Concours 9ᵉ" });
    expect(screen.getByRole("radio", { name: "6ᵉ année" })).toBeInTheDocument();
    expect(screen.queryByRole("radio", { name: "Culture G" })).not.toBeInTheDocument();
    expect(screen.queryByRole("radio", { name: "Secondaire" })).not.toBeInTheDocument();
    expect(screen.getByTestId("placement-start")).toBeDisabled();

    fireEvent.click(screen.getByRole("radio", { name: "Concours 9ᵉ" }));
    await screen.findByTestId("placement-subject-math");
    expect(listSubjects).toHaveBeenCalledWith({ data: { parcoursId: "concours-9eme" } });
  });

  it("démarre : retient le jeton, mesure, et va au test", async () => {
    render(<Page />);
    fireEvent.click(await screen.findByRole("radio", { name: "Concours 9ᵉ" }));
    fireEvent.click(await screen.findByTestId("placement-subject-math"));
    fireEvent.click(screen.getByTestId("placement-audience-parent"));
    fireEvent.click(screen.getByTestId("placement-start"));

    await waitFor(() =>
      expect(navigate).toHaveBeenCalledWith({
        to: "/test-de-niveau/$sessionId",
        params: { sessionId: started.id },
      }),
    );
    expect(start).toHaveBeenCalledWith({ data: { subjectId: "math", audience: "parent" } });
    expect(readRememberedPlacements()[0]?.token).toBe(started.token);
    expect(track).toHaveBeenCalledWith("placement_started", {
      subject_id: "math",
      audience: "student",
      signed_in: false,
      from_share: false,
    });
  });

  it("un lien partagé (?matiere=) ouvre le départ rapide, et le mesure comme venu d'un partage", async () => {
    hold.search = { matiere: "math" };
    getSubjectCard.mockResolvedValue({
      ...started.subject,
      testable: true,
      questions: 800,
      chapters: 20,
    });
    render(<Page />);
    const button = await screen.findByTestId("placement-quick-start-button");
    expect(screen.getByTestId("placement-quick-start")).toHaveTextContent("Mathématiques");
    fireEvent.click(button);
    await waitFor(() => expect(navigate).toHaveBeenCalled());
    expect(track).toHaveBeenCalledWith(
      "placement_started",
      expect.objectContaining({ from_share: true }),
    );
  });

  it("une matière partagée qui n'est pas testable le dit, sans bouton", async () => {
    hold.search = { matiere: "mince" };
    getSubjectCard.mockResolvedValue({
      ...started.subject,
      id: "mince",
      testable: false,
      questions: 3,
      chapters: 1,
    });
    render(<Page />);
    await screen.findByTestId("placement-quick-start");
    await waitFor(() =>
      expect(screen.getByTestId("placement-quick-start")).toHaveTextContent(
        "pas encore assez de questions",
      ),
    );
    expect(screen.queryByTestId("placement-quick-start-button")).not.toBeInTheDocument();
  });

  it("le dernier test de l'appareil se rouvre ; un connecté est renvoyé vers son Hall", async () => {
    window.localStorage.setItem(
      "na9ra.placement.v1",
      JSON.stringify([
        {
          id: started.id,
          token: started.token,
          subjectId: "math",
          subjectName: "Maths",
          at: Date.now(),
          scoreOn20: 14,
          band: "en-route",
          finished: true,
        },
      ]),
    );
    const { unmount } = render(<Page />);
    expect(await screen.findByTestId("placement-last-result")).toHaveTextContent("14/20 en Maths");
    unmount();

    hold.auth = { user: { id: "u1" }, loading: false };
    render(<Page />);
    await screen.findByRole("radio", { name: "Concours 9ᵉ" });
    expect(screen.queryByTestId("placement-last-result")).not.toBeInTheDocument();
    expect(screen.getByRole("link", { name: "Voir dans mon Hall" })).toHaveAttribute(
      "href",
      "/dashboard",
    );
  });

  it("valide la recherche : seuls des identifiants de catalogue passent", () => {
    const validate = (
      Route as unknown as { validateSearch: (s: Record<string, unknown>) => Record<string, string> }
    ).validateSearch;
    expect(validate({ matiere: "math-6eme", niveau: "concours-9eme" })).toEqual({
      matiere: "math-6eme",
      niveau: "concours-9eme",
    });
    expect(validate({ matiere: "<script>", niveau: "a b" })).toEqual({});
    expect(validate({ matiere: 42 })).toEqual({});
  });
});
