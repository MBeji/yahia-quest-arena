# Étude 20 — Rappel actif tolérant : jeu de réponses acceptées (zéro question exclue)

> **Statut** : brouillon (Q-1 & Q-3 arbitrées 2026-07-15 ; restent Q-2 budget/modèle Tier B, Q-4 élargissement éligibilité — non bloquantes)
> **Priorité** : 20 · **Valeur** : rend les **12 349** missions Rappel (étude 17) réellement jouables — une réponse **correcte mais formulée autrement** cesse d'être refusée, **sans retirer une seule question** du mode · **Complexité** : moyenne+
> **Architecte** : Opus 4.8 / 2026-07-15 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : étude 17 (Rappel actif — **livrée** : `normalize_recall_text`, `is_question_recall_eligible`, `score_recall_answer`, colonnes `variant`) · s'articule avec l'étude 04-A0 (télémétrie misconceptions), l'étude 12 (studio d'ingestion — même posture « génération hors-ligne → fichiers → compilation ») et le canal `content_reports` (boucle d'auto-correction) · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/interactive-question-types.md`, `content/README.md`, `content-engine/references/math-and-notation.md`, `docs/content-voice-and-composition.md`

## 1. Contexte & objectif produit

**Problème (constaté en production, 2026-07-15).** Le mode Rappel de l'étude 17 compare la réponse
**tapée** à l'unique **texte de la bonne option** du QCM, après normalisation
(`normalize_recall_text`), par **égalité stricte tout-ou-rien** (R-4). Or une même question a
souvent **plusieurs réponses correctes formulées différemment**. Une session réelle sur la mission
« التموقع في الفضاء » (positionnement dans l'espace, 1re année de base — 6 ans) l'a rendu visible :

| #   | Prompt (résumé)                    | Bonne option | Réponse tapée  | Verdict moteur | Réalité pédagogique                                          |
| --- | ---------------------------------- | ------------ | -------------- | -------------- | ------------------------------------------------------------ |
| Q1  | « أين الطائر ؟ » (où est l'oiseau) | فوقها        | فوق الشجرة     | ❌ À revoir    | **juste** — « au-dessus d'elle » = « au-dessus de l'arbre »  |
| Q4  | « أين الكرة ؟ » (où est la balle)  | داخل الصندوق | في جوف الصندوق | ❌ À revoir    | **juste** — synonymes (« dans » / « dans le creux de »)      |
| Q2  | « أيّ حيوان أصغر ؟ »               | النملة       | NAMLA          | ❌ À revoir    | translittération latine — clavier arabe indisponible à 6 ans |
| Q5  | « نأكل ونكتب باليد… »              | اليمنى       | DROITE         | ❌ À revoir    | réponse en français                                          |
| Q6  | « أيّ شيء أقصر ؟ »                 | القلم        | ALKALAM        | ❌ À revoir    | translittération de « al-qalam »                             |

Deux familles de faux négatifs distinctes :

1. **Variabilité de formulation** (Q1, Q4) : la bonne réponse est une **phrase** (prépositionnelle,
   positionnelle, définie) qui admet des paraphrases exactes. La règle d'éligibilité R-2(g) de
   l'étude 17 exclut « lequel/parmi/… » mais **pas** les questions de position (« أين / où /
   where ») ni les réponses multi-mots — elles restent proposées, puis refusent des paraphrases
   justes. **Cause racine : le moteur ne connaît qu'UNE réponse acceptable là où il en existe
   plusieurs.**
2. **Écriture hors-registre** (Q2, Q5, Q6) : l'élève tape une **translittération latine** ou une
   **traduction** de la réponse arabe (à 6 ans, le clavier arabe est hors de portée). La
   normalisation ne translittère pas — refus légitime au sens strict, mais expérience punitive.
   Cas voisin non illustré ici mais mesuré : en arabe, taper le mot **sans l'article défini
   « ال »** (« نملة » au lieu de « النملة ») est aussi refusé — `normalize_recall_text` ne plie pas
   l'article.

**Ce que la mesure exhaustive (§9) tranche** — 18 669 QCM, éligibilité calculée par portage 1:1 de
la règle SQL déployée : **12 349 questions éligibles (66,1 %)**. Surtout, elle **cadre la nature du
problème** : le portail d'éligibilité et `normalize_recall_text` neutralisent **déjà** tout le
typographique (espaces, accents, hamza/ة/ى, tashkeel, ponctuation, chiffres arabes-indics). **Le
faux négatif résiduel est donc exclusivement lexical/morphologique/syntaxique**, et se concentre en
trois gisements : (a) **réponses ≥ 2 mots — 57,8 % des éligibles** (reformulations, synonymes) ;
(b) **article défini** — arabe « ال » sur **21,4 % des éligibles ar (1 833 questions)**, plus son
équivalent français `le/la/l'` et les contractions anglaises `they're`/`can't` ; (c) **positionnels
— 385** (peu nombreux mais quasi tous à risque). Ce cadrage oriente directement la génération (§3) :
le gisement (b) est **mécanique** (déterministe, sans IA) ; les gisements (a)/(c) demandent une passe
sémantique relue.

**Décision produit (arbitrage Mohamed, 2026-07-15).** **On n'exclut AUCUNE question** du mode
Rappel. On garde tout le catalogue éligible et on rend chaque question **réellement répondable en
saisie libre** en dotant le moteur du **jeu des réponses acceptées** de chaque question — ce que
l'étude 17 avait explicitement renvoyé à une « extension v2 naturelle » (`recallAnswers`, hors
périmètre v1, §Hors-périmètre étude 17). Cette étude EST cette v2, élargie.

**Résultat attendu.** Pour chaque question éligible, le moteur compare la saisie normalisée non
plus à une seule chaîne mais à un **ensemble fermé de réponses acceptées** (la bonne option **plus**
ses variantes valides : paraphrases, synonymes, formes morphologiques — avec/sans article, genre,
pluriel —, positions équivalentes, et pour l'arabe — tous niveaux (Q-1) — translittérations latines
usuelles). L'ensemble est **produit hors-ligne** (passe de génération outillée + revue), stocké dans
le contenu versionné, **compilé** comme le reste, et **jamais envoyé au client** (même posture
server-only que la clé). Le scoring **reste 100 % déterministe au runtime** (test d'appartenance
normalisé) — aucun jugement IA, aucune latence, aucun coût par réponse, aucun oracle exposé.

**Ce que l'étude ne cherche PAS à faire** : introduire un correcteur flou/Levenshtein en base
(la comparaison reste exacte, sur un ensemble élargi) · appeler un LLM au moment de répondre ·
noter du texte libre subjectif (essai) — non-goal de la spec Tier B, inchangé · toucher au quiz de
compréhension, au Donjon ou aux duels · **exclure des questions** ou introduire un réglage
d'éligibilité par niveau qui masquerait du contenu.

**État réel du code (base étude 17, livrée).** `normalize_recall_text(text)` (IMMUTABLE, SQL pur,
9 étapes), `is_question_recall_eligible(q)` (R-2 a–i, listes closes), `score_recall_answer(q,choice)`
(STABLE, égalité normalisée simple) — les trois `REVOKE`d d'anon/authenticated. La clé n'atteint
jamais le client (`getExercise` whitelist ses colonnes ; `get_recall_questions` renvoie prompt seul).
`exercise_sessions.variant` / `attempts.variant` discriminent classique vs rappel. **Aucune de ces
signatures n'est cassée par cette étude** — on ajoute une source de vérité (l'ensemble accepté) et
on élargit un seul corps de fonction (`score_recall_answer`).

