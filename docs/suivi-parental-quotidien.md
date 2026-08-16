# Suivi parental « jour par jour »

> Spec normative du tableau de bord d'activité quotidienne du module **Suivi parental**
> (`/parent-report`, onglet « Jour par jour »). En cas de désaccord avec un autre document,
> [`AGENTS.md`](../AGENTS.md) prime ; ici on décrit **ce qui est mesuré, comment, et pourquoi
> les seuils sont ceux-là**.

## Ce que le module doit permettre de répondre

Quatre questions, et rien d'autre. Tout l'écran n'est que la justification de ces quatre cases :

1. **Est-ce que mon enfant travaille ?** → activités réalisées.
2. **Est-ce qu'il travaille sérieusement et régulièrement ?** → indice d'**engagement**.
3. **Est-ce qu'il progresse ?** → écart de score avec la période précédente.
4. **Est-ce que son temps de travail est efficace ?** → indice d'**efficacité**.

Corollaire de conception : sept notions restent **distinctes** et ne sont jamais additionnées
ni confondues — temps dans l'application, temps d'apprentissage, activité réalisée,
performance, progression, engagement, efficacité.

## Le socle : `learning_pulses`

Avant ce module, la seule durée existante était `attempts.duration_seconds`, c'est-à-dire le
temps passé **dans un exercice terminé**. Lire un cours ne laissait aucune trace, un exercice
abandonné ne comptait pour rien, et « heure de première connexion » n'avait pas de source.

`learning_pulses` (migration `20260816180000`) est une table **append-only** de « pouls » :
le client déclare périodiquement _N secondes d'activité réelle sur telle surface_.

| Colonne          | Rôle                                                                      |
| ---------------- | ------------------------------------------------------------------------- |
| `surface`        | `lesson` · `exercise` · `quiz` · `recall` · `dungeon` · `duel` · `browse` |
| `subject_id`     | slug de matière (`subjects.id` est du TEXTE), dénormalisé, sans FK        |
| `chapter_id`     | UUID de chapitre, dénormalisé, sans FK                                    |
| `exercise_id`    | UUID d'exercice, dénormalisé, sans FK                                     |
| `active_seconds` | 1–300, après écrêtage serveur                                             |
| `progress_pct`   | 0–100 — pour un cours, la profondeur de lecture atteinte                  |

Pas de clé étrangère vers le catalogue, exactement comme `question_attempts.chapter_id` : le
corpus est réappliqué hors migrations (`sql/content/*.sql`), une FK ferait dépendre la
télémétrie de lignes absentes du dépôt public (piège `db:check-chain`).

### Ce qui compte comme « temps réel »

Côté client (`src/shared/lib/learning-pulse.ts`, `src/hooks/use-learning-pulse.ts`), une
tranche de temps n'est comptée que si **l'onglet est visible ET une interaction date de moins
de 90 s**. Trois protections complètent la mesure :

- une tranche entre deux tics est plafonnée à 15 s (onglet gelé, machine en veille) ;
- une horloge qui recule ne crédite rien ;
- le compteur est **soldé** au masquage de l'onglet, au démontage, et à tout changement de
  cible — le temps lu sur le chapitre A ne peut pas être crédité au chapitre B.

### L'invariant anti-triche

`record_learning_pulse` ne crédite **jamais** plus de secondes qu'il ne s'en est écoulé depuis
le pouls précédent du même élève. Un client modifié qui poste « 3 600 secondes » chaque seconde
n'obtient qu'une seconde. C'est aussi ce qui garde le total honnête quand deux onglets sont
ouverts : le temps d'application reste borné par l'horloge murale.

Le client n'a **aucun droit d'écriture** sur la table : la RPC `SECURITY DEFINER` est la seule
porte. Rétention 12 mois, purgée par `pg_cron` (`purge-learning-pulses`, 03 h 25).

### Confidentialité

