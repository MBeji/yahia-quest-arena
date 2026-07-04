# Étude 09 — Économie du jeu : instrumentation & équilibrage

> **Statut** : brouillon
> **Priorité** : 09 · **Valeur** : 📊 pilotage — savoir si la courbe XP/coins est trop rapide ou trop lente **en vrai**, avant de toucher quoi que ce soit · **Complexité** : faible/moyenne
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : rien (indépendant, peut démarrer tôt) · **Bloque** : tout futur rééquilibrage sérieux (04/05 profiteront des mêmes vues)
> **Docs normatifs liés** : CLAUDE.md (consommables, gamification centralisée, gotcha grants), `src/shared/constants/gamification.ts`, `content-engine/references/rewards-and-modes.md` (table canonique des récompenses), ARCHITECTURE.md

## 1. Contexte & objectif produit

L'économie est **déjà bien conçue et centralisée** : toutes les constantes vivent dans
`src/shared/constants/gamification.ts` (200 XP/niveau, seuils 60/80 %, demi-coins à 40 %,
récompenses par difficulté d1→d4 : 50/75/120/300 XP), la table canonique des récompenses est
normative (`rewards-and-modes.md`, ~1 coin / 5 XP), et l'anti-farm est serveur
(`tooFast` < 4 s/question, ré-attempt payé seulement si `improved`, rien sous 60 %). Le problème
n'est **pas** le design : c'est l'**absence de boucle de mesure**. Personne ne sait si un élève
moyen atteint le niveau 5 en 3 jours ou en 3 mois, si les coins s'accumulent sans sink (inflation
⇒ boutique sans valeur), ni si les consommables sont réellement armés/consommés. Cette étude est
une étude d'**outillage** : instrumenter, simuler, encadrer le processus de changement — **pas**
rééquilibrer. KPI de succès : la page admin « Économie » répond aux 5 questions ci-dessous sans
requête manuelle ; `npm run economy:check` casse si une modification de constante viole un
garde-fou. Non-objectifs : A/B testing (aucune infra), refonte des récompenses, monétisation des
coins.

## 2. Spécification fonctionnelle

- **Acteurs** : admin uniquement (page read-only) ; développeur (simulateur en CI locale). Aucun
  écran élève, aucun changement de gameplay.
- **US-1** : en tant qu'admin, je vois la distribution de l'XP gagné/jour (p50/p90/max) et le
  temps réel pour atteindre chaque niveau (percentiles de jours entre inscription et palier).
- **US-2** : je vois sources vs sinks de coins sur 30 j glissants (gagnés vs dépensés boutique +
  `STREAK_RECOVERY_COST`) et le ratio d'inflation.
- **US-3** : je vois le taux d'armement/consommation par type de consommable (potions, retry
  shield, streak shield, hints) — un item jamais consommé = signal design.
- **US-4** : je vois la progression des élèves vs le palier premium (part des actifs bloqués au
  free preview d1, conversion entitlement).
- **US-5** : en tant que dev, `npm run economy:check` rejoue 8 semaines de 3 personas sur les
  constantes **réelles** et échoue si un garde-fou est violé.
