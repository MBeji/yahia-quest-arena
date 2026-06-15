---
name: code-review
description: >-
  Revue de code complète d'une PR de yahia-quest-arena. Pilote un harness de
  revue reproductible (cadrage du diff, gate automatique, checklist par axe :
  architecture, craft, sécurité, complétude, cohérence projet, perf, i18n/RTL,
  DB↔code, tests, accessibilité) puis produit un verdict go/no-go classé par
  sévérité. À utiliser dès qu'on demande de « relire », « reviewer », « faire la
  revue », « code review » d'une PR, d'une branche ou du diff courant.
---

# Revue de code — Na9ra Nal3ab (yahia-quest-arena)

Ce skill conduit une **revue de code complète et exigeante** d'une PR. Il ne se
limite pas à chercher des bugs : il évalue l'architecture, le craft, la
sécurité, la complétude, la cohérence avec le projet et la dette technique, en
s'appuyant sur les règles canoniques de `CLAUDE.md` et `ARCHITECTURE.md`.

> **Principe directeur.** `CLAUDE.md` est la source de vérité. Toute violation
> d'une règle de `CLAUDE.md` est, par défaut, **bloquante**. En cas de doute
> entre deux interprétations, c'est `CLAUDE.md` puis `ARCHITECTURE.md` qui
> tranchent ; les docs `docs/*.md` défèrent à ces deux fichiers.

---

## Le harness de revue (procédure, dans l'ordre)

Exécute ces étapes dans l'ordre. Ne saute jamais une étape ; si une étape est
sans objet (ex. aucune migration), dis-le explicitement dans le rapport.

### 1. Cadrer le périmètre

Identifie précisément ce qui est revu :

```bash
git fetch origin
git log --oneline origin/main..HEAD        # commits de la branche
git diff --stat origin/main...HEAD          # surface du changement
git diff origin/main...HEAD                 # le diff complet
```

- Note la **taille** (fichiers/lignes touchés) et la **nature** (feature, fix,
  refactor, migration, chore).
- Lis la **description de la PR** et l'issue liée : le diff fait-il ce qui est
  annoncé, ni plus ni moins ? Tout écart (scope creep, TODO orphelin, fichier
  hors sujet) est un finding.
- Repère les **zones sensibles** touchées (voir §« Points chauds » plus bas)
  pour calibrer la profondeur de la relecture.

### 2. Reconstituer le contexte

On ne juge pas une ligne hors contexte. Pour chaque fichier modifié :

- Ouvre le **fichier entier**, pas seulement le hunk, pour comprendre les
  invariants locaux.
- Trouve les **appelants/appelés** (Grep) : un changement de signature ou de
  contrat casse-t-il un consommateur ?
- Vérifie l'existence de **tests co-localisés** dans le `__tests__/` de la
  feature concernée.

### 3. Passer le gate automatique

Le craft « gratuit » se vérifie par la machine, pas à l'œil. Lance d'abord :

```bash
npm run verify        # lint (zéro warning) + typecheck strict + tests
```

Pour une PR release-grade ou qui touche build/contenu/DB :

```bash
npm run ci:verify     # + coverage (seuils 80%) + build:check + audit:deps
```

Un gate rouge est un finding **bloquant** : ne continue pas la revue comme si de
rien n'était, signale-le en tête de rapport. (Skill associé : `/verify`.)

### 4. Dérouler la checklist par axe (§ ci-dessous)

Pour **chaque** axe, parcours les points et consigne les écarts. Un axe « OK »
doit être affirmé explicitement, pas passé sous silence.

### 5. Classer chaque finding par sévérité

| Sévérité                | Sens                                    | Exemples                                                                                                                   |
| ----------------------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 🔴 **Bloquant**         | Doit être corrigé avant merge           | Faille de sécurité, RLS/grant manquant, gate rouge, régression, violation `CLAUDE.md`, ordre migration↔deploy non respecté |
| 🟠 **Majeur**           | À corriger sauf justification explicite | Bug edge-case, fuite d'abstraction, frontière feature/shared franchie, test manquant sur comportement nouveau              |
| 🟡 **Mineur**           | À améliorer                             | Lisibilité, nommage, duplication légère, log mal placé                                                                     |
| 🔵 **Nit / suggestion** | Optionnel                               | Style, micro-perf, idée d'amélioration future                                                                              |

