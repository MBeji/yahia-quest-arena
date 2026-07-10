# Étude 14 — Refonte UX/design de l'application

> **Statut** : en exécution (lot 0 mergé ; lot 1 livré en PR)
> **Priorité** : transverse · **Valeur** : cohérence perçue, confiance parents, lisibilité élèves — sans re-branding · **Complexité** : moyenne+ (large surface, risque unitaire faible)
> **Architecte** : Fable / 2026-07-10 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : — (questions arbitrées) · **Bloque** : rien (les autres études peuvent avancer en parallèle, mais les lots UI d'autres épics devraient consommer les primitives du lot 1 dès qu'il est mergé)
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, docs/xss-rendering-policy.md ; annexe factuelle : [AUDIT-2026-07.md](./AUDIT-2026-07.md)

## 1. Contexte & objectif produit

L'app est **déjà bien tokenisée** (~88 % des couleurs passent par le système oklch 3-thèmes)
et possède une identité forte (registre public « Référence » vert + registre jeu « Arène »
or/RPG). Le problème n'est pas l'identité, c'est la **dérive artisanale** : chaque écran
réinvente les mêmes patterns (8 barres de progression, 7 boutons retour, 5 largeurs de page,
5 loaders), la convention RTL n'est appliquée qu'à moitié (61 classes physiques en code
métier), le duel est un îlot sans style, l'auth casse en thème clair, et les erreurs des
routes publiques échappent à l'i18n. Détail complet : [AUDIT-2026-07.md](./AUDIT-2026-07.md).

**Résultat attendu** : un design system formalisé (tokens + primitives partagées + règles
outillées) et chaque écran rattaché à son registre, refondu **par lots d'une PR**, sans
big-bang, gate verte à chaque pas.

**Indicateurs de succès** (mesurables par grep/CI, pas subjectifs) :

- 0 classe directionnelle physique en code métier (hors `components/ui` vendorisé) ;
- 0 classe de palette brute (`text-blue-400`…) et 0 `text-white` en code métier ;
- 1 seule syntaxe de token couleur et 1 seule écriture du dégradé or ;
- exactement **2 thèmes** (clair « Référence » vert / sombre « Noir & Or »), le thème violet
  supprimé, la préférence stockée migrée sans casse ;
- les 8 barres de progression remplacées par 1 primitive ; idem retour/stat/empty/loader ;
- 100 % des messages d'erreur passés par l'i18n ;
- budgets bundle inchangés (`build:check`), coverage non régressée.

**Ce que l'epic ne fait PAS** : pas de nouveau branding, pas de refonte de l'information
architecture (routes/navigation inchangées), pas de nouveaux écrans, pas de changement de
mécanique de jeu, pas de touche aux server fns.

## 2. Spécification fonctionnelle

- **Acteurs** : tous (élève, parent, enseignant anonyme sur le tier public, admin).
- **US-1** — En tant qu'utilisateur, je choisis mon thème (clair ou sombre) et il s'applique
  **partout et de façon cohérente** — landing, auth, écrans connectés, jeu — sans rupture :
  l'auth suit le thème actif (claire en `reference`, noir & or en `dark`).
- **US-2** — En tant qu'élève arabophone, chaque écran (pas seulement le tier public) est
  correctement miroir en RTL.
- **US-3** — En tant qu'élève, la difficulté d'une mission se lit d'un coup d'œil avec le même
  vocabulaire visuel (étoiles) partout : listes, donjon, quêtes, résultats.
- **US-4** — En tant qu'utilisateur, chargement/erreur/vide ont la même grammaire sur tous les
  écrans, dans ma langue.
- **US-5** — En tant qu'utilisateur sensible au mouvement, `prefers-reduced-motion` est
  respecté par TOUTES les animations (CSS et motion/react).
- **US-6** — En tant que joueur de duel, l'écran duel appartient au monde « Arène » (or,
  font-display) comme le donjon.
- **Règles** :
  - **R-1** : le thème (clair/sombre) est **global et transversal** — choisi au switcher,
    appliqué de la landing au donjon, mode anonyme ou connecté ; la zone (public/jeu) ne
    choisit que la _composition_ (densité, font-display, effets), jamais la palette ; aucune
    couleur de registre codée en dur dans un composant.
  - **R-2** : code métier = propriétés logiques uniquement (`ms/me/ps/pe/start/end/text-start`) ;
    `rtl:-scale-x-100` réservé aux icônes directionnelles.
  - **R-3** : une seule syntaxe de token : les couleurs de marque or/flame sont mappées dans
    `@theme` et consommées en utilitaires natifs (`bg-gold/15`, `text-neon-gold`) ; les
    dégradés uniquement via `--gradient-*`.
  - **R-4** : tout pattern présent sur ≥ 2 écrans vit dans une primitive partagée.
  - **R-5** : chaque PR de refonte d'écran joint des captures avant/après en FR + AR (RTL),
    desktop + mobile, thème du registre concerné.
  - **R-6** : les chaînes visibles passent par `@/lib/i18n` — y compris les erreurs des routes
    publiques.
