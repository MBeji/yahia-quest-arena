# STATUS — état du projet (topo central)

> **Instantané daté du 2026-09-22** (`main` à **#<!--status-sync:main-pr-->1094<!--/status-sync-->** ;
> exécution V1 « Apprendre & maîtriser » de la doctrine verticale, é26). **Point d'entrée unique**
> pour savoir où en est le projet : phase, décisions qui gouvernent, état réel des features,
> études, travaux en vol. Il ne duplique pas les documents normatifs — [AGENTS.md](./AGENTS.md)
> gagne en cas de conflit. Les études, la ROADMAP et le programme go-live vivent au **dépôt
> privé** `MBeji/yahia-quest-content` (`FableEtudes/`).
>
> **Règles de maintenance.** (1) Toute session qui livre un jalon structurant met à jour la
> section concernée, **et sa date**. (2) En cas de doute, le **code et les migrations font
> foi**, pas ce fichier — un statut se **constate**, il ne se déduit pas. (3) Les décisions se
> journalisent dans [`docs/journal-decisions.md`](./docs/journal-decisions.md) (append-only) ;
> §2 ne garde que celles qui gouvernent encore. (4) **Ne rien recopier qui a déjà un fichier**
> (lots → ROADMAP privée, dette → `docs/dette-technique.md`, pièges →
> [`docs/agents/pieges-du-code.md`](./docs/agents/pieges-du-code.md), détail d'un incident → son
> issue ou sa PR). (5) Un compteur affirmé porte un marqueur `count:` que `harness:check`
> recalcule. (6) Le « `main` à #N » de l'en-tête porte le **seul** marqueur `status-sync` du
> fichier ; `status-freshness-watch.yml` le confronte chaque jour au tip de `main` et ouvre une
> issue `status-perime` au-delà de 25 PR d'écart (il a décroché trois fois : 27, 68, 114 PR).
>
> **Cure du 2026-09-22** : 670 lignes / 262 Ko → cette version. Rien n'a été re-sondé pour
> l'occasion au-delà du §6 ; le récit complet des passes précédentes reste lisible par
> `git show 855d018:STATUS.md`.

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
> `ETUDE.md` et `FableEtudes/ROADMAP.md` (privé). `etudes:check` (Content CI privée) échoue sur
> toute contradiction entre ce tableau, l'index et les en-têtes. Ne pas y recopier le détail des
> lots.

