# Étude 06 — PWA & lecture hors-ligne

> **Statut** : brouillon
> **Priorité** : 06 · **Valeur** : marché — connectivité intermittente en Tunisie ; installer l'app et relire ses cours sans réseau · **Complexité** : haute
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : besoin utilisateur documenté (télémétrie/retours) · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/xss-rendering-policy.md`, `docs/environment-variables.md`

## 1. Contexte & objectif produit

L'app est aujourd'hui **100 % online** : sans réseau, écran blanc ou erreur navigateur — aucune
page de repli, aucun cache applicatif, pas de manifest (non installable). Or la cible (élèves
tunisiens, mobile d'abord) subit une connectivité intermittente ; le contenu le plus relu — les
**cours et résumés** (`chapters.lesson_content` / `chapters.summary`) — est pourtant du pur
contenu de lecture, cacheable sans risque.

- **Résultat attendu (v1)** : app **installable** (manifest + service worker) ; **offline en
  LECTURE SEULE** : app shell + cours/résumés des chapitres **récemment visités** disponibles
  sans réseau ; indicateur global hors-ligne ; page offline de repli brandée.
- **KPI** : taux d'installation PWA ; % de sessions avec ≥ 1 lecture offline ; taux d'erreur
  « écran blanc offline » → 0 ; `build:check` et `smoke:shell` restent verts.
- **Ce que l'epic NE fait PAS** : **AUCUNE tentative d'exercice hors-ligne**. Le scoring est
  server-side par conception (clé jamais côté client — GAP-020) : pas de file d'attente de
  tentatives, pas d'XP offline, pas de mutation rejouée. Une v2 « tentatives différées » serait
  une **étude séparée** (non-goal explicite, voir §2 Hors périmètre).

## 2. Spécification fonctionnelle

### Acteurs & parcours

- **US-1** : en tant qu'élève, je peux installer l'app (prompt natif / A2HS iOS) et la lancer
  depuis l'écran d'accueil en plein écran, icône et couleurs de la marque.
- **US-2** : hors-ligne, l'app shell se charge et j'accède aux cours/résumés des chapitres que
  j'ai visités récemment, dans la langue où je les ai lus.
- **US-3** : hors-ligne, un **banner global** m'indique le mode dégradé (« Hors connexion —
  lecture seule ») ; les actions de jeu (quêtes, dungeon, boutique) sont désactivées visuellement.
- **US-4** : chaque chapitre affiche un état « disponible hors-ligne » (badge) quand son cours
  est en cache.
- **US-5** : si je navigue vers une page non cachée hors-ligne, je vois une **page offline de
  repli brandée** (cohérente avec la page d'erreur brandée de `src/server.ts`), avec retour aux
  chapitres disponibles.
- **US-6** : après un déploiement, je reçois la nouvelle version sans rester bloqué sur un vieux
  bundle (stratégie de mise à jour, R-7).

Écrans : aucun nouvel écran métier — banner global, badge par chapitre, page `/offline` de repli.
Mobile-first + RTL (le banner et la page offline existent en FR/EN/AR, miroir RTL).

### Règles métier

- **R-1** : offline = lecture seule. Aucune server fn POST n'est intentée hors-ligne ; les
  mutations échouent franchement (pas de retry silencieux, pas de file d'attente).
- **R-2** : seuls **app shell + assets** sont précachés ; le **contenu de cours** est mis en
  cache **à la visite** (runtime, stale-while-revalidate) — jamais de précache massif du catalogue.
- **R-3** : sont persistées UNIQUEMENT les queries de lecture de contenu (subject/chapters :
  cours, résumé, métadonnées de chapitre). **Jamais** : profil/XP/coins, inventaire, leaderboard,
  entitlements, réponses/clés de questions.
- **R-4** : le SW n'intercepte **jamais** les server fns (POST) ni les routes/endpoints d'auth
  Supabase : network-only strict dessus (R-1 en découle).
- **R-5** : le contenu caché respecte le gate premium tel qu'il était à la visite : on ne cache
  que ce que le serveur a réellement servi à cet utilisateur ; rien de plus n'est exposé offline.
- **R-6** : quotas : cache contenu borné (nombre d'entrées + TTL, lot 4) avec éviction LRU ;
  jamais de croissance non bornée de l'IndexedDB/localStorage.
- **R-7** : mise à jour du SW : nouveau bundle détecté → prompt « Nouvelle version disponible »
  (pas de `skipWaiting` silencieux en navigation), rechargement contrôlé.
- **R-8** : à la déconnexion (logout), le cache de contenu persisté est purgé (appareils partagés).

### i18n / Hors périmètre (v1)

- Clés `offline.*` en FR/EN/AR ; banner et page de repli RTL-safe.
- **Hors périmètre v1** : tentatives d'exercices différées et toute écriture offline (**étude
  séparée v2 — non-goal assumé**), notifications push (feature `notifications` existante,
  indépendante), précache de tout un parcours, téléchargement explicite « pack hors-ligne ».

## 3. Architecture technique (décisions fermées)

### Pas de modèle de données

Aucune table, aucune migration : tout est client-side (SW + persistance TanStack Query).

### Service worker & build (vite-plugin-pwa / Workbox)

- Intégration dans le `vite.config.ts` **inline** existant (gotcha CLAUDE.md : `manualChunks`
  tuné à la main, budgets bundle) : ajouter `VitePWA(...)` à la composition manuelle des plugins,
  puis **re-runner `npm run build:check` et `npm run smoke:shell`** — le SW ne doit casser ni le
  budget ni le shell prod.

```ts
// vite.config.ts (extrait — lot 1)
VitePWA({
  registerType: "prompt", // R-7 : jamais de skipWaiting silencieux
  manifest: {/* name, icons, theme_color, display: "standalone", dir/lang par défaut fr */},
  workbox: {
    navigateFallback: "/offline", // US-5
    navigationPreload: true,
    runtimeCaching: [/* lot 2 — cf. D-2 */],
    // R-4 : les POST (server fns) et l'auth ne sont JAMAIS interceptés :
    // Workbox ne route que les GET par défaut ; exclusions explicites en plus
    // (denylist navigateFallback + aucune route runtime sur /_serverFn/ ni *.supabase.co/auth).
  },
});
```

- **Précache** : app shell + assets versionnés Vite (JS/CSS/fonts/icônes). Pas de HTML SSR
  précaché autre que la page `/offline` de repli.
- **CSP** : `src/shared/lib/csp.ts` n'a pas de `worker-src` aujourd'hui — ajouter
  `worker-src 'self'` (ne pas laisser retomber sur `default-src` implicitement) ; vérifier que
  `connect-src 'self' https://*.supabase.co …` couvre les fetchs du SW (déjà le cas).