Chaque finding cite **`fichier:ligne`**, explique le **pourquoi** (impact, pas
seulement « c'est mal »), et propose un **correctif concret**.

### 6. Rendre le verdict (format en fin de fichier)

---

## Checklist par axe

### A. Architecture & frontières

- [ ] **Frontières feature/shared respectées** : une feature **n'importe jamais**
      une autre feature. Le partage passe par `src/shared/`. (Violation =
      bloquant.)
- [ ] **Routes minces** : `src/routes/*` ne contient pas de logique métier ;
      celle-ci vit dans `{feature}.server.ts` / helpers de la feature.
- [ ] **Bon home** : server fns + helpers → `@/features/{name}` ;
      utils/logger/supabase/types → `@/shared/*` ; primitives UI →
      `@/components/ui/*` (il n'y a **pas** de `src/shared/ui`) ; i18n →
      `@/lib/i18n` ; hook mobile → `@/hooks/use-mobile` ; `useAuth` →
      `@/features/auth`.
- [ ] **Barrels** : l'API publique d'une feature passe par son `index.ts` ; pas
      d'import « profond » qui contourne le barrel.
- [ ] **Pas de fichier généré édité à la main** : `routeTree.gen.ts`,
      `supabase/integrations/.../types.ts` (régénérer via `supabase gen types`),
      migrations de contenu sous `supabase/migrations/` (régénérer via
      `content:build`), `auth-middleware.ts` (édition prudente seulement).
- [ ] **Pas de dette nouvelle** : aucun shim de rétro-compat, code mort, ou
      module dupliqué. Ce qui est remplacé est **supprimé**.

### B. Craft & lisibilité

- [ ] Le code **ressemble au code environnant** : mêmes idiomes, densité de
      commentaires, conventions de nommage.
- [ ] **Nommage** : fichiers en kebab-case ; server fns nommées par des verbes
      (`getSubject`, `submitAttempt`).
- [ ] Fonctions à responsabilité unique, sans complexité accidentelle ; pas de
      copier-coller là où une abstraction existe déjà dans `shared/`.
- [ ] Gestion d'erreur explicite : pas d'erreur avalée silencieusement ; les
      messages sont actionnables.
- [ ] Pas de nombres/seuils magiques en dur : les règles de gameplay vivent dans
      `src/shared/constants/gamification.ts`, pas inline.

### C. Sécurité (axe prioritaire)

- [ ] **Authn/Authz sur server fns** : chaque `createServerFn` passe par
      `.middleware([requireSupabaseAuth])` ; le `userId`/`claims` vient du
      contexte injecté, **jamais** de l'input client.
- [ ] **RLS & grants** : toute nouvelle table a une RLS ; les fonctions
      privilégiées (`award_xp`, `submit_exercise_attempt`, …) restent `REVOKE`
      pour `anon`/`authenticated`. Pas d'élévation de privilège via RPC.
- [ ] **Validation d'entrée** : `zod` via `.inputValidator` sur **chaque** server
      fn ; bornes, types et énumérations vérifiés côté serveur.
- [ ] **Anti-triche économie/gameplay** : les récompenses (XP/coins), l'usage des
      consommables et les gates anti-farm (`tooFast` / `≥60%` / `improved`) ne
      sont jamais contournables côté client ; le scoring reste atomique dans
      `submit_exercise_attempt`.
- [ ] **Gate premium par parcours** : l'accès est désormais **par parcours** — un
      parcours concours exige une entitlement active (l'aperçu gratuit = quiz de
      compréhension + difficulté 1). Vérifié **côté serveur** via
      `resolve_exercise_access`, jamais seulement masqué dans l'UI.
- [ ] **Données de mineurs / vie privée** : pas d'exposition de PII (élève,
      famille) au-delà du strict nécessaire ; les `parent_student_links`,
      `parent-report`, leaderboard ne fuitent pas d'identifiants/données privées.
- [ ] **XSS** : tout HTML rendu est assaini via DOMPurify
      (`src/shared/lib/markdown.ts`) ; conformité à `docs/xss-rendering-policy.md` ;
      pas de `dangerouslySetInnerHTML` non assaini.
- [ ] **Secrets & logs** : aucun secret en dur ; logs via `@/shared/lib/logger`
      (qui redacte), jamais de `console` brut exposant des données sensibles ;
      cf. `docs/logging-standard.md`.
- [ ] **Env vars** : usage conforme à `docs/environment-variables.md` ; absence
      gérée proprement (erreur descriptive, pas de fail silencieux).

### D. Complétude & exactitude

- [ ] **Cas limites** : null/undefined, listes vides, échecs réseau/RPC,
      concurrence (double soumission), valeurs aux bornes (0%, 60%, 100%).
- [ ] **Dégradation gracieuse préservée** : les fns qui tolèrent un RPC manquant
      (ex. `get_best_scores_by_exercise` → fallback vide) gardent ce
      comportement.
- [ ] **i18n/RTL** : toute chaîne visible est traduite (FR/EN/AR), pas de texte en
      dur ; les nouveaux écrans fonctionnent en RTL (arabe).
- [ ] **États UI** : loading / erreur / vide / succès tous gérés ; pas d'« écran
      blanc » sur erreur. Redirection auth dans un `useEffect`, pas pendant le
      render.
- [ ] **Pas de régression** : le changement ne casse aucun parcours existant
      (quest → submit, dungeon, shop, progression, parcours).

### E. Cohérence avec le projet

- [ ] Respecte les **10 features** et leur structure (`index.ts`,
      `{name}.server.ts`, `components/`, `__tests__/`).
- [ ] **Contenu sujets** : aucun ajout de chapitre/exercice par migration écrite à
      la main — éditer `content/` puis `content:build`. `content:qa` passe.
- [ ] Style de commit **conventionnel** (`feat:`, `fix:`, `test:`, `chore:`…),
      messages clairs ; commits petits et revue-ables.
- [ ] Cohérence avec les patterns déjà présents (TanStack Query pour le cache,
      server fns pour l'accès données, etc.).

### F. Données ↔ code (déploiement)

- [ ] **Ordre migration↔deploy** : si le code dépend d'une nouvelle migration
      (table/colonne/RPC, grants révoqués), la migration est-elle prévue pour être
      **appliquée avant** le push/déploiement ? Pousser sur `main` auto-déploie en
      prod : un code en avance sur le schéma = **bloquant**.
- [ ] Migrations **idempotentes** et réversibles dans la mesure du possible ; pas
      d'output dépendant de la machine.
- [ ] Types Supabase régénérés si le schéma change (`types.ts` à jour).

### G. Tests

- [ ] **Les tests voyagent avec le code** : tout comportement nouveau/modifié a
      des tests co-localisés dans `__tests__/`.
- [ ] La **couverture ne régresse pas** (seuils 80% partout) ; pas d'élargissement
      de `include` pour diluer la métrique avec du code vendored/glue.
- [ ] Les tests vérifient le **comportement** (entrées/sorties, effets), pas
      l'implémentation ; cas d'erreur et cas limites couverts.
- [ ] Pour les changements DB sensibles, penser à la suite pgTAP (grants, RLS,
      scoring) ; pour les parcours utilisateurs, aux specs Playwright `/e2e`.

### H. Performance

- [ ] Pas de N+1 ni de requête non bornée ; FK du chemin chaud indexées si
      pertinent.
- [ ] Pas de travail coûteux dans le render React ; mémoïsation là où nécessaire,
      mais pas de sur-optimisation.
- [ ] Budget de bundle respecté (`build:check`) ; pas d'import lourd inutile.

### I. Accessibilité & UX

- [ ] Sémantique HTML / rôles ARIA / focus management corrects sur les nouveaux
      composants interactifs.
- [ ] Contrastes et tailles de cibles raisonnables ; navigation clavier possible.

### J. Autres signaux à surveiller

- [ ] **Dépendances** : nouvel ajout justifié, maintenu, sans doublon avec
      l'existant ; `audit:deps` propre ; cf. `docs/dependency-maintenance.md`.
- [ ] **Compat SSR / Workers** : pas d'API navigateur-only exécutée côté serveur.
- [ ] Pas de `--no-verify`, `@ts-ignore`/`as any`, règle ESLint désactivée inline,
      ni seuil de couverture abaissé pour « faire passer » (affaiblir le gate =
      bloquant).

---

## Points chauds (relire en profondeur)

Ces zones concentrent le risque ; double-attention dès qu'elles sont touchées :

- `submit_exercise_attempt`, `award_xp`, `handle_new_user` — scoring,
  récompenses, anti-triche atomiques (SQL).
- `activate_inventory_item` / mécaniques de consommables (slots next-quest vs
  passif, anti-gaspillage).
- `auth-middleware.ts` et tout `createServerFn` — surface authn/authz.
- Gate premium (`parcours/` — entitlements + `resolve_exercise_access`) — toute logique de
  scoring/déblocage ; aucun code ne dépend de `subscription_*` / `has_active_subscription` /
  `admin_*_subscription` (supprimés dans la migration `20260609000000`).
- `content-report/` et `parent-report/` — exposition de données.
- `src/server.ts` / `src/start.ts` — entrées SSR/Worker, gestion d'erreur 500.
- Toute migration sous `supabase/migrations/` et les grants/RLS.

---

## Format du rapport (verdict)

Termine **toujours** par un rapport structuré :

1. **Verdict** : ✅ Approuvé · 🟠 Approuvé sous réserve · 🔴 Changements requis.
2. **Résumé** : 2-3 lignes — ce que fait la PR, qualité globale, gate (vert/rouge).
3. **Findings par sévérité** (🔴 → 🔵), chacun avec `fichier:ligne`, le
   _pourquoi_ (impact) et un correctif proposé. Regroupe par axe si volumineux.
4. **Ce qui est bien** : souligne les bons choix (renforce les bonnes pratiques).
5. **Checklist de sortie** : liste cochée des axes A→J (OK / N/A / findings).

### Règles de conduite

- **Cite toujours `fichier:ligne`** ; pas de critique abstraite.
- **Explique l'impact**, pas seulement la règle violée.
- **Distingue le bloquant du goût** : ne noie pas un finding sécurité sous des
  nits de style.
- **Ne réécris pas la PR** : propose des correctifs ciblés. N'applique des
  changements que si on te le demande explicitement.
- **Sois honnête sur le gate** : ne déclare jamais une PR saine sur un gate
  rouge.
