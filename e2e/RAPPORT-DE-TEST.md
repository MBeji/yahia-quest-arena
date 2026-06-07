# Rapport de test E2E — XP Scholars

> Plan de non-régression / bug-bounty couvrant les fonctionnalités majeures :
> affichage & responsive, parcours pédagogiques, gamification, programmes hors-école,
> i18n/RTL et autorisations. Format : **Scénario → Étapes → Résultat (passe / ne passe pas)**.

## Méthode & légende

- **Approche** : DOM + accessibilité (axe-core), **sans captures pixel**. Sélecteurs stables
  (rôle / texte / href) + `data-testid` uniquement là où aucun point d'ancrage n'existe.
- **Deux tiers** :
  - **Public** (`e2e/public/`) — aucune dépendance backend. **Exécuté localement** → résultats réels ci-dessous.
  - **Authentifié** (`e2e/authed/`) — nécessite le **projet Supabase TEST** + 4 comptes seedés
    (free / premium / parent / admin). **Non exécutable sur ce poste** (le `.env` local pointe un
    vrai projet) → **exécuté en CI** (`e2e-auth.yml`). Les scénarios sont écrits, typés et lintés ;
    leur exécution dépend des pré-requis CI (voir §7).
- **Légende résultat** :
  - ✅ **PASS** — exécuté et vert (local).
  - ⏳ **PRÊT (CI)** — automatisé, validé statiquement (typecheck + lint + listing), à exécuter en CI.
  - ⚠️ **OBSERVATION** — comportement à confirmer / point d'attention (voir §6).

**État des portes (ce poste, 2026-06-07)** : `npm run verify` → **552 tests** ✅ · e2e `tsc` ✅ ·
e2e ESLint ✅ · `playwright --list` → **56 tests / 19 fichiers** · tier public **26/26 ✅**.

---

## 1. Affichage, responsive & changement de langue

### 1.1 Rendu responsive de la landing (mobile / tablette / desktop)

- **Étapes** : charger `/` à 375 px, 768 px, 1280 px ; vérifier la marque, les CTA _Sign in_ /
  _Join_ visibles ; vérifier l'absence de débordement horizontal (`scrollWidth − clientWidth ≤ 3`).
- **Spec** : `public/responsive.spec.ts` (3 tailles × 2 projets).
- **Résultat** : ✅ **PASS** (6/6, desktop + mobile).

### 1.2 Changement de langue dynamique + RTL (public)

- **Étapes** : sur `/`, basculer EN → FR → AR → EN via le sélecteur ; après chaque bascule
  vérifier `<html lang>`, `<html dir>` (AR ⇒ `rtl`) et que le CTA d'inscription est traduit
  (_Join_ / _Rejoindre_ / `انضم`) — **sans rechargement**.
- **Spec** : `public/i18n-switch.spec.ts`.
- **Résultat** : ✅ **PASS** (desktop + mobile).

### 1.3 Changement de langue + RTL dans l'app (authentifié)

- **Étapes** : sur `/dashboard`, basculer en arabe → `<html dir="rtl">`, `lang="ar"`, le catalogue
  reste rendu (session intacte) ; rebasculer en anglais → `dir="ltr"`.
- **Spec** : `authed/i18n-rtl.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 1.4 Accessibilité des pages publiques

- **Étapes** : axe-core sur landing / login / signup ; échec si violation _serious/critical_ WCAG2 A/AA.
- **Spec** : `public/a11y.spec.ts`.
- **Résultat** : ✅ **PASS** (desktop + mobile).

---

## 2. Parcours utilisateurs — contenu pédagogique & accès premium

### 2.1 Navigation catalogue (dashboard → matière → mission)

- **Étapes** : ouvrir `/dashboard` ; cliquer la 1ʳᵉ carte matière ; vérifier l'URL `/subject/…`
  et la présence d'au moins une mission (`a[href^="/quest/"]`).
- **Spec** : `authed/catalogue.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 2.2 Verrou « niveau supérieur » premium — élève gratuit bloqué

