# Étude 07 — Knowledge Graph & profils de maîtrise par compétence

> **Statut** : en exécution (validée par l'humain 2026-07-11 — Q-1/Q-2/Q-3 tranchées ; lot 1 lancé)
> **Priorité** : 07 (exécutable dès que l'étude 04 lot A0 tourne) · **Valeur** : passer de « Math = 72 % » à une carte de maîtrise par compétence avec prérequis — le socle qui rend l'adaptatif (04), l'analytics (08) et le tuteur (11) réellement intelligents · **Complexité** : haute (transverse pipeline contenu + DB + agrégats)
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : étude 04 lots A0.1–A0.3 (télémétrie `question_attempts` + patron de registre) ; tagging de contenu progressif (chantier contenu parallèle) · **Bloque** : étude 08 (points faibles), étude 11 (exercice similaire), étude 04 phase A2+ (reco par compétence)
> **Docs normatifs liés** : CLAUDE.md (pipeline contenu, gotcha grants), `content-engine/references/generation-pipeline.md`, étude 04 (registre misconceptions — patron jumeau)

## 1. Contexte & objectif produit

La hiérarchie actuelle (`themes → grades → subjects → chapters → exercises → questions`) est une
hiérarchie **éditoriale**, pas **pédagogique** : elle dit où vit une question, pas ce qu'elle
évalue. Résultat : le produit sait dire « 72 % en math » mais pas « fractions 95 %, géométrie
41 % », ni « il échoue en géométrie parce que la compétence prérequise _proportionnalité_ est à
50 % ». Objectif : chaque question connaît ses **compétences évaluées** ; les compétences
connaissent leurs **prérequis** ; la télémétrie (étude 04) entretient une **maîtrise 0–100 par
(élève, compétence)** ; et une requête répond à « pourquoi échoue-t-il ici ? » par la chaîne de
prérequis faibles. KPI : % du stock de questions taggé, précision perçue du diagnostic
(plan-joué→réussite), adoption du panneau compétences.
Non-objectif : base de données graphe dédiée, ontologie universitaire exhaustive, IRT/ML
(explicitement gelés — voir Hors périmètre).

## 2. Spécification fonctionnelle

- **US-1** : élève — dans ma progression, je vois par matière ma carte de compétences (liste ou
  radar : libellé élève + maîtrise 0–100 + tendance ▲▼), et « ce qui te bloque » : les prérequis
  faibles des compétences en échec.
- **US-2** : élève — chaque compétence faible propose « S'entraîner » → exercices existants qui
  l'évaluent (accessibles : gate premium respecté, même règle R-3 que l'étude 04).
- **US-3** : moteur (étude 04) — `get_daily_plan` peut prioriser par compétence dûe/faible plutôt
  que par chapitre.
- **US-4** : parent (étude 08) — le rapport montre les 5 compétences les plus faibles avec
  libellés compréhensibles.
- **R-1** : une compétence est un id stable namespacé `matière.domaine.competence`
  (`math.geo.thales-direct`), défini UNE fois dans le registre versionné — jamais de texte libre,
  jamais de renommage d'id (même règle d'identité que les slugs).
- **R-2** : une question porte **1 à 3** compétences (la première = principale) ; un quiz/d1 peut
  n'en porter qu'une ; le tagging est **optionnel** pendant la montée en charge (question non
  taggée = neutre, jamais bloquante pour `content:check`).
- **R-3** : les arêtes de prérequis relient des compétences **de la même matière-famille**
  (cross-matière interdit v1 — simplicité) ; le graphe est un DAG (cycle = erreur de lint).
- **R-4** : maîtrise = **EWMA explicable** (BKT-allégé) : `m ← m + α·(résultat − m)` avec α
  dépendant de la difficulté de la question (d1 α=0.15, d2 0.2, d3 0.25, d4 0.3), initialisée à
  50 au premier contact, **dégradée par l'oubli** (−1 pt/semaine d'inactivité sur la compétence,
  plancher 30, appliqué à la lecture — pas de job). Constantes centralisées.
- **R-5** : « pourquoi j'échoue » = pour une compétence en échec (m<50), remonter les prérequis
  directs avec m<60, triés par (profondeur, maîtrise) — max 3 affichés, en langage élève.
- **R-6** : aucun agrégat d'un autre élève ; libellés i18n FR/EN/AR dans le registre (l'id n'est
  jamais affiché).
