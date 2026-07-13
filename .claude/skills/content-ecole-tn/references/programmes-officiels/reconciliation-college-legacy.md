# Plan de réconciliation — collège scientifique sans transcription officielle

> Contexte (audit 2026-07-12, avant l'ouverture du lycée) : la chaîne applique désormais la règle
> « **transcription d'abord** » (`content-ecole-tn/SKILL.md`) — un contenu scolaire ne devrait être
> généré qu'après que `programme/<grade>/<matière>.md` existe. Trois matières du collège scientifique
> ont été générées **avant** cette règle (juillet 2026, PR #268/#278/#282/#289) et n'ont **jamais** eu de
> transcription CNP officielle en regard. Ce n'est pas un doublon comme la campagne ScribeKit collège
> FR/EN/AR (cf. `content-ingest/SKILL.md` R-4) — ici il n'existe **aucune** fiche du tout, ancienne ou
> nouvelle, pour ces couples (grade, matière). Dette de fidélité héritée, pas une régression récente.

## Périmètre constaté (vérifié par lecture directe du repo, pas de supposition)

| Grade     | Matière            | `content/` (généré, jouable)                                                  | `programme/<grade>/<matière>.md` (transcription CNP) |
| --------- | ------------------ | ----------------------------------------------------------------------------- | ---------------------------------------------------- |
| 7ème-base | Maths              | `math-7eme` (13 chapitres)                                                    | ❌ absent                                            |
| 7ème-base | Sciences physiques | `sciences-physiques-7eme`                                                     | ❌ absent                                            |
| 7ème-base | SVT                | `sciences-vie-terre-7eme`                                                     | ❌ absent                                            |
| 8ème-base | Maths              | `math-8eme` (12 chapitres)                                                    | ❌ absent                                            |
| 8ème-base | Sciences physiques | `sciences-physiques-8eme`                                                     | ❌ absent                                            |
| 8ème-base | SVT                | `sciences-vie-terre-8eme`                                                     | ❌ absent                                            |
| 9ème-base | Maths              | `math` (id legacy bare — 9ème, cf. convention id `content-ecole-tn/SKILL.md`) | ❌ absent                                            |
| 9ème-base | Sciences physiques | `svt` (⚠️ id **anomalie historique** = sciences physiques 9ème, PAS SVT)      | ❌ absent                                            |
| 9ème-base | SVT                | `sciences-vie-terre` (id bare — la vraie SVT 9ème)                            | ❌ absent                                            |

À l'inverse, langues collège (arabe/français/anglais, 7-8-9ème) **ont** leur transcription
(`programme/{7,8,9}eme-base/{arabe,francais,anglais}.md`) — pas concernées par ce plan.

## Pourquoi ça compte

- `content-audit` (skill) re-résout chaque question et vérifie la calibration/notation, mais **ne
  vérifie pas la fidélité au programme officiel** faute de fiche de référence à confronter (règle R-3
  `content-ingest`) — ces 9 sujets sont donc **hors de portée** de cette vérification depuis toujours.
- Toute évolution future de ces chapitres (ajout, correction, montée en difficulté par un `prof-*`) se
  fait **sans garde-fou de scope** contre le programme officiel — risque de dérive silencieuse.

## Plan (à exécuter, pas urgent — pas de gate cassée, c'est un renforcement)

1. **Transcrire d'abord la 9ème** (année de concours national, plus haute exposition) : maths, sciences
   physiques, SVT — un lot par matière, standard « profondeur de génération » (voir R-5/R-6/R-7 de
   `content-ingest/SKILL.md`), guide enseignant + manuel élève combinés quand les deux existent
   (`cnp-officiel/CATALOGUE.md` pour repérer les codes).
2. **Puis 8ème, puis 7ème** dans le même ordre de matières.
3. **Passer `content-audit` sur l'existant** une fois chaque fiche disponible : confronter chapitre par
   chapitre le contenu déjà généré (`content/<matière>-<grade>/`) à la transcription fraîche — n'importe
   quel écart de scope devient un finding priorisé, pas une réécriture automatique (le programme gagne,
   mais on documente l'écart avant de trancher, règle R-3).
4. Mettre à jour `programme/_INDEX.md` (une ligne par couple grade×matière, actuellement absente pour ces
   9 cas — le tableau collège du fichier ne liste que les langues).

## Ce que ce plan n'est PAS

- Pas une invalidation du contenu existant : ces 9 sujets sont vivants, joués, et n'ont **aucun signalement
  de qualité** connu à ce jour. La transcription rétroactive est un renforcement de la garantie de
  fidélité, pas une correction de bug.
- Pas un prérequis bloquant pour l'ouverture du lycée (chantier distinct, cycles différents) — mais à
  faire avant de charger davantage ce cycle (nouveaux `prof-*-college` overlays, révisions profondes).
