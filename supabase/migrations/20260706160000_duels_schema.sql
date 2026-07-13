-- Duels temps réel & ligues — lot 1 (FableEtudes/05-duels-ligues #lot-1).
--
-- Schema ONLY (stop-point du lot : AUCUN RPC de jeu — matchmaking/scoring/finalize
-- sont le lot 2). Three additive tables for asynchronous-tolerant 1v1 duels that
-- reuse the existing content + the Dungeon server-authoritative scoring pattern:
--
--   * duel_queue          — the matchmaking waiting room, one row per user
--                           (PK user_id → R-10: at most one queue entry). Owner-only.
--   * duels               — a match: a FROZEN question set (question_ids, R-2), a
--                           status lifecycle, and an expiry (D-3 async tolerance).
--   * duel_participants   — the two players' per-duel state: score + one server
--                           timestamp per answered question (answers_submitted_at,
--                           R-5 anti-cheat timing).
--
-- Security posture (patron exact de 20260608120000_parcours_entity.sql):
--   - RLS on all three; duel_queue is owner-only, duels/duel_participants are
--     readable only by a participant; NO client writes anywhere (every mutation
--     goes through the lot-2 SECURITY DEFINER RPCs, which run as table owner).
--   - Explicit grants (CLAUDE.md gotcha: fresh stacks get no default privileges).
--     The answer key never lives here — question_ids are just references; the
--     correction is revealed by the lot-2 get_duel_state only once finished (R-6).
--
-- Écart accepté vs l'étude (documenté au journal §8) : l'étude écrit la visibilité
-- « participant » comme un `EXISTS` sur `duel_participants` DANS la policy de
-- `duel_participants` elle-même — ce qui déclenche la récursion RLS infinie de
-- Postgres (même piège que 20260526260000_fix_admin_rls_recursion.sql). On préserve
-- l'intention EXACTE avec le patron déjà établi du repo : un prédicat
-- SECURITY DEFINER `is_duel_participant()` qui lit la table hors RLS. Ce n'est PAS
-- un RPC de jeu (aucune logique de match/score) — c'est l'infrastructure de la
-- policy, exactement comme `is_admin()`.

-- ---------------------------------------------------------------------------
-- 1. duel_queue — the matchmaking waiting room (owner-only).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.duel_queue (
  user_id     UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  parcours_id TEXT NOT NULL REFERENCES public.parcours(id) ON DELETE CASCADE,
  grade_id    UUID REFERENCES public.grades(id),
  enqueued_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Matchmaking scans the oldest compatible entries of a parcours (lot 2).
CREATE INDEX IF NOT EXISTS idx_duel_queue_parcours_enqueued
  ON public.duel_queue (parcours_id, enqueued_at);

ALTER TABLE public.duel_queue ENABLE ROW LEVEL SECURITY;

-- Owner-only: a student manages ONLY their own queue entry (join/cancel). No
-- UPDATE policy — a queue row is immutable (re-enqueue = delete + insert).
CREATE POLICY "Queue rows are owner-only (select)" ON public.duel_queue
  FOR SELECT USING (user_id = (SELECT auth.uid()));
CREATE POLICY "Queue rows are owner-only (insert)" ON public.duel_queue
  FOR INSERT WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY "Queue rows are owner-only (delete)" ON public.duel_queue
  FOR DELETE USING (user_id = (SELECT auth.uid()));

-- The student joins/leaves the queue directly (owner-scoped), so SELECT + INSERT
-- + DELETE are granted; UPDATE is never allowed. Matchmaking (lot 2) removes the
-- paired rows as table owner.
REVOKE ALL ON public.duel_queue FROM anon, authenticated;
GRANT SELECT, INSERT, DELETE ON public.duel_queue TO authenticated;
GRANT ALL ON public.duel_queue TO service_role;

-- ---------------------------------------------------------------------------
-- 2. duels — a match with a frozen question set + lifecycle + expiry.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.duels (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parcours_id     TEXT NOT NULL REFERENCES public.parcours(id),
  exercise_source TEXT NOT NULL DEFAULT 'parcours_pool',
  question_ids    UUID[] NOT NULL,          -- set figé au matchmaking (R-2)
  status          TEXT NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending', 'active', 'finished', 'expired')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at      TIMESTAMPTZ NOT NULL
);

-- The expiry cron sweeps active duels past their deadline (lot 2, R-9).
CREATE INDEX IF NOT EXISTS idx_duels_status_expires
  ON public.duels (status, expires_at);

ALTER TABLE public.duels ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------------
-- 3. duel_participants — the two players' per-duel state.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.duel_participants (
  duel_id              UUID NOT NULL REFERENCES public.duels(id) ON DELETE CASCADE,
  user_id              UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  score                INT NOT NULL DEFAULT 0,
  finished_at          TIMESTAMPTZ,
  answers_submitted_at TIMESTAMPTZ[] NOT NULL DEFAULT '{}',  -- 1 server ts/question (R-5)
  PRIMARY KEY (duel_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_duel_participants_user
  ON public.duel_participants (user_id);

ALTER TABLE public.duel_participants ENABLE ROW LEVEL SECURITY;

-- Membership predicate (breaks RLS self-recursion — see header). SECURITY DEFINER
-- reads duel_participants as the table owner, bypassing RLS on the inner scan, so
-- a policy may call it without recursing. Same device as public.is_admin().
CREATE OR REPLACE FUNCTION public.is_duel_participant(p_duel UUID, p_user UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.duel_participants
    WHERE duel_id = p_duel AND user_id = p_user
  );
$$;

REVOKE ALL ON FUNCTION public.is_duel_participant(UUID, UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.is_duel_participant(UUID, UUID) TO authenticated;

-- A participant sees BOTH rows of their duel (self + opponent): the opponent's
-- answers_submitted_at LENGTH is the public progress counter (R-3), while their
-- answers/keys are simply not stored client-readable (the correction lives in
-- questions, revealed only via the lot-2 RPC once finished — R-6). The write path
-- is RPC-only, so no INSERT/UPDATE/DELETE policy exists.
CREATE POLICY "Participants readable within one's own duel" ON public.duel_participants
  FOR SELECT USING (public.is_duel_participant(duel_id, (SELECT auth.uid())));

REVOKE INSERT, UPDATE, DELETE ON public.duel_participants FROM authenticated, anon;
REVOKE ALL ON public.duel_participants FROM anon;
GRANT SELECT ON public.duel_participants TO authenticated;
GRANT ALL ON public.duel_participants TO service_role;

-- A duel is visible only to its two participants (no global feed), via the same
-- membership predicate. Declared AFTER duel_participants so the predicate exists.
CREATE POLICY "Duels readable by participants" ON public.duels
  FOR SELECT USING (public.is_duel_participant(id, (SELECT auth.uid())));

REVOKE INSERT, UPDATE, DELETE ON public.duels FROM authenticated, anon;
REVOKE ALL ON public.duels FROM anon;
GRANT SELECT ON public.duels TO authenticated;
GRANT ALL ON public.duels TO service_role;
