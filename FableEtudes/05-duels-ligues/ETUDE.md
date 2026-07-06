# Étude 05 — Duels temps réel & ligues

> **Statut** : en exécution (GO humain 2026-07-06 — lots 1→4 livrés : duel jouable en polling + couche Realtime presence/progression ; Q-1/Q-4 tranchées §7 ; ⚠️ seul le lot 5 « ligues » reste, bloqué sur Q-3)
> **Priorité** : 05 · **Valeur** : rétention/engagement — compétition directe entre élèves, boucle sociale au-dessus du contenu existant · **Complexité** : très haute
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : Étude 01 (revenus d'abord), infra Supabase Realtime activée sur le projet · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/logging-standard.md`, `docs/environment-variables.md`

## 1. Contexte & objectif produit

Aujourd'hui la compétition est **passive** : leaderboard global/par matière (`getLeaderboard`,
`get_global_leaderboard`) et Dungeon solo chronométré. Aucune interaction directe élève↔élève.
Le duel 1v1 crée une boucle d'engagement courte (« défie un pair sur les mêmes questions ») qui
réutilise 100 % du contenu existant (`exercises`/`questions` du parcours actif) et le patron de
scoring server-side du Dungeon (`submit_dungeon_answer`).

- **Résultat attendu (v1)** : un élève entre en file, est apparié à un pair du **même parcours**,
  les deux répondent au **même set figé** de questions ; le score est calculé serveur ; le
  résultat tombe même si l'adversaire joue plus tard (asynchrone-tolérant).
- **KPI** : % de DAU lançant ≥ 1 duel ; duels terminés / duels créés (> 70 %) ; rétention J7 des
  duellistes vs non-duellistes ; temps médian d'appariement.
- **Ce que l'epic NE fait PAS** : pas de serveur de jeu dédié, pas de WebRTC, pas de chat, pas de
  mode spectateur, pas de tournois. Les **ligues** sont un lot v2 séparé (lot 5), dernier.

## 2. Spécification fonctionnelle

### Acteurs & parcours (élève uniquement ; parent/admin hors périmètre)

- **US-1** : en tant qu'élève, je rejoins une file d'attente depuis `/duel` et je vois un état
  « recherche d'adversaire… » (annulable).
