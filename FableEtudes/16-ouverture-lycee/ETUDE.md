# Étude 16 — Ouverture du lycée : 4 années × sections, mutualisation du tronc commun, arborescence UX

> **Statut** : validée (arbitrages Q-1…Q-5 rendus le 2026-07-11 ; maquette du lot 3 à valider sur R-8 é15)
> **Priorité** : 16 · **Valeur** : 🎓 ouverture du second cycle complet — 17 classes sélectionnables, ~15-19 ans, l'audience la plus motivée (bac) · **Complexité** : haute (surface large, mais découpée en lots courts + vagues de contenu)
> **Architecte** : Fable / 2026-07-11 · **Exécuteur cible** : Sonnet (lots 1-3) + skills contenu (vagues, pilotées par `curriculum-architect`)
> **Dépend de** : [`docs/lycee-architecture.md`](../../docs/lycee-architecture.md) (normatif — amendé par la PR de cette étude), étude 15 (lots 3/8/10 : coordination écrans, voir RISK-2), corpus L1 secondaire (transcriptions officielles)
> **Bloque** : la campagne de génération lycée (stations L2–L5), étude 02 (examen blanc — a besoin des `NN-annales-bac`)
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, docs/lycee-architecture.md, `content-engine/references/generation-pipeline.md`, `curriculum-architect/references/programme-map.md`

## 1. Contexte & objectif produit

**La demande produit** : ouvrir le lycée **en totalité côté classes** (les 4 années, toutes les
sections) en commençant par les **matières principales** uniquement. Deux complexités nommées :
(a) à partir du branchement en sections, plusieurs classes **partagent du contenu** qu'il ne faut
pas dupliquer ; (b) l'**UX de l'arborescence** — comment afficher un niveau qui a plusieurs
sections. Précision factuelle importante : dans le système tunisien le branchement commence en
**2ème année** secondaire (4 orientations), pas en 3ème ; les sections complètes (×6) couvrent la
3ème et le bac. C'est déjà le modèle seedé en DB.

**État réel (vérifié sur code + migrations, 2026-07-11) :**

- **Le socle data (station L0) est FAIT et en prod.** `20260704235000_lycee_section_grades_seed.sql`
  (PR #285, mergée) : 16 nœuds de section (`2eme-sec-*` ×4, `3eme-sec-*` ×6, `bac-*` ×6,
  `display_order` 14→29, cycle `secondaire`), flag `grades.is_selectable` (false sur les 3 nœuds
  plats legacy `2eme-sec`/`3eme-sec`/`bac`), 1 parcours par nœud tous `coming_soon`
  (kind `scolaire` gratuit pour 2ème/3ème, `concours` pour les 6 `bac-*`). Le scoping produit
  (dashboard, JourneyMap, `(theme, grade) → parcours`) fonctionne **déjà** sur ces nœuds —
  vérifié : `getDashboard` filtre par `grade_id` exact, aucune fuite inter-sections.
- **Un pilote tourne de bout en bout** : `math-bac-math` (1 chapitre complet d1→d4 + annales),
  parcours `concours-bac-math` **ouvert** (`20260705100000`) et gratuit (`20260705120000`).
- **Phase 100 % gratuite** (étude 15, arbitrage Q-2, lot 2 livré) : `is_premium = false` partout
  (`20260711100000`), infra entitlements dormante jusqu'à l'étude 01. **L'ouverture du lycée se
  fait donc entièrement gratuite** ; le design premium `bac-*` de `docs/lycee-architecture.md` §5
  reste la cible dormante.
- **Le vote existe** : `parcours_interest` + RPC `toggle_parcours_interest` (coming_soon
  uniquement) + bouton « ça m'intéresse » déjà rendu à l'onboarding — le signal de demande par
  section est déjà collecté.

**Le problème, précisément :**

1. **UX cassée** : l'onboarding et `/programme` affichent le cycle « secondaire » comme une
   **liste plate de 20 cartes** — les 3 nœuds legacy en doublon conceptuel (le flag
   `is_selectable` n'est lu **nulle part** dans `src/`, et les types Supabase générés ne le
   connaissent même pas), les 16 sections mélangées sans regroupement par année, 19 cartes
   « Bientôt » sur 20. C'est le « dead-end lycée » de l'audit étude 15 §G.
2. **i18n** : `grades` est monolingue (`name_fr` seul) ; un lycéen arabophone voit « Bac Sciences
   expérimentales » en plein UI arabe. (`parcours` a déjà `name_en`/`name_ar`… jamais sélectionnés.)
3. **Duplication de contenu** : `docs/lycee-architecture.md` §8 accepte en v1 d'écrire le tronc
   commun **une fois par section** (anglais de 3ème = 6 dossiers identiques). À l'échelle du
   périmètre demandé (~17 classes), ce trade-off ne tient plus : coût d'authoring ×4…×6 sur le
   tronc, et risque de divergence silencieuse entre copies. La présente étude **remplace ce
   trade-off** par un mécanisme de mutualisation dans le pipeline (D-4).
4. **Pas de plan d'ouverture** : 19 parcours `coming_soon` sans seuil défini de bascule
   `available` ni ordre de vagues arbitré.

