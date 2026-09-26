# STATUS — état du projet et feuille de route

<!-- roadmap-sync: since-pr=1098 -->

> **Instantané daté du 2026-09-23** (`main` à **#<!--status-sync:main-pr-->1098<!--/status-sync-->** ;
> exécution V1 « Apprendre & maîtriser » de la doctrine verticale, é26). **Document unique** pour
> savoir où en est le projet ET ce qui reste à faire : phase, décisions qui gouvernent, état réel
> des features et des études, **feuille de route (§6)**. Depuis le 2026-09-23 il n'y a plus de
> ROADMAP privée : elle a été fusionnée ici. Il ne duplique pas les documents normatifs —
> [AGENTS.md](./AGENTS.md) gagne en cas de conflit. Les études (`ETUDE.md`, leur index) et le
> programme go-live restent au **dépôt privé** `MBeji/yahia-quest-content` (`FableEtudes/`).
>
> **Règles de maintenance.** (1) Toute session qui livre un jalon structurant met à jour la
> section concernée, **et sa date**. (2) En cas de doute, le **code et les migrations font
> foi**, pas ce fichier — un statut se **constate**, il ne se déduit pas. (3) Les décisions se
> journalisent dans [`docs/journal-decisions.md`](./docs/journal-decisions.md) (append-only) ;
> §2 ne garde que celles qui gouvernent encore. (4) **Ne rien recopier qui a déjà un fichier**
> (détail d'un lot → le §4/§8 de son `ETUDE.md`, dette → `docs/dette-technique.md`, pièges →
> [`docs/agents/pieges-du-code.md`](./docs/agents/pieges-du-code.md), détail d'un incident → son
> issue ou sa PR). (5) Un compteur affirmé porte un marqueur `count:` que `harness:check`
> recalcule. (6) Le « `main` à #N » de l'en-tête porte le **seul** marqueur `status-sync` du
> fichier ; `status-freshness-watch.yml` le confronte chaque jour au tip de `main` et ouvre une
> issue `status-perime` au-delà de 25 PR d'écart. (7) Le marqueur `roadmap-sync` : tout lot
> d'étude livré au moteur après cette PR doit être **cité** ici (numéro de PR), sinon
> `check-roadmap-sync.mjs` (cron du dépôt privé) ouvre une issue `roadmap-drift`. Une ligne
> livrée **sort** de la §6 dans la PR qui la livre, avec une ligne au journal (§9).
>
> **Fusion du 2026-09-23** : la ROADMAP privée (531 lignes, refondue le matin même) et ce topo ne
> font plus qu'un. L'ancienne roadmap se lit par `git show cc8c123:FableEtudes/ROADMAP.md` dans le
> dépôt privé ; l'ancien récit de ce fichier par `git show 855d018:STATUS.md`.

---

## 1. Identité & phase actuelle

