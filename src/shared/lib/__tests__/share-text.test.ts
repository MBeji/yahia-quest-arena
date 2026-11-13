// @vitest-environment node
import { describe, expect, it, vi } from "vitest";
import { readEntrySource } from "../entry-source";
import {
  chapterShareUrl,
  fillShareTemplate,
  shareEnvFrom,
  shareText,
  whatsappUrl,
  type ShareEnv,
} from "../share-text";

/**
 * Étude 40, lot 4 — LE GESTE DE PARTAGE et le texte qu'il envoie. Chaque règle a son test nommé.
 */
const abort = () => Object.assign(new Error("fermée"), { name: "AbortError" });

function env(parts: Partial<Record<keyof ShareEnv, "ok" | "cancelled" | "broken">>) {
  const outcome = (kind: "ok" | "cancelled" | "broken") =>
    kind === "ok"
      ? vi.fn().mockResolvedValue(undefined)
      : vi.fn().mockRejectedValue(kind === "cancelled" ? abort() : new Error("refus"));
  const share = parts.share ? outcome(parts.share) : undefined;
  const writeText = parts.writeText ? outcome(parts.writeText) : undefined;
  const open = parts.open
    ? vi.fn((url: string) => {
        if (parts.open !== "ok") throw new Error(`fenêtre refusée : ${url}`);
      })
    : undefined;
  return { share, open, writeText };
}

describe("R-15 — la feuille de partage, à défaut WhatsApp, à défaut la copie", () => {
  it("R-15 : la feuille de partage du système d'abord, et rien d'autre", async () => {
    const e = env({ share: "ok", open: "ok", writeText: "ok" });
    expect(await shareText("texte", {}, e)).toBe("share");
    expect(e.share).toHaveBeenCalledWith({ text: "texte" });
    expect(e.open).not.toHaveBeenCalled();
    expect(e.writeText).not.toHaveBeenCalled();
  });

  it("R-15 : sans feuille de partage, wa.me SANS destinataire — le visiteur choisit", async () => {
    const e = env({ open: "ok", writeText: "ok" });
    expect(await shareText("📚 Les fractions : https://x.tn/a?b=1&c", {}, e)).toBe("whatsapp");
    const url = new URL(e.open!.mock.calls[0][0]);
    expect(url.origin + url.pathname).toBe("https://wa.me/");
    expect(url.searchParams.get("text")).toBe("📚 Les fractions : https://x.tn/a?b=1&c");
    expect(e.writeText).not.toHaveBeenCalled();
  });

  it("R-15 : ni l'un ni l'autre, la copie", async () => {
    const e = env({ writeText: "ok" });
    expect(await shareText("texte", {}, e)).toBe("copy");
    expect(e.writeText).toHaveBeenCalledWith("texte");
  });

  it("R-15 : une fenêtre refusée retombe sur la copie", async () => {
    expect(await shareText("texte", {}, env({ open: "broken", writeText: "ok" }))).toBe("copy");
  });

  it("R-15 : feuille FERMÉE par la personne — rien ne part, WhatsApp ne s'ouvre pas dans son dos", async () => {
    const e = env({ share: "cancelled", open: "ok", writeText: "ok" });
    expect(await shareText("texte", {}, e)).toBe("none");
    expect(e.open).not.toHaveBeenCalled();
    expect(e.writeText).not.toHaveBeenCalled();
  });

  it("R-15 : feuille qui échoue pour une autre raison — canal suivant", async () => {
    expect(await shareText("texte", {}, env({ share: "broken", open: "ok" }))).toBe("whatsapp");
  });

  it("R-15 : un appareil qui ne sait rien faire rend `none`, sans lever", async () => {
    expect(await shareText("texte", {}, {})).toBe("none");
    expect(await shareText("texte", {}, env({ writeText: "broken" }))).toBe("none");
    expect(await shareText("texte", {}, shareEnvFrom(undefined))).toBe("none");
  });

  it("R-15 : le lien WhatsApp encode tout le texte", () => {
    expect(whatsappUrl("a b&c=d #e")).toBe("https://wa.me/?text=a%20b%26c%3Dd%20%23e");
  });
});

