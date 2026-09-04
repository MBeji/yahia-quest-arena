# Pièges du code applicatif

> Des comportements que **le gate local ne montre pas** et qu'on ne devine pas en lisant le
> code : chacun a coûté soit un bug en production, soit un cycle de build. Ils ne sont pas dans
> [`AGENTS.md`](../../AGENTS.md) § Known gotchas parce que ce fichier a un budget dur de
> 250 lignes (il est injecté dans chaque session) — ici, il n'y en a pas.
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
