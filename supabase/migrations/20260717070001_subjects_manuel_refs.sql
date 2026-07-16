-- =========================================================
-- Additive: link each subject to its official CNP student-textbook (manuel
-- élève) PDF volume(s), surfaced as a « Manuel officiel » card on the public
-- subject page (login-gated download via signed URLs).
--
-- Populated by the content pipeline (subject.json `manuels` → content:build →
-- subjects.manuel_refs). Nullable and idempotent, so it is safe to land ahead
-- of the code that consumes it (DoD §7: additive migrations first).
--
-- Shape: [{ "code": "<book code>", "label": "<volume label or null>" }, ...]
-- Only metadata lives here (book code + display label); the PDF FILES are
-- served from the separate, access-controlled `manuel-eleve` Storage bucket.
-- `subjects` is already world-readable, so the codes/labels are public — the
-- files are not.
-- =========================================================

ALTER TABLE public.subjects
  ADD COLUMN IF NOT EXISTS manuel_refs JSONB;

COMMENT ON COLUMN public.subjects.manuel_refs IS
  'Optional [{code, label}]: the official CNP manuel élève PDF volume(s) for this subject. Set by content:build; rendered as a login-gated « Manuel officiel » card on the subject page (files live in the private manuel-eleve bucket).';