**Résultat attendu** : un lycéen de n'importe quelle classe choisit son année **puis** sa section
en ≤ 2 gestes ; les nœuds legacy disparaissent de toutes les surfaces ; le tronc commun est écrit
**une fois** et compilé vers N sections ; les 17 classes ouvrent par vagues avec un seuil de
contenu explicite, re-priorisables par les votes.

**KPIs :**

- 0 nœud legacy visible (onboarding, `/programme`, admin exclus) ; 0 liste de sections à plat.
- Choix d'une classe lycée : ≤ 2 interactions (année → section) ; **un seul niveau de l'arbre par
  écran** (pages légères, arbitrage 2026-07-11) — jamais années ET sections déroulées sur la même
  page.
- Tronc commun : 1 dossier source par (matière × année) au lieu de ×4/×6 — ≥ 50 % du volume
  d'authoring lycée économisé (mesure : dossiers `content/` vs subjects compilés, §4bis).
- Chaque vague : parcours flippé `available` **uniquement** au seuil R-8 atteint, migration
  `open_*` dédiée.
- Libellés grades servis dans les 3 langues avec fallback (`name_fr`).

**Ce que l'étude ne fait PAS** : pas de réactivation premium (étude 01 ; les parcours `bac-*`
gardent `kind='concours'` dormant), pas de fusion de progression inter-sections (v1 : un subject
par section, progression indépendante — voir R-6), pas de sport / 3èmes langues
(allemand/espagnol/italien) / pensée islamique (hors périmètre initial, conventions prêtes), pas
de rédaction du contenu lui-même (les vagues cadrent ; les skills exécutent), pas de refonte des
écrans au-delà du bloc lycée (étude 15).

## 2. Spécification fonctionnelle

**Acteurs** : élève lycéen (~15-19 ans, FR/AR/EN), élève de 9ème qui anticipe son orientation,
parent, visiteur anonyme, admin (priorisation des vagues).

