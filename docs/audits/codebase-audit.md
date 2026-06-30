# 🛡️ Audit technique — yahia-quest-arena (XP Scholars)

> Audit de qualité, maintenabilité, sécurité et conformité aux bonnes pratiques.
> **Date :** 2026-06-30 · **Commit audité :** `5fc5452` (`main`) · **Branche d'audit :** `claude/codebase-audit-93e1p5`
> **Méthode :** analyse statique + exécution de la _gate_ réelle (lint, typecheck, couverture), revue manuelle ciblée et fan‑out d'agents de revue par axe.

---

## 1. Introduction

### 1.1 Objectifs

Évaluer l'application **yahia-quest-arena** (academy d'apprentissage gamifiée, FR/EN/AR) selon **8 axes** :
gestion de versions, stack technique, architecture, qualité de code, tests, performance, logging/erreurs, sécurité.
Produire un rapport factuel, chiffré et actionnable.

### 1.2 Contexte projet

- **Type :** application web _fullstack_ (SSR), académie d'apprentissage par « quêtes » (QCM, XP, badges, donjon, classement).
- **Stack :** Vite 8 · TanStack Start (SSR + file‑routing + server fns) · React 19 · TanStack Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix‑shadcn. Déploiement **Vercel** (auto‑deploy sur `main`).
- **Langages :** TypeScript (strict), SQL (migrations Supabase), Markdown (contenu pédagogique versionné).
- **Volumétrie :** ~328 fichiers TS/TSX (~41 700 LOC hors générés), 202 migrations SQL, ~60 sujets de contenu, 10+ _features_.

### 1.3 Périmètre

Code applicatif `src/`, migrations `supabase/`, pipeline de contenu `content/` + `scripts/`, configuration (CI, lint, build),
documentation (`CLAUDE.md`, `ARCHITECTURE.md`, `docs/`). **Hors périmètre :** exactitude pédagogique du contenu (couverte par
le sweep `content-audit`), exécution e2e Playwright (projet TEST dédié, hors _gate_ unitaire).

### 1.4 Méthodologie & outils

| Outil / méthode                                | Usage                                                            |
| ---------------------------------------------- | ---------------------------------------------------------------- |
| `npm run lint` (ESLint 10, `--max-warnings=0`) | Conformité style & règles                                        |
| `npm run typecheck` (tsc strict)               | Sûreté des types                                                 |
| `npm run test:coverage` (Vitest 4 + v8)        | Couverture réelle mesurée                                        |
| `npm audit --omit=dev`                         | Vulnérabilités de dépendances (CVE)                              |
| `git log/branch/tag`                           | Hygiène du dépôt                                                 |
| Revue manuelle + agents de revue               | Architecture, sécurité, perf, SOLID (références `fichier:ligne`) |

---

## 2. Résumé exécutif

### 2.1 Radar des 8 axes

<!-- Le graphique radar ci-dessous est un bloc HTML inline (Chart.js via CDN). Il s'affiche
     dans un navigateur ou une preview Markdown locale. GitHub neutralise <script> dans le
     rendu Markdown : se référer alors au tableau de synthèse (§2.2) qui porte les mêmes scores. -->
<div style="max-width:680px;margin:0 auto;background:#0b1020;border-radius:12px;padding:16px;">
  <canvas id="auditRadar" width="680" height="520"></canvas>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
(function () {
  function draw() {
    var el = document.getElementById('auditRadar');
    if (!el || typeof Chart === 'undefined') { return; }
    new Chart(el.getContext('2d'), {
      type: 'radar',
      data: {
        labels: [
          'Gestion de versions',
          'Stack technique',
          'Architecture',
          'Qualité de code',
          'Tests & couverture',
          'Performance',
          'Logging & erreurs',
          'Sécurité'
        ],
        datasets: [{
          label: 'Score / 4',
          data: [3, 3.5, 4, 3.5, 3.5, 3, 3.5, 4],
          fill: true,
          backgroundColor: 'rgba(250, 204, 21, 0.2)',
          borderColor: 'rgba(250, 204, 21, 1)',
          pointBackgroundColor: 'rgba(250, 204, 21, 1)',
          pointBorderColor: '#fff',
          borderWidth: 2
        }]
      },
      options: {
        scales: {
          r: {
            min: 0, max: 4, ticks: { stepSize: 1, color: '#cbd5e1', backdropColor: 'transparent' },
            grid: { color: 'rgba(148,163,184,0.25)' },
            angleLines: { color: 'rgba(148,163,184,0.25)' },
            pointLabels: { color: '#e2e8f0', font: { size: 12 } }
          }
        },
        plugins: {
          legend: { labels: { color: '#e2e8f0' } },
          title: { display: true, text: 'Audit yahia-quest-arena — score par axe (/4)', color: '#facc15', font: { size: 15 } }
        }
      }
    });
  }
  if (document.readyState === 'complete') { draw(); }
  else { window.addEventListener('load', draw); }
})();
</script>

