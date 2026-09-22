# Pièges du code applicatif

> Des comportements que **le gate local ne montre pas** et qu'on ne devine pas en lisant le
> code : chacun a coûté soit un bug en production, soit un cycle de build. Ils ne sont pas dans
> [`AGENTS.md`](../../AGENTS.md) § Known gotchas parce que ce fichier a un budget dur de
> 200 lignes (il est injecté dans chaque session) — ici, il n'y en a pas.
>
> **Une entrée n'arrive ici que mesurée.** Pas « je crois que » : le chiffre, la commande qui
> l'a produit, la date. Si l'outillage change et qu'elle devient fausse, elle se corrige — elle
> ne se garde pas par respect pour l'ancienneté.

## Exporter le composant d'une route défait le code-splitting

**Symptôme** : `npm run verify` est vert, la CI rougit sur `build:check` — le chunk d'entrée
`index-*.js` dépasse son budget de 450 kB pour un diff de 150 lignes.

**Cause** : un `export function MaPage()` dans `src/routes/*.tsx`, ajouté pour qu'un test unitaire
puisse importer la page. Le splitter de TanStack Start ne peut plus sortir le composant du graphe
principal — ses imports (motion, icônes, primitives de formulaire) remontent avec lui dans le
chunk d'entrée.

**Mesuré le 2026-08-16** sur `/auth`, trois `npm run build:check` successifs dans le même
worktree :

| Arbre                                           | `index-*.js` |
| ----------------------------------------------- | ------------ |
| référence (sans le correctif)                   | 439,75 kB    |
| correctif **avec** `export function AuthPage()` | 520,52 kB    |
| correctif **sans** l'export du composant        | 439,75 kB    |

Soit **+80,77 kB pour le seul mot-clé `export`**. Les deux helpers **purs** exportés du même
fichier (`friendlyAuthError`, `isEmailNotConfirmed`) coûtent **0** : ils ne référencent aucun
import lourd, le tree-shaking fait le reste.

**Ce qu'il faut faire** : garder le composant non exporté et le lire via `Route.component`, avec
`createFileRoute` mocké pour rendre ses options —
voir [`auth-signup.test.tsx`](../../src/routes/__tests__/auth-signup.test.tsx). N'exporter d'un
fichier de route que des fonctions pures.

**Pourquoi ça échappe au gate local** : `build:check` n'est pas dans `verify` (voir AGENTS.md
§ Known gotchas, « CI runs a superset of local verify »). Le lancer avant de pousser dès qu'on
touche à un fichier de route ou qu'on ajoute des clés i18n.

## Une inscription Supabase peut réussir sans qu'aucun mail ne parte

**Symptôme** : l'écran « Confirme ton email » s'affiche, aucun mail n'arrive — ni en boîte, ni en
spam — et les logs SMTP ne montrent **rien** à envoyer. Aucune erreur nulle part.

**Cause** : la protection anti-énumération d'e-mail. Sur une adresse qui a **déjà** un compte,
GoTrue répond **200** avec un utilisateur **factice** — id aléatoire (différent du vrai), `role`
vide, `confirmation_sent_at` horodaté à l'instant — et n'envoie rien. Le but est de ne pas révéler
quelles adresses sont inscrites ; l'effet de bord est qu'un client naïf annonce un mail qui
n'existera jamais.

**Le seul indice honnête est un tableau `identities` vide.** `confirmation_sent_at` ment, l'`id`
ment, le code HTTP ment.

```ts
// `undefined` ≠ vide : seul un vrai tableau vide signifie « rien n'a été créé ici ».
const identities = data.user?.identities;
if (!data.session && Array.isArray(identities) && identities.length === 0) {
  /* l'adresse a déjà un compte — aucun mail n'est parti */
}
```

**Vérifié contre la prod le 2026-08-16** (trois `POST /auth/v1/signup`, boîte de réception
relue) : deux adresses neuves → deux mails en 2 secondes, en boîte de réception ; la répétition
sur une adresse existante → 200, `identities: []`, **zéro mail**.

**Ce que ça implique côté produit** : sans cette branche, l'adresse est **murée** — se
réinscrire répète le mensonge, se connecter répond « confirme d'abord ton compte ». Tout écran
qui dit « on t'a envoyé un lien » doit donc offrir un **renvoi** (`auth.resend`), et un échec
d'envoi (`Error sending confirmation email`) doit se distinguer d'une erreur d'identifiants :
le compte, lui, existe. Voir [`auth.tsx`](../../src/routes/auth.tsx).

