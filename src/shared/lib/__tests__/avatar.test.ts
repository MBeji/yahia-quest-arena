import { describe, it, expect } from "vitest";
import { avatarEmojiForSlug } from "../avatar";

describe("avatarEmojiForSlug", () => {
  it("maps each seeded skin slug to its emoji glyph", () => {
    expect(avatarEmojiForSlug("samurai")).toBe("⚔️");
    expect(avatarEmojiForSlug("samurai-neon")).toBe("⚔️");
    expect(avatarEmojiForSlug("ninja")).toBe("🥷");
    expect(avatarEmojiForSlug("mage")).toBe("🧙");
    expect(avatarEmojiForSlug("dragon")).toBe("🐲");
    expect(avatarEmojiForSlug("pharaoh")).toBe("👑");
  });

  it("returns null when no skin is equipped (null/undefined/empty)", () => {
    expect(avatarEmojiForSlug(null)).toBeNull();
    expect(avatarEmojiForSlug(undefined)).toBeNull();
    expect(avatarEmojiForSlug("")).toBeNull();
  });

  it("returns null for an unknown slug", () => {
    expect(avatarEmojiForSlug("wizard-of-oz")).toBeNull();
  });
});
