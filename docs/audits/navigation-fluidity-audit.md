# Audit — Fluidité de navigation (mode anonyme & mode connecté)

> **Date** : 2026-06-29 · **Périmètre** : navigation inter-écrans, logique de routage, UX
> de transition anonyme ↔ connecté. **Type** : lecture seule, aucun code applicatif modifié.
> **Méthode** : revue des routes (`src/routes/**`), des shells `_public` / `_authenticated`,
> des composants de navigation partagés, du flux d'auth (Supabase), confrontés aux specs e2e
> existantes (`e2e/public-anon/navigation.spec.ts`, `e2e/authed/navigation.spec.ts`).

## Verdict

La navigation est **globalement saine et bien structurée**. L'architecture à deux coquilles
(`_public` pour l'anonyme, `_authenticated` pour le connecté), le routage d'exercice
*auth-aware* (`exerciseRouteFor` : `/exercice` pour l'anon, `/quest` pour le connecté), les
redirections 301 de convergence (`/themes`, `/subject`, `/lesson` → slugs publics FR) et le
guard d'auth en `useEffect` (pas de flash de contenu protégé) sont des points forts réels,
déjà couverts par des specs e2e.

**Aucun bloquant fonctionnel** au sens « écran inatteignable » ou « boucle de redirection ».
Les frictions identifiées sont des **dead-ends de remontée hiérarchique**, une **gestion
d'erreur manquante sur un écran public**, et l'**absence de préservation du deep-link
après login**. Aucune n'expose de données protégées (toutes les server fns valident le JWT).

## Légende de sévérité

| Niveau | Sens |
|---|---|
| 🔴 **Majeur** | Friction nette dans un parcours courant ; à corriger avant de qualifier la nav « fluide ». |
| 🟡 **Mineur** | Friction localisée ou incohérence ; correctif simple, faible risque. |
| ⚪ **Nit** | Cosmétique / confort / a11y ; opportuniste. |

> Note de fiabilité : deux affirmations issues du balayage automatique ont été **réfutées
> après vérification du code** et sont reclassées en bas de document (section
> « Affirmations corrigées »). Les sévérités ci-dessous sont celles vérifiées.

## Synthèse des constats

| # | Sévérité | Zone | Constat | Emplacement |
|---|---|---|---|---|
| 1 | 🔴 Majeur | Anonyme | `/chapitre/$chapterId` ne gère pas l'état d'erreur → **spinner infini** si le fetch échoue (les voisins `/matiere`, `/exercice` le gèrent). | `routes/_public/chapitre.$chapterId.tsx:22-33` |
| 2 | 🔴 Majeur | Anonyme | Pas de remontée **Matière → Niveau** : arrivé sur une matière, aucun lien retour vers le niveau parent (browser-back uniquement). | `features/quest/components/subject-hub.tsx` |
| 3 | 🔴 Majeur | Anonyme | Pas de remontée **Chapitre → Matière** : le nom de la matière dans le lecteur de cours est du texte, pas un lien. | `features/quest/components/lesson-reader.tsx` (en-tête) |
| 4 | 🔴 Majeur | Transition | **Deep-link non préservé après login** : un anon qui ouvre un lien protégé est renvoyé vers `/dashboard` après connexion, jamais vers la page demandée. | `routes/auth.tsx:36,85-90` · `routes/_authenticated.tsx:71-75` |
| 5 | 🟡 Mineur | Connecté | `/programme` (catalogue public, cible de la nav « Découvrir ») n'est **pas scopé au parcours actif** : un connecté y voit tous les niveaux au lieu de son parcours. | `routes/_authenticated/themes.tsx` (301 → `/programme`) |
| 6 | 🟡 Mineur | Connecté | **Aucun sélecteur de parcours** post-onboarding : changer de parcours impose de repasser par l'onboarding ; le parcours actif n'est pas non plus affiché dans la nav. | nav shell `routes/_authenticated.tsx` |
| 7 | 🟡 Mineur | Connecté | Liens **admin cachés sur mobile** (`hidden lg:*`), sans menu overflow → un admin sur mobile ne peut atteindre `/admin/*` depuis la nav. | `routes/_authenticated.tsx` (header) |
| 8 | 🟡 Mineur | Transition | Cache React Query **non purgé au logout** (`queryClient.clear()` absent). Pas de fuite (server fns protégées) mais données périmées possibles à la reconnexion. | `routes/_authenticated.tsx:100-104` |
| 9 | ⚪ Nit | Transition | Confirmation d'e-mail **hardcodée vers `/dashboard`** (`emailRedirectTo`), même problème de deep-link que #4. | `routes/auth.tsx` (~l.132) |
| 10 | ⚪ Nit | Anonyme | Boutons nav cours **précédent/suivant sans `aria-label`** contextualisé ; liste d'exercices sans `role="list"`. | `lesson-reader.tsx`, `subject-hub.tsx` |
| 11 | ⚪ Nit | Connecté | Pas de feedback « enregistrement… » entre la sélection de parcours en onboarding et l'arrivée au dashboard. | `routes/_authenticated/onboarding.tsx` |

## Détail par zone

### A. Mode anonyme (`_public`)

**Ce qui marche.** Hiérarchie claire `landing → /programme|/extras → /niveau → /matiere →
/chapitre|/exercice`. CTAs de découverte convergents et cohérents (le header pointe
`Programme`/`Extras`/`Se connecter`/`S'inscrire`). Le routage *auth-aware* envoie l'anon vers
la pratique gratuite (`/exercice`) sans jamais le bloquer au mur de login — comportement
verrouillé par `e2e/public-anon/navigation.spec.ts` (cours → « pratiquer » → exercice, et
exercice → « revoir le cours » → chapitre). États de chargement / vides / erreurs gérés sur
`/programme`, `/niveau`, `/matiere`, `/exercice`.

**Frictions.**
- **#1 (Majeur)** — `/chapitre/$chapterId` : `useQuery` ne récupère pas `isError`, et le garde
  `if (isLoading || !data)` retombe sur le spinner pour un fetch en échec → **spinner
  perpétuel**. Les routes sœurs affichent un message d'erreur ; l'incohérence est la preuve
  que c'est un oubli, pas un choix.
- **#2 / #3 (Majeur)** — Remontée hiérarchique incomplète. On descend bien
  niveau→matière→chapitre, mais on ne peut pas remonter matière→niveau ni chapitre→matière
  autrement qu'avec le bouton du navigateur. Le contenu existe pour le faire (la matière
  connaît son parcours, le chapitre connaît `subject_id`) — il manque juste les liens. À noter :
  le passage chapitre→exercice et exercice→chapitre, lui, **est** câblé (testé en e2e).

### B. Mode connecté (`_authenticated`)

**Ce qui marche.** Guard d'auth centralisé en `useEffect` (redirige l'anon vers `/auth`, le
profil sans parcours vers `/onboarding`), pas de flash de contenu protégé (`return null` tant
que `!user`). Nav principale cohérente desktop + bottom-tab-bar mobile, avec un **mode
immersif** qui masque la barre sur `/quest`, `/dungeon`, `/lesson`, `/onboarding` pour ne pas
chevaucher les CTAs de jeu. Retours bien balisés sur les écrans de jeu : le quest revient vers
`/matiere/$subjectId` (ou `/dashboard`), `QuestResultActions` offre Hall / Matière / Rejouer /
Quête suivante ; le dungeon revient au dashboard. Le flux principal
`dashboard → parcours (JourneyMap) → matière → cours/quest` est lisible.

