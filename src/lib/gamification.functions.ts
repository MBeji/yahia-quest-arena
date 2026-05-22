import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";

// ---------- Get dashboard ----------
export const getDashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const [profileRes, subjectsRes, attemptsRes] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", userId).maybeSingle(),
      supabase.from("subjects").select("*").order("display_order"),
      supabase
        .from("attempts")
        .select("subject_id,score_pct,xp_earned,completed_at,exercise_id")
        .eq("user_id", userId)
        .order("completed_at", { ascending: false })
        .limit(50),
    ]);

    if (profileRes.error) throw new Error(profileRes.error.message);
    if (subjectsRes.error) throw new Error(subjectsRes.error.message);
    if (attemptsRes.error) throw new Error(attemptsRes.error.message);

    // build per-subject avg score
    const bySubject: Record<string, { count: number; avg: number; xp: number }> = {};
    for (const a of attemptsRes.data ?? []) {
      const s = (bySubject[a.subject_id] ??= { count: 0, avg: 0, xp: 0 });
      s.avg = (s.avg * s.count + Number(a.score_pct)) / (s.count + 1);
      s.count += 1;
      s.xp += a.xp_earned;
    }

    return {
      profile: profileRes.data,
      subjects: subjectsRes.data ?? [],
      stats: bySubject,
      recent: attemptsRes.data ?? [],
    };
  });

// ---------- Get a subject with chapters & exercises ----------
export const getSubject = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ subjectId: z.string() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const [subj, chaps, exs, atts] = await Promise.all([
      supabase.from("subjects").select("*").eq("id", data.subjectId).single(),
      supabase.from("chapters").select("*").eq("subject_id", data.subjectId).order("display_order"),
      supabase.from("exercises").select("*").eq("subject_id", data.subjectId).order("display_order"),
      supabase.from("attempts").select("exercise_id,score_pct").eq("user_id", userId).eq("subject_id", data.subjectId),
    ]);
    if (subj.error) throw new Error(subj.error.message);

    const best: Record<string, number> = {};
    for (const a of atts.data ?? []) {
      best[a.exercise_id] = Math.max(best[a.exercise_id] ?? 0, Number(a.score_pct));
    }

    return {
      subject: subj.data,
      chapters: chaps.data ?? [],
      exercises: exs.data ?? [],
      bestByExercise: best,
    };
  });

// ---------- Get exercise + questions ----------
export const getExercise = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const [ex, qs] = await Promise.all([
      supabase.from("exercises").select("*, subjects(*), chapters(*)").eq("id", data.exerciseId).single(),
      supabase
        .from("questions")
        .select("id,prompt,options,correct_option,explanation,display_order")
        .eq("exercise_id", data.exerciseId)
        .order("display_order"),
    ]);
    if (ex.error) throw new Error(ex.error.message);
    return { exercise: ex.data, questions: qs.data ?? [] };
  });

// ---------- Submit attempt ----------
export const submitAttempt = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      exerciseId: z.string().uuid(),
      answers: z.array(z.object({ questionId: z.string().uuid(), choice: z.string() })).min(1).max(100),
      durationSeconds: z.number().int().min(0).max(7200),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const [exRes, qsRes] = await Promise.all([
      supabase.from("exercises").select("id,subject_id,xp_reward,difficulty").eq("id", data.exerciseId).single(),
      supabase.from("questions").select("id,correct_option").eq("exercise_id", data.exerciseId),
    ]);
    if (exRes.error) throw new Error(exRes.error.message);
    if (qsRes.error) throw new Error(qsRes.error.message);

    const correctMap = new Map(qsRes.data.map((q) => [q.id, q.correct_option]));
    let correct = 0;
    for (const a of data.answers) {
      if (correctMap.get(a.questionId) === a.choice) correct += 1;
    }
    const total = qsRes.data.length;
    const pct = total > 0 ? (correct / total) * 100 : 0;

    // Scoring: base + speed bonus
    const idealTime = total * 30; // 30s per Q
    const speedFactor = Math.max(0.5, Math.min(1.4, idealTime / Math.max(15, data.durationSeconds)));
    const xpEarned = Math.round(exRes.data.xp_reward * (pct / 100) * speedFactor);

    // Insert attempt
    const insRes = await supabase.from("attempts").insert({
      user_id: userId,
      exercise_id: data.exerciseId,
      subject_id: exRes.data.subject_id,
      correct_count: correct,
      total_count: total,
      score_pct: pct,
      duration_seconds: data.durationSeconds,
      xp_earned: xpEarned,
    });
    if (insRes.error) throw new Error(insRes.error.message);

    // Award XP via DB function (security definer)
    const { data: newProfile, error: rpcErr } = await supabase.rpc("award_xp", { p_user: userId, p_xp: xpEarned });
    if (rpcErr) throw new Error(rpcErr.message);

    return {
      correct, total, scorePct: pct, xpEarned,
      profile: Array.isArray(newProfile) ? newProfile[0] : newProfile,
      correctMap: Object.fromEntries(correctMap),
    };
  });