- **US-2** : apparié, je joue un set de N questions (même set que l'adversaire), une par une,
  avec le même écran de réponse que le Dungeon (options mélangées, pas de clé côté client).
- **US-3** : je vois l'avancement de l'adversaire en temps réel (« a répondu à Q3 ») quand il est
  en ligne — jamais ses réponses ni son score en cours.
- **US-4** : si l'adversaire est hors-ligne, je termine quand même ; le duel reste `active`
  jusqu'à ce qu'il joue ou que `expires_at` passe ; je suis notifié du résultat final.
- **US-5** : à la fin (les deux ont fini, ou expiration), je vois le récapitulatif : scores,
  vainqueur, corrigés (review) — **jamais avant** que le duel soit `finished`/`expired`.
- **US-6** : je gagne XP/coins selon le résultat, dans la limite anti-farm quotidienne.
- **US-7 (v2, lot 5)** : je vois ma ligue hebdomadaire (tranche de classement) et je reçois la
  récompense de fin de semaine par notification.

Écrans (mobile-first, RTL) : `/duel` (hub : file + duels en cours + historique), `/duel/$duelId`
(jeu), récap final. États vides (« aucun duel »), chargement, erreur (retry), file annulable.

### Règles métier

- **R-1** : appariement uniquement entre deux élèves du **même parcours** (`duel_queue.parcours_id`).
- **R-2** : le set de questions est **figé au matchmaking** (`duels.question_ids uuid[]`) — mêmes
  questions, même ordre, pour les deux joueurs ; tirées d'exercices du parcours du duel.
- **R-3** : tout scoring passe par le RPC `submit_duel_answer` (patron `submit_dungeon_answer`) ;
  la clé de réponse n'est **jamais** transmise au client avant la fin du duel (R-6).
- **R-4** : Realtime = présence + notification d'avancement **uniquement** ; aucun payload de
  réponse, de score ou de clé ne transite par broadcast.
- **R-5** : anti-triche timing : timestamp serveur par réponse dans `duel_participants` ; une
  réponse < `MIN_SECONDS_PER_QUESTION` (constante existante, 4 s) est marquée `too_fast` et
  comptée fausse pour le score.
- **R-6** : le review (clé + explication) n'est visible qu'une fois `duels.status ∈ {finished, expired}`.
- **R-7** : anti-farm : au plus `DUEL_MAX_REWARDED_PER_DAY` duels **récompensés** par jour
  (constante à ajouter dans `src/shared/constants/gamification.ts`) ; au-delà, le duel se joue
  mais rapporte 0 XP/0 coins.
- **R-8** : le perdant **ne perd jamais** d'XP ; il reçoit une récompense de participation réduite.
- **R-9** : un duel non terminé à `expires_at` (défaut 24 h) passe `expired` : le joueur ayant
  fini est vainqueur par forfait ; si aucun n'a fini, aucun vainqueur, aucune récompense.
- **R-10** : au plus 1 entrée en file et `DUEL_MAX_ACTIVE` duels actifs simultanés par élève.
- **R-11** : quitter mid-duel ne supprime rien : le duel reste `active` jusqu'à reprise ou expiry.
- **R-12** : Realtime indisponible → dégradation en asynchrone pur (polling TanstackQuery sur
  `get_duel_state`, résultat notifié) ; aucune fonctionnalité bloquée.

### i18n / Hors périmètre (v1)

- Clés FR/EN/AR dans `@/lib/i18n` (`duel.*`) ; écrans RTL (l'arène affiche les deux avatars —
  vérifier le miroir des barres de progression en RTL).
- Hors périmètre v1 : ligues (lot 5), défis à un ami précis par lien, revanche automatique,
  matchmaking cross-grade (Q-2), classement de duels dédié.

## 3. Architecture technique (décisions fermées)

### Modèle de données (migration additive + pgTAP ; grants EXPLICITES — gotcha CLAUDE.md)

```sql
CREATE TABLE public.duel_queue (
  user_id     UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  parcours_id TEXT NOT NULL REFERENCES public.parcours(id) ON DELETE CASCADE,
  grade_id    UUID REFERENCES public.grades(id),
  enqueued_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE public.duels (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parcours_id     TEXT NOT NULL REFERENCES public.parcours(id),
  exercise_source TEXT NOT NULL DEFAULT 'parcours_pool',
  question_ids    UUID[] NOT NULL,          -- set figé au matchmaking (R-2)
  status          TEXT NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','active','finished','expired')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at      TIMESTAMPTZ NOT NULL
);
CREATE TABLE public.duel_participants (
  duel_id               UUID NOT NULL REFERENCES public.duels(id) ON DELETE CASCADE,
  user_id               UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  score                 INT NOT NULL DEFAULT 0,
  finished_at           TIMESTAMPTZ,
  answers_submitted_at  TIMESTAMPTZ[] NOT NULL DEFAULT '{}',  -- 1 ts serveur/question (R-5)
  PRIMARY KEY (duel_id, user_id)
);
```

RLS : `duel_queue` owner-only (SELECT/INSERT/DELETE `user_id = auth.uid()`, jamais d'UPDATE) ;
`duels` et `duel_participants` : SELECT réservé aux participants (`EXISTS` sur
`duel_participants`), **aucun write client** (`REVOKE INSERT, UPDATE, DELETE … FROM authenticated, anon;`
`REVOKE ALL … FROM anon;` + `GRANT SELECT … TO authenticated;` — patron exact de
`20260608120000_parcours_entity.sql`). Index : `duel_queue(parcours_id, enqueued_at)`,
`duels(status, expires_at)`, `duel_participants(user_id)`.

### Server (RPCs SQL + server fns)

- `match_duel()` — SECURITY DEFINER, `search_path = public`. Insère l'appelant en file (upsert),
  puis apparie **atomiquement** les 2 plus anciens compatibles (même `parcours_id`) via
  `SELECT … FROM duel_queue WHERE parcours_id = … ORDER BY enqueued_at LIMIT 2 FOR UPDATE SKIP LOCKED`;
  si 2 lignes : crée `duels` (tirage `question_ids` dans le pool du parcours) + 2
  `duel_participants`, supprime les 2 lignes de file, retourne le `duel_id` (sinon NULL = en attente).
- `submit_duel_answer(p_duel, p_question, p_choice)` — SECURITY DEFINER, calqué sur
  `submit_dungeon_answer` : vérifie participant + statut `active` + question ∈ set + non déjà
  répondue ; horodate (`answers_submitted_at`), applique R-5, incrémente `score` ; ne retourne
  **ni** `correctChoice` **ni** `explanation` tant que le duel n'est pas fini (R-6, diff. Dungeon).
- `finalize_duel(p_duel)` — appelé au dernier submit des deux joueurs OU par le cron d'expiry :
  passe `finished`/`expired`, calcule le vainqueur, crédite via `award_duel_rewards` (variante
  contrôlée d'`award_xp` : plafond R-7, plancher R-8) — REVOKE anon/authenticated sur celle-ci.
- `get_duel_state(p_duel)` — participant-only : statut, index courant, avancement adverse
  (compteur seul), et le review complet uniquement si fini.
- Server fns dans `src/features/duel/duel.server.ts` (patron `dungeon.server.ts`) :
  `joinDuelQueue`, `leaveDuelQueue`, `getDuelState`, `submitDuelAnswer`, `getDuelHistory` —
  toutes `createServerFn` + `requireSupabaseAuth` + zod (`.inputValidator`) + `isRateLimited`
  - `failWithClientError`.

### Client / Realtime / Observabilité

- `src/features/duel/` : `index.ts` (barrel), `duel.server.ts`, `components/` (`DuelArena`,
  `DuelQueueCard`, `DuelRecap`, `OpponentProgress`), `__tests__/`. Routes
  `routes/_authenticated/duel/index.tsx` et `duel/$duelId.tsx` (thin). **Jamais** d'import d'une
  autre feature — partages via `src/shared/` (constantes → `gamification.ts`).
- Realtime : canal privé `duel:{duelId}` — **presence** (adversaire en ligne) + **broadcast**
  `{ type: "progress", answeredCount }` émis par le client _après_ ACK du RPC. Hook
  `useDuelChannel` avec fallback polling `get_duel_state` (5 s) si le canal ne s'établit pas (R-12).
- Expiry : job cron du patron `notifications.cron.server.ts` (feature `notifications` existante)
  balaie `duels WHERE status='active' AND expires_at < now()` → `finalize_duel` + notification.
- Logs structurés via `@/shared/lib/logger` : `duel.matched`, `duel.finished`, `duel.expired`,
  `duel.realtime_fallback` (mesure du taux de dégradation).

### Décisions d'architecture (ADR)

- **D-1** : Supabase Realtime (broadcast + presence), **pas** de serveur de jeu dédié — coût nul,
  déjà dans la stack (`wss://*.supabase.co` déjà en CSP `connect-src`) ; rejeté : serveur WS
  dédié (infra + ops disproportionnés pour un 1v1 tour par tour).
- **D-2** : matchmaking en SQL (`FOR UPDATE SKIP LOCKED`) — atomicité sans coordinateur ;
  rejeté : matchmaking applicatif (courses entre instances serverless Vercel).
- **D-3** : duel asynchrone-tolérant (expiry 24 h) — un élève tunisien à connectivité
  intermittente peut toujours finir ; rejeté : duel strictement synchrone (taux d'abandon rédhibitoire).
- **D-4** : scoring 100 % RPC, Realtime jamais dans le chemin de confiance — invariant
  « clé jamais côté client » (identique Dungeon) ; rejeté : score déclaré par le client.
- **D-5** : récompenses par variante contrôlée (`award_duel_rewards`), pas d'appel direct à
  `award_xp` depuis le client-path — plafond quotidien centralisé dans `gamification.ts`.
- **D-6** : ligues = agrégation hebdomadaire _au-dessus_ des duels (vue matérialisée ou requête
  agrégée duels de la semaine + XP), récompenses via le cron notifications existant — aucun
  nouveau canal ; rejeté : table de ligue temps réel mise à jour à chaque duel.

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                       | fichiers/objets créés                                                     | tests exigés                       | dépend de        |
| --- | ------------------------------------------------------ | ------------------------------------------------------------------------- | ---------------------------------- | ---------------- |
| 1   | Migration tables + RLS + grants + index                | `supabase/migrations/…_duels.sql`                                         | pgTAP (RLS, grants, contraintes)   | —                |
| 2   | RPCs matchmaking + scoring + finalize + expiry cron    | `match_duel`, `submit_duel_answer`, `finalize_duel`, `get_duel_state`     | pgTAP (atomicité, R-1…R-9)         | 1                |
| 3   | Feature + UI duel en **polling** (sans Realtime)       | `src/features/duel/*`, routes `/duel`, `/duel/$duelId`, i18n `duel.*`     | Vitest co-localisés (US-1…6, R-x)  | 2                |
| 4   | Realtime presence + progression + fallback             | `useDuelChannel`, `OpponentProgress` branché                              | Vitest (fallback R-12), e2e authed | 3                |
| 5   | **Ligues v2** : agrégat hebdo + tranches + récompenses | vue/requête ligue, RPC lecture, cron récompenses, UI `/duel` onglet ligue | pgTAP + Vitest                     | 3 (4 non requis) |

- [x] Lot 1 — migration `duel_queue`/`duels`/`duel_participants` (+ pgTAP). **Stop-point** : aucun RPC.
- [x] Lot 2 — RPCs + constantes `DUEL_*` dans `gamification.ts` + balayage expiry. **Stop-point** : aucune UI.
- [x] Lot 3 — feature `duel/` complète en polling, utile seule (R-12 est le mode nominal ici). **Stop-point** : pas de Realtime.
- [x] Lot 4 — canal `duel:{duelId}`, presence, broadcast progression, fallback prouvé. **Stop-point** : pas de ligues.
- [ ] Lot 5 — ligues hebdomadaires (après arbitrage Q-3/Q-4). **Stop-point** : rien au-delà (saisons, tournois).

Chaque lot = une PR, gate verte (`npm run verify`), migration **avant** le code qui la lit (DoD §7).

## 5. Stratégie de test

- **pgTAP** (lots 1–2, 5) : RLS (non-participant ne lit rien ; owner-only sur la file), grants
  explicites, atomicité de `match_duel` (deux appels concurrents ne créent qu'un duel — SKIP
  LOCKED), R-2 (set identique), R-5 (`too_fast`), R-7/R-8 (plafond/plancher), R-9 (expiry).
- **Vitest co-localisés** (`src/features/duel/__tests__/`) : parsing des payloads RPC (patron
  `parseDungeonAnswerPayload`), états UI (file, arène, récap, expiré), fallback polling.
- **Playwright e2e** (projet TEST uniquement) : duel complet entre les deux users seedés
  (`scripts/e2e/seed-test-users.mjs`), review masqué avant la fin.
- **smoke:shell** : inchangé mais obligatoire au vert — le client Realtime entre dans le bundle
  prod (chunk vendor : attention au `manualChunks` hand-tuné, re-run `build:check`).
- Non-régression : suites Dungeon/quest/dashboard existantes intactes ; aucune modification
  d'`award_xp` ni de `submit_exercise_attempt`.

## 6. Risques & mitigations

- **RISK-1** — Charge/quotas Realtime (connexions simultanées, plan Supabase). _Prob. moyenne,
  impact moyen._ Mitigation : 1 canal par duel actif seulement, fermé au récap ; fallback polling
  natif (R-12) ; métrique `duel.realtime_fallback` pour dimensionner avant d'ouvrir large.
- **RISK-2** — Abandon mid-duel → duels zombies. _Prob. haute, impact faible._ Mitigation :
  `expires_at` + cron d'expiry (R-9, R-11) ; forfait déterministe ; historique purgeable.
- **RISK-3** — Triche (réponses instantanées, multi-comptes, set fuité). _Prob. moyenne, impact
  moyen._ Mitigation : timestamps serveur + `MIN_SECONDS_PER_QUESTION` (R-5), set figé serveur
  (R-2), clé jamais côté client (R-3/R-6), plafond de récompenses (R-7), rate limiting par fn.
- **RISK-4** — Course au matchmaking (double appariement). _Prob. faible, impact haut._
  Mitigation : transaction unique `FOR UPDATE SKIP LOCKED` (D-2) + PK sur `duel_queue.user_id` +
  test pgTAP de concurrence.
- **RISK-5** — File vide (peu de joueurs au même moment sur le même parcours). _Prob. haute au
  lancement, impact moyen._ Mitigation : mode asynchrone-tolérant (D-3) rend l'attente courte
  acceptable ; timeout de file côté UI avec sortie propre ; Q-2 (cross-grade) en levier futur.

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — TRANCHÉE (2026-07-06, délégation humaine « meilleures pratiques »)** : barème ancré sur
  l'économie existante (exercice pratique ≈ 75 XP / 15 coins). **Vainqueur 60 XP / 12 coins**,
  **perdant 20 XP / 4 coins** (participation, jamais négatif — R-8), **nul 40 XP / 8 coins**,
  **forfait** (adversaire expiré) = barème vainqueur. **`DUEL_MAX_REWARDED_PER_DAY = 5`** (miroir du
  cap Dungeon). Set de **5 questions**, expiry **24 h**, **3 duels actifs** max. Constantes dans
  `src/shared/constants/gamification.ts` (`DUEL_*`), miroir SQL dans les RPCs.
- **Q-2** : autoriser un matchmaking **cross-grade** (même thème, grades adjacents) quand la file
  du parcours est vide ? Impact équité — v1 reste strictement même parcours (R-1). _(Non requis
  avant le lot 3 ; levier futur si les files sont vides.)_
- **Q-3** : ligues — durée de saison (semaine ISO ? saison scolaire ?), nombre de tranches, et
  récompenses de fin de saison (cosmétique vs coins). _(À trancher avant le lot 5.)_
- **Q-4 — TRANCHÉE (2026-07-06, délégation humaine « meilleures pratiques »)** : les duels sont
  **ouverts à TOUS les parcours** (FREE + premium), **sans gate d'entitlement**. Un duel est une
  mécanique de rétention dont la valeur dépend de la profondeur de la file (effet réseau ; cf.
  RISK-5 file vide) ; le réserver au premium tuerait la boucle sociale. La monétisation reste sur
  le contenu (parcours concours). Différent du Dungeon (perk de consommation de contenu) —
  volontairement. Matchmaking intra-parcours conservé (R-1).

## 8. Journal d'exécution

- **2026-07-06 — Lot 1 livré** (migration `20260706160000_duels_schema.sql` + pgTAP
  `21_duels_schema.test.sql`, 20 assertions — suite 245/245 sur base vierge). Les 3 tables
  (`duel_queue` owner-only ; `duels` + `duel_participants` participant-SELECT, aucun write
  client), grants explicites (patron `parcours_entity`), index. Stop-point respecté : AUCUN RPC
  de jeu.
  **Écart accepté n°1** : la visibilité « participant » est portée par un prédicat
  `is_duel_participant(duel, user)` **SECURITY DEFINER**, au lieu de l'`EXISTS` sur
  `duel_participants` inline que l'étude écrit dans la policy de `duel_participants` elle-même —
  ce dernier déclenche la **récursion RLS infinie** de Postgres (même piège corrigé pour l'admin
  par `20260526260000_fix_admin_rls_recursion.sql`). L'intention (visibilité strictement
  participant, les deux lignes du duel lisibles) est **préservée à l'identique** ; c'est le patron
  déjà établi du repo (`is_admin()`), pas un RPC de jeu. La policy de `duels` réutilise le même
  prédicat (elle aussi aurait récursé via `duel_participants`).
  **Note de blocage** : les lots 2+ (RPCs) restent **bloqués** tant que l'humain n'a pas tranché
  **Q-1** (barème récompenses + `DUEL_MAX_REWARDED_PER_DAY`) et **Q-4** (duels premium-only vs
  FREE) — ce sont des décisions produit préalables au lot 2/lot 3. Dépendance **Realtime**
  (Supabase Realtime activé sur le projet) requise seulement au lot 4.
- **2026-07-06 — Lot 2 livré** (migration `20260706170000_duels_rpcs.sql` + pgTAP
  `22_duels_rpcs.test.sql`, 21 assertions — suite 266/266 sur base vierge ; verify 1082 tests).
  Les 5 RPCs (`match_duel` SKIP LOCKED, `submit_duel_answer` ordonné + R-5 + R-6, `finalize_duel`
  barème/cap, `get_duel_state` participant-only, `expire_duels` + pg_cron) + `award_duel_rewards`.
  **Q-1 et Q-4 tranchées** (§7) par délégation humaine (« fais les décisions selon les meilleures
  pratiques »). Constantes `DUEL_*` dans `gamification.ts`.
  **Écart accepté n°2** : `award_duel_rewards` est une fonction dédiée (et non un appel direct à
  `award_xp`) car `award_xp` porte un garde self-only (`auth.uid() = p_user`) qui bloquerait la
  récompense de l'adversaire depuis `finalize_duel` ; la variante recopie la courbe niveau/classe/
  tier d'`award_xp` **sans** toucher au streak (piloté par le chemin exercice/quiz) — conforme à
  l'esprit de D-5 (« variante contrôlée d'award_xp »).
  **Écart accepté n°3** : colonne additive `duel_participants.rewarded_at` (non prévue au schéma du
  lot 1) pour compter le cap quotidien R-7 sans re-scan — additive, RLS déjà en place.
  **Note** : la concurrence stricte de `match_duel` (deux appels simultanés → un seul duel via
  `FOR UPDATE SKIP LOCKED`) est garantie par conception ; le pgTAP mono-transaction couvre
  l'appariement fonctionnel + R-1/R-2, la concurrence réelle sera re-vérifiée en e2e (lot 3+).
- **2026-07-06 — Lot 3 livré** (feature `src/features/duel/` complète en **polling**, pas de
  Realtime — R-12 est le mode nominal). Server fns (`matchDuel`/`leaveDuelQueue`/`getDuelState`/
  `getDuelQuestions`/`submitDuelAnswer`/`getDuelHistory`, `createServerFn`+`requireSupabaseAuth`+
  zod+rate-limit) ; composants `DuelQueueCard`/`DuelArena`/`DuelRecap`/`OpponentProgress` ;
  routes `/duel` (hub) + `/duel/$duelId` (jeu, `refetchInterval` tant que `active`) ; namespace
  i18n `duel.*` FR/EN/AR ; Vitest co-localisés (`duel-components.test.tsx`, 11 assertions :
  verdict win/loss/draw/forfait, progression adverse R-3, écran de jeu). Q-4=ouvert → aucun gate
  premium dans l'UI. Gates : verify (1093 tests) + build:check + smoke:shell verts. **Pas de
  migration** dans ce lot.
  **Deux manques de la surface RPC du lot 2, comblés côté server-fn sans nouvelle migration** :
  (1) les RPCs n'exposent les prompts qu'au `review` post-partie → `getDuelQuestions` lit le set
  figé `duels.question_ids` (RLS participant) + les colonnes **masquées** de `questions`
  (`id/prompt/options/question_type` ; `correct_option`/`answer_key`/`explanation` restent
  revoked) — R-6 tenu, aucune clé fuitée. (2) le recap a besoin du verdict : `getDuelState`
  révèle le score final de l'adversaire **uniquement une fois le duel réglé** (R-3 tenu pendant
  la partie).
  **Écart accepté n°4** : `src/shared/integrations/supabase/types.ts` édité à la main (tables
  `duel_*` + RPCs `match_duel`/`submit_duel_answer`/`get_duel_state`) car `supabase gen types`
  n'a pas été relancé dans cette session offline (DoD §4 permet un hand-edit minimal et noté ;
  commentaire ajouté dans le fichier).
  **Écart accepté n°5** : budget bundle `i18n-` relevé 96→100 KB (croissance légitime du
  namespace trilingue `duel.*` ; gzip ~30 KB, impact réseau marginal — documenté dans
  `scripts/check-bundle-budget.mjs`).

