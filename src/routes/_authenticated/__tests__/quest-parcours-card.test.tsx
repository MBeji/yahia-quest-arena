import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

/**
 * Étude 38 lot 2 — l'accueil n'est plus un péage (R-5, US-2).
 *
 * Un élève sans classe qui ouvre une quête la JOUE ; la route pose au-dessus du
 * lecteur une carte qui lui propose la classe du chapitre. Ce que ces tests fixent :
 *  - le lecteur est rendu dans TOUS les cas — la carte n'ouvre ni ne ferme rien ;
 *  - la carte n'existe que pour un `student` sans parcours ;
 *  - « Choisir » fait ce que fait l'assistant (même fonction serveur, même pack de
 *    bienvenue) et le dit à la mesure avec `source: "quest_card"`.
 */
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useParams: () => ({ exerciseId: "6e7219be-5c5a-586e-bedd-318a6262ec8f" }),
    useSearch: () => ({}),
  }),
  Link: ({ children }: { children?: React.ReactNode }) => <a>{children}</a>,
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));

const toastSuccess = vi.fn();
const toastError = vi.fn();
vi.mock("sonner", () => ({
  toast: {
    success: (...a: unknown[]) => toastSuccess(...a),
    error: (...a: unknown[]) => toastError(...a),
  },
}));

const getExerciseParcours = vi.fn();
vi.mock("@/features/quest", () => ({
  RECALL_LOCKED_MESSAGE: "recall-locked",
  RECALL_NOT_ELIGIBLE_MESSAGE: "recall-not-eligible",
  checkQuestion: vi.fn(),
  getExerciseParcours: (...a: unknown[]) => getExerciseParcours(...a),
  revealHint: vi.fn(),
  startExerciseSession: vi.fn(),
  getAttemptProgress: vi.fn(),
  submitAttempt: vi.fn(),
}));
vi.mock("@/features/quest/components/exercise-player", () => ({
  ExercisePlayer: ({ exerciseId }: { exerciseId: string }) => (
    <div data-testid="exercise-player">{exerciseId}</div>
  ),
}));
vi.mock("@/features/quest/components/quest-result-actions", () => ({
  QuestResultActions: () => null,
}));
vi.mock("@/features/tutor", () => ({ TutorPanel: () => null }));
// Étude 40, lot 2 — le candidat « rappel » de l'écran de résultat : jamais proposable ici
// (l'écran de résultat n'est pas l'objet de ce fichier ; il a ses propres tests).
vi.mock("@/features/notifications", () => ({
  usePushVictoryCandidate: () => ({ kind: "push", available: false, render: () => null }),
}));
vi.mock("@/features/content-report", () => ({ ReportErrorButton: () => null }));
vi.mock("@/features/subscription", () => ({ SubscriptionPaywall: () => null }));

const setCurrentParcours = vi.fn();
const claimWelcomePack = vi.fn();
const useMyRole = vi.fn();
vi.mock("@/features/auth", () => ({
  setCurrentParcours: (...a: unknown[]) => setCurrentParcours(...a),
  claimWelcomePack: (...a: unknown[]) => claimWelcomePack(...a),
  useMyRole: () => useMyRole(),
  useAuth: () => ({ user: { id: "11111111-1111-4111-8111-111111111111" } }),
}));

const hasActiveParentLink = vi.fn();
vi.mock("@/features/parent-report/parent-link.server", () => ({
  hasActiveParentLink: (...a: unknown[]) => hasActiveParentLink(...a),
}));

import { Route } from "../quest.$exerciseId";

const QuestPage = (Route as unknown as { component: React.ComponentType }).component;

const EXERCISE_ID = "6e7219be-5c5a-586e-bedd-318a6262ec8f";
const NEUVIEME = {
  id: "ecole-9eme",
  name_fr: "9ème année",
  name_en: "9th grade",
  name_ar: "السنة التاسعة",
};
const NEW_STUDENT = { role: "student", currentParcoursId: null, hasProfile: true, isLoaded: true };

function renderPage() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  const invalidate = vi.spyOn(client, "invalidateQueries");
  render(
    <QueryClientProvider client={client}>
      <QuestPage />
    </QueryClientProvider>,
  );
  return { invalidate };
}

const card = () => screen.queryByTestId("parcours-quick-pick");

