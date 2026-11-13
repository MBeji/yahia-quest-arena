import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 40, lot 4 — LA RANGÉE « Garder ce chapitre », sur ses états : reprise seule, reprise +
 * réussite, échec ; et ce qu'elle envoie par chaque canal (R-15 à R-17).
 */
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

import { I18nProvider } from "@/lib/i18n";
import { STORAGE_KEY as LOCALE_KEY } from "@/lib/i18n/context";
import { arKeep } from "@/lib/i18n/keep/ar";
import { enKeep } from "@/lib/i18n/keep/en";
import { frKeep } from "@/lib/i18n/keep/fr";
import { KeepRow } from "../keep-row";

const CHAPTER_URL = "https://www.na9ranal3ab.tn/chapitre/c-1";

function mount(props: Partial<Parameters<typeof KeepRow>[0]> = {}) {
  return render(
    <I18nProvider>
      <KeepRow
        chapterId="c-1"
        chapterTitle="Les fractions"
        subjectName="Mathématiques"
        surface="practice"
        {...props}
      />
    </I18nProvider>,
  );
}

/** Pose (ou retire) les trois canaux de l'appareil. */
function device(parts: { share?: unknown; open?: unknown; writeText?: unknown }) {
  Object.defineProperty(navigator, "share", { value: parts.share, configurable: true });
  Object.defineProperty(navigator, "clipboard", {
    value: parts.writeText ? { writeText: parts.writeText } : undefined,
    configurable: true,
  });
  Object.defineProperty(window, "open", { value: parts.open, configurable: true, writable: true });
}

const originalOpen = window.open;

