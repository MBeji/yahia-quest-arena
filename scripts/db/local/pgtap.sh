#!/usr/bin/env bash
# La suite pgTAP en UNE commande, en local comme en session cloud — étude cloud-first, lot 4
# (docs/agents/pgtap-en-local.md). C'est la recette du playbook, rendue exécutable et
# consciente de la VM cloud :
#   - la VM démarre en root, et `initdb` REFUSE root : le cluster jetable est créé et piloté
#     par l'utilisateur `postgres` (su), puis interrogé en TCP avec `--auth=trust` ;
#   - pgTAP n'est pas préinstallé ; le champ « Setup script » de l'environnement n'existe pas
#     dans l'application mobile — donc on l'installe ICI, à la demande, quand on est root
#     (archive.ubuntu.com est dans la liste réseau par défaut). ~30 s une fois par VM.
#   - fsync=off parce que la base est jetable : c'est l'essentiel du gain de vitesse.
#
#   npm run db:test:local                 # tout : cluster jetable, shim, chaîne, suite, arrêt
#   PGTAP_KEEP=1 npm run db:test:local    # garde le cluster vivant (typer les RPC, requêter)
#   PGTAP_PORT=55433 npm run db:test:local
#
# Code de sortie : 0 si la chaîne se rejoue sans erreur ET si pg_prove est vert ; 1 sinon ;
# 2 si l'outillage manque et ne peut pas s'installer (le message dit quoi faire).
set -u

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORT="${PGTAP_PORT:-55432}"
PG_MAJOR="${PGTAP_PG_MAJOR:-16}"
PGBIN="${PGTAP_PGBIN:-}"
if [ -z "$PGBIN" ]; then
  if command -v pg_config >/dev/null 2>&1; then PGBIN="$(pg_config --bindir)"; else PGBIN="/usr/lib/postgresql/${PG_MAJOR}/bin"; fi
fi
SHAREDIR="$("$PGBIN/pg_config" --sharedir 2>/dev/null || echo "/usr/share/postgresql/${PG_MAJOR}")"

say() { printf '[pgtap] %s\n' "$*"; }
now() { date +%s; }

# ---- 1. l'outillage : Postgres, pgTAP, pg_prove ---------------------------------------------
if [ ! -x "$PGBIN/initdb" ]; then
  say "Postgres introuvable dans $PGBIN — installer postgresql-${PG_MAJOR} (ou PGTAP_PGBIN=<bindir>)."
  exit 2
fi
if [ ! -f "$SHAREDIR/extension/pgtap.control" ] || ! command -v pg_prove >/dev/null 2>&1; then
  if [ "$(id -u)" = "0" ] && command -v apt-get >/dev/null 2>&1; then
    say "pgTAP absent — installation (apt, ~30 s, une fois par VM)…"
    t0=$(now)
    export DEBIAN_FRONTEND=noninteractive
    if ! { apt-get update -qq && apt-get install -y -qq --no-install-recommends "postgresql-${PG_MAJOR}-pgtap"; } >/dev/null 2>&1; then
      say "l'installation de postgresql-${PG_MAJOR}-pgtap a échoué — réseau ? (archive.ubuntu.com doit être joignable)."
      exit 2
    fi
    say "pgTAP installé en $(( $(now) - t0 )) s."
  else
    say "pgTAP absent : apt-get install postgresql-${PG_MAJOR}-pgtap (Debian/Ubuntu ; pg_prove vient avec)."
    exit 2
  fi
fi

# ---- 2. un cluster jetable, en TCP, sur un port qui ne gêne personne --------------------------
WORK="$(mktemp -d /var/tmp/yqa-pgtap.XXXXXX)"
DATA="$WORK/data"
AS_PG=""
if [ "$(id -u)" = "0" ]; then
  # initdb refuse root : le cluster appartient à `postgres`, on lui parle en TCP.
  chown postgres:postgres "$WORK"
  AS_PG="su postgres -s /bin/bash -c"
fi
run_pg() { if [ -n "$AS_PG" ]; then $AS_PG "$1"; else bash -c "$1"; fi; }

stop_cluster() {
  run_pg "'$PGBIN/pg_ctl' -D '$DATA' stop -m fast >/dev/null 2>&1" || true
  rm -rf "$WORK"
}

t0=$(now)
if ! run_pg "'$PGBIN/initdb' -D '$DATA' -U postgres --auth=trust >/dev/null 2>&1 && '$PGBIN/pg_ctl' -D '$DATA' -o '-p $PORT -c fsync=off -c synchronous_commit=off' -l '$WORK/pg.log' start >/dev/null 2>&1"; then
  say "le cluster jetable n'a pas démarré — voir $WORK/pg.log (port $PORT déjà pris ?)."
  cat "$WORK/pg.log" 2>/dev/null | tail -5
  rm -rf "$WORK"
  exit 1
fi
say "cluster jetable démarré sur le port $PORT en $(( $(now) - t0 )) s."
if [ "${PGTAP_KEEP:-}" != "1" ]; then trap stop_cluster EXIT; fi

export PGHOST=127.0.0.1 PGPORT="$PORT" PGUSER=postgres PGDATABASE=postgres

# ---- 3. le shim Supabase, puis la chaîne complète des migrations, dans l'ordre des noms -------
if ! psql -v ON_ERROR_STOP=1 -q -f "$ROOT/scripts/db/local/supabase-shim.sql" >"$WORK/shim.log" 2>&1; then
  say "le shim a échoué :"; tail -5 "$WORK/shim.log"; exit 1
fi
t1=$(now); fails=0; count=0
for f in "$ROOT"/supabase/migrations/*.sql; do
  count=$((count + 1))
  if ! psql -v ON_ERROR_STOP=1 -q -f "$f" >>"$WORK/migrations.log" 2>&1; then
    fails=$((fails + 1)); say "FAIL $(basename "$f")"
  fi
done
say "chaîne rejouée : $count migrations, $fails échec(s), $(( $(now) - t1 )) s."

# ---- 4. la suite -----------------------------------------------------------------------------
t2=$(now)
pg_prove -f "$ROOT"/supabase/tests/*.sql
prove_rc=$?
say "pg_prove : exit $prove_rc en $(( $(now) - t2 )) s — total $(( $(now) - t0 )) s."
if [ "${PGTAP_KEEP:-}" = "1" ]; then
  say "cluster conservé (PGTAP_KEEP=1) : psql -h 127.0.0.1 -p $PORT -U postgres — arrêt : $PGBIN/pg_ctl -D $DATA stop"
fi
[ "$fails" -eq 0 ] && [ "$prove_rc" -eq 0 ]
