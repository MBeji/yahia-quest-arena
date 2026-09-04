import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { renderHook, act } from "@testing-library/react";

const { mockEnsureFresh, mockReport } = vi.hoisted(() => ({
  mockEnsureFresh: vi.fn(),
  mockReport: vi.fn(),
}));
vi.mock("@/shared/integrations/supabase/session-freshness", () => ({
  ensureFreshSession: mockEnsureFresh,
}));
vi.mock("@/shared/lib/client-log", () => ({ reportClientError: mockReport }));

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

describe("soumission sous filet", () => {
  it("écrit la soumission AVANT toute tentative réseau", async () => {
    const { result } = mount();
    // L'ordre ne se vérifie qu'EN COURS D'ENVOI : après coup, la file est vide
    // dans les deux cas, et le test passerait même si on écrivait trop tard.
    let enFileAuMomentDeLEnvoi = -1;
    await act(() =>
      result.current.guardSubmit(SESSION, { sessionId: SESSION, answers: [] }, async () => {
        enFileAuMomentDeLEnvoi = pendingCount();
        expect(pending()[0].kind).toBe("quest.submit");
        return "ok";
      }),
    );

    expect(enFileAuMomentDeLEnvoi).toBe(1);
  });

  it("rafraîchit la session avant l'envoi", async () => {
    const { result } = mount();
    const ordre: string[] = [];
    mockEnsureFresh.mockImplementation(() => {
      ordre.push("jeton");
      return Promise.resolve("token");
    });

    await act(() =>
      result.current.guardSubmit(SESSION, {}, async () => {
        ordre.push("envoi");
        return "ok";
      }),
    );

    expect(ordre).toEqual(["jeton", "envoi"]);
  });

  it("envoie quand même si le rafraîchissement échoue", async () => {
    // Le serveur tranchera, et la file rattrapera son refus : un échec ici ne
    // doit surtout pas empêcher d'écrire le travail, ni de tenter.
    mockEnsureFresh.mockRejectedValue(new Error("auth down"));
    const send = vi.fn().mockResolvedValue("ok");
    const { result } = mount();

    await act(() => result.current.guardSubmit(SESSION, {}, send));

    expect(send).toHaveBeenCalledTimes(1);
  });

  it("sort l'item de la file et efface le brouillon une fois la copie rendue", async () => {
    const { result } = mount();
    act(() => result.current.markDirty());
    act(() => {
      window.dispatchEvent(new Event("pagehide"));
    });

    await act(() => result.current.guardSubmit(SESSION, {}, async () => "ok"));

    expect(pendingCount()).toBe(0);
    expect(loadDraft(EX, "classic")).toBeNull();
  });

  it("rend au lecteur exactement ce que l'envoi a rendu", async () => {
    const { result } = mount();
    const score = { scorePct: 80 };

    const rendu = await act(() => result.current.guardSubmit(SESSION, {}, async () => score));

    expect(rendu).toBe(score);
  });

  it("ne met rien en file dans le registre anonyme, et envoie quand même", async () => {
    const send = vi.fn().mockResolvedValue("ok");
    const { result } = mount({ enabled: false });

    await act(() => result.current.guardSubmit(SESSION, {}, send));

    expect(pendingCount()).toBe(0);
    expect(mockEnsureFresh).not.toHaveBeenCalled();
    expect(send).toHaveBeenCalledTimes(1);
  });
});

// =============================================================================
// LA SOUMISSION QUI N'ABOUTIT PAS — la panne du 2026-09-03.
//
// Une mission validée qui ne s'enregistre pas se manifestait par un
// `toast.error` et rien d'autre : ni ligne en base, ni compteur, ni issue. Le
// lendemain, le suivi parental montrait « 0 exercice » pour une soirée que
// l'élève avait passée à répondre, et rien nulle part ne disait pourquoi.
// =============================================================================
describe("échec de soumission", () => {
  const echoue = (result: { current: ReturnType<typeof useQuestAutosave> }, error: Error) =>
    act(() =>
      result.current.guardSubmit(SESSION, {}, () => Promise.reject(error)).catch(() => null),
    );

  it("raconte l'échec à la boîte noire, sans jeter le travail", async () => {
    const { result } = mount();

    await echoue(result, new Error("Exercise has no questions"));

    expect(mockReport).toHaveBeenCalledWith({
      stage: "quest-submit",
      clientId: questOutboxClientId(SESSION),
      errMessage: "Exercise has no questions",
      payload: { variant: "classic", queued: true },
    });
    // L'item RESTE en file : `outbox.ts` le rejouera. Raconter n'est pas jeter.
    expect(pendingCount()).toBe(1);
    // Et le brouillon reste : la partie n'est pas finie tant qu'elle n'est pas passée.
    expect(result.current.status).toBe("pending");
  });

  it("laisse le refus d'AUTH à `outbox.ts` — le doubler fausserait ses seuils", async () => {
    // Là-bas le TTL du jeton est pris AVANT le rafraîchissement forcé ; ici il
    // serait celui du jeton neuf, et la mesure ne dirait plus rien de la panne.
    const { result } = mount();

    await echoue(result, new Error("Unauthorized: Invalid token"));

    expect(mockReport).not.toHaveBeenCalled();
    expect(pendingCount()).toBe(1);
  });

  it("propage l'erreur au lecteur — l'échec n'est jamais maquillé en réussite", async () => {
    const { result } = mount();

    await expect(
      act(() => result.current.guardSubmit(SESSION, {}, () => Promise.reject(new Error("boom")))),
    ).rejects.toThrow("boom");
  });

  it("raconte aussi l'échec du registre anonyme, en disant qu'il n'est pas en file", async () => {
    // Rien ne le rejouera : sa partie est perdue pour de bon. Raison de plus
    // pour que la panne, elle, soit connue.
    const { result } = mount({ enabled: false });

    await echoue(result, new Error("boom"));

    expect(mockReport.mock.calls[0][0].payload).toEqual({ variant: "classic", queued: false });
  });
});

describe("statut affiché", () => {
  it("passe de idle à pending puis saved", async () => {
    const { result } = mount();
    expect(result.current.status).toBe("idle");

    await act(() =>
      result.current.guardSubmit(SESSION, {}, async () => {
        // En vol : le travail est en file, l'indicateur doit le dire.
        expect(pendingCount()).toBe(1);
        return "ok";
      }),
    );

    expect(result.current.status).toBe("saved");
  });
});
