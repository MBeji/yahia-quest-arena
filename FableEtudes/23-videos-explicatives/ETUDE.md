# Étude 23 — Vidéos explicatives dans les cours et les corrections (intégration externe d'abord)

> **Statut** : brouillon
> **Priorité** : 23 · **Valeur** : l'élève qui n'a pas compris à l'écrit voit la notion expliquée à
> l'oral, par un prof, sans quitter l'app — dans le cours ET au moment exact de l'échec (correction) ·
> **Complexité** : moyenne
> **Architecte** : Fable 5 / 2026-07-17 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : é18 (livrée — lecteur de cours structuré) ; arbitrage Q-1 (allowlist des chaînes)
> avant le lot 5 · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/xss-rendering-policy.md`,
> `docs/content-voice-and-composition.md`, `content/README.md`,
> `content-engine/references/generation-pipeline.md`

---

## 1. Contexte & objectif produit

### Le besoin

Le cours écrit a fait un bond (é18 : blocs pédagogiques, figures, cartes de révision) — mais il
reste **muet**. Or l'élève tunisien qui bloque sur une notion fait aujourd'hui une chose : il ouvre
YouTube. Un écosystème réel de chaînes gratuites couvre déjà le programme tunisien (concours 9ᵉ,
bac, collège en arabe) et le programme français voisin (lycée scientifique en français) — annexe A.
L'app peut capter ce gisement **sans produire une seule vidéo ni héberger un seul octet** : des
vidéos courtes, choisies une par une pour leur adéquation au chapitre, intégrées aux deux moments
pédagogiques qui comptent :

1. **Le cours** — une section « En vidéo » dans le lecteur de chapitre : la notion expliquée à
   l'oral complète le texte et les figures.
2. **La correction** — l'écran de fin d'exercice/quiz raté propose « revoir la notion en vidéo » :
   c'est le moment où la motivation de comprendre est maximale, et où l'app n'offre aujourd'hui
   que l'`explanation` texte par question et un lien vers le cours.

Signal de marché : le ministère de l'Éducation a lancé **EduSoutien** (mars 2026) — cours vidéo
gratuits d'enseignants supervisés, derrière login, sans embed possible. Le besoin « soutien vidéo
gratuit » est donc validé au niveau institutionnel ; l'app reste seule à l'insérer dans un
parcours gamifié avec quiz/exercices (l'annexe A note EduSoutien comme partenaire potentiel, pas
comme source intégrable).

**Vision en trois phases** (cette étude ne livre que la phase A) :

| phase | contenu                                                                                                                                                                            | statut                                               |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| **A** | **Vidéos externes gratuites** (YouTube d'abord), curées chapitre par chapitre depuis une allowlist de chaînes validée par l'humain                                                 | **cette étude, lots 1–5**                            |
| B     | **Vidéos propres** — générées par IA ou tournées par des enseignants — publiées sur une **chaîne YouTube officielle du projet** puis intégrées par le MÊME pipeline (`kind` dédié) | cadrée ici (D-9), sans lot                           |
| C     | Hébergement en propre (Supabase Storage / service de streaming)                                                                                                                    | non justifié en phase gratuite — réévalué avec l'é01 |

### L'état réel, mesuré sur le dépôt (2026-07-17)

- **Aucune vidéo nulle part** : zéro `<iframe>`, zéro référence YouTube/Vimeo dans `src/` et
  `content/` ; aucun champ vidéo dans le schéma de contenu (`src/shared/content/schema.ts`) ni
  dans les tables `chapters`/`exercises`.
- **La CSP bloquerait un embed aujourd'hui** : `buildContentSecurityPolicy`
  (`src/shared/lib/csp.ts`) n'émet pas de `frame-src`, donc `default-src 'self'` s'applique et le
  navigateur refuserait toute iframe YouTube. C'est une (bonne) décision par défaut — l'étude
  l'ouvre d'exactement un host (D-6).
- **Les points d'ancrage existent déjà** : le lecteur `LessonReader` a un emplacement naturel sous
  le cours (le précédent est `ManuelPagesSection`) ; l'écran `QuestResultScreen` porte déjà le CTA
  « revoir le cours » sur échec de quiz ; la correction de fin de session est `QuestReviewList`.
- **Le pipeline de contenu sait déjà faire** : `chapters.manuel_ref` (JSONB compilé depuis
  `chapter.json`) est le modèle exact d'un champ média compilé ; `content/misconceptions.json` est
  le modèle exact d'un registre central versionné à vocabulaire clos.

### Résultat attendu

1. Un chapitre peut déclarer 0–3 vidéos ; le lecteur public les affiche dans une section « En
   vidéo » — **façade cliquable** : rien n'est chargé depuis YouTube avant le clic de l'élève.
2. Un exercice raté (ou un quiz raté) propose la vidéo de révision de la notion sur son écran de
   résultat.
3. Chaque vidéo intégrée est passée par une **grille de pertinence pédagogique** (R-2) et une
   **validation humaine** (R-3) ; sa fiche vit dans un **registre versionné** avec date de
   vérification et statut ; un **health-check hebdomadaire** détecte les vidéos mortes.
4. Le pilote : **maths 9ᵉ** (année de concours, 13 chapitres de contenu + annales) couverte.

### Indicateurs de succès (mesurables)

| KPI                                                                      | avant | cible (fin d'étude)          |
| ------------------------------------------------------------------------ | ----- | ---------------------------- |
| Chapitres de maths 9ᵉ avec ≥ 1 vidéo validée                             | 0     | **≥ 10 / 13** (hors annales) |
| Vidéos au registre avec `verifiedOn` + visionnage intégral               | 0     | **100 % des entrées**        |
| Requêtes vers YouTube avant clic de l'élève (posture RGPD mineurs)       | —     | **0** (façade, R-4)          |
| Liens morts détectés en prod entre deux health-checks                    | —     | **≤ 7 jours** de latence     |
| Écrans d'échec (exercice/quiz) proposant une vidéo (chapitres du pilote) | 0     | 100 % des chapitres couverts |

### Ce que l'epic ne cherche PAS à faire

- **Pas d'hébergement de vidéo** (ni Supabase Storage, ni streaming) : la phase gratuite interdit
  tout coût par usage. L'embed externe est l'usage prévu par les plateformes.
- **Pas de génération IA ni de studio d'enregistrement** : la phase B est cadrée (D-9) mais aucun
  lot ne la livre.
- **Pas de vidéo par question** : la curation à l'échelle de 18 708 questions est irréaliste et
  l'`explanation` texte existe partout ; l'ancrage v1 est **chapitre** + **exercice** (D-7).
- **Pas de gamification du visionnage** : aucun XP/coin/badge lié à la vidéo, aucun gate « regarder
  pour continuer » (R-10). La vidéo est une aide, pas une mission.
- **Pas de directive `::: video` dans le markdown** en v1 : la vidéo ne traverse jamais le renderer
  de cours (D-4) — la frontière XSS de l'é18 reste intacte au caractère près.
- **Pas de player maison ni de téléchargement** : le player est celui de la plateforme hôte, dans
  son iframe.

---

## 2. Spécification fonctionnelle

### Acteurs & parcours

Le lecteur de cours est **public** (anonyme compris) ; l'écran de résultat existe en variante
connectée (`/quest/$exerciseId`) et anonyme (`/exercice/$exerciseId`). Tout ce qui suit vaut pour
les deux, sauf mention.

- **US-1** — En tant qu'élève lisant un chapitre, je vois sous le cours une section « En vidéo »
  avec 1–3 vignettes (titre, chaîne, durée) et je regarde la vidéo **dans la page**, sans être
  emmené sur YouTube.
- **US-2** — En tant qu'élève qui rate un exercice (< seuil de réussite), l'écran de résultat me
  propose **une** vidéo « revoir la notion » ; je la regarde là, puis je rejoue.
- **US-3** — En tant qu'élève qui rate le quiz de compréhension, le bandeau d'échec (qui me renvoie
  déjà vers le cours) me propose aussi la vidéo du chapitre.
- **US-4** — En tant qu'élève arabophone, les vidéos de mes matières en arabe **sont en arabe**
  (la langue d'instruction de la matière, R-8) et la section s'affiche correctement en RTL.
- **US-5** — En tant qu'élève sur mobile avec un forfait data limité, **rien n'est téléchargé
  depuis YouTube tant que je n'ai pas cliqué** ; la vignette m'annonce la durée avant que je
  m'engage.
- **US-6** — En tant que curateur (architecte/humain), je propose des vidéos par chapitre via un
  skill outillé, avec la grille de pertinence, et le registre versionné garde la trace de qui a
  vérifié quoi et quand.
- **US-7** — En tant que parent, je constate que les vidéos sont choisies une à une (pas un flux
  algorithmique), courtes, sans compte YouTube requis, et que l'app annonce qui héberge la vidéo.
- **US-8** — En tant qu'ops, je suis prévenu par une issue GitHub quand une vidéo intégrée devient
  indisponible ou non-intégrable, avec la liste des sujets à rebâtir.

**Flux UX — cours** (`/chapitre/$chapterId`) : section « En vidéo » entre la fin du cours et
`ManuelPagesSection` ; 1–3 cartes-façades (vignette YouTube en lazy-load, badge durée, nom de la
chaîne, mention hébergeur) ; clic → l'iframe remplace la vignette **au même emplacement** (ratio
16:9 réservé, zéro CLS) et démarre ; une seule vidéo active à la fois (cliquer une 2ᵉ façade
décharge la 1ʳᵉ). État vide : la section n'est pas rendue (aucun placeholder). Impression :
masquée (`print:hidden`).

**Flux UX — correction** : sur l'écran de résultat, si `scorePct < seuil` et qu'une vidéo de
révision est résolue (R-6), un bloc « 🎬 Revoir la notion en vidéo » apparaît **au-dessus** de la
liste de correction, avec la même façade. Sur un quiz raté, le bloc s'insère sous le bandeau
d'échec existant (qui garde son CTA cours). Jamais pendant une question (R-7).

### Règles métier

**Curation & registre**

- **R-1** — **Toute vidéo vit dans le registre** `content/videos.json`. Le contenu (`chapter.json`,
  `exercices/*.json`) ne référence que des **ids de registre** ; une réf inconnue est un `[error]`
  de `content:qa`. L'id est namespacé par famille de matière (`math.thales-configuration`), stable
  à vie (créer/retirer, jamais renommer).
- **R-2** — **Grille de pertinence pédagogique** (chaque critère est éliminatoire, consigné dans la
  fiche registre) :
  1. **Langue** = langue d'instruction de la matière (`subjects.content_language`) — R-8 ;
  2. **Alignement programme** : la vidéo explique la notion **du chapitre** telle que le programme
     tunisien officiel la définit (pas seulement le même thème) ; les écarts de progression ou de
     terminologie avec le cours de l'app sont notés dans `notes`, un écart de **méthode** non
     compatible élimine ;
  3. **Niveau** : vocabulaire, prérequis et rythme adaptés à l'âge du grade cible ;
  4. **Format** : une notion par vidéo ; durée cible 2–15 min (`[warn]` QA au-delà de 15 min) ;
  5. **Exactitude** : visionnage **intégral** par le curateur, zéro erreur mathématique/scientifique
     tolérée (une vidéo fausse est pire qu'aucune vidéo — même doctrine que les figures é18) ;
  6. **Notation** : cohérente avec `math-and-notation.md` (chiffres occidentaux, notation standard) ;
     une notation divergente (ex. notation anglo-saxonne de la division) élimine pour les petites
     classes, se note pour le lycée ;
  7. **Chaîne** : issue de l'**allowlist** validée (Q-1), embed activé, établie (régularité,
     ancienneté), sans placement de produit intrusif dans la vidéo.
- **R-3** — **Validation humaine avant merge** : une entrée de registre n'est mergeable qu'avec
  `verifiedOn` + `verifiedBy` renseignés après visionnage intégral. Le skill (lot 4) **propose** ;
  un humain (ou une session avec visionnage effectif outillé) **valide**. Une PR de campagne liste
  dans sa description chaque vidéo ajoutée avec son motif de sélection.
- **R-6** — **Résolution de la vidéo de révision** (écran de résultat) : `exercises.correction_video`
  si l'exercice en déclare une, sinon **la première** vidéo du chapitre, sinon rien. Résolue
  côté serveur dans le payload de session (§3), jamais calculée client depuis des données non
  chargées.
- **R-11** — **Volumétrie** : 0–3 vidéos par chapitre (`[error]` QA au-delà) ; l'ordre du tableau
  `videos` de `chapter.json` est l'ordre d'affichage, et la première est la vidéo de révision par
  défaut du chapitre (R-6).
- **R-12** — **Cycle de vie registre** : `status ∈ {active, broken, retired}`. Seule une vidéo
  `active` est compilée ; référencer une vidéo non-`active` depuis le contenu est un `[error]`
  QA (le fix : retirer la réf ou remplacer la vidéo, puis rebâtir les sujets impactés). Le
  health-check (lot 4) détecte et **propose** le passage à `broken` ; il ne modifie jamais le
  registre seul (une issue trace, une session applique).

**Rendu & vie privée**

- **R-4** — **Façade zéro-requête-tierce** : avant le clic, la carte vidéo ne déclenche **aucune
  requête hors du domaine** — le poster est **auto-hébergé** (`public/video-posters/<id>.jpg`,
  téléchargé une fois à la curation — D-11), avec repli sur une carte stylée sans image si le
  fichier manque. L'iframe n'existe dans le DOM qu'après le clic. La CSP devient la **preuve
  technique** de l'invariant (aucun host vidéo hors `frame-src`). La carte porte la mention
  hébergeur + un micro-libellé compréhensible par un enfant : « En appuyant, tu charges une vidéo
  YouTube (Google) » — c'est le pattern façade/deux-clics que la CNIL applique elle-même, le clic
  éclairé valant acte positif (transparence parent, US-7). Optimisation permise : un
  `<link rel="preconnect">` vers l'host d'embed au premier survol/touch de la façade.
- **R-5** — **Paramètres d'embed** (provider `youtube`) : host `www.youtube-nocookie.com`
  (privacy-enhanced — zéro cookie avant Play ; du localStorage tiers subsiste, d'où la façade),
  `rel=0` (depuis 2018 : suggestions limitées à la même chaîne), `playsinline=1` (mobile iOS),
  `autoplay=1` **uniquement parce que l'iframe naît du clic Play de la façade** (l'interdit des
  policies vise l'autoplay sans interaction ; sans ce param, l'élève devrait cliquer deux fois —
  ignoré par le player sur une vidéo made-for-kids, comportement accepté), `hl=<langue du
contenu>` ; `start`/`end` émis si la fiche registre définit un extrait (permet d'intégrer 3 min
  utiles d'un format long) ; `cc_load_policy=1&cc_lang_pref=<lang>` si la fiche demande les
  sous-titres. `modestbranding` est **mort depuis 2023** — ne pas l'émettre. Jamais
  `enablejsapi` (pas de contrôle JS du player en v1 → rien à ajouter à `script-src`/`connect-src`).
  Jamais `referrerpolicy="no-referrer"` (le player exige le Referer — erreur 153).
- **R-7** — **Jamais pendant une question** : aucune surface de jeu (question affichée, chrono en
  cours, donjon, duel) ne rend de vidéo. Les seuls ancrages sont le lecteur de cours et l'écran de
  résultat. (Une vidéo pendant le chrono serait à la fois une aide non tracée et une fuite
  d'attention.)
- **R-9** — **L'app ne pousse jamais vers YouTube** : pas de lien « Voir sur YouTube », pas de
  chip chaîne cliquable. Le logo/branding du player dans l'iframe (exigé par les ToS YouTube)
  suffit. Ce que l'iframe affiche après la lecture appartient à YouTube ; ce que l'app rend
  n'invite jamais à sortir.
- **R-10** — **Aucun couplage gameplay** : pas d'XP, pas de coins, pas de badge, pas de gate lié au
  visionnage ; regarder ou non ne change aucun état serveur (v1 : la seule trace est l'événement
  analytics anonyme R-13).

**i18n & RTL**

- **R-8** — **La langue de la vidéo est la langue d'instruction de la matière**
  (`subjects.content_language`) : vidéos en arabe pour le primaire/collège (y c. maths/physique/SVT
  collège), en français pour les matières francophones du lycée, dans la langue cible pour les
  thèmes langues. `[error]` QA si `lang` de la vidéo ≠ `contentLanguage` du sujet qui la
  référence. Les thèmes trilingues (culture-generale, muscle-cerveau) référencent des vidéos
  différentes par sujet-frère — jamais « la même vidéo pour les trois ».
- **R-13** — Chrome de la section en locale UI (`t.quest.video*`, fr/en/ar) ; titre/chaîne de la
  vidéo dans la langue du **contenu** (donnée du registre), affichés avec `dir` auto. La façade
  entière est RTL-safe (badge durée, icône play indépendante du sens de lecture).
- **R-14** — **Conformité ToS YouTube** (l'embed sans clé reste soumis aux API Services Terms +
  Developer Policies) : ne jamais recouvrir/modifier le player une fois chargé (la façade
  s'arrête au moment où l'iframe naît — c'est l'overlay de consentement explicitement toléré) ;
  player ≥ 200×200 px (le 16:9 pleine colonne y est très au-dessus) ; Referer intact ; pas de
  lecture en arrière-plan ; le statut **made-for-kids** de chaque vidéo est relevé à la curation
  et consigné dans la fiche registre (obligation développeur), et l'app est **auto-désignée
  child-directed** auprès de Google (action ops — Q-3).

### i18n (clés)

`t.quest.videoSectionTitle` (« En vidéo » / "On video" / « بالفيديو »), `t.quest.videoPlay`
(aria : « Regarder : {title} ({m} min) »), `t.quest.videoHostedBy` (« Vidéo hébergée par
{host} »), `t.quest.videoReviewTitle` (« Revoir la notion en vidéo »), `t.quest.videoDuration`
(« {m} min »). Chiffres de durée en chiffres occidentaux partout (règle notation globale).

### Hors périmètre (v1)

- Vidéo par **question** ; vidéos dans donjon/duels ; sous-titres imposés ; playlist/chapitrage.
- Suivi par élève du visionnage (table dédiée, reprise de lecture) — réévalué avec l'é04/é07 si le
  besoin « révision guidée » le justifie.
- Signalement dédié « cette vidéo a un problème » : le launcher bug-report global couvre le besoin
  v1 ; une extension de `content_reports` au média est notée pour plus tard.
- Directive `::: video` inline dans `cours.md` (D-4, extension future).
- Providers autres que YouTube **dans le code** : le registre est extensible (`provider`), mais la
  v1 n'implémente que `youtube` (l'allowlist Q-1 dira si un 2ᵉ provider mérite son intégration).

---

## 3. Architecture technique (décisions fermées)

### Modèle de données

**Aucune table nouvelle.** Deux colonnes JSONB additives, même pattern que `chapters.manuel_ref`
(compilées depuis les fichiers, jamais éditées à la main) :

```sql
-- Migration additive (lot 1) — s'applique avant tout code qui la lit (DoD §7).
ALTER TABLE public.chapters
  ADD COLUMN IF NOT EXISTS videos jsonb NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE public.exercises
  ADD COLUMN IF NOT EXISTS correction_video jsonb; -- NULL = pas de vidéo dédiée

COMMENT ON COLUMN public.chapters.videos IS
  'Compiled display objects of the chapter''s curated explainer videos (étude 23). Source of truth: content/videos.json + chapter.json refs. Never hand-edited.';
COMMENT ON COLUMN public.exercises.correction_video IS
  'Compiled display object of the exercise''s dedicated correction video (étude 23), overriding the chapter fallback on the result screen.';
```

Pas de RLS/grants nouveaux : les colonnes vivent sur des tables déjà couvertes (SELECT public via
les politiques existantes) et ne portent **aucune donnée sensible** (tout est public par nature —
le contenu compilé d'un registre versionné).

**Shape compilée** (ce que le client reçoit — un sous-ensemble d'affichage du registre) :

```jsonc
// chapters.videos — tableau ordonné (0–3)
[
  {
    "id": "math.thales-configuration", // id registre (stable — analytics, poster, debug)
    "provider": "youtube",
    "videoId": "AbCdEfGhIjK", // ^[A-Za-z0-9_-]{11}$ — SEULE donnée utilisée pour bâtir l'URL
    "title": "Théorème de Thalès — la configuration",
    "channel": "Maths et tiques",
    "lang": "fr",
    "durationSec": 480, // durée de l'extrait si startSec/endSec définis
    "startSec": 312, // absent si vidéo entière
    "endSec": 540,
  },
]
// exercises.correction_video — même objet, singulier, nullable
```

**Volontairement absents de la shape compilée** : `channelUrl`, `notes`, `verifiedBy`… — aucune
URL libre n'atteint le client (D-10) ; la fiche complète reste dans le registre versionné.

### Contenu (fichiers) — source de vérité

**`content/videos.json`** (nouveau registre central, pattern `misconceptions.json`) :

```jsonc
{
  "math.thales-configuration": {
    "provider": "youtube", // enum fermé, v1: "youtube"
    "videoId": "AbCdEfGhIjK", // regex stricte par provider
    "title": "Théorème de Thalès — la configuration", // langue = lang
    "channel": "Maths et tiques",
    "channelUrl": "https://www.youtube.com/@MathsetTiques", // registre seulement, jamais compilé
    "lang": "fr", // ∈ {fr, en, ar}
    "durationSec": 480,
    "kind": "teacher", // teacher | official | ai  (phase B: ai/official — D-9)
    "grades": ["9eme-base"], // hints de curation (KNOWN_GRADE_SLUGS), informatif
    "notions": ["configuration de Thalès", "rapports de longueurs"],
    "competencies": ["math.geo.thales-direct"], // OPTIONNEL — ids du registre é07, vérifiés par QA
    "startSec": 312, // OPTIONNEL — extrait d'un format long (émis en ?start=)
    "endSec": 540, // OPTIONNEL — fin d'extrait (émis en ?end=) ; endSec > startSec (QA)
    "madeForKids": false, // relevé à la curation (R-14) ; true = le player ignore l'autoplay
    "addedOn": "2026-07-20",
    "verifiedOn": "2026-07-20", // R-3 : requis pour status active
    "verifiedBy": "Mohamed",
    "status": "active", // active | broken | retired (R-12)
    "notes": "Notation identique au cours ; aucune divergence de méthode.",
  },
}
```

Le **poster** de la façade est un fichier conventionnel `public/video-posters/<id registre>.jpg`
(téléchargé une fois à la curation depuis la vignette publique de la vidéo — D-11) ; s'il manque,
la façade dégrade en carte stylée sans image. Quand un extrait est défini (`startSec`), la durée
affichée est celle de l'**extrait**, pas de la vidéo.

**`chapter.json`** gagne un champ optionnel :

```jsonc
{ "videos": ["math.thales-configuration", "math.thales-erreurs-classiques"] }
```

**`exercices/*.json`** gagne un champ optionnel :

```jsonc
{ "correctionVideo": "math.thales-erreurs-classiques" }
```

**Validation (zod, `src/shared/content/schema.ts`)** : `videoRegistrySchema`
(record id→entrée ; id namespacé « famille.slug » même style que les tags é04 ; `videoId` validé
par regex du provider ; dates ISO ; `status` enum), `chapterMetaSchema.videos`
(`z.array(videoRefSchema).max(3)`), `exerciseSchema.correctionVideo` optionnel. `content:qa`
ajoute : réf inconnue → `[error]` ; réf vers non-`active` → `[error]` ; `lang` ≠
`contentLanguage` du sujet → `[error]` ; `durationSec` > 900 → `[warn]` ; `competencies` inconnues
→ `[error]` (réutilise le chargeur de registres é07) ; entrée `active` sans `verifiedOn` →
`[error]` ; `endSec` sans `startSec` ou `endSec <= startSec` → `[error]`.

**Compilation (`sql-builder.ts`)** : résout les refs → objets d'affichage (shape ci-dessus) dans
l'UPSERT `chapters` (colonne `videos`) et `exercises` (colonne `correction_video`), même
mécanique idempotente que `manuel_ref`. Une vidéo passée non-`active` disparaît de la DB **au
rebuild des sujets qui la référencent** (l'issue du health-check les liste, R-12/US-8).

### Serveur

Aucun RPC nouveau, aucune logique SQL. Deux extensions de lecture :

- **`getChapterLesson`** (`quest.server.ts`) : le SELECT chapitre ajoute `videos` ; le type
  `LessonReaderChapter` gagne `videos: CompiledVideo[] | null`.
- **Payload de session d'exercice** (connecté `startExerciseSession` + variante anonyme) : ajoute
  `correctionVideo: CompiledVideo | null`, résolu serveur en une passe : `exercises
.correction_video ?? chapters.videos->0 ?? null` (R-6). Aucune donnée sensible (contenu public de
  révision) ; le fait qu'il voyage dès le début de session ne fuit rien (R-7 le garde hors des
  écrans de jeu).

Zod côté serveur : la shape compilée est re-validée par un `compiledVideoSchema` partagé avant
d'être renvoyée (défense en profondeur contre un JSONB inattendu — même posture défensive que les
RPC tolérés-manquants).

### Client

**`src/features/quest/components/video-embed.tsx`** (nouveau, ~120 lignes, zéro dépendance) :

```tsx
export type CompiledVideo = {
  id: string;
  provider: "youtube";
  videoId: string;
  title: string;
  channel: string;
  lang: "fr" | "en" | "ar";
  durationSec: number;
  startSec?: number;
  endSec?: number;
};
export function VideoEmbed({
  video,
  context,
}: {
  video: CompiledVideo;
  context: "lesson" | "result";
});
```

- **Façade** : `<button>` (ratio 16:9 réservé) — poster **local**
  `/video-posters/${video.id}.jpg` (`loading="lazy"`, `alt=""`, repli stylé sans image sur
  `onError` — D-11), icône play maison, badge durée, ligne titre + chaîne +
  `t.quest.videoHostedBy` + micro-libellé de chargement (R-4). `aria-label` complet (R-13).
  Un id qui ne matche pas `^[A-Za-z0-9_-]{11}$` rend `null` (défense en profondeur — le schéma
  l'a déjà garanti). Au premier survol/`touchstart` : `<link rel="preconnect">` vers
  `https://www.youtube-nocookie.com` (warm-up, zéro donnée).
- **Au clic** : remplace la façade par
  `<iframe src="https://www.youtube-nocookie.com/embed/${videoId}?autoplay=1&rel=0&playsinline=1&hl=${lang}[&start=…][&end=…][&cc_load_policy=1&cc_lang_pref=…]" title={title} allow="autoplay; encrypted-media; picture-in-picture; fullscreen" />`
  (R-5 — referrer par défaut conservé), focus déplacé sur l'iframe ; émet l'événement analytics
  (observabilité).
- L'URL est **construite par template depuis des champs validés** — jamais une URL venue des
  données (D-10).

**`src/features/quest/components/chapter-videos-section.tsx`** (nouveau, ~60 lignes) : la section
« En vidéo » du lecteur — titre, cartes `VideoEmbed`, « une seule iframe active à la fois »
(état local `activeId`), `print:hidden`, rendu `null` si 0 vidéo. Insérée dans `LessonReader`
au-dessus de `ManuelPagesSection`.

**Écran de résultat** (`QuestResultScreen`) : nouveau bloc « revoir en vidéo » — rendu si
`!passed && correctionVideo` (exercice) ou sous le bandeau d'échec quiz (US-3) ; réutilise
`VideoEmbed` avec `context="result"`.

**CSP** (`src/shared/lib/csp.ts`) — la directive nouvelle, un seul host :

```ts
"frame-src https://www.youtube-nocookie.com",
```

(`img-src` est **inchangé** — les posters sont servis par `'self'` (D-11) ; `connect-src`
inchangé — pas d'`enablejsapi`, R-5.) Le commentaire du fichier documente que le frame n'est
monté qu'après une action utilisateur (façade) : la CSP est la preuve qu'aucun autre host vidéo
ne peut apparaître.

### Sécurité & anti-triche

- **La frontière XSS de l'é18 n'est pas touchée** : ni `renderLesson` ni `ALLOWED_TAGS` ne
  changent — `iframe` n'entre **jamais** dans le HTML assaini ; toute la vidéo est du JSX (D-4).
  `docs/xss-rendering-policy.md` gagne un paragraphe « Video embed path » qui l'acte.
- **Aucune URL libre côté client** (D-10) : le client reçoit `provider` (enum) + `videoId`
  (regex), l'URL est un template du code. Un registre compromis ne peut au pire pointer que vers
  une **autre vidéo YouTube** — jamais vers un host arbitraire (la CSP `frame-src` le garantit en
  dernière ligne).
- **Anti-triche** : R-7 (aucune vidéo pendant le jeu) ; aucune clé de réponse ne transite par ces
  champs ; `correction_video` est de la révision, pas de la réponse.
- **Vie privée (mineurs)** : posture « façade deux-clics » de doctrine CNIL — **zéro requête
  tierce avant le clic** (posters locaux, D-11) ; host nocookie ensuite (zéro cookie avant Play ;
  le localStorage tiers post-chargement est la raison d'être de la façade) ; libellé de la carte
  compréhensible par un enfant (R-4) ; l'embed YouTube est documenté dans la politique de
  confidentialité à destination des parents. Résiduel < 15 ans : RISK-8.
- **Conformité plateforme (R-14)** : façade = overlay de consentement toléré par les Developer
  Policies (jamais d'overlay une fois le player chargé) ; player ≥ 200×200 ; Referer conservé ;
  statut made-for-kids relevé par vidéo à la curation ; self-désignation child-directed du site
  (Q-3).

### Intégrations & env

**Aucune variable d'environnement nouvelle**, aucun secret, aucune API key : l'embed iframe et
l'endpoint public oEmbed (health-check) n'en demandent pas. `docs/environment-variables.md`
inchangé.

### Observabilité

- **Client** : événement GA4 `video_open` `{ video_id, context: "lesson"|"result", subject_id }`
  via un helper no-op-safe dans `analytics.ts` (même philosophie : jamais de throw, inerte hors
  prod). C'est LA métrique produit de l'étude (taux d'usage réel avant d'étendre la campagne).
- **Serveur** : rien de nouveau (lectures existantes). Le health-check (lot 4) logge en CI et
  ouvre/actualise une issue `video-health` (pattern `content-audit.yml`).

### Décisions d'architecture (ADR)

- **D-1 — Embed externe d'abord, zéro hébergement.** L'app intègre des vidéos publiées par leurs
  auteurs sur leur plateforme, via le mécanisme officiel (iframe embed). Coût zéro, droits clairs
  (l'embed est l'usage prévu ; on ne copie, ne télécharge, ne rediffuse rien), réversible.
  _Rejeté_ : héberger (coût, droits, pipeline d'assets — hors phase gratuite) ; télécharger/proxyfier
  (violation ToS).
- **D-2 — Un registre central versionné** (`content/videos.json`), pas des URLs éparpillées dans
  les fichiers de chapitres. La curation est un **actif** : fiche par vidéo (qui a vérifié, quand,
  quoi), dédup naturelle (une vidéo réutilisée par N chapitres = 1 entrée), health-check en un
  point, remplacement en un point. _Rejeté_ : URL inline dans `chapter.json` — invérifiable,
  dupliquée, indistinguable d'un champ libre.
- **D-3 — Compilation dénormalisée en JSONB** (`chapters.videos`, `exercises.correction_video`),
  pas de table `videos`. Le besoin est du **read-only d'affichage** joint au chapitre/exercice ;
  le pattern existe (`manuel_ref`) ; zéro table = zéro RLS/grant/pgTAP nouveau. Une table ne
  s'imposera que si un besoin **par élève** (progression de visionnage) apparaît — hors périmètre.
- **D-4 — La vidéo ne traverse jamais le renderer markdown.** Pas de directive `::: video` en v1,
  pas d'`iframe` dans `ALLOWED_TAGS`, rien dans `dangerouslySetInnerHTML` : la section vidéo est
  du JSX pur sous le cours. La frontière XSS durcie par l'é18 reste intacte ; et une vidéo
  externe explique une **notion de chapitre**, pas une ligne précise — l'ancrage fin n'apporterait
  presque rien pour un risque et un coût réels. _Extension future_ : une directive
  `::: video <ref>` émettant un placeholder inerte hydraté par le lecteur — à n'ouvrir que si la
  phase B (vidéos propres, sectionnées) le justifie.
- **D-5 — Façade maison, pas de dépendance.** ~120 lignes de JSX remplacent `lite-youtube-embed` :
  budget bundle tenu, pas de web component à styler, comportement exact voulu (une seule active,
  analytics, i18n/RTL, a11y). Même doctrine que le renderer (« le maison reste maison », é18
  RISK-7).
- **D-6 — CSP : ouvrir exactement un host** (`frame-src https://www.youtube-nocookie.com`).
  L'ajout d'un provider = une décision de code revue (PROVIDERS + CSP), jamais une donnée.
- **D-7 — Ancrage chapitre + exercice, pas question.** La correction par question reste
  l'`explanation` texte (universelle, déjà là) ; la vidéo est la **notion** — l'écran de résultat
  la propose une fois, au bon moment. 18 708 vidéos par question est un non-objectif définitif.
- **D-8 — La langue de la vidéo suit la langue d'instruction de la matière** (R-8) — c'est la
  même règle que le contenu école monolingue ; une vidéo dans « l'autre » langue casserait la
  terminologie d'examen que l'app enseigne.
- **D-9 — Phase B (vidéos IA / enseignants) : héberger sur une chaîne YouTube officielle du
  projet, pas en propre.** Le jour où des vidéos maison existent (générées ou tournées), elles
  sont publiées sur la chaîne du projet et intégrées par le MÊME pipeline (`kind: "ai"|"official"`,
  provider youtube) : zéro infra nouvelle, modération = contrôle de la chaîne, branding gratuit,
  et le player/la CSP/le registre ne bougent pas. Argument décisif découvert en recherche : une
  chaîne membre du Partner Program avec monétisation désactivée est le **seul** cas où YouTube
  garantit zéro pub sur l'embed — la chaîne officielle est donc aussi la seule route « zéro pub »
  crédible à terme (RISK-2). L'hébergement en propre (Storage/streaming — ou un PeerTube
  auto-hébergé, sans pub) reste le plan C, conditionné à la sortie de la phase gratuite (é01).
- **D-10 — Le client ne reçoit jamais d'URL, seulement des identifiants validés.** `provider`
  (enum) + `videoId` (regex par provider) → URL par template dans le code. Supprime toute la
  classe « lien malveillant injecté par la donnée ».
- **D-11 — Posters auto-hébergés, téléchargés une fois à la curation.** Le skill de curation
  enregistre la vignette publique de la vidéo dans `public/video-posters/<id>.jpg` (fichier
  versionné, ~15–30 Ko ; nommé par l'id **registre**, pas l'id YouTube). C'est ce qui rend la
  façade **réellement** zéro-requête-tierce (la vignette `i.ytimg.com`, pattern par défaut des
  façades open source, est déjà une requête vers Google avant tout clic — incompatible avec la
  posture mineurs). Repli sans image si le fichier manque : une façade ne casse jamais.
  _Rejeté_ : vignette `i.ytimg.com` lazy (requête tierce pré-clic) ; téléchargement au build
  (réseau dans le build = fragile + non déterministe) ; pas d'image du tout (engagement moindre,
  alors que le coût du poster est nul). Ne contredit pas « SVG seul » (é18 D-8) : cette doctrine
  vise le contenu pédagogique versionné dans `content/`, pas une image de courtoisie d'UI.

---

## 4. Plan d'exécution en lots

| lot   | contenu (résumé)                                      | fichiers/objets créés                                                                                                                                                    | tests exigés                                        | dépend de |
| ----- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------- | --------- |
| **1** | Socle données : registre + schéma + build + migration | `content/videos.json` (vide), `schema.ts`, `loader.ts`, `sql-builder.ts`, `scripts/content/qa*.ts`, migration additive                                                   | unit schema/builder/QA, pgTAP suite existante verte | —         |
| **2** | UI cours : façade + section + CSP + i18n + analytics  | `video-embed.tsx` (n), `chapter-videos-section.tsx` (n), `lesson-reader.tsx`, `quest.server.ts` (SELECT), `csp.ts`, `analytics.ts`, i18n, `docs/xss-rendering-policy.md` | unit (façade = cœur), `smoke:shell`                 | 1         |
| **3** | UI correction : écran de résultat (exercice + quiz)   | `quest-result-screen.tsx`, payloads de session (connecté + anon), `exercise-player.tsx`                                                                                  | unit + e2e auth (échec → bloc vidéo)                | 1, 2      |
| **4** | Outillage curation : skill + health-check hebdo       | `.claude/skills/content-videos/` (n), `scripts/content/check-videos.mjs` (n), `.github/workflows/video-health.yml` (n), `generation-pipeline.md` (carte)                 | unit du checker (fixtures oEmbed)                   | 1         |
| **5** | Campagne pilote : maths 9ᵉ                            | `content/videos.json` (entrées validées), `content/math/*/chapter.json`, migration `content:build -- --subject math`                                                     | `content:check` + `content:qa:strict`               | 2, 4, Q-1 |

- [ ] **Lot 1 — Le socle données.**
      _Périmètre_ : R-1, R-11, R-12 côté validation ; migration SQL ci-dessus (§3) ;
      `videoRegistrySchema` + champs `chapter.videos` / `exercise.correctionVideo` ; résolution +
      compilation JSONB dans `sql-builder.ts` ; contrôles `content:qa` listés en §3 (réf inconnue,
      non-active, langue, durée, compétences, `verifiedOn`). Le registre est **livré vide** (`{}`) ;
      les fixtures de test portent les cas. Aucune UI.
      _Acceptation_ : `npm run verify` + `content:check`/`content:qa:strict` verts sur le corpus
      réel (inchangé) ET sur les fixtures ; la migration passe la suite pgTAP (fresh DB) ; un
      `content:build -- --subject <x>` d'un sujet SANS vidéos produit un SQL **identique à
      l'existant** modulo la colonne (no-op prouvé sur un sujet témoin).
      _Stop-point_ : ne pas toucher au client, ni à la CSP, ni au moindre skill.

- [ ] **Lot 2 — La section vidéo du cours.**
      _Périmètre_ : US-1, US-4, US-5, US-7 ; R-4, R-5, R-9, R-13, R-14 ; D-5, D-6, D-11 (côté
      rendu : poster local + repli). `VideoEmbed` + `ChapterVideosSection` + insertion
      `LessonReader` ; `getChapterLesson` SELECT `videos` ; `frame-src` dans `csp.ts` ; clés
      i18n (libellé façade compris) ; événement `video_open` ; mise à jour
      `docs/xss-rendering-policy.md` (« Video embed path » : JSX pur, jamais le renderer) ; texte
      proposé pour la politique de confidentialité (remis à Mohamed, Q-3b).
      _Acceptation_ : les tests unit prouvent **l'invariant façade** — aucun `<iframe>` ni aucune
      URL d'un host tiers dans le DOM avant clic, `src` exacte (`youtube-nocookie` + params R-5,
      y compris `start`/`end`) après clic, une seule active à la fois, repli sans poster propre,
      `null` sur `videoId` invalide ; `smoke:shell` vert (lecteur public = bundle prod) ; RTL
      vérifié sur un chapitre arabe de fixture.
      _Stop-point_ : ne pas toucher aux écrans de résultat (lot 3) ; ne pas ajouter de vidéo réelle
      au registre (lot 5).

- [ ] **Lot 3 — La vidéo de correction.**
      _Périmètre_ : US-2, US-3 ; R-6, R-7 ; D-7. Payloads de session étendus (`correctionVideo`
      résolu serveur, variantes connectée ET anonyme) ; bloc « revoir en vidéo » de
      `QuestResultScreen` (échec exercice + échec quiz) ; `compiledVideoSchema` partagé.
      _Acceptation_ : unit — le bloc apparaît sur échec avec vidéo résolue, jamais sur réussite,
      jamais pendant une question (le player n'importe pas `VideoEmbed` hors résultat) ; la
      résolution R-6 (exercice > chapitre > rien) testée aux trois niveaux ; une spec e2e auth :
      échouer un exercice d'un chapitre à vidéo (seed TEST) → le bloc est visible.
      _Stop-point_ : aucun changement aux RPC de scoring ; aucun XP/état lié à la vidéo (R-10).

- [ ] **Lot 4 — L'outillage de curation.**
      _Périmètre_ : US-6, US-8 ; R-2, R-3, R-12, R-14 côté outillage. Skill `content-videos`
      (SKILL.md : workflow proposer→visionner→consigner, la grille R-2 opérationnalisée, le
      téléchargement du poster (D-11), le relevé made-for-kids/région — via la Data API v3 si une
      clé **locale et optionnelle** est fournie au poste de curation, sinon manuel ;
      `references/video-sources.md` = l'allowlist arbitrée en Q-1 + le panorama annexe A) ;
      `scripts/content/check-videos.mjs` (pour chaque entrée `active` : GET oEmbed
      `https://www.youtube.com/oembed?url=…&format=json`, throttlé ~1 req/s — 200 =
      vivante+embeddable, 401 = embed désactivé, 403 = privée, 404 = supprimée, 400 = id
      malformé ; sortie JSON + exit code) ; workflow `video-health.yml` (hebdo, ouvre/actualise
      une issue listant les vidéos mortes ET les sujets à rebâtir, pattern `content-audit.yml`,
      skip propre sans réseau) ; ajout du skill à la carte `generation-pipeline.md`.
      _Acceptation_ : checker testé sur fixtures (200/400/401/403/404/timeout) ; le workflow
      tourne en `workflow_dispatch` à vide (registre vide → no-op vert). L'endpoint oEmbed est
      best-effort (pas de SLA) : un échec réseau produit `unknown`, jamais un faux `broken`.
      _Stop-point_ : le checker ne modifie **jamais** `videos.json` (R-12) ; pas de campagne ;
      aucune clé API requise par l'app, la CI ou le workflow (la Data API reste un outil de
      poste de curation).

