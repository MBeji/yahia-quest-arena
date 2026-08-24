# Campagnes de contenu — conduite de session

> Playbook (étude 25 D-7). ⚠️ **Depuis la scission de l'étude 24 (2026-07-20), une campagne de
> contenu ne se lance plus depuis ce dépôt** : le corpus, les 41 skills `content-*`/`prof-*`, la
> méthode (`METHODE-GENERATION-CONTENU.md`) et les études vivent dans le dépôt **privé**
> `MBeji/yahia-quest-content`. Ce dépôt-ci ne garde que le **moteur** (`scripts/content/**`,
> `src/shared/content/**`), que la CI privée invoque par double checkout.
>
> Ce fichier reste ici parce que ce qu'il décrit — la **conduite** d'une session de campagne — est
> une leçon de process, pas du contenu : elle vaut quel que soit le dépôt où tourne la session.
> Les règles d'écriture, elles, vivent avec les skills, au privé.

## Le corpus source est hors dépôt

Les manuels et documents CNP vivent dans le dossier **wrapper** `YahiaAcademy/` (hors git, non
versionné). Une campagne tourne donc **sur ce poste**, pas dans un runner CI : la session doit
être lancée localement avec l'accès au corpus (`--add-dir`). Une session headless sans
abonnement échoue (« Not logged in »), et une clé API n'est pas une alternative acceptée ici.

## Budget de session

Vérifié sur le pilote maths 2ᵉ sec (manuel de 364 pages, 19 chapitres) : **~4 chapitres par
session** en lecture vision. Au-delà, la qualité chute avant le quota. Conséquences :

- **une matière par session**, pas une classe entière ;
- **livrer en petits lots poussés** — une PR par fiche, puis une PR par tranche de ≤ 4 chapitres.
  Jamais une longue session sans livrable : une session tuée par la limite d'usage perd tout ce
  qui n'est pas poussé.

## Lire les PDF

`Read` sur un PDF de manuel échoue en pratique (taille, pages scannées). Passer par le rendu en
images (`render.sh`, ~150 dpi) puis lecture vision. La couche texte, quand elle existe, est
fiable pour la prose et **trompeuse pour les mathématiques** (formules aplaties) — re-vérifier
toute formule à l'image.

## Vérifier l'existant AVANT de générer

Le registre `programmes-officiels/suivi/` dit ce qui est **déjà transcrit** (plages de pages,
statuts normés) ; `_INDEX.md` en est la vue **générée** (`npm run programme:index`), et
`npm run programme:check` est le gate. Un statut `[~]` signifie « déjà fait », pas « trou à
combler » — la double transcription est l'erreur la plus coûteuse de cette chaîne. Le registre se
met à jour **dans le même commit** que la fiche qu'il décrit.

## Ce que les gates ne voient pas

`content:qa:strict` vérifie la **structure** et la **notation**, pas la **correction** : une clé
de réponse fausse passe le gate. C'est le rôle du sweep `content-audit` (re-résolution de chaque
question) et de l'audit humain. Ne jamais conclure « le contenu est bon » sur un gate vert.

Corollaire observé : les erreurs se logent plus souvent dans les **exemples du cours** que dans
les clés de réponse — l'audit doit lire `cours.md`, pas seulement les quiz.

## Merger ne publie pas — et un run vert ne prouve pas la publication

Le contenu a quitté le framework de migrations (étude 24 D-3) : il est **appliqué** à la prod par
le workflow privé `apply-content.yml`, en `workflow_dispatch` **seul**. Un merge ne déclenche
rien. Une campagne mergée, auditée et verte peut donc n'atteindre **aucun élève** — c'est arrivé
sur 18 sujets à la fois (privé #124), et sur les 1 049 tags de misconception de C4bis, restés
invisibles entre leur merge et leur application.

**Cibler un sujet.** L'entrée `subjects` vide applique **tout le corpus** : ~45 min d'écriture
continue en prod, contre ~2 min pour un sujet. Sûr pour les données, pas pour la charge.
Toujours un `dry_run=true` d'abord : il affiche le plan et sort.

⚠️ **Et le run vert ne prouve pas que tout est arrivé.** L'étape de contrôle du workflow compte
les **chapitres et les questions** ; elle ne regarde **aucune colonne serveur-seul** —
`distractor_tags` (étude 04 D-1), `correct_option`, et demain tout champ exclu de la whitelist
`SELECT` de `questions`. Un canal peut donc s'afficher vert en ayant appliqué des lignes sans le
signal qui justifiait la campagne.

Le contrôle qui tranche, depuis l'extérieur et en lecture seule (clés **publiques** du `.env`) :
comparer le **décompte de questions du sujet en prod** au décompte du **corpus au SHA appliqué**.

```bash
# $URL / $KEY : VITE_SUPABASE_URL et VITE_SUPABASE_PUBLISHABLE_KEY du .env — publiques.
curl -s -H "apikey: $KEY" -H "Prefer: count=exact" -H "Range: 0-0" -o /dev/null -D - "$URL/rest/v1/questions?select=id,exercises!inner(id,chapters!inner(subject_id))&exercises.chapters.subject_id=eq.math"
# → Content-Range: 0-0/818   (à comparer au corpus au SHA appliqué)
```

Égalité ⇒ les lignes ont bien été ré-upsertées à ce SHA, et les colonnes serveur-seul voyagent
dans le **même** upsert : elles sont là. C'est la preuve la plus forte accessible sans accès
base. Contrôle négatif à faire une fois : demander `distractor_tags` en anon doit répondre
`42501 permission denied` — une réponse serait une fuite, pas une bonne nouvelle.

La preuve de bout en bout, elle, reste **produit** : `user_misconceptions` qui se remplit quand
des élèves ratent des questions taguées. Elle ne s'observe pas le jour de l'application.
