import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi, beforeEach } from "vitest";
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
vi.mock("@/features/dashboard", () => ({ getParcours: vi.fn() }));
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
  }),
}));

async function renderParametrage() {
  await import("@/routes/_authenticated/parametrage");
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
    await renderParametrage();

    expect(screen.getByTestId("settings-pseudo").textContent).toBe("Yahia");

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    expect(screen.getByTestId("settings-pseudo-input")).toHaveValue("Yahia");
  });

  it("saves the new pseudo and refreshes BOTH surfaces that show it", async () => {
    const user = userEvent.setup();
    await renderParametrage();

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
    await renderParametrage();

    await user.click(screen.getByTestId("settings-pseudo-edit"));
    await user.clear(screen.getByTestId("settings-pseudo-input"));

    expect(screen.getByTestId("settings-pseudo-save")).toBeDisabled();
    await user.click(screen.getByTestId("settings-pseudo-save"));
    expect(updateDisplayName).not.toHaveBeenCalled();
  });

  it("cancels without writing anything", async () => {
    const user = userEvent.setup();
    await renderParametrage();

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
    await renderParametrage();

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
    await renderParametrage();
    expect(screen.getByTestId("settings-pseudo").textContent).toBe("—");
  });
});