Aucune URL, aucun contenu, aucun texte libre : uniquement des identifiants de catalogue déjà
publics et une durée. Rien ne sort de Postgres — PostHog reste sans PII et n'a aucun rapport
avec ceci (`src/shared/lib/product-analytics.ts`).

## Les faits : `get_student_daily_report`

Migration `20260816180100`. Rend **des faits, jamais un jugement** : jours, cours consultés,
exercices réalisés, agrégats par matière et par chapitre, totaux, et les mêmes totaux sur la
**période précédente de même longueur** (c'est elle qui porte « progression sur 7 / 30 jours »).

- **Fuseau** : `Africa/Tunis`. Un tableau de bord quotidien ne peut pas découper les journées
  en UTC — une révision de 22 h 30 tomberait le lendemain.
- **Bornes** : 92 jours maximum, 300 lignes par liste.
- **Accès** : admin, ou parent **effectivement lié**. Jamais exposé au chemin public par code
  alliance : le code est une capacité au porteur, l'activité minute par minute d'un mineur n'a
  rien à faire derrière.

### Seuils portés par le SQL

| Seuil                       | Valeur                | Pourquoi                                                             |
| --------------------------- | --------------------- | -------------------------------------------------------------------- |
| Nouvelle session            | 30 min                | Silence au-delà duquel on parle d'une nouvelle session d'application |
| Cours « réellement étudié » | ≥ 120 s **et** ≥ 60 % | Il faut à la fois du temps **et** de la descente dans la page        |
| Réussite d'un exercice      | 60 %                  | Miroir de `PASS_THRESHOLD_PCT`                                       |

Le verdict « étudié » est calculé **dans le SQL et nulle part ailleurs** : le même seuil sert au
détail et aux totaux, ils ne peuvent pas diverger.

### Le détail d'une tentative

`get_student_attempt_detail` rend les questions et **ce que l'enfant a répondu**. La bonne
réponse et l'explication sont mises à `null` pour un exercice `mode = 'quiz'` : rien n'empêche
un élève d'ouvrir un compte parent et de s'y lier avec son propre code alliance, la garde
anti-mémorisation de `get_attempt_review` (20260610170000) vaut donc aussi côté parent.

La session d'où viennent les réponses est lue dans `attempts.session_id` — colonne posée par
`20260816170000`, puis renseignée par la RPC de soumission et rétro-remplie par
`20260816190000`. Quand elle vaut `NULL` (une ligne que le backfill n'a pas su trancher), la RPC
retombe sur la session terminée du même couple (élève, exercice) la plus proche dans le temps :
les deux écritures ont lieu dans la même transaction. Ce repli est exactement celui que le
`COMMENT` de la colonne annonce, et il s'éteint de lui-même ligne par ligne — aucun code à
retoucher ici.

## Les règles : `src/features/parent-report/insights/`

Fonctions **pures**, sans réseau ni DOM ni horloge. Ce sont des règles produit : elles vont
bouger, elles doivent être explicables au parent facteur par facteur, et elles méritent des
tests lisibles. C'est aussi ce qui permettra de brancher plus tard une couche d'insights IA sur
les mêmes faits **sans retoucher le SQL**.

### Deux principes non négociables

1. **Un indice doit être explicable.** Le parent ne voit pas « 72/100 » tombé du ciel : il voit
   ce qui a porté le niveau, ce qui l'a retenu, et les valeurs brutes derrière.
2. **On ne note pas ce qu'on n'a pas mesuré.** Un facteur sans donnée est **retiré** du calcul
   et les poids des autres sont renormalisés — pas compté zéro. Compter zéro punirait un enfant
   pour une absence d'instrumentation (typiquement : une période antérieure aux pouls). Si plus
   rien n'est mesurable, l'indice se déclare insuffisant au lieu d'afficher 0.

### Engagement — « est-ce qu'il s'y met, régulièrement ? »

| Facteur               | Poids | Cible                                    |
| --------------------- | ----: | ---------------------------------------- |
| Régularité            |    22 | 5 jours actifs par semaine               |
| Temps d'apprentissage |    20 | 25 min / jour de la période              |
| Volume d'activité     |    18 | 3 activités / jour                       |
| Cours menés à bout    |    12 | étudiés / ouverts                        |
| Persévérance          |    13 | sessions terminées / commencées          |
| Progression           |    10 | −10 pts → 0 · stable → 0,5 · +10 pts → 1 |
| Révisions             |     5 | 5 min / jour de rappel actif             |

Les cibles sont **proportionnelles à la longueur de la période** : sinon « aujourd'hui » serait
toujours médiocre et « ce mois » toujours excellent.

### Efficacité — « ce temps produit-il des résultats ? »

| Facteur                         | Poids | Cible                                    |
| ------------------------------- | ----: | ---------------------------------------- |
| Justesse des réponses           |    25 | 85 % de bonnes réponses                  |
| Rendement du temps              |    20 | 8 min par exercice réussi (30 = mauvais) |
| Progression                     |    20 | idem engagement                          |
| Réussite après plusieurs essais |    15 | 1 tentative (3,5 = décrochage)           |
| Rythme de réponse               |    10 | 15–45 s / question, en cloche            |
| Gain après révision             |    10 | score en rappel vs en classique          |

Le **rythme** est noté en cloche : sous 8 s on clique sans lire, au-delà de 90 s on a décroché
de l'écran. Les deux extrêmes sont plafonnés à 0,2 — un mauvais rythme n'annule pas le facteur.

### Bandes

`≥ 80` très bon · `≥ 60` bon · `≥ 40` moyen · sinon faible. Alignées sur le verdict du bilan
famille existant.

### Alertes

`buildAlerts` ne rend **aucun texte** : une clé, un ton, une gravité, des paramètres. Le libellé
est monté côté composant depuis le dictionnaire i18n (fr / en / ar). On teste ainsi les règles
sans tester des phrases, et on traduit sans toucher aux règles.

Une alerte n'est utile que si elle est **rare** : les seuils sont posés haut (chute ≥ 10 points,
≥ 60 min de travail pour « temps sans progrès », ≥ 4 sessions pour l'abandon), et la liste est
plafonnée à 6, avertissements d'abord.

## Couverture du programme — une règle, jamais deux

La colonne « Programme » du tableau des matières rend **chapitres terminés / chapitres publiés**.
Elle ne définit rien : elle réutilise la règle qui fait déjà autorité pour la carte `/parcours`
que l'élève voit, et pour le hub matière.

- un chapitre est **publié** s'il porte au moins une mission de catalogue (`source = 'admin'`,
  hors quiz) — sinon il serait « terminé » par vacuité ou bloquerait le taux à jamais ;
- une mission est **réussie** à partir de 60 % (meilleur score en variante classique — une
  reprise en Rappel ne termine jamais un chapitre) ;
- en scolaire, le **quiz de compréhension** doit en plus être passé à 80 % sans rush.

La règle vivait en double : `get_user_parcours_progress` (SQL) et `chapter-completion.ts`
(client), avec la consigne de les garder d'accord. La migration `20260816200000` l'a **extraite**
dans `student_parcours_progress(p_user, …)` et rebranché la RPC de l'élève dessus. Parent et
enfant lisent donc le même chiffre **par construction**, pas par vigilance. Toucher à la règle,
c'est toucher à cette fonction — et aux deux écrans à la fois.

Une matière sans chapitre publié affiche « — », pas « 0 % » : la fraction n'existe pas.

## Le niveau scolaire, sans lequel rien ne se distingue

Une matière appartient à un niveau (`math-6`, `math-9`, `math-2sec-sciences`…). Le bilan
affichait `subjects.name_fr` seul : un élève inscrit à plusieurs niveaux voyait **quatre lignes
« Mathématiques » identiques**, sans rien pour les relier à quoi que ce soit (signalé en
production le 2026-08-16). `grades.name_fr` accompagne désormais chaque matière, partout.

## Deux surfaces, le même tableau de bord

| Surface          | Qui                          | Ce qu'on y voit                      |
| ---------------- | ---------------------------- | ------------------------------------ |
| `/parent-report` | parent connecté **et lié**   | tout                                 |
| `/suivi`         | **porteur du code alliance** | tout, réponses de l'enfant comprises |

Décision produit du 2026-08-16, prise en connaissance de cause : le rapport public par code
reçoit l'intégralité du tableau de bord. C'est un accès **au porteur** assumé — le code fait
122 bits aléatoires, c'est l'élève qui le transmet, et quiconque l'obtient voit tout. Le même
choix gouvernait déjà le bilan depuis l'étude 15.

⚠️ **Une seule chose reste masquée, et ce n'est pas de la confidentialité** : la correction d'un
quiz de compréhension. C'est l'anti-mémorisation du verrou de chapitre. Sans elle, un élève
ouvrirait la correction de son propre quiz avec son propre code et repasserait le verrou de tête.
Le parent voit quand même ce que son enfant a répondu, et si c'était juste.

Côté code, un seul écran sert les deux : `ReportSource` (`report-source.ts`) choisit la RPC, et
**aucun droit** — le contrôle d'accès est entièrement serveur (lien famille d'un côté, décodage
du code et « c'est bien un élève » de l'autre).