**KPI de succès.**

- **Taux « réponse juste refusée » < 1 %** des sessions Rappel (mesuré via signalements + revue
  d'échantillons) — c'était déjà la cible R-4 de l'étude 17 ; c'est ici l'objectif primaire.
- **Couverture** : ≥ 95 % des questions éligibles disposent d'un `recallAnswers` généré **et validé**
  (le reste = la bonne option seule, comportement étude 17 — jamais pire qu'aujourd'hui).
- **Non-régression** : le scoring reste déterministe (pgTAP table-driven), la clé et l'ensemble
  accepté ne fuient pas (smoke + test de whitelist), et une saisie fausse reste fausse (l'ensemble
  n'entre jamais en collision avec un distracteur — R-2(h) étendu à tout l'ensemble).

## 2. Spécification fonctionnelle

### Acteurs & parcours

Élève **connecté** (jeu du Rappel, inchangé étude 17) ; **auteur/architecte** (génère et valide les
ensembles, hors-ligne) ; **admin** (triage des « refus contestés », lot 5). L'anonyme voit la
mission verrouillée (override R-9 du 2026-07-15) mais ne joue pas.

- **US-1 — ma paraphrase juste est acceptée.** Élève : en Rappel, si je tape une **formulation
  correcte** de la réponse (« فوق الشجرة » là où l'option disait « فوقها »), elle est **validée** ;
  je ne suis plus pénalisé pour avoir dit juste autrement.
- **US-2 — l'arabe est équitable.** Élève (contenu ar) : je tape le mot **avec ou sans l'article
  défini**, avec la variante orthographique usuelle (hamza approximative déjà pliée étude 17), et —
  **quel que soit mon niveau** (Q-1 arbitrée « tout ») — une **translittération latine courante** est
  acceptée si je n'ai pas de clavier arabe ; la barre de caractères d'appoint (R-12 étude 17) reste
  offerte.
- **US-3 — aucune question ne disparaît.** Élève : toutes les missions Rappel de l'étude 17 restent
  présentes ; aucune n'est retirée sous prétexte qu'elle « admet plusieurs réponses » — elle est au
  contraire **mieux corrigée**.
- **US-4 — une vraie erreur reste une erreur.** Élève : si je tape un **distracteur** ou une
  réponse hors-sujet, c'est **faux** (l'ensemble accepté ne contient jamais un distracteur ni une
  réponse fausse) — la valeur pédagogique du rappel est préservée.
- **US-5 — je peux signaler un refus injuste.** Élève : à la correction, si une de mes réponses
  refusées me semble juste, le bouton « Signaler une erreur » (existant, `content_reports`) me
  permet de la remonter ; elle alimente la file de revue (lot 5).
- **US-6 — auteur : je génère et je relis.** Auteur/architecte : je lance la passe de génération sur
  une matière ; elle produit un `recallAnswers` par question éligible ; `content:qa` le valide
  (typabilité, non-collision) ; je relis le diff avant compilation — **aucune** mise en base d'un
  ensemble non relu.

**Flux écran (élève).** Inchangé vs étude 17 (bandeau « Mode Rappel · sans options · XP ×1,5 »,
input texte, char-bar R-12, correction réponse-tapée vs réponse-attendue). **Seul le verdict change**
de justesse : des paraphrases correctes passent désormais au vert. À la correction, la « réponse
attendue » affichée reste le **texte de la bonne option** (canonique) — on n'expose pas tout
l'ensemble accepté (bruit + fuite de la richesse du gabarit).

### Règles métier

- **R-1 — ensemble accepté server-only.** `recallAnswers` d'une question est stocké dans une
  colonne **jamais lisible par le client** (même posture que `correct_option` / `distractor_tags`).
  La comparaison est exclusivement serveur (`score_recall_answer`, `SECURITY DEFINER`/`REVOKE`d).
  Aucune route ne le sélectionne ; `get_recall_questions` continue de ne renvoyer que le prompt.
- **R-2 — définition de l'ensemble accepté.** Pour une question éligible, l'ensemble des réponses
  acceptées est : `{ texte de la bonne option }` **∪** `{ chaque entrée de recallAnswers }`, chaque
  membre passé par `normalize_recall_text`. La **bonne option est toujours implicitement acceptée**
  (jamais besoin de la répéter dans `recallAnswers`). Le champ `recallAnswers` est **optionnel** :
  absent ⇒ comportement étude 17 (bonne option seule), jamais une régression.
- **R-3 — scoring (déterministe, tout-ou-rien, ensemble élargi).** `score_recall_answer(q,choice)`
  renvoie vrai ssi `normalize(choice)` **∈** l'ensemble accepté normalisé **et** `choice` non
  vide/blanc. Pas de crédit partiel, pas de distance d'édition. La normalisation est celle de
  l'étude 17 (`normalize_recall_text`), inchangée par défaut (voir R-8 pour l'unique extension
  proposée).
