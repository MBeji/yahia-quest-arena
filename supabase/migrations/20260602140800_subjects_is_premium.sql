-- =========================================================
-- Ensure subjects.is_premium exists BEFORE the generated content migrations
-- (20260602141000_generated_*_content.sql) that INSERT it.
--
-- Those content migrations were (re)generated with the is_premium column but
-- keep their original 2026-06-02 timestamps, while the column is otherwise
-- only added later by 20260603140000_subject_premium_flag.sql. On a fresh
-- database, applying migrations in timestamp order therefore failed with:
--   ERROR: column "is_premium" of relation "subjects" does not exist
--
-- This migration adds the column early; both this and the later
-- subject_premium_flag migration use IF NOT EXISTS, so they are safe no-ops
-- relative to each other (and on databases where the column already exists).
-- =========================================================

ALTER TABLE public.subjects
  ADD COLUMN IF NOT EXISTS is_premium BOOLEAN NOT NULL DEFAULT false;