- **US-1** — En tant qu'élève de 1ère année secondaire, je choisis « 1ère année » directement
  (le tronc commun n'a pas de section) et j'arrive sur mes matières.
- **US-2** — En tant qu'élève de 2ème/3ème/bac, je choisis mon **année** puis ma **section**
  (« أنا باك رياضيات ») en ≤ 2 gestes, à l'onboarding comme dans l'Explorer (`/programme`).
- **US-3** — En tant qu'élève d'une section « Bientôt », je peux voter (« ça m'intéresse ») et —
  dès le lot 10 de l'étude 15 (option A, Q-6 é15) — la sélectionner quand même avec l'accueil
  « ta classe arrive ». Cette étude n'implémente PAS la sélectionnabilité (périmètre é15) ; elle
  garantit que le picker groupé l'expose proprement.
- **US-4** — En tant qu'élève connecté, je vois **ma section** nommée dans mon QG/JourneyMap
  (« Bac Mathématiques », localisé), pas un titre générique.
- **US-5** — En tant qu'élève qui change de section (réorientation, erreur de choix), je re-choisis
  via l'Explorer ; mes XP/pièces/badges/série sont conservés (globaux au profil) ; la progression
  par matière est propre à chaque section et l'UI me le dit honnêtement avant de confirmer.
- **US-6** — En tant que visiteur/parent, le bloc Lycée de `/programme` présente 4 cartes
  d'année (page légère) ; chaque année ouvre sa page de sections avec l'état réel (disponible /
  bientôt + intérêt) et la volumétrie honnête — en 3 langues.
- **US-7** — En tant qu'arabophone, les noms d'années et de sections s'affichent en arabe
  (données `grades` localisées), avec fallback français.
- **US-8** — En tant qu'admin, je lis les votes par section (existant) pour re-prioriser les
  vagues d'ouverture.

**Règles métier :**

- **R-1** — Toute surface user-facing qui liste grades/parcours **filtre** les parcours dont le
  grade porte `is_selectable = false`. Les parcours à `grade_id` NULL (thèmes libres) ne sont pas
  concernés. Admin : non filtré.
- **R-2** — Le lycée est TOUJOURS présenté **année → section**, en **drill-down par écrans
  légers** (arbitrage 2026-07-11) : un écran montre UN niveau de l'arbre — (1) les années du
  cycle ; (2) clic sur une année ⇒ **nouvelle page/étape** avec ses sections ; (3) clic sur une
  section ⇒ ses matières (page `/niveau/$parcoursId` existante). Jamais d'accordéon multi-niveaux
  ni de page chargée, mobile-first. La 1ère sec n'a pas de sous-niveau (clic direct → matières).
- **R-3** — L'état d'une section est toujours visible avant le clic : disponible / « Bientôt »,
  **avec le compteur d'intérêt public** (« 🔔 N intéressés », arbitrage Q-5) + vote (connecté ;
  un anonyme voit le compteur, le vote l'invite à se connecter). Aucun mensonge d'offre.
- **R-4** — Libellés localisés : `grades.name_en`/`name_ar` (nouvelles colonnes, backfill des 29
  lignes `ecole-tn`) sélectionnés selon la locale avec fallback `name_fr` ; même mécanique que
  les parcours (é15 R-6/lot 3). Tout `name_*` rendu dans une locale opposée porte l'isolation
  bidi existante (`isRtlText`/`dir`).
- **R-5** — **Mutualisation** : une matière dont le programme officiel est **identique** pour
  plusieurs sections d'une même année est authored **une fois** (dossier partagé `compileTo`,
  D-4) et compilée en un subject par section. La décision de partage se prend **par matière ×
  année, à la station L1 (sur transcription)** — jamais par défaut. En cas de doute : dossiers
  séparés (fidélité > économie).
- **R-6** — **Pas de fusion de progression inter-sections (v1)** : chaque section a ses subjects
  (UUIDs propres), donc quiz-gates et progression indépendants. Changer de section conserve
  XP/niveau/pièces/badges/série (portés par `profiles`) mais repart sur la progression matière
  de la nouvelle section. L'écran de switch l'énonce (US-5).
- **R-7** — **Fork sans perte** : retirer une section d'un dossier partagé pour lui donner son
  dossier dédié DOIT conserver l'id de subject compilé (`<matière>-<gradeSlug>`) et les slugs de
  chapitres/exercices → mêmes UUIDv5, progression élève intacte (garanti par D-4.a ; test dédié).
- **R-8** — **Seuil d'ouverture d'une section** (bascule `coming_soon → available`, une migration
  `open_*` par section) — **arbitré Q-1 : UNE matière complète ouvre la section.** « Complète » =
  tous les chapitres du programme officiel (transcription L1) avec le socle par chapitre
  (cours + résumé + quiz + d1 + d2). En pratique la première matière complète est la dominante
  n°1 (ordre d'authoring des vagues) ; d3/d4 et `NN-annales-bac` arrivent derrière (overlay
  L3/L4) sans bloquer l'ouverture ; les autres matières de la classe s'ajoutent en continu.
- **R-9** — Les nouvelles sections seedées ou re-ciblées par `compileTo` référencent uniquement
  des `gradeSlug` du référentiel canonique (liste fermée validée au build, D-4) — un slug
  inconnu = échec de `content:check`, jamais un subject à `grade_id` NULL silencieux.
- **R-10** — **Périmètre v1 par classe : 4-5 matières « vraiment cœur » maximum** (arbitrage
  Q-3) : les dominantes de la section + le tronc le plus rentable (français partout ; arabe ou
  philosophie selon l'année/section). Le reste (anglais hors sections où il est cœur, philo 3ème,
  histoire-géo hors lettres/éco, informatique 1ère…) passe en extension v1.1 — les dossiers ⚭
  rendent l'ajout ultérieur bon marché. La liste finale par classe est arrêtée au plan de vague
  (`curriculum-architect` + Mohamed).

**i18n** : nouvelles clés `lyceeYears` (1ère année / 2ème année / 3ème année / Baccalauréat) dans
`fr.ts` + `fr-public.ts` et miroirs EN/AR ; noms de sections = données DB localisées (R-4), pas
des clés front. RTL : cartes d'année et de section testées en AR (captures é15 R-5).

**Hors périmètre (v1)** : sélectionnabilité des `coming_soon` (é15 lot 10), recomposition globale
des écrans onboarding/catalogue (é15), premium (é01), mapping de progression inter-sections
(candidat étude 07), section sport et matières hors « principales » (§4bis les liste).

## 3. Architecture technique (décisions fermées)

### D-1 — Le modèle de données est ACQUIS : sections = nœuds `grades` (rien à re-décider)

Décision de `docs/lycee-architecture.md` §2, seedée et en prod. Cette étude n'ajoute **aucune
table**. Constat d'implémentation à répercuter dans le doc (PR de cette étude) : les parcours
2ème/3ème sont `kind='scolaire'` (pas `libre` — le CHECK a été élargi par `20260617120000`), et le
§6 (spec de seed) est réalisé. Amendements chirurgicaux : §5 (kind réel + note phase gratuite),
§6 (statut fait), §2/§8 (mutualisation → cette étude), + la ligne périmée « None of this is in
the DB yet » de `programme-map.md`.

### D-2 — Localisation des grades : colonnes `name_en`/`name_ar` (miroir du modèle parcours)

Migration additive : `ALTER TABLE public.grades ADD COLUMN IF NOT EXISTS name_en TEXT, ADD COLUMN
IF NOT EXISTS name_ar TEXT;` + backfill des **29 lignes** `ecole-tn` (13 échelle + 16 sections).
Nullable, fallback `name_fr` côté serveur — exactement le contrat parcours (`20260608120000`).
Source des noms officiels (arbitrage Q-4) : la nomenclature ministérielle publiée — **edunet.tn
/ CNP** ; l'exécuteur du lot 2 y récupère les intitulés AR/FR/EN des 16 sections, les consigne
en annexe de la migration (URL de source citée), et Mohamed relit avant merge (RISK-3).
Alternative rejetée : clés i18n front par slug — casse la symétrie avec parcours (é15 lot 3 fait
l'inverse), et le catalogue serait intraduisible côté SSR/e2e sans DB.

### D-3 — L'« année » d'un nœud secondaire est DÉRIVÉE du slug (pas de nouvelle colonne)

Helper pur `lyceeYearOf(slug)` → `'1ere' | '2eme' | '3eme' | 'bac' | null` par préfixe sur la
liste fermée des 17 slugs (les slugs sont l'identité canonique du repo ; le set est clos et
versionné). Vit dans `src/features/dashboard/program-families.ts` à côté de `buildPrograms`.
Alternative rejetée : colonne `grades.year_group` — donnée dérivable, migration + régénération de
types pour zéro pouvoir expressif supplémentaire.

### D-4 — Mutualisation : `compileTo[]`, l'expansion « 1 dossier source → N subjects » (LE cœur)

Constat pipeline (vérifié) : `sql-builder.ts` dérive **tout** de `meta.id` (`chapterId =
uuidV5("<subjectId>/<chapterSlug>")`, etc. — jamais du nom de dossier), le pruning est scopé
`subject_id = meta.id`, et `build.ts` sait déjà émettre N migrations horodatées pour N subjects.
Le mécanisme est donc une **expansion au chargement**, sans toucher `sql-builder.ts`.

**Schéma (`src/shared/content/schema.ts`)** — extension de `subjectMetaSchema` :

```ts
// Nouveau : référentiel canonique des slugs de grades (liste fermée, synchro avec les seeds)
export const KNOWN_GRADE_SLUGS = [/* 13 échelle + 16 sections + 3 legacy (jamais ciblables en compileTo) */] as const;

compileTo: z.array(z.object({
  id: z.string().regex(/^[a-z][a-z0-9-]*$/),   // id du subject COMPILÉ — seul id qui atteint la DB
  gradeSlug: z.string().min(1),                 // ∈ KNOWN_GRADE_SLUGS, is_selectable uniquement
  nameFr: z.string().min(1).optional(),         // défaut : meta.nameFr
  description: z.string().min(1).optional(),    // défaut : meta.description
})).min(2).optional(),
```

Contraintes (superRefine + validation loader) : `compileTo` présent ⇒ `gradeSlug` racine absent/null
et l'`id` racine est **virtuel** (convention `<matière>-<année>`, ex. `anglais-3eme-sec` — n'atteint
jamais la DB) ; ids cibles **distincts**, chacun `endsWith("-" + gradeSlug)` (convention
`<matière>-<gradeSlug>` verbatim préservée) ; slugs ∈ référentiel et ≠ nœuds legacy (R-9).

**Filtrage par section, deux niveaux** (pour le « quasi-identique ») :

- `chapter.json` : `gradeSlugs?: string[]` (⊂ cibles du subject) — un chapitre présent seulement
  pour certaines sections ;
- `exercices/*.json` (et missions) : `gradeSlugs?: string[]` (⊂ cibles du chapitre) — permet des
  paliers d3/d4 **par section** dans un dossier partagé (ex. le défi « lettres » renforcé de
  `arabe-bac` ciblant `bac-lettres` seul). `quiz.json` suit son chapitre. Défaut partout : toutes
  les cibles.

**Expansion (`loader.ts`)** : `expandSubjects(loaded)` clone le `LoadedSubject` par cible
(surcharge `id`/`gradeSlug`/`nameFr`/`description`, retire `compileTo`), filtre
chapitres/exercices par `gradeSlugs`, puis vérifie l'**unicité globale** des ids compilés (entre
eux ET contre les dossiers physiques — collision = erreur de build, jamais un écrasement
silencieux). `build.ts` et `qa.ts` consomment les subjects **expansés** ; `--subject <dossier>`
garde sa sémantique dossier (un dossier partagé régénère ses N migrations
`_generated_<id-cible>_content.sql` d'un coup) ; `program-manifest`/`content:audit` voient les
ids compilés (les manifests L1 les énumèrent mécaniquement depuis `compileTo`).

**D-4.a — Invariant de stabilité (le garde-fou du long terme)** : les UUIDv5 dérivent de
l'**identité compilée** (`<matière>-<gradeSlug>` + slugs), jamais du dossier source. Corollaire
(R-7) : fork sans perte — sortir `bac-lettres` d'un `francais-bac` partagé vers un dossier dédié
conserve ids et progression, tant que les slugs de chapitres/exercices sont repris. Test unitaire
dédié (SQL snapshot identique avant/après fork).

**D-4.b — Règle de partage/fork (doctrine, appliquée à L1)** : programme officiel identique
(constaté sur transcription) ⇒ partage ; divergence **structurelle** (liste de chapitres ≠) ⇒
dossiers séparés d'emblée ; divergence de **profondeur seulement** (mêmes chapitres, exigence ≠)
⇒ partage + `gradeSlugs` au niveau exercice. Principe directeur : **plus on approche de
l'examen, moins on partage** — au bac, les dominantes de section sont toujours dédiées (fidélité
annales), le partage y est réservé au tronc (langues, philo, histoire-géo).