- **R-4 — invariant anti-collision (précision d'abord).** Un membre de l'ensemble accepté **ne doit
  jamais** égaler (normalisé) le texte d'un **distracteur** de la même question. `content:qa` **rejette**
  (erreur) tout `recallAnswers` qui collisionne un distracteur, ou qui duplique la bonne option, ou
  qui duplique un autre membre. Rationale : mieux vaut refuser une paraphrase rare que d'accepter une
  réponse ambiguë et détruire la valeur pédagogique (US-4). C'est l'extension à tout l'ensemble de la
  règle R-2(h) de l'étude 17.
- **R-5 — typabilité de chaque membre.** Chaque membre de `recallAnswers`, une fois normalisé, doit
  respecter le charset tapable au clavier de l'étude 17 R-2(i) : `^[a-z0-9.ء-ي]+$`. Un membre qui se
  normalise en vide, ou qui contient un caractère hors-charset, est **rejeté** par `content:qa`
  (erreur). (Une translittération latine d'un mot arabe est donc naturellement autorisée — lettres
  latines de base.)
- **R-6 — éligibilité : on ne RETIRE rien, on peut ÉLARGIR.** L'ensemble accepté rendant les
  questions à formulation variable **corrigeables**, la justification des exclusions R-2(f/g) de
  l'étude 17 (marqueurs composites, énoncés « dépendants des options ») **s'assouplit** mais **ne se
  durcit jamais**. v1 : `is_question_recall_eligible` **reste identique** (aucune question éligible
  aujourd'hui ne devient inéligible). Élargir l'éligibilité aux questions aujourd'hui exclues est une
  **extension explicitement hors-v1** (annexe §9, candidate lot ultérieur) — car elle demande de
  générer des ensembles pour des questions encore jamais servies en Rappel.
- **R-7 — génération hors-ligne, revue obligatoire, zéro IA au runtime.** Les ensembles sont produits
  par une passe outillée (skill dédié, §3) **avant** toute mise en base, écrits en **fichiers**
  contenu, validés par `content:qa`/`content:qa:strict`, **relus** dans le diff, puis compilés
  (UUIDv5 idempotent). Aucun appel modèle n'a lieu pendant une session élève. C'est la même doctrine
  que le reste du moteur de contenu (fichiers → compilation) et que l'étude 12.
- **R-8 — normalisation : extensions minimales et sûres (décision fermée).** On **préfère porter les
  variantes dans l'ensemble généré** plutôt que d'assouplir `normalize_recall_text` (une règle de
  normalisation trop large — p. ex. plier l'article « ال » globalement — risque de créer des
  collisions distracteur invisibles sur tout le catalogue). v1 : **aucune modification** de
  `normalize_recall_text`. L'article défini arabe, les paraphrases, les translittérations sont gérés
  **comme membres de l'ensemble** (contrôlés par R-4/R-5, donc sûrs question par question).
- **R-9 — télémétrie inchangée (étude 04-A0).** Une réponse tapée qui égale (normalisé) un
  **distracteur** résout toujours son `misconception_tag` (R-7 étude 17). Une réponse acceptée via
  l'ensemble n'est pas un distracteur (R-4) ⇒ pas de tag, cohérent. `question_attempts` continue de
  logguer `choice` = texte tapé.
- **R-10 — périmètre moteur.** Quiz de compréhension, Donjon, duels : jamais concernés (comme étude
  17). `check_answers`, `score_quiz`, `submit_dungeon_answer` non modifiés.

### i18n

Aucune nouvelle surface élève obligatoire (le mode Rappel existe déjà). Extensions possibles (lot 4) :
libellés de la barre de saisie arabe / clavier d'appoint pour les petites classes, sous `t.quest.*`.
Le champ `recallAnswers` est du **contenu** (dans la langue d'instruction de la matière), pas de
l'i18n applicatif. Notation standard maintenue (chiffres occidentaux, LTR pour les équations) —
`content-engine/references/math-and-notation.md`.

### Hors périmètre (v1)

Correcteur flou/Levenshtein · LLM au runtime · crédit partiel · élargissement de l'éligibilité aux
questions aujourd'hui exclues (R-6) · Rappel sur quiz/Donjon/duels · réglage per-question de
l'éligibilité par les auteurs · clavier arabe complet à l'écran (v1 = char-bar R-12 + translittérations
générées ; clavier riche = lot 4 si les KPI l'exigent) · traduction inter-langues des réponses (une
réponse française à une question arabe reste fausse — c'est la langue d'instruction qui prime ; seule
la **translittération** de la réponse arabe est un aménagement petites-classes).

## 3. Architecture technique (décisions fermées)

### Modèle de données (migration additive, lot 1)

Une seule colonne **server-only** sur `questions`, peuplée par le compilateur de contenu :

```sql
-- Ensemble des réponses acceptées EN PLUS de la bonne option, normalisées à la compilation
-- (l'auteur écrit du texte lisible ; le builder normalise + dédoublonne). JSONB = array de text.
ALTER TABLE public.questions
  ADD COLUMN recall_answers jsonb NOT NULL DEFAULT '[]'::jsonb;

-- Invariant de forme (le contenu de l'array est validé plus finement par content:qa côté build).
ALTER TABLE public.questions
  ADD CONSTRAINT questions_recall_answers_is_array
  CHECK (jsonb_typeof(recall_answers) = 'array');
```

**Aucun grant nouveau, et surtout aucun grant de lecture** : `recall_answers` suit exactement la
posture de `correct_option`/`distractor_tags` — la colonne existe mais **n'est jamais dans une
whitelist client**. Le SELECT RLS public sur `questions` (lecture du catalogue) **doit exclure cette
colonne** partout où il liste des colonnes explicites ; auditer `getExercise`, `get_recall_questions`
et toute vue/politique qui `SELECT *` sur `questions` (si une politique fait `SELECT *`, ajouter une
vue projetée ou passer par la RPC DEFINER — **stop-point sécurité du lot 1**).

### Fonction de scoring (lot 1) — le seul corps modifié

`score_recall_answer` passe d'une égalité simple à un **test d'appartenance** normalisé. Signature,
posture `SECURITY`/`STABLE` et `REVOKE` **inchangés** (D-3 étude 17 : `score_answer` classique n'est
pas touchée) :

```sql
CREATE OR REPLACE FUNCTION public.score_recall_answer(q public.questions, p_choice text)
RETURNS boolean
STABLE
LANGUAGE sql
SET search_path = public
AS $$
  SELECT btrim(coalesce(p_choice, '')) <> ''
     AND public.normalize_recall_text(p_choice) IN (
       -- la bonne option, toujours acceptée
       SELECT public.normalize_recall_text(
         (SELECT opt ->> 'text' FROM jsonb_array_elements(q.options) opt
           WHERE opt ->> 'id' = q.correct_option)
       )
       UNION
       -- les variantes acceptées authored/générées
       SELECT public.normalize_recall_text(x)
       FROM jsonb_array_elements_text(q.recall_answers) AS x
     );
$$;
```

Idempotent, déterministe, aucun élargissement de surface d'attaque (la colonne reste server-only, la
fonction reste `REVOKE`d). pgTAP table-driven (lot 1) : bonne option, chaque variante, un distracteur
(faux), vide (faux), variante avec espaces/casse/tashkeel.

### Pipeline contenu (lot 1) — champ `recallAnswers`

Nouveau champ **optionnel** au schéma zod des questions (`src/shared/content/schema.ts`) :

```ts
// question schema — ajout
recallAnswers: z.array(z.string().min(1).max(512)).max(24).optional(),
```

Le **builder** (`scripts/content/build.ts` / `sql-builder.ts`) émet la colonne `recall_answers`
(array JSONB) ; **la normalisation et le dédoublonnage restent en base** (le builder écrit le texte
brut lisible ; `score_recall_answer` normalise — source unique de la normalisation, évite toute
divergence TS/SQL). Le champ voyage dans la migration idempotente par sujet (UUIDv5 stable, pas de
backfill : les questions sans `recallAnswers` gardent `'[]'`).

**QA (`content:qa` + `content:qa:strict`)** — nouvelles vérifications (erreurs, pas warnings) :

1. chaque entrée `recallAnswers`, normalisée (mêmes règles que le SQL, portées en TS dans
   `src/shared/content/` — **avec un test qui prouve la parité TS↔SQL** sur un corpus fixe), est
   **non vide** et respecte le charset R-5 ;
2. **aucune collision** avec un distracteur normalisé (R-4), ni doublon de la bonne option, ni
   doublon interne ;
3. `recallAnswers` n'est autorisé **que** sur une question **éligible** (`is_question_recall_eligible`
   vraie) — sinon warning « ensemble ignoré » (la question n'est pas servie en Rappel) ;
4. taille bornée (≤ 24 entrées) pour éviter les ensembles ballonnés.

### Génération des ensembles (lot 2+) — DEUX tiers (la mesure §9 les sépare nettement)

**Tier A — expansion morphologique déterministe (SANS IA, ~cœur du gisement « article »).** Une
passe **mécanique** (fonction pure, testable) génère les variantes morphologiques sûres, langue par
langue — c'est le plus gros gisement mesuré (article défini : 21,4 % des éligibles ar + équivalents
fr/en) et il ne nécessite **aucun modèle** :

- **arabe** : réponse avec ⇄ sans article « ال » en tête (`النبات الأخضر` ⇄ `نبات أخضر`) ;
- **français** : article de tête `le/la/les/l'` ajouté ⇄ retiré (`Afrique` ⇄ `l'Afrique`) ;
- **anglais** : contractions usuelles étendues ⇄ contractées (`they're` ⇄ `they are`, `can't` ⇄
  `cannot`, `it's` ⇄ `it is`), article `the/a/an` de tête.

Chaque variante produite passe la **garde anti-collision R-4** (si elle égale un distracteur normalisé,
elle est **écartée** — la question reste, seule la variante tombe : c'est ce qui préserve le « zéro
exclusion », contrairement à un pliage global en normalisation qui exclurait la question par collision,
D-2). Tier A est **exécutable au build** ou pré-généré en fichiers ; sans IA, il est quasi-gratuit et
couvre mécaniquement le gisement (b).

**Tier B — génération sémantique (IA + double-solve + revue humaine), gisements (a)/(c).** Le skill
`.claude/skills/content-recall-answers/` (déféré à `content-engine` : schéma, barre qualité, notation)
produit pour chaque question éligible **à réponse ≥ 2 mots ou positionnelle** les **paraphrases /
synonymes exacts / positions équivalentes** validés (« فوقها » ↔ « فوق الشجرة » ↔ « في الأعلى ») —
bornés (≤ 24), jamais un quasi-synonyme qui changerait le sens. Le skill **re-résout** chaque question
et vérifie que chaque variante est bien **une** bonne réponse **et** ne matche aucun distracteur
(miroir de la garde `content:qa`) avant de l'écrire. Il produit **des fichiers uniquement**, puis lance
`content:check` + `content:qa:strict`.

**Translittérations latines** (arabe, **tous niveaux** — Q-1 arbitrée « tout ») : ajoutées par Tier A/B,
par défaut pour les réponses **mono-mot** (« النملة » → « namla »/« nemla ») ; le multi-mot n'est ajouté
que s'il est **non ambigu** (une seule romanisation raisonnable) et non collisionnant (R-4).

La campagne (lot 3) suit la **priorité produit** — petites classes d'abord (public le plus fragile,
problème le plus aigu, cf. la mission constatée), puis concours — **une matière par PR** (règle
anti-troncature + `content:build --subject <id>` du repo), revue de diff avant compilation. Tier A
peut être appliqué **à tout le corpus d'un coup** (déterministe, peu risqué) ; Tier B est batché.

