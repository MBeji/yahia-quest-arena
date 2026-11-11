// La lecture d'un chapitre — le cours, son résumé, ses vidéos, et les pages du
// manuel qu'il cite. Sorti de `quest.server.ts` (2026-10-30) pour la raison qui
// en a déjà sorti `quest.check.server` et `quest.progress.server` : le fichier
// était à 746 lignes de code pour un plafond de 750, et lire un chapitre n'a
// rien à voir avec jouer un exercice. Texte déplacé à l'identique.

import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { MIN_SECONDS_PER_QUESTION, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import type { CompiledVideo } from "@/shared/content/schema";
import { isUnrestrictedViewer } from "./quest.access";

// ---------- Get chapter lesson content ----------
/** Narrowed chapter row for the reader — adds the `videos` and `domain` columns the generated types lack. */
type ChapterLessonRow = {
  id: string;
  title: string;
  description: string | null;
  lesson_content: string | null;
  summary: string | null;
  subject_id: string;
  display_order: number;
  /**
   * Domaine du programme auquel ce chapitre appartient — la « section » de la
   * matière (Algèbre, Géométrie, قواعد اللغة…). NULL tant que le contenu ne l'a
   * pas rattaché : c'est l'état de tout le corpus au moment où la colonne arrive.
   */
  domain: string | null;
  videos: CompiledVideo[] | null;
  subjects: { grade_id?: string | null; name_fr: string; content_language?: string } | null;
};

export const getChapterLesson = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d) => z.object({ chapterId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const { data: chapterRow, error } = await supabase
      .from("chapters")
      .select(
        "id, title, description, lesson_content, summary, subject_id, display_order, domain, videos, subjects(id, name_fr, color_token, icon, content_language, grade_id)",
      )
      .eq("id", data.chapterId)
      .single();
    if (error) {
      failWithClientError("quest.getChapterLesson", error, "Impossible de charger la leçon.");
    }

    // Selecting the étude-23 `videos` column and `domain` (both absent from the
    // pre-existing generated types) makes the row loosely typed — narrow it once,
    // the same posture the joined `subjects` relation already uses. The compiled
    // `videos` JSONB (0–3 display objects) flows straight to the public reader,
    // and `domain` names the section of the program this chapter sits in.
    //
    // Cette liste de colonnes est EXPLICITE : elle exige que `domain` existe en
    // base. C'est pourquoi ce lot arrive APRÈS le merge de sa migration
    // (`20260818120000`, appliquée en prod le 2026-08-18) et non avec elle — le
    // hub, lui, lit `select("*")` et tolérait son absence (DoD §7).
    const chapter = chapterRow as unknown as ChapterLessonRow;
    const videos: CompiledVideo[] = chapter.videos ?? [];

    // Fetch all sibling chapters for navigation. We only need each sibling's
    // metadata + whether it HAS a lesson — never the lesson body itself. Pulling
    // `lesson_content` here shipped every sibling's full markdown over the wire
    // just to derive a boolean (a subject with N chapters × ~30 KB each). Split
    // into two tiny reads: the metadata for all siblings, and the id-only set of
    // those that actually carry a lesson.
    const [{ data: siblings }, { data: siblingsWithLesson }, unrestricted] = await Promise.all([
      supabase
        .from("chapters")
        .select("id, title, display_order")
        .eq("subject_id", chapter.subject_id)
        .order("display_order"),
      supabase
        .from("chapters")
        .select("id")
        .eq("subject_id", chapter.subject_id)
        .not("lesson_content", "is", null)
        // Preserve the old `!!lesson_content` semantics: an empty string is "no lesson".
        .neq("lesson_content", ""),
      isUnrestrictedViewer(supabase, userId),
    ]);

    const withLesson = new Set((siblingsWithLesson ?? []).map((s) => s.id));
    const allChapters = (siblings ?? []).map((s) => ({
      id: s.id,
      title: s.title,
      display_order: s.display_order,
      hasLesson: withLesson.has(s.id),
    }));

    // Target for the course reader's single « practise this chapter » CTA: the
    // chapter's first non-quiz exercise (real practice — the comprehension quiz
    // is the connected gate, not practice). null → nothing to practise → no CTA.
    // The reader links it auth-aware (signed-in → /quest, anon → /exercice).
    const { data: chapterExercises } = await supabase
      .from("exercises")
      .select("id, mode, display_order")
      .eq("chapter_id", data.chapterId)
      .order("display_order");
    const practiceExerciseId = (chapterExercises ?? []).find((e) => e.mode !== "quiz")?.id ?? null;

    // Quiz-gate affordance for the reader CTA (étude 15, lot 1 — audit §D-4): the
    // chapter's quiz id, whether the gate applies (school subjects only — same
    // rule as getSubject), and — signed-in only — whether THIS user already
    // passed it (score ≥ threshold AND not rushed, mirroring getSubject).
    // Anonymous visitors resolve their pass client-side (sessionStorage, see
    // anon-quiz-gate.ts), so quizPassed stays null for them.
    const quizExerciseId = (chapterExercises ?? []).find((e) => e.mode === "quiz")?.id ?? null;
    const isSchoolSubject =
      ((chapter.subjects as { grade_id?: string | null } | null)?.grade_id ?? null) !== null;
    const quizGated = isSchoolSubject && quizExerciseId !== null;
    let quizPassed: boolean | null = null;
    if (quizGated && userId && !unrestricted) {
      const { data: passedRows } = await supabase
        .from("attempts")
        .select("duration_seconds,total_count")
        .eq("user_id", userId)
        .eq("exercise_id", quizExerciseId as string)
        .gte("score_pct", QUIZ_PASS_THRESHOLD_PCT);
      quizPassed = (passedRows ?? []).some(
        (r) => (r.duration_seconds ?? 0) >= (r.total_count ?? 0) * MIN_SECONDS_PER_QUESTION,
      );
    }
    // Compte de test (admin) : la porte est franchie d'office (quest.access.ts).
    if (quizGated && unrestricted) quizPassed = true;

    return {
      chapter: { ...chapter, videos },
      allChapters,
      practiceExerciseId,
      quizExerciseId,
      quizGated,
      quizPassed,
    };
  });

