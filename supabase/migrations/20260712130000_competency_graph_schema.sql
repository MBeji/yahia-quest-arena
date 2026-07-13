-- Knowledge graph — étude 07 lot 1 (FableEtudes/07-knowledge-graph-competences #lot-1).
--
-- CATALOG tables only (amendement d'architecte 2026-07-11) : le registre
-- compilé (migration générée suivante) doit s'appliquer sur une DB fraîche,
-- donc les tables qu'il remplit arrivent ici, au lot 1. La table de maîtrise
-- `user_competency_mastery` + le trigger EWMA (D-3/R-4) restent le lot 2.
--
--   * competencies       — the closed, versioned competency registry compiled
--     from content/competences/<famille>.json (D-1). Ids are deterministic
--     UUIDv5 of the stable slug (R-1: create/deprecate, never rename).
--   * competency_prereqs — the prerequisite DAG edges, same-family only (R-3;
--     acyclicity is enforced upstream by the content pipeline lint).
--   * question_competencies — which questions evaluate which competencies
--     (D-2). Unlike distractor_tags (étude 04 D-1, server-only), these ids
--     describe the QUESTION, not its options — they never reveal the key, so
--     the junction is safely client-readable.
--
-- Writes: compiled content migrations only (applied as the table owner).
-- Client roles are read-only; anon sees nothing (v1 surfaces live behind auth).
-- CLAUDE.md gotcha: new tables ship their own explicit GRANTs.

CREATE TABLE IF NOT EXISTS public.competencies (
  id UUID PRIMARY KEY,                       -- UUIDv5(slug), compiled from the registry
  slug TEXT NOT NULL UNIQUE,                 -- 'math.geo.thales-direct'
  family TEXT NOT NULL,                      -- 'math'
  label_fr TEXT NOT NULL,
  label_en TEXT NOT NULL,
  label_ar TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_competencies_family
  ON public.competencies (family);

CREATE TABLE IF NOT EXISTS public.competency_prereqs (
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  prereq_id     UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  PRIMARY KEY (competency_id, prereq_id),
  CHECK (competency_id <> prereq_id)
);

-- Reverse lookup: "which competencies does X unlock" (déblocages, lot 4+).
CREATE INDEX IF NOT EXISTS idx_competency_prereqs_prereq
  ON public.competency_prereqs (prereq_id);

CREATE TABLE IF NOT EXISTS public.question_competencies (
  question_id   UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  is_primary BOOLEAN NOT NULL DEFAULT false, -- first authored id = principale (R-2)
  PRIMARY KEY (question_id, competency_id)
);

-- Reverse lookup: exercises evaluating a competency (US-2, lot 4).
CREATE INDEX IF NOT EXISTS idx_question_competencies_competency
  ON public.question_competencies (competency_id);

-- ---------------------------------------------------------------------------
-- RLS: authenticated reads the catalogue; nobody writes but the owner
-- (compiled migrations). No write policies on purpose.
-- ---------------------------------------------------------------------------
ALTER TABLE public.competencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.competency_prereqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.question_competencies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated read competencies" ON public.competencies
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated read competency prereqs" ON public.competency_prereqs
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated read question competencies" ON public.question_competencies
  FOR SELECT TO authenticated USING (true);

-- End-state grants on every stack (cloud default privileges may differ from
-- the fresh local stack): SELECT only for the client, nothing for anon.
REVOKE ALL ON public.competencies FROM anon, authenticated;
REVOKE ALL ON public.competency_prereqs FROM anon, authenticated;
REVOKE ALL ON public.question_competencies FROM anon, authenticated;

GRANT SELECT ON public.competencies TO authenticated;
GRANT SELECT ON public.competency_prereqs TO authenticated;
GRANT SELECT ON public.question_competencies TO authenticated;

GRANT ALL ON public.competencies TO service_role;
GRANT ALL ON public.competency_prereqs TO service_role;
GRANT ALL ON public.question_competencies TO service_role;