## Trois pièges de migration qui ne se voient pas au moment où on les écrit

Condensés en tête d'`AGENTS.md` jusqu'à l'étude 32 (D-8) ; le détail vit ici, la règle courte
reste là-bas.

**Une table neuve a besoin de ses `GRANT` explicites.** Un `CREATE TABLE` sans son propre
`GRANT SELECT … TO authenticated` fonctionne en cloud — le rôle y hérite d'assez de choses — et
casse la suite pgTAP nocturne sur une base fraîche. Référence : la migration de base
`20260612221000_baseline_table_grants.sql`.

**Une migration doit trier APRÈS la plus récente déjà sur `main`.** Un horodatage antidaté
bloque `supabase db push` et laisse silencieusement la prod derrière le code. Le check de PR
`Migration order` l'attrape avant le merge — c'est un check **requis**, contrairement au suivant.

**La prod n'est PAS le juge de la reconstructibilité.** Une migration peut passer en prod, où
ses parents sont anciens, et rendre impossible la construction d'une base **vierge** — donc
casser pgTAP et tout projet TEST neuf. Quatre pannes de cette forme ont atteint `main` après le
lot 4 de l'étude 24 (#548, #549, #552, #557), déterrées une par une à la main. Deux garde-fous,
et leurs limites : `db-tests.yml` tourne sur les PR **mais n'est pas requis** — un rouge n'arrête
pas l'auto-merge, il faut aller le lire ; `db:check-chain` rejoue la chaîne **statiquement**, en
~0,2 s et sans base. Un INSERT qui dépend de lignes absentes se garde par
`WHERE EXISTS (SELECT 1 FROM public.<parent> …)`.

## Un `CREATE OR REPLACE` peut effacer trois lots sans qu'aucun gate ne bronche

**Symptôme** : aucun. La migration s'applique, la fonction compile, `verify` et la suite pgTAP
sont vertes — et une fonctionnalité livrée deux semaines plus tôt a disparu du jeu.

**Cause** : une fonction SQL n'a pas de « fichier propriétaire ». Sa définition **vivante** est
le **dernier** `CREATE OR REPLACE` dans l'ordre des migrations, et il atterrit dans la migration
du lot qui l'a touchée en dernier — un nom qui ne dit rien d'elle. Recopier une révision plus
ancienne pour y ajouter une ligne réécrit donc la fonction **sans** les lots intermédiaires.
Rien ne le signale : le gate vérifie que le SQL est valide, pas qu'il est à jour.

**Mesuré le 2026-08-16** sur `submit_exercise_attempt` — la fonction la plus disputée du dépôt,
six révisions, dont deux dans la même heure :

| Migration                                      | Ce qu'elle a ajouté        |
| ---------------------------------------------- | -------------------------- |
| `20260706130000_adaptive_telemetry_a0_capture` | télémétrie par question    |
| `20260714130000_recall_mode_rpcs`              | variante Rappel            |
| `20260720170000_sm2_close_reviews_on_pass`     | clôture des révisions SM-2 |
| `20260727120000_short_answer_native_type`      | scoring `short_answer`     |
| `20260816140000_boss_speed_xp_bonus`           | bonus de vitesse du boss   |

Repartir de la première (celle que désignait le brief) aurait effacé les quatre suivantes.

**Le réflexe**, au moment d'écrire **et** juste avant de committer — `main` bouge :

```bash
git grep -n "CREATE OR REPLACE FUNCTION public.<nom>" origin/main -- supabase/migrations | sort | tail -1
```

Puis : extraire le corps (`sed -n 'D,Fp'`), appliquer la modification **par script** avec une
assertion sur le nombre d'occurrences, et `diff` le résultat contre l'extrait — le diff doit ne
montrer **que** les lignes voulues. C'est l'audit qui remplace la relecture de 500 lignes, et
c'est ce qui rend la PR relisable.

## `ON CONFLICT DO NOTHING` fige la PREMIÈRE valeur, jamais la meilleure