|                      |                                                                                                                                                                                                                                                                                                                                                                             |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Produit / marque** | **Na9ra Nal3ab** — académie d'apprentissage gamifiée, programme scolaire tunisien (13 niveaux + lycée en ouverture) + pistes libres (culture G, muscle-cerveau, langues)                                                                                                                                                                                                    |
| **Repos**            | `yahia-quest-arena` — le **moteur**, public · `MBeji/yahia-quest-content` — corpus, études, go-live (privé) · `MBeji/ScribeKit` — moteur de transcription. Les manuels se lisent chez le CNP par code (`npm run content:manuel:fetch`), les documents collectés vivent sur Google Drive                                                                                     |
| **Prod**             | **`https://www.na9ranal3ab.tn`** — seul hôte qui répond 200 (l'apex redirige en 308, `*.vercel.app` en 301). Push sur `main` = déploiement + auto-application des migrations. `SITE_URL` et `rel="canonical"` déclarent `www` (#706). ⚠️ Pour sonder : `-L` obligatoire, et un User-Agent non bloqué sur les pages HTML (le bot guard refuse `curl/` ; `/api/health` passe) |
| **Phase**            | **Bêta publique 100 % gratuite**, contenu praticable **sans compte**. L'infrastructure premium existe, **dormante et réversible** (étude 01, gelée)                                                                                                                                                                                                                         |
| **Jalon**            | Rentrée du 1ᵉʳ septembre **passée**. La « Porte 1 » du go-live n'attend plus que **GAP-003 / INPDP** (humain)                                                                                                                                                                                                                                                               |

---

## 1bis. Position de référence & scorecard (étude 28)

**Position** — _« la plateforme où l'élève tunisien s'entraîne et mesure sa maîtrise »_ : chez
les autres on regarde, ici on s'entraîne. Renoncement acté : pas de concurrence au cours vidéo,
canal ministériel hors cible. Soutenabilité : **B2B établissement**, l'élève reste gratuit
(suspendu au dégel de é01).

| KPI                                  | cible                                     | état (date du relevé)                                                                                                                                                                                                                                                                                              |
| ------------------------------------ | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **1 — un canal d'acquisition actif** | ≥ 1 ouvert et mesuré dans PostHog         | 🔴 **zéro** — D1/D2/D3 ouverts depuis le 2026-06-13. **C'est le goulot du projet** (2026-08-24)                                                                                                                                                                                                                    |
| **2 — la rétention est publiée**     | retour S(N)→S(N+1) calculé et affiché     | 🟢 la métrique existe et se lit (`/admin/engagement`, relevé hebdo automatique par `engagement-report.yml`, issue `engagement-releve`). ⚠️ `n` va de 1 à 5 : c'est du bruit tant que la ligne 1 n'amène personne. Source des « chapitres maîtrisés » : le grand livre `user_chapter_stars` depuis é34 (2026-09-14) |
| **3 — zéro différenciateur éteint**  | `user_misconceptions` non vide en prod    | 🟠 armé, pas prouvé — tagging de `math` 9ᵉ publié (662/818 questions, 81 % ; les 156 autres sont des muettes décidées). La table reste vide tant qu'aucun élève ne rate une question taguée (2026-08-24)                                                                                                           |
| **4 — classes de concours entières** | 6ᵉ 4/4 matières · 9ᵉ tenue à la barre é18 | 🟠 6ᵉ à 3/4 — le **français** manque (fiche transcrite, zéro contenu) · 9ᵉ : 6 matières (2026-08-24)                                                                                                                                                                                                               |
| **5 — verrous légaux levés**         | GAP-024 livré · GAP-003 tranché           | 🟠 GAP-024 complet côté code (pages légales #701, suppression de compte #791, `export_user_data` #948). **GAP-003 (INPDP) reste, humain** — la part Claude du dossier est livrée (`docs/inventaire-traitements-inpdp.md`) (2026-09-03)                                                                             |

---

## 2. Décisions structurantes

Seulement ce qui gouverne encore le travail ; l'historique complet est au
[journal](./docs/journal-decisions.md). Une nouvelle décision va au journal **et**, si elle change
l'état courant, ici.

| Décision                                              | Depuis           | Ce qu'elle impose                                                                                                                                                                                                          |
| ----------------------------------------------------- | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Gratuité de phase**                                 | 2026-06-21       | `is_premium = false` partout, aucune mission gatée, aucune surface ne dit « premium / abonnement / payant ». Machinerie dormante ; dégel par é01                                                                           |
| **Doctrine verticale — profondeur avant largeur**     | 2026-07-20 (é26) | V1 « Apprendre & maîtriser » avant l'expansion ; é06, é10, é12 **gelées** (réversible)                                                                                                                                     |
| **Le corpus n'est plus ici**                          | 2026-07-20 (é24) | `content/`, les <!--count:corpus-skills-->43<!--/count--> skills pédagogiques et `FableEtudes/` sont au privé ; `leak:check` échoue si du corpus revient. Le contenu se compile en `sql/content/*.sql`, plus en migrations |
| **`AGENTS.md` canonique, harness déclaratif**         | 2026-07-19 (é25) | Les fichiers par outil sont des pointeurs ; `harness/policy.json` est la source des vues générées, `harness:check` échoue sur dérive                                                                                       |
| **La chaîne est automatique**                         | 2026-07-27       | Push sur `main` = déploiement + migrations. Personne ne merge à la main : la session qui pousse reste de garde jusqu'au merge réel. Jamais de `supabase db push` sur la prod                                               |
| **Tout est autorisé aux sessions (option C)**         | 2026-09-05       | Famille `cloud-autonomy` ; les dénis gagnent toujours ; démarrage en « Accept edits » (`zero-intervention.md` § 2026-09-05)                                                                                                |
| **Le français du lycée est natif**                    | 2026-07-13       | Écrit directement en français, dans le jargon des manuels — aucun pont fr↔ar                                                                                                                                               |
| **R-5 se lit au chapitre**                            | 2026-07-29       | Une fiche `partielle` ne bloque pas la matière : on génère sur les sections réellement transcrites                                                                                                                         |
| **Sonder, pas déduire**                               | 2026-07-27       | Un état hors dépôt (DNS, secret, console tierce) se vérifie de l'extérieur avant d'être écrit                                                                                                                              |
| **Une lecture DÉCLARÉE n'est pas une lecture**        | 2026-09-19       | 24 fiches semées `complete` n'avaient été lues qu'en partie (9 % à 91 %) : repassées `partielle` / `pagesLues: inconnu`. `statut` et `profondeur` se **constatent**, jamais recopiés d'un seed                             |
| **Une question OUVERTE n'est servie qu'avec un juge** | 2026-09-13 (é33) | `short_answer` servie au seul élève dont la surface IA `open_answer` est active (`can_play_open_questions`, service ET dénominateur) ; l'IA ne peut que renverser un refus. Duel, donjon et bac blanc l'excluent           |

---

## 3. État réel des features (relu contre le code le 2026-08-24 ; colonne M le 2026-09-04)

**État** : 🟢 LIVE · 🟠 PARTIEL · 💤 DORMANT (code intact, inerte) · ⬜ ABSENT. **M** (é26,
[`doctrine-verticale.md`](./docs/doctrine-verticale.md) §3) : M0 absente · M1 squelette · M2
fonctionnelle sans excellence · **M3 = plancher de tout ce qui est LIVE** · M4 référence. Deux
lignes sur trente sont à M3 : c'est la dette que la doctrine rend visible. ⚠️ Une capacité dont
la charge utile vit au corpus se re-constate **depuis le dépôt privé**.

| Feature                                                        | État | M   | Note                                                                                                                                                                                              |
| -------------------------------------------------------------- | ---- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Boucle quête (QCM, XP, badges, streaks, boutique)              | 🟢   | M3  | `submit_exercise_attempt` ; soumissions mises en file locale avant envoi (`outbox.ts`)                                                                                                            |
| Types de questions natifs (numeric, ordering, matching, multi) | 🟢   | M2  | é03. Minces : ~1,2 % du corpus                                                                                                                                                                    |
| Donjon                                                         | 🟢   | M2  | verrous = progression (PREREQ/LEVEL/DAILY_LIMIT), plus un avantage premium                                                                                                                        |
| Duels temps réel & ligues hebdo                                | 🟢   | M2  | é05 ; pg_cron `expire-duels` + `award-duel-league-week`                                                                                                                                           |
| Arène (Donjon·Duels·Classement) + coquille parent              | 🟢   | M2  | é15, `/arene`                                                                                                                                                                                     |
| Paramétrage unique (`/parametrage`) + pôle `/console`          | 🟢   | M2  | #787 ; pseudo modifiable                                                                                                                                                                          |
| Suppression de compte + export des données (GAP-024)           | 🟢   | M2  | effacement dur (#791), `export_user_data` dérivé du catalogue (#948, pgTAP 85)                                                                                                                    |
| Plateforme publique sans login                                 | 🟢   | M2  | catalogue → cours → pratique corrigée, trilingue                                                                                                                                                  |
| Manuel élève officiel (lien public)                            | 🟢   | M2  | `src/shared/content/manuel-cnp.ts`, ni bucket ni upload                                                                                                                                           |
| Suivi parent (lien famille + rapport public par code)          | 🟢   | M2  | #335                                                                                                                                                                                              |
| Suivi parental jour par jour                                   | 🟢   | M2  | `learning_pulses`, couverture du programme, « ce qui manque » par chapitre — [spec](./docs/suivi-parental-quotidien.md)                                                                           |
| Signalement d'erreur de contenu / de bug                       | 🟢   | M2  | `content_reports`, `bug_reports`, consoles admin, `report-apply.yml` applique les recommandations mûries                                                                                          |
| Notifications push                                             | 🟢   | M3  | service worker + souscriptions                                                                                                                                                                    |
| SEO (sitemap, robots, meta, canonique)                         | 🟢   | M2  | Search Console vérifiée ; canonique `www` (#706)                                                                                                                                                  |
| Moteur adaptatif (é04)                                         | 🟢   | M2  | A0 → A2 clos ; armé par le tagging `math` 9ᵉ, `user_misconceptions` encore vide. `difficulty_adaptation` supprimée (#910/#911)                                                                    |
| Tuteur déterministe (é30, lots 0bis→4)                         | 🟢   | M2  | croyance BKT, inférence dans le graphe, frontière ZPD, décision — sans clé d'IA. Aucune surface n'affiche `p_known`. Lots 5-9 différés                                                            |
| Knowledge graph / compétences (é07)                            | 🟢   | M2  | 5/5 lots ; 62 compétences / 80 arêtes ; tagging hors `math` = fil CONTENU                                                                                                                         |
| Parcours élève & progression (é22)                             | 🟢   | M2  | carte honnête, « Ma classe », prochaine action unifiée. Porte du quiz définie une fois (`chapter_quiz_gated`/`_cleared`, #1005)                                                                   |
| Étoiles de chapitre & sceaux de matière (é34)                  | 🟢   | —   | grand livre insert-only (lot 1, M non évaluée), la progression ne recule plus — [spec](./docs/etoiles-et-sceaux.md)                                                                               |
| Réponses acceptées / `short_answer` (é20)                      | 🟢   | M2  | Tier A au build ; 119 `short_answer` en `math` 9ᵉ, **servies à personne** tant qu'aucune famille n'active `open_answer` (é33)                                                                     |
| Rappel actif (é17)                                             | 🟢   | M2  | saisie libre normalisée côté serveur, XP ×1,5                                                                                                                                                     |
| Examen blanc (é02)                                             | 🟢   | M2  | `/examens`, coefficients réels du concours ; détail par épreuve, pas par chapitre ; annales à produire au privé                                                                                   |
| Tuteur IA « El Ostedh » (é11, 8/8 lots)                        | 🟢   | M2  | bulle permanente (grisée sans clé), chat cadré par chapitre, bilans hebdo, éviction du cache sur deux 👎 distincts. Garde anti-triche sur les épreuves **vivantes** (`81_tutor_gate_live_trials`) |
| Mode IA « à la clé de la famille » (é29, BYOK)                 | 🟢   | M2  | clé famille ou plateforme (DeepSeek, depuis 2026-09-01) ; plafonds 2 $/j, 20 $/mois ; `AI_LIVE_FEATURES` ouvre toutes les surfaces à l'activation. Pilote suivi dans #1087                        |
| Consoles admin                                                 | 🟢   | M2  | 8 routes `/admin/*` gardées `is_admin`                                                                                                                                                            |
| Domaines de programme sous une matière                         | 🟠   | M1  | code livré (`chapters.domain`, #766/#767), **inerte** tant que le corpus ne déclare aucun domaine                                                                                                 |
| PWA / offline                                                  | 🟠   | M1  | manifest + SW seulement ; lecture offline = é06, gelée                                                                                                                                            |
| Gate premium · paywall · beta-access                           | 💤   | M1  | inerte (`is_premium=false`) ; réactivation = `UPDATE` inverse (é01)                                                                                                                               |
| Paiement en ligne                                              | ⬜   | M0  | é01 gelée                                                                                                                                                                                         |

---

## 4. Études (FableEtudes) — instantané

> L'**état**, pas le « comment » : la source est `FableEtudes/README.md`, l'en-tête de chaque
> `ETUDE.md` (privé) ; le reste-à-faire est en §6. `etudes:check` (Content CI privée) échoue sur
> toute contradiction entre ce tableau, l'index et les en-têtes. Ne pas y recopier le détail des
> lots.

| État                                       | Études                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Livrées** — dossier dans `EtudeRealisé/` | **11** tuteur IA « El Ostedh » · **02** examen blanc · **03** types de questions natifs · **04** moteur adaptatif · **05** duels & ligues · **07** knowledge graph & maîtrise · **13** moteur de transcription (ScribeKit) · **14** refonte UX/design · **15** contenu & composition des écrans · **17** rappel actif · **18** cours vivants · **22** parcours élève & progression · **28** stratégie de référence · **29** mode IA « à la clé de la famille » · **30** tuteur déterministe (lots 5-9 différés) · **31** l'envie de revenir · **32** harness : optimiser, simplifier · **26** doctrine verticale · **21** valorisation des manuels (lot 3 abandonné) · **35** comprendre la théorie (lot 7 différé au premier trafic) · **34** étoiles & sceaux (lot 5 différé) · **20** réponses acceptées (mesure différée au volume, lot 4 → campagne) |
| **Scission faite**                         | **24** protection IP — lots 1-4 livrés, gate anti-fuite en place ; lot 5 (purge de l'historique public) reporté, lot 6 partiel                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **En exécution**                           | **09** économie du jeu (lots 1-2) · **16** ouverture lycée (reste la campagne) · **23** vidéos explicatives (reste le lot 5) · **25** harness AI-native (reste L7)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Validées**                               | **19** questions illustrées                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| **Brouillons**                             | **08** analytics familles\* · **27** sources web tierces                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| **Gelées**                                 | **01** paiement en ligne (véhicule de dégel du premium) · **06** PWA offline, **10** anti-fraude, **12** studio d'ingestion (doctrine verticale, réversible)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |

\* é08 porte le **canal enseignant** (é28 Q-3), derrière la précondition D-5 (GAP-024 + GAP-003) ;
sa justification « premium » est à re-scoper à sa validation. Illustrations : é18 = cours, é19 =
questions — leurs campagnes suivent la §6.1.

---

## 5. Programme go-live

Au privé, `FableEtudes/go-live/` (entrée : son `README.md`). Chantiers C1, C2, C3, C4, C5, C7
**clos** ; C6 supersédé par la gratuité (archive de dégel pour é01) ; C8 (plateforme publique)
**live** depuis le 2026-06-22. **La Porte 1 n'attend plus qu'une chose, et ce n'est pas du code :**
**GAP-003** (conformité mineurs / INPDP) — décisions humaines ; é29 §3.8 y ajoute un registre de
traitement pour le mode IA. GAP-024 ne garde qu'un reste non codable : l'identité de l'éditeur
pour des mentions légales complètes. Le kill-switch `rollback-prod.yml` est testé (dispatchable
par une session, famille `ops-dispatch`).

---

## 6. Feuille de route — le reste-à-faire, trié (2026-09-23)

### 6.0 Les quatre règles

1. **Finir avant d'ouvrir.** Au plus **deux** campagnes de contenu et **deux** chantiers de
   code ouverts en même temps. On n'ouvre pas de nouveau couple niveau × matière tant qu'une
   campagne de la §6.1 reste ouverte, et on ne commence aucun lot de la §6.3.
2. **Une ligne = une session = une PR**, suivie jusqu'au merge réel (et, pour du contenu,
   jusqu'à la prod).
3. **Un statut se vérifie en lançant la commande ou en lisant l'issue** ; on ne se fie jamais à
   la ligne qui en parle (§8, L-1 et L-7). Pour le contenu : `npm run programme:etat` (ce qui
   manque), l'issue `content-drift` du dépôt privé (mergé mais pas en prod), `/campagne`.
4. **Une ligne livrée sort de cette section** dans la PR qui la livre, avec une ligne au
   journal (§9) qui cite la PR. On ne garde jamais une ligne cochée : c'est elle qui périme.

**Reprise pour une session vierge** : les contrats d'exécution (`ETUDE.md`, go-live) sont au
dépôt privé — pour une ligne de code, démarrer ici et lire l'étude là-bas ; pour du contenu,
démarrer au privé. pgTAP tourne sur les PR de migration mais **n'est pas requis** : un rouge
n'arrête pas l'auto-merge, il faut aller le lire.

**Chemin critique vers l'acquisition** : GAP-003 (humain) → é28 D-5 levée → é08 volet
enseignant (§6.3) → premier canal actif (KPI-1, à zéro depuis le 2026-06-13). Il ne reste **rien
de codable** avant GAP-003.

### 6.1 Priorité 1 — un contenu juste, compris, et qui sert vraiment l'élève

> **Arbitrage du propriétaire, 2026-09-23** : les mesures qui demandent un volume d'usage
> (pilote IA, `short_answer`, « cours → quiz ») sont dépriorisées — le volume n'existe pas
> encore. **L'effort va au contenu.** Sa qualité se prouve **sans élèves**, par cinq
> contrôles qui existent déjà ; un chapitre n'est « fini » que s'il les passe tous.

**La barre d'un chapitre qui a de la valeur** (chaque niveau a son outil, aucun n'est déclaratif) :

| #   | Le chapitre est…                                                              | Prouvé par                                                                                 |
| --- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| 1   | **Au programme** — les bonnes notions, à la bonne année, depuis la source CNP | fiche R-5 lue en entier, `programme:check`                                                 |
| 1   | **Compris** — chaque notion part du concret, se montre, se vérifie sur place  | patron de notion (é35) : `coursePattern` posé, contrôles C-1…C-7 en `error`                |
| 2   | **Diagnostique** — chaque mauvaise réponse nomme l'erreur de l'élève          | distracteurs tagués au registre des erreurs (é30), C-5                                     |
| 3   | **Juste** — aucune clé fausse, aucune explication fausse                      | audit indépendant qui **re-résout** chaque question (`content-audit`), `content:qa:strict` |
| 4   | **En production** — l'élève le voit                                           | `apply-content.yml` joué, issue `content-drift` close                                      |

**Par où commencer : les classes de concours** (6ᵉ et 9ᵉ), là où l'enjeu pour l'élève est le
plus fort. État mesuré le 2026-09-23 sur les 10 matières servies (plus `french-6eme`, absent) :

| Matière (id)                  | Niveau 2 (patron)                                            | Niveau 3 (tags) |
| ----------------------------- | ------------------------------------------------------------ | --------------- |
| maths 9ᵉ (`math`)             | ✅ armé (`error`)                                            | ✅              |
| arabe 9ᵉ, français 9ᵉ, SVT 9ᵉ | ✅ écrit, pas armé                                           | ❌              |
| anglais 6ᵉ (`english-6eme`)   | ✅ écrit, pas armé                                           | ❌              |
| **maths 6ᵉ** (`math-6eme`)    | ✅ armé (`error`) — campagne finie le 2026-09-23             | ✅ 1 347 tags   |
| physique-chimie 9ᵉ (`svt`)    | ✅ écrit, pas armé — réalignée sur le manuel le 2026-09-25   | ❌              |
| anglais 9ᵉ (`english`)        | ✅ écrit, pas armé — réalignée sur les manuels le 2026-09-25 | ❌              |
| arabe 6ᵉ (`arabic-6eme`)      | ✅ écrit, pas armé — réaligné sur le manuel le 2026-09-26    | ❌              |
| éveil scientifique 6ᵉ         | ❌                                                           | ❌              |
| **français 6ᵉ**               | — la matière n'existe pas (fiche partielle, LOT A d'abord)   | —               |

**Les deux campagnes ouvertes** (règle 1 : pas plus de deux) :

1. **Concours au patron** — une matière par campagne, dans l'ordre : ~~`math-6eme`~~ (✅ finie
   le 2026-09-23 : 24/24 chapitres, manuel élève lu à 73 %, privé#535 → privé#542),
   ~~physique-chimie 9ᵉ (`svt`)~~ (✅ patron écrit le 2026-09-25, privé#546 : AUCUNE fiche
   n'existait — le contenu servi enseignait la loi d'Ohm et les lentilles, hors programme, et
   ignorait la moitié du programme ; manuel 103902 lu en entier, 13 chapitres dont 4 neufs,
   armement en attente de ses tags), ~~anglais 9ᵉ (`english`)~~ (✅ patron écrit le 2026-09-25, privé#548 : Student's Book 141906 et Workbook 141907 lus en entier — le passif, le discours indirect, le 2ᵉ/3ᵉ conditionnel, _unless_ et _whose/where_ n'y sont pas enseignés ; 06 et 07 réalignés en place sur les _Communicative Functions_ et le _Word Building_, les extras gardés en « Going further » sans item ; armement en attente de ses tags), ~~arabe 6ᵉ (`arabic-6eme`)~~ (✅ patron écrit le 2026-09-26, privé#553 : manuel élève 101612 p.3–124 lu à l'image, 31 leçons ; arbitrage du propriétaire « la grammaire seule » — lecture et production écrite restent non servies ; 13 chapitres réalignés, la leçon 26 (الواو والياء في ج.م.س المضاف) enfin enseignée ; armement en attente de ses tags), puis, éveil 6ᵉ ; puis les tags (niveau 3) des
   matières au patron non armé ; puis `french-6eme`. Chaque matière finit par un audit
   indépendant (niveau 4) et sa publication (niveau 5). **Chaque tranche commence par lire le
   manuel élève à l'image** : sur `math-6eme`, cette lecture a trouvé une trentaine de notions
   pratiquées par le manuel et absentes de la fiche (division par un décimal, échelle,
   multiplication d'une durée, médiatrice, bissectrice, aire du losange…). Reste à la matière un
   lot « exercices » : items sur ces notions neuves, paires d'items quasi identiques.
2. **Arabe de base 1ʳᵉ→8ᵉ** — arbitrages rendus le 2026-09-23 (synthèse §4bis au dépôt privé) :
   (a) réaligner les ~10 notions servies hors année sur le programme post-2006, **sans renommer
   ni supprimer de slug** (sinon étoiles et sceaux orphelins) ; (b) ouvrir le canal `نصوص`,
   8ᵉ d'abord ; (c) les 11 مدوّنات القسم comptent comme sources — les 7 de maths et de français
   sont lues par les campagnes de ces matières.

Leur avancement se lit avec `programme:etat` et `/campagne`, jamais ici.

**Code, seulement ce qui sert ces campagnes.** Reste à clore é09, après A16 (§6.2).

### 6.2 Ce qui attend le propriétaire

Rien ici n'est codable — seulement ce qui cite un mur de
[`zero-intervention.md`](./docs/agents/zero-intervention.md). Dans l'ordre :

| #   | Geste / décision                                                                                                                                       | Débloque                                          |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------- |
| 2   | **Déclaration INPDP (GAP-003)** — tout ce qui se décide est isolé au §7 de [`inventaire-traitements-inpdp.md`](./docs/inventaire-traitements-inpdp.md) | é28 D-5 → é08 enseignant → canal d'acquisition    |
| 3   | **A16** : le rachat de série couvre **53 %** des jours manqués (G-4 ≤ 20 %, garde-fou corrigé par #947). Desserrer le seuil ou renchérir le shield     | `economy:check` vert, clôture de é09              |
| 4   | **é25 L7** : drill de portabilité, une session avec le propriétaire                                                                                    | clôture de é25                                    |
| 5   | Console : coller les 3 gabarits d'e-mail FR dans Supabase ; vérifier qu'un `web_vitals` arrive dans PostHog                                            | premier contact parent en français ; perf mesurée |
| 5   | Démarches externes : é23 Q-3 (app child-directed auprès de Google), é24 Q-4 (OTDAV/INNORPI)                                                            | —                                                 |

### 6.3 Gelé, bloqué ou différé — rien ne se lance avant sa condition

| Quoi                                                                                                                 | Condition d'entrée                                               |
| -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **é08 volet enseignant** (classes + code, liste + taux par chapitre, devoir)                                         | é28 D-5 levée (GAP-003) ; Q-4 de l'étude tranchée avant le lot 4 |
| é08 : trois lots parent (examen blanc au rapport, digest hebdo opt-in, comparatif seuillé)                           | un chantier de code libre — les premiers à prendre ensuite       |
| é34 lot 5 : l'échelle nommée des 50 niveaux                                                                          | la liste des 50 savants, livrée et relue (contenu)               |
| Pilote IA Q-9 — **clos le 2026-09-23** « armé, sans volume » ; le relevé hebdomadaire (#1087) continue seul          | un volume d'usage minimal (KPI-1 > 0)                            |
| é20 : mesure du pilote `short_answer` (119 questions libres, maths 9ᵉ)                                               | un volume d'usage minimal                                        |
| é20 lot 4 : campagne `acceptedAnswers` Tier B                                                                        | une place libre en §6.1 (après les concours)                     |
| é23 lot 5 : vidéos `math` 9ᵉ                                                                                         | une place libre en §6.1                                          |
| é16 vague A : les quatre matières lycée restantes (ouverture)                                                        | une place libre en §6.1 — profondeur avant largeur               |
| é35 lot 7 : la mesure « cours → quiz » (`admin_lesson_to_quiz_outcome` + bloc console), spécifiée au §3.2 de l'étude | KPI-1 > 0 — le premier trafic (arbitrage Q-6)                    |
| é20 lot 6 : boucle du refus contesté (optionnel)                                                                     | un signalement réel « réponse juste refusée »                    |
| é09 lot 3 : snapshot `economy_daily_stats`                                                                           | un constat mesuré (RPC > 2 s ou écart de coins gênant)           |
| é30 lots 5-9                                                                                                         | du volume réel dans `user_misconceptions` (vide en prod)         |
| é19 questions illustrées (validée, jamais démarrée)                                                                  | une place libre en §6.1                                          |
| é24 lot 5 : purge de l'historique git public · lot 6 : tier e2e authentifiée                                         | une fenêtre calme constatée                                      |
| #660 : `typescript` v7                                                                                               | `typescript-eslint` compatible en amont — ne rien forcer         |
| é27 sources web tierces (brouillon)                                                                                  | Q-1…Q-5 arbitrées                                                |
| é06 PWA offline · é10 anti-fraude · é12 studio d'ingestion                                                           | dégel explicite par le propriétaire (é10 : au volume réel)       |
| é01 paiement en ligne                                                                                                | sortie de la phase gratuite                                      |

**Tranché le 2026-08-24, à ne pas rouvrir sans raison neuve** (détail au journal des décisions) :
G-1 devient une fenêtre par profil ; canari `npm ci --dry-run` sous npm 10 avec Node 24 ;
e-mails d'authentification en anglais ; dossier INPDP monté en interne.

### 6.4 Issues ouvertes au moteur (re-sondé le 2026-09-23 — à re-sonder avant d'y croire)

| Issue     | Quoi                                                                                                                                                                                        |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **#1087** | 🤖 Relevé du pilote IA (é29 §1.4), tenu chaque lundi par `ai-pilot-report.yml`                                                                                                              |
| **#1002** | Identifiants hors dépôt : `GH_AUTOMATION_PAT` renouvelé sans expiration le 2026-09-23 (#1078 close par sa garde) ; `CLAUDE_CODE_OAUTH_TOKEN` non daté, sa mort sera constatée, pas prévenue |
| **#962**  | 📈 Relevé d'engagement hebdo (é31) — informatif                                                                                                                                             |
| **#937**  | Gates orphelins : la classe est fermée par une garde                                                                                                                                        |
| **#660**  | Major `typescript` v7 — voir §6.3                                                                                                                                                           |

PR [#932](https://github.com/MBeji/yahia-quest-arena/pull/932) : savepoint volontaire en `draft/`.
Branches distantes sans PR : du ménage, pas un backlog ; une session cloud ne peut pas en
supprimer (#1094).

---

## 7. Carte de la documentation

| Document                                                             | Rôle                                                                                 |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| [AGENTS.md](./AGENTS.md)                                             | **Canonique** : commandes, conventions, DoD, gotchas — gagne sur tout autre document |
| [CLAUDE.md](./CLAUDE.md)                                             | `@AGENTS.md` + le câblage propre à Claude Code                                       |
| [ARCHITECTURE.md](./ARCHITECTURE.md)                                 | Stack, flux, modèle de données                                                       |
| **STATUS.md** (ce fichier)                                           | Topo **et feuille de route** : état features/études, reste-à-faire trié              |
| [docs/journal-decisions.md](./docs/journal-decisions.md)             | Décisions datées, append-only                                                        |
| [docs/dette-technique.md](./docs/dette-technique.md)                 | Dette de code encore ouverte                                                         |
| [docs/agents/](./docs/agents/README.md)                              | Playbooks d'exploitation (zéro intervention, pièges, collaboration, gardes, cloud)   |
| [docs/audit-global-2026-09-12.md](./docs/audit-global-2026-09-12.md) | Audit global daté — descend dans `docs/archive/` une fois traité                     |
| [docs/archive/](./docs/archive/README.md)                            | Audits one-shot dépassés — historique, jamais un backlog                             |
| `FableEtudes/` + `go-live/` (**privé**)                              | Études (`ETUDE.md` + index), programme go-live                                       |

---

## 8. Leçons de méthode (payées par des pannes réelles)

- **L-1** — Une priorité écrite le jour J et mergée à J+6 est un instantané périmé. Relire
  l'issue ou le code avant de prendre une ligne.
- **L-2** — Une garde qui échoue en silence ne se distingue pas d'une garde qui passe. Ce qui
  manque n'est jamais la garde, c'est que sa panne atteigne quelqu'un.
- **L-3** — Une fonction SQL vivante se **substitue** depuis son texte extrait, elle ne se retape
  pas (`get_daily_plan`, #818).
- **L-4** — Un seuil dupliqué devient faux à plusieurs endroits ; ne jamais recopier une RPC
  existante, cela crée un second juge sur la même question.
- **L-5** — La prod ne juge pas la reconstructibilité de la base, et un gate vert veut dire
  seulement « rien de ce que je sais lire ne manque ».
- **L-6** — Le contenu commande le produit : avant de conclure qu'une ligne de code est bloquée,
  lancer `programme:etat`.
- **L-7** — Un chiffre vit à plusieurs endroits d'un document : après l'avoir changé, le `grep`
  avant de committer.
- **L-8** — Une horloge sans relève n'est pas une horloge : le verdict Q-9 « attendu
  ≈ 2026-09-15 » est passé sans que personne ne relève la mesure (#1086 l'a automatisée), et une
  campagne finie le 2026-09-18 était encore donnée « à faire » le 2026-09-23. Moins de chantiers
  ouverts = moins de lignes à tenir justes (§6.0 règle 1).

---

## 9. Journal de la feuille de route

> Une ligne par événement, qui cite ses PR (moteur : `#N` ; dépôt privé : `privé#N`).

| Date       | Événement                                                                                                                                                                                                                                                                                                                                                                                                     |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-09-26 | **Arabe 6ᵉ réaligné sur le manuel officiel** (privé#553) : 101612 p.3–124 lu à l'image leçon par leçon ; arbitrage du propriétaire — la grammaire au patron, lecture et production écrite hors campagne ; 13 chapitres réécrits (notions hors manuel retirées, leçon 26 ajoutée), audit indépendant en 4 passes ; publié en production                                                                        |
| 2026-09-25 | **Anglais 9ᵉ réaligné sur les manuels officiels** (privé#548) : Student's Book et Workbook lus en entier, fiche R-5 complétée ; arbitrages du propriétaire — 06 et 07 réalignés en place (passif et discours indirect hors programme), 2ᵉ conditionnel / _unless_ / _whose-where_ gardés en « pour aller plus loin » sans item ; 10 chapitres au patron, audit indépendant en 3 passes ; publié en production |
| 2026-09-25 | **Physique-chimie 9ᵉ réalignée sur le manuel officiel** (privé#546) : aucune fiche n'existait ; manuel 103902 lu en entier ; arbitrage du propriétaire « réaligner en place » — 08 (Ohm) devient le courant alternatif, 03 perd les lentilles, 01 devient un rappel de 8ᵉ, 4 chapitres neufs ; audit indépendant des 13 chapitres ; publiée en production                                                     |
| 2026-09-23 | **Maths 6ᵉ au patron, campagne finie** : 24 chapitres réécrits en 4 tranches (privé#535, #537, #539, #542), chacune après lecture du manuel élève (30 → 127 p. / 174) et un audit indépendant ; `coursePattern` armé en `error`, publiée en production                                                                                                                                                        |
| 2026-09-23 | **Le contenu devient la priorité 1** (arbitrage du propriétaire) : pilote Q-9 clos « armé, sans volume », mesures à volume différées ; é20 et é34 livrées ; §6.1 réécrite autour de la barre de qualité en cinq niveaux et des classes de concours                                                                                                                                                            |
| 2026-09-23 | `GH_AUTOMATION_PAT` renouvelé sans date d'expiration ; la garde, qui mourait sur ce cas, corrigée (#1105) et #1078 refermée par elle                                                                                                                                                                                                                                                                          |
| 2026-09-23 | é35 livrée : bilan (lot 8) au privé — 20/20 chapitres au patron, 0 erreur ; lot 7 différé au premier trafic (Q-6), Q-5 à trancher                                                                                                                                                                                                                                                                             |
| 2026-09-23 | Arabe 1ʳᵉ→8ᵉ : trois arbitrages rendus (oui · oui · oui) ; 11 مدوّنات القسم requalifiées en sources au registre                                                                                                                                                                                                                                                                                               |
| 2026-09-23 | **ROADMAP privée fusionnée dans ce fichier** — un seul document pour l'état et le reste-à-faire ; `roadmap-sync` lit désormais STATUS.md, base à #1098                                                                                                                                                                                                                                                        |
| 2026-09-23 | Refonte « finir avant d'ouvrir » de la roadmap (privé#524, #1098) : règle de WIP, chaque ligne ouverte triée                                                                                                                                                                                                                                                                                                  |
| 2026-09-22 | Pilote IA mesuré chaque lundi (#1086, #1088) ; STATUS.md réduit à l'état (#1095)                                                                                                                                                                                                                                                                                                                              |
| 2026-09-18 | é35 : patron de notion étendu au concours 9ᵉ, campagne finie (privé#420 → privé#437)                                                                                                                                                                                                                                                                                                                          |
| 2026-09-16 | é35 validée, lots 1 à 6 livrés (#1050, privé#403 → privé#413)                                                                                                                                                                                                                                                                                                                                                 |
| 2026-09-14 | é34 étoiles & sceaux : lots 1 à 4 livrés (#1036, #1040 → #1045)                                                                                                                                                                                                                                                                                                                                               |
| 2026-09-02 | `export_user_data` livré (#948) : D-5 n'attend plus que GAP-003                                                                                                                                                                                                                                                                                                                                               |
| 2026-09-01 | é11 : 8 lots livrés (#844) ; le pilote Q-9 démarre avec les deux clés                                                                                                                                                                                                                                                                                                                                         |
