#!/usr/bin/env bash
# Régénère src/shared/integrations/supabase/types.ts depuis la CHAÎNE DE MIGRATIONS — pas
# depuis la prod. Audit du 2026-09-12 (D-1) : le fichier était en retard de 28 RPC et 3 tables
# parce que rien ne le régénérait ; `npm run db:check-types` rougit désormais sur cet écart, et
# ce script est son remède. C'est la recette de docs/agents/pgtap-en-local.md (§ « Le même
# cluster type aussi les RPC ») rendue exécutable, ses trois écarts réglés DANS la base de
# génération, jamais dans le fichier :
#   1. pgTAP absent (le shim l'installe dans `public`, ses ~200 fonctions entreraient dans les
#      types) et les extensions dans `extensions`, comme en prod (pgcrypto dans `public`
#      ajoutait `gen_salt`, `dearmor`… aux types) ;
#   2. `graphql_public` présent (un stub `graphql()` suffit) et la version PostgREST lue dans le
#      fichier committé — sans eux la sortie perd `__InternalSupabase` et ce schéma ;
#   3. ce que la prod porte HORS chaîne n'est pas reproduit : c'est voulu (le gate le refuserait),
#      et ça se voit au `git diff` — rien ne doit disparaître qui ne soit expliqué.
# Le générateur est le module même que `supabase gen types` fait tourner dans Docker,
# @supabase/postgres-meta, installé HORS dépôt (/var/tmp/pgmeta) : ni Docker, ni jeton prod.
#
#   npm run db:gen-types                 # rejoue la chaîne (pgtap.sh), génère, écrit types.ts
#   PGMETA_DIR=… PGTAP_PORT=… npm run db:gen-types
#
# Sortie : 0 si types.ts est régénéré et que `db:check-types` le tient ; 1 sinon.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORT="${PGTAP_PORT:-55432}"
PGMETA_DIR="${PGMETA_DIR:-/var/tmp/pgmeta}"
PGMETA_VERSION="${PGMETA_VERSION:-0.99.0}"
TYPES="$ROOT/src/shared/integrations/supabase/types.ts"
say() { printf '[gen-types] %s\n' "$*"; }

# ---- 1. la chaîne, rejouée et PROUVÉE (pgTAP) sur un cluster jetable gardé vivant ------------
say "rejeu de la chaîne + suite pgTAP (scripts/db/local/pgtap.sh, PGTAP_KEEP=1)…"
keep_log="$(mktemp)"
if ! PGTAP_KEEP=1 PGTAP_PORT="$PORT" bash "$ROOT/scripts/db/local/pgtap.sh" | tee "$keep_log"; then
  say "la chaîne ou la suite pgTAP est rouge — on ne type pas une base cassée."
  exit 1
fi
DATA="$(sed -n 's/.*-D \([^ ]*\) stop.*/\1/p' "$keep_log" | tail -1)"
PGBIN="$(sed -n "s/.*arrêt : \([^ ]*\)\/pg_ctl .*/\1/p" "$keep_log" | tail -1)"
export PGHOST=127.0.0.1 PGPORT="$PORT" PGUSER=postgres

stop_cluster() {
  if [ -n "${DATA:-}" ] && [ -n "${PGBIN:-}" ]; then
    if [ "$(id -u)" = "0" ]; then su postgres -s /bin/bash -c "'$PGBIN/pg_ctl' -D '$DATA' stop -m fast >/dev/null 2>&1" || true
    else "$PGBIN/pg_ctl" -D "$DATA" stop -m fast >/dev/null 2>&1 || true; fi
    rm -rf "$(dirname "$DATA")"
  fi
}
trap stop_cluster EXIT