describe("KeepRow — les états de la rangée", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.localStorage.clear();
  });
  afterEach(() => device({ open: originalOpen }));

  it("US-7 — sans réussite : « M'envoyer la suite » seul, aucun champ de saisie", () => {
    const { container } = mount();
    expect(screen.getByRole("button", { name: frKeep.sendNext })).toBeInTheDocument();
    expect(screen.queryByTestId("keep-share-success")).not.toBeInTheDocument();
    expect(container.querySelector("input, textarea, select, form")).toBeNull();
  });

  it("US-8 — sur une réussite : « Partager ma réussite » en plus", () => {
    mount({ success: { correct: 4, total: 5 } });
    expect(screen.getByRole("button", { name: frKeep.sendNext })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: frKeep.shareSuccess })).toBeInTheDocument();
  });

  it("R-17 — un échec ne se partage pas", () => {
    mount({ success: null });
    expect(screen.queryByRole("button", { name: frKeep.shareSuccess })).not.toBeInTheDocument();
  });

  it("US-7 — en bas d'un cours, le geste se nomme « M'envoyer ce cours »", () => {
    mount({ surface: "reader" });
    expect(screen.getByRole("button", { name: frKeep.sendLesson })).toBeInTheDocument();
  });

  it("R-16 — la reprise par la feuille de partage : chapitre, matière, lien du CHAPITRE", async () => {
    const share = vi.fn().mockResolvedValue(undefined);
    device({ share });
    mount();
    fireEvent.click(screen.getByTestId("keep-send"));
    await waitFor(() => expect(trackProductEvent).toHaveBeenCalled());
    expect(share).toHaveBeenCalledWith({
      text: `📚 Les fractions — Mathématiques. Je reprends ici : ${CHAPTER_URL}?src=resume_link`,
    });
    expect(trackProductEvent).toHaveBeenCalledWith("content_shared", {
      intent: "resume",
      surface: "practice",
      method: "share",
    });
  });

  it("R-15 — sans feuille de partage : wa.me, sans destinataire", async () => {
    const open = vi.fn();
    device({ open });
    mount({ success: { correct: 4, total: 5 } });
    fireEvent.click(screen.getByTestId("keep-share-success"));
    await waitFor(() => expect(trackProductEvent).toHaveBeenCalled());
    const url = new URL(open.mock.calls[0][0] as string);
    expect(url.origin + url.pathname).toBe("https://wa.me/");
    expect(url.searchParams.get("text")).toBe(
      `✅ Les fractions — 4/5 au quiz sur Na9ra Nal3ab. À toi : ${CHAPTER_URL}?src=share`,
    );
    expect(trackProductEvent).toHaveBeenCalledWith("content_shared", {
      intent: "success",
      surface: "practice",
      method: "whatsapp",
    });
    expect(screen.getByTestId("keep-copied")).toHaveTextContent("");
  });

  it("R-15 — ni l'un ni l'autre : copie, et la rangée le confirme", async () => {
    const writeText = vi.fn().mockResolvedValue(undefined);
    device({ writeText });
    mount({ surface: "reader" });
    fireEvent.click(screen.getByTestId("keep-send"));
    await waitFor(() => expect(screen.getByRole("status")).toHaveTextContent(frKeep.copied));
    expect(writeText).toHaveBeenCalledWith(
      `📚 Les fractions — Mathématiques. Je reprends ici : ${CHAPTER_URL}?src=resume_link`,
    );
    expect(trackProductEvent).toHaveBeenCalledWith("content_shared", {
      intent: "resume",
      surface: "reader",
      method: "copy",
    });
  });

  it("feuille fermée par la personne : rien n'est parti, rien n'est compté", async () => {
    const share = vi.fn().mockRejectedValue(Object.assign(new Error("x"), { name: "AbortError" }));
    const open = vi.fn();
    device({ share, open });
    mount();
    fireEvent.click(screen.getByTestId("keep-send"));
    await waitFor(() => expect(share).toHaveBeenCalled());
    await Promise.resolve();
    expect(open).not.toHaveBeenCalled();
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("R-4 — la mesure ne porte ni titre, ni score, ni adresse : trois étiquettes fermées", async () => {
    device({ share: vi.fn().mockResolvedValue(undefined) });
    mount({ success: { correct: 4, total: 5 } });
    fireEvent.click(screen.getByTestId("keep-share-success"));
    await waitFor(() => expect(trackProductEvent).toHaveBeenCalled());
    const props = trackProductEvent.mock.calls[0][1] as Record<string, unknown>;
    expect(Object.keys(props).sort()).toEqual(["intent", "method", "surface"]);
    expect(JSON.stringify(props)).not.toMatch(/fractions|4|5|chapitre|c-1/i);
  });

  it("R-16 — le texte est dans la langue de l'INTERFACE, le titre tel qu'il est", async () => {
    window.localStorage.setItem(LOCALE_KEY, "ar");
    const share = vi.fn().mockResolvedValue(undefined);
    device({ share });
    mount({ chapterTitle: "الكسور", subjectName: "الرياضيات" });
    const row = await screen.findByTestId("keep-row");
    await waitFor(() => expect(row).toHaveAttribute("dir", "rtl"));
    fireEvent.click(screen.getByRole("button", { name: arKeep.sendNext }));
    await waitFor(() => expect(share).toHaveBeenCalled());
    expect(share.mock.calls[0][0].text).toBe(
      `📚 الكسور — الرياضيات. أواصل من هنا: ${CHAPTER_URL}?src=resume_link`,
    );
  });
});

describe("KeepRow — les trois catalogues", () => {
  it("R-17 — aucun gabarit ne porte de prénom, de pseudo ni de comparaison", () => {
    for (const copy of [frKeep, enKeep, arKeep]) {
      for (const template of [copy.resumeText, copy.successText]) {
        const slots = template.match(/\{[a-z]+\}/g) ?? [];
        expect(slots.every((s) => /^\{(chapter|subject|correct|total|url)\}$/.test(s))).toBe(true);
        expect(template).toContain("{chapter}");
        expect(template).toContain("{url}");
      }
      expect(copy.successText).toContain("{correct}/{total}");
      expect(`${copy.resumeText} ${copy.successText}`).not.toMatch(
        /mieux que|meilleur|classement|better than|rank|أفضل من|ترتيب/i,
      );
    }
  });
});