- **Hors périmètre (v1)** : IRT (calibration de difficulté par item — **gelé** : gate à ≥1000
  réponses/item médianes, décision humaine), BKT complet à 4 paramètres, ML de recommandation,
  édition du graphe en UI (le registre est un fichier versionné), compétences cross-matière.

## 3. Architecture technique (décisions fermées)

- **D-1 — Le graphe vit dans le pipeline de contenu, pas dans une UI d'admin.** Registre
  versionné `content/competences/<famille>.json` (une famille = matière trans-grades : `math`,
  `physique`, `arabe`…) : `{ id, labels: {fr,en,ar}, prereqs: [ids] }`. Validé par zod + lint QA
  (ids uniques, DAG R-3, libellés trilingues complets). Compilé par le générateur en tables
  relationnelles — mêmes UUIDv5 déterministes, même idempotence que tout le contenu. Rejeté :
  table éditée à la main (perd le versioning/review), graphe DB dédié (Neo4j & co — inutile à
  cette échelle, un DAG en table d'arêtes se requête très bien en SQL récursif).
- **D-2 — Le tagging des questions est un champ de contenu** : `competencies: ["math.geo.thales-direct"]`
  optionnel par question dans `exercices/*.json`/`quiz.json` (R-2), compilé en table de jointure.
  Contrairement aux tags de misconception (server-only, étude 04 D-1), les ids de compétences ne
  révèlent **pas** la clé (ils décrivent la question, pas les options) → la jointure est lisible
  côté client sans risque. Les skills prof-\*/wrappers taguent naturellement (leurs cartes de
  chapitres ≈ les domaines) ; le stock existant est taggé par vagues (chantier contenu piloté par
  `curriculum-architect`, priorité aux parcours concours).
- **D-3 — La maîtrise est un agrégat entretenu à l'écriture** (trigger léger sur
  `question_attempts`, comme `user_misconceptions` de l'étude 04) + l'oubli appliqué à la lecture
  (R-4). Rejeté : recalcul batch nocturne (latence UX), calcul à la volée (scan).
- **D-4 — L'échelle de sophistication est un contrat** : v1 = EWMA/R-4 ; IRT et au-delà sont un
  **remplacement de la fonction de mise à jour**, pas du schéma — le schéma (registre, jointure,
  agrégat) est conçu pour survivre au changement de modèle. C'est ici que la proposition
  « IRT+BKT+ML » atterrira quand le volume le justifiera (gate en Hors périmètre).

**Modèle de données** (migrations additives + GRANTs explicites) :

```sql
CREATE TABLE public.competencies (
  id UUID PRIMARY KEY,                       -- UUIDv5(slug), compilé depuis le registre
  slug TEXT NOT NULL UNIQUE,                 -- 'math.geo.thales-direct'
  family TEXT NOT NULL,                      -- 'math'
  label_fr TEXT NOT NULL, label_en TEXT NOT NULL, label_ar TEXT NOT NULL
);
CREATE TABLE public.competency_prereqs (
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  prereq_id     UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  PRIMARY KEY (competency_id, prereq_id), CHECK (competency_id <> prereq_id)
);
CREATE TABLE public.question_competencies (
  question_id  UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  is_primary BOOLEAN NOT NULL DEFAULT false,
  PRIMARY KEY (question_id, competency_id)
);
CREATE TABLE public.user_competency_mastery (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  mastery NUMERIC NOT NULL DEFAULT 50 CHECK (mastery BETWEEN 0 AND 100),
  attempts INT NOT NULL DEFAULT 0, last_attempt_at TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (user_id, competency_id)
);
-- RLS: competencies/prereqs/question_competencies SELECT authenticated (catalogue public);
-- mastery: owner SELECT + admin + parent lié (patron parcours_entitlements); écritures via trigger only.
-- GRANTs explicites sur les 4 tables (gotcha CLAUDE.md). Index: mastery (user_id, mastery ASC).
```

**Pipeline contenu** : zod (`competencyRefSchema` + champ optionnel R-2), loader des registres
famille, `sql-builder` émet registre + jointures (idempotent, prune des mappings retirés — même
sémantique que le reste) ; lints `content:qa` : id inconnu = erreur, cycle = erreur (R-3),
famille≠matière du sujet = warning. **Skills** : `content-engine/references/content-schema.md` +
prof-\*/wrappers apprennent le champ (dernier lot).

**Server** : extension du trigger de l'étude 04 (A0) pour entretenir `user_competency_mastery`
(D-3, R-4) ; RPC `get_my_competency_map(subject_family)` (US-1 : maîtrises + oubli appliqué +
tendance 14j) ; RPC `get_competency_blockers(competency)` (R-5, requête récursive bornée
profondeur 3) ; RPC `get_exercises_for_competency(competency)` (US-2, joint le gate d'accès).
Server fns zod dans `progression/` (comme l'étude 04 — même feature, ce sont deux vues du même
socle).

**Client** : panneau « Carte de compétences » dans la page progression (liste groupée par
domaine, barres 0–100, RTL ok) + bloc « Ce qui te bloque » (R-5). Pas de visualisation graphe
v1 (joli mais sans valeur pédagogique directe).

## 4. Plan d'exécution en lots

| lot | contenu                                                                                                                                                                                             | tests exigés                                              | dépend de      |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- | -------------- |
| 1   | Pipeline : registres `content/competences/*.json` + zod + lints (D-1, R-1/R-3) + `sql-builder` (4 tables, migration compilée) + premier registre `math` (~40 compétences, rédigé avec l'architecte) | Vitest schema/loader/sql-builder ; content:check/qa verts | —              |
| 2   | Migration tables + RLS/grants + trigger maîtrise (D-3, R-4)                                                                                                                                         | pgTAP (RLS parent/owner, EWMA cas limites, oubli, DAG)    | 1, étude 04 A0 |
| 3   | Tagging de contenu vague 1 : questions math 9ème + 6ème (concours)                                                                                                                                  | content:qa ; audit d'échantillon par `content-audit`      | 1              |
| 4   | RPCs map/blockers/exercises + fns + panneau compétences (US-1/2, R-5/R-6)                                                                                                                           | pgTAP (récursion bornée, gate) ; Vitest UI + i18n/RTL     | 2, 3           |
| 5   | Branchement étude 04 : `get_daily_plan` compétence-aware (US-3)                                                                                                                                     | pgTAP non-régression du plan                              | 4              |

- [x] Lot 1 — pipeline + registre math (merge seul)
- [ ] Lot 2 — DB + maîtrise
- [ ] Lot 3 — tagging vague 1 (chantier contenu, PR séparée du code)
- [ ] Lot 4 — RPCs + UI
- [ ] Lot 5 — intégration plan quotidien

**Stop-points** : ne jamais renommer un id de compétence (R-1 — créer/déprécier seulement) ; le
lot 2 ne touche pas aux barèmes de récompense ; l'exécuteur ne rédige PAS les registres de
compétences (contenu pédagogique = architecte/skills contenu) ; IRT/ML interdits sans levée
explicite du gate (D-4).

## 5. Stratégie de test

pgTAP : trigger EWMA (matrice difficulté×résultat, plancher/plafond, oubli), récursion prérequis
(profondeur, cycles impossibles par lint mais testés en défense), RLS (parent lié lit, autrui
non). Vitest : zod/lints (DAG, ids), sql-builder (idempotence, prune), panneau (états vides —
« joue d'abord ! » — et RTL). E2E authed : jouer un exercice taggé → la maîtrise bouge sur la
carte.

## 6. Risques & mitigations

- **RISK-1** Tagging incohérent entre auteurs (probable/moyen) → registre fermé + lint + revue
  d'échantillons `content-audit` par vague ; granularité imposée (R-2 max 3).
- **RISK-2** Maîtrise perçue comme fausse au démarrage (certain/faible) → init à 50 affichée
  « en cours d'évaluation » sous 5 tentatives (attempts<5) ; ne jamais montrer 50 comme un vrai
  score.
- **RISK-3** Registre mal découpé (trop fin/gros) (possible/moyen) → vague 1 = math concours
  seulement, revue humaine du registre avant les familles suivantes.
- **RISK-4** Divergence avec les tags de misconception (possible/faible) → convention : une
  misconception appartient à une compétence (`math.frac.add-denominators` ⊂ `math.frac.operations`)
  — vérifiée par lint quand les deux registres existent.

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — TRANCHÉ (2026-07-11)** : granularité **medium ~55-70** (et non ~40 ≈ 1/chapitre,
  qui ne serait qu'un renommage des chapitres) : ~1 compétence par chapitre déjà fin (6ème,
  23 chapitres), 2-3 par chapitre large (9ème, 14 chapitres), plus quelques compétences-ponts
  7ème/8ème (relatifs, puissances, Pythagore) taggables par les questions de révision 9ème.
  La valeur diagnostique vient du DAG de prérequis qui **traverse** chapitres et niveaux
  (proportionnalité → Thalès, fonction linéaire ← proportionnalité). L'échantillon (registre
  math v1) reste soumis à validation humaine avant le tagging de masse (lot 3).
- **Q-2 — TRANCHÉ (2026-07-11)** : carte visible dès **`attempts ≥ 5`** ; en dessous, badge
  « en cours d'évaluation » (jamais un chiffre nu — RISK-2). Constante centralisée, ajustable
  aux données réelles.
- **Q-3 — TRANCHÉ (2026-07-11)** : gate IRT validé tel quel (**≥1000 réponses médianes/item
  sur corpus stable + décision humaine**) ; d'ici là D-4 verrouille (EWMA explicable seulement).

## 8. Journal d'exécution

- **2026-07-11 — Étude validée** (Q-1/Q-2/Q-3 tranchées par Mohamed, voir §7). Passage en
  exécution, lot 1 lancé (architecte Fable aux commandes : il rédige aussi le registre math —
  le stop-point « l'exécuteur ne rédige pas les registres » vise les exécuteurs Sonnet).
  **Amendement d'architecte (avant lot 1)** : les **3 tables catalogue** (`competencies`,
  `competency_prereqs`, `question_competencies`) + RLS/grants migrent **au lot 1** (et non au
  lot 2) — la migration compilée du registre doit s'appliquer sur une DB fraîche (suite pgTAP :
  toute migration doit passer dans l'ordre des timestamps), donc les tables qu'elle remplit
  doivent la précéder. Le lot 2 garde `user_competency_mastery` + le trigger EWMA + l'oubli.
- **2026-07-11 — Lot 1 livré** (pipeline + registre math + tables catalogue).
  - **Registre** `content/competences/math.json` : **57 compétences** (granularité Q-1),
    10 domaines (`num/frac/prop/alg/fn/stat/geo/vec/esp/mes`), **75 arêtes** de prérequis
    traversant chapitres et niveaux (Thalès ← proportionnalité, fonction linéaire ←
    proportionnalité, ponts 7ème/8ème : relatifs, puissances, Pythagore) ; terminologie AR
    alignée sur les manuels/corpus (فيثاغورس، الوسيط، المعدّل الحسابي، علاقة شال، الأشعّة).
    **Échantillon à valider par l'humain avant le lot 3** (stop-point Q-1).
  - **Pipeline** : `competencyIdSchema`/`competencyRegistrySchema` + `findCompetencyCycle`
    (structure, trilingue, prereqs même-famille et DAG validés au `content:check`), champ
    `competencies` par question (1–3, 1er = principale, **tous types** — contrairement à
    `misconceptionTag` mcq-only), loader `loadCompetencyRegistries` (nom de fichier = famille),
    `sql-builder` : `buildCompetencyRegistryMigrationSql` (upsert + prune par famille + arêtes)
    et jointure `question_competencies` émise dans la migration sujet (garde `to_regclass`,
    prune convergent — dé-tagger converge à zéro), `build.ts --competences` (émet le registre
    SEUL, ne régénère jamais les sujets), lint qa `auditCompetencyRefs` (id inconnu = erreur ;
    famille≠sujet = warning).
  - **DB** : `20260711130000_competency_graph_schema.sql` (3 tables + RLS SELECT authenticated
    - GRANTs explicites + index reverse) ; `20260711131000_generated_competences_registry.sql`
      (compilée, idempotente). pgTAP `26_competency_graph_schema.test.sql` (20 assertions :
      grants/RLS/seed/CHECK/FK/anon).
  - **Écart accepté n°2** : la validation structurelle du registre (dont le DAG R-3) vit dans
    `content:check` (zod/loader) et non `content:qa` — plus strict, même esprit ; `content:qa`
    garde le croisement de vocabulaire (id inconnu) et la couverture famille.
  - **Écart accepté n°3** : champ `subjectPrefixes` ajouté au registre famille — le nom de
    famille est sémantique et non dérivable des ids sujets (la future famille `physique`
    couvrira le sujet `svt`) ; il alimente le lint famille≠matière.
  - **Gate** : `verify` vert (1223 tests dont 22 nouveaux), `content:check` (73 sujets +
    57 compétences), `content:qa:strict` 0 erreur, ordre des migrations conforme
    (13xxxx > 12xxxx de main).