# ---- 2. la base de génération : copie de la chaîne, sans pgTAP, extensions rangées ----------
psql -d postgres -qc "DROP DATABASE IF EXISTS gen_types" >/dev/null
psql -d postgres -qc "CREATE DATABASE gen_types TEMPLATE postgres" >/dev/null
POSTGREST_VERSION="$(sed -n 's/.*PostgrestVersion: "\([^"]*\)".*/\1/p' "$TYPES" | head -1)"
psql -d gen_types -v ON_ERROR_STOP=1 -q <<'SQL'
DROP EXTENSION IF EXISTS pgtap CASCADE;
CREATE SCHEMA IF NOT EXISTS extensions;
DO $$
DECLARE ext text;
BEGIN
  FOR ext IN SELECT extname FROM pg_extension e JOIN pg_namespace n ON n.oid = e.extnamespace
             WHERE n.nspname = 'public' AND extname <> 'plpgsql'
  LOOP EXECUTE format('ALTER EXTENSION %I SET SCHEMA extensions', ext); END LOOP;
END $$;
CREATE SCHEMA IF NOT EXISTS graphql_public;
CREATE OR REPLACE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL, query text DEFAULT NULL,
  variables jsonb DEFAULT NULL, extensions jsonb DEFAULT NULL) RETURNS jsonb LANGUAGE sql AS $$ SELECT '{}'::jsonb $$;
SQL
say "base de génération prête (pgTAP retiré, extensions dans \`extensions\`, graphql_public posé)."

# ---- 3. le générateur, hors dépôt -----------------------------------------------------------
if [ ! -d "$PGMETA_DIR/node_modules/@supabase/postgres-meta" ]; then
  say "installation de @supabase/postgres-meta@$PGMETA_VERSION dans $PGMETA_DIR (hors dépôt)…"
  mkdir -p "$PGMETA_DIR" && (cd "$PGMETA_DIR" && [ -f package.json ] || npm init -y >/dev/null)
  (cd "$PGMETA_DIR" && npm i "@supabase/postgres-meta@$PGMETA_VERSION" --no-audit --no-fund >/dev/null)
fi
cat > "$PGMETA_DIR/gen.mjs" <<'JS'
import { PostgresMeta } from "@supabase/postgres-meta/dist/lib/index.js";
import { getGeneratorMetadata } from "@supabase/postgres-meta/dist/lib/generators.js";
import { generateTypescriptTypes } from "@supabase/postgres-meta/dist/server/format-pool.js";
import { GENERATE_TYPES_DEFAULT_SCHEMA } from "@supabase/postgres-meta/dist/server/constants.js";
const pgMeta = new PostgresMeta({ connectionString: process.argv[2] });
const { data, error } = await getGeneratorMetadata(pgMeta, {
  includedSchemas: ["public", "graphql_public"],
  excludedSchemas: [],
});
if (error) { console.error(error); process.exit(1); }
process.stdout.write(
  await generateTypescriptTypes(data, {
    detectOneToOneRelationships: true,
    postgrestVersion: process.argv[3],
    defaultSchema: GENERATE_TYPES_DEFAULT_SCHEMA,
  }),
);
await pgMeta.end();
process.exit(0);
JS
tmp="$(mktemp --suffix=.ts)"
(cd "$PGMETA_DIR" && node gen.mjs "postgresql://postgres@127.0.0.1:$PORT/gen_types" "${POSTGREST_VERSION:-14.17}" 2>/dev/null) > "$tmp"
[ -s "$tmp" ] || { say "génération vide — voir $PGMETA_DIR/gen.mjs."; exit 1; }
"$ROOT/node_modules/.bin/prettier" --config "$ROOT/.prettierrc" --write "$tmp" >/dev/null

# ---- 4. écrire, puis laisser le gate juger --------------------------------------------------
if cmp -s "$tmp" "$TYPES"; then
  say "types.ts déjà à jour (aucun changement)."
else
  cp "$tmp" "$TYPES"
  say "types.ts régénéré — $(cd "$ROOT" && git diff --stat -- "$TYPES" | tail -1)"
fi
rm -f "$tmp" "$keep_log"
(cd "$ROOT" && node scripts/db/check-types-drift.mjs)
