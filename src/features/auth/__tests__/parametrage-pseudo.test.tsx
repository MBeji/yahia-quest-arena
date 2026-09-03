import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi, beforeAll, beforeEach } from "vitest";
import React from "react";

/**
 * The rename row of « Mon compte » (/parametrage). Captured from the route's
 * `createFileRoute` call and rendered in isolation, like the other route tests.
 *
 * The regression worth a net here is NOT the input — it is the two cache keys. The
 * pseudo is read from `me-role` on this page, and from the full profile under
 * `dashboard` by BOTH the hall and the Shop; invalidating only the first leaves the
 * app showing two different names for the same user until the next reload.
 */
let captured: React.ComponentType | undefined;

const invalidateQueries = vi.fn();
const updateDisplayName = vi.fn();
const toastSuccess = vi.fn();
const toastError = vi.fn();
let displayName: string | null = "Yahia";

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: { component: React.ComponentType }) => {
    captured = opts.component;
    return {};
  },
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
  useNavigate: () => vi.fn(),
}));

vi.mock("@tanstack/react-query", () => ({
  useQuery: () => ({ data: undefined }),
  useQueryClient: () => ({ invalidateQueries }),
  // é31 lot 3 : le choix de l'objectif du jour, monté sur la même page, écrit par
  // une mutation. Le stub la neutralise — ce fichier teste le pseudo.
  useMutation: () => ({ mutate: vi.fn(), isPending: false }),
}));

// `createMiddleware`/`createServerFn` are stubbed too, not just `useServerFn`: the
// real auth barrel is imported below (for the real validation), and it pulls
// `auth.server.ts` → the auth middleware, which calls both at module load.
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: () => vi.fn(),
    };
    return chain;
  },
}));

vi.mock("sonner", () => ({ toast: { success: toastSuccess, error: toastError } }));

vi.mock("@/components/ui/page-shell", () => ({
  PageShell: ({ children }: { children: React.ReactNode }) =>
    React.createElement("main", null, children),
}));

vi.mock("@/components/ui/settings-controls", () => ({
  ThemeChoice: () => null,
  LocaleChoice: () => null,
  SoundToggles: () => null,
}));

// `usePush` depuis é11 lot 3 : la page lit l'état du push pour décider si elle
// propose le rappel du tuteur. `unsupported` ⇒ la carte se cache, et ce test-ci
// ne parle que du pseudo.
vi.mock("@/features/notifications", () => ({
  EnablePushCard: () => null,
  usePush: () => ({ state: "unsupported", busy: false, enable: vi.fn(), disable: vi.fn() }),
}));
vi.mock("@/features/tutor/components/tutor-plan-push-card", () => ({
  TutorPlanPushCard: () => null,
}));
// é31 lot 3 : la page porte désormais le choix de l'objectif du jour, qui lit et
// écrit par la feature `dashboard`. Le mock la couvre pour que ce test reste
// centré sur le pseudo.
vi.mock("@/features/dashboard", () => ({
  getParcours: vi.fn(),
  getDailyRing: vi.fn(() => Promise.resolve({ xpToday: 0, goal: 100, canChange: true })),
  setDailyXpGoal: vi.fn(),
  DAILY_XP_GOALS: [50, 100, 200] as const,
  DAILY_GOAL_ALREADY_SET: "DAILY_GOAL_ALREADY_SET_TODAY",
}));
vi.mock("@/features/parent-report", () => ({ formatStudentAllianceCode: () => "" }));
vi.mock("@/shared/lib/parcours-locale", () => ({ parcoursName: () => "" }));
vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: { auth: { signOut: vi.fn(), resetPasswordForEmail: vi.fn() } },
}));

// The VALIDATION stays real — the whole point of the disabled Save button is that
// the page and the server fn refuse exactly the same pseudos. Only the hooks and
// the write itself are faked.
vi.mock("@/features/auth", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/features/auth")>();
  return {
    ...actual,
    useAuth: () => ({ user: { id: "user-123", email: "y@example.com" } }),
    useMyRole: () => ({ role: "student", currentParcoursId: null, displayName }),
    updateDisplayName,
  };
});

vi.mock("@/lib/i18n", () => ({
  useI18n: () => ({ locale: "fr" }),
  useT: () => ({
    settings: {
      title: "Paramétrage",
      subtitle: "",
      accountTitle: "Mon compte",
      accountDesc: "",
      email: "Adresse e-mail",
      avatar: "Avatar",
      avatarAction: "Choisir",
      password: "Mot de passe",
      passwordAction: "Recevoir un lien",
      passwordSent: "",
      passwordError: "",
      pseudoAction: "Changer",
      pseudoSave: "Enregistrer",
      pseudoCancel: "Annuler",
      pseudoSaved: "Te voilà renommé.",
      pseudoError: "Le changement a échoué.",
      pseudoRule: "De 1 à {max} caractères, sans symboles invisibles.",
      parcoursTitle: "Mon parcours",
      parcoursDesc: "",
      parcoursCurrent: "Parcours actif",
      parcoursNone: "Aucun",
      parcoursChange: "Changer de parcours",
      displayTitle: "Affichage",
      displayDesc: "",
      soundTitle: "Sons",
      soundDesc: "",
      helpTitle: "Aide",
      helpDesc: "",
      helpTerms: "Conditions",
      helpPrivacy: "Confidentialité",
      allianceCode: "Code",
      allianceCopy: "Copier",
      allianceCopied: "Copié",
      allianceHint: "Partage ce code avec ton parent.",
    },
    layout: { signOut: "Déconnexion", logoutToast: "" },
    auth: { heroNameLabel: "Prénom ou pseudo" },
    // é31 lot 3 : le choix de l'objectif du jour vit dans la section « Affichage ».
    dashboard: {
      dailyGoalChoose: "Ton objectif du jour",
      dailyGoalChooseHint: "",
      dailyGoalAlreadySet: "",
      dailyGoalSaved: "",
    },
    errors: { errorFallback: "" },
  }),
}));