| État                                       | Études                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Livrées** — dossier dans `EtudeRealisé/` | **11** tuteur IA « El Ostedh » · **02** examen blanc · **03** types de questions natifs · **04** moteur adaptatif · **05** duels & ligues · **07** knowledge graph & maîtrise · **13** moteur de transcription (ScribeKit) · **14** refonte UX/design · **15** contenu & composition des écrans · **17** rappel actif · **18** cours vivants · **22** parcours élève & progression · **28** stratégie de référence · **29** mode IA « à la clé de la famille » · **30** tuteur déterministe (lots 5-9 différés) · **31** l'envie de revenir · **32** harness : optimiser, simplifier · **26** doctrine verticale · **21** valorisation des manuels (lot 3 abandonné) |
| **Scission faite**                         | **24** protection IP — lots 1-4 livrés, gate anti-fuite en place ; lot 5 (purge de l'historique public) reporté, lot 6 partiel                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| **En exécution**                           | **34** étoiles & sceaux (lot 1 livré) · **09** économie du jeu (lots 1-2) · **35** comprendre la théorie (lots 1-2 livrés, reste la campagne maths 9ᵉ) · **16** ouverture lycée (reste la campagne) · **20** réponses acceptées (lots 1·2·3·5·7) · **23** vidéos explicatives (reste le lot 5) · **25** harness AI-native (reste L7)                                                                                                                                                                                                                                                                                                                                 |
| **Validées**                               | **19** questions illustrées                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| **Brouillons**                             | **08** analytics familles\* · **27** sources web tierces                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| **Gelées**                                 | **01** paiement en ligne (véhicule de dégel du premium) · **06** PWA offline, **10** anti-fraude, **12** studio d'ingestion (doctrine verticale, réversible)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

\* é08 porte le **canal enseignant** (é28 Q-3), derrière la précondition D-5 (GAP-024 + GAP-003) ;
sa justification « premium » est à re-scoper à sa validation. Illustrations : é18 = cours, é19 =
questions — leurs campagnes vivent dans la ROADMAP privée.

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

## 6. Travaux en vol (re-sondé le 2026-09-22)

**PR ouverte au moteur** : [#932](https://github.com/MBeji/yahia-quest-arena/pull/932), savepoint
volontaire en `draft/` (pgTAP du verrouillage de `client_errors`) — rien n'attend un merge.

**Issues ouvertes au moteur** (comptées par l'API ; à re-sonder avant de croire ce tableau) :

| Issue     | Quoi                                                                                                                                            |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **#1092** | `upgrade-guard` : un conflit de peer fait échouer le lot patch/minor — la garde n'a jamais appliqué un lot. Travail de code                     |
| **#1087** | 🤖 Relevé du pilote IA (é29 §1.4), tenu chaque lundi par `ai-pilot-report.yml`. Premier relevé : 1 famille, 0,078 $ — la question est le volume |
| **#1078** | 🔑 `GH_AUTOMATION_PAT` expire le **2026-10-04** — geste navigateur, aucune session ne peut le faire                                             |
| **#1002** | Identifiants hors dépôt : moitié PAT couverte par #1078 ; `CLAUDE_CODE_OAUTH_TOKEN` non daté, sa mort sera constatée, pas prévenue              |
| **#962**  | 📈 Relevé d'engagement hebdo (é31) — informatif                                                                                                 |
| **#937**  | Gates orphelins : la classe est fermée par une garde                                                                                            |
| **#660**  | Major `typescript` v7 — gate rouge, `typescript-eslint` bloquant. Attendre l'amont                                                              |

Branches distantes sans PR : du ménage, pas un backlog (vérifiées par le contenu le 2026-08-26 —
aucune ne porte de travail perdu). Une session cloud ne peut pas supprimer une branche distante
(#1094).

---

## 7. Carte de la documentation

| Document                                                             | Rôle                                                                                 |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| [AGENTS.md](./AGENTS.md)                                             | **Canonique** : commandes, conventions, DoD, gotchas — gagne sur tout autre document |
| [CLAUDE.md](./CLAUDE.md)                                             | `@AGENTS.md` + le câblage propre à Claude Code                                       |
| [ARCHITECTURE.md](./ARCHITECTURE.md)                                 | Stack, flux, modèle de données                                                       |
| **STATUS.md** (ce fichier)                                           | Topo : phase, décisions qui gouvernent, état features/études/chantiers               |
| [docs/journal-decisions.md](./docs/journal-decisions.md)             | Décisions datées, append-only                                                        |
| [docs/dette-technique.md](./docs/dette-technique.md)                 | Dette de code encore ouverte                                                         |
| [docs/agents/](./docs/agents/README.md)                              | Playbooks d'exploitation (zéro intervention, pièges, collaboration, gardes, cloud)   |
| [docs/audit-global-2026-09-12.md](./docs/audit-global-2026-09-12.md) | Audit global daté — descend dans `docs/archive/` une fois traité                     |
| [docs/archive/](./docs/archive/README.md)                            | Audits one-shot dépassés — historique, jamais un backlog                             |
| `FableEtudes/` + `go-live/` (**privé**)                              | Études, ROADMAP, programme go-live                                                   |

---

## 8. Prochaines actions

> **L'ordre fait foi dans la ROADMAP privée** (`FableEtudes/ROADMAP.md`, refondue le 2026-09-23 :
> « finir avant d'ouvrir »). Ceci en est le sommet. **Règle de WIP** : au plus deux chantiers de
> code ouverts ; aucune étude nouvelle tant que la file « finir » n'est pas vide.

**Finir — ce qu'une session prend, dans l'ordre**

1. **é35 lot 7** (mesure `admin_lesson_to_quiz_outcome`, console), puis **lot 8** (bilan, Q-5) et
   clôture — la campagne maths 9ᵉ et son extension au concours 9ᵉ sont faites.
2. **é20** — mesurer le pilote `short_answer` (signalements + `content-audit`), puis clore ; le
   lot 4 devient une campagne de contenu.
3. **Clôtures administratives** — é34 (lots 1-4 faits, lot 5 optionnel différé), é09 (après A16),
   é11 (§4/§8 à resynchroniser après le verdict Q-9).

**Le goulot (zéro canal d'acquisition)** : GAP-003 → é28 D-5 → é08 volet enseignant → un canal.
Rien de codable avant GAP-003.

**Ce qui attend un humain** — seulement ce qui cite un mur de
[`zero-intervention.md`](./docs/agents/zero-intervention.md) :

1. **Renouveler `GH_AUTOMATION_PAT`** avant le **2026-10-04** (#1078).
2. **Verdict du pilote IA Q-9** — mesure relevée chaque lundi dans #1087 ; la question est le
   volume, pas le coût.
3. **Arabe 1ʳᵉ→8ᵉ : trois arbitrages** (audit au dépôt privé, 2026-09-22).
4. **Déclaration INPDP (GAP-003)** — tout ce qui se décide est isolé au §7 de
   [`inventaire-traitements-inpdp.md`](./docs/inventaire-traitements-inpdp.md).
5. **A16** (prix du rachat de série) · **é25 L7** (drill de portabilité) · gabarits d'e-mail FR et
   vérification `web_vitals` en console.

**Tranché le 2026-08-24, à ne pas rouvrir sans raison neuve** (détail au journal) : G-1 devient une
fenêtre par profil (lot dans `scripts/economy/assertions.mjs`) ; canari `npm ci --dry-run` sous
npm 10 avec Node 24 ; e-mails d'authentification en anglais ; dossier INPDP monté en interne.

> **▶ Reprise pour une session vierge.** Les contrats d'exécution (ROADMAP, `ETUDE.md`, go-live)
> sont au **privé** : démarrer là et ajouter ce dépôt. Campagnes de contenu ouvertes (ROADMAP §4) : les
> finir avant d'en ouvrir une autre. Discipline : AGENTS.md (un lot = une PR ; migration additive avant le code,
> destructive dans un merge séparé ; pgTAP tourne sur les PR de migration mais **n'est pas
> requis** — un rouge n'arrête pas l'auto-merge, il faut aller le lire).