**Frictions.**
- **#5 (Mineur)** — La nav « Découvrir » a convergé vers `/programme` (public, tous niveaux).
  Pour un connecté, ça casse l'attente « voir mon parcours » : `/parcours` (JourneyMap) est la
  vue scopée, mais `/programme` reste global. À clarifier (renvoyer le connecté vers
  `/parcours`, ou scoper l'affichage).
- **#6 (Mineur)** — Le parcours actif est persisté côté serveur mais **invisible** dans
  l'UI (pas de label « Maths 9ème ») et **non changeable** sans repasser l'onboarding. Friction
  réelle pour un élève multi-parcours.
- **#7 (Mineur)** — Sur mobile, les entrées admin sont en `hidden lg:*` sans repli → admin
  mobile sans accès nav à `/admin/*`.

### C. Frontière anonyme ↔ connecté

**Ce qui marche.** Pas de boucle de redirection : les 301 (`/lesson`→`/chapitre`, etc.) sont
en `beforeLoad`, donc s'exécutent avant le guard d'auth ; l'anon n'est pas baladé vers
`/auth` pour du contenu public. Le header public bascule login/signup ↔ `AccountHud` sans
clignotement. Logout propre (`supabase.auth.signOut()` puis `/`), et le bouton back après
logout ne ré-expose aucun contenu (server fns protégées).

**Frictions.**
- **#4 (Majeur)** — `validateSearch` de `/auth` ne capture que `mode` ; après connexion (et
  via `onAuthStateChange`), on `navigate({ to: "/dashboard" })` en dur. Le guard
  `_authenticated` redirige aussi vers `/auth?mode=login` **sans** mémoriser le chemin
  d'origine. Résultat : tout deep-link protégé est perdu au login. Correctif standard :
  propager un `from`/`redirectTo` dans la recherche et le consommer après `SIGNED_IN`.