Alternatives rejetées : **N:N subject↔grades en DB** (casse `resolve_subject_parcours`, le
scoping dashboard, le pruning keyé `subject_id`, la RLS — exactement ce que le doc lycée §2
écarte) ; **symlinks de chapitres** (fonctionne par accident via `listDirs`, mais fragile sur
Windows — l'environnement de dev principal) ; **héritage `extends` entre dossiers** (sémantique
de merge profonde, QA ambiguë, diffs illisibles). Coût estimé du retenu : ~40-60 lignes + tests
(schema/loader/build/qa), zéro migration.

### D-5 — UX de l'arborescence, surface par surface

Composant/logique partagés : `buildPrograms` (`program-families.ts`) apprend le niveau « année »
sous le cycle secondaire — `type LyceeYearGroup = { yearKey, labelKey, sections: ProgramParcours[] }` ;
`ProgramParcours` gagne `gradeSlug`, `gradeSelectable` (→ filtre R-1 DANS le builder, appliqué à
toutes les surfaces d'un coup). `getParcours` (`dashboard.server.ts`) élargit son select/lookup :
`grades.slug`, `grades.is_selectable`, `name_en`/`name_ar` (grades + parcours, fallback serveur) —
« selects élargis » au sens R-10b é15, zéro RLS touchée.

Navigation en **drill-down par écrans légers** (R-2, arbitrage 2026-07-11 — remplace toute idée
d'accordéon multi-niveaux) :

1. **Catalogue `/programme`** (`parcours-catalogue.tsx` — le « lycée compacté » du lot 8 é15,
   dont cette section EST la spec) : le bloc Lycée montre **4 cartes d'année seulement** —
   « 1ère année secondaire » (→ `/niveau/ecole-1ere-sec` direct), « 2ème année », « 3ème année »,
   « Baccalauréat 🏆 », chacune avec son sous-texte (« n sections · n disponibles »). Clic sur une
   année à sections → **nouvelle page** `/programme/lycee/$annee`
   (`src/routes/_public/programme.lycee.$annee.tsx`, `$annee ∈ {2eme, 3eme, bac}`, 404 sinon) :
   la liste des sections de l'année (cartes pleine largeur mobile : nom localisé, badge
   disponible/« Bientôt », compteur « 🔔 N intéressés » (D-7), Trophy sur les bac), section
   disponible → `/niveau/$parcoursId` (les matières — existant). Breadcrumb retour vers
   `/programme`.
2. **Onboarding** (`onboarding.tsx`, `ParcoursStep`) : même drill-down en **sous-étapes du
   wizard** (pas de nouvelle route) : le cycle Secondaire liste 1ère année + 3 cartes d'année ;
   taper une année ⇒ l'étape « Choisis ta section » (liste des sections de cette année, mêmes
   cartes état + compteur + vote, bouton retour). Sélection = comportement actuel (la
   sélectionnabilité des `coming_soon` reste le lot 10 é15, option A). `dir` bidi sur les noms.
   ≤ 2 gestes (R-2).