- **Étapes** : récupérer une mission **difficulté ≥ 3** dans une matière **gratuite & hors-école**
  (donc seul le verrou premium s'applique, pas le quiz) ; sur la page matière, vérifier le label
  _Abonnement requis_ (FR/EN/AR) ; ouvrir la mission → **paywall** affiché.
- **Spec** : `authed/premium-gate.spec.ts` (describe « free »).
- **Résultat** : ⏳ **PRÊT (CI)**. Voir ⚠️ §6.1 (le seuil difficulté ≥ 3 est **global**, pas limité à la 9ème).

### 2.3 Déverrouillage premium — abonné

- **Étapes** : le **compte premium** ouvre la **même** mission difficulté ≥ 3 → pas de paywall,
  le QCM s'affiche (≥ 2 options).
- **Spec** : `authed/premium-gate.spec.ts` (describe « premium »).
- **Résultat** : ⏳ **PRÊT (CI)**.

### 2.4 Module entièrement premium (matière payante) — élève gratuit

- **Étapes** : ouvrir une matière `is_premium` → paywall d'abonnement + CTA bêta rendus en page.
- **Spec** : `authed/free-user.spec.ts` (existant).
- **Résultat** : ⏳ **PRÊT (CI)**.

### 2.5 Verrou quiz de compréhension — **programme scolaire uniquement**

- **Étapes** : matière **scolaire** (free) → au moins une mission verrouillée tant que le quiz
  n'est pas réussi ; matière **hors-école** → **aucune** mission verrouillée.
- **Spec** : `authed/quiz-gate.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 2.6 Boucle de jeu complète (QCM → score → revue)

- **Étapes** : ouvrir une mission gratuite hors-école ; répondre à toutes les questions ;
  atteindre l'écran de score (%) + une carte de revue par question.
- **Spec** : `authed/gameplay-loop.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

---

## 3. Gamification

### 3.1 Affichage des compteurs (niveau / XP / coins)

- **Étapes** : `/dashboard` → les puces _Lvl_, _XP_, _Coins_ sont visibles (`data-testid` dédiés).
- **Spec** : `authed/progression-stats.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 3.2 Gain d'XP après un exercice réussi

- **Étapes** : lire l'XP du profil (admin DB) ; jouer un exercice **culture-générale** en répondant
  **correctement** (options appariées par **texte**, car le QCM les mélange) et au **rythme anti-triche**
  (≥ 4 s/question) ; vérifier le score (%) puis **XP_après > XP_avant**.
- **Spec** : `authed/progression-stats.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 3.3 Dépense de coins via un achat boutique

- **Étapes** : fixer le solde à 99 999 (admin DB) ; `/dashboard` → la puce coins affiche 99 999 ;
  acheter le 1ᵉʳ article → **coins diminués** + un badge _In stock / Owned / Equipped_ apparaît.
- **Spec** : `authed/shop.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 3.4 Utilisation d'un consommable acheté (armement)

- **Étapes** : acheter chaque article ; si un consommable armable existe → cliquer _Activer_ →
  badge _Actif · …_ ; sinon, confirmer au moins la possession d'articles.
- **Spec** : `authed/shop.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

### 3.5 Tableau de classement (ranking)

- **Étapes** : `/leaderboard` → titre + onglet _Global_ visibles ; soit des lignes de classement,
  soit l'état vide explicite ; bascule vers un classement par matière puis retour _Global_.
- **Spec** : `authed/leaderboard.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

---

## 4. Programmes hors-école — 4 familles & jeu sans cours obligatoire

### 4.1 Les 4 familles sont présentes au catalogue

- **Étapes** : lister les thèmes ayant au moins une matière ; vérifier la présence de
  `ecole-tn` (programme scolaire), `culture-generale`, `muscle-cerveau` (QI), `francais` (langue).
- **Spec** : `authed/four-families.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**. Voir ⚠️ §6.4 (seul le track **français** a du contenu ; il est premium).

### 4.2 Une famille hors-école est jouable sans validation théorique

- **Étapes** : ouvrir une matière `culture-generale` → missions directement disponibles **et**
  **aucune** mission verrouillée par un quiz.
- **Spec** : `authed/four-families.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**.

---

## 5. Autorisations (sécurité d'usage)

### 5.1 Un élève ne peut pas atteindre l'espace admin

- **Étapes** : `/admin/subscriptions` en élève → message _Administrators only / Accès réservé_ ;
  le lien admin est **absent** du dashboard.
- **Spec** : `authed/authorization.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**. Voir ⚠️ §6.2 et §6.3.

### 5.2 parent-report n'expose pas les données d'un autre élève

- **Étapes** : un élève ouvre `/parent-report` → état de liaison « Alliance Code » (aucune donnée tierce).
- **Spec** : `authed/authorization.spec.ts`.
- **Résultat** : ⏳ **PRÊT (CI)**. Voir ⚠️ §6.3.

### 5.3 Accès admin / parent autorisés (chemin positif)

- **Étapes** : admin ouvre les pages admin ; parent ouvre le rapport parent.
- **Spec** : `authed/admin-and-parent.spec.ts` (existant).
- **Résultat** : ⏳ **PRÊT (CI)**.

---

## 6. Observations pour la campagne bug-bounty

> Constats relevés en lisant le code pendant l'écriture des tests — à confirmer / corriger.

1. **⚠️ Le verrou premium « difficulté ≥ 3 » est GLOBAL, pas spécifique à la 9ème.**
   `PREMIUM_MIN_DIFFICULTY = 3` s'applique à **tous** les thèmes (y compris culture-générale et QI),
   alors que l'intention exprimée est « seul le niveau supérieur du programme 9ème est premium ».
   → Décider : verrou par difficulté global (comportement actuel) **ou** réservé au scolaire ?

2. **⚠️ Fenêtre de garde admin pendant le chargement du rôle.** La garde
   `if (role !== null && role !== "admin")` ne bloque pas tant que `role` vaut `null` (chargement).
   Aucune **donnée** admin ne fuit (les requêtes sont conditionnées à `role === "admin"`), mais le
   _chrome_ de la page admin peut s'afficher brièvement. → Envisager un état de chargement explicite.

3. **ℹ️ `/parent-report` : exposition cosmétique uniquement (pas de faille).** Un élève peut ouvrir
   la page et voir le formulaire de liaison « Alliance Code », **mais le serveur est correctement
   gardé** : `getLinkedStudents` lève « Access denied: parent or admin account required » pour un
   `student`, les INSERT dans `parent_student_links` sont **révoqués au niveau DB** (RPC dédiée) et
   l'appel est **rate-limité**. Aucune donnée tierce n'est exposée. → Améliorer le confort : ajouter
   une garde de rôle côté route pour ne pas afficher l'UI parent à un élève (priorité basse).

4. **⚠️ Track « langue » incomplet.** Seul le thème `francais` a du contenu (`fr-mastery`), et il est
   **premium** → un élève gratuit n'a accès à **aucun** contenu de programme de langue. Les thèmes
   `anglais` / `arabe` sont seedés mais **vides**. → « Programme de langue (3 langues) » non couvert.

5. **ℹ️ Industrialisation des sélecteurs.** Ajout de `data-testid` ciblés : `stat-level/-xp/-coins`,
   `leaderboard-row`, `leaderboard-global-tab`, `shop` + `shop-item[data-item-code][data-owned]`.
   (Boutons boutique déjà accessibles via `aria-label`.)

---

## 7. Pré-requis pour exécuter le tier authentifié (CI)

1. **Projet Supabase TEST** (`pqegdnwdtbjtplcthxyp`) avec **schéma + contenu appliqués** :
   migrations de base **et** les lots culture-générale + iq-training (sinon `subjectIdByTheme`,
   `premiumDifficultyExercise`, `four-families` échouent par absence de données).
2. **Comptes seedés** : `npm run e2e:seed` (free / premium / parent / admin).
3. **Secrets CI** : `TEST_SUPABASE_URL`, `TEST_SUPABASE_ANON_KEY`, `TEST_SUPABASE_SERVICE_ROLE_KEY`,
   `E2E_USER_PASSWORD` (sinon `e2e-auth.yml` est _skipped_ en vert).
4. **Reset** : la CI lance un reset-gameplay avant la passe (les specs free supposent « aucun quiz
   réussi » au départ ; les specs mutant le profil — XP, coins — supposent un état réinitialisé).

> Tant que ces pré-requis ne sont pas réunis, le tier authentifié reste **PRÊT (CI)** : code écrit,
> typé, linté et listé par Playwright, mais sans verdict d'exécution.