**Symptôme** : une colonne semée porte une valeur qu'aucun fichier du dépôt ne réclame plus.
Le seed qui la corrige est là, il est postérieur, il s'exécute sans erreur — et il ne change
rien. Aucun gate ne bronche : `db:check-chain` rejoue la chaîne, la migration réussit, la suite
pgTAP passe.

**Cause** : `ON CONFLICT (code) DO NOTHING` ne veut pas dire « insérer si absent, corriger si
présent ». Il veut dire « ne rien faire du tout si la ligne existe ». Un second `INSERT` écrit
pour amender une ligne déjà semée est un **no-op silencieux**.

**Mesuré le 2026-09-03**, quatre mois après les faits. `20260522153000_family_content_rewards.sql`
sème trois badges avec un `icon_name` en minuscules :

```sql
('streak_7', …, 'rare', 'flame', 'streak_7'),
('boss_slayer', …, 'epic', 'swords', 'boss_win'),
('math_blitz', …, 'rare', 'zap', 'math_95')
ON CONFLICT (code) DO NOTHING;
```

`20260522170000_seed_content.sql` — **le même jour, 1 h 40 plus tard** — réécrit les mêmes badges
avec la bonne casse (`Flame`, `Shield`, …), et porte lui aussi `DO NOTHING`. Les lignes existant
déjà, la correction n'a jamais été appliquée. Or `BadgeMedal` résout le glyphe par
`GLYPHS[iconName] || Award` : trois badges ont rendu le glyphe passe-partout du 2026-05-22 au
2026-09-03 sans qu'aucun test ne rougisse — le repli est un filet, pas une carte de glyphes.

**La parade, en deux temps.**

1. **Corriger une ligne existante demande un `UPDATE` explicite** (ou `DO UPDATE SET`), gardé sur
   la valeur fautive pour rester idempotent :

   ```sql
   UPDATE public.badges SET icon_name = 'Flame' WHERE code = 'streak_7' AND icon_name = 'flame';
   ```

2. ⚠️ **Surtout pas en réécrivant la migration fautive.** Elle est appliquée en production, et le
   suivi se fait par **version**, jamais par contenu : la réécrire ne rejoue rien là-bas et fait
   diverger une base vierge de la prod — le piège que `AGENTS.md` nomme sous « la prod n'est PAS
   le juge de la reconstructibilité », pris par l'autre bout.

**Ce qui le rend invisible**, et donc ce qu'il faut garder : les deux moitiés sont justes
séparément. Le seed d'origine est valide, le seed correctif est valide, et leur composition ne
l'est pas. C'est la même classe que R-13 de l'étude 31 (« un badge sans règle ») et que
`auth-refusals.ts` : deux listes tenues à la main, chacune juste de son côté. Un test qui
confronte les deux — ici `badge-medal.test.tsx`, qui compare la carte des glyphes au semis des
migrations dans les deux sens — est le seul filet qui tienne.

## Deux plafonds de 30 s, et c'est le mauvais qui gagne la course

**Symptôme** : la Forge rend un `504 Gateway Timeout` **brut** au lieu d'une erreur typée. À
l'écran, rien — le bouton repasse de « La Forge travaille… » à son état initial, sans un mot.
L'énergie de l'élève est débitée, et la console de dépense n'enregistre aucun appel.

**Cause** : deux plafonds indépendants valaient tous les deux 30 s — la garde applicative
(`AI_EGRESS_RULES.timeoutMs`, condition 6 de R-6) et le `maxDuration` de la fonction SSR
(`scripts/build-vercel.mjs`). Quand l'appel dépasse, la plateforme tue le processus **avant**
que notre garde ait pu typer l'erreur : plus personne n'est là pour écrire le message, ni pour
solder la dépense.

**Mesuré le 2026-08-25**, `grok-4.6` derrière un endpoint compatible OpenAI, quiz de 7 questions
avec le schéma réel de la Forge :

| Grandeur                      | Valeur                              |
| ----------------------------- | ----------------------------------- |
| durée réelle de la génération | **56 à 59 s**                       |
| tokens de raisonnement        | 2547                                |
| tokens de complétion          | 1052                                |
| `finish_reason`               | `stop` — la réponse était **bonne** |

Le contenu n'était pas en cause : 7 items rendus, 7 conformes au schéma Zod, 0 rejet par les
filtres. Seule la latence tuait.

