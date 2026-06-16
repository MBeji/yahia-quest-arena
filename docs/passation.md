# Document de passation — Na9ra Nal3ab (yahia-quest-arena)

> **Snapshot de passation** destiné à toute personne (ou agent) qui reprend le projet.
> Il donne l'image d'ensemble, l'état courant et les points d'entrée. Il **ne fait pas
> autorité** : la source canonique reste [`CLAUDE.md`](../CLAUDE.md) (qui gagne sur tout
> autre doc), complétée par [`ARCHITECTURE.md`](../ARCHITECTURE.md). En cas de
> divergence, corriger ce fichier — pas l'inverse.
>
> **Dernière mise à jour :** 2026-06-16 · **Branche de référence :** `main` (auto-déploie en prod Vercel).

---

## 1. En une phrase

Académie d'apprentissage **gamifiée** (manga shōnen / RPG), trilingue **FR / EN / AR (RTL)** :
l'élève fait des « quêtes » (QCM), gagne XP / pièces, débloque badges, monte de niveau et de
classe de héros, grimpe au classement et affronte un mode « donjon » chronométré. Catalogue large
structuré en `thèmes → grades → matières → chapitres → exercices → questions`.

## 2. Stack & déploiement

- **Front/SSR :** Vite 8 · TanStack Start (SSR + file-routing + server fns) · React 19 ·
  TanStack Query 5 · Tailwind 4 / Radix-shadcn.
- **Backend :** Supabase (Postgres + Auth + RLS). Logique métier sensible **en SQL**
  (`award_xp`, `submit_exercise_attempt`, `resolve_exercise_access`, …).
- **Déploiement :** push sur **`main` → auto-déploie la prod sur Vercel**
  (`scripts/build-vercel.mjs`, `vercel.json`). Une config Cloudflare Workers existe mais
  Vercel est la cible live.
- **Toolchain :** npm (`package-lock.json`), **Node 22 / npm 10** (CI). Tests : Vitest 4 +
  Testing Library (unit) et Playwright (e2e).

> ⚠️ **Couplage DB ↔ code (DoD §7).** Comme `main` déploie en prod, toute migration dont
> dépend le code **doit être appliquée à la DB AVANT le push**. Les migrations ne sont pas
> auto-appliquées : `supabase db push` ou l'éditeur SQL Supabase.

## 3. État courant (au 2026-06-16)

| Domaine | État |
|---|---|
| **Features** (`src/features/`) | **11** : `auth`, `dashboard`, `quest`, `dungeon`, `shop`, `progression`, `parent-report`, `subscription`, `content-report`, `parcours`, `notifications` (web-push, Phase 1). _NB : CLAUDE.md cite encore « 10 features » — `notifications` est la 11ᵉ, ajoutée plus tard._ |
| **Migrations Supabase** | 108 fichiers dans `supabase/migrations/` (dont le contenu pédagogique généré). |
| **Tests unit/intégration** | ~78 fichiers de tests Vitest. Gate à 80 % (réel ≈ 93 % lignes). |
| **E2E** | ~32 specs Playwright (`e2e/`) — projet Supabase TEST dédié, **hors** gate unitaire. |
| **Thèmes avec contenu** | `ecole-tn`, `culture-generale`, `muscle-cerveau`, `anglais`, `francais`. Le track standalone **`arabe` n'a pas encore de contenu** (l'arabe scolaire vit sous `ecole-tn`). |
| **Branche de travail courante** | `claude/passation-document-update-vij7fu` — au même commit qu'`origin/main`. |

## 4. Modèle de données & règles métier (rappel)

Détail complet : [`CLAUDE.md` §Data model](../CLAUDE.md) et `ARCHITECTURE.md`. Points clés :

- **Hiérarchie catalogue :** seul le thème école a des **grades** (échelle tunisienne 1ʳᵉ
  base → Bac, 13 niveaux ; 6ème/9ème/Bac = examens nationaux). Tout sous `subjects` est
  agnostique au thème/grade.
- **Parcours & premium :** un **parcours** = `(thème, grade)`. Les 2 parcours **concours**
  (9ème, 6ème) sont PREMIUM ; le reste est FREE. L'accès est tranché **côté serveur** par
  `resolve_exercise_access` ; un parcours premium n'ouvre une mission qu'au détenteur d'un
  `parcours_entitlement` vivant (direct ou via parent lié = _family pack_), **sauf l'aperçu
  gratuit** (quiz de compréhension + difficulté 1). Le donjon est un perk premium.
