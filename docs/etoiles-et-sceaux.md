# Étoiles de chapitre & sceaux de matière

> **Ce document est normatif** : il dit ce qu'un élève gagne, ce qu'un parent lit, et ce qu'une
> session ne doit pas casser. Il vient de l'**étude 34** (dépôt privé
> `FableEtudes/34-etoiles-et-sceaux/`, validée le 2026-09-14), qui reste la version longue —
> analyse comparative des modèles de progression, décisions d'architecture, plan en 5 lots.
> Ce fichier-ci est la version opposable, celle qu'une session lit sans charger l'étude.
>
> Il **amende** [`AGENTS.md`](../AGENTS.md) et l'étude 22 sur un point précis, nommé plus bas :
> la complétion d'un chapitre ne se recalcule plus, elle **s'inscrit**.

---

## 1. La règle, en une page

| Terme                 | Définition exacte                                                                                                                                                         |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **mission comptée**   | meilleure tentative **classique** ≥ 60 % **et** ≥ 4 s/question (non précipitée). Une reprise en Rappel ne compte jamais.                                                  |
| **étoile r (1→4)**    | toutes les missions de catalogue de difficulté **≤ r** sont comptées, le quiz du chapitre est franchi, et **au moins une** mission est comptée.                           |
| **chapitre publié**   | il porte au moins une mission de catalogue (`source='admin'`, hors quiz) — donc il est jouable.                                                                           |
| **chapitre maîtrisé** | étoile **4** : toutes les missions de catalogue réussies, quiz compris. C'est **le seul mot de verdict** ; « terminé » en est un synonyme d'écran, jamais un second état. |
| **sceau r**           | **tous** les chapitres publiés de la matière portent l'étoile r **au grand livre**.                                                                                       |
| **nouveauté ✨**      | une mission (ou un chapitre, ou un quiz) arrivée **après** la référence de l'élève, et jamais tentée. Référence = max(dernière étoile inscrite, dernière tentative).      |

**Les quatre crans portent les noms de l'échelle du contenu** : ⭐ socle · ⭐⭐ pratique ·
⭐⭐⭐ boss · ⭐⭐⭐⭐ élite. Ce sont ceux que les titres de missions affichent déjà.

### Ce qui ne s'efface jamais (R-6)

Une étoile ou un sceau atteint est **inscrit** dans `user_chapter_stars` / `user_subject_seals`
et **n'en sort jamais** — ni par un ajout de contenu, ni par un élagage, ni par un changement de
règle. **Tout statut affiché se lit au grand livre** ; le calcul vivant ne sert qu'à deux
choses : faire **monter** le grand livre, et **décrire le reste-à-faire**.

C'est la raison d'être de l'étude. Avant elle, ajouter une mission à un chapitre maîtrisé le
dé-maîtrisait pour tous les élèves qui l'avaient fini ; ajouter un chapitre faisait chuter la
matière ; ajouter un quiz refermait la porte rétroactivement ; un élagage effaçait les
tentatives. Le contenu **est fait pour grandir** : un système de progression qui punit son
arrivée est en contradiction avec le produit.

### La vacuité, et sa borne (D-3)

Un cran **absent** du chapitre est franchi par vacuité : un chapitre ⭐·⭐⭐ entièrement réussi
est **maîtrisé**, et sa jauge n'a que **deux crans** — on n'affiche pas un palier qu'aucun
contenu ne permet d'atteindre. Mesuré sur le corpus le 2026-09-14 : 57 chapitres sur 773 n'ont
aucune mission ⭐, 35 aucune ⭐⭐.

**Mais la vacuité est bornée** : sans **aucune** mission comptée, le chapitre vaut **zéro**
étoile. Sans cette garde, un chapitre ⭐⭐⭐·⭐⭐⭐⭐ non joué offrirait deux étoiles pour zéro
travail, les crans 1 et 2 étant absents.

### Ce qui ne donne jamais d'étoile

- une mission **hors catalogue** — `source='parent'` aujourd'hui, et toute source future
  (élève, IA) : elles comptent pour l'**effort** (XP, ligne « Missions de la famille »), jamais
  pour un jalon. C'est ce qui garde les étoiles comparables entre élèves et empêche un tiers
  d'en donner ou d'en retirer ;
- une reprise en **Rappel** ;
- une réussite **précipitée** (< 4 s/question) — même règle que l'XP et que le quiz.

---

## 2. Ce que ça ne fait pas

- **Aucun verrou.** Étoiles et sceaux ne conditionnent aucun accès, aucune récompense, aucun
  classement. Les trois verrous de l'étude 22 (quiz, arène, Rappel) restent les seuls. Un écran
  qui afficherait une étoile comme une condition est un bug de doctrine.
- **Aucune économie.** Ni XP ni pièces pour une étoile ou un sceau : `gamification.ts` n'est pas
  touché, `economy:check` n'a rien à rejouer. Toute valeur passe par l'étude 09.
- **Aucun modèle de compétence.** Les étoiles disent ce que l'élève **a fait** ; la maîtrise
  EWMA (étude 07) et la croyance BKT (étude 30) disent ce qu'il **sait**. Les deux sont
  orthogonaux : un chapitre ★★★★ avec une compétence « fragile » est un état normal. Une étoile
  **ne se dégrade pas par l'oubli** — la révision est le métier de SM-2 et de la frontière.

---

## 3. Le schéma, et qui écrit