- **i18n** : nouvelles clés d'erreur publiques FR/EN/AR ; aucune autre clé ne change.
- **Hors périmètre (v1)** : nouveau thème, mode « high-contrast », refonte des emails/pages
  légales, redesign des SVG pédagogiques (`svg-figure`).

## 3. Architecture technique (décisions fermées)

Aucune migration DB, aucun changement server. Tout est client/CSS.

- **D-1 — Deux thèmes uniques, transversaux (arbitrage Q-1).** Le système passe de 3 thèmes
  (`reference`/`light`/`dark` violet) à **2** :
  - **Clair « Référence »** : vert sobre institutionnel (l'actuel `reference`, inchangé) ;
  - **Sombre « Noir & Or »** : le `dark` actuel **recoloré** — le violet électrique disparaît,
    `--primary` et les accents passent sur la gamme or déjà tokenisée (`--gold`,
    `--gold-bright`), fond noir profond.

  Le thème `light` (jaune-vert) est supprimé ; les préférences stockées
  (`localStorage`/cookie `xp-scholars-theme` = `light`) migrent vers `reference` au premier
  chargement (même mécanique que la migration de locale existante). `THEMES`, le switcher,
  `themeFromCookieHeader` et les tests suivent. La zone (layout `_public` vs
  `_authenticated`) ne choisit que la composition (densité, font-display, effets « Arène ») —
  la palette vient exclusivement du thème. L'auth est refondue pour suivre le thème actif
  (US-1) au lieu d'imposer le sombre.

- **D-2 — Primitives partagées** (nouvelles, sous `src/components/ui/` pour les génériques,
  `src/components/game/` pour celles du registre Arène) : `PageShell` (conteneur standard :
  3 gabarits `narrow|reading|wide` au lieu de 5 largeurs ad hoc), `GoldProgress` (l'unique
  barre or, construite sur `ui/progress.tsx`), `StatTile`, `BackLink`, `EmptyState`,
  `LoadingState` (skeleton tokenisé — plus de `bg-black/40`), `DifficultyStars`,
  `PremiumBadge`. Chacune avec tests co-localisés.
- **D-3 — Tokens.** Mapper `--gold`, `--gold-bright`, `--neon-gold`, `--flame`, `--champagne`
  dans `@theme` (utilitaires natifs) ; conserver `--gradient-gold` comme seule écriture du
  dégradé ; normaliser l'échelle micro-typo (`text-[10px]/[11px]` → `text-2xs` token) et le
  tracking des labels.
- **D-4 — Garde-fous outillés, pas seulement documentés.** Règle ESLint `no-restricted-syntax`
  (ou plugin tailwind) qui interdit en code métier : classes physiques directionnelles,
  palette brute Tailwind, `text-white`. Whitelist explicite pour `components/ui` vendorisé et
  les hex légitimes (logo Google, confetti, canvas). Zéro-warning policy déjà en place → le
  garde-fou est bloquant naturellement.
- **D-5 — Motion.** Un module `src/shared/lib/motion.ts` : variantes d'entrée standard
  (fade/rise/scale) + helper qui neutralise les `initial/animate` quand `useReducedMotion()`
  est vrai ; les écrans consomment ces variantes au lieu d'objets inline.
- **D-6 — Itération visuelle via Claude Design (DesignSync).** Les tokens + primitives sont
  publiés dans un projet Design System claude.ai/design (cards HTML par composant/variante,
  marqueurs `@dsCard`) pour valider la direction visuellement avant chaque lot d'écran, et
  resynchronisés composant par composant. Le projet DS n'est PAS la source de vérité du code —
  `styles.css` + les primitives le restent ; le DS est l'outil de revue/décision.
- **Alternatives rejetées** : re-branding complet (coût/risque sans besoin exprimé) ;
  bibliothèque de composants externe (shadcn déjà vendorisé) ; refonte en une PR (contraire au
  DoD et au risque bundle `manualChunks`).

## 4. Plan d'exécution en lots

Chaque lot = une PR mergeable, gate verte (`npm run verify`), captures R-5 jointes.

| lot | contenu (résumé)                                                                                                                                    | fichiers/objets principaux                                                          | tests exigés                   | dépend de |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------ | --------- |
| 0   | Cette étude + audit + arbitrages                                                                                                                    | `FableEtudes/14-refonte-ux-design/*`                                                | —                              | —         |
| 1   | Fondations : 2 thèmes (D-1 : suppression `light`, dark → noir & or, migration préférence), tokens `@theme` (D-3), primitives D-2, module motion D-5 | `styles.css`, `lib/theme`, `components/ui` + `components/game`, `shared/lib/motion` | unit par primitive + thème     | 0 validé  |
| 2   | Garde-fous lint (D-4) + sweep RTL des 61 classes physiques métier                                                                                   | `eslint.config`, ~20 fichiers touchés                                               | lint vert, snapshots RTL       | 1         |
| 3   | i18n des erreurs publiques + unification loading/error/empty sur `LoadingState`/`EmptyState`                                                        | routes `_public/*`, features                                                        | unit i18n, snapshots           | 1         |
| 4   | Auth + onboarding rattachés au thème actif (US-1)                                                                                                   | `routes/auth.tsx`, `onboarding.tsx`                                                 | unit, captures 3 thèmes        | 1, 2      |
| 5   | Dashboard sur les primitives (`PageShell`, `GoldProgress`, `StatTile`…)                                                                             | `routes/_authenticated/dashboard.tsx` + composants                                  | unit existants verts, captures | 1, 2      |
| 6   | Boucle quête : `exercise-player`, `quest-reward-grid`, `subject-hub` (+ `DifficultyStars` partout)                                                  | `features/quest/*`                                                                  | unit existants, captures       | 5         |
| 7   | Donjon                                                                                                                                              | `routes/_authenticated/dungeon.tsx`                                                 | idem                           | 6         |
| 8   | Duel rattaché au registre Arène (US-6) + a11y duel                                                                                                  | `features/duel/*`, `routes/duel*`                                                   | idem                           | 5         |
| 9   | Leaderboard + shop (badges-shop) + parcours/journey                                                                                                 | `leaderboard.tsx`, `dashboard-badges-shop`, `parcours/*`                            | idem                           | 5         |
| 10  | Parent-report + admin : purge palette brute/`text-white`, `PageShell` admin                                                                         | `features/parent-report/*`, `routes/admin.*`                                        | idem                           | 5         |
| 11  | Motion : gating reduced-motion généralisé (US-5) + harmonisation des entrées                                                                        | écrans restants                                                                     | unit motion helper             | 1         |

Stop-points : un lot d'écran ne touche NI les primitives (retour lot 1 si manque) NI un autre
écran ; toute divergence étude↔code → STOP et remontée (règle FableEtudes).

- [x] Lot 0 — étude + audit (cette PR)
- [x] Lot 1 — fondations (PR livrée : 2 thèmes, tokens, primitives, motion)
- [x] Lot 2 — RTL + lint (PR livrée : garde-fou + sweep)
- [ ] Lot 3 — états système + i18n erreurs
- [ ] Lot 4 — auth/onboarding
- [ ] Lot 5 — dashboard
- [ ] Lot 6 — quête
- [ ] Lot 7 — donjon
- [ ] Lot 8 — duel
- [ ] Lot 9 — leaderboard/shop/parcours
- [ ] Lot 10 — parent-report/admin
- [ ] Lot 11 — motion

## 5. Stratégie de test

- **Unit (Vitest)** : chaque primitive du lot 1 avec tests co-localisés (rendu, variantes,
  a11y de base) ; les tests existants des écrans refondus doivent rester verts sans être
  affaiblis ; coverage ≥ existant.
- **Lint** : les garde-fous D-4 sont eux-mêmes le test de non-régression des règles R-2/R-3.
- **Visuel** : captures avant/après par PR (R-5) — harness Playwright de la phase 0 réutilisé ;
  pour les écrans authentifiés, exige Q-2 (creds TEST) ou passe par le nightly e2e.
- **smoke:shell** : obligatoire à chaque lot (le bundle prod est touché par tous les lots).
- **Pas de pgTAP** (aucun SQL).

## 6. Risques & mitigations

- **RISK-1 — Régression bundle** (manualChunks main-réglé, budget strict). Prob. moyenne,
  impact haut. Mitigation : aucune nouvelle dépendance ; `npm run build:check` à chaque lot ;
  ne pas toucher les groupes vendor.
- **RISK-2 — Régression visuelle non vue faute de captures authentifiées.** Q-2 arbitré mais
  les creds TEST ne sont pas encore injectés dans le container remote. Mitigation : injecter
  `.env.test` dans la config d'environnement avant le lot 4 ; à défaut, s'appuyer sur le
  nightly e2e + revue humaine des PR.
- **RISK-3 — Sweep RTL casse un alignement voulu** (ex. chiffres en `text-right` dans une
  saisie numérique, légitime en LTR ET RTL pour des nombres). Mitigation : le lot 2 traite les
  cas au cas par cas avec captures AR, pas un sed aveugle ; les exceptions sont commentées.
- **RISK-4 — Scope creep de redesign** (« tant qu'on y est »). Mitigation : hors-périmètre §2
  - stop-points de lots ; toute envie nouvelle = nouvelle ligne au journal, pas au lot.
- **RISK-5 — Conflits avec les épics en exécution** (04, 13). Prob. faible (surfaces
  disjointes). Mitigation : lots d'écran courts, rebase fréquent.

## 7. Questions ouvertes (pour l'humain)

Toutes arbitrées le 2026-07-10 — l'étude passe « validée ». Décisions consignées :

- **Q-1 — ARBITRÉ : unification à 2 thèmes.** Suppression du violet électrique. Deux thèmes
  globaux et transversaux (landing → écrans connectés, anonyme ou connecté, choisis au
  switcher et appliqués partout de façon cohérente) : **Clair « Référence »** (vert sobre
  institutionnel) et **Sombre « Noir & Or »**. → intégré à D-1 et au lot 1.
- **Q-2 — ARBITRÉ : validé.** Les identifiants Supabase TEST (`.env.test`) sont disponibles
  côté humain (PC + environnement). Note d'exécution : ils ne sont pas encore visibles dans
  le container remote (ni fichier ni variables) — à injecter dans la config de
  l'environnement Claude Code (variables ou setup script) pour débloquer les captures
  authentifiées locales ; la CI e2e-auth a déjà ses secrets.
- **Q-3 — ARBITRÉ : GO.** Publication du Design System sur claude.ai/design (D-6) dès que les
  primitives du lot 1 existent.
- **Q-4 — ARBITRÉ : étoiles standard.** ⭐ 1-4 comme repère **unique** de difficulté sur toute
  l'app, en remplacement des barrettes du donjon et des mentions « Niveau N ». Extensible à
  5/6 étoiles plus tard — toujours des étoiles ; la primitive `DifficultyStars` prend un
  `max` paramétrable.

## 8. Journal d'exécution

- 2026-07-10 — Lot 0 : étude + audit livrés (branche `claude/app-ux-design-refactor-o606bq`).
  Constats phase 0 : voir AUDIT-2026-07.md. Captures publiques archivées côté session (32,
  0 erreur). Supabase local impossible dans l'environnement d'exécution (proxy réseau ↔
  registres Docker) — à l'origine de Q-2.
- 2026-07-10 — Arbitrages humains Q-1…Q-4 rendus (§7), statut → **validée**. Impact scope :
  le lot 1 absorbe l'unification à 2 thèmes (D-1 réécrit) ; `DifficultyStars` paramétrable
  au-delà de 4. `.env.test` toujours absent du container remote (voir Q-2).
- 2026-07-10 — Lot 1 livré : thème `light` supprimé (+ migration des préférences), `:root`
  sombre recoloré Noir & Or (violet retiré, utilitaires tokenisés en `color-mix` → la plupart
  des overrides par thème supprimés, −106 lignes de CSS), token `--text-2xs`, primitives
  `PageShell`/`BackLink`/`EmptyState`/`LoadingState` (ui) + `GoldProgress`/`StatTile`/
  `DifficultyStars`/`PremiumBadge` (game), module `shared/lib/motion` (`useEntrance`), clé
  i18n `common.difficulty` (FR/EN/AR). Gate verte (1196 tests, +21), build:check + smoke:shell
  verts, captures 2 thèmes validées. Constat conservé pour le lot 4 : l'auth reste sombre en
  thème clair (inchangé — son rattachement au thème actif est le périmètre du lot 4).
- 2026-07-10 — Lot 1 mergé (#349). Lot 2 livré : garde-fou `scripts/lint/check-rtl-classes.mjs`
  branché sur `npm run lint` (donc CI) — interdit ml/mr/pl/pr, text-left/right, left-/right-
  positionnels (hors centrage `left-1/2`), rounded-l/r, border-l/r en code métier, avec
  marqueur d'exception `rtl-ok` ; sweep : 43 occurrences converties en propriétés logiques
  (+ 3 chevrons `group-hover:translate-x` compensés `rtl:`), 1 exception documentée (stack
  trace `__root.tsx`, LTR par nature), la compensation manuelle `rtl:left-4 rtl:right-auto`
  du bug-launcher remplacée par `end-4`. Écarts acceptés vs D-4 : (a) le volet palette
  brute/`text-white` du garde-fou arrivera avec le lot 10 (l'activer avant la purge mettrait
  la gate au rouge) ; (b) `translate-x` de centrage (`left-1/2 -translate-x-1/2`) exempté —
  symétrique en RTL. Vérifié : gate verte, capture auth AR (icônes/paddings côté start).