### 2.2 Tableau de synthèse

| #   | Axe                            |     Score     | Justification courte                                                                                                                          |
| --- | ------------------------------ | :-----------: | --------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | 🔀 Gestion de versions         |   **3 / 4**   | Commits conventionnels (~95 %), workflow par PR, 11 workflows CI ; **aucun tag/release** malgré une politique documentée.                     |
| 2   | 📦 Stack technique             |  **3.5 / 4**  | Stack très récent (React 19, Vite 8, TS 6, Zod 4) + automatisation d'upgrades ; 1 vuln _low_ transitive (dev), léger retard sur les _minors_. |
| 3   | 🏗️ Architecture                |   **4 / 4**   | Isolation _feature_ parfaite (0 import croisé), routes fines, logique métier en server fns + RPC/RLS.                                         |
| 4   | 📝 Qualité de code             |  **3.5 / 4**  | Nommage cohérent, dette quasi nulle (1 TODO, 0 `@ts-ignore`) ; quelques fichiers volumineux, `no-unused-vars` désactivé.                      |
| 5   | 🧪 Tests & couverture          |  **3.5 / 4**  | Couverture **93.8 %** lignes, tests pgTAP des RPC critiques, 35 specs e2e ; trous : `recoverStreak`, cron push non testés.                    |
| 6   | ⚡ Performance                 |   **3 / 4**   | _Code‑splitting_/lazy/budgets exemplaires ; fetch non borné des `attempts` + N+1 d'entitlement par parcours.                                  |
| 7   | 🪵 Logging & gestion d'erreurs |  **3.5 / 4**  | Log structuré + redaction + Sentry + _boundaries_ en couches ; redaction par nom de clé (superficielle).                                      |
| 8   | 🔒 Sécurité                    |   **4 / 4**   | Défense en profondeur : RLS, RPC `SECURITY DEFINER`, trigger anti‑escalade de rôle, CSRF, bot‑guard, rate‑limit ; aucun secret en clair.      |
|     | **Moyenne**                    | **≈ 3.5 / 4** | **Codebase mûr, discipliné, prêt pour la production.**                                                                                        |

> **Légende sévérité :** 🔴 critique · 🟠 élevée · 🟡 moyenne · 🟢 faible/bon · ✅ point fort · ❌ écart.

### 2.3 Verdict

✅ **GO.** Le projet est de **haute maturité** : _gate_ verte (lint + typecheck + 93.8 % de couverture), sécurité en
défense‑en‑profondeur, architecture _feature‑based_ rigoureusement isolée et dette technique quasi nulle. Les écarts
relevés sont **non bloquants** (perf de montée en charge, traçabilité des releases, quelques chemins non testés) et
relèvent du raffinement plutôt que de la correction.

---

## 3. Analyse détaillée

### 3.1 🔀 Gestion de versions — **3 / 4**

**Constats factuels**

- ✅ **Commits conventionnels** : ~95 % des messages suivent `feat()/fix()/docs()/chore()/test()/ci()` (26 `feat(`, 12 `fix(`, etc.).
- ✅ **Workflow par PR** : 35/40 derniers commits portent un numéro de PR `(#NNN)` ; merges propres, historique linéaire et lisible.
- ✅ **CI très complète** : 11 workflows (`ci`, `db-tests` pgTAP, `e2e`, `e2e-auth`, `nightly`, `migration-gate`, `db-migrate-prod`, `db-backup`, `regression-guard`, `upgrade-guard`, `content-audit`).
- ✅ **Hygiène du dépôt** : 2 branches seulement à l'`origin` (pas de branches abandonnées), `.gitignore`/`.gitattributes` présents, `SECURITY.md` présent.
- ❌ **Aucun tag ni release** : `git tag` → 0, alors que `docs/release-tagging-policy.md` impose des tags SemVer annotés après CI verte. La traçabilité des déploiements et le _rollback_ rapide en pâtissent.
- 🟡 Historique court (54 commits) — normal pour un projet jeune, mais limite l'analyse de tendance.