3. **QG / JourneyMap** (`journey-header.tsx`, `parcours.tsx`) : kicker = nom localisé du parcours
   actif (« Bac Mathématiques ») — converge avec é15 D-6 (« kicker = classe, pas FORCE »).
4. **Switch de section** (`/niveau/$parcoursId`, existant) : inchangé structurellement ; la copy
   de confirmation énonce R-6 (acquis conservés / progression par matière propre à la section).
5. **Admin votes** (existant) : liste s'allonge mécaniquement (~28 lignes) — aucun changement
   requis ; confort (groupement par année) hors périmètre.

### D-7 — Compteur d'intérêt public (arbitrage Q-5)

Les votes deviennent visibles côté élève/visiteur : nouveau RPC lecture seule
`get_parcours_interest_counts()` → `TABLE(parcours_id TEXT, interested INTEGER)`,
`SECURITY DEFINER`, agrégat **anonyme** (aucun `user_id` exposé), limité aux parcours
`coming_soon` ; `REVOKE ALL` par défaut puis `GRANT EXECUTE TO anon, authenticated` (le
catalogue est public). L'UI l'affiche sur les cartes sections « Bientôt » (« 🔔 12 intéressés » ;
après vote : état actif du bouton existant). Un anonyme voit le compteur ; le bouton vote
l'emmène vers `/auth` (copy honnête, US-7 é15). L'RPC admin existante (détail par user) reste
admin-only, inchangée.

### D-6 — Ouverture par vagues, pilotée par la demande

