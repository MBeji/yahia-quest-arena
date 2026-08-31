// jsdom (défaut) : `localStorage` est tout le sujet.
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  DRAFT_MAX_AGE_MS,
  clearDraft,
  loadDraft,
  questOutboxClientId,
  resumeFrom,
  saveDraft,
} from "@/features/quest/quest-draft";

const EX = "11111111-1111-4111-8111-111111111111";

beforeEach(() => {
  localStorage.clear();
});

afterEach(() => {
  vi.useRealTimers();
  vi.restoreAllMocks();
});

describe("questOutboxClientId", () => {
  it("derives the queue key from the session, the server's own idempotency key", () => {
    expect(questOutboxClientId("abc")).toBe("quest.submit:abc");
    // Deux appels pour la même session donnent la MÊME clé : c'est ce qui rend
    // une mise en file répétée incapable de créer deux envois.
    expect(questOutboxClientId("abc")).toBe(questOutboxClientId("abc"));
  });
});

describe("saveDraft / loadDraft", () => {
  it("round-trips a draft", () => {
    saveDraft(EX, "classic", {
      sessionId: "s1",
      answers: [{ questionId: "q1", choice: "a" }],
      idx: 1,
    });

    const draft = loadDraft(EX, "classic");
    expect(draft?.sessionId).toBe("s1");
    expect(draft?.answers).toEqual([{ questionId: "q1", choice: "a" }]);
    expect(draft?.idx).toBe(1);
  });

  it("keeps drafts of the same exercise apart by variant", () => {
    saveDraft(EX, "classic", {
      sessionId: "s1",
      answers: [{ questionId: "q1", choice: "a" }],
      idx: 1,
    });

    expect(loadDraft(EX, "recall")).toBeNull();
    expect(loadDraft(EX, "classic")).not.toBeNull();
  });

  it("writes nothing when there is no answer yet", () => {
    // Sinon on proposerait une reprise à qui vient d'ouvrir la mission.
    saveDraft(EX, "classic", { sessionId: "s1", answers: [], idx: 0 });

    expect(loadDraft(EX, "classic")).toBeNull();
  });

  it("discards a draft older than its shelf life", () => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-08-30T10:00:00Z"));
    saveDraft(EX, "classic", {
      sessionId: "s1",
      answers: [{ questionId: "q1", choice: "a" }],
      idx: 1,
    });

    vi.setSystemTime(new Date(Date.now() + DRAFT_MAX_AGE_MS + 1000));

    expect(loadDraft(EX, "classic")).toBeNull();
    // …et il est effacé au passage, pas seulement ignoré.
    expect(localStorage.length).toBe(0);
  });

  it("rejects a malformed draft rather than half-trusting it", () => {
    // Un brouillon douteux vaut moins qu'aucun brouillon : le croire ferait
    // reprendre des réponses qui ne sont pas celles de l'élève.
    localStorage.setItem(`nn:quest-draft:v1:${EX}:classic`, "{not json");
    expect(loadDraft(EX, "classic")).toBeNull();

    localStorage.setItem(
      `nn:quest-draft:v1:${EX}:classic`,
      JSON.stringify({ answers: [{ questionId: "q1" }], idx: 0, updatedAt: Date.now() }),
    );
    expect(loadDraft(EX, "classic")).toBeNull();
  });

  it("clears a draft on demand", () => {
    saveDraft(EX, "classic", {
      sessionId: "s1",
      answers: [{ questionId: "q1", choice: "a" }],
      idx: 1,
    });
    clearDraft(EX, "classic");

    expect(loadDraft(EX, "classic")).toBeNull();
  });

  it("never throws when the storage refuses to write", () => {
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new Error("QuotaExceededError");
    });

    expect(() =>
      saveDraft(EX, "classic", {
        sessionId: "s1",
        answers: [{ questionId: "q1", choice: "a" }],
        idx: 0,
      }),
    ).not.toThrow();
  });
});

describe("resumeFrom", () => {
  const served = ["q1", "q2", "q3"];

  it("resumes at the first UNANSWERED question, whatever the stored index said", () => {
    const { answers, idx } = resumeFrom(served, [
      { questionId: "q1", choice: "a" },
      { questionId: "q2", choice: "b" },
    ]);

    expect(answers).toHaveLength(2);
    expect(idx).toBe(2);
  });

  it("survives a reordering of the served questions", () => {
    // L'élève avait répondu à q3 ; au rechargement, les questions sortent dans
    // un autre ordre. Un index conservé aurait désigné une autre question.
    const { answers, idx } = resumeFrom(["q3", "q1", "q2"], [{ questionId: "q3", choice: "c" }]);

    expect(answers).toEqual([{ questionId: "q3", choice: "c" }]);
    expect(idx).toBe(1);
  });

  it("drops an answer whose question is no longer served", () => {
    const { answers, idx } = resumeFrom(served, [
      { questionId: "gone", choice: "x" },
      { questionId: "q1", choice: "a" },
    ]);

    expect(answers).toEqual([{ questionId: "q1", choice: "a" }]);
    expect(idx).toBe(1);
  });

  it("deduplicates repeated answers for one question", () => {
    // Sinon la réponse partirait en double dans le payload de soumission.
    const { answers } = resumeFrom(served, [
      { questionId: "q1", choice: "a" },
      { questionId: "q1", choice: "b" },
    ]);

    expect(answers).toEqual([{ questionId: "q1", choice: "a" }]);
  });

  it("reports a complete run by pointing past the last question", () => {
    // Le lecteur s'en sert pour NE PAS reprendre : la partie était finie, seule
    // la soumission a échoué, et elle est déjà en file.
    const { idx } = resumeFrom(served, [
      { questionId: "q1", choice: "a" },
      { questionId: "q2", choice: "b" },
      { questionId: "q3", choice: "c" },
    ]);

    expect(idx).toBe(served.length);
  });
});
