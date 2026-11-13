// @vitest-environment node
import { describe, expect, it, vi } from "vitest";
import { shareFamilyReport } from "../report-share";

/**
 * Étude 40, lot 4 (R-18) — le geste « Partager le bilan » des deux écrans parents, FIXÉ tel qu'il
 * était avant de passer par `shareText` :
 *
 *   if (navigator.share) { navigator.share({ text }).catch(() => {}); return; }
 *   window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, "_blank", "noopener,noreferrer");
 */
describe("shareFamilyReport — le comportement historique des bilans parents", () => {
  const text = "📋 Bilan de la semaine\n⭐ Yahia — 12 exercices · 82%";

  it("avec une feuille de partage : elle seule, avec le texte", async () => {
    const share = vi.fn().mockResolvedValue(undefined);
    const open = vi.fn();
    await shareFamilyReport(text, { share, open });
    expect(share).toHaveBeenCalledWith({ text });
    expect(open).not.toHaveBeenCalled();
  });

  it("feuille fermée ou refusée : avalé, et RIEN d'autre ne s'ouvre", async () => {
    for (const error of [Object.assign(new Error("x"), { name: "AbortError" }), new Error("x")]) {
      const share = vi.fn().mockRejectedValue(error);
      const open = vi.fn();
      const writeText = vi.fn();
      await expect(shareFamilyReport(text, { share, open, writeText })).resolves.toBe("none");
      expect(open).not.toHaveBeenCalled();
      expect(writeText).not.toHaveBeenCalled();
    }
  });

  it("sans feuille de partage : WhatsApp web, sans destinataire, texte encodé", async () => {
    const open = vi.fn();
    const writeText = vi.fn();
    await shareFamilyReport(text, { open, writeText });
    expect(open).toHaveBeenCalledWith(`https://wa.me/?text=${encodeURIComponent(text)}`);
    expect(writeText).not.toHaveBeenCalled();
  });

  it("jamais de copie : ces écrans n'ont pas de confirmation à montrer", async () => {
    const writeText = vi.fn();
    await expect(shareFamilyReport(text, { writeText })).resolves.toBe("none");
    expect(writeText).not.toHaveBeenCalled();
  });
});