| Objet                                                             | Rôle                                                                                                     |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `exercises.created_at`, `chapters.created_at`                     | la date d'entrée au catalogue. **Sans elle, « il a régressé » et « on a ajouté » sont indistinguables.** |
| `user_chapter_stars (user, chapter, star)`                        | le grand livre des étoiles. Insert-only.                                                                 |
| `user_subject_seals (user, subject, star)`                        | le grand livre des sceaux. Insert-only.                                                                  |
| `mission_is_counted` · `chapter_star_rungs` · `chapter_star_live` | la règle, écrite **une** fois. Internes.                                                                 |
| `record_progress_stars()` + `trg_record_progress_stars`           | **le seul écrivain**, sur `AFTER INSERT ON attempts`.                                                    |
| `replay_progress_stars()`                                         | le rejeu initial, idempotent — inscrit ce que les tentatives déjà en base valent.                        |
| `student_subject_stars` → `student_parcours_progress`             | l'agrégat par matière, et sa projection historique (même signature, trois appelants inchangés).          |
| `get_subject_progress(subject)` · `get_attempt_progress(attempt)` | les deux RPC élève, self-scopées.                                                                        |

**Pourquoi un trigger et pas une greffe dans `submit_exercise_attempt`** : cette RPC fait
~570 lignes et trois études l'ont ré-émise en trois semaines. Le fait « une tentative existe »
est possédé par la **table** : le trigger est son finalizer légitime, exactement comme
`record_competency_mastery`. Le delta à célébrer se lit ensuite par `get_attempt_progress`.

**`attempt_id` est `ON DELETE SET NULL`, jamais `CASCADE`** : quand le pipeline élague une
mission, ses tentatives partent en cascade — la ligne du grand livre reste, et perd seulement
son justificatif. C'est tout l'objet de la table.

---

## 4. Ce que cela amende

| Texte     | Avant                                                   | Maintenant                                                                                |
| --------- | ------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| é22 R-14  | mission réussie ≥ 60 % (durée ignorée)                  | inchangé pour la **récompense** ; pour une **étoile**, il faut en plus « non précipitée » |
| é22 R-15  | chapitre complété = quiz + toutes les missions réussies | **maîtrisé** = étoile 4 : **même contenu**, mais monotone, vacuité assumée, non précipité |
| é22 R-16  | progression = chapitres complétés / publiés (%)         | la **distribution des étoiles** + le sceau ; le pourcentage nu quitte les écrans          |
| é22 D-4   | « la complétion se calcule, ne se stocke pas »          | les **acquis** se stockent, le **reste-à-faire** se calcule                               |
| é31 KPI-E | chapitres complétés / actif                             | **définition inchangée**, comptée sur le grand livre : monotone, série continue           |

⚠️ **La barre n'a pas bougé.** L'architecte proposait de descendre « maîtrisé » à l'étoile 3
(tous les boss, l'élite en dépassement) ; l'arbitrage du 2026-09-14 a tranché **contre** : un
chapitre n'est maîtrisé que lorsqu'il n'y reste rien à faire. Ce que l'étude change n'est donc
pas le seuil, mais ce qui l'entoure — il ne redescend plus jamais, la distribution des étoiles
passe devant le ratio, et le geste manquant est nommé. Le chiffre à surveiller est la **médiane
de l'étoile** : si elle stagne pendant que la pratique monte, c'est que l'élite est hors de
portée du plus grand nombre, et la question se rouvre par amendement de l'étude.

---

## 5. Les pièges, pour qui touchera à ce code

- **`now()` est l'horloge de la TRANSACTION.** Dans un test pgTAP, un contenu « ajouté plus
  tard » porte exactement la même date que les tentatives posées juste avant : aucune nouveauté
  ✨ n'est alors détectable. Dater les tentatives dans le passé (`now() - INTERVAL '2 days'`).
- **Un `AFTER INSERT ... FOR EACH ROW` sur un `INSERT` à plusieurs `VALUES`** ne se déclenche
  qu'une fois **toutes** les lignes posées : la première tentative « verrait » les suivantes, ce
  qui n'arrive jamais en production (une soumission = une ligne). Une instruction par tentative
  dans les décors de test.
- **Le moteur de contenu n'a rien à changer** : `sql-builder` upserte avec des listes de
  colonnes explicites, donc `created_at` survit à une ré-application et se pose sur une
  insertion neuve. Ne pas l'ajouter à un `DO UPDATE SET`, jamais.
- **Ne jamais recopier un prédicat** (les seuils 60 / 80 / 4 s, la porte du quiz, « mission de
  catalogue ») : ils vivent chacun dans **une** fonction, et c'est ce qui a évité au projet trois
  divergences déjà payées.

---

## 6. Où c'est prouvé

| Fichier                                           | Ce qu'il tient                                                                                                    |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `supabase/tests/99_etoiles_regle.test.sql`        | R-3 et R-4 sur les échelles réelles du corpus (1·2·3·3·4, 1·2, 3·4), vacuité et sa borne, quiz, exclusions        |
| `supabase/tests/100_etoiles_grand_livre.test.sql` | **l'invariant de l'étude** : les quatre événements de contenu, et le grand livre qui ne bouge pas ; RLS et grants |
| `supabase/tests/101_sceaux_et_rpcs.test.sql`      | le sceau, les deux RPC élève et leur garde, l'accord des lecteurs                                                 |
| `supabase/tests/102_rejeu_initial.test.sql`       | le rejeu ≡ le trigger, le grand-père, l'idempotence                                                               |

⚠️ `db-tests.yml` tourne sur les PR mais **n'est pas un check requis** : lancer
`npm run db:test:local` avant de pousser un lot qui touche à ce code.