**Le commentaire qui a coûté la panne.** `digest.server.ts` affirmait : « `maxDuration: 30`
secondes (plan Hobby) — ce n'est pas un réglage qu'on remonte ». C'était vrai sous les anciennes
limites ; depuis que `fluid compute` est le défaut, le plan Hobby plafonne à **300 s** (doc
Vercel relevée le 2026-08-25). La contrainte avait disparu, le commentaire était resté, et il a
été cru sur parole — au point de faire conclure qu'il fallait passer à un plan payant.

**L'invariant à tenir** : toute valeur de `AI_TIMEOUT_MS` reste **strictement sous** le
`maxDuration` de la fonction SSR. Sinon c'est la plateforme qui coupe, et l'erreur devient
illisible pour celui qui la subit. Un test l'épingle
([`openai-compatible.test.ts`](../../src/shared/integrations/ai/__tests__/openai-compatible.test.ts)),
parce que les deux valeurs vivent dans deux fichiers que rien ne relie autrement.

**La règle générale** : une limite d'hébergement écrite dans un commentaire se **re-vérifie chez
le fournisseur** avant d'être crue. Les plafonds des plateformes bougent — les commentaires qui
les citent, non.

## Une garde qui lit un état que rien ne referme devient définitive

**Symptôme** : sur l'écran de correction d'une quête, « Demander au Prof » répond « Pas pendant
un donjon ! On en parle à la sortie ». Aucun donjon n'est en cours. Le refus est **permanent** :
il survit au rechargement, à la déconnexion, aux jours. Et comme il vient de la porte commune,
il éteint d'un coup l'explication d'erreur, le chat de chapitre, la boucle de compréhension et
« Entraîne-moi là-dessus » — donc l'entrée de la Forge par le tuteur. Vu de l'élève : « le mode
IA ne marche pas », alors qu'aucun appel de modèle n'a jamais été tenté.

**Cause** : `can_use_tutor` (R-1, é11) refusait dès qu'il **existait** une ligne d'épreuve non
close. Or aucune des trois ne se referme d'elle-même :

| Table               | Ce qui la ferme                                      | Ce qui arrive sinon                                                                     |
| ------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `dungeon_runs`      | une mauvaise réponse, ou `finalize_dungeon_run`      | onglet fermé ⇒ `status='active'` **à vie** ; `start_dungeon_run` en empile une nouvelle |
| `exercise_sessions` | la soumission (`completed_at`)                       | quête quittée ⇒ séance ouverte à vie ; relancer le même exercice en ouvre une seconde   |
| `duels`             | le balayage pg_cron `expire_duels`, toutes les 5 min | fenêtre de 5 min où un duel échu bloque encore                                          |

Le chemin le plus court vers le défaut ne demande même pas d'abandon durable : quitter un
exercice, le relancer, le terminer. La séance abandonnée est encore « en cours » quand l'écran
de correction du run suivant s'affiche.

**Vérifié le 2026-08-27** sur la suite pgTAP en local (recette de
[`pgtap-en-local.md`](./pgtap-en-local.md)) : les six assertions de
[`81_tutor_gate_live_trials.test.sql`](../../supabase/tests/81_tutor_gate_live_trials.test.sql)
qui décrivent une épreuve abandonnée sont **rouges** contre l'ancienne fonction et vertes contre
la nouvelle ; les six qui décrivent une épreuve réellement en cours sont vertes des deux côtés —
c'est ce second groupe qui prouve que l'anti-triche n'a pas été échangée contre le correctif.

**Le correctif** : la garde ne demande plus « cette ligne existe-t-elle ? » mais « cette épreuve
est-elle **vivante** ? » — donjon actif il y a moins de 30 min (dernière réponse, ou son départ),
duel avant sa propre `expires_at`, dernière séance de l'exercice ouverte depuis moins de 4 h.

**La règle générale** : avant d'écrire `WHERE status = 'active'` dans une garde, chercher **qui**
écrit l'autre statut. Si la réponse est « le chemin nominal », la garde est définitive pour tous
ceux qui ne l'ont pas pris — et un utilisateur ne dira jamais « ma course de donjon est restée
ouverte », il dira « ça ne marche pas ». Une garde se borne dans le temps, ou bien l'état qu'elle
lit se referme tout seul.

## Un paramètre d'URL qui exprime une INTENTION n'est pas un `defaultOpen`

