# Étude 12 — Studio d'ingestion (PDF/source → contenu, dans le pipeline à gates)

> **Statut** : brouillon
> **Priorité** : 12 · **Valeur** : faire chuter le coût de création quand la source n'est pas déjà couverte (PDF d'un enseignant, polycopié, annales papier) — sans sacrifier ce qui fait la valeur du contenu : fidélité, corrigés vérifiés, revue humaine · **Complexité** : moyenne (surtout process/outillage — le gros existe déjà)
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet (outillage) + skills contenu (génération)
> **Dépend de** : rien de bloquant ; synergie avec la couche de persistance existante (transcriptions CNP) · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md (content pipeline — « files only, never SQL »), `content-engine/references/generation-pipeline.md`, `docs/content-generation-pipeline.md`, REVUE-2026-07 (re-scoping de la feature #2)
> **Voir aussi** : [étude 13 — Moteur de transcription fidèle (OCR compris)](../13-moteur-transcription/ETUDE.md). L'étude 13 fait toute la **transcription fidèle** du corpus — extraction des PDF à couche-texte **et OCR/vision des scans** (via une interface LLM agnostique) → format app, résumable et traçable — **sans jamais générer de contenu**. L'étude 12 reste le **canal opéré/in-app** et le home de la **génération** (QCM/cours via les skills) : le skill `content-ingest` (D-2 ci-dessous) lance d'abord le moteur 13 pour obtenir la transcription, puis génère le contenu à partir d'elle.
> **La méthode opérationnelle de ce canal est [`../METHODE-GENERATION-CONTENU.md`](../METHODE-GENERATION-CONTENU.md)** (consolidation 2026-07-17) : le processus de référence source → fiche → contenu → prod, générique (profils ecole-cnp / ecole-secondaire / document-libre / sans-source) et budgété en tokens (charte T-1…T-10). Elle remplace l'ancien `PROMPT-TRANSCRIPTION-CNP.md`.

## 1. Contexte & objectif produit

La proposition d'origine (« un PDF entre, leçons/QCM/images/examens sortent automatiquement »)
sous-estime l'existant et sur-promet : la génération est **déjà industrialisée** (skills en
3 couches, gates `content:check`/`qa:strict`, migrations UUIDv5, audit planifié 2×/semaine) —
c'est un pipeline de **qualité contrôlée**, pas un générateur libre. Le chaînon réellement
manquant : quand la source est un **document arbitraire** (PDF enseignant, manuel non couvert),
il n'existe pas de chemin outillé source→`content/`. Objectif : ce chemin, **entièrement à
l'intérieur du pipeline à gates** (la ligne rouge de la REVUE : rien n'entre en base sans
fichiers versionnés + gates + revue). KPI : délai source→chapitre publié, coût de création par
chapitre, taux de rejet en revue/audit.
Non-objectif : bouton « générer » self-service pour tous les enseignants (v1), génération
d'images bitmap (le moteur rend du SVG), publication automatique sans revue.

## 2. Spécification fonctionnelle

- **US-1 (opérateur/architecte)** : je dépose un PDF source dans un espace d'ingestion, je lance
  le workflow : le document est transcrit en **fiche source structurée** (même format que les
  transcriptions CNP : périmètre, notions, exemples, exercices du document, bornes), stockée et
  versionnée à côté des transcriptions existantes.
- **US-2 (opérateur)** : depuis la fiche, la génération produit un **brouillon complet de
  chapitre** (`chapter.json`, `cours.md`, `resume.md`, `quiz.json`, `exercices/*` — ladder
  standard + interactifs) via les skills existants, sur une branche → PR normale (diff lisible,
  gates CI, revue humaine, audit).
- **US-3 (enseignant partenaire, v1 encadrée)** : je transmets mon PDF (canal simple : upload
  dans l'app → file d'attente admin, ou email) et je reçois le chapitre publié après le cycle ;
  je suis crédité dans `chapter.json.sources[]`.
- **R-1 — Rien ne contourne le pipeline** : la sortie de l'ingestion est TOUJOURS des fichiers
  `content/` sur une branche + les gates + revue humaine. Aucune écriture DB directe, aucun
  skip d'audit. (Identique à la règle des skills : « files only, never SQL ».)
- **R-2 — Provenance & droits** : chaque source ingérée porte auteur/origine/autorisation dans
  la fiche ; un document sous droits sans autorisation est refusé (checklist au dépôt). Les
  `sources[]` du chapitre citent le document.
- **R-3 — Programme d'abord** : pour une matière scolaire, la fiche source est **confrontée à la
  transcription CNP** (si elle existe) ; en cas de divergence de périmètre, le programme
  officiel gagne et l'écart est signalé (règle existante de `content-ecole-tn`).