describe("R-18 — une seule implémentation, les réglages des appelants historiques", () => {
  it("R-18 : `channels` restreint et ordonne les canaux", async () => {
    const e = env({ open: "ok", writeText: "ok" });
    expect(await shareText("texte", { channels: ["share", "copy"] }, e)).toBe("copy");
    expect(e.open).not.toHaveBeenCalled();
  });

  it("R-18 : `stop` — une feuille qui n'aboutit pas n'ouvre rien d'autre", async () => {
    const e = env({ share: "broken", open: "ok" });
    expect(await shareText("texte", { afterUnsharedSheet: "stop" }, e)).toBe("none");
    expect(e.open).not.toHaveBeenCalled();
  });

  it("R-18 : `next` — même une feuille fermée passe au canal suivant", async () => {
    const e = env({ share: "cancelled", writeText: "ok" });
    expect(
      await shareText("texte", { channels: ["share", "copy"], afterUnsharedSheet: "next" }, e),
    ).toBe("copy");
  });

  it("R-18 : `shareEnvFrom` appelle le navigateur comme les trois copies le faisaient", async () => {
    const share = vi.fn().mockResolvedValue(undefined);
    const writeText = vi.fn().mockResolvedValue(undefined);
    const open = vi.fn();
    const e = shareEnvFrom({ share, clipboard: { writeText } } as never, { open } as never);
    await e.share!({ text: "t" });
    e.open!("https://wa.me/?text=t");
    await e.writeText!("t");
    expect(share).toHaveBeenCalledWith({ text: "t" });
    expect(open).toHaveBeenCalledWith("https://wa.me/?text=t", "_blank", "noopener,noreferrer");
    expect(writeText).toHaveBeenCalledWith("t");
  });
});

describe("R-16 — le lien et le texte", () => {
  it("R-16 : l'adresse canonique `www` du CHAPITRE, avec sa source", () => {
    expect(chapterShareUrl("c-42", "resume_link")).toBe(
      "https://www.na9ranal3ab.tn/chapitre/c-42?src=resume_link",
    );
    expect(chapterShareUrl("c-42", "share")).toBe(
      "https://www.na9ranal3ab.tn/chapitre/c-42?src=share",
    );
  });

  it("R-16 : la source posée est une de celles que le lot 0 sait lire et retirer", () => {
    for (const source of ["resume_link", "share"] as const) {
      expect(readEntrySource(new URL(chapterShareUrl("c1", source)).search)).toBe(source);
    }
  });

  it("R-16 : un identifiant inattendu ne casse pas l'adresse", () => {
    expect(chapterShareUrl("a/b?c#d", "share")).toBe(
      "https://www.na9ranal3ab.tn/chapitre/a%2Fb%3Fc%23d?src=share",
    );
  });

  it("R-16 : le texte de reprise porte le chapitre, la matière et le lien", () => {
    expect(
      fillShareTemplate("📚 {chapter} — {subject}. Je reprends ici : {url}", {
        chapter: "Les fractions",
        subject: "Mathématiques",
        url: "https://www.na9ranal3ab.tn/chapitre/c1?src=resume_link",
      }),
    ).toBe(
      "📚 Les fractions — Mathématiques. Je reprends ici : https://www.na9ranal3ab.tn/chapitre/c1?src=resume_link",
    );
  });

  it("R-16 : le texte de réussite porte le score {bonnes}/{total}", () => {
    expect(
      fillShareTemplate(
        "✅ {chapter} — {correct}/{total} au quiz sur Na9ra Nal3ab. À toi : {url}",
        {
          chapter: "Les fractions",
          correct: 4,
          total: 5,
          url: "U",
        },
      ),
    ).toBe("✅ Les fractions — 4/5 au quiz sur Na9ra Nal3ab. À toi : U");
  });

  it("R-16 : sans matière connue, le tiret disparaît avec elle", () => {
    expect(
      fillShareTemplate("📚 {chapter} — {subject}. Je reprends ici : {url}", {
        chapter: "Les fractions",
        subject: null,
        url: "U",
      }),
    ).toBe("📚 Les fractions. Je reprends ici : U");
  });

  it("R-16 : un titre qui ressemble à un gabarit reste du texte", () => {
    expect(fillShareTemplate("{chapter} : {url}", { chapter: "{url} <b>$&</b>", url: "U" })).toBe(
      "{url} <b>$&</b> : U",
    );
  });
});
