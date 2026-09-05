# Faire tourner la suite pgTAP **en local**, sans Docker

> **Quand lire ceci** : dès qu'une session touche à `supabase/migrations/**` ou à
> `supabase/tests/**`. Mesuré le 2026-08-25 (étude 30, cinq lots de SQL) : la suite complète —
> **81 fichiers, 1 139 assertions** — tourne en **7 secondes** sur un Postgres local, contre
> **5 à 8 minutes** de boucle CI. Sur une journée de cinq migrations, c'est la différence entre
> itérer et attendre.

## Pourquoi ça vaut la peine

`db-tests.yml` est le seul filet exécutable du SQL (grants, RLS, `SECURITY DEFINER`), et
AGENTS.md le rappelle : il ne tourne **pas** sur la plupart des PR — nightly,
`workflow_dispatch`, et depuis le 2026-07-20 sur les PR qui touchent aux migrations. Il boote
Docker et rejoue ~190 migrations : compter 5-8 min par aller-retour.

Le résultat, documenté dans AGENTS.md : les quatre pannes en cascade de l'étude 24 (#548, #549,
#552, #557) ont chacune coûté un dispatch manuel de ~4 min **après** leur merge. `db:check-chain`
a depuis pris la moitié statique du problème. Ce document prend l'autre moitié — l'exécutable —
et la ramène sur le poste.

## La recette

Trois choses, dont une seule est à écrire : un Postgres, pgTAP, et un **shim** qui imite le
strict nécessaire de Supabase. Le shim est versionné : [`scripts/db/local/supabase-shim.sql`](../../scripts/db/local/supabase-shim.sql).

```bash
# 1. Postgres + pgTAP (Debian/Ubuntu ; le paquet pgTAP existe en 1.3.2)
apt-get install -y postgresql-16 postgresql-16-pgtap   # pg_prove vient avec

# 2. Un cluster jetable, sur un port qui ne gêne personne
initdb -D "$PGDATA" -U postgres --auth=trust -E UTF8 --locale=C.UTF-8
pg_ctl -D "$PGDATA" -o '-p 55432 -c fsync=off -c synchronous_commit=off' -l pg.log start

# 3. Le shim, puis la chaîne complète des migrations, dans l'ordre des noms
psql -h 127.0.0.1 -p 55432 -U postgres -v ON_ERROR_STOP=1 -f scripts/db/local/supabase-shim.sql
for f in supabase/migrations/*.sql; do
  psql -h 127.0.0.1 -p 55432 -U postgres -v ON_ERROR_STOP=1 -q -f "$f" || echo "FAIL $f"
done

# 4. La suite
PGHOST=127.0.0.1 PGPORT=55432 PGUSER=postgres PGDATABASE=postgres \
  pg_prove -f supabase/tests/*.sql
```

`fsync=off` n'est pas de la négligence : la base est jetable et recréée à chaque doute. C'est
l'essentiel du gain de vitesse.

Pour repartir d'une base **vierge** — le seul état qui prouve la reconstructibilité —
`createdb` un nouveau nom et rejouer les points 3 et 4. Quinze secondes.

## Ce que le shim doit contenir, et pourquoi

Le détail est dans le fichier ; deux points ont coûté un aller-retour chacun et méritent d'être
sus **avant** :

- **`auth.uid()` lit le blob de claims, pas une clé isolée.** Les suites posent
  `SET LOCAL "request.jwt.claims" = '{"sub":"…","role":"authenticated"}'`. Un `auth.uid()` qui
  ne lirait que `request.jwt.claim.sub` rend `NULL` : toutes les assertions RLS tombent, et
  elles tombent d'une façon qui ressemble à un défaut de RLS plutôt qu'à un shim incomplet.
- **`auth.users` a besoin de plus de colonnes qu'on ne croit** (`instance_id`, `is_sso_user`…).
  Les fixtures de plusieurs suites les renseignent ; sans elles, `plan()` échoue avant la
  première assertion et le rapport dit « 0 tests ran », ce qui n'oriente vers rien.
- **Le cluster doit être en UTF8, et `initdb` ne tourne pas en root.** Sans `-E UTF8`, un poste
  dont la locale est `C`/`POSIX` crée une base `SQL_ASCII`, et `normalize_recall_text` — qui
  appelle `normalize()` — tombe avec « Unicode normalization can only be performed if server
  encoding is UTF8 ». Toute suite qui touche au Rappel (29, 97…) rougit alors d'une façon qui
  ressemble à un défaut du SQL testé, pas de la base : le 97 a rendu « Bad plan, planned 10
  ran 6 » avant qu'on regarde l'encodage. Et `initdb` refuse de tourner en root — sur un
  conteneur qui n'a que ce compte, `runuser -u postgres -- initdb …`, avec un `PGDATA`
  appartenant à `postgres`. Mesuré le 2026-09-05 (100 fichiers, 1 404 assertions en 28 s une
  fois le cluster recréé).