- **Gamification :** seuils centralisés dans `src/shared/constants/gamification.ts` (200 XP/niveau,
  paliers de classe). Anti-farm : gates `tooFast` / `≥60 %` / `improved`.
- **Consommables (boutique) :** potions, bouclier de retry, bouclier de streak, indices —
  modèle « armé » via `inventory_items.is_active`. Voir ARCHITECTURE.md « Consumables ».

## 5. Démarrer / commandes essentielles

```bash
npm run dev          # serveur de dev (SSR)
npm run verify       # lint + typecheck + tests  (gate local / pre-push)
npm run ci:verify    # gate complet (+ coverage + build + audit + content:qa:strict)

# Pipeline de contenu (fichiers content/ → migrations SQL)
npm run content:check      # valide sans rien écrire
npm run content:build      # compile content/ → SQL idempotent dans supabase/migrations/
npm run content:qa:strict  # QA contenu, échoue sur warning
```

**Hooks husky :** `pre-commit` = lint-staged ; `pre-push` = `npm run verify`. Ne pas
contourner avec `--no-verify` sans raison.

## 6. Contenu pédagogique (le « bon » chemin)

Le contenu **n'est pas** du SQL écrit à la main : il vit en fichiers versionnés sous
`content/<matière>/NN-<slug>/` (`subject.json`, `chapter.json`, `cours.md`, `resume.md`,
`quiz.json`, `exercices/*.json`), validés par Zod puis compilés en migrations **idempotentes**
(UUIDv5 déterministes). **Pour ajouter/éditer du contenu : modifier `content/`, puis
`content:build`, relire le SQL, l'appliquer à la DB avant de déployer le code dépendant.**

L'authoring est industrialisé via les **skills Claude Code** sous `.claude/skills/`
(`content-engine` = cœur partagé ; wrappers par programme : `content-ecole-tn`,
`content-culture-generale`, `content-muscle-cerveau`, `content-iq-training`,
`content-langue-{anglais,francais,arabe}`, plus `content-cours` et `content-audit`).
Règle de notation : **chiffres occidentaux (0–9), équations LTR, unités SI partout — y
compris en arabe** (jamais de chiffres indo-arabes).

## 7. Opérations & automatisations

- **Déploiement :** push `main` → Vercel prod. Voir `docs/ci-cd-and-branch-protection.md`.
- **Sauvegardes/restauration :** `docs/backup-restore-runbook.md` (drills TEST+PROD validés).
- **E2E authentifié :** projet Supabase **TEST dédié** uniquement ; `cp .env.test.example .env.test`,
  `npm run e2e:doctor` / `e2e:setup` / `test:e2e:auth`. **Ne jamais pointer l'e2e sur la prod.**
  Runbook : `e2e/README.md`.
- **Garde-fous nocturnes (GitHub Actions + skills) :** `regression-guard` (23:00 UTC),
  `nightly` (01:00 UTC : E2E + pgTAP), puis `upgrade-guard` (montées de stack après un
  nightly vert). Aucun ne push sur `main` directement. Cadence/pièges :
  `docs/dependency-maintenance.md`.
- **Variables d'env runtime :** `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` (manquantes → le
  middleware lève une erreur explicite). Détail : `docs/environment-variables.md`.

## 8. Backlog ouvert (audit UX/UI — `docs/audit-ecrans-ux.md`, daté 2026-06-13)

Les **P0 (🔴) sont traités** (fil de navigation chapitre unifié, CTA leçon→quiz, i18n du bloc
donjon, `aria-label` nav, lien retour rapport parent). **Reste ouvert :**

**P1 (🟠) — important**
- (9) Corriger le lien/libellé « Admin » → `/parent-report`.
- (10) `DailyXpWidget` : afficher l'XP réel du jour + `dailyGoal` issu de `gamification.ts`.
- (11) Unifier les seuils de complétude (40/60/étoiles) sur le gate XP 60 %.
- (12) Désactiver/rediriger les cartes premium verrouillées de l'Explorer + toast au switch de parcours.
- (13) États d'erreur sur `parcours.tsx` / `parcours.$subjectId.tsx`.
- (14) Couleur d'erreur destructive (au lieu de doré) + lien « Mot de passe oublié » à l'auth.
- (15) Confirmation sur les actions destructives admin ; titre d'exercice signalé cliquable.
- (16) Barre de progression quête `(idx+1)/total` ; état « Quête suivante ».
- (17) Inventaire : « voir tout » + explication des slots d'armement.
- (18) Préciser le périmètre du paywall (missions concours + donjon) ; éviter le double retour.
- (19) Uniformiser le logo (Crown vs Sparkles).