describe("quête — carte de classe d'un élève sans parcours (é38 lot 2)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.sessionStorage.clear();
    useMyRole.mockReturnValue(NEW_STUDENT);
    getExerciseParcours.mockResolvedValue(NEUVIEME);
    setCurrentParcours.mockResolvedValue({ ok: true });
    claimWelcomePack.mockResolvedValue({ granted: true, coins: 50 });
    hasActiveParentLink.mockResolvedValue(false);
  });

  it("é40 lot 5 — « un parent est-il déjà lié ? » se lit PENDANT la quête d'un élève", async () => {
    renderPage();
    await waitFor(() => expect(hasActiveParentLink).toHaveBeenCalledTimes(1));
  });

  it.each(["parent", "admin"])(
    "é40 lot 5 — un %s n'a pas de code : rien n'est lu",
    async (role) => {
      useMyRole.mockReturnValue({ ...NEW_STUDENT, role });
      renderPage();
      await Promise.resolve();
      expect(hasActiveParentLink).not.toHaveBeenCalled();
    },
  );

  it("joue la quête ET propose la classe du chapitre à un élève sans parcours", async () => {
    renderPage();
    // Le lecteur est là d'emblée : il n'attend ni la carte ni le choix.
    expect(screen.getByTestId("exercise-player")).toHaveTextContent(EXERCISE_ID);
    expect(
      await screen.findByText("Ce chapitre est en 9ème année — c'est ta classe ?"),
    ).toBeInTheDocument();
    expect(getExerciseParcours).toHaveBeenCalledWith({ data: { exerciseId: EXERCISE_ID } });
  });

  it.each([
    ["un élève qui a déjà sa classe", { ...NEW_STUDENT, currentParcoursId: "ecole-6eme" }],
    ["un parent", { ...NEW_STUDENT, role: "parent" }],
    ["un admin", { ...NEW_STUDENT, role: "admin" }],
    ["un profil pas encore lu", { ...NEW_STUDENT, isLoaded: false }],
    ["un compte sans ligne de profil", { ...NEW_STUDENT, role: null, hasProfile: false }],
  ])("ne lit même pas le parcours pour %s", async (_label, me) => {
    useMyRole.mockReturnValue(me);
    renderPage();
    expect(screen.getByTestId("exercise-player")).toBeInTheDocument();
    // Un tour de boucle : une requête active serait partie.
    await Promise.resolve();
    expect(getExerciseParcours).not.toHaveBeenCalled();
    expect(card()).toBeNull();
  });

  it("ne montre pas de carte quand le chapitre n'a pas de parcours — la quête se joue", async () => {
    getExerciseParcours.mockResolvedValue(null);
    renderPage();
    await waitFor(() => expect(getExerciseParcours).toHaveBeenCalled());
    expect(card()).toBeNull();
    expect(screen.getByTestId("exercise-player")).toBeInTheDocument();
  });

  it("« Choisir » adopte la classe comme l'assistant : parcours, pack de bienvenue, mesure", async () => {
    const { invalidate } = renderPage();
    fireEvent.click(await screen.findByRole("button", { name: "Choisir" }));

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("onboarding_completed", {
        intent: "unknown",
        source: "quest_card",
      }),
    );
    expect(setCurrentParcours).toHaveBeenCalledWith({ data: { parcoursId: "ecole-9eme" } });
    expect(claimWelcomePack).toHaveBeenCalledTimes(1);
    expect(toastSuccess).toHaveBeenCalledWith("C'est parti ! +50 pièces de bienvenue");
    // Le rôle relu ferme la porte de l'assistant pour de bon ; le tableau de bord
    // et le sélecteur de parcours voient la classe neuve.
    for (const key of ["dashboard", "me-role", "me-parcours"]) {
      expect(invalidate).toHaveBeenCalledWith({ queryKey: [key] });
    }
    await waitFor(() => expect(card()).toBeNull());
    expect(screen.getByTestId("exercise-player")).toBeInTheDocument();
  });

  // Le pack est idempotent côté SQL : un élève qui l'a déjà reçu ne le revoit pas.
  it("n'annonce pas de pièces quand le pack de bienvenue a déjà été versé", async () => {
    claimWelcomePack.mockResolvedValue({ granted: false, coins: 0 });
    renderPage();
    fireEvent.click(await screen.findByRole("button", { name: "Choisir" }));
    await waitFor(() => expect(toastSuccess).toHaveBeenCalledWith("C'est parti !"));
  });

  it("un pack de bienvenue en échec ne défait pas le choix de la classe", async () => {
    claimWelcomePack.mockRejectedValue(new Error("réseau"));
    renderPage();
    fireEvent.click(await screen.findByRole("button", { name: "Choisir" }));

    await waitFor(() => expect(toastSuccess).toHaveBeenCalledWith("C'est parti !"));
    expect(trackProductEvent).toHaveBeenCalledTimes(1);
    expect(toastError).not.toHaveBeenCalled();
    expect(card()).toBeNull();
  });

  it("un enregistrement qui échoue le dit, ne mesure rien et laisse la carte", async () => {
    setCurrentParcours.mockRejectedValue(new Error("réseau"));
    renderPage();
    fireEvent.click(await screen.findByRole("button", { name: "Choisir" }));

    await waitFor(() =>
      expect(toastError).toHaveBeenCalledWith("Impossible d'enregistrer ton parcours. Réessaie."),
    );
    expect(claimWelcomePack).not.toHaveBeenCalled();
    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(card()).not.toBeNull();
    expect(screen.getByRole("button", { name: "Choisir" })).toBeEnabled();
  });

  it("« Plus tard » ferme la carte sans rien enregistrer, pour toute la session", async () => {
    const first = renderPage();
    fireEvent.click(await screen.findByRole("button", { name: "Plus tard" }));
    expect(card()).toBeNull();
    expect(setCurrentParcours).not.toHaveBeenCalled();
    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(first.invalidate).not.toHaveBeenCalled();

    // Une autre quête dans la même session de navigation : pas de relance.
    getExerciseParcours.mockClear();
    renderPage();
    await Promise.resolve();
    expect(getExerciseParcours).not.toHaveBeenCalled();
    expect(screen.queryAllByTestId("parcours-quick-pick")).toHaveLength(0);
  });
});
