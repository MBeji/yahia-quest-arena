# FableEtudes — dossiers d'étude & de conception (architecte → exécuteurs)

Ce répertoire contient les **études d'architecture technique et fonctionnelle complètes** des
epics du projet, produites par le **modèle architecte** (Fable/Opus) et destinées à être
**implémentées par un modèle exécuteur moins cher** (Sonnet ou équivalent), lot par lot.

> Une étude n'est pas un ticket : c'est le **contrat d'exécution**. Elle contient toutes les
> décisions déjà prises (données, RPC, UI, sécurité, découpage en lots, tests exigés) pour qu'un
> exécuteur puisse livrer chaque lot **sans re-décider l'architecture** et sans relire tout le
> repo. Quand une étude et le code divergent pendant l'exécution, l'exécuteur ne « corrige » pas
> l'étude : il s'arrête et remonte (voir Règles d'exécution).

## Rôles

| rôle           | qui                                  | fait                                                                                    | ne fait pas                                        |
| -------------- | ------------------------------------ | --------------------------------------------------------------------------------------- | -------------------------------------------------- |
| **Architecte** | Fable / Opus                         | audits, décisions d'architecture, l'étude complète, revue des lots livrés               | implémenter les lots                               |
| **Exécuteur**  | Sonnet (ou équiv.) **ou dév humain** | implémente UN lot par PR, tests inclus, gate verte, dans le cadre de l'étude            | dévier de l'étude, re-designer, fusionner des lots |
| **Humain**     | Mohamed                              | valide l'étude (statut → `validée`), tranche les questions ouvertes, arbitre les écarts | —                                                  |

> **Nouveau collaborateur humain ?** Tu endosses le rôle **Exécuteur**. Commence par
> **[`CONTRIBUER.md`](./CONTRIBUER.md)** : mise en route (setup, `.env`, `npm run verify`), ordre
> de lecture, workflow Git & chaîne d'auto-merge, réservation d'une étude à deux, STOP & escalade.
> Les « Règles d'exécution » ci-dessous s'appliquent à toi comme au modèle.
>
> **Contribuer le contenu persistant CNP avec ton agent IA ?** Prompt clé-en-main, zéro
> connaissance du projet requise :
> **[`PROMPT-TRANSCRIPTION-CNP.md`](./PROMPT-TRANSCRIPTION-CNP.md)** (études 12/13) — un seul
> input (portée + tes PDF, sinon téléchargés depuis le site du CNP), et l'agent **boucle sur
> tous les documents manquants** — classe par classe, matière par matière, chapitre par
> chapitre : transcription (ScribeKit) → enrichissement → audits → **génération via les
> skills du projet**, avec une PR par lot (matière complète).

## Cycle de vie d'une étude

`brouillon` → `validée` (par l'humain) → `en exécution` (lots en cours, cocher au fur et à mesure)
→ `livrée` (tous les lots mergés) — ou `gelée` (attente d'une dépendance / décision).
Le statut vit dans l'en-tête du dossier `ETUDE.md`; l'index ci-dessous est un instantané
(à jour au 2026-07-14) à resynchroniser quand on touche une étude. Quand un exécuteur **réserve**
une étude, la cellule « statut » porte son nom — `en exécution (<pseudo>)` — pour que le binôme
voie qui fait quoi (procédure : [`CONTRIBUER.md`](./CONTRIBUER.md) §4).

## Index des études

| #   | étude                                                                                        | valeur                                                                                     | complexité | statut       | dépend de                                                                                                                                                                                                                                                                                                                     |
| --- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 01  | [Paiement en ligne](01-paiement-en-ligne/ETUDE.md)                                           | 💰 réactivation du premium (hors phase gratuite)                                           | moyenne+   | **gelée**    | sortie de la phase gratuite (décision humaine) + choix PSP                                                                                                                                                                                                                                                                    |
| 02  | [Examen blanc / simulation concours](02-examen-blanc/ETUDE.md)                               | 💎 expérience concours (justif. premium à re-scoper)                                       | moyenne+   | brouillon    | contenu annales (`NN-annales-bac`)                                                                                                                                                                                                                                                                                            |
| 03  | [Types de questions natifs (Tier B)](03-types-questions-natifs/ETUDE.md)                     | 🎮 expérience & anti-devinette                                                             | haute      | livrée       | — (spec normative déjà mergée)                                                                                                                                                                                                                                                                                                |
| 04  | [Moteur adaptatif & diagnostic de misconceptions](04-moteur-adaptatif/ETUDE.md)              | 🧠 différenciateur pédagogique                                                             | haute      | en exécution | télémétrie (lot A0) puis volume                                                                                                                                                                                                                                                                                               |
| 05  | [Duels temps réel & ligues](05-duels-ligues/ETUDE.md)                                        | 🔁 rétention/engagement                                                                    | très haute | livrée       | — (livrée 2026-07-06, 5 lots)                                                                                                                                                                                                                                                                                                 |
| 06  | [PWA & lecture hors-ligne](06-pwa-offline/ETUDE.md)                                          | 🌍 marché (connectivité)                                                                   | haute      | brouillon    | besoin utilisateur documenté                                                                                                                                                                                                                                                                                                  |
| 07  | [Knowledge Graph & profils de maîtrise](07-knowledge-graph-competences/ETUDE.md)             | 🧭 socle de l'intelligence produit                                                         | haute      | en exécution | étude 04 lot A0 (✅) — lot 1 livré (#366) ; Q-1/2/3 tranchées 2026-07-11                                                                                                                                                                                                                                                      |
| 08  | [Analytics parents & enseignants](08-analytics-familles/ETUDE.md)                            | 👨‍👩‍👧 suivi familles (wording « payant » à re-scoper)                                         | moyenne    | brouillon    | 04-A0 ; 07 (faiblesses) ; 02 (percentile)                                                                                                                                                                                                                                                                                     |
| 09  | [Économie du jeu — instrumentation](09-economie-du-jeu/ETUDE.md)                             | ⚖️ motivation saine                                                                        | faible+    | brouillon    | — (indépendant)                                                                                                                                                                                                                                                                                                               |
| 10  | [Intégrité & anti-fraude](10-integrite-anti-fraude/ETUDE.md)                                 | 🛡️ crédibilité des classements                                                             | moyenne+   | brouillon    | s'active après 02/05                                                                                                                                                                                                                                                                                                          |
| 11  | [Tuteur IA pédagogique](11-tuteur-ia-pedagogique/ETUDE.md)                                   | 🤖 le rêve produit                                                                         | haute      | **gelée**    | gelée avec 01 (financement du coût par usage) ; 04-A0 (✅) ; 07                                                                                                                                                                                                                                                               |
| 12  | [Studio d'ingestion (PDF→contenu)](12-studio-ingestion/ETUDE.md)                             | 📥 coût de création                                                                        | moyenne    | brouillon    | pilote opéré avant canal in-app ; 13 (déterministe)                                                                                                                                                                                                                                                                           |
| 13  | [Moteur de transcription fidèle (corpus→app), OCR compris](13-moteur-transcription/ETUDE.md) | 🔧 transcription fidèle (OCR compris), résumable, traçable, LLM-agnostique                 | haute      | livrée       | — (moteur = repo externe **ScribeKit** ; pilote d'usage en cours, PR #348)                                                                                                                                                                                                                                                    |
| 14  | [Refonte UX/design (registres, primitives, RTL)](14-refonte-ux-design/ETUDE.md)              | 🎨 cohérence perçue & confiance                                                            | moyenne+   | livrée       | — (arbitré 2026-07-10)                                                                                                                                                                                                                                                                                                        |
| 15  | [Contenu & composition des écrans](15-contenu-design-ecrans/ETUDE.md)                        | 🧭 conversion, rétention J1, confiance parent                                              | moyenne+   | en exécution | é14 (livrée) — lots 0–6 livrés / 14                                                                                                                                                                                                                                                                                           |
| 16  | [Ouverture du lycée (sections, mutualisation, arborescence)](16-ouverture-lycee/ETUDE.md)    | 🎓 second cycle complet — 17 classes                                                       | haute      | en exécution | lots 0–3 livrés (#367/#369/#371/#375) ; reste : campagne de contenu (vague A, corpus L1 secondaire)                                                                                                                                                                                                                           |
| 17  | [Rappel actif (rejouer les QCM en saisie libre)](17-rappel-actif/ETUDE.md)                   | 🧠 double le contenu jouable à coût zéro (active recall)                                   | moyenne    | **validée**  | — (le contenu QCM existant suffit) ; Q-1…Q-4 arbitrées 2026-07-13 ; s'articule avec 03 et 04-A1                                                                                                                                                                                                                               |
| 18  | [Cours vivants (blocs pédagogiques & illustration)](18-cours-vivants/ETUDE.md)               | 📐 le cours cesse d'être un mur de texte ; la géométrie cesse d'être enseignée sans figure | moyenne+   | **livrée**   | — (5 lots livrés 2026-07-14 : 517 cours structurés · 3 827 cartes de révision · figures légendées/agrandissables · gate contenu ouvert aux 541 leçons (46 violations de notation corrigées) · axe 5 « Illustration » · **géométrie 9ᵉ illustrée, 25 figures**. Backlog laissé par l'axe 5 : 22 chapitres spatiaux → campagne) |

**Ordre d'exécution recommandé — révisé post-pivot gratuité (2026-07-11)** (les numéros sont des
identifiants, pas l'ordre) : finir l'en-cours `15 → 16 → 04-A1`, puis
`07 → 08 (re-scopée) → 02 (re-scopée) → 09 (parallèle) → 10 → 12 → 06`.
**`18` (cours vivants) est **livrée** (2026-07-14)** — et elle change les règles de toute campagne
de contenu qui suit : la barre qualité a désormais un **axe 5 « Illustration »**, `content:qa`
inspecte les leçons, et un chapitre à notions spatiales sans figure est signalé. Toute vague de
génération (16, lycée) doit s'y conformer, et **22 chapitres spatiaux sans dessin** restent au
backlog que l'axe 5 a produit (6ᵉ, 7ᵉ, 1ère sec…).
Les études `01` et `11` sont **gelées** tant que dure la phase gratuite (sortie de gel = décision
humaine). L'ancien ordre « monétisation d'abord » (`01 → 02 → …`) et ses verdicts restent lisibles
dans [`REVUE-2026-07-dix-features.md`](REVUE-2026-07-dix-features.md) (trace d'arbitrage datée,
antérieure au pivot). L'humain arbitre. État global du projet : [`../STATUS.md`](../STATUS.md).

## Format d'un dossier

Chaque epic a un dossier `NN-<slug>/` contenant au minimum `ETUDE.md` conforme à
[`_TEMPLATE.md`](_TEMPLATE.md) (annexes libres : maquettes, schémas SQL, benchmarks). Les études
**complètent** les documents normatifs du repo et ne les dupliquent jamais : CLAUDE.md et
ARCHITECTURE.md gagnent toujours, et une étude qui touche le moteur de contenu renvoie à
`docs/interactive-question-types.md`, `docs/lycee-architecture.md`, etc.

## Règles d'exécution (pour l'exécuteur — modèle ou dév humain — non négociables)

1. **Lis dans l'ordre** : CLAUDE.md (entier), puis l'ETUDE.md de ton epic (entier), puis la
   section du lot qui t'est confié. Ne commence pas sans ça.
2. **Un lot = une PR** sur une branche dédiée, message conventionnel, description qui référence
   l'étude (`FableEtudes/NN-…#lot-X`). Jamais deux lots dans une PR, jamais un lot partiel
   silencieux.
3. **Le cadre est fermé** : tu implémentes ce que le lot spécifie — mêmes noms de tables/colonnes/
   RPC/fichiers, mêmes frontières features/shared, mêmes invariants de sécurité. Si l'étude est
   ambiguë, incomplète, ou contredit le code réel : **STOP**, documente l'écart dans la PR/issue et
   demande l'arbitrage (architecte ou humain). Ne re-designe jamais en silence.
4. **DoD intégral** (CLAUDE.md « Definition of Done ») : gate verte (`npm run verify`, et
   `ci:verify` pour un lot release-grade), tests co-localisés qui voyagent avec le code, zéro
   affaiblissement du gate, migrations additives AVANT le code qui les utilise (§7), grants
   explicites sur toute nouvelle table, pgTAP pour toute logique SQL.
5. **Sécurité d'abord** : toute clé de réponse/donnée sensible reste server-side ; RLS sur toute
   nouvelle table ; validation zod sur toute server fn ; logging via `@/shared/lib/logger`
   (jamais de secrets). Un doute sécurité = STOP + escalade.
6. **Fin de lot** : coche la case du lot dans l'ETUDE.md (même PR), note les écarts acceptés dans
   la section « Journal d'exécution » de l'étude.

## Créer une nouvelle étude

Copier `_TEMPLATE.md` dans `NN-<slug>/ETUDE.md` (numéro = priorité), remplir TOUTES les sections
(une section vide = étude pas prête), ajouter la ligne d'index ici. Les études sont rédigées par
le modèle architecte ; un exécuteur ne crée pas d'étude.