### ⚠️ Suite bloquée (fin des lots livrables sans dépendance externe)

Les lots 1→3 sont livrés : le duel est **jouable de bout en bout en polling**. Les deux lots
restants ont des blocages externes :

- **Lot 5 (ligues hebdomadaires)** : requiert l'arbitrage humain **Q-3** (durée de saison, nombre
  de tranches, récompenses de fin de saison).

- **2026-07-06 — Lot 4 livré** (GO humain « activer Realtime »). Couche Realtime d'**enrichissement**
  au-dessus du polling autoritatif : hook `src/features/duel/use-duel-channel.ts` — canal privé
  `duel:{duelId}` en **presence** (adversaire en ligne) + **broadcast `progress` `{answered}`**
  émis à chaque avancée (R-4 : aucun payload de réponse/score/clé ne transite). Câblé dans
  `/duel/$duelId` : la progression adverse préfère le signal live quand Realtime est actif, sans
  jamais régresser sous la valeur pollée (`Math.max`) ; `OpponentProgress` gagne un point
  « en ligne » (i18n `online`/`offline`). **R-12 tenu** : le polling `get_duel_state` reste
  toujours actif et source de vérité (statut/score/review) ; si le canal n'établit pas
  (`CHANNEL_ERROR`/`TIMED_OUT`/`CLOSED`), `realtimeActive=false`, log `duel.realtime_fallback`, et
  l'UI continue sur le polling. Tests Vitest `use-duel-channel.test.ts` (6 : subscribe/track,
  broadcast, presence, fallback R-12 + log, cleanup). **Pas de migration.** Gates : verify
  (1124 tests) + build:check + smoke:shell verts.
  **Note infra** : le lot 4 utilise **broadcast + presence** (D-1), pas les Postgres-changes —
  ces canaux passent par le service Realtime intégré (`wss://*.supabase.co`, déjà en CSP), donc
  **aucun toggle de réplication côté projet n'est requis** ; le hook dégrade proprement si le
  service est indisponible.
  **Écart accepté n°6** : le budget bundle `i18n-` était déjà relevé à 100 KB au lot 3 ; les 2
  clés `online`/`offline` restent sous ce plafond (pas de nouveau relèvement).