/**
 * Charger le module de route est une COMPILATION, pas une assertion : le premier
 * `import()` transforme et évalue tout le graphe de la route. C'est le poste le
 * plus lourd du fichier, il est payé UNE fois, et il n'a rien à faire dans le
 * budget d'un test.
 *
 * Il y était : `renderParametrage()` l'appelait, donc le PREMIER test payait la
 * compilation en plus de son rendu. Sur un poste Windows chargé (`maxWorkers: 2`,
 * mémoire disputée) ça a franchi les 15 s du `testTimeout` global et fait échouer
 * un `git push` le 2026-08-26 — sur une branche qui ne touchait ni ce fichier, ni
 * l'auth, ni l'i18n. Toujours par TIMEOUT, jamais par assertion ; vert en isolation
 * (6 s) comme en CI.
 *
 * Le sortir dans un `beforeAll` doté de son propre budget sépare les deux horloges :
 * la compilation a le temps qu'il lui faut, les tests gardent les 15 s — qui
 * suffisent très largement à ce qu'ils mesurent vraiment. Hausser `testTimeout`
 * aurait déplacé le plafond sans traiter la cause, que `vitest.config.ts` nomme
 * déjà pour la classe entière (« the first-import transform/eval of a whole feature
 * graph counts against the test budget »).
 */
beforeAll(async () => {
  await import("@/routes/_authenticated/parametrage");
}, 60_000);

function renderParametrage() {
  if (!captured) throw new Error("ParametragePage not captured");
  return render(React.createElement(captured));
}

beforeEach(() => {
  invalidateQueries.mockReset();
  updateDisplayName.mockReset().mockResolvedValue({ displayName: "Yahia le Brave" });
  toastSuccess.mockReset();
  toastError.mockReset();
  displayName = "Yahia";
});

describe("/parametrage — renaming yourself", () => {
  it("shows the current pseudo and opens an input pre-filled with it", async () => {
    const user = userEvent.setup();
    renderParametrage();

    expect(screen.getByTestId("settings-pseudo").textContent).toBe("Yahia");

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    expect(screen.getByTestId("settings-pseudo-input")).toHaveValue("Yahia");
  });

  it("saves the new pseudo and refreshes BOTH surfaces that show it", async () => {
    const user = userEvent.setup();
    renderParametrage();

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    await user.clear(screen.getByTestId("settings-pseudo-input"));
    await user.type(screen.getByTestId("settings-pseudo-input"), "Yahia le Brave");
    await user.click(screen.getByTestId("settings-pseudo-save"));

    await waitFor(() =>
      expect(updateDisplayName).toHaveBeenCalledWith({ data: { displayName: "Yahia le Brave" } }),
    );
    expect(invalidateQueries).toHaveBeenCalledWith({ queryKey: ["me-role", "user-123"] });
    expect(invalidateQueries).toHaveBeenCalledWith({ queryKey: ["dashboard"] });
    await waitFor(() => expect(toastSuccess).toHaveBeenCalledWith("Te voilà renommé."));
    await waitFor(() => expect(screen.queryByTestId("settings-pseudo-input")).toBeNull());
  });

  it("refuses to send a pseudo the server fn would reject anyway", async () => {
    const user = userEvent.setup();
    renderParametrage();

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    await user.clear(screen.getByTestId("settings-pseudo-input"));

    expect(screen.getByTestId("settings-pseudo-save")).toBeDisabled();
    await user.click(screen.getByTestId("settings-pseudo-save"));
    expect(updateDisplayName).not.toHaveBeenCalled();
  });

  it("cancels without writing anything", async () => {
    const user = userEvent.setup();
    renderParametrage();

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    await user.clear(screen.getByTestId("settings-pseudo-input"));
    await user.type(screen.getByTestId("settings-pseudo-input"), "Autre");
    await user.click(screen.getByTestId("settings-pseudo-cancel"));

    expect(updateDisplayName).not.toHaveBeenCalled();
    expect(screen.getByTestId("settings-pseudo").textContent).toBe("Yahia");
  });

  it("keeps the draft open when the write fails, instead of claiming success", async () => {
    updateDisplayName.mockRejectedValue(new Error("display_name_update_failed"));
    const user = userEvent.setup();
    renderParametrage();

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    await user.clear(screen.getByTestId("settings-pseudo-input"));
    await user.type(screen.getByTestId("settings-pseudo-input"), "Yahia le Brave");
    await user.click(screen.getByTestId("settings-pseudo-save"));

    await waitFor(() => expect(toastError).toHaveBeenCalledWith("Le changement a échoué."));
    expect(toastSuccess).not.toHaveBeenCalled();
    expect(screen.getByTestId("settings-pseudo-input")).toHaveValue("Yahia le Brave");
  });

  it("falls back to a dash while the profile row has not loaded", async () => {
    displayName = null;
    renderParametrage();
    expect(screen.getByTestId("settings-pseudo").textContent).toBe("—");
  });
});
