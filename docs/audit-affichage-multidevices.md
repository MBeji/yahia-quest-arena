# Audit d'affichage multi-écrans / multi-devices — yahia-quest-arena

> Audit **responsive / affichage** ciblé sur le rendu de l'application à travers les
> tailles d'écran et les devices : petit Android, iPhone (SE → Pro Max avec encoche),
> iPad portrait/paysage, laptop, desktop. Daté du **2026-06-30**.
>
> Complémentaire de [`audit-ecrans-ux.md`](./audit-ecrans-ux.md) (qui couvre la navigation,
> l'i18n et l'UX de fond) : ce document se concentre **uniquement** sur l'affichage —
> débordements, points de rupture (breakpoints), cibles tactiles, typographie, RTL aux
> petites largeurs, encoche/safe-area, et unités de viewport.
>
> **Méthode :** fan-out de 18 agents d'audit (un par groupe d'écrans) lisant l'intégralité
> des routes et composants de présentation, puis vérification adversariale de chaque
> constat critique/majeur (42 vérifiés → 17 confirmés, 21 rétrogradés, 4 rejetés). Les
> correctifs de la §6 ont été appliqués sur la branche `claude/multi-device-display-audit`.

**Légende sévérité :** 🔴 critique · 🟠 majeur · 🟡 mineur · 🟢 point fort

**Devices / largeurs CSS de référence :**

| Device               | Largeur | Note                       |
| -------------------- | ------- | -------------------------- |
| Petit Android        | 360 px  | Le plus étroit réaliste    |
| iPhone SE            | 375 px  | —                          |
| iPhone 14/15 Pro Max | 430 px  | Encoche + safe-area insets |
| iPad Mini (portrait) | 768 px  | Bascule `md`               |
| iPad Pro (paysage)   | 1194 px | —                          |
| Laptop               | 1366 px | —                          |
| Desktop              | 1920 px | —                          |

Breakpoints Tailwind 4 (défauts, pas de `tailwind.config`) : `sm` 640 · `md` 768 · `lg`
1024 · `xl` 1280 · `2xl` 1536.

---

## 1. Synthèse exécutive

**L'application est globalement bien construite en mobile-first.** Les fondations responsive
sont saines et récurrentes sur presque tous les écrans :

- conteneurs centrés `mx-auto max-w-* px-4 sm:px-6` ;
- grilles mobile-first qui s'effondrent en une colonne sous `sm` (`grid gap-4 sm:grid-cols-2`) ;
- typographie plafonnée par variantes responsives (`text-3xl sm:text-4xl`, jamais de `text-5xl+`
  non bridé) ;
- shell authentifié avec **bottom-nav mobile** (`lg:hidden`, `min-h-[52px]`), **safe-area**
  (`pt-[env(safe-area-inset-top)]`, `pb-[calc(4.5rem+env(safe-area-inset-bottom))]`) et `viewport-fit=cover` ;
- RTL traité avec des propriétés logiques (`end-0`, `text-start`, `border-inline-start`) et le
  miroir d'icônes (`rtl:-scale-x-100`) ;
- canvas 3D décoratif coupé sur mobile (`useIsMobile` 768px) et `prefers-reduced-motion` respecté.