// ---------- Manuel élève pages (login-gated) ----------

/** A single official-textbook page available to display under a chapter. */
export type ManuelPage = { page: number; url: string };

/** Private Storage bucket holding the watermarked manuel-élève page images. */
const MANUEL_PAGES_BUCKET = "manuel-pages";
/** Signed-URL lifetime — long enough to read the gallery, short enough to expire. */
const MANUEL_SIGNED_URL_TTL_SECONDS = 60 * 60;

/** Shape of `chapters.manuel_ref` we rely on (the build also stores `pages`). */
const manuelRefSchema = z.object({
  code: z.string().regex(/^[A-Za-z0-9_-]+$/),
  pageNumbers: z.array(z.number().int().positive()).min(1),
});

/**
 * Resolve the official student-textbook (manuel élève) pages for a chapter into
 * **signed URLs**, gated to authenticated users. Returns `{ pages: [] }` when the
 * chapter has no `manuel_ref`, the data is malformed, or signing fails — the UI
 * simply hides the « Pages du manuel » section. The images live in a private
 * bucket (RLS = authenticated read); URLs are minted with the caller's JWT, so
 * anonymous visitors can neither call this nor read the objects.
 */
export const getManuelPageUrls = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d) => z.object({ chapterId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<{ pages: ManuelPage[] }> => {
    const { supabase } = context;

    const { data: chapter, error } = await supabase
      .from("chapters")
      .select("manuel_ref")
      .eq("id", data.chapterId)
      .single();
    if (error || !chapter) {
      logger.warn("quest.getManuelPageUrls: chapter not found", { chapterId: data.chapterId });
      return { pages: [] };
    }

    const parsed = manuelRefSchema.safeParse(chapter.manuel_ref);
    if (!parsed.success) return { pages: [] }; // no manuel link (or malformed) → hide the section

    const { code, pageNumbers } = parsed.data;
    // Map each storage path back to its page number; de-dupe defensively.
    const pageByPath = new Map(pageNumbers.map((p) => [`${code}/${p}.webp`, p]));
    const paths = [...pageByPath.keys()];

    const { data: signed, error: signError } = await supabase.storage
      .from(MANUEL_PAGES_BUCKET)
      .createSignedUrls(paths, MANUEL_SIGNED_URL_TTL_SECONDS);
    if (signError || !signed) {
      logger.warn("quest.getManuelPageUrls: failed to sign manuel page urls", {
        chapterId: data.chapterId,
      });
      return { pages: [] };
    }

    const pages: ManuelPage[] = signed
      .flatMap((s) => {
        if (s.error || !s.signedUrl || !s.path) return [];
        const page = pageByPath.get(s.path);
        return page ? [{ page, url: s.signedUrl }] : [];
      })
      .sort((a, b) => a.page - b.page);

    return { pages };
  });