```
┌──────────────────────────────────────────────────────────┐
│ Gestion de versions                                      │
├──────────────────────────────────────────────────────────┤
│ Conventions de commit et workflow PR exemplaires, CI     │
│ riche. Manque la stratégie de release : 0 tag malgré une │
│ politique écrite — traçabilité/rollback non outillés.    │
│ 🟢 3/4 — Excellent process, traçabilité release absente. │
└──────────────────────────────────────────────────────────┘
```

---

### 3.2 📦 Stack technique — **3.5 / 4**

**Constats factuels**

- ✅ **Stack à la pointe** : React 19.2, Vite 8, TanStack Start/Router/Query, TypeScript 6, Zod 4, Tailwind 4, Supabase JS 2.108.
- ✅ **Maintenance automatisée** : `upgrade-guard.yml` détecte et applique les montées de version (patch/minor groupés auto‑mergés sur _gate_ verte, chaque _major_ isolé) ; `dependency-maintenance.md` documente la cadence.
- ✅ **Pin de sécurité** : `overrides.esbuild ^0.28.1` (pin volontaire) maintenu.
- 🟡 **Vulnérabilité unique, _low_** : `@babel/core <=7.29.0` (GHSA‑4x5r‑pxfx‑6jf8, _Arbitrary File Read via sourceMappingURL_) — **transitive et dev‑only** ; `npm audit --omit=dev` ne remonte qu'1 alerte _low_, corrigeable via `npm audit fix`.
- 🟡 **Léger retard de _minors_** : plusieurs paquets Radix/TanStack/Supabase sont 1 _minor_ derrière (ex. `@supabase/supabase-js` 2.108 → 2.110). Sans danger et géré par l'automatisation, mais à monter régulièrement.

```
┌──────────────────────────────────────────────────────────┐
│ Stack technique                                          │
├──────────────────────────────────────────────────────────┤
│ Pile moderne, à jour, avec upgrades automatisés et pin   │
│ de sécurité. 1 vuln low transitive (dev) et un léger     │
│ retard de minors gérés par upgrade-guard.                │
│ 🟢 3.5/4 — Stack excellent, hygiène CVE quasi parfaite.  │
└──────────────────────────────────────────────────────────┘
```

---

### 3.3 🏗️ Architecture — **4 / 4**

**Constats factuels**

