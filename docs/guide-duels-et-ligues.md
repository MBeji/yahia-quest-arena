# Guide fonctionnel — Duels temps réel & ligues (étude 05)

> **Public** : produit, ops/infra, support, développeurs.
> **Statut** : livré en production (5 lots, PRs #313 / #315 / #320 / #321 / #322 / #323).
> Ce guide explique **comment ça marche pour l'élève et comment l'exploiter**. Le contrat
> d'architecture (RPC, RLS, invariants R-x) reste [`FableEtudes/05-duels-ligues/ETUDE.md`](../FableEtudes/05-duels-ligues/ETUDE.md).
> En cas de contradiction, CLAUDE.md et l'ETUDE.md priment.

## Ce que c'est

Un **duel** est un 1 contre 1 asynchrone-tolérant : deux élèves répondent au **même jeu de
5 questions figé**, chacun à son rythme, et le serveur départage sur le score. Une **ligue**
hebdomadaire agrège les duels de la semaine en un classement à points de championnat, avec des
paliers et un bonus de pièces en fin de saison. C'est une **feature de rétention/engagement** :
elle réutilise le contenu existant, ne crée pas de nouveau contenu.

## Le parcours élève

### Accès

Le hub des duels est la route **`/duel`**. ⚠️ **Note d'exploitation** : `/duel` n'est pas encore
ajouté au menu de navigation principal (dashboard / parcours / programme / dungeon / classement) —
il est aujourd'hui accessible par **URL directe** et par les liens vers un duel actif. Ajouter
l'entrée de menu est un petit follow-up produit (une ligne dans le shell `_authenticated.tsx`).

Prérequis : l'élève doit avoir un **parcours actif** (choisi à l'onboarding). Les duels sont
**ouverts à tous les parcours** — FREE comme premium — **sans gate premium** (décision Q-4 :
une feature de rétention a besoin de profondeur de file). Le duel se joue **sur le parcours actif**
de l'élève : on n'affronte que des adversaires du même couple (thème, niveau).

### Déroulé d'un duel

1. **« Trouver un adversaire »** → l'élève entre dans la file. Le hub _poll_ l'appariement toutes
   les 3 s. Tant qu'il n'y a pas de partenaire, il reste en attente (état normal) ; il peut annuler.
2. **Appariement** : dès que deux élèves compatibles sont en file, le serveur crée le duel, **fige
   5 questions** tirées du pool du parcours, et navigue les deux joueurs vers `/duel/$duelId`.
