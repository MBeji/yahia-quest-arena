# Audit UX/UI des écrans — yahia-quest-arena (Na9ra Nal3ab)

> Audit en **lecture seule** des ~18 écrans de l'application : cohérence, contenu,
> affichage, lucidité (expérience utilisateur), navigation et parcours utilisateur.
> Daté du 2026-06-13. Aucune correction de code n'a été appliquée — ce document est
> un constat priorisé servant de backlog.

**Légende sévérité :** 🔴 critique · 🟠 majeur · 🟡 mineur · 🟢 point fort / nit

---

## 1. Synthèse exécutive

L'application est **solide sur le fond** : architecture i18n propre (parité des clés
FR/EN/AR quasi parfaite, RTL résolu en SSR sans FOUC), états de chargement/erreur/vide
souvent couverts, a11y exemplaire sur l'écran QCM (radiogroup, raccourcis clavier,
indicateurs non-colorés), et un écran de résultat de quête riche (review, `noXpReason`,
level-up). Les points forts sont listés au §7.

Les problèmes se concentrent sur **trois fils rouges transversaux** qui touchent presque
tous les écrans, et sur **deux ruptures du parcours pédagogique central**.

### Les 5 problèmes structurants

1. ✅ ~~**Deux fils de navigation parallèles et incohérents**~~ — **résolu (F1)** : le
   zigzag chapitre `/parcours/$subjectId` (`SubjectPath`/`buildChapterNodes`) a été supprimé.
   La carte de monde `/parcours` route désormais tous ses nœuds vers l'unique écran chapitre
   `/subject/$subjectId` (celui au quiz-gate riche). Un seul fil, une seule logique de lock.

2. 🔴 **La leçon ne mène jamais au quiz ni aux exercices.** Le modèle pédagogique est
   `cours → quiz de compréhension → exercices`, mais l'écran `lesson.$chapterId` n'a
   **aucun CTA « Passer le quiz » / « Commencer les exercices »**. L'élève doit deviner
   qu'il faut remonter au breadcrumb. La transition la plus importante du produit n'existe
   pas dans l'UI.

3. 🔴 **i18n incomplète par chaînes codées en dur.** La _structure_ i18n est bonne, mais de
   nombreux littéraux sont écrits en dur (souvent en anglais, parfois en français) dans les
   composants — cassés pour les deux autres langues. Le pire foyer : tout le bloc « Donjon
   verrouillé » en français brut. Voir §3.

4. 🔴 **Navigation mobile/tablette défaillante.** La barre de nav masque tous les libellés
   sous 1024px (`hidden lg:inline`) → rangée d'icônes muettes **sans `aria-label`** sur les
   liens, dans un scroll horizontal à scrollbar cachée. Cœur de cible = enfants. Échec
   WCAG 2.4.4 / 4.1.2. Le hook `use-mobile` existe mais n'est pas branché sur la shell.

5. ⚠️ **`name_fr` affiché quelle que soit la langue.** ~~Régression i18n~~ — **requalifié
   après enquête (F3)** : le pipeline de contenu ne remplit **que** `name_fr` (les colonnes
   `name_en`/`name_ar` restent NULL), et y stocke le nom dans la langue du contenu du sujet.
   `name_fr` est donc le **nom canonique**, déjà dans la bonne langue pour la plupart des
   sujets. Le vrai problème est que **certains** sujets AR/EN ont un nom français saisi dans
   `name_fr` (ex. un sujet arabe nommé « Mathématiques »). **Ce n'est pas corrigeable en pur
   code** — il faut peupler `name_en`/`name_ar` (ou corriger les `nameFr`) dans `content/` +
   étendre l'INSERT du pipeline. Tâche de **données**, hors d'un correctif code. Non traité.

---

## 2. Fils rouges transversaux

### 🔴 F1 — Deux écrans pour une même matière