- [ ] **Lot 5 — Campagne pilote : maths 9ᵉ.**
      _Périmètre_ : remplir le registre pour maths 9ᵉ depuis l'allowlist Q-1 (cible : ≥ 10 des 13
      chapitres de contenu ; les annales n'ont pas de vidéo propre), poster téléchargé par vidéo
      (D-11), référencer dans les `chapter.json`, `correctionVideo` sur les boss des chapitres de
      géométrie si une vidéo « erreurs classiques » existe ; visionnage intégral + fiche complète
      par vidéo (R-2, R-3) ; rebuild `content:build -- --subject math` (jamais nu).
      _Attention langue (R-8)_ : maths 9ᵉ est un sujet **arabophone** — les chaînes candidates
      sont celles du volet AR/TN de l'annexe A (Devoir.TN/Tadris, chaîne nationale نوفيام, Faouzi
      El Gharbi, Sala7li…), PAS les chaînes françaises ; si le gisement arabe s'avère trop mince
      chapitre par chapitre, on documente les trous plutôt que d'y mettre du français (l'écart
      remonte à Mohamed, jamais tranché en silence).
      _Acceptation_ : KPI §1 atteints sur le pilote ; `content:qa:strict` vert ; la PR liste
      chaque vidéo avec chaîne, durée, notion, motif (R-3) ; DoD §7 (la migration de contenu
      s'applique au merge).
      _Stop-point_ : **une seule matière**. L'extension (6ᵉ, bac, collège…) sort de l'étude →
      backlog contenu, une matière par session (standard « profondeur de génération »).

**Après le lot 5** : campagne de fond hors étude, priorité aux années de concours puis au gisement
réel constaté (annexe A) : maths 6ᵉ → sciences 9ᵉ → bac (math/physique fr) → collège (ar). La
phase B (chaîne officielle, vidéos IA/enseignants) fera l'objet d'une étude ou d'un avenant quand
Mohamed décidera de produire (Q-4).

---

## 5. Stratégie de test

**Unit (Vitest, co-localisés)** — le cœur du gate :

- `schema.test.ts` (étendu) : registre valide/invalide (id malformé, `videoId` hors regex,
  status inconnu, dates), refs chapitre/exercice, bornes R-11.
- `sql-builder.test.ts` (étendu) : compilation des refs → JSONB (shape exacte, champs registre
  exclus D-10), exclusion des non-`active`, no-op sur sujet sans vidéos.
- `qa-checks.test.ts` (étendu) : chaque contrôle §3 sur fixtures minimales.
- `video-embed.test.tsx` (nouveau) — **les invariants de l'étude** : pas d'iframe NI d'URL de
  host tiers dans le DOM avant clic (le poster est `'self'`) ; `src` post-clic exacte (host
  nocookie, `rel=0`, `playsinline=1`, `hl`, `start`/`end` si extrait) ; `title`/`aria-label` ;
  repli sans poster ; `null` si `videoId` invalide ; RTL.
- `chapter-videos-section.test.tsx` : 0 vidéo → `null` ; une seule iframe active ; ordre.
- `quest-result-screen.test.tsx` (étendu) : bloc vidéo sur échec seulement ; quiz raté → bloc
  sous le bandeau ; réussite → absent.
- `csp.test.ts` (étendu) : `frame-src` présent, host exact, une seule occurrence.
- `check-videos.test.ts` (nouveau) : mapping oEmbed 200/400/401/403/404/timeout → statuts
  proposés (`ok`/`broken`/`unknown`).

**pgTAP** : rien de spécifique (aucune logique SQL) ; la suite existante prouve que la migration
additive s'applique sur DB fraîche.

**Gate contenu** : `content:check` + `content:qa:strict` verts à chaque lot ; le lot 5 est le
premier à faire tourner les contrôles sur des données réelles.

**`smoke:shell` — non négociable** (lots 2–3) : le lecteur public et l'écran de résultat sont du
bundle prod ; c'est la classe de code de l'incident 2026-07-01.

**e2e (Playwright)** : lot 2 — les specs publiques existantes du lecteur restent vertes (un
chapitre sans vidéo ne rend rien de nouveau) ; lot 3 — une spec `authed-chromium` : échec sur un
exercice seedé avec vidéo → bloc visible, clic → iframe présente avec `src` nocookie (on asserte
l'attribut, on n'attend jamais le player YouTube — pas de dépendance réseau externe dans le run).

**Non-régression** : lots 1–4 ne modifient **aucun** fichier sous `content/` (le diff le prouve) ;
les tests XSS de `markdown.test.ts` ne sont pas touchés (le renderer non plus).

---

## 6. Risques & mitigations

- **RISK-1 — Vidéo supprimée/privée/embed coupé après intégration.** _Probabilité certaine à
  l'échelle du temps / impact moyen._ Mitigation : health-check hebdo oEmbed (lot 4) + statut
  `broken` + issue listant les sujets à rebâtir (R-12) ; la façade est bâtie depuis le registre
  (titre/durée), donc même morte elle ne casse pas la page — elle affiche un player YouTube
  « vidéo indisponible » au pire pendant ≤ 7 jours.
- **RISK-2 — Publicités YouTube devant/dans la vidéo.** _Probabilité forte / impact image._
  État de fait vérifié : impossible de désactiver la pub côté embed ; une chaîne **hors** Partner
  Program peut recevoir des pubs imposées par YouTube (ToS 2020) ; le seul cas garanti sans pub
  est une chaîne **YPP monétisation désactivée** ; une vidéo made-for-kids ne reçoit que des pubs
  **non personnalisées**. Mitigation : trade-off assumé et validé par l'humain (Q-2) ; à notion
  égale, préférer les sources sans pub (Khan Academy — ONG sans pub, chaîne du ministère) ;
  transparence façade ; et la route « zéro pub » à terme est la chaîne officielle YPP
  monétisation-off (D-9).
- **RISK-3 — Fuite d'attention vers YouTube** (suggestions de fin de lecture). _Probabilité
  moyenne / impact produit._ Mitigation : `rel=0` (suggestions restreintes à la même chaîne),
  lecture in-page (jamais de navigation), aucun lien sortant (R-9), vidéos courtes une-notion.
  Résiduel assumé : l'écran de fin d'une iframe YouTube appartient à YouTube.
- **RISK-4 — Une vidéo validée devient inadaptée** (l'auteur la remplace/édite, ou dérive de la
  chaîne). _Probabilité faible / impact confiance._ Mitigation : allowlist de chaînes établies
  (Q-1) ; `verifiedOn` date la validation ; le balayage `content-audit` planifié peut re-visionner
  par échantillon ; signalement utilisateur (bug-report) en filet.
- **RISK-5 — Géo-blocage ou indisponibilité en Tunisie** d'une plateforme/vidéo. _Probabilité
  faible sur YouTube, réelle ailleurs (ex. Lumni)._ Mitigation : YouTube seul en v1 (D-6) ;
  l'allowlist note la disponibilité TN ; vérification terrain par Mohamed (Q-1) ; oEmbed ne voyant
  pas le géo-blocage, le signalement utilisateur reste le filet.
- **RISK-6 — Dérive de périmètre vers « plateforme vidéo »** (playlists, comptes, uploads).
  _Probabilité moyenne (enthousiasme produit) / impact focus._ Mitigation : non-objectifs §1
  explicites ; phase B verrouillée derrière Q-4 (décision humaine) ; R-10 interdit tout couplage
  gameplay qui rendrait la vidéo « obligatoire ».
- **RISK-7 — Poids/perf du lecteur public.** _Probabilité faible._ Façade = 1 `<img>` locale lazy
  - JSX ; aucune dépendance ; iframe seulement post-clic ; ratio réservé (zéro CLS) ;
    `build:check` (budgets) au gate comme toujours.
- **RISK-8 — Conformité traceurs pour les < 15 ans** (consentement conjoint parent/enfant exigé
  par l'art. 45 LIL pour les traceurs non essentiels). _Probabilité de contestation faible /
  impact conformité._ Mitigation : la façade **est** la mesure — aucun traceur tiers avant un
  acte positif éclairé par un libellé adapté à l'âge (doctrine CNIL du deux-clics, appliquée par
  la CNIL elle-même) ; documentation parents dans la politique de confidentialité ;
  self-désignation child-directed (Q-3) qui coupe la personnalisation côté Google. Résiduel
  assumé en phase gratuite ; à revisiter si un jour l'app collecte au-delà (é01).

---

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — L'allowlist initiale des chaînes** (la décision de curation n° 1). L'annexe A propose,
  par cycle × matière × langue, les chaînes candidates avec leur fiche (volume, durée, alignement
  programme tunisien, risques). À valider/amender par Mohamed — idéalement en vérifiant depuis la
  Tunisie la disponibilité réelle. Sans Q-1, les lots 1–4 (code) passent, le lot 5 (campagne)
  attend.
- **Q-2 — Acceptation des publicités YouTube** (RISK-2) : l'embed gratuit implique des pubs
  possibles avant/pendant les vidéos, y compris pour des mineurs. Les accepter (recommandation :
  oui, en phase gratuite, avec mention hébergeur visible) ou restreindre l'allowlist aux chaînes
  constatées à faible densité de pub ?
- **Q-3 — Actions ops de conformité (à faire une fois, hors code)** : (a) **self-désigner l'app
  child-directed** auprès de Google (outil officiel lié aux Developer Policies — R-14) ; (b)
  ajouter le paragraphe « vidéos YouTube intégrées » à la politique de confidentialité (page
  parents). Les deux sont des actions de compte/contenu que seul Mohamed peut faire ;
  l'exécuteur du lot 2 fournit le texte proposé du paragraphe.
- **Q-4 — Phase B (vidéos propres)** : créer dès maintenant la chaîne YouTube officielle du projet
  (D-9) pour y publier plus tard les vidéos IA/enseignants — ou attendre le bilan d'usage du
  pilote (`video_open`) ? Recommandation : attendre le bilan ; créer la chaîne est trivial le
  moment venu, et le registre (`kind`) est déjà prêt.
- **Q-5 — Dialecte au primaire (matières en arabe)** : une chaîne tunisienne qui explique en
  **derja** (comme en classe réelle) est-elle admissible, la terminologie officielle en فصحى
  restant portée par le cours écrit de l'app ? Recommandation : oui — c'est la langue réelle
  d'enseignement oral en Tunisie et un facteur majeur de compréhension pour les 6–12 ans ; la
  fiche registre note `notes: "explication en derja"`.

---

## 8. Journal d'exécution

| date       | lot | PR   | écarts acceptés / dettes notées                                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------- | --- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-07-17 | —   | —    | Étude rédigée (Fable 5). Q-1…Q-5 ouvertes ; statut `brouillon`.                                                                                                                                                                                                                                                                                                                                                                               |
| 2026-07-19 | 1   | #507 | Socle données conforme. Registre livré vide ; no-op prouvé (chapitre sans vidéo → `'[]'`, exercice → NULL). Les contrôles « active sans verifiedOn » et « endSec » sont posés dans `content:qa` (comme spécifié §3), pas en zod.                                                                                                                                                                                                              |
| 2026-07-19 | 2   | #510 | Conforme. **Dette** : la colonne `chapters.videos` manque aux types Supabase générés (`supabase gen types` impossible hors ligne, hook anti-édition) → narrowing local dans `getChapterLesson` ; régénérer les types au prochain accès DB. Budget bundle i18n bumpé 118→120 KB (pattern documenté du fichier).                                                                                                                                |
| 2026-07-19 | 3   | —    | Résolution R-6 placée dans `getExercise` (et non `startExerciseSession`) : c'est le payload que lisent **les deux** registres (connecté + anonyme) — `startExerciseSession` ne porte aucune donnée d'exercice. **Écart assumé** : la spec e2e auth est **reportée au lot 5** — aucune vidéo n'existe au registre avant la campagne, donc aucun seed TEST ne peut la rendre verte ; à écrire avec les données du pilote.                       |
| 2026-07-19 | 4   | —    | Outillage conforme : skill `content-videos` (+ `references/video-sources.md` = allowlist **proposée**, en attente Q-1), `check-videos.mjs` (oEmbed anonyme throttlé ; `unknown` sur échec réseau — jamais de faux `broken` ; ne modifie JAMAIS le registre), workflow hebdo `video-health.yml` (issue listant vidéos mortes **et sujets à rebâtir**, auto-close au vert), script `content:videos:check`. No-op vert prouvé sur registre vide. |

---

## Annexe A — Panorama des sources vidéo (recherche du 2026-07-17)

> Rôle : matière première de l'arbitrage **Q-1**. Chaque ligne « candidate » devra passer la
> grille R-2 **vidéo par vidéo** au moment de la curation — l'allowlist autorise une chaîne,
> elle ne pré-valide jamais une vidéo. Recherche menée le 2026-07-17 (trois volets : sources
> francophones, sources arabophones/tunisiennes, dossier technique — annexe B), sources web
> citées en fin de tableau.

### A.1 — Sources francophones retenues (lycée scientifique fr, français, culture G)

| source                                 | cible (contexte tunisien)                              | format / volume                                           | gratuité & embed                                       | alignement & remarques                                                                                                           |
| -------------------------------------- | ------------------------------------------------------ | --------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Yvan Monka — Maths et tiques**       | maths lycée (toutes sections) + collège fr             | ~1 900 vidéos, 5–15 min, une notion/un exercice par vidéo | 100 % gratuit, YouTube                                 | LA référence francophone (agrégé, 20 ans de fiabilité) ; programme lycée fr ≈ lycée tunisien (limites, dérivées, probas, suites) |
| **jaicompris Maths**                   | maths lycée — **corrections d'exercices**              | 1 095+ vidéos classées par chapitre                       | 100 % gratuit, YouTube                                 | le format exact « exercice corrigé » de l'écran de résultat                                                                      |
| **Hedacademy**                         | maths collège fr / remédiation lycée                   | 5–15 min, très accessibles ; 1,2 M abonnés                | chaîne gratuite (site freemium)                        | ton le plus engageant 12–16 ans ; légitimité (série Lumni 2025-26)                                                               |
| **Khan Academy FR**                    | verticale maths primaire→lycée + sciences (complément) | 6 000+ leçons, capsules courtes                           | gratuit, **sans pub** (ONG), licence CC BY-NC-SA       | seule verticale complète ; progression ≠ tunisienne → complément notionnel, jamais fil de programme                              |
| **Les Bons Profs** (YouTube)           | physique, SVT, français, multi-matières collège/lycée  | ~1 680 rappels de cours de 5–10 min                       | chaîne gratuite (site payant — ne rien lier au site)   | profs certifiés ; couvre d'un coup les matières non-maths                                                                        |
| **Paul Olivier / e-profs / F. Raffin** | physique-chimie collège→bac fr                         | capsules de cours + exos                                  | gratuits, YouTube                                      | recommandés par des académies fr ; Raffin = niveau bac (électricité, mécanique, solutions)                                       |
| **Prof SVT71 · Mon Cours de SVT**      | SVT lycée/bac fr                                       | cours + schémas-bilans                                    | gratuits, YouTube                                      | schémas-bilans = complément direct des cours SVT                                                                                 |
| **Kezako (Unisciel)**                  | sciences collège/lycée, culture scientifique           | 80+ capsules de 3–7 min                                   | gratuit, **licence CC**, embed officiel (Canal-U + YT) | la source juridiquement la plus propre ; série ancienne mais stable                                                              |
| **C'est pas sorcier** (+ successeur)   | éveil/SVT/physique primaire-collège, culture G         | 559 épisodes ~26 min → **extraits via `start`/`end`**     | gratuit, chaîne officielle                             | capital affectif énorme ; épisodes longs → toujours en extrait ; données parfois datées                                          |
| **Les fondamentaux (Réseau Canopé)**   | primaire — français (grammaire/conjugaison), maths     | ~600 films animés de 2–4 min, une notion par film         | gratuit ; **CGU d'embed à vérifier** (PeerTube Canopé) | la meilleure source 6–11 ans en français ; réserve juridique à lever avant usage en masse                                        |
| **1 jour, 1 question**                 | culture générale 8–13 ans                              | 1 min 42, série vivante                                   | gratuit, YouTube officiel                              | parfait pour le thème culture-generale fr                                                                                        |
| **Français avec Pierre**               | thème langue française (FLE), soutien collège/lycée    | vidéos courtes sous-titrées A2–B2                         | chaîne gratuite (site freemium)                        | référence FLE ; pour le thème `francais` plus que pour l'école                                                                   |
| **Mediaclasse**                        | méthode bac français (commentaire, dissertation)       | analyses d'œuvres + méthode                               | gratuit sur YouTube                                    | programme d'œuvres = bac FRANÇAIS → n'utiliser que méthode et classiques communs                                                 |
| **MATHEZER** 🇹🇳                        | maths lycée→bac, **sections tunisiennes**, fr          | cours + corrections pas à pas                             | chaîne gratuite (plateforme payante)                   | jargon et découpage exacts des sections TN — ce que les chaînes fr n'ont pas ; volume moindre                                    |
| **TuniSchool / Lyceena Academy** 🇹🇳    | physique, maths, info bac TN, fr                       | ~600 vidéos (Lyceena)                                     | freemium — n'intégrer que le YouTube public            | profs tunisiens expérimentés ; catalogue YouTube = sous-ensemble                                                                 |

### A.2 — Sources arabophones / tunisiennes retenues (primaire, collège, concours, bac ar)

| source                                           | cible (contexte tunisien)                                       | format / volume                                   | gratuité & embed                             | alignement & remarques                                                                                                           |
| ------------------------------------------------ | --------------------------------------------------------------- | ------------------------------------------------- | -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Devoir.TN / Tadris.TN** 🇹🇳                     | **collège 7-8-9ᵉ en arabe** (رياضيات، فيزياء، عربية) + إيقاظ 6ᵉ | vidéothèque massive par année/matière             | partie YouTube gratuite, partie player/packs | **seule couverture systématique du collège arabophone alignée manuels TN** ; frontière gratuit/payant à vérifier vidéo par vidéo |
| **TakiAcademy** 🇹🇳                               | bac + نوفيام (maths, physique, philo, éco)                      | 2 100+ vidéos, ~550 K abonnés ; lives longs 1–2 h | chaîne YouTube gratuite (plateforme payante) | 100 % programme TN (profs tunisiens, derja) ; formats longs → extraits `start`/`end` ; pubs                                      |
| **القناة الوطنية التربوية** (ministère) 🇹🇳       | classes d'examen : سيزيام، نوفيام، bac (par شعبة)               | cours filmés TV 30–55 min (archive 2020-21)       | gratuit, YouTube, **zéro risque de droits**  | supervision pédagogique officielle ; captation datée, peu de nouveautés → extraits                                               |
| **Saboura.net (صبورة)** 🇹🇳                       | **primaire** (عربية، رياضيات، إيقاظ، تربية إسلامية)             | 990+ vidéos gratuites                             | chaîne gratuite (lives payants)              | le cycle le plus mal servi ailleurs ; « conforme aux programmes officiels »                                                      |
| **Faouzi El Gharbi (MathTV7/8/9)** 🇹🇳            | maths collège + concours 9ᵉ                                     | progression par niveau TN (apps compagnes)        | gratuit, YouTube                             | prof vétéran (1990+) ; chaîne artisanale — régularité/embed à auditer                                                            |
| **صلّحلي (Sala7li)** + chaînes d'إصلاح الكتاب 🇹🇳 | **corrections du manuel officiel**, primaire/collège            | correction filmée page par page, en **derja**     | gratuit, YouTube                             | l'exact format « correction d'exercice », aligné par construction sur le manuel (Q-5) ; chaînes modestes → auditer une à une     |
| **Khan Academy بالعربية**                        | maths notionnelles primaire/collège (complément)                | capsules 3–10 min, fus7a                          | gratuit, **sans pub**, CC BY-NC-SA           | progression US traduite → complément notionnel uniquement (fractions, équations, Thalès…)                                        |
| **3ich English (عيش إنجليش)** 🇹🇳                 | anglais collège/lycée + thème anglais                           | 152 vidéos, 1,26 M abonnés                        | gratuit, YouTube                             | l'anglais expliqué en tunisien — pas aligné manuels mais complément puissant                                                     |
| **Mekkawi · تبسيط النحو** (fus7a)                | arabe langue — نحو/إعراب collège/lycée                          | cours structurés                                  | gratuits, YouTube                            | réserve **terminologique** (المكوّن الفعلي/الاسمي… : termes des manuels TN parfois absents des chaînes orientales)               |

### A.3 — Écartées (et pourquoi)

| source                                   | raison                                                                                                            |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **Lumni** (plateforme)                   | géo-blocage hors de France (droits France TV) + pas d'embed public — ses déclinaisons YouTube restent utilisables |
| **PCCL**                                 | animations Flash (mort en 2021), distribution .exe — non intégrable                                               |
| **Nafham (نفهم)**                        | programmes EG/SY/SA/DZ/KW — pas la Tunisie ; dialecte égyptien                                                    |
| **Edraak K-12**                          | progression jordanienne                                                                                           |
| **InnerFrench**                          | B1-B2 confirmé, épisodes 20–40 min, sujets adultes — hors cible 6–19 ans                                          |
| **Madrasa.org (مدرسة)**                  | beau catalogue STEM fus7a mais player propriétaire, YouTube partiel — à revisiter si accord/CGU                   |
| **Ostedhy (YouTube)**                    | chaîne trop petite et promotionnelle (la plateforme est payante)                                                  |
| **Dailymotion**                          | pubs cousues côté serveur depuis 2025 — inacceptable pour des mineurs                                             |
| **Vimeo Free**                           | 1 GB à vie / 2 uploads·mois / watermark — inutilisable comme source, marginal comme hébergement                   |
| **EduSoutien** (ministère)               | pas une source d'embed (login, player propre) — **opportunité de partenariat institutionnel**, à traiter à part   |
| TakiAcademy/Almourabi & co (plateformes) | l'offre structurée est payante — seules leurs chaînes YouTube publiques entrent dans le périmètre                 |

### A.4 — Allowlist PROPOSÉE (l'objet de Q-1)

> Par cycle × matière, dans la **langue d'instruction** (R-8). « Primaire » = chaînes candidates
> principales ; « complément » = à n'utiliser que quand la source primaire n'a pas la notion.
> Rappel : l'allowlist autorise une **chaîne** ; chaque **vidéo** passe la grille R-2 + visionnage.

| cycle × matière (langue)          | primaires                                                     | complément                                           |
| --------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------- |
| Primaire — عربية/قراءة (ar)       | Saboura                                                       | Sala7li (corrections manuel), chaînes d'instituteurs |
| Primaire — رياضيات (ar)           | Saboura                                                       | Khan ar (notionnel), Sala7li                         |
| Primaire — إيقاظ علمي (ar)        | Saboura                                                       | Devoir.TN (6ᵉ)                                       |
| Concours سيزيام 6ᵉ (ar)           | القناة الوطنية التربوية                                       | Devoir.TN/Tadris                                     |
| Collège 7-9ᵉ — maths (ar)         | Devoir.TN/Tadris · Faouzi El Gharbi                           | TakiAcademy (9ᵉ), Khan ar (notionnel)                |
| Collège 7-9ᵉ — physique/SVT (ar)  | Devoir.TN/Tadris                                              | TakiAcademy (9ᵉ)                                     |
| Concours نوفيام 9ᵉ (ar)           | القناة الوطنية · TakiAcademy                                  | El Gharbi, Sala7li                                   |
| Arabe langue — نحو/صرف (ar)       | Tadris (7-8ᵉ)                                                 | Mekkawi, تبسيط النحو (réserve terminologie)          |
| Lycée — maths (fr)                | Yvan Monka · jaicompris (corrections)                         | MATHEZER (sections TN), Hedacademy, Khan fr          |
| Lycée — physique-chimie (fr)      | Les Bons Profs · Paul Olivier · F. Raffin (bac)               | e-profs, TuniSchool/Lyceena                          |
| Lycée — SVT (fr)                  | Prof SVT71 · Mon Cours de SVT                                 | Les Bons Profs                                       |
| Lycée — info (fr)                 | TuniSchool/Lyceena                                            | —                                                    |
| Bac — philo/hist-géo/éco (ar)     | TakiAcademy · القناة الوطنية (par شعبة)                       | —                                                    |
| Français langue (3ᵉ année → bac)  | Les fondamentaux (si CGU OK) · Les Bons Profs (collège/lycée) | Français avec Pierre, Mediaclasse (méthode bac)      |
| Anglais (école + thème `anglais`) | 3ich English                                                  | à cartographier (FLE anglais généraliste)            |
| Culture générale (thème, fr)      | 1 jour 1 question (8-13 ans) · C'est (toujours) pas sorcier   | Kezako (CC)                                          |
| Culture générale (thème, ar/en)   | **trou identifié** — à cartographier dans une session dédiée  | Khan ar (sciences)                                   |

Trous assumés à ce stade : culture G en ar/en ; éveil scientifique 1ʳᵉ–5ᵉ hors Saboura ; le thème
`muscle-cerveau` (aucune vidéo nécessaire — le format est l'exercice) ; l'anglais scolaire aligné
manuels TN. Ils se documentent dans `references/video-sources.md` (lot 4) et se comblent au fil
des campagnes.

## Annexe B — Dossier technique (faits vérifiés le 2026-07-17)

1. **Embed sans clé, mais sous conditions** : l'iframe embed est libre (aucune API key), soumis
   aux [YouTube API Services Terms](https://developers.google.com/youtube/terms/api-services-terms-of-service)
   - [Developer Policies](https://developers.google.com/youtube/terms/developer-policies) même
     sans clé : pas d'overlay/modification du player (l'overlay de consentement pré-chargement —
     notre façade — est explicitement toléré), ≥ 200×200 px, Referer conservé (erreur 153 sinon),
     pas de lecture en arrière-plan, **obligation de relever le statut made-for-kids de chaque
     vidéo embarquée** et de se **self-désigner child-directed** pour un site destiné aux enfants.
2. **`youtube-nocookie.com`** ([doc](https://support.google.com/youtube/answer/171780?hl=fr)) :
   toujours supporté ; zéro cookie avant Play, mais du localStorage tiers dès le chargement de
   l'iframe → la façade (aucune iframe avant clic) reste nécessaire pour le zéro-traceur pré-clic.
3. **Pubs** : impossibles à couper côté embed ; chaînes hors Partner Program monétisables
   d'office par YouTube (ToS 2020) ; **seul cas garanti sans pub : chaîne YPP monétisation
   désactivée** (confirmé publiquement par YouTube, nov. 2025) ; made-for-kids → pubs non
   personnalisées uniquement.
4. **Paramètres** ([doc officielle](https://developers.google.com/youtube/player_parameters)) :
   `rel=0` = suggestions même-chaîne (depuis 2018) ; `modestbranding` **sans effet depuis
   2023-08-15** ; `playsinline`, `hl`, `start`/`end`, `cc_load_policy`/`cc_lang_pref` supportés.
5. **oEmbed** (`https://www.youtube.com/oembed?url=…`) — testé : 200 = publique+embeddable,
   400 = id malformé, 401 = embed désactivé, 403 = privée, 404 = supprimée. Sans clé, sans SLA →
   throttle ~1 req/s et statut `unknown` sur échec réseau. La
   [Data API v3](https://developers.google.com/youtube/v3/docs/videos) (`status.embeddable`,
   `status.madeForKids`, `contentDetails.regionRestriction`) : 1 unité/appel, 50 ids/appel,
   10 000 unités/jour gratuites — outil de poste de curation, jamais une dépendance de l'app.
6. **Façades** : `lite-youtube-embed` (Paul Irish, Apache-2.0) v0.3.4 (nov. 2025) reste le
   pattern de référence Core Web Vitals — mais charge son poster depuis `i.ytimg.com` (requête
   tierce pré-clic), d'où la façade maison + posters locaux (D-5/D-11).
7. **CNIL** ([recommandation cookies consolidée, janv. 2026](https://www.cnil.fr/sites/default/files/2026-01/recommandation_cookies_consolidee.pdf)) :
   localStorage = traceur ; le pattern **façade/deux-clics** est la méthode de référence (la CNIL
   l'applique sur son propre site, en nocookie) ; < 15 ans = consentement conjoint parent/enfant
   (art. 45 LIL) → libellé adapté à l'âge + documentation parents (RISK-8).
8. **Alternatives** : PeerTube = plan C sans pub crédible (auto-hébergé) ; Vimeo Free marginal
   (1 GB à vie, watermark) ; Dailymotion exclu (pubs stitchées) ; Internet Archive = domaine
   public seulement.
