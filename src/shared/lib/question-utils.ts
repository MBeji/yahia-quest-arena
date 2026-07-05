export type BaseOption = { id: string; text: string };
export type DisplayOption = BaseOption & { displayId: string };

/**
 * Split a `matching` question's options into the fixed (left, `l…` ids) and
 * movable (right, `r…` ids) columns — the id-prefix convention of the Tier-B
 * data model (docs/interactive-question-types.md).
 */
export function splitMatchingOptions<T extends BaseOption>(
  options: T[],
): { lefts: T[]; rights: T[] } {
  return {
    lefts: options.filter((o) => o.id.startsWith("l")),
    rights: options.filter((o) => o.id.startsWith("r")),
  };
}

const DISPLAY_LABELS = ["A", "B", "C", "D", "E", "F"] as const;

/** Fisher-Yates shuffle + apply A/B/C/D display labels */
export function shuffleOptions(options: BaseOption[]): DisplayOption[] {
  const shuffled = [...options];
  for (let i = shuffled.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }

  return shuffled.map((opt, index) => ({
    ...opt,
    displayId: DISPLAY_LABELS[index] ?? String(index + 1),
  }));
}