### Boucle d'auto-correction (lot 5, optionnel) — « refus contesté »

Un élève qui signale une réponse refusée-mais-juste (US-5, via `content_reports` avec un type
`recall_false_negative`) alimente une **file de revue admin** (`/admin/content-reports` filtré). Un
auteur confirme ⇒ la variante est **ajoutée à `recallAnswers`** (fichier → compilation). Le système
**apprend** ses angles morts au lieu de les répéter ; c'est la mitigation vivante du KPI « < 1 % ».
Aucune écriture automatique en base : la boucle reste **humaine-dans-la-boucle** (pas d'oracle
auto-modifiable).

### Sécurité & anti-triche

- `recall_answers` **server-only** (jamais whitelisté client) — invariant vérifié par un test de
  whitelist + `smoke:shell` (le bundle prod ne doit jamais recevoir la colonne).
- L'ensemble accepté ne peut pas ouvrir un oracle : `score_recall_answer` reste `REVOKE`d
  d'anon/authenticated (appelée uniquement par les RPCs DEFINER de soumission).
- R-4 (anti-collision) garantit qu'élargir l'acceptation **ne rend jamais un distracteur juste** — la
  triche « je tape n'importe quelle option » reste fausse.
- Génération hors-ligne ⇒ aucune surface d'injection au runtime.

