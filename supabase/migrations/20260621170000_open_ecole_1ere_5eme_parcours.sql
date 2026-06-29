-- Open the 1ère→5ème regular school parcours: flip "coming_soon" → "available".
--
-- These grades now ship content: maths 1ère→5ème is fully realigned on the official
-- CNP programme, and éveil scientifique 1ère is realigned (éveil 2ème→5ème keep their
-- existing content for now). The parcours were seeded `coming_soon` ("En construction")
-- by 20260617120000 before any content existed, so the classes showed an "En
-- construction" badge and their content stayed locked (resolve_exercise_access →
-- PARCOURS_COMING_SOON). Flipping the status unlocks them.
--
-- These are FREE `scolaire` parcours (is_premium = false, preview_policy = 'full'),
-- so becoming 'available' opens them fully — no entitlement required.
--
-- Idempotent: re-running is a no-op once the status is already 'available'.
-- Mirrors 20260609160000_concours_6eme_available.sql.
UPDATE public.parcours
SET status = 'available'
WHERE id IN (
  'ecole-1ere-base',
  'ecole-2eme-base',
  'ecole-3eme-base',
  'ecole-4eme-base',
  'ecole-5eme-base'
);