### Persistance des données de cours (TanStack Query persister)

- `@tanstack/query-persist-client` + persister IndexedDB (localStorage en repli) branché dans
  `src/router.tsx` où vit le QueryClient — avec `shouldDehydrateQuery` en **allowlist stricte**
  (R-3) : uniquement les query keys de lecture `subject`/`chapters` (cours, résumé). `maxAge`
  aligné sur le TTL de R-6. Jamais de mutation persistée, jamais de profil.
- Réseau coupé : les queries allowlistées servent le cache (stale) ; les autres tombent en
  erreur → UI dégradée (US-3) via un hook partagé `useOnlineStatus`
  (`src/shared/hooks/` ou `@/hooks`, même famille que `use-mobile`).

### Client / UI

- Pas de nouvelle feature métier : composants transverses dans `src/shared/` + `@/components` :
  `OfflineBanner` (global, monté dans le shell `_authenticated`), badge « disponible hors-ligne »
  sur la liste des chapitres (`/subject/$subjectId`), route publique `/offline` (page brandée,
  même direction artistique que la page d'erreur de `src/server.ts`), prompt de mise à jour (R-7).
- États TanStack Query : `fetchStatus === "paused"` (offline) distingué de l'erreur serveur pour
  afficher le bon message.

### Sécurité & observabilité

- Invariants : aucune clé de réponse en cache (elle n'atteint jamais le client — inchangé) ;
  R-5/R-8 ; le SW ne logge aucun token (les requêtes auth ne passent pas par lui, R-4).
- Logs structurés `@/shared/lib/logger` : `pwa.installed`, `pwa.sw_updated`,
  `offline.page_view`, `offline.chapter_read` (télémétrie d'usage → Q-3).

### Décisions d'architecture (ADR)

- **D-1** : `vite-plugin-pwa` (Workbox) plutôt qu'un SW artisanal — précache versionné géré,
  intégration Vite native ; rejeté : SW manuel (fragile face aux hash de chunks du build inline).
- **D-2** : contenu de cours en **stale-while-revalidate à la visite** (persister TanStack Query),
  pas de précache de données — respecte R-2/R-5 et le gate premium ; rejeté : précache API massif
  (exposition de contenu non servi + explosion du quota).
- **D-3** : `registerType: "prompt"` + UI de mise à jour — évite le vieux-bundle-fantôme après
  deploy (le risque n°1 sur Vercel où `main` auto-déploie) ; rejeté : `autoUpdate`/`skipWaiting`
  (casse une session de lecture en plein milieu, risque d'assets dépareillés).
- **D-4** : v1 sans aucune écriture offline — le scoring server-side est un invariant produit
  (GAP-020), une file de tentatives différées changerait le modèle de confiance ; **v2 = étude
  séparée**, explicitement hors de ce dossier.
- **D-5** : persistance dans IndexedDB (repli localStorage) via le persister officiel — pas de
  store maison ; le SW ne cache que des GET de shell/assets, les données passent par le persister
  (une seule source de vérité côté données).

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                      | fichiers/objets créés                                                           | tests exigés                             | dépend de |
| --- | ----------------------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------- | --------- |
| 1   | Manifest + SW app shell + CSP + prompt de mise à jour | `vite.config.ts` (VitePWA), icônes, `csp.ts` (`worker-src 'self'`), UI update   | Vitest ; `build:check` + `smoke:shell`   | —         |
| 2   | Persistance lecture cours + indicateurs UI            | persister dans `router.tsx`, `useOnlineStatus`, `OfflineBanner`, badge chapitre | Vitest co-localisés (R-1, R-3, US-3/4)   | 1         |
| 3   | Page `/offline` brandée + e2e/smoke                   | route `/offline`, spec Playwright offline                                       | e2e public (`context.setOffline`), smoke | 1         |
| 4   | Durcissement : quotas, éviction, purge au logout      | config `maxAge`/LRU, purge R-8, télémétrie `offline.*`                          | Vitest (R-6, R-8)                        | 2         |

- [ ] Lot 1 — manifest + SW (shell seul) + `worker-src` + prompt R-7 ; **`smoke:shell` vert obligatoire**. **Stop-point** : aucune donnée persistée.
- [ ] Lot 2 — persister allowlisté + banner + badge « disponible hors-ligne ». **Stop-point** : pas de page `/offline`, pas de quotas.
- [ ] Lot 3 — page de repli + spec Playwright public : visiter un chapitre, `context.setOffline(true)`, relire le cours + page repli sur route non cachée. **Stop-point** : pas de durcissement.
- [ ] Lot 4 — quotas/éviction/purge logout + événements de télémétrie. **Stop-point** : rien de v2 (aucune écriture offline).

Chaque lot = une PR, gate verte (`npm run verify` ; `ci:verify` pour les lots 1 et 3 qui
touchent le bundle prod).

## 5. Stratégie de test

- **Vitest co-localisés** : allowlist du persister (une query non listée n'est JAMAIS déshydratée
  — R-3), `useOnlineStatus`, `OfflineBanner`, logique badge, purge au logout (R-8).
- **smoke:shell** (critique, incident 2026-07-01) : c'est le seul tier qui exécute le bundle
  prod réel — il doit rester vert aux lots 1 et 3 ; l'enregistrement du SW ne doit produire ni
  page error ni page d'erreur brandée au premier chargement.
- **Playwright e2e public** (lot 3) : scénario offline via `context.setOffline(true)` sur un
  chapitre pré-visité (projet `public-chromium` + `public-mobile`) ; pas de backend requis.
- **build:check** : budgets bundle respectés malgré le plugin PWA (le SW est hors chunks
  applicatifs ; ne pas toucher `manualChunks` sans re-vérifier).
- Non-régression : aucune server fn modifiée ; pgTAP sans objet (zéro SQL) ; suites existantes
  intactes.

## 6. Risques & mitigations

- **RISK-1** — SW qui sert un **vieux bundle après deploy** (assets dépareillés, page morte).
  _Prob. haute, impact haut._ Mitigation : D-3 (`prompt` + reload contrôlé, R-7), précache
  versionné Workbox, `smoke:shell` au gate, spec e2e de mise à jour au lot 3.
- **RISK-2** — **Cache poisoning** / contenu servi à tort (réponse d'erreur cachée, contenu
  premium relu après révocation). _Prob. moyenne, impact moyen._ Mitigation : cache uniquement
  des réponses 200 GET (Workbox par défaut), allowlist R-3, TTL R-6, purge au logout R-8, R-5.
- **RISK-3** — **iOS quirks** (pas de prompt d'installation, quotas IndexedDB agressifs, SW
  évincé). _Prob. haute, impact moyen._ Mitigation : A2HS documenté dans l'UI (US-1), repli
  localStorage, l'app reste 100 % fonctionnelle online sans SW (dégradation nulle).
- **RISK-4** — Interception accidentelle d'une server fn / route auth par le SW. _Prob. faible,
  impact haut._ Mitigation : R-4 (Workbox ne route que les GET + denylist explicite), test Vitest
  dédié sur la config des routes runtime.
- **RISK-5** — Le plugin PWA casse le build inline (`manualChunks`, budget, chunk vendor
  circulaire). _Prob. moyenne, impact haut._ Mitigation : lot 1 minimal (shell seul),
  `build:check` + `smoke:shell` obligatoires avant merge, aucun remaniement des vendor groups.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : périmètre du cache contenu — combien de chapitres récents (N = 10 ? 20 ?) et TTL
  (7 j ? 30 j ?) ; arbitrage stockage mobile vs confort (fixe les constantes du lot 4).
- **Q-2** : opt-in par chapitre (« garder hors-ligne » explicite, épinglage) ou tout-automatique
  à la visite comme spécifié en v1 ? L'épinglage ajoute un écran et un quota dédié.
- **Q-3** : télémétrie d'usage offline — quels événements suivre et où les agréger (les
  `offline.*` du logger suffisent-ils, ou faut-il un événement analytics produit dédié ?).
- **Q-4** : priorité produit de la v2 « tentatives différées » (étude séparée) — faut-il la
  planifier maintenant pour dimensionner R-6, ou attendre les KPI de la v1 ?

## 8. Journal d'exécution

_(rempli au fil des lots par l'exécuteur : date, lot, PR, écarts acceptés, dettes notées)_