### Décisions d'architecture (ADR)

- **D-1 — ensemble authored/généré plutôt que correcteur flou.** Rejeté : Levenshtein/embeddings au
  runtime (non-déterministe, coût, faux positifs incontrôlables, oracle). Choisi : ensemble fermé,
  déterministe, contrôlé question par question. L'intelligence est déplacée à la **génération
  hors-ligne**, revue par un humain — le runtime reste bête et sûr.
- **D-2 — variantes dans l'ensemble, pas dans la normalisation (argument décisif : le zéro-exclusion).**
  Rejeté : plier l'article « ال » (ou d'autres classes) globalement dans `normalize_recall_text`.
  Raison dirimante : `is_question_recall_eligible` utilise **la même** normalisation pour son test
  d'anti-collision (h) ; un pliage global qui ferait coïncider une bonne réponse et un distracteur
  rendrait la question **inéligible** — donc la **retirerait** du Rappel. Un pliage global peut ainsi
  **exclure** du contenu, ce que la directive humaine interdit. Choisi : chaque variante est un membre
  **explicite** de l'ensemble, gardé par R-4/R-5 **par question** — en cas de collision on écarte **la
  variante**, jamais la question. `normalize_recall_text` reste **inchangée** (v1). Bonus : les variantes
  morphologiques (article, contraction) sont **déterministes** (Tier A, sans IA), donc ce choix n'a même
  pas de surcoût de génération.
- **D-3 — normalisation en base, texte lisible en fichier.** Le fichier contenu porte du texte
  **lisible** (relecture humaine possible) ; la **normalisation est faite par le SQL** au scoring —
  source unique, pas de risque de divergence TS/SQL. Un test de **parité** TS↔SQL protège le gate QA.