- **R-4 — Files d'attente bornées** : v1, l'ingestion est un **workflow opéré** (sessions Claude
  Code pilotées par l'opérateur), pas un job serveur — Vercel serverless n'exécute pas de jobs
  longs, et c'est un choix assumé, pas une dette.
- **Hors périmètre (v1)** : self-service enseignant complet (v2 : soumission in-app + statut),
  génération d'images (SVG autorisé via les règles existantes), flashcards (format inexistant
  dans le moteur — à traiter par l'étude des types natifs si le produit le demande), OCR de
  manuscrits.

## 3. Architecture technique (décisions fermées)

- **D-1 — L'ingestion est une extension de la couche de persistance existante**, pas un système
  parallèle : les fiches sources vivent sous
  `content-ecole-tn/references/programmes-officiels/sources-externes/<slug>/fiche.md` (école) ou
  `content/_sources/<theme>/<slug>/fiche.md` (non scolaire), avec un README de format calqué sur
  `programme/_TEMPLATE.md`. Même philosophie : **on transcrit une fois, on consomme la
  transcription** (jamais de re-lecture du PDF par les skills de génération).
- **D-2 — Un skill d'ingestion** (`content-ingest`) orchestre : lecture du PDF (vision/texte) →
  fiche structurée → confrontation CNP (R-3) → hand-off aux skills de génération
  (`content-ecole-tn`/wrappers + `content-cours` + `content-interactif` + prof-\* pour le
  plafond). Le skill est de la même famille que `curriculum-architect` : il produit fiche + plan,
  la génération reste chez les skills existants (pas de duplication du cœur).
- **D-3 — Le canal enseignant v1 est minimal côté app** : une table `ingestion_requests`
  (id, requester_id, kind teacher_pdf, storage_path (Supabase Storage, bucket privé), note,
  status received/in_review/generating/published/rejected, chapter_ref, timestamps ; RLS :
  requester lit SON statut, admin tout ; grants explicites) + upload dans l'app (page simple) +
  page admin de file d'attente. Le traitement reste D-2 (opéré). Rejeté v1 : orchestration
  serveur du LLM de génération (coût/latence/qualité incontrôlés en serverless, et bypass des
  gates).
- **D-4 — Aucune nouveauté de format de contenu** : l'ingestion produit uniquement des formats
  déjà normés (schema.ts + interactive-formats). Si un document appelle un format inexistant,
  c'est un signalement vers l'étude 03 / le catalogue — jamais un format ad hoc.

**Client/server (lot app uniquement)** : `src/features/ingestion/` minimal (fns zod :
`createIngestionRequest` avec upload Storage + quota 3 requêtes ouvertes/user, `getMyRequests`,
admin list/update-status) ; page « Proposer un contenu » (opt-in, lien discret) ; page admin.
**Observabilité** : logs de transition de statut ; le reste du suivi = PRs GitHub normales.

## 4. Plan d'exécution en lots

| lot | contenu                                                                                                     | exécutant           | tests exigés                                        | dépend de           |
| --- | ----------------------------------------------------------------------------------------------------------- | ------------------- | --------------------------------------------------- | ------------------- |
| 1   | Format de fiche source + emplacements (D-1) + skill `content-ingest` (D-2)                                  | architecte (skills) | dry-run sur 1 PDF pilote → 1 chapitre complet en PR | —                   |
| 2   | Pilote de bout en bout : 2 chapitres réels ingérés (1 scolaire avec R-3, 1 non scolaire), mesure coût/délai | opéré               | gates contenu + `content-audit` sur la sortie       | 1                   |
| 3   | App : `ingestion_requests` + Storage + pages élève/admin (D-3)                                              | exécuteur Sonnet    | pgTAP (RLS, quota) ; Vitest fns/UI                  | décision GO après 2 |
| 4   | v2 (GELÉE) : self-service élargi, notifications de statut, SLA                                              | —                   | —                                                   | Q-2                 |

- [x] Lot 1 — fiche + skill d'ingestion (skill 2026-07-09 ; format de fiche D-1 + méthode de référence 2026-07-17)
- [ ] Lot 2 — pilote (2 chapitres réels, rapport coût/délai)
- [ ] Lot 3 — canal in-app (GO humain après le pilote)
- [ ] Lot 4 — gelé

**Stop-points** : R-1 est absolu (tout écart = STOP) ; le lot 3 ne démarre pas sans le rapport
du lot 2 ; l'exécuteur Sonnet ne touche qu'au lot 3 (les lots 1–2 sont du ressort
architecte/opérateur — c'est du contenu et du skill-craft, pas du code).

## 5. Stratégie de test

Lot 1–2 : la « suite de tests » est le pipeline lui-même (content:check, qa:strict, audit,
revue de PR) + le rapport pilote (coût tokens, délai, taux de correction en revue). Lot 3 :
pgTAP (RLS/quota), Vitest (fns zod, upload mocké, états UI), pas d'e2e dédié v1 (page simple).

## 6. Risques & mitigations

- **RISK-1** Sur-promesse « tout automatique » (probable/majeur — déception produit) → cette
  étude re-scope explicitement ; la com' produit dit « proposez vos documents », pas « générez ».
- **RISK-2** Qualité de la sortie sous la barre (possible/majeur) → R-1 : les gates + audit
  s'appliquent intégralement ; le pilote (lot 2) mesure le taux de rejet avant d'ouvrir le canal.
- **RISK-3** Droits d'auteur (possible/majeur) → R-2 checklist bloquante + traçabilité
  `sources[]` ; en doute, refus.
- **RISK-4** File d'attente > capacité opérateur (possible/moyen) → quota D-3, statut honnête
  (`in_review` sans SLA v1), Q-2 arbitre l'élargissement.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : PDF pilote du lot 2 — lequel (un document enseignant réel disponible ?).
- **Q-2** : GO du canal in-app (lot 3) et politique d'éligibilité (enseignants partenaires
  identifiés vs tout parent ?).
- **Q-3** : crédit/rémunération des enseignants contributeurs (produit/juridique).

## 8. Journal d'exécution

- **2026-07-09 — Skill `content-ingest` créé + rebasé sur ScribeKit (étude 13).**
  `.claude/skills/content-ingest/SKILL.md` : orchestration en **3 couches** — **ScribeKit** (déterministe :
  extraction couche-texte / Word, échafaudage, manifeste validé, ledger + `AVANCEMENT.md` résumables, QA ;
  **0 LLM / 0 clé**) → **OCR des scans par l'AGENT** (vision d'abonnement Claude Max, **0 clé API**) →
  confrontation CNP (R-3) → hand-off aux skills de génération. **Décision clé (contrainte utilisateur)** :
  l'OCR des scans se fait **agent-in-the-loop** (abonnement), **pas** via l'API Anthropic — la ToS Anthropic
  interdit l'usage programmatique de l'abonnement (token OAuth réservé au CLI/claude.ai), et l'API
  (Messages API / Agent SDK) exige une clé **facturée au token** qui **n'utilise pas** l'abonnement. Le
  `--provider anthropic` de ScribeKit reste une option **batch non-supervisé** qui exige une clé facturée.
  La couche de persistance de `content-ecole-tn` (`references/programmes-officiels/README.md`) a été mise à
  jour pour ce flux outillé (§ « Transcription outillée : ScribeKit »).
  - _Reste (lots 1–3 de cette étude)_ : format de fiche `sources-externes/<slug>/fiche.md` normé (D-1),
    pilote de bout en bout mesuré (coût/délai), canal in-app `ingestion_requests` (D-3).