**Symptôme** : la bulle IA est là, le Prof n'est pas grisé, l'élève clique « Discuter avec le
Prof » puis « Y aller » — **rien ne se passe, il revient au cours**. Depuis un autre écran,
choisir un chapitre l'amène bien sur le cours, mais le chat semble absent. Aucune erreur, aucun
appel réseau en échec : de l'extérieur, une porte fermée de plus.

**Cause — trois défauts que la même phrase recouvre**, tous en aval de la porte réparée par #896 :

1. **L'intention n'arrivait qu'au montage.** `?chat=1` était lu dans un `useState(defaultOpen)`.
   Depuis un chapitre, « Y aller » ne change que la **recherche** de l'URL : même route, mêmes
   paramètres, donc **aucun remontage** — le composant garde son état, et l'initialiseur n'est
   jamais relu. Le cas de la capture (bulle ouverte au-dessus d'un chapitre) était exactement
   celui-là, et il ne produisait rigoureusement rien.
2. **Le panneau est monté APRÈS la leçon entière**, tout en bas du lecteur de cours. Ouvert sans
   être rejoint, il est invisible — « je reviens au cours » était littéralement vrai : l'élève
   regardait son cours, le chat trois écrans plus bas. Le routeur remet en plus la page **en
   haut** à chaque navigation, et cette ouverture EN EST une : un défilement demandé dans le même
   tour part avant ce retour en haut, qui l'écrase. D'où le `requestAnimationFrame`.
3. **La porte fermée était muette.** `can_use_tutor` referme la portée chapitre dès qu'une séance
   d'exercice de ce chapitre est restée ouverte (cas courant depuis #896 : moins de 4 h), et le
   panneau rendait `null` — pas un mot, juste après un clic. L'écran de correction, lui, nomme le
   refus depuis le lot 1 d'é11 (« Pas pendant un donjon ! ») ; les deux partagent désormais la
   table de [`src/features/tutor/locked.ts`](../../src/features/tutor/locked.ts).

**Mesuré le 2026-08-27** : contre le comportement précédent, **8 des 10 assertions** de
[`tutor-chat-panel.test.tsx`](../../src/features/tutor/__tests__/tutor-chat-panel.test.tsx) sont
rouges (`npx vitest run src/features/tutor/__tests__/tutor-chat-panel.test.tsx`) ; les 2 vertes
sont les invariants qu'on ne voulait pas changer — l'entrée pas encore revenue et le refus
intraduisible restent muets.

**La règle générale** : distinguer un paramètre d'**état** (un filtre, un onglet, un code de
suivi — il décrit la page, il reste dans l'URL) d'un paramètre d'**intention** (« ouvre ceci
maintenant »). Une intention se traite comme un **événement** : lue dans un effet et non dans un
initialiseur d'état ; **consommée** — retirée de l'URL par la route — sinon le clic suivant
produit une adresse identique, donc aucune navigation, donc la même panne un cran plus loin ; et
**amenée sous les yeux**, parce qu'ouvrir hors écran ne se distingue pas de ne rien faire. Et le
consommateur est celui qui l'a **prise** (ici le panneau, monté seulement une fois la session
résolue) : une intention retirée par la route avant que sa cible existe est une intention perdue.

## Une boucle de rendu se signale comme « 2 errors » — et un `| tail` la fait disparaître

**Vécu le 2026-09-14** (étude 34, lot 4). Un hook neuf, `useAttemptCelebration`, rend un objet —
comme tous ses voisins. Le lecteur d'exercice l'a mis dans la liste de dépendances de `resetRun` :

```ts
// ❌ `celebration` est un objet NEUF à chaque rendu
}, [resetSession, resetFeedback, resetHints, celebration]);

useEffect(() => {
  resetRun();
}, [exerciseId, resetRun]);
```

`resetRun` devient neuf à chaque rendu, donc l'effet se relance à chaque rendu, donc `resetRun()`
repose l'état, donc le composant re-rend : **boucle infinie**. En production, c'est la page de
quête qui prend 100 % d'un cœur et ne rend jamais. Le fichier documentait déjà la règle qui
l'interdit, trois lignes plus bas — « on dépend des CALLBACKS des hooks, jamais des objets » —
et le lot l'a enfreinte en ajoutant un hook de plus.

