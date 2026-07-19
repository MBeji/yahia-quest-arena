import type { SupabaseClient } from "@supabase/supabase-js";
import { compiledVideoSchema, type CompiledVideo } from "@/shared/content/schema";

/**
 * Correction-video resolution for the result screen (étude 23 R-6).
 *
 * Kept out of `quest.server.ts` so the rule stays unit-testable on its own and
 * the server module stays within its size budget.
 */

/**
 * Validate an untrusted compiled-video payload before it reaches the client
 * (defense in depth — étude 23 D-10). The JSONB columns are written by the
 * content pipeline, but a malformed/legacy row must degrade to "no video",
 * never to a half-built embed.
 */
export function parseCompiledVideo(value: unknown): CompiledVideo | null {
  const parsed = compiledVideoSchema.safeParse(value);
  return parsed.success ? parsed.data : null;
}

/**
 * Resolve the video offered on a failed exercise/quiz result screen (R-6):
 * the exercise's own `correction_video` when it declares one, else the FIRST
 * video of its chapter, else nothing. Resolved server-side (never computed on
 * the client from data it does not hold) and shared by the connected and
 * anonymous players, which both read the exercise through `getExercise`.
 */
export async function resolveCorrectionVideo(
  supabase: SupabaseClient,
  exercise: unknown,
): Promise<CompiledVideo | null> {
  const row = exercise as { correction_video?: unknown; chapter_id?: string | null } | null;

  // The exercise's dedicated video wins — no chapter round-trip needed.
  const own = parseCompiledVideo(row?.correction_video);
  if (own) return own;

  const chapterId = row?.chapter_id ?? null;
  if (!chapterId) return null;

  const { data } = await supabase.from("chapters").select("videos").eq("id", chapterId).single();
  const videos = (data as { videos?: unknown } | null)?.videos;
  return Array.isArray(videos) ? parseCompiledVideo(videos[0]) : null;
}