Les défauts ne sont **pas des cassures massives** mais des **dégradations** concentrées sur
quelques fils rouges transversaux et les primitives partagées (qui se propagent à tout l'app).

### Les 5 problèmes structurants

1. 🟠 **Cibles tactiles sous 44×44 px — systémique.** Le constat le plus fréquent (≈ 18
   occurrences). Tous les contrôles compacts du **header** (switchers langue/thème, déconnexion,
   liens admin icon-only), les **onglets** du classement, les **boutons d'action** des tables
   admin, les pills d'intérêt, le bouton « Activer » de l'inventaire, le bouton **fermer** des
   modales (~16 px !) et les tokens de taille du **primitive `Button`** (`sm` 32px, `icon` 36px)
   tombent sous le minimum tactile recommandé pour un public d'enfants/ados sur téléphone.

2. 🟠 **Débordement du contenu de leçon (markdown).** Les `.lesson-table` et `.lesson-math`
   générés sont en `width:100%` / `display:block` **sans conteneur à scroll horizontal**, et
   `.lesson-content` n'a pas d'`overflow-wrap`. Un tableau large, une équation longue ou une
   chaîne insécable (URL, identifiant) déborde le viewport à 360 px. Aggravé en arabe (RTL)
   où les tableaux sont forcés en `direction:ltr`.

3. 🟠 **Grilles `grid-cols-4` figées.** Le récap de récompenses de quête (`quest-reward-grid`)
   et les stats de game-over du donjon utilisent `grid-cols-4` **sans variante responsive** :
   4 cellules avec `p-4` + `text-2xl` sont écrasées dans ~312 px sur un petit téléphone, ce qui
   coupe les grandes valeurs d'XP/coins.

4. 🟠 **Nav publique invisible sur téléphone.** Dans le `public-header`, les liens catalogue
   (Programme / Extras) et le lien Connexion sont `hidden ... sm:flex` **sans remplacement
   mobile** (pas de menu/hamburger). Un visiteur sur téléphone (360–430 px) perd ces points
   d'entrée du header.

5. 🟡 **`min-h-screen` (100vh) au lieu de `dvh`.** Auth, onboarding, écrans de préparation
   quête/donjon et lightbox manuel utilisent `100vh`/`vh`, qui réserve la place de la barre
   d'adresse mobile et provoque le saut/clipping classique. Tailwind 4 supporte `dvh`.

À cela s'ajoute un **vrai bug d'affichage** : le hero du dashboard utilise une valeur arbitraire
Tailwind invalide `sm:grid-cols-[auto,1fr,auto]` (virgules au lieu de underscores) → la grille
3 colonnes prévue **ne s'applique jamais** (cf. §3.5).

---

## 2. Problèmes systémiques (multiplicateurs)

Ces points vivent dans des **primitives partagées** : un seul correctif corrige des dizaines
d'écrans.

### 🟠 S1 — Cibles tactiles < 44 px

| Contrôle                              | Fichier                                                  | Taille actuelle |
| ------------------------------------- | -------------------------------------------------------- | --------------- |
| Switcher thème (trigger)              | `components/ui/theme-switcher.tsx:42`                    | ~30×26 px       |
| Switcher langue (trigger)             | `components/ui/language-switcher.tsx:33`                 | ~28 px          |
| Bouton fermer de modale               | `components/ui/dialog.tsx:47`                            | ~16×16 px       |
| Tokens `Button` `sm`/`icon`           | `components/ui/button.tsx:20`                            | 32 / 36 px      |
| Déconnexion + liens admin (mobile)    | `routes/_authenticated.tsx:166,237`                      | ~28 px          |
| Onglets classement                    | `routes/_authenticated/leaderboard.tsx:96,112`           | ~32 px          |
| Boutons d'action tables admin (×6)    | `*-admin.tsx`                                            | ~28–32 px       |
| Pill « Ça m'intéresse »               | `dashboard/components/parcours-interest-button.tsx:35`   | ~26 px          |
| Bouton « Activer » inventaire         | `dashboard/components/dashboard-radar-inventory.tsx:204` | ~26 px          |
| Boutons auth (submit / Google / rôle) | `routes/auth.tsx:276,314,424`                            | ~36–40 px       |
| Bouton « Retour » onboarding          | `routes/_authenticated/onboarding.tsx:321`               | 36 px           |

**Reco :** relever ces contrôles au plancher 44 px (`min-h-11` / `py` augmenté), en priorité
sur les primitives partagées (switchers, `Dialog` close, `Button`) dont le bénéfice est global.

### 🟠 S2 — Contenu de leçon (markdown) non contenu

`styles.css` : `.lesson-table` (698), `.lesson-math` (712) et `.lesson-content` (631) débordent
horizontalement. **Reco :** envelopper/forcer le scroll horizontal (`display:block; overflow-x:auto`
sur les tableaux et `.lesson-math`) et ajouter `overflow-wrap:anywhere` + `pre { overflow-x:auto }`
à `.lesson-content`, en couvrant aussi les variantes `[dir=rtl]`.

### 🟡 S3 — Modales sans plafond de hauteur

`components/ui/dialog.tsx:41` : `DialogContent` est centré (`top-[50%]` + `translate-y-[-50%]`)
**sans `max-height` ni scroll interne** → contenu haut tronqué en paysage / iPhone SE. La `Sheet`
top/bottom a le même défaut. **Reco :** `max-h-[calc(100dvh-2rem)] overflow-y-auto` sur la base.

### 🟡 S4 — `100vh` au lieu de `dvh`

`auth.tsx:212,249`, `onboarding.tsx`, écrans `confetti`/préparation de quête, `min-h-[60vh]`
donjon, image `max-h-[78vh]` du lightbox manuel. **Reco :** basculer sur `dvh`.

### 🟡 S5 — Nav publique mobile absente

`components/public/public-header.tsx:36` : la `<nav>` Programme/Extras est `hidden ... sm:flex`.
**Reco :** rendre ces liens visibles sur téléphone (rangée compacte qui _wrap_, ou menu).

---

## 3. Audit par écran

<!-- Les résumés ci-dessous proviennent des agents d'audit (verdict responsive par groupe,
     points forts inclus). Traduits/condensés. -->

