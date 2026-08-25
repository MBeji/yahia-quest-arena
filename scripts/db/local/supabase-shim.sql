-- Minimal Supabase-compatible shim for a local pgTAP/perf harness.
-- NOT part of the repo: it exists only so this session can execute the real
-- migration chain and the pgTAP suite without Docker.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pgtap;

DO $$ BEGIN
  CREATE ROLE anon NOLOGIN NOINHERIT;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE ROLE authenticated NOLOGIN NOINHERIT;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE ROLE service_role NOLOGIN NOINHERIT BYPASSRLS;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE ROLE authenticator NOINHERIT LOGIN;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE ROLE supabase_auth_admin NOLOGIN CREATEROLE;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
GRANT anon, authenticated, service_role TO authenticator;
GRANT anon, authenticated, service_role TO postgres;

CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS storage;
CREATE SCHEMA IF NOT EXISTS extensions;

CREATE TABLE IF NOT EXISTS auth.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT,
  raw_user_meta_data JSONB DEFAULT '{}'::jsonb,
  raw_app_meta_data JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ,
  encrypted_password TEXT,
  email_confirmed_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ,
  confirmation_token TEXT,
  recovery_token TEXT,
  is_anonymous BOOLEAN NOT NULL DEFAULT false,
  role TEXT DEFAULT 'authenticated',
  aud TEXT DEFAULT 'authenticated'
);

CREATE TABLE IF NOT EXISTS auth.identities (
  provider_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  identity_data JSONB NOT NULL,
  provider TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  id UUID PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE OR REPLACE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql STABLE AS $$
  SELECT NULLIF(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$;
CREATE OR REPLACE FUNCTION auth.role() RETURNS TEXT LANGUAGE sql STABLE AS $$
  SELECT COALESCE(NULLIF(current_setting('request.jwt.claim.role', true), ''), 'anon');
$$;
CREATE OR REPLACE FUNCTION auth.jwt() RETURNS JSONB LANGUAGE sql STABLE AS $$
  SELECT COALESCE(NULLIF(current_setting('request.jwt.claims', true), '')::jsonb, '{}'::jsonb);
$$;
CREATE OR REPLACE FUNCTION auth.email() RETURNS TEXT LANGUAGE sql STABLE AS $$
  SELECT NULLIF(current_setting('request.jwt.claim.email', true), '');
$$;

CREATE TABLE IF NOT EXISTS storage.buckets (
  id TEXT PRIMARY KEY, name TEXT NOT NULL, owner UUID, public BOOLEAN DEFAULT false,
  file_size_limit BIGINT, allowed_mime_types TEXT[],
  created_at TIMESTAMPTZ DEFAULT now(), updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS storage.objects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bucket_id TEXT REFERENCES storage.buckets(id),
  name TEXT, owner UUID, owner_id TEXT,
  created_at TIMESTAMPTZ DEFAULT now(), updated_at TIMESTAMPTZ DEFAULT now(),
  last_accessed_at TIMESTAMPTZ DEFAULT now(), metadata JSONB,
  path_tokens TEXT[]
);
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;
ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA auth, storage, extensions, public TO anon, authenticated, service_role;
GRANT SELECT ON auth.users TO service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres;
-- (auth.uid/role/email re-defined to read the JSON claims blob, as Supabase does)
CREATE OR REPLACE FUNCTION auth.uid() RETURNS UUID LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    NULLIF(current_setting('request.jwt.claim.sub', true), ''),
    (NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid;
$$;
CREATE OR REPLACE FUNCTION auth.role() RETURNS TEXT LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    NULLIF(current_setting('request.jwt.claim.role', true), ''),
    (NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text;
$$;
CREATE OR REPLACE FUNCTION auth.email() RETURNS TEXT LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    NULLIF(current_setting('request.jwt.claim.email', true), ''),
    (NULLIF(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text;
$$;
ALTER TABLE auth.users
  ADD COLUMN IF NOT EXISTS instance_id UUID,
  ADD COLUMN IF NOT EXISTS phone TEXT,
  ADD COLUMN IF NOT EXISTS confirmed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS invited_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS banned_until TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS is_sso_user BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_super_admin BOOLEAN;