## Le même cluster type aussi les RPC — sans Docker, sans jeton prod

> Découvert le 2026-08-28 (objectifs famille jour/semaine). **Cela lève la contrainte des deux
> PR** que ce dossier et [`../suivi-parental-quotidien.md`](../suivi-parental-quotidien.md)
> décrivaient comme sans parade : une migration et le code qui l'utilise tiennent désormais
> dans une seule PR, comme le reste du dépôt le fait déjà.

`supabase gen types` refuse `--db-url` sans Docker : le CLI délègue l'introspection à l'image
`postgres-meta`. Mais **cette image n'est qu'un serveur autour d'un module npm**, et le module
s'installe seul — hors dépôt, comme `pglite` :

```bash
mkdir -p /var/tmp/pgmeta && cd /var/tmp/pgmeta && npm init -y && npm i @supabase/postgres-meta
```

Puis une dizaine de lignes qui appellent exactement ce que le conteneur appelle :

```js
import PostgresMeta from "@supabase/postgres-meta/dist/lib/PostgresMeta.js";
import { getGeneratorMetadata } from "@supabase/postgres-meta/dist/lib/generators.js";
import { apply } from "@supabase/postgres-meta/dist/server/templates/typescript.js";

const pgMeta = new (PostgresMeta.default ?? PostgresMeta)({ connectionString: process.argv[2] });
const { data } = await getGeneratorMetadata(pgMeta, {
  includedSchemas: ["public", "graphql_public"],
});
process.stdout.write(
  await apply({ ...data, detectOneToOneRelationships: true, postgrestVersion: "14.17" }),
);
await pgMeta.end();
```

Trois écarts font toute la différence entre un fichier utilisable et un diff de 8 000 lignes.
Les trois se règlent **dans la base de génération**, jamais à la main dans le fichier :

- **`graphql_public` et `postgrestVersion`.** Sans eux, la sortie perd le bloc
  `__InternalSupabase` et le schéma `graphql_public` que la prod porte. Le shim ne crée pas ce
  schéma : l'ajouter à la base de génération (une fonction `graphql()` stub suffit) et passer la
  version PostgREST lue dans le fichier committé.
- **pgTAP doit être ABSENT.** Le shim l'installe dans `public`, où la prod le tient dans
  `extensions` : ses ~200 fonctions (`col_is_null`, `_todo`, `finish`…) entrent alors dans les
  types. Générer depuis une base **séparée** — shim sans pgTAP, extensions dans `extensions` —
  et garder la base pgTAP pour `pg_prove`.
- **Ce que la prod porte hors migrations.** Ici `_backup_subscriptions_20260609`, laissé par la
  suppression des abonnements et référencé nulle part : la chaîne de migrations ne le reproduit
  pas, donc une génération « propre » le **supprimerait** des types. Le recréer dans la base de
  génération avant de générer. C'est le contrôle qui compte : `diff` contre le fichier committé,
  et **rien ne doit disparaître** qui ne soit expliqué.

Reste des écarts de **mise en forme** (prettier ré-enveloppe des objets selon les sauts de ligne
de la source) : sans portée, mais ils gonflent le diff — le relire par `grep '^-[^-]'` plutôt
qu'en entier.

## Ce que ça ne prouve PAS

Un shim n'est pas Supabase. Il approxime les rôles et `auth.*` ; il ne rejoue ni le pooler, ni
les extensions cloud, ni le comportement exact de `supabase db push`. Il est excellent pour
**itérer** — la logique métier, les grants, les RLS, les `SECURITY DEFINER`, la
reconstructibilité — et il ne remplace pas `db-tests.yml` comme **preuve**. La règle de conduite
qui en découle tient en une phrase :

> On itère en local jusqu'à ce que tout soit vert, puis on laisse `db-tests.yml` confirmer sur la
> vraie pile. Un vert local n'autorise pas à sauter le rouge de la CI ; il fait qu'on n'y arrive
> presque jamais.

Corollaire vérifié sur les cinq lots de l'étude 30 : les suites livrées étaient vertes en CI du
premier coup, et les trois défauts trouvés en route (un plancher BKT mal compris, une garde de
session manquante, une fixture verte pour la mauvaise raison) l'ont été **en local**, en
secondes, alors qu'ils auraient coûté trois dispatches.

## Le piège qui rend un test vert pour la mauvaise raison

Découvert au lot 4, et il vaut pour toute suite qui teste une **sélection** : si la fixture
rend le chemin qu'on ne teste PAS suffisant à produire le résultat attendu, l'assertion est
verte **avant même que le code testé existe**. En l'espèce, taguer les cinq questions de la
fixture faisait entrer toutes les destinations par la voie « tag » — celle que le lot ne touchait
pas — et l'assertion mesurait le repli, pas la décision.

La parade est mécanique : **écrire l'assertion, puis la faire échouer exprès** en retirant le
code testé. Si elle reste verte, elle ne teste pas ce qu'on croit.