### 3.1 Landing publique + header/footer

Page très solide : sections `max-w-5xl px-4 sm:px-6`, grilles `sm:grid-cols-3/2`, titres bridés
(`text-4xl sm:text-5xl`), CTA en `flex-wrap`, canvas 3D coupé sur mobile avec fallback image.
Faiblesses : header (S1 switchers, S5 nav mobile), pas de safe-area sur le header/footer collants.

### 3.2 Routes catalogue publiques

Base responsive très correcte (conteneurs cohérents, grilles mobile-first, tuiles d'icônes 44px
`h-11 w-11`, RTL explicite, SVG `max-w-full`). Les défauts viennent du corps de leçon markdown
(S2) et de quelques petites cibles + nav header (S5).

### 3.3 Auth (login / signup)

Carte unique centrée `max-w-md`, typo bridée (`text-2xl` max), reflow propre jusqu'à 360 px,
zéro débordement. Défauts : S4 (`min-h-screen`), S1 (boutons submit/Google/rôle), pas de
safe-area (logo haut / lien bas sous l'encoche en paysage), padding lourd (`p-8`+`px-6` → ~248 px
utiles à 360).

### 3.4 Shell authentifié + nav

Bien construit : bottom-nav mobile (`min-h-[52px]`), safe-area haut/bas, split desktop/mobile
propre, propriétés logiques RTL. Défauts : S1 (cluster de droite, liens admin icon-only sous
`lg`), **AccountHud à XP non borné** dans un cluster `shrink-0` → débordement possible du header
à 360 px, S4 (`min-h-screen`).

### 3.5 Dashboard + hero

Mobile-first dans l'ensemble (hero `p-6 sm:p-8`, chips `flex-wrap`, grilles qui s'effondrent,
blocs desktop-only masqués). **Vrai bug :** `sm:grid-cols-[auto,1fr,auto]` (`dashboard.tsx:337`)
est une valeur arbitraire **invalide** (virgules) → la grille 3 colonnes du hero ne s'applique
jamais. Aussi : S1 (chips ExplainHint, bouton copier le code, pills), bannière de récupération de
série serrée à 360.

### 3.6 Boutique + inventaire + cartes catalogue

