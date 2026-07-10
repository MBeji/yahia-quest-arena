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

| rôle           | modèle             | fait                                                                         | ne fait pas                                        |
| -------------- | ------------------ | ---------------------------------------------------------------------------- | -------------------------------------------------- |
| **Architecte** | Fable / Opus       | audits, décisions d'architecture, l'étude complète, revue des lots livrés    | implémenter les lots                               |
| **Exécuteur**  | Sonnet (ou équiv.) | implémente UN lot par PR, tests inclus, gate verte, dans le cadre de l'étude | dévier de l'étude, re-designer, fusionner des lots |
| **Humain**     | —                  | valide l'étude (statut → `validée`), tranche les questions ouvertes, merge   | —                                                  |

## Cycle de vie d'une étude

`brouillon` → `validée` (par l'humain) → `en exécution` (lots en cours, cocher au fur et à mesure)
→ `livrée` (tous les lots mergés) — ou `gelée` (attente d'une dépendance / décision).
Le statut vit dans l'en-tête du dossier `ETUDE.md`; l'index ci-dessous est un instantané à
resynchroniser quand on touche une étude.

## Index des études

| #   | étude                                                                                        | valeur                                                                     | complexité | statut       | dépend de                                           |
| --- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ---------- | ------------ | --------------------------------------------------- |
| 01  | [Paiement en ligne](01-paiement-en-ligne/ETUDE.md)                                           | 💰 revenus directs                                                         | moyenne+   | brouillon    | choix PSP + compte marchand (humain)                |
| 02  | [Examen blanc / simulation concours](02-examen-blanc/ETUDE.md)                               | 💎 valeur premium concours                                                 | moyenne+   | brouillon    | contenu annales (`NN-annales-bac`)                  |
| 03  | [Types de questions natifs (Tier B)](03-types-questions-natifs/ETUDE.md)                     | 🎮 expérience & anti-devinette                                             | haute      | livrée       | — (spec normative déjà mergée)                      |
| 04  | [Moteur adaptatif & diagnostic de misconceptions](04-moteur-adaptatif/ETUDE.md)              | 🧠 différenciateur pédagogique                                             | haute      | en exécution | télémétrie (lot A0) puis volume                     |
| 05  | [Duels temps réel & ligues](05-duels-ligues/ETUDE.md)                                        | 🔁 rétention/engagement                                                    | très haute | livrée       | 01 (revenus d'abord), infra Realtime                |
| 06  | [PWA & lecture hors-ligne](06-pwa-offline/ETUDE.md)                                          | 🌍 marché (connectivité)                                                   | haute      | brouillon    | besoin utilisateur documenté                        |
| 07  | [Knowledge Graph & profils de maîtrise](07-knowledge-graph-competences/ETUDE.md)             | 🧭 socle de l'intelligence produit                                         | haute      | brouillon    | étude 04 lot A0                                     |
| 08  | [Analytics parents & enseignants](08-analytics-familles/ETUDE.md)                            | 👨‍👩‍👧 valeur commerciale familles                                             | moyenne    | brouillon    | 04-A0 ; 07 (faiblesses) ; 02 (percentile)           |
| 09  | [Économie du jeu — instrumentation](09-economie-du-jeu/ETUDE.md)                             | ⚖️ motivation saine                                                        | faible+    | brouillon    | — (indépendant)                                     |
| 10  | [Intégrité & anti-fraude](10-integrite-anti-fraude/ETUDE.md)                                 | 🛡️ crédibilité des classements                                             | moyenne+   | brouillon    | s'active après 02/05                                |
| 11  | [Tuteur IA pédagogique](11-tuteur-ia-pedagogique/ETUDE.md)                                   | 🤖 le rêve produit                                                         | haute      | brouillon    | 01 (coût) ; 04-A0 ; 07 (similaire)                  |
| 12  | [Studio d'ingestion (PDF→contenu)](12-studio-ingestion/ETUDE.md)                             | 📥 coût de création                                                        | moyenne    | brouillon    | pilote opéré avant canal in-app ; 13 (déterministe) |
| 13  | [Moteur de transcription fidèle (corpus→app), OCR compris](13-moteur-transcription/ETUDE.md) | 🔧 transcription fidèle (OCR compris), résumable, traçable, LLM-agnostique | haute      | en exécution | — (la génération reste chez 12/skills)              |
| 14  | [Refonte UX/design (registres, primitives, RTL)](14-refonte-ux-design/ETUDE.md)              | 🎨 cohérence perçue & confiance                                            | moyenne+   | en exécution | — (arbitré 2026-07-10)                              |
| 15  | [Contenu & composition des écrans](15-contenu-design-ecrans/ETUDE.md)                        | 🧭 conversion, rétention J1, confiance payeur                              | moyenne+   | brouillon    | é14 (lots par écran) ; arbitrages Q-1…Q-6 (humain)  |

**Ordre d'exécution recommandé** (les numéros sont des identifiants, pas l'ordre) :
`01 → 02 → 03-B1 → 04-A0/A1 → 07 → 08 → 11 → 09 (parallèle) → 10 → 05 → 13 → 12 → 06`.
Verdicts et justification : [`REVUE-2026-07-dix-features.md`](REVUE-2026-07-dix-features.md)
(revue critique des 10 features proposées — approuvées / re-scopées / rejetées). L'humain arbitre.

## Format d'un dossier

Chaque epic a un dossier `NN-<slug>/` contenant au minimum `ETUDE.md` conforme à
[`_TEMPLATE.md`](_TEMPLATE.md) (annexes libres : maquettes, schémas SQL, benchmarks). Les études
**complètent** les documents normatifs du repo et ne les dupliquent jamais : CLAUDE.md et
ARCHITECTURE.md gagnent toujours, et une étude qui touche le moteur de contenu renvoie à
`docs/interactive-question-types.md`, `docs/lycee-architecture.md`, etc.

## Règles d'exécution (pour le modèle exécuteur — non négociables)

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