- **2026-07-17 — Consolidation : la méthode de référence remplace le prompt de campagne.**
  [`../METHODE-GENERATION-CONTENU.md`](../METHODE-GENERATION-CONTENU.md) fusionne l'ancien
  `PROMPT-TRANSCRIPTION-CNP.md` et le volet processus de cette étude en **une seule méthode**,
  générique (4 profils : `ecole-cnp` / `ecole-secondaire` / `document-libre` / `sans-source`)
  et **optimisée tokens** (charte T-1…T-9 : déterministe d'abord, une page lue une fois,
  fiche = capital, un lot = un contexte, unité de génération = le chapitre, brief matière
  réutilisé, R-7 par sondage dirigé, coût mesuré par lot). Elle tranche au passage le **D-1
  résiduel** : les fiches `document-libre` utilisent le **même gabarit `_TEMPLATE.md`** + un
  en-tête de provenance/droits, sous `programmes-officiels/sources-externes/<slug>/fiche.md`
  (école) ou `content/_sources/<theme>/<slug>/fiche.md` (hors école) → **lot 1 coché**. Le
  protocole R-7 est précisé : 100 % du critique (encadrés verbatim, chapitrage, zones `[?]`)
  plus un sondage ≥15 % des pages, escalade en re-lecture intégrale dès 3 erreurs
  substantielles. Intégré aussi : l'axe 5 Illustration (étude 18) et le français natif lycée
  (2026-07-13), absents de l'ancien prompt. _Reste_ : lot 2 (rapport coût/délai formalisé — la
  campagne 1ère sec fournit déjà les données à consolider), lot 3 (canal in-app, GO humain).
- **2026-07-17 — Amendement T-10 : livraison par tranches (décision Mohamed).** Plus jamais de
  longue session de génération sans livrable : le LOT B se livre désormais par **tranches de
  ≤4 chapitres complets** (commit local par chapitre, une PR + une migration fraîche par
  tranche, merge entre tranches — la matière reste l'unité de complétude, plus l'unité de
  livraison) ; au LOT A, l'arrêt propre **pousse** la fiche partielle étiquetée ; interruption
  au milieu d'un chapitre ⇒ sauvegarde `wip/` (draft). Motif : une session coupée avant son
  push perd 100 % du travail — le risque principal des campagnes longues. Répercuté dans la
  méthode (T-10, B2/B3, A3.4, STOP), `content-ingest` et `generation-pipeline.md`.