- **D-4 — zéro exclusion (directive humaine).** On ne durcit jamais l'éligibilité (R-6). Le contenu à
  formulation variable est **mieux corrigé**, pas retiré. Escape hatch éventuel (per-grade) explicitement
  **refusé** en v1.
- **D-5 — nouvelle étude plutôt qu'amendement de 17.** L'étude 17 est livrée ; cette évolution ajoute
  un champ contenu, une passe de génération, une campagne et un changement de scoring — assez pour un
  dossier propre (comme 18→19). L'étude 17 reste la référence du **mode** ; 20 est la référence de la
  **tolérance**.

## 4. Plan d'exécution en lots

| lot      | contenu (résumé)                                                                                                                                                                                                                                                                      | fichiers/objets créés                                                                                       | tests exigés                                                                                  | dépend de                       |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------- |
| 1        | Socle : colonne `recall_answers` server-only + `score_recall_answer` ensembliste + champ schéma `recallAnswers` + builder + QA (collision/typabilité/parité) + **cadrage du type `content_reports.recall_false_negative`** (enum/schéma + acceptation serveur, sans file admin — Q-3) | migration `2026…_recall_answers_set.sql` ; `schema.ts`, `sql-builder.ts` ; QA rules ; pgTAP ; unit build/QA | pgTAP scoring ; unit QA (collision, charset, parité TS↔SQL) ; test whitelist                  | étude 17 (livrée)               |
| 2        | **Tier A** — expansion morphologique **déterministe** (article ar « ال », article fr, contractions en) appliquée **au corpus entier** (gisement le plus gros, sans IA), gardée anti-collision                                                                                         | fonction pure `recall-morph-expand` ; fichiers `recallAnswers` (Tier A) tous sujets ; migrations sujets     | unit table-driven (par langue) ; `content:qa:strict` ; before/after faux négatifs « article » | lot 1                           |
| 3        | **Tier B** — skill `content-recall-answers` (paraphrases/synonymes/positions) + **pilote** : petites classes arabes (dont la mission constatée) + 2-3 témoins fr/en                                                                                                                   | `.claude/skills/content-recall-answers/…` ; `recallAnswers` (Tier B) matières pilotes                       | `content:qa:strict` ; échantillon re-solvé ; before/after                                     | lot 1 (Tier A recommandé avant) |
| 4        | Campagne Tier B corpus (priorité petites classes → concours → reste), **une matière par PR**                                                                                                                                                                                          | `recallAnswers` par matière ; migrations sujets                                                             | `content:qa:strict` par matière ; sweep `content-audit`                                       | lot 3                           |
| 5        | Aides à la saisie arabe petites classes (translittérations + éventuel clavier d'appoint) + i18n                                                                                                                                                                                       | extension char-bar R-12 / mini-clavier ar ; clés `t.quest.*`                                                | unit composant ; e2e saisie ar                                                                | lot 3                           |
| 6 (opt.) | Boucle « refus contesté » : type `content_reports.recall_false_negative` + file admin + ajout de variante                                                                                                                                                                             | server fn + filtre `/admin/content-reports`                                                                 | unit + e2e triage                                                                             | lot 1 ; canal content-reports   |

- [ ] **Lot 1 — Socle scoring ensembliste + colonne server-only + QA.** Périmètre : migration additive
      (`recall_answers` + CHECK), `CREATE OR REPLACE score_recall_answer` (test d'appartenance),
      champ `recallAnswers` au schéma zod, émission builder, règles `content:qa` (R-4/R-5 + parité
      TS↔SQL), pgTAP. **Critères** : R-1..R-5, R-8. **Stop-point** : ne génère AUCUN contenu, ne
      touche PAS `is_question_recall_eligible` ni `normalize_recall_text`, ne modifie pas les RPCs de
      soumission (elles appellent déjà `score_recall_answer`). Inclut le **cadrage du type
      `content_reports.recall_false_negative`** (enum + acceptation serveur) — **sans** la file admin
      (lot 6, Q-3). Sécurité : prouver que `recall_answers` n'est jamais côté client (audit whitelist +
      smoke) **avant** de clore le lot.
- [ ] **Lot 2 — Tier A : expansion morphologique déterministe (corpus entier).** Périmètre : une
      fonction **pure** (article ar/fr, contractions en), appliquée à toutes les questions éligibles,
      chaque variante gardée par R-4. Gros gain, faible risque, **sans IA**. **Critères** : US-2/R-2/
      R-4/R-5. **Stop-point** : Tier A ne produit QUE des variantes morphologiques mécaniques — aucune
      paraphrase sémantique (c'est le Tier B) ; mesurer le recul du gisement « article ».
- [ ] **Lot 3 — Tier B : skill de génération + pilote petites classes.** Périmètre : le skill, puis
      génération (paraphrases/synonymes/positions) sur la mission « التموقع في الفضاء » + arabes 1re–2e
      année + 2-3 témoins fr/en. **Critères** : US-1/US-6/R-2/R-4/R-5/R-7. **Stop-point** : pas de
      campagne globale ; mesurer et remonter avant d'étendre.
- [ ] **Lot 4 — Campagne Tier B (1 matière/PR).** Priorité produit. **Stop-point** : une matière par
      PR, jamais `content:build` nu (`--subject <id>`), revue de diff obligatoire.
- [ ] **Lot 5 — Aides de saisie arabe (petites classes).** **Stop-point** : livrable indépendant de la
      campagne complète.
- [ ] **Lot 6 (opt.) — Boucle refus contesté.** **Stop-point** : aucune écriture auto en base ;
      humain-dans-la-boucle.

## 5. Stratégie de test

- **pgTAP** (lot 1) : `score_recall_answer` table-driven — bonne option ✓, chaque variante de
  `recall_answers` ✓, un distracteur ✗, vide/blanc ✗, variantes casse/espaces/tashkeel/chiffres ✓, et
  le **cas défaut** `recall_answers = '[]'` (identique étude 17). Choix documenté : l'anti-collision
  (R-4) est garantie **à la compilation** (`content:qa`), **pas** au scoring — le scoring fait
  confiance à l'ensemble déjà validé ; il n'existe donc aucune défense SQL runtime contre un ensemble
  empoisonné, ce qui **impose** que la garde QA soit bloquante (`content:qa:strict` en CI) et la revue
  humaine obligatoire (R-7). C'est le pendant exact de `correct_option`, elle aussi crue par le
  scoring et garantie juste en amont.
- **Unit (Vitest)** : règles `content:qa` (collision, charset, doublon, taille) ; **parité TS↔SQL** de
  la normalisation sur un corpus fixe (le test qui garantit D-3) ; builder émet bien `recall_answers`.
- **Whitelist/sécurité** : test que `getExercise`/`get_recall_questions` ne renvoient jamais
  `recall_answers` ; `smoke:shell` (bundle prod) inchangé vert.
- **e2e (TEST project)** : rejouer une mission Rappel dont une question a `recallAnswers`, taper une
  **paraphrase** listée → session réussie ; taper un **distracteur** → faux. (Étend
  `e2e/authed/recall-mode.spec.ts`.)
- **Non-régression** : les questions sans `recallAnswers` scorent exactement comme étude 17 (défaut
  `'[]'`), prouvé par un cas pgTAP dédié.

## 6. Risques & mitigations

- **RISK-1 — l'ensemble accepte une réponse en fait fausse (sur-tolérance).** Impact fort (détruit la
  valeur pédagogique). Mitigation : R-4 (anti-collision distracteur, erreur QA), double-solve du skill,
  revue de diff humaine obligatoire (R-7), ensemble borné (≤24). Précision toujours prioritaire sur le
  rappel (comme R-2 étude 17).
- **RISK-2 — divergence normalisation TS (QA) ↔ SQL (scoring).** Impact : une variante validée par la
  QA mais refusée en base (ou l'inverse). Mitigation : **normalisation faite uniquement en SQL au
  scoring** (D-3) ; la QA porte une réplique TS **testée pour parité** sur corpus fixe — CI casse à la
  moindre dérive.
- **RISK-3 — coût/qualité de génération à l'échelle (~12 400 questions).** Mitigation : passe
  **hors-ligne**, batchée par matière, priorisée (petites classes d'abord), non bloquante (défaut =
  bonne option seule, jamais pire qu'aujourd'hui) ; couverture montée incrémentalement, mesurée.
- **RISK-4 — translittération latine ambiguë en arabe.** Mitigation : translittérations **mono-mot,
  petites classes uniquement**, gardées par R-4 (pas de collision distracteur) ; sinon exclues de
  l'ensemble. Q-1 tranche la portée.
- **RISK-5 — fuite de `recall_answers` au client.** Impact : oracle partiel. Mitigation : colonne
  server-only, audit whitelist + smoke, `REVOKE` maintenu sur le scoring — invariant testé au lot 1.
- **RISK-6 — la campagne prend du retard et le mode reste punitif entre-temps.** Mitigation : lot 2
  traite **en premier** la population la plus touchée (petites classes) ; lot 5 (boucle refus contesté)
  amortit les angles morts résiduels ; KPI suivi.

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — translittérations latines des réponses arabes. ✅ ARBITRÉE 2026-07-15 : « tout ».** Portée =
  **tous les niveaux** (pas seulement les petites classes) et **toutes les langues arabes** du
  catalogue. La sûreté ne repose pas sur une limite de portée mais sur les **gardes correctionnelles
  maintenues** : chaque translittération générée passe l'anti-collision R-4 (écartée si elle égale un
  distracteur normalisé) et le double-solve du skill. Par défaut mono-mot ; le multi-mot n'est ajouté
  que lorsqu'il est **non ambigu** (une seule romanisation raisonnable) et non collisionnant — sinon
  écarté. Impacte Tier A/B (lots 2/3/4).
- **Q-2 — budget/modèle de génération (Tier B seulement).** Le **Tier A** (article/contraction, gisement
  le plus gros) est **déterministe et gratuit** — aucun modèle. Seul le **Tier B** (paraphrases/synonymes
  sur les ~7 100 réponses ≥ 2 mots + 385 positionnels) consomme un modèle. Quel modèle/budget, batché par
  matière ? Recommandation : doctrine skills du repo (exécuteur bon marché + double-solve), priorisée
  (petites classes d'abord), non bloquante (défaut = bonne option seule).
- **Q-3 — boucle « refus contesté » (lot 6) : maintenant ou différée ? ✅ ARBITRÉE 2026-07-15.** Cadrer
  le **type `content_reports.recall_false_negative`** dès le **lot 1** (schéma/enum + acceptation
  serveur) ; livrer la **file admin** (`/admin/content-reports` filtré) et la procédure d'ajout de
  variante **après la campagne pilote** (lot 6), quand le volume réel est connu.
- **Q-4 — élargir l'éligibilité (R-6) aux questions aujourd'hui exclues ?** Hors-v1 ; à rouvrir si les
  KPI de couverture et de satisfaction le justifient (nécessiterait de générer des ensembles pour des
  questions jamais servies en Rappel).

## 8. Journal d'exécution

_(vide — à remplir lot par lot par l'exécuteur : date, lot, PR, écarts acceptés, dettes.)_

## 9. Annexe — mesure du corpus (recensement exhaustif, 2026-07-15)

**Méthode** : recensement **exhaustif** (pas d'échantillon) des 3 204 fichiers `quiz.json` +
`exercices/*.json` (76 sujets, ar/fr/en, tous niveaux) = **18 669 questions QCM**. Éligibilité
calculée par **portage fidèle 1:1 en JS de la fonction SQL déployée**
`is_question_recall_eligible` (a→i) + `normalize_recall_text` (`…/scratchpad/recall_exact.mjs`,
aucun fichier du dépôt modifié).

### Volumétrie

| Mesure                                  | Valeur     | %                        |
| --------------------------------------- | ---------- | ------------------------ |
| Questions QCM totales                   | **18 669** | 100 %                    |
| **Éligibles Rappel** (règle SQL exacte) | **12 349** | 66,1 % des QCM           |
| — prompt positionnel/localisation       | 385        | 3,1 % des éligibles      |
| — bonne réponse **≥ 2 mots**            | **7 137**  | **57,8 %** des éligibles |
| — bonne réponse 1 mot                   | 5 212      | 42,2 % des éligibles     |

| Langue | QCM    | Éligibles | Taux   | Positionnels | ≥2 mots | réponse en « ال »  |
| ------ | ------ | --------- | ------ | ------------ | ------- | ------------------ |
| **ar** | 12 435 | 8 556     | 68,8 % | 300          | 5 219   | **1 833 (21,4 %)** |
| **fr** | 3 636  | 2 145     | 59,0 % | 43           | 1 101   | —                  |
| **en** | 2 598  | 1 648     | 63,4 % | 42           | 817     | —                  |

### Lecture décisive pour l'architecture

Le portail d'éligibilité **et** la normalisation neutralisent DÉJÀ tout ce qui est typographique :
espacement, accents latins, hamza/ة/ى, tashkeel, ponctuation, système de chiffres. **Le faux
négatif résiduel est donc PUREMENT LEXICAL / MORPHOLOGIQUE / SYNTAXIQUE** — c'est exactement ce que
l'ensemble accepté doit couvrir. Trois gisements, par ordre de volume :

1. **Réponses ≥ 2 mots (7 137 ; 57,8 % des éligibles)** — reformulations multiples (synonyme, ordre,
   mot-outil ajouté/omis). Cible de la **génération sémantique (Tier B, IA + revue)**.
2. **Article défini (systématique)** — arabe « ال » : **1 833 réponses ar (21,4 % des éligibles ar)**,
   dont 1 004 aussi ≥ 2 mots ; **équivalent français** `le/la/l'` ajouté/omis (ex. 7-8 ci-dessous) ;
   **contractions anglaises** `they're`/`can't` vs formes pleines (ex. 10-11). Cible de la **génération
   morphologique déterministe (Tier A, SANS IA)** — voir §3.
3. **Positionnels (385 ; 3,1 %)** — peu nombreux mais **quasi tous à risque** (locution prépositionnelle
   à formulations concurrentes `في`/`داخل`, `on/in`, `dans/à`) ; échappent à la condition (g) d'éligibilité.

### Exemples concrets de faux négatifs (extraits — 12 relevés au total)

| #   | Fichier                                                                            | Bonne réponse          | Reformulations JUSTES refusées       |
| --- | ---------------------------------------------------------------------------------- | ---------------------- | ------------------------------------ |
| 2   | `math-1ere/07-reperage-espace/exercices/01-pratique.json` (ar)                     | داخل الصندوق           | في الصندوق · الصندوق                 |
| 4   | `eveil-scientifique-6eme/05-milieu-chaines-alimentaires/quiz.json` (ar)            | النبات الأخضر          | نبات أخضر (sans article)             |
| 5   | `culture-generale-politique-ar/01-institutions-et-regimes/exercices/02-boss.json`  | السلطة القضائية        | القضائية · سلطة قضائية               |
| 7   | `culture-generale-dungeon-fr/01-donjon-multi-themes/exercices/01-donjon-boss.json` | Afrique                | l'Afrique (article ajouté)           |
| 8   | idem                                                                               | Le Conseil de sécurité | Conseil de sécurité (sans article)   |
| 10  | `anglais-a1/01-verb-to-be/exercices/04-defi.json`                                  | They're on the table.  | They are on the table · On the table |
| 11  | `anglais-c1/03-modals-deduction/exercices/02-revision.json`                        | can't have             | cannot have                          |
| 12  | `english/09-reading-comprehension-writing/exercices/01-pratique.json`              | very clean             | clean · extremely clean (synonymes)  |

**Réserve** : la règle d'éligibilité est exacte (1:1 SQL) ; les axes positionnel/≥2 mots/« ال » sont
des **heuristiques de repérage de risque**, pas la logique de scoring — le taux réel de refus
dépendra des réponses effectivement tapées par les élèves (d'où le lot 5, boucle d'apprentissage).
