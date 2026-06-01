export type BaseOption = { id: string; text: string };
export type DisplayOption = BaseOption & { displayId: string };

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
