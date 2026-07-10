# `_ingest-batch-full` — transcriptions **first-pass** (ScribeKit, couverture complète)

Lot de transcriptions **first-pass** des documents CNP **à couche-texte propre** (0 OCR) des
**matières principales** : collège 6→9ème (**français / anglais**) + **1ère-sec** (**français /
anglais / chimie**). Produit par un pipeline outillé, **piloté par ScribeKit**.

## Méthode (pipeline outillé — 0 clé API)

1. **ScribeKit** (déterministe, 0 LLM / 0 clé) : `scribekit transcribe` → extraction **intégrale,
   sans troncature** de chaque source (manuel élève + guide enseignant + cahier), avec
   `ledger.json` + `AVANCEMENT.md` (résumable / traçable). C'est la couche déterministe de
   l'étude 13 / du skill `content-ingest`.
2. **Agent** : fiche structurée **fidèle** (structure exhaustive — modules / séquences / chapitres
   - objectifs + notions + supports + types d'activités + bornes de scope + incertitudes), à partir
     de l'extraction intégrale.
3. **Agent vérificateur** : contrôle de **fidélité** (aucune invention, notation standard —
   chiffres occidentaux / LTR / SI).

## Statut (2026-07-10)

- **10/11 fiches produites** : `6eme-base__anglais`, `7eme-base__francais`, `7eme-base__anglais`,
  `8eme-base__francais`, `8eme-base__anglais`, `9eme-base__francais`, `9eme-base__anglais`,
  `1ere-sec__francais`, `1ere-sec__anglais`, `1ere-sec__chimie`.
- **1 en attente** : `6eme-base__francais` — source ScribeKit très volumineuse (1,55 M car. dont un
  fascicule de grammaire de 903 Ko) ; sa fiche reste à produire.
- **Vérification** : passe interrompue par la **limite de session** (reset 5:10 Tunis). Seule
  `9eme-base__anglais` est **confirmée fidèle** à ce stade ; les 9 autres sont **à vérifier**.
  (Le lot first-pass tronqué antérieur avait validé 10/11 ; son unique signalement — une invention
  d'attribution en 7e FR — **n'est pas reproduite** dans la version couverture-complète.)

## Ce lot n'est **PAS** encore intégré

Ces fiches sont **first-pass, pour revue** (règle R-1 : fichiers versionnés + PR + revue humaine ;
aucune écriture DB). **Prochaines étapes** (après le reset de la limite) :

1. produire `6eme-base__francais` + lancer la **passe de vérification** sur les 9 fiches restantes ;
2. réconcilier les fiches **jugées fidèles** dans `programme/<niveau>/<matière>.md` + les manifestes
   - le `_INDEX` ;
3. la profondeur par-chapitre (comme la maths 1ère-sec finale) reste une **passe ultérieure** par
   matière — ceci n'est que la couche structure/objectifs.
