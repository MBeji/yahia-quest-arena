/** Minimal shapes needed to order exercises within a subject. */
type ChapterLike = { id: string; display_order: number | null };
type ExerciseLike = { id: string; chapter_id: string; display_order: number | null; mode: string };

/**
 * The next *playable* exercise (quizzes excluded) after `current`, ordered by
 * chapter display order then exercise display order. When `current` is a quiz,
 * returns the first playable exercise of its chapter. Returns null if there is
 * no next exercise.
 */
export function computeNextExerciseId(
  chapters: ChapterLike[],
  exercises: ExerciseLike[],
  current: { id: string; chapter_id: string; mode: string },
): string | null {
  const chapterOrder = new Map(chapters.map((c) => [c.id, c.display_order ?? 0]));
  const playable = exercises
    .filter((e) => e.mode !== "quiz")
    .slice()
    .sort(
      (a, b) =>
        (chapterOrder.get(a.chapter_id) ?? 0) - (chapterOrder.get(b.chapter_id) ?? 0) ||
        (a.display_order ?? 0) - (b.display_order ?? 0),
    );

  if (current.mode === "quiz") {
    return playable.find((e) => e.chapter_id === current.chapter_id)?.id ?? null;
  }
  const idx = playable.findIndex((e) => e.id === current.id);
  return idx === -1 ? null : (playable[idx + 1]?.id ?? null);
}
