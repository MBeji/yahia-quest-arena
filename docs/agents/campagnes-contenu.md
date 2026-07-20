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
