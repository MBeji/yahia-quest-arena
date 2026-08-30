import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { renderHook, act } from "@testing-library/react";

const { mockEnsureFresh } = vi.hoisted(() => ({ mockEnsureFresh: vi.fn() }));
vi.mock("@/shared/integrations/supabase/session-freshness", () => ({
  ensureFreshSession: mockEnsureFresh,
}));

import {
  QUEST_SNAPSHOT_INTERVAL_MS,
  useQuestAutosave,
} from "@/features/quest/components/use-quest-autosave";
import { loadDraft, questOutboxClientId } from "@/features/quest/quest-draft";
import { clearOutboxForTests, pending, pendingCount } from "@/shared/lib/outbox";

const EX = "11111111-1111-4111-8111-111111111111";
const SESSION = "s-1";

/**
 * Le hook tel que le lecteur l'appelle, avec une réponse déjà donnée : sans
 * réponse, il n'y a par construction rien à sauvegarder.
 */
function mount(overrides: Partial<Parameters<typeof useQuestAutosave>[0]> = {}) {
  return renderHook(() =>
    useQuestAutosave({
      exerciseId: EX,
      variant: "classic",
      enabled: true,
      sessionId: SESSION,
      answers: [{ questionId: "q1", choice: "a" }],
      idx: 1,
      ...overrides,
    }),
  );
}

beforeEach(() => {
  localStorage.clear();
  clearOutboxForTests();
  vi.clearAllMocks();
  mockEnsureFresh.mockResolvedValue("token");
});

afterEach(() => {
  vi.useRealTimers();
  vi.restoreAllMocks();
  clearOutboxForTests();
});

describe("instantané local", () => {
  it("n'écrit rien tant qu'aucune réponse n'a changé", () => {
    vi.useFakeTimers();
    mount();

    act(() => vi.advanceTimersByTime(QUEST_SNAPSHOT_INTERVAL_MS * 3));

    // Sans `markDirty`, il n'y a rien de neuf : réécrire à l'identique toutes
    // les 20 s ne protégerait de rien et userait le stockage pour rien.
    expect(loadDraft(EX, "classic")).toBeNull();
  });

  it("prend un instantané périodique dès qu'une réponse a changé", () => {
    vi.useFakeTimers();
    const { result } = mount();

    act(() => result.current.markDirty());
    act(() => vi.advanceTimersByTime(QUEST_SNAPSHOT_INTERVAL_MS));

    const draft = loadDraft(EX, "classic");
    expect(draft?.answers).toEqual([{ questionId: "q1", choice: "a" }]);
    expect(draft?.sessionId).toBe(SESSION);
  });

  it("écrit à la fermeture de l'onglet, sans attendre l'intervalle", () => {
    // `pagehide` est le signal qui compte sur mobile : c'est celui qui survit
    // quand le système tue l'onglet, là où `beforeunload` est sauté.
    const { result } = mount();
    act(() => result.current.markDirty());

    act(() => {
      window.dispatchEvent(new Event("pagehide"));
    });

    expect(loadDraft(EX, "classic")?.answers).toHaveLength(1);
  });

  it("écrit quand l'onglet passe en arrière-plan", () => {
    const { result } = mount();
    act(() => result.current.markDirty());
    vi.spyOn(document, "visibilityState", "get").mockReturnValue("hidden");

    act(() => {
      document.dispatchEvent(new Event("visibilitychange"));
    });

    expect(loadDraft(EX, "classic")?.answers).toHaveLength(1);
  });

  it("écrit au démontage — changer d'exercice est aussi une sortie", () => {
    const { result, unmount } = mount();
    act(() => result.current.markDirty());

    unmount();

    expect(loadDraft(EX, "classic")?.answers).toHaveLength(1);
  });

  it("ne sauvegarde rien dans le registre anonyme", () => {
    // `/exercice` joue sans compte : il n'a nulle part où resynchroniser, et son
    // score ne quitte pas le navigateur.
    const { result } = mount({ enabled: false });
    act(() => result.current.markDirty());

    act(() => {
      window.dispatchEvent(new Event("pagehide"));
    });

    expect(loadDraft(EX, "classic")).toBeNull();
  });
});

describe("mise en file de la soumission", () => {
  it("écrit la soumission AVANT toute tentative réseau", async () => {
    const { result } = mount();

    const clientId = await act(() =>
      result.current.beginSubmit(SESSION, { sessionId: SESSION, answers: [] }),
    );

    expect(clientId).toBe(questOutboxClientId(SESSION));
    expect(pendingCount()).toBe(1);
    expect(pending()[0].kind).toBe("quest.submit");
  });

  it("rafraîchit la session avant la mutation", async () => {
    const { result } = mount();

    await act(() => result.current.beginSubmit(SESSION, {}));

    expect(mockEnsureFresh).toHaveBeenCalledTimes(1);
  });

  it("met quand même en file si le rafraîchissement échoue", async () => {
    // Le serveur tranchera, et la file rattrapera son refus : un échec ici ne
    // doit surtout pas empêcher d'écrire le travail.
    mockEnsureFresh.mockRejectedValue(new Error("auth down"));
    const { result } = mount();

    await act(() => result.current.beginSubmit(SESSION, {}));

    expect(pendingCount()).toBe(1);
  });

  it("sort l'item de la file et efface le brouillon une fois la copie rendue", async () => {
    const { result } = mount();
    act(() => result.current.markDirty());
    act(() => {
      window.dispatchEvent(new Event("pagehide"));
    });

    const clientId = await act(() => result.current.beginSubmit(SESSION, {}));
    act(() => result.current.completeSubmit(clientId));

    expect(pendingCount()).toBe(0);
    expect(loadDraft(EX, "classic")).toBeNull();
  });

  it("ne met rien en file dans le registre anonyme", async () => {
    const { result } = mount({ enabled: false });

    await act(() => result.current.beginSubmit(SESSION, {}));

    expect(pendingCount()).toBe(0);
    expect(mockEnsureFresh).not.toHaveBeenCalled();
  });
});

describe("statut affiché", () => {
  it("passe de idle à pending puis saved", async () => {
    const { result } = mount();
    expect(result.current.status).toBe("idle");

    const clientId = await act(() => result.current.beginSubmit(SESSION, {}));
    expect(result.current.status).toBe("pending");

    act(() => result.current.completeSubmit(clientId));
    expect(result.current.status).toBe("saved");
  });
});
