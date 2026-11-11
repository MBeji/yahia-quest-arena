-- =========================================================
-- Additive: trace which official CNP textbook exercises a mission takes up.
--
-- Étude 21 lot 2 (D-6). Populated by the content pipeline
-- (`content:build` → `exercises.manuel_ref`), mirroring the pattern that
-- `chapters.manuel_ref` already established for the page gallery.
--
-- Shape: { "code": "222104P01", "pages"?: "68-71", "pageNumbers"?: [68,69,70,71],
--          "items": ["ex. 12", "ex. 13", "ex. 15a"] }
--
-- WHAT IT IS FOR, and it is only that: the coverage report (lot 4) crosses these
-- items against what the programme manifest declares, so a campaign can answer
-- "this manual is X % taken up, and here is what is left". Étude 21 Q-2 was
-- arbitrated NO — the provenance is **never shown to the student** — so the
-- column has exactly one consumer, and it is a report.
--
-- WHAT IT IS NOT. It carries no answer key: `items` are numbering labels from
-- the printed book ("ex. 12"), never a hint. The server-only invariants on
-- `correct_option` / `answer_key` / `distractor_tags` are untouched.
--
-- Grants: `exercises` is world-readable through a TABLE-level grant
-- (`20260612221000_baseline_table_grants.sql`, `GRANT SELECT ON public.subjects,
-- public.chapters, public.exercises, … TO anon, authenticated`) — not a
-- column-by-column one. An added column is therefore readable with no grant
-- change, and the étude's "the lot-2 executor checks and documents" is answered
-- here rather than assumed.
--
-- Nullable and idempotent, so it lands ahead of the code that writes it
-- (DoD §7: additive migrations first).
-- =========================================================

ALTER TABLE public.exercises
  ADD COLUMN IF NOT EXISTS manuel_ref JSONB;

COMMENT ON COLUMN public.exercises.manuel_ref IS
  'Optional {code, pages?, pageNumbers?, items[]}: the official CNP manuel élève exercises this mission takes up (étude 21 R-4). Set by content:build. Internal traceability only — never surfaced to the student (Q-2); its single consumer is the coverage report.';