- **R-1** : la page admin est **read-only** : aucune server fn de mutation, aucune action.
- **R-2** : aucune donnée nominative agrégée côté client au-delà de ce que l'admin voit déjà
  (agrégats anonymes ; pas de liste d'élèves dans cette page).
- **R-3** : le simulateur **importe** les constantes depuis `gamification.ts` — toute copie de
  valeur est un bug (sinon il valide une économie fantôme).
- **R-4 (processus)** : toute PR qui modifie `gamification.ts` ou la table canonique des
  récompenses joint la sortie `economy:check` **avant/après** dans sa description. Règle
  documentée ici ; l'architecte la référencera depuis CLAUDE.md ultérieurement (hors périmètre de
  l'exécuteur).
- **i18n** : page admin FR uniquement (comme les autres pages admin existantes) ; RTL sans objet.
- **Hors périmètre (v1)** : A/B testing, rebalance effectif des constantes, monétisation/achat de
  coins, alerting automatique (revue humaine périodique suffit, cf. Q-2).

## 3. Architecture technique (décisions fermées)

- **D-1 — Vues SQL, pas de nouvelle table (v1).** Les agrégats se calculent sur `attempts`
  (`xp_earned`, `score_pct`, `duration_seconds`, `completed_at`), `profiles` (xp/level/coins/
  streak/created_at), `inventory_items` × `shop_items`, `parcours_entitlements`, `dungeon_runs`.
  Volumétrie actuelle faible ⇒ vues à la demande. Rejeté : table d'événements économiques
  (sur-ingénierie v1) ; snapshot journalier réservé au Lot 3 conditionnel.
- **D-2 — Vues privées + un RPC admin.** Les vues `econ_*` sont `REVOKE`d de anon/authenticated
  (gotcha grants : sur la stack CI fraîche, aucun droit implicite — poser explicitement les
  REVOKE/GRANT). Exposition via **un** RPC `admin_economy_overview()` `SECURITY DEFINER` qui
  vérifie `profiles.role = 'admin'` (même posture que `admin_list_parcours_entitlements`) et
  retourne un JSONB par section. Rejeté : GRANT SELECT des vues à authenticated + filtre client
  (fuite d'agrégats globaux à tout connecté).
- **D-3 — Route admin dédiée, server fn dans la feature `dashboard`.** L'admin existant n'est
  **pas** une feature : ce sont des routes plates `_authenticated/admin.*.tsx`, chacune adossée à
  la feature propriétaire du domaine (subscriptions → `subscription/`, content-reports →
  `content-report/`). Il n'existe pas de « feature admin ». Je choisis donc : route
  `admin.economie.tsx` sur ce modèle (garde `useMyRole().isAdmin` côté client, RPC autoritaire
  côté serveur), et server fn `getEconomyOverview` dans `src/features/dashboard/economy.server.ts`
  (précédent : `getLeaderboard` vit déjà dans dashboard ; une feature `economy/` entière pour une
  page read-only serait du sur-découpage). Rejeté : nouvelle feature dédiée.
- **D-4 — Simulateur en pur JS important les constantes réelles.** `scripts/economy/simulate.mjs`
  importe `src/shared/constants/gamification.ts` via `node --experimental-strip-types` (mécanisme
  déjà utilisé par `content:check`). Il rejoue les règles (récompenses canoniques d1–d4, seuils
  60/40 %, `improved`, quiz gate 80 %, objectifs quotidiens/hebdo par défaut, coût streak
  recovery) pour 3 personas × 8 semaines, en déterministe (seed fixe). Script npm :
  `economy:check` — **hors** `verify`/`ci:verify` (c'est un garde-fou d'équilibrage, pas un test
  de code) ; lancé manuellement et par la règle R-4.
- **D-5 — Les coins gagnés ne sont pas persistés par attempt** (`attempts` n'a que `xp_earned`).
  La vue sources-de-coins **reconstruit** le flux par la règle canonique (~XP/5, demi-coins
  40–59 %) : approximation assumée et documentée dans la page. Si l'écart estimé/réel devient
  gênant, la colonne `coins_earned` additive est un durcissement du Lot 3 — pas un préalable.
- **Observabilité** : le RPC logge (logger partagé côté server fn) la durée d'exécution ; si
  > 2 s en prod réelle, déclencher le Lot 3.

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                              | fichiers/objets créés                                                                        | tests exigés                         | dépend de |
| --- | --------------------------------------------- | -------------------------------------------------------------------------------------------- | ------------------------------------ | --------- |
| 1   | Vues `econ_*` + RPC admin + page « Économie » | migration (vues+RPC+grants), `dashboard/economy.server.ts`, `admin.economie.tsx`, composants | pgTAP (RPC refuse non-admin), Vitest | —         |
| 2   | Simulateur + assertions garde-fous            | `scripts/economy/simulate.mjs`, `assertions.mjs`, script npm `economy:check`, règle R-4 ici  | Vitest sur le moteur de simulation   | —         |
| 3   | (conditionnel) snapshot + durcissements       | table `economy_daily_stats` (+RLS+GRANTs), cron/refresh, éventuel `attempts.coins_earned`    | pgTAP grants/RLS                     | 1         |

- [ ] **Lot 1 — Instrumentation.** Vues : `econ_xp_daily` (XP/jour/user → percentiles),
      `econ_level_velocity` (jours réels pour atteindre chaque niveau, dérivés du cumul
      `xp_earned` daté vs `XP_PER_LEVEL`), `econ_coin_flows_30d` (sources reconstruites D-5 vs sinks
      boutique/streak-recovery), `econ_consumables` (armement/consommation par `effect_payload`),
      `econ_premium_funnel` (actifs vs entitlement, plafonnés au free preview). RPC `SECURITY
DEFINER` + REVOKE/GRANT explicites. Page read-only (US-1…US-4), états vide/chargement/erreur.
      Stop-point : aucun simulateur, aucune table.
- [ ] **Lot 2 — Simulateur.** Personas : **assidu** (6 j/7, ~4 exercices/j, 85 % de réussite),
      **moyen** (3 j/7, ~2/j, 70 %), **occasionnel** (1 j/7, ~1–2/j, 60 %) ; 8 semaines. Sortie
      lisible (tableau niveaux/coins/streak par semaine) + assertions des garde-fous G-1…G-4 (§7).
      Stop-point : ne pas brancher au gate CI principal ; ne modifier ni CLAUDE.md ni les workflows.
- [ ] **Lot 3 — (si déclenché)** snapshot `economy_daily_stats` (additive, RLS admin-only,
      GRANTs explicites) rafraîchi par le RPC ou un cron, et/ou `attempts.coins_earned`. Stop-point :
      ne se lance que sur constat mesuré (RPC > 2 s ou écart coins jugé gênant), acté par l'architecte.

## 5. Stratégie de test

pgTAP : le RPC échoue pour un utilisateur non-admin, les vues sont inaccessibles à
anon/authenticated (grants), chaque vue retourne une forme stable sur données seedées. Vitest
co-localisés : mapping RPC→UI de `economy.server.ts` (zod, erreurs), moteur du simulateur (une
journée simulée reproduit exactement la règle canonique : 75 XP d2, demi-coins à 45 %, 0 sous
40 %, `improved`). Non-régression : aucune modification d'un RPC de gameplay existant dans les
lots 1–2 ; `npm run verify` inchangé.

## 6. Risques & mitigations

- **RISK-1 — Métriques vaniteuses** (moyennes flatteuses masquant les extrêmes). Mitigation :
  percentiles (p50/p90/max) partout, jamais de moyenne seule ; les 5 questions US-1…US-4 sont le
  contrat de la page — pas de métrique décorative ajoutée sans US.
- **RISK-2 — Sur-tuning** : l'outil incite à retoucher les constantes en boucle. Mitigation : la
  règle R-4 impose simulation avant/après par PR, et Q-2 fixe une cadence de revue (pas de
  réglage réactif au jour le jour) ; le rebalance lui-même reste hors périmètre.
- **RISK-3 — Simulateur qui diverge des règles SQL réelles** (la vérité est dans
  `submit_exercise_attempt`). Mitigation : import des constantes réelles (R-3), tests Vitest
  alignés sur la table canonique, et note explicite dans le script : toute évolution du RPC de
  scoring doit être répercutée (le régression-guard hebdo attrape l'oubli de test).
- **RISK-4 — Vues lentes quand le volume monte.** Mitigation : log de durée (D-5/observabilité) +
  Lot 3 conditionnel déjà spécifié (snapshot journalier additive).

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — Garde-fous chiffrés à valider** (valeurs proposées, assertions du Lot 2) :
  **G-1** le persona _moyen_ atteint le niveau 5 (1 000 XP) en **7–14 jours** — plus tôt = courbe
  trop rapide, plus tard = décourageant ; **G-2** aucun jour simulé (même _assidu_ optimal) ne
  dépasse **1 000 XP farmables/jour** (l'anti-farm `improved`/`tooFast`/60 % doit borner) ;
  **G-3** sinks ≥ **60 %** des sources de coins à horizon 30 j pour le persona moyen (sinon
  inflation : la boutique ne draine pas) ; **G-4** le streak shield ne rend pas la streak
  triviale : sur 8 semaines, le persona moyen ne peut pas couvrir plus de **~20 %** de ses jours
  manqués via shields (borné par leur coût en coins).
- **Q-2 — Cadence de revue humaine** de la page Économie : mensuelle (proposé) ou hebdo pendant
  les 2 premiers mois post-lancement ?
- **Q-3 — Seuil de déclenchement du Lot 3** : les 2 s de latence RPC proposées conviennent-elles,
  ou préférer un déclenchement purement volumétrique (ex. > 50 k attempts) ?

## 8. Journal d'exécution

_(rempli au fil des lots par l'exécuteur : date, lot, PR, écarts acceptés, dettes notées)_