Grilles mobile-first systématiques, aucun width fixe, zéro débordement, RTL délibéré. Défauts :
S1 (boutons compacts), radar SVG `h-72` fixe, noms d'items `text-lg` non tronqués.

### 3.7 Carte d'aventure (parcours)

Voir §3.7bis (audit ciblé complémentaire — l'agent initial avait renvoyé un résultat dégénéré).

### 3.8 Themes / explorer

`themes.tsx` et `themes_.$familyId.tsx` sont des **stubs de redirection 301** vers `/programme`
(chantier L2.A). Aucun rendu → aucun défaut d'affichage possible ; l'explorer vit dans `/programme`.

### 3.9 Subject hub + quiz-gate

Bien géré : `SubjectHub` en `max-w-3xl`, titre tronqué + méta `shrink-0` (pas de débordement même
à 360), `QuizLockScreen` `max-w-md` avec boutons `flex-wrap`. Seuls nits : hauteurs tactiles des
liens inline.

### 3.10 Leçon

Article centré `max-w-3xl px-4 sm:px-6`, titre bridé, grille manuel qui s'effondre, toolbar
`flex-wrap`, nav chapitre tronquée, RTL soigné. Risques : corps markdown (S2), lightbox manuel en
`vh` (S4), quelques cibles < 44px.

### 3.11 Quête QCM + practice + résultat

Bien construit mobile (containers `max-w-2xl`, typo bridée, options pleine largeur `py-3`, rangées
`flex-wrap`, review `sm:grid-cols-2`, hint clavier masqué sur phone). Défaut principal : **grille
récompenses `grid-cols-4` figée** (S3-bis layout), header boss non-wrap, bouton hint icon-only < 44px,
écrans confetti/préparation en `100vh`.

### 3.12 Donjon

Mobile-first (colonne `max-w-2xl`, options `py-3.5`, gameover `flex-wrap`, RTL géré). Faiblesses
à 360–375 : **stats game-over `grid-cols-4` figées**, paddings `px-6` larges, quelques cibles
(retour/retry/start) < 44px, `min-h-[60vh]` (S4).

### 3.13 Classement

Responsive et dégrade bien (réserve la place de la bottom-nav, lignes `flex-1 min-w-0 truncate`,
onglets `flex-wrap`, podium tronqué). Défauts : onglets ~32px (S1), titre `text-4xl` non bridé,
carte « mon rang » non tronquée (débordement à 360), podium `grid-cols-3` serré.

### 3.14 Rapport parent (graphes/jauges)

Conscient du responsive (`max-w-6xl p-4 md:p-8`, métriques `grid-cols-2 md:grid-cols-4`, formulaire
qui s'empile, bar chart en `overflow-x-auto`). Défauts : **ligne par-matière** à colonnes fixes qui
écrase la barre de progression à 360, `VerdictCard` non-wrap, pagination/chips < 44px.

### 3.15 Écrans admin (tables)

Larges mais responsables : conteneurs centrés, formulaire grant qui s'effondre, listes en cartes
`flex-wrap`, table 6 colonnes correctement en `overflow-x-auto` (`min-w-[760px]` scrolle). Défauts :
S1 (boutons d'action ~28–32px), `px-6` large à 360.

### 3.16 Overlays (paywall, beta, signalement, notifications, root error)

Sains : contraintes fluides `max-w-md`, aucun width fixe, zéro débordement, root shell avec
safe-area + status-bar. Défauts : S1 (boutons inline/form), `text-8xl` non responsive sur le 404.

### 3.17 Design system (styles, primitives, canvas)

Solide : sidebar en `svh` (pas de 100vh), Sheet mobile via `useIsMobile`, ambient 3D fallback CSS,
blobs en wrapper `overflow-hidden`, reduced-motion respecté. Gaps : **primitives overlay** (Dialog
S3, Sheet), aucune prise en compte safe-area dans les primitives portées, et S1 (SidebarTrigger
28px, `Button` sm/icon, close X ~16px) — multipliés sur tout l'app.

### 3.7bis Carte d'aventure (audit ciblé)

Ré-audit dédié de `journey-map.tsx` / `journey-track.tsx` / `journey-header.tsx` /
`path-node.tsx`. **Très bien gérée** : conteneurs `max-w-3xl/2xl px-6`, nœuds `w-40`/`max-w-[10rem]`
qui tiennent largement à 360 px, cercles `w-16 h-16` (64px > 44px), ligne centrale en
`left-1/2 -translate-x-1/2`, ping en `inset-0` (pas de débordement), RTL via flexbox. **Aucun
débordement horizontal involontaire ni overlap.** Seuls défauts : 🟠 la rangée zigzag
(`journey-track.tsx:35`) n'a **aucun padding latéral sous `sm`** (`sm:pl-6`/`sm:pr-6` seulement)
→ les nœuds alternés touchent le bord du viewport sur téléphone ; 🟡 titre `text-3xl` un peu grand
à 360 (`journey-header.tsx:22`).

---

## 4. Tableau des constats prioritaires (confirmés + rétrogradés)

> 38 constats majeurs/mineurs survivants après vérification adversariale (les 4 rejetés et les
> 67 nits ne sont pas listés ici).

| Sév. | Fichier:ligne                                                          | Catégorie     | Problème (résumé)                                              |
| ---- | ---------------------------------------------------------------------- | ------------- | -------------------------------------------------------------- |
| 🟠   | `components/account-hud.tsx`:31                                        | Débordement   | XP non borné dans un cluster `shrink-0` → header déborde à 360 |
| 🟠   | `routes/_authenticated.tsx`:237                                        | Cible tactile | Déconnexion icon-only ~28px sous `lg`                          |
| 🟠   | `routes/_authenticated.tsx`:166                                        | Cible tactile | Liens admin icon-only ~28px sous `lg`                          |
| 🟠   | `components/ui/theme-switcher.tsx`:39                                  | Cible tactile | Trigger thème ~30×26px                                         |
| 🟠   | `components/ui/language-switcher.tsx`:33                               | Cible tactile | Trigger langue ~28px                                           |
| 🟠   | `components/ui/dialog.tsx`:47                                          | Cible tactile | Bouton fermer ~16px                                            |
| 🟠   | `routes/_authenticated/leaderboard.tsx`:96                             | Cible tactile | Onglets ~32px                                                  |
| 🟠   | `styles.css`:698                                                       | Tableau       | `.lesson-table` sans scroll horizontal                         |
| 🟠   | `routes/_authenticated/parent-report.tsx`:360                          | Mise en page  | Barre de progression par-matière écrasée à 360                 |
| 🟠   | `components/public/public-header.tsx`:36                               | Navigation    | Nav Programme/Extras cachée sur phone, sans menu               |
| 🟠   | `features/quest/components/quest-reward-grid.tsx`:23                   | Mise en page  | `grid-cols-4` figée → valeurs coupées à 360                    |
| 🟠   | `features/dashboard/components/parcours-interest-button.tsx`:35        | Cible tactile | Pill « Ça m'intéresse » ~26px                                  |
| 🟡   | `components/ui/button.tsx`:20                                          | Cible tactile | Tokens `sm` 32px / `icon` 36px                                 |
| 🟡   | `components/ui/dialog.tsx`:41                                          | Modale        | Pas de `max-height` / scroll interne                           |
| 🟡   | `routes/auth.tsx`:249                                                  | Viewport      | `min-h-screen` (vh)                                            |
| 🟡   | `routes/auth.tsx`:276,314,424                                          | Cible tactile | Boutons submit/Google/rôle 36–40px                             |
| 🟡   | `routes/_authenticated/dashboard.tsx`:337                              | Mise en page  | `grid-cols-[auto,1fr,auto]` **invalide** (virgules)            |
| 🟡   | `routes/_authenticated/dashboard.tsx`:382                              | Cible tactile | Bouton copier code < 44px                                      |
| 🟡   | `features/dashboard/components/hero-stat-chips.tsx`:31                 | Cible tactile | Chips interactifs < 44px                                       |
| 🟡   | `routes/_authenticated/dungeon.tsx`:427                                | Mise en page  | Stats game-over `grid-cols-4` figées                           |
| 🟡   | `routes/_authenticated/dungeon.tsx`:303                                | Cible tactile | Bouton « Retry » < 44px                                        |
| 🟡   | `routes/_authenticated/leaderboard.tsx`:143                            | Débordement   | Carte « mon rang » non tronquée                                |
| 🟡   | `routes/_authenticated/onboarding.tsx`:321                             | Cible tactile | Bouton « Retour » 36px                                         |
| 🟡   | `styles.css`:712                                                       | Débordement   | `.lesson-math` sans `overflow-x`                               |
| 🟡   | `styles.css`:742                                                       | RTL           | Tableau forcé LTR sans scroll en arabe                         |
| 🟡   | `styles.css`:631                                                       | Débordement   | `.lesson-content` sans `overflow-wrap`                         |
| 🟡   | `features/quest/components/manuel-pages-section.tsx`:83                | Modale        | Lightbox image en `vh`                                         |
| 🟡   | `routes/_authenticated/parent-report.tsx`:439                          | Mise en page  | `VerdictCard` non-wrap                                         |
| 🟡   | `features/dashboard/components/dashboard-radar-inventory.tsx`:204      | Cible tactile | Bouton « Activer » ~26px                                       |
| 🟡   | `features/subscription/components/parcours-entitlements-admin.tsx`:215 | Cible tactile | Bouton « Révoquer » < 44px                                     |
| 🟡   | `features/subscription/components/beta-requests-admin.tsx`:132         | Cible tactile | Approuver/Rejeter ~32px                                        |
| 🟡   | `features/content-report/components/content-reports-admin.tsx`:123     | Cible tactile | Résoudre/Rejeter ~32px                                         |

---

## 5. Points forts à préserver

- **Bottom-nav mobile + safe-area** du shell authentifié (encoche, home-indicator gérés).
- Grilles **mobile-first** systématiques et typographie bridée par variantes responsives.
- **RTL** via propriétés logiques + miroir d'icônes, résolu en SSR sans FOUC.
- Canvas 3D **coupé sur mobile** avec fallback CSS, `prefers-reduced-motion` respecté.
- Tables admin / bar chart parent correctement enveloppés en `overflow-x-auto`.
- Sidebar en unités `svh` (pas de piège 100vh), Sheet mobile dédiée.
- Listes de classement `flex-1 min-w-0 truncate` (pas de débordement par nom long).

---

## 6. Correctifs appliqués

> Cette section est mise à jour au fil de la branche. Voir le diff pour le détail.

### Lot 1 — Débordement & mise en page (fonctionnel)

- `styles.css` : scroll horizontal sur `.lesson-table`/`.lesson-math` + `overflow-wrap` sur
  `.lesson-content` + `pre { overflow-x:auto }`, variantes RTL incluses (S2).
- `quest-reward-grid.tsx` + `dungeon.tsx` : `grid-cols-2 sm:grid-cols-4` (grilles figées).
- `account-hud.tsx` : XP en format compact + `min-w-0`/`truncate` (débordement header).
- `leaderboard.tsx` : `min-w-0`/`truncate` sur la carte « mon rang ».
- `parent-report.tsx` : ligne par-matière et `VerdictCard` rendues responsives.
- `dashboard.tsx` : `sm:grid-cols-[auto_1fr_auto]` (correction de la valeur invalide).

### Lot 2 — Cibles tactiles 44 px (primitives + contrôles flaggés)

- Primitives : `theme-switcher`, `language-switcher`, `dialog` (close + `max-h`/scroll), `button`
  (tokens tactiles).
- Contrôles : nav header (déconnexion/admin), onglets classement, boutons admin, pills d'intérêt,
  « Activer » inventaire, boutons auth, « Retour » onboarding, hint quête, retry donjon.

### Lot 3 — Viewport `dvh` & nav publique mobile

- `min-h-screen`/`vh` → `dvh` (auth, onboarding, écrans de préparation, lightbox).
- `public-header.tsx` : liens catalogue visibles sur téléphone.

### Lot 4 — Finitions : longue traîne des constats (couverture complète)

> Deuxième passe traitant l'ensemble des constats mineurs restants (la totalité des items
> code-actionnables de la §4 et des 67 mineurs). Seuls les constats que les auditeurs ont
> explicitement marqués « acceptable / sans changement / optionnel » (ex. bar chart parent déjà
> en `overflow-x-auto`, libellés de bottom-nav, blobs décoratifs) ont été laissés tels quels.

- **Cibles tactiles 44 px — généralisées** : la primitive `Button` applique désormais
  `[@media(pointer:coarse)]:min-h-11` (cascade sur tous ses usages, **tactile seulement** →
  desktop inchangé) ; idem `[@media(pointer:coarse)]:min-h-11` sur tous les contrôles compacts
  restants : toggle Cours/Résumé + Print (leçon), boutons du subject-hub / quiz-lock / hint /
  manuel prev-next, boutons boutique (Buy/Equip/Activate, + `flex-wrap`), « Activer » inventaire,
  chips du hero (via `ExplainHint`), boutons objectifs/quêtes + pill classement (dashboard),
  inputs/liens auth, chips & pagination du rapport parent, formulaire grant admin, boutons
  signalement / notifications / beta, liens nav publics (tablette).
- **Autres bugs de grille à virgule corrigés** (même classe que le hero) :
  `dashboard.tsx` `lg:grid-cols-[1fr_360px]` et `parent-report.tsx`
  `md:grid-cols-[1fr_180px_auto]` — ces grilles à colonnes fixes ne s'appliquaient jamais.
- **Typographie bridée sur petits écrans** : titres donjon (lobby/gameover), classement,
  catalogue, hero dashboard (`break-words` + `min-w-0`), 404 (`text-6xl sm:text-8xl`).
- **Débordement / troncature** : `min-w-0` + `truncate` sur les noms boutique/inventaire,
  carte sujet, en-tête boss ; `min-w-0` + `[&_svg]:max-w-full` sur les options de practice ;
  radar inventaire en `aspect-square` capé (au lieu de `h-72` fixe).
- **Padding responsive** `px-4 sm:px-6` (donjon, dashboard, classement, admin, auth) + cartes
  donjon/auth `p-5/p-6 sm:p-8` pour regagner de la largeur à 360 px.
- **Layout** : bannière de série et rangée d'actions boutique passées en `flex-wrap` /
  `flex-col sm:flex-row` ; en-tête de jeu du donjon en `flex-wrap`.
- **`dvh` étendu** à tous les loaders `min-h-[60vh]`/`[30vh]` (quête, donjon, classement,
  parcours, routes publiques).
- **Safe-area / encoche** : header & footer publics, wrapper auth (pt/pb `env(safe-area-inset-*)`),
  variantes `Sheet` haut/bas, gouttière latérale `w-[calc(100%-2rem)]` sur toutes les modales.
- **RTL** : chevrons d'onboarding miroir (`rtl:-scale-x-100`) ; titre du lightbox manuel
  décalé du bouton fermer (`pe-10`).

---

_Méthode : audit multi-agents en lecture seule (18 groupes + ré-audit ciblé), vérification
adversariale des constats majeurs, puis correctifs responsive avec gate vert (`npm run verify`)._