3. **Jeu** : chacun répond aux 5 questions **dans l'ordre figé**, à son rythme. Le score est
   calculé **côté serveur** (la clé de réponse n'est jamais envoyée au client avant la fin — R-3/R-6).
4. **Fin** : quand les deux ont fini (ou à l'expiration), le duel est _finalisé_, le récap révèle le
   score de l'adversaire et le verdict (victoire / nul / défaite), puis la révision des bonnes réponses.

### Paramètres de jeu (source unique : `src/shared/constants/gamification.ts`, miroir en SQL)

| Paramètre                   | Valeur                                                               | Sens                                             |
| --------------------------- | -------------------------------------------------------------------- | ------------------------------------------------ |
| `DUEL_QUESTION_COUNT`       | **5**                                                                | questions figées par duel                        |
| `DUEL_EXPIRY_HOURS`         | **24 h**                                                             | au-delà, le duel expire (forfait de l'inactif)   |
| `DUEL_MAX_ACTIVE`           | **3**                                                                | duels simultanés max par élève                   |
| `DUEL_MAX_REWARDED_PER_DAY` | **5**                                                                | duels récompensés par jour (anti-farm)           |
| Barème `DUEL_REWARDS`       | victoire **60 XP / 12 pièces** · nul **40 / 8** · défaite **20 / 4** | un forfait adverse = victoire                    |
| Anti-triche                 | **4 s minimum par question**                                         | répondre plus vite = compté **faux** (`tooFast`) |

Au-delà de 5 duels récompensés/jour, on peut continuer à jouer mais sans XP/pièces (les parties
comptent toujours pour la ligue).

## La ligue hebdomadaire

- **Saison = semaine ISO** (lundi, fuseau **Tunis**) — réutilise `app_current_week_start()`.
- **Points de championnat** par duel fini : **victoire 3 · nul 1 · défaite 0** (barème d'échecs, lisible).
- **Classement** trié par points, puis victoires, puis nombre de duels joués. Le hub affiche le
  **top 20 + la ligne de l'appelant** (jamais l'UUID d'un pair — seulement `display_name` + `is_me`).
- **5 paliers par centile** du classement (équitable quelle que soit la profondeur de la file) :

  | Palier     | Seuil (rang / total) | Pièces fin de saison |
  | ---------- | -------------------- | -------------------- |
  | 💎 diamant | ≤ 10 %               | 100                  |
  | platine    | ≤ 25 %               | 60                   |
  | or         | ≤ 50 %               | 30                   |
  | argent     | ≤ 75 %               | 15                   |
  | bronze     | reste                | 5                    |

- **Fin de saison** : chaque lundi **02h30** (pg_cron), `award_duel_league_week()` clôt la semaine
  écoulée, crédite les pièces (idempotent — rejouer ne double jamais), et une **bannière** dans le hub
  annonce à l'élève son palier + son gain de la semaine passée.

## Exploitation / ops

### pg_cron — deux jobs planifiés

Les duels et les ligues **fonctionnent sans pg_cron**, mais deux automatismes en dépendent. Si
l'extension est absente, la migration ne casse pas (elle émet un `NOTICE`) — il faut alors activer
pg_cron (Supabase → Database → Extensions) puis rejouer le bloc `cron.schedule(...)` :

| Job                      | Planning                         | Rôle                                  | Sans lui                                                    |
| ------------------------ | -------------------------------- | ------------------------------------- | ----------------------------------------------------------- |
| `expire-duels`           | `*/5 * * * *` (toutes les 5 min) | finalise les duels expirés (forfaits) | les duels expirés ne se finalisent pas tout seuls           |
| `award-duel-league-week` | `30 2 * * 1` (lundi 02h30)       | crédite les pièces de fin de saison   | le classement marche, mais pas le versement auto des pièces |

### Realtime (améliore l'expérience, pas requis)

Le mode nominal est le **polling** (`get_duel_state` toutes les 3 s) — le duel est pleinement
jouable sans Realtime. Si **Supabase Realtime** est activé sur le projet, le hook `useDuelChannel`
ajoute la **présence** (adversaire en ligne) et la **progression en direct** (broadcast) ; en cas
d'échec de canal, il **retombe silencieusement** sur le polling (`logger.warn("duel.realtime_fallback")`).
Activer Realtime est donc une décision ops optionnelle, sans risque de régression.

### Migrations concernées

`20260706160000_duels_schema.sql` (tables + RLS + grants), `20260706170000_duels_rpcs.sql`
(matchmaking/scoring/finalize/expiry + cron), `20260706180000_duel_leagues.sql` (ligues + cron).
Elles s'appliquent en prod automatiquement au merge (`db-migrate-prod.yml`).

## Sécurité (résumé)

- **Scoring 100 % serveur** ; la clé de réponse (`answer_key`/`correct_option`) n'est jamais lue
  côté client, y compris pendant le duel — l'écran de jeu ne lit que les colonnes masquées de
  `questions` (`id/prompt/options/question_type`).
- **RLS** sur toutes les tables ; un joueur ne voit que ses duels (prédicat `is_duel_participant`
  SECURITY DEFINER pour éviter la récursion de policy) ; le score de l'adversaire n'est révélé
  qu'une fois le duel **réglé**.
- **Anti-triche** temporel (4 s/question) et **cap quotidien** de duels récompensés (anti-farm),
  cohérents avec les gates existants.

## Où vit le code

- **Serveur** : `src/features/duel/duel.server.ts` (`matchDuel`, `leaveDuelQueue`, `getDuelState`,
  `getDuelQuestions`, `submitDuelAnswer`, `getDuelHistory`, `getDuelLeague`, `getDuelLastAward`).
- **UI** : hub `src/routes/_authenticated/duel.tsx` ; écran de jeu `duel.$duelId.tsx` ;
  composants `duel-arena` / `duel-recap` / `duel-queue-card` / `opponent-progress` / `duel-league` ;
  hook Realtime `use-duel-channel.ts`.
- **i18n** : `src/lib/i18n/duel.types.ts` + dictionnaires FR/EN/AR.
- **Constantes** : `src/shared/constants/gamification.ts` (`DUEL_*`).

## Écart / follow-up documenté

- **Notification push de fin de saison** : **différée** (pas d'infra push dans le repo). Le crédit
  de pièces + la bannière `lastAward` couvrent le feedback in-app ; aucune régression (écart n°7 de
  l'ETUDE.md).
- **Entrée de menu `/duel`** : à ajouter dans le shell de navigation (petit follow-up produit).