Le remède est l'idiome déjà en place pour `hints` et `feedback` : `const { reset: resetX } = x;`,
et c'est `resetX` qui va dans la liste.

**Ce qu'il faut retenir tient surtout à la façon dont ça se voit.** Une boucle de rendu
**synchrone** bloque la boucle d'événements : le `testTimeout` de 15 s ne peut pas se déclencher,
et le fichier de test ne rend **jamais** son verdict. Vitest ne l'a donc compté ni en `passed` ni
en `failed` :

```
 Test Files  339 passed (341)     ← 341 collectés, 339 rendus : DEUX manquent
      Tests  4313 passed (4338)
     Errors  2 errors             ← c'est là, et nulle part ailleurs
   Duration  1200.16s             ← au lieu de ~250 s
```

Trois réflexes, dans cet ordre :

1. **Lire le décompte entre parenthèses.** `339 passed (341)` n'est pas vert : il manque deux
   fichiers. « 0 failed » ne veut pas dire « tout est passé ».
2. **Ne jamais faire passer un gate par `| tail`, `| head` ou `| grep`.** Le code de sortie d'un
   pipeline est celui de la DERNIÈRE commande — `tail` réussit toujours. `npm run verify | tail -8`
   rend donc **0** sur une suite rouge. Rediriger (`> fichier 2>&1`) et lire le fichier ; si un
   filtre est vraiment nécessaire, `set -o pipefail`.
3. **Une durée qui explose est un symptôme, pas de la malchance.** Avant d'accuser la machine :
   `ps aux | grep vitest` — deux workers à 100 % de CPU pendant que le journal n'écrit plus
   depuis cinq minutes désignent un fichier qui tourne en rond, pas une contention. Le fichier
   fautif se trouve en soustrayant les fichiers rendus de ceux collectés.

## Une règle `@media print` accrochée à la COQUILLE meurt en silence quand le contenu déménage

**Vécu le 2026-09-19.** Un élève en thème « Noir & Or » imprime son cours (ou l'enregistre en
PDF, c'est le même chemin : `Ctrl+P` → « Enregistrer en PDF ») et reçoit **une feuille blanche**.
Rien de cassé côté JS, rien de rouge au gate : le cours est bien dans la page, il est juste
**écrit en blanc sur du blanc**.

Trois faits qui se combinent :

1. `.lesson-content { color: var(--foreground) }`, et `--foreground` vaut `oklch(0.965 …)` —
   un quasi-blanc — dans le thème sombre (`:root`). Le thème clair « Référence » n'a jamais
   montré le bug : son `--foreground` est déjà une encre.
2. Le navigateur **n'imprime pas les fonds** par défaut. Le noir de la coquille disparaît, le
   papier reste blanc, le texte reste blanc.
3. La règle qui remettait le cours à l'encre visait `.app-shell .lesson-content` (correctif C4,
   `d526f658`), parce que le lecteur vivait alors dans la coquille applicative. **Le chantier C8
   l'a déplacé** vers le registre public : `/chapitre/$chapterId` sous `.public-shell`, et
   `/lesson/$chapterId` n'est plus qu'une redirection 301. Le sélecteur n'attrapait donc plus
   **aucun** cours. `.public-shell`, lui, n'avait qu'un `color: #000` posé sur la coquille — que
   le `color` de `.lesson-content`, plus spécifique sur l'élément lui-même, écrase.

Mesuré dans Chromium (`emulateMedia({media:'print'})`, fonds neutralisés comme le fait une
imprimante), pixel le plus sombre du corps de texte sur fond blanc :

| Nœud                       | avant      | après |
| -------------------------- | ---------- | ----- |
| paragraphe du cours        | **1,74:1** | 21:1  |
| texte d'un bloc Définition | **1,31:1** | 21:1  |
| cellule de tableau         | **1,74:1** | 21:1  |

La barre AA est à 4,5:1 ; en dessous de ~1,5:1 il n'y a **rien** à voir sur du papier.

**Ce qu'il faut retenir tient en deux règles.**

1. **L'encre d'impression est une propriété du DOCUMENT, pas de sa coquille.** Le crochet doit
   être une classe de CONTENU, qui voyage avec lui quand il change d'écran : `.family-report`
   le faisait déjà bien pour le bilan parental, `.lesson-doc` / `.lesson-content` le font
   maintenant pour le cours. Une règle `@media print` préfixée par `.app-shell` ou
   `.public-shell` est un pari sur l'arborescence — et une route qui déménage ne fait pas de
   bruit.