- ✅ **Structure _feature‑based_** : `src/features/{auth, bug-report, content-report, dashboard, dungeon, notifications, parcours, parent-report, progression, quest, shop, subscription}` — chacune avec barrel `index.ts` et `*.server.ts`.
- ✅ **Isolation _feature_ PARFAITE** : **0 import croisé** détecté entre _features_ (règle « features never import features » respectée à 100 %) ; partage via `src/shared/`.
- ✅ **Routes fines** : `src/routes/` ne contient pas de logique métier — délégation aux server fns (ex. `routes/_authenticated/quest.$exerciseId.tsx` construit l'injection puis délègue à `<ExercisePlayer/>`).
- ✅ **Séparation des couches nette** : accès données = server fns `createServerFn().middleware([...])` ; logique privilégiée = RPC SQL `SECURITY DEFINER` ; UI = composants. Le `fichier:ligne` `src/start.ts` enregistre CSRF + middleware d'auth globalement.
- ✅ **Cohérence documentaire** : `CLAUDE.md` (source de vérité) + `ARCHITECTURE.md` + `docs/*` alignés.
- 🟡 **Pistes (non bloquantes)** : pipeline de contenu déterministe (UUIDv5) bien isolé ; quelques fichiers cumulatifs (cf. §3.4) gagneraient à être scindés par domaine.

```
┌──────────────────────────────────────────────────────────┐
│ Architecture                                             │
├──────────────────────────────────────────────────────────┤
│ Découpage feature-based rigoureux, isolation totale,     │
│ routes fines, logique métier centralisée en server fns + │
│ RPC/RLS. Patterns clairs et documentés.                  │
│ ✅ 4/4 — Architecture exemplaire et cohérente.           │
└──────────────────────────────────────────────────────────┘
```

---

### 3.4 📝 Qualité de code — **3.5 / 4** (moyenne des sous‑critères)

| Sous‑critère            |  Note   | Constat                                                                                                                                                                                                                                                |
| ----------------------- | :-----: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Lisibilité / clarté     |  **4**  | Indentation Prettier, nommage explicite, organisation _feature_. Commentaires « pourquoi » de grande qualité.                                                                                                                                          |
| Commentaires / doc      |  **4**  | Commentaires denses et pertinents + `CLAUDE.md`/`ARCHITECTURE.md`/`docs/` exhaustifs.                                                                                                                                                                  |
| Duplication             |  **4**  | Aucune duplication notable : rate‑limit, gestion d'erreur (`failWithClientError`), logging factorisés dans `shared/`.                                                                                                                                  |
| Code mort               |  **3**  | `@typescript-eslint/no-unused-vars` **désactivé** (`eslint.config.js`) → la détection d'imports/vars inutilisés repose sur Prettier/CI seuls. Lint néanmoins vert.                                                                                     |
| Complexité cyclomatique |  **3**  | Quelques gros fichiers : `exercise-player.tsx` (827 l.), `quest.server.ts` (800 l.), `routes/_authenticated/dashboard.tsx` (792 l.). Sous le plafond ESLint `max-lines:750` (hors blancs/commentaires) — donc conformes — mais candidats au découpage. |
| Respect SOLID           | **3.5** | **S** : server fns mono‑responsabilité ✓. **O/L** : pattern _strategy_ propre dans `ExercisePlayer` ✓. **I** : interfaces ciblées ✓. **D** : dépendance via barrels/`shared` ✓. Légère charge dans les composants game‑loop.                           |

**Dette technique mesurée**

- ✅ **1** marqueur `TODO` au total (`dashboard.server.ts:39`, optimisation SQL planifiée), **0** `FIXME`/`HACK`.
- ✅ **0** `@ts-ignore`, **0** `@ts-expect-error`, **0** `as any` dans le code applicatif (les `as any` se limitent au généré `routeTree.gen.ts`).
- ✅ Le seul `eslint-disable` est dans `routeTree.gen.ts` (généré).
- ✅ Les **2** usages de `dangerouslySetInnerHTML` sont **assainis** (`svg-figure.tsx` → `sanitizeSvg`, `lesson-reader.tsx` → `renderMarkdown`/DOMPurify).

```
┌──────────────────────────────────────────────────────────┐
│ Qualité de code                                          │
├──────────────────────────────────────────────────────────┤
│ Code propre, nommage systématique, dette quasi nulle,    │
│ zéro contournement de type. Réserves mineures : quelques │
│ fichiers volumineux et no-unused-vars désactivé.         │
│ 🟢 3.5/4 — Très bonne qualité, raffinements possibles.   │
└──────────────────────────────────────────────────────────┘
```

---

### 3.5 🧪 Tests & couverture — **3.5 / 4**

**Couverture réelle mesurée** (`vitest run --coverage`, _gate_ verte) :

| Métrique   | Couverture  | Seuil |
| ---------- | :---------: | :---: |
| Statements | **93.77 %** | 80 %  |
| Branches   | **83.44 %** | 80 %  |
| Functions  | **94.96 %** | 80 %  |
| Lines      | **94.47 %** | 80 %  |

**Constats factuels**

- ✅ **Pyramide saine** : **108** fichiers de tests unitaires/intégration (`src/**/__tests__`), **35** specs e2e Playwright (`e2e/`), **13** tests **pgTAP** SQL (`supabase/tests/`).
- ✅ **Chemins critiques couverts par pgTAP** : `award_xp`/`submit_exercise_attempt` (`04_scoring_submit_attempt`), escalade de rôle (`02_role_escalation`), isolation RLS (`03_rls_isolation`), entitlements premium (`05_parcours_entitlements`), quiz‑gate (`08_quiz_gate`), consommables (`07_shop_consumables`), lecture anonyme (`10_anon_catalogue_read`).
- ✅ **Couverture scopée au code « possédé »** (`features/`, `shared/`, `lib/`, `hooks/`) — UI vendorée/glue exclue à dessein ; seuils 80 % non dilués.
- ❌ **Trous de couverture** : `recoverStreak` (`progression.server.ts:9-77`) sans test ; `handlePushCron` (`notifications.cron.server.ts:36-100`) non testé ; `content-protection.ts` à ~26 % de lignes.
- 🟡 **Pas de benchmark perf en CI** (LCP/CWV) — le budget bundle joue le garde‑fou de taille, mais pas de régression runtime.

```
┌──────────────────────────────────────────────────────────┐
│ Tests & couverture                                       │
├──────────────────────────────────────────────────────────┤
│ Couverture 93.8% lignes, pyramide unit+e2e+pgTAP, RPC    │
│ critiques prouvés en SQL. Quelques chemins non testés    │
│ (recoverStreak, cron push) et pas de perf-bench CI.      │
│ 🟢 3.5/4 — Tests solides, trous ciblés à combler.        │
└──────────────────────────────────────────────────────────┘
```

---

### 3.6 ⚡ Performance — **3 / 4**

**Constats factuels — points forts**

- ✅ **_Code‑splitting_ soigné** : `vite.config.ts` isole `three`/`@react-three/fiber`, `motion`, Radix, Supabase en chunks séparés ; budgets vérifiés par `scripts/check-bundle-budget.mjs` (index ≤ 450 Ko, supabase ≤ 240 Ko, motion ≤ 150 Ko, i18n ≤ 88 Ko, dashboard ≤ 32 Ko).
- ✅ **Lazy‑loading des composants lourds** : `golden-hero-canvas`, `gold-ambient-canvas`, radar/inventaire, badges/shop, bannière concours chargés via `React.lazy()`.
- ✅ **Requêtes parallélisées** : `getDashboard` regroupe 4 requêtes en `Promise.all` (`dashboard.server.ts:41`), `staleTime` configuré côté Query (`use-my-role.ts:26` = 5 min, `manuel-pages-section.tsx:31` = 50 min).

**Constats factuels — écarts**

- 🟡 **Sur‑fetch non borné des `attempts`** (`dashboard.server.ts:50`) : `statsRes` lit **toutes** les tentatives de l'utilisateur (sans `limit`) pour agréger les stats par matière côté serveur. Coûteux pour un utilisateur actif (1000+ tentatives). Déjà tracé par `TODO(review #18)` → vue/RPC `subject_stats` (GROUP BY) recommandée.
- 🟡 **N+1 d'entitlement par parcours** (`dashboard.server.ts:348-365`) : `getParcours` émet un RPC `has_parcours_entitlement` **par parcours premium** dans un `Promise.all`. **Borné aujourd'hui** (seulement 2 parcours concours premium, et seulement si connecté), donc impact réel faible — mais ne monte pas en charge si le catalogue premium s'élargit ; à remplacer par un RPC _batch_/jointure.
- 🟢 **Élagage cron en N+1** (`notifications.cron.server.ts:73-92`) : une suppression par endpoint mort (404/410). Tâche planifiée hors chemin utilisateur → impact mineur.

```
┌──────────────────────────────────────────────────────────┐
│ Performance                                              │
├──────────────────────────────────────────────────────────┤
│ Splitting/lazy/budgets exemplaires côté bundle. Côté DB, │
│ un fetch attempts non borné et un N+1 d'entitlement (peu │
│ impactant aujourd'hui) limitent la montée en charge.     │
│ 🟢 3/4 — Bon front, à durcir côté agrégats serveur.      │
└──────────────────────────────────────────────────────────┘
```

---

### 3.7 🪵 Logging & gestion d'erreurs — **3.5 / 4**

**Constats factuels**

- ✅ **Log structuré JSON** (`src/shared/lib/logger.ts`) : `{ ts, level, message, ...meta }`, niveaux `info`/`warn`/`error`, forward Sentry sur `error`.
- ✅ **Redaction de secrets** : clés contenant `token`/`secret`/`password`/`key` masquées en `********` (`logger.ts:14-21`).
- ✅ **Gestion d'erreur en couches** : _error boundary_ racine (`__root.tsx`), utilitaire `failWithClientError` (log serveur complet + message FR utilisateur), page d'erreur _branded_ (`error-page.ts`), normalisation des 500 « avalés » par h3 (`server.ts`), capture Sentry sans DSN = no‑op (`monitoring.ts`).
- ✅ **Console maîtrisée** : **3** `console.*` bruts seulement et tous justifiés (config Supabase manquante côté client/serveur, _fallback_ délibéré dans `start.ts`). Le reste passe par le logger.
- 🟡 **Redaction superficielle** : basée sur le **nom** de la clé. Un secret rangé sous une clé non listée (ex. `authorization`/`bearer`) échapperait au masquage. Étendre la liste ou _hasher_ les valeurs sensibles.

```
┌──────────────────────────────────────────────────────────┐
│ Logging & gestion d'erreurs                              │
├──────────────────────────────────────────────────────────┤
│ Logger structuré, redaction, Sentry, boundaries en       │
│ couches et page d'erreur branded. Seul bémol : redaction │
│ par nom de clé, contournable par une clé non listée.     │
│ 🟢 3.5/4 — Très bon, durcir la redaction.                │
└──────────────────────────────────────────────────────────┘
```

---

### 3.8 🔒 Sécurité — **4 / 4**

**Constats factuels — défense en profondeur**

- ✅ **Auth serveur robuste** (`auth-middleware.ts`) : tout server fn passe par `requireSupabaseAuth`/`optionalSupabaseAuth` ; le JWT `Bearer` est vérifié via `supabase.auth.getClaims(token)` (anti‑falsification), `sub` exigé.
- ✅ **CSRF global** (`start.ts`) : `createCsrfMiddleware` sur tous les `serverFn`.
- ✅ **RLS partout** : RLS activé sur l'ensemble des tables ; politiques admin via helper `is_admin()` (`SECURITY DEFINER`, anti‑récursion RLS).
- ✅ **RPC privilégiés verrouillés** : `award_xp`/`award_coins` **REVOKE**és de `authenticated` (`20260606150000_security_p0_hardening.sql`) — impossible de _minter_ XP/coins ; appel uniquement interne.
- ✅ **Anti‑escalade de rôle** : colonne `role` non modifiable au niveau colonne ; seul `set_profile_role()` (auto‑scopé, `'student'|'parent'` uniquement) + trigger `prevent_role_escalation()` autorisent un changement ; admin réservé au `service_role`.
- ✅ **Immutabilité de l'économie** : `GRANT UPDATE` limité à `(display_name, avatar_slug, current_streak, last_active_date, current_grade_id)` — `xp/level/coins/role` non _writables_ directement.
- ✅ **Validation d'entrée** : **tous** les server fns valident via **Zod** (`.inputValidator`).
- ✅ **XSS maîtrisé** : `renderMarkdown` (escape HTML d'abord, puis DOMPurify avec allow‑list, SVG mis en quarantaine/assaini séparément) ; les 2 `dangerouslySetInnerHTML` sont assainis.
- ✅ **Secrets** : aucun secret en clair (grep `sk_live|AKIA|password=` → 0) ; `SUPABASE_SERVICE_ROLE_KEY`/VAPID/`CRON_SECRET` lus via `process.env` côté serveur uniquement ; clé anon/publishable publique **par conception** (RLS = frontière). `SECURITY.md` documente le périmètre et la rotation.
- ✅ **Bot‑guard + rate‑limit multi‑couches** : `bot-guard.ts` (allow crawlers SEO, 403 sur scrapers IA/outils, burst IP) + rate‑limit par RPC `check_rate_limit` (ex. `submitAttempt` 5/10 s, donjon 40/60 s) avec _fallback_ mémoire.

```
┌──────────────────────────────────────────────────────────┐
│ Sécurité                                                 │
├──────────────────────────────────────────────────────────┤
│ Défense en profondeur : RLS + RPC SECURITY DEFINER +     │
│ trigger anti-escalade + grants colonne + CSRF + Zod +    │
│ DOMPurify + bot-guard/rate-limit. Aucun secret en clair. │
│ ✅ 4/4 — Posture de sécurité exemplaire, sans High.      │
└──────────────────────────────────────────────────────────┘
```

---

## 4. Conclusion

### 4.1 ✅ Points forts (top 5)

1. ✅ **Sécurité en défense‑en‑profondeur** — RLS + RPC `SECURITY DEFINER` + trigger anti‑escalade + grants colonne + CSRF + Zod + bot‑guard/rate‑limit, prouvés par des tests pgTAP dédiés. Aucune faille _High_.
2. ✅ **Architecture _feature‑based_ irréprochable** — 0 import croisé entre _features_, routes fines, logique métier centralisée. Extensible sans dette.
3. ✅ **Dette technique quasi nulle** — 1 `TODO`, 0 `@ts-ignore`/`as any` applicatif, _gate_ stricte (`--max-warnings=0`) verte.
4. ✅ **Couverture de tests élevée et ciblée** — 93.8 % lignes, pyramide unit + e2e + pgTAP, RPC critiques prouvés en SQL.
5. ✅ **Industrialisation CI/CD remarquable** — 11 workflows (migration‑gate, prod‑apply gardé, regression/upgrade/content guards), pipeline de contenu déterministe, budgets de bundle.

### 4.2 ❌ Axes d'amélioration prioritaires (top 5)

1. 🟡 **Agrégats serveur non bornés** — fetch de toutes les `attempts` pour les stats par matière ; remplacer par une vue/RPC `subject_stats` (GROUP BY).
2. 🟡 **Traçabilité des releases** — appliquer `release-tagging-policy.md` : tags SemVer annotés après CI verte.
3. 🟡 **N+1 d'entitlement** — `getParcours` émet un RPC par parcours premium ; basculer sur un RPC _batch_/jointure avant d'élargir le catalogue premium.
4. 🟡 **Trous de tests ciblés** — couvrir `recoverStreak` et `handlePushCron` ; remonter `content-protection.ts`.
5. 🟢 **Durcissements mineurs** — réactiver `no-unused-vars` (ou `argsIgnorePattern`), étendre la redaction du logger (clés `authorization`/`bearer`), corriger la vuln _low_ `@babel/core` (`npm audit fix`).

### 4.3 📋 Plan d'action priorisé (max. 10)

| #   | Priorité | Action                                                                                                                      | Effort | Axe         |
| --- | :------: | --------------------------------------------------------------------------------------------------------------------------- | :----: | ----------- |
| 1   |  🔴 P1   | Créer une vue/RPC `subject_stats` (GROUP BY subject_id) et remplacer le fetch non borné des `attempts` dans `getDashboard`. |   M    | ⚡ Perf     |
| 2   |  🟠 P2   | Remplacer le N+1 `has_parcours_entitlement` de `getParcours` par un RPC _batch_/jointure.                                   |   M    | ⚡ Perf     |
| 3   |  🟠 P2   | Mettre en place le _tagging_ SemVer (workflow « release » après CI verte) conformément à `release-tagging-policy.md`.       |   S    | 🔀 Versions |
| 4   |  🟠 P2   | Ajouter des tests pour `recoverStreak` et `handlePushCron` ; remonter `content-protection.ts` au‑dessus du seuil.           |   M    | 🧪 Tests    |
| 5   |  🟡 P3   | `npm audit fix` pour la vuln _low_ `@babel/core`, puis monter le lot de _minors_ en retard via `upgrade-guard`.             |   S    | 📦 Stack    |
| 6   |  🟡 P3   | Réactiver `@typescript-eslint/no-unused-vars` (avec `argsIgnorePattern: "^_"`) pour outiller la détection de code mort.     |   S    | 📝 Qualité  |
| 7   |  🟡 P3   | Étendre la redaction du logger (ajouter `authorization`, `bearer`, `cookie`) ou masquer par valeur.                         |   S    | 🪵 Logging  |
| 8   |  🟡 P3   | Scinder `quest.server.ts` (session / contenu / public) et extraire des sous‑composants de `dashboard.tsx`.                  |   M    | 📝 Qualité  |
| 9   |  🟢 P4   | Batcher l'élagage des endpoints push morts (une requête `DELETE … IN (...)`).                                               |   S    | ⚡ Perf     |
| 10  |  🟢 P4   | Ajouter un budget de perf runtime (Lighthouse CI / LCP) en complément du budget bundle.                                     |   M    | 🧪 Tests    |

---

### 📎 Annexes

- **Métriques détaillées :** [`codebase-audit-metrics.csv`](./codebase-audit-metrics.csv)
- **Checklist d'actions :** [`codebase-audit-action-plan.md`](./codebase-audit-action-plan.md)
- **Effort :** S ≈ < 0.5 j · M ≈ 0.5–2 j · L ≈ > 2 j.

> _Rapport généré dans le cadre d'un audit automatisé assisté. Les scores reflètent l'état du commit `5fc5452` ;
> les écarts relevés sont non bloquants et n'altèrent pas le verdict **GO**._