Une vague = un jalon de contenu (§4bis) clôturé par une migration `open_*_parcours` **par
section** dès que R-8 est atteint (une matière complète — les sections d'une même vague ouvrent
donc au fil de l'eau, pas d'un bloc). Ordre **arbitré Q-2** (aligné doc lycée §8) :
**A** `1ere-sec` (tronc commun : sert les 15 sections d'aval + porte le pont linguistique) →
**B** `bac-math` + `bac-sciences-exp` (années d'examen, audience max ; le tronc `*-bac` compilé
×6 pré-remplit les 4 autres bacs) → **C** les 4 autres `bac-*` → **D** les 6 `3eme-sec-*` →
**E** les 4 `2eme-sec-*`. Re-priorisation : les votes `parcours_interest` (US-8) peuvent faire
passer une section devant dans SA vague ou promouvoir une section de la vague suivante —
décision humaine sur données admin, pas d'automatisme.

### Sécurité & observabilité

Server-side : selects élargis (R-10b é15) + UN nouveau RPC lecture seule (D-7,
`get_parcours_interest_counts` — agrégat anonyme, `SECURITY DEFINER`, grants explicites, pgTAP) ;
RLS inchangées. `compileTo` est purement compile-time (le SQL généré reste le même dialecte
idempotent audité). Les migrations `open_*` et le backfill i18n sont des UPDATE data additifs.
Observabilité : existante (votes, logs) — aucune métrique nouvelle requise.

## 4. Plan d'exécution en lots (exécuteur)

| lot | contenu (résumé)                                                                                                                                                                                                                                                                                                                                         | fichiers/objets principaux                                                                                                                                                    | tests exigés                                                                                                                                                        | dépend de                          |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| 0   | Étude + amendements docs normatifs + maquette arborescence                                                                                                                                                                                                                                                                                               | `FableEtudes/16-*`, `docs/lycee-architecture.md`, `programme-map.md`, `FableEtudes/README.md`                                                                                 | — (docs)                                                                                                                                                            | —                                  |
| 1   | **Pipeline mutualisation `compileTo`** (D-4) : schéma + expansion + garde-fous + docs pipeline                                                                                                                                                                                                                                                           | `schema.ts` (compileTo, `gradeSlugs`, `KNOWN_GRADE_SLUGS`), `loader.ts` (expansion+unicité), `build.ts`/`qa.ts` (consommation), `content/README.md`, `generation-pipeline.md` | unit : expansion/filtrage/unicité/collision, **stabilité UUID au fork (R-7)**, snapshot SQL ; `content:check` vert sur un fixture partagé                           | —                                  |
| 2   | **Data i18n grades + types + compteur public** (D-2/D-7) : migration `grades.name_en/name_ar` + backfill 29 lignes (noms officiels edunet.tn/CNP, AR relu) + RPC `get_parcours_interest_counts` (grants explicites), régénération types Supabase (inclut `is_selectable` manquant), `getParcours` élargi (slug, is_selectable, noms localisés, fallback) | migration (colonnes + backfill + RPC), `types.ts` régénéré, `dashboard.server.ts`                                                                                             | pgTAP (colonnes + backfill + non-régression + RPC : agrégat, coming_soon only, zéro user_id, grants), unit fallback locale                                          | —                                  |
| 3   | **UI arborescence drill-down** (D-3/D-5) : filtre R-1 dans `buildPrograms`, bloc Lycée = 4 cartes d'année + **nouvelle route** `/programme/lycee/$annee` (sections + compteur), sous-étape section à l'onboarding, kicker JourneyMap, copy switch (R-6), clés i18n ×3, RTL                                                                               | `program-families.ts`, `parcours-catalogue.tsx`, `routes/_public/programme.lycee.$annee.tsx` (nouveau), `onboarding.tsx`, `journey-header.tsx`, `fr/en/ar(-public).ts`        | unit : builder (années/filtre legacy/tri), composants états + compteur ; e2e onboarding+catalogue ajustés (page année) ; captures FR+AR (harness é15) ; smoke:shell | 2 ; **maquette validée (R-8 é15)** |

Stop-points exécuteur : maquette du bloc lycée non validée = STOP avant lot 3 ; toute envie de
toucher la sélectionnabilité `coming_soon` (é15 lot 10), au premium, ou aux mécaniques serveur =
hors périmètre ; divergence étude↔code = STOP et remontée.

- [x] Lot 0 — étude + amendements docs + maquette (cette PR)
- [ ] Lot 1 — pipeline `compileTo`
- [ ] Lot 2 — i18n grades + types régénérés
- [ ] Lot 3 — UI arborescence (après maquette validée)

**Coordination étude 15 (anti-collision, RISK-2)** : lot 3 é16 ne recompose PAS les pages — il
remplace le seul bloc « liste du cycle secondaire » (onboarding) et le seul bloc « grille Lycée »
(catalogue), avec sa propre maquette. Si é15 lot 8/10 passe AVANT : il intègre ces blocs tels que
spécifiés ici (cette section fait foi pour le lycée). S'il passe APRÈS : il recompose autour sans
casser le regroupement. Le journal des deux études se référence mutuellement au merge.

## 4bis. Plan de vagues contenu (campagne skills — hors lots exécuteur)

Chaque vague suit les stations du doc lycée §8 (L1 transcription → L2 base → L3 profs → L4
interactif → L5 audit), skills : `content-ecole-tn`, `prof-*-lycee`, `content-interactif`,
`content-audit`, arbitrées par `curriculum-architect`. **Toute décision de partage (⚭) ci-dessous
est un défaut de planification à CONFIRMER sur transcription L1 (R-5/D-4.b)** ; id source virtuel
= `<matière>-<année>`. Périmètre par classe : **4-5 matières cœur** (R-10, arbitrage Q-3) — le
cap gouverne l'effort d'authoring ; un tronc ⚭ déjà compilé peut porter une classe à 6 matières
visibles sans coût. **L'anglais et la philosophie de 3ème sortent du v1** (pack d'extension
v1.1, voir fin de section). Le pont linguistique (doc §4) s'applique aux matières basculées
ar→fr en 1ère sec.

**Vague A — `1ere-sec` (5 dossiers → 5 subjects)**
`math-1ere-sec`, `physique-1ere-sec`, `svt-1ere-sec` (fr — pont + `NN-pont-linguistique`),
`francais-1ere-sec`, `arabe-1ere-sec`. Ouvre `ecole-1ere-sec` dès la première matière complète
(R-8).

**Vague B — `bac-math` + `bac-sciences-exp` (7 dossiers → ~17 subjects compilés)**
Tronc ⚭×6 (authored maintenant, sert aussi la vague C) : `francais-bac`, `philosophie-bac` →
2 dossiers → 12 subjects. Dominantes dédiées (D-4.b) : compléter `math-bac-math` (existant),
`math-bac-sciences-exp`, `physique-bac-math`, `physique-bac-sciences-exp`,
`svt-bac-sciences-exp` → 5 dossiers. Classes résultantes : bac-math = math, physique, français,
philo (4 ✓) ; bac-sciences-exp = SVT, physique, math, français, philo (5 ✓). Ouvre
`concours-bac-sciences-exp` (+ ré-atteste `concours-bac-math` au seuil R-8).