## Livrer en deux temps

Les trois RPC de ce module (`record_learning_pulse`, `get_student_daily_report`,
`get_student_attempt_detail`) **ne peuvent pas être typées avant d'exister en base**.
`supabase.rpc()` n'accepte que les noms présents dans
`src/shared/integrations/supabase/types.ts`, qui est **généré** par `supabase gen types` **depuis
une base réelle** — jamais depuis `supabase/migrations/**`. Tant que la migration n'est pas
appliquée, `npm run typecheck` échoue sur les trois appels, et le fichier généré est bloqué à
l'édition manuelle (`guard-generated.mjs`, à raison).

C'est exactement le cas d'usage de la **DoD §7** (« additive migrations land before the code
that uses them ») :

1. **PR 1 — les migrations seules.** `20260816180000_learning_pulses.sql` et
   `20260816180100_parent_daily_report.sql` (+ le test pgTAP). Le gate est vert : rien de
   TypeScript ne les référence encore. Le merge déclenche `db-migrate-prod.yml`.
2. **Régénérer les types**, une fois la prod migrée :

   ```bash
   npx supabase gen types typescript --project-id <ref-prod> > src/shared/integrations/supabase/types.ts
   ```

3. **PR 2 — le code.** Instrumentation, moteur d'indices, UI, i18n, tests.

