import { describe, it, expect } from "vitest";
import {
  DISPLAY_NAME_MAX_LENGTH,
  displayNameSchema,
  isValidDisplayName,
} from "@/features/auth/display-name";

/**
 * The pseudo rule, pinned on both sides.
 *
 * What matters most here is NOT that invisible characters are refused — it is that
 * the rule stays the SAME one signup enforces. A stricter settings screen would lock
 * an existing user out of renaming a pseudo the app itself accepted at signup.
 *
 * The invisible characters are BUILT from their codepoint rather than pasted in: a
 * test whose whole point is a character you cannot see must not hide it from its own
 * reader — and `harness:check` scans this repo for exactly these codepoints.
 */
const NUL = String.fromCharCode(0x00);
const NON_BREAKING_SPACE = String.fromCharCode(0x00a0);
const ZERO_WIDTH_SPACE = String.fromCharCode(0x200b);
const RIGHT_TO_LEFT_OVERRIDE = String.fromCharCode(0x202e);

describe("display name — the shared rule", () => {
  it("stores the trimmed value, so ' Yahia ' and 'Yahia' are one pseudo", () => {
    expect(displayNameSchema.parse("  Yahia  ")).toBe("Yahia");
  });

  it("accepts the three languages the product ships in", () => {
    for (const pseudo of ["Yahia", "Émile", "يحيى", "Ali 9raya", "élève-2"]) {
      expect(isValidDisplayName(pseudo)).toBe(true);
    }
  });

  it("refuses an empty pseudo, whitespace included", () => {
    expect(isValidDisplayName("")).toBe(false);
    expect(isValidDisplayName("   ")).toBe(false);
    // U+00A0 is whitespace to String.trim, so a pseudo made of non-breaking spaces
    // is empty too — it would otherwise render as a nameless row on the leaderboard.
    expect(isValidDisplayName(NON_BREAKING_SPACE.repeat(3))).toBe(false);
  });

  it("keeps the length bound signup has always enforced", () => {
    expect(DISPLAY_NAME_MAX_LENGTH).toBe(80);
    expect(isValidDisplayName("x".repeat(DISPLAY_NAME_MAX_LENGTH))).toBe(true);
    expect(isValidDisplayName("x".repeat(DISPLAY_NAME_MAX_LENGTH + 1))).toBe(false);
    // The bound applies AFTER trimming — padding is not length.
    expect(isValidDisplayName(`  ${"x".repeat(DISPLAY_NAME_MAX_LENGTH)}  `)).toBe(true);
  });

  it("refuses control characters, which would break every one-line surface", () => {
    expect(isValidDisplayName("Ya\nhia")).toBe(false);
    expect(isValidDisplayName("Ya\thia")).toBe(false);
    expect(isValidDisplayName(`Ya${NUL}hia`)).toBe(false);
  });

  it("refuses invisible formatting, so a pseudo cannot render as another name", () => {
    // Zero-width space: two visually identical pseudos, one impersonating the other.
    expect(isValidDisplayName(`Ya${ZERO_WIDTH_SPACE}hia`)).toBe(false);
    // Right-to-left override: the stored string and the rendered name differ.
    expect(isValidDisplayName(`Ya${RIGHT_TO_LEFT_OVERRIDE}hia`)).toBe(false);
  });
});
