# Dette technique — ce qui reste vraiment ouvert

> **Re-vérifié dans le code le 2026-08-26** (`main` à #884) — la passe précédente datait du
> 2026-08-02 (#703), et l'écart entre les deux est la meilleure démonstration de la règle
> ci-dessous : trois des quatre lignes « ouvertes » citaient un chiffre que le code avait
> démenti. Ce fichier remplace le plan d'action
> de l'audit du 2026-06-30, dont la moitié des items « ouverts » étaient soldés sans que
> personne ne coche la case — c'est précisément le genre de rot qu'un backlog non vérifié
> produit. **Règle** : on n'inscrit ici qu'une dette dont on a re-lu la ligne de code, et on
> la sort quand la ligne a changé, pas quand on croit s'en souvenir.
>
> L'audit d'origine est archivé : [`docs/archive/2026-06-30-audit-codebase.md`](./archive/2026-06-30-audit-codebase.md)
> (+ ses métriques `.csv`). Les axes **perf** ont leur propre document vivant,
> [`docs/performance-audit.md`](./performance-audit.md), et son harnais de charge
> [`perf/README.md`](../perf/README.md).

## Ouvert

> **Re-mesuré le 2026-08-26** (`main` à #884), ligne de code par ligne de code, par une passe
> qualité à 6 axes. Ce que la re-mesure a trouvé mérite d'être dit, parce que c'est exactement
> ce que l'en-tête ci-dessus interdit : **trois des quatre lignes citaient des chiffres que le
> code avait démentis**. Le compteur de `quest.server.ts` datait de douze jours et sous-estimait
> de 22 lignes ; surtout, il désignait le mauvais fichier — deux autres sont plus gros.

| Dette                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Où                                                                                                                | Effort | Axe        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------- | ------ | ---------- |
| **Les 13 vues d'ombre du client Supabase hors des features nettoyées.** Re-compté le 2026-11-12 (`grep "as unknown as"` hors tests) : `ai-vault.server.ts` (1), `features/ai/ai-access.server.ts` (1), `features/auth/` (3 : `welcome-pack.server.ts`, `auth.server.ts` ×2), `features/parent-report/` (1), `features/notifications/notifications.cron.server.ts` (2, plus la **dernière** recopie de la prémisse fausse « sans accès DB »), `features/shop/` (1), `features/tutor/` (2 : `tutor.practice.server.ts`, `digest.server.ts`), et un cast de LIGNE à part, `quest.lesson.server.ts` (`videos` JSONB → `CompiledVideo[]`). La ligne précédente en annonçait 10 **en tout** : le compte datait d'août et la source a coulé depuis. La méthode est écrite et éprouvée (voir « Soldé ») : signature SQL lue AVANT de choisir — **(A)** `DEFAULT NULL` → `?? undefined`, zéro cast ; **(B)** obligatoire mais nullable → `nullableRpcArg()` ; **(C)** le SQL refuse NULL → rendre la garde prouvable — et, quand la FORME DE RETOUR diverge (union fermée, nullabilité), un schéma Zod dans `shared/integrations/supabase/rpc-rows.ts`, jamais un cast. **La source ne coule plus** : `local/no-supabase-shadow-view` (née verte le 2026-11-12) refuse tout nouveau cast du client, et ces fichiers sont nommés un à un dans son `PENDING_FILES` — le test de la règle échoue dès que l'un d'eux est propre, donc la liste ne peut que rétrécir | `src/features/{ai,auth,notifications,parent-report,shop,tutor}/`, `src/shared/integrations/ai/ai-vault.server.ts` | M      | 📝 Qualité |

## Latent — réveillé seulement par un retour du premium

| Dette                                                                                                                                                                                                                                                                              | Où                                                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| **N+1 sur `has_parcours_entitlement`** — un appel RPC par parcours. **Ne se déclenche pas aujourd'hui** : les deux sites d'appel court-circuitent sur `!p.is_premium`, et la phase gratuite met `is_premium = false` partout. À batcher **avant** tout dégel du premium (étude 01) | `src/features/dashboard/dashboard.server.ts:323, :769` |

## Soldé depuis l'audit (2026-06-30 → 2026-08-13)

- **Pas de _budget_ de perf runtime** — soldé le 2026-11-12 : `npm run perf:budget`
  (`perf/runtime/check-budget.mjs`, étape de `ci.yml` après `smoke:shell`) sert le bundle de
  production en local, charge `/` et `/programme` dans un Chromium bridé au profil téléphone
  (150 ms, 1,6 Mbit/s, CPU ÷ 4) et fait échouer la CI au-delà des plafonds de
  `perf/runtime/budget.mjs` : requêtes, octets transférés, JavaScript, HTML (déterministes,
  marge ≈ 3 %) et LCP (médiane de cinq, plafond au double du réel — il n'attrape que le premier
  rendu qui se met à attendre le JavaScript). **Reste ouvert, et c'est écrit dans le budget** :
  les pages à contenu (cours, matière, exercice) ne rendent pas sans base ; leur LCP se mesure
  en production (`perf/runtime/measure-pages.mjs`, `docs/performance-audit.md` §0-quater).

- **Les vues d'ombre RPC de `dashboard/`, `progression/`, `quest/`, `adaptive-inputs` et
  `usage.server`** — soldé le 2026-11-12. Mesure sur le diff : **22 casts `as unknown as` retirés**
  (plus 5 `supabase as XClient` posés sur un paramètre `unknown`, que le `grep` de la dette ne
  voyait pas), **20 types de vue supprimés**, **16 recopies de la prémisse fausse** (« `gen types`
  exige un accès DB indisponible en session ») effacées — il en reste **une**, hors périmètre
  (ligne « Ouvert »). 423 lignes retirées, 206 ajoutées, tests compris. **L'arbitrage de la forme
  de retour est pris, une fois** : elle se valide à la frontière. `rpc-rows.ts` porte un schéma Zod
  par RPC en `RETURNS TABLE`, tenu au type de l'application par `satisfies`, et `parseRpcRows`
  écarte la ligne hors contrat en la journalisant en erreur (chemin et code, jamais la valeur) au
  lieu de la laisser passer mal typée ; les autres lignes vivent, fidèle à la dégradation gracieuse
  de ces lectures. Chaque nullabilité a été relue dans le SQL, et la relecture a payé :
  `get_remediation_path.is_root_cause` rend **NULL** (pas `false`) quand tout le chemin est maîtrisé
  — un schéma naïf aurait écarté ces lignes et crié à la dérive sur un état normal. Côté arguments,
  sept `null` sont devenus des omissions (classe A, `DEFAULT NULL`), dont quatre dans `logAiUsage`,
  ce qui retire les quatre casts que ses appelants portaient. **`rate-limit.ts` n'était pas une
  dette** : sa vue est un type de paramètre auquel le vrai client est assignable — aucun des 28
  appelants ne caste —, c'est une inversion de dépendance qui tient ; rien n'y a bougé.

- **Tier A (é20) qui préfixait « ال » sans condition** — la ligne était périmée : relue le
  2026-11-12, la garde existe déjà (`canTakeArabicArticle`, `free-answer.ts`, présente sur `main`
  au plus tard à #1181, 2026-10-20) et refuse un chiffre, la classe fermée des particules, un mot
  annexé à un pronom et une tête مضاف. Le cas du pilote est figé par un test
  (`free-answer.test.ts` : « فوقها » ne rend plus « الفوقها », « 3 » et « في » ne rendent rien), donc
  plus aucune variante morte ne consomme la borne des 24. Exactement le rot que l'en-tête décrit —
  une dette soldée sans que personne ne coche la case.

- **La capture d'erreur SSR qui n'attrapait rien sous Node** — soldé le 2026-11-12, et pas par le
  correctif que la ligne prescrivait. Relue avant d'y croire, elle était juste sur le symptôme et
  fausse sur le remède : `process.on("uncaughtException" / "unhandledRejection")` n'aurait **rien
  attrapé non plus**. Mesure sur Node 24.22 avec le vrai `handleStartError` de TanStack Start
  1.169.45 : **0 événement `process`** pour un throw avalé — le framework l'attrape lui-même, le passe
  à `console.error` (sauf s'il porte un statut HTTP d'erreur, auquel cas il ne journalise **rien**),
  puis fabrique la réponse. Et un écouteur `uncaughtException` n'est pas neutre : sa seule présence
  empêche Node de terminer le processus. Le correctif retenu : `captureError()` dans
  `error-capture.ts`, appelée par le middleware de requête de `src/start.ts` au moment où il laisse
  remonter une erreur à statut — le seul endroit où elle est encore visible ; l'écouteur
  navigateur/Worker reste. **La relecture a trouvé plus grave au passage** : depuis la montée de
  dépendances du 2026-11-11 (#1241, Start 1.169.40 → 1.169.45, h3 retiré), le corps du 500 avalé
  porte une clé `statusText` que la liste fermée de `server.ts` refusait — **plus aucun 500 avalé
  n'était reconnu**, donc ni page d'erreur de marque (le visiteur recevait le JSON brut) ni ligne
  `logger.error`. Aucun test n'avait rougi : le corps y était écrit à la main. Il est désormais
  fabriqué par le vrai framework (test de contrat dans `server.test.ts`, vérifié rouge sans le
  correctif). Tests : 15 → 21 sur les trois fichiers, dont 3 pour le middleware, jusque-là sans test.

- **Les fichiers collés au plafond `max-lines: 750`** — soldé le 2026-11-03 (#1207, #1230, #1231,
  #1232 et la présente PR). Mesure ESLint, en lignes de **code** : `quest.server.ts` 746 → 502
  (lecture de chapitre et correction publique sorties), `subject-hub.test.tsx` 740 → 228 (un fichier
  par `describe` + `subject-hub-fixtures.ts`), `exercise-player.tsx` 740 → 622 (chronomètre du boss,
  portes du démarrage, en-tête de progression, bouton de validation), `routes/auth.tsx` 728 → 537
  (messages d'erreur, arrivée Google, trois composants), `quest.test.ts` 712 → 349 (le bloc
  `submitAttempt` à part), `tutor.server.ts` 700 → 480 (la boucle de compréhension, lot 4). Aucun
  test perdu : 31 → 31 et 30 → 30 dans les deux découpes de tests. **Plus aucun fichier à 700 lignes
  de code ou plus** ; les plus proches, à surveiller sans agir : `content-pipeline.test.ts` 690,
  `parent-report.test.ts` 688, `auth-signup.test.tsx` 659, `dashboard.server.ts` 655, `schema.ts`
  651, `etat-campagne.test.ts` 649. Les dictionnaires `src/lib/i18n/*.ts` sont hors règle par
  configuration.

- **`maxDuration: 300` recopié à trois endroits** — soldé le 2026-10-30 : une seule valeur,
  `SSR_MAX_DURATION_S` dans `scripts/vercel-function.mjs` (JS pur, lisible sur le builder Vercel
  quelle que soit sa version de Node, typé par un `.d.mts`). `build-vercel.mjs` et
  `tutor-digests.mjs` l'importent ; `forge-timeout.test.ts` aussi, au lieu d'extraire la valeur
  du texte par une regex, et le doublon en dur d'`openai-compatible.test.ts` est retiré.

- **Les primitives `components/ui` sans importeur** — soldé le 2026-10-27 : 32 des 56 primitives
  supprimées (calculé en point fixe : `separator` et `toggle` n'étaient importées que par
  `sidebar` et `toggle-group`, elles-mêmes mortes), avec les 27 paquets npm qui n'existaient que
  pour elles — dont `date-fns`, `lenis` et `@hookform/resolvers`, sans aucune référence. Le
  lockfile perd 36 entrées et n'en gagne aucune ; prouvé par `tsc`, `build:check` et le canari
  npm 10.

- **« Une feature n'importe jamais une autre » sans gate** — soldé le 2026-10-27 : huit violations
  supprimées avant de poser la règle, qui naît donc verte (`local/no-cross-feature-import`, tests
  compris). Arbitrage du propriétaire : la porte IA (`ai-call`, coffre, chiffrement, alertes de
  budget) est un **service partagé**, dans `src/shared/integrations/ai/` ; la saisie de question,
  ses plateaux et les confettis passent dans `src/components/game/`, `quest-labels` dans
  `src/shared/lib/`. Deux tests de route rangés sous une feature rejoignent `src/routes/__tests__/`.

- **L'environnement jsdom global** — soldé le 2026-10-27 : le docblock `// @vitest-environment node`
  (la voie de Vitest 4, voir `vitest.config.ts`) couvre 225 des 357 fichiers de test ; les 132
  restants rendent du DOM, et deux candidats qui échouaient sous `node` y sont restés. La suite est
  passée de 516 s (2026-08-26) à ~153 s ; la dernière repasse a fait gagner 11 s d'`environment`
  (109 s → 98 s, mesuré sur la même machine). Il n'y a plus de gros levier ici.

- **L'énergie d'un appel IA tué par la plateforme** — soldé le 2026-10-26 (migration
  `20261026100000`) : `ai_energy_ledger` gagne une colonne `reserved` (l'énergie encore en vol),
  soldée au succès par `settle_ai_energy`, rendue à la panne par `release_*`, et rendue par
  `sweep_ai_reservations()` après 5 minutes comme l'argent. Prouvé par
  `supabase/tests/105_ai_energy_sweep.test.sql`.

- **Le pont de types `client_errors` — et la dérive de `types.ts` qui le fabriquait** — soldé le
  2026-09-13 (audit du 2026-09-12, D-1) : le fichier était en retard de **28 RPC et 3 tables**
  vivantes. Il est désormais **régénéré depuis la chaîne** (`npm run db:gen-types`, sans Docker
  ni jeton prod) et gardé par `npm run db:check-types` dans `verify` ; le pont de
  `client-log.server.ts` est retiré, `client_errors` est typée comme les autres.

- **`npm ci` cassé sur `main`** — diagnostiqué ici le 2026-08-10 (#716 avait retiré du lock le
  `typescript@5.9.3` imbriqué dont `tsconfck` a besoin ; npm 10 mourait en `EUSAGE`), **corrigé
  sur `main` le 2026-08-10 par le revert #718**, qui cite la même erreur — la cause profonde
  était que le bump undici embarquait un miniflare 5 alpha. Reste vrai, et sans gravité : dev+CI
  tournent en **Node 24** (`.nvmrc`), la fonction SSR en prod en **`nodejs22.x`**
  (`build-vercel.mjs`) — deux chiffres qui cohabitent légitimement.

- **Élagage push ligne à ligne** — soldé le 2026-08-10 : les endpoints morts sont
  collectés puis supprimés en **un** `DELETE … IN (…)` par lot de 200 (l'`.in()`
  voyage dans l'URL, qui a un plafond). L'élagage est best-effort — les notifications
  sont déjà parties, un nettoyage raté ne fait plus échouer le cron.
  `notifications.cron.server.ts` ; deux tests épinglent le comportement (un seul
  aller-retour pour 5 endpoints morts, et `pruned: 0` si la suppression échoue).
- **Chunks vendor sans budget** (M1-fe de l'audit perf) — soldé le 2026-08-10 :
  `vendor-radix`, `vendor-icons` et `vendor-three` ont désormais un plafond.

Consigné parce que le plan d'action les portait encore comme ouverts :

- **Agrégats `subject_stats`** — le fetch non borné des `attempts` dans `getDashboard` a été
  remplacé par la RPC `get_user_subject_stats` (`GROUP BY subject_id`, une ligne bornée par
  matière). `dashboard.server.ts:238`.
- **Trous de tests** — `recoverStreak` est couvert (`progression/__tests__/progression.test.ts`),
  `handlePushCron` aussi (`notifications/__tests__/notifications.cron.test.ts`), et
  `content-protection.ts` a le sien (`shared/lib/__tests__/content-protection.test.ts`).
- **Quick wins de la PR #245** — redaction du logger étendue, `npm audit fix`,
  `no-unused-vars` réactivé, tag SemVer outillé (`release.yml`).