2. **Un test qui cherche une CHAÎNE dans `styles.css` ne dit rien de ce que la règle atteint.**
   Le garde-fou en place (`lesson-print-css.test.ts`) vérifiait que `.app-shell .lesson-content`
   existait bien dans la feuille. Il est resté **vert pendant tout le bug** : la règle existait,
   elle ne matchait plus rien. Le test réécrit (`lesson-print-css.test.tsx`) **monte le lecteur**,
   prend ses vrais nœuds et demande à `Element.matches()` si une règle `@media print` les attrape
   — sous `.public-shell`, sous `.app-shell`, et sans coquille du tout. Remis sur l'ancien
   sélecteur, il tombe en rouge sur 5 tests.

⚠️ Corollaire pour tout ce qui est `position: fixed` : à l'impression, un élément fixe se
**tamponne sur chaque page** du PDF. La bulle IA (`ai-launcher.tsx`) le faisait, par-dessus le
cours, pour tout élève connecté — d'où son `print:hidden`, comme l'en-tête, le sommaire et les
appels à l'action du lecteur.

## Règles laissées par les chantiers d'août-septembre 2026

Sorties de `STATUS.md` le 2026-09-22 (son § 6 les portait) ; le détail et les mesures sont dans
les PR citées. Chacune est tenue par un test ou un garde-fou — ne pas les défaire.

- **Les surfaces passent par des tokens** (#724, #734) : plus aucun remap ne rattrape un
  `bg-black` littéral, qui resterait noir sur le thème clair (le thème **par défaut**).
  `check-design-tokens.mjs` le refuse ; `--surface-1/2/3` sont définis dans chaque thème et un
  test les épingle dans les deux ; `src/__tests__/theme-contrast.test.ts` rend un contraste de
  token opposable avant le merge (#786).
- **Une fonction SQL vivante se SUBSTITUE, elle ne se retape pas** (#818) : `get_daily_plan`
  retapée à la main réinventait l'algorithme — c'est le `diff` contre la révision vivante qui l'a
  montré, pas un test. Voir aussi « Un `CREATE OR REPLACE` peut effacer trois lots » plus haut.
- **Le travail de l'élève est écrit AVANT d'être envoyé** (2026-08-31) : `src/shared/lib/outbox.ts`
  met la soumission en file locale, la tente, et ne l'en sort qu'acceptée. Une file rejouée exige
  un serveur idempotent (le rejeu **rend** la tentative au lieu de lever). `outbox.ts` consigne
  tout échec d'envoi avec sa disposition (« conservé » / « abandonné ») ; le vocabulaire des
  stages vit dans une seule table, `client-error-stages.ts`.
- **`ensureFreshSession` est sous mutex** (2026-08-31) : chaque `refreshSession()` fait tourner
  le refresh token, N rafraîchissements concurrents produisent N-1 jetons morts. La règle ESLint
  `local/single-browser-supabase-client` tient l'autre moitié : un seul client de navigateur.
- **`/api/client-log` n'exige aucun jeton, délibérément** (2026-08-31) : il reçoit le récit d'un
  refus d'authentification, donc d'un jeton cassé. Bornes : placé après `guardRequest` (plafond
  par IP), corps ≤ 8 ko, table sans policy RLS qui ne nomme personne. Trois tests le figent.
- **La porte du quiz d'un chapitre n'a qu'UNE définition** (2026-09-04, #1005) :
  `chapter_quiz_gated` / `chapter_quiz_cleared`, appelées par les quatre lecteurs (dont
  `start_exercise_session`). Un `LIMIT 1` sans `ORDER BY` tirait « le » quiz au hasard ;
  l'ordonner aurait rendu la réponse stable **et fausse**. Le pgTAP 96 tient le décor à deux quiz.
- **Un chiffre de couverture s'affiche avec son recours** (2026-09-04) : « 3/20 chap. » veut dire
  « maîtrisés », et le suivi liste ce qui manque par chapitre — y compris le quiz expédié
  (< 4 s/question) qui empêche un chapitre à 6/6 missions de compter. `student_chapter_gaps`
  reprend les prédicats de `student_parcours_progress`, une assertion pgTAP les confronte.