**Sans Docker en local, il n'y a pas de raccourci** : `supabase gen types --local` exige la stack
Supabase. La parade pour ne pas envoyer du PL/pgSQL non exécuté en prod est de le rejouer dans un
Postgres **WASM jetable, hors dépôt** :

```bash
npm i @electric-sql/pglite   # dans un dossier temporaire, JAMAIS dans le projet
```

`CREATE FUNCTION` y compile réellement le PL/pgSQL, et un jeu de données minimal suffit à
exécuter les RPC de bout en bout — c'est ainsi que le clamp anti-triche, le masquage de la
correction d'un quiz et la garde d'accès ont été vérifiés avant livraison.

## Ce que le module ne fait pas

- Il ne remplace pas le **Bilan famille** (`ReportContent`), qui reste la synthèse historique.
  Les deux vivent dans deux onglets : empilés, ils seraient illisibles tous les deux.
- Il ne mesure **pas rétroactivement**. Sur une période antérieure aux pouls, les durées valent
  0 ; le tableau de bord l'**annonce** (`range.measuredSince`) au lieu de laisser le parent lire
  un zéro de travers.
- Il n'enregistre **aucune** navigation hors apprentissage autre qu'un compteur de minutes
  agrégé (`surface = 'browse'`), exclu du temps d'apprentissage.