**Vague C — `bac-lettres` / `bac-eco-gestion` / `bac-techniques` / `bac-info` (~8 dossiers → ~15 subjects)**
Le tronc français/philo ×6 est déjà compilé (vague B). S'ajoutent : `arabe-bac` ⚭×6 (cœur
lettres — renforcement lettres via `gradeSlugs` d3/d4), `histoire-geo-bac` ⚭ {lettres,
eco-gestion}, `economie-bac-eco-gestion`, `gestion-bac-eco-gestion`, `technologie-bac-techniques`,
`informatique-bac-info`, `math-bac-techniques` ⚭ {techniques, info} _(à confirmer L1)_,
`physique-bac-techniques`. Classes : lettres = arabe, français, philo, histoire-géo (4 ✓) ;
eco-gestion = économie, gestion, français, philo, histoire-géo (5 ✓) ; techniques = technologie,
math, physique, français, philo (5 ✓) ; info = informatique, math, français, philo (4 ✓).
4 migrations `open_*` au fil de l'eau.

**Vague D — les 6 `3eme-sec-*` (~14 dossiers → ~28 subjects)**
Tronc ⚭×6 : `francais-3eme-sec`, `arabe-3eme-sec` → 2 dossiers. Math ×4 variantes _(à
confirmer)_ : `math-3eme-sec-math`, `math-3eme-sec-sciences-exp`, `math-3eme-sec-techniques`
⚭ {techniques, info}, `math-3eme-sec-lettres` ⚭ {lettres, eco-gestion}. Physique :
`physique-3eme-sec-math` ⚭ {math, sciences-exp} _(à confirmer)_, `physique-3eme-sec-techniques`.
Dominantes : `svt-3eme-sec-sciences-exp`, `technologie-3eme-sec-techniques`,
`informatique-3eme-sec-info`, `economie-3eme-sec-eco-gestion`, `gestion-3eme-sec-eco-gestion`,
`histoire-geo-3eme-sec` ⚭ {lettres, eco-gestion}. 6 migrations `open_*` au fil de l'eau.

**Vague E — les 4 `2eme-sec-*` (~10 dossiers → ~17 subjects)**
Tronc ⚭×4 : `francais-2eme-sec`, `arabe-2eme-sec`. Math _(à confirmer)_ :
`math-2eme-sec-sciences`, `math-2eme-sec-info`, `math-2eme-sec-lettres` ⚭ {lettres, eco-services}.
Dominantes : `physique-2eme-sec-sciences` _(⚭ info à confirmer)_, `svt-2eme-sec-sciences`,
`informatique-2eme-sec-info`, `economie-2eme-sec-eco-services`, `gestion-2eme-sec-eco-services`.
4 migrations `open_*` au fil de l'eau.