`subject.$subjectId.tsx` (liste classique) et `parcours.$subjectId.tsx` (carte d'aventure)
affichent les **mêmes chapitres** avec :

- des **logiques de lock divergentes** — carte : un chapitre se déverrouille au quiz du
  précédent (`journey.ts:120-153`) ; liste : aucun lock inter-chapitres
  (`subject.$subjectId.tsx:115-116`).
- des **destinations différentes** pour des cartes visuellement identiques —
  `journey-map.tsx:53` (node premium) → `/subject/$subjectId`, `journey-map.tsx:57` (node
  normal) → `/parcours/$subjectId`.

**Recommandation :** choisir **un seul** fil chapitre. Soit fusionner, soit faire de la
carte une simple vue alternative qui **partage la même logique de lock** que `journey.ts`.

### 🔴 F2 — Chaînes codées en dur (i18n cassée hors FR/EN)

> ✅ **Largement traité.** Externalisés en clés i18n FR/EN/AR : bloc verrou du donjon ;
> écran matière (Heroes Hall, Attribut, Boss, Difficulté, Pas de quêtes) ; écran quête
> (score, temps serveur, Question N, potions, en-tête) ; dashboard (toast noQuestTarget,
> Niveau, aria XP) ; chips héros (Niveau, Coins) ; boutique (itemType/rarity mappés avec
> fallback, Coins) ; auth (préfixe Google) ; landing (toggle reduce-motion, alt du héros).
> _Restent_ : quelques `min-h`/contrastes et le formatage de dates admin (cf. P2).

La parité des clés est bonne (447 FR / 445 EN / 445 AR), donc tout ce qui suit est du
littéral à externaliser :

| Écran                | Localisation                                                | Exemple                                                                      |
| -------------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Donjon (bloc verrou) | `dungeon.tsx:293-318, 331`                                  | tout le bloc « Donjon verrouillé » en FR brut                                |
| Dashboard            | `dashboard.tsx:325-327`                                     | `toast.info("No quest target available yet…")`                               |
| Subject              | `subject.$subjectId.tsx:91,100,257,268,326`                 | « Heroes Hall », « Attribute », « Boss », « Difficulty », « No quests yet. » |
| Quest                | `quest.$exerciseId.tsx:445,449,480-481,536,680`             | résultats EN + « Potion XP ×N appliquée ! » FR                               |
| Hero header          | `hero-stat-chips.tsx:36,53,61`, `dashboard.tsx:363,372,513` | « Lvl », « XP », « Coins », « Level », « XP Progress »                       |
| Boutique             | `dashboard-badges-shop.tsx:75,101,133,138`                  | `itemType`/`rarity` bruts, « Coins »                                         |
| Auth                 | `auth.tsx:75`                                               | préfixe « Google : » concaténé                                               |
| Landing              | `index.tsx:151-153,262`                                     | toggle reduce-motion FR, `alt` image EN                                      |
| Onboarding/Shell     | `onboarding.tsx`, `_authenticated.tsx:88-90`                | « Loading… » non i18n                                                        |

### 🟠 F3 — `name_fr` au lieu du nom localisé

Récurrent : `dashboard.tsx:513`, `onboarding.tsx:155,167,296`, `leaderboard.tsx:87,111,118`,
`dungeon.tsx:505`, `subject.$subjectId.tsx:103`, `lesson.$chapterId.tsx:222`,
`parcours.$subjectId.tsx:42`, `subject-path-card.tsx:84`, `parcours-hub.tsx:88`.
En arabe (RTL) un nom français apparaît au milieu d'une UI arabe.

### 🟠 F4 — Détection RTL incohérente (3 mécanismes)

- `quest.$exerciseId.tsx:181` → `color_token === "arabic"`
- `dungeon.tsx:526-531` → `color_token === "math" || "arabic"` (« math » forcé RTL est
  douteux : notation standard LTR)
- `subject.$subjectId.tsx:69` / `lesson.$chapterId.tsx:62` → `content_language === "ar"`

Un subject arabe dont le `color_token` diffère sera LTR dans la quête mais RTL ailleurs.
**Recommandation :** s'appuyer partout sur `content_language`.

### 🟠 F5 — Identité de marque incohérente

Logo `Crown` sur le landing (`index.tsx:160`) vs `Sparkles` sur l'auth (`auth.tsx:251`) et
la shell (`_authenticated.tsx:111`). Uniformiser.

---

## 3. Audit par écran

### 3.1 Landing publique — `index.tsx`

- 🟠 Pas de nav mobile : ancres `#features/#subjects/#ranks` en `hidden md:flex`, aucune
  alternative sous `md`.
- 🟠 Contrastes à valider : `text-muted-foreground` / `text-champagne/70` sur fond noir
  (risque < 4.5:1 WCAG AA).
- 🟡 Chiffres « preuve sociale » en dur (`5`, `200+`, streak `27`) — risque de promesse
  fausse à mesure que le catalogue grandit.
- 🟡 Aucun lien légal (CGU/confidentialité) en pied de page — produit payant ciblant des
  mineurs.
- 🟢 Hiérarchie claire ; toggle reduce-motion avec `aria-pressed`.

### 3.2 Auth (login/signup) — `auth.tsx`

- 🟠 **Couleur d'erreur = doré** (couleur de marque/succès), `auth.tsx:405,415` → signal
  d'échec affaibli. Utiliser une teinte destructive.
- 🟠 Formulaire **placeholder-as-label** : tous les `<Label>` sont `sr-only`, plus de label
  visible dès qu'on tape.
- 🟠 Redirection dure vers `/dashboard` si connecté (`:85,88`) → re-redirigé aussitôt vers
  `/onboarding` par le guard → **double flash**.
- 🟠 **Pas de lien « Mot de passe oublié »** → deadend pour un utilisateur ayant oublié son
  mot de passe.
- 🟡 Pas de hint « 8 caractères min » avant erreur ; bouton Google sans `aria-busy`.
- 🟢 Live region `role="alert"`, mapping `friendlyAuthError`, écran `emailSent` clair,
  gestion robuste du callback OAuth.
- 🟢 `login.tsx`/`signup.tsx` = purs redirects côté serveur (sains) ; juste différencier le
  `<title>` login vs signup.

### 3.3 Onboarding — `onboarding.tsx`

- 🔴 Nom de parcours **exclusivement `name_fr`** (`:155,167,296`), y compris en `aria-label`
  — régression i18n sur un écran trilingue.
- 🟠 Écart consigne↔code : **pas d'étape grade ni hero class** (2 étapes : intent →
  parcours). Le grade est implicite, la classe dérive du niveau. À clarifier produit (un
  utilisateur RPG s'attend souvent à choisir sa classe).
- 🟠 Parcours `coming_soon` **sélectionnable** : le filtre concours (`:206`) ne vérifie pas
  `status === "available"` et la carte n'est désactivée que sur `isComingSoon`.
- 🟠 **Risque de boucle de redirection** : si aucun parcours n'est disponible, l'élève ne
  peut pas finir l'onboarding et le guard `_authenticated.tsx:78-83` le renvoie en boucle.
- 🟠 Indicateur d'étapes non sémantique (`<motion.div>` sans `role="progressbar"`) ; pas de
  `<h1>`.
- 🟡 RTL : animations `x: 20 / x: -20` et chevrons non inversés en arabe.

### 3.4 Shell authentifié + navigation — `_authenticated.tsx`

- 🔴 Libellés masqués sous `lg` → icônes muettes sans `aria-label` sur mobile/tablette
  (`:117-179`). Pas de nav mobile dédiée (`use-mobile` non branché).
- 🟠 **Lien « Admin » pointe vers `/parent-report`** (`:146-149`) — trompeur ; doublon
  parent/admin vers la même URL avec deux libellés.
- 🟠 Incohérence libellé/route/icône « Parcours » (EN = « Adventure ») vs « Explorer »
  (`/themes`) ; le `ParcoursHub` est monté par `themes.tsx`, pas `parcours.tsx`.
- 🟠 Le logo pointe `/dashboard` pour tous, mais admin/parent y sont redirigés vers
  `/parent-report` → aller-retour inutile.
- 🟡 « Loading… » en dur (`:88-90`) ; badges compteurs sans `aria-label` ; aucun indicateur
  de parcours actif dans la barre.

### 3.5 Dashboard — `dashboard.tsx`

- 🔴 Toast « No quest target available yet… » en anglais brut (`:325-327`, TODO connu).
- 🟠 `DailyXpWidget` : `dailyGoal={100}` **hardcodé** et `xpToday` = somme des objectifs
  cochés (pas l'XP réel du jour) → la barre ne reflète pas la progression réelle
  (`:430-436`).
- 🟠 Libellés en dur « Attribute/quest/Lvl/Level/XP/Coins » (cf. F2) + `name_fr` (cf. F3).
- 🟡 Import mort `LanguageSwitcher` (`:42`). `xpPct` et `pct` peuvent diviser par zéro
  (cas limite). Skeletons sans `aria-busy`/`role="status"`. `clipboard.writeText` sans
  try/catch ni feedback d'échec.
- 🟢 Barre XP `role="progressbar"` complète ; lazy-load des sections ; états vides présents.

### 3.6 Explorer / hub parcours — `themes.tsx`

- 🟠 Triple vocabulaire pour un même écran : URL `/themes`, onglet « Explorer », titre
  « Choisis ton parcours ». Le modèle `themes → grades → subjects` n'apparaît jamais.
- 🟠 Le clic **switche le parcours actif puis redirige sans confirmation ni toast** (`:43`)
  — l'élève ne comprend pas qu'il vient de changer toute la portée de l'app.
- 🟠 Carte **premium verrouillée reste cliquable** (`parcours-hub.tsx:71` ne désactive que
  `isComingSoon`) → bascule sur un parcours dont tout est verrouillé, sans paywall.
- 🟢 Seul écran avec un skeleton vraiment soigné.

### 3.7 Carte d'aventure — `parcours.tsx` / `parcours.$subjectId.tsx`

- 🔴 Doublon avec `/subject/$subjectId` (cf. F1).
- 🟠 **Aucun état d'erreur** (`parcours.tsx:27`, `parcours.$subjectId.tsx:28`) → blocage
  « Chargement… » infini si la requête échoue.
- 🟠 Sublabel « 0/4 · 120 XP » mais la carte mène au **cours** (`/lesson`), pas aux
  exercices qui rapportent ces XP → mapping label→destination trompeur.
- 🔴 Deadend : depuis la carte, aucun chemin vers les **exercices** d'un chapitre (il faut
  passer par `/subject`).
- 🟡 « Abonnement requis » = vocabulaire subscription **périmé** (le modèle est
  entitlement/parcours).

### 3.8 Détail matière — `subject.$subjectId.tsx`

- 🟠 Panachage FR/EN (cf. F2) + `name_fr` (cf. F3).
- 🟠 **Seuils de complétude divergents** : « completed » ≥ 40% (`:117`), étoiles 40/70/90
  (`:210`), gate XP serveur 60%. Un exercice « complété » peut n'avoir jamais rapporté
  d'XP.
- 🟠 Double verrou : si `locked` (quiz) ET `premiumLocked`, le premium est masqué derrière
  le cadenas quiz.
- 🟢 **Meilleur traitement du quiz-gate de l'app** : carte quiz « Obligatoire », exercices
  verrouillés avec cadenas + explication. États error/loading présents.

### 3.9 Leçon — `lesson.$chapterId.tsx`

- 🔴 **Aucun CTA vers le quiz/exercices** (cf. F2, point #2) — deadend pédagogique majeur
  (`:245-298`).
- ~~🟠 Ancres TOC mortes~~ — **infirmé après vérification** : `renderMarkdown`
  (`src/shared/lib/markdown.ts`) injecte bien `id="section-{i}"` sur chaque `<h2>` et
  DOMPurify autorise l'attribut `id` (`ALLOWED_ATTR`). Les ancres du sommaire fonctionnent.
- 🟡 `name_fr` dans le header (`:222`) ; dots de progression sans `aria-label`.
- 🟢 Meilleur loading de l'app ; état vide soigné ; gestion `content_language`/RTL propre ;
  riche navigation inter-chapitres.

### 3.10 Quête QCM — `quest.$exerciseId.tsx`

- 🟠 Panachage FR/EN (cf. F2) + RTL via `color_token` (cf. F4).
- 🟠 Barre de progression `idx/total` (`:177`) → 0% sur Q1, jamais pleine.
- 🟠 Bouton « Quête suivante » **disparaît silencieusement** si `siblingSubjectQuery`
  échoue (`:78-83`) → l'élève croit avoir fini la matière.
- 🟡 **Pas de feedback juste/faux en cours** (choix assumé) — défendable pour un quiz, mais
  appliqué aussi aux exercices de pratique : l'élève enchaîne sans savoir s'il se trompe.
- 🟢 a11y exemplaire (radiogroup, raccourcis clavier, indicateurs non-colorés) ; écran
  résultat riche (review, `noXpReason`, level-up, badges) ; `QuestResultActions` avec
  « Quête suivante » bien pensé.

### 3.11 Donjon — `dungeon.tsx`

- 🔴 Tout le bloc « Donjon verrouillé » en **français codé en dur** (`:293-318,331`).
- 🟠 RTL via `color_token` fragile (cf. F4) ; `name_fr` (cf. F3).
- 🟡 Trois libellés pour la même destination `/dashboard` (« Hall des héros » / « Retour au
  hall » / « Quitter le donjon »). Loader d'accès = « … » au lieu du spinner standard.
  Deadend possible si `loadBatch` renvoie 0 question → game over sans avoir joué.
- 🟢 Concept « 1 vie » très clair ; gate premium via `SubscriptionPaywall` ; a11y
  non-couleur (icône + sr-only).

### 3.12 Classement — `leaderboard.tsx`

- 🟠 `name_fr` sur onglets/sous-titre (cf. F3) — `isRtlText(s.name_fr)` ne passera jamais
  en RTL.
- 🟡 Lignes de classement en `<div>` plutôt que `<ul role="list">` ; streak en couleur sans
  texte alternatif.
- 🟢 Carte « mon rang » + chip « Toi » → repérage clair ; protection contre fuite d'UUID.

### 3.13 Rapport parent — `parent-report.tsx`

- 🔴 **Seul écran sans lien de retour** (`backToHall` absent) — deadend de navigation.
- 🟠 Bar chart d'activité non accessible (tooltip `title` HTML, pas focusable clavier).
- 🟡 Suffixe « j » (jours) en dur (`:253`) ; `title` du graphe en dur FR (`:326`) ;
  `min-h-screen` crée de grands vides verticaux.
- 🟢 Verdict très lisible (jauge circulaire, excellent→inactif) ; formulaire de liaison
  clair ; auto-sélection du premier élève.

### 3.14 Admin (abonnements / bêta / signalements)

- 🟠 Actions destructives **sans confirmation** (revoke/reject) —
  `parcours-entitlements-admin.tsx:214`, `beta-requests-admin.tsx:144`.
- 🟠 Titre d'exercice signalé **non cliquable** vers `/quest/$exerciseId`
  (`content-reports-admin.tsx:112`).
- 🟡 Dates via `toLocaleDateString()` **sans locale i18n** (3 composants) ; flash de page
  vide pendant `role === null` (beta-requests, content-reports) ; table entitlements en
  scroll horizontal `min-w-[760px]` sur mobile.
- 🟢 Garde-fous admin homogènes ; badges compteurs « en attente » dans nav et titres.

### 3.15 Boutique & inventaire (pas d'écran dédié)

- 🟠 **Aucun écran `/shop`** : tout vit dans le dashboard (`dashboard-badges-shop.tsx`,
  `dashboard-radar-inventory.tsx`). Pas de lien direct possible vers la boutique.
- 🟠 Inventaire **tronqué à 4 items** sans « voir tout » → items au-delà invisibles et
  inactivables (`dashboard-radar-inventory.tsx:95`).
- 🟠 Slots d'armement (next-quest vs passif, 1 seul à la fois) **sans aucune explication
  in-UI** ; `itemType`/`rarity`/« Coins » non traduits (cf. F2).
- 🟡 Pas d'état vide boutique ; bouton « Acheter » désactivé sans message « pas assez de
  pièces ».
- 🟢 Bons `aria-label` sur buy/equip/activate ; labels d'armement i18n.

### 3.16 Paywall premium — `subscription-paywall.tsx`

- 🟠 **Périmètre ambigu** : rendu dans le donjon, il laisse croire qu'on paie « juste » le
  donjon alors que c'est l'entitlement parcours concours. Préciser ce qui est débloqué.
- 🟡 Double lien retour quand rendu dans le donjon (`:39` vs `dungeon.tsx:238`) ; pas de
  prix affiché (modèle out-of-band assumé).
- 🟢 Explique le modèle (achat par parcours, téléphone admin) ; alternative bêta gratuite
  intégrée.

### 3.17 Signalement de contenu — `report-error-button.tsx`

- 🟡 Validation ≥ 5 caractères sans feedback sur le bouton désactivé ; textarea sans `dir`
  auto à la saisie.
- 🟢 CTA discret, confirmation « envoyé », i18n complet.

### 3.18 Shell racine — `__root.tsx`

- 🟠 `ErrorComponent` utilise `console.error` direct (`:45`) au lieu du logger structuré
  (convention projet).
- 🟡 Meta document figées en FR (`:80-94`) ; le lien retour 404 fait un full reload
  (`<a href="/">`) au lieu d'une navigation router.
- 🟢 Résolution SSR de `<html lang/dir>` (RTL sans FOUC, `:162`).

---

## 4. Carte de navigation & deadends

**Accessible depuis la barre de nav :** dashboard · parcours · themes · dungeon ·
leaderboard · parent-report (parent/admin) · admin/\* (admin).

**Contextuel (hors nav) :** subject · lesson · quest · onboarding · parcours/$subjectId.

| Problème                                                                  | Sévérité |
| ------------------------------------------------------------------------- | -------- |
| `parent-report` sans lien de retour                                       | 🔴       |
| Leçon → aucun lien vers quiz/exercices                                    | 🔴       |
| Carte d'aventure → aucun lien vers les exercices                          | 🔴       |
| Bouton « Quête suivante » disparaît si query frère échoue                 | 🟠       |
| Carte d'aventure bloquée sur « Chargement… » si erreur                    | 🟠       |
| Logo → `/dashboard` renvoie admin/parent en aller-retour                  | 🟠       |
| Pas de `/shop` linkable                                                   | 🟠       |
| Objectif « subject » sans sujet attribué → impasse silencieuse (toast EN) | 🟠       |

---

## 5. Accessibilité (transverse)

- 🔴 Liens de nav icon-only sans nom accessible (`_authenticated.tsx:117-179`).
- 🟠 Indicateur d'étapes onboarding non sémantique ; bar chart parent non focusable ;
  formulaire auth placeholder-only.
- 🟠 Contrastes `muted-foreground`/teintes translucides sur fond sombre à valider WCAG AA
  (landing, hero chips, badges nav).
- 🟡 Skeletons sans `aria-busy`/`role="status"` (dashboard, onboarding, admin) ; dots de
  progression leçon et badges compteurs sans `aria-label` ; `prefers-reduced-motion` non
  respecté sur les `motion.div` d'entrée (seul l'ambient 3D le respecte).
- 🟢 Excellents : QCM (radiogroup + raccourcis + sr-only), donjon (icône + sr-only), live
  region auth.

---

## 6. Backlog priorisé (recommandations actionnables)

### P0 — à traiter en premier (🔴)

1. ✅ **Unifier le fil chapitre** — _fait_ : `/parcours/$subjectId` supprimé, la carte
   `/parcours` pointe vers l'unique `/subject/$subjectId`. (F1)
2. ✅ **Ajouter un CTA « Passer le quiz / Commencer les exercices »** en bas de la leçon
   (vers la page matière qui porte le quiz-gate). _Traité._ (F2)
3. ✅ **Externaliser le bloc « Donjon verrouillé »** en clés i18n. _Traité_ (les autres
   littéraux du tableau F2 restent à faire).
4. ✅ **Nav** : `aria-label`+`title` sur chaque `<Link>` icône. _Traité._ (Une vraie nav
   mobile hamburger/bottom-bar reste à concevoir.)
5. ~~Corriger les ancres TOC~~ — **infirmé** : les ancres fonctionnent déjà (cf. §3.9).
6. ✅ **Ajouter un lien de retour** au rapport parent. _Traité._

### P1 — important (🟠)

7. ⚠️ ~~Résoudre `name_fr` → nom localisé~~ (F3) — **non corrigeable en code** : seul
   `name_fr` est peuplé (cf. §1.5). Nécessite un travail de **données** dans `content/`.
8. ✅ **Unifier la détection RTL sur `content_language`** (F4) — _quête : fait_
   (`getExercise` renvoie désormais `content_language`, RTL basé dessus). _Donjon : partiel_
   — le forçage erroné « math → RTL » retiré ; l'unification complète attend que la RPC
   `get_dungeon_questions` porte `content_language` (migration DB).
9. Corriger le lien/libellé « Admin » → `/parent-report` (`_authenticated.tsx:146-149`).
10. `DailyXpWidget` : XP réel du jour + `dailyGoal` issu de `gamification.ts`.
11. Unifier les seuils de complétude (40/60/étoiles) sur le gate XP 60%.
12. Désactiver/rediriger les cartes premium verrouillées de l'Explorer ; ajouter un toast
    de confirmation au switch de parcours.
13. Ajouter des états d'erreur à `parcours.tsx` / `parcours.$subjectId.tsx`.
14. Couleur d'erreur destructive (au lieu de doré) + lien « Mot de passe oublié » à l'auth.
15. Confirmation sur les actions destructives admin ; titre d'exercice signalé cliquable.
16. Barre de progression quête `(idx+1)/total` ; état pour « Quête suivante ».
17. Inventaire : « voir tout » + explication des slots d'armement.
18. Préciser le périmètre du paywall (missions concours + donjon) ; éviter le double retour.
19. Uniformiser le logo (Crown vs Sparkles).

### P2 — finitions (🟡)

20. i18n : « Loading… », « XP Progress », suffixe « j », « Coins », `itemType`/`rarity`,
    toggle reduce-motion, `alt` hero, « Google : », dates admin via locale i18n.
21. a11y : `aria-busy`/`role="status"` sur skeletons ; `aria-label` sur dots/badges ;
    `<ul role="list">` au classement ; respecter `prefers-reduced-motion`.
22. ✅ Supprimer l'import mort `LanguageSwitcher` (`dashboard.tsx:42`). _Déjà fait_ —
    `LanguageSwitcher` n'est plus importé que dans `public-header.tsx` et
    `_authenticated.tsx`, où il est réellement utilisé.
23. ✅ `console.error` → logger structuré (`__root.tsx`). _Traité_ — le boundary d'erreur
    racine utilise désormais `logger.error("Root error boundary caught an error", { error })`.
24. Liens légaux au footer du landing ; meta document par-locale.
25. Vocabulaire : « Abonnement requis » → entitlement/parcours.

---

## 7. Points forts à préserver

- Architecture i18n propre : parité des clés FR/EN/AR, RTL résolu en SSR sans FOUC.
- a11y exemplaire du QCM (radiogroup, raccourcis clavier 1-4/A-D, indicateurs non-colorés).
- Écran résultat de quête riche : review détaillée, `noXpReason`, level-up, badges.
- Traitement du quiz-gate dans `subject.$subjectId.tsx` (le meilleur de l'app).
- `QuestResultActions` + `computeNextExerciseId` (fin d'exercice bien pensée).
- Verdict du rapport parent très lisible ; carte « mon rang » + chip « Toi » au classement.
- Garde-fous admin homogènes ; badges compteurs dans nav et titres.
- Skeletons soignés de l'Explorer ; meilleur loading sur la leçon.
- Protection contre la fuite d'UUID au classement.

---

_Méthode : lecture intégrale des fichiers de routes (`src/routes/**`) et composants de
features associés, plus vérification de la parité i18n et de la carte des liens internes.
Audit en lecture seule — aucun code modifié._