- **#8 (Mineur)** / **#9 (Nit)** — purge de cache au logout absente ; `emailRedirectTo` figé
  sur `/dashboard` (même angle mort que #4 pour le parcours d'inscription par e-mail).

## Recommandations priorisées

1. **#1** — Ajouter le branchement d'erreur sur `/chapitre/$chapterId` (récupérer `isError`,
   afficher le même bloc d'erreur que `/matiere` / `/exercice`). *Effort : minime.*
2. **#4** — Préserver le deep-link : capturer `from` à la redirection du guard, le valider dans
   la recherche de `/auth`, rediriger dessus après login (fallback `/dashboard`).
   *Effort : modéré (~½ j).* Traiter #9 dans la foulée (`emailRedirectTo`).
3. **#2 / #3** — Câbler les liens de remontée : matière→niveau (passer le `parcoursId`
   au `SubjectHub`) et chapitre→matière (rendre le nom de matière cliquable). *Effort : faible.*
4. **#5 / #6** — Décider de la sémantique « Découvrir » pour un connecté (scoper `/programme`
   au parcours **ou** router vers `/parcours`) et exposer un sélecteur + label de parcours
   actif dans la nav. *Effort : modéré.*
5. **#7 / #8 / #10 / #11** — Confort : repli mobile pour l'admin, `queryClient.clear()` au
   logout, `aria-label` sur la nav cours, feedback de chargement onboarding. *Effort : minime.*

## Affirmations corrigées (transparence du balayage)

Deux constats remontés par l'analyse automatique ont été **réfutés après lecture du code** ;
ils ne figurent pas dans la synthèse ci-dessus :

- ❌ *« Routes `/admin/*` sans guard → loader infini pour un non-admin. »* **Faux.**
  `admin.subscriptions.tsx:71-83` rend un écran « accès refusé » + lien retour pour
  `role !== null && !isAdmin`, et les queries sont `enabled: isAdmin`. Au pire un bref flash du
  chrome admin vide pendant la résolution du rôle (cosmétique, non retenu).
- ❌ *« Liens de gameplay = impasses dures (BLOQUANT). »* Reclassé : la remontée
  chapitre↔exercice est câblée et testée en e2e ; seules les remontées matière→niveau et
  chapitre→matière manquent (constats #2/#3, Majeur — friction, pas impasse absolue puisque le
  browser-back fonctionne).

## Couverture e2e existante (à étendre)

Les transitions critiques sont déjà gardées : `e2e/public-anon/navigation.spec.ts` (cours ↔
exercice, quiz anon → invitation compte) et `e2e/authed/navigation.spec.ts` (nav shell par
`href`, marque → dashboard). Les correctifs #1–#3 mériteraient chacun un test : erreur de
chargement cours, présence des liens de remontée matière/niveau et chapitre/matière.