**Volumétrie totale v1 : ~44 dossiers source → ~82 subjects compilés** (sans mutualisation :
~82 dossiers — **≈ 46 % d'authoring économisé**, concentré sur le tronc). **Pack v1.1 anglais**
(après le v1, ou promu par les votes) : `anglais-1ere-sec`, `anglais-2eme-sec` ⚭×4,
`anglais-3eme-sec` ⚭×6, `anglais-bac` ⚭×6 — 4 dossiers → 17 subjects, le partage rend
l'extension bon marché ; `philosophie-3eme-sec` ⚭×6 idem si le programme officiel le justifie.
L'ordre A→E est re-priorisable par les votes (D-6, arbitrage humain).

## 5. Stratégie de test

- **Unit (Vitest, co-localisés)** : lot 1 — expansion `compileTo` (ids/filtrage `gradeSlugs`/
  héritage nameFr/description), unicité globale (collision = erreur), R-9 (slug inconnu/legacy
  rejeté), **R-7 fork-stabilité** (snapshot SQL identique avant/après extraction d'une cible) ;
  lot 2 — fallback de locale (name_ar → name_fr) ; lot 3 — `lyceeYearOf`, `buildPrograms`
  (groupes, filtre legacy, tri, cycle sans lycée), états des composants (carte année, page/étape
  sections, badge, compteur, vote coming_soon seulement).
- **pgTAP** : lot 2 (colonnes + backfill 29/29 non NULL + non-régression des lignes non-école ;
  RPC compteur : agrégat exact, coming_soon uniquement, zéro `user_id` exposé, grants
  anon/authenticated) ; chaque migration `open_*` (status flip + idempotence) — le harnais
  nightly applique déjà tout sur DB fraîche.
- **e2e (TEST project)** : onboarding — le POM apprend l'étape « choisis ta section » ;
  catalogue public — le bloc Lycée expose 4 cartes d'année, la page `/programme/lycee/bac` liste
  ses sections, zéro legacy. (POMs actuels robustes : basés rôles/headings, pas de compte de
  cartes — vérifié.)
- **Contenu** : `content:check` + `content:qa:strict` verts sur fixtures partagés (lot 1) puis
  sur chaque vague ; `content-audit` (L5) vérifie par section la conformité programme des
  dossiers partagés (RISK-1).
- **Visuel/smoke** : captures FR+AR mobile+desktop du picker et du bloc catalogue (harness é15
  R-5) ; `smoke:shell` au lot 3 (bundle prod touché).

## 6. Risques & mitigations

- **RISK-1 — Fausse mutualisation** (programmes crus identiques mais différents → contenu
  infidèle pour une section). Prob. moyenne, impact haut (années d'examen). Mitigation : décision
  ⚭ prise uniquement sur transcription L1 (R-5) ; `content-audit` échantillonne par section
  compilée, pas par dossier ; fork sans perte (R-7) si découvert tard.
- **RISK-2 — Collision de lots avec é15** (mêmes fichiers onboarding/catalogue, lots 8/10 é15
  pas encore passés). Prob. haute, impact moyen. Mitigation : périmètre bloc-seulement du lot 3,
  règle d'ordre explicite (§4), rebase courts, renvois croisés dans les deux journaux.
- **RISK-3 — Qualité des noms AR des sections** (backfill lot 2). Impact confiance. Mitigation :
  annexe de backfill relue/corrigée par Mohamed avant merge (même protocole que é15 RISK-6).
- **RISK-4 — Bruit de migrations générées** (un dossier ⚭×6 régénère 6 fichiers par édition).
  Impact faible (idempotent, scopé `--subject`). Mitigation : régénérer uniquement le dossier
  touché ; les checks `Migration presence/order` couvrent déjà l'ordre.
- **RISK-5 — Dérive de duplication malgré le mécanisme** (un auteur copie un dossier au lieu de
  partager). Mitigation : doctrine D-4.b dans `generation-pipeline.md` + `content-ecole-tn`,
  `curriculum-architect` arbitre chaque plan de vague.
- **RISK-6 — Types Supabase régénérés hors-ligne** (lot 2 : `is_selectable` + `name_*`).
  Mitigation : `supabase gen types` si accès, sinon édition manuelle minimale notée (DoD §4).
- **RISK-7 — 19 classes « Bientôt » visibles longtemps** (promesse > livraison). Mitigation :
  vagues courtes, seuil R-8 honnête, option A é15 (sélectionner quand même + « ta classe
  arrive ») + vote — l'attente devient un signal exploité, pas un dead-end.

## 7. Questions ouvertes (pour l'humain)

Toutes arbitrées le 2026-07-11 — l'étude passe « validée ». Décisions consignées :

- **Q-1 — ARBITRÉ : une matière complète ouvre la section.** R-8 réécrit en conséquence
  (« complète » = tous les chapitres officiels avec cours + résumé + quiz + d1 + d2 ; d3/d4 et
  annales suivent en overlay sans bloquer). Les migrations `open_*` partent au fil de l'eau,
  section par section.
- **Q-2 — ARBITRÉ : 1ère année d'abord.** Ordre A→E confirmé (1ère sec → bac math/sc-exp →
  autres bacs → 3ème → 2ème), re-priorisable par les votes au sein des vagues.
- **Q-3 — ARBITRÉ : resserrer aux 4-5 matières vraiment cœur par classe.** Nouvelle règle R-10 ;
  §4bis réduit (anglais et philo 3ème → pack v1.1 ; histoire-géo limitée à lettres/éco ;
  informatique-1ère exclue ; technologie = matière unique des sections techniques). Liste finale
  par classe arrêtée au plan de vague.
- **Q-4 — ARBITRÉ : noms officiels sourcés CNP / edunet.tn.** L'exécuteur du lot 2 récupère la
  nomenclature ministérielle (URL citée en annexe de la migration), Mohamed relit l'AR avant
  merge.
- **Q-5 — ARBITRÉ : compteur affiché.** Nouveau D-7 (`get_parcours_interest_counts`, agrégat
  anonyme public) + affichage sur toutes les cartes sections `coming_soon`.

S'ajoute un arbitrage UX transverse (même date) : **navigation en drill-down par pages/étapes
légères** — niveau → clic → page des sections → clic → matières ; jamais de page chargée,
mobile d'abord. R-2 et D-5 réécrits en conséquence (les accordéons multi-niveaux initialement
proposés sont abandonnés).

## 8. Journal d'exécution

- 2026-07-11 — Lot 0 : étude rédigée (état des lieux vérifié sur code/migrations : L0 mergée et
  en prod, pilote `bac-math` ouvert gratuit, `is_selectable` non consommé, grades monolingues,
  pipeline dérivé de `meta.id` → mutualisation par expansion à ~40-60 lignes). Amendements
  chirurgicaux de `docs/lycee-architecture.md` (§2/§5/§6/§8) et `programme-map.md` (ligne DB
  périmée) dans la même PR. Maquette HTML de l'arborescence (onboarding + catalogue) jointe :
  [`maquette-arborescence.html`](./maquette-arborescence.html).
- 2026-07-11 — Arbitrages humains Q-1…Q-5 rendus (§7) + directive UX drill-down, statut →
  **validée**. Impacts intégrés : R-8 (une matière complète ouvre), R-10 (cap 4-5 matières
  cœur), D-5 réécrit (pages légères, nouvelle route `/programme/lycee/$annee`), D-7 ajouté
  (compteur public — RPC au lot 2), §4bis resserré (~44 dossiers → ~82 subjects, anglais/philo
  3ème → pack v1.1), maquette refaite en drill-down.