**P2 (🟡) — finitions :** reliquats i18n (« Loading… », « XP Progress », suffixe « j »,
« Coins », `itemType`/`rarity`…), a11y (`aria-busy`/`role="status"` sur skeletons,
`aria-label` sur dots/badges, `<ul role="list">` au classement, `prefers-reduced-motion`),
import mort `LanguageSwitcher` (`dashboard.tsx`), `console.error` → logger structuré,
liens légaux au footer, vocabulaire « Abonnement requis » → entitlement/parcours.

**Non corrigeable en code (donnée, pas bug) :** F3 `name_fr` — il n'existe pas de nom
localisé par enregistrement ; relève de l'authoring de contenu.

## 9. Pièges connus (à lire avant de toucher au code)

- **Migration feature/shared terminée** : plus de shims de rétro-compat (`src/lib/*`,
  `src/integrations/*`, `src/hooks/use-auth`…). Homes canoniques : server fns/helpers →
  `@/features/{name}` ; utils/logger/supabase/types → `@/shared/*`.
- **Pas de `src/shared/ui`** : importer les primitives UI via `@/components/ui/*` (le guide
  Copilot et CLAUDE.md notent cette dérive — `@/shared/ui/` n'a jamais existé).
- `src/routeTree.gen.ts` et `auth-middleware.ts` sont **générés / sensibles** — éditer avec soin.
- **Nouvelles tables = GRANTs explicites** : sur un DB neuf (pgTAP nightly), un `CREATE TABLE`
  sans `GRANT … TO authenticated` casse. Baseline : `20260612221000_baseline_table_grants.sql`.
- **Config Vite inline** (`vite.config.ts`) : `manualChunks` calé sur les budgets bundle —
  le retoucher peut créer un chunk vendor circulaire (crash prod). Re-run `npm run build:check`.
- **`ci.yml` ≠ gate complet** : il ne lance pas `content:qa:strict` ; le faire soi-même en
  touchant `content/`. CLI Supabase **épinglée** dans `db-tests.yml` / `e2e-auth.yml`.
- **E2E ≠ gate unitaire** : Playwright tape un projet Supabase TEST réel, pas les mocks.

## 10. Definition of Done (non négociable)

Une tâche est *done* seulement si : (1) le gate est vert (`npm run verify`, ou `ci:verify`
pour du release-grade) ; (2) le gate n'est pas affaibli (pas de `@ts-ignore`/`as any`, pas de
règle ESLint désactivée inline, pas de baisse de seuils, pas de `--no-verify`) ; (3) zéro
nouvelle dette (pas de shim/dead code/duplication) ; (4) types réels (`tsc` passe) ; (5) les
tests voyagent avec le code ; (6) commits petits et conventionnels ; (7) **migration DB
appliquée AVANT le push** quand le code en dépend. Détail : `CLAUDE.md` §Working mode.

## 11. Prochaines étapes recommandées

1. Solder les **P1 de l'audit UX** (liste §8) — petits lots reviewables, tests co-localisés.
2. **Authoring du track `arabe`** standalone (aujourd'hui sans contenu) si priorisé produit.
3. Web-push **au-delà de la Phase 1** (rappels streak) si la roadmap le prévoit.
4. Tenir CLAUDE.md à jour : aligner le **compte de features (11)** et la mention `notifications`.

## 12. Références canoniques

- [`CLAUDE.md`](../CLAUDE.md) — source de vérité (commandes, conventions, gotchas).
- [`ARCHITECTURE.md`](../ARCHITECTURE.md) — architecture détaillée.
- [`content/README.md`](../content/README.md) — pipeline de contenu (FR).
- [`e2e/README.md`](../e2e/README.md) — runbook E2E.
- `docs/` — `audit-ecrans-ux.md`, `backup-restore-runbook.md`, `ci-cd-and-branch-protection.md`,
  `dependency-maintenance.md`, `environment-variables.md`, `logging-standard.md`,
  `release-tagging-policy.md`, `xss-rendering-policy.md`.
- `.claude/skills/` — skills d'authoring & de garde (contenu, audit, verify, regression/upgrade-guard).
