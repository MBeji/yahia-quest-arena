-- Content release journal — étude 24 lot 3 (FableEtudes/24-protection-ip-contenu #lot-3).
--
-- The corpus is leaving the Supabase migration framework (D-3): a database can
-- only host ONE migration history, so two repos pushing to it deadlock ("Remote
-- migration versions not found in local migrations directory"). The content SQL
-- therefore becomes stable per-subject files (`sql/content/<subject>.sql`,
-- private repo) applied by a dedicated psql workflow.
--
-- That trade costs the corpus its bookkeeping: `supabase_migrations.schema_
-- migrations` no longer records what content reached prod, or when. This table
-- is the replacement journal — the answer to "which subjects were applied, from
-- which commit, by whom".
--
-- The table itself lives HERE, in the public repo, on purpose: it is schema, not
-- content. The public repo keeps "schéma + ops uniquement" (§4.1), so the table
-- is created by the sanctioned `db-migrate-prod.yml` auto-apply and proved by
-- the pgTAP nightly on a fresh DB. The private repo only INSERTs rows into it.
--
-- Ops-private: no client role reads or writes this journal — RLS is enabled with
-- NO policy at all, so even a leaked anon/authenticated key sees nothing. Only
-- service_role (the apply workflow) touches it.
-- CLAUDE.md gotcha: new tables ship their own explicit GRANTs.

CREATE TABLE IF NOT EXISTS public.content_releases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  git_sha TEXT NOT NULL,                     -- commit of the private corpus repo
  subjects TEXT[] NOT NULL DEFAULT '{}',     -- compiled subject ids applied in this run
  actor TEXT NOT NULL                        -- workflow run / dispatcher identity
);

-- The journal is read newest-first ("what shipped last?").
CREATE INDEX IF NOT EXISTS idx_content_releases_applied_at
  ON public.content_releases (applied_at DESC);

-- ---------------------------------------------------------------------------
-- RLS: enabled with NO policy — deny-all for anon and authenticated by design.
-- service_role bypasses RLS, which is exactly the intended sole writer.
-- ---------------------------------------------------------------------------
ALTER TABLE public.content_releases ENABLE ROW LEVEL SECURITY;

-- End-state grants on every stack (cloud default privileges may differ from the
-- fresh local stack): the client roles get nothing at all.
REVOKE ALL ON public.content_releases FROM anon, authenticated;

GRANT ALL ON public.content_releases TO service_role;
