import { describe, it, expect } from "vitest";

import { noXpReason } from "@/features/quest";

describe("noXpReason", () => {
  it("flags a too-fast attempt first (highest precedence)", () => {
    // Even with a passing, improved score, too-fast wins.
    const msg = noXpReason({ tooFast: true, scorePct: 90, improved: true });
    expect(msg).toContain("Trop rapide");
  });

  it("flags an under-threshold score (< 60%)", () => {
    const msg = noXpReason({ tooFast: false, scorePct: 50, improved: true });
    expect(msg).toContain("Sous 60");
  });

  it("flags a non-improved score (anti-farm)", () => {
    const msg = noXpReason({ tooFast: false, scorePct: 80, improved: false });
    expect(msg).toContain("Déjà maîtrisé");
  });

  it("returns at exactly the 60% threshold as not-under-threshold", () => {
    // 60% is a pass, so the reason must NOT be the under-60 branch.
    const msg = noXpReason({ tooFast: false, scorePct: 60, improved: false });
    expect(msg).toContain("Déjà maîtrisé");
  });

  it("has a generic fallback when no specific reason applies", () => {
    const msg = noXpReason({ tooFast: false, scorePct: 80, improved: true });
    expect(msg).toBe("Aucune XP gagnée cette fois.");
  });
});
